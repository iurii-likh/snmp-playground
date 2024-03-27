ARG VERSION
FROM redhat/ubi8:${VERSION:-latest}

RUN yum install --disableplugin subscription-manager -y \
                net-snmp \
                net-snmp-utils \
                net-snmp-libs \
                net-snmp-agent-libs \
    && yum clean all \
    && rm -rf /var/cache/yum

EXPOSE 33161/udp

ENTRYPOINT ["/usr/sbin/snmpd", "-f"]
CMD ["-Lf", "/var/log/snmpd-direct.log"]
