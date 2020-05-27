package ${package.Service};

import ${package.Entity}.${entity};
import ${superServiceClassPackage};
import ${superMapperClassPackage};
import com.jointt.ems.web.ui.DataGrid;
import javax.servlet.http.HttpServletResponse;
import framework.jointt.ems.page.Pagination;
import java.util.List;
import java.util.Map;
/**
 * <p>
 * ${table.name} 服务类
 * </p>
 *
 * @author ${author}
 * @date ${date}
 */
<#if kotlin>
interface ${table.serviceName} : ${superServiceClass}<${entity}>
<#else>
public interface ${table.serviceName} extends ${superServiceClass}<${entity}, ${table.mapperName}>{

    /**
     * 查询 DataGrid
     *
     * @param pagination 分页对象
     * @param parametersMap 请求参数
     * @return DataGrid
     */
    DataGrid getDataGrid(Pagination pagination, Map<String, Object> parametersMap);

}
</#if>
