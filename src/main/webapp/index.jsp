<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <%--    Web路径，
        1.不带/开始的相对路径，找资源是以当前资源的路径为基准。
        2.以/开始的相对路径，找资源是以服务器的路径为基准的。（推荐使用），需要加上项目名称。
    --%>
    <%--引入jquery--%>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.5.1.js"></script>
    <%--引入样式--%>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <%--引入js文件--%>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input"
                                   placeholder="email@test.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked">
                                男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-5">
                            <%-- 部门提交部门ID即可--%>
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input"
                                   placeholder="empName">
                            <span id="helpBlock" class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input"
                                   placeholder="email@test.com">
                            <span id="helpBlock2" class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-5">
                            <%-- 部门提交部门ID即可--%>
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<%--搭建页面--%>
<div class="container ">
    <%--这是标题行--%>
    <div class="row"></div>
    <div class="col-md-12">
        <h1>SSM-CRUD</h1>
    </div>
    <%--按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>
    <%--显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all"/>
                    </th>
                    <th>empId</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>

        </div>
    </div>

    <%--显示分页信息--%>
    <div class="row">
        <%-- 分页文字信息--%>
        <div class="col-md-5 col-md-offset-1" id="page_info_area">
        </div>

        <%--分页条信息--%>
        <div class="col-md-6" id="page_nav_area">
        </div>
    </div>

</div>

