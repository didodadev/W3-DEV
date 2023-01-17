<cf_get_lang_set module_name="training">
<cfset xfa.submit_quiz = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_calc_quiz">
<cfinclude template="../query/get_quiz.cfm">
<cfif isdefined('session.ep')>
	<cfset attributes.employee_id = session.ep.userid>
<cfelse>
	<cfset attributes.employee_id =  ''>
</cfif>
<cfif isdefined("attributes.class_id") and len(attributes.class_id)>
	<cfset attributes.class_id = attributes.class_id>
</cfif>
<cfinclude template="../query/get_user_join_quiz.cfm">

<!--- kullanıcı kendine ait olmayan testi göremez --->
<cfif isdefined('session.ep') and listgetat(session.ep.userkey,1,"-") is "e" and (get_quiz.quiz_departments is "") and (get_quiz.quiz_position_cats is "") >
	  <script type="text/javascript">
	 	{
			alert("<cf_get_lang_main no='120.Yetkiniz Yok'> ");
			window.close();
		}
	 </script>
	 <cfabort>
	<!--- <cflocation url="#request.self#?fuseaction=training.list_quizs" addtoken="No"> --->
</cfif>

<!--- Kullanıcı Sınava kaç kez girmiş kontrol et --->
<!--- <cfif not ((dateformat(get_quiz.quiz_startdate,dateformat_style) lte dateformat(now(),dateformat_style)) and (dateformat(get_quiz.quiz_finishdate,dateformat_style) gte dateformat(now(),dateformat_style)))>
	<cf_get_lang no='64.Test süresi dolmuştur'> !
	<cfabort>
</cfif> --->
<cfif get_user_join_quiz.recordcount GTE get_quiz.take_limit>
	<cf_get_lang no='63.Sınava girme limitini doldurdunuz !'>
	<cfabort>
</cfif>
<cfinclude template="../query/get_quiz_question_count.cfm">
<cfif get_quiz_question_count.COUNTED eq 0>
	Kayıtlı soru bulunamadı
	<cfabort>
</cfif>
<!--- kaç soru sorulacak --->
<cfif get_quiz_question_count.counted LT get_quiz.max_questions>
	<cfset question_limit = get_quiz_question_count.counted>
<cfelse>
	<cfset question_limit = get_quiz.max_questions>
</cfif>
<cfsavecontent variable="right">
    <form name="saat" id="saat" onsubmit="return false;">
        <cf_get_lang no='65.Kalan Süre'>: <input type="text" name="saat" id="saat" style="width:70px;border:none; font-size:14px;font-weight:bold;color:red;">
    </form>
</cfsavecontent>
<cf_popup_box title="#getLang('main',1414)# : #get_quiz.quiz_head#" right_images='#right#'>
	<cfif get_quiz.random eq 1>
        <!--- session tanımlı değil ise --->
        <cfif not isDefined("session.random_list")>
            <cfinclude template="../query/get_quiz_question_id_list.cfm">
            <!--- soruları karıştır --->
            <cfset question_list = valuelist(get_quiz_question_id_list.question_id)>
            <cfset random_list="">
            <cfscript>
                while ( (ListLen(random_list) LTE question_limit) and (ListLen(question_list) gt 0))
                    {
                    location = randRange(1,ListLen(question_List));
                    random_list = ListAppend(random_List,ListGetAt(question_list,location));
                    question_list = ListDeleteAt(question_list,location);
                    }	
            </cfscript>
            <cfset session.random_list = random_list>
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
                <cfinclude template="../query/get_quiz_question2.cfm">
                <cfinclude template="dsp_mqr2.cfm">
            </cfcase>
            <!--- soru cevap ardarda --->
            <cfcase value="3">
                <cfparam name="attributes.question_row" default="1">
                <cfset attributes.question_id=ListGetAt(session.random_list,attributes.question_row)>
                <cfinclude template="../query/get_quiz_question2.cfm">
                <cfinclude template="dsp_mqr3.cfm">
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
                <cfinclude template="../query/get_quiz_question.cfm">
                <cfinclude template="dsp_mq2.cfm">
            </cfcase>
            <!--- soru cevap ardarda --->
            <cfcase value="3">
                <cfparam name="attributes.question_row" default="1">
                <cfinclude template="../query/get_quiz_question.cfm">
                <cfinclude template="dsp_mq3.cfm">
            </cfcase>
        </cfswitch>
    </cfif>
    <cfif not isDefined("attributes.view_answer")>
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
                document.saat.saat.value = dakika+":"+sn;
                sn = sn -1;
                }
        }
        zaman();
        </script>
    </cfif>
    <script LANGUAGE="JavaScript1.1">
    function right(e) {
    /*
    if (event.type == 'unload') 
        {
        sayfa kapanınca yapılacaklar
        window.opener.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=training.quiz_results&quiz_id=<cfoutput>#attributes.quiz_id#</cfoutput>';
        }
    */
    if (navigator.appName == 'Netscape' && (e.which == 3 || e.which == 2)) return false;
    else if (navigator.appName == 'Microsoft Internet Explorer' && (event.button == 2 || event.button == 3)) 
        {
        /*zamanı durdurduğu için kapattım*/
        alert('Sağ tıklama izniniz yok.');
        return false;
        }
    
    if (event.altKey || event.ctrlKey) 
        {
        alert('Kısayol tuşlarına izniniz yok.');
        return false;
        }
    return true;
    }
    /*document.onmousedown=right;
    document.onmouseup=right;*/
    document.onkeydown=right;
    /*document.onunload=right;*/
    /*if (document.layers) window.captureEvents(Event.MOUSEDOWN);
    if (document.layers) window.captureEvents(Event.MOUSEUP);*/
    if (document.layers) window.captureEvents(Event.KEYDOWN);
    /*if (document.layers) window.captureEvents(Event.UNLOAD);*/
    window.onmousedown=right;
    window.onmouseup=right;
    window.onkeydown=right;
    /*window.onunload=right;*/
    </script>
</cf_popup_box>
