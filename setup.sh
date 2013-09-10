#!/usr/bin/env bash
#
set -e

git_url="https://github.com/ryurock/versicolor.git"
repo_name="versicolor"

#
# Requirement Tool filter method
#
requirement_tool_filter() {
    local command=""
    local command_ver=""

    # OSXの場合
    if [ `uname` = "Darwin" ]; then
        # Homebrew install
        if ! which brew >/dev/null 2>&1; then
            echo "[Install] dependency Homebrew"
            ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
            command_ver=$(brew --version)
            command=$(which brew)
            echo "[Install] installed Homebrew. path : ${comand} version : ${command_ver}"
        else
            echo "[Install] Already exists dependency Homebrew"
        fi

        # git install
        if ! which git >/dev/null 2>&1; then
            echo "[Install] dependency Git"
            brew install git
            command_ver=$(git --version)
            command=$(which git)
            echo "[Install] installed Git. path : ${comand} version : ${command_ver}"
        else
            echo "[Install] Already exists dependency Git"
        fi

        # vagrant install
        if ! which vagrant >/dev/null 2>&1; then
            echo "[Install] dependency Vagrant"
            curl -O http://files.vagrantup.com/packages/7ec0ee1d00a916f80b109a298bab08e391945243/Vagrant-1.2.7.dmg
            hdiutil mount Vagrant-1.2.7.dmg
            sudo installer -pkg /Volumes/Vagrant/Vagrant.pkg -target "/Volumes/Macintosh HD"
            command_ver=$(vagrant --version)
            command=$(which vagrant)
            echo "[Install] installed Vagrant. path : ${comand} version : ${command_ver}"
        else
            echo "[Install] Already exists dependency vagrant"
        fi

        # Packer Install
        if ! which packer >/dev/null 2>&1; then
            echo "[Install] dependency Packer"
            brew tap homebrew/binary
            brew install packer
            command_ver=$(packer --version)
            command=$(which packer)
            echo "[Install] installed Packer. path : ${comand} version : ${command_ver}"
        fi
    fi

    command=$(vagrant plugin list | grep vagrant-vbguest | awk '{print $1}')

    if [ ! "${command}" = "vagrant-vbguest" ]; then
        echo "[Install] dependency Vagarant Plugin. vagrant-vbguest"
        vagrant plugin install vagrant-vbguest
    else
        echo "[Install] Already exists dependency Vagrant Plugin. vagrant-vbguest"
    fi

    command=$(vagrant plugin list | grep sahara | awk '{print $1}')

    if [ ! "${command}" = "sahara" ]; then
        echo "[Install] dependency Vagarant Plugin. sahara"
        vagrant plugin install sahara
    else
        echo "[Install] Already exists dependency Vagrant Plugin. sahara"
    fi

}

#
# Create Synced Folder method
#
mkdir_synced_folder() {
    local command=$(cat Vagrantfile | grep 'config.vm.synced_folder' | awk '{print $2}' | sed -e "s/,//g" | sed -e 's/"//g')

    if [ ! -e "${command}" ]; then
        mkdir -p "./${command}"
        touch "./${command}/.gitignore"
    fi
}

#
# Already Box Destroy Method
#
box_destroy() {
    local command=$(cat Vagrantfile | grep 'BOX_NAME =' | awk '{print $3}' | sed -e 's/"//g')

    if [ -e "~/.vagrant.d/boxes/${command}/virtualbox" ]; then
        rm -rf "~/.vagrant.d/boxes/${command}/virtualbox"
        echo "boxes deleted"
    fi
}


#
# main
#
requirement_tool_filter
git clone "${git_url}"
cd "${repo_name}"
mkdir_synced_folder

vagrant destroy --force
box_destroy

packer build -only=virtualbox packer.json
vagrant up
