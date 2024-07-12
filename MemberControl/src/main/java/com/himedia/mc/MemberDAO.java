package com.himedia.mc;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberDAO {
	void insertData(String uid, String upw1, String un, String ud, String ug, String mb, String allnf);
	int logincheck(String userid, String passwd);
}
