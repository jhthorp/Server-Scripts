# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) 
and this project adheres to 
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - YYYY-MM-DD

Initial release of the following scripts:

* General
	* upload_and_run_command.sh - A script to create a scripts bundle and upload 
	it to a server before executing the command.
	* upload_and_run_script.sh - A script to create a scripts bundle and upload 
	it to a server before starting the script.
	* upload_bundle.sh - A script to create a scripts bundle and upload it to a 
	server.
* Scripts
	* download_burnin_results.sh - A script to download the output files from a 
	Burn-In process.
	* download_erase_results.sh - A script to download the output files from an 
	Erase process.
	* upload_and_run_burnin.sh - A script to create a 
	[Utility-Scripts](https://github.com/jhthorp/Utility-Scripts) bundle and 
	upload it to a server before starting the Burn-In process.
	* upload_and_run_erase.sh - A script to create a 
	[Utility-Scripts](https://github.com/jhthorp/Utility-Scripts) bundle and 
	upload it to a server before starting the Erase process
* TrueNAS
	* create_truenas_bundle.sh - A script to create an archive bundle for 
	uploading to a TrueNAS server.
	* upload_truenas_bundle.sh - A script to create a TrueNAS scripts bundle 
	and upload it to a server.

[//]: # (Version Diffs)
[Unreleased]: https://github.com/jhthorp/Server-Scripts/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/jhthorp/Server-Scripts/releases/tag/v1.0.0