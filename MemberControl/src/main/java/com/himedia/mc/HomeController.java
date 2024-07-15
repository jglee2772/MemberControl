package com.himedia.mc;

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
	
	@GetMapping("/")
	public String home(HttpServletRequest req, Model model) {
		String linkstr="";
		HttpSession s =req.getSession();
		String userid = (String) s.getAttribute("userid");
		if(userid == null || userid.equals("")) {
			linkstr = "<a href='/login'>로그인</a>&nbsp&nbsp&nbsp;"+
					"<a href='/signup'>회원가입</a>";
		}else {
			linkstr = "사용자["+userid+"]&nbsp&nbsp;"+
					"<a href='/logout'>로그아웃</a>";
		}
		model.addAttribute("linkstr",linkstr);
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
	
	
	@GetMapping("/nothing")
	public String nothing(HttpServletRequest req,Model model) {
		HttpSession s = req.getSession();
		String userid = (String) s.getAttribute("userid");
		if (userid==null||userid.equals("")) {
			model.addAttribute("message", "로그인이 필요합니다.");
			return "login";
		}
		return "nothing";
	}
}
