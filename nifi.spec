Name:           nifi
Version:        %{_version}
Release:        1%{?dist}
Summary:        Apache Nifi
License:        Apache License, Version 2.0 and others (see included LICENSE file)
URL:            https://nifi.apache.org
Group:          Utilities
Source0:        %{name}-%{version}-bin.zip
Source1:        https://dlcdn.apache.org/%{name}/%{version}/%{name}-%{version}-bin.zip 
BuildArch:      noarch

Requires(pre): /usr/sbin/useradd, /usr/bin/getent
Requires(postun): /usr/sbin/userdel

%description
Apache NiFi is dataflow system based on the Flow-Based Programming concepts.

%prep
%setup -q

%build
# do nothing

%install
mkdir -p %{buildroot}/opt/%{name}
cp -r * %{buildroot}/opt/%{name}

%files
%defattr(-, %{name}, %{name}, -)
%license /opt/%{name}/LICENSE
%docdir /opt/%{name}/docs
%config(noreplace) /opt/%{name}/conf
/opt/%{name}/

%pre
/usr/bin/getent group nifi > /dev/null || /usr/sbin/groupadd -r nifi;
/usr/bin/getent passwd nifi > /dev/null || /usr/sbin/useradd -r -g nifi -d /opt/nifi -s /sbin/nologin -c "NiFi System User" nifi;

%postun
case "$1" in
   0) # This is a yum remove.
      /usr/sbin/userdel %{name}
   ;;
   1) # This is a yum upgrade.
      # do nothing
   ;;
esac
