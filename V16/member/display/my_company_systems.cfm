<cfsetting showdebugoutput="no">
<cfquery name="GET_SYSTEM_LIST" datasource="#DSN3#">
	SELECT
		SC.SUBSCRIPTION_NO,
		SC.SUBSCRIPTION_HEAD,
		SC.START_DATE,
		SC.SUBSCRIPTION_ID,
		SC.IS_ACTIVE,
		SST.SUBSCRIPTION_TYPE
	FROM
		SUBSCRIPTION_CONTRACT SC,
		SETUP_SUBSCRIPTION_TYPE SST
	WHERE
		SC.SUBSCRIPTION_ID IS NOT NULL AND 
		SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID 
	<cfif isdefined ("attributes.cpid") and len(attributes.cpid)>
		AND SC.COMPANY_ID = #attributes.cpid# 
	<cfelseif isdefined ("attributes.cid") and len(attributes.cid)> 
		AND SC.CONSUMER_ID = #attributes.cid#
	<cfelseif isdefined('attributes.assetp_id') and len(attributes.assetp_id)>
		AND SC.ASSETP_ID = #attributes.assetp_id#
	</cfif>
	ORDER BY
		SC.RECORD_DATE DESC
</cfquery>

<cf_ajax_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='29502.Abone No'></th>
				<th style="width:150px;"><cf_get_lang dictionary_id="57747.Sözleşme Tarihi"></th>
				<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<th><cf_get_lang dictionary_id='57486.Kategori'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_system_list.recordcount>	
			<cfoutput query="get_system_list" startrow="1" maxrows="#attributes.maxrows#">
				<tr>
					<!---<td width="100">#subscription_no#</td>--->
					<td><cfif GET_SYSTEM_LIST.IS_ACTIVE eq 1>#subscription_no#<cfelse><font color="FFF0000">#subscription_no#</font></cfif></td>
					<!---<td width="150">#dateformat(start_date,dateformat_style)#</td>--->
					<td><cfif GET_SYSTEM_LIST.IS_ACTIVE eq 1>#dateformat(start_date,dateformat_style)#<cfelse><font color="FFF0000">#dateformat(start_date,dateformat_style)#</font></cfif></td>
					<td><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id#" class="tableyazi">#subscription_head#</a></td>
					<!---<td width="100">#subscription_type#</td>--->
					<td><cfif GET_SYSTEM_LIST.IS_ACTIVE eq 1>#subscription_type#<cfelse><font color="FFF0000">#subscription_type#</font></cfif></td>
				</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			</cfif>
		</tbody>
</cf_ajax_list>
