FROM ubuntu

COPY dart /usr/bin
COPY app.dart.snapshot /root/bin/
ENTRYPOINT ["dart", "/root/bin/app.dart.snapshot", "-p", "80", "/root/content/"]

EXPOSE 80