title: Nexus+IDEA+Maven搭建手册
date: 2018-08-14 17:00:00
permalink: nexus-idea-maven-manual
categories: 
- Nexus
tags:
- Nexus
- Maven
- IDEA
- 建栋
---


## 背景

目前我司私服Nexus可以直接访问,后续会存储一些更敏感的数据,所以需要进行授权访问，本文将介绍在Windows平台如何搭建Nexus私服和基于IDEA+Maven使用手册。

## 语言环境
* JDK 1.8
* IDEA (集成开发工具)
* Nexus 3.13.0

## 关键点
* 搭建Nexus私服, 并能使用Maven命令上传构件包(jar) 
* 使用浏览器访问私服前端页面
* 需要登录后才可看到私服上存储的相关构件 
* 项目jar依赖的构件能从私服获取

<!--more-->

## 一、Nexus搭建与配置
### 1.下载Nexus
Nexus 专业版是需要付费的，这里我们下载开源版 Nexus OSS 3.x版本。下载地址:https://www.sonatype.com/download-oss-sonatype
![](images/nexus/1.png)
### 2.安装
解压nexus-3.13.0-01-win64.zip，得到以下目录
1.nexus-3.13.0-01   //nexus程序
2.sonatype-work     //数据，备份nexus的时候可以备份这个文件夹
### 3.配置系统环境变量
新建系统变量，如下图：
![](images/nexus/2.png)
编辑系统变量Path,加入%NEXUS%\bin\;
### 4.启动Nexus
以管理员运行cmd，输入命令nexus /install，控制台输出如下：
`PS D:\ProgramFiles\nexus-3.13.0-01\bin> nexus /install`
`Stopping service 'nexus'.`
`Service stopped`
`Installed service 'nexus'.`

常用命令

* nexus.exe /install 安装nexus为系统服务
* nexus.exe /uninstall 卸载nexus为系统服务
* nexus.exe /start 启动nexus服务
* nexus.exe /stop 停止nexus服务

`注意：必须以管理员运行cmd，否则会报错：Could not stop service.`

输入命令nexus.exe /start 启动后，浏览器访问：http://localhost:8081/ 即可访问Nexus私服仓库管理后台。
![](images/nexus/3.png)
点击右上角Sign in登录，`默认管理员账号：admin/admin123`

`Nexus仓库管理后台默认端口号是8081，可以在Nexus安装目录下etc\nexus-default.properties修改`

到这里，我们已经完成了Nexus安装和启动，下面对Nexus管理后台的基本使用说明和用户访问权限相关配置。
## 二、Nexus管理后台配置
### 1.Nexus仓库管理
登录Nexus管理后台后，点击Server adminIstration configuration图标-》Repositories，进入仓库管理页面，如下图：
![](images/nexus/4.png)
![](images/nexus/5.png)

图中Nexus默认创建了7个仓库，分别有3种仓库类型，这里简单介绍下几种repository的类型：
`hosted，本地仓库，通常我们会部署自己的构件到这一类型的仓库。比如公司的第二方库。`
`proxy，代理仓库，它们被用来代理远程的公共仓库，如maven中央仓。`
`group，仓库组，用来合并多个hosted/proxy仓库，当你的项目希望在多个repository使用资源时就不需要多次引用了，只需要引用一个group即可。`

我们前面讲到类型为hosted的为本地仓库，Nexus预置了3个本地仓库，分别是Releases, Snapshots, nuget-hosted. 分别讲一下这三个预置的仓库都是做什么用的

Releases：这里存放我们自己项目中发布的构建,通常是Release版本的,比如我们自己做了一个FTP Server的项目,生成的构件为ftpserver.war,我们就可以把这个构建发布到Nexus的Releases本地仓库. 关于符合发布后面会有介绍.

Snapshots：这个仓库非常的有用,它的目的是让我们可以发布那些非release版本,非稳定版本, 比如我们在trunk下开发一个项目,在正式release之前你可能需要临时发布一个版本给你的同伴使用,因为你的同伴正在依赖你的模块开发,那么这个时候我们就可以发布Snapshot版本到这个仓库,你的同伴就可以通过简单的命令来获取和使用这个临时版本.

