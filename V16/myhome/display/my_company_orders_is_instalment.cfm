<cfsetting showdebugoutput="no">
<cfquery name="GET_ORDER_LIST" datasource="#dsn3#">
	SELECT 
		ORDER_NUMBER,
		ORDER_HEAD,
		ORDER_STATUS,
		NETTOTAL,
		ORDER_DATE,
		ORDER_ID,
		OTHER_MONEY,
		OTHER_MONEY_VALUE
	FROM 
		ORDERS
	WHERE
		ORDERS.PURCHASE_SALES = 1 AND
		ORDERS.ORDER_ZONE = 0 AND
		ORDERS.IS_INSTALMENT = 1 
		<cfif isdefined ("attributes.cpid") and len(attributes.cpid)>
			AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
		<cfelseif isdefined ("attributes.cid") and len(attributes.cid)>
			AND 
			(
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
				COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
			)
		</cfif>
	ORDER BY
		ORDER_DATE DESC
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_order_list.recordcount#">
<cf_ajax_list>
    <thead>
         <tr>
            <th><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='57742.Tarih'></th>
            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='31382.Döviz Tutar'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='57756.Durum'></th>
        </tr>
    </thead>
	<cfif get_order_list.recordcount>
		<cfoutput query="get_order_list" startrow="1" maxrows="#attributes.maxrows#">
		<tbody>
			 <tr>
				<td width="55">#ORDER_NUMBER#</td>
				<td width="60">#dateformat(ORDER_DATE,dateformat_style)#</td>
				<td>
					<cfif get_module_user(11) or get_module_user(32)>
						<a href="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#order_id#" class="tableyazi">#ORDER_HEAD#</a>
					<cfelse>
						#order_head#
					</cfif>
				</td>
				<td width="100" style="text-align:right;">
					#TlFormat(NETTOTAL)#&nbsp;#session.ep.money#
				</td>
				<td width="50" style="text-align:right;">
					<cfif OTHER_MONEY neq '#session.ep.money#'>
						#TlFormat(OTHER_MONEY_VALUE)#&nbsp;#OTHER_MONEY#
					</cfif>
				</td>
				<td style="text-align:right;">
					<cfif ORDER_STATUS eq 0>
						<cf_get_lang dictionary_id='57494.Pasif'>
					<cfelseif ORDER_STATUS eq 1>
						<cf_get_lang dictionary_id='57493.Aktif'>
					</cfif>
				</td>
		  </tr>
		  </tbody>
		</cfoutput>
   <tbody>
		<cfelse>
			<tr>
				<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</tbody></cfif>
	
</cf_ajax_list>

