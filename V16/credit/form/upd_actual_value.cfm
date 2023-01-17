<!--- <cfdump var="#attributes#" abort> --->
<cfif isdefined("attributes.history_id") and len(attributes.history_id)>
    <cfquery name="GET_STOCKBOND" datasource="#DSN3#">
        SELECT * FROM STOCKBONDS_VALUE_CHANGES AS SVC
            JOIN STOCKBONDS AS S ON S.STOCKBOND_ID = SVC.STOCKBOND_ID
            JOIN STOCKBONDS_SALEPURCHASE_ROW AS SSR ON SSR.STOCKBOND_ID = S.STOCKBOND_ID
        WHERE HISTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.history_id#">
    </cfquery>
<cfelse>
    <cfquery name="GET_STOCKBOND" datasource="#DSN3#">
        SELECT
            STOCKBONDS.ACTUAL_VALUE, STOCKBONDS.OTHER_ACTUAL_VALUE, STOCKBONDS_SALEPURCHASE_ROW.SALES_PURCHASE_ID
        FROM
            STOCKBONDS
        LEFT JOIN STOCKBONDS_SALEPURCHASE_ROW ON STOCKBONDS.STOCKBOND_ID = STOCKBONDS_SALEPURCHASE_ROW.STOCKBOND_ID
        WHERE
        STOCKBONDS.STOCKBOND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stockbond_id#">
    </cfquery>
</cfif>
    <cfquery name="GET_ACTION_MONEY" datasource="#dsn3#">
        SELECT MONEY_TYPE AS MONEY, * FROM STOCKBONDS_SALEPURCHASE_MONEY WHERE ACTION_ID = #GET_STOCKBOND.SALES_PURCHASE_ID#
    </cfquery>
    <cfquery name="GET_BOND_ACTION" datasource="#dsn3#">
        SELECT * FROM STOCKBONDS_SALEPURCHASE WHERE ACTION_ID = #GET_STOCKBOND.SALES_PURCHASE_ID#
    </cfquery>

<cf_box title="#getLang('','Değerleme',48777)#" draggable="1" closable="1" design_type="1">
    <cfform name="upd_act_value" method="post" action="#request.self#?fuseaction=credit.emptypopup_ajax_stockbond_value_currently">
        <cfif isdefined("attributes.history_id") and len(attributes.history_id)>
            <input type="hidden" name="history_id" id="history_id" value="<cfoutput>#attributes.history_id#</cfoutput>">
            <input type="hidden" name="stockbond_id" id="stockbond_id" value="<cfoutput>#GET_STOCKBOND.stockbond_id#</cfoutput>">
        <cfelse>
            <input type="hidden" name="stockbond_id" id="stockbond_id" value="<cfoutput>#attributes.stockbond_id#</cfoutput>">
        </cfif>
            <div class="row" type="row">
                <div class="col col-1"></div>
                <div class="col col-10 col-md-10 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group large" id="item-action_date">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='47990.Güncelleme Tarihi'></label>
                        <div class="col col-12 col-xs-12">
                            <div class="input-group">
                                <cfif isDefined("attributes.history_id")>
                                    <cfset house = datepart('h',GET_STOCKBOND.date)>
                                    <cfset min = datepart('n',GET_STOCKBOND.date)>
                                    <cfset date = dateformat(GET_STOCKBOND.date,dateformat_style)>
                                <cfelse>
                                    <cfset house = 0>
                                    <cfset min = 0>
                                    <cfset date = dateformat(now(),dateformat_style)>
                                </cfif>
                                <cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" value="#date#" maxlength="10" required="yes" message="Tarih Girmelisiniz!">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
                                <span class="input-group-addon no-bg"></span>
                                <cf_wrkTimeFormat name="hours" value="#house#">
                                <span class="input-group-addon no-bg"></span>
                                <select id="minutes" name="minutes">
                                    <cfloop from="0" to="59" index="i" step="5">
                                            <option value="<cfoutput>#i#</cfoutput>" <cfif min eq i> selected</cfif> ><cfif i lt 10>0</cfif><cfoutput>#i#</cfoutput></option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-guncel-deger">
                        <label class="col col-12"><cf_get_lang dictionary_id='51413.Güncel Değer'></label>
                        <div class="col col-12 col-xs-12">
                            <input type="text" name="actual_value" id="actual_value" value="<cfoutput>#TLFormat(GET_STOCKBOND.ACTUAL_VALUE,session.ep.our_company_info.rate_round_num)#</cfoutput>" onBlur="hesapla();" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
                        </div>
                    </div>
                    <div class="form-group" id="item-guncel-deger-doviz">
                        <label class="col col-12"><cf_get_lang dictionary_id ='51414.Güncel Değer Döviz'></label>
                        <div class="col col-12 col-xs-12">
                            <input type="text" name="OTHER_ACTUAL_VALUE" id="OTHER_ACTUAL_VALUE" value="<cfoutput>#TLFormat(GET_STOCKBOND.OTHER_ACTUAL_VALUE,session.ep.our_company_info.rate_round_num)#</cfoutput>" onBlur="hesapla(1);" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
                        </div>
                    </div>
                    <div class="form-group"> 
                        <label class="col col-12 bold"><cf_get_lang dictionary_id='57677.Dövizler'></label>
                        <div class="col col-12 scrollContent scroll-x1">
                            <table>
                            <input type="hidden" name="deger_get_money" id="deger_get_money" value="<cfoutput>#get_action_money.recordcount#</cfoutput>">
                            <input type="hidden" name="money_type" id="money_type" value="<cfoutput>#session.ep.money#</cfoutput>">
                            <cfif session.ep.rate_valid eq 1>
                                <cfset readonly_info = "yes">
                            <cfelse>
                                <cfset readonly_info = "no">
                            </cfif>
                            <cfoutput query="get_action_money">
                            <tr>
                                <td height="17">
                                    <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                    <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                    <input type="radio" name="rd_money" id="rd_money" value="#money#" onClick="doviz_hesapla();" <cfif get_bond_action.other_money eq money>checked</cfif>>#money#
                                </td>
                                <td>
                                    #TLFormat(rate1,0)# / <input type="text" name="value_rate2#currentrow#" id="value_rate2#currentrow#"<cfif readonly_info>readonly</cfif> class="box" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" style="width:50px !important;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="doviz_hesapla();">
                                </td>
                            </tr>
                            </cfoutput>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                
                <div class="col col-12">
                    <div id="SHOW_INFO"></div>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </div>
    </cfform>
