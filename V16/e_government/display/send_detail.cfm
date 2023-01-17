<!---
    File: send_detail.cfm
    Folder: V16\invoice\display\
    Author:
    Date:
    Description:
        E-fatura gönderim detayları
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
        12.03.2021 Gönderim detayları ve dönüş değerleri tek bir sayfa da birleştirildi. 
    To Do:

--->

<cf_xml_page_edit fuseact="add_options.popup_send_detail">

<cfscript>
	our_company = CreateObject("component","V16.e_government.cfc.einvoice");
	our_company.dsn = dsn;
	our_company.dsn_alias = dsn_alias;
	our_company.dsn2 = dsn2;
	our_company_fnc = our_company.get_our_company_fnc(session.ep.company_id);
    get_einvoice_detail = our_company.get_einvoice_detail_fnc(action_id:attributes.action_id,action_type:attributes.action_type);
    get_invoice_relation = our_company.get_invoice_relation(action_id:attributes.action_id, action_type:attributes.action_type, invoice_type:'einvoice');
</cfscript>
<cfif get_invoice_relation.recordcount gt 0 >
    <cfif our_company_fnc.einvoice_type_alias eq 'dp'>
        <cfif our_company_fnc.einvoice_test_system eq 1>
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
                    <tem:CorporateCode>#our_company_fnc.EINVOICE_COMPANY_CODE#</tem:CorporateCode>
                    <tem:LoginName>#our_company_fnc.EINVOICE_USER_NAME#</tem:LoginName>
                    <tem:Password><![CDATA[#our_company_fnc.EINVOICE_PASSWORD#]]></tem:Password>
                </tem:GetFormsAuthenticationTicket>
            </soapenv:Body>
            </soapenv:Envelope></cfoutput>
        </cfxml>

        <!--- Tek seferlik ticket alınıyor ---> 
        <cfhttp url="#web_service_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
            <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
        </cfhttp>

        <cfset Ticket =xmlParse(httpResponse.filecontent)>
        <cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>

        <!--- durum sorgulama için gerekli xml formatı hazırlanıyor --->
        <cfsavecontent variable="invoice_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <tem:CheckInvoiceState>
                            <tem:Ticket>#Ticket#</tem:Ticket>
                            <tem:UUID>#get_invoice_relation.UUID#</tem:UUID>
                        </tem:CheckInvoiceState>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfsavecontent>

        <!--- durum sorgulama işlemi gerçekleşiyor --->
        <cfhttp url="#web_service_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/CheckInvoiceState">
            <cfhttpparam type="header" name="content-length" value="#len(invoice_data)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(invoice_data)#">
        </cfhttp>

        <!--- dönüş değeri ilgili tabloyu güncelliyor --->
        <cfset soapResponse = xmlParse(httpResponse.Filecontent).Envelope.Body.CheckInvoiceStateResponse.CheckInvoiceStateResult>
        <cfset StatusCode = soapResponse.StatusCode.XmlText>
        <cfset StatusDescription = soapResponse.StatusDescription.XmlText>
        <cfscript>
            if(StatusCode is '49' And StatusDescription is 'SİLİNMİŞ FATURA'){
                Error_code = 'Fatura Entegratör Sisteminde Bulunamadı, Fatura Bağlantıları Silindi, Yeniden Gönderebilirsiniz';
                queryExecute("DELETE FROM EINVOICE_RELATION WHERE ACTION_ID = #attributes.action_id# AND ACTION_TYPE = '#attributes.action_type#'",{},{datasource:'#dsn2#'});
                queryExecute("DELETE FROM EINVOICE_SENDING_DETAIL WHERE ACTION_ID = #attributes.action_id# AND ACTION_TYPE = '#attributes.action_type#'",{},{datasource:'#dsn2#'});
            }else{
                our_company.upd_einvoice_relation_fnc(
                                                        uuid:get_invoice_relation.uuid,
                                                        profile_id:get_invoice_relation.profile_id,
                                                        StatusCode:StatusCode,
                                                        CheckInvoiceStateResult:StatusDescription,
                                                        einvoice_type:our_company_fnc.einvoice_type
                                                    );
            }
        </cfscript>

        <!--- faturanın tüm tarihçesi için gerekli xml formatı hazırlanıyor --->
        <cfsavecontent variable="return_send_detail">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <tem:InvoiceStatusHistory>
                            <tem:Ticket>#Ticket#</tem:Ticket>
                            <tem:UUID>#get_invoice_relation.UUID#</tem:UUID>
                        </tem:InvoiceStatusHistory>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfsavecontent>

        <!--- tüm tarihçe için sorgulama işlemi gerçekleşiyor --->
        <cfhttp url="#web_service_url#" method="post" result="SendDetail">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/InvoiceStatusHistory">
            <cfhttpparam type="header" name="content-length" value="#len(return_send_detail)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(return_send_detail)#">
        </cfhttp>  

        <cfxml variable="SendDetailResponse"><cfoutput>#SendDetail.Filecontent#</cfoutput></cfxml>
        <cfset ServiceResult = SendDetailResponse.Envelope.Body.InvoiceStatusHistoryResponse.InvoiceStatusHistoryResult.ServiceResult.XmlText>
    <cfelseif our_company_fnc.einvoice_type_alias eq 'spr'>
        <cfset soap = createObject("Component","V16.e_government.cfc.super.einvoice.soap")>
        <cfset soap.init()>
        <cfset soapResponse = soap.CheckInvoiceState(uuid: get_invoice_relation.uuid)>
     <cfelseif our_company_fnc.einvoice_type_alias eq 'dgn'>
        <cfset soap = createObject('component','V16.e_government.cfc.dogan.efatura.soap')>
        <cfset soap.init()>
        <cfset invoice_state = soap.CheckInvoiceState(uuid : get_invoice_relation.UUID)>
    </cfif>
</cfif>

<cf_box title="#getLang('','',51954)# - #getLang('','',51946)#" closable="1" popup_box="1">
    <div class="row"><a href="javascript://" class="ui-ripple-btn margin-0" onclick="reRequest()"><cf_get_lang dictionary_id="64689.Durum Sorgula / Güncelle"></a></div>
    <cf_seperator title="#getLang('','',29872)# #getLang('','',51954)#" id="SendDetail">
        <cf_ajax_list id="SendDetail">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='29872.E-Fatura'><cf_get_lang dictionary_id='58527.ID'></th>
                    <th><cf_get_lang dictionary_id='59825.Workcube Referans'> <cf_get_lang dictionary_id='58527.ID'></th>
                    <cfif len(get_einvoice_detail.invoice_type_code)>
                        <th><cf_get_lang dictionary_id='57288.Fatura Tipi'></th>
                    </cfif>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <cfif session.ep.admin>
                            <a href="javascript:void(0);" onclick="open_xml()" class="tableyazi"><cfoutput>#get_einvoice_detail.integration_id[1]#</cfoutput></a>
                        <cfelse>
                            <cfoutput>#get_einvoice_detail.integration_id[1]#</cfoutput>
                        </cfif>
                    </td>
                    <td><cfoutput>#get_einvoice_detail.einvoice_id[1]#</cfoutput></td>
                    <cfif len(get_einvoice_detail.invoice_type_code)>
                    <td><cfoutput>#get_einvoice_detail.invoice_type_code#</cfoutput></td>
                    </cfif>
                </tr>
            </tbody>
        </cf_ajax_list>    
	<cf_seperator title="#getLang('','',51946)# - #getLang('','',57473)#" id="ReturnDetail">
        <cf_ajax_list id="ReturnDetail">
            <thead>
                <tr>
                    <th><b><cf_get_lang dictionary_id='57066.Gönderen'></b></th>
                    <th><cf_get_lang dictionary_id='31753.Gönderim Tarihi'></th>
                    <th><b><cf_get_lang dictionary_id='59832.Fatura Durumu'></b></b></th>
                    <th><b><cf_get_lang dictionary_id='57441.Fatura'> <cf_get_lang dictionary_id='58685.Hata Açıklaması'></b></th>
                </tr>
            </thead>
            <tbody>
                <cfif isdefined("ServiceResult") and ServiceResult neq "Error"> <!--- sadece dtp tarafındaki tüm historyi alabildiğimiz bi servis --->
                    <!--- son aşama en üste gelecek şekilde sıralıyoruz --->
                    <cfloop from="#arrayLen(SendDetailResponse.Envelope.Body.InvoiceStatusHistoryResponse.InvoiceStatusHistoryResult.InvoiceStatuses.xmlchildren)#" to="1" index="i" step="-1">
                        <tr>
                            <td>Entegratör Bilgisi</td>
                            <td>
                                <cfoutput>
                                    #dateformat(SendDetailResponse.Envelope.Body.InvoiceStatusHistoryResponse.InvoiceStatusHistoryResult.InvoiceStatuses.xmlchildren[i].TransactionDate.XmlText,dateformat_style)#
                                    #timeFormat(SendDetailResponse.Envelope.Body.InvoiceStatusHistoryResponse.InvoiceStatusHistoryResult.InvoiceStatuses.xmlchildren[i].TransactionDate.XmlText,'HH:nn:ss')#
                                </cfoutput>
                            </td>
                            <td><cfoutput>#SendDetailResponse.Envelope.Body.InvoiceStatusHistoryResponse.InvoiceStatusHistoryResult.InvoiceStatuses.xmlchildren[i].TransactionDescription.XmlText#</cfoutput></td>
                            <td></td>
                        </tr>
                    </cfloop>
                </cfif>
                <cfoutput query="get_einvoice_detail">
                    <tr>
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
<script type="text/javascript">
	function open_xml(){
		file_= "<cfoutput>documents/einvoice_send/#session.ep.company_id#/#year(get_einvoice_detail.record_date)#/#numberformat(month(get_einvoice_detail.record_date),00)#/#get_einvoice_detail.EINVOICE_ID#</cfoutput>.xml";		
		get_wrk_message_div("<cfoutput>#message#</cfoutput>","XML",file_)
	}

	function open_zip(){
		file_= "<cfoutput>documents/einvoice_send/#session.ep.company_id#/#year(get_einvoice_detail.record_date)#/#numberformat(month(get_einvoice_detail.record_date),00)#/#get_einvoice_detail.EINVOICE_ID#</cfoutput>.zip";
		get_wrk_message_div("<cfoutput>#message#</cfoutput>","Zip",file_)
	}

    function reRequest(){
        closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=invoice.popup_send_detail&action_id=#attributes.action_id#&action_type=#attributes.action_type#</cfoutput>');
    }

	$(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });
</script>

<cfif our_company_fnc.einvoice_type_alias eq 'dgn'>
    <cfquery name = "get_invoice" datasource = "#dsn2#">
        SELECT TOP 100
            CASE WHEN EIR.INTEGRATION_ID IS NOT NULL THEN 'EINVOICE'
                 WHEN EAR.INTEGRATION_ID IS NOT NULL THEN 'EARCHIVE'
                 ELSE '' END AS TYPE,
            EIR.INTEGRATION_ID,
            EIR.EINVOICE_ID,
            EAR.INTEGRATION_ID,
            EAR.EARCHIVE_ID,
            I.INVOICE_ID,
            I.UUID,
            ISNULL(EIR.UUID,EAR.UUID) AS UUID_INT,
            I.INVOICE_NUMBER,
            I.SERIAL_NO,
            C.TAXNO,
            I.INVOICE_CAT AS ACTION_TYPE,
            I.INVOICE_CAT,
            I.IS_CASH,
            ISNULL(EIR.ACTION_TYPE,EAR.ACTION_TYPE) AS ACTION_TYPE
        FROM
            #dsn2#.INVOICE I
                LEFT JOIN #dsn2#.EINVOICE_RELATION EIR ON EIR.ACTION_ID = I.INVOICE_ID AND EIR.ACTION_TYPE = 'INVOICE'
                LEFT JOIN #dsn2#.EARCHIVE_RELATION EAR ON EAR.ACTION_ID = I.INVOICE_ID AND EAR.ACTION_TYPE = 'INVOICE'
                LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = I.COMPANY_ID
        WHERE
            1 = 1
            AND ISNULL(EIR.SENDER_TYPE,EAR.SENDER_TYPE) = 4
            AND DATEADD(DAY,60,ISNULL(EIR.RECORD_DATE,EAR.RECORD_DATE)) > GETDATE()
            AND EIR.RELATION_ID IS NOT NULL
            <cfif structKeyExists(attributes, 'action_id')>
                AND I.INVOICE_ID = #attributes.action_id#
            </cfif>
    </cfquery>

    <cfset einv_common = createObject("component", "V16.e_government.cfc.dogan.efatura.common")>
    <cfset einv_soap = createObject("component", "V16.e_government.cfc.dogan.efatura.soap")>

    <cfset einv_soap.init()>

    <cfset einv_ticket = einv_soap.GetFormsAuthentication(company_id : session.ep.company_id)>

    <cfoutput query = "get_invoice">
        <cfif type eq 'EINVOICE'>
            <cfxml variable="availableinvoices_data">
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl">
                <soapenv:Header/>
                <soapenv:Body>
                    <wsdl:GetInvoiceRequest>
                        <REQUEST_HEADER>
                            <SESSION_ID>#einv_ticket#</SESSION_ID>
                            <APPLICATION_NAME>W3C</APPLICATION_NAME>
                            <COMPRESSED>N</COMPRESSED>
                        </REQUEST_HEADER>
                        <INVOICE_SEARCH_KEY>
                            <UUID>#trim(UUID_INT)#</UUID>
                            <READ_INCLUDED>true</READ_INCLUDED>
                            <DIRECTION>OUT</DIRECTION>
                        </INVOICE_SEARCH_KEY>
                        <HEADER_ONLY>Y</HEADER_ONLY>
                    </wsdl:GetInvoiceRequest>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfxml>

            <cftry>
                <cfset httpresult = einv_soap.SendHttp("EFaturaOIB", "http://tempuri.org/GetInvoiceRequest", availableinvoices_data)>

                <cfset xmlresult = xmlParse(httpresult.Filecontent)>

                <cfif structKeyExists(xmlresult.Envelope.Body.GetInvoiceResponse,'INVOICE')>
                    <cfset real_invoice_number = xmlresult.Envelope.Body.GetInvoiceResponse.INVOICE.XmlAttributes.ID>

                    <cfif real_invoice_number neq invoice_number>
                    <!---
                        #invoice_id# id'li faturanın numarası güncelleniyor. #invoice_number# --> #real_invoice_number#<br />
                    --->

                        <cfset new_invoice_number = real_invoice_number>


                        <cfif isdefined("new_invoice_number") and len(new_invoice_number)>
                            <cftry>
                                <cfset yeni_fatura_no="#new_invoice_number#">
                                <cfif action_type is 'INVOICE' or 1 eq 1>
                                    <!--- Fatura ise cari, muhasebe, irsaliye ve bütçe islemleri güncelleniyor --->
                                    <cfquery name="UPD_INVOICE_SALE" datasource="#dsn2#">
                                        UPDATE INVOICE SET INVOICE_NUMBER = '#yeni_fatura_no#',SERIAL_NO = '#yeni_fatura_no#',SERIAL_NUMBER = NULL WHERE INVOICE_ID = #get_invoice.invoice_id#
                                    </cfquery>
                                    <cfquery name="UPD_CARI_ROWS" datasource="#dsn2#">
                                        UPDATE CARI_ROWS SET PAPER_NO = '#yeni_fatura_no#', ACTION_NAME = ACTION_NAME + ' (E-FATURA)'  WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE_ID = #get_invoice.invoice_cat#
                                    </cfquery>
                                    <cfquery name="UPD_ACCOUNT_CARD" datasource="#dsn2#">
                                        UPDATE ACCOUNT_CARD SET PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150) WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE = #get_invoice.invoice_cat#
                                    </cfquery>
                                    <cfquery name="UPD_ACCOUNT_CARD_ROW" datasource="#dsn2#">
                                        UPDATE 
                                            ACCOUNT_CARD_ROWS 
                                        SET 
                                            DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                                        WHERE 
                                            CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE = #get_invoice.invoice_cat#)
                                    </cfquery>
                                    <cfquery name="UPD_ACCOUNT_ROWS_IFRS" datasource="#DSN2#">
                                        UPDATE 
                                            ACCOUNT_ROWS_IFRS 
                                        SET 
                                            DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150)
                                        WHERE 
                                            CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE = #get_invoice.invoice_cat#)
                                    </cfquery>
                                    <cfif len(get_invoice.is_cash) and get_invoice.is_cash eq 1>
                                        <cfquery name="UPD_ACCOUNT_CARD_CASH" datasource="#dsn2#">
                                            UPDATE 
                                                ACCOUNT_CARD 
                                            SET 
                                                PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150) 
                                            WHERE
                                                ACTION_ID = #get_invoice.CASH_ID# 
                                                AND ACTION_TYPE IN (34,35) 
                                                AND ACTION_ID IN (SELECT ACTION_ID FROM CASH_ACTIONS WHERE ACTION_ID = #get_invoice.CASH_ID# )
                                        </cfquery>
                                        <cfquery name="UPD_ACCOUNT_CARD_CASH_ROW" datasource="#dsn2#">
                                            UPDATE 
                                                ACCOUNT_CARD_ROWS 
                                            SET 
                                                DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                                            WHERE 
                                                CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD AC JOIN CASH_ACTIONS CA ON CA.ACTION_ID = AC.ACTION_ID WHERE AC.ACTION_ID = #get_invoice.CASH_ID# AND AC.ACTION_TYPE IN (34,35) )
                                        </cfquery>
                                    </cfif>
                                    <cfquery name="UPD_EXP_DETAIL" datasource="#dsn2#">
                                        UPDATE 
                                            EXPENSE_ITEMS_ROWS 
                                        SET 
                                            DETAIL = REPLACE(CAST(DETAIL AS NVARCHAR),'#get_invoice.invoice_number#','#yeni_fatura_no#')
                                        WHERE 
                                            INVOICE_ID = #get_invoice.invoice_id#
                                    </cfquery>
                                    <cfquery name="UPD_INVOICE_SALE" datasource="#dsn2#">
                                        UPDATE 
                                            SHIP 
                                        SET 
                                            SHIP_NUMBER= '#yeni_fatura_no#' 
                                        FROM 
                                            SHIP S,INVOICE_SHIPS ISH 
                                        WHERE 
                                            ISH.INVOICE_ID = '#get_invoice.invoice_id#' AND ISH.SHIP_ID = S.SHIP_ID AND ISNULL(ISH.IS_WITH_SHIP,0) = 1 
                                    </cfquery>
                                    <cfquery name="UPD_INVOICE_SHIPS" datasource="#dsn2#">
                                        UPDATE INVOICE_SHIPS SET INVOICE_NUMBER = '#yeni_fatura_no#', SHIP_NUMBER = '#yeni_fatura_no#' WHERE INVOICE_ID = #get_invoice.invoice_id# AND ISNULL(IS_WITH_SHIP,0) = 1
                                    </cfquery>
                                    <cfquery name="UPD_INVOICE_SHIPS" datasource="#dsn2#">
                                        UPDATE INVOICE_SHIPS SET INVOICE_NUMBER = '#yeni_fatura_no#' WHERE INVOICE_ID = #get_invoice.invoice_id# AND ISNULL(IS_WITH_SHIP,0) = 0
                                    </cfquery>
                                    <cfquery name="get_ship_info" datasource="#dsn2#">
                                        SELECT
                                            S.SHIP_TYPE,
                                            S.COMPANY_ID,
                                            S.SHIP_ID
                                        FROM
                                            SHIP S, INVOICE_SHIPS ISH
                                        WHERE 
                                            ISH.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.invoice_id#"> 
                                            AND ISH.SHIP_ID = S.SHIP_ID AND ISNULL(ISH.IS_WITH_SHIP,0) = 1
                                    </cfquery>
                                    <cfif get_ship_info.recordCount>
                                        <cfquery name="upd_serial_no" datasource="#dsn2#">
                                            UPDATE #dsn3_alias#.SERVICE_GUARANTY_NEW 
                                                SET PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#yeni_fatura_no#">
                                            WHERE 
                                                PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_info.SHIP_TYPE#"> 
                                                AND SALE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_info.COMPANY_ID#">
                                                AND PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_info.SHIP_ID#">
                                        </cfquery>
                                    </cfif>

                                    <cfquery name = "get_inv_cash_pos" datasource = "#dsn2#">
                                        SELECT * FROM INVOICE_CASH_POS WHERE INVOICE_ID = #get_invoice.invoice_id#
                                    </cfquery>
                                    <cfloop query = "get_inv_cash_pos">
                                        <cfif len(cash_id)>
                                            <cfquery name = "get_acc_card" datasource = "#dsn2#">
                                                SELECT
                                                    CARD_ID
                                                FROM
                                                    ACCOUNT_CARD 
                                                WHERE
                                                    ACTION_ID = #cash_id# 
                                                    AND ACTION_TYPE IN (35)
                                            </cfquery>
                                            <cfquery name="UPD_ACCOUNT_CARD_CASH_POS" datasource="#dsn2#">
                                                UPDATE 
                                                    ACCOUNT_CARD 
                                                SET 
                                                    PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150) 
                                                WHERE
                                                    CARD_ID = #get_acc_card.card_id#
                                            </cfquery>
                                            <cfquery name="UPD_ACCOUNT_CARD_CASH_ROW" datasource="#dsn2#">
                                                UPDATE
                                                    ACCOUNT_CARD_ROWS
                                                SET
                                                    DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                                                WHERE
                                                    CARD_ID = #get_acc_card.card_id#
                                            </cfquery>
                                        </cfif>
                                        <cfif len(pos_action_id)>
                                            <cfquery name = "get_acc_card" datasource = "#dsn2#">
                                                SELECT
                                                    CARD_ID
                                                FROM
                                                    ACCOUNT_CARD 
                                                WHERE
                                                    ACTION_ID = #pos_action_id# 
                                                    AND ACTION_TYPE IN (241)
                                            </cfquery>
                                            <cfquery name="UPD_ACCOUNT_CARD_CASH_POS" datasource="#dsn2#">
                                                UPDATE 
                                                    ACCOUNT_CARD 
                                                SET 
                                                    PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150)
                                                WHERE
                                                    CARD_ID = #get_acc_card.card_id#
                                            </cfquery>
                                            <cfquery name="UPD_ACCOUNT_CARD_CASH_ROW" datasource="#dsn2#">
                                                UPDATE
                                                    ACCOUNT_CARD_ROWS
                                                SET
                                                    DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                                                WHERE
                                                    CARD_ID = #get_acc_card.card_id#
                                            </cfquery>
                                        </cfif>
                                    </cfloop>
                                <cfelse>
                                    <!--- Gelir fisi ise cari ,muhasebe güncelleniyor --->
                                    <cfquery name="UPD_EXPENSE" datasource="#dsn2#">
                                        UPDATE EXPENSE_ITEM_PLANS SET PAPER_NO = '#yeni_fatura_no#',SERIAL_NO = '#yeni_fatura_no#',SERIAL_NUMBER = NULL WHERE EXPENSE_ID = #get_invoice.invoice_id#
                                    </cfquery>
                                    <cfquery name="UPD_CARI_ROWS" datasource="#dsn2#">
                                        UPDATE CARI_ROWS SET PAPER_NO = '#yeni_fatura_no#',ACTION_NAME = ACTION_NAME + ' (E-FATURA)' WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE_ID = #get_invoice.action_type#
                                    </cfquery>
                                    <cfquery name="UPD_ACCOUNT_CARD" datasource="#dsn2#">
                                        UPDATE ACCOUNT_CARD SET PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150) WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE = #get_invoice.action_type#
                                    </cfquery>
                                    <cfquery name="UPD_ACCOUNT_CARD_ROW" datasource="#dsn2#">
                                        UPDATE 
                                            ACCOUNT_CARD_ROWS 
                                        SET 
                                            DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                                        WHERE 
                                            CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD WHERE ACTION_ID = #get_invoice.invoice_id# AND ACTION_TYPE = #get_invoice.action_type#)
                                    </cfquery>
                                    <cfif len(get_invoice.is_cash) and get_invoice.is_cash eq 1>
                                        <cfquery name="UPD_ACCOUNT_CARD_CASH" datasource="#dsn2#">
                                            UPDATE 
                                                ACCOUNT_CARD 
                                            SET 
                                                PAPER_NO = '#yeni_fatura_no#',CARD_DETAIL = LEFT(REPLACE(CARD_DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),150) 
                                            WHERE
                                                ACTION_ID = #get_invoice.CASH_ID# 
                                                AND ACTION_TYPE IN (24,25,31,32) 
                                                AND ACTION_ID IN (SELECT ACTION_ID FROM CASH_ACTIONS WHERE ACTION_ID = #get_invoice.CASH_ID# )
                                        </cfquery>
                                        <cfquery name="UPD_ACCOUNT_CARD_CASH_ROW" datasource="#dsn2#">
                                            UPDATE
                                                ACCOUNT_CARD_ROWS
                                            SET
                                                DETAIL = LEFT(REPLACE(DETAIL,'#get_invoice.invoice_number#','#yeni_fatura_no#'),500)
                                            WHERE
                                                CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD AC JOIN CASH_ACTIONS CA ON CA.ACTION_ID = AC.ACTION_ID WHERE AC.ACTION_ID = #get_invoice.CASH_ID# AND AC.ACTION_TYPE IN (24,25,31,32) )
                                        </cfquery>
                                    </cfif>
                                </cfif>
                                <!---  islem tamamlandıgında iliski tablosunda belge güncellendi alanını 1 set ediyoruz.--->
                                <cfquery name="upd_inv_rel" datasource="#dsn2#">
                                    UPDATE EINVOICE_RELATION SET IS_PAPER_UPDATE = 1 WHERE INTEGRATION_ID = '#new_invoice_number#'
                                </cfquery>
                                <cfcatch type="any">
                                    <cfdump  var="#cfcatch#">
                                    <cfabort>
                                </cfcatch>
                            </cftry>
                        </cfif>
                        <!---
                        #invoice_id# id'li faturanın numarası güncellendi. #invoice_number# --> #real_invoice_number#<br />
                        --->
                    </cfif>
                <cfelse>
                    <!---
                    #invoice_id# id'li faturanın uuid'si boşta kalmış. <br />
                    --->
                </cfif>

                <cfcatch>
                    <cfdump  var="#cfcatch#">
                    <cfabort>
                </cfcatch>
            </cftry>
        </cfif>
    </cfoutput>
</cfif>