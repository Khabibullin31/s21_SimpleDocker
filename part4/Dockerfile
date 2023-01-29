FROM nginx:latest
COPY /nginx/nginx.conf /etc/nginx/
RUN apt-get update && apt-get install -y \
    gcc \
    libfcgi-dev \
    spawn-fcgi 
COPY server.c /home/
COPY run.sh /home/
WORKDIR /home/
RUN chmod 777 run.sh ; \
    gcc server.c -lfcgi ; \
    chmod 777 a.out ; \
    touch /var/run/nginx.pid ; \
    chown -R nginx:nginx /var/run/nginx.pid ;
CMD [ "sh", "./run.sh" ]