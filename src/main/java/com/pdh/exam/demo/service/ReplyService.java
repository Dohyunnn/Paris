package com.pdh.exam.demo.service;

import org.springframework.stereotype.Service;

import com.pdh.exam.demo.repository.ReplyRepository;
import com.pdh.exam.demo.utill.Ut;
import com.pdh.exam.demo.vo.ResultData;
import com.pdh.exam.demo.vo.Rq;

@Service
public class ReplyService {
	private ReplyRepository replyRepository;
	private Rq rq;

	public ReplyService(ReplyRepository replyRepository, Rq rq) {
		this.replyRepository = replyRepository;
		this.rq = rq;
	}

	public ResultData<Integer> writeReply(int actorId, String relTypeCode, int relId, String body) {
		replyRepository.writeReply(actorId, relTypeCode, relId, body);
		int id = replyRepository.getLastInsertId();

		return ResultData.from("S-1", Ut.f("%d번 댓글이 생성되었습니다.", id), "id", id);
	}
}