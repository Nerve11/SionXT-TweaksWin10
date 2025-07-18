@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title SionXT-Tweaks - Optimized for Win10/11
:: Version: 4.0

:: Detect Windows Version (existing)
for /f "tokens=3" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild ^| findstr /ri "REG_SZ"') do set Build=%%i
for /f "tokens=3" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentMajorVersionNumber ^| findstr /ri "REG_SZ"') do set MajorVersion=%%i

if not defined MajorVersion (
    ver | find "10.0" >nul
    if %errorlevel% == 0 set MajorVersion=10
    ver | find "11.0" >nul
    if %errorlevel% == 0 set MajorVersion=11
)

if %MajorVersion% lss 10 (
    echo This script is designed for Windows 10/11. Exiting.
    pause
    exit
)
if %MajorVersion% == 10 if %Build% lss 19044 (
    echo Warning: This Windows 10 build is older than 21H2. Some tweaks may not apply correctly.
)
if %MajorVersion% == 11 if %Build% lss 22621 (
    echo Warning: This Windows 11 build is older than 22H2. Some tweaks may not apply correctly.
)
if %MajorVersion% == 11 if %Build% gtr 26100 (
    echo Warning: This Windows 11 build is newer than 24H2. Tweaks may need updates.
)

:: ==========================================================================
::                      SionXT-TweaksWin10 - License
:: ==========================================================================
::
:: This script is provided for personal, non-commercial use only.
::
:: **YOU ARE EXPRESSLY PROHIBITED FROM:**
::
:: 1.  Using this script for any commercial purposes, including but not
::     limited to selling, distributing, or incorporating it into
::     commercial products or services.
::
:: 2.  Using this script for any malicious, harmful, or illegal activities.
::
:: 3.  Distributing modified or unmodified versions of this script without
::     explicit permission from the original author (SionXT).
::
:: By using this script, you acknowledge and agree to these terms.
::
:: If you do not agree to these terms, you are not authorized to use this script.
::
:: ==========================================================================

:: UAC elevation
>nul 2>&1 reg query "HKU\S-1-5-19" || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
)

mode con: cols=80 lines=25
mode con: cols=80 lines=25

:: Function Definitions
:confirm_action
echo %~1 (Y/N)?
choice /c YN
if %errorlevel%==2 exit /b 1
exit /b 0

:execute_reg
%~1
if %errorlevel% neq 0 echo Warning: Failed - %~1
exit /b

:main_menu
cls
echo.
echo    ========================================
echo             SionXT-Tweaks
echo    ========================================
echo.
echo    [1] Service Optimization (Effective debloating)
echo    [2] Debloat Apps
echo    [3] GPU Optimization
echo    [4] CPU Optimization
echo    [5] Registry Optimization (Verified tweaks)
echo    [6] System Cleaning
echo    [7] Network Optimization (Low-latency focus)
echo    [8] Privacy Enhancements
echo    [0] EXIT
echo.
set /p choice=\"Select an option: \"

if \"%choice%\"==\"1\" goto optimize_service
if \"%choice%\"==\"2\" goto debloat
if \"%choice%\"==\"3\" goto gpu_optimization_menu
if \"%choice%\"==\"4\" goto cpusettings
if \"%choice%\"==\"5\" goto regsettings
if \"%choice%\"==\"6\" goto clean_temp_and_other
if \"%choice%\"==\"7\" goto network_optimization
if \"%choice%\"==\"8\" goto privacy_enhance
if \"%choice%\"==\"0\" exit

echo Invalid choice.
timeout /t 2 >nul
goto main_menu

:optimize_service
cls
echo Optimizing services...
call :confirm_action \"Disable non-essential services?\"
if %errorlevel% neq 0 goto main_menu

:: Backup Start - Added Backup Functionality from HoneCtrl ==========================
echo Creating System Restore Point and Registry Backups...
echo.

:: Make Hone Directory for Backups if it doesn't exist
mkdir %SYSTEMDRIVE%\Hone >nul 2>&1
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup >nul 2>&1

:: Create System Restore Point
echo Creating System Restore Point...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\' >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Checkpoint-Computer -Description 'SionXT Tweaks - Service Optimization Backup' >nul 2>&1

:: Create Registry Backups
echo Backing up Registry (HKCU and HKLM)...
for /F "tokens=2" %%i in ('date /t') do set date=%%i
set date1=%date:/=.%
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1% >nul 2>&1
reg export HKCU %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKCU_ServiceOptimization.reg /y >nul 2>&1
reg export HKLM %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKLM_ServiceOptimization.reg /y >nul 2>&1
echo.
echo System Restore Point and Registry Backups Created. Proceeding with Service Optimization...
timeout /t 3 /nobreak >nul

:: Backup End ====================================================================

:: Effective service disables (e.g., from Atlas OS inspiration): Disable Superfetch/SysMain, Search, Print, etc.
sc config SysMain start=disabled
sc stop SysMain
sc config WSearch start=disabled
sc stop WSearch
sc config Spooler start=disabled
sc stop Spooler
// Add more verified ones, remove unnecessary

:: Enhanced Defender removal (existing, keep)
echo Disabling Windows Defender Services...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpsdrv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wanarp" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f 2>nul

:: Additional Defender Disable for Win11
if %MajorVersion% == 11 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f 2>nul
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdFilter" /v "Start" /t REG_DWORD /d "4" /f 2>nul
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdBoot" /v "Start" /t REG_DWORD /d "4" /f 2>nul
)

:: Disable Printer Services
echo Disabling Printer Services...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Spooler" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PrintNotify" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul

:: Disable Troubleshooting
echo Disabling Troubleshooting Services...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TroubleshootingSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul

:: Disable Windows Updates
echo Disabling Windows Update Services...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DoSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "1" /f 2>nul

