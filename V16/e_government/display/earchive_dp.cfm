<!---
    File: earchive_dp.cfm
    Folder: V16\e_government\display
    Author:
    Date:
    Description:
        Digital Planet E-arşiv fatura gönderme
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
         13.04.21 farklı session değerleriyle kayıt atılacağız için tüm ep değerleri session base e çevirildi
    To Do:
   
--->

<cfif not ArrayLen(xml_error_codes)><!--- İlgili XML oluşumunda eksiklik ve Hata yok ise --->
	<cfinclude template="create_ubltr_earchive.cfm" />
    <cfset directory_name_xml	= "#upload_folder#earchive_send#dir_seperator##session_base.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)##dir_seperator#xml" />
	<cfset directory_name_zip	= "#upload_folder#earchive_send#dir_seperator##session_base.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)##dir_seperator#zip" />
	<cfset preview_invoice_xml	= "documents/earchive_send/#session_base.company_id#/#year(now())#/#numberformat(month(now()),00)#/xml/#invoice_number#.xml" />
    <cfif not DirectoryExists(directory_name_xml)>
        <cfdirectory action="create" directory="#directory_name_xml#">
    </cfif>
    <cfif not DirectoryExists(directory_name_zip)>
        <cfdirectory action="create" directory="#directory_name_zip#">
    </cfif>
    <cfscript>
    	earchive_tmp = CreateObject("component","V16.e_government.cfc.earchieve");
    	earchive_tmp.dsn = dsn;
        earchive_tmp.dsn2 = dsn2;
        zip_filename = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')#_#createuuid()#.zip";
    </cfscript>
    
    <cfif get_our_company.earchive_test_system eq 1>
		<cfset web_service_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/IntegrationService.asmx'>
	<cfelse>
		<cfset web_service_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
	</cfif>
    <!--- E-Arşiv Fatura XML'i dosyaya yazılıyor. --->
    <cffile action="write" file="#directory_name_xml##dir_seperator##invoice_number#.xml" output="#trim(invoice_data)#" charset="utf-8" />
    
    <!--- Fatura önizleme sayfasından geliyor ise çalışmayı durduruyoruz --->
    <cfif attributes.fuseaction Neq 'invoice.popup_preview_invoice'>
        <cfzip source="#directory_name_xml##dir_seperator##invoice_number#.xml" action="zip" file="#directory_name_zip##dir_seperator##zip_filename#" />

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

        <!--- Fatura kaydetmek icin gerekli tek seferlik ticket alınıyor ---> 
        <cfhttp url="#web_service_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
            <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
        </cfhttp>

        <cftry>
            <cfset Ticket = xmlParse(httpResponse.filecontent)>
            <cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
            <cfcatch type="Any">
                Ticket Alma Sırasında Bir Hata Meydana Geldi !<br /><cfabort>
            </cfcatch>
        </cftry>

        <cffile action="READBINARY" file="#directory_name_xml##dir_seperator##invoice_number#.xml" variable="earchive">
        <cfset base64_earchive = trim(ToBase64(earchive))>
        <cffile action = "delete" file = "#directory_name_xml##dir_seperator##invoice_number#.xml">
        
        <cfxml variable="send_earchive_data" casesensitive="no"><cfoutput>
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
        <soapenv:Header/>
        <soapenv:Body>
            <cfif get_our_company.is_template_code eq 1><tem:SendEArchiveDataWithTemplateCode><cfelse><tem:SendEArchiveData></cfif>
                <!--Optional:-->
                <tem:Ticket>#Ticket#</tem:Ticket>
                <tem:FileType>UBL</tem:FileType>
                <!--Optional:-->
                <tem:InvoiceRawData>#base64_earchive#</tem:InvoiceRawData>
                <!--Optional:-->
                <tem:CorporateCode>#get_our_company.earchive_company_code#</tem:CorporateCode>
                <!--Optional:-->
                <tem:MapCode></tem:MapCode>
                <cfif get_our_company.is_template_code eq 1><tem:TemplateCode>#invoice_prefix#</tem:TemplateCode>
            </tem:SendEArchiveDataWithTemplateCode><cfelse></tem:SendEArchiveData></cfif>
        </soapenv:Body>
        </soapenv:Envelope>
        </cfoutput></cfxml>

        <!--- Fatura kaydı gercekletiriliyor --->
        <cfhttp url="#web_service_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfif get_our_company.is_template_code eq 1><cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/SendEArchiveDataWithTemplateCode"><cfelse><cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/SendEArchiveData"></cfif>
            <cfhttpparam type="header" name="content-length" value="#len(send_earchive_data)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(send_earchive_data)#">
        </cfhttp>

        <cftry>
            <cfif get_our_company.is_template_code eq 1>
                <cfset xml_doc = xmlparse(httpResponse.Filecontent).Envelope.Body.SendEArchiveDataWithTemplateCodeResponse.SendEArchiveDataWithTemplateCodeResult>
            <cfelse>
                <cfset xml_doc = xmlparse(httpResponse.Filecontent).Envelope.Body.SendEArchiveDataResponse.SendEArchiveDataResult>
            </cfif>
            <cfset status_code = xml_doc.Invoices.InvoiceStateResult.StatusCode.XmlText>
            <cfif ListFind("60",status_code)>
                <cfset status_code = 1>
            </cfif>
            <cfset uuid = xml_doc.Invoices.InvoiceStateResult.UUID.XmlText>
            <cfset integration_id = xml_doc.Invoices.InvoiceStateResult.InvoiceId.XmlText>
            <cfset service_result = xml_doc.Invoices.InvoiceStateResult.ServiceResult.XmlText>
            <cfset status_description = xml_doc.Invoices.InvoiceStateResult.StatusDescription.XmlText>
            <cfset error_code = xml_doc.Invoices.InvoiceStateResult.ErrorCode.XmlText> 
            <cfset new_invoice_number = integration_id>
            <cfif isdefined("xml_doc.Invoices.InvoiceStateResult.ServiceResultDescription.XmlText")>
                <cfset service_result_description = xml_doc.Invoices.InvoiceStateResult.ServiceResultDescription.XmlText>
            <cfelse>
                <cfset service_result_description = "">
            </cfif>
                
            <cfquery name="GET_OUTPUT_TYPE" dbtype="query"><!--- Mail Gönderim Kontrolü --->
                SELECT OUTPUT_TYPE FROM output_type_array WHERE UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
            </cfquery>

            <cfscript>
                earchive_sending_detail_fnc = earchive_tmp.add_earchive_sending_detail(
                                    zip_file_name: zip_filename,
                                    service_result: service_result,
                                    uuid: uuid,
                                    earchive_id:invoice_number,
                                    status_description:status_description,
                                    service_result_description:service_result_description,
                                    status_code:status_code,
                                    error_code:error_code,
                                    action_id:attributes.action_id,
                                    action_type:attributes.action_type,
                                    output_type:get_output_type.output_type,
                                    earchive_sending_type:get_invoice.earchive_sending_type,
                                    invoice_type_code:temp_InvoiceTypeCode
                );
            </cfscript>
            
        <cfif status_code eq 1>
                <cfset invoice_path ="earchive_send/#session_base.company_id#/#year(now())#/#numberformat(month(now()),00)#/xml/#invoice_number#.xml">
                <cfscript>
                    earchive_relation_tmp = earchive_tmp.add_earchive_relation(
                                            status_description: status_description,
                                            uuid:uuid,
                                            integration_id:integration_id,
                                            earchive_id:invoice_number,
                                            action_id:attributes.action_id,
                                            action_type:attributes.action_type,
                                            path: invoice_path,
                                            sender_type:get_our_company.earchive_integration_type,
                                            earchive_sending_type: get_invoice.earchive_sending_type,
                                            is_internet:get_invoice.is_internet
                            );							
                </cfscript>
        </cfif>
        
        <cfif attributes.action_type is 'INVOICE'>
                <cfquery name="GET_INVOICE" datasource="#DSN2#">
                    SELECT INVOICE_ID,INVOICE_CAT,WRK_ID,INVOICE_NUMBER,INVOICE_DATE FROM INVOICE WHERE INVOICE_ID = #attributes.action_id#
                </cfquery>
        <cfelse>
                <cfquery name="GET_INVOICE" datasource="#DSN2#">
                    SELECT EXPENSE_ID,ACTION_TYPE,PAPER_NO, EXPENSE_DATE AS INVOICE_DATE, ACTION_TYPE AS INVOICE_CAT FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = #attributes.action_id#
                </cfquery>
                <cfset row_action_id = get_invoice.expense_id>
        </cfif>
        <cfcatch type="any">
            <cftry>
                <cfif get_our_company.is_template_code eq 1>
                    <cfset xml_doc = xmlparse(httpResponse.Filecontent).Envelope.Body.SendEArchiveDataWithTemplateCodeResponse.SendEArchiveDataWithTemplateCodeResult>
                <cfelse>
                    <cfset xml_doc = xmlparse(httpResponse.Filecontent).Envelope.Body.SendEArchiveDataResponse.SendEArchiveDataResult>
                </cfif>
                    <cfset status_description = xml_doc.ServiceResultDescription.XmlText>
                <cfoutput>#status_description#</cfoutput>
            <cfcatch>
                    <cfif isdefined("STATUS_DESCRIPTION")><cfoutput>#STATUS_DESCRIPTION#</cfoutput><cfelse>Fatura Gönderimi Sırasında Bir Hata Meydana Geldi !</cfif><br />
            </cfcatch>
            </cftry><cfabort>
        </cfcatch>
        </cftry>
    </cfif>
<cfelse>
	<ul>
        <cfloop array="#xml_error_codes#" index="error_code">
            <cfoutput>
                <li style="margin-top:5px;"><i style="font-size:15px;color:##FF0000 !important;" class="fa fa-exclamation"></i>&nbsp;&nbsp;#error_code#</li>
            </cfoutput>
        </cfloop>
    </ul>
    <cfabort>
</cfif>