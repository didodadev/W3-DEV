<cfinclude template="../query/my_sett.cfm">
<cfquery name="GET_MY_REPORTS" datasource="#dsn#">
	SELECT 
		RW.*,
		R.REPORT_NAME,
		R.IS_FILE,
		R.RECORD_DATE
	FROM 
		REPORT_ACCESS_RIGHTS  RW,
		REPORTS R
	WHERE 		
		R.REPORT_ID = RW.REPORT_ID AND
		(
			POS_CAT_ID = (SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid# AND IS_MASTER = 1) OR
			POS_CODE = (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid# AND IS_MASTER = 1)
		)
</cfquery>
<table width="100%" height="100%"border="0" cellspacing="1" cellpadding="2">
	<tr>
		<td valign="top" width="250">
			<table width="100%" border="0" cellspacing="1" cellpadding="2">
				<tr>
					<td class="txtboldblue"><cf_get_lang dictionary_id='31188.Rapor Adı'></td>
					<td class="txtboldblue" width="65"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></td>
				</tr>
				<cfif GET_MY_REPORTS.RECORDCOUNT>
					<cfoutput query="GET_MY_REPORTS">
						<tr height="20">
							<td><a class="tableyazi" href="#request.self#?fuseaction=report.<cfif is_file eq 1>emptypopup_</cfif>detail_report&report_id=#report_id#">#report_name#</a></td>
							<td>#dateformat(record_date,dateformat_style)#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr height="20">
						<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
</table>
