ARG VERSION
FROM fedora:${VERSION:-latest}

RUN yum install -y \
                net-snmp \
                net-snmp-utils \
                net-snmp-libs \
                net-snmp-agent-libs \
                net-snmp-devel \
                libsmi

EXPOSE 162/udp
