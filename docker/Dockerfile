FROM guacamole/guacamole:0.9.13-incubating

COPY configuration/guacamole.properties /opt/guacamole
COPY lib/guacamole-auth-jdbc-postgresql-0.9.13-incubating.jar /opt/guacamole/extensions/
COPY lib/postgresql-42.2.12.jar /opt/guacamole/lib/
COPY configuration/user-mapping.xml /opt/guacamole
COPY startx.sh /opt/guacamole/bin/
RUN chmod +x /opt/guacamole/bin/startx.sh

CMD ["/opt/guacamole/bin/startx.sh"]
