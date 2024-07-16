package com.himedia.mc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardDAO {
	void insert(String a,String b,String c);
	ArrayList<boardDTO> getList();
	boardDTO getView(int a);
	void deleteView(int a);
	void updateView(int a, String b, String c);
	void addHit(int a);
}
