package com.zen.crud.service;

import com.zen.crud.bean.Department;
import com.zen.crud.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {


    @Autowired
    DepartmentMapper departmentMapper;

    public List<Department> getAllDepts() {
        List<Department> departments = departmentMapper.selectByExample(null);
        return departments;
    }
}
