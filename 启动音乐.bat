echo off
chcp 65001
setlocal enabledelayedexpansion

taskkill /f /im mpv.exe

rem ############################
if not exist config.txt (
    echo 配置文件不存在，自动生成默认配置
    (
echo =基础=======================
echo ·mpv.exe程序路径
echo mpv\mpv.exe
echo ·播放音量（数值）（默认60）
echo 60
echo =功能=======================
echo ·时间间隔（true/false）（默认false）
echo false
echo ·时间间隔时长（数值/小时）（默认5）
echo 5
echo ============================
echo 注意事项:每一项都不能留空
    ) > config.txt
    echo 请重试
    Pause
    goto end
)
if not exist playlist.txt (
    type nul >playlist.txt
    echo playlist.txt文件不存在,现已创建
    echo 请添加一个音乐文件后再尝试
    Pause
    goto end
)
if not exist time.txt (
    echo -24>>time.txt
    echo 100>>time.txt
    echo time.txt文件不存在,现已创建
    Pause
)

rem ############################
:: 时间间隔是否启用
set interval=true
for /f "skip=7 delims=" %%a in (config.txt) do (
    echo 时间间隔是否启用：%%a
    set interval=%%a
    goto l1
)
:l1
::时间间隔时间
set /a interval_time=5
for /f "skip=9 delims=" %%a in (config.txt) do (
    echo 时间间隔时间：%%a
    set interval_time=%%a
    goto l2
)
:l2
:: mpv.exe路径
for /f "skip=2 delims=" %%a in (config.txt) do (
    echo mpv.exe路径：%%a
    set mpv_path=%%a
    goto l3
)
:l3
:: 播放音量
set /a volume=60
for /f "skip=4 delims=" %%a in (config.txt) do (
    echo 播放音量：%%a
    set volume=%%a
    goto l4
)
:l4
rem ############################
:: 音乐数量
for /f "delims=" %%i in (playlist.txt) do (
        set /a music_count+=1
)
echo 当前播放列表歌曲数量：%music_count% 
rem ############################

set "day=%date:~11,2%"
set "hour=%time:~0,2%"
echo 当前日期：%day%
echo 当前时间：%hour%  
set /a day_num=1%day% - 100
set /a hour_num=1%hour% - 100
echo date完整内容=[%date%]

if not exist time.txt (
    echo time.txt文件不存在 此次播放音乐
    goto loop
)

set "targetFile=time.txt"

:: 读取第1行（PowerShell 数组从0开始计数，第1行对应索引0）
for /f "delims=" %%a in ('powershell "(Get-Content '%targetFile%')[0]"') do set "line1=%%a"
:: 读取第2行（对应索引1）
for /f "delims=" %%b in ('powershell "(Get-Content '%targetFile%')[1]"') do set "line2=%%b"

echo 上次播放-小时：%line1%
echo 上次播放-日期：%line2%

set /a time_1=hour_num - line1
set /a time_2=day_num - line2

echo 时间间隔-小时：%time_1%
echo 时间间隔-日期：%time_2%

if "%interval%"=="true" (
    echo 时间间隔启用
    
    if %line2% equ %day% (
        if %time_1% leq %interval_time% (
        echo 时间间隔触发
        goto end
        )
    ) else (
        echo 时间间隔未触发
    )
) else (
    echo 时间间隔未启用
)


::重置played.txt文件
if exist played.txt (
    for /f "delims=" %%i in (played.txt) do (
        set /a count+=1
    )
    echo 当前已播放歌曲数量：%count%
    if !count! geq %music_count% (
        echo 已达到最大歌曲数量 重置played.txt文件
        del played.txt
    )
)

:loop


set /a calls+=1
echo 选择音乐次数：%calls%
if %calls% geq 1000 (
    echo 已达到最大选择次数 重置played.txt文件
    del played.txt
)

rem ------------------------歌曲选择---------------------------------------------
set /a num=!random! %% %music_count%
echo 随机选择的音乐编号：%num%

if %num% ==0 (
    for /f "delims=" %%a in (playlist.txt) do (
        set music=%%a
        goto l
    )
)
for /f "skip=%num% delims=" %%a in (playlist.txt) do (
    set music=%%a
    goto l
)
:l
rem ---------------------------------------------------------------------------

echo 选中的项目: !music!

:: 判断是否重新选择音乐
for /f "delims=" %%i in (played.txt) do (
        echo 当前与判断%%i
        if "%%i"=="!music!" (
            echo 音乐已播放过，重新选择
            goto loop
        )
    )
if exist played.txt (
   echo played.txt文件存在
)
echo !music! >> played.txt

start /b %mpv_path% "!music!" --no-video --volume=%volume% --audio-display=no --force-window=no

echo play !music!

set "day=%date:~11,2%"
set "hour=%time:~0,2%"
echo 当前日期：%day%
echo 当前时间：%hour%  
set /a day_num=1%day% - 100
set /a hour_num=1%hour% - 100
echo date完整内容=[%date%]
(
echo %hour_num%
echo %day_num%
)>time.txt

:end
endlocal
timeout /t 5 /nobreak >nul