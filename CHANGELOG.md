# Changelog

## [3.0.0] - UNRELEASED

* Replace Raven project page deadlinks with mirrored versions.
* Update OmniAuth requirement.
* Rename default branch.
* Migrate from use of URI::encode to CGI::escape instead.
* Rename auth strategy to match gem name.
* Remove email from authentication info hash.
* Load RSA keys from a single specified directory.

## [2.0.1] - 2020-06-03

* Cast the RSA key ID to an integer when verifying authentication signatures.

## [2.0.0] - 2020-05-27

* Add support for the SRCF Goose authentication service.
* Add support for multiple signing keys.
* Return an error if the authentication responses is issued too far into the future from a local perspective.
* Improve compliance of the skew parameter with the WebAuth protocol.
* Raise an exception if RSA key file path and/or ID are not present.
* Improve documentation and example code.
* Bump internal dependencies.

## [1.0.1] - 2018-11-15

* No user-facing changes.
* Bump internal rack version to 2.0.6 in order to patch a DoS vulnerability (CVE-2018-16468).

## [1.0.0] - 2018-11-04

* Initial release.
