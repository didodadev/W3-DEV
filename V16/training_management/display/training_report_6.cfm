<cfinclude template="../query/get_training_eval_quiz_chapters.cfm">
<cfquery name="get_qu_con" datasource="#DSN#">
	SELECT CLASS_ID FROM TRAINING_PERFORMANCE WHERE	CLASS_ID =#attributes.CLASS_ID#
</cfquery>
<cfif get_qu_con.recordcount and LEN(attributes.quiz_id)>
<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
  <!---<tr><td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td></tr>--->
  <tr>
	  <td valign="top" height="100%">
	  	  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
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
					  <cfif get_quiz_questions.RecordCount>
						<tr height="20">
						  <td class="formbold" colspan="#get_emp_att.RecordCount+1#">#chapter#</td>
						</tr>
						<cfif len(chapter_info)>
						  <tr height="20" class="txtbold">
							<td colspan="#get_emp_att.RecordCount+1#">#chapter_info# </td>
						  </tr>
						</cfif>
						<!--- Sorular basliyor --->
						<cfif isdefined("attributes.list")>
						  <cfloop query="get_quiz_questions"> 
							  <cfset attributes.QUESTION_ID = get_quiz_questions.QUESTION_ID>
							  <tr height="20">
								<td width="100%">#get_quiz_questions.currentrow#- #get_quiz_questions.question# </td>
								<cfif ANSWER_NUMBER_gelen NEQ 0>
									<cfset puan_veren = 0>
									<cfset point_found = 0>
									<cfloop query="get_emp_att">
									  <cfset attributes.emp_id_currentrow = get_emp_att.currentrow>
									  <cfset attributes.emp_id = get_emp_att.emp_id>
									  <cfquery name="get_training_performance_id" datasource="#dsn#">
									  	SELECT TRAINING_PERFORMANCE_ID FROM TRAINING_PERFORMANCE WHERE CLASS_ID = #attributes.CLASS_ID# AND TRAINING_QUIZ_ID = #attributes.QUIZ_ID# AND ENTRY_EMP_ID = #attributes.emp_id# 
									  </cfquery>
									  <cfif get_training_performance_id.recordcount>
									  <cfquery name="GET_QUIZ_RESULT" datasource="#dsn#">
											SELECT
												QUESTION_POINT
											FROM
												EMPLOYEE_QUIZ_RESULTS,
												EMPLOYEE_QUIZ_RESULTS_DETAILS
											WHERE
												EMPLOYEE_QUIZ_RESULTS.RESULT_ID = EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID
												AND EMPLOYEE_QUIZ_RESULTS.TRAINING_PERFORMANCE_ID=#get_training_performance_id.TRAINING_PERFORMANCE_ID# 
												AND EMPLOYEE_QUIZ_RESULTS.QUIZ_ID = #attributes.QUIZ_ID#
												AND EMPLOYEE_QUIZ_RESULTS_DETAILS.QUESTION_ID = #attributes.QUESTION_ID#
									  </cfquery>
											<cfset point_found = point_found +GET_QUIZ_RESULT.QUESTION_POINT>
											<cfset puan_veren=puan_veren+1>
									  </cfif>
									</cfloop>
									<td  align="center">
										<cfif puan_veren neq 0>
											#evaluate(wrk_round(point_found/puan_veren))#
										<cfelse>
											0 
										 </cfif>
									</td>
								<cfelse>
									<td style="text-align:right;">&nbsp; </td>
						 	   </cfif>
							</tr>
						</cfloop>
					  	</cfif>
					</cfif>
				</cfoutput>
			</cfif>
		  </table>
	  </td>
  </tr>
  <!--- **************************** GRAPHICS ***************************** --->
  <tr> 
  <td>
  <br/>
  <br/>
  <table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
    <cfif get_quiz_chapters.recordcount>
      <cfoutput query="get_quiz_chapters">
      <cfif isdefined("attributes.gr_type") and len(attributes.gr_type)>
        <cfparam name="attributes.graph_type" default="#attributes.gr_type#">
        <cfelse>
        <cfparam name="attributes.graph_type" default="bar">
      </cfif>
      <cfset ANSWER_NUMBER_GELEN = get_quiz_chapters.ANSWER_NUMBER>
      <cfset attributes.CHAPTER_ID = CHAPTER_ID>
      <cfinclude template="../query/get_training_eval_quiz_questions.cfm">
      <cfset label = get_quiz_chapters.chapter[currentrow]>
      <cfif (currentrow mod 2) eq 1>
      <tr>
        <td>
          <cfelse>
        <td>
          </cfif>
			 <font color="0000FF">#label#</font><br/>
		<cfset colorlist="d099ff,6666cc,33cc33,cc6600,ff6600,ffcc00,ff66ff,999933,cccc99,996699,339999,ccff66,ccccff,6699ff"> 
		<cfchart format="jpg" chartwidth="300" chartheight="250" fontsize="12" labelformat="number" showlegend="yes" xaxistitle="Puan" yaxistitle="Eğitim Soruları" tipBGColor="0099FF" scaleto="5" font="Arial" pieslicestyle="solid">	
		<cfchartseries type="#attributes.graph_type#"  paintstyle="plain" colorlist="#colorlist#">
		  <cfloop query="get_quiz_questions" >
            <cfset attributes.QUESTION_ID = get_quiz_questions.QUESTION_ID>
            <cfif ANSWER_NUMBER_gelen NEQ 0>
              <cfset katilim=0>
              <cfset puan=0>
              <cfloop query="get_emp_att">
                <cfset attributes.emp_id_currentrow = get_emp_att.currentrow>
                <cfset attributes.emp_id = get_emp_att.emp_id>
				 <cfquery name="get_training_performance_id" datasource="#dsn#">
					SELECT TRAINING_PERFORMANCE_ID FROM TRAINING_PERFORMANCE WHERE CLASS_ID = #attributes.CLASS_ID# AND TRAINING_QUIZ_ID = #attributes.QUIZ_ID# AND ENTRY_EMP_ID = #attributes.emp_id# 
				  </cfquery>
				  <cfif get_training_performance_id.recordcount>
				  <cfquery name="GET_QUIZ_RESULT" datasource="#dsn#">
						SELECT
							QUESTION_POINT
						FROM
							EMPLOYEE_QUIZ_RESULTS,
							EMPLOYEE_QUIZ_RESULTS_DETAILS
						WHERE
							EMPLOYEE_QUIZ_RESULTS.RESULT_ID = EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID
							AND EMPLOYEE_QUIZ_RESULTS.TRAINING_PERFORMANCE_ID=#get_training_performance_id.TRAINING_PERFORMANCE_ID# 
							AND EMPLOYEE_QUIZ_RESULTS.QUIZ_ID = #attributes.QUIZ_ID#
							AND EMPLOYEE_QUIZ_RESULTS_DETAILS.QUESTION_ID = #attributes.QUESTION_ID#
				  </cfquery>
                  	<cfset point_found = GET_QUIZ_RESULT.QUESTION_POINT>
                 	 <cfset katilim=katilim+1>
                 	 <cfset puan=puan + point_found>
                  <cfelse>
                  	<cfset point_found = "">
                </cfif>
              </cfloop>
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
          <cfif (currentrow mod 2) eq 1>
        </td>
        <cfelse>
      </td>
      </tr>
    </cfif>
    </cfoutput>
    </cfif> 
  </table>
  <br/>
  <cfset name_list = "">
  <cfset agirlik_list = "">
  <cfset puan_list = "">
  <cfset son_list = "">
  <cfset toplam_puan_ = 0>
  <cfif get_quiz_chapters.recordcount>
		<cfoutput query="get_quiz_chapters">
			<cfquery name="get_agirlik" datasource="#dsn#">
				SELECT 	
					QUESTION_POINT
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
			<cfif get_agirlik.recordcount>
				<cfset this_puan_ = 0>
				<cfloop query="get_agirlik">
					<cfset this_puan_ = this_puan_ + get_agirlik.QUESTION_POINT>
				</cfloop>
				<cfset this_point_ = this_puan_ / get_agirlik.recordcount>
				<cfset name_list = listappend(name_list,chapter)>
				<cfset agirlik_list = listappend(agirlik_list,chapter_weight)>
				<cfset puan_list = listappend(puan_list,this_point_)>
			</cfif>
		</cfoutput>
			<cfif get_agirlik.recordcount and listlen(name_list)>
				<cfset count_ = 0>
				<cfloop list="#name_list#" index="i">
					<cfset count_ = count_ + 1>
					<cfset dogru_puan_ = listgetat(agirlik_list,count_) * listgetat(puan_list,count_)>
					<cfset son_list = listappend(son_list,dogru_puan_)>
					<cfset toplam_puan_  = toplam_puan_ + dogru_puan_>
				</cfloop>
					<cfif len(son_list) and son_list gt 0 and len(toplam_puan_) and toplam_puan_ gt 0>
						<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
							<tr>
								<td>
								<font color="0000FF">Bölüm Ortalamaları Raporu</font><br/>
								<cfset colorlist="d099ff,6666cc,33cc33,cc6600,ff6600,ffcc00,ff66ff,999933,cccc99,996699,339999,ccff66,ccccff,6699ff"> 
								<cfchart format="jpg" chartwidth="300" chartheight="250" fontsize="12" labelformat="number" showlegend="yes" xaxistitle="Puan" yaxistitle="Eğitim Soruları" tipBGColor="0099FF" scalefrom="0" scaleto="100" font="Arial" pieslicestyle="solid">	
								<cfchartseries type="#attributes.graph_type#"  paintstyle="plain" colorlist="#colorlist#">
										 <cfset count_ = 0>
										 <cfloop list="#name_list#" index="i">
											<cfset count_ = count_ + 1>
											<cfset deger_ = wrk_round((listgetat(son_list,count_) * 100) / toplam_puan_)>
											<cfchartdata  item="#i#" value="#deger_#">
										</cfloop>
								 </cfchartseries>
								</cfchart>
							</td>
							</tr>
						</table>
					</cfif>
					<cfinclude template="training_report6_include.cfm">
			</cfif>
  </cfif>
  </td>
  </tr>
  <!--- **************************** //GRAPHICS ***************************** --->
  <!---<tr><td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td></tr>--->
</table>
</cfif>
