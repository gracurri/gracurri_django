<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>��ȿ�� �˻� + ajax ���̵� �ߺ� �˻�</title>
<style type="text/css">
	.input-group{margin-bottom: 10px;}
	.input-group label { 
		color: #424242; 
		font-size: 15px; 
		padding-right: 10px; 
	}
</style>
<script type="text/javascript" src="<%=request.getContextPath() %>/resource/js/jquery-3.4.1.min.js"></script>
<script type="text/javascript">
	/*
		����ǽ�1. '����, ���̵�, �н�����, �н����� Ȯ��, �̸���, ����' ��
		��ȿ�� �˻縦 �ϴ� �ڵ带 �ۼ��ϰ�, ���̵�� ���̵� �ߺ��˻縦 �ϵ����Ͽ���.
		(���̵� �ߺ��˻� ajax : �ߺ��˻��ϴ� jsp �������� ���� ����� �ۼ��Ͻÿ�.)			
	*/
	$(function(){
		
		/************************************************
		���̵� �ߺ� üũ �Լ�
		�ۼ��� : ȫ�浿
		�ۼ��� : 2020-04-08
		'���̵� �ߺ��˻�', 'ȸ������' ��ưŬ���� ���� �ڵ�� 
		Ȯ���ϵ��� �ϱ����ؼ� �Լ��� ���� ����
		2������ ����ϰ� �񵿱�ȭ�� üũ�� ���ÿ� �Ұ����Ͽ�
		����ȭ��  ajax ����ϵ��� ����
		*************************************************/		
		var userIdCheck = function(){
			
			var userId = $('[name="userId"]').val();
			var getCheckData;
			
			//ajax ����ȭ
			var request = $.ajax({
				url: "ajaxIdCheck.jsp", //����� url
				method: "POST", //����� �޼��� Ÿ��
				data: { userId : userId }, //������ ����Ÿ
				dataType: "json",
				async : false //����ȭ��Ű��
			});	 
			request.done(function( data ) {
				if(data != undefined && data != ''){
					//����ȭ������ getCheckData�� ����� �޾�
					//�Ʒ� �ڵ忡�� ó�� ����
					getCheckData = data;
				}
			});	 
			request.fail(function( jqXHR, textStatus ) {
			  alert( "Request failed: " + textStatus );
			});
			
			//����ȭ ������� �Ͽ� ������� �޾� �ü� �־�
			//getCheckData ����Ÿ üũ
			if(getCheckData == undefined || getCheckData.result == 'Y'){
				alert('����� �� ���� ���̵� �Դϴ�.');
				$('[name="idCheck"]').val('N');
				return true;
			}else{
				$('[name="idCheck"]').val('Y');
			}
			return false;
		}
		
		/************************************************
		��ȿ�� �˻� �Լ�
		�ۼ��� : ȫ�浿
		�ۼ��� : 2020-04-08
		�ݺ��Ǵ� �۾��� �ּ�ȭ �ϱ����ؼ� �Լ��� ��ȿ�� �˻� ����
		�Լ� ���ϰ��� true �ϰ�� ����  
		!!��ü�� ��� Ű ���� ����
		1) target : üũ ���
		2) compareTarget : üũ ����� ���� �� �� ��� - ���� ���� ��� target�� ��
		3) lenTarget : ����Ÿ ���� üũ ��� - ���� ������ ��� length�� 0�̸� �ȵ�
		4) msg : ���� �߻��� ����� ����
		*************************************************/			
		var valueChecks = function(checkObj){
				
			var target = checkObj.target; //�� üũ ���
			var compareTarget = checkObj.compareTarget; //���� ��ġ �� ���
			var lenTarget = checkObj.lenTarget; //����Ÿ ���� 
			var msg = checkObj.msg; //���� �߻��� ����
			var isCheck = false; //������ ��� false �����ϰ�� true ��ȯ
						
			if(target != undefined){
				if(compareTarget != undefined){
					if(target.val() != compareTarget.val()){						
						alert(msg);
						compareTarget.val('')
						compareTarget.focus();
						isCheck = true;
					}
				}else if(lenTarget != undefined){
					if(lenTarget.length == 0){
						alert(msg);
						target.eq(0).focus();
						isCheck = true;
					}
				}else{
					if(target.val() == ''){						
						alert(msg);
						target.focus();
						isCheck = true;
					}						
				}
			}else{
				isCheck = true;
			}
			
			return isCheck;
		}
		
		//ȸ������ Ŭ�� �̺�Ʈ
		$('#joinBtn').click(function(){	
			if(valueChecks({target : $('[name="userName"]'), 	msg : 'ȸ������ �Է����ּ���.'})) return;
			if(valueChecks({target : $('[name="userId"]'), 		msg : 'ȸ�����̵� �Է����ּ���.'})) return;						
			if(valueChecks({target : $('[name="userPw"]'), 		msg : '�н����带 �Է����ּ���.'})) return;			
			if(valueChecks({target : $('[name="userPw"]'), 		msg : '�н����尡 Ʋ���ϴ�.', compareTarget : $('[name="userPwCheck"]')})) return;
			if(valueChecks({target : $('[name="userEmail"]'), 	msg : '�̸����� �Է����ּ���.'})) return;
			if(valueChecks({target : $('[name="userGender"]'), 	msg : '������ �Է����ּ���.', lenTarget : $('[name="userGender"]:checked')})) return;
			if(valueChecks({target : $('[name="idCheck"]'), 	msg : '�ƾƵ� �ߺ��˻縦 ���� ���ּ���.'})) return;	
			if(userIdCheck()) return;	//���̵� �ߺ� �˻� �ѹ��� �ǽ�		
			$('#joinFrom').submit();
			
		});
		//���̵� �ߺ��˻� Ŭ�� �̺�Ʈ
		$('#userIdCheck').click(function(){
			if(!userIdCheck()){
				alert('����� �� �ִ� ���̵� �Դϴ�.');
			}
		});
				
	});
</script>
</head>
<body>
	<form id="joinFrom" action="./ajaxEx01.jsp" method="post">
	
		<input type="hidden" name="idCheck">
		
		<div class="input-group">
			<label>ȸ���� </label>
			<input type="text" name="userName">
		</div>
		<div class="input-group">
			<label>���̵� </label>
			<input type="text" name="userId">
			<button type="button" id="userIdCheck">���̵� �ߺ� �˻�</button>
			<div id="userIdMsg"></div>
		</div>	
		<button type="button" id="joinBtn"> ȸ������ </button>
	</form>
</body>
</html>