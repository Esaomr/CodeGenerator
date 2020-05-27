package ${package.ServiceImpl};

import ${package.Entity}.${entity};
import ${package.Mapper}.${table.mapperName};
import ${package.Service}.${table.serviceName};
import ${superServiceImplClassPackage};
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.apache.poi.ss.usermodel.Workbook;
import org.jeecgframework.poi.excel.ExcelExportUtil;
import org.jeecgframework.poi.excel.entity.ExportParams;
import org.jeecgframework.poi.excel.entity.params.ExcelExportEntity;
import framework.jointt.ems.page.Pagination;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import com.jointt.ems.web.ui.DataGrid;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * @author ${author}
 * @since ${date}
 */
@Service
public class ${table.serviceImplName} extends ${superServiceClass}Impl<${entity}, ${table.mapperName}> implements ${table.serviceName} {

    @Autowired
    private ${entity}Dao ${table.name}Dao;

    @Override
    public DataGrid getDataGrid(Pagination pagination, Map<String, Object> parametersMap) {
        if (pagination == null) {
            pagination = new Pagination();
        }
        pagination = ${table.name}Dao.find${entity}Page(pagination, parametersMap);
        return new DataGrid(pagination.getTotalCount(), pagination.getResult());
    }

}