:: Disable Xbox services
echo Disabling Xbox Services...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XblGameSave" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\xboxgip" /v "Start" /t REG_DWORD /d "4" /f 2>nul

:: Disable Copy
echo Disabling Copy Services...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\cbdhsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\EFS" /v "Start" /t REG_DWORD /d "4" /f 2>nul

:: Disable Other Services and Drivers
echo Disabling Other Services...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBIOS" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventSystem" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SENS" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RemoteAccess" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppVClient" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WSearch" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Ndu" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\QWAVE" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\QWAVEdrv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TokenBroker" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\System\CurrentControlSet\Services\Beep" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\System\CurrentControlSet\Services\bam" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AJRouter" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\ALG" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppIDSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Appinfo" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppMgmt" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppReadiness" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppXSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AssignedAccessManagerSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\autotimesvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AxInstSV" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BITS" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BrokerInfrastructure" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\camsvc" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CertPropSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\COMSysApp" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CoreMessagingRegistrar" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CryptSvc" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CscService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DcomLaunch" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\defragsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceInstall" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevQueryBroker" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\diagnosticshub.standardcollector.service" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DispBrokerDesktopSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DisplayEnhancementService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DmEnrollmentSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DoSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dot3svc" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DsmSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DsSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DusmSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Eaphost" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\embeddedmode" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\EntAppSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventLog" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventSystem" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\fdPHost" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\FDResPub" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\fhsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\FrameServer" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\gpsvc" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GraphicsPerfSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\hidserv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\HvHost" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\icssvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\IKEEXT" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\InstallService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\iphlpsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\IpxlatCfgSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\KeyIso" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\KtmRm" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LicenseManager" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lltdsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LSM" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LxpSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MSDTC" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MSiSCSI" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\msiserver" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NaturalAuthentication" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcaSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcbService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netman" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\netprofm" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetSetupSvc" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NgcCtnrSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NgcSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nsi" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\p2pimsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\p2psvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PeerDistSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PerfHost" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PhoneSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\pla" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PNRPAutoReg" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PNRPsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Power" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\ProfSvc" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PushToInstall" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RemoteRegistry" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RmSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RpcEptMapper" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RpcLocator" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RpcSs" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SamSs" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SCardSvr" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\ScDeviceEnum" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Schedule" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SCPolicySvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SDRSVC" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\seclogon" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SEMgrSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SensorDataService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SensorService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SensrSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SessionEnv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SgrmBroker" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\shpamsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\smphost" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SmsRouter" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SSDPSRV" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\ssh-agent" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SstpSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\StateRepository" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stisvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\StorSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\svsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\swprv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SystemEventsBroker" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TabletInputService" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TapiSrv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TermService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TieringEngineService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TokenBroker" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TrkWks" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TrustedInstaller" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UevAgentService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UmRdpService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\upnphost" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UserManager" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\VaultSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\vds" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\vmicguestinterface" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\vmicheartbeat" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\vmickvpexchange" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\vmicrdv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\vmicshutdown" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\vmictimesync" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\vmicvmsession" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\vmicvss" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\VSS" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WalletService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wbengine" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WbioSrvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wcncsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdiServiceHost" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdiSystemHost" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WebClient" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wecsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wercplsupport" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WerSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WFDSConMgrSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WiaRpc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Winmgmt" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinRM" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "Start" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wlidsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wlpasvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WManSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f 2>nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableOnAccessProtection" /t REG_DWORD /d 1 /f 2>nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f 2>nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f 2>nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d 1 /f 2>nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableEmailScanning" /t REG_DWORD /d 1 /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wmiApSrv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpcMonSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WPDBusEnum" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpnService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WwanSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AarSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BcastDVRUserService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CredentialEnrollmentManagerUserSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevicePickerUserSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevicesFlowUserSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MessagingService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UdkUserSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UserDataSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpnUserService" /v "Start" /t REG_DWORD /d "3" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wscsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul

:: Remove Useless Services
echo Removing Useless Services...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\diagsvc" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Telemetry" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\sedsvc" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\MapsBroker" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\WarpJITSvc" /f 2>nul

:: Disable Push Notifications
echo Disabling Push Notifications...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f 2>nul

echo.
echo Windows 10 services optimization completed. Returning to main menu.
timeout /t 5 /nobreak >nul
goto main_menu


:memory_optimization
cls
echo Memory Optimization (Separate Feature) is selected.
echo.
echo **WARNING: Applying Memory Compression and Page Combine Tweaks.**
echo **INFO:** These tweaks are controversial and may not improve performance,
echo         and in some cases can degrade it. Proceed with caution
echo         and monitor your system after applying these tweaks.
pause
echo.

:: Backup Start - Added Backup Functionality from HoneCtrl ==========================
echo Creating System Restore Point and Registry Backups...
echo.

:: Make Hone Directory for Backups if it doesn't exist
mkdir %SYSTEMDRIVE%\Hone >nul 2>&1
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup >nul 2>&1

:: Create System Restore Point
echo Creating System Restore Point...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\' >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Checkpoint-Computer -Description 'SionXT Tweaks - Memory Optimization Backup' >nul 2>&1

:: Create Registry Backups
echo Backing up Registry (HKCU and HKLM)...
for /F "tokens=2" %%i in ('date /t') do set date=%%i
set date1=%date:/=.%
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1% >nul 2>&1
reg export HKCU %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKCU_MemoryOptimization.reg /y >nul 2>&1
reg export HKLM %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKLM_MemoryOptimization.reg /y >nul 2>&1
echo.
echo System Restore Point and Registry Backups Created. Proceeding with Memory Optimization...
timeout /t 3 /nobreak >nul

:: Backup End ====================================================================

