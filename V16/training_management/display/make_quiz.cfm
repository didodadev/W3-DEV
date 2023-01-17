<cfset xfa.submit_quiz = "#request.self#?fuseaction=training_management.calc_quiz">
<cfinclude template="../query/get_tra_quiz.cfm">
<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)>
	<cfset attributes.employee_id=attributes.emp_id>
<cfelse>
	<cfset attributes.employee_id=session.ep.userid>
</cfif>
<cfset cfc= createObject("component","V16.training_management.cfc.TrainingTest")>
<cfset  get_user_join_quiz = cfc.QUIZ_RESULT_COUNT(QUIZ_ID:attributes.QUIZ_ID,employee_id:attributes.employee_id,is_stop:0)>
<!---<cfif listgetat(session.ep.userkey,1,"-") is "e" and (get_quiz.quiz_departments is "")>--->
<cfif session.ep.userid neq get_quiz.record_emp><!--- kullanıcı kendine ait olmayan testi göremez--->
	  <script type="text/javascript">
	 	{
			alert("<cf_get_lang_main no='120.Yetkiniz Yok'> ");
			window.close();
		}
	 </script>
	 <cfabort>
</cfif>
<cfif get_user_join_quiz.recordcount GTE get_quiz.take_limit><!--- Kullanıcı Sınava kaç kez girmiş kontrol et --->
  <cf_get_lang no='53.Sınava girme limitini doldurdunuz'> !
  <cfabort>
</cfif>
<cfif not ((dateformat(get_quiz.quiz_startdate,"yyyymmdd") lte dateformat(now(),"yyyymmdd")) and (dateformat(get_quiz.quiz_finishdate,"yyyymmdd") gte dateformat(now(),"yyyymmdd")))>
  <cf_get_lang no='54.Test süresi dolmuştur'> !
  <cfabort>
</cfif>
<cfset  get_quiz_question_count = cfc.GET_QUIZ_QUESTIONS(QUIZ_ID:attributes.QUIZ_ID)>
<cfif get_quiz_question_count.COUNTED eq 0>
	<cf_get_lang no="46292.Kayıtlı soru bulunamadı">	
	<cfabort>
</cfif>
<!--- kaç soru sorulacak --->
<cfif get_quiz_question_count.counted LT get_quiz.max_questions>
  <cfset question_limit = get_quiz_question_count.counted>
<cfelse>
  <cfset question_limit = get_quiz.max_questions>
</cfif>

<cfif not isDefined("session.quiz_start")>
  <!--- veritabanına ilk kaydı gir --->
  <cfset session.quiz_start = now()>
<cfelse>
	 <cfset session.quiz_start = session.quiz_start>
</cfif>
<cfset session.quiz_id = attributes.quiz_id>
<cfsavecontent variable="right">
    <form name="saat" onsubmit="return false;">
        <cf_get_lang no='55.Kalan Süre'>:  <input type="text" name="saat" id="saat" style="width:70px;border:none; font-size:14px;font-weight:bold;color:red;">
    </form>
