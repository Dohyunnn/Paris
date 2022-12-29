<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="아이디 찾기" />
<%@ include file="../common/head.jspf" %>

<script>
  let MemberFindLoginId__submitDone = false;
  function MemberFindLoginId__submit(form) {
    if (MemberFindLoginId__submitDone) {
      alert('처리중입니다.');
      return;
    }
    form.name.value = form.name.value.trim();
    if (form.name.value.length == 0) {
      alert('이름을 입력해주세요.');
      form.name.focus();
      return;
    }
    form.email.value = form.email.value.trim();
    if (form.email.value.length == 0) {
      alert('이메일을 입력해주세요.');
      form.email.focus();
      return;
    }
    
    MemberFindLoginId__submitDone = true;
    form.submit();
  }
</script>

<section class="mt-5">
  <div class="container mx-auto px-3">
    <form class="table-box-type-1" method="POST" action="../member/doFindLoginId" onsubmit="MemberFindLoginId__submit(this); return false;">
    <input type="hidden" name="afterFindLoginIdUri" value="${param.afterFindLoginIdUri}"/>
      <table>
        <colgroup>
          <col width="200" />
        </colgroup>
        <tbody>
          <tr>
            <th>이름</th>
            <td>
              <input name="name" type="text" placeholder="이름" class=" w-96 input input-bordered w-full max-w-xs" />
            </td>
          </tr>
          <tr>
            <th>이메일</th>
            <td>
            <input name="email" type="text" placeholder="이메일" class=" w-96 input input-bordered w-full max-w-xs" />
            </td>
          </tr>
          <tr>
            <th>아이디 찾기</th>
            <td>
              <button type="submit" class="btn btn-primary">아이디 찾기</button>
              <button type="button" class="btn btn-outline btn-success" onclick="history.back();">뒤로가기</button>
            </td>
          </tr>
          <tr>
            <th>비고</th>
            <td>
              <a href="/usr/member/login" type="submit" class="btn btn-link">로그인</a>
              <a href="../member/findLoignPw" type="submit" class="btn btn-link">비밀번호 찾기</a>
            </td>
          </tr>
        </tbody>
      </table>
    </form>
   </div>
</section>

<%@ include file="../common/foot.jspf"%>