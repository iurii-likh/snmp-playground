ARG VERSION
FROM redhat/ubi8:${VERSION:-latest}

RUN yum install --disableplugin subscription-manager -y \
                net-snmp \
                net-snmp-utils \
                net-snmp-libs \
                net-snmp-agent-libs \
    && yum clean all \
    && rm -rf /var/cache/yum 

EXPOSE 33162/udp

ENTRYPOINT ["/usr/sbin/snmptrapd", "-f"]
CMD ["-Lf" , "/var/log/snmptrapd-direct.log", "-OQ"]
