package com.pdh.exam.demo.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

import com.pdh.exam.demo.service.GenFileService;
import com.pdh.exam.demo.service.MemberService;
import com.pdh.exam.demo.utill.Ut;
import com.pdh.exam.demo.vo.Member;
import com.pdh.exam.demo.vo.ResultData;
import com.pdh.exam.demo.vo.Rq;

@Controller
public class UsrMemberController {	
	private MemberService memberService;
	private GenFileService genFileService;
	private Rq rq;
	
	public UsrMemberController(MemberService memberService,GenFileService genFileService, Rq rq) {
		this.memberService = memberService;
		this.genFileService = genFileService;
		this.rq=rq;
	}
	
	@RequestMapping("/usr/member/doJoin")
	@ResponseBody
	public String doJoin(String loginId, String loginPw, String name, String nickname, String cellphoneNo, String email,  @RequestParam(defaultValue = "/") String afterLoginUri, MultipartRequest multipartRequest) {
		
		System.out.println("loginPw : " +  loginPw);
		
		ResultData<Integer> joinRd = memberService.join(loginId, loginPw, name, nickname, cellphoneNo, email);
		
		if ( joinRd.isFail() ) {
			return rq.jsHistoryBack(joinRd.getResultCode(), joinRd.getMsg());
		}
		
		int newMemberId = (int)joinRd.getBody().get("id");
		
		String afterJoinUri = "../member/login?afterLoginUri=" +  Ut.getUriEncoded(afterLoginUri);
		
		Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
		
		for (String fileInputName : fileMap.keySet()) {
            MultipartFile multipartFile = fileMap.get(fileInputName);

            if ( multipartFile.isEmpty() == false ) {
                genFileService.save(multipartFile, newMemberId);
            }
        }
		return rq.jsReplace("??????????????? ?????????????????????. ????????? ??? ??????????????????.", afterJoinUri);
	}
	
	@RequestMapping("/usr/member/getLoginIdDup")
	@ResponseBody
	public ResultData getLoginIdDup(String loginId) {
		if ( Ut.empty(loginId) ) {
			return ResultData.from("F-1","loginId(???)??? ??????????????????.");
		}

		Member oldMember = memberService.getMemberByLoginId(loginId);

		if (oldMember != null) {
			return ResultData.from("F-A", "?????? ???????????? ?????? ??????????????????.", "loginId", loginId);
		}

		return ResultData.from("S-A", "??????????????? ?????????????????? ?????????.", "loginId", loginId);
	}

	@RequestMapping("/usr/member/join")
	public String showJoin() {
		return "usr/member/join";
	}
	
	@RequestMapping("/usr/member/doLogout")
	@ResponseBody
	public String doLogout(@RequestParam(defaultValue = "/") String afterLogoutUri) {
		rq.logout();
		
		return rq.jsReplace( "???????????? ???????????????.", afterLogoutUri);
	}
	
	@RequestMapping("/usr/member/login")
	public String showLogin() {
		return "usr/member/login";
	
}
	
	@RequestMapping("/usr/member/doLogin")
	@ResponseBody
	public String doLogin(String loginId, String loginPw, @RequestParam(defaultValue = "/") String afterLoginUri) {	
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if ( member == null ) {
			return rq.jsHistoryBack( "???????????? ?????? ?????????????????? ?????????.");
		}
		
		if ( member.getLoginPw().equals(loginPw) == false ) {
			return rq.jsHistoryBack( "??????????????? ???????????? ????????????.");
		}
		
		rq.login(member);
		
		String msg = Ut.f("%s??? ???????????????.", member.getNickname());

		boolean isUsingTempPassword = memberService.isUsingTempPassword(member.getId());

		if ( isUsingTempPassword ) {
			msg = "?????? ??????????????? ??????????????????.";
			afterLoginUri = "/usr/member/myPage";
		}

		return rq.jsReplace(msg, afterLoginUri);
	}
	
	@RequestMapping("/usr/member/findLoginId")
	public String showFindLoginId() {
		return "usr/member/findLoginId";
	}

	@RequestMapping("/usr/member/doFindLoginId")
	@ResponseBody
	public String doFindLogiId(String name, String email, @RequestParam(defaultValue = "/") String afterFindLoginIdUri) {

		Member member = memberService.getMemberByNameAndEmail(name, email);

		if ( member == null ) {
			return rq.jsHistoryBack("???????????? ?????? ?????? ?????? ??????????????????.");
		}

		return rq.jsReplace(Ut.f("???????????? ???????????? [%s]?????????.", member.getLoginId()), afterFindLoginIdUri);
	}
	
