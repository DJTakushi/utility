# utility
utility scripts


### installWin.bat
Run this in commandPrompt/PowerShell to install software.

# Bootloader issues
Drive can become unbootable after installing on a CMS / Safe Boot machine (as required by Windows11)
This can be remedied with the instructions in the post (https://askubuntu.com/questions/1260263/installed-ubuntu-alongside-windows-10-and-now-windows-doesnt-boot)
```
I always get the same problem when I install Ubuntu to my nvme ssd hard drive alongside Windows 10.

I think the problem is related to uefi or mbr or efi or legacy which I know nothing about

But after searching for hours I always fix this problem with this method:

NOTE: this method not the easiest or the best, but at least it works

Burn Windows to USB

Plug the USB into your computer

Start the computer and press Esc (or whatever key you use to access the boot menu)

Select the USB in the boot menu

Choose language and press next

Select Repair your computer

Select Advanced

Select Command prompt

Enter the following commands:

bootrec /fixmb
bootrec /fixboot
Note: it's ok if the above step returned access denied or something like that

bootrec /rebuildbcd
bcdboot c:\windows /s c:
Then reboot and repeat the steps from number 3 to 7

Now instead of opening the command prompt choose Fix startup problems

After that you are done.
```
