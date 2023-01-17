<cfquery name="GET_CUSTOMER_TYPE" datasource="#DSN#">
	SELECT 
	    CUSTOMER_TYPE_ID, 
        CUSTOMER_TYPE, 
        DETAIL, 
        IS_CONTROL, 
        CONTROL_RATE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_CUSTOMER_TYPE 
    WHERE 
	    CUSTOMER_TYPE_ID = #url.id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  	<tr>
		<td class="headbold"><cf_get_lang_main no='45.Müşteri'> <cf_get_lang no='1627.Tipi'> <cf_get_lang_main no='52.Guncelle'></td>
		<td align="right" class="headbold" style="text-align:right;">
			<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_crm_contracts_history&id=#url.id#&customer_type=1</cfoutput>','list','popup_customer_type_history');"><img src="/images/history.gif" alt="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_customer_type"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a>
		</td>
  	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_customer_type.cfm"></td>
		<td valign="top">
            <table>
                <cfform name="upd_customer_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_customer_type">
                <input type="hidden" name="customer_type_id" id="customer_type_id" value="<cfoutput>#url.id#</cfoutput>">
                <input type="hidden" name="old_customer_type" id="old_customer_type" value="<cfoutput>#get_customer_type.customer_type#</cfoutput>">
                <input type="hidden" name="old_is_control" id="old_is_control" value="<cfoutput>#get_customer_type.is_control#</cfoutput>">
                <input type="hidden" name="old_control_rate" id="old_control_rate" value="<cfoutput>#get_customer_type.control_rate#</cfoutput>">
                <input type="hidden" name="old_detail" id="old_detail" value="<cfoutput>#get_customer_type.detail#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='218.Tip'>*</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no='1755.Tip Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="customer_type" value="#get_customer_type.customer_type#" maxlength="25" required="Yes" message="#message#" style="width:180px;">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea name="detail" id="detail" style="width:180px;height:90px;"><cfoutput>#get_customer_type.detail#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang no='1710.Tutar Kontrolü'></td>
                        <td><input type="checkbox" name="is_control" id="is_control" <cfif get_customer_type.is_control eq 1>checked</cfif> onClick="is_control_function()"></td>
                    </tr>
                    <tr>
                        <td><span id="span_1" <cfif get_customer_type.is_control eq 0>style="display:none;"</cfif>><cf_get_lang no='1354.Zorunluluk Oranı'></span></td>
                        <td>
                            <span id="span_2" <cfif get_customer_type.is_control eq 0>style="display:none;"</cfif>>
                                <input type="text" name="control_rate" id="control_rate" value="<cfoutput>#tlformat(get_customer_type.control_rate,0)#</cfoutput>" maxlength="3" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox" style="width:30px;">
                            </span>
                        </td>
                    </tr>			
                    <tr>
                        <td></td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cfoutput>
                                <cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_customer_type.record_emp,0,0)# - #dateformat(get_customer_type.record_date,dateformat_style)#<br/>
                            <cfif len(get_customer_type.update_emp)>
                                <cf_get_lang_main no='291.Güncelleme'> : #get_emp_info(get_customer_type.update_emp,0,0)# - #dateformat(get_customer_type.update_date,dateformat_style)#
                            </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
		</td>
	</tr>
</table>
<script type="text/javascript">
function kontrol()
{
	if(document.upd_customer_type.detail.value.length>1000)
	{
		alert("<cf_get_lang no='2643.Açıklama 1000 Karakterden Uzun Olamaz'>!");
		return false;
	}
	if(document.upd_customer_type.is_control.checked == true)
	{
		if(document.upd_customer_type.control_rate.value == '')
		{
			alert("<cf_get_lang no='1376.Zorunluluk Oranı Girmelisiniz'>!");
			return false;		
		}
		else
		{
			if(document.upd_customer_type.control_rate.value > 100)
			{
				alert("<cf_get_lang no='1377.Zorunluluk Oranı Kontrol Ediniz'>!");
				return false;
			}
		}
		
	}
	document.upd_customer_type.control_rate.value = filterNum(document.upd_customer_type.control_rate.value);
	return true;
}

function is_control_function()
{
	if(document.upd_customer_type.is_control.checked == true)
	{
		goster(span_1);
		goster(span_2);
	}
	else
	{
		gizle(span_1);
		gizle(span_2);
	}
}
</script>
