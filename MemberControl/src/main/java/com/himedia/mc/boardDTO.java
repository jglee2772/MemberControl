package com.himedia.mc;

import lombok.Data;

@Data
public class boardDTO {
	int id;
	String title;
	String content;
	String writer;
	String created;
	String updated;
	int hit;
}
