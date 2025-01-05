# streamfallback

receives an Srt stream, outputs to Rtmp (Twitch/Youtube) or Srt

if the Srt ingest fails or disconnects, it automatically switches to fallback videos. Instantly switches back if Srt comes back online - ideal for IRL streamers

Works with hvec input, since we need reencoding anyway to properly switch to fallback videos

for easy of use docker-compose:
```yml
services:
  liquidsoap:
    image: savonet/liquidsoap:v2.3.0
    volumes:
      - /home/liquidsoap:/app
    working_dir: /app
    network_mode: host
    command: ["liquidsoap", "streaming.liq"]
```

Todo:
- use env for streamkey
