<cfif not IsDefined("attributes.event")>
	<cfset attributes.event = "list">
</cfif>
<cfset content = "">
<cfset unitValue = "">
<cfset employeeId = "">
<cfset employeeName = "">
<cfset accountCode = "">
<cfset accountCodeName = "">
<cfset cardType = "">
<cfset closeAccDay = "">
<cfset paymentDay = "">
<cfif attributes.event is "list">
    <cfparam name="attributes.account_id" default="">
    <cfparam name="attributes.creditcard_status" default="">
    <cfif isdefined("attributes.is_submited")>
        <cfset arama_yapilmali = 0>
    </cfif>
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
	<cfquery name="get_creditcard" datasource="#DSN3#">
        SELECT
        	 * ,
             BANK_BRANCH.BANK_BRANCH_NAME,
            ACCOUNTS.ACCOUNT_NAME,
            <cfif session.ep.period_year lt 2009>
                CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID,
            </cfif>
            ACCOUNTS.ACCOUNT_ID,
            SETUP_CREDITCARD.CARDCAT,
            SETUP_CREDITCARD.CARDCAT_ID,
            EMPLOYEES.EMPLOYEE_NAME,
            EMPLOYEES.EMPLOYEE_SURNAME
        FROM 
        	CREDIT_CARD 
        	LEFT JOIN ACCOUNTS ON ACCOUNTS.ACCOUNT_ID = CREDIT_CARD.ACCOUNT_ID
            LEFT JOIN BANK_BRANCH ON ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID 
            LEFT JOIN #dsn_alias#.SETUP_CREDITCARD ON SETUP_CREDITCARD.CARDCAT_ID = CREDIT_CARD.CARD_TYPE
            LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID =CREDIT_CARD.CARD_EMPLOYEE_ID
        WHERE 
			<cfif isdefined("attributes.is_submited") and attributes.creditcard_status eq 1>
                IS_ACTIVE = 1
            <cfelseif isdefined("attributes.is_submited") and attributes.creditcard_status eq 0>
                IS_ACTIVE = 0
            <cfelse>
                IS_ACTIVE IS NOT NULL
            </cfif>
            <cfif isdefined("attributes.account_id") and len(attributes.account_id)>
                AND CREDIT_CARD.ACCOUNT_ID = #account_id#
            </cfif>
            <cfif session.ep.period_year lt 2009>
               AND (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
            <cfelse>
               AND ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
            </cfif>
            
            ORDER BY
                CREDITCARD_ID
       
    </cfquery>
    <cfparam name="attributes.totalrecords" default='#get_creditcard.recordcount#'>
</cfif> 
    
<cfif attributes.event is 'upd'>
	 <cfquery name="GETCARD" datasource="#DSN3#">
		SELECT * FROM CREDIT_CARD WHERE CREDITCARD_ID = #attributes.creditcard_id#
	</cfquery>
	<cfquery name="GET_ACCOUNT" datasource="#DSN2#">
		SELECT ACCOUNT_CODE, ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#getcard.account_code#'
	</cfquery>
</cfif>
<cfif attributes.event is 'upd' or attributes.event is 'add'>
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
</cfif>
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT 
    	<cfif attributes.event is 'upd' or attributes.event is 'add'>
        	<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID,
            </cfif>
        </cfif>
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME
	FROM
		ACCOUNTS
        <cfif attributes.event is 'upd' or attributes.event is 'add'>
        	,BANK_BRANCH
        </cfif>
	WHERE
     <cfif attributes.event is 'upd' or attributes.event is 'add'>
        	ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID AND
        </cfif>
		<cfif session.ep.period_year lt 2009>
			 (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
		</cfif>
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME
         <cfif attributes.event is 'upd' or attributes.event is 'add'>
        	,BANK_NAME
        </cfif>
</cfquery>
<cfif attributes.event is 'upd' or attributes.event is 'list'>
	<cfscript>
        getCCNOKey = createObject("component", "settings.cfc.setupCcnoKey");
        getCCNOKey.dsn = dsn;
        getCCNOKey1 = getCCNOKey.getCCNOKey1();
        getCCNOKey2 = getCCNOKey.getCCNOKey2();
    </cfscript>
    <cfif attributes.event is 'upd'>
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
        <cfset unitValue = TLFormat(getcard.card_limit)>
        <cfset employeeId = getcard.card_employee_id>
        <cfset employeeName = get_emp_info(getcard.card_employee_id,0,0)>
        <cfset accountCode = getcard.account_code>
        <cfset accountCodeName = get_account.account_code & ' - ' & get_account.account_name>
        <cfset cardType = getcard.card_type>
        <cfset closeAccDay = getcard.close_acc_day>
        <cfset paymentDay = getcard.payment_day>
    </cfif>
</cfif>
<cfif not attributes.event is "list">
	<script type="text/javascript">
        function kontrol()
        {  
            if(list_getat(creditCard.account_id.value,2,'-') != creditCard.money_type.value)
            {
                alert("<cf_get_lang dictionary_id='54522.Banka Hesabının İşlem Dövizi ve Limit İşlem Dövizi Aynı Olmalıdır'>");
                return false;
            }
            if(creditCard.account_code.value == "")
            {
                alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1399.Muhasebe Kodu'>");
                return false;
            }
            return true;
        }
        function unformat_fields()
        {
            creditCard.unit_value.value = filterNum(creditCard.unit_value.value);
        }
    </script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'finance/form/list_credit_card.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'finance/form/form_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'finance/query/upd_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_creditcard&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'creditcard_id=##attributes.creditcard_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.creditcard_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/form_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_creditcard&event=upd';
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_creditcard&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'creditCard';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CREDIT_CARD';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-cardno','item-account_code']";
</cfscript>
