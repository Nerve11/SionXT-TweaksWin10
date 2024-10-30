If you are reading this with Nvidia drivers already installed, you have two choices
A) Uninstall the drivers via DDU https://www.guru3d.com/download/display-driver-uninstaller-download/. 
B) Reinstall Windows via a flash drive with the Custom OS on it. Example of good custom ISOs: 
  I  ReviOS ( ReviOS 10 - 22.12 Clean https://pixeldrain.com/u/9U5iNqoZ 
  II ReviOS 10 - 22.12 Upgrade https://pixeldrain.com/u/p2xBTr1s 
You can check these iso's via https://github.com/StasiumDev/ReviOS-Verifier ) 
 III Xos win10 v8 ( Download: https: //drive.google.com/drive/folders/1sqy8ZDCbh8Uqc-PDHQYm0G17zimp7Ig2 SHA1: 13ffb937cbf4202e1ec62ec3a0c2beaa3d4ec1da , by https://github.com/imribiy )

General. 
   When you don't have a driver for your video card, you go to https://www.nvidia.com/en-us/drivers/ and download the driver for your video card model. 
Download NVCleanstall v1.16.0 - https://www.techpowerup.com/download/techpowerup-nvcleanstall/. 
Open as administrator and select “Use driver files on disk” (here you will find the downloaded driver). 
Select Components To Install :
Select “PhysX”
Installation Tweaks
Select “Disable Installer Telemetry”. , “Perform a Clean Installation”. Check Show Expert Tweaks. Here you select “Disable Driver Telemetry”,“ Disable Nvidia HD Audio device sleep timer”, “Disable HDCP”. 
At the very bottom, check “Use method compatible with Easy-Anti-Cheat” and “Automatically accept the ‘driver unsigned’ warning”.

Then install as usual
