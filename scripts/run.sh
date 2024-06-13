#!/bin/bash

set -e

function print_help { echo "Usage: $0 [ -v NIFI_VERSION ] [ -u NIFI_BIN_URL ]" >&2 ; }

while getopts "v:u" flag
do
    case "${flag}" in
        v) NIFI_VERSION=${OPTARG};;
        u) NIFI_BIN_URL=${OPTARG};;
	\? | h | *) print_help; exit 2;;
    esac
done

RPM_SAFE_NIFI_VERSION=${NIFI_VERSION/-M/~M}

echo "setup rpmmacros...."
echo "# macros" >  ~/.rpmmacros && \
echo "%_topdir    ${HOME}/rpmbuild" >> ~/.rpmmacros && \
mkdir -p ~/rpmbuild

echo "download files...."
curl -fSL -o nifi-${NIFI_VERSION}-bin.zip.sha512 https://archive.apache.org/dist/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.zip.sha512

if [[ -n "${NIFI_BIN_URL}" ]]
then
	URL=${NIFI_BIN_URL}
else
	URL=https://archive.apache.org/dist/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.zip
fi

curl -fSL -o nifi-${NIFI_VERSION}-bin.zip ${URL}
echo "`cat nifi-${NIFI_VERSION}-bin.zip.sha512`  nifi-${NIFI_VERSION}-bin.zip" | sha512sum -c

echo "setup build dirs...."
mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
mv nifi-${NIFI_VERSION}-bin.zip ~/rpmbuild/SOURCES/nifi-${RPM_SAFE_NIFI_VERSION}-bin.zip
cp nifi.spec ~/rpmbuild/SPECS

echo "build rpm..."
cd ~/rpmbuild
rpmbuild -bb --define "orig_version ${NIFI_VERSION}" --define "_version ${RPM_SAFE_NIFI_VERSION}" SPECS/nifi.spec
