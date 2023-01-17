

<!--- <cfif question_limit EQ attributes.question_row> --->
	<cfoutput>
	<form method="post" action="#xfa.submit_quiz#" name="make_quiz">
	<input type="Hidden" name="quiz_id" id="quiz_id" value="#attributes.quiz_id#">
	</cfoutput>
<!--- <cfelse>
	<form method="post" name="make_quiz">
</cfif> --->

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
<cfoutput query="get_quiz_question">
	<!--- <script type="text/javascript">
		// zamanlayıcı triger
	    setTimeout("document.make_quiz.submit()", #submit_time#);
	</script> --->
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="txtbold">
	  <tr>
	      <td><cf_get_lang_main no='1398.Soru'> #attributes.question_row# : #question# <br/><br/></td>
	  </tr>
	<cfif ANSWER_NUMBER NEQ 0>
	  <!--- <cfset right_number = 0>
	  <cfloop from="1" to="#answer_number#" index="i">
			<cfif evaluate("answer#i#_true") eq 1>
				<cfset right_number = right_number + 1>
			</cfif>
	  </cfloop> --->
	  <cfloop from="1" to="20" index="i">
	  <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
	  <tr>
		  <td>
		  <cfswitch expression="#ANSWER_TYPE#">
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
		  <cf_get_lang no='246.Bilgi'> :
		  #question_info#
	      </td>
	  </tr>
	</cfif>
	<cfif question_limit EQ attributes.question_row>
	  	<tr>
	        <td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="57650.Dök"></cfsavecontent>
			<cf_workcube_buttons is_upd='0' insert_info='#message#'>
			<input type="Reset" value="Sıfırla" style="width:65px;"></td>
	  	</tr>
	<cfelse>
	  	<tr>
	        <td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="55568.Sonraki Soru"></cfsavecontent>
			<cf_workcube_buttons is_upd='0' insert_info='#message#'>
			<input type="Reset" value="Sıfırla" style="width:65px;"></td>
	  	</tr>
	</cfif>
	</table>
</cfoutput>			
</form>
