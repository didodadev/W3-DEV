<!---
    File: 
    Folder: 
	Controller: 
    Author: 
    Date: 
    Description:
        Bu rapor ile mükellefler sistemde güncellenir.
    History:
        06.05.2020 Gramoni-Mahmut Çifçi - Mükerrer mükellef aktarımı yapılmaması için kontrol eklendi
    To Do:

--->
<cf_box title="#getlang('','E-Fatura Mükellef Aktarım','65484')#">
    <cfform name="einvoice_taxpayer" method="post" action="#request.self#?fuseaction=account.einvoice_taxpayer">
        <input type="hidden" name="is_submitted" id="is_submitted" value="1">
            <div class="form-group">
            <cf_get_lang dictionary_id="65482.Bu rapor çalıştırıldığında sisteminizde kayıtlı bireysel ve kurumsal hesapların e-fatura mükellefiyet durumları kontrol edilerek güncellenir, hesaplara ait aliaslar webservisler yolu içe çekilir.">
        </div>  
        <div class="form-group">  
            <cf_get_lang dictionary_id="65483.Lütfen Rapor çalıştırıldığında tamamlanmadan ilgili sekmeyi kapatmayınız, raporun çalışması zaman alabilir.">
        </div> 
                <cf_box_footer>
                <cf_workcube_buttons button_type="1" add_function='kontrol(0)' insert_info="#getlang('','Çalıştır','57911')#">
                <cf_workcube_buttons button_type="1" add_function='kontrol(1)' insert_info="#getlang('','Tümü İçin','65485')# #getlang('','Çalıştır','57911')#">
                </cf_box_footer>
     
    </cfform>
    <cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
        <cfscript>
            get_einv_comp_tmp= createObject("component","V16.e_government.cfc.einvoice");
            get_einv_comp_tmp.dsn = dsn;
            get_einv_comp = get_einv_comp_tmp.get_our_company_fnc(einvoice_type:3,first_company:1);
        </cfscript>
        <cfquery name="UPD_COMPANY" datasource="#DSN#">
            UPDATE COMPANY SET TAXNO = NULL WHERE TAXNO = ''
        </cfquery>
    
        <cfset temp_earchive = 0>
    
        <cfquery name="GET_EARCHIVE_COLUMN" datasource="#DSN#">
            SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OUR_COMPANY_INFO' AND COLUMN_NAME = 'IS_EARCHIVE'
        </cfquery>
        <cfif get_earchive_column.recordcount>
            <cfquery name="GET_EARCHIVE" datasource="#DSN#">
                SELECT IS_EARCHIVE FROM OUR_COMPANY_INFO WHERE IS_EARCHIVE = 1
            </cfquery>
            <cfif get_earchive.recordcount>
                <cfset temp_earchive = 1>
            </cfif>
        </cfif>
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
        <cfif get_einv_comp.einvoice_test_system eq 1>
            <cfset dp_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/integrationservice.asmx'>
        <cfelse>
            <cfset dp_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
        </cfif>
        <!--- Mükellef listesi icin gerekli tek seferlik ticket alınıyor ---> 
        <cfhttp url="#dp_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
            <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
        </cfhttp>
    
        <cfscript>
            Ticket = xmlParse(httpResponse.filecontent);
            Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText;
            if (not isdefined("attributes.all")) {
                startdate = "#dateformat(dateadd('d',-1,now()),'yyyy-mm-dd')#";
            }
            else {
                startdate = "2010-01-01";
            }
        </cfscript>
    
        <cfsavecontent variable="invoice_data"><cfoutput>
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
        <soapenv:Header/>
        <soapenv:Body>
            <tem:GetTaxIdListbyDate>
                <tem:Ticket>#Ticket#</tem:Ticket>
                <tem:StartDate>#startdate#</tem:StartDate>
            </tem:GetTaxIdListbyDate>
        </soapenv:Body>
        </soapenv:Envelope>
        </cfoutput>
        </cfsavecontent>
    
        <!--- Mukellef listesi alınıyor --->
        <cfhttp url="#dp_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetTaxIdListbyDate">
            <cfhttpparam type="header" name="content-length" value="#len(invoice_data)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(invoice_data)#">
        </cfhttp>
    
        <cftry>
            <cfset item =  xmlParse(httpResponse.Filecontent).Envelope.Body.GetTaxIdListbyDateResponse.GetTaxIdListbyDateResult.CustomerInfoList.EInvoiceCustomerResult>
            <cfset line_count = arraylen(item)>
            <cfcatch>
                <cfset line_count = 0>
            </cfcatch>
        </cftry>
    
        <cfif line_count gt 0>
            <cfset upd_einvoice_company_import_array = ArrayNew(1) />
            <cfset row_count = 500 />
            
            <!---Tum Mukelleflerin Aktarımı--->	
            <cfif isdefined("attributes.all")>
                <cfquery datasource="#DSN#">
                    TRUNCATE TABLE EINVOICE_COMPANY_IMPORT
                </cfquery>
            </cfif>   
            <cfloop from="1" to="#line_count#" index="xml_ind">
                <cfscript>
                    tax_no[xml_ind]             = item[xml_ind].TaxIdOrPersonalId.xmlText;
                    alias[xml_ind]              = item[xml_ind].Alias.xmlText;
                    company_full_name[xml_ind]  = left(replace(item[xml_ind].Name.xmlText,'#chr(39)#',' ','all'),250);
                    type[xml_ind]               = item[xml_ind].Type.xmlText;
                    register_date[xml_ind]      = CreateODBCDateTime(replace(item[xml_ind].RegisterTime.xmlText,"T"," "));
                    alias_creation_date[xml_ind]= CreateODBCDateTime(replace(item[xml_ind].AliasCreateDate.xmlText,"T"," "));
    
                    upd_einvoice_company_import_array[xml_ind mod row_count+1] = "
                    IF NOT EXISTS(SELECT EINVOICE_COMP_ID FROM EINVOICE_COMPANY_IMPORT WHERE TAX_NO = '#tax_no[xml_ind]#' AND ALIAS = '#alias[xml_ind]#')
                    BEGIN
                    INSERT INTO
                        EINVOICE_COMPANY_IMPORT
                    (
                        TAX_NO,
                        ALIAS,
                        COMPANY_FULLNAME,
                        TYPE,
                        REGISTER_DATE,
                        ALIAS_CREATION_DATE
                    )
                        VALUES
                    (
                        '#tax_no[xml_ind]#',
                        '#alias[xml_ind]#',
                        '#company_full_name[xml_ind]#',
                        '#type[xml_ind]#',
                        #register_date[xml_ind]#,
                        #alias_creation_date[xml_ind]#
                    )
                    END";
                </cfscript>
                <cfif xml_ind mod row_count eq 0>
                    <cfset upd_einvoice_company_import_array = ArrayToList(upd_einvoice_company_import_array,"#chr(13)&chr(10)#") />
                    <cfquery datasource="#dsn#">
                        #PreserveSingleQuotes(upd_einvoice_company_import_array)#
                    </cfquery>
                    <cfset upd_einvoice_company_import_array = ArrayNew(1) />
                </cfif> 
            </cfloop>
            <cfif ArrayLen(upd_einvoice_company_import_array)>
                <cfset upd_einvoice_company_import_array = ArrayToList(upd_einvoice_company_import_array,"#chr(13)&chr(10)#") />
                <cfquery datasource="#dsn#">
                    #PreserveSingleQuotes(upd_einvoice_company_import_array)#
                </cfquery>
            </cfif>
        
        <!---Kurumsal uye guncelleme--->    
            <cfquery name="UPD_COMP" datasource="#DSN#" result="xxx2">
                UPDATE COMPANY SET USE_EFATURA = 0, IS_CIVIL_COMPANY = 0, <cfif temp_earchive eq 1>USE_EARCHIVE = 1,</cfif>EFATURA_DATE = NULL
            </cfquery>
            
            <cfquery name="UPD_COMP" datasource="#DSN#" result="xxx">
                UPDATE 
                    C
                SET 
                    USE_EFATURA = 1,<cfif temp_earchive eq 1>USE_EARCHIVE = 0,EARCHIVE_SENDING_TYPE = NULL,</cfif> EFATURA_DATE = ECI.REGISTER_DATE
                FROM 
                    COMPANY C, EINVOICE_COMPANY_IMPORT ECI
                WHERE 
                    ECI.TAX_NO = C.TAXNO AND
                    LEN(ECI.TAX_NO) = 10
            </cfquery>
    
            <cfquery name="UPD_COMP_CIVIL" datasource="#DSN#">
                UPDATE C SET IS_CIVIL_COMPANY = 1 FROM COMPANY C, EINVOICE_COMPANY_IMPORT ECI WHERE ECI.TAX_NO = C.TAXNO AND ECI.TYPE = 'Kamu'
            </cfquery>
            
            <cfquery name="UPD_COP_WITH_TC" datasource="#DSN#"><!---#77353 Vergi Numarası Olmayıp TC Numarası olan kurumsal üyeler içinde güncelleme yapılması sağlandı (Add by: MCP) --->
                IF NOT EXISTS( SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY' AND COLUMN_NAME = 'IS_PERSON')
                    BEGIN
                        UPDATE 
                            COMPANY
                        SET 
                            USE_EFATURA=1,
                            <cfif temp_earchive eq 1>USE_EARCHIVE = 0,EARCHIVE_SENDING_TYPE = NULL,</cfif>
                            EFATURA_DATE=ECI.REGISTER_DATE
                        FROM 
                            COMPANY C
                            INNER JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = C.MANAGER_PARTNER_ID
                            INNER JOIN EINVOICE_COMPANY_IMPORT ECI ON ECI.TAX_NO = CP.TC_IDENTITY
                        WHERE
                            C.TAXNO IS NULL AND
                            CP.TC_IDENTITY IS NOT NULL
                    END
            ELSE
                    BEGIN
                        UPDATE 
                            COMPANY
                        SET 
                            USE_EFATURA=1,
                            <cfif temp_earchive eq 1>USE_EARCHIVE = 0,EARCHIVE_SENDING_TYPE = NULL,</cfif>
                            EFATURA_DATE=ECI.REGISTER_DATE
                        FROM 
                            COMPANY C
                            INNER JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = C.MANAGER_PARTNER_ID
                            INNER JOIN EINVOICE_COMPANY_IMPORT ECI ON ECI.TAX_NO = CP.TC_IDENTITY
                        WHERE
                            C.IS_PERSON = 1 AND
                            CP.TC_IDENTITY IS NOT NULL
                    END
            </cfquery>
            
            <!---Bireysel uye guncelleme--->    
                
            <cfquery name="UPD_COMP" datasource="#DSN#" result="yyy2">
                UPDATE CONSUMER SET USE_EFATURA = 0,<cfif temp_earchive eq 1>USE_EARCHIVE = 1,</cfif>EFATURA_DATE = NULL
            </cfquery>
                    
            <cfquery name="UPD_COMP" datasource="#DSN#" result="yyy">
                UPDATE 
                    C
                SET 
                    USE_EFATURA = 1,<cfif temp_earchive eq 1>USE_EARCHIVE = 0,</cfif> EFATURA_DATE = ECI.REGISTER_DATE
                FROM 
                    CONSUMER C, EINVOICE_COMPANY_IMPORT ECI
                WHERE 
    
                    ECI.TAX_NO = C.TC_IDENTY_NO AND
                    LEN(ECI.TAX_NO) = 11
            </cfquery>
            <cf_get_lang dictionary_id='57434.Rapor'> <cfif isdefined("attributes.all")>Tüm Mükellef <cfelse>Günlük Yeni Mükellef </cfif> listesini alacak şekilde çalıştırıldı. <cf_get_lang dictionary_id='39812.Toplam Kayıt Sayısı'> :  <cfoutput>#line_count#</cfoutput>
        <cfelse>
            <cfoutput>#startdate#</cfoutput> <cf_get_lang dictionary_id='64964.tarihinden sonra e-Fatura sistemine kayıt olan üye bulunamadı'>
        </cfif>
    </cfif>
    </cf_box>
<script>
    function kontrol(id){
        if(id==1){ einvoice_taxpayer.action=einvoice_taxpayer.action+'&all=1';}
    }
</script>