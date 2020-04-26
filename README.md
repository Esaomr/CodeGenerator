## 项目说明
本项目采用SpringBoot + Mybatis + 笔者最佳实践构建，适用于做毕设、微型项目等。本项目非多模块化设计，所以不适用于多个Web工程的场景。

## 控制层

- 控制层的包名建议采用`api.模块.XxxController`。
- 控制层建议不捕获异常（除项目中自定义的BusinessException除外），如有IOException等强制捕获异常应当直接往外抛。
- 控制层所有的Controller都应当继承`BaseController`，便于通用的异常处理和相关信息的获取（如日志对象log)。

## 服务层

- 服务层包名建议采用`service.模块.XxxService`格式定义。
- 服务层建议不捕获异常（交给Controller处理），当出现业务异常时（如手机号码已被注册）应当抛出项目中自定义的BusinessException。

## 持久层

- 持久层建议采用MyBatis Generator自动生成对应的Mapper和Model（实体类）

## Mybatis Generator
1. 创建Maven build，并将`Commant Line`设置为`mybatis-generator:generate`。
2. 修改`generator.properties`中的数据库配置，驱动包地址建议不进行修改，而通过将驱动包拷贝至`generator`目录下来完成。
3. 修改`generator.properties`中的`model.package(实体类存放包名)`、`dao.package(Mapper类存放包名)`、`table.name(需要生成的表名)`
4. 执行创建好的Maven build即可。

## 异常处理

> 在`BaseController`中进行了全局异常捕获(BaseController.exceptionHandler)，这也是为什么我们建议`Controller`不进行异常捕获的原因。

## 环境分离

> 为了避免生产环境的数据库信息、服务器信息、OSS信息等重要信息不泄漏给开发人员，我们不建议采用SpringBoot的profile方式来做环境分离，而采用`-Dspring.config.location`的指定配置文件的方式来实现。

## 日志处理
使用SpringBoot官方推荐的logback作为日志框架，通过`logback.xml`对日志进行配置，项目中的日志分为两个环境——开发环境(development)和生产环境(production)。在我们的预想中，测试环境推荐采用生产环境的配置

> 项目中通过配置`project.env`来设置日志的appender，你也可以直接修改`logback.appender`属性达到同样的目的。

## 单元测试
使用SpringBoot自带的jUnit测试框架，我们为单元测试封装了`BaseTest.java`，所有的单元测试类均需要集成该类。

> 封装`BaseTest`的目的是便于在升降SpringBoot时做调整，通过注解可继承的特性我们也不需要在每个测试类添加测试注解，同时`BastTest`还封装了`print`方法用于打印测试结果。