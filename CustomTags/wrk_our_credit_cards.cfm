<!--- Şirket Kredi Kartı bilgilerini ve banka hesabı bağlantılarını almak için
	<cf_wrk_our_credit_cards slct_width="" credit_card="#query.credit_card#">
		created AE20090622		
	onclick_function: 	Selectbox click icin
	slct_width : selectbox genişliği (optional)
	credit_card : update sayfaları için
 --->
<cfparam name="attributes.slct_width" default='150'>
<cfparam name="attributes.credit_card_info" default="">
<cfparam name="attributes.onclick_function" default="">
<cfparam name="attributes.disabled_info" default="">
<cfparam name="attributes.isRequired" default="">
<cfparam name="attributes.required_message" default="#caller.getLang('main',201)#">
<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
	DT - 12052016 isRequired  ve required_message eklendi .  
	attributes.isRequired='required'  verildiğinde kredi kartı selecti altında "Lütfen Kredi Kartı Seçiniz"  uyarısı  verir .
--->
<!--- 
	FA-09102013
	kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
	Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
--->
<cfscript>
	getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
	getCCNOKey.dsn = caller.dsn;
	getCCNOKey1 = getCCNOKey.getCCNOKey1();
	getCCNOKey2 = getCCNOKey.getCCNOKey2();
</cfscript>

<cfquery name="GET_ACCOUNTS" datasource="#caller.dsn3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
	<cfif session.ep.period_year lt 2009>
		CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
	<cfelse>
		ACCOUNTS.ACCOUNT_CURRENCY_ID,
	</cfif>
		CREDIT_CARD.CREDITCARD_ID,
		CREDIT_CARD.CREDITCARD_NUMBER
	FROM
		ACCOUNTS,
		CREDIT_CARD
	WHERE
		ACCOUNTS.ACCOUNT_ID = CREDIT_CARD.ACCOUNT_ID AND
		CREDIT_CARD.IS_ACTIVE = 1
	<cfif listgetat(caller.fuseaction,1,'.') is 'store'>
		AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
	</cfif>
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME,
		CREDIT_CARD.CREDITCARD_ID
</cfquery>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
<cfset key_type = '#session.ep.company_id#'>
<select name="credit_card_info" <cfoutput>#attributes.isRequired#</cfoutput> data-msg="<cfoutput>#attributes.required_message#</cfoutput>" <cfif attributes.disabled_info eq 1>disabled</cfif> id="credit_card_info" style="width:<cfoutput>#attributes.slct_width#</cfoutput>px;"<cfif len(attributes.onclick_function)>onChange="<cfoutput>#attributes.onclick_function#</cfoutput>;"</cfif>>
	<option value="" selected><cfoutput>#caller.getLang('main',787)#</cfoutput></option>
	<cfoutput query="get_accounts">
		<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
		<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
			<!--- anahtarlar decode ediliyor --->
			<cfset ccno_key1 = caller.contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
			<cfset ccno_key2 = caller.contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
			<!--- kart no encode ediliyor --->
			<cfset content = caller.contentEncryptingandDecodingAES(isEncode:0,content:creditcard_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
			<cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
		<cfelse>
			<cfset content = '#mid(Decrypt(creditcard_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(creditcard_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(creditcard_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(creditcard_number,key_type,"CFMX_COMPAT","Hex")))#'>
		</cfif>
		<option value="#account_id#;#account_currency_id#;#creditcard_id#" <cfif attributes.credit_card_info eq creditcard_id>selected</cfif> title="#account_name#/#content#">#account_name#/#content# - #account_currency_id#</option>
	</cfoutput>
</select>
 