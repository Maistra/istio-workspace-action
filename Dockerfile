FROM quay.io/maistra/istio-workspace:latest

ADD ike_actions.sh /usr/local/bin/ike_actions.sh
ENTRYPOINT [ "ike_actions.sh" ]
