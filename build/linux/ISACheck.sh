#!/bin/bash

# 获取CPU架构
arch=$(uname -m)

# 检查CPU指令集扩展
case $arch in
    x86_64)
        # 检查是否支持SSE4.2
        if grep -q 'sse4_2' /proc/cpuinfo; then
            echo "该CPU及Linux发行版支持SSE4.2扩展指令集，可以正常运行Watt Toolkit"
        else
            echo "该CPU或Linux发行版不支持SSE4.2扩展指令集，可能不能正常运行Watt Toolkit！"
        fi
        ;;
    aarch64)
        # 检查是否支持NEON
        if grep -q 'neon' /proc/cpuinfo; then
            echo "该CPU及Linux发行版支持NEON扩展指令集，可以正常运行Watt Toolkit"
        else
            echo "该CPU或Linux发行版不支持NEON扩展指令集，可能不能正常运行Watt Toolkit！"
        fi
        ;;
    loongarch64)
        # 检查是否支持LSX和LASX
        if grep -q 'lsx' /proc/cpuinfo && grep -q 'lasx' /proc/cpuinfo; then
            echo "该CPU及Linux发行版支持LSX和LASX扩展指令集，可以正常运行Watt Toolkit"
        else
            echo "该CPU或Linux发行版不支持LSX和LASX扩展指令集，可能不能正常运行Watt Toolkit！"
        fi
        ;;
    riscv64)
        # 检查ISA字段中的'v'扩展或显式cpu-vector字段
        if { grep -m1 '^isa\s*:' /proc/cpuinfo | grep -q 'v'; } || \
        { grep -q 'cpu-vector' /proc/cpuinfo; }; then
            echo "该CPU及Linux发行版支持RISC-V的RVV向量扩展，可以正常运行Watt Toolkit"
        else
            echo "该CPU或Linux发行版不支持RISC-V的RVV向量扩展，可能不能正常运行Watt Toolkit！"
        fi
        ;;
    *)
        echo "未知CPU架构：$arch"
        ;;
esac
