<!---
    File: send_iptal_earchive.cfm
    Folder: V16\e_government\display\
	Controller: 
    Author:
    Date:
    Description:
        E-arşiv fatura iptal bilgisi gönderimi
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
<cfquery name="GET_COMP_INFO" datasource="#dsn#">
    SELECT
        OC.TAX_NO
    FROM 
        OUR_COMPANY OC
    WHERE 
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="GET_INVOICE_RELATION" datasource="#DSN2#">
	SELECT EARCHIVE_ID,STATUS,RELATION_ID,UUID,INTEGRATION_ID FROM EARCHIVE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#">
</cfquery>

<cfif attributes.action_type eq 'EXPENSE_ITEM_PLANS'><!--- Gelir fişi iptal EE20160208 --->
	<cfquery name="GET_INVOICE" datasource="#DSN2#">
    	SELECT 
            EIP.EXPENSE_DATE INVOICE_DATE,
            EIP.UPDATE_DATE,
            (EIP.TOTAL_AMOUNT/IM.RATE2) GROSSTOTAL,
            0 SA_DISCOUNT,
            0 ROW_DISCOUNT
        FROM 
        	EXPENSE_ITEM_PLANS EIP
            	LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = EIP.EXPENSE_ID AND IM.MONEY_TYPE = EIP.OTHER_MONEY 
        WHERE 
        	EIP.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
    </cfquery>
    
    <cfquery name="GET_INVOICE_KDV" datasource="#DSN2#">
    	SELECT 
        	TAX_AMOUNT
        FROM
        	(
            	SELECT
                	ROUND((EIR.AMOUNT/IM.RATE2),2) TAX_AMOUNT
                FROM
                	EXPENSE_ITEMS_ROWS EIR
                    	LEFT JOIN EXPENSE_ITEMS_ROWS EIRR ON EIRR.EXPENSE_ID = EIR.EXPENSE_ID AND EIRR.EXP_ITEM_ROWS_ID <> EIR.EXP_ITEM_ROWS_ID
                		LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = EIR.INVOICE_ID AND IM.MONEY_TYPE = EIR.MONEY_CURRENCY_ID,
                    #dsn3_alias#.PRODUCT_PERIOD PP
                WHERE
                	PP.PRODUCT_ID = EIR.PRODUCT_ID AND 
					PP.TAX_CODE IS NOT NULL AND
					PP.PERIOD_ID = #session.ep.period_id# AND
					EIR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
            ) T1
        GROUP BY 
            TAX_AMOUNT
      </cfquery>
<cfelse><!--- Fatura İptal --->
	<cfquery name="GET_INVOICE" datasource="#DSN2#">
        SELECT 
            I.INVOICE_DATE,
            I.UPDATE_DATE,
            (I.GROSSTOTAL/IM.RATE2) GROSSTOTAL,
            ISNULL(ROUND((I.SA_DISCOUNT/IM.RATE2),2),0) SA_DISCOUNT,
            (SELECT ISNULL((SUM(DISCOUNTTOTAL)/IM.RATE2),0) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID = I.INVOICE_ID) ROW_DISCOUNT 
        FROM 
            INVOICE I
            	LEFT JOIN #dsn2_alias#.INVOICE_MONEY IM ON IM.ACTION_ID = I.INVOICE_ID AND IM.MONEY_TYPE = I.OTHER_MONEY 
        WHERE 
            I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND ISNULL(I.IS_IPTAL,0) = 1
    </cfquery>
    
    <cfquery name="GET_INVOICE_KDV" datasource="#DSN2#">
        SELECT
            TAX_AMOUNT
        FROM
        (
            SELECT 
                ROUND((IR.NETTOTAL/IM.RATE2),2) TAX_AMOUNT
            FROM 
                INVOICE_ROW IR
                    LEFT JOIN INVOICE_ROW IRR ON IRR.INVOICE_ID = IR.INVOICE_ID AND IRR.INVOICE_ROW_ID <> IR.INVOICE_ROW_ID
                    LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                #dsn3_alias#.PRODUCT_PERIOD PP
            WHERE 
                PP.PRODUCT_ID = IR.PRODUCT_ID AND 
                PP.TAX_CODE IS NOT NULL AND
                PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> 
        ) T1
        GROUP BY 
            TAX_AMOUNT
     </cfquery>
</cfif>

<cfquery name="GET_ROW_TAX" dbtype="query">
	SELECT SUM(TAX_AMOUNT) TAX_AMOUNT FROM GET_INVOICE_KDV
