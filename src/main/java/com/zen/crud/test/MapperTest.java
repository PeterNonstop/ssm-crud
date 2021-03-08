package com.zen.crud.test;

import com.zen.crud.bean.Department;
import com.zen.crud.bean.Employee;
import com.zen.crud.dao.DepartmentMapper;
import com.zen.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试dao层的工作
 * 推荐Spring的项目就可以使用Spring的单元测试，可以自动注入我们需要的组件。
 * 1. 导入spring的单元测试模块
 * 2. ContextConfiguration指定spring配置文件的位置
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    //批量执行
    @Autowired
    SqlSession sqlSession;

    /**
     * 测试DepartmentMapper
     */
    @Test
    public void testDeptCrud() {

        System.out.println(departmentMapper);
        departmentMapper.insertSelective(new Department(null, "开发部"));
        departmentMapper.insertSelective(new Department(null, "测试部"));

        System.out.println("插入完成====");
    }

    @Test
    public void testEmployee() {
        //插入员工
        employeeMapper.insertSelective(new Employee(null, "peter", "M", "peter@outlook.com", 1));

        System.out.println("插入完成====");
    }

    @Test
    public void testBatchEmployee() {
        //批量插入员工，使用可以批量操作的sqlSession
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);

        for (int i = 0; i < 1000; i = i + 2) {
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uid, "M", uid + "@test.com", 1));
        }
        System.out.println("插入完成====");

        for (int i = 1; i < 1000; i = i + 2) {
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uid, "F", uid + "@zen.com", 2));
        }
        System.out.println("插入完成====");
    }
}
