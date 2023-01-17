<!--- <cfif question_limit EQ attributes.question_row>
	<cfinclude template="../query/add_quiz_result.cfm">
</cfif> --->
<!--- toplam süre yada soru süresi hesabı sonucu tek değişkene at --->
<cfif get_quiz.total_time is "">
	<cfset submit_time = get_quiz_question2.question_time*60000>
<cfelse>
	<cfset submit_time = round(get_quiz.total_time/question_limit)*60000>
</cfif>
<cfif question_limit EQ attributes.question_row>
	<form method="post" action="<cfoutput>#xfa.submit_quiz#</cfoutput>" name="make_quiz">
<cfelse>
	<form method="post" name="make_quiz">
</cfif>
<input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
<input type="Hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
<input type="Hidden" name="page_type" id="page_type" value="<cfoutput>#attributes.page_type#</cfoutput>">
<input type="Hidden" name="is_stopped_quiz" id="is_stopped_quiz" value="">
<input type="Hidden" name="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" id="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" value="0">
<!--- önceki cevapları ekle --->
<cfloop from="1" to="#evaluate(attributes.question_row-1)#" index="i">
	<cfoutput><input type="Hidden" name="user_answer_#i#" id="user_answer_#i#" value="#htmleditformat(evaluate("form.user_answer_#i#"))#"></cfoutput>
</cfloop>
<cfif isDefined("attributes.open_question")>
	<input type="Hidden" name="open_question" id="open_question" value="1">
</cfif>
<input type="Hidden" name="question_row" id="question_row" value="<cfoutput>#evaluate(attributes.question_row+1)#</cfoutput>">
<!--- sıradaki soruyu görüntüle --->			
<cfoutput query="get_quiz_question2">
	<script type="text/javascript">
		/*zamanlayıcı triger*/
	    setTimeout("document.make_quiz.submit()", #submit_time#);
	</script>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="txtbold">
	  <tr>
	      <td><cf_get_lang_main no='1398.Soru'> #attributes.question_row# : #question# <br/><br/></td>
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
		  #evaluate("answer"&i&"_text")#
	      </td>
	  </tr>
	  </cfif>
	  </cfloop>
	<cfelse>
		<input type="Hidden" name="open_question" id="open_question" value="1">
		<tr>
			<td><textarea name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" cols="45" rows="4"></textarea></td>
		</tr>
	</cfif>
	<cfif len(question_info)>
	  <tr>
		  <td>
		  <br/>
		  <cf_get_lang_main no='144.Bilgi'> :
		  #question_info#
	      </td>
	  </tr>
	</cfif>
	<cfif question_limit EQ attributes.question_row>
	  	<tr>
	        <td>
			<cfsavecontent variable="message6">Geri</cfsavecontent>
			<input type="button" onClick="history.go(-1);" value="<cfoutput>#message6#</cfoutput>" name="Back" id="Back" style="width:75px;">
			<!--- <cfsavecontent variable="message1">Sınavı Durdur</cfsavecontent>
			<input type="Reset" value="<cfoutput>#message1#</cfoutput>" name="Reset" style="width:75px;"> --->
			<cfsavecontent variable="message"><cf_get_lang no='251.Sınavı Bitir'></cfsavecontent>
			<cf_workcube_buttons is_upd='0' insert_info='#message#'>
        </td>
	  	</tr>
	<cfelse>
	  	<tr>
	        <td>
			<cfif attributes.question_row gt 1>
				<cfsavecontent variable="message6">Önceki Soru</cfsavecontent>
				<input type="button" onClick="history.go(-1);" value="<cfoutput>#message6#</cfoutput>" name="Back" id="Back" style="width:75px;">
			</cfif>
			 <cfsavecontent variable="message1">Sınavı Durdur</cfsavecontent>
			<input type="button" onClick="is_stopped_quiz_function();" value="<cfoutput>#message1#</cfoutput>" name="stopped" id="stopped" style="width:75px;">
			<cfsavecontent variable="message1"><cf_get_lang no='252.Sonraki Soru'></cfsavecontent>
			<cf_workcube_buttons is_upd='0' insert_info='#message1#'>
        </td>
	  	</tr>
	</cfif>
	</table>
</cfoutput>			
</form>
<script type="text/javascript">
	function is_stopped_quiz_function()
	{
		document.make_quiz.is_stopped_quiz.value = 1;
		document.make_quiz.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.calc_quiz";
		document.make_quiz.submit();
	}
</script>
