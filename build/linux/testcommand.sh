#!/bin/bash
# 检查XDG_DESKTOP_DIR环境变量，如果未设置则使用默认值，支持KDE的中文桌面路径
if command -v xdg-user-dir &>/dev/null; then
    XDG_DESKTOP_DIR=$(xdg-user-dir DESKTOP)
else
    XDG_DESKTOP_DIR="$HOME/Desktop"
fi
echo $XDG_DESKTOP_DIR
