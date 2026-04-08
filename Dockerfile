#FROM ubuntu:latest
#RUN apt-get update
#RUN apt-get install curl ca-certificates -y
#RUN dd if=/dev/random of=100MB.bin bs=1M count=100
#RUN rm 100MB.bin

FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html

