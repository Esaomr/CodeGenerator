package com.codes;

import com.baomidou.mybatisplus.core.exceptions.MybatisPlusException;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.InjectionConfig;
import com.baomidou.mybatisplus.generator.config.*;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import com.baomidou.mybatisplus.generator.config.rules.DateType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/**
 * @author lbk
 * @date 2019/12/17
 * @time 10:52
 */
public class CodeGenerator {
    public static String scanner(String tip) {
        Scanner scanner = new Scanner(System.in);
        StringBuilder help = new StringBuilder();
        help.append("请输入" + tip + "：");
        System.out.println(help.toString());
        if (scanner.hasNext()) {
            String ipt = scanner.next();
            if (StringUtils.isNotBlank(ipt)) {
                return ipt;
            }
        }
        throw new MybatisPlusException("请输入正确的" + tip + "！");
    }

    public static void main(String[] args) {
        // 代码生成器
        AutoGenerator mpg = new AutoGenerator();

        // 全局配置
        GlobalConfig gc = new GlobalConfig();
        String projectPath = System.getProperty("user.dir");
        gc.setOutputDir(projectPath + "/src/main/java");
        gc.setAuthor("lbk");
        gc.setOpen(false);
        gc.setServiceName("%sService");
        gc.setServiceImplName("%sServiceImpl");
        gc.setMapperName("%sDao");
        gc.setDateType(DateType.ONLY_DATE);
        mpg.setGlobalConfig(gc);

        // 数据源配置
        DataSourceConfig dsc = new DataSourceConfig();
        dsc.setUrl("jdbc:postgresql://14.29.114.203:6543/imp");
        dsc.setDriverName("org.postgresql.Driver");
        dsc.setUsername("jointt");
        dsc.setPassword("jointt");
        dsc.setSchemaName("jointt");
        mpg.setDataSource(dsc);

        // 包配置
        PackageConfig pc = new PackageConfig();
        pc.setModuleName(scanner("模块名称"));
        pc.setParent("com.codes");
        mpg.setPackageInfo(pc);

        // 自定义配置
        InjectionConfig cfg = new InjectionConfig() {
            @Override
            public void initMap() {

            }
        };

        // 配置自定义模板，用于生成任何自己想要的文件
        String templatePath = "/daoImpl.java.ftl";
        String templatePath2 = "/entityVo.java.ftl";
//        String templatePath3 = "/test.jsp.ftl";
        List<FileOutConfig> focList = new ArrayList<>();
        String path = "/src/main/java/com/codes/" + pc.getModuleName();
        focList.add(new FileOutConfig(templatePath) {
            @Override
            public String outputFile(TableInfo tableInfo) {
                return projectPath + path + "/mapper/xml/" + tableInfo.getEntityName() + "DaoImpl.java";
            }
        });

        focList.add(new FileOutConfig(templatePath2) {
            @Override
            public String outputFile(TableInfo tableInfo) {
                return projectPath + path + "/entity/" + tableInfo.getEntityName() + "Vo.java" ;
            }
        });

//        focList.add(new FileOutConfig(templatePath3) {
//            @Override
//            public String outputFile(TableInfo tableInfo) {
//                return projectPath + path + "/jsp/" + tableInfo.getName() + "_form.jsp" ;
//            }
//        });
//
//        focList.add(new FileOutConfig(templatePath3) {
//            @Override
//            public String outputFile(TableInfo tableInfo) {
//                return projectPath + path + "/jsp/" + tableInfo.getName() + "_index.jsp" ;
//            }
//        });
//
//        focList.add(new FileOutConfig(templatePath3) {
//            @Override
//            public String outputFile(TableInfo tableInfo) {
//                return projectPath + path + "/jsp/" + tableInfo.getName() + "_view.jsp" ;
//            }
//        });
//
//        focList.add(new FileOutConfig(templatePath3) {
//            @Override
//            public String outputFile(TableInfo tableInfo) {
//                return projectPath + path + "/js/" + tableInfo.getName() + "_form.js" ;
//            }
//        });
//
//        focList.add(new FileOutConfig(templatePath3) {
//            @Override
//            public String outputFile(TableInfo tableInfo) {
//                return projectPath + path + "/js/" + tableInfo.getName() + "_index.js" ;
//            }
//        });

        cfg.setFileOutConfigList(focList);
        mpg.setCfg(cfg);

        // 设置 mvc 的模板，模板位于 resources 下
        TemplateConfig templateConfig = new TemplateConfig();
        templateConfig.setController("controller.java");
        templateConfig.setService("service.java");
        templateConfig.setServiceImpl("serviceImpl.java");
        templateConfig.setMapper("mapper.java");
        templateConfig.setEntity("entity.java");
        templateConfig.setXml(null);
        mpg.setTemplate(templateConfig);

        // 策略配置
        StrategyConfig strategy = new StrategyConfig();
        strategy.setNaming(NamingStrategy.underline_to_camel);
        strategy.setColumnNaming(NamingStrategy.underline_to_camel);
        strategy.setSuperEntityClass("framework.jointt.ems.entity.BaseEntity");
        strategy.setSuperServiceClass(null);
        strategy.setSuperServiceImplClass(null);
        strategy.setSuperServiceClass("com.jointt.ems.core.service.commonality.AbstractService");
        strategy.setSuperMapperClass("framework.jointt.ems.dao.GenericDao");
        strategy.setSuperControllerClass("com.jointt.ems.web.action.AbstractController");
        strategy.setSuperEntityColumns("id");
        strategy.setInclude(scanner("表名,多个以英文逗号分隔").split(","));
        strategy.setControllerMappingHyphenStyle(true);
        strategy.setTablePrefix(pc.getModuleName() + "_");
        mpg.setStrategy(strategy);
        mpg.setTemplateEngine(new FreemarkerTemplateEngine());
        mpg.execute();
    }
}
