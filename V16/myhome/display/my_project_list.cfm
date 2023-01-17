<cfsetting showdebugoutput="no">
<cfquery name="GET_PROJECTS" datasource="#DSN#">
	SELECT 
		COMPANY_ID,
		PARTNER_ID,
		PROJECT_HEAD,
		PROJECT_ID,
		CONSUMER_ID,
		RECORD_DATE,
		PRO_CURRENCY_ID,
		PROJECT_STATUS
	FROM 
		PRO_PROJECTS
	WHERE
		<cfif isdefined ("attributes.cpid") and len(attributes.cpid)>
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
		<cfelseif isdefined ("attributes.cid") and len(attributes.cid)>
			(
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
				COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
			)
		</cfif>
</cfquery>
<cf_ajax_list>
	<thead>
		<tr>
			<th width="200"><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th><cf_get_lang dictionary_id='57482.Aşama'></th>
			<th><cf_get_lang dictionary_id='57756.Durum'></th>
		</tr>
	</thead>
	<tbody>
	  <cfif get_projects.recordcount>
		<cfset out_partner_id_list =''>
		<cfset consumer_id_list =''>
		<cfset project_stage_list=''>
		<cfoutput query="get_projects" startrow="1" maxrows="#attributes.maxrows#">
			<cfif len(partner_id) and not listfind(out_partner_id_list,partner_id)>
				<cfset out_partner_id_list = Listappend(out_partner_id_list,partner_id)>
			</cfif>
			<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
				<cfset consumer_id_list = Listappend(consumer_id_list,consumer_id)>
			</cfif>
			<cfif len(pro_currency_id) and not listfind(project_stage_list,pro_currency_id)>
				<cfset project_stage_list = Listappend(project_stage_list,pro_currency_id)>
			</cfif>
		</cfoutput>
		<cfif len(consumer_id_list)>
			<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
			<cfquery name="get_consumer_detail" datasource="#DSN#">
				SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
			</cfquery>
			<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(out_partner_id_list)>
			<cfset out_partner_id_list=listsort(out_partner_id_list,"numeric","ASC",",")>
			<cfquery name="get_partner_detail" datasource="#dsn#">
				SELECT
					CP.COMPANY_PARTNER_NAME,
					CP.COMPANY_PARTNER_SURNAME,
					CP.PARTNER_ID					
				FROM 
					COMPANY_PARTNER CP
				WHERE 
					CP.PARTNER_ID IN (#out_partner_id_list#) 
				ORDER BY
					PARTNER_ID
			</cfquery>
			<cfset out_partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(project_stage_list)>
			<cfquery name="get_currency_name" datasource="#dsn#">
				SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#project_stage_list#) ORDER BY PROCESS_ROW_ID
			</cfquery>
			<cfset project_stage_list = listsort(listdeleteduplicates(valuelist(get_currency_name.process_row_id,',')),'numeric','ASC',',')>
		</cfif>
			<cfoutput query="get_projects" startrow="1" maxrows="#attributes.maxrows#">
				<tr>
					<td>#dateformat(record_date,dateformat_style)#</td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=project.projects&event=det&id=#project_id#','project');" class="tableyazi">#project_head#</a></td>
					<td><cfif len(get_projects.partner_id)>
							#get_partner_detail.company_partner_name[listfind(out_partner_id_list,get_projects.partner_id,',')]#
							#get_partner_detail.company_partner_surname[listfind(out_partner_id_list,get_projects.partner_id,',')]#
						<cfelseif Len(get_projects.consumer_id)>
							#get_consumer_detail.consumer_name[listfind(consumer_id_list,get_projects.consumer_id,',')]#
							#get_consumer_detail.consumer_surname[listfind(consumer_id_list,get_projects.consumer_id,',')]#
						</cfif>
					</td>
					<td>#get_currency_name.stage[listfind(project_stage_list,pro_currency_id,',')]#</td>
					<td>
						<cfif project_status eq 1>
							<cf_get_lang dictionary_id='57493.Aktif'>
						<cfelseif project_status eq 0>
							<cf_get_lang dictionary_id='57494.Pasif'>
						</cfif>
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_ajax_list>
