ARG version
FROM redhat/ubi8:$version

RUN yum install -y \
                net-snmp \
                net-snmp-utils \
                net-snmp-agent-libs \
                net-snmp-libs \
    && yum clean all \
    && rm -rf /var/cache/yum

