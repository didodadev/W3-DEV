<cfsetting showdebugoutput="no">
<cfquery name="get_survey_participants" datasource="#dsn#">
	SELECT 
		SURVEY_MAIN_RESULT_ID,
		PARTNER_ID,
		CONSUMER_ID,
		EMP_ID,
		COMPANY_ID,
		SCORE_RESULT,
		RECORD_IP,
		UPDATE_IP,
		RECORD_EMP
	FROM 
		SURVEY_MAIN_RESULT 
	WHERE 
		SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> 
	ORDER BY 
		SURVEY_MAIN_RESULT_ID DESC
</cfquery>
<cfif fuseaction contains 'objects'>
	<cfset fuseact = 'popup_add_detailed_survey_main_result'>
	<cfset fuseact2 = 'popup_form_upd_detailed_survey_main_result'>
<cfelse>
	<cfset fuseact = 'form_add_detailed_survey_main_result'>
	<cfset fuseact2 = 'form_upd_detailed_survey_main_result'>
</cfif>
<table class="dph" align="center">
	<tr>
    	<td><h1><cf_get_lang dictionary_id="29779.Analiz Sonucu"></h1></td>
    	<td style="text-align:right;">
            <table style="text-align:right;">
            <cfform name="list_participants" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_participants">
                <input type="hidden" name="survey_id" id="survey_id" value="<cfoutput>#attributes.survey_id#</cfoutput>">
                <input type="hidden" name="action_type" id="action_type" value="<cfoutput>#attributes.action_type#</cfoutput>">
                <tr> 
                    <td><cfoutput>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_detailed_analyse_result&survey_id=#attributes.survey_id#','page','popup_dsp_analyse_result');"><img src="/images/grafi.gif" alt="<cf_get_lang_main no='723.Sonuçlar'>"  title="<cf_get_lang_main no='723.Sonuçlar'>" border="0"></a>
                        </cfoutput>
                    </td>
                </tr>
            </cfform>
            </table>
        </td>
     </tr>
</table>
<table class="big_list" align="center">
	<thead>
        <tr> 
            <th width="25"><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='29780.Katılımcı'></th>
            <th width="50"><cf_get_lang dictionary_id='58984.Puan'></th>
            <th width="100"><cf_get_lang dictionary_id='29779.Analiz Sonucu'></th>
			<!---<th width="20">
				 bence hiç eklenemesin sm <cfif attributes.action_type neq 8><!--- performans tipi ise burdan form eklenemesin--->
					<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#fuseact#&survey_id=#attributes.survey_id#&action_type=#attributes.action_type#</cfoutput>"><img src="images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>"></a>
				</cfif> 
			</th>--->
	   </tr>
    </thead>
    <tbody>
	<cfif get_survey_participants.recordcount>
		<cfoutput query="get_survey_participants"> 
			<tr class="color-row">
				<td align="left">#currentrow#</td>
				<td height="2" nowrap="nowrap">
					<!--- Kurumsal ise --->
					<cfif len(partner_id)>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium','popup_par_det');" class="tableyazi">#get_par_info(partner_id,0,1,0)#</a>
						(<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium','popup_com_det');" class="tableyazi">#get_par_info(partner_id,0,-1,0)#</a>)
					<!--- bireysel ise --->
					<cfelseif len(consumer_id)>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium','popup_con_det');" class="tableyazi">#get_cons_info(consumer_id,0,0)#</a>
					<!--- calisan ise --->
					<cfelseif len(emp_id)>
						<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id#','medium');">#get_emp_info(emp_id,0,0)#</a>
					<!--- calisan ise --->
					<cfelseif len(record_emp)>
						<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');">#get_emp_info(record_emp,0,0)#</a>
					<!--- site ziyaretcisi --->
					<cfelse>
						<cfif len(update_ip)>
							#update_ip#
						<cfelseif len(record_ip)>
							#record_ip#
						</cfif>
					</cfif>
				</td>
				<td style="text-align:right">
					<!---<cfquery name="total_point" datasource="#dsn#">
						SELECT 
							SUM(OPTION_POINT) AS TOTAL_POINT_ 
						FROM 
							SURVEY_QUESTION_RESULT 
						WHERE 
							SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_participants.survey_main_result_id#"> AND 
							SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> 
						</cfquery>
						<cfif total_point.TOTAL_POINT_ gt 0>#total_point.TOTAL_POINT_#<cfelse>0</cfif>--->
					#TlFormat(score_result,0)#
				</td>
				<td>
					<cfquery name="get_survey" datasource="#dsn#">
						SELECT ISNULL(TOTAL_SCORE,0) TOTAL_SCORE,ISNULL(SCORE1,0) SCORE1,COMMENT1,SCORE2,COMMENT2,SCORE3,COMMENT3,SCORE4,COMMENT4,SCORE5,COMMENT5 FROM SURVEY_MAIN WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
					</cfquery>
					<cfset "new_score6" = get_survey.TOTAL_SCORE+1>
					<cfloop from="1" to="5" index="scr">
						<cfset "new_score#scr#" = Evaluate("get_survey.score#scr#")>
						<cfif scr neq 5><cfset "new_score#scr+1#" = Evaluate("get_survey.score#scr+1#")></cfif>
						<cfif not Len(Evaluate("new_score#scr#"))><cfset "new_score#scr#" = score_result></cfif>
						<cfif not Len(Evaluate("new_score#scr+1#"))><cfset "new_score#scr+1#" = score_result></cfif>
						<cfif (score_result gte Evaluate("new_score#scr#")) and (score_result lt Evaluate("new_score#scr+1#"))>
							#Evaluate("get_survey.comment#scr#")#
						</cfif> 
					</cfloop>
					<!--- <cfset "new_score6" = total_point.TOTAL_POINT_>
					<cfloop from="1" to="5" index="scr">
					<cfset "new_score#scr#" = Evaluate("get_survey.score#scr#")>
					<cfif scr neq 5><cfset "new_score#scr+1#" = Evaluate("get_survey.score#scr+1#")></cfif>
					<cfif not Len(Evaluate("new_score#scr#"))><cfset "new_score#scr#" = total_point.TOTAL_POINT_></cfif>
					<cfif not Len(Evaluate("new_score#scr+1#"))><cfset "new_score#scr+1#" = total_point.TOTAL_POINT_></cfif>
					<cfif (total_point.TOTAL_POINT_ lt Evaluate("new_score#scr#")) and (total_point.TOTAL_POINT_ gte Evaluate("new_score#scr+1#"))>
					#Evaluate("get_survey.comment#scr#")#
					</cfif> 
					</cfloop> --->
				</td>
				<!--- <td width="20" align="center"><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#fuseact2#&survey_id=#attributes.survey_id#&result_id=#get_survey_participants.survey_main_result_id#"><img src="images/update_list.gif" border="0" alt="<cf_get_lang_main no='52.Güncelle'>"></a></td> --->
			</tr>
		  </cfoutput> 
	 <cfelse>
		<tr height="20">
			<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
		</tr>
	 </cfif>
    </tbody>
</table>
