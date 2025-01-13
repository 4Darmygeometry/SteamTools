#!/bin/bash
# 检查XDG_DESKTOP_DIR环境变量，如果未设置则使用默认值，支持KDE的中文桌面路径
if command -v xdg-user-dir &>/dev/null; then
    XDG_DESKTOP_DIR=$(xdg-user-dir DESKTOP)
else
    XDG_DESKTOP_DIR="$HOME/Desktop"
fi
echo 桌面位置：$XDG_DESKTOP_DIR
Determine_distribution() {
    # 由于Linux发行版包管理器可以混装，如Debian安装Arch Linux的pacman，此处采用/etc/os-release的形式进行一次判断。
    # 读取 /etc/os-release 文件并提取 ID 字段，转换为小写
    os_id=$(grep "^ID=" /etc/os-release | cut -d'=' -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')
    # 输出 ID
    echo "OS ID: $os_id"

    case "$os_id" in
    "ubuntu" | "debian" | "kali" | "mx" | "devuan" | "pureos" | "parrot" | "trisquel" | "bunsenlabs" | "deepin" | "antix" | "uos" | "kylin" | "loongnix" | "gxde")
        echo 默认包管理器：apt
        ;;
    "fedora")
        echo 默认包管理器：dnf
        ;;
    "centos" | "rhel" | "rocky" | "alma" | "amzn" | "nfs" | "alt")
        echo 默认包管理器：yum
        ;;
    "opensuse")
        echo 默认包管理器：zypper
        ;;
    "arch" | "manjaro" | "artix" | "chakra" | "blackarch" | "frugalware")
        echo 默认包管理器：pacman
        ;;
    "mageia" | "pclinuxos" | "openmandriva" | "rosa" | "vectorlinux")
        echo 默认包管理器：urpmi
        ;;
    "slackware" | "salix" | "porteus" | "slacko")
        echo 默认包管理器：slackpkg
        ;;
    "gentoo")
        echo 默认包管理器：emerge
        ;;
    "solus")
        echo 默认包管理器：eopkg
        ;;
    "clearlinux")
        echo 默认包管理器：swupd
        ;;
    "nixos")
        echo 默认包管理器：nix
        ;;
    "void")
        echo 默认包管理器：xbps
        ;;
    "puppy")
        echo 默认包管理器：petget
        ;;
    "tinycore")
        echo 默认包管理器：tce-load
        ;;
    "aosc")
        echo 默认包管理器：oma
        ;;
    "yongbao")
        echo 无包管理器
        ;;
    *)
        echo 未知发行版
        ;;
    esac
}
Determine_distribution
