<cf_get_lang_set module_name="bank">
<cfquery name="get_bank_actions" datasource="#dsn2#">
	SELECT
		BA.ACTION_DATE,
		BA.ACTION_VALUE,
		BA.ACTION_CURRENCY_ID,
		BA.RECORD_EMP,
		BA.RECORD_DATE,
		A.ACCOUNT_NAME,
		BAM.UPD_STATUS,
		BAM.ACTION_TYPE_ID PROCESS_TYPE
	FROM 
		BANK_ACTIONS BA,
		BANK_ACTIONS_MULTI BAM,
		#dsn3_alias#.ACCOUNTS A
	WHERE
		ISNULL(ACTION_TO_ACCOUNT_ID,ACTION_FROM_ACCOUNT_ID) = A.ACCOUNT_ID	
		AND BA.MULTI_ACTION_ID = BAM.MULTI_ACTION_ID
		AND BA.MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_action_id#">
</cfquery>
<cfquery name="get_bank_action_money" datasource="#dsn2#">
	SELECT
		RATE1,
		RATE2,
		MONEY_TYPE
	FROM 
		BANK_ACTION_MULTI_MONEY
	WHERE
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_action_id#">
</cfquery>
<cfsavecontent variable="right_">
	<cfif get_module_user(22)>
		<li><a href="javascript://"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=<cfif session.ep.isBranchAuthorization>store<cfelse>account</cfif>.popup_list_card_rows&action_id=#attributes.multi_action_id#&process_cat=#get_bank_actions.process_type#</cfoutput>','page');"><i class="icon-fa fa-table"title="<cf_get_lang dictionary_id='58215.Muhasebe Fişi'>"></i></a></li>
	</cfif>
</cfsavecontent>
<cf_box title="#getLang('main',806)#" right_images="#right_#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_box_elements>
        <cf_grid_list>
            <cfif get_bank_actions.recordcount>
                <thead>
                    <tr height="20">
                        <th class="txtbold" colspan="3"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                        <th><cfoutput>#dateformat(get_bank_actions.action_date,dateformat_style)#</cfoutput></th>
                    </tr>
                    <tr height="20">
                        <th ><cf_get_lang dictionary_id='57487.No'></th>
                        <th  ><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
                        <th  ><cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th ><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
                    </tr>
                </thead>
                
                <tbody>
                    <cfoutput query="get_bank_actions">
                        <tr height="20">
                            <td width="10">#currentrow#</td>
                            <td>#account_name#</td>
                            <td style="text-align:right;">#tlformat(action_value)#</td>
                            <td>&nbsp;&nbsp;&nbsp;#action_currency_id#</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cfif>
        </cf_grid_list>
    
            <table>
                <tr>
                    <td colspan="2" class="txtbold"><cf_get_lang dictionary_id='57487.No'></td>
                </tr>
                <cfoutput query="get_bank_action_money">
                    <tr>
                        <td>#money_type#</td>
                        <td>#TLFormat(rate1,0)#/#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#</td>
                    </tr>
                </cfoutput>
        	</table>
       
    </cf_box_elements>
	<cf_box_footer>
		<cf_record_info query_name="get_bank_actions">
        <div style="float:right;">
            <cfoutput>
			<cfif get_bank_actions.upd_status neq 0>
                <cfsavecontent variable="del_message"><cf_get_lang dictionary_id='65143.Kur Değerleme İşlemini Silmek İstediğinize Emin misiniz'></cfsavecontent>
                    <button type="button"  class="ui-ripple-btn" onClick="javascript:if (confirm('<cfoutput>#del_message#</cfoutput>')) openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_bank_rate_valuation&multi_action_id=#attributes.multi_action_id#&old_process_type=#get_bank_actions.process_type#</cfoutput>');">#getLang('','işlemi sil','58216')#</button>
            </cfif>
            <a href="javascript://"  class="ui-ripple-btn" onclick="close_();">#getLang('','kapat','57553')#</a>
        </cfoutput>
              
        </div>
	</cf_box_footer>
</cf_box>
<script type="text/javascript">
    function close_(){
        <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
    }
</script>
