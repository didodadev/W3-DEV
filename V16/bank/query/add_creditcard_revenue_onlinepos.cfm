<!--- Kredi kartı tahsilat kayıt sayfasıdır, sanal pos tan yapılan kayıtlar için...Aysenur 20060401--->
<cf_get_lang_set module_name="bank">
<cf_papers paper_type="creditcard_revenue">
<cfscript>
	if(len(attributes.card_no))
	{
		/* FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
			Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir */
		getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
		getCCNOKey.dsn = dsn;
		getCCNOKey1 = getCCNOKey.getCCNOKey1();
		getCCNOKey2 = getCCNOKey.getCCNOKey2();
		
		if (len(attributes.action_from_company_id))//kredi kart bilgileri
			key_type = attributes.action_from_company_id;
		else if (len(attributes.cons_id))
			key_type = attributes.cons_id;
		
		if (getCCNOKey1.recordcount and getCCNOKey2.recordcount)
		{
			// anahtarlar decode ediliyor 
			ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey);
			ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey);
			// kart no encode ediliyor
			content = contentEncryptingandDecodingAES(isEncode:1,content:attributes.card_no,accountKey:key_type,key1:ccno_key1,key2:ccno_key2);
		}
		else
			content = Encrypt(attributes.card_no,key_type,"CFMX_COMPAT","Hex");
	}
</cfscript>

<cfif not isdefined("is_transaction")>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfinclude template="add_creditcard_revenue_onlinepos_ic.cfm">
		</cftransaction>
	</cflock>
<cfelse>
	<cfinclude template="add_creditcard_revenue_onlinepos_ic.cfm">
</cfif>
<cfif isdefined("attributes.paper_number") and len(attributes.paper_number) and len(paper_number)>
    <cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN3#">
        UPDATE 
            GENERAL_PAPERS
        SET
            CREDITCARD_REVENUE_NUMBER = #paper_number#
        WHERE
            CREDITCARD_REVENUE_NUMBER IS NOT NULL
    </cfquery>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
