<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="관리자페이지 회원리스트" />
<%@ include file="../common/head.jspf" %>

<section class="mt-5">
  <div class="container mx-auto px-3">
    <div class="flex">
      <div>
        회원 수 : <span class="text-blue-700">${membersCount}</span>명
      </div>
      <div class="flex-grow"></div>
      <form class="flex">

       <select data-value="${authLevel}" name="authLevel"class="select select-bordered">
          <option disabled="disabled">회원종류</option>
          <option value="3">일반회원</option>
          <option value="7">관리자</option>
          <option value="0">전부</option>
        </select>

        <select data-value="${param.searchKeywordTypeCode}" name="searchKeywordTypeCode"class="select select-bordered">
          <option disabled="disabled">검색타입</option>
          <option value="loginId">로그인아이디</option>
          <option value="name">이름</option>
          <option value="nickname">닉네임</option>
          <option value="loginId,name,nickname">전부</option>
        </select>

        <input name="searchKeyword" type="text" class="ml-2 w-72 input input-bordered" placeholder="검색어" maxlength="20" value="${param.searchKeyword}"/>

        <button type="submit" class="ml-2 btn btn-primary">검색</button>
      </form>
    </div>
    <div class="mt-3">
      <table class="table table-fixed w-full">
        <colgroup>
          <col />
          <col />
          <col />
          <col />
          <col />
          <col />
        </colgroup>
        <thead>
          <tr>
            <th>번호</th>
            <th>가입날짜</th>
            <th>갱신날짜</th>
            <th>아이디</th>
            <th>이름</th>
            <th>별명</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="member" items="${members}">
            <tr class="hover">
              <th>${member.id}</th>
              <td>${member.forPrintType1RegDate}</td>
              <td>${member.forPrintType1UpdateDate}</td>
              <td>${member.loginId}</td>
              <td>${member.name}</td>
              <td>${member.nickname}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>

    <div class="page-menu mt-4">
      <div class="btn-group justify-center">
        <c:set var="pageMenuArmLen" value="9" />
        <c:set var="startPage" value="${page - pageMenuArmLen >= 1 ? page - pageMenuArmLen : 1}" />
        <c:set var="endPage" value="${page + pageMenuArmLen <= pagesCount ? page + pageMenuArmLen : pagesCount}" />

        <c:set var="pageBaseUri" value="?authLevel=${authLevel}" />
        <c:set var="pageBaseUri" value="${pageBaseUri}&searchKeyword=${param.searchKeyword}" />
        <c:set var="pageBaseUri" value="${pageBaseUri}&searchKeywordTypeCode=${param.searchKeywordTypeCode}" />

        <c:if test="${startPage > 1}">
          <a class="btn btn-sm " href="${pageBaseUri}&page=1">1</a>
          <c:if test="${startPage > 2}">
            <a class="btn btn-sm btn-disabled">...</a>
          </c:if>
        </c:if>

        <c:forEach begin="${startPage}" end="${endPage}" var="i">
          <a class="btn btn-sm ${page == i ? 'btn-active' : '' }" href="${pageBaseUri}&page=${i}">${i}</a>
        </c:forEach>

        <c:if test="${endPage < pagesCount}">
          <c:if test="${endPage < pagesCount - 1}">
            <a class="btn btn-sm btn-disabled">...</a>
          </c:if>
          <a class="btn btn-sm" href="${pageBaseUri}&page=${pagesCount}">${pagesCount}</a>
        </c:if>
      </div>
    </div>

  </div>
</section>

<%@ include file="../common/foot.jspf" %>