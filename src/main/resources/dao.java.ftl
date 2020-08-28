package ${package.Mapper};

import ${package.Entity}.${entity};
import ${superMapperClassPackage};
import framework.jointt.ems.page.Pagination;
import java.util.Map;
/**
 * ${cfg.annotation}(${table.name}) 接口
 *
 * @author ${author}
 * @date ${date}
 */
<#if kotlin>
interface ${table.mapperName} : ${superMapperClass}<${entity}>
<#else>
public interface ${table.mapperName} extends ${superMapperClass}<${entity}, String> {

    /**
     * 查询 DataGrid
     *
     * @param pagination 分页对象
     * @param parametersMap 请求参数
     * @return 分页对象
     */
    Pagination findPage(Pagination pagination, Map<String, Object> parametersMap);
}
</#if>
