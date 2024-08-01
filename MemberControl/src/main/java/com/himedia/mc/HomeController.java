package com.himedia.mc;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
	@Autowired MemberDAO mdao;
	@Autowired BoardDAO bdao;
	@Autowired MenuDAO pdao;
	@Autowired ViewDAO vdao;
	
	@PostMapping("/list")
	@ResponseBody
	public String doList(HttpServletRequest req) {
		int start = 0;
		ArrayList<boardDTO> arBoard = bdao.getList(start);
		JSONArray ja = new JSONArray();
		for(boardDTO bdto : arBoard) {
			JSONObject jo = new JSONObject();
			jo.put("id", bdto.getId());
			jo.put("title", bdto.getTitle());
			jo.put("content", bdto.getContent());
			jo.put("writer", bdto.getWriter());
			jo.put("created", bdto.getCreated());
			jo.put("updated", bdto.getUpdated());
			jo.put("hit", bdto.getHit());
			ja.put(jo);
		}
		return ja.toString();
	}
	@PostMapping("/boardContent")
	@ResponseBody
	public String contentin(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		boardDTO bdto = bdao.getView(id);		
		return bdto.getContent();
	}
	
	@GetMapping("/crud")
	public String crud(HttpServletRequest req) {
		HttpSession s = req.getSession();
		String userid = (String) s.getAttribute("userid");
		if (userid==null||userid.equals("")) {
			return "redirect:/login";
		}
		return "ajax/crud";
	}
	@GetMapping("/menuctrl")
	public String menuCtrl() {
		return "menu/crud";
	}
	@GetMapping("/orderctrl")
	public String orderCtrl() {
		return "menu/order";
	}
	@PostMapping("/menulist")
	@ResponseBody
	public String menuList(HttpServletRequest req) {
		ArrayList<menuDTO> arMenu = pdao.getMenuList();
		JSONArray ma = new JSONArray();
		for(menuDTO mdto : arMenu) {
			JSONObject mo = new JSONObject();
			mo.put("id", mdto.getId());
			mo.put("name", mdto.getName());
			mo.put("price", mdto.getPrice());
			ma.put(mo);
		}
		return ma.toString();
	}
	@PostMapping("/revenuelist")
	@ResponseBody
	public String revenuelist(HttpServletRequest req) {
		ArrayList<revenueDTO> arRev = pdao.getRevList();
		JSONArray ra = new JSONArray();
		for(revenueDTO rdto : arRev) {
			JSONObject ro = new JSONObject();
			ro.put("id", rdto.getId());
			ro.put("mobile", rdto.getMobile());
			ro.put("menuname", rdto.getMenuid());
			ro.put("qty", rdto.getQty());
			ro.put("menusum", rdto.getMenusum());
			ro.put("created", rdto.getCreated());
			ra.put(ro);
		}
		return ra.toString();
	}
	@PostMapping("/addMenu")
	@ResponseBody
	public String Addmenu(HttpServletRequest req) {
		String name = req.getParameter("name");
		String price = req.getParameter("price");
		pdao.insertAddMenu(name, Integer.parseInt(price));
		return "ok";
	}
	@PostMapping("/updateMenu")
	@ResponseBody
	public String updateMenu(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		String name = req.getParameter("name");
		int price = Integer.parseInt(req.getParameter("price"));
		pdao.updateMenu(id, name, price);
		return "ok";
	}
	@PostMapping("/deleteMenu")
	@ResponseBody
	public String deleteMenu(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		pdao.deleteMenu(id);
		return "ok";
	}
	@PostMapping("/addRevenue")
	@ResponseBody
	public String addRevenue(HttpServletRequest req) {
		String mobile = req.getParameter("mobile");
		int menuid = Integer.parseInt(req.getParameter("menuid"));
		int qty = Integer.parseInt(req.getParameter("qty"));
		int menusum = Integer.parseInt(req.getParameter("menusum"));
		pdao.insertAddrev(mobile, menuid, qty, menusum);
		return "ok";
	}
	@PostMapping("/saveBoard")
	@ResponseBody
	public String save(HttpServletRequest req) {
		HttpSession s = req.getSession();
		String writer = (String) s.getAttribute("userid");
		String title = req.getParameter("title");
		String content = req.getParameter("content");
		bdao.insert(title, writer, content);
		return "ok";
	}
	@PostMapping("/updateBoard")
	@ResponseBody
	public String updateBoard(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		String title = req.getParameter("title");
		String content = req.getParameter("content");
		bdao.updateView(id,title, content);
		return "ok";
	}
	@PostMapping("/deleteBoard")
	@ResponseBody
	public String deleteBoard(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		bdao.deleteView(id);
		return "ok";
	}
	@GetMapping("/")
	public String home(HttpServletRequest req, Model model) {
		String linkstr="";
		String newpost="";
		HttpSession s =req.getSession();
		String userid = (String) s.getAttribute("userid");
		if(userid == null || userid.equals("")) {
			linkstr = "<a href='/login'>로그인</a>&nbsp&nbsp&nbsp;"+
					"<a href='/signup'>회원가입</a>";
			newpost = "";
		}else {
			linkstr = "사용자["+userid+"]&nbsp&nbsp;"+
					"<a href='/logout'>로그아웃</a>";
			newpost = "<a href='/write'>새글작성</a>";
		}
		model.addAttribute("linkstr",linkstr);
		model.addAttribute("newpost",newpost);
		String pageno = req.getParameter("p");
		int nowpage = 1;
		if(pageno == null || pageno.equals("")) nowpage=1;
		else nowpage = Integer.parseInt(pageno);
		int total = bdao.getCount();
		int pagesize=20;
		int start = (nowpage-1)*pagesize;
		System.out.println(start);
		int lastpage = (int)Math.ceil((double)total/pagesize);
		System.out.println(lastpage);
		String movestr = "<a href='/?p=1'>처음</a>&nbsp;&nbsp;";
		if(nowpage!=1) {
			movestr +="<a href='/?p="+(nowpage-1)+"'>이전</a>&nbsp;&nbsp;";
		}
		if(nowpage!=lastpage) {
			movestr +="<a href='/?p="+(nowpage+1)+"'>다음</a>&nbsp;&nbsp;";
		}
		movestr+="<a href='/?p="+lastpage+"'>마지막</a>";
		model.addAttribute("movestr",movestr);
		ArrayList<boardDTO> arBoard = bdao.getList(start);
		model.addAttribute("arBoard",arBoard);
		return "home";
	}
	@GetMapping("/logout")
	public String logout(HttpServletRequest req) {
		HttpSession s = req.getSession();
		s.invalidate();
		return "redirect:/";
	}
	@GetMapping("/login")
	public String login() {
		return "login";
	}
	@GetMapping("/signup")
	public String signup() {
		return "signup";
	}
	@PostMapping("/dosignup")
	public String dosignup(HttpServletRequest req) {
		String uid = req.getParameter("uid");
		String upw1 = req.getParameter("upw1");
		String upw2 = req.getParameter("upw2");
		if (!upw1.equals(upw2)) return "redirect:/signup";
		String un = req.getParameter("un");
		String ud = req.getParameter("ud");
		String ug = req.getParameter("ug");
		String mb = req.getParameter("mobile");
		String nf[] = req.getParameterValues("nf");
		if (uid.equals("")||upw1.equals("")||un.equals("")||ud.equals("")||ug.equals("")||mb.equals("")) {
			return "signup";
		}
		String allnf=""; 
		for(String x : nf) {
			if(!allnf.equals("")) allnf+=","+x;
			allnf+=x;
		}
		mdao.insertData(uid, upw1, un, ud, ug, mb, allnf);
		return "login";
	}
	@PostMapping("/doLogin")
	public String doLogin(HttpServletRequest req, Model model) {
		String uid = req.getParameter("userid");
		String pw = req.getParameter("password");
		int n = mdao.logincheck(uid, pw);
		if(n>0) {
			HttpSession s = req.getSession();
	        s.setAttribute("userid", uid);
		} else {
			return "login";
		}
		return "redirect:/";
	}
	@GetMapping("/cancellogin")
	public String cancellogin() {
		return "redirect:/";
	}
	
	
	@GetMapping("/board")
	public String nothing(HttpServletRequest req,Model model) {
		HttpSession s = req.getSession();
		String userid = (String) s.getAttribute("userid");
		if (userid==null||userid.equals("")) {
			model.addAttribute("message", "로그인이 필요합니다.");
			return "login";
		}
		return "board";
	}
	@GetMapping("/write")
	public String write(HttpServletRequest req, Model model) {
		HttpSession s = req.getSession();
		String userid = (String) s.getAttribute("userid");
		model.addAttribute("userid",userid);
		return "board/write";
	}
	@PostMapping("/save")
	public String save(HttpServletRequest req, Model model) {
		String title = req.getParameter("title");
		String writer = req.getParameter("writer");
		String content = req.getParameter("content");
		bdao.insert(title, writer, content);
		return "redirect:/";
	}
	@GetMapping("/view")
	public String view(HttpServletRequest req, Model model) {
		int id =Integer.parseInt(req.getParameter("id"));
		boardDTO bdto = bdao.getView(id);
		bdao.addHit(id);
		model.addAttribute("board",bdto);
		ArrayList<replyDTO> arReply = vdao.getreplyList(id);
		model.addAttribute("arReply",arReply);
		return "board/view";
	}
	@PostMapping("/addComment")
	@ResponseBody
	public String addComment(HttpServletRequest req) {
		HttpSession s = req.getSession();
		String writer =(String) s.getAttribute("userid");
		String content = req.getParameter("content");
	    int boardid = Integer.parseInt(req.getParameter("boardid"));
	    vdao.addComment(boardid, content, writer);
	    return "ok";
	}
	@PostMapping("/updateComment")
	@ResponseBody
	public String updateComment(HttpServletRequest req) {
		HttpSession s = req.getSession();
		String writer =(String) s.getAttribute("userid");
		String content = req.getParameter("content");
		return "ok";
	}
	@GetMapping("/delete")
	public String delete(HttpServletRequest req) {
		HttpSession s = req.getSession();
		String userid = (String) s.getAttribute("userid");
		if (userid==null||userid.equals("")) {
			return "redirect:/";
		}
		int id = Integer.parseInt(req.getParameter("id"));
		boardDTO bdto = bdao.getView(id);
		if(userid.equals(bdto.getWriter())) {
			bdao.deleteView(id);
			return "redirect:/";
		} else {
			return "redirect:/";
		}
	}
	@GetMapping("/update")
	public String update(HttpServletRequest req, Model model) {
		HttpSession s = req.getSession();
		String userid = (String) s.getAttribute("userid");
		if (userid==null||userid.equals("")) {
			return "redirect:/";
		}
		int id =Integer.parseInt(req.getParameter("id"));
		boardDTO bdto = bdao.getView(id);
		if(userid.equals(bdto.getWriter())) {
			model.addAttribute("board",bdto);
			return "board/update";
		} else {
			return "redirect:/";
		}
	}
	@PostMapping("/modify")
	public String modify(HttpServletRequest req, Model model) {
		int id = Integer.parseInt(req.getParameter("id"));
		String title = req.getParameter("title");
		String content = req.getParameter("content");
		bdao.updateView(id, title, content);
		return "redirect:/";
	}
}
