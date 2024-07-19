package com.himedia.mc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MenuDAO {
	ArrayList<menuDTO> getMenuList();
	void insertAddMenu(String a,int b);
	void deleteMenu(int a);
	void updateMenu(int a, String b, int c);
}
