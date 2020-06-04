#!/bin/bash
# nginx简易安装脚本，版本以及nginx安装模块可修改。
echo "start"

echo  -e "\033[1;31m 安装前的检查  \033[0m "
 
echo -e "\033[1;37m 1 检查是否已安装nginx  \033[0m "
nginx -V >/dev/null 2>&1
if [  $? == 0 ]; then
echo  " nginx已安装 "
echo   " 检查nginx版本，已安装模块是否满足要求 "
exit;
else
echo  " nginx未安装 "
fi
 
echo -e "\033[1;37m 2 检查80端口是否被占用  \033[0m "
str=`/usr/bin/netstat -ntlp|grep -w 80 |wc -l`
if [ -z "$str" ]; then
echo " 80端口未被占用"
else
echo " 80端口被占用，请关闭80端口再进行安装"
exit;
fi

# pcre_version="8.36"
# openssl_version="1.0.1j"
# zlib_version="1.2.11"
# nginx_version="1.8.0"
 
pcre_version="8.36"
openssl_version="1.1.1"
zlib_version="1.2.11"
nginx_version="1.14.0"
 
 
echo "安装：gcc gcc-c++"
yum install -y gcc gcc-c++
 
echo "进入目录：/usr/local/"
cd /usr/local/
echo ""
 
 
echo "下载：pcre-"$pcre_version""
pcre_url="http://jaist.dl.sourceforge.net/project/pcre/pcre/"$pcre_version"/pcre-"$pcre_version".tar.gz"
wget $pcre_url
echo "解压：pcre-"$pcre_version".tar.gz"
tar -zxvf pcre-"$pcre_version".tar.gz
echo "进入目录：/usr/local/pcre-"$pcre_version""
cd pcre-"$pcre_version"
echo "编译安装：pcre-"$pcre_version""
./configure
make && make install
echo "返回到目录：/usr/local/"
cd /usr/local/
echo ""
 
 
echo "下载：openssl-"$openssl_version""
openssl_url="http://www.openssl.org/source/openssl-"$openssl_version".tar.gz"
wget $openssl_url
echo "解压：openssl-"$openssl_version".tar.gz"
tar -zxvf openssl-"$openssl_version".tar.gz
echo "进入目录：openssl-"$openssl_version""
cd openssl-"$openssl_version"
echo "编译安装：openssl-"$openssl_version""
./config
make && make install
echo "返回到目录：/usr/local/"
cd /usr/local/
echo ""
 
 
echo "下载：zlib-"$zlib_version""
zlib_url="http://zlib.net/zlib-"$zlib_version".tar.gz"
wget $zlib_url
echo "解压：zlib-"$zlib_version".tar.gz"
tar -zxvf zlib-"$zlib_version".tar.gz
echo "进入目录：zlib-"$zlib_version""
cd zlib-"$zlib_version"
echo "编译安装：zlib-"$zlib_version""
./configure
make && make install
echo "返回到目录：/usr/local/"
cd /usr/local/
echo ""
 
 
echo "下载：nginx-"$nginx_version""
nginx_url="http://nginx.org/download/nginx-"$nginx_version".tar.gz"
wget $nginx_url
echo "解压：nginx-"$nginx_version".tar.gz"
tar -zxvf nginx-"$nginx_version".tar.gz
echo "重命名nginx-"$nginx_version"为nginx"
mv nginx-"$nginx_version" nginx
echo "进入目录：nginx"
cd nginx
echo "编译安装：nginx-"$nginx_version""
./configure --user=nobody --group=nobody --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_gzip_static_module --with-http_realip_module --with-http_sub_module --with-http_ssl_module --with-pcre=/usr/local/pcre-"$pcre_version" --with-zlib=/usr/local/zlib-"$zlib_version" --with-openssl=/usr/local/openssl-"$openssl_version"
make && make install
echo "创建目录：/usr/local/nginx/logs"
mkdir logs
echo "返回到目录：/usr/local/"
cd /usr/local/
echo ""
 
 
read -p "是否需要删除下载的安装（输入y/Y删除，其他不删除）：" inputMsg
if [ "$inputMsg" == 'y' ] || [ "$inputMsg" == 'Y' ] 
then
    rm -rf nginx-"$nginx_version".tar.gz pcre-"$pcre_version".tar.gz openssl-"$openssl_version".tar.gz zlib-"$zlib_version".tar.gz
    echo "删除完成"
else
    echo "不删除"
fi
echo ""
 
read -p "是否需要启动nginx（输入y/Y启动，其他不启动）：" startNginxMsg
if [ "$startNginxMsg" == 'y' ] || [ "$startNginxMsg" == 'Y' ] 
then
    /usr/local/nginx/sbin/nginx
    if [ $? -eq 0 ]
    # 获取本机ip，需要根据实际修改主机ip域。两端需要加反引号以获取命令返回信息。如果不设置ip域则可能会取出包含127.0.0.1等多个地址信息
    then
        localIp=`/sbin/ifconfig -a|grep inet|grep 172.17.*.*|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
        echo "启动成功,请访问: http://$localIp"
    else
        echo "启动失败，请查看异常信息确定失败原因"
    fi
else
    echo "不启动"
fi
echo ""
 
 
echo "版本信息："
echo "pcre："$pcre_version
echo "openssl："$openssl_version
echo "zlib："$zlib_version
echo "nginx："$nginx_version
echo ""
 
echo "安装路径: /usr/local/"
echo "end"
