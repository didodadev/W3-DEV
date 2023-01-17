<!---
    File: 
    Folder: 
	Controller: 
    Author: 
    Date: 
    Description:
        Bu rapor ile giden e-faturaların durumları sorgulanır.
    History:
        BK 20141012 Temel ve Ticari Fatura Durum Sorgulamasi Yapar. Son bir ay icinde gonderilmis faturalar icin calisir.
		attributes.year parametresi kullanılırsa gecmis donemdeki fatura durumları guncellenir.
		Gecmis donem rapor kullanımı : http://wrk/index.cfm?fuseaction=report.detail_report&year=2014&report_id=120
    To Do:

--->

<cfscript>
	get_einv_comp_tmp= createObject("component","V16.e_government.cfc.einvoice");
	get_einv_comp_tmp.dsn = dsn;
	get_einv_comp = get_einv_comp_tmp.get_our_company_fnc(einvoice_type:3);
</cfscript>

<cfloop query="GET_EINV_COMP">
	<cfif einvoice_test_system eq 1>
        <cfset dp_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/IntegrationService.asmx'>    
    <cfelse>
        <cfset dp_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
    </cfif>

    <cfif not isdefined("attributes.year")>
    	<cfif get_einv_comp.special_period eq 0>
        	<cfset temp_dsn2 = '#dsn#_#year(now())#_#get_einv_comp.comp_id#'>
        <cfelse>
            <cfquery name="GET_PERIOD" datasource="#dsn#">
                SELECT 
                    PERIOD_YEAR 
                FROM 
                    SETUP_PERIOD 
                WHERE 
                    FINISH_DATE >= #createdate(year(now()),month(now()),day(now()))# AND
                    START_DATE <= #createdate(year(now()),month(now()),day(now()))#						
            </cfquery>
    		<cfset temp_dsn2 = '#dsn#_#get_period.period_year#_#get_einv_comp.comp_id#'>
       	</cfif>
    <cfelse>
    	<cfset temp_dsn2 = '#dsn#_#attributes.year#_#get_einv_comp.comp_id#'>
    </cfif> 
    
    <cfset upd_einvoice_relation_array2 = ArrayNew(1)>
    
    <cfquery name="GET_INVOICE_DET" datasource="#temp_dsn2#">
        SELECT 
            ER.UUID,
            ER.STATUS,
            ER.PROFILE_ID,
            ER.INTEGRATION_ID,
            I.INVOICE_NUMBER
        FROM 
            EINVOICE_RELATION ER,
            INVOICE I
        WHERE 
            --ER.STATUS IS NULL AND
            ER.ACTION_ID = I.INVOICE_ID AND
            ER.SENDER_TYPE = 3 AND
            <cfif isdefined("attributes.all")><!--- Son bir ay icinde gonderilen faturalar --->
	            ER.RECORD_DATE > DATEADD(MM, -1, GETDATE()) 
            <cfelse>
	            ER.RECORD_DATE > DATEADD(DD, -8, GETDATE()) 
            </cfif>
    </cfquery>

    <cfif get_invoice_det.recordcount>
        <!--- Ticket almak icin gerekli XML formati hazirlaniyor --->
		<cfxml variable="ticket_data"><cfoutput>
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
		<soapenv:Header/>
		<soapenv:Body>
			<tem:GetFormsAuthenticationTicket>
				<tem:CorporateCode>#get_einv_comp.EINVOICE_COMPANY_CODE#</tem:CorporateCode>
				<tem:LoginName>#get_einv_comp.EINVOICE_USER_NAME#</tem:LoginName>
				<tem:Password><![CDATA[#get_einv_comp.EINVOICE_PASSWORD#]]></tem:Password>
			</tem:GetFormsAuthenticationTicket>
		</soapenv:Body>
		</soapenv:Envelope></cfoutput>
		</cfxml>
        
        <!--- Tek seferlik ticket alınıyor ---> 
        <cfhttp url="#dp_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
            <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
        </cfhttp>
        <cfset Ticket = xmlParse(httpResponse.filecontent)>
        <cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
        <table>
        <cfloop query="GET_INVOICE_DET">
           	<cfsavecontent variable="invoice_data"><cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
            <soapenv:Header/>
                <soapenv:Body>
                  <tem:CheckInvoiceState>
                     <tem:Ticket>#Ticket#</tem:Ticket>
                     <tem:UUID>#get_invoice_det.uuid#</tem:UUID>
                  </tem:CheckInvoiceState>
                </soapenv:Body>
            </soapenv:Envelope></cfoutput>
            </cfsavecontent>
    
            <cfhttp url="#dp_url#" method="post" result="httpResponse">
                <cfhttpparam type="header" name="content-type" value="text/xml">
                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/CheckInvoiceState">
                <cfhttpparam type="header" name="content-length" value="#len(invoice_data)#">
                <cfhttpparam type="header" name="charset" value="utf-8">
                <cfhttpparam type="xml" name="message" value="#trim(invoice_data)#">
            </cfhttp>
            
            <cftry>
				<cfset CheckInvoiceStateResult = xmlParse(httpResponse.Filecontent).Envelope.Body.CheckInvoiceStateResponse.CheckInvoiceStateResult.StatusDescription.XmlText>
                <cfset StatusCode = xmlParse(httpResponse.Filecontent).Envelope.Body.CheckInvoiceStateResponse.CheckInvoiceStateResult.StatusCode.XmlText>
                <cfscript>
                //Ticari ve Temel fatura sorgulaması//
                    upd_einvoice_relation_tmp= createObject("component","V16.e_government.cfc.einvoice");
                    upd_einvoice_relation_tmp.dsn2 = temp_dsn2;
                    upd_einvoice_relation = upd_einvoice_relation_tmp.upd_einvoice_relation_fnc(uuid:GET_INVOICE_DET.uuid,profile_id:GET_INVOICE_DET.profile_id,StatusCode:StatusCode,CheckInvoiceStateResult:CheckInvoiceStateResult,einvoice_type:get_einv_comp.einvoice_type);
                </cfscript>
                
                <tr>
                    <cfoutput>
                    <td>#get_invoice_det.invoice_number#</td>
                    <td><b>#CheckInvoiceStateResult#</b></td>
                    </cfoutput>
                </tr> 
            <cfcatch>
            </cfcatch>
            </cftry>
        </cfloop>
		<cfif ArrayLen(upd_einvoice_relation_array2)>
            <cfset upd_einvoice_relation_array2 = ArrayToList(upd_einvoice_relation_array2,"#chr(13)&chr(10)#")><!---  SQL cumlesi liste olarak olustu --->
           	<cfquery name="upd_einvoice_relation_" datasource="#temp_dsn2#">
                #PreserveSingleQuotes(upd_einvoice_relation_array2)#
            </cfquery>
        </cfif>           
        </table>
    <cfelse>
        (<cfoutput>#COMPANY_NAME#</cfoutput>) şirketinde gönderim detayı sorgulanacak fatura bulunamadı!<br />
    </cfif>
</cfloop>