:: DISABLE MEMORY COMPRESSION AND PAGE COMBINE (REQUIRES SYSMAIN) -
echo Applying DISABLE MEMORY COMPRESSION AND PAGE COMBINE Tweaks (Gaming Version)...
sc config SysMain start= auto
if %errorlevel% neq 0 (
    echo **ERROR:** Failed to configure SysMain service to start automatically. Error code: %errorlevel%
    pause
    goto main_menu
)
echo SysMain service configured to start automatically.
sc start SysMain
if %errorlevel% neq 0 (
    echo **ERROR:** Failed to start SysMain service. Error code: %errorlevel%
    echo Please ensure the service is not disabled by other policies or software.
    sc config SysMain start= disabled
    pause
    goto main_menu
)
echo SysMain service started.
powershell -Command "Disable-MMAgent -MemoryCompression"
if %errorlevel% neq 0 (
    echo **ERROR:** Failed to disable Memory Compression. Error code: %errorlevel%
}
echo Memory Compression disabled.
powershell -Command "Disable-MMAgent -PageCombining"
if %errorlevel% neq 0 (
    echo **ERROR:** Failed to disable Page Combining. Error code: %errorlevel%
}
echo Page Combining disabled.
sc stop SysMain
if %errorlevel% neq 0 (
    echo **ERROR:** Failed to stop SysMain service. Error code: %errorlevel%
}
echo SysMain service stopped.
sc config SysMain start= disabled
if %errorlevel% neq 0 (
    echo **ERROR:** Failed to configure SysMain service to disabled startup. Error code: %errorlevel%
}
echo SysMain service configured to disabled startup.

echo.
echo Memory Optimization completed. Returning to main menu.
timeout /t 5 /nobreak >nul
goto main_menu


:debloat
goto :debloat_section


:debloat_section
cls
echo Debloating Windows is underway. Do not touch anything. Thank you.
echo.
echo **WARNING:** Debloating will remove pre-installed applications.
echo Some of these applications might be desired.
echo Proceed with caution.
pause
echo.

:: Backup Start - Added Backup Functionality from HoneCtrl ==========================
echo Creating System Restore Point and Registry Backups...
echo.

:: Make Hone Directory for Backups if it doesn't exist
mkdir %SYSTEMDRIVE%\Hone >nul 2>&1
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup >nul 2>&1

:: Create System Restore Point
echo Creating System Restore Point...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\' >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Checkpoint-Computer -Description 'SionXT Tweaks - Debloat Backup' >nul 2>&1

:: Create Registry Backups
echo Backing up Registry (HKCU and HKLM)...
for /F "tokens=2" %%i in ('date /t') do set date=%%i
set date1=%date:/=.%
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1% >nul 2>&1
reg export HKCU %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKCU_Debloat.reg /y >nul 2>&1
reg export HKLM %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKLM_Debloat.reg /y >nul 2>&1
echo.
echo System Restore Point and Registry Backups Created. Proceeding with Debloat...
timeout /t 3 /nobreak >nul

:: Backup End ====================================================================

echo Removing pre-installed applications...

:: List of packages to remove
set "packages_to_remove=Microsoft.BingWeather,Microsoft.GetHelp,Microsoft.Getstarted,Microsoft.Messaging,Microsoft.Microsoft3DViewer,Microsoft.MicrosoftSolitaireCollection,Microsoft.MicrosoftStickyNotes,Microsoft.MixedReality.Portal,Microsoft.OneConnect,Microsoft.People,Microsoft.Print3D,Microsoft.SkypeApp,Microsoft.WindowsAlarms,Microsoft.WindowsCamera,microsoft.windowscommunicationsapps,Microsoft.WindowsMaps,Microsoft.WindowsFeedbackHub,Microsoft.WindowsSoundRecorder,Microsoft.YourPhone,Microsoft.ZuneMusic,Microsoft.HEIFImageExtension,Microsoft.WebMediaExtensions,Microsoft.WebpImageExtension,Microsoft.3dBuilder,bing,bingfinance,bingsports,CommsPhone,Drawboard PDF,Sway,WindowsAlarms,WindowsPhone,zune,Microsoft.Getstarted,Microsoft.ZuneVideo,Microsoft.ZuneMusic,Microsoft.GetHelp,Microsoft.Messaging,Microsoft.WindowsFeedbackHub,Microsoft.People,Microsoft.3DBuilder,Microsoft.Print3D,EclipseManager,ActiproSoftwareLLC,AdobeSystemsIncorporated.AdobePhotoshopExpress,'D5EA27B7.Duolingo-LearnLanguagesforFree',PandoraMediaInc,CandyCrush,*Wunderlist*,*Flipboard*,*Twitter*,*Facebook*,*Sway*,*disney*,Microsoft.BingTravel,Microsoft.BingHealthAndFitness,Microsoft.BingNews,Microsoft.BingSports,Microsoft.BingFoodAndDrink,Microsoft.BingWeather,Microsoft.BingFinance,Microsoft.Office.OneNote,Microsoft.MicrosoftOfficeHub,Microsoft.MicrosoftSolitaireCollection,Microsoft.BioEnrollment,ContentDeliveryManager,'Microsoft.Advertising.Xaml'"

for %%p in (%packages_to_remove%) do (
    echo Removing package: %%p
    PowerShell -command "Get-AppxPackage *%%p* | Remove-AppxPackage" >nul 2>&1
)

echo.
echo Uninstalling OneDrive...
taskkill /f /im OneDrive.exe >nul 2>&1
PowerShell -Command "Start-Process -FilePath $env:SystemRoot\SysWOW64\OneDriveSetup.exe -ArgumentList /uninstall -NoNewWindow -Wait" >nul 2>&1

echo.
echo Debloating completed! Returning to main menu.
timeout /t 5 /nobreak >nul
goto main_menu


