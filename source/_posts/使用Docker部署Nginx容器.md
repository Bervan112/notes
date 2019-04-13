title: 使用Docker部署Nginx容器
date: 2018-10-22 18:00:00
permalink: docker-nginx-deploy
categories: 
- Docker
tags:
- Docker
- Nginx
- 建栋
---


## 背景
使用docker部署nginx碰到的unknown: Are you trying to mount a directory onto a file (or vice-versa)? Check if the specified 问题和解决方案。


## 语言环境
* docker 18.03.1-ce
* nginx 1.15.5
* Mac OSX 10.11.4 

<!--more-->

## 一、Docker 安装 Nginx
### 1.docker search nginx
查找 Docker Hub 上的 nginx 镜像
```
tanjiandongdeMacBook-Pro:nginx jayden$ docker search nginx
NAME                                                   DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
nginx                                                  Official build of Nginx.                        9946                [OK]                
jwilder/nginx-proxy                                    Automated Nginx reverse proxy for docker con…   1435                                    [OK]
richarvey/nginx-php-fpm                                Container running Nginx + PHP-FPM capable of…   627                                     [OK]
jrcs/letsencrypt-nginx-proxy-companion                 LetsEncrypt container to use with nginx as p…   425                                     [OK]
kong                                                   Open-source Microservice & API Management la…   235                 [OK]                
webdevops/php-nginx                                    Nginx with PHP-FPM                              114                                     [OK]
kitematic/hello-world-nginx                            A light-weight nginx container that demonstr…   111                                     
zabbix/zabbix-web-nginx-mysql                          Zabbix frontend based on Nginx web-server wi…   73                                      [OK]
bitnami/nginx                                          Bitnami nginx Docker Image                      58                                      [OK]
1and1internet/ubuntu-16-nginx-php-phpmyadmin-mysql-5   ubuntu-16-nginx-php-phpmyadmin-mysql-5          48                                      [OK]
```
搜索结果中的NAME是镜像的名称，OFFICIAL是否为官方镜像。

### 2.docker pull nginx
这里我们拉去官方的nginx镜像，下载成功之后，本地就会有可用的nginx镜像了。
```
tanjiandongdeMacBook-Pro:nginx jayden$ docker images nginx
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               latest              dbfc48660aeb        6 days ago          109MB
```
## 二、使用镜像运行容器
```$xslt
#创建nginx目录，挂载容器文件使用
tanjiandongdeMacBook-Pro:tmp jayden$ mkdir nginx 
#运行容器
tanjiandongdeMacBook-Pro:tmp jayden$ docker run -p 80:80 --name mynginx -v $PWD/www:/www -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf -v $PWD/conf/conf.d:/etc/nginx/conf.d/ -v $PWD/logs:/wwwlogs -d nginx
bc286f0e22cd7bf0c1c33a797830f42e8c1f4db780395e21b96fbee77ac265f1
docker: Error response from daemon: OCI runtime create failed: container_linux.go:348: starting container process caused 
"process_linux.go:402: container init caused \"rootfs_linux.go:58: mounting \\\"/Users/jayden/developer/docker/tmp/conf/nginx.conf\\\"
 to rootfs \\\"/var/lib/docker/overlay2/f434d457863a046191fb197225c0600efefad30e017ad693e6a53018bf553af0/merged\\\" 
 at \\\"/var/lib/docker/overlay2/f434d457863a046191fb197225c0600efefad30e017ad693e6a53018bf553af0/merged/etc/nginx/nginx.conf\\\" 
 caused \\\"not a directory\\\"\"": unknown: Are you trying to mount a directory onto a file (or vice-versa)? Check if the specified 
 host path exists and is the expected type.
```

命令说明：
+ -p 80:80：将容器的80端口映射到主机的80端口
+ --name mynginx：将容器命名为mynginx
+ -v $PWD/www:/www：将主机中当前目录下的www挂载到容器的/www
+ -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf：将主机中当前目录下的nginx.conf挂载到容器的/etc/nginx/nginx.conf
+ -v $PWD/conf/conf.d:/etc/nginx/conf.d：将主机中当前目录下的conf/conf.d挂载到容器的/etc/nginx/conf.d
+ -v $PWD/logs:/wwwlogs：将主机中当前目录下的logs挂载到容器的/wwwlogs

如上输出运行容器错误信息""not a directory\\\"\"": unknown: Are you trying to mount a directory onto a file"
这是因为容器中的/etc/nginx/nginx.conf是一个文件，而挂载主机$PWD/conf/nginx.conf会当作成目录，
从错误信息得知挂载的应该为文件而非目录，所以尝试在nginx目录下手动创建conf/nginx.conf文件.

**nginx.conf文件：**
```
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf; 
}

```
**在conf.d目录下创建default.conf文件（配置默认localhost:80服务）：**
```$xslt
server {
    listen       80;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```
**文件结构如下：**
```$xslt
tanjiandongdeMacBook-Pro:nginx jayden$ ls -R
conf	logs	www

./conf:
conf.d		nginx.conf

./conf/conf.d:
default.conf

./logs:

./www:

```
**再次运行容器**
```$xslt
tanjiandongdeMacBook-Pro:tmp jayden$ docker run -p 80:80 --name mynginx -v $PWD/www:/www -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf -v $PWD/conf/conf.d:/etc/nginx/conf.d/ -v $PWD/logs:/wwwlogs -d nginx
ccc35bc38a61c4e0379ebce79a2556e49228192a7610f27337029bc0259d2461
```
成功运行容器，并返回容器ID，执行命令``docker ps``查看正在运行的容器，返回结果如下：
```$xslt
tanjiandongdeMacBook-Pro:nginx jayden$ docker ps
CONTAINER ID   IMAGE  COMMAND                  CREATED             STATUS              PORTS                 NAMES
ccc35bc38a61   nginx  "nginx -g 'daemon of…"   4 minutes ago       Up 4 minutes        0.0.0.0:80->80/tcp    mynginx
```
主要说明：
+ CONTAINER ID：当前容器的ID
+ IMAGE       ：该容器使用哪个镜像运行
+ COMMAND     ：启动容器的命令行
+ CREATED     ：容器创建时间
+ STATUS      ：显示该容器的运行或停止状态，Up 4 minutes表示已运行4分钟
+ PORTS       ：容器的80端口映射到主机的80端口
+ NAMES       ：容器名称mynginx

**可以直接进入 [http://localhost](http://localhost) 访问，成功访问如下图所示。**
![welcom](images/nginx/1.png "Welcome to nginx")

## 相关命令
+ docker search nginx #搜索镜像
+ docker pull nginx #下载镜像到本地
+ docker image ls #列出所有的镜像
+ docker rmi nginx #删除镜像
+ docker ps #列出所有正在运行的容器，docker ps -a 查看所有的容器(包括已停止的容器)
+ docker run #从镜像中创建并运行容器
+ docker stop mynginx #暂停容器
+ docker start mynginx #启动容器
+ docker restart mynginx #重启容器
+ docker rm mynginx #删除容器
+ docker exec -it mynginx /bin/sh #进入nginx容器
+ docker logs -f -t --since="2018-10-23" --tail=10 mynginx #查看docker日志文件
   + --tail = 10 : 读取最后10条记录
   + --since : 哪天的日志
   + --mynginx : 容器名

## 参考文章

* [Docker 安装 Nginx](http://www.runoob.com/docker/docker-install-nginx.html)
* [使用docker部署nginx容器](https://blog.csdn.net/u013494765/article/details/78258270?locationNum=5&fps=1)
