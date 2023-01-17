<cfsetting showdebugoutput="no">
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
	<cfif isdefined("attributes.cpid")>
		COMPANY_ID = #attributes.cpid#
	<cfelse>
		(
			CONSUMER_ID = #attributes.cid# OR
			COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = #attributes.cid#)
			<!--- Bireysel Uye iliskilendirilerek olusturulan partner icin eklendi fbs 20101218 --->
		)
	</cfif>
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
			SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#help_stage_list#) ORDER BY PROCESS_ROW_ID
		</cfquery>
		<cfset help_stage_list=listsort(help_stage_list,"numeric","ASC",",")>
	</cfif>
</cfif>
<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th><cf_get_lang dictionary_id='57482.Aşama'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
		</tr>
	</thead>
    <tbody>
		<cfif get_help.recordcount>
            <cfoutput query="get_help" startrow="1" maxrows="#attributes.maxrows#">
                <tr>
                    <td>
                        #dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#
                    </td>
                    <td>#applicant_name#</td>
                    <td><cfif len(process_stage)>#process_type.stage[listfind(help_stage_list,get_help.process_stage,',')]#</cfif></td>
                    <td><a href="#request.self#?fuseaction=call.helpdesk&event=upd&cus_help_id=#cus_help_id#">#subject#</a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
            </tr> 
        </cfif>
	</tbody>
</cf_ajax_list>