### 2.访问认证&Nexus账户管理
默认情况下，Nexus开启匿名用户可访问仓库，例如：直接访问仓库URL地址就能看到仓库的所有jar包，为了保证我司内部员工安全使用，取消匿名用户访问。

* 取消匿名访问：点击左侧菜单Security->Anonymous,取消勾选复选框，点击Save保存。如下图：
![](images/nexus/6.png)

* 为开发同事创建账号，在左侧菜单展开Security，点击Users-》Create local user，创建新用户jayden
![](images/nexus/7.png)
`重要字段说明：`
`ID：用户账户名`
`Status：Active/Disabled 启用/禁用 `
`Roles：系统默认有nx-admin,nx-anonymous两种角色。nx-admin权限最大，等同admin账号。nx-anonymous为匿名游客权限，只能访问仓库。如果需要更多角色Role，可以在Security Roles创建。`
好了，到这里已经把Nexus基本配置完成，下面对Nexus进行上传和下载jar包使用说明。

## 三、利用Nexus私服，进行上传和下载jar包
### 1.远程仓库的认证
出于安全方面的考虑，上一步我们开启了认证信息才能访问的仓库。配置认证信息，进入maven安装目录\conf，配置在settings.xml文件中。如下：在settings.xml中配置<servers>节点，用的账号为上面我们创建的账户。
```
<servers>
    <server>
      <id>nexus</id>
      <username>jayden</username>
      <password>123456</password>
    </server>
  </servers>
  ```
上面代码配置了一个id为nexus的远程仓库认证信息。认证用户名为jayden，认证密码为123456。
`备注：这里的关键是id元素，id没有要求，随便定义，但是后面配置远程仓库的id必须和这里的id保持一致。`

### 2.上传jar包
* 在IDEA创建一个Maven java项目，groupId=com.gyenno.common；artifactId=gyenno-common;Version=1.0-SNAPSHOT

* 创建一个class，类名为com.gyenno.common.NexusTest,代码如下：
![](images/nexus/8.png)

* 修改工程项目pom.xml文件，配置发布到私服，如下图：
![](images/nexus/9.png)
* 在IDEA中，输入快捷键Alt+F12，打开Terminal，并输入`mvn deploy` 编译并部署项目，此时控制台输出如下:
![](images/nexus/10.png)
maven编译打包了gyennocommon项目，并把打包gyenno-common-1.0-20180814.113529-1.jar上传到了maven-snapshots仓库；
通过浏览器访问：http://localhost:8081/#browse/browse:maven-snapshots
仓库里有刚刚控制台输出上传的jar包，说明我们通过maven deploy命令已完成上传jar包。
![](images/nexus/11.png)

`备注：如果像把jar包上传到maven-releases仓库，把pom.xml中的version版本号“-SNAPSHOT”去掉就好。 执行命令mvn deploy时，maven会根据“-SNAPSHOT”来判断发布到maven-snapshots仓库，还是会发布到maven-releases仓库`

### 3.下载jar包
* 在IDEA创建一个Maven java项目，groupId=com.gyenno.test；artifactId=gyenno-test;Version=1.0-SNAPSHOT
* 修改工程项目pom.xml文件，配置私服仓库和添加上一步上传的gyenno-common的包依赖，如下pom.xml
![](images/nexus/12.png)
在上图中左侧IDEA的External Libraries可以看到，Maven:com.gyenno.common:gyenno-common:1.0-SNAPSHOT,说明jar包已成功下载并引入到项目中。我们可以通过代码调用jar包中的com.gyenno.common.NexusTest.echo(String msg) 方法来看看。
* 在创建一个Test类，实现main方法，代码如下：
```
public class Test {
	public static void main(String[] args) {
		System.out.println(com.gyenno.common.NexusTest.echo("你好!!"));
	}
}
```
执行main方法结果如下图：
![](images/nexus/13.png)

到此我们完成了下载依赖的jar包。
`备注：修改pom.xml时，IDEA没有自动执行maven加载所依赖的jar包，需要通过鼠标选中pom.xml，右键-》maven-》执行Reimport  即可`

## 参考文章

* [nexus3.1私服搭建](https://blog.csdn.net/qqqqq210/article/details/52993337)
* [Maven入门：使用Nexus搭建Maven私服及上传下载jar包](https://www.cnblogs.com/tyhj-zxp/p/7605879.html)