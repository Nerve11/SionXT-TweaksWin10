@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title SionXT-TweaksWin10

:: UAC
>nul 2>&1 reg query "HKU\S-1-5-19" || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
)

mode con: cols=80 lines=25

:main_menu
cls
echo.
echo    ========================================
echo             SionXT-TweaksWin10
echo    ========================================
echo.
echo    [1] Service optimization
echo    [2] Debloat
echo    [3] GPU Optimization(for Nvidia users only. AMD users sorry. use after installing the driver!!)
echo    [4] CPU Optimization
echo    [5] SionXT REG optimization
echo    [6] Cleaning after optimization
echo    [0] EXIT
echo.
set /p choice="Select an option: "

if "%choice%"=="1" goto optimize_service
if "%choice%"=="2" goto debloat
if "%choice%"=="3" goto gpusettings
if "%choice%"=="4" goto cpusettings
if "%choice%"=="5" goto regsettings
if "%choice%"=="6" goto clean_temp_and_other
if "%choice%"=="0" exit

echo Wrong selection. Please select again.
timeout /t 2 /nobreak >nul
goto main_menu


:optimize_service
cls
echo Optimization of Windows 10 services is underway. Do not touch anything. thx

echo.
echo System File Check (SFC) starting...
echo Estimated time: 10-20 minutes
echo.
echo Progress:
echo [                    ] 0%%
sfc /scannow | find "%%"
echo.
echo SFC scan complete.
echo.
timeout /t 3 /nobreak >nul

echo Running DISM System Health Check...
echo Estimated time: 15-30 minutes depending on internet speed
echo.
echo Progress:
DISM /Online /Cleanup-Image /RestoreHealth /Source:WIM:D:\Sources\install.wim:1 /LimitAccess

echo.
echo System checks completed.
echo.
timeout /t 3 /nobreak >nul

echo Applying service optimization....
echo.

:: Disable Bluetooth Drivers and Services
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BluetoothUserService" /v "Start" /t REG_DWORD /d "4" /f
if %errorlevel% neq 0 (
    echo Error disabling BluetoothUserService.
    pause
    goto main_menu
    goto startweaks
)
pause
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Microsoft_Bluetooth_AvrcpTransport" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\HidBth" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BTHUSB" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BTHPORT" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthPan" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthMini" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthLEEnum" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthHFEnum" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthEnum" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthA2dp" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RFCOMM" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BTAGService" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthAvctpSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\bthserv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
:: Disable Defender Drivers and Services
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpsdrv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wanarp" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f 2>nul
:: Disable Printer Services
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Spooler" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PrintNotify" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
:: Disable Troubleshooting
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TroubleshootingSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
:: Disable Windows Updates
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DoSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "1" /f 2>nul
:: Disable Xbox services
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XblGameSave" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\xboxgip" /v "Start" /t REG_DWORD /d "4" /f 2>nul
:: Disable Copy
reg add "HKLM\SYSTEM\CurrentControlSet\Services\cbdhsvc" /v "Start" /t REG_DWORD /d "4" /f 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\EFS" /v "Start" /t REG_DWORD /d "4" /f 2>nul
:: Disable Other Services and Drivers
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
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "Start" /t REG_DWORD /d "2" /f 2>nul
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
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableOnAccessProtection" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableEmailScanning" /t REG_DWORD /d 1 /f
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
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\diagsvc" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Telemetry" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\sedsvc" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\MapsBroker" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\WarpJITSvc" /f 2>nul
:: Disable Push Notifications
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f 2>nul

echo Windows 10 services optimization is running out. Soon you'll be back in the menu
timeout /t 5 /nobreak >nul
goto main_menu
goto startweaks


@echo off
:debloat
cls
set "load="
set "loadnum=0"
set "progress=0"

:Loading
if %progress%==10 goto EndDebloat
if %loadnum%==105 goto EndDebloat
set "load=%load%█"
cls
echo Debloating Windows...
echo ------------------------------------
echo Progress: %load% %loadnum%%%
echo ------------------------------------
ping localhost -n 2 >nul
set /a loadnum=%loadnum% + 10
set /a progress=%progress% + 1
goto Loading

