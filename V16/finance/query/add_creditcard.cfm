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
		<cfquery name="ADD_CREDIT_CARD" datasource="#DSN3#">
			INSERT INTO
				CREDIT_CARD
				(
					CREDITCARD_NUMBER,
					ACCOUNT_ID,
					CARD_LIMIT,
					MONEY_CURRENCY,
					CARD_EMPLOYEE_ID,
					CARD_TYPE,
					ACCOUNT_CODE,
					PAYMENT_DAY,
					CLOSE_ACC_DAY,
					IS_ACTIVE,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					'#content#',
					<cfif len(attributes.account_id)>#listfirst(attributes.account_id,'-')#<cfelse>NULL</cfif>,
					<cfif len(attributes.unit_value)>#attributes.unit_value#<cfelse>0</cfif>,
					'#attributes.money_type#',
					<cfif len(attributes.employee_id) and len(attributes.employee_name)>#attributes.employee_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.card_type)>#attributes.card_type#<cfelse>NULL</cfif>,
					'#attributes.account_code#',
					<cfif len(attributes.paymentday)>#attributes.paymentday#<cfelse>0</cfif>,
					<cfif len(attributes.close_acc_day)>#attributes.close_acc_day#<cfelse>0</cfif>,
					<cfif isdefined("attributes.creditcard_status")>1<cfelse>0</cfif>,
					#session.ep.userid#,
					#now()#,
					'#cgi.remote_addr#'
				)
		</cfquery>
	</cftransaction>
</cflock>
<cfquery name="GET_MAXID" datasource="#DSN3#">
	SELECT MAX(CREDITCARD_ID) AS MAX_ID FROM CREDIT_CARD
</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=finance.list_creditcard&event=upd&creditcard_id=#GET_MAXID.MAX_ID#</cfoutput>';
</script>
