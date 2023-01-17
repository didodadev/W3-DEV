<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
	<!--- 
		FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
		Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
	--->
	<cfscript>
		getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
		getCCNOKey.dsn = dsn;
		getCCNOKey1 = getCCNOKey.getCCNOKey1();
		getCCNOKey2 = getCCNOKey.getCCNOKey2();
	</cfscript>
	
	<cfset cc_number_list = ''>
	<cfif isDefined("attributes.comp_id")>
		<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
		<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
            <!--- anahtarlar decode ediliyor --->
            <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
            <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
            <!--- kart no encode ediliyor --->
            <cfset content = contentEncryptingandDecodingAES(isEncode:1,content:attributes.card_no,accountKey:attributes.comp_id,key1:ccno_key1,key2:ccno_key2) />
        <cfelse>
			<cfset content = Encrypt(attributes.card_no,attributes.comp_id,"CFMX_COMPAT","Hex")>
        </cfif>
		<cfif attributes.xml_same_credit_card_control eq 0>
			<cfquery name="get_comp_cc_numbers" datasource="#dsn#">
				SELECT COMPANY_CC_NUMBER FROM COMPANY_CC WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#"> AND COMPANY_CC_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ccid#">
			</cfquery>
			<cfloop query="get_comp_cc_numbers">
				<cfif not listfind(cc_number_list,get_comp_cc_numbers.company_cc_number)>
					<cfset cc_number_list = listappend(cc_number_list,get_comp_cc_numbers.company_cc_number,',')>
				</cfif>
			</cfloop>
		</cfif>
		<cfif not listfind(cc_number_list,content) or attributes.xml_same_credit_card_control eq 1>
			<!--- GEÇMİŞİ YEDEKLİYOR--->
            <cf_wrk_get_history  datasource='#DSN#' source_table='COMPANY_CC' target_table='COMPANY_CC_HISTORY' record_id='#attributes.ccid#' record_name='COMPANY_CC_ID'>
			<cfquery name="UPD_CREDIT_CARD" datasource="#dsn#">
				UPDATE
					COMPANY_CC
				SET
					COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">,
					COMPANY_CC_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_type#">,
					RESP_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.resp_code#">,
					COMPANY_CC_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#content#">,
					COMPANY_BANK_TYPE = <cfif isDefined("attributes.bank_type") and len(attributes.bank_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type#">,<cfelse>NULL,</cfif>
					COMPANY_CARD_OWNER = <cfif isDefined("attributes.card_owner") and len(attributes.card_owner)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_owner#">,<cfelse>NULL,</cfif>
					COMPANY_EX_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month#">,
					COMPANY_EX_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year#">,
					IS_DEFAULT = <cfif isDefined("attributes.default_card")>1,<cfelse>0,</cfif>
					ACC_OFF_DAY = <cfif isDefined("attributes.acc_off_date") and len(attributes.acc_off_date)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_off_date#">,<cfelse>NULL,</cfif>
					SPECIAL_DEFINITION_ID = <cfif isDefined("attributes.special_def_id") and len(attributes.special_def_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_def_id#">,<cfelse>NULL,</cfif>
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					COMP_CVS = 	<cfif isDefined("attributes.cvs") and len(attributes.cvs)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cvs#"><cfelse>NULL</cfif>
				WHERE
					COMPANY_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ccid#">
			</cfquery>
			<cfif isdefined("attributes.default_card")  and xml_deactivate_other_credit_cards eq 1>
				<cfquery name="UPDATE_DEFAULT_INFO" datasource="#dsn#">
				UPDATE
					COMPANY_CC
				SET
					IS_DEFAULT = 0
				WHERE
					COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#"> AND
					COMPANY_CC_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ccid#">
				</cfquery>
			</cfif>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang no='607.Üyeye Aynı Kredi Kartını Birden Fazla Ekleyemezsiniz'>!");
				history.back();
			</script>
		</cfif>
	<cfelse>
		<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
		<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
            <!--- anahtarlar decode ediliyor --->
            <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
            <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
            <!--- kart no encode ediliyor --->
            <cfset content = contentEncryptingandDecodingAES(isEncode:1,content:attributes.card_no,accountKey:attributes.cons_id,key1:ccno_key1,key2:ccno_key2) />
        <cfelse>		
			<cfset content = Encrypt(attributes.card_no,attributes.cons_id,"CFMX_COMPAT","Hex")>
        </cfif>
		<cfif attributes.xml_same_credit_card_control eq 0>
			<cfquery name="get_cons_cc_numbers" datasource="#dsn#">
				SELECT CONSUMER_CC_NUMBER FROM CONSUMER_CC WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#"> AND CONSUMER_CC_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ccid#">
			</cfquery>
			<cfloop query="get_cons_cc_numbers">
				<cfif not listfind(cc_number_list,get_cons_cc_numbers.consumer_cc_number)>
					<cfset cc_number_list = listappend(cc_number_list,get_cons_cc_numbers.consumer_cc_number,',')>
				</cfif>
			</cfloop>
		</cfif>
		<cfif not listfind(cc_number_list,content) or attributes.xml_same_credit_card_control eq 1>
			<!--- GEÇMİŞİ YEDEKLİYOR--->
            <cf_wrk_get_history  datasource='#DSN#' source_table='CONSUMER_CC' target_table='CONSUMER_CC_HISTORY' record_id='#attributes.ccid#' record_name='CONSUMER_CC_ID'>
			<cfquery name="UPD_CREDIT_CARD" datasource="#dsn#">
				UPDATE
					CONSUMER_CC
				SET
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#">,
					CONSUMER_CC_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_type#">,
					RESP_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.resp_code#">,
					CONSUMER_CC_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#content#">,
					CONSUMER_BANK_TYPE = <cfif isDefined("attributes.bank_type") and len(attributes.bank_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type#">,<cfelse>NULL,</cfif>
					CONSUMER_CARD_OWNER = <cfif isDefined("attributes.card_owner") and len(attributes.card_owner)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_owner#">,<cfelse>NULL,</cfif>
					CONSUMER_EX_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.MONTH#">,
					CONSUMER_EX_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.YEAR#">,
					IS_DEFAULT = <cfif isDefined("attributes.default_card")>1,<cfelse>0,</cfif>
					ACC_OFF_DAY = <cfif isDefined("attributes.acc_off_date") and len(attributes.acc_off_date)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_off_date#">,<cfelse>NULL,</cfif>
					SPECIAL_DEFINITION_ID = <cfif isDefined("attributes.special_def_id") and len(attributes.special_def_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_def_id#">,<cfelse>NULL,</cfif>
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					UPDATE_CONS = NULL,
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					CONS_CVS = 	<cfif isDefined("attributes.cvs") and len(attributes.cvs)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cvs#"><cfelse>NULL</cfif>
				WHERE
					CONSUMER_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ccid#">				   
			</cfquery>
			<cfif isdefined("attributes.default_card") and xml_deactivate_other_credit_cards eq 1>
				<cfquery name="UPDATE_DEFAULT_INFO" datasource="#dsn#">
				UPDATE
					CONSUMER_CC
				SET
					IS_DEFAULT = 0
				WHERE
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#"> AND
					CONSUMER_CC_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ccid#">
				</cfquery>
			</cfif>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang no='607.Üyeye Aynı Kredi Kartını Birden Fazla Ekleyemezsiniz'>!");
				history.back();
			</script>
		</cfif>
	</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif not (isDefined('attributes.draggable') and len(attributes.draggable))>
		wrk_opener_reload();
		window.close();
	<cfelse>
		 closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
	</cfif>
</script>

