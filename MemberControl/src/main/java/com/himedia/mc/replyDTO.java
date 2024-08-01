package com.himedia.mc;

import java.util.ArrayList;

import lombok.Data;

@Data
public class replyDTO {
	int id;
	int board_id;
	int par_id;
	String content;
	String writer;
	String created;
	String updated;
}
