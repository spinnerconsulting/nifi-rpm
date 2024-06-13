# nifi-rpm
RPM packaging for Apache Nifi

Includes Nifi spec file and a bash script to build the RPM.

# Prerequisites
## RHEL 8 - based systems
Install required packages:
```sh
dnf install rpm-build unzip
```

# Running
Run script:
```sh
./scripts/run.sh -v <Nifi Version>
```
|Option|Required|Description|
| ------ | ------ | ------ |
|-v| true | The version of Nifi to package as an RPM. Example: '1.22.0'.  Example for milestone releases: '2.0.0-M3' |
|-u| false | The URL to use for downloading the binary zip file. Defaults to the official Apache Nifi distribution link. |
|-h| false | Prints usage information.|