</cfquery>
<cfif not get_row_tax.recordcount>
	<cfset row_tax_amount_ = 0>
<cfelse>
	<cfset row_tax_amount_ = get_row_tax.tax_amount>
</cfif>

<cfif get_invoice.recordcount>
    <cfif get_our_company.EARCHIVE_TYPE_ALIAS eq 'dp'><!--- DP --->
    	<cfif get_our_company.earchive_test_system eq 1>
			<cfset web_service_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/IntegrationService.asmx'>
        <cfelse>
            <cfset web_service_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
        </cfif>
        
        <cfset save_folder      = "#upload_folder#e_government#dir_seperator#xml" />

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
                <cf_get_lang dictionary_id='30628.Ticket Alma Sırasında Bir Hata Meydana Geldi'> !<br /><cfabort>
            </cfcatch>
        </cftry>
        
        <cfxml variable="sendCancelEArchive" casesensitive="no"><cfoutput>
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
           <soapenv:Header/>
           <soapenv:Body>
              <tem:CancelEArchiveInvoice>
                 <!--Optional:-->
                 <tem:Ticket>#Ticket#</tem:Ticket>
                 <!--Optional:-->
                 <tem:Value>#get_invoice_relation.uuid#</tem:Value>
                 <!--Optional:-->
                 <tem:Type>UUID</tem:Type>
                 <tem:TotalAmount>0</tem:TotalAmount><!--- 0 gönderilir ise faturadaki tutar entegratör tarafından hesaplanır #NumberFormat(get_invoice.grosstotal-row_tax_amount_ -(get_invoice.sa_discount+get_invoice.row_discount),"_.00")#--->
                 <tem:CancelDate>#DateFormat(dateadd('h',session.ep.time_zone,now()),"yyyy-mm-dd")#T#TimeFormat(dateadd('h',session.ep.time_zone,now()),"HH:MM:SS")#Z</tem:CancelDate>
              </tem:CancelEArchiveInvoice>
           </soapenv:Body>
        </soapenv:Envelope>
		</cfoutput></cfxml>
        
        <cfhttp url="#web_service_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/CancelEArchiveInvoice">
            <cfhttpparam type="header" name="content-length" value="#len(sendCancelEArchive)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(sendCancelEArchive)#">
        </cfhttp>
        
        <cftry>
        	<cfset result = xmlParse(httpResponse.FileContent).Envelope.Body.CancelEArchiveInvoiceResponse.CancelEArchiveInvoiceResult.ServiceResult.XmlText>
            <cfset error_code = xmlParse(httpResponse.FileContent).Envelope.Body.CancelEArchiveInvoiceResponse.CancelEArchiveInvoiceResult.ErrorCode.XmlText>
            <cfif result eq "Successful" or listfind("34",error_code)><!--- 34 :Fatura Daha önceden gönderilmiş ise --->
                <cfquery name="UPD_EARCHIVE" datasource="#DSN2#">
                    UPDATE 
                        EARCHIVE_RELATION 
                    SET
                        IS_CANCEL=1,
                        CANCEL_DESCRIPTION= 'E-Arşiv Fatura İptal Edildi!',
                        CANCEL_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        CANCEL_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">		 
                    WHERE 
                        RELATION_ID = #get_invoice_relation.relation_id#
                </cfquery>
            <cfelse>
              	<cfset cancel_detail = xmlParse(httpResponse.FileContent).Envelope.Body.CancelEArchiveInvoiceResponse.CancelEArchiveInvoiceResult.ServiceResultDescription.XmlText>
                <cfquery name="UPD_EARCHIVE" datasource="#DSN2#">
                    UPDATE 
                        EARCHIVE_RELATION 
                    SET
                        CANCEL_DESCRIPTION= <cfqueryparam cfsqltype="cf_sql_varchar" value="#cancel_detail#">,
                        CANCEL_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        CANCEL_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">	 
                    WHERE 
                        RELATION_ID = #get_invoice_relation.relation_id#
                </cfquery>
				<cfoutput><cf_get_lang dictionary_id='59841.E-Arşiv Fatura İptalinde Hata Meydana Geldi'>! <br/> <cf_get_lang dictionary_id='58685.Hata Açıklaması'> : (#error_code#)#cancel_detail#</cfoutput><cfabort>
            </cfif> 
        <cfcatch type="any">
        	<cfoutput><cf_get_lang dictionary_id='59841.E-Arşiv Fatura İptalinde Hata Meydana Geldi'>!</cfoutput><cfabort>
        </cfcatch>
        </cftry>
    <cfelseif get_our_company.EARCHIVE_TYPE_ALIAS eq 'spr'>
        <cfset soap = createObject("Component","V16.e_government.cfc.super.earchive.soap")>
        <cfset soap.init()>
        <cfset GetInvoice = soap.CancelInvoice(uuid: GET_INVOICE_RELATION.uuid)>
        <cftry>
            <cfif GetInvoice.Status eq "Successful" ><!--- 34 :Fatura Daha önceden gönderilmiş ise --->
                <cfquery name="UPD_EARCHIVE" datasource="#DSN2#">
                    UPDATE 
                        EARCHIVE_RELATION 
                    SET
                        IS_CANCEL=1,
                        CANCEL_DESCRIPTION= 'E-Arşiv Fatura İptal Edildi!',
                        CANCEL_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        CANCEL_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">		 
                    WHERE 
                        RELATION_ID = #get_invoice_relation.relation_id#
                </cfquery>
            <cfelse>
                <cfquery name="UPD_EARCHIVE" datasource="#DSN2#">
                    UPDATE 
                        EARCHIVE_RELATION 
                    SET
                        CANCEL_DESCRIPTION= <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetInvoice.status_description#">,
                        CANCEL_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        CANCEL_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">	 
                    WHERE 
                        RELATION_ID = #get_invoice_relation.relation_id#
                </cfquery>
				<cfoutput><cf_get_lang dictionary_id='59841.E-Arşiv Fatura İptalinde Hata Meydana Geldi'>! <br/> <cf_get_lang dictionary_id='58685.Hata Açıklaması'> :#GetInvoice.status_description#</cfoutput><cfabort>
            </cfif> 
        <cfcatch type="any">
        	<cfoutput><cf_get_lang dictionary_id='59841.E-Arşiv Fatura İptalinde Hata Meydana Geldi'>!</cfoutput><cfabort>
        </cfcatch>
        </cftry>
    <cfelseif get_our_company.EARCHIVE_TYPE_ALIAS eq 'dgn'>
        <cfset soap = createObject("Component","V16.e_government.cfc.dogan.earsiv.soap")>
        <cfset soap.init()>
        <cfset GetInvoice = soap.CancelInvoice(uuid: GET_INVOICE_RELATION.uuid)>
        <cftry>
            <cfif GetInvoice.Status eq 0 >
                <cfquery name="UPD_EARCHIVE" datasource="#DSN2#">
                    UPDATE 
                        EARCHIVE_RELATION 
                    SET
                        IS_CANCEL=1,
                        CANCEL_DESCRIPTION= 'E-Arşiv Fatura İptal Edildi!',
                        CANCEL_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        CANCEL_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">		 
                    WHERE 
                        RELATION_ID = #get_invoice_relation.relation_id#
                </cfquery>
            <cfelse>
                <cfquery name="UPD_EARCHIVE" datasource="#DSN2#">
                    UPDATE 
                        EARCHIVE_RELATION 
                    SET
                        CANCEL_DESCRIPTION= <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetInvoice.status_description#">,
                        CANCEL_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        CANCEL_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">	 
                    WHERE 
                        RELATION_ID = #get_invoice_relation.relation_id#
                </cfquery>
				<cfoutput><cf_get_lang dictionary_id='59841.E-Arşiv Fatura İptalinde Hata Meydana Geldi'>! <br/> <cf_get_lang dictionary_id='58685.Hata Açıklaması'> :#GetInvoice.status_description#</cfoutput><cfabort>
            </cfif> 
        <cfcatch type="any">
        	<cfoutput><cf_get_lang dictionary_id='59841.E-Arşiv Fatura İptalinde Hata Meydana Geldi'>!</cfoutput><cfabort>
        </cfcatch>
        </cftry>
    <cfelse>
        <script type="text/javascript">
            alert("Lütfen Entegrasyon Firma Tanımlarını Kontrol Ediniz!");
        </script>
    </cfif>  
    <script type="text/javascript">
        window.opener.location.reload(true);
        window.close();
    </script> 
<cfelse>
	<script type="text/javascript">
        alert("<cf_get_lang dictionary_id='54647.Fatura Bulunamadı'>. <cf_get_lang dictionary_id='59842.Lütfen Kaydı Kontrol Ediniz'> !");
        window.close();
    </script>
</cfif>