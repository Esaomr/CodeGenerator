package ${package.Mapper};

import ${package.Entity}.${entity};
import ${superMapperClassPackage};
import framework.jointt.ems.page.Pagination;
import java.util.Map;
/**
 * <p>
 * ${table.name} 接口
 * </p>
 *
 * @author ${author}
 * @since ${date}
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
     * @return DataGrid
     */
    Pagination find${entity}Page(Pagination pagination, Map<String, Object> parametersMap);
}
</#if>
