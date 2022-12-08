package com.pdh.exam.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.pdh.exam.demo.repository.ArticleRepository;
import com.pdh.exam.demo.repository.BoardRepository;
import com.pdh.exam.demo.utill.Ut;
import com.pdh.exam.demo.vo.Article;
import com.pdh.exam.demo.vo.Board;
import com.pdh.exam.demo.vo.ResultData;

@Service
public class BoardService {
	private BoardRepository boardRepository;

	public BoardService(BoardRepository boardRepository) {
		this.boardRepository = boardRepository;
	}

	public Board getBoardById(int id) {
		return boardRepository.getBoardById(id);
	}

}