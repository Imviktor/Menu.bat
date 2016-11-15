@echo off

rem Opciones de Maven
rem - Por defecto autmentamos la memoria para evitar problemas de PermGen
rem - Si es necesario aumentar o midificar estas opciones a medida que el 
rem   proyecto se complique

rem #### Subcommands definition
IF NOT "%1"=="" GOTO subcomandos

:menu_start
echo CD="%CD%"
echo .
echo .
echo .        .d8888b.  8888888b.   .d88888b.  888 
echo .       d88p  y88b 888   Y88b d88P" "Y88b 888
echo .      Y88b.       888    888 888     888 888
echo .       "Y888b.    888   d88P 888     888 888
echo .         "Y88b.   8888888P"  888     888 888
echo .           "888   888        888     888 888
echo .      Y88b  d88P  888        Y88b. .d88P 888b.....
echo .       "Y8888P"   888         "Y88888P"  888888888
echo . -------------------------------------------------------
echo .    					Menu SPOL
echo . -------------------------------------------------------
set OPTION=1
SET CHOICE=
:menu
set CHOICES=
echo . %CHOICE%

rem ---------------------------------- OPCIONES ------------------------------------

set LABEL=deployDesar
set TEXT=Desplegar en desarrollo (Desarrollo - Requiere acceso sin proxy)
set KEY=1
if "%CHOICE%"=="" echo . %KEY%. %TEXT%  
if "%OPTION%"=="%CHOICE%" goto %LABEL%
set CHOICES=%CHOICES%%KEY%
set /a "OPTION+=1"

echo .
echo . ---------------- OFFLINE MODE ----------------
echo .

set LABEL=testOffline
set TEXT=Test de funcionamiento offline
set KEY=2
if "%CHOICE%"=="" echo . %KEY%. %TEXT%  
if "%OPTION%"=="%CHOICE%" goto %LABEL%
set CHOICES=%CHOICES%%KEY%
set /a "OPTION+=1"

set LABEL=customRepo
set TEXT=Build project with custom repo
set KEY=3
if "%CHOICE%"=="" echo . %KEY%. %TEXT%  
if "%OPTION%"=="%CHOICE%" goto %LABEL%
set CHOICES=%CHOICES%%KEY%
set /a "OPTION+=1"

set LABEL=deployOffline
set TEXT=Desplegar en servidor offline (Servidor)
set KEY=4
if "%CHOICE%"=="" echo . %KEY%. %TEXT%  
if "%OPTION%"=="%CHOICE%" goto %LABEL%
set CHOICES=%CHOICES%%KEY%
set /a "OPTION+=1"

set LABEL=installCustomLibs
set TEXT=Instalar libs personalizadas (Desarrollo)
set KEY=5
if "%CHOICE%"=="" echo . %KEY%. %TEXT%  
if "%OPTION%"=="%CHOICE%" goto %LABEL%
set CHOICES=%CHOICES%%KEY%
set /a "OPTION+=1"

echo .
echo .

rem ########################################################

choice /C %CHOICES%
set CHOICE=%errorlevel%
set OPTION=1
goto menu

rem ########################################################
:deployDesar
echo Desplegar Desarrollo
start %CD%\menu.bat deployDesar
goto menu_start

:testOffline
echo Test de funcionamiento offline
start %CD%\menu.bat testOffline
goto menu_start

:customRepo
echo Test de funcionamiento offline
start %CD%\menu.bat customRepo
goto menu_start

:deployOffline
echo Desplegar Offline
start %CD%\menu.bat deployOffline
goto menu_start

:installCustomLibs
echo Instalar librerias
start %CD%\menu.bat installCustomLibs
goto menu_start

rem ===========================================
:subcomandos
echo . -------------------------------------------
echo .    Menu SPOL . Subcomando %1
echo . -------------------------------------------
goto do_%1

echo .
echo ERROR. Subcomando no reconocido %1
echo . 
pause
goto end

:do_deployDesar
call mvn clean install
call mvn -Djetty.port=8080 jetty:run
goto end

:do_testOffline
call mvn dependency:go-offline -Dmaven.repo.local=%CD%\repo
goto end

:do_customRepo
call mvn clean install -Dmaven.repo.local=%CD%\repo
goto end

:do_deployOffline
call mvn -o clean install jetty:run -Djetty.port=80 -Dmaven.repo.local=%CD%\repo
goto end

:do_installCustomLibs
call mvn install:install-file -Dfile=lib\oplall-12.6.jar -DgroupId=com.ibm.cplex -DartifactId=oplall -Dversion=12.6 -Dpackaging=jar
goto end

:end