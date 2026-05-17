##mysql 8.0  install or uninstall  or restall....

MYSQL_DIR=/usr/local/mysql
MYSQL_OPTION=$1
MYSQL_PKGNAME=mysql-8.0.31-linux-glibc2.12-x86_64.tar.xz

if [ "${MYSQL_OPTION}" == "install" ];then
	if [ -d "$MYSQL_DIR" ];then
		printf "$MYSQL_DIR is exist and don't install\n"
		exit 1
	else 
		wget https://dev.mysql.com/get/Downloads/MySQL-8.0/${MYSQL_PKGNAME}
		tar -xvf ${MYSQL_PKGNAME}
		mv mysql-8.0.31-linux-glibc2.12-x86_64 /usr/local/mysql
		groupadd mysql
		useradd -r -g mysql mysql
		chown -R mysql:mysql /usr/local/mysql/
		cd /usr/local/mysql
		mkdir data
		yum -y install numactl.x86_64
		ln -s -f /usr/lib64/libtinfo.so.6.2 /usr/lib64/libtinfo.so.5
		bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
		chown -R root:root ./
		chown -R mysql:mysql data
		mkdir /etc/init.d
		cp ./support-files/mysql.server /etc/init.d/mysqld
		cp /opt/sh/.mysql.cnf /etc/my.cnf
		chown 777 /etc/my.cnf 
		chmod +x /etc/init.d/mysqld
		/etc/init.d/mysqld restart
		source /etc/profile
		echo "change rootpwd"
		printf "source /opt/sh/.mysql_root_pwd;\n";
		service mysqld restart
		exit 1
	fi
elif [ "${MYSQL_OPTION}" == "rootpwd" ];then
	printf "source /opt/sh/.mysql_root_pwd;\n";
	exit 1	
elif [ "${MYSQL_OPTION}" == "mycnf" ];then
        cp /opt/sh/.mysql.cnf /etc/my.cnf
	service mysqld restart
        exit 1
else
	printf " Use: install|rootpwd|mycnf\n"		
	exit 1
fi




