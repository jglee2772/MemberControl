package com.himedia.mc;

import lombok.Data;

@Data
public class memberDTO {
	int id;
	String userid;
	String passwd;
	String realname;
	String birthday;
	String gender;
	String mobile;
	String[] favorate;
}
