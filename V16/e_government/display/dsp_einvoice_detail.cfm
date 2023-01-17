<!---
    File: dsp_einvoice_detail.cfm
    Folder: V16\e_government\display\
	Controller: 
    Author:
    Date:
    Description:
        efatura görüntüleme sayfası gelen efatura id ye göre xml okunup ekrana basılır 20131113 sm
    History:
        Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com 2020-01-16 19:27:09
        DTP dışındaki entegratör kısımları kaldırıldı.

        Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com 2020-03-27 23:55:34
        E-government standart modüle taşındı
    To Do:

--->

<cfscript>
	get_einvoice = createobject("component","V16.e_government.cfc.einvoice");
	get_einvoice.dsn = dsn;
	get_einvoice_def = get_einvoice.get_our_company_fnc(session.ep.company_id);
</cfscript>

<!---Firma donem icerisinde Entegrasyon firması degistirirse--->
<cfif not isdefined("attributes.integration_id") or not len(attributes.integration_id)>
	<cfset attributes.integration_id = attributes.uuid>
</cfif>

<cfif get_einvoice_def.einvoice_type_alias eq 'dp'>
    <cfif get_einvoice_def.einvoice_test_system eq 1>
        <cfset dp_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/Integrationservice.asmx'>
    <cfelse>
        <cfset dp_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
    </cfif>

    <!--- Ticket almak icin gerekli XML formati hazirlaniyor --->
    <cfxml variable="ticket_data"><cfoutput>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
    <soapenv:Header/>
    <soapenv:Body>
        <tem:GetFormsAuthenticationTicket>
            <tem:CorporateCode>#get_einvoice_def.EINVOICE_COMPANY_CODE#</tem:CorporateCode>
            <tem:LoginName>#get_einvoice_def.EINVOICE_USER_NAME#</tem:LoginName>
            <tem:Password><![CDATA[#get_einvoice_def.EINVOICE_PASSWORD#]]></tem:Password>
        </tem:GetFormsAuthenticationTicket>
    </soapenv:Body>
    </soapenv:Envelope></cfoutput>
    </cfxml>
    
    <cfhttp url="#dp_url#" method="post" result="ticketResponse">
        <cfhttpparam type="header" name="content-type" value="text/xml">
        <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
        <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
        <cfhttpparam type="header" name="charset" value="utf-8">
        <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
    </cfhttp>

    <cfset Ticket = xmlParse(ticketResponse.filecontent)>
    <cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>

    <cfxml variable="get_EInvoice"><cfoutput>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
        <soapenv:Header/>
        <soapenv:Body>
            <tem:GetInvoicePDF>
                <tem:Ticket>#Ticket#</tem:Ticket>
                <tem:UUID>#attributes.uuid#</tem:UUID>
            </tem:GetInvoicePDF>
        </soapenv:Body>
    </soapenv:Envelope></cfoutput>
    </cfxml>

    <cfhttp url="#dp_url#" method="post" result="GetInvoice">
        <cfhttpparam type="header" name="content-type" value="text/xml">
        <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetInvoicePDF">
        <cfhttpparam type="header" name="content-length" value="#len(get_EInvoice)#">
        <cfhttpparam type="header" name="charset" value="utf-8">
        <cfhttpparam type="xml" name="message" value="#trim(get_EInvoice)#">
    </cfhttp>

    <cfset soapResponse = xmlParse(GetInvoice.fileContent).Envelope.Body.GetInvoicePDFResponse.GetInvoicePDFResult />

    <cfif StructKeyExists(soapResponse,"ReturnValue")>
        <cfset temp_base64 = soapResponse.ReturnValue.xmlText />
        <cfset getPDFData = tobinary(temp_base64) />
        <cfheader name="Content-Disposition" value="attachment; filename=#attributes.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-8" reset="true" variable="#getPDFData#" />

    <cfelseif soapResponse.ErrorCode.XmlText is '34' And soapResponse.ServiceResultDescription.XmlText is 'Fatura Bulanamadı !'>
        <cfset user_domain = (( cgi.server_port eq 443 ) ? 'https://' : 'http://') & cgi.server_name >
        <cfhtmltopdf
            destination="#upload_folder##dir_seperator##attributes.integration_id#.pdf" overwrite="yes"
            source="#user_domain#/V16/e_government/cfc/einvoice.cfc?method=get_pdf&uuid=#attributes.uuid#&dsn2_name=#dsn2#">
        </cfhtmltopdf>
        <cfheader name="Content-Disposition" value="attachment; filename=#attributes.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-16" reset="true" file="#user_domain#/documents/#attributes.integration_id#.pdf" />
        <cffile action="delete" file="#replace("#upload_folder##attributes.integration_id#.pdf","\","/","all")#" mode="777">
        
    <cfelse>  
        <cfset Error_code =  soapResponse.ServiceResultDescription.xmlText />
    </cfif>
<cfelseif get_einvoice_def.einvoice_type_alias eq 'spr'>
    <cfset soap = createObject("Component","V16.e_government.cfc.super.einvoice.soap")>
    <cfset soap.init()>
    <cfset GetInvoice = soap.getInvoicePDF(uuid: attributes.uuid)>

    <cfif GetInvoice.service_result eq 'Success'>
        <cfset getData = tobinary(GetInvoice.pdf_data)>
        <cfheader name="Content-Disposition" value="attachment; filename=#attributes.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-8" reset="true" variable="#getData#" />
    <cfelseif GetInvoice.service_result eq 'InvoiceNotExists'>
        <cfset user_domain = (( cgi.server_port eq 443 ) ? 'https://' : 'http://') & cgi.server_name >
        <cfhtmltopdf
            destination="#upload_folder##dir_seperator##attributes.integration_id#.pdf" overwrite="yes"
            source="#user_domain#/V16/e_government/cfc/einvoice.cfc?method=get_pdf&uuid=#attributes.uuid#&integration_id=#attributes.integration_id#&dsn2_name=#dsn2#">
        </cfhtmltopdf>
        <cfheader name="Content-Disposition" value="attachment; filename=#attributes.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-16" reset="true" file="#user_domain#/documents/#attributes.integration_id#.pdf" />

        <cffile action="delete" file="#replace("#upload_folder##arguments.integration_id#.pdf","\","/","all")#" mode="777">
    <cfelse>
        <cfset error_code = 'Problem oluştu, tekrar deneyin.'>
    </cfif> 

<cfelseif get_einvoice_def.einvoice_type_alias eq 'dgn'> <!--- Doğan --->
    <cfscript>
        soap = createObject('component','V16.e_government.cfc.dogan.efatura.soap');
        soap.init();
        invoice_pdf = soap.getInvoicePDF(uuid : attributes.UUID).pdf_data;
    </cfscript>
    <cffile action="write" file = "#gettempdirectory()##attributes.integration_id#.zip" output = "#tobinary(invoice_pdf)#">
    <cfzip action = "list" file = "#gettempdirectory()##attributes.integration_id#.zip" name = "res">
    <cfzip action = "readbinary" file = "#gettempdirectory()##attributes.integration_id#.zip" entrypath = "#res.Name#" variable = "invoice_pdf" >

    <cfset getPDFData = tobinary(invoice_pdf) />
    <cfheader name="Content-Disposition" value="attachment; filename=#attributes.uuid#.pdf" charset="utf-8" />
    <cfcontent type="application/pdf; charset=utf-8" reset="true" variable="#getPDFData#" />
<cfelse>
    <cfset Error_code = "Lütfen entegrasyon firma tanımlarını kontrol ediniz!" />
</cfif>
<cfif isdefined("Error_code")> 
    <cf_popup_box title = "E-Fatura Görsel">
        <table width="%100" height="10">
            <tr>
                <td style="color:#F00;font-weight:700"><cfoutput><span><cf_get_lang dictionary_id='40568.Hata Kodu'> : #Error_code#!</span></cfoutput></td>
            </tr>
        </table>
    </cf_popup_box>
</cfif>