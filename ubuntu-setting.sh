# Ubuntu 20.04 LTS에 필요한 설정을 한다.
# docker-compose를 사용하기 위해 docker를 설치한다.
# ufw 설정을 한다

# !/bin/bash

# docker 설치
sudo apt-get update
sudo apt-get install -y docker.io

# docker-compose 설치
sudo apt-get install -y python3-pip
sudo pip3 install docker-compose

# ufw 설정
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 8080
sudo ufw allow 8081
sudo ufw enable

# letsencrypt를 사용해 https 설정
sudo apt-get install -y certbot python3-certbot-nginx
# standalone 모드로 설정
sudo certbot certonly --standalone -d t7c29.p.ssafy.io
# nginx 설정
sudo certbot --nginx -d t7c29.p.ssafy.io

# nginx 설정
sudo apt-get install -y nginx
