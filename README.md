# snmptools

This repo is created in order to make process of deploying test environments running Net-SNMP snmpd and snmptrapd services fast and easy.


### Requirements:

- docker (https://docs.docker.com/docker-for-mac/install/)
- docker-compose (https://docs.docker.com/compose/install/)

### How to use:

- download the repo

- in order to create and start container with running service run 

  **`docker-compose up -d`** 

- in order to stop and remove the container run 

  **`docker-compose down`** ,
  
### Additional information:

In order to omit conflicts caused by accessing to standard SNMP ports `161` and `162`, containers use `33161` and `33162` ports respectively.

All logs collected during containers work will be kept in file `/log/<service>/<service>-direct.log*` until next run of `docker-compose -f <...> up`, when log is being truncated.

File `*cfg/<service>/snmp.conf*` adds MIBs delivered in `*mibs*` directory.

File `*cfg/snmptrapd/root/.snmp/snmptrapd.local.conf*` aggregates files, where defined access rules for different SNMP versions. Credentials and engine IDs which should be used in order to trap/inform being accepted and logged by *snmptrapd.service* running into the container. Community strings for traps in SNMPv1 and SNMPv2c are also defined in the files `v1.conf` and `v2c.conf`.

### Example of using snmptrapd:

TERMINAL 1:

    $ git clone git@github.ibm.com:Iurii-Likh/snmp-playground.git
    $ cd snmp-playground
    $ docker build -f snmp.Dockerfile --build-arg version=latest -t client:rh8-latest .
    $ docker-compose up -d ; \
    > tail -f log/snmptrapd/snmptrapd-direct.log 


TERMINAL 2:

    $ docker run -ti --rm --network snmp-playground_lab \
    >            -v ./cfg/client/root/.snmp:/root/.snmp \
    >            -v ./mibs:/tmp/mibs client:rh8-latest bash
    $ DATE=$(date +%F\ %T); \
    > snmptrap -Ci -v2c -c snmpv2public <lab-snmptrapd-ip>:162 '' \
    > IIAS-MIB::testHWAlert199 \
    > IIAS-MIB::alertDescription.0 s "MANUALLY SENT ALERT AT $DATE"


TERMINAL 1 output:
   
    10:58:14 2024/03/21 TRAP 844ac4a09078.snmp-playground_lab
    PDU INFO:
      receivedfrom:      UDP: [172.24.0.4]:54146->[172.24.0.2]:162
      community:         INFORM, SNMP v2c, community snmpv2public
    VARBINDS:
      DISMAN-EVENT-MIB::sysUpTimeInstance = 0:1:03:38.78
      SNMPv2-MIB::snmpTrapOID.0 = IIAS-MIB::testHWAlert199
      IIAS-MIB::alertDescription.0 = MANUALLY SENT ALERT AT 2024-03-21 10:58:14


In "TERMINAL 1 output" above following lines mean: 

    10:58:14 2024/03/21 TRAP 844ac4a09078.snmp-playground_lab : "844ac4a09078" - 'client' container's hostname
    receivedfrom:      UDP: [172.24.0.4]:54146->[172.24.0.2]:162 : "172.24.0.2" and "172.24.0.4" 'lab-snmptrapd' and 'client' containers IP addresses respectivelly 
    SNMPv2-MIB::snmpTrapOID.0 = IIAS-MIB::testHWAlert199 : "IIAS-MIB::testHWAlert199" the notification's MIB and label in format <MIB>::<symbol>
    IIAS-MIB::alertDescription.0 = MANUALLY SENT ALERT AT 2024-03-21 10:58:14 : the varbind we manually attached in 'snmptrap' command in the very last line of 'TERMINAL 2'  

