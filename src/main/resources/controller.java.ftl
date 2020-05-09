package ${package.Controller};

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Autowired;
import com.jointt.ems.web.ui.PageRequest;
import com.jointt.ems.web.constant.MessageStatus;
import com.jointt.ems.web.ui.DataGrid;
import com.jointt.ems.web.ui.JsonModel;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import framework.jointt.ems.page.Pagination;
import org.apache.commons.lang3.StringUtils;
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
 * @since ${date}
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
    public String view(HttpServletRequest request) {
        String id = request.getParameter("id");
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
    public DataGrid dataGrid(HttpServletRequest request, Pagination pagination) {
        Map<String, Object> parametersMap = ServletUtils.getParametersStartingWith(request, null);
        datagrid = ${table.name}Service.getDataGrid(pagination, parametersMap);
        return datagrid;
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
            ${entity} em = ${table.name}Service.save(${table.name});
            if (em != null && null != (em.getId())) {
                json = new JsonModel("新增成功！！！", MessageStatus.OK);
            } else {
                json = new JsonModel("新增失败！！！", MessageStatus.ERROR);
            }
        } catch (Exception e) {
            json = new JsonModel("新增失败！！！错误如下：" + e.getMessage(), MessageStatus.ERROR);
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
                json = new JsonModel("修改成功！！！", MessageStatus.OK);
            } else {
                json = new JsonModel("修改失败！！！", MessageStatus.ERROR);
            }
        } catch (Exception e) {
            json = new JsonModel("修改失败！！！错误如下：" + e.getMessage(), MessageStatus.ERROR);
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
    public JsonModel delete(HttpServletRequest request) {
        try {
            String ids = request.getParameter("ids");
            int temp = ${table.name}Service.batchDelete(ids);
            if(temp > 0) {
                json = new JsonModel("删除成功！！！", MessageStatus.OK);
            }else{
                json = new JsonModel("删除不成功！！！", MessageStatus.PROMPT);
            }
        } catch (Exception e) {
            json = new JsonModel("删除失败！！！" , MessageStatus.ERROR);
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
        ${table.name}Service.exprotExcel(fileName, fileName, "自定义", list, Employee.class, response);
    }
}
</#if>
