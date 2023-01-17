<!---
    File: einvoice_approval.cfm
    Folder: V16\invoice\query\
	Controller:
    Author:
    Date:
    Description:
        
    History:
        Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com 2020-01-20 13:52:07 
        DTP dışındaki tüm entegratörler kaldırıldı
    To Do:

--->

<cfif isdefined("attributes.receiving_detail_id") and len(attributes.receiving_detail_id)>
    <cfquery name="GET_EINVOICE_TYPE" datasource="#DSN2#">
        SELECT
            OC.EINVOICE_COMPANY_CODE,
            OC.EINVOICE_TEST_SYSTEM,
            OC.EINVOICE_RECEIVER_ALIAS,
            OC.EINVOICE_SENDER_ALIAS,   
            OC.EINVOICE_USER_NAME,
            OC.EINVOICE_PASSWORD,  
            O.TAX_NO
        FROM
            #dsn_alias#.OUR_COMPANY_INFO OC,
            #dsn_alias#.OUR_COMPANY O
        WHERE
            O.COMP_ID = OC.COMP_ID AND
            OC.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">    
    </cfquery>
    <cfquery name="GET_INV_DET" datasource="#DSN2#">
        SELECT
            UUID,
            PROFILE_ID,
            EINVOICE_ID,
            EINVOICE_TYPE,
            SENDER_TAX_ID,
            SENDER_ALIAS,
            RECEIVER_TAX_ID,
            DETAIL,
            INVOICE_TYPE_CODE
        FROM
            EINVOICE_RECEIVING_DETAIL
        WHERE
            RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
    </cfquery>
    <cfif get_inv_det.profile_id eq 'TICARIFATURA'>
        <cfif GET_INV_DET.einvoice_type eq 3>
            <cfif get_einvoice_type.einvoice_test_system eq 1>
                <cfset web_service_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/IntegrationService.asmx'>
            <cfelse>
                <cfset web_service_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
            </cfif>

            <!--- Ticket almak icin gerekli XML formati hazirlaniyor --->
            <cfxml variable="ticket_data"><cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
            <soapenv:Header/>
            <soapenv:Body>
                <tem:GetFormsAuthenticationTicket>
                    <tem:CorporateCode>#GET_EINVOICE_TYPE.EINVOICE_COMPANY_CODE#</tem:CorporateCode>
                    <tem:LoginName>#GET_EINVOICE_TYPE.EINVOICE_USER_NAME#</tem:LoginName>
                    <tem:Password><![CDATA[#GET_EINVOICE_TYPE.EINVOICE_PASSWORD#]]></tem:Password>
                </tem:GetFormsAuthenticationTicket>
            </soapenv:Body>
            </soapenv:Envelope></cfoutput>
            </cfxml>

            <!--- Fatura kaydetmek icin gerekli tek seferlik ticket alınıyor ---> 
            <cfhttp url="#web_service_url#" method="post" result="httpResponse">
                <cfhttpparam type="header" name="content-type" value="text/xml">
                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
                <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
                <cfhttpparam type="header" name="charset" value="utf-8">
                <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
            </cfhttp>

            <cfset Ticket = xmlParse(httpResponse.filecontent)>
            <cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
            <!--- Gelen Fatura Kabul Servisi --->
            <cfxml variable="UUID"><cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:AcceptInvoice>
                        <tem:Ticket>#Ticket#</tem:Ticket>
                        <tem:UUID>#get_inv_det.uuid#</tem:UUID>
                    </tem:AcceptInvoice>
                </soapenv:Body>
            </soapenv:Envelope></cfoutput>
            </cfxml>

            <cfhttp url="#web_service_url#" method="post" result="AcceptInvoice">
                <cfhttpparam type="header" name="content-type" value="text/xml">
                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/AcceptInvoice">
                <cfhttpparam type="header" name="content-length" value="#len(UUID)#">
                <cfhttpparam type="header" name="charset" value="utf-8">
                <cfhttpparam type="xml" name="message" value="#trim(UUID)#">
            </cfhttp>
            
            <cfscript>
                AcceptInvoiceResponse   = xmlparse(AcceptInvoice.filecontent).Envelope.Body.AcceptInvoiceResponse.AcceptInvoiceResult;
                result                  = AcceptInvoiceResponse.ServiceResult.XmlText;
                if(isdefined("AcceptInvoiceResponse.ServiceResultDescription"))
                result_message          = AcceptInvoiceResponse.ServiceResultDescription.XmlText;
                else
                result_message          = "";
                error_code              = AcceptInvoiceResponse.ErrorCode.XmlText;

                //hata kodu:48 dönüyorsa fatura tarihi geçmiş,hata kodu:64 8 gün içinde onaylanmadığı için otomatik olarak onaylanmış demektir bunları da onaylı olarak alıyoruz
                //hata kodu: 34 fatura karşı sistemde bulunamadığı durumda onaylı kabul ediyoruz
                if (listfind('48,64,34',error_code)) {
                    result = 'Successful';
                }
            </cfscript>
        <cfelseif GET_INV_DET.einvoice_type eq 4> <!--- dogan e-donusum --->
            <cfset einv_common = createObject("component", "V16.e_government.cfc.dogan.efatura.common")>
            <cfset einv_soap = createObject("component", "V16.e_government.cfc.dogan.efatura.soap")>
            <cfset einv_soap.init()>

            <cfset result = einv_soap.InvoiceApproval(uuid : GET_INV_DET.UUID)>

            <cfif result.return_code eq 0>
                <cfset result = 'Successful'> 
            </cfif>
        <cfelseif GET_INV_DET.einvoice_type eq 5> <!--- super entegrator --->
            <cfset einv_common = createObject("component", "V16.e_government.cfc.super.einvoice.common")>
            <cfset einv_soap = createObject("component", "V16.e_government.cfc.super.einvoice.soap")>
            <cfset einv_soap.init()>

            <cfset result_service = einv_soap.InvoiceApproval(uuid : GET_INV_DET.UUID)>
            <cfif result_service.return_code eq 0>
                <cfset result = 'Successful'> 
            </cfif>

        </cfif>
    <cfelse>
        <cfset result = 'Successful'> 
    </cfif>
    <cfif isdefined("result") and result eq 'Successful'>
        <cfquery name="UPD_EINVOICE_RECEIVING_DETAIL" datasource="#DSN2#">
            UPDATE
                EINVOICE_RECEIVING_DETAIL
            SET
            	<cfif isdefined("temp_expense_id")>
                EXPENSE_ID = #max_id.identitycol#,
                <cfelse>
                INVOICE_ID = #get_invoice_id.max_id#,
                </cfif>
                IS_PROCESS = 1,
                STATUS = 1,
                UPDATE_DATE = #now()#
            WHERE
              	RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.receiving_detail_id#">
        </cfquery>

        <!--- wex counter kaydı atılıyor --->
        <!--- <cftry>
            <cfquery name="get_license_id" datasource="#dsn2#">
                SELECT TOP 1 WORKCUBE_ID FROM #dsn#.WRK_LICENSE ORDER BY LICENSE_ID DESC
            </cfquery>
            <cfhttp url="http://wex.workcube.com/wex.cfm/e-government_paper/addCounter" charset="utf-8" result="result">
                <cfhttpparam name="subscription_no" type="formfield" value="#get_license_id.WORKCUBE_ID#" />
                <cfhttpparam name="domain" type="formfield" value="#cgi.http_host#" />
                <cfhttpparam name="domain_ip" type="formfield" value="#cgi.local_addr#" />
                <cfhttpparam name="product_id" type="formfield" value="8719" />
                <cfhttpparam name="amount" type="formfield" value="1" />
                <cfhttpparam name="process_type" type="formfield" value="#INVOICE_CAT#" />
                <cfhttpparam name="process_doc_no" type="formfield" value="#form.invoice_number#" />
                <cfhttpparam name="process_date" type="formfield" value="#dateFormat(attributes.invoice_date,dateformat_style)#" />
                <cfhttpparam name="wex_type" type="formfield" value="E-Fatura" />
                <cfhttpparam name="wex_integrator" type="formfield" value="#GET_INV_DET.einvoice_type#" />
                <cfhttpparam name="counter_incoming" type="formfield" value="1" />
            </cfhttp>
            <cfset responseService = result.FileContent>
            <cfset responseWex = deserializeJson(responseService) />
            <cfif responseWex.status neq 1>
                <script type = "text/javascript">
                    alert('İşlem başarılı, ancak wex kaydı yapılamadı! Lütfen sistem yöneticinize bilgi veriniz!');
                </script>
            </cfif>
            <cfcatch>
                <cfdump var="#cfcatch#">
            </cfcatch>
        </cftry> --->
        <!--- //wex counter kaydı atılıyor --->

        <cfif isdefined('error_code') And error_code Eq 34>
        <script type="text/javascript">
			alert("E-Fatura Entegratör sisteminde bulunamadı!\nOnaylama işlemine devam edebilirsiniz.");
        </script>
        </cfif>
     <cfelse>
        <script type="text/javascript">
			alert("E-Fatura Onaylanırken Bir Hata Oluştu.\n Hata Kodu : <cfoutput><cfif isdefined("result")>#result#</cfif></cfoutput>!");
            history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>