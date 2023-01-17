<cfsetting showdebugoutput="no">
<cfquery name="GET_EMP_ADD" datasource="#dsn#">
	SELECT COUNT(EMP_ID) AS TOTAL,COUNT(CON_ID) AS TOTAL_CON,COUNT(PAR_ID) AS TOTAL_PAR FROM ORGANIZATION_ATTENDER WHERE ORGANIZATION_ID=#attributes.ORGANIZATION_ID# 
</cfquery>
<cf_ajax_list>
	<tr>
		<td><cf_get_lang_main no='1983.Katılımcı'>(<cf_get_lang dictionary_id='57576.Çalışan'>)</td>
		<td>: <cfoutput>#get_emp_add.total#</cfoutput></td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='1983.Katılımcı'>(<cf_get_lang dictionary_id='57256.Bireysel'>)</td>
		<td>: <cfoutput>#get_emp_add.total_con#</cfoutput></td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='1983.Katılımcı'>(<cf_get_lang dictionary_id='57255.Kurumsal'>)</td>
		<td>: <cfoutput>#get_emp_add.total_par#</cfoutput></td>
	</tr>
</cf_ajax_list>

