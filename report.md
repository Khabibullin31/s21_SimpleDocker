## Part 1. Готовый докер
1.1 Взять официальный докер образ с nginx и выкачать его при помощи docker pull
``` brew
команда - docker pull nginx
```
![](/screenshots/1.1.png)
1.2 Проверить наличие докер образа через docker images
``` brew
команда - docker images
```
![](/screenshots/1.2.png)
1.3 Запустить докер образ через docker run -d [image_id|repository]
``` brew
команда - docker run -d 88736fe82739
```
![](/screenshots/1.3.png)     

1.4 Проверить, что образ запустился через docker ps
``` brew
команда - docker ps
```
![](/screenshots/1.4.png)
1.5 Посмотреть информацию о контейнере через docker inspect [container_id|container_name]
``` brew
команда - docker inspect 39c687146d2a
```
![](/screenshots/1.5.png)
![](/screenshots/1.6.png)
![](/screenshots/1.7.png)
![](/screenshots/1.8.png)
1.6 Остановить докер образ через docker stop [container_id|container_name]
``` brew
команда - docker stop 39c687146d2a
```
![](/screenshots/1.9.png)


1.7 Проверить, что образ остановился через docker ps                
``` brew
команда - docker ps
```
![](/screenshots/1.10.png)
1.8 Запустить докер с замапленными портами 80 и 443 на локальную машину через команду run
``` brew
команда - docker run -d -p 80:80 -p 443:443 88736fe82739
```
![](/screenshots/1.11.png)

1.9 Проверить, что по адресу localhost:80 доступна стартовая страница nginx
![](/screenshots/1.12.png)

1.10 Перезапустить докер контейнер через docker restart [container_id|container_name]
``` brew
команда - docker restart 462de500acb9
```
1.11 Проверить любым способом, что контейнер запустился
``` brew
команда - docker ps
```
![](/screenshots/1.13.png)
## Part 2. Операции с контейнером
2.1 Прочитать конфигурационный файл nginx.conf внутри докер контейнера через команду exec
``` brew
команда - docker run -d -p 80:80 88736fe82739
          docker exec 7c394b3d337b cat /etc/nginx/nginx.conf
```
![](/screenshots/2.1.png)
2.2 Создать на локальной машине файл nginx.conf
2.3 Настроить в нем по пути /status отдачу страницы статуса сервера nginx
![](/screenshots/2.2.png)
2.3 Скопировать созданный файл nginx.conf внутрь докер образа через команду docker cp
``` brew
команда - docker cp nginx.conf 7c394b3d337b:/etc/nginx/
```
2.4 Перезапустить nginx внутри докер образа через команду exec
``` brew
команда - docker exec 7c394b3d337b nginx -s reload
```
![](/screenshots/2.3.png)

2.5 Проверить, что по адресу localhost:80/status отдается страничка со статусом сервера nginx
![](/screenshots/2.4.png)

2.6 Экспортировать контейнер в файл container.tar через команду export
``` brew
команда - docker export 7c394b3d337b > container.tar
```
2.7 Остановить контейнер
``` brew
команда - docker stop 7c394b3d337b
```
![](/screenshots/2.5.png)

2.8 Удалить образ через docker rmi [image_id|repository], не удаляя перед этим контейнеры
``` brew
команда - docker rmi 88736fe82739 -f 
```
![](/screenshots/2.6.png)
2.9 Удалить остановленный контейнер
``` brew
команда - docker rm 7c394b3d337b
```
![](/screenshots/2.7.png)
2.10 Импортировать контейнер обратно через команду import
``` brew
команда - docker import -c 'cmd ["nginx", "-g", "daemon off;"]' -c 'ENTRYPOINT 
          ["/docker-entrypoint.sh"]' /screenshots/container.tar nginx_imp
```
2.11 Запустить импортированный контейнер
``` brew
команда - docker run -d -p 80:80 8f2316e63344
```
2.12 Проверить, что по адресу localhost:80/status отдается страничка со статусом сервера nginx
``` brew
команда - curl localhost:80/status
```
![](/screenshots/2.8.png)
![](/screenshots/2.9.png)
## Part 3. Мини веб-сервер
3.1 Написать мини сервер на C и FastCgi, который будет возвращать простейшую страничку с надписью Hello World!
![](/screenshots/3.1.png)
3.2 Написать свой nginx.conf, который будет проксировать все запросы с 81 порта на 127.0.0.1:8080
![](/screenshots/3.2.png)
3.3 Запустить написанный мини сервер через spawn-fcgi на порту 8080

