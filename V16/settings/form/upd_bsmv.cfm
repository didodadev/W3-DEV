
<cfinclude template="../../objects/query/tax_type_code.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','BSMV Oranı','50999')#" add_href="#request.self#?fuseaction=settings.list_bsmv" is_blank="0">
        <cfset gbsmv = createObject("component","V16.settings.cfc.bsmv")/>
        <cfset category= gbsmv.SelectID(attributes.bid)/>
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
            <cfinclude template="../display/list_bsmv.cfm">
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="tax">
                <input type="hidden" value="<cfoutput>#session.ep.period_is_integrated#</cfoutput>" name="period_is_integrated" id="period_is_integrated">
                <input type="Hidden" id="counter" name="counter">
                <cfinput type="hidden" name="bid" value="#attributes.bid#">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-Account_Code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42531.Satış Muhasebe Kodu'><cfif session.ep.period_is_integrated eq 1> *</cfif></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='42203.Satış Muhasebe Kodu Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" required="yes" message="#message#" name="Account_Code" value="#category.account_code#" onFocus="AutoComplete_Create('Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-Account_Code_p">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42532.Alış Muhasebe Kodu'><cfif session.ep.period_is_integrated eq 1> *</cfif></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='42253.Alış Muhasebe Kodu Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" required="yes" message="#message#" name="Account_Code_p" value="#category.purchase_code#" onFocus="AutoComplete_Create('Account_Code_p','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=tax.Account_Code_p');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-Account_Code_iade">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42995.Satış İade  Muhasebe Kodu'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='43187.Satış İade Muhasebe Kodu Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" required="yes" message="Satış İade Muhasebe Kodu girmelisiniz" name="Account_Code_iade" value="#category.account_code_iade#" onFocus="AutoComplete_Create('Account_Code_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">   
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code_iade');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-Account_Code_p_iade">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42996.Alış İade Muhasebe Kodu'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='43186.Alış İade Muhasebe Kodu Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" required="yes" message="Alış İade Muhasebe Kodu girmelisiniz" name="Account_Code_p_iade" value="#category.purchase_code_iade#" onFocus="AutoComplete_Create('Account_Code_p_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code_p_iade');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-direct_expense_Account_Code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56194.Doğrudan Giderleştirme Hesabı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="direct_expense_Account_Code" value="#category.DIRECT_EXPENSE_CODE#" onFocus="AutoComplete_Create('direct_expense_Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('direct_expense_Account_Code');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_item_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52017.Doğrudan Giderleştirme Gider Kalemi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="expense_item_id" id="expense_item_id" value="#category.EXPENSE_ITEM_ID#">
                                    <cfinput type="text" name="expense_item_name" id="expense_item_name" value="#category.EXPENSE_ITEM_NAME#" onFocus="AutoComplete_Create('expense_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','0','EXPENSE_ITEM_ID,ACCOUNT_CODE,TAX_CODE','expense_item_id,account_code,tax_code','add_costplan',1);" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_item();"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-tax_">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50923.BSMV'><cf_get_lang dictionary_id='58671.Oranı'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='50923.BSMV'><cf_get_lang dictionary_id='58671.Oranı'></cfsavecontent>
                                <cfinput type="text" name="tax_" value="#tlformat(category.tax,3)#" maxlength="5" required="yes" message="#message#" onKeyUp="return(FormatCurrency(this,event,3));">
                            </div>
                        </div>
                        <div class="form-group" id="item-TAX_CODES">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53332.Vergi'><cf_get_lang dictionary_id='49089.Kodu'><cfif session.ep.our_company_info.is_efatura>*</cfif></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="tax_code" id="tax_code">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="TAX_CODES">
                                        <option value="#TAX_CODE_ID#,#TAX_CODE_NAME#" title="#TAX_CODE_NAME#" <cfif tax_codes.tax_code_id eq CATEGORY.tax_code>selected="selected"</cfif>>#TAX_CODE_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="detail" id="detail" rows="2" cols="21"><cfoutput>#category.detail#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="CATEGORY">
                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                </cf_box_footer>
            </cfform>
        </div>
    </cf_box>
</div>

<script type="text/javascript">
	function kontrol()
	{
		x = (50 - document.tax.detail.value.length);
		if ( x < 0)
		{ 
			alert ("<cf_get_lang dictionary_id='43826.Açıklama Bölümüne En Fazla 50 Karakter Girmelisiniz'>");
			return false;
		}
		if (document.getElementById('period_is_integrated').value == 1)
		{
			if (document.tax.Account_Code =='')
			{
				alert("<cf_get_lang dictionary_id='43177.Lütfen Satış Muhasebe Kodu Seçiniz'>!");
				return false;
			}
			if (document.tax.Account_Code_p =='')
			{
				alert("<cf_get_lang dictionary_id='43178.Lütfen Alış Muhasebe Kodu Seçiniz'>!");
				return false;
			}
		}
		<cfif session.ep.our_company_info.is_efatura>
		if(document.getElementById('tax_code').value == '')
		{
			alert("<cf_get_lang dictionary_id='60818.Vergi Kodu Seçiniz'>!");
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
			if(WrkAccountControl(document.getElementById(inputlist[i-1]).value,'Lütfen geçerli muhasebe kodları kullanınız.','<cfoutput>#dsn2#</cfoutput>') == 0)
				return false;
		}
		return true;
	}
	function pencere_ac(isim)
	{
		if(document.getElementById(isim).value.length != 0)
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=tax.'+isim+'&account_code=' + document.getElementById(isim).value);
		else
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=tax.'+isim);
    }
    function pencere_ac_item()
	{
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=all.expense_item_id&field_name=all.expense_item_name');
	}
</script>
