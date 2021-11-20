#!/bin/bash

# filename: tgit.sh
# author: @Patrick Jun
# version: 1.0.2

####################### 配置-start ########################
# git内网地址
git_in='192.168.0.110:[0-9]\{1,5\}'
# git外网地址
git_out='223.223.223.223:9999'

# 用户名和邮箱
git_user_name='鲁班大师'
git_user_email='patrick@example.com'
####################### 配置-end ########################


# 函数：执行克隆命令，并设置用户信息
doGitCloneAndSetLocalUser(){
  url=$1
  # 获取仓库名
  array=(${url//// })
  package_name_git=${array[${#array[@]}-1]}
  package_name=`echo $package_name_git | sed 's/\.git//'`
  
  # 给当前项目设置用户名和邮箱(PS：cd命令会启动一个子shell进程，所以需要每次cd)
  echo -e "\033[34mtgit: set local user.name=$2\033[0m"
  `cd ./$package_name && git config --local user.name $2`

  echo -e "\033[34mtgit: set local user.email=$3\033[0m"
  `cd ./$package_name && git config --local user.email $3`
}

# 函数：当前目录下，设置用户信息
doGitSetLocalUser(){
  # 给当前项目设置用户名和邮箱(PS：cd命令会启动一个子shell进程，所以需要每次cd)
  echo -e "\033[34mtgit: set local user.name=$1\033[0m"
  `git config --local user.name $1`
  echo -e "\033[34mtgit: set local user.email=$2\033[0m"
  `git config --local user.email $2`
}

# 函数：预处理 is_do_exit 0 继续执行 1只执行预处理命令，不再往下执行了
is_do_exit=0
preCommand(){
  case $1 in
    name)
      doGitSetLocalUser $git_user_name $git_user_email
      is_do_exit=1
      ;;
    --help)
      echo -e "\033[34mtgit 特殊命令：\033[0m"
      echo -e "  \033[32mtgit name\033[0m: 给当前项目设置为公司的用户信息\n"
      echo -e "\033[34mgit 原命令：\033[0m"
      git --help
      is_do_exit=1
      ;;
    *)
      # is_do_exit=0
      # exit 0;
      ;;
  esac
}

# 函数：判断部分命令特殊，进行特殊操作
checkCommand(){
  case $1 in
    clone)
      doGitCloneAndSetLocalUser $2 $git_user_name $git_user_email
      ;;
    init)
      doGitSetLocalUser $git_user_name $git_user_email
      ;;
    *)
      # exit 0;
      ;;
  esac
}

####################### main-start ########################
echo -e "\033[34mtgit: Working...\033[0m"

# 预处理
preCommand $1
if [ $? -ne 0 ]
then
  echo -e "\033[31mtgit: Failed!\033[0m"
  exit 1
else
  if [ $is_do_exit -ne 0 ]
  then
    echo -e "\033[32mtgit: Success!\033[0m"
    exit 0
  fi
fi

# 参数内外网检测
if [ -z `echo $2 | grep -o $git_in` ]
then
  # 外网地址，直接调用git
  git $@
  if [ $? -ne 0 ]
  then
    echo -e "\033[31mtgit: Failed!\033[0m"
    exit 1
  else
    checkCommand $@
    echo -e "\033[32mtgit: Success!\033[0m"
    exit 0
  fi
else
  # 内网地址，替换成外网地址
  params=`echo $@ | sed "s/$git_in/$git_out/"`
  echo -e "\033[34mtgit: Replace with: $params\033[0m"
  git $params
  if [ $? -ne 0 ]
  then
    echo -e "\033[31mtgit: Failed!\033[0m"
    exit 1
  else
    checkCommand $params
    echo -e "\033[32mtgit: Success!\033[0m"
    exit 0
  fi
fi
####################### main-end ########################