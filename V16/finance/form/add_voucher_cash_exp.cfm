<!--- <cfinclude template="../query/get_control.cfm"> --->
<cfinclude template="../query/get_money.cfm">
<!---<cfinclude template="../query/get_cashes.cfm">--->
<cfsavecontent variable="head_">
  <cfif isdefined('attributes.is_ciro_voucher')><cf_get_lang dictionary_id='54510.Endorsed Promissory Notes Entry'><cfelse><cf_get_lang dictionary_id='54506.Kasa Portföy Senet Girişi'></cfif>
</cfsavecontent>
<cfsavecontent variable="right">
  <font color="#FF0000"><cf_get_lang dictionary_id='54899.Dikkat Toplu Senet Girişi Workcube kullanacak şirketlerin sadece başlangıçta senetlerini sisteme girmeleri için kullanılır'></font>
</cfsavecontent>
<cfset pageHead = head_>

<cf_catalystHeader>
<cfform name="add_voucher_entry"  method="post" action="#request.self#?fuseaction=finance.emptypopup_add_voucher_cash_exp">
  <cfif isdefined('attributes.is_ciro_voucher')>
    <input type="hidden" name="is_ciro_voucher" id="is_ciro_voucher" value="1">
  </cfif>  
  <cfoutput query="GET_MONEY">
    <cfif money eq session.ep.money2>
      <cfinput name="money_rate2" type="hidden" value="#rate2#" class="moneybox">
    </cfif>
  </cfoutput>
<cf_box title="#head_#">
            <div class="row"><label class="pull-left bold"><cfoutput>#right#</cfoutput></label></div>
                <div class="row">
                    <div class="col col-12">
                        <cf_grid_list>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id="57520.Kasa"></th>
                                    <th><cf_get_lang dictionary_id="57742.Tarih">*</th>
                                    <th><cf_get_lang dictionary_id="58180.Borçlu"></th>
                                    <cfif isdefined("attributes.is_ciro_voucher")>
                                        <th><cf_get_lang dictionary_id="50488.Senet Sahibi"> *</th>
                                    </cfif>
                                    <th><cf_get_lang dictionary_id="57519.Cari Hesap"> *</th>
                                    <th><cf_get_lang dictionary_id="58502.Senet No"> *</th>
                                    <th><cf_get_lang dictionary_id="57673.Tutar"> *</th>
                                    <th><cf_get_lang dictionary_id="57489.Para Birimi"></th>
                                    <th><cf_get_lang dictionary_id="50263.Sistem Para Br."></th>
                                    <th><cf_get_lang dictionary_id="57789.Özel Kod"></th>
                                </tr>
                            </thead>
                            <cfloop from="1" to="15" index="i">
                            <tbody>
                                <tr>
                                <td>
                                    <cf_wrk_Cash name="hesap#i#" currency_branch="2">
                                </td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="54902.Senet Tarihini Giriniz"></cfsavecontent>
                                            <cfinput value="" type="text" name="VOUCHER_DUEDATE#i#" style="width:65px;" message="#message#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="VOUCHER_DUEDATE#i#"></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="48251.Şirket girmelisiniz"></cfsavecontent>
                                    <cfinput type="text" name="DEBTOR_NAME#i#" value="" style="width:80px;" message="#message#">
                                </td>
                                <cfif isdefined("attributes.is_ciro_voucher")>
                                    <td nowrap="nowrap">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <cfinput type="hidden" name="owner_company_id#i#" value="">
                                                <cfinput type="hidden" name="owner_consumer_id#i#" value="">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='50081.cari hesap Seçiniz !'></cfsavecontent>
                                                <cfinput type="text" name="owner_company_name#i#" value="" message="#message#" style="width:120px;" onFocus="AutoComplete_Create('owner_company_name#i#','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',0,2,0','COMPANY_ID,CONSUMER_ID','owner_company_id#i#,owner_consumer_id#i#','add_voucher_entry','3','250');">
                                                <span class="input-group-addon icon-ellipsis"  onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_member_name=add_voucher_entry.owner_company_name#i#&field_comp_id=add_voucher_entry.owner_company_id#i#&field_comp_name=add_voucher_entry.owner_company_name#i#&field_consumer=add_voucher_entry.owner_consumer_id#i#</cfoutput>');"></span>
                                            </div>
                                        </div>
                                    </td>
                                </cfif>
                                <td nowrap="nowrap">
                                    <div class="form-group">
                                        <div class="input-group">
                                            <cfinput type="hidden" name="company_id#i#" value="">
                                            <cfinput type="hidden" name="consumer_id#i#" value="">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='50081.cari hesap Seçiniz !'></cfsavecontent>
                                            <cfinput type="text" name="company_name#i#" value="" onFocus="AutoComplete_Create('company_name#i#','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',0,2,0','COMPANY_ID,CONSUMER_ID','company_id#i#,consumer_id#i#','add_voucher_entry','3','250');" message="#message#" style="width:120px;">
                                            <span class="input-group-addon icon-ellipsis"  onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_member_name=add_voucher_entry.company_name#i#&field_comp_id=add_voucher_entry.company_id#i#&field_comp_name=add_voucher_entry.company_name#i#&field_consumer=add_voucher_entry.consumer_id#i#</cfoutput>');"></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58744.Senet no giriniz"></cfsavecontent>
                                    <cfinput type="text" name="VOUCHER_NO#i#" style="width:80px;" message="#message#">
                                </td>
                                <td>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="54619.Tutar girmelisiniz"></cfsavecontent>
                                    <cfinput type="text" name="VOUCHER_VALUE#i#" class="moneybox" onBlur="hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" style="width:80px;" message="#message#">
                                </td>
                                <td>
                                    <select name="CURRENCY_ID<cfoutput>#i#</cfoutput>" id="CURRENCY_ID<cfoutput>#i#</cfoutput>" style="width:70px;" onChange="hesapla(<cfoutput>#i#</cfoutput>);">
                                    <cfoutput query="GET_MONEY">
                                    <option value="#money#;#rate2#;#rate1#"<cfif money eq session.ep.money>selected</cfif>>#MONEY#</option>
                                    </cfoutput>
                                    </select>
                                </td>
                                <td>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="54619.Tutar girmelisiniz"></cfsavecontent>
                                    <cfinput type="text" name="SYSTEM_VOUCHER_VALUE#i#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" style="width:80px;" message="#message#">
                                </td>
                                <cfinput type="hidden" name="VOUCHER_OTHER_MONEY_VALUE#i#" style="width:80px;" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                <td><cfinput type="text" name="VOUCHER_CODE#i#" value="" maxlength="50" style="width:80px;"></td>
                                </tr>
                            </tbody>
                            </cfloop> 
                        </cf_grid_list>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cf_workcube_buttons type_format="1" is_upd='0' add_function="kontrol()">
                    </div>
                </div>
            </cf_box>
