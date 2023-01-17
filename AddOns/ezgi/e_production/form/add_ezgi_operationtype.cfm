<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>
<cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
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
</cfif>
<cf_form_box title="#getLang('prod',67)#">
    <cfform name="operation_type" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_operationtype" > 
         <table>
            <tr>
                <td><cf_get_lang_main no ='81.Aktif'>/<cf_get_lang_main no ='82.Pasif'></td>
                <td>
                    <cfif isdefined('get_op_type')>
                    <input type="checkbox" name="status" id="status" value="1" <cfif get_op_type.operation_status eq 1>checked</cfif>>
                    <cfelse>
                    <input type="checkbox" name="status" id="status" value="1">
                    </cfif>
                </td>
            </tr>
            <tr>
             	<td width="90"><cfoutput>#getLang('ch',188)#</cfoutput> *</td>
             	<td>
                 	<select name="is_virtual" id="is_virtual" style="width:70px">
                     	<option value="0"><cf_get_lang_main no='3293.Gerçek'></option>
                      	<option value="1"><cf_get_lang_main no='1515.Sanal'></option>
                  	</select>
            	</td>
       		</tr>
            <tr> 
                <td><cf_get_lang_main no='388.İşlem Tipi'>*</td>
                <td>
                    <cfsavecontent variable="message"><cfoutput>#getLang('prod',427)#</cfoutput></cfsavecontent>
                    <cfif isdefined('get_op_type')>
                    <cfinput type="text" name="op_name" required="yes" message="#message#"  style="width:201px;" value="#get_op_type.OPERATION_TYPE#">
                    <cfelse>
                    <cfinput type="text" name="op_name" required="yes" message="#message#" style="width:201px;">
                    </cfif> 
                </td>
            </tr>
            <tr>
                <td nowrap="nowrap"><cfoutput>#getLang('prod',64)#</cfoutput> *</td>
                <td>
                    <cfif isdefined('get_op_type')>
                    <cfinput type="text" name="operation_code" id="operation_code" style="width:201px;" value="#get_op_type.OPERATION_CODE#" maxlength="5">
                    <cfelse>
                    <cfinput type="text" name="operation_code" id="operation_code" style="width:201px;" maxlength="5">
                    </cfif>
                </td>
            </tr>
            <tr> 
                <td width="80"><cfoutput>#getLang('prod',32)#</cfoutput> *</td>
                <td><cfsavecontent variable="message1"><cfoutput>#getLang('prod',31)#</cfoutput></cfsavecontent>
                    <cfif isdefined('get_op_type')>
                        <cfinput type="text" name="operation_cost" validate="float" style="width:138px;" class="moneybox" message="#message#" value="#TLFormat(get_op_type.operation_cost)#" onkeyup="return(FormatCurrency(this,event));">
                            <select name="money" id="money" style="width:60px;">
                            <cfloop query="get_money">
                                <option value="<cfoutput>#money#</cfoutput>" <cfif get_op_type.money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>
                            </cfloop>
                        </select>
                    <cfelse>

                        <cfinput type="text" name="operation_cost" validate="float" class="moneybox" style="width:138px;" required="yes" message="#message1#" onkeyup="return(FormatCurrency(this,event));">
                        <select name="money" id="money" style="width:60px;">
                            <cfoutput query="get_money">
                                <option value="#money#" >#money#</option>
                            </cfoutput>
                        </select>
                    </cfif>
                </td>
            </tr>
            <tr> 
                <td><cf_get_lang_main no='3355.Hazırlık Süresi'></td>
                <td>
                    <cfif isdefined('get_op_type')>
                    	<cfinput type="text" name="ezgi_h_sure" style="width:100px; text-align:right" maxlength="3" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this);" value="#get_op_type.EZGI_H_SURE#">
                    <cfelse>
                    	<cfinput type="text" name="ezgi_h_sure"  style="width:100px; text-align:right" maxlength="3" onkeyup="isNumber(this);" onblur="isNumber(this);"  validate="integer" value="0">
                    </cfif>
                    (sn.)
                </td>
            </tr>
            <tr>
          		<td width="90"><cfoutput>#getLang('prod',561)#</cfoutput> *</td>
              	<td>
                 	<cfinput type="text" name="minutes" value="0"  style="width:100px; text-align:right" maxlength="3" onkeyup="isNumber(this);" onblur="isNumber(this);"  validate="integer">
                 	(sn.)
              	</td>
          	</tr>
            <tr>
             	<td width="90"><cf_get_lang_main no='3356.Zaman Formülü'> *</td>
             	<td><cfinput type="text" name="ezgi_formul" style="width:200px; text-align:left" value=""></td>
        	</tr>
            <tr> 
                <td valign="top"><cf_get_lang_main no='217.Açıklama'> 2</td>
                <td>
                    <cfif isdefined('get_op_type')>
                        <cfinput type="text" name="comment_2" maxlength="100" style="width:200px; height:20px;" value="#get_op_type.comment2#"/>
                    <cfelse>
                        <cfinput type="text" name="comment_2" maxlength="100" style="width:200px; height:20px;"/>
                    </cfif>
                </td>
            </tr>
            <tr> 
                <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                <td>
                    <cfif isdefined('get_op_type')>
                        <cftextarea name="comment"  style="width:200px; height:70px;"><cfoutput>#get_op_type.comment#</cfoutput></cftextarea>
                    <cfelse>
                        <cftextarea name="comment"  style="width:200px; height:80px;" ></cftextarea>
                    </cfif>
                </td>
            </tr>
            <tr> 
                <td><cf_get_lang_main no='56.Belge'></td>
                <td><input type="file" name="asset" id="asset" style="width:200px;"></td>
            </tr>
            <tr> 
                <td colspan="2"><input type="hidden" name="record_date" id="record_date"> 
                    <input type="hidden" name="record_emp" id="record_emp"> 
                </td>
            </tr>
        </table>
        <cf_form_box_footer><cf_workcube_buttons is_upd='0' add_function='unformat_fields()'></cf_form_box_footer>
    </cfform>
</cf_form_box>
<script type="text/javascript">
	function unformat_fields()
	{
		if ((document.operation_type.comment_2.value.length) > 100 || (document.operation_type.comment.value.length) > 100 )
		{
			alert('<cf_get_lang_main no='3357.En Fazla 100 Karakter Açıklama Girebilirsiniz.'>');	
			return false;
		}
		if(document.getElementById('operation_code').value != '')
		{
			operation_code_control=wrk_safe_query("prdp_op_code","dsn3",0,document.getElementById('operation_code').value);
			if(operation_code_control.recordcount > 0)
			{
				alert("<cf_get_lang_main no='3358.Girdiginiz Operasyon Kodu Kullanılıyor'>!");
				return false;
			}
		}
		else
		{
			alert("<cf_get_lang_main no='3359.Lütfen Operasyon Kodu Giriniz.'>");
			return false;
		}
		
		operation_type.operation_cost.value = filterNum(operation_type.operation_cost.value);
		return true;
	}
</script>