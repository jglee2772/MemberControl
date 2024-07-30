package com.himedia.mc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RoomDAO {
	ArrayList<roomtypeDTO> getTypeList();
	void insertRoom(String a, int b, int c, int d);
	ArrayList<roomDTO> getRoomList();
	void deleteRoom(int a);
	void updateRoom(int a, String b, int c, int d, int e);
}
