title: Maven和SBT配置Nexus远程仓库的认证
date: 2018-08-15 13:00:00
permalink: maven-sbt-config-account
categories: 
- Nexus

tags:
- Scala
- Maven
- SBT
- Nexus
- 建栋
- 天生
---


## 背景
一般情况我们本地的Nexus仓库都是有网关密码的，不能随便访问，因此如果Maven或SBT下载和上传jar包的时候需要配置远程仓库的认证，下面介绍如何使用Maven或SBT构建项目时需要做的授权认证配置。

## 语言环境
* JDK1.8
* Nexus 3.12.1
* Maven 3.5.4
* SBT 1.1.6

## 关键点
* 配置Maven访问Nexus远程仓库的认证
* 配置SBT访问Nexus远程仓库的认证

<!--more-->

## 配置Maven访问Nexus远程仓库的认证
进入maven安装目录\conf，在settings.xml文件中找到`<servers>`标签，添加以下内容：
```
<servers>
    <server>
      <id>gyenno-central</id>
      <username>developer</username>
      <password>GYENNO.sz@2018</password>
    </server>
</servers>
```
上面代码配置了一个id为gyenno-central的远程仓库认证信息，认证用户名为developer，认证密码为GYENNO.sz@2018。
`备注：这里的关键是id元素，id没有要求，随便定义，但是后面工程项目配置pom.xml远程仓库的id必须和这里的id保持一致。`

## 配置SBT访问Nexus远程仓库的认证
SBT有两种配置方式

### 方案一

在工程项目找到build.sbt加上这么一行：

```
credentials += Credentials("Sonatype Nexus Repository Manager", "nexus.gyenno.com", "developer", "GYENNO.sz@2018")
```

### 方案二

***采用该方案: 方便统一配置及安全***

用户目录下新建(如不存在)目录`.sbt`, 在该目录内部新建文件`.credentials`, 内容如下: 

```
realm=Sonatype Nexus Repository Manager
host=nexus.gyenno.com
user=developer
password=GYENNO.sz@2018
```

编辑当前项目的`build.sbt`文件, 在文件底部新增如下语句: 

```
credentials += Credentials(Path.userHome / ".sbt" / ".credentials")
```

注: 文件存放的位置需要与`build.sbt`中引用的文件位置一致

## 参考文章

* [Sbt构建工具常用操作](https://www.jianshu.com/p/9494aecebc8d)
* [Nexus+IDEA+Maven搭建手册](http://blog.gyenno.com/nexus-idea-maven-manual.html)
* [Publish SBT project to Maven repo(Nexus?)](https://afoo.me/posts/2014-07-11-publish-sbt-project-to-maven-repo.html)
