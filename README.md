# How to bootstrap the Vagrant machine

```
vagrant up

vagrant ssh
```

change the root user password to "vagrant"

```
sudo su

passwd
```

go back in the host machine and bootstrap Chef with

```
knife solo bootstrap root@192.168.33.10 development.json
```