<cf_xml_page_edit fuseact="objects.popup_form_add_bank_account" is_multi_page="1">
<cfquery name="GET_BANK_NAMES" datasource="#DSN#">
SELECT BANK_ID, BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfinclude template="../query/get_money_2.cfm"> 
<cfparam name="attributes.modal_id" default="">
<cfform name="add_account" action="#request.self#?fuseaction=objects.emptypopup_add_bank_account" method="post">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29449.Banka Hesabı'></cfsavecontent>
    <cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_box_elements>
            <cfif isdefined("url.cpid") and len(url.cpid)>
                <input type="hidden" name="cpid" id="cpid" value="<cfoutput>#url.cpid#</cfoutput>">
            <cfelseif isdefined("url.cid") and len(url.cid)>
                <input type="hidden" name="cid" id="cid" value="<cfoutput>#url.cid#</cfoutput>">
            <cfelseif isdefined("url.employee_id") and len(url.employee_id)>
                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#url.employee_id#</cfoutput>">
                <input type="hidden" name="is_account_control" value="<cfoutput>#xml_account_control#</cfoutput>">
            <cfelseif isdefined("session.ww.userid")>
                <input type="hidden" name="cid" id="cid" value="<cfoutput>#session.ww.userid#</cfoutput>">			
            </cfif>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="row">
                <div class="form-group" id="item-company_status">
                    <label class="col col-4 col-sm-12"></label>
                        <div class="col col-8 col-sm-12">
                        <label><cf_get_lang dictionary_id ='29436.Standart Hesap'><input type="checkbox" name="default_account" id="default_account" value="1" checked></label>
                    </div>
                </div>
            </div>
            <cfif isdefined("url.employee_id") and len(url.employee_id)>            
                <cfif xml_account_holder_change eq 1>
                    <cfset cmp = createObject("component","V16.hr.cfc.get_emp_detail")>
                    <cfset cmp.dsn = dsn/>
                    <cfset get_emp_ = cmp.get_employee_detail(employee_id:url.employee_id)>                        
                    <cfset get_identy = cmp.get_emp_identy(employee_id:url.employee_id)>      

                    <div class="col col-12 col-md-12 col-sm-12" type="column" index="2" sort="true">
                        <div class="form-group">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57631.Ad'></label>
                            <div class="col col-8 col-sm-12">
                                <cfinput type="text" name="name" maxlength="50" value="#get_emp_.employee_name#">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58726.Soyad'></label>
                            <div class="col col-8 col-sm-12">
                                <cfinput type="text" name="surname" maxlength="50" value="#get_emp_.employee_surname#">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58025.Kimlik No'></label>
                            <div class="col col-8 col-sm-12">
                                <cfinput type="text" name="tc_identy_no" maxlength="50" value="#get_identy.tc_identy_no#">
                            </div>
                        </div>
                    </div>                  
                </cfif>
            </cfif>
            <div class="col col-12 col-md-12 col-sm-12" type="column" index="3" sort="true">
                <cfif xml_use_stage eq 1>
                <div class="form-group" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                    <div class="col col-8 col-sm-12">
                        <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0' tabindex="10">
                    </div>
                </div>
            </cfif>
                <div class="form-group">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57521.Banka'><cfif xml_bank_required>*</cfif></label>
                    <div class="col col-8 col-sm-12">
                        <select name="account_bank_id" id="account_bank_id" onChange="set_bank_branch(this.value);">
                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                            <cfoutput query="get_bank_names">
                                <option value="#bank_id#;#bank_code#;#bank_name#">#bank_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" <cfif isdefined("is_change_code") and is_change_code eq 0>style="display:none;"</cfif>>
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57521.Banka'></label>
                    <div class="col col-8 col-sm-12">
                        <cfif isdefined("is_change_code") and is_change_code eq 0>
                            <cfinput type="text" name="bank_name" style="width:220px;" readonly>
                        <cfelse>
                            <cfinput type="text" name="bank_name" maxlength="150" style="width:220px;">
                        </cfif>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'><cfif xml_branch_required>*</cfif></label>
                    <div class="col col-8 col-sm-12">
                        <select name="account_branch_id" id="account_branch_id" onChange="set_branch_code(this.value);">
                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" <cfif isdefined("is_change_code") and is_change_code eq 0>style="display:none;"</cfif>>
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                    <div class="col col-8 col-sm-12">
                        <cfif isdefined("is_change_code") and is_change_code eq 0>
                            <cfinput type="text" name="branch_name" id="branch_name" readonly>
                        <cfelse>
                            <cfinput type="text" name="branch_name" id="branch_name">
                        </cfif>
                    </div>
                </div>
                <cfif not isdefined("url.employee_id")>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='59006.Banka Kodu'></label>
                            <div class="col col-8 col-sm-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='59006.Banka Kodu'>!</cfsavecontent>
                                    <cfif isdefined("is_change_code") and is_change_code eq 0>
                                        <cfinput type="text" name="bank_code" id="bank_code" message="#message#" onKeyUp="isNumber(this);" readonly>
                                    <cfelse>
                                        <cfinput type="text" name="bank_code" id="bank_code" message="#message#" onKeyUp="isNumber(this);">
                                    </cfif>
                            </div>
                    </div>
                </cfif>
                <div class="form-group">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='59005.Şube Kodu'><cfif xml_branch_required>*</cfif></label>
                    <div class="col col-8 col-sm-12">
                        <cfif isdefined("is_change_code") and is_change_code eq 0>
                            <cfinput type="text" name="branch_code" id="branch_code" onKeyUp="isNumber(this);" readonly>
                        <cfelse>
                            <cfinput type="text" name="branch_code" id="branch_code" onKeyUp="isNumber(this);">
                        </cfif>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='29530.Swift Kodu'></label>
                    <div class="col col-8 col-sm-12">
                        <cfif isdefined("is_change_code") and is_change_code eq 0>
                            <cfinput type="text" name="swift_code" id="swift_code" maxlength="50" readonly>
                        <cfelse>
                            <cfinput type="text" name="swift_code" id="swift_code" maxlength="50">
                        </cfif>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58178.Hesap No'></label>
                    <div class="col col-8 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='50237.Banka Hesap No Girmelisiniz'></cfsavecontent>
                    <!---<cf_input_pcKlavye name="account_no" type="text" numpad="true" accessible="true" maxlength="34" inputStyle="width:220px;" message="#message#" required="no">--->
                        <input name="account_no" type="text" autocomplete="off" maxlength="34" message="#message#" required="no">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='59007.IBAN Kodu'><cfif xml_iban_required> *</cfif></label>
                    <div class="col col-8 col-sm-12">
                    <cfoutput><input type="text" id="iban_code" autocomplete="off"  name="iban_code"maxlength="#xml_iban_maxlength#"></cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                    <div class="col col-8 col-sm-12">
                        <select name="money" id="money">
                            <cfoutput query="get_money">
                                <option value="#money#">#money#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </div>
            <cfif isdefined("url.employee_id") and len(url.employee_id)>
                <cfif xml_view_join_account eq 1>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='60287.Ortak Hesap ise'></label>
                        <div class="col col-8 col-sm-12">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57631.Ad'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="join_account_name" maxlength="50" value="">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58726.Soyad'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="join_account_surname" maxlength="50" value="">
                        </div>
                    </div>
                </cfif>
            </cfif>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </cf_box_footer>
    </cf_box>
    </cfform>   
    <script type="text/javascript">
    function set_bank_branch(xyz)
    {
        document.add_account.branch_code.value = "";
        document.add_account.swift_code.value = "";
        if(xyz.split(';')[2]!= undefined)
            document.add_account.bank_name.value = xyz.split(';')[2];
        else
        {
            document.add_account.bank_name.value = "";
            document.add_account.branch_name.value = "";
        }
        <cfif not isdefined("url.employee_id")>
            if(xyz.split(';')[1]!= undefined)
                document.add_account.bank_code.value = xyz.split(';')[1];
            else
                document.add_account.bank_code.value = "";
        </cfif>
        var bank_id_ = xyz.split(';')[0];
        <cfif fusebox.use_period eq true>
            dsn_branch = 'dsn3';
        <cfelse>
            dsn_branch = 'dsn';
        </cfif>
        if(bank_id_.length)
            var bank_branch_names = wrk_safe_query('mr_bank_branch_name',"dsn3",0,bank_id_);
        var option_count = document.getElementById('account_branch_id').options.length; 
        for(x=option_count;x>=0;x--)
            document.getElementById('account_branch_id').options[x] = null;
        
        if(bank_branch_names != undefined && bank_branch_names.recordcount != 0)
        {	
            document.getElementById('account_branch_id').options[0] = new Option('<cf_get_lang dictionary_id ="57734.Seçiniz">','');
            for(var xx=0;xx<bank_branch_names.recordcount;xx++)
                document.getElementById('account_branch_id').options[xx+1]=new Option(bank_branch_names.BANK_BRANCH_NAME[xx],bank_branch_names.BANK_BRANCH_ID[xx]+';'+bank_branch_names.BRANCH_CODE[xx]+';'+bank_branch_names.BANK_BRANCH_NAME[xx]+';'+bank_branch_names.SWIFT_CODE[xx]);
        }
        else
            document.getElementById('account_branch_id').options[0] = new Option('<cf_get_lang dictionary_id ="57734.Seçiniz">','');
    }
    function set_branch_code(abc)
    {
        if(abc.split(';')[1]!= undefined)
            document.add_account.branch_code.value = abc.split(';')[1];
        else
            document.add_account.branch_code.value = "";
        
        if(abc.split(';')[2]!= undefined)
            document.add_account.branch_name.value = abc.split(';')[2];
        else
            document.add_account.branch_name.value = "";
        
        if(abc.split(';')[3]!= undefined)
            document.add_account.swift_code.value = abc.split(';')[3];
        else
            document.add_account.swift_code.value = "";
    }
    function kontrol()
    {       
    <cfif xml_iban_required>
    if(document.upd_account.iban_code.value == '')
            {
            alert('<cf_get_lang dictionary_id="29397.IBAN Code Değerini Giriniz"> !');
            return false;
            }
    </cfif>
    if(iban_code.value!=""){
    var iban_langth=<cfoutput><cfif xml_iban_maxlength neq "">#xml_iban_maxlength#<cfelse>26</cfif></cfoutput>;
        var iban=iban_code.value;
    if (iban.length < 5 || iban.length >34) 
    { 
        alert ('<cf_get_lang dictionary_id="63198.IBAN Numarası 5 Karakterden Küçük, 34 Karakterden Büyük Olamaz.">'); 
        return false; 
    } 

    if(iban.substr(0,2) == 'TR' && iban.length != iban_langth)
    { 
        alert ('<cf_get_lang dictionary_id="63196.TR ile Başlayan IBAN Numarası"> '+iban_langth+' <cf_get_lang dictionary_id="63197.Karakter Olmalıdır.">'); 
        return false; 
    } 	

    var karakter1 = iban.charCodeAt(0);
    var karakter2 = iban.charCodeAt(1);
    var karakter3 = iban.charCodeAt(2);
    var karakter4 = iban.charCodeAt(3);

    if (!(65 <= karakter1 && karakter1 <= 90) || !(65 <= karakter2 && karakter2 <= 90)) 
    {
        alert('<cf_get_lang dictionary_id="63195.IBAN Numarasında 1. ve 2. Karakterler Büyük Harf Olmalıdır !">');
        return false; 
    } 

    if (!(48 <= karakter3 && karakter3 <= 57) || !(48 <= karakter4 && karakter4 <= 57)) 
    {
        alert('<cf_get_lang dictionary_id="63194.IBAN Numarasında 3. ve 4. Karakterler Rakam Olmalıdır !">'); 
        return false; 
    }

    new_iban = iban.substring(4) + iban.substring(0, 4); 
    for (i = 0, r = 0; i < new_iban.length; i++ ) 
    { 
        karakter = new_iban.charCodeAt(i); 
        if (48 <= karakter && karakter <= 57) 
            k = karakter - 48; 
        else if (65 <= karakter && karakter <= 90) 
            k = karakter - 55; 
        else
        { 
            alert('<cf_get_lang dictionary_id="63192.IBAN Numarası Sadece Rakam ve Büyük Harf Olmalıdır!">'); 
            return false; 
        } 
        
        if (k > 9) 
            r = (100 * r + k) % 97; 
        else 
            r = (10 * r + k) % 97; 
    } 

    if (r != 1) 
    { 
        alert('<cf_get_lang dictionary_id="63191.IBAN Numarası Geçersizdir.">'); 
        return false; 
    }
    }
        <cfif xml_bank_required>
            if(document.add_account.account_bank_id.value == '' && document.add_account.bank_name.value =='')
            {
                alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan">:<cf_get_lang dictionary_id="57521.Banka">');
                return false;
            }
        </cfif>
        <cfif xml_branch_required>
            if(document.add_account.account_branch_id.value == '' && document.add_account.branch_name.value == '')
            {
                alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan">:<cf_get_lang dictionary_id="57453.Sube">');
                return false;
            }
            if(document.add_account.branch_code.value == '')
            {
                alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan">:<cf_get_lang dictionary_id="59005.Sube Kodu">');
                return false;
            }
        </cfif>
        if(document.add_account.iban_code.value == '' && document.add_account.account_no.value =='')
        {
            alert("<cf_get_lang dictionary_id='33364.Iban Kodu ya da Hesap No Bilgilerinden En Az Bir Tanesini Giriniz '> !");
            return false;
        }
        loadPopupBox('add_account',<cfoutput>#attributes.modal_id#</cfoutput>);
        return false;
    }
</script>
