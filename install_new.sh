cd "$(dirname "$0")"
LINK="https://github.com/cms-dev/cms/releases/download/v1.3.2/v1.3.2.tar.gz"
ARCHIVE="v1.3.2.tar.gz"
WARNING="Run ./install.sh patch if you are using Ubuntu 18.04 or higher"
case "$1" in
    apt)
        sudo apt install build-essential openjdk-8-jre openjdk-8-jdk \
        fpc postgresql postgresql-client gettext python2.7 \
        iso-codes shared-mime-info stl-manual cgroup-lite libcap-dev \
        python-dev libpq-dev libcups2-dev libyaml-dev \
        libffi-dev python-pip virtualenv
    ;;
    aptoptional)
        sudo apt-get install nginx-full php7.0-cli php7.0-fpm \
        phppgadmin texlive-latex-base a2ps gcj-jdk haskell-platform
    ;;
    wget)
        (
            test -f "$ARCHIVE" &&
            echo "$ARCHIVE has been downloaded already" ||
            wget -O "$ARCHIVE" "$LINK"
        ) &&
        tar xf "$ARCHIVE"
    ;;    
    prerequisites)
        (
            cd cms/ &&
            yes | sudo ./prerequisites.py install &&
            (
                groups | grep cmsuser ||
                echo "Please logout and login again"
            )
        )
    ;;   
    virtualenv)
        (
            sudo apt install virtualenv
            sudo mkdir /usr/local/lib/cms/
            sudo chown `whoami`:`whoami` /usr/local/lib/cms/
            virtualenv -p python2 /usr/local/lib/cms/
        )
    ;;
    patch)
        sed -i -e 's/bcrypt==2.0/bcrypt==3.1/g' cms/requirements.txt
    ;;
    setup)
        (
            cd cms/ &&
            source /usr/local/lib/cms/bin/activate &&
            pip install -r requirements.txt &&
            python setup.py install &&
            deactivate
        )
    ;;
    postgres)
        (
            sudo su --login postgres -c "createuser --username=postgres --pwprompt cmsuser" <<< $'your_password_here\nyour_password_here'
            sudo su --login postgres -c "createdb --username=postgres --owner=cmsuser cmsdb"
            sudo su --login postgres -c "psql --username=postgres --dbname=cmsdb --command='ALTER SCHEMA public OWNER TO cmsuser'"
            sudo su --login postgres -c "psql --username=postgres --dbname=cmsdb --command='GRANT SELECT ON pg_largeobject TO cmsuser'"
        )
    ;;
    install)
        ./install.sh apt &&
        ./install.sh wget &&
        (
            lsb_release -a | grep "18.04" &&
            ./install.sh patch ||
            echo "$WARNING"
        ) &&
        ./install.sh prerequisites &&
        ./install.sh virtualenv &&
        ./install.sh setup &&
        ./install.sh postgres &&
        (
            groups | grep cmsuser ||
            echo "Please logout and login again"
        )
        echo "Installed successfully"
    ;;
    *)
    ;;
esac
© 2019 GitHub, Inc.
