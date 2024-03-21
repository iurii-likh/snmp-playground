ARG version
FROM redhat/ubi8:$version

RUN yum install -y net-snmp net-snmp-agent-libs net-snmp-libs net-snmp-utils \
    && yum clean all \
    && rm -rf /var/cache/yum

