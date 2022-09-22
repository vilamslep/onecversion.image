FROM alpine:3.5

RUN apk add --no-cache openssh && ssh-keygen -A && echo 'root:root' | chpasswd
EXPOSE 22
CMD /usr/sbin/sshd -D -o PermitRootLogin=yes -o AddressFamily=inet -o GatewayPorts=yes