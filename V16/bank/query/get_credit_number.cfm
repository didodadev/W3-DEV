<cfsetting showdebugoutput="no">
<cfquery name="get_credit_card" datasource="#dsn#">
	SELECT
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			CC.COMPANY_CC_ID MEMBER_CC_ID,
			CC.COMPANY_ID MEMBER_ID,
			CC.COMPANY_CC_TYPE MEMBER_CC_TYPE,
			CC.COMPANY_CC_NUMBER MEMBER_CC_NUMBER,
			CC.COMPANY_EX_MONTH MEMBER_EX_MONTH,
			CC.COMPANY_EX_YEAR MEMBER_EX_YEAR
		<cfelse>
			CC.CONSUMER_CC_ID MEMBER_CC_ID,
			CC.CONSUMER_ID MEMBER_ID,
			CC.CONSUMER_CC_TYPE MEMBER_CC_TYPE,
			CC.CONSUMER_CC_NUMBER MEMBER_CC_NUMBER,
			CC.CONSUMER_EX_MONTH MEMBER_EX_MONTH,
			CC.CONSUMER_EX_YEAR MEMBER_EX_YEAR
		</cfif>
		,IS_DEFAULT
		,SC.CARDCAT
	FROM
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			COMPANY_CC CC
		<cfelse>
			CONSUMER_CC CC
		</cfif>,
		SETUP_CREDITCARD SC
	WHERE
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		<cfelse>
			CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<cfif attributes.x_select_active_cards eq 0>
			AND IS_DEFAULT = 1
		</cfif>
		AND CC.COMPANY_CC_TYPE = SC.CARDCAT_ID
	ORDER BY
		IS_DEFAULT DESC
</cfquery>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset key_type = attributes.company_id>
<cfelse>
	<cfset key_type = attributes.consumer_id>
</cfif>
<cfscript>
	getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
	getCCNOKey.dsn = dsn;
	getCCNOKey1 = getCCNOKey.getCCNOKey1();
	getCCNOKey2 = getCCNOKey.getCCNOKey2();
</cfscript>
<select name="member_card_id" id="member_card_id" style="width:240px;">
	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
	<cfoutput query="get_credit_card">
		<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
			<!--- anahtarlar decode ediliyor --->
			<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
			<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
			<!--- kart no decode ediliyor --->
			<cfset content = contentEncryptingandDecodingAES(isEncode:0,content:member_cc_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
			<cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
		<cfelse>
			<cfset content = '#mid(Decrypt(member_cc_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(member_cc_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(member_cc_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(member_cc_number,key_type,"CFMX_COMPAT","Hex")))#'>
		</cfif>
		<option value="#MEMBER_CC_ID#" <cfif is_default eq 0>style="color:##FF0000"</cfif>>#cardcat#/#content#/#MEMBER_EX_MONTH#-#MEMBER_EX_YEAR#</option>
	</cfoutput>
</select>
