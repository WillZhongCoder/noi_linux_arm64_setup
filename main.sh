#!/bin/bash

# ----------------------------------------------------------------------
# NOI Linux 2.0 竞赛环境配置脚本 for ARM64 Ubuntu
# 注意：该脚本假定您已运行在 arm64 架构的 Ubuntu 系统上。
# ----------------------------------------------------------------------

# 确保脚本以 root 权限运行
if [[ $EUID -ne 0 ]]; then
   echo "此脚本必须使用 sudo 运行." 
   exit 1
fi

echo "--- 正在开始配置 NOI Linux 2.0 竞赛环境（ARM64） ---"

# 1. 更新系统并安装必要的工具
echo "1/4: 更新系统软件包并安装基础工具..."
apt update
# 安装 build-essential 提供基础 C/C++ 编译环境
# 安装 wget/curl 用于下载，vim/nano 用于编辑，git 用于版本控制
apt install -y build-essential wget curl vim nano git python3

# 2. 安装并配置 NOI/OI 竞赛常用编译器
# NOI Linux 2.0 通常基于 Ubuntu 18.04/20.04 的环境，这里选择常见的版本。
# 注意：GCC 7/9/11 是常见的竞赛环境版本。
echo "2/4: 安装 GCC/G++ 多版本编译器..."

# 安装 GCC 7 和 G++ 7
if apt install -y gcc-7 g++-7; then
    echo "GCC/G++ 7 安装成功."
    # 配置多版本系统，方便切换
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 70
else
    echo "警告：GCC/G++ 7 安装失败，可能您的系统源不包含该版本。将跳过此版本。"
fi

# 安装 GCC 9 和 G++ 9
if apt install -y gcc-9 g++-9; then
    echo "GCC/G++ 9 安装成功."
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 90
else
    echo "警告：GCC/G++ 9 安装失败，可能您的系统源不包含该版本。将跳过此版本。"
fi

# 安装最新默认的 GCC/G++ 版本（通常是 11/12+）
echo "确保安装了默认的最新版本..."
apt install -y gcc g++

# 3. 安装 Pascal 编译器 (FreePascal Compiler - FPC)
# NOI Linux 2.0 需要 Pascal 编译器
echo "3/4: 安装 FreePascal 编译器 (FPC)..."
if apt install -y fp-compiler; then
    echo "FreePascal (FPC) 安装成功."
else
    echo "警告：FreePascal (FPC) 安装失败，可能您的系统源不包含。请手动检查 'apt install fpc'."
fi

# 4. 安装常用 IDE 和文本编辑器
# Code::Blocks 和 VS Code 是常用的 OI/NOI 编程环境
echo "4/4: 安装常用 IDE 和文本编辑器..."

# Code::Blocks（通常在 Ubuntu 仓库中）
if apt install -y codeblocks; then
    echo "Code::Blocks 安装成功."
else
    echo "警告：Code::Blocks 安装失败，请手动检查."
fi

# VS Code - 适用于 ARM64 的 VS Code 通常需要从官方下载 .deb 包
# 这里使用通用包名，如果失败请用户手动安装
echo "尝试安装 VS Code (arm64 snap 或 deb)..."
if snap install code --classic; then
    echo "Visual Studio Code (Snap) 安装成功."
else
    echo "警告：VS Code snap 安装失败，请尝试 'apt install code' 或从官网下载 arm64 .deb 包安装."
fi

# 5. 最终环境配置检查和清理
echo "--- 环境配置完成 ---"
echo "请手动运行以下命令确认关键编译器版本："
echo "gcc --version"
echo "g++ --version"
echo "fpc -i"
echo ""
echo "如需切换默认 GCC/G++ 版本，请运行："
echo "sudo update-alternatives --config gcc"
echo "sudo update-alternatives --config g++"

apt autoremove -y
apt clean

echo "环境配置脚本执行完毕。请重启系统以确保所有变更生效。"