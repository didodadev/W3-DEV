<cfif question_limit EQ attributes.question_row>
	<!--- veritabanına ilk kaydı gir --->
	<cfset session.quiz_start = now()>
	<cfset session.quiz_id = attributes.quiz_id>
	<cfinclude template="../query/add_quiz_result.cfm">
</cfif>


<!--- toplam süre yada soru süresi hesabı sonucu tek değişkene at --->
<cfif get_quiz.total_time is "">
	<cfset submit_time = get_quiz_question2.question_time*60000>
<cfelse>
	<cfset submit_time = round(get_quiz.total_time/question_limit)*60000>
</cfif>
<cfif question_limit EQ attributes.question_row>
	<cfoutput>
	<form method="post" action="#xfa.submit_quiz#" name="make_quiz" id="make_quiz">
	<input type="Hidden" name="quiz_id" id="quiz_id" value="#attributes.quiz_id#">
	<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
	</cfoutput>
<cfelse>
	<form method="post" name="make_quiz">
</cfif>
<input type="Hidden" name="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" id="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" value="">
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
	
	<table width="98%" align="center">
	  <tr>
	      <td><strong><cf_get_lang_main no='1398.Soru'> #attributes.question_row#:</strong> #question# <br/><br/></td>
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
			<td><textarea name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" cols="60" rows="4"></textarea></td>
		</tr>
	</cfif>
	<cfif len(question_info)>
	  <tr>
		  <td>
		  <br/>
		  <strong><cf_get_lang_main no='217.Açıklama'>:</strong>
		  #question_info#
	      </td>
	  </tr>
	</cfif>
	<cfif question_limit EQ attributes.question_row>
	  	<tr>
	        <td width="600">
		<cfsavecontent variable="message"><cf_get_lang no='1.Sınavı Bitir'></cfsavecontent>
	  	<cf_workcube_buttons is_upd='0' insert_info='#message#'>          
		<!--- <input type="Reset" value="Reset" name="Reset" style="width:65px;"> --->
        </td>
	  	</tr>
	<cfelse>
	  	<tr>
	        <td width="600">
			<cfif attributes.question_row gt 1>
				<cfsavecontent variable="message6">Geri</cfsavecontent>
				<input type="button" onClick="history.go(-1);" value="<cfoutput>#message6#</cfoutput>" name="Back" id="Back" style="width:75px;">
			</cfif>
			<cfsavecontent variable="message1"><cf_get_lang no='9.Sonraki Soru'></cfsavecontent>
			<cf_workcube_buttons is_upd='0'  insert_info='#message1#'>          
        <!---   <input type="Reset" value="Reset" name="Reset2" style="width:65px;"> --->
        </td>
	  	</tr>
	</cfif>
	</table>
</cfoutput>			
</form>
