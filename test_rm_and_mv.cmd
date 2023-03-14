@echo off
set PATH=c:\msys64\usr\bin
set PROMPT=+$s
set result=0

dir c:\opt\msys2-runtime-* > NUL 2>&1
if NOT ERRORLEVEL 1 sh -x -c "pacman -Up --noconfirm /c/opt/msys2-runtime-*"

echo;
echo === normal directory : prepare

sh -x -c "rm -rf /c/normal_dir && mkdir -p /c/normal_dir"
sh -x -c "touch /c/normal_dir/file_to_unlink"
sh -x -c "touch /c/normal_dir/file_to_rename"
sh -x -c "find /c/normal_dir -type f"

echo;
echo === normal directory : test

sh -x -c "rm /c/normal_dir/file_to_unlink"
call :a
sh -x -c "mv /c/normal_dir/file_to_rename /c/normal_dir/rename_complete"
call :a
sh -x -c "find /c/normal_dir -type f"

echo;
echo === bind mounted directory : prepare

@echo on
del /q c:\binded_dir\*
@echo off
sh -x -c "touch /c/binded_dir/file_to_unlink"
sh -x -c "touch /c/binded_dir/file_to_rename"
sh -x -c "find /c/binded_dir -type f"

echo;
echo === bind mounted directory : test

sh -x -c "rm /c/binded_dir/file_to_unlink"
call :a
sh -x -c "mv /c/binded_dir/file_to_rename /c/binded_dir/rename_complete"
call :a
sh -x -c "find /c/binded_dir -type f"

echo;
echo === crossing directory mv : prepare

@echo on
del /q c:\binded_dir\*
@echo off
sh -x -c "rm -rf /c/normal_dir && mkdir -p /c/normal_dir"
sh -x -c "touch /c/normal_dir/normal_to_bind"
sh -x -c "touch /c/binded_dir/binded_to_normal"
sh -x -c "(find /c/normal_dir /c/binded_dir -type f)"

echo;
echo === crossing directory mv : test

sh -x -c "mv /c/normal_dir/normal_to_bind /c/binded_dir/to_binded_complete"
call :a
sh -x -c "mv /c/binded_dir/binded_to_normal /c/normal_dir/to_normal_complete"
call :a
sh -x -c "(find /c/normal_dir /c/binded_dir -type f)"

echo;
echo === environment

sh -x -c "ls -l /usr/bin/msys-2.0.dll"
sh -x -c "pacman -Qi msys2-runtime"

exit /b %result%

rem accumulate errorlevel
:a
echo [41mfailed.[m
set /a result=%result%+%errorlevel%
exit /b

