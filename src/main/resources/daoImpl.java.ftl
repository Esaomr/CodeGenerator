package ${package.Mapper};

import ${package.Mapper}.${table.mapperName};
import ${superMapperClassPackage}Impl;
import org.springframework.stereotype.Repository;
import framework.jointt.ems.page.Pagination;
import org.hibernate.Query;
/**
 * <p>
 * ${table.name}
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
@Repository
<#if kotlin>
open class ${table.mapperImplName} : ${superMapperImplClass}<${table.mapperName}, ${entity}>(), ${table.mapperName} {

}
<#else>
public class ${table.mapperName}Impl extends ${superMapperClass}Impl<${entity}, String> implements ${table.mapperName} {

     /**
     * 查询DataGrid
     *
     * @param pagination
     * @param parametersMap
     * @return
     */
    @Override
    public Pagination find${entity}Page(Pagination pagination, Map<String, Object> parametersMap) {
        StringBuffer sb = new StringBuffer();
        sb.append("FROM ${entity} temp WHERE 1=1");
        if(parametersMap.containsKey("epId") && StringUtils.isNotBlank(parametersMap.get("epId").toString())){
            sb.append(" AND temp.enterpriseId = :epId");
        }
        if(parametersMap.containsKey("name") && StringUtils.isNotBlank(parametersMap.get("name").toString())){
            sb.append(" AND temp.name like '%" + parametersMap.get("name") + "%'");
        }
        Long count = count(sb.toString(), parametersMap);
        pagination.setTotalCount(count);
        sb.append(" ORDER BY id");
        Query query = createQuery(sb.toString(), parametersMap);
        setPageParameterToQuery(query, pagination);
        List<${entity}> result = (List<${entity}>) query.list();
        pagination.setResult(result);
        return pagination;
    }
}
</#if>