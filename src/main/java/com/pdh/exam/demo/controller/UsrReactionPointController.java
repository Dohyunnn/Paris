package com.pdh.exam.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pdh.exam.demo.service.ReactionPointService;
import com.pdh.exam.demo.vo.ResultData;
import com.pdh.exam.demo.vo.Rq;

@Controller
public class UsrReactionPointController {
	private ReactionPointService reactionPointService;
	private Rq rq;

	public UsrReactionPointController(ReactionPointService reactionPointService, Rq rq) {
		this.reactionPointService = reactionPointService;
		this.rq = rq;
	}

	@RequestMapping("/usr/reactionPoint/doGoodReaction")
	@ResponseBody
	String doGoodReaction(String relTypeCode, int relId, String replaceUri) {
		ResultData actorCanMackReactionPointRd = reactionPointService.actorCanMakeReactionPoint(rq.getLoginedMemberId(), relTypeCode, relId);

		if (actorCanMackReactionPointRd.isFail()) {
			return rq.jsHistoryBack(actorCanMackReactionPointRd.getMsg());
		}

		ResultData addGoodReactionPoint = reactionPointService.addGoodReactionPoint(rq.getLoginedMemberId(), relTypeCode, relId);

		return rq.jsReplace(addGoodReactionPoint.getMsg(), replaceUri);
	}

	@RequestMapping("/usr/reactionPoint/doCancelGoodReaction")
	@ResponseBody
	String doCancelGoodReaction(String relTypeCode, int relId, String replaceUri) {
		ResultData actorCanMackReactionPointRd = reactionPointService.actorCanMakeReactionPoint(rq.getLoginedMemberId(), relTypeCode, relId);

		if (actorCanMackReactionPointRd.isSuccess()) {
			return rq.jsHistoryBack("이미 취소되었습니다.");
		}

		ResultData deleteGoodReactionPoint = reactionPointService.deleteGoodReactionPoint(rq.getLoginedMemberId(), relTypeCode, relId);

		return rq.jsReplace(deleteGoodReactionPoint.getMsg(), replaceUri);
	}

	@RequestMapping("/usr/reactionPoint/doBadReaction")
	@ResponseBody
	String doBadReaction(String relTypeCode, int relId, String replaceUri) {
		
		ResultData actorCanMackReactionPointRd = reactionPointService.actorCanMakeReactionPoint(rq.getLoginedMemberId(), relTypeCode, relId);

		if (actorCanMackReactionPointRd.isFail()) {
			return rq.jsHistoryBack(actorCanMackReactionPointRd.getMsg());
		}

		ResultData addBadReactionPoint = reactionPointService.addBadReactionPoint(rq.getLoginedMemberId(), relTypeCode, relId);

		return rq.jsReplace(addBadReactionPoint.getMsg(), replaceUri);
	}

	@RequestMapping("/usr/reactionPoint/doCacelBadReaction")
	@ResponseBody
	String doCancelBadReaction(String relTypeCode, int relId, String replaceUri) {
		ResultData actorCanMackReactionPointRd = reactionPointService.actorCanMakeReactionPoint(rq.getLoginedMemberId(), relTypeCode, relId);

		if (actorCanMackReactionPointRd .isSuccess()) {
			return rq.jsHistoryBack("이미 취소되었습니다.");
		}

		ResultData deleteBadReactionPoint = reactionPointService.deleteBadReactionPoint(rq.getLoginedMemberId(), relTypeCode, relId);
		return rq.jsReplace(deleteBadReactionPoint.getMsg(), replaceUri);
	}
}