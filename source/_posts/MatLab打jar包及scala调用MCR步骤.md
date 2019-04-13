title: MatLab打jar包及scala调用MCR步骤
date: 2018-10-19 16:30:31
permalink: scala-invoke-mcr
categories: 
- Matlab
tags:
- Matlab
- MCR
- 望智
---


## 背景

* 描述如何Matlab打包及MCR调用过程中遇到的问题及解决方法

## 语言环境
* JDK 1.7
* JDK 1.8
* IDEA (集成开发工具)
* Matlab

## 安装MatLab
* 安装激活参考: [MatLab安装及打包](http://blog.gyenno.com/matlab-service-install-employ.html)

<!--more-->

## 运行Matlab和打包
* 安装并激活完成后，以管理员身份运行matlab
* 在命令行输入deploytool——>Library Compiler，把需要打包的.m文件导入
* 根据需求修改项目名称及类名开始打包，如下图：
  ![](images/matlab/image16.png)
* 若打包是出现下图错误：
  ![](images/matlab/image17.png)
  则为JDK版本问题，需要下载JDK1.7版本并修改环境变量，使当前环境JDK版本为1.7。

## 将matlab包导入IDEA进行测试
* 将JDK环境切换回JDK1.8，把Matlab打包生成的jar包和MCR中对应本机操作系统的javaBuilder.jar加入到项目中,如下图：
  ![](images/matlab/image18.png)
* 若项目中使用maven或sbt导入，需要将对应本机操作系统的jar包并上传至nexus，artifactId需修改为对应版本以便区分，如下图：
  ![](images/matlab/image19.png)
* 在项目pom.xml文件或build.sbt文件中导入jar包，如下图：
  ![](images/matlab/image20.png)
  ![](images/matlab/image21.png)
* 按上述操作步骤，可成功调用Matlab生成的jar包，调用算法接口分析数据：
  ![](images/matlab/image22.png)


## 参考文章

* [MatLab安装及打包](http://blog.gyenno.com/matlab-service-install-employ.html)
