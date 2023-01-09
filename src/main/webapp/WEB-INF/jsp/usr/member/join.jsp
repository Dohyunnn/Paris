<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.pdh.exam.demo.utill.Ut"%>
<c:set var="pageTitle" value="회원가입" />
<%@ include file="../common/head.jspf"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.20/lodash.min.js"></script>

<script>
	let submitJoinFormDone = false;
	let validLogind = "";
	function submitJoinForm(form) {
		if (submitJoinFormDone) {
			alert('처리중입니다.');
			return;
		}
		
		form.loginId.value = form.loginId.value.trim();
		if (form.loginId.value.length == 0) {
			alert('로그인아이디를 입력해주세요.');
			form.loginId.focus();
			return;
		}
		
		if (form.loginId.value != validLogind) {
			alert('해당 로그인아이디는 올바르지 않습니다. 다른 로그인아이디를 입력해주세요.');
			form.loginId.focus();
			return;
		}

		form.loginPwInput.value = form.loginPwInput.value.trim();
		if (form.loginPwInput.value.length == 0) {
			alert('비밀번호를 입력해주세요.');
			form.loginPwInput.focus();
			return;
		}
		form.loginPwConfirm.value = form.loginPwConfirm.value.trim();
		if (form.loginPwConfirm.value.length == 0) {
			alert('비밀번호확인을 입력해주세요.');
			form.loginPwConfirm.focus();
			return;
		}
		if (form.loginPwInput.value != form.loginPwConfirm.value) {
			alert('비밀번호확인이 일치하지 않습니다.');
			form.loginPwConfirm.focus();
			return;
		}
		form.name.value = form.name.value.trim();
		if (form.name.value.length == 0) {
			alert('이름을 입력해주세요.');
			form.name.focus();
			return;
		}
		form.nickname.value = form.nickname.value.trim();
		if (form.nickname.value.length == 0) {
			alert('닉네임을 입력해주세요.');
			form.nickname.focus();
			return;
		}
		form.email.value = form.email.value.trim();
		if (form.email.value.length == 0) {
			alert('이메일을 입력해주세요.');
			form.email.focus();
			return;
		}
		form.cellphoneNo.value = form.cellphoneNo.value.trim();
		if (form.cellphoneNo.value.length == 0) {
			alert('휴대전화번호를 입력해주세요.');
			form.cellphoneNo.focus();
			return;
		}
		
		const maxSizeMb = 10;
		const maxSize = maxSizeMb * 1204 * 1204;
		
		const profileImgFileInput = form["file__member__0__extra__profileImg__1"];
		
		if( profileImgFileInput.value ) {
			if ( profileImgFileInput.files[0].size > maxSize ) {
				alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
				profileImgFileInput.focus();
				
				return;
			}
		}
		
		form.loginPw.value = sha256(form.loginPwInput.value);
		form.loginPwInput.value = '';
		form.loginPwConfirm.value = '';
		
		submitJoinFormDone = true;
		form.submit();
	}
	
	function checkLoginDup(el) {
		const form = $(el).closest('form').get(0);
		
		if ( form.loginId.value.length == 0 ) {
			validLogind = '';
			return;
		}	
	
		if ( validLogind == form.loginId.value ) {
			return;
		}
		$.get( '../member/getLoginIdDup', {
			  isAjax: 'Y',
			  loginId: form.loginId.value
		 	}, function(data) {
		
		var $massage = $(form.loginId).next();
		
		if ( data.resultCode.substr(0, 2) == 'S-') {
    		$massage.empty().append('<div class="mt-2 text-green-500">'+ data.msg +'</div>');
    		validLogind = data.data1;
    	} else {
    		$massage.empty().append('<div class="mt-2 text-red-500">'+ data.msg +'</div>');
    		validLogind = '';
    	}
    			
    	if (data.success) {
		  	validLogind = data.data1;
		} else {
		  	validLogind = '';
		}
		
		 	  }, 'json');
 	}
 	
 	const checkLoginDupDebounced = _.debounce(checkLoginDup, 300);
	
</script>

<section class="mt-5">
  <div class="container mx-auto px-3">
    <div class="table-box-type-1">
       <form class="table-box-type-1" method="POST" enctype="multipart/form-data" action="../member/doJoin" onsubmit="submitJoinForm(this); return false;">
        <input type="hidden" name="afterJoinUri" value="${param.afterJoinUri}"/>
          <input type="hidden" name="loginPw">  
             <table>
          <colgroup>
            <col width="200" />
          </colgroup>
          <tbody>
            <tr>
              <th>로그인아이디</th>
              <td>
                <input class="input input-bordered" name="loginId" placeholder="로그인아이디" type="text" onkeyup="checkLoginDupDebounced(this);" autocomplete="off"/>
                <div class="massage-msg"></div>
              </td>
            </tr>
            <tr>
              <th>로그인비밀번호</th>
              <td>
                <input class="input input-bordered" name="loginPwInput" placeholder="로그인비밀번호" type="password" />
              </td>
            </tr>
            <tr>
              <th>로그인비밀번호 확인</th>
              <td>
                <input class="input input-bordered" name="loginPwConfirm" placeholder="로그인비밀번호 확인" type="password" />
              </td>
            </tr>
            <tr>
              <th>이름</th>
              <td>
                <input class="input input-bordered" name="name" placeholder="이름" type="text" />
              </td>
            </tr>
            <tr>
              <th>닉네임</0th>
              <td>
                <input class="input input-bordered" name="nickname" placeholder="닉네임" type="text" />
              </td>
            </tr>
            <tr>
            <th>프로필 이미지</th>
              <td>
             <input accept="image/gif, image/jpeg, image/png" name="file__member__0__extra__profileImg__1" placeholder="프로필 이미지를 선택해주세요" type="file" />
              </td>
            </tr>
            <tr>
              <th>이메일</th>
              <td>
                <input class="input input-bordered" name="email" placeholder="이메일" type="text" />
              </td>
            </tr>
            <tr>
              <th>휴대전화번호</th>
              <td>
                <input class="input input-bordered" name="cellphoneNo" placeholder="휴대전화번호" type="text" />
              </td>
            </tr>
            <tr>
              <th>회원가입</th>
              <td>
                <button type="submit" class="btn btn-primary">회원가입</button>
                <button type="button" class="btn btn-outline btn-success" onclick="history.back();">뒤로가기</button>
              </td>
            </tr>
          </tbody>
        </table>
      </form>
    </div>
  </div>
</section>

<%@ include file="../common/foot.jspf"%>