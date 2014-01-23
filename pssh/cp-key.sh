pssh -t 10 -h os.ip.log -l root -A -i mkdir /root/.ssh
pscp -t 10 -h os.ip.log -l root -A /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
