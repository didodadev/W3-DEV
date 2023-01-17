<!--- <cfinclude template="../query/get_control.cfm"> --->
<cfinclude template="../query/get_money.cfm">
<!---<cfinclude template="../query/get_cashes.cfm">--->
<cfsavecontent variable="head_">
<cfif isDefined("attributes.is_ciro_cheque")><cf_get_lang dictionary_id='54476.Toplu Ciro Çek Girişi'><cfelse><cf_get_lang dictionary_id='54618.Kasalara Toplu Portföy Çek Girişi'></cfif>
</cfsavecontent>
<cfsavecontent variable="right">
    <font color="#FF0000"><cf_get_lang dictionary_id='54617.Dikkat Toplu Çek Girişi Workcube kullanacak şirketlerin sadece başlangıçta çeklerini sisteme girmeleri için kullanılır'>.</font>
</cfsavecontent>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_cheque_entry"  method="post" action="#request.self#?fuseaction=finance.emptypopup_add_cheque_cash_exp">
            <cfif isdefined("attributes.is_ciro_cheque")> <!--- sayfa ciro cek aktarımından geliyorsa --->
                <input type="hidden" name="is_ciro_cheque" id="is_ciro_cheque" value="1">
            </cfif>
            <cfoutput query="GET_MONEY">
                <cfif money eq session.ep.money2>
                    <cfinput name="money_rate2" type="hidden" value="#rate2#" class="moneybox">
                </cfif>
            </cfoutput>
            <div class="row"><label class="pull-left bold"><cfoutput>#head_#</cfoutput></label><label class="pull-right bold"><cfoutput>#right#</cfoutput></label></div>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="200"><cf_get_lang dictionary_id='57520.Kasa'></th>
                        <th><cf_get_lang dictionary_id='57742.Tarih'> *</th>
                        <th><cf_get_lang dictionary_id='58180.Borçlu'></th>
                        <th><cf_get_lang dictionary_id='58970.Ciro Eden'></th>
                        <cfif isdefined("attributes.is_ciro_cheque")>
                            <th><cf_get_lang dictionary_id='58902.Çek Sahibi'> *</th>
                        </cfif>
                        <th width="250"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</th>
                        <th><cf_get_lang dictionary_id='57521.Banka'></th>
                        <th><cf_get_lang dictionary_id='57453.Şube'></th>
                        <th nowrap="nowrap"><cf_get_lang dictionary_id='54490.Çek No'></th>
                        <th><cf_get_lang dictionary_id='57673.Tutar'> *</th>
                        <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                        <th><cf_get_lang dictionary_id='54901.Sistem Para Br.'></th>
                        <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                    </tr>
                </thead>
                <cfloop from="1" to="15" index="i">
                    <tbody>
                        <tr>
                            <td>
                                <div class="form-group">
                                    <cf_wrk_Cash name="hesap#i#" currency_branch="2">
                                </div>
                            </td>
                            <td nowrap="nowrap">
                                <div class="form-group">
                                    <div class="input-group">
                                        <cfinput value="" type="text" name="CHEQUE_DUEDATE#i#" message="#getLang('','Lutfen Tarih Giriniz',58503)#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="CHEQUE_DUEDATE#i#"></span>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="form-group"><cfinput type="text" name="DEBTOR_NAME#i#" value="" message="#getLang('','şirket giriniz',54613)#"></div>
                            </td>
                            <td><div class="form-group"><cfinput type="text" name="endorsement_member#i#"></div></td>
                            <cfif isdefined("attributes.is_ciro_cheque")>
                                <td nowrap="nowrap">
                                    <div class="form-group">
                                        <div class="input-group">
                                            <cfinput type="hidden" name="owner_company_id#i#" value="">
                                            <cfinput type="hidden" name="owner_consumer_id#i#" value="">
                                            <cfinput type="text" name="owner_company_name#i#" value="" message="#getLang('','cari hesap Seçiniz',45308)#" onFocus="AutoComplete_Create('owner_company_name#i#','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',0,2,0','COMPANY_ID,CONSUMER_ID','owner_company_id#i#,owner_consumer_id#i#','add_cheque_entry','3','250');">
                                            <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_member_name=add_cheque_entry.owner_company_name#i#&field_comp_id=add_cheque_entry.owner_company_id#i#&field_comp_name=add_cheque_entry.owner_company_name#i#&field_consumer=add_cheque_entry.owner_consumer_id#i#</cfoutput>');"></span>
                                        </div>
                                    </div>
                                </td>
                            </cfif>
                            <td nowrap="nowrap">
                                <div class="form-group">
                                    <div class="input-group">
                                        <cfinput type="hidden" name="company_id#i#" value="">
                                        <cfinput type="hidden" name="consumer_id#i#" value="">
                                        <cfinput type="text" name="company_name#i#" value="" message="#getLang('','cari hesap Seçiniz',45308)#" onFocus="AutoComplete_Create('company_name#i#','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',0,2,0','COMPANY_ID,CONSUMER_ID','company_id#i#,consumer_id#i#','add_cheque_entry','3','250');">
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_member_name=add_cheque_entry.company_name#i#&field_comp_id=add_cheque_entry.company_id#i#&field_comp_name=add_cheque_entry.company_name#i#&field_consumer=add_cheque_entry.consumer_id#i#</cfoutput>');"></span>
                                    </div>
                                </div>
                            </td>
                            <td><div class="form-group"><cfinput type="text" name="BANK_NAME#i#"></div></td>
                            <td><div class="form-group"><cfinput type="text" name="BANK_BRANCH_NAME#i#"></div></td>
                            <td>
                                <div class="form-group">
                                    <cfinput type="text" name="CHEQUE_NO#i#" onkeyup="isNumber(this);" onblur='isNumber(this);' message="#getLang('','çek no giriniz',54614)#">
                                </div>
                            </td>
                            <td>
                                <div class="form-group"><cfinput type="text" name="CHEQUE_VALUE#i#" id="CHEQUE_VALUE#i#"  class="moneybox" onBlur="hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" message="#getLang('','tutar girmelisiniz',29535)#"></div>
                            </td>
                            <td>
                                <div class="form-group">
                                    <select name="CURRENCY_ID<cfoutput>#i#</cfoutput>" id="CURRENCY_ID<cfoutput>#i#</cfoutput>" onchange="hesapla(<cfoutput>#i#</cfoutput>);">
                                        <cfoutput query="GET_MONEY">
                                            <option value="#money#;#rate2#;#rate1#"<cfif money eq session.ep.money>selected</cfif>>#MONEY#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </td>
                            <td nowrap="nowrap">
                                <div class="form-group"><cfinput type="text" name="SYSTEM_CHEQUE_VALUE#i#"  class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div>
                            </td>
                            <cfinput type="hidden" name="CHEQUE_OTHER_MONEY_VALUE#i#" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                            <td nowrap="nowrap"><div class="form-group"><cfinput type="text" name="CHEQUE_CODE#i#" value="" maxlength="50"></div></td>
                        </tr>
                    </tbody>
                </cfloop>  
            </cf_grid_list>
            <cf_box_footer>
                <cf_workcube_buttons type_format="1" is_upd='0' add_function="kontrol()">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	for(var i=1; i<=15; i++)
	{
		if(eval('add_cheque_entry.CHEQUE_NO'+i).value != "")
		{
			if(eval('add_cheque_entry.CHEQUE_VALUE'+i).value == "")
			{
				alert(i + ".Satır için Lütfen Tutar Giriniz !");
				return false;
			}
			if(eval('add_cheque_entry.CHEQUE_DUEDATE'+i).value == "")
			{
				alert(i + ".Satır için Lütfen Tarih Seçiniz !");
				return false;
			}	
			if(eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" && ( eval('add_cheque_entry.company_name'+i).value == "" || ( eval('add_cheque_entry.company_name'+i).value != "" && eval('add_cheque_entry.company_id'+i).value == "" && eval('add_cheque_entry.consumer_id'+i).value == "" )) )
			{
				alert(i + ".Satır için Lütfen Cari Hesap Seçiniz!");
				return false;
			}
		}
		else if(eval('add_cheque_entry.CHEQUE_NO'+i).value == "" && (eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" || eval('add_cheque_entry.CHEQUE_DUEDATE'+i).value != "" || eval('add_cheque_entry.company_name'+i).value != "" || eval('add_cheque_entry.company_id'+i).value != "" || eval('add_cheque_entry.consumer_id'+i).value != ""))
		{
			alert(i + ".Satır için Lütfen Çek No Giriniz!");
			return false;
		}
		if (eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" && list_getat(eval('add_cheque_entry.hesap'+i).value,2,';') != list_getat(eval('add_cheque_entry.CURRENCY_ID'+i).value,1,';'))
		{
			alert('Kasa ile Çekin Para Birimi Farklı');
			return false;
		} 
		if(eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" && eval('add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value == "")
		{
			alert("Sistem Para Birimi Tutarları Eksik!");
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
		eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value=filterNum(eval('document.add_cheque_entry.CHEQUE_VALUE'+i ).value);
		eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value=filterNum(eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i ).value);
		eval('document.add_cheque_entry.CHEQUE_OTHER_MONEY_VALUE'+i).value=filterNum(eval('document.add_cheque_entry.CHEQUE_OTHER_MONEY_VALUE'+i ).value);
	}
	return true;
}
function hesapla(i)
{
	if(eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value != '')
	{
		var temp_cheque_value = filterNum(eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value);
		var money_type=eval('document.add_cheque_entry.CURRENCY_ID'+i)[eval('document.add_cheque_entry.CURRENCY_ID'+i).options.selectedIndex].value;
		money_rate = (list_getat(money_type,2,';')/list_getat(money_type,3,';'));
		eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value = commaSplit(parseFloat(temp_cheque_value)*parseFloat(money_rate));
		eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value = commaSplit(temp_cheque_value);
		eval('document.add_cheque_entry.CHEQUE_OTHER_MONEY_VALUE'+i).value = commaSplit(filterNum(eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value)/document.add_cheque_entry.money_rate2.value);
	}
	else
		eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value =0;
}
</script>
