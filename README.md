# Server Scripts

The scripts within this project are to support various useful operations with 
stand-alone servers such as TrueNAS.

## Table of Contents

* [Warnings](#warnings)
* [Getting Started](#getting-started)
* [Prerequisites](#prerequisites)
* [Setup](#setup)
* [Scripts](#scripts)
	* [General](#general)
		* [upload_and_run_command.sh](#upload_and_run_commandsh)
		* [upload_and_run_script.sh](#upload_and_run_scriptsh)
		* [upload_bundle.sh](#upload_bundlesh)
	* [Processes](#processes)
		* [download_burnin_results.sh](#download_burnin_resultssh)
		* [download_erase_results.sh](#download_erase_resultssh)
		* [upload_and_run_burnin.sh](#upload_and_run_burninsh)
		* [upload_and_run_erase.sh](#upload_and_run_erasesh)
	* [TrueNAS](#truenas)
		* [create_truenas_bundle.sh](#create_truenas_bundlesh)
		* [upload_truenas_bundle.sh](#upload_truenas_bundlesh)
* [Deployment](#deployment)
* [Dependencies](#dependencies)
* [Notes](#notes)
* [Test Environments](#test-environments)
	* [Operating System Compatibility](#operating-system-compatibility)
	* [Hardware Compatibility](#hardware-compatibility)
* [Contributing](#contributing)
* [Support](#support)
* [Versioning](#versioning)
* [Authors](#authors)
* [Copyright](#copyright)
* [License](#license)
* [Acknowledgments](#acknowledgments)

## Warnings

| :warning: |                      :warning:                       | :warning: |
|   :---:   |                        :---:                         |   :---:   |
| :warning: |**Executing Burn-In/Erase scripts will destroy data!**| :warning: |
| :warning: |                      :warning:                       | :warning: |

## Getting Started

These instructions will get you a copy of the project up and running on your 
local machine for development and testing purposes. See 
[deployment](#deployment) for notes on how to deploy the project on a live 
system.

### Prerequisites

* [Utility-Scripts](https://github.com/jhthorp/Utility-Scripts) exist at the 
same directory path
* [Drive-Scripts](https://github.com/jhthorp/Drive-Scripts) exist at the 
same directory path

### Setup

In order to use the scripts within this package, you will need to clone, or 
download, into the same top-level directory path, the following repositories:

* [Utility-Scripts](https://github.com/jhthorp/Utility-Scripts)
* [Drive-Scripts](https://github.com/jhthorp/Drive-Scripts)

```
/path/to/Utility-Scripts
/path/to/Drive-Scripts
/path/to/Server-Scripts
```

## Scripts

### General

#### upload_and_run_command.sh

A script to create a scripts bundle and upload it to a server before executing 
the command.

_Usage_

```
[bash] ./upload_and_run_command.sh <srcDir> <host> <port> [remote_user] 
[command_to_run]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|     Source Directory      |                 Source directory                 |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|        Remote User        |               User to connect with               |
|      Command To Run       |                Command to execute                |

_Examples_

* **./upload_and_run_command.sh** "../TrueNAS-Scripts" 192.168.1.1 22
* **./upload_and_run_command.sh** "../TrueNAS-Scripts" 192.168.1.1 22 "root"
* **./upload_and_run_command.sh** "../TrueNAS-Scripts" 192.168.1.1 22 "root" 
"pwd"

#### upload_and_run_script.sh

A script to create a scripts bundle and upload it to a server before starting 
the script.

_Usage_

```
[bash] ./upload_and_run_script.sh <srcDir> <host> <port> [remote_user] 
[script_to_run]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|     Source Directory      |                 Source directory                 |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|        Remote User        |               User to connect with               |
|       Script To Run       |                Script to execute                 |

_Examples_

* **./upload_and_run_script.sh** "../TrueNAS-Scripts" 192.168.1.1 22
* **./upload_and_run_script.sh** "../TrueNAS-Scripts" 192.168.1.1 22 "root"
* **./upload_and_run_script.sh** "../TrueNAS-Scripts" 192.168.1.1 22 "root"
"Utility-Scripts/tmux/start_tmux_session 'session-name'"

#### upload_bundle.sh

A script to create a scripts bundle and upload it to a server.

_Usage_

```
[bash] ./upload_bundle.sh <srcDir> <host> <port> [remote_user]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|     Source Directory      |                 Source directory                 |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|        Remote User        |               User to connect with               |

_Examples_

* **./upload_bundle.sh** "../TrueNAS-Scripts" 192.168.1.1 22
* **./upload_bundle.sh** "../TrueNAS-Scripts" 192.168.1.1 22 "root"

### Processes

#### download_burnin_results.sh

A script to download the output files from a Burn-In process.

_Usage_

```
[bash] ./download_burnin_results.sh <host> <port> <remote_user>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|        Remote User        |               User to connect with               |

_Examples_

* **./download_burnin_results.sh** 192.168.1.1 22 "root"

#### download_erase_results.sh

A script to download the output files from an Erase process.

_Usage_

```
[bash] ./download_erase_results.sh <host> <port> <remote_user>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|        Remote User        |               User to connect with               |

_Examples_

* **./download_erase_results.sh** 192.168.1.1 22 "root"

#### upload_and_run_burnin.sh

A script to create a Utility scripts bundle and upload it to a server before 
starting the Burn-In process.

_Usage_

```
[bash] ./upload_and_run_burnin.sh <host> <port> [remote_user] [drives_override] 
[zero_drives] [session_suffix] [end_on_detach]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|        Remote User        |               User to connect with               |
|      drives_override      |          Array of drive IDs to burn-in           |
|        zero_drives        |   Zero the drives after testing has completed    |
|      session_suffix       |        Suffix to add to the session name         |
|       end_on_detach       |  End process when the TMUX session is detached   |

_Examples_

* **./upload_and_run_burnin.sh** 192.168.1.1 22
* **./upload_and_run_burnin.sh** 192.168.1.1 22 "root"
* **./upload_and_run_burnin.sh** 192.168.1.1 22 "root" "/dev/da0 /dev/da2 
/dev/da4"
* **./upload_and_run_burnin.sh** 192.168.1.1 22 "root" "/dev/da0 /dev/da2 
/dev/da4" true
* **./upload_and_run_burnin.sh** 192.168.1.1 22 "root" "/dev/da0 /dev/da2" false 
"session2"
* **./upload_and_run_burnin.sh** 192.168.1.1 22 "root" "/dev/da0 /dev/da2" false 
"s3" true

#### upload_and_run_erase.sh

A script to create a Utility scripts bundle and upload it to a server before 
starting the Erase process.

_Usage_

```
[bash] ./upload_and_run_erase.sh <host> <port> [remote_user] [drives_override] 
[session_suffix] [end_on_detach]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|        Remote User        |               User to connect with               |
|      drives_override      |          Array of drive IDs to burn-in           |
|      session_suffix       |        Suffix to add to the session name         |
|       end_on_detach       |  End process when the TMUX session is detached   |

_Examples_

* **./upload_and_run_erase.sh** 192.168.1.1 22
* **./upload_and_run_erase.sh** 192.168.1.1 22 "root"
* **./upload_and_run_erase.sh** 192.168.1.1 22 "root" "/dev/da0 /dev/da2 
/dev/da4"
* **./upload_and_run_erase.sh** 192.168.1.1 22 "root" "/dev/da0 /dev/da2" 
"session2"
* **./upload_and_run_erase.sh** 192.168.1.1 22 "root" "/dev/da0 /dev/da2" "s3" 
true

### TrueNAS

#### create_truenas_bundle.sh

A script to create an archive bundle for uploading to a TrueNAS server.

_Usage_

```
[bash] ./create_truenas_bundle.sh [completeBundleName]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|        Bundle Name        |            Name for the output bundle            |

_Examples_

* **./create_truenas_bundle.sh** "TrueNAS"

#### upload_truenas_bundle.sh

A script to create a TrueNAS scripts bundle and upload it to a server.

_Usage_

```
[bash] ./upload_truenas_bundle.sh <host> <port> [remote_user]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|        Remote User        |               User to connect with               |

_Examples_

* **./upload_truenas_bundle.sh** 192.168.1.1 22
* **./upload_truenas_bundle.sh** 192.168.1.1 22 "root"

## Deployment

This section provides additional notes about how to deploy this on a live 
system.

## Dependencies

* [Utility-Scripts](https://github.com/jhthorp/Utility-Scripts) - A collection 
of utility scripts.
* [Drive-Scripts](https://github.com/jhthorp/Drive-Scripts) - A collection 
of hard drive scripts.

## Notes

This project does not contain any additional notes at this time.

## Test Environments

### Operating System Compatibility

|        Status        |                        System                         |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                     MacOS 11.2.x                      |
|  :white_check_mark:  |                     MacOS 11.1.x                      |
|  :white_check_mark:  |                     MacOS 11.0.x                      |

### Hardware Compatibility

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |              MacBook Pro (15-inch, 2018)              |

## Contributing

Please read [CODE_OF_CONDUCT](.github/CODE_OF_CONDUCT.md) for details on our 
Code of Conduct and [CONTRIBUTING](.github/CONTRIBUTING.md) for details on the 
process for submitting pull requests.

## Support

Please read [SUPPORT](.github/SUPPORT.md) for details on how to request 
support from the team.  For any security concerns, please read 
[SECURITY](.github/SECURITY.md) for our related process.

## Versioning

We use [Semantic Versioning](http://semver.org/) for versioning. For available 
releases, please see the 
[available tags](https://github.com/jhthorp/Server-Scripts/tags) or look through 
our [Release Notes](.github/RELEASE_NOTES.md). For extensive documentation of 
changes between releases, please see the [Changelog](.github/CHANGELOG.md).

## Authors

* **Jack Thorp** - *Initial work* - [jhthorp](https://github.com/jhthorp)

See also the list of 
[contributors](https://github.com/jhthorp/Server-Scripts/contributors) who 
participated in this project.

## Copyright

Copyright © 2020 - 2021, Jack Thorp and associated contributors.

## License

This project is licensed under the GNU General Public License - see the 
[LICENSE](LICENSE.md) for details.

## Acknowledgments

* N/A