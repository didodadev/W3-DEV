
<cfinclude template="../../objects/query/tax_type_code.cfm">
<cf_box title="#getLang(280,'Özel İletişim Vergi Oranı',50980)#" add_href="#request.self#?fuseaction=settings.list_oiv" is_blank="0">
    <cfform name="tax">
        <cf_box_elements> 
            <div class="col col-3 col-xs-12">
				<div class="scrollbar" style="max-height:403px;overflow:auto;">
                    <div id="cc">
                        <cfinclude template="../display/list_oiv.cfm">
                    </div>
                </div>
            </div>
            <div class="col col-6 col-xs-12">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42531.Satış Muhasebe Kodu'><cfif session.ep.period_is_integrated eq 1> <font color=black>*</font></cfif></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" value="<cfoutput>#session.ep.period_is_integrated#</cfoutput>" name="period_is_integrated" id="period_is_integrated">
                            <input type="Hidden" id="counter" name="counter">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='42203.Satış Muhasebe Kodu girmelisiniz'></cfsavecontent>
                            <cfinput type="text" required="yes" message="#message#" name="Account_Code" onFocus="AutoComplete_Create('Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42532.Alış Muhasebe Kodu'><cfif session.ep.period_is_integrated eq 1><font color=black>*</font></cfif></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='42253.Alis Muhasebe Kodu Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" required="yes" message="#message#" name="Account_Code_p" onFocus="AutoComplete_Create('Account_Code_p','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                            <span class="input-group-addon icon-ellipsis" href="javascript://"  onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=tax.Account_Code_p');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42995.Satış İade Muhasebe Kodu'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='43187.Satış İade Muhasebe Kodu girmelisiniz'></cfsavecontent>
                            <cfinput type="text" required="yes" message="#message#" name="Account_Code_iade" onFocus="AutoComplete_Create('Account_Code_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code_iade');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42996.Alış İade Muhasebe Kodu'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='43186.Alış İade Muhasebe Kodu Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" required="yes" message="#message#" name="Account_Code_p_iade" onFocus="AutoComplete_Create('Account_Code_p_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code_p_iade');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50982.ÖİV'><cf_get_lang dictionary_id='58671.Oranı'><font color=black>*</font></label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='50982.ÖİV'><cf_get_lang dictionary_id='58671.Oranı'></cfsavecontent>
                        <cfinput type="text" name="tax_" value="" maxlength="4" required="yes" message="#message#" onKeyUp="return(FormatCurrency(this,event,3));">
                    </div>
                </div>
                <div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53332.Vergi'><cf_get_lang dictionary_id='49089.Kodu'><cfif session.ep.our_company_info.is_efatura>*</cfif></label>
                    <div class="col col-8 col-xs-12">
                        <select name="tax_code" id="tax_code" style="width:137px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>!</option>
                            <cfoutput query="TAX_CODES">
                                <option value="#TAX_CODE_ID#,#TAX_CODE_NAME#" title="#detail#">#TAX_CODE_NAME#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <textarea name="detail" id="detail" rows="6" cols="45" style="width:137px; height:40px;"></textarea>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="kontrol()">
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		x = (50 - document.tax.detail.value.length);
		if ( x < 0)
		{ 
			alert ("<cf_get_lang dictionary_id ='43826.Bölümüne En Fazla 50 Karakter Girmelisiniz'>");
			return false;
		}
		if (document.getElementById('period_is_integrated').value == 1)
		{
			if (document.tax.Account_Code =='')
			{
				alert("<cf_get_lang dictionary_id ='43177.Lütfen Satış Muhasebe Kodu Seçiniz'>!");
				return false;
			}
			if (document.tax.Account_Code_p =='')
			{
				alert("<cf_get_lang dictionary_id ='43178.Lütfen Alış Muhasebe Kodu Seçiniz'>!");
				return false;
            }
        }
		<cfif session.ep.our_company_info.is_efatura>
		if(document.getElementById('tax_code').value == '')
		{
			alert("<cf_get_lang dictionary_id='60818.Vergi Kodu Seçiniz'> !");
			return false;
		}
		</cfif>
		if(tax_code_validation() == 0)
			return false;
		return true;
	}
	function tax_code_validation()
	{
		var inputlist = ["Account_Code","Account_Code_p","Account_Code_iade","Account_Code_p_iade"];
		for(i=1; i< inputlist.length; i++) {
			if(WrkAccountControl(document.getElementById(inputlist[i-1]).value, "<cf_get_lang dictionary_id='61205.Lütfen geçerli muhasebe kodları kullanınız'>",'<cfoutput>#dsn2#</cfoutput>') == 0)
				return false;
		}
		return true;
	}
	function pencere_ac(isim)
	{
		if(document.getElementById(isim).value.length != 0)
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=tax.'+isim+'&account_code=' + document.getElementById(isim).value);
		else
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=tax.'+isim+'&account_code=');
	}
</script>