<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.creditcard_status" default="">
<cfif isdefined("attributes.is_submited")>
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
    
	<cfset arama_yapilmali = 0>
    <cfquery name="GET_CREDITCARD" datasource="#DSN3#">
        SELECT
            *
        FROM
            CREDIT_CARD
        WHERE 
        <cfif attributes.creditcard_status eq 1>
            IS_ACTIVE = 1
        <cfelseif attributes.creditcard_status eq 0>
            IS_ACTIVE = 0
        <cfelse>
            IS_ACTIVE IS NOT NULL
        </cfif>
        <cfif isdefined("attributes.account_id") and len(attributes.account_id)>
            AND ACCOUNT_ID = #account_id#
        </cfif>
        
        ORDER BY
            CREDITCARD_ID
    </cfquery>
<cfelse>
  	<cfset arama_yapilmali = 1>
  	<cfset GET_CREDITCARD.recordcount = 0>
</cfif>
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT 
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME
	FROM
		ACCOUNTS
	WHERE
		<cfif session.ep.period_year lt 2009>
			(ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
		</cfif>
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME
</cfquery>
<cfset adres = "">
<cfif isdefined("attributes.is_submited") and len ('is_submited')>
	<cfset adres = "#adres#&is_submited=#attributes.is_submited#">
</cfif>
<cfif isdefined("attributes.account_id") and len ('account_id')>
	<cfset adres = "#adres#&account_id=#attributes.account_id#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_creditcard.recordcount#'>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form"  method="post" action="#request.self#?fuseaction=finance.list_creditcard">
            <input type="hidden" name="is_submited" id="is_submited" value="1">
            <cf_box_search> 
                <div class="form-group">            
                    <select name="account_id" id="account_id">
                        <option value=""><cf_get_lang dictionary_id='57652.Hesap'></option>
                        <cfoutput query="get_accounts">
                            <option value="#account_id#"<cfif attributes.account_id eq ACCOUNT_ID>selected</cfif>>#account_name#</option>
                        </cfoutput>
                    </select>                      
                </div>
                <div class="form-group">            
                    <select name="creditcard_status" id="creditcard_status">
                        <option value="1" <cfif attributes.creditcard_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.creditcard_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                        <option value="2" <cfif attributes.creditcard_status is 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                    </select>                    
                </div>
                <div class="form-group small"> 
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" maxlength="3">                   
                </div>
                <div class="form-group">            
                    <cf_wrk_search_button button_type="4">                
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(389,'Kredi Kartları',54775)#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='54817.Kart No'></th>
                    <th><cf_get_lang dictionary_id='57652.Hesap'></th>
                    <th><cf_get_lang dictionary_id='54818.Kartı Kullanan'></th>
                    <th><cf_get_lang dictionary_id='54820.Limit'></th>
                    <th><cf_get_lang dictionary_id='54819.Kart Tipi'></th>
                    <th><cf_get_lang dictionary_id='54821.Ödeme Günü'></th>
                    <th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_creditcard&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil --><!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_creditcard.recordcount>
                    <cfset account_id_list = ''>
                    <cfset card_type_list = ''>
                    <cfset card_employee_id_list = ''>
                    <cfoutput query="get_creditcard" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(account_id) and not listfind(account_id_list,account_id)>
                            <cfset account_id_list  = listappend(account_id_list,account_id,',')>
                        </cfif>
                        <cfif len(card_type) and not listfind(card_type_list,card_type)>
                            <cfset card_type_list = listappend(card_type_list,card_type,',')>
                        </cfif>
                        <cfif len(card_employee_id) and not listfind(card_employee_id_list,card_employee_id)>
                            <cfset card_employee_id_list = listappend(card_employee_id_list,card_employee_id,',')>
                        </cfif>
                    </cfoutput>
                    <cfif len(account_id_list)>
                        <cfset account_id_list=listsort(account_id_list,"numeric","ASC",",")>
                        <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
                            SELECT
                                BANK_BRANCH.BANK_BRANCH_NAME,
                                ACCOUNTS.ACCOUNT_NAME,
                                <cfif session.ep.period_year lt 2009>
                                    CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
                                <cfelse>
                                    ACCOUNTS.ACCOUNT_CURRENCY_ID,
                                </cfif>
                                ACCOUNTS.ACCOUNT_ID
                            FROM
                                ACCOUNTS,
                                BANK_BRANCH
                            WHERE
                                ACCOUNTS.ACCOUNT_ID IN (#account_id_list#) AND
                                ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID AND
                                <cfif session.ep.period_year lt 2009>
                                    (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
                                <cfelse>
                                    ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
                                </cfif>
                            ORDER BY
                                ACCOUNT_ID
                        </cfquery>
                    </cfif> 
                    <cfif len(card_type_list)>
                        <cfset card_type_list=listsort(card_type_list,"numeric","ASC",",")>
                        <cfquery name="get_card" datasource="#dsn#">
                            SELECT CARDCAT,CARDCAT_ID FROM SETUP_CREDITCARD WHERE CARDCAT_ID IN (#card_type_list#) ORDER BY CARDCAT_ID
                        </cfquery>
                    </cfif>
                    <cfif len(card_employee_id_list)>
                        <cfset card_employee_id_list=listsort(card_employee_id_list,"numeric","ASC",",")>
                        <cfquery name="get_emp" datasource="#dsn#">
                            SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#card_employee_id_list#) ORDER BY EMPLOYEE_ID
                        </cfquery>
                    </cfif>
                    <cfoutput query="get_creditcard" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>
                                <cfset key_type = '#session.ep.company_id#'>
                                <!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
                                <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                                    <!--- anahtarlar decode ediliyor --->
                                    <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                                    <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                                    <!--- kart no encode ediliyor --->
                                    <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:get_creditcard.creditcard_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                                    <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
                                <cfelse>
                                    <cfset content = '#mid(Decrypt(get_creditcard.creditcard_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_creditcard.creditcard_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_creditcard.creditcard_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_creditcard.creditcard_number,key_type,"CFMX_COMPAT","Hex")))#'>
                                </cfif>
                                <a class="tableyazi" href="#request.self#?fuseaction=finance.list_creditcard&event=upd&creditcard_id=#creditcard_id#">
                                    #content#
                                </a>
                            </td>
                            <td><cfif len(account_id)>#get_accounts.bank_branch_name[listfind(account_id_list,account_id,',')]# / #get_accounts.account_name[listfind(account_id_list,account_id,',')]# #get_accounts.account_currency_id[listfind(account_id_list,account_id,',')]#</cfif></td>
                            <td>
                                <cfif len(card_employee_id)>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#card_employee_id#','medium');" class="tableyazi">#get_emp.EMPLOYEE_NAME[listfind(card_employee_id_list,card_employee_id,',')]#	#get_emp.EMPLOYEE_SURNAME[listfind(card_employee_id_list,card_employee_id,',')]#
                                </cfif>
                            </td>
                            <td style="text-align:right;">#TLFormat(card_limit)# #money_currency#</td>
                            <td><cfif len(card_type)>#get_card.cardcat[listfind(card_type_list,card_type,',')]#</cfif></td>
                            <td style="text-align:left;">#payment_day#</td>
                            <!-- sil --><td><a href="#request.self#?fuseaction=finance.list_creditcard&event=upd&creditcard_id=#creditcard_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="8">
                            <cfif arama_yapilmali neq 1>
                                <cf_get_lang dictionary_id='57484.Kayıt Yok'>
                            <cfelse>
                                <cf_get_lang dictionary_id='57701.Filtre Ediniz'>!
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>

        <cfset adres = "finance.list_creditcard">
        <cfif isdefined ("attributes.account_id") and len(attributes.account_id)>
            <cfset adres = "#adres#&attributes.account_id=#attributes.account_id#">
        </cfif>
        <cfif isdefined("attributes.is_submited") and len ('is_submited')>
            <cfset adres = "#adres#&is_submited=#attributes.is_submited#">
        </cfif>
        <cfif isdefined ("attributes.creditcard_status") and len(attributes.creditcard_status)>
            <cfset adres = "#adres#&attributes.creditcard_status=#attributes.creditcard_status#">
        </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#adres#"> 
    </cf_box>
</div>
