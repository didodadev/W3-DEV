<cfsetting showdebugoutput="no">
<cfparam name="attributes.page" default='1'>
<cfquery name="GET_HELP" datasource="#DSN#">
	SELECT 
		APPLICANT_NAME,
		SUBJECT,
		RECORD_DATE,
		PROCESS_STAGE,
		CUS_HELP_ID
	FROM
		CUSTOMER_HELP
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
	ORDER BY
		RECORD_DATE DESC
</cfquery>
<cfif get_help.recordcount>
	<cfset help_stage_list=''>
	<cfoutput query="get_help">
		<cfif len(process_stage) and not listfind(help_stage_list,process_stage)>
			<cfset help_stage_list=listappend(help_stage_list,process_stage)>
		</cfif>
	</cfoutput>
	<cfif len(help_stage_list)>
		<cfquery name="PROCESS_TYPE" datasource="#DSN#">
			SELECT
				STAGE,
				PROCESS_ROW_ID
			FROM
				PROCESS_TYPE_ROWS
			WHERE
				PROCESS_ROW_ID IN(#help_stage_list#)
			ORDER BY
				PROCESS_ROW_ID
		</cfquery>
		<cfset help_stage_list=listsort(help_stage_list,"numeric","ASC",",")>
	</cfif>
</cfif>
<div class="table-responsive-lg">
	<table class="table">
		<thead class="main-bg-color">
			<tr>
				<td><cf_get_lang dictionary_id='57742.Tarih'></td>
				<td><cf_get_lang dictionary_id='57629.Açıklama'></td>
				<td><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
				<td><cf_get_lang dictionary_id='57482.Aşama'></td>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="get_help" startrow="1" maxrows="#attributes.maxrows#">
				<cfif get_help.recordcount>
					<tr>
						<td>#dateformat(date_add('h',session.pp.time_zone,record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,record_date),'hh:mm')#</td>
						<td>#SUBJECT#</td>
						<td>#APPLICANT_NAME#</td>
						<td><cfif len(process_stage)>#process_type.stage[listfind(help_stage_list,get_help.process_stage,',')]#</cfif></td>
					</tr>
				</cfif>
			</cfoutput>
			<cfif not get_help.recordcount>
				<tr>
					<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		</tbody>
	</table>
</div>