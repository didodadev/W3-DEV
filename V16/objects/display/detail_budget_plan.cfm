<cfquery name="get_budget_plan" datasource="#dsn2#">
	SELECT * FROM CARI_ROWS WHERE CARI_ACTION_ID = #attributes.ID#
</cfquery>
<cfif get_budget_plan.recordcount>
<cfquery name="GET_CARD" datasource="#dsn2#">
    SELECT
        ACS.CARD_ID,
        ACS.ACTION_TYPE,
        ACS.ACTION_ID
    FROM
        ACCOUNT_CARD ACS
    WHERE
        ACS.ACTION_TYPE = #get_budget_plan.action_type_id#
        AND ACS.ACTION_ID =  #get_budget_plan.action_id#
</cfquery>
<cfsavecontent variable="right">
    <cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#GET_CARD.action_id#&process_cat=#get_card.action_type#</cfoutput>','page');"><img src="/images/extre.gif"  border="0" title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"></a>
    </cfif>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32824.Gelir Gider Detay'></cfsavecontent>
<cf_popup_box title="#message#" right_images="#right#">
	<table>
		<cfoutput query="get_budget_plan">
			<tr height="20">
				<td class="txtbold"><cf_get_lang dictionary_id='57519.Cari Hesap'></td>
				<td>: <cfif len(from_cmp_id)>#get_par_info(from_cmp_id,1,1,0)#<cfelseif len(to_cmp_id)>#get_par_info(to_cmp_id,1,1,0)#<cfelseif len(from_consumer_id)>#get_cons_info(from_consumer_id,0,0)# <cfelseif len(to_consumer_id)>#get_cons_info(to_consumer_id,0,0)# </cfif>&nbsp;</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang dictionary_id='57742.Tarih'></td>
				<td>: #dateformat(action_date,dateformat_style)#&nbsp;</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang dictionary_id='57673.Tutar'></td>
				<td>: #TLFormat(action_value)# #ACTION_CURRENCY_ID#&nbsp;</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang dictionary_id='32742.Sistem Tutarı'></td>
				<td>: #TLFormat(other_cash_act_value)# #other_money#&nbsp;</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang dictionary_id='32743.Sistem İkinci Dövizi'></td>
				<td>: #tlformat(action_value_2)# #action_currency_2#&nbsp;</td>
			</tr>
		</cfoutput>
	</table>
	<cf_popup_box_footer>
		<cf_record_info query_name="get_budget_plan">
	</cf_popup_box_footer>
</cf_popup_box>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='58486.Kayıt Bulunamadı'>");
		window.close();
	</script>
</cfif>

