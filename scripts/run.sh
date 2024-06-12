#!/bin/bash

set -e

dnf -y update && dnf -y install rpm-build unzip

echo "setup rpmmacros...."
echo "# macros" >  /root/.rpmmacros && \
echo "%_topdir    /root/rpmbuild" >> /root/.rpmmacros && \
mkdir -p /root/rpmbuild

echo "download files...."
curl -fsSL -o nifi-$NIFI_VERSION-bin.zip https://archive.apache.org/dist/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.zip
curl -fsSL -o nifi-$NIFI_VERSION-bin.zip.sha512 https://archive.apache.org/dist/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.zip.sha512
echo "`cat nifi-$NIFI_VERSION-bin.zip.sha512`  nifi-$NIFI_VERSION-bin.zip" | sha512sum -c

echo "setup build dirs...."
mkdir -p /root/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
mv nifi-$NIFI_VERSION-bin.zip /root/rpmbuild/SOURCES
cp nifi.spec /root/rpmbuild/SPECS

echo "build rpm..."
cd /root/rpmbuild
rpmbuild -bb --define "_version $NIFI_VERSION" SPECS/nifi.spec
