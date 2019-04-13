title: idea使用sbt进行remote调试
date: 2018-07-12 15:50:23
permalink: idea-remote-debug-tutorial
categories: 
- IDEA
tags:
- IDEA
- debug
- 博文
---

## 背景

* 公司使用scala作为后端开发语言，刚刚接触这门语言及对应的IDE工具，互联网上关于scala在idea上remote的debug模式资料比较少
* 本文将介绍如何启动idea的remote调试功能，便于快速迭代开发

## 语言环境
* JDK 1.8
* scala 2.12.6
* sbt 1.1.6
* IDEA (集成开发工具)

## 示例代码
下载代码，并倒入有scala，sbt插件的IDEA
[http://gitlab.gyenno.com/backend/gyenno-service](http://gitlab.gyenno.com/backend/gyenno-service)

<!--more-->

## 操作步骤
### 1、找到File菜单下Settings打开SBT配置，在对应JVM下VM parameters中添加以下配置

-XX:MaxPermSize=384M -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005

如下图：
![](images/idea/i1.png)

### 2、打开idea里Termilal，并用sbt启动项目，会出现"Listening for transport dt_socket at address: 5005"
 sbt -jvm-debug 5005

### 3、找到Run菜单下Edit Configurations，点击后出现配置页面，点击+，选择remote;按照下述方式配置
 Name:自定义名称
 Transport:Socket
 Debugger mode:Attach
 Host:127.0.0.1
 Port:5005
 Search sources using modules classpath:选择目标项目
如下图：
![](images/idea/i2.png)
### 4、在idea右上角debug附近，选择刚刚配置的remote的debug配置，点击debug，直到debug控制台出现"Connected to the target VM, address: '127.0.0.1:5005', transport: 'socket'"
 如下图：
 ![](images/idea/i3.png)
 ![](images/idea/i4.png)
### 5、在测试类上打上断点
### 6、返回控制台，输入以下命令，直到断点变成带勾的样式，之后就可以调试你的项目了
project 项目名
~testOnly *DeviceActorTest
如下图：
 ![](images/idea/i5.png)
### 7、如果是希望通过swagger来调试你自己的代码，那么你需要用下述命令启动项目，并在你要调试的代码出打上断点
run -jvm-debug 5005

## 参考文章
[Debugging Scala code with simple-build-tool (sbt) and IntelliJ](https://stackoverflow.com/questions/4150776/debugging-scala-code-with-simple-build-tool-sbt-and-intellij)