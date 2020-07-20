package ${package.Mapper};

import ${package.Mapper}.${table.mapperName};
import ${superMapperClassPackage}Impl;
import org.springframework.stereotype.Repository;
import framework.jointt.ems.page.Pagination;
import org.hibernate.Query;
import org.apache.commons.lang3.StringUtils;
import java.util.Map;
/**
 * @author ${author}
 * @date ${date}
 */
@Repository
<#if kotlin>
open class ${table.mapperImplName} : ${superMapperImplClass}<${table.mapperName}, ${entity}>(), ${table.mapperName} {

}
<#else>
public class ${table.mapperName}Impl extends ${superMapperClass}Impl<${entity}, String> implements ${table.mapperName} {

    @Override
    public Pagination findPage(Pagination pagination, Map<String, Object> parametersMap) {
        StringBuffer sb = new StringBuffer();
        sb.append("FROM ${entity} temp WHERE 1=1");
        if(parametersMap.containsKey("epId") && StringUtils.isNotBlank(parametersMap.get("epId").toString())){
            sb.append(" AND temp.enterpriseId = :epId");
        }
        if(parametersMap.containsKey("name") && StringUtils.isNotBlank(parametersMap.get("name").toString())){
            sb.append(" AND temp.name like '%" + parametersMap.get("name") + "%'");
        }
        sb.append(" ORDER BY id");
        return findPage(sb.toString(), pagination, parametersMap);
    }
}
</#if>