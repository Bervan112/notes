title: Flyway规范
date: 2018-08-31 15:50:26
permalink: flyway-specification
categories: 
- 规范
tags:
- 云服务部
- 建栋
---

## 背景

Flyway是一款开源的数据库版本管理工具，它更倾向于规约优于配置的方式。

Flyway可以独立于应用实现管理并跟踪数据库变更，支持数据库版本自动升级，并且有一套默认的规约，不需要复杂的配置，Migrations可以写成SQL脚本，也可以写在Java代码中，不仅支持Command Line和Java API，还支持Build构建工具和Spring Boot等，同时在分布式环境下能够安全可靠地升级数据库，同时也支持失败恢复等。

[https://flywaydb.org/documentation/migrations](https://flywaydb.org/documentation/migrations)

<!--more-->

## SQL文件命名规范

版本号__描述.sql

V: 版本控制

U：撤销

R：可重复执行

`V{version}_{date}_{num}__{type}_{description}_{Author}.sql`

例如： `V5_1_0_20180914_1__DDL_alter_table_medicinenames_qiaotiansheng`

详细说明：

version : 需求版本号 （2.3.3、2.4.0）

date: 提交日期20180507

num: 开发人员自由命名，格式必须为数字

type: sql文件类型  DML 数据更新(插入、更新、删除); DDL 结构更新; DCL 权限控制；

description: 文件描述

Author: 开发人员姓名

## SQL文件规范

1. 插入新数据，建议使用Replace替代Insert，但需要保证插入的数据是完整且包含主键，否则未包含的列自动置为空值

2. 创建视图建议使用Create OR Replace，可多次执行不报错

3. 批量插入数据，建议关闭外键检查和自动提交，如下SQL：
   ```
   -- 关闭外键检查
   SET foreign_key_checks = 0;
   -- 关闭自动提交
   SET AUTOCOMMIT=0;
   -- 开始事务
   begin;
   
   insert into xxxxxx(c1,c2,c3) values (v1,v2,v3),(v1,v2,v3)...
   
   -- 提交事务
   COMMIT;
   ```
4. SQL文件已经提交之后，不得修改，否则会导致校验失败

5.  添加外键的SQL，一定要加上外键名称， 没有名称系统会默认生成，会导致各环境外键名不一致，就无法删除外键了。添加外键
alter table locstock add foreign key locstock_ibfk2(stockid) references product(stockid)
locstock 为表名, locstock_ibfk2 为外键名 第一个括号里填写外键列名, product为表名,第二个括号里是写外键关联的列名

6. 为保证量表相关业务在单机版、云端版之间的一致性， 不得通过量表ID来进行操作；相关操作全部改成通过量表英文名称（GAUGE_NAME_EN）来执行；新增量表时GAUGE_NAME_EN必填，且唯一。量表题目通过量表GAUGE_NAME_EN+题号来确定。 量表答案通过GAUGE_NAME_EN+题号+答案sort（1,2,3）来确定。


## 修复校验错误

* 测试环境： /gyenno/src/ruiyun/flyway-5.1.1
* 开发环境: /opt/gyenno/project/flyway-5.1.1

将所有的sql文件拷贝到 sql目录下，执行 ./flyway repair




