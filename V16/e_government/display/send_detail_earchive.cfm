<!---
    File: send_detail_earchive.cfm
    Folder: V16\e_government\display\
    Author:
    Date:
    Description:
        E-Arşiv fatura gönderim detayları
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
        12.03.2021 Gönderim detayları ve dönüş değerleri tek bir sayfa da birleştirildi. 
    To Do:

--->
<cfparam name="attributes.modal_id" default="">
<cfset upload_folder = Replace(upload_folder,'\','/','all')>
<cfscript>
	earchive_detail = CreateObject("component","V16.e_government.cfc.earchieve");
	earchive_detail.dsn = dsn;
	earchive_detail.dsn_alias = dsn_alias;
	earchive_detail.dsn2 = dsn2;
	get_detail = earchive_detail.get_detail_fnc(action_id:attributes.action_id,action_type:attributes.action_type);
    GET_OUR_COMPANY = earchive_detail.get_our_company_fnc(company_id : session.ep.company_id);
    GET_INVOICE_RELATION = earchive_detail.get_earchive_relation(action_id:attributes.action_id, action_type:attributes.action_type);
</cfscript>

<cfif get_invoice_relation.recordcount gt 0 >
    <cfif GET_OUR_COMPANY.earchive_type_alias eq 'dp'>

        <cfif get_our_company.earchive_test_system eq 1>
            <cfset web_service_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/IntegrationService.asmx'>
        <cfelse>
            <cfset web_service_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
        </cfif>
        
        <cfset save_folder	    = "#upload_folder#e_government#dir_seperator#xml" />

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
                <cf_get_lang dictionary_id="30628.Ticket Alma Sırasında Bir Hata Meydana Geldi"> !<br /><cfabort>
            </cfcatch>
        </cftry>
        
        <cfxml variable="get_earchive_data_status" casesensitive="no"><cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
            <soapenv:Header/>
            <soapenv:Body>
                <tem:CheckEArchiveInvoiceState>
                    <tem:Ticket>#Ticket#</tem:Ticket>
                    <tem:InvoiceNumber>#get_invoice_relation.uuid#</tem:InvoiceNumber>
                    <tem:InvoiceNumberType>UUID</tem:InvoiceNumberType>
                </tem:CheckEArchiveInvoiceState>
            </soapenv:Body>
            </soapenv:Envelope>
            </cfoutput>
        </cfxml>
        
        <cfhttp url="#web_service_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/CheckEArchiveInvoiceState">
            <cfhttpparam type="header" name="content-length" value="#len(get_earchive_data_status)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(get_earchive_data_status)#">
        </cfhttp>

        <cftry>
            <cfset StatusCode = xmlParse(httpResponse.FileContent).Envelope.Body.CheckEArchiveInvoiceStateResponse.CheckEArchiveInvoiceStateResult.InvoiceStatusCode.XmlText>
            <cfset CheckInvoiceStateResult = xmlParse(httpResponse.FileContent).Envelope.Body.CheckEArchiveInvoiceStateResponse.CheckEArchiveInvoiceStateResult.InvoiceStatusDescription.XmlText>
            <cfquery name="UPD_EINVOICE_RELATION" datasource="#DSN2#">
                UPDATE
                    EARCHIVE_RELATION
                SET
                    STATUS = <cfif listfind('60,61',StatusCode) >1<cfelse>NULL</cfif>,
                    STATUS_CODE = #StatusCode#,
                    STATUS_DESCRIPTION = '#CheckInvoiceStateResult#'
                WHERE
                    UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_invoice_relation.uuid#">
            </cfquery>
            <cfcatch type="any">
                <cftry>
                    <cfset Error = xmlParse(httpResponse.FileContent)>
                    <cfif isdefined("Error.Envelope.Body.CheckEArchiveInvoiceStateResponse.CheckEArchiveInvoiceStateResult.ErrorCode")>
                        <cfset Error_code = Error.Envelope.Body.CheckEArchiveInvoiceStateResponse.CheckEArchiveInvoiceStateResult.ServiceResultDescription.XmlText>
                    </cfif>
                <cfcatch type="any">
                    <cfset Error_code = "E-Arşiv Fatura Durum Sorgulamasında bir Hata Meydana Geldi!">
                </cfcatch>
                </cftry>
            </cfcatch>
        </cftry>
    <cfelseif GET_OUR_COMPANY.earchive_type_alias eq 'spr'>
        <cfset soap = createObject("Component","V16.e_government.cfc.super.earchive.soap")>
        <cfset soap.init()>
        <cfset soapResponse = soap.CheckInvoiceState(uuid: get_invoice_relation.uuid)>

        <cftry>
            <cfquery name="UPD_EINVOICE_RELATION" datasource="#DSN2#">
                UPDATE
                    EARCHIVE_RELATION
                SET
                    STATUS = <cfif listfind('40',soapResponse.StatusCode) >1<cfelse>NULL</cfif>,
                    STATUS_CODE = #soapResponse.StatusCode#,
                    STATUS_DESCRIPTION = '#soapResponse.STATUSDESCRIPTION#'
                WHERE
                    UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_invoice_relation.uuid#">
            </cfquery>
            <cfcatch type="any">
                <cfset Error_code = "E-Arşiv Fatura Durum Sorgulamasında bir Hata Meydana Geldi!">
            </cfcatch>
        </cftry>
    <cfelseif GET_OUR_COMPANY.earchive_type_alias eq 'dgn'>
        <cfset soap = createObject("Component","V16.e_government.cfc.dogan.earsiv.soap")>
        <cfset soap.init()>
        <cfset soapResponse = soap.CheckInvoiceState(uuid: get_invoice_relation.uuid)>

        <cftry>
            <cfquery name="UPD_EINVOICE_RELATION" datasource="#DSN2#">
                UPDATE
                    EARCHIVE_RELATION
                SET
                    STATUS = <cfif listfind('120',soapResponse.StatusCode) >1<cfelse>NULL</cfif>,
                    STATUS_CODE = #soapResponse.StatusCode#,
                    STATUS_DESCRIPTION = '#soapResponse.STATUSDESCRIPTION#'
                WHERE
                    UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_invoice_relation.uuid#">
            </cfquery>
            <cfcatch type="any">
                <cfset Error_code = "E-Arşiv Fatura Durum Sorgulamasında bir Hata Meydana Geldi!">
            </cfcatch>
        </cftry>
        
    </cfif>

</cfif>

<cfif get_Detail.recordcount and len(get_Detail.ZIP_FILE_NAME)>
	<cfset zip_file_directory = "#upload_folder#earchive_send#dir_seperator##session.ep.company_id##dir_seperator##year(get_Detail.record_date)##dir_seperator##numberformat(month(get_Detail.record_date),00)##dir_seperator#zip#dir_seperator##get_Detail.ZIP_FILE_NAME#" />
    <cfset xml_file_path = "#upload_folder#reserve_files#dir_seperator##year(get_Detail.record_date)##numberformat(month(get_Detail.record_date),00)##numberformat(day(get_Detail.record_date),00)##dir_seperator#" />
    <cfif not DirectoryExists(xml_file_path)>
        <cfdirectory action='create' directory='#xml_file_path#' />
    </cfif>
    <cfif fileExists(zip_file_directory)>
        <cfzip
            action="unzip"
            file="#zip_file_directory#"
            destination="#xml_file_path#"
            entrypath="#get_Detail.EARCHIVE_ID#.xml"
            storepath="false" />
    <cfelse>
        <script language="javascript">
            alert('<cf_get_lang dictionary_id="46489.Dosya bulunamadı">');
            window.close();
        </script>
        <cfabort />
    </cfif>
</cfif>

<cf_box title="#getLang('','',51954)# - #getLang('','',51946)#" closable="1" popup_box="1">
    <div class="row"><a href="javascript://" class="ui-ripple-btn margin-0" onclick="reRequest()"><cf_get_lang dictionary_id="64689.Durum Sorgula / Güncelle"></a></div>
    <cf_seperator title="#getLang('','',57145)# #getLang('','',51954)#" id="SendDetail">
        <cf_ajax_list id="SendDetail">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id="59328.E-Arşiv"> <cf_get_lang dictionary_id="58527.ID"></th>
                    <th><cf_get_lang dictionary_id="59825.Workcube Referans"> <cf_get_lang dictionary_id="58527.ID"></th>
                    <cfif session.ep.admin>
                        <th><cf_get_lang dictionary_id="43492.Paket"></th>
                    </cfif>
                    <cfif len(get_detail.invoice_type_code)>
                        <th><cf_get_lang dictionary_id='57288.Fatura Tipi'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='59832.Fatura Durumu'></th>
                    <cfif len(get_Detail.output_type[1]) and get_Detail.output_type[1] neq '0000'>
                        <th><cf_get_lang dictionary_id="57143.Gönderim Tipi"></th>
                    </cfif>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><cfoutput>#get_Detail.INTEGRATION_ID[1]#</cfoutput></td>
                    <td><cfoutput>#get_Detail.EARCHIVE_ID[1]#</cfoutput></td>
                    <cfif session.ep.admin>
                        <td>
                            <a href="javascript://" onclick="open_zip()" class="tableyazi">
                                <cfoutput>#get_Detail.ZIP_FILE_NAME[1]#</cfoutput>
                            </a>
                        </td>
                    </cfif>
                    <cfif len(get_detail.invoice_type_code)>
                    <td><cfoutput>#get_detail.invoice_type_code#</cfoutput></td>
                    </cfif>
                    <td>
                        <cfif get_Detail.is_cancel[1] eq 1>
                            <font color="FF0000"><cf_get_lang dictionary_id="59833.Fatura İptal Edildi">!</font>
                        <cfelseif len(get_Detail.relation_detail[1])>
                            <cfoutput><cfif get_Detail.status_code[1] eq 999><font color="##FF0000"><b>#get_Detail.relation_detail[1]#</b></font><cfelse>#get_Detail.relation_detail[1]#</cfif></cfoutput>
                        <cfelseif (len(get_Detail.status[1]) and get_Detail.status[1])>
                            <cf_get_lang dictionary_id="59834.Fatura Onaylandı">
                        <cfelse>
                            <cf_get_lang dictionary_id="59835.Fatura Gönderilmedi">
                        </cfif>
                    </td>
                    <cfif len(get_Detail.output_type[1]) and get_Detail.output_type[1] neq '0000'>
                        <td>
                            <cfif get_Detail.output_type[1] eq '0001'>
                                <cf_get_lang dictionary_id="29766.XML">
                            <cfelseif get_Detail.output_type[1] eq '0010'>
                                <cf_get_lang dictionary_id="29733.PDF">
                            <cfelseif get_Detail.output_type[1] eq '0011'>
                                <cf_get_lang dictionary_id="29733.PDF"> , <cf_get_lang dictionary_id="29766.XML">
                            <cfelseif get_Detail.output_type[1] eq '0100'>
                                <cf_get_lang dictionary_id="36212.Email">
                            <cfelseif get_Detail.output_type[1] eq '0101'>
                                <cf_get_lang dictionary_id="29766.XML"> , <cf_get_lang dictionary_id="36212.Email">
                            <cfelseif get_Detail.output_type[1] eq '0110'>
                                <cf_get_lang dictionary_id="29733.PDF"> , <cf_get_lang dictionary_id="36212.Email">
                            <cfelseif get_Detail.output_type[1] eq '0111'>
                                <cf_get_lang dictionary_id="29766.XML"> , <cf_get_lang dictionary_id="29733.PDF"> , <cf_get_lang dictionary_id="36212.Email">
                            </cfif>
                        </td>
                    </cfif>
                </tr>
            </tbody>
        </cf_ajax_list>    
	<cf_seperator title="#getLang('','',51946)# - #getLang('','',57473)#" id="ReturnDetail">
        <cf_ajax_list id="ReturnDetail">
            <thead>
                <tr>
                    <th><b><cf_get_lang dictionary_id="57066.Gönderen"></b></th>
                    <th><b><cf_get_lang dictionary_id="31753.Gönderim Tarihi"></b></th>
                    <th><b><cf_get_lang dictionary_id="59832.Fatura Durumu"></b></th>
                    <th><b><cf_get_lang dictionary_id="59836.Gönderim Açıklaması"></b></th>
                </tr>
            </thead>
            <tbody>
            <cfoutput query="get_Detail">
                <cfif len(cancel_date)>
                    <tr>
                        <td><font color="##FF0000">#name2#</font></td>
                        <td style="width:90px;"><font color="##FF0000">#dateformat(cancel_date,dateformat_style)# #timeformat(dateadd('h', session.ep.time_zone, cancel_date),timeformat_style)#</font></td>
                        <td><font color="##FF0000"><cfif service_result neq 'Successful'><font color="FF0000">#status_description#</font><cfelse>#status_description#</cfif></font></td>
                        <td><font color="##FF0000">#cancel_description#</font></td>
                    </tr>
                </cfif>
                <tr valign="top">
                    <td width="150">#name#</td>
                    <td width="150">#dateformat(record_date,dateformat_style)# #timeformat(dateadd('h', session.ep.time_zone, record_date),timeformat_style)#</td>
                    <td width="200"><cfif service_result neq 'Successful'><font color="FF0000">#status_description#</font><cfelse>#status_description#</cfif></td>
                    <td>#service_result_description#</td>
                </tr>
            </cfoutput>
            </tbody>
        </cf_ajax_list>
</cf_box>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="29728.Dosya İndir"></cfsavecontent>
<cfif get_Detail.recordcount>
	<script type="text/javascript">
        function open_xml(){
            file_= "<cfoutput>documents/reserve_files/#year(get_Detail.record_date)##numberformat(month(get_Detail.record_date),00)##numberformat(day(get_Detail.record_date),00)#/#get_Detail.EARCHIVE_ID#.xml</cfoutput>";
            get_wrk_message_div("<cfoutput>#message#</cfoutput>","XML",file_)
        }

        function open_zip(){
            file_= "<cfoutput>documents/earchive_send/#session.ep.company_id#/#year(get_Detail.record_date)#/#numberformat(month(get_Detail.record_date),00)#/zip/#get_Detail.ZIP_FILE_NAME#</cfoutput>";
            get_wrk_message_div("<cfoutput>#message#</cfoutput>","Zip",file_)
        }

        function reRequest(){
            closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=invoice.popup_send_detail_earchive&action_id=#attributes.action_id#&action_type=#attributes.action_type#</cfoutput>');
        }

        $(document).keydown(function(e){
            // ESCAPE key pressed
            if (e.keyCode == 27) {
                window.close();
            }
        });
    </script>
</cfif>