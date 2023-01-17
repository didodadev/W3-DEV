<cfsetting showdebugoutput="no">
<cfquery name="GET_SERVICE_LIST" datasource="#DSN3#">
	SELECT
		SERVICE_ID,
		RECORD_DATE,
		SERVICE_NO,
		SERVICE_HEAD,
		PRODUCT_NAME,
		SERVICE_STATUS_ID,
		SERVICE_SUBSTATUS_ID
	FROM
		SERVICE
	WHERE 
		SERVICE_ACTIVE = 1 
		<cfif isdefined ("attributes.cpid") and len(attributes.cpid)>
		AND SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
		<cfelseif isdefined ("attributes.cid") and len(attributes.cid)>
		AND
			(
				SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
				SERVICE_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
			)
		</cfif>
	ORDER BY
		RECORD_DATE DESC
</cfquery>
<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th><cf_get_lang dictionary_id='57480.Konu'></th>
			<th><cf_get_lang dictionary_id='57482.Aşama'></th>
			<th><cf_get_lang dictionary_id='58973.Alt Aşama'></th>
			<th><cf_get_lang dictionary_id='57657.Ürün'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_service_list.recordcount>
		<cfset service_stage_list = ''>
		<cfset service_substage_list = ''>
		<cfoutput query="get_service_list" startrow="1" maxrows="#attributes.maxrows#">
			<cfif len(service_status_id) and not listfind(service_stage_list,service_status_id)>
				<cfset service_stage_list=listappend(service_stage_list,service_status_id)>
			</cfif>
			<cfif len(service_substatus_id) and not listfind(service_substage_list,service_substatus_id)>
				<cfset service_substage_list=listappend(service_substage_list,service_substatus_id)>
			</cfif>
		</cfoutput>
		<cfif len(service_stage_list)>
		<cfset service_stage_list = listsort(service_stage_list,"numeric","ASC",",")>
			<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
				SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#service_stage_list#) ORDER BY PROCESS_ROW_ID
			</cfquery>
		</cfif>
		<cfif len(service_substage_list)>
		<cfset service_substage_list = listsort(service_substage_list,"numeric","ASC",",")>
			<cfquery name="GET_PROCESS_SUBSTAGE" datasource="#DSN3#">
				SELECT SERVICE_SUBSTATUS FROM SERVICE_SUBSTATUS WHERE SERVICE_SUBSTATUS_ID IN(#service_substage_list#) ORDER BY SERVICE_SUBSTATUS_ID
			</cfquery>
		</cfif>
		<cfoutput query="get_service_list" startrow="1" maxrows="#attributes.maxrows#">
			<tr>
				<td>#service_no#</td>
				<td>#dateformat(record_date,dateformat_style)#</td>
				<td><a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#service_id#" class="tableyazi">#service_head#</a></td>
				<td><cfif len(service_status_id)>#get_process_stage.stage[listfind(service_stage_list,service_status_id,',')]#</cfif></td>
				<td><cfif len(service_substatus_id)>#get_process_substage.service_substatus[listfind(service_substage_list,service_substatus_id,',')]#</cfif></td>
				<td>#product_name#</td>
			</tr>
		</cfoutput>
		<cfelse>
			<tr>
				<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_ajax_list>
