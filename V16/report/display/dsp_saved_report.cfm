<cfflush interval="5000">
<cfquery name="get_saved_report" datasource="#dsn#">
	SELECT FILE_NAME,REPORT_NAME FROM SAVED_REPORTS WHERE SR_ID = #ATTRIBUTES.SR_ID#
</cfquery>
<cffile action="read" file="#upload_folder#report#dir_seperator#saved#dir_seperator##get_saved_report.file_name#" variable="cont" charset="utf-8">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="35">
			<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
				<td height="35" class="headbold" width="99%"> <cf_get_lang dictionary_id='39808.Kayıtlı rapor'>: <cfoutput>#get_saved_report.report_name#</cfoutput></td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' trail='0' tag_module='report_saved_div'> 
				<td nowrap>  
				<cfoutput> 
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=report.popup_form_upd_saved_report&sr_id=#sr_id#','small');"><img src="/images/refer.gif" border="0"></a>
				</cfoutput>
				</td>				
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top"><div id="report_saved_div"><cfoutput>#cont#</cfoutput></div></td>
	</tr>
</table>
