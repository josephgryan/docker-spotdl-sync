FROM python:3.12-slim
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg git curl \
  && pip install --no-cache-dir git+https://github.com/TzurSoffer/spotify-downloader \
  && rm -rf /var/lib/apt/lists/*
ENV DENO_INSTALL=/usr/local
RUN curl -fsSL https://deno.land | sh
WORKDIR /app
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
CMD ["/app/entrypoint.sh"]