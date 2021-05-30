package com.zen.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zen.crud.bean.Employee;
import com.zen.crud.bean.Msg;
import com.zen.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 处理员工crud
 * <p>
 * URI:
 * /emp/{id}  GET 查询员工
 * /emp       POST 保存员工
 * /emp/{id}  PUT 修改员工
 * /emp/{id}  delete 删除员工
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 查询员工数据，分页查询
     *
     * @return
     */
    @RequestMapping("/empsNotJson")
    public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn,
                          Model model) {
        System.out.println("EmployeeController...getEmps...");

        //引入PageHelper分页插件
        //在查询之前只需调用，传入页码，以及每页的页数
        PageHelper.startPage(pn, 7);
        //startPage后面紧跟就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        //用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行。
        //封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数(5)
        PageInfo page = new PageInfo(emps, 5);
        model.addAttribute("pageInfo", page);

        return "list";
    }

    @RequestMapping("/hello")
    @ResponseBody
    public String hello() {
        return "hello";
    }


    /**
     * @RequestBody以json格式数据返回给前端 需要导入jackson包
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        System.out.println("EmployeeController...getEmpsWithJson...");

        //引入PageHelper分页插件
        //在查询之前只需调用，传入页码，以及每页的页数
        PageHelper.startPage(pn, 7);
        //startPage后面紧跟就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        //用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行。
        //封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数(5)
        PageInfo page = new PageInfo(emps, 5);

        return Msg.success().add("pageInfo", page);
    }

    /**
     * 保存用户
     * 1.JSR303检验
     * 2.导入Hibernate-validator
     *
     * @param employee
     * @return
     */
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result) {
        if (result.hasErrors()) {
            Map<String, Object> map = new HashMap<>();
            //校验失败，返回失败；在模态框中显示失败信息
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                System.out.println("错误的字段名：" + error.getField());
                System.out.println("错误信息：" + error.getDefaultMessage());
                map.put(error.getField(), error.getDefaultMessage());
            }
            return Msg.fail().add("errorFields", map);
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 检验用户是否可用
     *
     * @param empName
     * @return
     */
    @RequestMapping("/checkUser")
    @ResponseBody
    public Msg checkUser(@RequestParam("empName") String empName) {
        //先判断用户名是否可用的表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)) {
            return Msg.fail().add("va_msg", "用户名必须是6-16位英文和数字的组合或者是2-5位中文。");
        }

        //数据库用户名重复校验
        boolean b = employeeService.checkUser(empName);
        if (b) {
            return Msg.success();
        } else {
            return Msg.fail().add("va_msg", "用户名不可用");
        }
    }


    //查询：GET
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id) {
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp", employee);
    }

    /**
     * 如果直接发送ajax(PUT)请求:
     * Employee{empId=1014, empName='null', gender='null', email='null', dId=null, department=null}
     * <p>
     * 问题：
     * 请求体中有数据，但在Employee对象封装不上。
     * <p>
     * 原因：
     * Tomcat：
     * 1.将请求中的数据，封装成一个map.
     * 2.request.getParameter("empName")就会从这个map中取值。
     * 3.springmvc封装POJO对象的时候。
     * 会把POJO中每个属性的值，request.getParameter()
     * <p>
     * AJAX发送put请求：
     * put请求，请求体中的数据，request.getParameter()拿不到。
     * tomcat一看是put请求，不会封装请求中的数据为map。
     * 只有post形式的请求才封装请求体的数据为map.
     * org.apache.catalina.connector.Request--parseParameters()
     * <p>
     * 解决方案：
     * <p>
     * 为能支持ajax直接发送的put之类的请求还要封装请求体中的数据。
     * web.xml中配置：HttpPutFormContentFilter。
     * 作用：将请求体中的数据解析重新包装在一个map.
     * request被重新包装。request.getParameter()被重写。
     * <p>
     * 员工更新方法
     *
     * @param employee bnmn;,
     * @return
     */
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateSaveEmp(Employee employee, HttpServletRequest request) {
        System.out.println("gender,请求中的值：" + request.getParameter("gender"));
        System.out.println("将要更新的员工数据===>" + employee);
        employeeService.updateEmp(employee);

        return Msg.success();
    }


    /**
     * 单个删除、批量删除 二合一
     * 批量删除：1-2-3
     * 单个删除：1
     *
     * @param ids
     * @return
     */
    //删除员工
    @RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteEmp(@PathVariable("ids") String ids) {
        if (ids.contains("-")) {
            //批量删除
            List<Integer> delIds = new ArrayList<>();
            String[] strIds = ids.split("-");

            for (String strId : strIds) {
                delIds.add(Integer.parseInt(strId));
            }

            employeeService.deleteBatch(delIds);

        } else {
            //单个删除
            int id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }

        return Msg.success();
    }

    /**
     * 通过ID查询带部门信息
     *
     * @param empId
     * @param request
     * @return
     */

    @RequestMapping("/empsWithId")
    @ResponseBody
    public Msg getEmpsWithId(Integer empId, HttpServletRequest request) {
        //System.out.println("EmployeeController...getEmpsWithId===>" + request.getParameter("empId"));

        //引入PageHelper分页插件
        //在查询之前只需调用，传入页码，以及每页的页数
        PageHelper.startPage(1, 7);
        //startPage后面紧跟就是一个分页查询
        List<Employee> emps = new ArrayList<>();
        if (empId != null) {
            System.out.println("EmployeeController...getEmpsWithId===>" + Integer.parseInt(request.getParameter("empId")));
            Integer id = Integer.parseInt(request.getParameter("empId"));
            emps.add(employeeService.getEmpWithDept(id));
        } else {
            emps = employeeService.getAll();
        }

        System.out.println(emps.parallelStream().filter(Objects::nonNull).collect(Collectors.toList()));

        // 为空
        if ((emps.size() == 1 && null == emps.get(0)) || emps.size() == 0) {

            System.out.println("NO MSG.");
            return Msg.fail().add("va_msg", "用户名ID不存在；请重试！");

        } else {
            // 不为空

            //用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行。
            //封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数(5)
            PageInfo page = new PageInfo(emps, 5);

            return Msg.success().add("pageInfo", page);
        }
    }
}
