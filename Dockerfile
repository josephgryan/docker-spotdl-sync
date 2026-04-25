FROM python:3.12-alpine

RUN apk add --no-cache ffmpeg dcron git \
 && pip install --no-cache-dir git+https://github.com/TzurSoffer/spotify-downloader
 
WORKDIR /app

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

CMD ["/app/entrypoint.sh"]