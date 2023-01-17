<!---
    File: change_invoice_status.cfm
    Folder: V16\e_government\display
    Author:
    Date:
    Description:
        E-fatura red bilgisini entegratör sisteme gönderir.
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
        14.04.2020 Gramoni-Mahmut Çifçi - DTP dışındaki enegratörler kaldırıldı
    To Do:

--->

<cfsetting showdebugoutput="no">
<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
	SELECT
		OC.EINVOICE_COMPANY_CODE,
        OC.EINVOICE_TEST_SYSTEM,
        OC.EINVOICE_RECEIVER_ALIAS,
        OC.EINVOICE_USER_NAME,
        OC.EINVOICE_PASSWORD,
		O.TAX_NO,
        OC.EINVOICE_SENDER_ALIAS,
        OC.EINVOICE_TYPE,
        OC.EINVOICE_TYPE_ALIAS
	FROM
		OUR_COMPANY_INFO OC,
       	OUR_COMPANY O
	WHERE
    	O.COMP_ID = OC.COMP_ID AND
		OC.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery> 

<cfquery name="GET_RECEIVING_DETAIL" datasource="#DSN2#">
	SELECT
		*
	FROM
		EINVOICE_RECEIVING_DETAIL
	WHERE
		RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#"> AND
        PROFILE_ID = 'TICARIFATURA'
</cfquery>

<!--- Portal Red Islemi Sadece tabloda guncelleme yapilacak---> 
<cfif GET_OUR_COMPANY.einvoice_type eq 1>
	<cfquery name="UPD_STATUS" datasource="#DSN2#">
		UPDATE 
			EINVOICE_RECEIVING_DETAIL
		SET
			UPDATE_DATE = #now()#,
            IS_PROCESS = 1,
			STATUS = 0
		WHERE
			RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
	</cfquery>
	<script type="text/javascript">
		alert('Fatura Red Edildi !');
		window.opener.location.reload(true);
		window.close();
	</script>
<!--- Digital Planet Red İslemi---> 
<cfelseif GET_OUR_COMPANY.EINVOICE_TYPE_ALIAS eq 'dp'>
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
    
    <!--- Ticket ---> 
    <cfhttp url="#web_service_url#" method="post" result="httpResponse">
        <cfhttpparam type="header" name="content-type" value="text/xml">
        <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
        <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
        <cfhttpparam type="header" name="charset" value="utf-8">
        <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
    </cfhttp>

    <cfset Ticket = xmlParse(httpResponse.filecontent)>
    <cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
	
	<!--- Gelen Fatura Red Servisi --->
    <cfxml variable="soapRejectInvoice"><cfoutput>
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
        <soapenv:Header/>
            <soapenv:Body>
              <tem:RejectInvoice>
                 <tem:Ticket>#Ticket#</tem:Ticket>
                 <tem:UUID>#get_receiving_detail.uuid#</tem:UUID>
                 <tem:Description><cfif len(get_receiving_detail.detail)>#get_receiving_detail.detail#<cfelse><cf_get_lang dictionary_id='54645.Red Edildi'></cfif></tem:Description>
              </tem:RejectInvoice>
            </soapenv:Body>
        </soapenv:Envelope>
    </cfoutput>
	</cfxml> 
    
    <cfhttp url="#web_service_url#" method="post" result="RejectInvoice">
        <cfhttpparam type="header" name="content-type" value="text/xml">
        <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/RejectInvoice">
        <cfhttpparam type="header" name="content-length" value="#len(soapRejectInvoice)#">
        <cfhttpparam type="header" name="charset" value="utf-8">
        <cfhttpparam type="xml" name="message" value="#trim(soapRejectInvoice)#">
    </cfhttp>

    <cftry>
        <cfset result = "#xmlparse(RejectInvoice.filecontent).Envelope.Body.RejectInvoiceResponse.RejectInvoiceResult.ServiceResult.XmlText#">
        <cfif result eq 'Successful'>
            <cfquery name="UPD_STATUS" datasource="#DSN2#">
                UPDATE 
                    EINVOICE_RECEIVING_DETAIL
                SET
                    UPDATE_DATE = #now()#,
                    IS_PROCESS = 1,
                    STATUS = 0
                WHERE
                    RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
            </cfquery>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='54646.Fatura Red Edildi'>!");
                window.opener.location.reload(true);
                window.close();
            </script>
            <cfabort>
        <cfelse>
        
        	<cfset result2 = "#xmlparse(RejectInvoice.filecontent).Envelope.Body.RejectInvoiceResponse.RejectInvoiceResult.ServiceResultDescription.XmlText#">
            <cfsavecontent variable="invoice_data"><cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                    <soapenv:Body>
                      <tem:CheckInvoiceState>
                         <tem:Ticket>#Ticket#</tem:Ticket>
                         <tem:UUID>#get_receiving_detail.uuid#</tem:UUID>
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
            
	    	<cfset result3 = "#xmlparse(httpResponse.filecontent).Envelope.Body.CheckInvoiceStateResponse.CheckInvoiceStateResult.StatusCode.XmlText#">
			<!--- Portal uzerinden Red islemi 9988 Kabul 9987--->
            <cfif result3 eq '9988'>
                <cfquery name="UPD_STATUS" datasource="#DSN2#">
                    UPDATE 
                        EINVOICE_RECEIVING_DETAIL
                    SET
                        UPDATE_DATE = #now()#,
                        IS_PROCESS = 1,
                        STATUS = 0
                    WHERE
                        RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
                </cfquery>
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id='54646.Fatura Red Edildi'>!");
                    window.opener.location.reload(true);
                    window.close();
                </script>
                <cfabort>
            <cfelse>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='54644.Fatura Red Edildirken Bir Hata Oluştu.'><cf_get_lang dictionary_id='40568.Hata Kodu'>:<cfoutput>#result2#</cfoutput>");
					window.close();
                </script>
                <cfabort>
        	</cfif>
        </cfif>
    <cfcatch>
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='54644.Fatura Red Edildirken Bir Hata Oluştu'>");
            window.close();
        </script>
        <cfabort>
    </cfcatch>
    </cftry>
