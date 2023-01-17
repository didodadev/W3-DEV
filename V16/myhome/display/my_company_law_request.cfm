<cfsetting showdebugoutput="no">
<cfquery name="GET_LAW_REQUEST" datasource="#DSN#">
	SELECT 
		REQUEST_STATUS,
		FILE_NUMBER,
		FILE_STAGE,
		REVENUE_DATE,
		LAW_REQUEST_ID,
		LAW_ADWOCATE,
		REQUEST_STATUS
	FROM 
		COMPANY_LAW_REQUEST
	WHERE
		<cfif isdefined ("attributes.cpid") and len(attributes.cpid)>
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
		<cfelseif isdefined ("attributes.cid") and len(attributes.cid)>
			(
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
				COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
			)
		</cfif>
	ORDER BY
		REVENUE_DATE DESC
</cfquery>
<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57756.Durum'></th>
			<th><cf_get_lang dictionary_id='31746.İcra Tarihi'></th>
			<th><cf_get_lang dictionary_id='31747.Dosya Durumu'></th>
			<th><cf_get_lang dictionary_id='31748.Avukat'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_law_request.recordcount>
			<cfset consumer_id_list=''>
			<cfoutput query="get_law_request" startrow="1" maxrows="#attributes.maxrows#">
				<cfif not listfind(consumer_id_list,law_adwocate)>
					<cfset consumer_id_list=listappend(consumer_id_list,law_adwocate)>
				 </cfif>
			</cfoutput>
			<cfif len(consumer_id_list)>
				<cfset consumer_id_list=listsort(consumer_id_list,"numeric")>
				<cfquery name="get_consumer_detail" datasource="#DSN#">
					SELECT CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
				 </cfquery>
			</cfif>
			<cfoutput query="get_law_request" startrow="1" maxrows="#attributes.maxrows#">
				<tr>
					<td width="55"><a href="#request.self#?fuseaction=ch.list_law_request&event=upd&id=#law_request_id#" class="tableyazi">#file_number#</a></td>
					<td width="55"><cfif request_status eq 1><cf_get_lang dictionary_id ='57493.Aktif'><cfelse><cf_get_lang dictionary_id ='57494.Pasif'></cfif></td>
					<td width="60">#dateformat(revenue_date,dateformat_style)#</td>
					<td width="60">#file_stage#</td>
					<td width="80">
						<cfif len(law_adwocate) and len(consumer_id_list)>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#law_adwocate#','medium');" class="tableyazi">
								#get_consumer_detail.consumer_name[listfind(consumer_id_list,law_adwocate,',')]# #get_consumer_detail.consumer_surname[listfind(consumer_id_list,law_adwocate,',')]#
							</a>
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
