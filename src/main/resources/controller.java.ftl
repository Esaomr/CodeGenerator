package ${package.Controller};

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.apache.commons.lang3.StringUtils;
import framework.jointt.ems.utils.excel.ExcelUtils;
import framework.jointt.ems.page.Pagination;
import com.jointt.ems.web.ui.PageRequest;
import com.jointt.ems.web.constant.MessageStatus;
import com.jointt.ems.web.ui.DataGrid;
import com.jointt.ems.web.ui.JsonModel;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.List;

<#if restControllerStyle>
import org.springframework.web.bind.annotation.RestController;
<#else>
import org.springframework.stereotype.Controller;
</#if>
<#if superControllerClassPackage??>
import ${superControllerClassPackage};
</#if>

/**
 * <p>
 * ${table.name} 控制器
 * </p>
 *
 * @author ${author}
 * @date ${date}
 */
<#if restControllerStyle>
@RestController
<#else>
@Controller
</#if>
@RequestMapping("<#if package.ModuleName??>/${package.ModuleName}</#if>/<#if controllerMappingHyphenStyle??>${controllerMappingHyphen}<#else>${table.entityPath}</#if>")
<#if kotlin>
class ${table.controllerName}<#if superControllerClass??> : ${superControllerClass}()</#if>
<#else>
<#if superControllerClass??>
public class ${table.controllerName} extends ${superControllerClass} {
<#else>
public class ${table.controllerName} {
</#if>

    private static Logger logger = LoggerFactory.getLogger(${table.controllerName}.class);

    private final String PAGE_PREFIX = "/${package.ModuleName}/${table.entityPath}/";
    private final String INDEX_PAGE = PAGE_PREFIX + "${table.name}_index";
    private final String FORM_PAGE = PAGE_PREFIX + "${table.name}_form";
    private final String VIEW_PAGE = PAGE_PREFIX + "${table.name}_view";

    @Autowired
    private ${table.serviceName} ${table.name}Service;

    @Autowired
    private EnterpriseService enterpriseService;

    /**
     * 跳转到主页
     *
     * @return 主页路径
     */
    @RequestMapping(value = "index")
    public String index() {
        return INDEX_PAGE;
    }

    /**
     * 跳转到新增页
     *
     * @return 表单页路径
     */
    @RequestMapping(value = "addForm")
    public String addFrom(HttpServletRequest request) {
        request.setAttribute("action", "${package.ModuleName}/${table.entityPath}/insert");
        return FORM_PAGE;
    }

    /**
     * 跳转到修改页
     *
     * @return 表单页路径
     */
    @RequestMapping(value = "editForm")
    public String editFrom(HttpServletRequest request) {
        String emId = request.getParameter("id");
        ${entity} ${table.name} = ${table.name}Service.getById(emId);
        request.setAttribute("${table.name}", ${table.name});
        request.setAttribute("action", "${package.ModuleName}/${table.entityPath}/update");
        return FORM_PAGE;
    }

    /**
     * 跳转到视图页
     *
     * @return 视图页路径
     */
    @OperateResourceCode(operateCode = "view", resourceCodeList = {"${table.name}", "senior${entity}"})
    @RequestMapping(value = "view")
    public String view(String id) {
        ${entity} ${table.name} = ${table.name}Service.getById(id);
        request.setAttribute("${table.name}", ${table.name});
        return VIEW_PAGE;
    }

    /**
     * 查询 DataGrid
     *
     * @return
     */
    @OperateResourceCode(operateCode = "view", resourceCodeList = {"${table.name}","senior${entity}"})
    @RequestMapping(value = "datagrid")
    @ResponseBody
    public DataGrid dataGrid(Pagination pagination) {
        Map<String, Object> parametersMap = ServletUtils.getParametersStartingWith(request, null);
        dataGrid = ${table.name}Service.getDataGrid(pagination, parametersMap);
        return dataGrid;
    }

    /**
     * 新增操作
     *
     * @return 提示信息
     */
    @OperateResourceCode(operateCode = "create", resourceCodeList = {"${table.name}", "senior${entity}"})
    @RequestMapping(value = "insert")
    @ResponseBody
    public JsonModel insert(${entity} ${table.name}) {
        try {
            ${entity} temp = ${table.name}Service.save(${table.name});
            if (null != temp && null != (temp.getId())) {
                json = JsonModel.success("新增成功！！！");
            } else {
                json = JsonModel.error("新增失败！！！");
            }
        } catch (Exception e) {
            logger.error(LogExceptionStackUtil.LogExceptionStack(e));
            json = JsonModel.error("新增失败！！！错误如下：" + e.getMessage());
            e.printStackTrace();
        }
        return json;
    }

    /**
     * 修改操作
     *
     * @param ${table.name} 要更新的实体类对象
     * @return 提示信息
     */
    @OperateResourceCode(operateCode = "edit", resourceCodeList = {"${table.name}", "senior${entity}"})
    @RequestMapping(value = "update")
    @ResponseBody
    public JsonModel update(${entity} ${table.name}) {
        try {
            ${entity} temp =  ${table.name}Service.update(${table.name});
            if (temp != null && temp.getId() != null) {
                json = JsonModel.success("修改成功！！！");
            } else {
                json = JsonModel.error("修改失败！！！");
            }
        } catch (Exception e) {
            logger.error(LogExceptionStackUtil.LogExceptionStack(e));
            json = JsonModel.error("修改失败！！！错误如下：" + e.getMessage());
            e.printStackTrace();
        }
        return json;
    }

    /**
     * 根据 id 单个或批量删除
     *
     * @return 提示信息
     */
    @OperateResourceCode(operateCode = "delete", resourceCodeList = {"${table.name}", "senior${entity}"})
    @RequestMapping(value = "delete")
    @ResponseBody
    public JsonModel delete(String ids) {
        try {
            int temp = ${table.name}Service.batchDelete(ids);
            if(temp > 0) {
                json = JsonModel.success("删除成功！！！");
            }else{
                json = JsonModel.error("删除不成功！！！");
            }
        } catch (Exception e) {
            logger.error(LogExceptionStackUtil.LogExceptionStack(e));
            json = JsonModel.error("删除失败！！！");
            e.printStackTrace();
        }
        return json;
    }

    /**
     * 导出成Excel表
     *
     * @throws Exception
     */
    @RequestMapping(value = "exportExcel")
    public void exportExcel(String ids, String epId, HttpServletResponse response) throws Exception {
        List<${entity}> list = null;
        if(StringUtils.isNotBlank(ids)){
            list = ${table.name}Service.getListByIds(ids);
        } else {
            list = ${table.name}Service.read();
        }
        Enterprise enterprise = enterpriseService.get(epId);
        String fileName = enterprise.getName() + "自定义";
        ExcelUtils.exprotExcel(fileName, new ExportParams("自定义", "自定义"), list, ${entity}.class, response);
    }

    /**
     * 导入excel
     *
     * @param epId 企业id
     */
    @ResponseBody
    @RequestMapping(value = "importExcel")
    public JsonModel importExcel(String epId) throws Exception {
        try {
            List<${entity}> list = ExcelUtils.importExcelByIs(getDefaultImportParams(), "file", ${entity}.class, request);
            ${table.name}Service.saveAll(list);
            json = JsonModel.success("导入成功！！！");
        } catch (Exception e) {
            logger.error(LogExceptionStackUtil.LogExceptionStack(e));
            json = JsonModel.error("导入失败！！！错误如下：" + e.getMessage());
            e.printStackTrace();
        }
        return json;
    }
}
</#if>
