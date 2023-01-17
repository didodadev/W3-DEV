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

<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
	<!--- anahtarlar decode ediliyor --->
	<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
	<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
	<!--- kart no encode ediliyor --->
	<cfset content = contentEncryptingandDecodingAES(isEncode:1,content:attributes.cardno,accountKey:session.ep.company_id,key1:ccno_key1,key2:ccno_key2) />
<cfelse>
	<cfset content = Encrypt(attributes.cardno,session.ep.company_id,"CFMX_COMPAT","Hex")>
</cfif>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_CREDITCARD" datasource="#dsn3#">
			UPDATE
				CREDIT_CARD
			SET
				CREDITCARD_NUMBER = '#content#', 
				ACCOUNT_ID = <cfif len(attributes.account_id)>#listfirst(attributes.account_id,'-')#,<cfelse>NULL,</cfif>
				CARD_LIMIT = <cfif len(attributes.unit_value)>#attributes.unit_value#,<cfelse>0,</cfif>
				MONEY_CURRENCY = '#attributes.money_type#',
				CARD_EMPLOYEE_ID = <cfif len(attributes.employee_id) and len(attributes.employee_name)>#attributes.employee_id#,<cfelse>NULL,</cfif>
				CARD_TYPE = <cfif len(attributes.card_type)>#attributes.card_type#,<cfelse>NULL,</cfif>
				ACCOUNT_CODE = '#attributes.account_code#',
				PAYMENT_DAY = <cfif len(attributes.paymentday)>#attributes.paymentday#,<cfelse>0,</cfif>
				CLOSE_ACC_DAY = <cfif len(attributes.close_acc_day)>#attributes.close_acc_day#,<cfelse>0,</cfif>
				IS_ACTIVE = <cfif isdefined("attributes.creditcard_status")>1,<cfelse>0,</cfif>
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#'
			WHERE
				CREDITCARD_ID = #attributes.CREDITCARD_ID#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=finance.list_creditcard&event=upd&creditcard_id=#attributes.CREDITCARD_ID#</cfoutput>';
</script>
