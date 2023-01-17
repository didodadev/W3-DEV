<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
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
			<cfset content = contentEncryptingandDecodingAES(isEncode:1,content:attributes.card_no,accountKey:attributes.member_id,key1:ccno_key1,key2:ccno_key2) />
		<cfelse>
			<cfset content = Encrypt(attributes.card_no,attributes.member_id,"CFMX_COMPAT","Hex")>
		</cfif>
        
		<cfif isDefined("attributes.member_type") and attributes.member_type is 'partner'>
			<cfif isdefined('attributes.is_add') and attributes.is_add eq 1>
				<cfquery name="ADD_CREDIT_CARD" datasource="#dsn#">
					INSERT INTO 
						COMPANY_CC 
						(
							COMPANY_ID,
							COMPANY_CC_TYPE,
							COMPANY_CC_NUMBER,
							COMPANY_BANK_TYPE,
							COMPANY_CARD_OWNER,
							COMPANY_EX_MONTH,
							COMPANY_EX_YEAR,
							COMP_CVS,
							IS_DEFAULT,
							ACC_OFF_DAY,
							RECORD_DATE,
							RECORD_IP
						)
					VALUES
						(   
							#attributes.member_id#,
							#attributes.card_type#,
							'#content#',
							<cfif isDefined("attributes.bank_type") and len(attributes.bank_type)>#attributes.bank_type#,<cfelse>NULL,</cfif>
							<cfif isDefined("attributes.card_owner") and len(attributes.card_owner)>'#attributes.card_owner#',<cfelse>NULL,</cfif>
							#attributes.month#,
							#attributes.year#,
							<cfif isDefined("attributes.cvs") and len(attributes.cvs)>'#attributes.cvs#',<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.default_card")>1,<cfelse>0,</cfif>
							<cfif isDefined("attributes.acc_off_date") and len(attributes.acc_off_date)>'#attributes.acc_off_date#',<cfelse>NULL,</cfif>
							#now()#,
							'#cgi.remote_addr#'
						)
				</cfquery>
			<cfelseif isdefined('attributes.is_upd') and attributes.is_upd eq 1>
				<cfquery name="UPD_CREDIT_CARD" datasource="#dsn#">
					UPDATE
						COMPANY_CC
					SET
						COMPANY_ID = #attributes.member_id#,
						COMPANY_CC_TYPE = #attributes.card_type#,
						COMPANY_CC_NUMBER = '#content#',
						COMPANY_BANK_TYPE = <cfif isDefined("attributes.bank_type") and len(attributes.bank_type)>#attributes.bank_type#,<cfelse>NULL,</cfif>
						COMPANY_CARD_OWNER = <cfif isDefined("attributes.card_owner") and len(attributes.card_owner)>'#attributes.card_owner#',<cfelse>NULL,</cfif>
						COMPANY_EX_MONTH = #attributes.month#,
						COMPANY_EX_YEAR = #attributes.year#,
						IS_DEFAULT = <cfif isDefined("attributes.default_card")>1,<cfelse>0,</cfif>
						ACC_OFF_DAY = <cfif isDefined("attributes.acc_off_date") and len(attributes.acc_off_date)>'#attributes.acc_off_date#',<cfelse>NULL,</cfif>
						COMP_CVS = 	<cfif isDefined("attributes.cvs") and len(attributes.cvs)>'#attributes.cvs#'<cfelse>NULL</cfif>
					WHERE
						COMPANY_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ccid#">
				</cfquery>
			<cfelse>
				<cfquery name="DEL_CC" datasource="#dsn#">
					DELETE FROM
						COMPANY_CC 
					WHERE 
						COMPANY_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ccid#">
				</cfquery>
			</cfif>
		<cfelse>
			<cfif isdefined('attributes.is_add') and attributes.is_add eq 1>
				<cfquery name="ADD_CREDIT_CARD" datasource="#dsn#">
					INSERT INTO
						CONSUMER_CC
						(
							CONSUMER_ID,
							CONSUMER_CC_TYPE,
							CONSUMER_CC_NUMBER,
							CONSUMER_BANK_TYPE,
							CONSUMER_CARD_OWNER,
							CONSUMER_EX_MONTH,
							CONSUMER_EX_YEAR,
							CONS_CVS,
							IS_DEFAULT,
							ACC_OFF_DAY,
							RECORD_CONS,
							RECORD_DATE,
							RECORD_IP
						)
					VALUES 
						(
							#attributes.member_id#,
							#attributes.card_type#,
							'#content#',
							<cfif isDefined("attributes.bank_type") and len(attributes.bank_type)>#attributes.bank_type#,<cfelse>NULL,</cfif>
							<cfif isDefined("attributes.card_owner") and len(attributes.card_owner)>'#attributes.card_owner#',<cfelse>NULL,</cfif>
							#attributes.month#,
							#attributes.year#,
							<cfif isDefined("attributes.cvs") and len(attributes.cvs)>'#attributes.cvs#',<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.default_card")>1,<cfelse>0,</cfif>
							<cfif isDefined("attributes.acc_off_date") and len(attributes.acc_off_date)>'#attributes.acc_off_date#',<cfelse>NULL,</cfif>
							#session.ww.userid#,
							#now()#,
							'#cgi.remote_addr#'
						)
				</cfquery>
			<cfelseif isdefined('attributes.is_upd') and attributes.is_upd eq 1>
				<cfquery name="UPD_CREDIT_CARD" datasource="#dsn#">
					UPDATE
						CONSUMER_CC
					SET
						CONSUMER_ID = #attributes.member_id#,
						CONSUMER_CC_TYPE = #attributes.card_type#,
						CONSUMER_CC_NUMBER = '#content#',
						CONSUMER_BANK_TYPE = <cfif isDefined("attributes.bank_type") and len(attributes.bank_type)>#attributes.bank_type#,<cfelse>NULL,</cfif>
						CONSUMER_CARD_OWNER = <cfif isDefined("attributes.card_owner") and len(attributes.card_owner)>'#attributes.card_owner#',<cfelse>NULL,</cfif>
						CONSUMER_EX_MONTH = #attributes.MONTH#,
						CONSUMER_EX_YEAR = #attributes.YEAR#,
						IS_DEFAULT = <cfif isDefined("attributes.default_card")>1,<cfelse>0,</cfif>
						ACC_OFF_DAY = <cfif isDefined("attributes.acc_off_date") and len(attributes.acc_off_date)>'#attributes.acc_off_date#',<cfelse>NULL,</cfif>
						CONS_CVS = 	<cfif isDefined("attributes.cvs") and len(attributes.cvs)>'#attributes.cvs#'<cfelse>NULL</cfif>,
						UPDATE_CONS = #session.ww.userid#,
						UPDATE_EMP = NULL
					WHERE
						CONSUMER_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ccid#">
				</cfquery>
			<cfelse>
				<cfquery name="DEL_CC" datasource="#dsn#">
					DELETE FROM
						CONSUMER_CC 
					WHERE 
						CONSUMER_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ccid#">
				</cfquery>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=objects2.list_member_credit_card" addtoken="no">
