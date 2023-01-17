<cfinclude template="../query/get_training_eval_quiz_chapters.cfm">
<!---<cfquery name="get_qu_con" datasource="#DSN#">
	SELECT
		CLASS_ID
	FROM
		TRAINING_CLASS_EVAL
	WHERE
		CLASS_ID =#attributes.CLASS_ID#
</cfquery>--->
<cfif  LEN(attributes.quiz_id) and isdefined("attributes.quiz_id")>
<table cellpadding="0" cellspacing="0" style="height:290mm;width:210mm;" align="center" border="0" bordercolor="#CCCCCC">
	<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
	</tr>
<tr>
<td valign="top" height="100%">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <cfif isdefined("attributes.kapak_bas")>
    <tr>
	   <td class="headbold" height="35" align="center"><font color="##CC0099"><cfoutput>#attributes.kapak_bas#</cfoutput></font></td>
	</tr>
  </cfif>
  <tr>
    <td class="headbold" height="35" align="center"><font color="#CC0000"><cf_get_lang no='224.Katılımcı Değerlendirme Formları'></font></td>
  </tr>
</table>
		<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
		
    <!---<cfif isdefined("attributes.list")>--->
	   <cfif get_quiz_chapters.recordcount>
		  
		  <cfif isdefined("attributes.gr_type") and len(attributes.gr_type)>
           <cfparam name="attributes.graph_type" default="#attributes.gr_type#">
          <cfelse>
            <cfparam name="attributes.graph_type" default="bar">
          </cfif>
		  
		   
			<tr>
			  <td class="txtbold">&nbsp;</td>
				<td  align="center" style="writing-mode : tb-rl;"><cf_get_lang_main no='1572.Puan'></td>
			 </tr>
			<cfoutput query="get_quiz_chapters">
			<cfset ANSWER_NUMBER_GELEN = get_quiz_chapters.ANSWER_NUMBER>
			<cfset attributes.CHAPTER_ID = CHAPTER_ID>
			<cfinclude template="../query/get_training_eval_quiz_questions.cfm">
	<cfif isdefined("attributes.list")>
			<cfif get_quiz_questions.RecordCount>
			  <tr height="20">
				<!---<td class="formbold" colspan="#get_emp_att.RecordCount+1#">#chapter#</td>--->
				<td class="formbold">#chapter#</td>
			  </tr>
			  <cfif len(chapter_info)>
				<tr height="20" class="txtbold">
				  <!---<td colspan="#get_emp_att.RecordCount+1#">#chapter_info# </td>--->
				  <td>#chapter_info# </td>
				</tr>
			  </cfif>
			  <!--- Sorular basliyor --->
			 
			 <cfloop query="get_quiz_questions">
			  
			  <cfset attributes.QUESTION_ID = get_quiz_questions.QUESTION_ID>
			  <tr height="20">
				<td nowrap width="100%">#get_quiz_questions.currentrow#- #get_quiz_questions.question#  </td>
			<cfif ANSWER_NUMBER_gelen NEQ 0>
						<!---<cfset puan_veren = 0>
					<cfset point_found = 0>--->
				
			<cfloop list="#attributes.class_id_list#" index="i">
			  <cfset attributes.class_id= i>
			  <cfquery name="get_qu_con" datasource="#DSN#">
	             SELECT
		           CLASS_ID
	             FROM
		           TRAINING_CLASS_EVAL
	             WHERE
		            CLASS_ID =#attributes.CLASS_ID#
             </cfquery>
	          <cfif (get_qu_con.recordcount) and LEN(attributes.quiz_id)> 
			    	
				 <cfinclude template="../query/get_report_queries.cfm">	
				 <cfinclude template="../query/get_upd_class_queries.cfm">	
				<cfset puan_veren = 0>
				<cfset point_found = 0>
				<cfloop query="get_emp_att">
			
					<cfset attributes.emp_id_currentrow = get_emp_att.currentrow>
					<cfset attributes.emp_id = get_emp_att.emp_id>
				
					
					<cfquery name="GET_QUIZ_RESULT" datasource="#dsn#">
						SELECT 
							QUESTION_POINT 
						FROM 
							TRAINING_CLASS_EVAL,
							TRAINING_CLASS_EVAL_DETAILS
						WHERE 
							TRAINING_CLASS_EVAL.CLASS_EVAL_ID=TRAINING_CLASS_EVAL_DETAILS.CLASS_EVAL_ID
						AND 
							TRAINING_CLASS_EVAL.EMP_ID=#attributes.emp_id# 
						AND
							TRAINING_CLASS_EVAL.QUIZ_ID = #attributes.quiz_id# 
						AND
							TRAINING_CLASS_EVAL.CLASS_ID = #attributes.CLASS_ID# 
						AND
							TRAINING_CLASS_EVAL_DETAILS.QUESTION_ID = #attributes.QUESTION_ID#
					</cfquery>
					<cfif GET_QUIZ_RESULT.RECORDCOUNT AND GET_QUIZ_RESULT.QUESTION_POINT>
						<cfset point_found = point_found +GET_QUIZ_RESULT.QUESTION_POINT>
						<cfset puan_veren=puan_veren+1>
					<cfelse>
					</cfif>
				</cfloop>
			 </cfif><!--- **** --->
			</cfloop><!---*********--->
				  <td  align="center"><cfif puan_veren neq 0>#evaluate(point_found/puan_veren)#<cfelse>0</cfif></td>
			 
			  <cfelse>
			  <td style="text-align:right;"> </td>
			  </tr>
		    </cfif>
			
			<cfif len(question_info)>
			  <tr height="20" class="txtbold">
				<td colspan="2">#get_quiz_questions.question_info#</td>
			  </tr>
			</cfif>
			
			</cfloop>
			
			<cfelse>
		  </cfif>
	</cfif>	  
		  
			<!--- **************************--->
		<!---<tr>
		   <td>
		     <cfset colorlist="d099ff,6666cc,33cc33,cc6600,ff6600,ffcc00,ff66ff,999933,cccc99,996699,339999,ccff66,ccccff,6699ff">
            <cfchart format="jpg" chartwidth="500" fontsize="12"	labelformat="number" showlegend="yes"
				xaxistitle="Puan"	yaxistitle="Eğitim Soruları" tipBGColor="0099FF" scaleto="5" font="Arial" >
            <cfchartseries	 type="#attributes.graph_type#"  paintstyle="plain" colorlist="#colorlist#">
           <cfloop query="get_quiz_questions" >
              <cfset attributes.QUESTION_ID = get_quiz_questions.QUESTION_ID>
              <cfif ANSWER_NUMBER_gelen NEQ 0>
                <cfset katilim=0>
                <cfset puan=0>
                <cfloop query="get_emp_att">
                  <cfset attributes.emp_id_currentrow = get_emp_att.currentrow>
                  <cfset attributes.emp_id = get_emp_att.emp_id>
                  <cfquery name="GET_QUIZ_RESULT" datasource="#dsn#">
					SELECT 
					  QUESTION_POINT 
					FROM 
					  TRAINING_CLASS_EVAL,
					  TRAINING_CLASS_EVAL_DETAILS
					WHERE 
					  TRAINING_CLASS_EVAL.CLASS_EVAL_ID = TRAINING_CLASS_EVAL_DETAILS.CLASS_EVAL_ID
						 AND 
					  TRAINING_CLASS_EVAL.EMP_ID=#attributes.emp_id# AND
					  TRAINING_CLASS_EVAL.QUIZ_ID = #attributes.QUIZ_ID# 
						AND 
					 TRAINING_CLASS_EVAL.CLASS_ID = #attributes.CLASS_ID# 
						AND 
					 TRAINING_CLASS_EVAL_DETAILS.QUESTION_ID = #attributes.QUESTION_ID#
                  </cfquery>
                  <cfif GET_QUIZ_RESULT.RECORDCOUNT AND GET_QUIZ_RESULT.QUESTION_POINT>
                    <cfset point_found = GET_QUIZ_RESULT.QUESTION_POINT>
                    <cfset katilim=katilim+1>
                    <cfset puan=puan + point_found>
                    <cfelse>
                    <cfset point_found = "">
                  </cfif>
                </cfloop><!--- #LEFT(get_quiz_questions.question,15)# --->
					 <cfset my_st="Soru #currentrow# ">
					<cfif katilim neq 0>
					 <cfset puan_katilim = evaluate(puan/katilim)>
					  <cfif len(my_st) and len(puan_katilim) and isdefined("katilim") and (katilim neq 0)>
				         <cfchartdata  item="#my_st#" value="#puan_katilim#" >
                      </cfif> 
					</cfif> 
               
			  </cfif>
			</cfloop>
            </cfchartseries>
            </cfchart>
		   </td>
		 </tr>--->
			<!--- ************************--->
	  <!---		<cfelse>
		  </cfif>--->
		  </cfoutput>
		<cfelse>
		</cfif>
		</table>
	</td>
</tr>
<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
</tr>
</table>
</cfif>