</cfsavecontent>
<cf_popup_box title='#get_quiz.quiz_head#' right_images='#right#'>
	<cfif get_quiz.random eq 1>
	  <!--- session tanımlı değil ise --->
	  <cfif not isDefined("session.random_list")>
		<cfinclude template="../query/get_quiz_question_id_list.cfm">
		<!--- soruları karıştır --->
		<cfset question_list = ValueList(GET_QUIZ_QUESTION_ID_LIST.QUESTION_ID)>
		<cfset random_list="">
		<cfscript>
			while ( (ListLen(random_list) LT question_limit) and (ListLen(question_list) gt 0))
				{
				location = randRange(1,ListLen(question_List));
				random_list = ListAppend(random_List,ListGetAt(question_list,location));
				question_list = ListDeleteAt(question_list,location);
				}
			session.random_list = random_list;
		</cfscript>
	  </cfif>
	  <!--- sorular karışık --->
	  <cfswitch expression="#get_quiz.quiz_type#">
		<!--- bütün sorular birarada --->
		<cfcase value="1">
		<!--- Sınav Sorularını al --->
			<cfset attributes.limit = question_limit>
			<cfinclude template="../query/get_quiz_questions.cfm">
			<cfinclude template="dsp_mqr1.cfm">
		</cfcase>
		<!--- sorular arka arkaya --->
		<cfcase value="2">
			<cfparam name="attributes.question_row" default="1">
			<cfset attributes.question_id=ListGetAt(session.random_list,attributes.question_row)>
			<cfif isdefined("attributes.result_id") and len(attributes.result_id)>
				<cfinclude template="../query/get_quiz_question2.cfm">
				<cfinclude template="dsp_mqr_upd2.cfm">
			<cfelse>
				<cfinclude template="../query/get_quiz_question2.cfm">
				<cfinclude template="dsp_mqr2.cfm">
			</cfif>
		</cfcase>
		<!--- soru cevap ardarda --->
		<cfcase value="3">
			<cfparam name="attributes.question_row" default="1">
			<cfset attributes.question_id=ListGetAt(session.random_list,attributes.question_row)>
			<cfif isdefined("attributes.result_id") and len(attributes.result_id)>
				<cfinclude template="../query/get_quiz_question2.cfm">
				<cfinclude template="dsp_mqr_upd3.cfm">
			<cfelse>
				<cfinclude template="../query/get_quiz_question2.cfm">
				<cfinclude template="dsp_mqr3.cfm">
			</cfif>
		</cfcase>
	  </cfswitch>
	  <cfelse>
	  <!--- sorular düzenli --->
	  <cfswitch expression="#get_quiz.quiz_type#">
		<!--- bütün sorular birarada --->
		<cfcase value="1">
			<cfset attributes.limit = question_limit>
			<cfinclude template="../query/get_quiz_questions.cfm">
			<cfinclude template="dsp_mq1.cfm">
		</cfcase>
		<!--- sorular arka arkaya --->
		<cfcase value="2">
			<cfparam name="attributes.question_row" default="1">
			<cfif isdefined("attributes.result_id") and len(attributes.result_id)>
				<cfinclude template="../query/get_quiz_question.cfm">
				<cfset attributes.question_id=GET_QUIZ_QUESTION.QUESTION_ID>
				<cfinclude template="dsp_mq_upd2.cfm">
			<cfelse>
				<cfinclude template="../query/get_quiz_question.cfm">
				<cfinclude template="dsp_mq2.cfm">
			</cfif>
		</cfcase>
		<!--- soru cevap ardarda --->
		<cfcase value="3">
			<cfparam name="attributes.question_row" default="1">
			<cfif isdefined("attributes.result_id") and len(attributes.result_id)>
				<cfinclude template="../query/get_quiz_question.cfm">
				<cfset attributes.question_id=GET_QUIZ_QUESTION.QUESTION_ID>
				<cfinclude template="dsp_mq_upd3.cfm">
			<cfelse>
				<cfinclude template="../query/get_quiz_question.cfm">
				<cfinclude template="dsp_mq3.cfm">
			</cfif>
		</cfcase>
	  </cfswitch>
	</cfif>
	<cfif not isDefined("attributes.view_answer") and isdefined("attributes.page_type") and attributes.page_type eq 2>
	  <script type="text/javascript">
		/*zamanlayıcı triger*/
		dakika = <cfoutput>#evaluate(submit_time/60000)#</cfoutput>;
		sn = 1;
		function zaman()
		{
			setTimeout("zaman()", 1000);
			if (sn == 0)
				{
				dakika = dakika-1;
				sn = 59;
				}
			if ((dakika >= 0) && (sn>=0))
				{
				saat.saat.value = dakika+":"+sn;
				sn = sn -1;
				}
		}
		zaman();
		</script>
	</cfif>
</cf_popup_box>
	<script LANGUAGE="JavaScript1.1">
	function right(e) 
	{
		if (navigator.appName == 'Netscape' && (e.which == 3 || e.which == 2)) return false;
		else if (navigator.appName == 'Microsoft Internet Explorer' && (event.button == 2 || event.button == 3)) 
		{
		/*zamanı durdurduğu için kapattım*/
		alert("<cf_get_lang no='76.Sağ Tıklama İzniniz Yok !'>");
		return false;
		}
		return true;
	}
	document.onkeydown=right;
	if (document.layers) window.captureEvents(Event.KEYDOWN);
	window.onmousedown=right;
	window.onmouseup=right;
	window.onkeydown=right;
</script>
