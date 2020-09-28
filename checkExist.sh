#!/bin/bash
# 判断仓库是否存在,存在输出 1，否则输出0
# 入参：仓库名

maindir=/app/svn
if [ -d "$maindir/$1" ]; then
  echo -n "success"
else
  echo -n "fail"
fi
