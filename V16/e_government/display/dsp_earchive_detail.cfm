<!---
    File: dsp_earchive_detail.cfm
    Folder: V16\e_government\display\
	Controller: 
    Author:
    Date:
    Description:
        
    History:
        Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com 2020-03-27 23:55:34
        E-government standart modüle taşındı
    To Do:

--->

<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
	SELECT
		EARCHIVE_INTEGRATION_TYPE,
		EARCHIVE_TEST_SYSTEM,
		EARCHIVE_COMPANY_CODE,
		EARCHIVE_USERNAME,
		EARCHIVE_PASSWORD,
        EARCHIVE_TYPE_ALIAS
	FROM
		EARCHIVE_INTEGRATION_INFO
	WHERE
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<cfquery name="GET_INVOICE_RELATION" datasource="#DSN2#">
	SELECT ACTION_ID,ACTION_TYPE,UUID,STATUS,INTEGRATION_ID,ISNULL(IS_CANCEL,0) IS_CANCEL FROM EARCHIVE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#"> ORDER BY RECORD_DATE DESC
</cfquery>

<cfif GET_OUR_COMPANY.EARCHIVE_TYPE_ALIAS eq 'dp'>
    <cfif get_our_company.earchive_test_system eq 1>
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
            <tem:CorporateCode>#get_our_company.EARCHIVE_COMPANY_CODE#</tem:CorporateCode>
            <tem:LoginName>#get_our_company.EARCHIVE_USERNAME#</tem:LoginName>
            <tem:Password><![CDATA[#get_our_company.EARCHIVE_PASSWORD#]]></tem:Password>
        </tem:GetFormsAuthenticationTicket>
    </soapenv:Body>
    </soapenv:Envelope></cfoutput>
    </cfxml>

    <!--- tek seferlik ticket alınıyor ---> 
    <cfhttp url="#web_service_url#" method="post" result="ticketResponse">
        <cfhttpparam type="header" name="content-type" value="text/xml">
        <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
        <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
        <cfhttpparam type="header" name="charset" value="utf-8">
        <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
    </cfhttp>

    <cftry>
        <cfset Ticket = xmlParse(ticketResponse.filecontent)>
        <cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
        <cfcatch type="Any">
            <cf_get_lang dictionary_id='30628.Ticket Alma Sırasında Bir Hata Meydana Geldi'> !<br /><br /><cf_get_lang dictionary_id='34215.Hata Mesajı'>: <cfoutput>#cfcatch.detail#</cfoutput><cfabort>
        </cfcatch>
    </cftry>

    <cfxml variable="EArchiveView" casesensitive="no"><cfoutput>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
        <soapenv:Header/>
        <soapenv:Body>
            <tem:GetEArchiveInvoice>
                <tem:Ticket>#Ticket#</tem:Ticket>
                <tem:Value>#get_invoice_relation.uuid#</tem:Value>
                <tem:ValueType>UUID</tem:ValueType>
                <tem:FileType>PDF</tem:FileType>
            </tem:GetEArchiveInvoice>
        </soapenv:Body>
    </soapenv:Envelope>
    </cfoutput></cfxml>

    <cfhttp url="#web_service_url#" method="post" result="httpResponse">
        <cfhttpparam type="header" name="content-type" value="text/xml">
        <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetEArchiveInvoice">
        <cfhttpparam type="header" name="content-length" value="#len(EArchiveView)#">
        <cfhttpparam type="header" name="charset" value="utf-8">
        <cfhttpparam type="xml" name="message" value="#trim(EArchiveView)#">
    </cfhttp>

    <cftry>
        <cfset temp_base64 = xmlParse(httpResponse.fileContent).Envelope.Body.GetEArchiveInvoiceResponse.GetEArchiveInvoiceResult>

        <cfif StructKeyExists(temp_base64,"ReturnValue")>
            <cfset getPDFData = tobinary(temp_base64.ReturnValue.XmlText)>
            <cfif get_invoice_relation.action_type is 'INVOICE'><!--- fatura ise print edilmiş olsun --->
                <cfquery name="UPD_INV" datasource="#DSN2#">
                    UPDATE INVOICE SET PRINT_COUNT = ISNULL(PRINT_COUNT,0) + 1 WHERE INVOICE_ID = #get_invoice_relation.action_id#
                </cfquery>
            </cfif>
            <cfheader name="Content-Disposition" value="attachment; filename=#get_invoice_relation.integration_id#.pdf" charset="utf-8">
            <cfcontent type="application/pdf; charset=utf-8" reset="true" variable="#getPDFData#">
        <cfelse>
            <cfset user_domain = (( cgi.server_port eq 443 ) ? 'https://' : 'http://') & cgi.server_name >
            <cfquery name="get_Detail" datasource="#dsn2#">
                SELECT * FROM EARCHIVE_SENDING_DETAIL WHERE UUID = '#GET_INVOICE_RELATION.uuid#'
            </cfquery>

            <cfset zip_file_directory = "#upload_folder#earchive_send#dir_seperator##session.ep.company_id##dir_seperator##year(get_Detail.record_date)##dir_seperator##numberformat(month(get_Detail.record_date),00)##dir_seperator#zip#dir_seperator##get_Detail.ZIP_FILE_NAME#" />
            <cfset xml_file_path = "#upload_folder#reserve_files#dir_seperator##year(get_Detail.record_date)##numberformat(month(get_Detail.record_date),00)##numberformat(day(get_Detail.record_date),00)##dir_seperator#" />
            
            <cfif not DirectoryExists(xml_file_path)>
                <cfdirectory action='create' directory='#xml_file_path#' />
            </cfif>

            <cfzip
                action="unzip"
                file="#zip_file_directory#"
                destination="#xml_file_path#"
                entrypath="#get_Detail.EARCHIVE_ID#.xml"
                storepath="false" />

            <cfhtmltopdf
                destination="#upload_folder##dir_seperator##GET_INVOICE_RELATION.integration_id#.pdf" overwrite="yes"
                source="#user_domain#/V16/e_government/cfc/earchieve.cfc?method=get_pdf&path=#xml_file_path#&earchive_id=#get_Detail.EARCHIVE_ID#">
            </cfhtmltopdf>

            <cfheader name="Content-Disposition" value="attachment; filename=#GET_INVOICE_RELATION.integration_id#.pdf" charset="utf-8" />
            <cfcontent type="application/pdf; charset=utf-16" reset="true" file="#user_domain#/documents/#GET_INVOICE_RELATION.integration_id#.pdf" />

            <cffile action="delete" file="#replace("#upload_folder##GET_INVOICE_RELATION.integration_id#.pdf","\","/","all")#" mode="777">
            
        </cfif>
    <cfcatch type="any">
        <script>
            alert("<cf_get_lang dictionary_id='60057.E-Erşiv Fatura PDF gösterilemiyor'> , <cf_get_lang dictionary_id='34563.Daha Sonra Tekrar Deneyiniz'>!\n\n<cf_get_lang dictionary_id='34215.Hata Mesajı'>: <cfoutput>#cfcatch.detail#</cfoutput>");
            history.back();
        </script>
    </cfcatch>
    </cftry>
<cfelseif GET_OUR_COMPANY.EARCHIVE_TYPE_ALIAS eq 'spr'>
    <cfset soap = createObject("Component","V16.e_government.cfc.super.earchive.soap")>
    <cfset soap.init()>
    <cfset GetInvoice = soap.getInvoicePDF(uuid: GET_INVOICE_RELATION.uuid)>

    <cfif GetInvoice.service_result eq 'Success'>
        <cfset getData = tobinary(GetInvoice.pdf_data)>
        <cfheader name="Content-Disposition" value="attachment; filename=#GET_INVOICE_RELATION.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-8" reset="true" variable="#getData#" />
    <cfelseif GetInvoice.service_result eq 'NotExists'>
        <cfset user_domain = (( cgi.server_port eq 443 ) ? 'https://' : 'http://') & cgi.server_name >

        <cfquery name="get_Detail" datasource="#dsn2#">
            SELECT * FROM EARCHIVE_SENDING_DETAIL WHERE UUID = '#GET_INVOICE_RELATION.uuid#'
        </cfquery>

        <cfset zip_file_directory = "#upload_folder#earchive_send#dir_seperator##session.ep.company_id##dir_seperator##year(get_Detail.record_date)##dir_seperator##numberformat(month(get_Detail.record_date),00)##dir_seperator#zip#dir_seperator##get_Detail.ZIP_FILE_NAME#" />
        <cfset xml_file_path = "#upload_folder#reserve_files#dir_seperator##year(get_Detail.record_date)##numberformat(month(get_Detail.record_date),00)##numberformat(day(get_Detail.record_date),00)##dir_seperator#" />
        
        <cfif not DirectoryExists(xml_file_path)>
            <cfdirectory action='create' directory='#xml_file_path#' />
        </cfif>

        <cfzip
            action="unzip"
            file="#zip_file_directory#"
            destination="#xml_file_path#"
            entrypath="#get_Detail.EARCHIVE_ID#.xml"
            storepath="false" />

        <cfhtmltopdf
            destination="#upload_folder##dir_seperator##GET_INVOICE_RELATION.integration_id#.pdf" overwrite="yes"
            source="#user_domain#/V16/e_government/cfc/earchieve.cfc?method=get_pdf&path=#xml_file_path#&earchive_id=#get_Detail.EARCHIVE_ID#">
        </cfhtmltopdf>

        <cfheader name="Content-Disposition" value="attachment; filename=#GET_INVOICE_RELATION.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-16" reset="true" file="#user_domain#/documents/#GET_INVOICE_RELATION.integration_id#.pdf" />

        <cffile action="delete" file="#replace("#upload_folder##GET_INVOICE_RELATION.integration_id#.pdf","\","/","all")#" mode="777">
    <cfelse>
        <cfset error_code = 'Problem oluştu, tekrar deneyin.'>
    </cfif>
<cfelseif get_our_company.earchive_type_alias eq 'dgn'>
    <cfscript>
        soap = createObject('component','V16.e_government.cfc.dogan.earsiv.soap');
        soap.init();
        invoice_pdf = soap.getInvoicePDF(uuid : GET_INVOICE_RELATION.UUID).pdf_data;
    </cfscript>


    <cffile action="write" file = "#gettempdirectory()##GET_INVOICE_RELATION.integration_id#.zip" output = "#tobinary(invoice_pdf)#">
    <cfzip action = "list" file = "#gettempdirectory()##GET_INVOICE_RELATION.integration_id#.zip" name = "res">
    <cfzip action = "readbinary" file = "#gettempdirectory()##GET_INVOICE_RELATION.integration_id#.zip" entrypath = "#res.Name#" variable = "invoice_pdf" >

    <cfset getPDFData = tobinary(invoice_pdf) />
    <cfheader name="Content-Disposition" value="attachment; filename=#GET_INVOICE_RELATION.integration_id#.pdf" charset="utf-8" />
    <cfcontent type="application/pdf; charset=utf-8" reset="true" variable="#getPDFData#" />
<cfelse>
    Lütfen entegrasyon firma tanımlarını kontrol ediniz!
</cfif>
