<!--- VKN veya TCKN degerinin mukellef olup olmadıgını kontrol eden CFC 
Verilen degerlere gore COMPANY tablosunda guncelleme yapar. BK 20141118--->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<!--- Ana Fonksiyon --->
    <cffunction name="CheckCustomerTaxIdMain" access="public" output="false" returntype="any">
        <cfargument name="Action_Type" type="string" required="yes" default="" />
        <cfargument name="Action_ID" type="string" required="yes" default="" />
        <cfargument name="VKN" type="string" required="false" default="" />
        <cfargument name="TCKN" type="string" required="false" default="" />
        <cfargument name="using_alias" required="false" default="#dsn#" />
		<cfset variable.Action_Type = arguments.Action_Type>
        <cfset variable.Action_ID = arguments.Action_ID>
        <cfset variable.VKN = arguments.VKN>
        <cfset variable.TCKN = arguments.TCKN>
        <cfif arguments.using_alias eq dsn>
        	<cfset variable.temp_datasource = dsn>
        <cfelse>
        	<cfset variable.temp_datasource = arguments.using_alias>
        </cfif>
        <cfset variable.temp_alias = '#dsn#'>
        <cfset return_value=StructNew()>
        <cfif len(arguments.VKN) or len(arguments.TCKN)>
            <cfquery name="GET_EINVOICE_COMPANY" datasource="#variable.temp_datasource#">
                SELECT 
                    OCI.EINVOICE_TYPE,
                    OCI.EINVOICE_TEST_SYSTEM,
                    OCI.EINVOICE_COMPANY_CODE,
                    OCI.EINVOICE_USER_NAME,
                    OCI.EINVOICE_PASSWORD,
                    OCI.EINVOICE_SENDER_ALIAS,
                    OCI.EINVOICE_TYPE_ALIAS,
                    OC.TAX_NO 
                FROM 
                    #variable.temp_alias#.OUR_COMPANY_INFO OCI,
                    #variable.temp_alias#.OUR_COMPANY OC 
                WHERE 
                    OCI.COMP_ID = OC.COMP_ID AND 
                    OCI.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            </cfquery>
            <cfif get_einvoice_company.EINVOICE_TYPE_ALIAS eq 'dp'>
            	<cfset xxx = CheckCustomerTaxIdDigital(GET_EINVOICE_COMPANY)>
            <cfelseif get_einvoice_company.EINVOICE_TYPE_ALIAS eq 'spr'>
            	<cfset xxx = CheckCustomerTaxIdSuper(GET_EINVOICE_COMPANY)>
            <cfelse>
				<cfset return_value.Id="0">  
                <cfset return_value.Value="Entegratör Değerlerinizi Kontrol Ediniz !">    
            </cfif>
        <cfelse>
        	<cfquery name="UPD_EFATURA" datasource="#variable.temp_datasource#">
                UPDATE #variable.temp_alias#.#variable.action_type# SET USE_EFATURA = 0,EFATURA_DATE = NULL,USE_EARCHIVE = 1 WHERE #variable.action_type#_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable.action_id#">
            </cfquery>
			<cfset return_value.Id="0">  
            <cfset return_value.Value="VKN veya TCKN Değerlerini Kontrol Ediniz !">    
        </cfif>
        <cfreturn return_value> 
	</cffunction>
    
	<!--- Digital Planet --->   
 	<cffunction name="CheckCustomerTaxIdDigital" access="public" output="false">
    	<cfargument name="GET_EINVOICE_COMPANY" type="query" default="" required="yes">
		
		<cfif get_einvoice_company.einvoice_test_system eq 1>
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
                    <tem:CorporateCode>#get_einvoice_company.EINVOICE_COMPANY_CODE#</tem:CorporateCode>
                    <tem:LoginName>#get_einvoice_company.EINVOICE_USER_NAME#</tem:LoginName>
                    <tem:Password><![CDATA[#get_einvoice_company.EINVOICE_PASSWORD#]]></tem:Password>
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

            <cfsavecontent variable="data_check_customer"><cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
            <soapenv:Header/>
                <soapenv:Body>
                  <tem:CheckCustomerTaxId>
                     <tem:Ticket>#Ticket#</tem:Ticket>
                     <tem:TaxIdOrPersonalId><cfif len(variable.VKN)>#variable.VKN#<cfelse>#variable.TCKN#</cfif></tem:TaxIdOrPersonalId>
                  </tem:CheckCustomerTaxId>
                </soapenv:Body>
            </soapenv:Envelope></cfoutput>
            </cfsavecontent>
            
            <cfhttp url="#web_service_url#" method="post" result="httpResponse">
                <cfhttpparam type="header" name="content-type" value="text/xml">
                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/CheckCustomerTaxId">
                <cfhttpparam type="header" name="content-length" value="#len(data_check_customer)#">
                <cfhttpparam type="header" name="charset" value="utf-8">
                <cfhttpparam type="xml" name="message" value="#trim(data_check_customer)#">
            </cfhttp>
            <cfset is_exist = xmlparse(httpResponse.filecontent).Envelope.Body.CheckCustomerTaxIdResponse.CheckCustomerTaxIdResult.CustomerInfoList.EInvoiceCustomerResult.IsExist.XmlText>
            <cfset RegisterTime = xmlparse(httpResponse.filecontent).Envelope.Body.CheckCustomerTaxIdResponse.CheckCustomerTaxIdResult.CustomerInfoList.EInvoiceCustomerResult.RegisterTime.XmlText>
        
            <cfif is_exist eq 'true'>              
                <cfset comp_type = xmlparse(httpResponse.filecontent).Envelope.Body.CheckCustomerTaxIdResponse.CheckCustomerTaxIdResult.CustomerInfoList.EInvoiceCustomerResult.Type.XmlText>
                <cfquery name="UPD_EFATURA" datasource="#variable.temp_datasource#">
                    UPDATE #variable.temp_alias#.#variable.action_type# SET USE_EFATURA = 1, EFATURA_DATE = #CreateODBCDateTime(replace(RegisterTime,'T',' '))#, USE_EARCHIVE = 0, IS_CIVIL_COMPANY = <cfif comp_type eq 'Kamu'>1<cfelse>0</cfif> WHERE #variable.action_type#_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable.action_id#">
                </cfquery>
                <cfset return_value.Id="1">  
                <cfset return_value.Value="Mükellef">                         
            <cfelse>
                <cfquery name="UPD_EFATURA" datasource="#variable.temp_datasource#">
                	UPDATE #variable.temp_alias#.#variable.action_type# SET USE_EFATURA = 0, EFATURA_DATE = NULL, USE_EARCHIVE = 1, IS_CIVIL_COMPANY = 0 WHERE #variable.action_type#_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable.action_id#">
                </cfquery>             
                <cfset return_value.Id="1">  
                <cfset return_value.Value="Mükellef Değil">    
            </cfif>
            <cfcatch>
                <cfset return_value.Id="0">  
                <cfset return_value.Value="Digital Planet Web Servis Erişim Hatası">    
            </cfcatch>
        </cftry>
	</cffunction>
    
    <!--- Super Entegrator --->
    <cffunction name="CheckCustomerTaxIdSuper" access="public" output="false">
        <cfargument name="GET_EINVOICE_COMPANY" type="query" default="" required="yes">
        <cfset soap = createObject("Component","V16.e_government.cfc.super.einvoice.soap")>
        <cfset soap.init()>
        <cfset GetAlias = soap.GetUserAliases(vkn_tckn: '#IIf(len(variable.VKN),"variable.VKN",DE(variable.TCKN))#')>
        <cfif GetAlias.status>
            <cfset GetStatus = soap.IsEinvoiceUser(vkn_tckn: '#IIf(len(variable.VKN),"variable.VKN",DE(variable.TCKN))#', alias: getAlias.alias)>
            <cfquery name="UPD_EFATURA" datasource="#variable.temp_datasource#">
                UPDATE #variable.temp_alias#.#variable.action_type# SET USE_EFATURA = 1, EFATURA_DATE = #CreateODBCDateTime(replace(GetAlias.create_date,'T',' '))#, USE_EARCHIVE = 0 <cfif variable.action_type eq 'COMPANY'>, IS_CIVIL_COMPANY = <cfif GetAlias.type eq 'Kamu'>1<cfelse>0</cfif> </cfif> WHERE #variable.action_type#_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable.action_id#">
            </cfquery>
            <cfset return_value.Id="1">  
            <cfset return_value.Value="Mükellef">     
        <cfelse>
            <cfquery name="UPD_EFATURA" datasource="#variable.temp_datasource#">
                UPDATE #variable.temp_alias#.#variable.action_type# SET USE_EFATURA = 0, EFATURA_DATE = NULL, USE_EARCHIVE = 1 <cfif variable.action_type eq 'COMPANY'>, IS_CIVIL_COMPANY = 0 </cfif> WHERE #variable.action_type#_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable.action_id#">
            </cfquery>  
            <cfset return_value.Id = 0>  
            <cfset return_value.Value = "Mükellef Değil">    
        </cfif>
        
    </cffunction>
</cfcomponent>
