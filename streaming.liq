#set("log.level", 4)

srtinput =
  input.srt(
    port=6969,
    mode="listener",
    streamid="somethingsomething"
  )
fallback_video = playlist(reload_mode="always", "slate/")

e =
  %ffmpeg(
    format = "mpegts",
    %audio(
      codec = "libfdk_aac",
      samplerate = 48000,
      b = "32k",
      afterburner = 1,
      profile = "aac_he_v2"
    ),
    %video(
      codec = "libx264",
      b = "6000k",
      preset = 4,
      "x264-params" = "scenecut=0:open_gop=0:min-keyint=150:keyint=150",
      video_size = "1920x1080",
      framerate = 25
    )
  )

outputd = fallback(track_sensitive=false, [srtinput, fallback_video])

output.srt(
  mode="caller",
  port=6420,
  streamid="whatever",
  e,
  fallible=true,
  outputd
)


# to twitch "stream url" would then be [Twitch ingest server url]/[stream key]
# stream key is in environment variables
# output.url(
#   fallible=true,
#   url="rtmp://live.twitch.tv/app/STREAMKEY",
#   enc,
#   outputd
# )
