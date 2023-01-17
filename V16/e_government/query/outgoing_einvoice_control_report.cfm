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
    
    <cfquery name="GET_INVOICE_DET" datasource="#temp_dsn2#">
        SELECT 
            ER.UUID,
            ER.STATUS,
            ER.PROFILE_ID,
            ER.INTEGRATION_ID,
            ER.RECORD_DATE,
            I.INVOICE_NUMBER,
            I.INVOICE_ID,
            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS NAME,
            C.FULLNAME,
            C.COMPANY_ID,
            CONS.CONSUMER_ID,
            CONS.CONSUMER_NAME,
            CONS.CONSUMER_SURNAME
        FROM 
            EINVOICE_RELATION ER,
            INVOICE I
            LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = I.COMPANY_ID
            LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID = I.CONSUMER_ID, 
            #dsn#.EMPLOYEES E
        WHERE 
            E.EMPLOYEE_ID = ER.RECORD_EMP AND
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
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='61724'></cfsavecontent>
        <cf_box title="#title#">
            <cf_grid_list>
                <thead>
                    <th width="10"></th>
                    <th><cf_get_lang dictionary_id='30525.Fatura No'></th>
                    <th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
                    <th><cf_get_lang dictionary_id='33800.Gönderim Tarihi'></th>
                    <th><cf_get_lang dictionary_id='48280.Gönderen Kişi'></th>
                    <th><cf_get_lang dictionary_id='57894.Statü'></th>
                    <th width="10"></th>
                </thead>
                <tbody>
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

                            <cfif StatusCode eq 41> <!--- gönderim onayı bekliyor --->
                                <cfset divColor = 'background-color:##fff4de;color:##ffa800;'>
                            <cfelseif StatusCode eq 1> <!--- gönderiliyor --->
                                <cfset divColor = 'background-color:##c9f7f5;color:##3699ff;'>
                            <cfelseif StatusCode eq 18> <!--- imza başarısız --->
                                <cfset divColor = 'background-color:##ffe2e5;color:##f64e60;'>
                            <cfelseif StatusCode eq 33> <!--- Maliyeye Gönderildi --->
                                <cfset divColor = 'background-color:##c9f7f5;color:##1bc5bd;'>
                            <cfelse>
                                <cfset divColor = 'background-color:##fff4de;color:##ffa800;'>
                            </cfif>
                            <cfscript>
                            //Ticari ve Temel fatura sorgulaması//
                                upd_einvoice_relation_tmp= createObject("component","V16.e_government.cfc.einvoice");
                                upd_einvoice_relation_tmp.dsn2 = temp_dsn2;
                                upd_einvoice_relation = upd_einvoice_relation_tmp.upd_einvoice_relation_fnc(uuid:GET_INVOICE_DET.uuid,profile_id:GET_INVOICE_DET.profile_id,StatusCode:StatusCode,CheckInvoiceStateResult:CheckInvoiceStateResult,einvoice_type:get_einv_comp.einvoice_type);
                            </cfscript>
                            <tr>
                                <cfoutput>
                                    <td>#currentrow#</td>
                                    <td>#get_invoice_det.invoice_number#</td>
                                    <td>
                                        <cfif len(get_invoice_det.company_id)>
                                            #get_invoice_det.FULLNAME#
                                        <cfelseif len(get_invoice_det.consumer_id)>
                                            #get_invoice_det.CONSUMER_NAME# #get_invoice_det.CONSUMER_SURNAME#
                                        </cfif>
                                    </td>
                                    <td>#dateFormat(get_invoice_det.record_date,dateformat_style)# #dateFormat(get_invoice_det.record_date,timeformat_style)#</td>
                                    <td>#get_invoice_det.NAME#</td>
                                    <td style="width:200px;">
                                        <div style="#divColor#" class="process text-center">
                                            <b>#CheckInvoiceStateResult#</b>
                                        </div>
                                    </td>
                                    <td><a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_invoice_det.INVOICE_ID#" target="_blank"><i class="icon-detail"></i></a></td>
                                </cfoutput>
                            </tr> 
                        <cfcatch>
                        </cfcatch>
                        </cftry>
                    </cfloop>
                </tbody>
            </cf_grid_list>
        </cf_box>
    <cfelse>
        <cf_box title="#title#">
            <cf_grid_list>
                <tr>
                    <td>Listelenecek herhangi bir fatura bulunamadı</td>
                </tr>
            </cf_grid_list>
        </cf_box>
    </cfif>
</cfloop>