<!---
    File: return_detail.cfm
    Folder: V16\e_government\display\
	Controller: 
    Author: 
    Date: 
    Description:
        
    History:
        Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com 2020-03-13 02:26:54
        E-devlet standart modüle taşındı.
        DTP dışındaki diğer entegratörler kaldırıldı.
    To Do:

--->

<cfif session.ep.admin>
	<a href="javascript://" onclick="window.location.assign('<cfoutput>#request.self#?fuseaction=invoice.popup_return_detail&action_id=#attributes.action_id#&action_type=#attributes.action_type#&re_query=true','wide');</cfoutput>" style="float:right; margin:5px">	
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="59829.Tekrar Sorgula"></cfsavecontent>
        <img src="images/refresh.png" height="17" align="absmiddle" title="Tekrar Sorgula">
	</a>
</cfif>

<cf_popup_box title="Dönüş Değerleri">
<cfif isDefined("attributes.re_query")>
	<cfquery name="upd_einvoice_rel" datasource="#dsn2#">
        UPDATE
            EINVOICE_RELATION
        SET
            STATUS = NULL,
            STATUS_CODE = NULL,
            STATUS_DESCRIPTION = NULL,
            STATUS_DATE = NULL                           
        WHERE
            ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
            ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#">
    </cfquery>
</cfif>
    <cfscript>
		get_our_company_tmp= createObject("component","V16.e_government.cfc.einvoice");//E-Fatura Tanımlarını cfc'den alıyor.
		get_our_company_tmp.dsn = dsn;
		get_our_company = get_our_company_tmp.get_our_company_fnc(company_id:session.ep.company_id); 
		
		get_invoice_relation_tmp= createObject("component","V16.e_government.cfc.einvoice");//E-Fatura İlişki Tablosundan kayda ait değerler çekiliyor.
		get_invoice_relation_tmp.dsn2 = dsn2;
		get_invoice_relation = get_invoice_relation_tmp.get_invoice_relation(action_id:attributes.action_id, action_type:attributes.action_type, invoice_type:'einvoice');
	</cfscript>

	<cfif len(get_invoice_relation.status)>
        <cf_medium_list>
            <thead>
                <tr>
                    <th style="width:180px"><cf_get_lang dictionary_id="59825.Workcube Referans"> <cf_get_lang dictionary_id="58527.ID"></th>
                    <th style="width:120px"><cf_get_lang dictionary_id="29872.E-Fatura"> <cf_get_lang dictionary_id="58527.ID"></th>                                
                    <th style="width:40px"><cf_get_lang dictionary_id="32646.Kodu"></th>
                    <th><cf_get_lang dictionary_id="57629.Açıklama"></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput>
                    <tr>
                        <td>#get_invoice_relation.einvoice_id#</td>
                        <td>#get_invoice_relation.integration_id#</td>
                        <td>#get_invoice_relation.status_code#</td>
                        <td><cfif len(get_invoice_relation.status_description)>#get_invoice_relation.status_description#<cfelse>#get_invoice_relation.status#</cfif></td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_medium_list>
    <cfelse>
        <cfif get_our_company.einvoice_type eq get_invoice_relation.sender_type>
            <!--- Digital Planet--->
            <cfif get_our_company.einvoice_type eq 3>
                <cfif get_our_company.einvoice_test_system eq 1>
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
                        <tem:CorporateCode>#get_our_company.EINVOICE_COMPANY_CODE#</tem:CorporateCode>
                        <tem:LoginName>#get_our_company.EINVOICE_USER_NAME#</tem:LoginName>
                        <tem:Password><![CDATA[#get_our_company.EINVOICE_PASSWORD#]]></tem:Password>
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

                <cfsavecontent variable="invoice_data"><cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                   <soapenv:Header/>
                   <soapenv:Body>
                      <tem:CheckInvoiceState>
                         <tem:Ticket>#Ticket#</tem:Ticket>
                         <tem:UUID>#get_invoice_relation.UUID#</tem:UUID>
                      </tem:CheckInvoiceState>
                   </soapenv:Body>
                </soapenv:Envelope></cfoutput>
                </cfsavecontent>

                <cfhttp url="#web_service_url#" method="post" result="httpResponse">
                    <cfhttpparam type="header" name="content-type" value="text/xml">
                    <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/CheckInvoiceState">
                    <cfhttpparam type="header" name="content-length" value="#len(invoice_data)#">
                    <cfhttpparam type="header" name="charset" value="utf-8">
                    <cfhttpparam type="xml" name="message" value="#trim(invoice_data)#">
                </cfhttp>

                <cfscript>
                    soapResponse        = xmlParse(httpResponse.Filecontent).Envelope.Body.CheckInvoiceStateResponse.CheckInvoiceStateResult;
                    StatusCode          = soapResponse.StatusCode.XmlText;
                    StatusDescription   = soapResponse.StatusDescription.XmlText;
                    if(StatusCode is '49' And StatusDescription is 'SİLİNMİŞ FATURA'){
                        Error_code = 'Fatura Entegratör Sisteminde Bulunamadı, Fatura Bağlantıları Silindi, Yeniden Gönderebilirsiniz';
                        queryExecute("DELETE FROM EINVOICE_RELATION WHERE ACTION_ID = #attributes.action_id# AND ACTION_TYPE = '#attributes.action_type#'",{},{datasource:'#dsn2#'});
                        queryExecute("DELETE FROM EINVOICE_SENDING_DETAIL WHERE ACTION_ID = #attributes.action_id# AND ACTION_TYPE = '#attributes.action_type#'",{},{datasource:'#dsn2#'});
                    }
                    else{
                        upd_einvoice_relation_tmp= createObject("component","V16.e_government.cfc.einvoice");
                        upd_einvoice_relation_tmp.dsn2 = dsn2;
                        upd_einvoice_relation_tmp.upd_einvoice_relation_fnc(
                            uuid:get_invoice_relation.uuid,
                            profile_id:get_invoice_relation.profile_id,
                            StatusCode:StatusCode,
                            CheckInvoiceStateResult:StatusDescription,
                            einvoice_type:get_our_company.einvoice_type);
                        Error_code = StatusDescription;
                    }
                </cfscript>
            <cfelse>
                <cfset Error_code = 'Entegrasyon Firma Tanımlarını Kontrol Ediniz ' />
            </cfif>
        <cfelse>
            <cfset Error_code = '<cf_get_lang dictionary_id="59831.Sorgulamak İstediğiniz Faturanın Entegratör Tipi İle Kullanılan Entegratör Tipi Farklı Olduğundan Durum Sorgulama Yapılamaz">' />
        </cfif>
        <table>
            <tr>
                <td style="color:#F00;font-weight:700"><cfoutput><span>#Error_code#!</span></cfoutput></td>
            </tr>
        </table>
    </cfif>
</cf_popup_box>
<script type="text/javascript">
    $(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });
</script>