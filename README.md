# CMS-installer step-by-step

Install [CMS](https://github.com/cms-dev/cms) quickly and easy.

## Installation some package 

1. Install Ubuntu 18.04 LTS

2. Update your system
```
sudo apt update
sudo apt upgrade
```

3. Clone your source code
```
sudo apt install -y git
git clone https://github.com/Greenhat1998/cms-installer.git
cd cms-installer
```

## Installation CMS with virtual environment

```
chmod a+x install.sh
./install install
```
Now CMS is installed.

## Running CMS

1. Initialize virtual environment and register account with administrator role

```
source /usr/local/lib/cms/bin/activate
cmsInitDB
cmsAddAdmin -p 12345678 admin
cmsAdminWebServer
```

2. Start CMS system 

Open some terminal tab:
```
source /usr/local/lib/cms/bin/activate
cmsLogService               #in terminal 1
cmsRankingWebServer         #in terminal 2
cmsResourceService -a       #in terminal 3
```

3. Access CMS

Manager system: [localhost:8889](http://localhost:8889)

View ranking:   [localhost:8890](http://localhost:8890)

Login system:   [localhost:8888](http://localhost:8888)
