<cfinclude template="../../objects/query/tax_type_code.cfm">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58021.ÖTV'></cfsavecontent>
        <cf_box title="#title#" add_href="#request.self#?fuseaction=settings.list_otv" is_blank="0">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
                <cfinclude template="../display/list_otv.cfm">
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <cfform name="tax">
                <input type="hidden" value="<cfoutput>#session.ep.period_is_integrated#</cfoutput>" name="period_is_integrated" id="period_is_integrated">
                <input type="Hidden" id="counter" name="counter">
                    <cf_box_elements>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-sales-account-code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42531.Satış Muhasebe Kodu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='42203.Satış Muhasebe Kodu Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" required="yes" message="#message#" name="Account_Code" onFocus="AutoComplete_Create('Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code');"></a>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-account-code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42532.Alış Muhasebe Kodu'><cfif session.ep.period_is_integrated eq 1><font color=black>*</font></cfif></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='42253.Alış Muhasebe Kodu Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" required="yes" message="#message#" name="Account_Code_p" onFocus="AutoComplete_Create('Account_Code_p','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=tax.Account_Code_p','list');"></a>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-sales-account-code-iade">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42995.Satış İade  Muhasebe Kodu'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang no='1204.Satış İade Muhasebe Kodu girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" required="yes" message="#message#" name="Account_Code_iade" onFocus="AutoComplete_Create('Account_Code_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code_iade');"></a>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-account-code-iade">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42996.Alış İade Muhasebe Kodu'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='43186.Alış İade Muhasebe Kodu Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" required="yes" message="#message#" name="Account_Code_p_iade" onFocus="AutoComplete_Create('Account_Code_p_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://"  onclick="pencere_ac('Account_Code_p_iade');"></a>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-sales-account-code-discount">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62914.Satış İndirim Muhasebe Kodu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfinput type="text" name="account_code_discount" onFocus="AutoComplete_Create('account_code_discount','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('account_code_discount');"></a>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-account-code-discount">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62915.Alış İndirim Muhasebe Kodu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfinput type="text" name="account_code_p_discount" onFocus="AutoComplete_Create('account_code_p_discount','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://"  onclick="pencere_ac('account_code_p_discount');"></a>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <select name="tax_type" id="tax_type" onchange="show()">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="1"><cf_get_lang dictionary_id='62479.Sabit Tutar'></option>
                                    <option value="2"><cf_get_lang dictionary_id='62480.Oransal'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-tax_" style="display:none;">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58021.ÖtV'><cf_get_lang dictionary_id='58671.Oranı'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58021.ÖtV'><cf_get_lang dictionary_id='58671.Oranı'></cfsavecontent>
                                <cfinput type="text" name="tax_" id="tax_" value="" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));">
                            </div>
                        </div>
                        <div class="form-group" id="item-tax_2" style="display:none;">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58021.ÖtV'><cf_get_lang dictionary_id='58671.Oranı'>% *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58021.ÖtV'><cf_get_lang dictionary_id='58671.Oranı'></cfsavecontent>
                                <cfinput type="text" name="tax_" id="tax_2" value="" onkeyup="return(FormatCurrency(this,event,4));"> 
                                <span class="input-group-addon"> % </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-tax-code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53332.Vergi'><cf_get_lang dictionary_id='49089.Kodu'><cfif session.ep.our_company_info.is_efatura>*</cfif></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <select name="tax_code" id="tax_code">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="TAX_CODES">
                                        <option value="#TAX_CODE_ID#,#TAX_CODE_NAME#" title="#detail#">#TAX_CODE_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <textarea name="detail" id="detail" rows="2" cols="21"></textarea>
                            </div>
                        </div>
                    </cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cf_box_footer>
                            <cf_workcube_buttons is_upd='0' add_function="kontrol()"><!--- OnFormSubmit()&& --->
                        </cf_box_footer>
                    </div>
                </cfform>
            </div>
          </cf_box>
    </div>


<script type="text/javascript">
    function show()
            {
            var option = document.getElementById("tax_type").value;
                if(option == "1")
                {
                document.getElementById("item-tax_").style.display="block";
                document.getElementById("item-tax_2").style.display="none";
                return true;
                }
                    
                if(option == "2")
                {
                document.getElementById("item-tax_2").style.display="block";
                document.getElementById("item-tax_").style.display="none";
                return true;
                }
                else
                {
                document.getElementById("item-tax_2").style.display="none";
                document.getElementById("item-tax_").style.display="none";
                return true;
                }
            }
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
        if(document.getElementById('tax_type').value == 1 && document.getElementById('tax_').value == 0)
            {
                alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='58021.ÖtV'><cf_get_lang dictionary_id='58671.Oranı'>!")
                return false;
            }
             
            if(document.getElementById('tax_type').value == 2 && document.getElementById('tax_2').value == 0)
            {
                alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='58021.ÖtV'><cf_get_lang dictionary_id='58671.Oranı'>!")
                return false;
            }
        <cfif session.ep.our_company_info.is_efatura>
        if(document.getElementById('tax_code').value == '')
        {
            alert("Vergi Kodu Seçiniz !");
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
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=tax.'+isim+'&account_code=' + document.getElementById(isim).value, 'list');
        else
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=tax.'+isim, 'list');
    }

    
</script>