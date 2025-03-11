#!/bin/bash
# 检查XDG_DESKTOP_DIR环境变量，如果未设置则使用默认值，支持KDE的中文桌面路径
if command -v xdg-user-dir &>/dev/null; then
    XDG_DESKTOP_DIR=$(xdg-user-dir DESKTOP)
else
    XDG_DESKTOP_DIR="$HOME/Desktop"
fi
echo 桌面位置：$XDG_DESKTOP_DIR
Determine_distribution() {
    # 判断发行版类型
    # 由于Linux发行版包管理器可以混装，如Debian安装Arch Linux的pacman，此处采用/etc/os-release的形式进行一次判断。
    # 读取 /etc/os-release 文件并提取 ID 字段，转换为小写
    # $installprefix是该发行版包管理器安装软件前缀
    # $nssvar是该发行版certutil包名称
    os_id=$(grep "^ID=" /etc/os-release | cut -d'=' -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')
    # 输出 ID
    echo "OS ID: $os_id"

    case "$os_id" in
    "ubuntu" | "debian" | "kali" | "mx" | "devuan" | "pureos" | "parrot" | "trisquel" | "bunsenlabs" | "deepin" | "antix" | "uos" | "kylin" | "loongnix" | "gxde" | "nfsdesktop")
        echo 默认包管理器：apt
        sudo apt update
        installprefix="sudo apt install -y"
        nssvar="libnss3-tools"
        ;;
    "fedora")
        echo 默认包管理器：dnf
        installprefix="sudo dnf install -y"
        nssvar="nss-tools"
        ;;
    "centos" | "rhel" | "rocky" | "alma" | "amzn" | "alt")
        echo 默认包管理器：yum
        installprefix="sudo yum install -y"
        nssvar="nss-tools"
        ;;
    "opensuse")
        echo 默认包管理器：zypper
        sudo zypper refresh
        installprefix="sudo zypper install"
        nssvar="mozilla-nss-tools"
        ;;
    "arch" | "manjaro" | "artix" | "chakra" | "blackarch" | "frugalware")
        echo 默认包管理器：pacman
        installprefix="sudo pacman -S"
        nssvar="nss"
        ;;
    "mageia" | "pclinuxos" | "openmandriva" | "rosa" | "vectorlinux")
        echo 默认包管理器：urpmi
        sudo urpmi.update -a
        installprefix="sudo urpmi"
        nssvar="nss-tools"
        ;;
    "slackware" | "salix" | "porteus" | "slacko")
        echo 默认包管理器：slackpkg
        sudo slackpkg update gpg
        sudo slackpkg update
        installprefix="sudo slackpkg install"
        nssvar="nss"
        ;;
    "aosc")
        echo 默认包管理器：oma
        installprefix="sudo oma install -y"
        nssvar="nss"
        ;;
    "gentoo")
        echo 默认包管理器：emerge
        sudo emerge --sync
        installprefix="sudo emerge -av"
        nssvar="nss"
        ;;
    "solus")
        echo 默认包管理器：eopkg
        sudo eopkg update-repo
        installprefix="sudo eopkg install"
        nssvar="nss-tools"
        ;;
    "clearlinux" | "nixos" | "void" | "puppy" | "tinycore" | "yongbao")
        # 冷门发行版，手动安装判断变量
        manualins="1"
        ;;
    *)
        echo 未知发行版
        manualins="1"
        ;;
    esac
}
Determine_distribution

default_base_path="$HOME/WattToolkit"
# Linux发行版一般都内置dialog（yongbao除外），yongbao内置whiptail且无包管理器（没有zenity），某些linux发行版内置zenity
command -v dialog &>/dev/null && dialog1="dialog" || dialog1="whiptail"
    if command -v zenity &>/dev/null; then
        custom_base_path=$(zenity --entry --title="安装路径" --text="请输入安装路径（默认为 "$default_base_path"，不输入则使用默认路径）")
    else
        custom_base_path=$($dialog1 --title "安装路径" --inputbox "请输入安装路径（默认为 "$default_base_path"，不输入则使用默认路径）" 10 60 3>&1 1>&2 2>&3)
    fi
echo $custom_base_path
read
if [ "$os_id" != "yongbao" ]; then zenity --question --text="$1" --width=400; else whiptail --yesno "$1" 10 60; fi
[ "$os_id" != "yongbao" ] && zenity --info --text="未知的设备架构:$arch!" --width=300 || whiptail --msgbox "未知的设备架构:$arch!" 10 60
[ "$os_id" != "yongbao" ] && zenity --info --text="未知的最新版本 Hash:$n_sha384!" --width=300 || whiptail --msgbox "未知的最新版本 Hash:$n_sha384!" 10 60
        if [ "$os_id" != "yongbao" ]; then
            wget "$downloads_url" -O "$tar_path" 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# 下载中 \2\/s, 剩余时间： \3/' | zenity --progress --title="$title Watt Toolkit" --auto-close --width=500
        else
            wget "$downloads_url" -O "$tar_path" 2>&1 | sed -u 's/.* \([0-9]\+\)%.*/\1/' | whiptail --title "$title" --gauge "正在下载中" 10 60 0
        fi
[ "$os_id" != "yongbao" ] && zenity --error --text="下载错误。" --width=500 || whiptail --msgbox "下载错误。" 10 60
Decompression() {
    echo "正在校验安装包"
    TOTAL_FILES=$(tar tf "$tar_name" 2>/dev/null | wc -l)
    {
       COUNTER=0
       tar -xzvf "$tar_name" 2>/dev/null | while read -r FILE; do
       COUNTER=$((COUNTER + 1))
       PERCENTAGE=$((COUNTER * 100 / TOTAL_FILES))
       echo "# 解压 $FILE"
       echo "$PERCENTAGE"
     done
     echo "100"
   }| { ([ "$os_id" != "yongbao" ] && zenity --progress --title="安装中" --text="正在解压文件..." --width=500 --percentage=0 --auto-close --no-cancel || whiptail --title "安装中" --gauge "正在解压文件..." 10 60 0)}
    rm -f "$appVer_path" &>/dev/null
    dotnet_path="$base_path/dotnet"
    dotnet_exec="$dotnet_path/dotnet"
    [ -x "$dotnet_exec" ] || chmod +x "$dotnet_exec"
    chmod +x "$base_path/$exec_name.sh"
}
if [ "$os_id" != "yongbao" ]; then zenity --question --text="本地已有最新安装包是否继续解压?" --width=400; else whiptail --yesno "本地已有最新安装包是否继续解压?" 10 60; fi
choice=$([ "$os_id" != "yongbao" ] && { zenity --list --radiolist --title="请选择要添加到的位置" --column="选择" --column="路径" TRUE "$XDG_DESKTOP_DIR" FALSE "$HOME/.local/share/applications/";} || { whiptail --title "请选择要添加到的位置" --radiolist "" 10 60 2 "$XDG_DESKTOP_DIR" "" ON "$HOME/.local/share/applications/" "" OFF 3>&1 1>&2 2>&3;} )
echo $choice
read
[ "$os_id" != "yongbao" ] && zenity --info --text="无效选项，请重新选择。" --width=300 || whiptail --msgbox "无效选项，请重新选择。" 10 60
if [ "$os_id" = "yongbao" ]; then sudo chmod u+s $(which pkexec); fi
