title: HTTP断点续传
date: 2018-07-19 11:52:39
permalink: http-break-point-resume
categories: 
- Java
tags:
- Java
- Slice
- 望智
---


## 背景

* 断点上传能够防止意外情况导致上传未完成的文件在下次上传时还要重新上传
* 描述HTTP文件分片上传，断点续传的服务端实现

## 语言环境
* JDK 1.8
* IDEA (集成开发工具)

## 关键点
* 前端对文件分片处理，按分片发送上传请求
* 每上传完一个分片，服务端标识分片上传状态
* 服务端根据分片上传状态处理分片上传请求
* 完成所有分片上传后合并文件
    
<!--more-->

## 实现过程

1.搭建SpringMVC项目

* 项目结构如下图: 

    ![](images/upload/u1.png) 

* 配置支持文件上传
```
<!-- 支持文件上传 -->
<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
	<!-- 请求编码格式 -->
	<property name="defaultEncoding" value="utf-8"></property>
	<!-- 缓冲区大小(单位:KB) -->
	<property name="maxInMemorySize" value="1024"></property>
</bean>
```

* 创建数据库表用于保存文件上传记录及分片上传状态
```
CREATE TABLE `file_pro` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(100) NOT NULL COMMENT '文件名',
  `filePath` varchar(200) DEFAULT '' COMMENT '文件路径',
  `fileUrl` varchar(255) DEFAULT NULL COMMENT '文件url',
  `description` varchar(255) DEFAULT NULL COMMENT '描述信息',
  `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
  `fileId` varchar(100) DEFAULT NULL COMMENT '文件ID',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `status` int(1) DEFAULT '0' COMMENT '是否上传成功状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COMMENT='上传文件表';

CREATE TABLE `file_slice` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `fileId` varchar(100) NOT NULL COMMENT '文件id',
  `filePath` varchar(200) DEFAULT '' COMMENT '文件路径',
  `sliceIndex` int(11) DEFAULT '0' COMMENT '文件分片索引',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `status` int(1) DEFAULT '0' COMMENT '是否上传成功状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4705 DEFAULT CHARSET=utf8 COMMENT='文件分片表';
```

2.上传文件前检查文件是否已上传

* 根据文件md5值，判断文件是否存在
```
in = file.getInputStream();
md5 = DigestUtils.md5Hex(IOUtils.toByteArray(in));
```

* 若文件已经存在，返回相应信息，若不存在，设置文件初始信息，如md5，uuid等并返回
```
String md5 = FileMd5Util.getFileMD5(multipartFile);
List<FilePro> list = fileService.queryByMD5(md5);
FilePro filePro = null;
if (list == null || list.size() == 0) {
    //没有上传过文件
    filePro = new FilePro();
    String uuid = UUID.randomUUID().toString();
    filePro.setStatus(0);
    filePro.setMd5(md5);
    filePro.setFileId(uuid);
} else {
    filePro = list.get(0);
}
result = new Result(true, filePro);
return result;
```

3.前端将文件分片上传，服务端获取相应参数,如分片总数，当前分片序号等
```
@RequestMapping(value = "/upload", method = RequestMethod.POST)
@ResponseBody
public Result uploadFile(HttpServletRequest request, @RequestParam(value = "file") MultipartFile multipartFile){...}
```
4.根据分片状态处理请求

* 判断是否分片已经上传，已上传完成的直接返回
```
List<Integer> indexList = fileService.querySliceIndexByFileId(uuid);
if(indexList.contains(index)){
    result.setSuccess(true);
    result.setMessage("分片已上传");
    return result;
}
```
* 未上传的完成上传并保存上传记录，标识分片上传状态
```
multipartFile.transferTo(new File(saveDirectory, uuid + "_" + index));
//文件分片首次上传,保存文件上传记录
if(index == 0){
    saveFilePro(fileName, root, uuid, fileMd5);
}
saveFileSlice(saveDirectory, uuid, index); //分片上传记录
```

5.所有分片上传完成后，合并文件
```
for (int i = 0; i < total; i++) {
    temp = new FileInputStream(new File(saveDirectory, uuid + "_" + i));
    while ((len = temp.read(byt)) != -1) {
        outputStream.write(byt, 0, len);
    }
}
```

## 参考文章

* 无