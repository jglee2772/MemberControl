package com.himedia.mc;

import lombok.Data;

@Data
public class replyDTO {
	int id;
	int par_id;
	String content;
	String writer;
	String created;
	String updated;
}
