set TMP_ANDROID_HOME=%ANDROID_HOME%
set android_home=
set ANDROID_HOME=%TMP_ANDROID_HOME%
set TMP_ANDROID_HOME=
call pik use 193
call bundle exec cucumber --tags @sanity --tags ~@wip > cukes_output.txt
type cukes_output.txt
type cukes_output.txt | findstr /C:"Failing Scenarios"
if ERRORLEVEL 0 SET RETCODE=1
if ERRORLEVEL 1 SET RETCODE=0
exit %RETCODE%