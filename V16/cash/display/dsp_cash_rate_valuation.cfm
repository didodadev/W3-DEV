<cf_get_lang_set module_name="cash">
<cfquery name="get_cash_actions" datasource="#dsn2#">
	SELECT
		CA.ACTION_DATE,
		CA.ACTION_VALUE,
		CA.CASH_ACTION_CURRENCY_ID,
		CA.RECORD_EMP,
		CA.RECORD_DATE,
        CA.UPDATE_EMP,
        CA.UPDATE_DATE,
		C.CASH_NAME,
		CAM.UPD_STATUS,
		CAM.ACTION_TYPE_ID PROCESS_TYPE
	FROM 
		CASH_ACTIONS CA,
		CASH_ACTIONS_MULTI CAM,
		CASH C
	WHERE
		ISNULL(CASH_ACTION_FROM_CASH_ID,CASH_ACTION_TO_CASH_ID) = C.CASH_ID	
		AND CA.MULTI_ACTION_ID = CAM.MULTI_ACTION_ID
		AND CA.MULTI_ACTION_ID = #attributes.multi_action_id#
</cfquery>
<cfquery name="get_cash_action_money" datasource="#dsn2#">
	SELECT
		RATE1,
		RATE2,
		MONEY_TYPE
	FROM 
		CASH_ACTION_MULTI_MONEY
	WHERE
		ACTION_ID = #attributes.multi_action_id#
</cfquery>
<cfsavecontent variable="img_">
	<cfif get_module_user(22)>
        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_action_id#&process_cat=#get_cash_actions.process_type#</cfoutput>','page');"><img src="/images/extre.gif"  border="0" alt="<cf_get_lang_main no='803.Muhasebe Fişi'>" title="<cf_get_lang_main no='803.Muhasebe Fişi'>"></a>
    </cfif>
</cfsavecontent>
<cf_popup_box title="#getLang('main',802)#" right_images="#img_#">
	<cf_area width="220">
        <cf_form_list>
            <cfif get_cash_actions.recordcount>
                <thead>
                    <tr>
                        <th colspan="4"><cf_get_lang_main no='467.İşlem Tarihi'> :<cfoutput>#dateformat(get_cash_actions.action_date,dateformat_style)#</cfoutput></th>
                    </tr>
                    <tr>
                        <th><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no='108.Kasa'></th>
                        <th><cf_get_lang_main no='261.Tutar'></th>
                        <th><cf_get_lang_main no='709.İşlem Dövizi'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="get_cash_actions">
                        <tr>
                            <td width="10">#currentrow#</td>
                            <td>#cash_name#</td>
                            <td style="text-align:right;">#tlformat(action_value)#</td>
                            <td>&nbsp;&nbsp;&nbsp;#session.ep.money#</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cfif>
        </cf_form_list>
    </cf_area>
    <cfif get_cash_action_money.recordcount>
        <cf_area>
            <table>
                <tr>
                    <td colspan="2" class="txtbold"><cf_get_lang no='87.İşlem Para Brimi'></td>
                </tr>
                <cfoutput query="get_cash_action_money">
                    <tr>
                        <td>#money_type#</td>
                        <td>#TLFormat(rate1,0)#/#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#</td>
                    </tr>
                </cfoutput>
            </table>
        </cf_area>
    </cfif>
    <cf_popup_box_footer>
     	<cf_record_info query_name="get_cash_actions">
        <div style="text-align:right;">
			<cfif get_cash_actions.upd_status neq 0>
                <cfsavecontent variable="del_message"><cf_get_lang_main no='805.Kur Değerleme İşlemini Silmek İstediğinize Emin misiniz?'></cfsavecontent>
                <input type="Button" style="width:103px;" value="<cf_get_lang_main no='804.İşlemi Sil'>" onclick="javascript:if (confirm('<cfoutput>#del_message#</cfoutput>')) window.location='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_cash_rate_valuation&multi_action_id=#attributes.multi_action_id#&old_process_type=#get_cash_actions.process_type#</cfoutput>';">
            </cfif> 
        </div>
	</cf_popup_box_footer>
</cf_popup_box>
