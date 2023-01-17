<!--- <cfif ((isdefined("get_quiz_question.recordcount") and not get_quiz_question.recordcount) or (question_limit EQ attributes.question_row))>
	<cfif isdefined("form.view_answer")><cfinclude template="../query/add_quiz_result.cfm"></cfif>
</cfif> --->
<cfif (not get_quiz_question2.recordcount) or (ListLen(session.random_list) EQ attributes.question_row)>
	<cfif isDefined("attributes.view_answer")>
		<form method="post" action="<cfoutput>#xfa.submit_quiz#</cfoutput>" name="make_quiz">
	<cfelse>
		<form method="post" name="make_quiz">
	</cfif>
<cfelse>
<form method="post" name="make_quiz">
  </cfif>
  <input type="Hidden" name="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" id="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" value="">
  <input type="Hidden" name="is_stopped_quiz" id="is_stopped_quiz" value="">
  <input type="Hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
  <input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
  <input type="Hidden" name="page_type" id="page_type" value="<cfoutput>#attributes.page_type#</cfoutput>">
  <!--- önceki cevapları ekle --->
  <cfif isdefined("form.view_answer")>
    <cfloop from="1" to="#attributes.question_row#" index="i">
      <cfoutput>
        <input type="Hidden" name="user_answer_#i#" id="user_answer_#i#" value="#htmleditformat(evaluate("form.user_answer_#i#"))#">
      </cfoutput>
    </cfloop>
    <cfelse>
    <cfloop from="1" to="#evaluate(attributes.question_row-1)#" index="i">
      <cfoutput>
        <input type="Hidden" name="user_answer_#i#" id="user_answer_#i#" value="#htmleditformat(evaluate("form.user_answer_#i#"))#">
      </cfoutput>
    </cfloop>
  </cfif>
  <cfif isDefined("attributes.open_question")>
    <input type="Hidden" name="open_question" id="open_question" value="1">
  </cfif>
  <cfif isDefined("attributes.view_answer")>
    <input type="Hidden" name="question_row" id="question_row" value="<cfoutput>#evaluate(attributes.question_row+1)#</cfoutput>">
    <!--- cevabı görüntüle --->
    <table class="txtbold">
      <tr>
        <td><cf_get_lang no='48.Doğru Cevaplar'> :<br/>
          <br/>
        </td>
      </tr>
      <cfloop from="1" to="#get_quiz_question2.ANSWER_NUMBER#" index="k">
        <cfset temp_bool = evaluate("get_quiz_question2.answer#k#_true")>
        <cfif temp_bool eq 1>
          <tr>
            <td>
              <cfset temp_photo = evaluate("get_quiz_question2.answer#k#_photo")>
              <cfoutput>
                <cfif len(temp_photo)>
                  <img src="#file_web_path#training/#evaluate("get_quiz_question2.answer#k#_photo")#" border="0">
                </cfif>
                #evaluate("get_quiz_question2.answer"&k&"_text")# </cfoutput> </td>
          </tr>
        </cfif>
      </cfloop>
      <cfif (not get_quiz_question2.recordcount) or (ListLen(session.random_list) EQ attributes.question_row)>
        <tr>
          <td><br/>
            <br/>
		  <cfsavecontent variable="message"><cf_get_lang no='251.Sınavı Bitir'></cfsavecontent>
            <cf_workcube_buttons 
			is_upd='0' 
			insert_info='#message#' 
			><!--- add_function='#xfa.submit_quiz#'---> 
        </tr>
        <cfelse>
        <tr>
          <td><br/>
            <br/>
			<cfsavecontent variable="message6"><cf_get_lang no="97.Önceki Soru"></cfsavecontent>
			<input type="button" onClick="history.go(-1);" value="<cfoutput>#message6#</cfoutput>" name="Back" id="Back" style="width:75px;">
	  		<cfsavecontent variable="message1"><cf_get_lang no='252.Sonraki Soru'></cfsavecontent>
            <cf_workcube_buttons 
				is_upd='0' 
				insert_info='#message1#' 
				insert_alert=''> 
			</td>
        </tr>
      </cfif>
    </table>
    <cfelse>
    <input type="Hidden" name="question_row" id="question_row" value="<cfoutput>#attributes.question_row#</cfoutput>">
    <input type="Hidden" name="view_answer" id="view_answer" value="1">
    <!--- toplam süre yada soru süresi hesabı sonucu tek değişkene at --->
    <cfif get_quiz.total_time is "">
      <cfset submit_time = get_quiz_question2.question_time*60000>
      <cfelse>
      <cfset submit_time = round(get_quiz.total_time/question_limit)*60000>
    </cfif>
    <!--- soruyu görüntüle --->
    <cfoutput query="get_quiz_question2">
      <script type="text/javascript">
			/*zamanlayıcı triger*/
		    setTimeout("document.make_quiz.submit()", #submit_time#);
		</script>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="txtbold">
        <tr>
          <td><cf_get_lang_main no='1398.Soru'> #attributes.question_row# : #question# <br/>
            <br/>
          </td>
        </tr>
        <cfif ANSWER_NUMBER NEQ 0>
          <cfset right_number = 0>
          <cfloop from="1" to="#answer_number#" index="i">
            <cfif evaluate("answer#i#_true") eq 1>
              <cfset right_number = right_number + 1>
            </cfif>
          </cfloop>
          <cfloop from="1" to="20" index="i">
            <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
              <tr>
                <td>
                  <cfswitch expression="#right_number#">
                    <cfcase value="1">
                    <input type="Radio" name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" value="#i#">
                    </cfcase>
                    <cfdefaultcase>
                    <input type="checkbox" name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" value="#i#">
                    </cfdefaultcase>
                  </cfswitch>
                  <cfif len(evaluate("answer#i#_photo"))>
                    <img src="#file_web_path#training/#evaluate("answer#i#_photo")#" border="0">
                  </cfif>
                  #evaluate("answer"&i&"_text")# </td>
              </tr>
            </cfif>
          </cfloop>
          <cfelse>
          <input type="Hidden" name="open_question" id="open_question" value="1">
          <tr>
            <td><textarea name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" cols="45" rows="4"></textarea>
            </td>
          </tr>
        </cfif>
        <cfif len(question_info)>
          <tr>
            <td> <br/>
              <cf_get_lang_main no='144.Bilgi'>:#question_info# </td>
          </tr>
        </cfif>
        <tr>
          <td><br/>
            <br/>
			<cfif attributes.question_row gt 1>
				 <cfsavecontent variable="message1"><cf_get_lang dictionary_id="46073.Sınavı Durdur"></cfsavecontent>
				<input type="button" onClick="is_stopped_quiz_function();" value="<cfoutput>#message1#</cfoutput>" name="stopped" id="stopped" style="width:75px;">
				<cfsavecontent variable="message6"><cf_get_lang_main no="20.Geri"></cfsavecontent>
				<input type="button" onClick="history.go(-1);" value="<cfoutput>#message6#</cfoutput>" name="Back" id="Back" style="width:75px;">
			</cfif>
	  		<cfsavecontent variable="message3">Cevap</cfsavecontent>
			<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message3#' insert_alert=''>
          </td>
        </tr>
      </table>
    </cfoutput>
  </cfif>
</form>
<script type="text/javascript">
	function is_stopped_quiz_function()
	{
		document.make_quiz.is_stopped_quiz.value = 1;
		document.make_quiz.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.calc_quiz";
		document.make_quiz.submit();
	}
</script>

