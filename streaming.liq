#set("log.level", 4)
# set all pipelines to defaults
settings.frame.video.width := 1920
settings.frame.video.height := 1080
settings.frame.video.framerate := 25

srtinput =
  input.srt(
    port=1234,
    mode="listener",
    streamid="something"
  )
fallback_video = playlist(reload_mode="always", "slate/")

enc =
  %ffmpeg(
    format = "flv",
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
      preset = "fast",
      "x264-params" =
        "keyint=50:min-keyint=50:scenecut=0:vbv-bufsize=12000:vbv-maxrate=6000:bitrate=6000",
      video_size = "1920x1080",
      framerate = 25
    )
  )

outputd = fallback(track_sensitive=false, [srtinput, fallback_video])

# output.srt(
#   mode="caller",
#   port=4321,
#   streamid="something",
#   enc,
#   fallible=true,
#   outputd
# )

TwitchStreamKey = getenv("", "TWITCH_STREAM_KEY")

# print
print(
  "TwitchStreamKey: #{TwitchStreamKey}"
)

# if no key exit
if TwitchStreamKey == "" then exit(2) end

output.url(
  fallible=true,
  url="rtmp://live.twitch.tv/app/#{TwitchStreamKey}",
  enc,
  outputd
)
