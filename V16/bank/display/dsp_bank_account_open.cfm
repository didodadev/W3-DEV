<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.TABLE_NAME="BANK_ACTIONS">
<cfinclude template="../query/get_action_detail.cfm">
<cfinclude template="../query/get_money_rate.cfm">
<cf_popup_box title="#getLang('main',498)#"><!--- Hesap Acilis Islemi --->
    <table>
        <tr height="20">
            <td width="100" class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
            <td>: <cfoutput>#dateformat(get_action_detail.action_date,dateformat_style)#</cfoutput> 
        </tr>
		<tr height="20">
            <td class="txtbold"><cf_get_lang_main no='240.Hesap'></td>
            <td>: 
				<cfset attributes.ACCOUNT_ID_='#get_action_detail.ACTION_TO_ACCOUNT_ID#'>
				<cfinclude  template="../query/get_accounts.cfm">
				<cfset currency=get_accounts.ACCOUNT_CURRENCY_ID>
				<cfinclude template="../query/get_action_rate.cfm">
				<cfoutput>#get_accounts.ACCOUNT_NAME#&nbsp;#get_action_rate.MONEY#</cfoutput> 
			</td>
        </tr>
		<tr height="20">
            <td class="txtbold"><cf_get_lang_main no='261.Tutar'></td>
            <td>: <cfoutput>#TLFormat(get_action_detail.ACTION_VALUE)#&nbsp;#get_action_rate.MONEY#</cfoutput> </td>
        </tr>
        <tr height="20">
            <td class="txtbold"><cf_get_lang_main no='455.Borç/Alacak'></td>
            <td>: 
				<cfquery name="get_cari_rows" datasource="#DSN2#">
					SELECT FROM_ACCOUNT_ID,TO_ACCOUNT_ID FROM CARI_ROWS WHERE ACTION_ID=#URL.ID# and ACTION_TYPE_ID=20
				</cfquery>
				<cfif len(get_cari_rows.TO_ACCOUNT_ID) >
					<cf_get_lang_main no='175.Borç'>
				<cfelse>
					<cf_get_lang_main no='176.Alacak'>
				</cfif>
            </td>
        </tr>
        <tr height="20">
            <td valign="top" class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
            <td>: <cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput> </td>
        </tr>
    </table>
	<cf_popup_box_footer>
		<cf_record_info query_name="get_action_detail">
		<cf_workcube_buttons is_insert="0" is_cancel="1" cancel_info="#getLang('main',141)#">
	</cf_popup_box_footer>
</cf_popup_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
