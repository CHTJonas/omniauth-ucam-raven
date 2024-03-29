require 'omniauth'
require 'cgi'
require 'base64'
require 'openssl'

module OmniAuth
  module Strategies
    class UcamRaven
      include OmniAuth::Strategy

      # Built-in WLS endpoints.
      RAVEN_URL = 'https://raven.cam.ac.uk/auth/authenticate.html'
      GOOSE_URL = 'https://auth.srcf.net/wls/authenticate'

      # The name of the strategy.
      option :name, 'ucam-raven'

      # Query parameters to pass to the WLS.
      # By choice, we only use version 3 so we can support Raven for Life.
      # See: https://w3.charliejonas.co.uk/mirror/raven/waa2wls-protocol.txt
      option :url, nil
      option :desc, nil
      option :aauth, nil
      option :iact, nil
      option :msg, nil
      option :params, nil
      option :date, false
      option :skew, 45 # the spec states that a time of 30-60 seconds is probably appropriate
      option :fail, nil

      # Path to the directory used to store RSA public keys.
      args :keys_dir

      # Whether or not to use the SRCF authentication service instead of Raven.
      option :honk, false

      # This method is called when the strategy is instantiated.
      def initialize(*args, &block)
        super(*args, &block)
        raise 'RSA public key directory not setup' if options.keys_dir.nil?
        raise 'RSA public key directory must exist' unless Dir.exist?(options.keys_dir)
      end

      # This method is called when the user initiates a login. It redirects them to the Raven service for authentication.
      def request_phase
        url = (
          if options.url
            options.url
          else
            options.honk ? GOOSE_URL : RAVEN_URL
          end).dup
        url << "?ver=3"
        url << "&url=#{callback_url}"
        url << "&desc=#{CGI::escape options.desc}" if options.desc
        url << "&aauth=#{CGI::escape options.aauth}" if options.aauth
        url << "&iact=#{CGI::escape options.iact}" if options.iact
        url << "&msg=#{CGI::escape options.msg}" if options.msg
        url << "&params=#{CGI::escape options.params}" if options.params
        url << "&date=#{date_to_rfc3339}" if options.date
        # The skew parameter is DEPRECATED and SHOULD NOT be included in requests to the WLS.
        url << "&fail=#{CGI::escape options.fail}" if options.fail
        redirect url
      end

      # This method is called after the user authenticates to Raven and is redirected back to the application.
      def callback_phase
        # Check the response is in the format we're expecting.
        return fail!(:wls_response_not_present) if wls_response.nil? || wls_response == ""
        return fail!(:authentication_cancelled_by_user) if wls_response[1].to_i == 410
        return fail!(:no_mutually_acceptable_authentication_types_available) if wls_response[1].to_i == 510
        return fail!(:unsupported_protocol_version) if wls_response[1].to_i == 520
        return fail!(:general_request_parameter_error) if wls_response[1].to_i == 530
        return fail!(:interaction_would_be_required) if wls_response[1].to_i == 540
        return fail!(:waa_not_authorised) if wls_response[1].to_i == 560
        return fail!(:authentication_declined) if wls_response[1].to_i == 570
        return fail!(:invalid_response_status) unless wls_response[1].to_i == 200
        return fail!(:raven_version_mismatch) unless wls_response[0].to_i == 3
        return fail!(:invalid_response_url) unless wls_response[5] == callback_url.split('?').first
        return fail!(:too_few_wls_response_parameters) if wls_response.length < 14
        return fail!(:too_many_wls_response_parameters) if wls_response.length > 14

        # Check the time skew in seconds.
        return fail!(:invalid_issue) unless wls_response[3].length == 16
        skew = ((DateTime.now.new_offset(0) - date_from_rfc3339(wls_response[3])) * 24 * 60 * 60).to_i
        return fail!(:skew_too_large) unless skew.abs < options.skew

        # Check that the RSA key ID and signature are correct.
        key_id = wls_response[12].to_i.to_s # avoid any funny business
        key_path = File.join(options.keys_dir, key_id)
        return fail!(:rsa_key_not_found) unless File.exist?(key_path)
        key_contents = File.read(key_path)
        key = OpenSSL::PKey::RSA.new(key_contents)
        signed_part = wls_response.first(12).join('!')
        base64_part = wls_response[13].tr('-._','+/=')
        signature = Base64.decode64(base64_part)
        digest = OpenSSL::Digest::SHA1.new
        return fail!(:rsa_signature_check_failed) unless key.verify(digest, signature, signed_part)
        return super
      end

      uid do
        wls_response[6]
      end

      info do
        {
          name: nil,
          ptags: ptags
        }
      end

      credentials do
        {
          auth: auth,
          sso: sso
        }
      end

      extra do
        {
          id: id,
          lifetime: lifetime,
          parameters: parameters
        }
      end

      private

      def wls_response
        # ver, status, msg, issue, id, url, principal, ptags, auth, sso, life, params, kid, signature
        @wls_response ||= request.params['WLS-Response'].split('!')
      end

      def ptags
        wls_response[7].split(',')
      end

      def auth
        wls_response[8]
      end

      def sso
        wls_response[9].split(',')
      end

      def id
        wls_response[4]
      end

      def lifetime
        wls_response[10]
      end

      def parameters
        wls_response[11]
      end

      # Raven returns RFC3339 without hyphens and colons so we
      # can't pass to the inbuilt Date.rfc3339 method. Grrrr...
      def date_from_rfc3339(rfc3339)
        year = rfc3339[0..3].to_i
        month = rfc3339[4..5].to_i
        day = rfc3339[6..7].to_i
        hour = rfc3339[9..10].to_i
        minute = rfc3339[11..12].to_i
        second = rfc3339[13..14].to_i
        DateTime.new(year, month, day, hour, minute, second)
      end

      def date_to_rfc3339
        t = Time.now.utc
        s = String.new
        s << "%04d" % t.year
        s << "%02d" % t.month
        s << "%02d" % t.day
        s << "T"
        s << "%02d" % t.hour
        s << "%02d" % t.min
        s << "%02d" % t.sec
        s << "Z"
        return s
      end
    end
  end
end

OmniAuth.config.add_camelization "ucamraven", "UcamRaven"
OmniAuth.config.add_camelization "ucam-raven", "UcamRaven"
OmniAuth.config.add_camelization "ucam_raven", "UcamRaven"
