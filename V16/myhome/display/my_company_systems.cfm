<cfsetting showdebugoutput="no">
<cfquery name="GET_SYSTEM_LIST" datasource="#DSN3#">
	SELECT
		SC.SUBSCRIPTION_NO,
		SC.SUBSCRIPTION_HEAD,
		SC.START_DATE,
		SC.SUBSCRIPTION_ID,
		SST.SUBSCRIPTION_TYPE,
		MONTAGE_DATE,
		SUBSCRIPTION_STAGE,
		SALES_CONSUMER_ID,
		SALES_PARTNER_ID,
		FINISH_DATE,
		IS_ACTIVE
	FROM
		SUBSCRIPTION_CONTRACT SC,
        SETUP_SUBSCRIPTION_TYPE SST
	WHERE
		SC.SUBSCRIPTION_ID IS NOT NULL 
        AND IS_ACTIVE = 1
		AND SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID 
		<cfif isdefined ("x_subs_comp_id") and len(x_subs_comp_id)>
		AND SC.COMPANY_ID  IN (#x_subs_comp_id#)
		<cfelseif isdefined ("attributes.cpid") and len(attributes.cpid)>
		AND SC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
		<cfelseif isdefined ("attributes.cid") and len(attributes.cid)>
		AND
			(
				SC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
				SC.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
			)
		<cfelseif isdefined('attributes.assetp_id') and len(attributes.assetp_id)>
			AND SC.ASSETP_ID = #attributes.assetp_id#
		</cfif>
	ORDER BY
		SC.RECORD_DATE DESC
</cfquery>
<cf_flat_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='58832.Abone'><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='58859.Süreç'></th>
			<th><cf_get_lang dictionary_id='32575.İş ortağı'></th>
			<th><cf_get_lang dictionary_id='60935.Sözleşme Bitiş Tarihi'></th>
			<th><cf_get_lang dictionary_id='57747.Sözleşme Tarihi'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<th><cf_get_lang dictionary_id='57486.Kategori'></th>
		</tr>
	</thead>	
	<tbody>
		<cfif get_system_list.recordcount>	
			<cfoutput query="get_system_list" startrow="1" maxrows="#attributes.maxrows#">
				<tr>
					<td><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#SUBSCRIPTION_ID#" target="_blank">#subscription_no#</a></td>
					<td>
						<cfif len(get_system_list.subscription_stage)>
							<cfset contract_cmp = createObject("component","V16.sales.cfc.subscription_contract")>
							<cfset process_stage=contract_cmp.GET_PROCESS_TYPE(get_system_list.subscription_stage)>#process_stage.stage#
						</cfif>
					</td>
					<td><cfif len(get_system_list.sales_partner_id)>#get_par_info(get_system_list.sales_partner_id, 0, 0, 0)#<cfelseif len(get_system_list.sales_consumer_id)>#get_par_info(get_system_list.sales_consumer_id, 0, 0, 0)#</cfif></td>
					<td><cfif len(get_system_list.finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
					<td>#dateformat(start_date,dateformat_style)#</td>
					<td><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id#">#subscription_head#</a></td>
					<td>#subscription_type#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>

<cfif get_system_list.recordcount>
	<cfoutput query="get_system_list">
		<cfif is_active eq 1 and len(finish_date)>
			<cfif datediff('d',now(), finish_date) lt 0>
				<script type="text/javascript">
					if (confirm("#subscription_no# No lu Abonenin Sözleşmesi #dateformat(finish_date,dateformat_style)# tarihinde sona ermiştir. Lütfen Fırsat Ekleyiniz!")) {
						window.location.href = "#request.self#?fuseaction=sales.list_opportunity&event=add&service_id=#attributes.service_id#";
					} 
				</script>
				<cfabort>
			</cfif>
		</cfif>
	</cfoutput>
</cfif>
