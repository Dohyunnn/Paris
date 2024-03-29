package com.pdh.exam.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pdh.exam.demo.service.ArticleService;
import com.pdh.exam.demo.service.ReplyService;
import com.pdh.exam.demo.utill.Ut;
import com.pdh.exam.demo.vo.Article;
import com.pdh.exam.demo.vo.Reply;
import com.pdh.exam.demo.vo.ResultData;
import com.pdh.exam.demo.vo.Rq;

@Controller
public class UsrReplyController {	
	private ReplyService replyService;
	private ArticleService articleService;
	private Rq rq;

	public UsrReplyController(ReplyService replyService, ArticleService articleService, Rq rq) {
		this.replyService = replyService;
		this.articleService = articleService;
		this.rq = rq;
	}

	@RequestMapping("/usr/reply/doWrite")
	@ResponseBody
	public String doJoin(String relTypeCode, int relId, String body, String replaceUri) {
		if ( Ut.empty(relTypeCode) ) {
			return rq.jsHistoryBack("relTypeCode(을)를 입력해주세요.");
		}

		if ( Ut.empty(relId) ) {
			return  rq.jsHistoryBack("relId(을)를 입력해주세요.");
		}

		if ( Ut.empty(body) ) {
			return  rq.jsHistoryBack("body(을)를 입력해주세요.");
		}	

		ResultData<Integer> writeReplyRd = replyService.writeReply(rq.getLoginedMemberId(), relTypeCode, relId, body);
		int id = writeReplyRd.getData1();

		if ( Ut.empty( replaceUri )) {
			switch (relTypeCode) {
			case "article":
				replaceUri = Ut.f("../article/detail?id=%d", relId);
				break;
			}
		}


		return rq.jsReplace(writeReplyRd.getMsg(), replaceUri);
	}
	
	@RequestMapping("/usr/reply/doDelete")
	@ResponseBody
	public String doDelete(int id, String replaceUri) {
		if ( Ut.empty(id) ) {
			return rq.jsHistoryBack("id(을)를 입력해주세요.");
		}

		Reply reply = replyService.getForPrintReply(rq.getLoginedMemberId(), id);

		if ( reply == null ) {
			return rq.jsHistoryBack(Ut.f("%d번 댓글은 존재하지 않습니다.", id));
		}

		if ( reply.isExtra__actorCanDelete() == false ) {
			return rq.jsHistoryBack(Ut.f("%d번 댓글을 삭제할 권한이 없습니다.", id));
		}

		ResultData deleteReplyRd = replyService.deleteReply(id);

		if ( Ut.empty( replaceUri )) {
			switch (reply.getRelTypeCode()) {
			case "article":
				replaceUri = Ut.f("../article/detail?id=%d", reply.getRelId());
				break;
			}
		}

		return rq.jsReplace(deleteReplyRd.getMsg(), replaceUri);
	}
	
	@RequestMapping("/usr/reply/doDeleteAjax")
	@ResponseBody
	public ResultData doDeleteAjax(int id) {
		if ( Ut.empty(id) ) {
			return ResultData.from("F-1","id(을)를 입력해주세요.");
		}

		Reply reply = replyService.getForPrintReply(rq.getLoginedMemberId(), id);

		if ( reply == null ) {
			return ResultData.from("F-2", Ut.f("%d번 댓글은 존재하지 않습니다.", id));
		}

		if ( reply.isExtra__actorCanDelete() == false ) {
			return ResultData.from("F-3", Ut.f("%d번 댓글을 삭제할 권한이 없습니다.", id));
		}

		ResultData deleteReplyRd = replyService.deleteReply(id);

		return ResultData.from("S-1", deleteReplyRd.getMsg());
	}
	
	@RequestMapping("/usr/reply/modify")
	public String modify(int id, String replaceUri, Model model) {
		if ( Ut.empty(id) ) {
			return rq.jsHistoryBack("id(을)를 입력해주세요.");
		}

		Reply reply = replyService.getForPrintReply(rq.getLoginedMemberId(), id);

		if ( reply == null ) {
			return rq.jsHistoryBack(Ut.f("%d번 댓글은 존재하지 않습니다.", id));
		}

		if ( reply.isExtra__actorCanDelete() == false ) {
			return rq.jsHistoryBack(Ut.f("%d번 댓글을 수정할 권한이 없습니다.", id));
		}

		String relDataTitle = null;

		switch (reply.getRelTypeCode()) {
		case "article":
			Article article = articleService.getArticle(reply.getRelId());
			relDataTitle = article.getTitle();
		}

		model.addAttribute("relDataTitle", relDataTitle);
		model.addAttribute("reply", reply);


		return "usr/reply/modify";
  }
	
	@RequestMapping("/usr/reply/doModify")
	@ResponseBody
	public String doModify(int id, String body, String replaceUri) {
		if ( Ut.empty(id) ) {
			return rq.jsHistoryBack("id(을)를 입력해주세요.");
		}

		Reply reply = replyService.getForPrintReply(rq.getLoginedMemberId(), id);

		if ( reply == null ) {
			return rq.jsHistoryBack(Ut.f("%d번 댓글은 존재하지 않습니다.", id));
		}

		if ( reply.isExtra__actorCanDelete() == false ) {
			return rq.jsHistoryBack(Ut.f("%d번 댓글을 수정할 권한이 없습니다.", id));
		}

		if ( Ut.empty(body) ) {
			return rq.jsHistoryBack("body(을)를 입력해주세요.");
		}

		ResultData modifyReplyRd = replyService.modifyReply(id, body);

		if ( Ut.empty( replaceUri )) {
			switch (reply.getRelTypeCode()) {
			case "article":
				replaceUri = Ut.f("../article/detail?id=%d", reply.getRelId());
				break;
			}
		}

		return rq.jsReplace(modifyReplyRd.getMsg(), replaceUri);
	}
}