<cfset wizard = createObject("component", "V16.account.cfc.MagicAuditor" )>
<cfset get_wizards = wizard.det_wizard2(
                                            wizard_id : attributes.wizard_id
                                       )>

<cfquery name = "get_blocks" dbtype = "query">
    SELECT DISTINCT WIZARD_BLOCK_ID FROM get_wizards
</cfquery>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='60305.Magic Auditor'> : <cf_get_lang dictionary_id='64427.?'></cfsavecontent>
<cf_box title="#title#" closable="0" collapsable="1" uidrop="1">
<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
            <th class="text-right"><cf_get_lang dictionary_id='57492.Toplam'> <cfoutput>#session.ep.money#</cfoutput></th>
            <th class="text-right"><cf_get_lang dictionary_id='37530.2nd Currency'></th>
            <th class="text-center" style = "width:80px;"><i class="icon-exchange" aria-hidden="true"></i></th>
            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
            <th class="text-right"><cf_get_lang dictionary_id='57492.Toplam'> <cfoutput>#session.ep.money#</cfoutput></th>
            <th class="text-right"><cf_get_lang dictionary_id='37530.2nd Currency'></th>
            <th class="text-center" style = "width:20px;"><i class="fa fa-eye" aria-hidden="true"></i></th>
        </tr>
    </thead>
    <tbody>
        <cfloop from = "1" to = "#get_blocks.recordcount#" index = "b">
            <cfquery name = "get_block" dbtype = "query">
                SELECT * FROM get_wizards WHERE WIZARD_BLOCK_ID = #get_blocks.wizard_block_id[b]# ORDER BY BLOCK_COLUMN
            </cfquery>
            <cfset left_block_bakiye = 0>
            <cfset left_block_bakiye_2 = 0>
            <cfset right_block_bakiye = 0>
            <cfset right_block_bakiye_2 = 0>

            <cfoutput query = "get_block">
                <cfquery name = "get_balance" datasource = "#dsn2#">
                    WITH CTE1 AS (
                        SELECT
                            AP.ACCOUNT_CODE,
                            ISNULL(SUM(ACR.AMOUNT * (1 - 2 * ACR.BA)),0) AS ACC_BALANCE,
                            ISNULL(SUM(ACR.AMOUNT_2 * (1 - 2 * ACR.BA)),0) AS ACC_BALANCE_2
                        FROM
                            ACCOUNT_PLAN AP
                                LEFT JOIN ACCOUNT_CARD_ROWS ACR ON ACR.ACCOUNT_ID LIKE AP.ACCOUNT_CODE + '%'
                                LEFT JOIN ACCOUNT_CARD AC ON AC.CARD_ID = ACR.CARD_ID
                        WHERE
                            ACR.BA = #ba#
                            <cfif len(get_block.ACTION_TYPE)>
                                AND AC.ACTION_TYPE IN (#get_block.ACTION_TYPE#)
                            </cfif>
                        GROUP BY
                            AP.ACCOUNT_CODE
                    )
                    SELECT
                        ACCOUNT_CODE,
                        ACC_BALANCE,
                        ACC_BALANCE_2
                    FROM
                        CTE1
                    WHERE
                        ACCOUNT_CODE = '#account_code#'
                </cfquery>

                <cfif len(get_balance.acc_balance)>
                    <cfset acc_balance = get_balance.acc_balance>
                    <cfset acc_balance_2 = get_balance.acc_balance_2>
                <cfelse>
                    <cfset acc_balance = 0>
                    <cfset acc_balance_2 = 0>
                </cfif>
                <cfscript>
                    switch (block_column) {
                        case 1:
                            left_bakiye = acc_balance * (rate/100);
                            left_block_bakiye = left_block_bakiye + left_bakiye;
                            left_bakiye_2 = acc_balance_2 * (rate/100);
                            left_block_bakiye_2 = left_block_bakiye_2 + left_bakiye_2;
                            break;
                        
                        case 2 :
                            right_bakiye = acc_balance * (rate/100);
                            right_block_bakiye = right_block_bakiye + right_bakiye;
                            right_bakiye_2 = acc_balance_2 * (rate/100);
                            right_block_bakiye_2 = right_block_bakiye_2 + right_bakiye_2;
                            break;
                    }
                </cfscript>
            </cfoutput>
            <tr>
                <td><cfoutput>#get_block.BLOCK_NAME_LEFT#</cfoutput></td>
                <td class="text-right"><cfoutput>#TLFormat(left_block_bakiye)#</cfoutput></td>
                <td class="text-right"><cfoutput>#TLFormat(left_block_bakiye_2)#</cfoutput></td>
                <td class="text-center">
                    <strong>
                    <cfif get_block.block_operation eq 0> = <cfelseif get_block.block_operation eq 1> >= <cfelseif get_block.block_operation eq 2> <= <cfelseif get_block.block_operation eq 3> > <cfelseif get_block.block_operation eq 4> < </cfif>
                    <cfoutput>#get_block.BLOCK_RATE#%</cfoutput></strong>
                </td>
                <td><cfoutput>#get_block.BLOCK_NAME_RIGHT#</cfoutput></td>
                <td class="text-right"><cfoutput>#TLFormat(right_block_bakiye)#</cfoutput></td>
                <td class="text-right"><cfoutput>#TLFormat(right_block_bakiye_2)#</cfoutput></td>
                <td class="text-center">
                    <cfif right_block_bakiye eq 0 >
						<cfset block_total_rate = 0>
					<cfelse>
						<cfset block_total_rate = left_block_bakiye / right_block_bakiye>
					</cfif>
                    <cfif get_block.block_operation eq 0> <cfset operation = block_total_rate eq get_block.block_rate>
                    <cfelseif get_block.block_operation eq 1> <cfset operation = block_total_rate gte get_block.block_rate> 
                    <cfelseif get_block.block_operation eq 2> <cfset operation = block_total_rate lte get_block.block_rate>
                    <cfelseif get_block.block_operation eq 3> <cfset operation = block_total_rate gt get_block.block_rate>
                    <cfelseif get_block.block_operation eq 4> <cfset operation = block_total_rate lt get_block.block_rate>
                    </cfif>

                    <cfif operation >
                        <span class="fa fa-smile-o" style="font-size:17px;color:green;"></span> 
                    <cfelse>
                        <span class="fa fa-frown-o" style="font-size:17px;color:red;"></span>
                    </cfif>
                </td>
            </tr>
        </cfloop>
    </tbody>
</cf_grid_list>
<!--- Uidrop ile excel alındığı için kapatıldı. --->
<!--- <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="run_wizard" action="#request.self#?fuseaction=#attributes.fuseaction#">
        <div class="ui-info-bottom flex-end">
            <!--- <div class="form-group" id="item-process_date">
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='330.Tarih'>!</cfsavecontent>
                    <cfinput type="text" name="process_date" maxlength="10" required="Yes" message="#message#" validate="#validate_style#" value="#dateformat(now(),dateformat_style)#">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
                </div>
            </div>
            <div class="form-group" id="item-wizard_designer">
                <div class="input-group">
                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                    <input type="text" name="employee_name" id="employee_name" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" value="" autocomplete="off">
                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=run_wizard.employee_id&field_name=run_wizard.employee_name&select_list=1');"></span>
                </div>
            </div>
            <div class="form-group" id="item-assetcat_id">
                <div class="input-group">
                    <input type="hidden" name="assetcat_id" id="assetcat_id" <cfif isdefined('attributes.assetcat_id') and len(attributes.assetcat_id)> value="<cfoutput>#attributes.assetcat_id#</cfoutput>"</cfif>>
                    <input type="text" name="assetcat_name" id="assetcat_name" placeholder="<cf_get_lang_main no='1739.Tüm Kategoriler'> *" onfocus="AutoComplete_Create('assetcat_name','ASSETCAT','ASSETCAT_PATH','get_asset_cat','0','ASSETCAT_ID','assetcat_id','','3','130');" autocomplete="off">
                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat&chooseCat=1&form_name=run_wizard&field_id=assetcat_id&field_name=assetcat_name','list');"></span>			
                </div>
            </div>
            <div class="form-group" id="item-note">
                <div class="input-group">
                    <input type="text" name="note" id="note" value="" placeholder="<cf_get_lang dictionary_id='57629.Açıklama'>">
              </div>
            </div> --->
            <a href="javascript://" onclick="return (PROCTest(this,1));" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-save"></i><cf_get_lang dictionary_id='59295.Arşivle'></a>
        </div>
    </cfform>
</div> --->
</cf_box>