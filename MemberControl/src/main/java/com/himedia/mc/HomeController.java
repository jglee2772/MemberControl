package com.himedia.mc;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
	@Autowired MemberDAO mdao;
	@Autowired BoardDAO bdao;
	
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
		ArrayList<boardDTO> arBoard = bdao.getList();
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
		return "board/view";
	}
	@GetMapping("delete")
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
	@GetMapping("update")
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
	@PostMapping("modify")
	public String modify(HttpServletRequest req, Model model) {
		int id = Integer.parseInt(req.getParameter("id"));
		String title = req.getParameter("title");
		String content = req.getParameter("content");
		bdao.updateView(id, title, content);
		return "redirect:/";
	}
}
