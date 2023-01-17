<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>
<cfquery name="get_op_type" datasource="#dsn3#">
	SELECT 
		O.*, 
		E.EMPLOYEE_NAME, 
		E.EMPLOYEE_SURNAME 
	FROM 
		OPERATION_TYPES O, 
		#dsn_alias#.EMPLOYEES E 
	WHERE 
		E.EMPLOYEE_ID = O.RECORD_EMP  AND	
		O.OPERATION_TYPE_ID = #attributes.operation_type_id#
</cfquery>
<table class="dph">
    <tr>
        <td class="dpht"><cfoutput>#getLang('prod',74)#</cfoutput></td>
        <td class="dphb">
            <a href="<cfoutput>#request.self#?fuseaction=prod.add_ezgi_operationtype</cfoutput>"><img src="/images/plus1.gif" align="absmiddle" title="<cf_get_lang_main no='170.Ekle'>" border="0"> </a>
            <a href="<cfoutput>#request.self#?fuseaction=prod.add_ezgi_operationtype&operation_type_id=#attributes.operation_type_id#</cfoutput>"><img src="/images/plus.gif" title="<cf_get_lang_main no='64.Kopyala'>" align="absmiddle" border="0"></a>
        </td>
    </tr>
</table>
<table class="dpm">
	<tr>
    	<td class="dpml">
            <cf_form_box nohover="1">
              <cfform name="operation_type" enctype="multipart/form-data" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_operationtype&operation_type_id=#attributes.operation_type_id#" method="post">
                <cfoutput>
                    <table border="0" cellspacing="1" cellpadding="1" width="100%">
                        <tr>
                            <td><cf_get_lang_main no ='81.Aktif'>/<cf_get_lang_main no ='82.Pasif'></td>
                            <td>
                                <input type="checkbox" name="status" id="status" value="1" <cfif get_op_type.operation_status eq 1>checked</cfif>>
                            </td>
                        </tr>
                        <tr>
                            <td width="90"><cfoutput>#getLang('ch',188)#</cfoutput> *</td>
                            <td>
                            	<select name="is_virtual" id="is_virtual" style="width:70px">
                                	<option value="0" <cfif get_op_type.IS_VIRTUAL eq 0>selected</cfif>><cf_get_lang_main no='3293.Gerçek'></option>
                                    <option value="1" <cfif get_op_type.IS_VIRTUAL eq 1>selected</cfif>><cf_get_lang_main no='1515.Sanal'></option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td width="90"><cf_get_lang_main no='388.İşlem Tipi'> *</td>
                            <td><cfsavecontent variable="message">#getLang('prod',427)#</cfsavecontent>
                            <cfinput type="text" name="op_name" required="yes" message="#message#"  style="width:201px;" value="#get_op_type.OPERATION_TYPE#">
                            </td>
                        </tr>
                        <tr>
                            <td><cfoutput>#getLang('prod',64)#</cfoutput> *</td>
                            <td><cfinput type="text" name="operation_code" id="operation_code" style="width:201px;" value="#get_op_type.OPERATION_CODE#" maxlength="5"></td>
                        </tr>
                        <tr> 
                            <td width="80"><cfoutput>#getLang('prod',32)#</cfoutput> *</td>
                            <td>
                                <cfsavecontent variable="message"><cfoutput>#getLang('prod',31)#</cfoutput></cfsavecontent>
                                <cfinput type="text" name="operation_cost" validate="float" style="width:138px;" class="moneybox" message="#message#" value="#TLFormat(get_op_type.operation_cost)#" onkeyup="return(FormatCurrency(this,event));">
                                <select name="money" id="money" style="width:60px;">
                                <cfloop query="get_money">
                                <option value="#money#" <cfif get_op_type.money eq money>selected</cfif>>#money#</option>
                                </cfloop>
                                </select>
                            </td>
                        </tr>

                        <tr>
                            <td><cf_get_lang_main no='3355.Hazırlık Süresi'> *</td>
                			<td>
                    			<cfinput type="text" name="ezgi_h_sure" style="width:100px; text-align:right" maxlength="3" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this);" value="#get_op_type.EZGI_H_SURE#">
                    			(<cf_get_lang_main no='3223.Sn'>.)
                			</td>
                        </tr>
                        <tr>
                            <td width="90"><cfoutput>#getLang('prod',561)#</cfoutput> *</td>
                            <td>
                            	 <cfinput type="text" name="minutes" style="width:50px; text-align:right" maxlength="3" onkeyup="isNumber(this);" onblur="isNumber(this);"  validate="integer" value="#get_op_type.O_MINUTE#">
                            </td>
                        </tr>
                        <tr>
                            <td width="90"><cf_get_lang_main no='3356.Zaman Formülü'> *</td>
                            <td>
                            	 <cfinput type="text" name="ezgi_formul" style="width:200px; text-align:left" value="#get_op_type.EZGI_FORMUL#">
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no='217.Açıklama'> 2</td>
                            <td><input type="text" name="comment_2" id="comment_2" maxlength="100" style="width:200px; height:20px;" value="#get_op_type.comment2#"/></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no='217.Açıklama'></td>
                            <td><textarea name="comment" id="comment" style="width:200px; height:70px;">#get_op_type.comment#</textarea></td>
                        </tr>
                        <tr>
                            <td><cfif len(get_op_type.FILE_NAME)><input type="radio" name="upd_asset" id="upd_asset" value="1"></cfif><cf_get_lang_main no='56.Belge'></td>
                            <td><input type="file" name="asset" id="asset" style="width:200px;"></td>
                        </tr>
                        <cfif len(get_op_type.FILE_NAME)>
                        <tr>
                            <td colspan="2">
                                <input type="radio" name="upd_asset" id="upd_asset" value="0" checked>
                                <a href="javascript://" onclick="windowopen('#file_web_path#operationtype/#get_op_type.FILE_NAME#','medium')" class="tableyazi">#get_op_type.FILE_NAME#</a>
                            </td>
                        </tr>
                        </cfif>
                    </table>
                    <cf_form_box_footer>
                        <input type="hidden" name="record_date" id="record_date">
                        <input type="hidden" name="record_emp" id="record_emp"><cf_workcube_buttons is_upd='1' is_delete='0' add_function='unformat_fields()'>
                    </cf_form_box_footer>
                </cfoutput>
              </cfform>
            </cf_form_box>
		</td>
		<td class="dpmr">
            <cfsavecontent variable="message"><cf_get_lang_main no='1422.İstasyon'>-<cf_get_lang_main no='3367.Kapasite'>/<cf_get_lang_main no='79.Saat'></cfsavecontent>
            <cf_box id="list_ezgi_product_ws"
            title="#message#"
            box_page="#request.self#?fuseaction=prod.emptypopup_list_ezgi_product_ws_ajaxproduct&operation_type_id=#attributes.operation_type_id#"
            add_href="#request.self#?fuseaction=prod.popup_add_ezgi_ws_product&is_upd_workstation=1&operation_type_id=#attributes.operation_type_id#"
            closable="0"
            add_href_size="horizantal"></cf_box>
		</td>
    </tr>
</table>
<script type="text/javascript">
function unformat_fields()
{	
	if(document.getElementById('operation_code').value != '')
	{
		var listParam = document.getElementById('operation_code').value + "*" + "<cfoutput>#attributes.operation_type_id#</cfoutput>";
		operation_code_control=wrk_safe_query("prdp_operation_code_control",'dsn3',0,listParam);
		if(operation_code_control.recordcount > 0)
		{
			alert("<cf_get_lang_main no='3358.Girdiginiz Operasyon Kodu Kullanılıyor'>");
			return false;
		}
	}

	operation_type.operation_cost.value = filterNum(operation_type.operation_cost.value);
	return true;
}
</script>