FROM ubuntu:22.04

RUN apt update && \
    apt install -y ffmpeg curl

WORKDIR /app
COPY . .
RUN chmod +x live.sh fetch_videos.sh

CMD ["./live.sh"]
