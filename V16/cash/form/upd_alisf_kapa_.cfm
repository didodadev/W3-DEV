<cf_get_lang_set module_name="cash">
<cfset attributes.TABLE_NAME = "CASH_ACTIONS">
<cfinclude template="../query/get_action_detail.cfm">
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
    	ACS.ACTION_TYPE = #get_action_detail.action_type_id#
		AND ACS.ACTION_ID = #attributes.id#
</cfquery>
<cfsavecontent variable="right">
<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.ACTION_TYPE_ID#</cfoutput>','page');"><img src="/images/extre.gif"  border="0" title="<cfoutput>#getLang('main',2577)#</cfoutput>"></a>
</cfif>
</cfsavecontent>
<cf_popup_box title="#getLang('main',430)#"  right_images="#right#"><!--- Alis Fatura Kapama --->
	<cfoutput>
		<table>
			<tr height="20">
				<td width="90" class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
				<td>: #dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang no='79.Kasadan'></td>
				<td><cfset cash_id=get_action_detail.CASH_ACTION_FROM_CASH_ID>
					<cfif len(get_action_detail.CASH_ACTION_FROM_CASH_ID)>
						<cfinclude template="../query/get_action_cash.cfm">
						: #get_action_cash.CASH_NAME# <cf_get_lang no='77.kasasından'>
					</cfif>
				</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no='29.Fatura'></td>
				<td><cfif len(get_action_detail.BILL_ID)>
						<cfset bill_id=get_action_detail.BILL_ID>
						<cfinclude template="../query/get_action_bill.cfm">
						: #get_action_bill.INVOICE_NUMBER# <cf_get_lang no='135.no lu fatura'>
					</cfif>
				</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no='261.Tutar'></td>
				<td>: #TLFormat(get_action_detail.CASH_ACTION_VALUE)#&nbsp;#get_action_detail.cash_action_currency_id#</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no='644.Dövizli Tutar'></td>
				<td>: #TLFormat(get_action_detail.other_cash_act_value)#&nbsp;#get_action_detail.other_money#</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
				<td>: #get_action_detail.ACTION_DETAIL# </td>
			</tr>
		</table>
	</cfoutput>
	<cf_popup_box_footer>
		<cf_record_info query_name="get_action_detail">
		<cf_workcube_buttons is_insert="0" is_cancel="1" cancel_info="#getLang('main',141)#">
	</cf_popup_box_footer>
</cf_popup_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