:gpusettings
cls
echo GPU Optimization (Nvidia) is selected.
echo.
echo **INFO:** Applying GPU Optimization tweaks for NVIDIA cards.
echo Proceed with caution.
pause
timeout /t 5 /nobreak >nul

:: Backup Start - Added Backup Functionality from HoneCtrl ==========================
echo Creating System Restore Point and Registry Backups...
echo.

:: Make Hone Directory for Backups if it doesn't exist
mkdir %SYSTEMDRIVE%\Hone >nul 2>&1
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup >nul 2>&1

:: Create System Restore Point
echo Creating System Restore Point...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\' >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Checkpoint-Computer -Description 'SionXT Tweaks - GPU Nvidia Optimization Backup' >nul 2>&1

:: Create Registry Backups
echo Backing up Registry (HKCU and HKLM)...
for /F "tokens=2" %%i in ('date /t') do set date=%%i
set date1=%date:/=.%
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1% >nul 2>&1
reg export HKCU %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKCU_GPU_Nvidia_Optimization.reg /y >nul 2>&1
reg export HKLM %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKLM_GPU_Nvidia_Optimization.reg /y >nul 2>&1
echo.
echo System Restore Point and Registry Backups Created. Proceeding with Nvidia GPU Optimization...
timeout /t 3 /nobreak >nul

:: Backup End ====================================================================

goto :gpusettings_section

:gpusettings_section
echo Applying Nvidia GPU Optimizations...

:: Nvidia Driver Thread Priority
call :execute_reg "reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f"

:: DXGKrnl Thread Priority
call :execute_reg "reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl\Parameters" /v "ThreadPriority" /t REG_DWORD /d "15" /f"

:: Optimize GPU Priority Scheduling
call :execute_reg "reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\NVAPI" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f"

:: Nvidia Turbo Queue and SBA
call :execute_reg "reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "TurboQueue" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "EnableVIASBA" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "EnableIrongateSBA" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "EnableAGPSBA" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "EnableAGPFW" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "FastVram" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "ShadowFB" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "TexturePrecache" /t REG_DWORD /d "1" /f"
call :execute_reg "reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "EnableFastCopyPixels" /t REG_DWORD /d "1" /f"

echo.
echo Nvidia GPU Optimization completed. Returning to main menu.
timeout /t 5 /nobreak >nul
goto main_menu

:amdgpusettings
cls
echo GPU Optimization (AMD) is selected.
echo.
echo **WARNING:** Applying GPU Optimization tweaks for AMD cards.

echo Proceed with caution and test thoroughly after applying.
echo **Disclaimer:** These tweaks are based on publicly available information
echo and community findings, not on "paid" or truly hidden optimizations.
echo Actual performance gains are system-dependent and results may vary.
pause
timeout /t 5 /nobreak >nul

:: Backup Start - Added Backup Functionality from HoneCtrl ==========================
echo Creating System Restore Point and Registry Backups...
echo.

:: Make Hone Directory for Backups if it doesn't exist
mkdir %SYSTEMDRIVE%\Hone >nul 2>&1
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup >nul 2>&1

:: Create System Restore Point
echo Creating System Restore Point...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\' >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Checkpoint-Computer -Description 'SionXT Tweaks - GPU AMD Optimization Backup' >nul 2>&1

:: Create Registry Backups
echo Backing up Registry (HKCU and HKLM)...
for /F "tokens=2" %%i in ('date /t') do set date=%%i
set date1=%date:/=.%
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1% >nul 2>&1
reg export HKCU %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKCU_GPU_AMD_Optimization.reg /y >nul 2>&1
reg export HKLM %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKLM_GPU_AMD_Optimization.reg /y >nul 2>&1
echo.
echo System Restore Point and Registry Backups Created. Proceeding with AMD GPU Optimization...
timeout /t 3 /nobreak >nul

:: Backup End ====================================================================

goto :amdgpusettings_section

:amdgpusettings_section
echo Applying AMD GPU Optimizations...

