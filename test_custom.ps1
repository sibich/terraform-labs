new-item D:\soft -ItemType directory -Force
Invoke-WebRequest -Uri https://notepad-plus-plus.org/repository/7.x/7.7.1/npp.7.7.1.Installer.x64.exe -OutFile D:\soft\note.exe
Install-Module -Name Az -Force
#Start-Process 'D:\soft\note.exe' "/S"