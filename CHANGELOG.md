# Changelog

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
