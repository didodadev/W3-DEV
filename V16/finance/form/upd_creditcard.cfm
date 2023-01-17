<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT 
		MONEY,
		RATE2,
		RATE1
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1
	ORDER BY
		MONEY_ID
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
	SELECT
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		ACCOUNTS.ACCOUNT_NAME,
		ACCOUNTS.ACCOUNT_ID
	FROM
		ACCOUNTS ,
		BANK_BRANCH
	WHERE
		ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID AND
		<cfif session.ep.period_year lt 2009>
			(ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
		</cfif>
	ORDER BY
		BANK_NAME,
		ACCOUNT_NAME
</cfquery>
<cfquery name="GETCARD" datasource="#DSN3#">
	SELECT * FROM CREDIT_CARD WHERE CREDITCARD_ID = #attributes.creditcard_id#
</cfquery>
<!--- 
	FA-09102013
	kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
	Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
--->
<cfscript>
	getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
	getCCNOKey.dsn = dsn;
	getCCNOKey1 = getCCNOKey.getCCNOKey1();
	getCCNOKey2 = getCCNOKey.getCCNOKey2();
</cfscript>

<cfsavecontent variable="img"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.popup_add_creditcard"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></cfsavecontent>
<cf_catalystHeader>
<cf_box>
	<cfform name="add_pos" id="add_pos" method="post" action="#request.self#?fuseaction=finance.emptypopup_upd_creditcard">
		<input type="hidden" name="creditcard_id" id="creditcard_id" value="<cfoutput>#attributes.creditcard_id#</cfoutput>">
        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.creditcard_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-creditcard_status">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <label><cf_get_lang_main no='81.Aktif'><input type="checkbox" name="creditcard_status" id="creditcard_status" <cfif getcard.is_active eq 1>checked</cfif>></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-cardno">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48854.Kart No'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfset key_type = '#session.ep.company_id#'>
                            <!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
                            <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                                <!--- anahtarlar decode ediliyor --->
                                <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                                <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                                <!--- kart no encode ediliyor --->
                                    <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:getcard.creditcard_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                                    <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'> 
                            <cfelse>
                                <cfset content = '#mid(Decrypt(getcard.creditcard_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(getcard.creditcard_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(getcard.creditcard_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(getcard.creditcard_number,key_type,"CFMX_COMPAT","Hex")))#'>
                            </cfif>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='54961.Geçerli Bir Kredi Kartı Numarası Giriniz'> !</cfsavecontent>
                            <cfinput type="text" name="cardno" id="cardno" validate="creditcard" value="#content#" required="yes" maxlength="16" message="#message#">                              
                        </div>
                    </div> 
                    <div class="form-group" id="item-account_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57652.Hesap'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="account_id" id="account_id" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> </option>
                                <cfoutput query="get_accounts">
                                    <option value="#account_id#-#account_currency_id#" <cfif getcard.account_id eq account_id>selected</cfif>>#account_name#&nbsp;#account_currency_id#</option>
                                </cfoutput>
                            </select>                               
                        </div>
                    </div>                        
                    <div class="form-group" id="item-unit_value">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54820.Limit'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="unit_value" class="moneybox" value="#TLFormat(getcard.card_limit)#" onkeyup="return(FormatCurrency(this,event));">
                                <span class="input-group-addon width">
                                <select name="money_type" id="money_type" >
                                    <cfoutput query="get_money">
                                        <option value="#money#" <cfif money eq getcard.money_currency>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>                                    	 
                                </span>
                            </div>
                        </div>
                    </div>                        
                    <div class="form-group" id="item-employee_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54818.Kartı Kullanan'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group"> 
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#getcard.card_employee_id#</cfoutput>">
                                <input type="text" name="employee_name" id="employee_name" readonly value="<cfoutput>#get_emp_info(getcard.card_employee_id,0,0)#</cfoutput>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_pos.employee_id&field_name=add_pos.employee_name&select_list=1','list','popup_list_positions');"></span>
                            </div>
                        </div>
                    </div>                        
                    <div class="form-group" id="item-account_code_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group"> 
                                <cfquery name="GET_ACCOUNT" datasource="#DSN2#">
                                    SELECT ACCOUNT_CODE, ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#getcard.account_code#'
                                </cfquery>
                                <input type="hidden" name="account_code" id="account_code" value="<cfoutput>#getcard.account_code#</cfoutput>">
                                <input type="text" name="account_code_name" id="account_code_name" value="<cfoutput>#get_account.account_code# #get_account.account_name#</cfoutput>" readonly>     
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_pos.account_code_name&field_id=add_pos.account_code','list')"></span>
                            </div>
                        </div>
                    </div>                        
                    <div class="form-group" id="item-card_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30363.Kart Tipi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_wrk_combo
                                name="card_type"
                                query_name="GET_CREDITCARD"
                                option_name="cardcat"
                                option_value="cardcat_id"
                                value="#getcard.card_type#"
                                width="170">
                        </div>
                    </div>                        
                    <div class="form-group" id="item-close_acc_day">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30721.Hesap Kesim Günü'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="close_acc_day" value="#getcard.close_acc_day#" required="yes" maxlength="30" onkeyup="return(FormatCurrency(this,event,0));" range="1,31" class="moneybox">
                        </div>
                    </div>
                    <div class="form-group" id="item-paymentday">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54821.Ödeme Günü'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="paymentday" value="#getcard.payment_day#" required="yes" maxlength="30" onkeyup="return(FormatCurrency(this,event,0));" range="1,31" class="moneybox">								
                        </div>
                    </div>
                </div> 
               
            </cf_box_elements> 
            <cf_box_footer>
                <div class="col col-6 col-xs-12">
                    <cf_record_info 
                        query_name = "getcard"
                        record_emp = "record_emp"
                        update_emp = "update_emp" 
                        record_date = "record_date"
                        update_date ="update_date">
                </div> 
                <div class="col col-6 col-xs-12">
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                </div> 
            </cf_box_footer>   
	</cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(!$("#cardno").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='54961.Geçerli Bir Kredi Kartı Numarası Giriniz'>!</cfoutput>"})    
			return false;
		}
		if(!$("#paymentday").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='30721.Hesap Kesim Günü'> <cf_get_lang dictionary_id='54962.1 ile 31 Gün Arasında Olmalıdır'> !</cfoutput>"})    
			return false;
		}
		if(!$("#close_acc_day").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='54821.Ödeme Günü'> <cf_get_lang dictionary_id='54962.1 ile 31 Gün Arasında Olmalıdır'>!</cfoutput>"})    
			return false;
		}
		if(list_getat(add_pos.account_id.value,2,'-') != add_pos.money_type.value)
		{
			alert("<cf_get_lang dictionary_id='54522.Banka Hesabının İşlem Dövizi ve Limit İşlem Dövizi Aynı Olmalıdır'>");
			return false;
		}
		if(add_pos.account_code.value == "")
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='58811.Muhasebe Kodu'>");
			return false;
		}
		return unformat_fields();
	}
	function unformat_fields()
	{
		add_pos.unit_value.value = filterNum(add_pos.unit_value.value);
	}
</script>
