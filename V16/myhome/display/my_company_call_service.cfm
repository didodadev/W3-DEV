<cfsetting showdebugoutput="no">
<cfquery name="GET_G_SERVICE" datasource="#DSN#">
	SELECT
		G_SERVICE.SERVICE_ID,
		G_SERVICE.RECORD_DATE,
		G_SERVICE.SERVICE_NO,
		G_SERVICE.SERVICE_HEAD,
		G_SERVICE.SERVICE_ACTIVE,
		G_SERVICE.REF_NO,
		G_SERVICE_APPCAT.SERVICECAT,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		G_SERVICE WITH (NOLOCK),
		G_SERVICE_APPCAT  WITH (NOLOCK),
		PROCESS_TYPE_ROWS WITH (NOLOCK)
	WHERE 
		G_SERVICE.SERVICECAT_ID = G_SERVICE_APPCAT.SERVICECAT_ID AND
		G_SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
		<cfif isdefined ("attributes.cpid") and len(attributes.cpid)>
			AND G_SERVICE.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
		<cfelseif isdefined ("attributes.cid") and len(attributes.cid)>
		AND
			(
				G_SERVICE.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
				G_SERVICE.SERVICE_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
			)
		</cfif>
	ORDER BY
		G_SERVICE.RECORD_DATE DESC
</cfquery>
<cfquery name="GET_SERVICE_APPCAT_SUB_STATUS_ALL" datasource="#DSN#">
	SELECT SERVICE_SUB_CAT_ID,SERVICE_EXPLAIN, SERVICE_SUB_STATUS_ID, SERVICE_SUB_STATUS FROM G_SERVICE_APPCAT_SUB_STATUS
</cfquery>
<cf_ajax_list>
	<thead>
		 <tr>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='31036.Başvuru'><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th><cf_get_lang dictionary_id='57480.Konu'></th>
			<th><cf_get_lang dictionary_id='57486.Kategori'></th>
			<cfif isdefined('is_call_subcat') and is_call_subcat eq 1> 	
				<th><cf_get_lang dictionary_id='31061.Alt Kategori'></th>
			</cfif>
			<th><cf_get_lang dictionary_id='57482.Aşama'></th>
			<th><cf_get_lang dictionary_id='58794.Referans No'></th>
			<th><cf_get_lang dictionary_id='57756.Durum'></th>
		</tr>
	</thead>
	<tbody>
	<cfif get_g_service.recordcount>
		<cfoutput query="get_g_service" startrow="1" maxrows="#attributes.maxrows#">
			<tr>
				<td width="55">#currentrow#</td>
				<td width="80"><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#get_g_service.service_id#" class="tableyazi">#service_no#</a></td>
				<td width="60">#dateformat(record_date,dateformat_style)#</td>
				<td width="200">#service_head#</td>
				<td>#servicecat#</td>
				<cfif isdefined('is_call_subcat') and is_call_subcat eq 1> 
					<td>
						<cfquery name="GET_APP_ROWS" datasource="#DSN#">
							SELECT SERVICE_SUB_STATUS_ID FROM G_SERVICE_APP_ROWS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_id#">
						</cfquery>
						<cfif get_app_rows.recordcount>
							<cfquery name="GET_SERVICE_APP_ROW" dbtype="query">
								SELECT 
									GET_SERVICE_APPCAT_SUB_STATUS_ALL.SERVICE_SUB_STATUS
								FROM 
									GET_APP_ROWS,
									GET_SERVICE_APPCAT_SUB_STATUS_ALL
								WHERE
									GET_APP_ROWS.SERVICE_SUB_STATUS_ID = GET_SERVICE_APPCAT_SUB_STATUS_ALL.SERVICE_SUB_STATUS_ID
							</cfquery>
							<cfloop query="get_service_app_row">#service_sub_status#<cfif currentrow neq get_service_app_row.recordcount>,<br/></cfif></cfloop>
						</cfif>
					</td>
				</cfif>
				<td>#stage#</td>
				<td>#ref_no#</td>
				<td><cfif service_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelseif service_active eq 0><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
		</tr>	
	</cfif>
	</tbody>
</cf_ajax_list>
