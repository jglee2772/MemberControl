package com.himedia.mc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ViewDAO {
	void addComment(int a, String b,String c);
	ArrayList<replyDTO> getreplyList(int a);
}
