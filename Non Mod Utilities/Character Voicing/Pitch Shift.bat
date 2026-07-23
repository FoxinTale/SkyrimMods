@echo off
setlocal

set INDIR=C:\TTS\aileen_out_24k
set OUTDIR=C:\TTS\aileen_out_pitch_24k

mkdir "%OUTDIR%" 2>nul

for %%F in ("%INDIR%\*.wav") do (
    echo Processing %%~nxF
    P:\FFMPEG\bin\ffmpeg -y -i "%%F" -af "rubberband=pitch=1.0746078,aresample=44100" -ac 1 -sample_fmt s16 "%OUTDIR%\%%~nxF"
)

echo Done.
pause