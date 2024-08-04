FROM nginx:latest

# 기본 패키지 업데이트 및 설치
RUN apt update && apt install -y python3-full procps dos2unix && apt clean

# 작업 디렉토리 설정
WORKDIR /flaskapp

# Python 가상 환경 생성
RUN python3 -m venv /flaskapp/venv

# 의존성 파일 복사 및 설치
COPY requirements.txt /flaskapp/
RUN /flaskapp/venv/bin/pip install -r /flaskapp/requirements.txt

# 애플리케이션 파일 복사
COPY app.py /flaskapp/

# Nginx 설정 파일 복사 및 심볼릭 링크 생성
COPY site.conf /etc/nginx/sites-available/flaskapp.conf
RUN ln -s /etc/nginx/sites-available/flaskapp.conf /etc/nginx/conf.d \
    && mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak

# 시작 스크립트 복사 및 실행 권한 설정
COPY start.sh /flaskapp/start.sh
RUN dos2unix /flaskapp/start.sh
RUN chmod +x /flaskapp/start.sh

# 컨테이너 시작 명령
ENTRYPOINT ["/flaskapp/start.sh"]
