'HideBat.vbs

CreateObject("Wscript.Shell").Run "wsl -d Ubuntu -- export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0; PATH=/home/jackson/.nix-profile/bin:$PATH /home/jackson/.nix-profile/bin/emacs", 0, True