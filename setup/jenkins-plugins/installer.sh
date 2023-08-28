#!/bin/bash
#!/bin/bash

set -eo pipefail
JENKINS_URL="http://localhost:8080"

JENKINS_CRUMB=$(curl -s --cookie-jar /tmp/cookies -u admin:Tncc ${JENKINS_URL}/crumbI$

JENKINS_TOKEN=$(curl -s -X POST -H "Jenkins-Crumb:${JENKINS_CRUMB}" --cookie /tmp/coo$


echo $JENKINS_URL
echo $JENKINS_CRUMB
echo $JENKINS_TOKEN

while read plugin; do
   echo "........Installing ${plugin} .."
   curl -s POST --data "<jenkins><install plugin='${plugin}' /></jenkins>" -H 'Conten$
done < plugins.txt


#### we also need to do a restart for some plugins

#### check all plugins installed in jenkins
#
# http://<jenkins-url>/script

# Jenkins.instance.pluginManager.plugins.each{
#   plugin ->
#     println ("${plugin.getDisplayName()} (${plugin.getShortName()}): ${plugin.getVe$
# }


#### Check for updates/errors - http://<jenkins-url>/updateCenter

