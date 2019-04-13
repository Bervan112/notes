title: Swagger使用手册
date: 2018-07-05 14:25:00
permalink: swagger-using-manual
categories: 
- 规范
tags:
- Swagger
- Restful
- 天生
---


## 背景

目前臻络科技新型架构的文档使用`swagger`进行描述, 该文档描述如何使用swagger.


## 文档地址

```
# 开发环境 - 医动力v4
http://appdev.gyenno.com/service_im_dev/v3/swagger

# 开发环境 - 臻络服务v5
http://appdev.gyenno.com/service_im_dev/ydl_center/v3_1/swagger


# 测试环境 - 医动力v4
http://apptest.gyenno.com/service_im_test/v3/swagger

# 测试环境 - 臻络服务v5
http://apptest.gyenno.com/service_im_test/ydl_center/v3_1/swagger

# 生产环境

```

<!--more-->

## 主界面

主界面描述了`业务分类`, `业务接口`, `接口方法(GET, PUT, POST, DELETE)`, `是否需要授权才可访问(即header中携带token)`; 

如下图: 

![](images/swagger/s1.png) 

## token格式

1. 置于`http request header`中
2. `name`使用`Authorization`, `value`格式如下:
	* Bearer + " " + token (注: 中间必须有个空格)

例如: 
```
Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJvcmdUeXBlIjoxLCJzdWIiOiIxNTgxNDc1MTc3MiIsInVzZXJUeXBlIjoyLCJleHAiOjE1MTc5MDUyMDAsInVzZXJJZCI6MTAwMCwib3JnSWQiOjJ9.6Z669xIW_zkaqghsC4Mv4l4LQeRT90PFY2DzYHoVAeI
```

## 数据结构和参数是否必选说明

数据结构: 

* $int32: 整型
* $int64: 长整型
* []: 数组类型
* string: 字符串类型

任何地方的参数只要有`红色 *`就代表该参数为必填; 部分接口为了实现支持多功能, 需要根据文字描述进行填写.

**以上描述同样适用于接口调用的响应参数**

## REST 架构中参数类型描述
 
* query: url中`?`后的参数, 例如: /users?pageNo=2&pageSize=10
* path: url中的值, 例如: /users/1001
* body: http post/put的requestBody, 例如: {"name": "AC", "age": 20}
* header: http header中的参数

## swagger Request描述

### 默认
![](images/swagger/s2.png)  

此时可观察到调用接口时需要使用的参数样例;

### 参数描述

![](images/swagger/s3.png) 

点击`Model`, 可观察到调用参数的数据结构和是否必选;


## swagger Response描述

### 默认

![](images/swagger/s4.png)

此时可观察到调用接口时返回的结果样例;

### 参数描述

![](images/swagger/s5.png)

点击`Model`, 可观察到返回结果的数据结构和是否一定会返回;

### 异常描述

本架构参考`github`的API进行设计, 业务执行成功`http status`为`200`并且响应结构根据响应数据结构进行描述; 业务执行未成功`http status`为`4xx/5xx`; 具体查看文档描述.

### http status code

* 200: 业务执行成功
* 400: 调用接口入参有误
* 401: 认证失败, token已过期
* 403: 授权失败, token权限不足
* 404: 资源不存在
* 409: 资源冲突