</cfform>
<script type="text/javascript">
function kontrol()
{
   
	for(var i=1; i<=15; i++)
	{
        
        if(eval('add_voucher_entry.hesap'+i).value != "")
		{
            
            
            if(eval('add_voucher_entry.VOUCHER_NO'+i).value == "")
            {
                alert(i + ".<cf_get_lang dictionary_id='45657.Satır İçin'> <cf_get_lang dictionary_id='50332.Senet No Girmelisiniz'>");
                    return false;
            }
        
	
			if(eval('add_voucher_entry.VOUCHER_VALUE'+i).value == "")
			{
				alert(i + ".<cf_get_lang dictionary_id='45657.Satır İçin'> <cf_get_lang dictionary_id='54493.Lütfen Tutar Giriniz'> !");
				return false;
			}
			if(eval('add_voucher_entry.VOUCHER_DUEDATE'+i).value == "")
			{
				alert(i + ".<cf_get_lang dictionary_id='45657.Satır İçin'> <cf_get_lang dictionary_id='56195.Lütfen Tarih Seçiniz'>!");
				return false;
			}	
			if(eval('add_voucher_entry.VOUCHER_VALUE'+i).value != "" && ( eval('add_voucher_entry.company_name'+i).value == "" || ( eval('add_voucher_entry.company_name'+i).value != "" && eval('add_voucher_entry.company_id'+i).value == "" && eval('add_voucher_entry.consumer_id'+i).value == "" )) )
			{
				alert(i + ".<cf_get_lang dictionary_id='45657.Satır İçin'> <cf_get_lang dictionary_id='54489.Please Select Current Account'>!");
				return false;
			}
		}
		if (eval('add_voucher_entry.VOUCHER_VALUE'+i).value != "" && list_getat(eval('add_voucher_entry.hesap'+i).value,2,';') != list_getat(eval('add_voucher_entry.CURRENCY_ID'+i).value,1,';'))
		{
			alert('<cf_get_lang dictionary_id='50495.Kasa ile Senetin Para Birimi Farklı'>');
			return false;
		} 
		if(eval('add_voucher_entry.VOUCHER_VALUE'+i).value != "" && eval('add_voucher_entry.SYSTEM_VOUCHER_VALUE'+i).value == "")
		{
			alert("<cf_get_lang dictionary_id='54904.Sistem Para Birimi Tutarları Eksik'>!");
			return false;
		}
	}
	return (unformat_fields());
	return true;
}
function unformat_fields()
{
	for(var i=1; i<=15; i++)
		{
		eval('document.add_voucher_entry.VOUCHER_VALUE'+i).value=filterNum(eval('document.add_voucher_entry.VOUCHER_VALUE'+i ).value);
		eval('document.add_voucher_entry.SYSTEM_VOUCHER_VALUE'+i).value=filterNum(eval('document.add_voucher_entry.SYSTEM_VOUCHER_VALUE'+i ).value);
		eval('document.add_voucher_entry.VOUCHER_OTHER_MONEY_VALUE'+i).value=filterNum(eval('document.add_voucher_entry.VOUCHER_OTHER_MONEY_VALUE'+i ).value);
		}
	return true;
}
function hesapla(i)
{
	if(eval('document.add_voucher_entry.VOUCHER_VALUE'+i).value != '')
	{
		var temp_cheque_value = filterNum(eval('document.add_voucher_entry.VOUCHER_VALUE'+i).value);
		var money_type=eval('document.add_voucher_entry.CURRENCY_ID'+i)[eval('document.add_voucher_entry.CURRENCY_ID'+i).options.selectedIndex].value;
		money_rate = (list_getat(money_type,2,';')/list_getat(money_type,3,';'));
		eval('document.add_voucher_entry.SYSTEM_VOUCHER_VALUE'+i).value = commaSplit(parseFloat(temp_cheque_value)*parseFloat(money_rate));
		eval('document.add_voucher_entry.VOUCHER_VALUE'+i).value = commaSplit(temp_cheque_value);
		eval('document.add_voucher_entry.VOUCHER_OTHER_MONEY_VALUE'+i).value = commaSplit(filterNum(eval('document.add_voucher_entry.SYSTEM_VOUCHER_VALUE'+i).value)/document.add_voucher_entry.money_rate2.value);
	}
	else
		eval('document.add_voucher_entry.SYSTEM_VOUCHER_VALUE'+i).value =0;
}
</script>