:0
PowerShell -command "Get-AppxPackage *Microsoft.BingWeather* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.Getstarted* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.Messaging* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage" >nul 2>&1
:1
PowerShell -command "Get-AppxPackage *Microsoft.MixedReality.Portal* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.OneConnect* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.People* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.Print3D* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.SkypeApp* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.WindowsAlarms* | Remove-AppxPackage" >nul 2>&1
:2
PowerShell -command "Get-AppxPackage *Microsoft.WindowsCamera* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *microsoft.windowscommunicationsapps* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.WindowsSoundRecorder* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.YourPhone* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.ZuneMusic* | Remove-AppxPackage" >nul 2>&1
:3
PowerShell -command "Get-AppxPackage *Microsoft.HEIFImageExtension* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.WebMediaExtensions* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.WebpImageExtension* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Microsoft.3dBuilder* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage -allusers *bing* | Remove-AppxPackage" >nul 2>&1
:4
PowerShell -command "Get-AppxPackage -allusers *bingfinance* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage -allusers *bingsports* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage -allusers *CommsPhone* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage -allusers *Drawboard PDF* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage -allusers *Sway* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage -allusers *WindowsAlarms* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage -allusers *WindowsPhone* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage -allusers *zune* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "ps onedrive | Stop-Process -Force" >nul 2>&1
:5
PowerShell -Command "Start-Process -FilePath $env:SystemRoot\SysWOW64\OneDriveSetup.exe -ArgumentList /uninstall -NoNewWindow -Wait" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.ZuneVideo | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.GetHelp | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.Messaging | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.People | Remove-AppxPackage" >nul 2>&1
:6
PowerShell -command "Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.Print3D | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage EclipseManager | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage ActiproSoftwareLLC | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage AdobeSystemsIncorporated.AdobePhotoshopExpress | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage 'D5EA27B7.Duolingo-LearnLanguagesforFree' | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage PandoraMediaInc | Remove-AppxPackage" >nul 2>&1
:7
PowerShell -command "Get-AppxPackage CandyCrush | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Wunderlist* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Flipboard* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Twitter* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Facebook* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage *Sway* | Remove-AppxPackage" >nul 2>&1
:8
PowerShell -command "Get-AppxPackage *disney* | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.BingTravel | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.BingHealthAndFitness | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.BingSports | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.BingFoodAndDrink | Remove-AppxPackage" >nul 2>&1
:9
PowerShell -command "Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.BingFinance | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage Microsoft.BioEnrollment | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage ContentDeliveryManager | Remove-AppxPackage" >nul 2>&1
PowerShell -command "Get-AppxPackage 'Microsoft.Advertising.Xaml' | Remove-AppxPackage" >nul 2>&1

:EndDebloat
echo Debloating completed!
timeout /t 5 /nobreak >nul
cls
echo [92mDebloating completed![0m
timeout /t 3 >nul
goto main_menu



:gpusettings 
cls
echo Выполняется отключение ненужных служб...
:: Здесь можно добавить команды для отключения служб
timeout /t 5 /nobreak >nul
goto main_menu
goto startweaks

:cpusettings
cls
echo Выполняется установка обновлений...
:: Здесь можно добавить команды для установки обновлений
timeout /t 5 /nobreak >nul
goto main_menu
goto startweaks


:regsettings
cls
echo Applying REG settings...

@echo off
setlocal enabledelayedexpansion

:: Проверка на повторное выполнение команд
set "executed_commands="

:: Функция для выполнения команды и проверки errorlevel
:execute_command
set "command=%~1"
if "!command!"=="" goto end_execute_command
if "!executed_commands:;!command;=!"=="!executed_commands!" (
    echo Executing: !command!
    !command!
    if errorlevel 1 (
        echo Error executing: !command!
        exit /b 1
    )
    set "executed_commands=!executed_commands!;!command!"
)
goto end_execute_command

:end_execute_command
exit /b 0

:: Выполнение команд
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
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "239" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "240" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "1740" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "1741" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d "10" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d "10" /f"
call :execute_command "reg add "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d "10" /f"
call :execute_command "reg add "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d "10" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d "10" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d "10" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "ffffffff" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d "000f0000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableBucketSize" /t REG_DWORD /d "00000001" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableSize" /t REG_DWORD /d "00000180" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxCacheEntryTtlLimit" /t REG_DWORD /d "0000FA00" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxSOACacheEntryTtlLimit" /t REG_DWORD /d "0000012D" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters\OCMsetup" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters\Security" /v "SecureDSCommunication" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters\setup" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Setup" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "IRPStackSize" /t REG_DWORD /d "80" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SizReqBuf" /t REG_DWORD /d "170372" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "HiberbootEnabled" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "MaxOutstandingSends" /t REG_DWORD /d "1073741824" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "4294967295" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\DiffservByteMappingConforming" /v "ServiceTypeBestEffort" /t REG_DWORD /d "99" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\DiffservByteMappingConforming" /v "ServiceTypeControlledLoad" /t REG_DWORD /d "99" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\DiffservByteMappingConforming" /v "ServiceTypeGuaranteed" /t REG_DWORD /d "99" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\DiffservByteMappingConforming" /v "ServiceTypeNetworkControl" /t REG_DWORD /d "99" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\DiffservByteMappingConforming" /v "ServiceTypeQualitative" /t REG_DWORD /d "99" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\DiffservByteMappingNonConforming" /v "ServiceTypeBestEffort" /t REG_DWORD /d "99" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\DiffservByteMappingNonConforming" /v "ServiceTypeControlledLoad" /t REG_DWORD /d "99" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\DiffservByteMappingNonConforming" /v "ServiceTypeGuaranteed" /t REG_DWORD /d "99" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\DiffservByteMappingNonConforming" /v "ServiceTypeNetworkControl" /t REG_DWORD /d "99" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\DiffservByteMappingNonConforming" /v "ServiceTypeQualitative" /t REG_DWORD /d "99" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\UserPriorityMapping" /v "ServiceTypeNonConforming" /t REG_DWORD /d "7" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\UserPriorityMapping" /v "ServiceTypeBestEffort" /t REG_DWORD /d "7" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\UserPriorityMapping" /v "ServiceTypeControlledLoad" /t REG_DWORD /d "7" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\UserPriorityMapping" /v "ServiceTypeGuaranteed" /t REG_DWORD /d "7" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\UserPriorityMapping" /v "ServiceTypeNetworkControl" /t REG_DWORD /d "7" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Psched\UserPriorityMapping" /v "ServiceTypeQualitative" /t REG_DWORD /d "7" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v "IRPStackSize" /t REG_DWORD /d "50" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v "SizReqBuf" /t REG_DWORD /d "170372" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\BITS" /v "EnableBITSMaxBandwidth" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\NetCache" /v "PeerCachingLatencyThreshold" /t REG_DWORD /d "268435
call :execute_command "reg add "HKLM\SOFTWARE\Policies\Microsoft\PeerDist\Service" /v "Enable" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "UpdateSecurityLevel" /t REG_DWORD /d "598" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "RegistrationTtl" /t REG_DWORD /d "1117034098" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Network Connections" /v "NC_AllowNetBridge_NLA" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKLM\Software\Policies\Microsoft\Windows\Network Connections" /v "NC_AllowAdvancedTCPIPConfig" /t REG_DWORD /d "1" /f"

:: Настройка USB устройств
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID') do (
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f"
    call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f"
)

call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbxhci\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl\Parameters" /v "ThreadPriority" /t REG_DWORD /d "15" /f"

:: Настройка IDE контроллеров
for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID 2^>nul') do (
    if "!str:PCI\VEN_=!" neq "!str!" (
        call :execute_command "reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f"
    )
)

