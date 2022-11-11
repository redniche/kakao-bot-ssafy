# docker-compose의 무중단 배포를 위한 스크립트

#!/bin/bash

# Blue/Green 배포를 위한 변수
# 현재 배포된 컨테이너 이름 blue 포함
BLUE_CONTAINER=$(docker ps -f name=blue -q)
# 새로운 컨테이너 이름
NEW_CONTAINER=$(docker ps -f name=green -q)

# 현재 배포된 컨테이너가 없다면
if [ -z "$CURRENT_CONTAINER" ]; then
    # 새로운 컨테이너를 현재 컨테이너로 설정
    CURRENT_CONTAINER=$NEW_CONTAINER
    # 새로운 컨테이너 이름을 비워줌
    NEW_CONTAINER=""
fi

# 현재 컨테이너가 없다면
if [ -z "$CURRENT_CONTAINER" ]; then
    # 현재 컨테이너를 blue로 설정
    CURRENT_CONTAINER=blue
    # blue 컨테이너를 생성
    docker-compose up -d blue
else
    # 새로운 컨테이너를 생성
    docker-compose up -d green
    # 새로운 컨테이너가 생성되기 전까지 기다림
    sleep 10
fi  


# 프로세스에 새로운 컨테이너가 생성되었는지 확인
NEW_CONTAINER=$(docker ps -f name=green -q)

# 새로운 컨테이너가 생성되었다면
if [ -n "$NEW_CONTAINER" ]; then
    # 새로운 컨테이너에 nginx 설정
    docker exec -it $NEW_CONTAINER /bin/bash -c "cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak"
    docker exec -it $NEW_CONTAINER /bin/bash -c "cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak"
    docker cp nginx/nginx.conf $NEW_CONTAINER:/etc/nginx/nginx.conf
    docker cp nginx/default.conf $NEW_CONTAINER:/etc/nginx/conf.d/default.conf
    docker exec -it $NEW_CONTAINER /bin/bash -c "nginx -s reload"
    # 새로운 컨테이너에 letsencrypt 설정
    docker exec -it $NEW_CONTAINER /bin/bash -c "certbot --nginx -d t7c29.p.ssafy.io"
    # 새로운 컨테이너에 docker-compose 설정
    docker exec -it $NEW_CONTAINER /bin/bash -c "cp /home/ubuntu/docker-compose.yml /home/ubuntu/docker-compose.yml.bak"
    docker cp docker-compose.yml $NEW_CONTAINER:/home/ubuntu/docker-compose.yml
    # 새로운 컨테이너에 deploy.sh 설정
    docker exec -it $NEW_CONTAINER /bin/bash -c "cp /home/ubuntu/deploy.sh /home/ubuntu/deploy.sh.bak"
    docker cp deploy.sh $NEW_CONTAINER:/home/ubuntu/deploy.sh
    # 새로운 컨테이너에 nginx 설정
    docker exec -it $NEW_CONTAINER /bin/bash -c "cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak"
    docker exec -it $NEW_CONTAINER /bin/bash -c "cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak"
    docker cp nginx.conf $NEW_CONTAINER:/etc/nginx/nginx.conf
    docker cp default.conf $NEW_CONTAINER:/etc/nginx/conf.d/default.conf
    docker exec -it $NEW_CONTAINER /bin/bash -c "nginx -s reload"
    # 새로운 컨테이너에 letsencrypt 설정
    docker exec -it $NEW_CONTAINER /bin/bash -c "certbot --nginx -d t7c29.p.ssafy.io"
    # 새로운


#  컨테이너 이름에 맞는 /nginx/nginx.${CURRENT_CONTAINER}.conf 파일을 /etc/nginx/nginx.conf로 복사
