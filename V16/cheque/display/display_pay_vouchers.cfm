<cf_get_lang_set module_name="cheque">
<cfsetting showdebugoutput="no">
<cfquery name="get_all_vouchers" datasource="#dsn2#">
	SELECT
		V.*
	FROM
		VOUCHER_HISTORY VH,
		VOUCHER V
	WHERE
		VH.PAYROLL_ID = #attributes.action_id# AND
		V.VOUCHER_ID = VH.VOUCHER_ID
	ORDER BY V.VOUCHER_ID
</cfquery>
<cfset voucher_id_list = valuelist(get_all_vouchers.voucher_id)>
<cfset voucher_id_list = listsort(voucher_id_list,"numeric","ASC",",")>
<cfquery name="get_all_closed" datasource="#dsn2#">
	SELECT
		CLOSED_AMOUNT,
		ACTION_ID
	FROM 
		VOUCHER_CLOSED
	WHERE
		PAYROLL_ID = #attributes.action_id# AND
		IS_VOUCHER_DELAY IS NULL
	ORDER BY ACTION_ID
</cfquery>
<cfquery name="get_all_closed_delay" datasource="#dsn2#">
	SELECT
		CLOSED_AMOUNT,
		ACTION_ID
	FROM 
		VOUCHER_CLOSED
	WHERE
		PAYROLL_ID = #attributes.action_id# AND
		IS_VOUCHER_DELAY IS NOT NULL
	ORDER BY ACTION_ID
</cfquery>
<cfoutput query="get_all_closed">
	<cfset "closed_amount_#action_id#" = closed_amount>
</cfoutput>
<cfoutput query="get_all_closed_delay">
	<cfset "delay_closed_amount_#action_id#" = closed_amount>
</cfoutput>
<cf_medium_list>
	<thead>
		<tr>
			<th width="25"><cf_get_lang_main no='75.No'></th>
			<th width="80"><cf_get_lang_main no='1090.Senet No'></th>
			<th width="80"><cf_get_lang_main no='469.Vade Tarihi'></th>
			<th width="80"  style="text-align:right;"><cf_get_lang_main no='596.Senet'> <cf_get_lang_main no='261.Tutar'></th>
			<th width="80"  style="text-align:right;"><cf_get_lang no='166.Gecikme Faizi'></th>
			<th width="250" nowrap="nowrap"></td>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_all_vouchers">
			<tr height="20" class="color-row">
				<td>#currentrow#</td>
				<td>#voucher_no# <cfif is_pay_term eq 1>- <cf_get_lang_main no='2148.Ödeme Sözü'></cfif></td>
				<td>#dateformat(voucher_duedate,dateformat_style)#</td>
				<td  style="text-align:right;">
					<cfif isdefined("closed_amount_#voucher_id#")>
						#TlFormat(evaluate("closed_amount_#voucher_id#"))#
					<cfelse>
						#TlFormat(0)#
					</cfif>
				</td>
				<td  style="text-align:right;">
					<cfif isdefined("delay_closed_amount_#voucher_id#")>
						#TlFormat(evaluate("delay_closed_amount_#voucher_id#"))#
					<cfelse>
						#TlFormat(0)#
					</cfif>
				</td>
				<td width="250" nowrap="nowrap" class="color-list"></td>
			</tr>
		</cfoutput>
	</tbody>
</cf_medium_list>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