</cf_box>
<script>

    function kontrol(){
        if( $("#action_date").val() == '' || $("#actual_value").val() == '' || $("#OTHER_ACTUAL_VALUE").val() == '' ){
            alert("<cf_get_lang dictionary_id='29722.Zorunlu Alanları Doldurun'>");
            return false;
        }
        else{
            unformat_fields();
            AjaxFormSubmit(upd_act_value,'SHOW_INFO',1,'Güncelleniyor','Güncellendi');
            location.reload();
        }
        return false;
    }

    function unformat_fields()
    {

        document.getElementById("actual_value").value =  filterNum(document.getElementById("actual_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
         document.getElementById("OTHER_ACTUAL_VALUE").value =  filterNum(document.getElementById("OTHER_ACTUAL_VALUE").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');

        for(st=1;st<=document.getElementById("deger_get_money").value;st++)
        {
            document.getElementById("value_rate2"+ st).value = filterNum(document.getElementById("value_rate2"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
        }
    }

    function hesapla( val = null)
    {
        actual_value = document.getElementById("actual_value");
        OTHER_ACTUAL_VALUE= document.getElementById("OTHER_ACTUAL_VALUE");

        for (var i=1; i<=document.getElementById("deger_get_money").value; i++)
        {		
            if(document.upd_act_value.rd_money[i-1].checked == true)
            {
                form_value_rate2 = filterNum(document.getElementById("value_rate2"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                if( val == null) {
                    document.getElementById("OTHER_ACTUAL_VALUE").value = commaSplit(filterNum(document.getElementById("actual_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(form_value_rate2)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                }else{
                    document.getElementById("actual_value").value = commaSplit(filterNum(document.getElementById("OTHER_ACTUAL_VALUE").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*(parseFloat(form_value_rate2)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                }
            }
        }
        
    }

    function doviz_hesapla()
    {
        for (var t=1; t<=document.getElementById("deger_get_money").value; t++)
        {		
            if(document.upd_act_value.rd_money[t-1].checked == true)
            {
                	
                    rate2_value = filterNum(document.getElementById("value_rate2"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                    document.getElementById("OTHER_ACTUAL_VALUE").value = commaSplit(filterNum(document.getElementById("actual_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                
            }
        }
    }
    
    $("div#warning_modal").css({"min-width": 300})

</script>
