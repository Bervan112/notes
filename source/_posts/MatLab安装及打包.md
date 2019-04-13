title: MatLab安装及打包
date: 2018-07-05 11:02:26
permalink: matlab-service-install-employ
categories: 
- Matlab
tags:
- Matlab
- kaka
---


## 背景

* 硬件设备产生大量传感数据, 需要根据这些原始数据拟合出人能看懂并应用于生活的数据; 公司一直使用Matlab进行数据分析, 本文将介绍如何安装Matlab和打包测试
* 描述如何快速将项目运行起来

## 语言环境
* JDK 1.7
* IDEA (集成开发工具)

## 安装MatLab
* 版本MatlabR2014a,网上下载，并且一般自带破解文件
* 安装注意事项：1.必须断网。2.iso文件不能解压，用WinRAR打开运行setup.exe开始安装。
* 安装完成后，不要打开Matlab，先打开破解文档下的“serial”文件夹，根据自己系统的打开相应的文件夹，32 位系统请 打开“Matlab32”，64 位系统请打开“Matlab64，将打开的文件夹下的“libmwservices.dll”拷贝到你所安装的 Matlab2014a 的 bin 文件里面 替换原来所存在的“libmwservices.dll”，找到破解文件中自带的install.jar，替换掉安装目录/java/jar/install.jar。 

<!--more-->

## 运行Matlab和打包
* 编写计算代码，然后保存，如下图：
![](images/matlab/image3.png)
* 在命令行输入deploytool——>Library Compiler
![](images/matlab/image1.png)
* 注意事项：
   * **1.**如果打包失败，可以查看日志，如下图：
   * ![](images/matlab/image2.png)
   * **2.**如果日志报错是由于JDK版本问题，则很有可能环境变量配置1.8的版本，更改为1.7，重启Matlap重新打包。
   * **3.**如果matlab未完全破解也会打包失败，例如64操作系统。需要替换掉.\Matlab64\bin\win64”目录下的compiler.dll，mcc.exe，libmwservices.dll三个文件和licenses目录中的文件。
   * **4.**以管理员身份运行matlab
* 打包成功得到jar包，如下：
  ![](images/matlab/image4.png)
  ![](images/matlab/image5.png)
  ![](images/matlab/image6.png)

## 将matlab包导入IDEA进行测试
* 把multi.jar和javaBuilder.jar加入到项目中，其中javaBuilder.jar在matlab安装目录toolbox\javabuilder\jar下，看清操作系统，比如64位操作系统是toolbox\javabuilder\jar\win64\javaBuilder.jar,如下图：
  ![](images/matlab/image7.png)
* 编写测试类调用multi.jar，如下图：
  ![](images/matlab/image8.png)
* 测试代码，成功调用multi.jar，如下图：
  ![](images/matlab/image9.png)
* IDEA打包测试，按下图操作：
  ![](images/matlab/image10.png)
  ![](images/matlab/image11.png)
* Build——>Build Artifacts——>Build,打包时项目JDK一定要为1.7，matlab打包不支持1.8，如下图：
  ![](images/matlab/image12.png)
  ![](images/matlab/image13.png)
* 项目结构中会多出out目录，就是IDEA打包matlab包的所属目录，然后进入IDEA的命令行，运行jar包，如下图：
  ![](images/matlab/image14.png)
  ![](images/matlab/image15.png)


## 参考文章

* 无