	@RequestMapping("/usr/member/findLoginPw")
	public String showFindLoginPw() {
		return "usr/member/findLoginPw";
	}

	@RequestMapping("/usr/member/doFindLoginPw")
	@ResponseBody
	public String doFindLoginPw(String loginId, String email, @RequestParam(defaultValue = "/") String afterFindLoginPwUri) {		

		Member member = memberService.getMemberByLoginId(loginId);

		if ( member == null ) {
			return rq.jsHistoryBack("???????????? ????????? ???????????? ????????????.");
		}

		if ( member.getEmail().equals(email) == false ) {
			return rq.jsHistoryBack("???????????? ????????? ???????????? ????????????.");
		}

		ResultData notifyTempLoginPwByEmailRs = memberService.notifyTempLoginPwByEmail(member);

		return rq.jsReplace(notifyTempLoginPwByEmailRs.getMsg(), afterFindLoginPwUri);
	}

	
	@RequestMapping("/usr/member/myPage")
	public String showMyPage() {
		return "usr/member/myPage";
	}
	
	@RequestMapping("/usr/member/checkPassword")
	public String showCheckPassword() {
		return "usr/member/checkPassword";
	}
	
	@RequestMapping("/usr/member/doCheckPassword")
	@ResponseBody
	public String doCheckPassword(String loginPw, String replaceUri) {
		if (rq.getLoginedMember().getLoginPw().equals(loginPw) == false) {
			return rq.jsHistoryBack("??????????????? ???????????? ????????????.");
		}
		
		if ( replaceUri.equals("../member/modify") ) {
			String memberModifyAuthKey = memberService.genMemberModifyAuthKey(rq.getLoginedMemberId());

			replaceUri += "?memberModifyAuthKey=" + memberModifyAuthKey;
		}		


		return rq.jsReplace("", replaceUri);
	}
	

	@RequestMapping("/usr/member/modify")
	public String showModify(String memberModifyAuthKey) {
		if ( Ut.empty(memberModifyAuthKey)) {
			return rq.historyBackJsOnview("memberModifyAuthKey(???)??? ???????????????.");
			}
		ResultData checkMemberModifyAuthKeyRd = memberService.checkMemberModifyAuthKey(rq.getLoginedMemberId(), memberModifyAuthKey);


		if ( checkMemberModifyAuthKeyRd.isFail() ) {
			return rq.historyBackJsOnview(checkMemberModifyAuthKeyRd.getMsg());
		}
		
		return "usr/member/modify";
	  } 
	
	@RequestMapping("/usr/member/doModify")
	@ResponseBody
	public String doModify(HttpServletRequest req, String memberModifyAuthKey, String loginPw, String name, String nickname, String email,
			String cellphoneNo, MultipartRequest multipartRequest) {
			if ( Ut.empty(memberModifyAuthKey)) {
			return rq.jsHistoryBack("memberModifyAuthKey(???)??? ???????????????.");
		}

		ResultData checkMemberModifyAuthKeyRd = memberService.checkMemberModifyAuthKey(rq.getLoginedMemberId(), memberModifyAuthKey);
		
		if ( checkMemberModifyAuthKeyRd.isFail() ) {
			return rq.jsHistoryBack(checkMemberModifyAuthKeyRd.getMsg());
		}
			loginPw = null;

		ResultData modifyRd = memberService.modify(rq.getLoginedMemberId(), loginPw, name, nickname, email,
				cellphoneNo);

		if (req.getParameter("deleteFile__member__0__extra__profileImg__1") != null ) {
			System.out.println("?????????.");
			genFileService.deleteGenFiles("member", rq.getLoginedMemberId(), "extra", "profileImg", 1);
		}
		
		Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();

		for (String fileInputName : fileMap.keySet()) {
			MultipartFile multipartFile = fileMap.get(fileInputName);

			if (multipartFile.isEmpty() == false) {
				genFileService.save(multipartFile, rq.getLoginedMemberId());
			}
		}

		return rq.jsReplace(modifyRd.getMsg(), "/usr/member/myPage");
	}
}