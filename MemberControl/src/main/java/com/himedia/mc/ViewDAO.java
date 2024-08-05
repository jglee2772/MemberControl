package com.himedia.mc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ViewDAO {
	void addComment(int boardId, String content, String writer);
    void deleteComment(int id);
    void updateComment(int id, String content);
    ArrayList<replyDTO> getreplyList(int boardId);
    void addReply(int boardid, int parentid, String content, String writer);
}
