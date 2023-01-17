<br/>
<cfset name_liste = "">
<cfset agirlik_liste = "">
<cfset puan_liste = "">
<cfset puan_list_2 = "">
<cfset max_point_list = "">
<cfset max_point = 0 >
<cfset entry_emp_id = "">
<cfif get_quiz_chapters.recordcount>
	<cfoutput query="get_quiz_chapters">
		<cfloop from="1" to="20" index="x">
			<cfif Evaluate('ANSWER#x#_POINT') gt max_point>
				<cfset max_point = Evaluate('ANSWER#x#_POINT')>
			</cfif>
		</cfloop>
		<cfquery name="get_agirlik_2" datasource="#dsn#">
			SELECT 	
				QUESTION_POINT,
				TP.ENTRY_EMP_ID
			FROM 
				EMPLOYEE_QUIZ_QUESTION EQQ,
				TRAINING_PERFORMANCE TP,
				EMPLOYEE_QUIZ_RESULTS EQR,
				EMPLOYEE_QUIZ_RESULTS_DETAILS EQRD,
				EMPLOYEES E
			WHERE
				EQQ.CHAPTER_ID=#CHAPTER_ID# AND
				TP.TRAINING_QUIZ_ID = #ATTRIBUTES.QUIZ_ID# AND
				TP.CLASS_ID = #ATTRIBUTES.CLASS_ID# AND
				EQR.QUIZ_ID = #ATTRIBUTES.QUIZ_ID# AND
				EQR.RESULT_ID = EQRD.RESULT_ID AND
				EQR.TRAINING_PERFORMANCE_ID = TP.TRAINING_PERFORMANCE_ID AND
				EQRD.QUESTION_ID = EQQ.QUESTION_ID AND
				TP.ENTRY_EMP_ID = E.EMPLOYEE_ID AND
				EQRD.GD <> 1
		</cfquery>
		<cfset entry_emp_list=''>
		<cfif get_agirlik_2.recordcount>
			<cfquery name="GET_QUIZ_QUESTIONS_ANSWER" datasource="#dsn#">
				SELECT 
					*
				FROM 
					EMPLOYEE_QUIZ_QUESTION
				WHERE
					CHAPTER_ID=#CHAPTER_ID#
			</cfquery>
			<cfset max_chapter_point =0>
			<cfset max_chapter_point = INT(wrk_round(chapter_weight/GET_QUIZ_QUESTIONS_ANSWER.RECORDCOUNT*max_point))*GET_QUIZ_QUESTIONS_ANSWER.RECORDCOUNT><!--- DB'de QUESTION_POINT alanı integer olduğundan tam sayıya yuvarlayarak atıyordu burdadad integer fonksiyonu ile tam sayısı alınarak soru sayısı ile çarpıldı ve maximum puan hesaplandı --->
			<!--- #chapter_weight#--#GET_QUIZ_QUESTIONS_ANSWER.RECORDCOUNT#--#max_point#--#max_chapter_point#<br/> --->
			<cfset this_puan_ = 0>
			<cfset list_len = 0>
			<cfloop query="get_agirlik_2">
				<cfset this_puan_ = this_puan_ + get_agirlik_2.QUESTION_POINT>
				<cfif not listfind(entry_emp_list,get_agirlik_2.ENTRY_EMP_ID,',')>
					<cfset entry_emp_list=ListAppend(entry_emp_list,get_agirlik_2.ENTRY_EMP_ID,',')>
				</cfif>
			</cfloop>
			<cfset list_len = listlen(entry_emp_list,',')>
			<cfset this_point_ = this_puan_ / get_agirlik_2.recordcount>
			<cfset name_liste = listappend(name_liste,chapter)>
			<cfset puan_liste = listappend(puan_liste,this_puan_/list_len)>
			<cfset puan_list_2 = listappend(puan_list_2,max_chapter_point)>
		</cfif>
	</cfoutput>
	<cfif listlen(name_liste)>
		<cfset count_ = 0>
			<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
				<tr>
					<td>
					<font color="0000FF">Bölüm Ortalamaları Raporu 2</font><br/>
					<cfset colorlist="d099ff,6666cc,33cc33,cc6600,ff6600,ffcc00,ff66ff,999933,cccc99,996699,339999,ccff66,ccccff,6699ff"> 
					<cfchart format="jpg" chartwidth="300" chartheight="250" fontsize="12" labelformat="number" showlegend="yes" xaxistitle="Puan" yaxistitle="Eğitim Soruları" tipBGColor="0099FF" scalefrom="0" scaleto="100" font="Arial" pieslicestyle="solid">	
					<cfchartseries type="#attributes.graph_type#"  paintstyle="plain" colorlist="#colorlist#">
							 <cfset count_2 = 0>
							 <cfloop list="#name_liste#" index="i">
								<cfset count_2 = count_2 + 1>
								<cfset deger_2 = wrk_round((listgetat(puan_liste,count_2) * 100) / listgetat(puan_list_2,count_2))>
								<cfchartdata  item="#i#" value="#deger_2#">
							</cfloop>
					 </cfchartseries>
					</cfchart>
				</td>
				</tr>
			</table>
	</cfif>
</cfif>