Последоватлеьность действий:
``` brew
docker pull nginx
docker images
docker run -d -p 81:81 [IMAGE_ID]
docker ps
```
![](/screenshots/3.3.png)
``` brew
docker cp nginx.conf [CONTAINER ID]:/etc/nginx/
docker cp server.c [CONTAINER ID]:/home/
docker exec -it [CONTAINER ID] bash     // чтобы подключиься к контейнеру
```
![](/screenshots/3.4.png)
``` brew
apt-get update
apt-get install gcc
apt-get install spawn-fcgi
apt-get install libfcgi-dev
gcc *.c -lfcgi
spawn-fcgi -p 8080 /screenshots/a.out
nginx -s reload
```
![](/screenshots/3.5.png)

3.4 Проверить, что в браузере по localhost:81 отдается написанная вами страничка
``` brew
curl localhost:81
```
![](/screenshots/3.7.png)
![](/screenshots/3.6.png)
## Part 4. Свой докер
4.1 Написать свой докер образ, который:

1) собирает исходники мини сервера на FastCgi из Части 3

2) запускает его на 8080 порту

3) копирует внутрь образа написанный /screenshots/nginx/nginx.conf

4) запускает nginx.

4.2 Собрать написанный докер образ через docker build при этом указав имя и тег

4.3 Проверить через docker images, что все собралось корректно

![](/screenshots/4.1.png)
![](/screenshots/4.2.png)
![](/screenshots/4.6.png)
4.3 Запустить собранный докер образ с маппингом 81 порта на 80 на локальной машине и маппингом папки /screenshots/nginx внутрь контейнера по адресу, где лежат конфигурационные файлы nginx'а (см. Часть 2)

4.4 Проверить, что по localhost:80 доступна страничка написанного мини сервера
![](/screenshots/4.3.png)

4.5 Дописать в /screenshots/nginx/nginx.conf проксирование странички /status, по которой надо отдавать статус сервера nginx
![](/screenshots/4.4.png)
4.6 Перезапустить докер образ
![](/screenshots/4.5.png)
## Part 5. Dockle
5.1 Просканировать образ из предыдущего задания через dockle [image_id|repository]
``` brew
команда dockle -i CIS-DI-0010 r:r
```
![](/screenshots/5.1.png)
![](/screenshots/5.2.png)

5.2 Исправить образ так, чтобы при проверке через dockle не было ошибок и предупреждений
![](/screenshots/5.3.png)
![](/screenshots/5.4.png)
## Part 6. Базовый Docker Compose
6.1 Написать файл docker-compose.yml, с помощью которого:
1) Поднять докер контейнер из Части 5 (он должен работать в локальной сети, т.е. не нужно использовать инструкцию EXPOSE и мапить порты на локальную машину)
2) Поднять докер контейнер с nginx, который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера
![](/screenshots/6.2.png)
6.2 Замапить 8080 порт второго контейнера на 80 порт локальной машины
![](/screenshots/6.1.png)

6.3 Собрать и запустить проект с помощью команд docker-compose build и docker-compose up

6.4 Проверить, что в браузере по localhost:80 отдается написанная вами страничка, как и ранее
![](/screenshots/6.3.png)
![](/screenshots/6.4.png)
