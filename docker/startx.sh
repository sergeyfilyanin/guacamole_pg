#!/bin/sh -e
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

##
## @fn start.sh
##
## Automatically configures and starts Guacamole under Tomcat. Guacamole's
## guacamole.properties file will be automatically generated based on the
## linked database container (either MySQL or PostgreSQL) and the linked guacd
## container. The Tomcat process will ultimately replace the process of this
## script, running in the foreground until terminated.
##

GUACAMOLE_HOME_TEMPLATE="$GUACAMOLE_HOME"

GUACAMOLE_HOME="$HOME/guacamole"
GUACAMOLE_EXT="$GUACAMOLE_HOME/extensions"
GUACAMOLE_LIB="$GUACAMOLE_HOME/lib"
GUACAMOLE_PROPERTIES="$GUACAMOLE_HOME/guacamole.properties"

##
## Sets the given property to the given value within guacamole.properties,
## creating guacamole.properties first if necessary.
##
## @param NAME
##     The name of the property to set.
##
## @param VALUE
##     The value to set the property to.
##
set_property() {

    NAME="$1"
    VALUE="$2"

    # Ensure guacamole.properties exists
    if [ ! -e "$GUACAMOLE_PROPERTIES" ]; then
        mkdir -p "$GUACAMOLE_HOME"
        echo "# guacamole.properties - generated `date`" > "$GUACAMOLE_PROPERTIES"
    fi

    # Set property
    echo "$NAME: $VALUE" >> "$GUACAMOLE_PROPERTIES"

}

##
## Sets the given property to the given value within guacamole.properties only
## if a value is provided, creating guacamole.properties first if necessary.
##
## @param NAME
##     The name of the property to set.
##
## @param VALUE
##     The value to set the property to, if any. If omitted or empty, the
##     property will not be set.
##
set_optional_property() {

    NAME="$1"
    VALUE="$2"

    # Set the property only if a value is provided
    if [ -n "$VALUE" ]; then
        set_property "$NAME" "$VALUE"
    fi

}

##
## Starts Guacamole under Tomcat, replacing the current process with the
## Tomcat process. As the current process will be replaced, this MUST be the
## last function run within the script.
##
start_guacamole() {

    # Install webapp
    rm -Rf /usr/local/tomcat/webapps/${WEBAPP_CONTEXT:-guacamole}
    ln -sf /opt/guacamole/guacamole.war /usr/local/tomcat/webapps/${WEBAPP_CONTEXT:-guacamole}.war

    # Start tomcat
    cd /usr/local/tomcat
    exec catalina.sh run

}

#
# Point to associated guacd
#

# Use linked container for guacd if specified
if [ -n "$GUACD_NAME" ]; then
    GUACD_HOSTNAME="$GUACD_PORT_4822_TCP_ADDR"
    GUACD_PORT="$GUACD_PORT_4822_TCP_PORT"
fi

# Use default guacd port if none specified
GUACD_PORT="${GUACD_PORT-4822}"

# Verify required guacd connection information is present
if [ -z "$GUACD_HOSTNAME" -o -z "$GUACD_PORT" ]; then
    cat <<END
FATAL: Missing GUACD_HOSTNAME or "guacd" link.
-------------------------------------------------------------------------------
Every Guacamole instance needs a corresponding copy of guacd running. To
provide this, you must either:
(a) Explicitly link that container with the link named "guacd".
(b) If not using a Docker container for guacd, explicitly specify the TCP
    connection information using the following environment variables:
GUACD_HOSTNAME     The hostname or IP address of guacd. If not using a guacd
                   Docker container and corresponding link, this environment
                   variable is *REQUIRED*.
GUACD_PORT         The port on which guacd is listening for TCP connections.
                   This environment variable is optional. If omitted, the
                   standard guacd port of 4822 will be used.
END
    exit 1;
fi

# Update config file
set_property "guacd-hostname" "$GUACD_HOSTNAME"
set_property "guacd-port"     "$GUACD_PORT"

#
# Track which authentication backends are installed
#


# Set logback level if specified
if [ -n "$LOGBACK_LEVEL" ]; then
    unzip -o -j /opt/guacamole/guacamole.war WEB-INF/classes/logback.xml -d $GUACAMOLE_HOME
    sed -i "s/level=\"debug\"/level=\"$LOGBACK_LEVEL\"/" $GUACAMOLE_HOME/logback.xml
fi

#
# Finally start Guacamole (under Tomcat)
#

start_guacamole
