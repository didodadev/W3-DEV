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
					SELECT COMPANY_CC_NUMBER FROM COMPANY_CC WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
				</cfquery>
				<cfloop query="get_comp_cc_numbers">
					<cfif not listfind(cc_number_list,get_comp_cc_numbers.company_cc_number)>
						<cfset cc_number_list = listappend(cc_number_list,get_comp_cc_numbers.company_cc_number,',')>
					</cfif>
				</cfloop>
			</cfif>
			<cfif not listfind(cc_number_list,content) or attributes.xml_same_credit_card_control eq 1>
				<cfquery name="ADD_CREDIT_CARD" datasource="#dsn#" result="MAX_ID">
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
                            SPECIAL_DEFINITION_ID,
							ACC_OFF_DAY,
							RESP_CODE,
							RECORD_DATE,
							RECORD_IP,
							RECORD_EMP
						)
						VALUES 
						(   
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_type#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#content#">,
							<cfif isDefined("attributes.bank_type") and len(attributes.bank_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type#">,<cfelse>NULL,</cfif>
							<cfif isDefined("attributes.card_owner") and len(attributes.card_owner)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_owner#">,<cfelse>NULL,</cfif>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year#">,
							<cfif isDefined("attributes.cvs") and len(attributes.cvs)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cvs#">,<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.default_card")>1,<cfelse>0,</cfif>
							<cfif isDefined("attributes.special_def_id") and len(attributes.special_def_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_def_id#">,<cfelse>NULL,</cfif>
							<cfif isDefined("attributes.acc_off_date") and len(attributes.acc_off_date)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_off_date#">,<cfelse>NULL,</cfif>
							<cfif isDefined("attributes.resp_code") and len(attributes.resp_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.resp_code#">,<cfelse>NULL,</cfif>
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
						)
				</cfquery>
				<cfif isdefined("attributes.default_card") and xml_deactivate_other_credit_cards eq 1><!--- o şirket için tek bir kredi kartı aktif olsn diye,diğerleri sıfırlanıyor --->
					<cfquery name="UPDATE_DEFAULT_INFO" datasource="#dsn#">
						UPDATE
							COMPANY_CC
						SET
							IS_DEFAULT = 0
						WHERE
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#"> AND
							COMPANY_CC_ID <> #MAX_ID.IDENTITYCOL#
					</cfquery>
				</cfif>
			<cfelse>
				<script type="text/javascript">
					alert('Üyeye Aynı Kredi Kartını Birden Fazla Ekleyemezsiniz!');
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
					SELECT CONSUMER_CC_NUMBER FROM CONSUMER_CC WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#">
				</cfquery>
				<cfloop query="get_cons_cc_numbers">
					<cfif not listfind(cc_number_list,get_cons_cc_numbers.consumer_cc_number)>
						<cfset cc_number_list = listappend(cc_number_list,get_cons_cc_numbers.consumer_cc_number,',')>
					</cfif>
				</cfloop>
			</cfif>
			<cfif not listfind(cc_number_list,content) or attributes.xml_same_credit_card_control eq 1>
				<cfquery name="ADD_CREDIT_CARD" datasource="#dsn#" result="MAX_ID">
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
                            SPECIAL_DEFINITION_ID,
							RESP_CODE,
                            RECORD_DATE,
                            RECORD_IP,
                            RECORD_EMP
                        )
                    VALUES 
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_type#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#content#">,
                            <cfif isDefined("attributes.bank_type") and len(attributes.bank_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type#">,<cfelse>NULL,</cfif>
                            <cfif isDefined("attributes.card_owner") and len(attributes.card_owner)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_owner#">,<cfelse>NULL,</cfif>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year#">,
                            <cfif isDefined("attributes.cvs") and len(attributes.cvs)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cvs#">,<cfelse>NULL,</cfif>
                            <cfif isdefined("attributes.default_card")>1,<cfelse>0,</cfif>
                            <cfif isDefined("attributes.acc_off_date") and len(attributes.acc_off_date)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_off_date#">,<cfelse>NULL,</cfif>
							<cfif isDefined("attributes.special_def_id") and len(attributes.special_def_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_def_id#">,<cfelse>NULL,</cfif>
							<cfif isDefined("attributes.resp_code") and len(attributes.resp_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.resp_code#">,<cfelse>NULL,</cfif>
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                        )
				</cfquery>
				<cfif isdefined("attributes.default_card") and xml_deactivate_other_credit_cards eq 1>
					<cfquery name="UPDATE_DEFAULT_INFO" datasource="#dsn#">
						UPDATE
							CONSUMER_CC
						SET
							IS_DEFAULT = 0
						WHERE
							CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#"> AND
							CONSUMER_CC_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
					</cfquery>
				</cfif>
			<cfelse>
				<script type="text/javascript">
					alert('Üyeye Aynı Kredi Kartını Birden Fazla Ekleyemezsiniz!');
					history.back();
				</script>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif session.ep.our_company_info.subscription_contract eq 1 and isdefined('MAX_ID.IDENTITYCOL') and len(MAX_ID.IDENTITYCOL)><!--- abonelik işlemleri kullananlar için,kredi kartı ekleyince sistemlerle ilişki kurma ekranı açılıcak..Ayşenur20070822 --->
		window.open('<cfoutput>#request.self#?fuseaction=member.popup_list_related_subs&member_cc_id=#MAX_ID.IDENTITYCOL#<cfif isDefined("attributes.comp_id")>&inv_comp_id=#attributes.comp_id#&member_name=#URLEncodedFormat(get_par_info(attributes.comp_id,1,0,0))#<cfelse>&inv_cons_id=#attributes.cons_id#&member_name=#URLEncodedFormat(get_cons_info(attributes.cons_id,0,0))#</cfif></cfoutput>','','resizable=1,scrollbars=1,top=150,left=150,height=470,width=600'); 
	</cfif>
	<cfif not (isDefined('attributes.draggable') and len(attributes.draggable))>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
	</cfif>
</script>
