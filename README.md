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
cd chef && knife solo bootstrap root@192.168.33.10 development.json
```

and then, to run the server, just type

```
vagrant ssh
cd /vagrant
bundle exec unicorn_rails -c config/unicorn.rb
```

Optional: add the option -D to daemonize the process
