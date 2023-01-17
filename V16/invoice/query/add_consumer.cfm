<cfinclude template = "../../objects/query/session_base.cfm">
<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.member_name=replacelist(attributes.member_name,list,list2)>
<cfset attributes.member_surname=replacelist(attributes.member_surname,list,list2)>
<cfif isDefined("attributes.tc_num") and len(attributes.tc_num) and not (isdefined("attributes.xml_kontrol_tcnumber") and attributes.xml_kontrol_tcnumber eq 0)>
	<cfquery name="get_consumer_tc_kontrol" datasource="#dsn2#">
		SELECT
			CONSUMER_ID,
			TERMINATE_DATE,
			CONSUMER_STATUS
		FROM
			#dsn_alias#.CONSUMER
		WHERE
			TC_IDENTY_NO = '#trim(attributes.tc_num)#'
	</cfquery>
	<cfif get_consumer_tc_kontrol.recordcount gte 1>
		<cfif get_consumer_tc_kontrol.consumer_status eq 0>
			<script type="text/javascript">
				alert("Girilen TC kimlik No Sistemden Çıkmış Olan Bir Üyeye Ait. Lütfen Sistem Yöneticisine Başvurunuz !");
				history.back();
			</script>
		<cfelse>
			<script type="text/javascript">
				alert("Aynı Tc Kimlik Numarası ile Kayıtlı Bir Üye Var. Lütfen Kontrol Ediniz !");
				history.back();
			</script>
		</cfif>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="ADD_CONSUMER" datasource="#DSN2#">
	INSERT INTO
		#dsn_alias#.CONSUMER
    (
        IS_CARI,
        ISPOTANTIAL,
        <cfif isdefined("attributes.member_special_code") and len(attributes.member_special_code)>OZEL_KOD,</cfif>
        CONSUMER_CAT_ID,
        CONSUMER_STAGE,
        CONSUMER_EMAIL,
        CONSUMER_FAX,
        CONSUMER_FAXCODE,
        COMPANY,
        CONSUMER_NAME,
        CONSUMER_SURNAME,
        MOBIL_CODE,
        MOBILTEL,
        <cfif isdefined("attributes.mobil_code_2")>MOBIL_CODE_2,</cfif>
        <cfif isdefined("attributes.mobil_tel_2")>MOBILTEL_2,</cfif>
        TAX_OFFICE,
        TAX_NO,
        <cfif isdefined("attributes.adres_type") and len(attributes.adres_type)>
            CONSUMER_HOMETEL,
            CONSUMER_HOMETELCODE,
            HOMEADDRESS,
            HOME_COUNTY_ID,
            HOME_CITY_ID,
            HOME_COUNTRY_ID,
        <cfelse>
            CONSUMER_WORKTEL,
            CONSUMER_WORKTELCODE,
            TAX_ADRESS,
            TAX_COUNTY_ID,
            TAX_CITY_ID,
            TAX_COUNTRY_ID,
        </cfif>
        TC_IDENTY_NO,
        VOCATION_TYPE_ID,
        IMS_CODE_ID,
        PERIOD_ID,
        RECORD_IP,
        RECORD_MEMBER,
        RECORD_DATE
    )
	VALUES 	 
    (
        1,
        0,
        <cfif isdefined("attributes.member_special_code") and len(attributes.member_special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_special_code#">,</cfif>
        <cfif isdefined("attributes.cons_member_cat") and len(attributes.cons_member_cat)>#cons_member_cat#,<cfelse>#consumer_cat_id#,</cfif>
        #attributes.consumer_stage#,
        <cfif isdefined("attributes.email") and len(attributes.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.fax_number") and len(attributes.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fax_number#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.faxcode") and len(attributes.faxcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.faxcode#"><cfelse>NULL</cfif>,
        <cfif isDefined("attributes.comp_name") and Len(attributes.comp_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comp_name#"><cfelse>NULL</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_surname#">,
        <cfif len(attributes.mobil_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_code#"><cfelse>NULL</cfif>,
        <cfif len(attributes.mobil_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_tel#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.mobil_code_2")><cfif len(attributes.mobil_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_code_2#"><cfelse>NULL</cfif>,</cfif>
        <cfif isdefined("attributes.mobil_tel_2")><cfif len(attributes.mobil_tel_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_tel_2#"><cfelse>NULL</cfif>,</cfif>
        <cfif len(attributes.tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_office#"><cfelse>NULL</cfif>,
        <cfif len(attributes.tax_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_num#"><cfelse>NULL</cfif>,
        <cfif len(attributes.tel_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_number#"><cfelse>NULL</cfif>,
        <cfif len(attributes.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_code#"><cfelse>NULL</cfif>,
        <cfif len(attributes.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.address#"><cfelse>NULL</cfif>,
        <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
        <cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
        1,
        <cfif isdefined('attributes.tc_num') and len(attributes.tc_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tc_num#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.vocation_type") and len(attributes.vocation_type)>#attributes.vocation_type#<cfelse>NULL</cfif>,
        <cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id)>#attributes.ims_code_id#<cfelse>NULL</cfif>,
        #session_base.period_id#,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #session_base.userid#,
        #now()#
    )
</cfquery>
<cfquery name="GET_MAX_CONS" datasource="#DSN2#">
	SELECT 
		MAX(CONSUMER_ID) MAX_CONS 
	FROM 
		#dsn_alias#.CONSUMER
</cfquery>
<cfquery name="UPD_MEMBER_CODE" datasource="#DSN2#">
	UPDATE 
		#dsn_alias#.CONSUMER 
	SET 
		<cfif isdefined("attributes.member_code") and len(attributes.member_code)>
			MEMBER_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.member_code)#">
		<cfelse>
			MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="B#get_max_cons.max_cons#">
		</cfif>
	WHERE 
		CONSUMER_ID = #get_max_cons.max_cons#
</cfquery>
<cfquery name="ADD_COMP_PERIOD" datasource="#DSN2#">
	INSERT INTO
		#dsn_alias#.CONSUMER_PERIOD
    (
        CONSUMER_ID,
        PERIOD_ID,
        ACCOUNT_CODE
    )
	VALUES
    (
        #get_max_cons.max_cons#,
        #session_base.period_id#,
        <cfif isdefined("acc") and len(acc)><cfqueryparam cfsqltype="cf_sql_varchar" value="#acc#"><cfelse>NULL</cfif>
    )
</cfquery>
<cfquery name="add_branch_related" datasource="#DSN2#">
	INSERT INTO
		#dsn_alias#.COMPANY_BRANCH_RELATED
    (
        CONSUMER_ID,
        OUR_COMPANY_ID,
        BRANCH_ID,
        OPEN_DATE,
        RECORD_EMP,
        RECORD_DATE,
        RECORD_IP
    )
	VALUES
    (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session_base.user_location,2,'-')#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
    )
</cfquery>

<cf_workcube_process is_upd='1' 
	data_source='#dsn2#'
	old_process_line='0'
	process_stage='#attributes.consumer_stage#' 
	record_member='#session_base.userid#' 
	record_date='#now()#' 
	action_table='CONSUMER'
	action_column='CONSUMER_ID'
	action_id='#get_max_cons.max_cons#'
	action_page='#request.self#?fuseaction=member.consumer_list&event=det&cid=#get_max_cons.max_cons#' 
	warning_description='Bireysel Üye : #attributes.member_name# #attributes.member_surname#'>
	
<cfif session_base.our_company_info.is_efatura and isdefined("attributes.tc_num") and len(attributes.tc_num)>
	<cfquery name="CHK_EINVOICE_METHOD" datasource="#DSN2#">
    	SELECT EINVOICE_TYPE,EINVOICE_TEST_SYSTEM,EINVOICE_COMPANY_CODE,EINVOICE_USER_NAME,EINVOICE_PASSWORD FROM #dsn_alias#.OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
    </cfquery>
    <cfif chk_einvoice_method.einvoice_type eq 3>
		<cfif chk_einvoice_method.einvoice_test_system eq 1>
            <cfset web_service_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/IntegrationService.asmx'>
        <cfelse>
            <cfset web_service_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
        </cfif>    
        <cftry>
        
        <!--- Ticket almak icin gerekli XML formati hazirlaniyor --->
        <cfxml variable="ticket_data"><cfoutput>
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
        <soapenv:Header/>
        <soapenv:Body>
            <tem:GetFormsAuthenticationTicket>
                <tem:CorporateCode>#CHK_EINVOICE_METHOD.EINVOICE_COMPANY_CODE#</tem:CorporateCode>
                <tem:LoginName>#CHK_EINVOICE_METHOD.EINVOICE_USER_NAME#</tem:LoginName>
                <tem:Password><![CDATA[#CHK_EINVOICE_METHOD.EINVOICE_PASSWORD#]]></tem:Password>
            </tem:GetFormsAuthenticationTicket>
        </soapenv:Body>
        </soapenv:Envelope></cfoutput>
        </cfxml>
        
        <cfhttp url="#web_service_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
            <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
        </cfhttp>
        
        <cfset Ticket = xmlParse(httpResponse.filecontent)>
        <cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
    
        <cfsavecontent variable="xml_tc_identy"><cfoutput>
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
        <soapenv:Header/>
            <soapenv:Body>
              <tem:CheckCustomerTaxId>
                 <tem:Ticket>#Ticket#</tem:Ticket>
                 <tem:TaxIdOrPersonalId>#attributes.tc_num#</tem:TaxIdOrPersonalId>
              </tem:CheckCustomerTaxId>
            </soapenv:Body>
        </soapenv:Envelope></cfoutput>
        </cfsavecontent>
        
        <cfhttp url="#web_service_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/CheckCustomerTaxId">
            <cfhttpparam type="header" name="content-length" value="#len(xml_tc_identy)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(xml_tc_identy)#">
        </cfhttp>
        <cfset is_exist = xmlparse(httpResponse.filecontent).Envelope.Body.CheckCustomerTaxIdResponse.CheckCustomerTaxIdResult.CustomerInfoList.EInvoiceCustomerResult.IsExist.XmlText>
        <cfset RegisterTime = xmlparse(httpResponse.filecontent).Envelope.Body.CheckCustomerTaxIdResponse.CheckCustomerTaxIdResult.CustomerInfoList.EInvoiceCustomerResult.RegisterTime.XmlText>
        <cfif is_exist eq 'true'>
            <cfquery name="UPD_CONS" datasource="#DSN#">
                UPDATE CONSUMER SET USE_EFATURA = 1,EFATURA_DATE = #CreateODBCDateTime(replace(RegisterTime,'T',' '))# WHERE CONSUMER_ID = #get_max_cons.max_cons#
            </cfquery>
        </cfif>
        <cfcatch>
        </cfcatch>
        </cftry>
      <cfelseif chk_einvoice_method.einvoice_type eq 6>
			<cfif CHK_EINVOICE_METHOD.einvoice_test_system eq 1>
                <cfset web_service_url = 'http://178.251.43.49:8080/efatura/ws/connectorService?wsdl'>
                <cfset is_test = 1>
            <cfelse>
                <cfset web_service_url = 'https://connector.efinans.com.tr/connector/ws/connectorService?wsdl '>
                <cfset is_test = 0>
            </cfif>  
            <cfset ef.lang = 'tr'>
            <cftry>
            <cfset vkn = attributes.tc_num>
            <cfscript>
                objeFinans = createObject("component", "V16.add_options.cfc.efinans").init(CHK_EINVOICE_METHOD.EINVOICE_USER_NAME, CHK_EINVOICE_METHOD.EINVOICE_PASSWORD, ef.lang, is_test);
                httpResponse = objeFinans.efaturaKullaniciBilgisi(vkn);
            </cfscript>
            <cfset soapResponse = xmlParse(httpResponse.fileContent) />
            <cfset responseNodes = xmlSearch(soapResponse, "//*[ local-name() = 'return' ]" ) />
            <cfif arraylen(responseNodes) gt 0>
                <cfset RegisterTime = xmlparse(httpResponse.filecontent).Envelope.Body.efaturaKullaniciBilgisiResponse.return.kayitZamani.xmltext>
                 <cfscript>
                    year_ = mid(RegisterTime,1,4);
                    month_ = mid(RegisterTime,5,2);
                    day_ = mid(RegisterTime,7,2);
                    my_date = createdate(year_,month_,day_);
                </cfscript>
                <cfquery name="UPD_CONS" datasource="#DSN#">
                    UPDATE CONSUMER SET USE_EFATURA = 1,EFATURA_DATE = #my_date# WHERE CONSUMER_ID = #GET_MAX_CONS.MAX_CONS#
                </cfquery>
            </cfif>
            <cfcatch></cfcatch>
        </cftry>
	</cfif>
</cfif>	