:: Очистка кэша и логов
echo Cleaning Cache and Logs...
md c:\windows\temp >nul 2>&1
del c:\windows\logs\cbs\*.log >nul 2>&1
del C:\Windows\Logs\MoSetup\*.log >nul 2>&1
del C:\Windows\Panther\*.log /s /q >nul 2>&1
del C:\Windows\inf\*.log /s /q >nul 2>&1
del C:\Windows\logs\*.log /s /q >nul 2>&1
del C:\Windows\SoftwareDistribution\*.log /s /q >nul 2>&1
del C:\Windows\Microsoft.NET\*.log /s /q >nul 2>&1
del C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\WebCache\*.log /s /q >nul 2>&1
del C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\SettingSync\*.log /s /q >nul 2>&1
del C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\Explorer\ThumbCacheToDelete\*.tmp /s /q >nul 2>&1
del C:\Users\%USERNAME%\AppData\Local\Microsoft\"Terminal Server Client"\Cache\*.bin /s /q >nul 2>&1

:: Применение реестра
echo Applying Regedits...
call :execute_command "reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "8" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v "value" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d 2 /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "UseActionCenterExperience" /t REG_DWORD /d "00000000" /f"
call :execute_command "reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d 0 /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableBucketSize" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableSize" /t REG_DWORD /d "180" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxCacheEntryTtlLimit" /t REG_DWORD /d "fa00" /f"
call :execute_command "reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxSOACacheEntryTtlLimit" /t REG_DWORD /d "12d" /f"
call :execute_command "reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f"
call :execute_command "reg delete "HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f"
call :execute_command "reg delete "HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f"
call :execute_command "reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "2000" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_SZ /d "1000" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility" /v "Sound on Activation" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility" /v "Warning Sounds" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility" /v "StickyKeys" /t REG_SZ /d "506" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "2" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "34" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v "DelayBeforeAcceptance" /t REG_SZ /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatRate" /t REG_SZ /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay" /t REG_SZ /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "2" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\HighContrast" /v "Flags" /t REG_SZ /d "4218" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_SZ /d "130" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\MouseKeys" /v "MaximumSpeed" /t REG_SZ /d "39" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\MouseKeys" /v "TimeToMaximumSpeed" /t REG_SZ /d "3000" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\SoundSentry" /v "Flags" /t REG_SZ /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\SoundSentry" /v "FSTextEffect" /t REG_SZ /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\SoundSentry" /v "TextEffect" /t REG_SZ /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\SoundSentry" /v "WindowsEffect" /t REG_SZ /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\SlateLaunch" /v "ATapp" /t REG_SZ /d """" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\SlateLaunch" /v "LaunchAT" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Superfetch/Main" /v "Enabled" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Superfetch/PfApLog" /v "Enabled" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Superfetch/StoreLog" /v "Enabled" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f"
call :execute_command "reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f"
call :execute_command "reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tiff" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpg" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".png" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpeg" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".bmp" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpe" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jfif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".dib" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".ico" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".gif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tga" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotification" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f"
call :execute_command "reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WSearch" /v Start /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WMPNetworkSvc" /v Start /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wisvc" /v Start /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WpnService" /v Start /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WbioSrvc" /v Start /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CmService" /v Start /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\icssvc" /v Start /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\netprofm" /v Start /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinRM" /v Start /t REG_DWORD /d 4 /f

timeout /t 3 >nul
goto main_menu


:clean_temp_and_other
cls
echo Cleaning temporary files...
timeout /t 5 /nobreak >nul
goto main_menu
goto startweaks