<cfelseif GET_OUR_COMPANY.EINVOICE_TYPE_ALIAS eq 'dgn'>
    <cfset soap = createObject("Component","V16.e_government.cfc.dogan.efatura.soap")>
    <cfset soap.init()>
    <cfset common = createObject("Component","V16.e_government.cfc.dogan.efatura.common")>

    <cfset ticket = soap.GetFormsAuthentication()>

    <cfxml variable="invoice_response_data">
        <cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl">
                <soapenv:Header/>
                <soapenv:Body>
                    <wsdl:SendInvoiceResponseWithServerSignRequest>
                        <REQUEST_HEADER>
                            <SESSION_ID>#ticket#</SESSION_ID>
                        </REQUEST_HEADER>
                        <STATUS>RED</STATUS>
                        <INVOICE ID="#get_receiving_detail.einvoice_id#">
                        </INVOICE>
                    </wsdl:SendInvoiceResponseWithServerSignRequest>
                </soapenv:Body>
            </soapenv:Envelope>
        </cfoutput>
    </cfxml>

    <cftry>
        <cfset httpresult = soap.SendHttp("EFaturaOIB", "http://tempuri.org/SendInvoiceResponseWithServerSignRequest", invoice_response_data)>
        <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

        <cfset resultdata = structNew()>

        <cfif not structKeyExists(xmlresult.Envelope.Body, 'Fault')>
            <cfquery name="UPD_STATUS" datasource="#DSN2#">
                UPDATE 
                    EINVOICE_RECEIVING_DETAIL
                SET
                    UPDATE_DATE = #now()#,
                    IS_PROCESS = 1,
                    STATUS = 0
                WHERE
                    RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
            </cfquery>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='54646.Fatura Red Edildi'>!");
                window.opener.location.reload(true);
                window.close();
            </script>
            <cfabort>
        <cfelseif xmlresult.Envelope.Body.Fault.detail.RequestFault.ERROR_CODE.xmlText eq 2005>
            <cfquery name="UPD_STATUS" datasource="#DSN2#">
                UPDATE 
                    EINVOICE_RECEIVING_DETAIL
                SET
                    UPDATE_DATE = #now()#,
                    IS_PROCESS = 1,
                    STATUS = 0
                WHERE
                    RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
            </cfquery>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='54646.Fatura Red Edildi'>!");
                window.opener.location.reload(true);
                window.close();
            </script>
            <cfabort>
        <cfelse>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='54644.Fatura Red Edildirken Bir Hata Oluştu.'> Hata : <cfoutput>#xmlresult.Envelope.Body.Fault.detail.RequestFault.ERROR_SHORT_DES.xmlText#</cfoutput>");
                window.close();
            </script>
            <cfabort>
        </cfif>

        <cfcatch>
            Red işlemi esnasında bir hata oluştu. <br>
            Sistem yöneticisine bilgi veriniz. <br><br><br>
            <cfdump  var="#cfcatch#">
            <cfabort>
        </cfcatch>
    </cftry>
<cfelseif GET_OUR_COMPANY.EINVOICE_TYPE_ALIAS eq 'spr'>
    <cfset einv_common = createObject("component", "V16.e_government.cfc.super.einvoice.common")>
    <cfset einv_soap = createObject("component", "V16.e_government.cfc.super.einvoice.soap")>
    <cfset einv_soap.init()>
    <cfif len(get_receiving_detail.detail)><cfset message = '#get_receiving_detail.detail#'><cfelse><cfset message = '#getLang('','Red',54645)#'></cfif>
    <cfset result_service = einv_soap.InvoiceApproval(uuid : get_receiving_detail.UUID, responseType: 'Reject', message: message)>
    <cftry>
        <cfif result_service.return_code eq 0>
            <cfset result = 'Successful'> 
        </cfif>
        <cfif result eq 'Successful'>
            <cfquery name="UPD_STATUS" datasource="#DSN2#">
                UPDATE 
                    EINVOICE_RECEIVING_DETAIL
                SET
                    UPDATE_DATE = #now()#,
                    IS_PROCESS = 1,
                    STATUS = 0
                WHERE
                    RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
            </cfquery>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='54646.Fatura Red Edildi'>!");
                window.opener.location.reload(true);
                window.close();
            </script>
            <cfabort>
        <cfelse>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='54644.Fatura Red Edildirken Bir Hata Oluştu.'> Hata : <cfoutput>#xmlresult.Envelope.Body.Fault.detail.RequestFault.ERROR_SHORT_DES.xmlText#</cfoutput>");
                window.close();
            </script>
            <cfabort>
        </cfif>

        <cfcatch>
            Red işlemi esnasında bir hata oluştu. <br>
            Sistem yöneticisine bilgi veriniz. <br><br><br>
            <cfdump  var="#cfcatch#">
            <cfabort>
        </cfcatch>
    </cftry>
<cfelse>
    <cfdump  var="#GET_OUR_COMPANY.einvoice_type#">
</cfif>