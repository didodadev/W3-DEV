<cfcomponent>
    <cfproperty type="any" name="CommonObject">
    <cfproperty type="any" name="Cache_ticket">
    <cfproperty type="string" name="urlPrefix">

    <cfset useTicketCache = 0>

    <cffunction name="init">
        <cfset this.CommonObject = createObject("component", "V16.e_government.cfc.dogan.earsiv.common")>
        <cfset integrationinfo = this.CommonObject.GetEArchiveIntegrationInfo()>
        <cfif integrationinfo.recordcount gt 0>
            <cfif integrationinfo.EARSIV_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = trim(integrationinfo.EARSIV_TEST_URL)>
            <cfelse>
                <cfset this.urlPrefix = trim(integrationinfo.EARSIV_LIVE_URL)>
            </cfif>
            <cfif right(this.urlPrefix, 1) neq "/">
                <cfset this.urlPrefix = this.urlPrefix & "/">
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name="SendHttp" access="public">
        <cfargument name="UrlPostfix">
        <cfargument name="SOAPAction">
        <cfargument name="body">
        <cfargument name="contentType" default="text/xml">

        <cfhttp url="#this.urlPrefix##arguments.UrlPostfix#" method="post" result="requestResult">
            <cfhttpparam type="header" name="content-type" value="#arguments.contentType#">
            <cfhttpparam type="header" name="SOAPAction" value="#arguments.SOAPAction#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="header" name="content-length" value="#len(arguments.body)#">
            <cfhttpparam type="xml" name="message" value="#trim(arguments.body)#">
        </cfhttp>

        <cfreturn requestResult>
    </cffunction>

    <cffunction name="GetFormsAuthentication" access="public">
        
        <cfif useTicketCache and isDefined("this.Cache_ticket")>
            <cfreturn this.Cache_ticket>
        </cfif>

        <cfset authvars = this.CommonObject.GetAuthorizationVars()>

        <cfxml variable="ticket_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <wsdl:LoginRequest>
                            <REQUEST_HEADER>
                                <SESSION_ID>-1</SESSION_ID>
                            </REQUEST_HEADER>REQUEST_HEADER>
                            <USER_NAME>#authvars.loginName#</USER_NAME>
                            <PASSWORD>#authvars.password#</PASSWORD>
                        </wsdl:LoginRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("AuthenticationWS", "http://tempuri.org/LoginRequest", ticket_data)>

            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfif useTicketCache>
                <cfset this.Cache_ticket = xmlresult.Envelope.Body.LoginResponse.SESSION_ID.XmlText>
            </cfif>
            <!--- 10013 : Geçersiz Kullanıcı --->
            <cfif structKeyExists(xmlresult.Envelope.Body.LoginResponse,'ERROR_TYPE')>
                <cfreturn xmlresult.Envelope.Body.LoginResponse.ERROR_TYPE.ERROR_SHORT_DES.XmlText>
            <cfelse>
                <cfreturn xmlresult.Envelope.Body.LoginResponse.SESSION_ID.XmlText>
            </cfif>
            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="SendInvoiceData" access="public">
        <cfargument name="ubl">
        <cfargument name="invoice_number">
        <cfargument name="directory_name">
        <cfargument name="zip_filename">
        <cfargument name="invoice_prefix">
        <cfargument name="email">
        <cfargument name="sending_type">

        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        <cfset ticket = GetFormsAuthentication()>

        <cffile action="write" file="#directory_name#/#invoice_number#.xml" output="#trim(ubl)#" charset="utf-8" />
        <cffile action="readbinary" file="#directory_name#/#invoice_number#.xml" variable="ubl_binary">

        <cfxml variable="earchive_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:arc="http://schemas.i2i.com/ei/wsdl/archive" xmlns:xmime="http://www.w3.org/2005/05/xmlmime">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <arc:ArchiveInvoiceExtendedRequest>
                            <REQUEST_HEADER>
                                <SESSION_ID>#ticket#</SESSION_ID>
                                <COMPRESSED>N</COMPRESSED>
                            </REQUEST_HEADER>
                            <ArchiveInvoiceExtendedContent>
                                <INVOICE_PROPERTIES>
                                    <EARSIV_FLAG>Y</EARSIV_FLAG>
                                    <EARSIV_PROPERTIES>
                                        <EARSIV_TYPE>NORMAL</EARSIV_TYPE>
                                        <EARSIV_EMAIL_FLAG><cfif arguments.sending_type eq 1>Y<cfelse>N</cfif></EARSIV_EMAIL_FLAG>
                                        <EARSIV_EMAIL>#arguments.email#</EARSIV_EMAIL>
                                        <SUB_STATUS>NEW</SUB_STATUS>
                                        <cfif isDefined('arguments.invoice_prefix') and len(arguments.invoice_prefix)>
                                            <SERI>#arguments.invoice_prefix#</SERI>
                                        </cfif>
                                    </EARSIV_PROPERTIES>
                                    <INVOICE_CONTENT xmime:contentType="application/?">#toBase64(ubl)#</INVOICE_CONTENT>
                                </INVOICE_PROPERTIES>
                            </ArchiveInvoiceExtendedContent>
                        </arc:ArchiveInvoiceExtendedRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("EIArchiveWS/EFaturaArchive", "http://tempuri.org/WriteToArchieveExtended", earchive_data)>
            
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.invoices = arrayNew(1)>

            <cfset get_sending_type = this.CommonObject.getEarchiveSendingType(url.action_id, url.action_type)>

            <cfif structKeyExists(xmlresult.Envelope.Body.ArchiveInvoiceExtendedResponse,'ERROR_TYPE')>
                <cfset resultdata.ServiceResultDescription = xmlresult.Envelope.Body.ArchiveInvoiceExtendedResponse.ERROR_TYPE.ERROR_SHORT_DES.XmlText>
                <cfset resultdata.ErrorCode = xmlresult.Envelope.Body.ArchiveInvoiceExtendedResponse.ERROR_TYPE.ERROR_CODE.XmlText>
                <cfset resultdata.statuscode = 0>
                <cfset resultdata.uuid = ''>

                <cfscript>
                    earchive_sending_detail_fnc = this.CommonObject.addEarchiveSendingDetail(
                        zip_file_name: arguments.zip_filename,
                        service_result: 'Error',
                        uuid: xmlParse(arguments.ubl).Invoice.UUID.XmlText,
                        earchive_id:xmlParse(arguments.ubl).Invoice.ID.XmlText,
                        status_description:'HATA',
                        service_result_description:xmlresult.Envelope.Body.ArchiveInvoiceExtendedResponse.ERROR_TYPE.ERROR_SHORT_DES.XmlText,
                        status_code:0,
                        error_code:xmlresult.Envelope.Body.ArchiveInvoiceExtendedResponse.ERROR_TYPE.ERROR_CODE.XmlText,
                        action_id:url.action_id,
                        action_type:url.action_type,
                        output_type:'',
                        earchive_sending_type:get_sending_type.earchive_sending_type,
                        invoice_type_code:xmlParse(arguments.ubl).Invoice.InvoiceTypeCode.XmlText
                    );
                </cfscript>
            <cfelse>

                <cfset integration_id = xmlResult.Envelope.Body.ArchiveInvoiceExtendedResponse.INVOICE_ID.XmlText>

                <cfset invoice_path ="earchive_send/#session.ep.company_id#/#year(now())#/#numberformat(month(now()),00)#/xml/#invoice_number#.xml">
                <cfscript>
                    earchive_sending_detail_fnc = this.CommonObject.addEarchiveSendingDetail(
                        zip_file_name: arguments.zip_filename,
                        service_result: 'Successful',
                        uuid: xmlParse(arguments.ubl).Invoice.UUID.XmlText,
                        earchive_id:xmlParse(arguments.ubl).Invoice.ID.XmlText,
                        status_description:'RAPORLAMAYA HAZIR',
                        service_result_description:'',
                        status_code:1,
                        error_code:0,
                        action_id:url.action_id,
                        action_type:url.action_type,
                        output_type:'',
                        earchive_sending_type:get_sending_type.earchive_sending_type,
                        invoice_type_code:xmlParse(arguments.ubl).Invoice.InvoiceTypeCode.XmlText
                    );
                </cfscript>

                <cfset invoice_path ="earchive_send/#session.ep.company_id#/#year(now())#/#numberformat(month(now()),00)#/xml/#invoice_number#.xml">

                <cfscript>
                    earchive_relation_tmp = this.CommonObject.addEarchiveRelation(
                                            status_description: 'RAPORLAMAYA HAZIR',
                                            uuid:xmlParse(arguments.ubl).Invoice.UUID.XmlText,
                                            integration_id:xmlresult.Envelope.Body.ArchiveInvoiceExtendedResponse.INVOICE_ID.XmlText,
                                            earchive_id:xmlParse(arguments.ubl).Invoice.ID.XmlText,
                                            action_id:url.action_id,
                                            action_type:url.action_type,
                                            path: invoice_path,
                                            sender_type:4,
                                            earchive_sending_type: get_sending_type.earchive_sending_type,
                                            is_internet:get_sending_type.is_internet
                            );							
                </cfscript>
                
                <cfset invoice.uuid = xmlParse(ubl).Invoice.UUID.XmlText>
                <cfset invoice.invoiceid = xmlParse(ubl).Invoice.ID.XmlText>
                <cfset invoice.status_code = 1>
                <cfset invoice.earchiveid = integration_id>
                <cfset arrayAppend( resultdata.invoices, invoice )>

                <cfset resultdata.statuscode = 1>
                <cfset resultdata.uuid = ''>
            </cfif>

            <cfreturn resultdata>

            <cfcatch>
                <cfdump  var="#cfcatch#">
                <cfdump  var="#xmlresult#">
                <cfabort>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="CheckInvoiceState" access="public" hint="Faturanın durumunu sorgular">
        <cfargument name="uuid">
        <cfargument name="direction" default="Outgoing" hint="Giden için Outgoing gelen için Incoming">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:arc="http://schemas.i2i.com/ei/wsdl/archive">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <arc:GetEArchiveInvoiceStatusRequest>
                            <REQUEST_HEADER>
                                <SESSION_ID>#ticket#</SESSION_ID>    
                            </REQUEST_HEADER>
                            <UUID>#arguments.uuid#</UUID>
                        </arc:GetEArchiveInvoiceStatusRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("EIArchiveWS/EFaturaArchive", "http://tempuri.org/GetEArchiveInvoiceStatus", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.statusdescription = xmlresult.Envelope.Body.GetEArchiveInvoiceStatusResponse.INVOICE.HEADER.STATUS_DESC.XmlText>
            <cfset resultdata.statuscode = xmlresult.Envelope.Body.GetEArchiveInvoiceStatusResponse.INVOICE.HEADER.STATUS.XmlText>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="getInvoicePDF" access="public" hint="Faturanın durumunu sorgular">
        <cfargument name="uuid">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:arc="http://schemas.i2i.com/ei/wsdl/archive">
                <soapenv:Header/>
                <soapenv:Body>
                    <arc:ArchiveInvoiceReadRequest>
                        <REQUEST_HEADER>
                            <SESSION_ID>#ticket#</SESSION_ID>
                            <APPLICATION_NAME>W3C</APPLICATION_NAME>
                        </REQUEST_HEADER>
                        <INVOICEID>#arguments.uuid#</INVOICEID>
                        <PORTAL_DIRECTION>OUT</PORTAL_DIRECTION>
                        <PROFILE>PDF</PROFILE>
                    </arc:ArchiveInvoiceReadRequest>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("EIArchiveWS/EFaturaArchive", "http://tempuri.org/ArchiveInvoiceRead", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.pdf_data = xmlresult.Envelope.Body.ArchiveInvoiceReadResponse.INVOICE.XmlText>
            
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="CancelInvoice" access="public" hint="Fatura İptal">
        <cfargument name="uuid">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:arc="http://schemas.i2i.com/ei/wsdl/archive" xmlns:xmime="http://www.w3.org/2005/05/xmlmime">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <arc:CancelEArchiveInvoiceRequest>
                            <REQUEST_HEADER>
                                <SESSION_ID>#ticket#</SESSION_ID>
                            </REQUEST_HEADER>
                            <CancelEArsivInvoiceContent>
                                <FATURA_UUID>#arguments.uuid#</FATURA_UUID>
                            </CancelEArsivInvoiceContent>
                        </arc:CancelEArchiveInvoiceRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("EIArchiveWS/EFaturaArchive", "http://tempuri.org/CancelEArchiveInvoice", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfif structKeyExists(xmlresult.Envelope.Body.CancelEArchiveInvoiceResponse, 'ERROR_TYPE')>
                <cfset resultdata.status = xmlresult.Envelope.Body.CancelEArchiveInvoiceResponse.ERROR_TYPE.ERROR_CODE.XmlText>
                <cfset resultdata.status_description = xmlresult.Envelope.Body.CancelEArchiveInvoiceResponse.ERROR_TYPE.ERROR_SHORT_DES.XmlText>
            <cfelse>
                <cfset resultdata.status = xmlresult.Envelope.Body.CancelEArchiveInvoiceResponse.REQUEST_RETURN.RETURN_CODE.XmlText>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>