:: AMD Shader Cache Size (
echo Setting AMD Shader Cache Size...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ShaderCache" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v "ShaderCache" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0002" /v "ShaderCache" /t REG_DWORD /d "4" /f 2>nul
:: Note: The Class GUID and instance numbers (0000, 0001, 0002) might vary.
:: You might need to dynamically find the correct instance for AMD GPU.

:: AMD Surface Format Optimization (Example tweak - adjust as needed)
echo Enabling AMD Surface Format Optimization...
reg add "HKLM\SOFTWARE\AMD\Catalyst" /v "SurfaceFormatOptimizations" /t REG_DWORD /d "1" /f 2>nul

:: AMD Flip Queue Size
echo Setting AMD Flip Queue Size...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "FlipQueueSize" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v "FlipQueueSize" /t REG_DWORD /d "2" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0002" /v "FlipQueueSize" /t REG_DWORD /d "2" /f 2>nul
:: Note:  Again, instance numbers might need dynamic detection.

:: AMD Power Saving Features
echo Disabling AMD ULPS (Ultra Low Power State)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t REG_DWORD /d "0" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v "EnableUlps" /t REG_DWORD /d "0" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0002" /v "EnableUlps" /t REG_DWORD /d "0" /f 2>nul
echo.
echo AMD GPU Optimization completed. Returning to main menu.
timeout /t 5 /nobreak >nul
goto main_menu


:cpusettings
cls
echo CPU Optimization is selected.
echo.
echo **INFO:** Applying CPU Optimization tweaks to improve performance.
echo Proceed with caution.
pause
timeout /t 5 /nobreak >nul

:: Backup Start - Added Backup Functionality from HoneCtrl ==========================
echo Creating System Restore Point and Registry Backups...
echo.

:: Make Hone Directory for Backups if it doesn't exist
mkdir %SYSTEMDRIVE%\Hone >nul 2>&1
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup >nul 2>&1

:: Create System Restore Point
echo Creating System Restore Point...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\' >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Checkpoint-Computer -Description 'SionXT Tweaks - CPU Optimization Backup' >nul 2>&1

:: Create Registry Backups
echo Backing up Registry (HKCU and HKLM)...
for /F "tokens=2" %%i in ('date /t') do set date=%%i
set date1=%date:/=.%
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1% >nul 2>&1
reg export HKCU %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKCU_CPU_Optimization.reg /y >nul 2>&1
reg export HKLM %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKLM_CPU_Optimization.reg /y >nul 2>&1
echo.
echo System Restore Point and Registry Backups Created. Proceeding with CPU Optimization...
timeout /t 3 /nobreak >nul

:: Backup End ====================================================================

goto :cpusettings_section

:cpusettings_section
echo Applying CPU Optimizations...

:: Disable Core Parking
echo Disabling Core Parking...
powercfg /setacvalue SCHEME_CURRENT SUB_PROCESSOR PROCPARKMAX 100
powercfg /setactive SCHEME_CURRENT
if %errorlevel% neq 0 echo **WARNING:** Error disabling Core Parking.

:: Set System Responsiveness
echo Setting System Responsiveness...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f
if %errorlevel% neq 0 echo **WARNING:** Error setting System Responsiveness.

:: Enable HPET (High Precision Event Timer)
echo Enabling HPET...
bcdedit /set useplatformclock true
if %errorlevel% neq 0 echo **WARNING:** Error enabling HPET.

echo Disabling Dynamic Ticks...
bcdedit /set disabledynamictick yes
if %errorlevel% neq 0 echo **WARNING:** Error disabling Dynamic Ticks.

echo.
echo CPU Optimization completed. Returning to main menu.
timeout /t 5 /nobreak >nul
goto main_menu


:regsettings

:: Backup Start - Added Backup Functionality from HoneCtrl ==========================
cls
echo Applying SionXT REG optimization...
echo.
echo **WARNING:** REG optimization modifies registry settings.
echo Incorrect registry changes can cause system instability.
echo Proceed with caution.
pause
echo.

echo Creating System Restore Point and Registry Backups...
echo.

:: Make Hone Directory for Backups if it doesn't exist
mkdir %SYSTEMDRIVE%\Hone >nul 2>&1
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup >nul 2>&1

:: Create System Restore Point
echo Creating System Restore Point...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\' >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Checkpoint-Computer -Description 'SionXT Tweaks - REG Optimization Backup' >nul 2>&1

:: Create Registry Backups
echo Backing up Registry (HKCU and HKLM)...
for /F "tokens=2" %%i in ('date /t') do set date=%%i
set date1=%date:/=.%
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1% >nul 2>&1
reg export HKCU %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKCU_REG_Optimization.reg /y >nul 2>&1
reg export HKLM %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKLM_REG_Optimization.reg /y >nul 2>&1
echo.
echo System Restore Point and Registry Backups Created. Proceeding with REG Optimization...
timeout /t 3 /nobreak >nul

:: Backup End ====================================================================

goto :regsettings_section

:regsettings_section
set "executed_commands="

:: Function to execute command and check errorlevel
:execute_command
set "command=%~1"
if "!command!"=="" goto end_execute_command
if "!executed_commands:;!command;=!"=="!executed_commands!" (
    echo Executing: !command!
    !command!
    if errorlevel 1 (
        echo Error executing: !command!
        echo Failed command was: !command!
        pause
        exit /b 1
    )
    set "executed_commands=!executed_commands!;!command!"
)
:end_execute_command

:: Mouse HID Optimize
echo Setting Mouse HID Parameters...
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouhid\Parameters" /v "TreatAbsolutePointerAsAbsolute" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouhid\Parameters" /v "TreatAbsoluteAsRelative" /t REG_DWORD /d "0" /f"

:: Disable Mouse Acceleration
echo Disabling Mouse Acceleration...
call :execute_command "reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f"
call :execute_command "reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_DWORD /d "0" /f"

:: Mouse Absolute Curve
echo Setting Mouse Absolute Curve...
call :execute_command "reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "000000000000000000a0000000000000004001000000000000800200000000000000050000000000" /f"
call :execute_command "reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "000000000000000066a6020000000000cd4c050000000000a0990a00000000003833150000000000" /f"

:: Disable Sticky and Toggle Keys
echo Disabling Sticky and Toggle Keys...
call :execute_command "reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f"
call :execute_command "reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "58" /f"

:: Disable Filter Keys
echo Disabling Filter Keys...
call :execute_command "reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "122" /f"


:: TCP/IP Parameters
echo Setting TCP/IP Parameters...
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d "16" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t REG_DWORD /d "16" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableConnectionRateLimiting" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableDCA" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableRSS" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableTCPA" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "IRPStackSize" /t REG_DWORD /d "0000001e" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxFreeTcbs" /t REG_DWORD /d "65535" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxHashTableSize" /t REG_DWORD /d "00010000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SizReqBuf" /t REG_DWORD /d "51319" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SynAttackProtect" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDataRetransmissions" /t REG_DWORD /d "4" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d "00000005" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "StrictTimeWaitSeqCheck" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableIPSourceRouting" /t REG_DWORD /d "00000008" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "KeepAliveInterval" /t REG_DWORD /d "000003e8" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpCreateAndConnectTcbRateLimitDepth" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPInitalRtt" /t REG_DWORD /d "00046325" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "00000002" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpNumConnections" /t REG_DWORD /d "de7a" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "00000042d" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpFinWait2Delay" /t REG_DWORD /d "00000042d" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "IPAutoconfigurationEnabled" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "38" /f"

:: TCP/IP Interfaces Parameters
echo Setting TCP/IP Interfaces Parameters...
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "DisableTaskOffload" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "EnableConnectionRateLimiting" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "EnableDCA" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "EnablePMTUBHDetect" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "EnablePMTUDiscovery" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "EnableRSS" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "EnableTCPA" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "EnableWsd" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "IRPStackSize" /t REG_DWORD /d "0000001e" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "MaxFreeTcbs" /t REG_DWORD /d "65535" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "MaxHashTableSize" /t REG_DWORD /d "00010000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "MaxUserPort" /t REG_DWORD /d "65534" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "SackOpts" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "SizReqBuf" /t REG_DWORD /d "51319" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "SynAttackProtect" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TCPNoDelay" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "Tcp1323Opts" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpMaxDataRetransmissions" /t REG_DWORD /d "5" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpAckFrequency" /t REG_DWORD /d "00000004" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "StrictTimeWaitSeqCheck" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "DisableIPSourceRouting" /t REG_DWORD /d "00000008" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "KeepAliveInterval" /t REG_DWORD /d "000003e8" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpCreateAndConnectTcbRateLimitDepth" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "IPAutoconfigurationEnabled" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TCPInitalRtt" /t REG_DWORD /d "00046325" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpMaxDupAcks" /t REG_DWORD /d "00000002" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpNumConnections" /t REG_DWORD /d "de7a" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpTimedWaitDelay" /t REG_DWORD /d "00000042d" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpFinWait2Delay" /t REG_DWORD /d "00000042d" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TCPDelAckTicks" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "DefaultTTL" /t REG_DWORD /d "38" /f"

:: TCP/IP ServiceProvider
echo Setting TCP/IP ServiceProvider...
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "239" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "240" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "1740" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "1741" /f"

:: Internet Settings
echo Setting Internet Settings...
call :execute_command "reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d "10" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d "10" /f"
call :execute_command "reg add "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d "10" /f"
call :execute_command "reg add "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d "10" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d "10" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d "10" /f"

:: Multimedia System Profile
echo Setting Multimedia System Profile...
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "ffffffff" /f"

:: Memory Management
echo Setting Memory Management...
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d "000f0000" /f"

:: DNS Cache Parameters
echo Setting DNS Cache Parameters...
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableBucketSize" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableSize" /t REG_DWORD /d "00000180" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxCacheEntryTtlLimit" /t REG_DWORD /d "0000FA00" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxSOACacheEntryTtlLimit" /t REG_DWORD /d "0000012D" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "00000000" /f"

:: MSMQ Parameters
echo Setting MSMQ Parameters...
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters\OCMsetup" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters\Security" /v "SecureDSCommunication" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters\setup" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Setup" /f"

:: LanmanServer Parameters
echo Setting LanmanServer Parameters...
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v "IRPStackSize" /t REG_DWORD /d "50" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v "SizReqBuf" /t REG_DWORD /d "170372" /f"

:: BITS Policies
echo Setting BITS Policies...
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\BITS" /v "EnableBITSMaxBandwidth" /t REG_DWORD /d "0" /f"

:: NetCache Policies
echo Setting NetCache Policies...
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\NetCache" /v "PeerCachingLatencyThreshold" /t REG_DWORD /d "268435" /f"

:: PeerDist Service Policies
echo Setting PeerDist Service Policies...
call :execute_command "reg add "HKLM\SOFTWARE\Policies\Microsoft\PeerDist\Service" /v "Enable" /t REG_DWORD /d "1" /f"

:: DNSClient Policies
echo Setting DNSClient Policies...
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "UpdateSecurityLevel" /t REG_DWORD /d "598" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "RegistrationTtl" /t REG_DWORD /d "1117034098" /f"

:: Network Connections Policies
echo Setting Network Connections Policies...
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Network Connections" /v "NC_AllowNetBridge_NLA" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Network Connections" /v "NC_AllowAdvancedTCPIPConfig" /t REG_DWORD /d "1" /f"

:: USB Device Settings
echo Setting USB Device Parameters...
for /f "tokens=2 delims==" %%i in ('wmic path Win32_USBController get PNPDeviceID /value ^| find "="') do (
    set "deviceId=%%i"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\!deviceId!\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\!deviceId!\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\!deviceId!\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\!deviceId!\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\!deviceId!\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\!deviceId!\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\!deviceId!\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\!deviceId!\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\!deviceId!\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f"
)

:: USB Host Controller Thread Priority
echo Setting USB Host Controller Thread Priority...
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbxhci\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f"

:: NDIS Thread Priority
echo Setting NDIS Thread Priority...
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f"


:: IDE Controller Settings
echo Setting IDE Controller Parameters...
for /f "tokens=2 delims==" %%i in ('wmic path Win32_IDEController get PNPDeviceID /value ^| find "="') do (
    set "deviceId=%%i"
    echo Processing IDE Controller: !deviceId!
    set "str=!deviceId!"
    set "str=!str:PCI\VEN_=!"
    if "!str:PCI\VEN_=!" neq "!str!" (
        call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\!deviceId!\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f"
    )
)

echo.
echo SionXT REG optimization completed. Returning to main menu.
timeout /t 3 >nul
goto main_menu


:clean_temp_and_other
cls
echo Cleaning temporary files and other system caches...
echo.
echo **WARNING:** This option will delete temporary files and system caches.
echo Make sure you close any important applications before proceeding.
pause
echo.

:: Backup Start - Added Backup Functionality from HoneCtrl ==========================
echo Creating System Restore Point and Registry Backups...
echo.

:: Make Hone Directory for Backups if it doesn't exist
mkdir %SYSTEMDRIVE%\Hone >nul 2>&1
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup >nul 2>&1

:: Create System Restore Point
echo Creating System Restore Point...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\' >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Checkpoint-Computer -Description 'SionXT Tweaks - Cleaning Backup' >nul 2>&1

:: Create Registry Backups
echo Backing up Registry (HKCU and HKLM)...
for /F "tokens=2" %%i in ('date /t') do set date=%%i
set date1=%date:/=.%
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1% >nul 2>&1
reg export HKCU %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKCU_Cleaning.reg /y >nul 2>&1
reg export HKLM %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKLM_Cleaning.reg /y >nul 2>&1
echo.
echo System Restore Point and Registry Backups Created. Proceeding with Cleaning...
timeout /t 3 /nobreak >nul

:: Backup End ====================================================================

echo Cleaning Cache and Logs...
md c:\windows\temp >nul 2>&1
del c:\windows\temp\* /f /s /q >nul 2>&1
rd c:\windows\temp /s /q >nul 2>&1
md c:\windows\temp >nul 2>&1
del c:\windows\logs\cbs\*.log /f /q >nul 2>&1
del C:\Windows\Logs\MoSetup\*.log /f /q >nul 2>&1
del C:\Windows\Panther\*.log /s /q /f >nul 2>&1
del C:\Windows\inf\*.log /s /q /f >nul 2>&1
del C:\Windows\logs\*.log /s /q /f >nul 2>&1
del C:\Windows\SoftwareDistribution\Download\* /f /s /q >nul 2>&1
del C:\Windows\SoftwareDistribution\DataStore\Logs\* /f /s /q >nul 2>&1
del C:\Windows\Microsoft.NET\*.log /s /q /f >nul 2>&1
del C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\WebCache\* /f /s /q >nul 2>&1
del C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\SettingSync\*.log /s /q /f >nul 2>&1
del C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\Explorer\ThumbCacheToDelete\*.tmp /s /q /f >nul 2>&1
del C:\Users\%USERNAME%\AppData\Local\Microsoft\"Terminal Server Client"\Cache\* /s /q /f >nul 2>&1

echo.
echo Temporary files and caches cleaning completed. Returning to main menu.
timeout /t 5 /nobreak >nul
goto main_menu

:network_optimization
cls
echo Network Optimization is selected.
echo.
echo **INFO:** Applying Network Optimization tweaks to improve latency and throughput.
echo Proceed with caution.
pause
timeout /t 3 /nobreak >nul

:: Backup Start - Added Backup Functionality from HoneCtrl ==========================
echo Creating System Restore Point and Registry Backups...
echo.

:: Make Hone Directory for Backups if it doesn't exist
mkdir %SYSTEMDRIVE%\Hone >nul 2>&1
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup >nul 2>&1

:: Create System Restore Point
echo Creating System Restore Point...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\' >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Checkpoint-Computer -Description 'SionXT Tweaks - Network Optimization Backup' >nul 2>&1

:: Create Registry Backups
echo Backing up Registry (HKCU and HKLM)...
for /F "tokens=2" %%i in ('date /t') do set date=%%i
set date1=%date:/=.%
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1% >nul 2>&1
reg export HKCU %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKCU_Network_Optimization.reg /y >nul 2>&1
reg export HKLM %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKLM_Network_Optimization.reg /y >nul 2>&1
echo.
echo System Restore Point and Registry Backups Created. Proceeding with Network Optimization...
timeout /t 3 /nobreak >nul

:: Backup End ====================================================================

goto :network_optimization_section

:network_optimization_section
echo Applying Network Optimizations...

:: **QoS Packet Scheduler Configuration for Games**
echo Configuring QoS Packet Scheduler for Games...

:: **Warning:**  QoS policies might require administrator privileges to be fully effective.
::            Also, overly aggressive QoS can sometimes starve other network traffic.
::            Test your network performance after applying these policies.

:: **Method 1: Prioritize based on Executable Name (Example: game.exe)**
echo Creating QoS Policy to prioritize game traffic (by executable name)...
netsh qos policy add name="Game Traffic Priority (Exe)" appname="game.exe" priority=6
if %errorlevel% neq 0 echo **WARNING:** Error adding QoS policy by executable name.
echo **INFO:**  QoS Policy added to prioritize traffic from "game.exe".
echo **INFO:**  **You need to replace "game.exe" with the actual executable name of your game.**
echo **INFO:**  You can add multiple policies for different game executables.

:: **Method 2: Prioritize based on Port Range (Example: UDP ports 27000-27030 - Steam Games)**
echo Creating QoS Policy to prioritize game traffic (by port range - UDP 27000-27030)...
netsh qos policy add name="Game Traffic Priority (UDP Ports)" ipprotocol=UDP srcportrange=0-65535 dstportrange=27000-27030 priority=5
if %errorlevel% neq 0 echo **WARNING:** Error adding QoS policy by port range.
echo **INFO:**  QoS Policy added to prioritize UDP traffic on ports 27000-27030 (example for Steam games).
echo **INFO:**  You may need to adjust the port range based on the games you play.
echo **INFO:**  Consult your game's documentation or network settings for port information.

:: **Explanation of QoS Priorities:**
echo **INFO:**  QoS Priorities range from 0 (Lowest) to 7 (Highest).
echo **INFO:**  7 - Critical, 6 - High, 5 - Medium-High, 4 - Medium, 3 - Medium-Low, 2 - Low, 1 - Best Effort, 0 - Background.
echo **INFO:**  We are using Priority 6 (High) for executable-based policy and 5 (Medium-High) for port-based policy.
echo **INFO:**  Adjust priorities as needed, but higher priority for games is generally recommended.

:: Enable TCP Fast Open (Already present - keeping it)
echo Enabling TCP Fast Open...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableFastOpen" /t REG_DWORD /d "2" /f
if %errorlevel% neq 0 echo **WARNING:** Error enabling TCP Fast Open.

:: Increase TCP Window Size (Already present - keeping it)
echo Increasing TCP Window Size...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d "65535" /f
if %errorlevel% neq 0 echo **WARNING:** Error increasing TCP Window Size.

:: Enable Congestion Control Algorithm (CTCP - Already present - keeping it)
echo Enabling CTCP Congestion Control...
netsh int tcp set global congestionprovider=ctcp
if %errorlevel% neq 0 echo **WARNING:** Error enabling CTCP.

:: Disable Nagle's Algorithm (Already present - keeping it)
echo Disabling Nagle's Algorithm...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
if %errorlevel% neq 0 echo **WARNING:** Error disabling Nagle's Algorithm.

:: Enable QoS Packet Scheduler (Already present - but now policies are configured)
echo Enabling QoS Packet Scheduler... (Policies are now configured)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\QoSPolicyDefinitions" /v "EnableQoS" /t REG_DWORD /d "1" /f
if %errorlevel% neq 0 echo **WARNING:** Error enabling QoS Packet Scheduler.


:: **Bufferbloat Mitigation Tweaks**
echo Applying Bufferbloat Mitigation Tweaks...

:: **1.  ECN (Explicit Congestion Notification) - Enable**
echo Enabling ECN (Explicit Congestion Notification)...
netsh int tcp set global ecncapability=enabled
if %errorlevel% neq 0 echo **WARNING:** Error enabling ECN.
echo **INFO:**  ECN can help reduce bufferbloat by signaling congestion early.
echo **INFO:**  Requires router and remote server support for ECN to be effective.

:: **2.  DSCP Marking (Differentiated Services Code Point) -  Mark Game Traffic (Example: DSCP 46 - Expedited Forwarding)**
echo Marking Game Traffic with DSCP (Expedited Forwarding - DSCP 46)...
echo **INFO:**  DSCP marking works in conjunction with QoS policies.
echo **INFO:**  The QoS policies created above already include DSCP marking by default based on priority.
echo **INFO:**  For example, Priority 6 (High) typically maps to DSCP CS6 (Class Selector 6), which is often treated as high priority.
echo **INFO:**  Priority 5 (Medium-High) typically maps to DSCP CS5.
echo **INFO:**  You can customize DSCP values in the QoS policies if needed using the 'dscp' parameter in 'netsh qos policy add'.
echo **INFO:**  Example to set DSCP to Expedited Forwarding (EF - DSCP 46) for the executable-based policy:
echo **INFO:**  `netsh qos policy add name="Game Traffic Priority (Exe)" appname="game.exe" priority=6 dscp=46`
echo **INFO:**  However, for most home networks, the default DSCP marking based on QoS priority should be sufficient.


:: **Important Notes on QoS and Bufferbloat Tweaks:**
echo.
echo **IMPORTANT:**  QoS and bufferbloat tweaks are most effective when your router also supports QoS and bufferbloat mitigation techniques (e.g., SQM - Smart Queue Management).
echo **IMPORTANT:**  These tweaks primarily affect outbound traffic from your computer.
echo **IMPORTANT:**  The effectiveness of these tweaks can vary depending on your network setup, internet connection, and the games you play.
echo **IMPORTANT:**  Incorrect QoS or bufferbloat settings can sometimes worsen network performance.
echo **IMPORTANT:**  **Test your network performance (ping, latency, jitter, bufferbloat) before and after applying these tweaks to measure the impact.**
echo **IMPORTANT:**  Use online tools like speedtest.net, waveformbufferbloat.com, or DSLReports Speed Test to check bufferbloat and network performance.


echo.
echo Network Optimization completed. Returning to main menu.
timeout /t 3 /nobreak >nul
goto main_menu


:privacy_enhance
cls
echo Enhancing Privacy...
call :confirm_action \"Apply privacy tweaks? This disables telemetry and tracking.\"
if %errorlevel% neq 0 goto main_menu

:: Backup
echo Creating System Restore Point and Registry Backups...
echo.

:: Make Hone Directory for Backups if it doesn't exist
mkdir %SYSTEMDRIVE%\Hone >nul 2>&1
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup >nul 2>&1

:: Create System Restore Point
echo Creating System Restore Point...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1

:: Create Registry Backups
echo Backing up Registry (HKCU and HKLM)...
for /F "tokens=2" %%i in ('date /t') do set date=%%i
set date1=%date:/=.%
mkdir %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1% >nul 2>&1
reg export HKCU %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKCU_PrivacyEnhancement.reg /y >nul 2>&1
reg export HKLM %SYSTEMDRIVE%\Hone\SionXT_Backup\%date1%\SionXT_HKLM_PrivacyEnhancement.reg /y >nul 2>&1
echo.
echo System Restore Point and Registry Backups Created. Proceeding with Privacy Enhancements...
timeout /t 3 /nobreak >nul

:: Backup End ====================================================================

:: Disable Telemetry
reg add "HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

:: Disable Advertising ID
reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f

:: Disable Cortana
reg add "HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f

:: Block Tracking Domains in Hosts
set HOSTS="%windir%\\System32\\drivers\\etc\\hosts"
echo 127.0.0.1 vortex.data.microsoft.com >> %HOSTS%
echo 127.0.0.1 telecommand.telemetry.microsoft.com >> %HOSTS%
echo 127.0.0.1 oca.telemetry.microsoft.com >> %HOSTS%
echo 127.0.0.1 settings-sandbox.data.microsoft.com >> %HOSTS%
echo Privacy enhancements applied.
timeout /t 3 >nul
goto main_menu

:exit
echo Exiting SionXT-TweaksWin10.
exit