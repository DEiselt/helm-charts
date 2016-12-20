{{- define "notification_start_tpl" -}}
#!/bin/bash

# set some env variables from the openstack env properly based on env
. /container.init/common-start

function process_config {
  cp /monasca-etc-base/notification-notification-config.yml /etc/monasca/notification-config.yml

  # use Kubernetes IDs for some attributes
  sed "s,KAFKA_CONSUMER_ID,${KUBE_POD_NAME},g" -i /etc/monasca/notification-config.yml
}

function start_application {
  exec /usr/share/python/monasca-notification/bin/monasca-notification /etc/monasca/notification-config.yml
}

function diagnose_application {
  echo "Notification could not be started: dump config"
  cat /etc/monasca/notification-config.yml | grep -v "passwd"
} 

process_config

start_application

diagnose_application
{{ end }}
