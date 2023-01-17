<cf_xml_page_edit fuseact="objects.popup_form_upd_bank_account" is_multi_page="1">
<cfquery name="GET_BANK_NAMES" datasource="#DSN#">
	SELECT BANK_ID, BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfinclude template="../query/get_money_2.cfm">
<cfinclude template="../query/get_bank_account.cfm">
<cfparam name="attributes.modal_id" default="">
<cfform name="upd_account" action="#request.self#?fuseaction=objects.emptypopup_upd_bank_account" method="post">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29449.Banka Hesabı'></cfsavecontent>
    <cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_box_elements>
            <cfoutput>
            <input type="hidden" name="bid" id="bid" value="#url.bid#">
            <cfif isdefined("attributes.cid")>
                <input type="hidden" name="cid" id="cid" value="#url.cid#">
            <cfelseif isdefined("attributes.cpid")>
                <input type="hidden" name="cpid" id="cpid" value="#url.cpid#">
            <cfelseif isdefined("attributes.employee_id")>
                <input type="hidden" name="employee_id" id="employee_id" value="#url.employee_id#">
                <input type="hidden" name="is_account_control" value="<cfoutput>#xml_account_control#</cfoutput>">
            <cfelseif isdefined("session.ww.userid")>
                <input type="hidden" name="cid" id="cid" value="#session.ww.userid#">
            </cfif>
            </cfoutput>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="row">
                    <div class="form-group" id="item-company_status">
                        <label class="col col-4 col-sm-12"></label>
                            <div class="col col-8 col-sm-12">
                        <input type="checkbox" name="default_account" id="default_account" value="" <cfif get_bank_account.account_default eq 1> checked</cfif>> <cf_get_lang dictionary_id ='29436.Standart Hesap'>
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
                                <cfinput type="text" name="name" maxlength="50" value="#get_bank_account.name#">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58726.Soyad'></label>
                            <div class="col col-8 col-sm-12">
                                <cfinput type="text" name="surname" maxlength="50" value="#get_bank_account.surname#">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58025.Kimlik No'></label>
                            <div class="col col-8 col-sm-12">
                                <cfinput type="text" name="tc_identy_no" maxlength="50" value="#get_bank_account.tc_identy_no#">
                            </div>
                        </div>
                    </div>                  
                </cfif>
            </cfif>
        <div class="col col-12 col-md-12 col-sm-12" type="column" index="3" sort="true">
            <cfif xml_use_stage eq 1>
            <!--- Bireysel Uye Sayfası --->	
            <cfif isdefined("attributes.cid")>
                <cfquery name="GET_BANK_PROCESS" datasource="#DSN#">
                select * from CONSUMER_BANK where CONSUMER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">AND CONSUMER_BANK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bid#">
                </cfquery>
            <!--- Kurumsal Uye Sayfası --->	
            <cfelseif isdefined("attributes.cpid")>
                <cfquery name="GET_BANK_PROCESS" datasource="#DSN#">
                    select * from COMPANY_BANK where COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">AND COMPANY_BANK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bid#">
                </cfquery>
            <cfelseif isdefined("attributes.employee_id")>
                <cfquery name="GET_BANK_PROCESS" datasource="#DSN#">
                    select * from EMPLOYEES_BANK_ACCOUNTS where EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">AND EMP_BANK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bid#">
                </cfquery>
            </cfif>
            <div class="form-group" id="item-process_stage">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                <div class="col col-8 col-sm-12">
                    <cf_workcube_process is_upd='0' select_value='#GET_BANK_PROCESS.bank_stage#' process_cat_width='140' is_detail='1'>
                </div>
            </div>
        </cfif>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57521.Banka'><cfif xml_bank_required>*</cfif></label>
                <div class="col col-8 col-sm-12">
                    <select name="account_bank_id" id="account_bank_id" onChange="set_bank_branch(this.value);">
                        <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                        <cfoutput query="get_bank_names">
                            <option value="#bank_id#;#bank_code#;#bank_name#"<cfif bank_name eq get_bank_account.bank> selected</cfif>>#bank_name#</option> 
                        </cfoutput>
                    </select>
                </div>                      
            </div>
            <div class="form-group" <cfif isdefined("is_change_code") and is_change_code eq 0>style="display:none;"</cfif>>
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57521.Banka'></label>
                <div class="col col-8 col-sm-12">
                    <cfif isdefined("is_change_code") and is_change_code eq 0>
                        <cfinput type="text" name="bank_name" id="bank_name"value="#get_bank_account.bank#" readonly>
                    <cfelse>
                        <cfinput type="text" name="bank_name" id="bank_name" maxlength="150" value="#get_bank_account.bank#">
                    </cfif>
                </div>
            </div>
            <cfif fusebox.use_period eq 1> <!--- banka şubeleri şirket db sinde tutuluyor ve use_period false olan kurulumlarda şirket db si yok--->
            <div class="form-group">
                <cfif isdefined("get_bank_account") and get_bank_account.recordcount>
                    <cfquery name="GET_BANK_BRANCH" datasource="#DSN#">
                        SELECT 
                            BB.BANK_BRANCH_ID, 
                            BB.BANK_BRANCH_NAME, 
                            BB.BRANCH_CODE,
                            BB.SWIFT_CODE
                        FROM 
                            #dsn3_alias#.BANK_BRANCH BB,
                            SETUP_BANK_TYPES SB
                        WHERE 
                            BB.BANK_ID = SB.BANK_ID AND
                            SB.BANK_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_bank_account.bank#">
                        ORDER BY
                            BB.BANK_BRANCH_NAME    
                    </cfquery>
                </cfif>
               <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'><cfif xml_branch_required>*</cfif></label>
                <div class="col col-8 col-sm-12"><select name="account_branch_id" id="account_branch_id" onChange="set_branch_code(this.value);">
                        <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                        <cfif isdefined("get_bank_branch")>
                        <cfoutput query="get_bank_branch">
                            <option value="#bank_branch_id#;#branch_code#;#bank_branch_name#;#swift_code#" <cfif bank_branch_name eq get_bank_account.bank_branch> selected</cfif>>#bank_branch_name#</option>
                        </cfoutput>
                        </cfif>
                    </select>
                </div>
            </div>
            </cfif>
            <div class="form-group" <cfif isdefined("is_change_code") and is_change_code eq 0>style="display:none;"</cfif>>
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                <div class="col col-8 col-sm-12"><cfif isdefined("is_change_code") and is_change_code eq 0>
                        <cfinput type="text" name="branch_name" id="branch_name" value="#get_bank_account.bank_branch#" readonly>
                    <cfelse>
                        <cfinput type="text" name="branch_name" id="branch_name" value="#get_bank_account.bank_branch#">
                    </cfif>
                </div>
            </div>
            <cfif not isdefined("attributes.employee_id")>
            <div class="form-group"> 
                   <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='59006.Banka Kodu'></label>
                    <div class="col col-8 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='59006.Banka Kodu'>!</cfsavecontent>
                        <cfif isdefined("is_change_code") and is_change_code eq 0>
                            <cfinput type="text" name="bank_code" id="" message="#message#" value="#get_bank_account.bank_code#" onKeyUp="isNumber(this);" readonly>
                        <cfelse>
                            <cfinput type="text" name="bank_code" id="bank_code" message="#message#" value="#get_bank_account.bank_code#" onKeyUp="isNumber(this);">
                        </cfif>
                    </div>
            </div>
            </cfif>
            <div class="form-group"> 
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='59005.Şube Kodu'><cfif xml_branch_required>*</cfif></label>
                <div class="col col-8 col-sm-12">
                    <cfif isdefined("is_change_code") and is_change_code eq 0>
                        <cfinput type="text" name="branch_code" id="branch_code" value="#get_bank_account.bank_branch_code#" onKeyUp="isNumber(this);" readonly>
                    <cfelse>
                        <cfinput type="text" name="branch_code" id="branch_code" value="#get_bank_account.bank_branch_code#" onKeyUp="isNumber(this);">
                    </cfif>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='29530.Swift Kodu'></label>
                <div class="col col-8 col-sm-12"><cfif isdefined("is_change_code") and is_change_code eq 0>
                        <cfinput type="text" name="swift_code" id="swift_code" value="#get_bank_account.bank_swift_code#" maxlength="50" readonly>
                    <cfelse>
                        <cfinput type="text" name="swift_code" id="swift_code" value="#get_bank_account.bank_swift_code#" maxlength="50">
                    </cfif>
                </div>
            </div>

            <div class="form-group"> 
               <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58178.Hesap No'></label>
                <div class="col col-8 col-sm-12"><cfif not isdefined("url.employee_id")>
                            <cfset coory_ = 185>
                        <cfelse>
                            <cfset coory_ = 165>
                        </cfif>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='50237.Banka Hesap No'>!</cfsavecontent>
                    <!---<cf_input_pcKlavye name="account_no" type="text" value="#get_bank_account.account_no#" numpad="true" accessible="true" maxlength="20" inputStyle="width:220px;" message="#message#" required="no">--->
                    <input name="account_no" type="text" value="<cfoutput>#get_bank_account.account_no#</cfoutput>" required="no" maxlength="20"  message="<cfoutput>#message#</cfoutput>">
              </div>
            </div>

            <div class="form-group"> 
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='59007.IBAN Kodu'> <cfif xml_iban_required> *</cfif></label>
                    <cfoutput>  <div class="col col-8 col-sm-12"><input type="text" id='iban_code' autocomplete="off" name='iban_code' value="#get_bank_account.iban_code#" maxlength="#xml_iban_maxlength#>"></div></cfoutput>
            </div>
            <div class="form-group"> 
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                <div class="col col-8 col-sm-12">
                    <select name="money" id="money">
                        <cfoutput query="get_money"> 
                            <option value="#money#" <cfif get_bank_account.money is money>selected</cfif>>#money#</option>
                        </cfoutput> 
                    </select>
                </div>
            </div>
            <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
                <cfif xml_view_join_account eq 1>
                    <div class="form-group">
                       <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='60287.Ortak Hesap ise'></label>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57631.Ad'></label>
                        <div class="col col-8 col-sm-12"><cfinput type="text" name="join_account_name" maxlength="50" value="#get_bank_account.join_account_name#"></div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58726.Soyad'></label>
                        <div class="col col-8 col-sm-12"><cfinput type="text" name="join_account_surname" maxlength="50" value="#get_bank_account.join_account_surname#"></div>
                    </div>
                </cfif>
            </cfif>
        </div>
        </cf_box_elements>
        <cf_box_footer>
            <cfif isdefined("session.ww") or isdefined("attributes.cid")>
                <cf_record_info query_name="GET_BANK_ACCOUNT" is_consumer="1">
            <cfelse>
                <cf_record_info query_name="GET_BANK_ACCOUNT" is_consumer="0">					
            </cfif>
                <cf_workcube_buttons is_upd='1' del_function='deleteControl()' add_function='kontrol()'>
        </cf_box_footer>
    </cf_box>
