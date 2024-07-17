package com.himedia.mc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MenuDAO {
	ArrayList<menuDTO> getMenuList();
}
