#!/bin/bash

# 检查上一条命令执行结果， 如果失败则输出错误消息
# $1 string 失败消息内容
assert_command_result () {
  if [ $? -ne 0 ]; then
    echo ""
    echo ""
    echo "==================================================================="
    echo "# ERROR : $1"
    echo "==================================================================="
    exit
  fi
  return 0
}

# 输出过程消息
# $1 内容
print_progress () {
  echo ""
  echo "--------------------------------------------------------------------"
  echo " ==> $1 "
  echo "--------------------------------------------------------------------"
}

# 检查用户名是否存在
# $1 待检查用户名
# $? 0 存在 1 不存在
user_exists () {
  local count=`cat /etc/passwd | grep $1 | wc -l`
  if [ $count -gt 0 ]; then
    return 0
  else
    return 1 
  fi
}

# 检查用组户名是否存在
# $1 待检查用户组名
# $? 0 存在 1 不存在
user_group_exists () {
  local count=`cat /etc/group | grep $1 | wc -l`
  if [ $count -gt 0 ]; then
    return 0
  else
    return 1
  fi
}

# 获取系统可用内存和swap空间大小
total_mem_swap_size () {
  local size=`free -t | grep Total | grep "[0-9]*" -o | head -n 1`
  echo $size
}

# 如果指定的文件夹不存在则创建文件夹
# $1 文件夹路径
mkdir_if_not_exists () {
  if [ ! -d $1 ]; then 
    mkdir -p $1
  fi
}