<script type="text/javascript">
    //添加员工时页面刷新使用
    var totalRecord;
    //修改员工时使用
    var currentPage;

    //1.页面加载完成后，直接发送一个ajax请求，要到分页数据
    $(function () {
        //一进入index就显示第一页
        to_page(1);
    });


    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn=" + pn,
            type: "get",
            success: function (result) {
                //console.log(result)
                // 1.页面解析并显示员工数据
                build_emps_table(result);
                // 2.解析并显示分页信息
                build_page_info(result);
                // 3.解析并显示分页条
                build_page_nav(result);
            }
        });
    }


    function build_emps_table(result) {
        //page_info_area,使用之前先清空
        $("#emps_table tbody").empty();

        //清空多选框的状态
        $("#check_all").prop("checked", false);

        var emps = result.extend.pageInfo.list;
        $.each(emps, function (index, item) {
            // console.log(item.empName);
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'/> </td>");
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            // var gender = item.gender=='M'?"男":"女";
            var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);

            //append方法执行完成以后还是返回原来的元素
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>")).addClass("glyphicon glyphicon-pencil").append("编辑");

            //在编辑按钮添加一个自定义属性，来表示当前员工的id
            //更新员工时使用
            editBtn.attr("edit-id", item.empId);

            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>")).addClass("glyphicon glyphicon-trash").append("删除");

            //删除员工时使用
            delBtn.attr("edit-id", item.empId);

            var btnId = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            $("<tr></tr>").append(checkBoxTd)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnId)
                .appendTo("#emps_table tbody");
        });

    }

    //解析显示分页信息
    function build_page_info(result) {
        //page_info_area,使用前清空
        $("#page_info_area").empty();

        //console.log(result);
        $("#page_info_area").append("< 当前"
            + result.extend.pageInfo.pageNum + "页，共"
            + result.extend.pageInfo.pages + "页，总共"
            + result.extend.pageInfo.total + "条记录 >");

        //员工添加成功时需要
        totalRecord = result.extend.pageInfo.total;
        //员工修改时调用
        currentPage = result.extend.pageInfo.pageNum;
    }

    //解析显示分页条，点击事件
    function build_page_nav(result) {
        //page_nav_area,使用前每次清空
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");

        //构造元素
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));

        if (result.extend.pageInfo.hasPreviousPage == false) {
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        } else {
            //为元素添加单击翻页事件
            firstPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum - 1);
            });
        }


        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));

        if (result.extend.pageInfo.hasNextPage == false) {
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        } else {
            //添加下一页，末页的单击事件
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
        }


        //添加首页，前一页
        ul.append(firstPageLi).append(prePageLi);
        //遍历ul中添加页码提示
        $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            //选中高亮
            if (result.extend.pageInfo.pageNum == item) {
                numLi.addClass("active");
            }
            //单击事件
            numLi.click(function () {
                to_page(item);
            });

            ul.append(numLi);
        });

        //添加后一页，末页
        ul.append(nextPageLi).append(lastPageLi);

        //把ul加入到nav中
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    //清空表单样式及内容
    function reset_form(ele) {
        //内容重置
        $(ele)[0].reset();
        //样式重置
        $(ele).find("*").removeClass("has-success has-error");
        $(ele).find(".help-block").text("");
    }

    //点击新增，弹出模态框
    $("#emp_add_modal_btn").click(function () {
        //每次打开时清除表单数据，表单(数据，样式)重置
        reset_form("#empAddModel form");
        // $("#empAddModel form")[0].reset();

        //发送ajax请求，获取部门信息,显示在模态框下拉列表中
        getDepts("#empAddModel select");

        //弹出模态框
        $("#empAddModel").modal({
            backdrop: "static"
        });
    });

    //查出所有部门信息并显示在下拉列表中
    function getDepts(ele) {
        //使用前先清空下拉列表
        $(ele).empty();

        $.ajax({
            url: "${APP_PATH}/depts",
            type: "GET",
            success: function (result) {
                // console.log(result);
                /**
                 * {"code":100,"msg":"处理成功!",
                 * "extend":
                 * {"depts":[{"deptId":1,"deptName":"开发部"},
                 * {"deptId":2,"deptName":"测试部"}]}
                 * **/
                $.each(result.extend.depts, function () {
                    // this代表当前现在遍历的元素
                    var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                    optionEle.appendTo(ele);
                });
            }
        });
    }

    //对表单的中数据进行校验
    function validate_add_form() {
        //1. 对用户名进行校验
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if (!regName.test(empName)) {
            // alert("用户名可以是2-5位中文或者6-16位英文和数字的组合。");
            show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合。。");
            return false;
        } else {
            show_validate_msg("#empName_add_input", "success", "");
        }

        //2. 对邮箱进行校验
        var email = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            // alert("邮箱格式不正确。");
            show_validate_msg("#email_add_input", "error", "邮箱格式不正确。");
            return false;
        } else {
            show_validate_msg("#email_add_input", "success", "");
        }
        return true;

    }

    function show_validate_msg(ele, status, msg) {
        //清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");

        if ("success" == status) {
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        } else if ("error" == status) {
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    //检验用户名可否可用
    $("#empName_add_input").change(function () {
        //发送ajax请求验证用户可用性
        var empName = this.value;
        $.ajax({
            url: "${APP_PATH}/checkUser",
            data: "empName=" + empName,
            type: "POST",
            success: function (result) {
                if (result.code == 100) {
                    show_validate_msg("#empName_add_input", "success", "用户名可用");
                    //ajax提交表单前判断这个属性
                    $("#emp_save_btn").attr("ajax-va", "success");
                } else {
                    show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax-va", "error");
                }
            }
        });

    });

    //保存按钮的单击事件
    $("#emp_save_btn").click(function () {
        // 模态框中填写的表单数据提交给服务器保存
        // 先对模态框中的数据进行校验

        if (!validate_add_form()) {
            return false;
        }

        //1.关闭模态框 2.添加数据

        //判断之前的ajax用户名检验是否成功，如果成功
        if ($("#emp_save_btn").attr("ajax-va") == "error") {
            return false;
        }

        //发送ajax请求保存员工
        // alert($("#empAddModel form").serialize());
        //$("#empAddModel form").serialize()系列化表单数据，与bean对应.
        $.ajax({
            url: "${APP_PATH}/emp",
            type: "POST",
            data: $("#empAddModel form").serialize(),
            success: function (result) {
                // alert(result.msg);
                if (result.code == 100) {
                    //员工保存成功
                    //1. 关闭模态框
                    $("#empAddModel").modal("hide");
                    //2.页面刷新至最后一页（新增加的员工页）
                    //发送ajax请求显示最后一页数据即可
                    //总记录说肯定比总页码大
                    to_page(totalRecord);
                } else {
                    //显示失败信息
                    console.log(result);
                    if (undefined !== result.extend.errorFields.email) {
                        //显示邮箱错误信息
                        show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                    }

                    if (undefined !== result.extend.errorFields.empName) {
                        //显示用户错误信息
                        show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                    }
                }

            }
        });
    });

    //更新btn事件
    //我们是按钮创建之前就绑定了click事件，所有不能绑定。
    //解决方法：
    //1.创建按钮的事件绑定事件
    //2.绑定单击.live()(新版已弃用)，使用on.
    $(document).on("click", ".edit_btn", function () {
        // alert("edit_btn click.")

        // 查出部门信息，并显示部门列表
        //发送ajax请求，获取部门信息,显示在模态框下拉列表中
        getDepts("#empUpdateModel select");

        // 查出员工信息，显示员工信息
        getEmp($(this).attr("edit-id"));

        //把员工的id传递给模态框的更新按钮
        $("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));

        //弹出模态框
        $("#empUpdateModel").modal({
            backdrop: "static"
        });
    });

    function getEmp(id) {
        $.ajax({
            url: "${APP_PATH}/emp/" + id,
            type: "GET",
            success: function (result) {
                console.log(result);
                var empData = result.extend.emp;
                $("#empName_update_static").text(empData.empName);
                $("#email_update_input").val(empData.email);
                $("#empUpdateModel input[name=gender]").val([empData.gender]);
                $("#empUpdateModel select").val([empData.dId]);
            }

        });
    }

    //点击更新模态框中的更新按钮，保存员工信息
    $("#emp_update_btn").click(function () {
        //1. 验证邮箱格式是否合法
        var email = $("#email_update_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            // alert("邮箱格式不正确。");
            show_validate_msg("#email_update_input", "error", "邮箱格式不正确。");
            return false;
        } else {
            show_validate_msg("#email_update_input", "success", "");
        }

        // 2. 发送ajax请求，保存更新的员工数据
        $.ajax({
            url: "${APP_PATH}/emp/" + $(this).attr("edit-id"),
            type: "PUT",
            data: $("#empUpdateModel form").serialize(),
            // data: $("#empUpdateModel form").serialize()+"&_method=PUT",
            success: function (result) {
                console.log(result);
                //1.关闭模态框
                $("#empUpdateModel").modal("hide");

                //2.返回至修改员工的那页
                to_page(currentPage);
            }
        });

    });

    //单个删除
    $(document).on("click", ".delete_btn", function () {
        // alert($(this).parents("tr").find("td:eq(1)").text());
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).attr("edit-id")
        if (confirm("确认删除【" + empName + "】吗？")) {
            //确认，发送ajax请求删除即可
            $.ajax({
                url: "${APP_PATH}/emp/" + empId,
                type: "DELETE",
                success: function (result) {
                    // console.log(result);
                    alert(result.msg);
                    //回到本页
                    to_page(currentPage);
                }
            });
        }
    });

    //完成全选，全不选功能
    $("#check_all").click(function () {
        // attr获取checked属性时是undefined;
        // 用prop()获取dom原生的属性，用attr获取自定义的属性
        // alert($(this).prop("checked"));
        $(".check_item").prop("checked", $(this).prop("checked"));
    });

    //check_item
    $(document).on("click", ".check_item", function () {
        //判断当前选择的元素是否全选
        //console.log($(".check_item:checked").length);
        var flag = $(".check_item:checked").length == $(".check_item").length;
        $("#check_all").prop("checked", flag);
    });

    //点击全选，批量删除
    $("#emp_delete_all_btn").click(function () {
        var empNames = "";
        var empIds = "";
        $.each($(".check_item:checked"), function () {
            //获取被删除员工的name
            empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
            //获取被删除元素的id
            empIds += $(this).parents("tr").find("td:eq(1)").text() + "-";
        });

        //去除empNames结束多余的,
        empNames = empNames.substring(0, empNames.length - 1);
        //去除empIds中结束多余的-
        empIds = empIds.substring(0, empIds.length - 1);
        if (confirm("确认删除【" + empNames + "】吗？")) {
            //发送ajax请求
            $.ajax({
                url: "${APP_PATH}/emp/" + empIds,
                type: "DELETE",
                success: function (result) {
                    // console.log(result);
                    alert(result.msg);
                    //回到当前页
                    to_page(currentPage);
                }
            });
        }
    });

</script>

</body>
</html>
