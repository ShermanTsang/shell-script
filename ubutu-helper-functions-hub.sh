#!/bin/bash
# author:ShareManT
# script:ubutu-helper-functions-hub

version=1.0

echo "==========================================="
echo "ubutu-helper-functions-hub V.${version}"
echo "==========================================="


setLangToChinese () {

	echo "[ Install ] Install chinese lang pack for ubutu via apt-get"
	apt-get -y install language-pack-zh-hant language-pack-zh-hans zhcon zh-autoconvert

	echo "[ Config ] Config lang option sentences to relative files"
	echo -e "LANG="zh_CN.UTF-8"\nLANGUAGE="zh_CN:zh"" > /etc/default/locale
	echo -e "LANG="zh_CN.UTF-8"\nLANGUAGE="zh_CN:zh:en_US:en"" >> /etc/environment
	echo -e "en_US.UTF-8 UTF-8\nen_GB.UTF-8 UTF-8\nzh_CN.UTF-8 UTF-8\nzh_CN.GBK GBK\nzh_CN GB2312" >> /var/lib/locales/supported.d/local

	echo "[ Generate ] Generate language files"
	locale-gen

	echo "[ Check ] Check the current default language option"
	locale

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
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc

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
	apt-get install gnupg2

	echo "[ Config ] set gpg2 key"
	gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

	echo "[ Config ] set gpg2 key"
	\curl -sSL https://get.rvm.io | bash -s stable

	echo "[ Refresh ] make the configuration valid"
	source ~/.bashrc
	source ~/.bash_profile
	
	echo "[ Mirror ] set ruby cache accelerated mirror for chinese"
	echo "ruby_url=https://cache.ruby-china.com/pub/ruby" > /usr/local/rvm/user/db 

	echo "[ Install ] install Ruby latest"
	rvm install ruby

	echo "[ Mirror ] set ruby gem accelerated mirror for chinese"
	gem source -a https://gems.ruby-china.com
	gem source -r https://rubygems.org/
	
}

installNodejs () {

	echo "[ Install ] install nodejs latest"
	apt-get -y install nodejs

	echo "[ Install ] install npm latest"
	apt-get -y install npm

	echo "[ mirror ] set npm source mirror to TaoBaoNpmMirror"
	npm config set registry https://registry.npm.taobao.org

	echo "[ Install ] instal n module of npm for nodejs version control"
	npm install -g n

	echo "[ Install ] instal yarn of npm for npm package management"
	npm install -g yarn

	echo "[ mirror ] set yarn source mirror to TaoBaoNpmMirror"
	yarn config set registry https://registry.npm.taobao.org

}