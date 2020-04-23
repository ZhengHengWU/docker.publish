echo '>>>删除项目目录'
rm -rf /home/code/vueDotNetCore-OpenSource
echo '>>>创建项目目录'
mkdir /home/code/vueDotNetCore-OpenSource
echo '>>>克隆源代码'
git clone https://github.com/ZhengHengWU/vue-dotNetCore-Demo.git /home/code/vueDotNetCore-OpenSource
echo '执行dotnet编译发布'
dotnet restore  /home/code/vueDotNetCore-OpenSource/dotNetCoreApi
dotnet build  /home/code/vueDotNetCore-OpenSource/dotNetCoreApi
dotnet publish /home/code/vueDotNetCore-OpenSource/dotNetCoreApi -o /home/publish/dotNetApi
echo '>>>获取旧的容器id'
CID=$(docker ps |grep "dotnetapicontains" |awk '{print $1}')
echo $CID
echo '>>>停止旧的容器'
if [ "$CID" != "" ];then
 docker stop $CID
 echo '>>>删除旧的容器'
 docker rm $CID
fi

echo '>>>获取旧的镜像'
IID=$(docker images |grep "dotnetapi" |awk '{print $3}')
echo $IID
if [ "$IID" != "" ];then
 echo '>>>删除旧的镜像'
 docker rmi $IID
fi


echo '构建docker镜像'
docker build -t dotnetapi /home/publish/dotNetApi

sleep 10
echo '>>>启动新的容器'
docker run -d -p 5002:5002 --name dotnetapicontains dotnetapi

