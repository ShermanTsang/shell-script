#!/bin/bash
# author:ShareManT
# script:centos-helper-functions-hub

version=1.1

echo "==========================================="
echo "Centos-tookit-functions-hub V.${version}"
echo "==========================================="

modifyHostName() {

    echo "[ Check ] current hostnamectl"
    hostnamectl
    echo "[ Input ] please input the new hostname"
    hostnamectl
    read newHostName
    echo "[ Config ] set hostnamectl ${newHostName}"
    sudo hostnamectl set-hostname ${newHostName}
    
}

installBtPanel () {

    echo "[ Install ] install bt panel"
    yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
    
}

installOhMyZsh () {

    if( cat /etc/shells | grep zsh ){
         echo "[ Check ] zsh is not found"
         echo "[ Install ] install zsh via yum"
         yum -y install zsh
         echo "[ Config ] change the default shell to zsh"
         chsh -s /bin/zsh
    }
    
    echo "[ Install ] install oh-my-zsh from github source"
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

    echo "[ Config ] set oh-my-zsh bash theme to af-agic"
    sed -i 's/robbyrussell/af-magic/g' ~/.zshrc

    echo "[ Config ] set oh-my-zsh plugins"
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions docker tmux fzf)/g' ~/.zshrc

    echo "[ Download ] download zsh plugin sources from github"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

    echo "[ Config ] set oh-my-zsh time stamp format for chinese friendly"
    sed -i 's/\# HIST_STAMPS=\"mm\/dd\/yyyy\"/HIST_STAMPS=\"yyyy-mm-dd\"/' ~/.zshrc

    echo "[ Refresh ] make the configuration valid"
    source ~/.zshrc

}

installRuby () {

	echo "[ Install ] install gpg2"
	yum install gnupg2

	echo "[ Config ] set gpg2 key"
	gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

	echo "[ Config ] set gpg2 key"
	\curl -sSL https://get.rvm.io | bash -s stable

	echo "[ Refresh ] make the configuration valid"
	source ~/.bashrc
	source ~/.bash_profile
	
	echo "[ Mirror ] set ruby cache accelerated mirror for chinese"
	echo "ruby_url=https://cache.ruby-china.com/pub/ruby" > /usr/local/rvm/user/db 

	echo "[ Mirror ] set ruby gem accelerated mirror for chinese"
	gem source -a https://gems.ruby-china.com
	gem source -r https://rubygems.org/
	
}

installNodejs () {

	echo "[ Config ] install and config newer rpm source hub"
	# for 64bit linux core
	rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	# for 32bit linux core
	# rpm -ivh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
	rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
	rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
	rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi

	echo "[ Install ] install nodejs(with npm)"
	curl --silent --location https://rpm.nodesource.com/setup_5.x | bash -
	yum -y install nodejs

	echo "[ mirror ] set npm source mirror to TaoBaoNpmMirror"
	npm config set registry https://registry.npm.taobao.org

	echo "[ Install ] instal n module of npm for npm version control"
	npm install -g n

	echo "[ Install ] instal yarn of npm for nodejs package management"
	npm install -g yarn

	echo "[ mirror ] set yarn source mirror to TaoBaoNpmMirror"
	yarn config set registry https://registry.npm.taobao.org

}
