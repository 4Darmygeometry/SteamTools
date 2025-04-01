#!/bin/bash

# 获取CPU架构
arch=$(uname -m)

# 检查CPU指令集扩展
case $arch in
    x86_64)
        # 检查是否支持SSE4.2
        if grep -iq 'sse4_2' /proc/cpuinfo; then
            echo "该CPU及Linux发行版支持SSE4.2扩展指令集，可以正常运行Watt Toolkit"
        else
            echo "该CPU或Linux发行版不支持SSE4.2扩展指令集，可能不能正常运行Watt Toolkit！"
        fi
        ;;
    aarch64 | arm64)
        # 检查是否支持NEON
        if grep -iq 'neon' /proc/cpuinfo || grep -iq 'asimd' /proc/cpuinfo; then
            echo "该CPU及Linux发行版支持ARM SIMD扩展指令集（NEON/ASIMD），可以正常运行Watt Toolkit"
        else
            echo "该CPU或Linux发行版不支持ARM SIMD扩展指令集（NEON/ASIMD），可能不能正常运行Watt Toolkit！"
        fi
        ;;
    loongarch64)
        # 检查是否支持LSX和LASX，Watt Toolkit龙芯版的运行同时需要LSX与LASX
        if grep -iq 'lsx' /proc/cpuinfo && grep -iq 'lasx' /proc/cpuinfo; then
            echo "该CPU及Linux发行版同时支持LSX和LASX扩展指令集，可以正常运行Watt Toolkit"
        else
            echo "该CPU或Linux发行版不支持LSX或LASX扩展指令集其中一种，可能不能正常运行Watt Toolkit！"
        fi
        ;;
    riscv64)
        # 检查ISA字段中的'v'扩展或显式cpu-vector字段
        if { grep -m1 '^isa\s*:' /proc/cpuinfo | grep -iqE '\bv[0-9]*\b'; } || \
        { grep -q 'cpu-vector' /proc/cpuinfo; }; then
            echo "该CPU及Linux发行版支持RISC-V的RVV向量扩展，可以正常运行Watt Toolkit"
        else
            echo "该CPU或Linux发行版不支持RISC-V的RVV向量扩展，可能不能正常运行Watt Toolkit！"
        fi
        ;;
    i?86 | arm*)
        # 32位不再受到支持
        echo "Watt Toolkit不再支持32位，32位用户请自行在Github/Gitee下载旧版使用，谢谢。"
        ;;
    *)
        echo "未知CPU架构：$arch"
        ;;
esac
