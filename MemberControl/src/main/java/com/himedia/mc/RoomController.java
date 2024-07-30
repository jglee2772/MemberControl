package com.himedia.mc;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class RoomController {
	@Autowired RoomDAO rdao;
	
	@GetMapping("/room")
	public String room() {
		return "croom/room";
	}
	@PostMapping("/roomtype")
	@ResponseBody
	public String roomtype(HttpServletRequest req) {
		ArrayList<roomtypeDTO> arRoom = rdao.getTypeList();
		JSONArray ra = new JSONArray();
		for(roomtypeDTO rdto : arRoom) {
			JSONObject ro = new JSONObject();
			ro.put("id", rdto.getId());
			ro.put("typename", rdto.getTypename());
			ra.put(ro);
		}
		return ra.toString();
	}
	@PostMapping("/insertroom")
	@ResponseBody
	public String insertroom(HttpServletRequest req) {
		String name = req.getParameter("name");
		int type = Integer.parseInt(req.getParameter("type"));
		int personal = Integer.parseInt(req.getParameter("personal"));
		int price = Integer.parseInt(req.getParameter("price"));
		rdao.insertRoom(name, type, personal, price);
		return "ok";
	}
	@PostMapping("/updateroom")
	@ResponseBody
	public String updateroom(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		String name = req.getParameter("name");
		int type = Integer.parseInt(req.getParameter("type"));
		int personal = Integer.parseInt(req.getParameter("personal"));
		int price = Integer.parseInt(req.getParameter("price"));
		rdao.updateRoom(id, name, type, personal, price);
		return "ok";
	}
	@PostMapping("/loadroom")
	@ResponseBody
	public String loadroom(HttpServletRequest req) {
		ArrayList<roomDTO> arRoom = rdao.getRoomList();
		JSONArray ra = new JSONArray();
		for(roomDTO rdto : arRoom) {
			JSONObject ro = new JSONObject();
			ro.put("id", rdto.getId());
			ro.put("typename", rdto.getTypename());
			ro.put("name", rdto.getName());
			ro.put("personal", rdto.getPersonal());
			ro.put("price", rdto.getPrice());
			ra.put(ro);
		}
		return ra.toString();
	}
	@PostMapping("/deleteroom")
	@ResponseBody
	public String deleteroom(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		rdao.deleteRoom(id);
		return "ok";
	}

}
