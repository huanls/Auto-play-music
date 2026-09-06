# Auto-play-music
# Introduction

This project controls the mpv media player via Windows batch scripts \(\.bat\) to achieve conditional automated music playback\.

---
<div align="left">
  <a href="./README.md">🌏English/中文</a>
</div>

# Usage Scenarios

- Add the script to the Windows startup list to enable automatic music playback on system boot

    - Adjust the *time interval* parameter to play music only once per day and start your day pleasantly

# Operation Logic

- When the script is launched, it automatically selects one music track from `playlist.txt` for playback

- Played music files are recorded in `played.txt`\. A track will not be replayed if it is already listed in `played.txt`, unless all tracks in the playlist have been recorded in `played.txt`

- Only one track will be played through mpv per script launch

# Feature Details

## Time Interval

- The time difference \(in hours\) between the current launch and the last launch is compared against the configured **time interval duration** parameter\. Playback will be skipped if the difference is smaller than the configured value, and proceed if larger\.

- If the last playback and current playback do not fall on the same calendar day \(with 00:00 as the day boundary\), playback will start directly regardless of the time interval comparison result\.

# Configuration Files

## *playlist\.txt*

Defines the music library for playback

- Add the relative or absolute path of each music file on a separate line

## *config\.txt*

Stores required runtime parameters and feature enable/disable toggles

- **No field may be left blank**

- Enter `true` or `false` to enable or disable features

- Fill in parameters according to the prompts inside the configuration file

```config.txt
=Basic=======================
·mpv.exe path
mpv\mpv.exe
·Playback volume (numeric) (default: 60) (range: 0~100)
60
=Features=======================
·Time interval (true/false) (default: false)
false
·Time interval duration (numeric/hours) (default: 5)
5
============================
Note: No field can be left blank
```

# Installation \& Usage

## mpv Installation \(Dependency\)

- Visit [https://github\.com/zhongfly/mpv\-winbuild/releases](https://github.com/zhongfly/mpv-winbuild/releases)

- Find and download the build matching your system architecture

- Extract the archive and save it anywhere on your computer, or place it in the same directory as the script

## Script Installation

- Go to the [Release page](https://github.com/huanls/Auto-play-music/releases) and download `main.zip`

- Extract `main.zip` to any location

- \(Optional\) Move the extracted mpv folder into the directory where you extracted `main.zip`

- Run `启动音乐.bat` repeatedly\. The script will generate and populate the configuration files automatically, and you will need to edit the configuration files following the terminal prompts each time\.

Configuration complete\. Thank you for using this script 😊😊😊

# Supplement

## Stop Music Playback

- Terminate the mpv process via Command Prompt \(cmd\) \(you can also save this command as a standalone batch script\)

```bat
taskkill /f /im mpv.exe
```

> （注：部分内容可能由 AI 生成）