</cfform>
<script type="text/javascript">
	function deleteControl(){
        <cfif isdefined("attributes.cid")>
		document.upd_account.action = '<cfoutput>#request.self#?fuseaction=objects.del_bank_account</cfoutput>';
    <cfelseif isdefined("attributes.cpid")>
        document.upd_account.action = '<cfoutput>#request.self#?fuseaction=objects.del_bank_account</cfoutput>';
    <cfelseif isdefined("attributes.employee_id")>
        document.upd_account.action = '<cfoutput>#request.self#?fuseaction=objects.del_bank_account</cfoutput>';
    <cfelseif isdefined("session.ww.userid")>
        document.upd_account.action = '<cfoutput>#request.self#?fuseaction=objects.del_bank_account</cfoutput>';
    </cfif>
		loadPopupBox('upd_account',<cfoutput>#attributes.modal_id#</cfoutput>);
		return false;
    }
	function set_bank_branch(xyz)
	{
		document.upd_account.branch_code.value = "";
		document.upd_account.branch_name.value = "";
		if(xyz.split(';')[2]!= undefined)
			document.upd_account.bank_name.value = xyz.split(';')[2];
		else
		{
			document.upd_account.bank_name.value = "";
			document.upd_account.branch_name.value = "";
		}
		<cfif not isdefined("attributes.employee_id")>
			if(xyz.split(';')[1]!= undefined)
				document.upd_account.bank_code.value = xyz.split(';')[1];
			else
				document.upd_account.bank_code.value = "";
		</cfif>		
		var bank_id_ = xyz.split(';')[0];
		var bank_branch_names = wrk_safe_query("mr_bank_branch_name","dsn3",0,bank_id_);
		
		var option_count = document.getElementById('account_branch_id').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('account_branch_id').options[x] = null;
		
		if(bank_branch_names.recordcount != 0)
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
			document.upd_account.branch_code.value = abc.split(';')[1];
		else
			document.upd_account.branch_code.value = "";
		
		if(abc.split(';')[2]!= undefined)
			document.upd_account.branch_name.value = abc.split(';')[2];
		else
			document.upd_account.branch_name.value = "";
		
		if(abc.split(';')[3]!= undefined)
			document.upd_account.swift_code.value = abc.split(';')[3];
		else
			document.upd_account.swift_code.value = "";
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
		<cfif is_change_code eq 0 and isdefined("url.employee_id") and len(url.employee_id)>
            alert('<cf_get_lang dictionary_id="61174.Yetkiniz yok. Sistem Yöneticisine başvurunuz">');
            return false;
        </cfif>
		<cfif xml_bank_required>
			if(document.upd_account.account_bank_id.value == '' && document.upd_account.bank_name.value =='')
			{
			   alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan">:<cf_get_lang dictionary_id="57521.Banka">');
			   return false;
			}
		</cfif>
		<cfif xml_branch_required>
			if(document.upd_account.account_branch_id.value == '' && document.upd_account.branch_name.value == '')
			{
			   alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan">:<cf_get_lang dictionary_id="57453.Sube">');
			   return false;
			}
			if(document.upd_account.branch_code.value == '')
			{
			   alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan">:<cf_get_lang dictionary_id="59005.Sube Kodu">');
			   return false;
			}
		</cfif>
		if(document.upd_account.iban_code.value == '' && document.upd_account.account_no.value =='')
		{
			alert("<cf_get_lang dictionary_id='33364.Iban Kodu ya da Hesap No Bilgilerinden En Az Bir Tanesini Giriniz '> !");
			return false;
		}
        loadPopupBox('upd_account',<cfoutput>#attributes.modal_id#</cfoutput>);
		return false;
	}
</script>
