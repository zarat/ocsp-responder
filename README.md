# ocsp-responder

<code>
FROM ubuntu:latest
RUN apt-get update && apt-get install -y git
WORKDIR /opt
RUN git clone https://github.com/zarat/ocsp-responder
</code>
