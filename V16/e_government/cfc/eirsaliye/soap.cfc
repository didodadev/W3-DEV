<!---
    File :          eirsaliye.soap.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          23.05.2020
    Description :   Eirsaliye soap katmanı
    Notes :         
--->
<cfcomponent>

    <cfproperty type="any" name="CommonObject">
    <cfproperty type="any" name="Cache_ticket">
    <cfproperty type="string" name="urlPrefix">

    <cfset useTicketCache = 0>

    <cffunction name="init">
        <cfset this.CommonObject = createObject("component", "V16.e_government.cfc.eirsaliye.common")>
        <cfset integrationinfo = this.CommonObject.GetEShipmentIntegrationInfo()>
        <cfif integrationinfo.recordcount gt 0>
            <cfif integrationinfo.ESHIPMENT_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = trim(integrationinfo.ESHIPMENT_TEST_URL)>
            <cfelse>
                <cfset this.urlPrefix = trim(integrationinfo.ESHIPMENT_LIVE_URL)>
            </cfif>
            <cfif right(this.urlPrefix, 1) neq "/">
                <cfset this.urlPrefix = this.urlPrefix & "/">
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name="SendHttp" access="private">
        <cfargument name="UrlPostfix">
        <cfargument name="SOAPAction">
        <cfargument name="body">
        <cfargument name="contentType" default="text/xml">

        <cfhttp url="#this.urlPrefix##arguments.UrlPostfix#" method="post" result="requestResult">
            <cfhttpparam type="header" name="content-type" value="#arguments.contentType#">
            <cfhttpparam type="header" name="SOAPAction" value="#arguments.SOAPAction#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="header" name="content-legth" value="#len(arguments.body)#">
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
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
            <soapenv:Header/>
            <soapenv:Body>
                <tem:GetFormsAuthenticationTicket>
                    <tem:CorporateCode>#authvars.corporateCode#</tem:CorporateCode>
                    <tem:LoginName>#authvars.loginName#</tem:LoginName>
                    <tem:Password>#authvars.password#</tem:Password>
                </tem:GetFormsAuthenticationTicket>
            </soapenv:Body>
            </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/GetFormsAuthenticationTicket", ticket_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfif useTicketCache>
                <cfset this.Cache_ticket = xmlresult.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
            </cfif>
            <cfreturn xmlresult.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="SendDespatchData" access="public" hint="İrsaliye Verisi Gönder">
        <cfargument name="ubl">

        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        <cfset ticket = GetFormsAuthentication()>
        
        <cfxml variable="despatch_data">
            <cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
            <soapenv:Header/>
            <soapenv:Body>
                <tem:SendDespatchData>
                    <tem:Ticket>#ticket#</tem:Ticket>
                    <tem:FileType>UBL</tem:FileType>
                    <tem:despatchRawData>#trim(toBase64(arguments.ubl))#</tem:despatchRawData>
                    <tem:CorporateCode>#authvars.corporateCode#</tem:CorporateCode>
                    <tem:MapCode></tem:MapCode>
                    <tem:ReceiverPostboxName></tem:ReceiverPostboxName>
                </tem:SendDespatchData>
            </soapenv:Body>
            </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/SendDespatchData", despatch_data)>

            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.despatches = arrayNew(1)>

            <cfset resultdata.serviceResult = xmlresult.Envelope.Body.SendDespatchDataResponse.SendDespatchDataResult.serviceResult.XmlText>
            
            <cfif resultdata.serviceResult eq "Error">
                <cfset resultdata.ServiceResultDescription = xmlresult.Envelope.Body.SendDespatchDataResponse.SendDespatchDataResult.ServiceResultDescription.XmlText>
                <cfset resultdata.ErrorCode = xmlresult.Envelope.Body.SendDespatchDataResponse.SendDespatchDataResult.ErrorCode.XmlText>
                <cfset resultdata.statuscode = xmlresult.Envelope.Body.SendDespatchDataResponse.SendDespatchDataResult.Despatches.DespatchStateResult.StatusCode.XmlText>
                <cfset resultdata.uuid = xmlresult.Envelope.Body.SendDespatchDataResponse.SendDespatchDataResult.Despatches.DespatchStateResult.UUID.XmlText>
            <cfelse>
                <cfset resultdata.InstanceIdentifier = xmlresult.Envelope.Body.SendDespatchDataResponse.SendDespatchDataResult.InstanceIdentifier.XmlText>
                <cfloop array="#xmlresult.Envelope.Body.SendDespatchDataResponse.SendDespatchDataResult.Despatches.xmlchildren#" index="child">
                    <cfset despatch = structNew()>
                    <cfset despatch.serviceresult = child.ServiceResult.XmlText>
                    <cfif despatch.serviceresult eq "Error">
                        <cfset despatch.errorcode = child.ErrorCode.XmlText>
                        <cfset despatch.statuscode = child.StatusCode.XmlText>
                    <cfelse>
                        <cfset despatch.ServiceResultDescription = child.ServiceResultDescription.XmlText>
                        <cfset despatch.ServiceStatusDescription = child.StatusDescription.XmlText>
                        <cfset despatch.errorcode = child.ErrorCode.XmlText>
                        <cfset despatch.uuid = child.UUID.XmlText>
                        <cfset despatch.despatchid = child.DespatchId.XmlText>
                        <cfset despatch.statuscode = child.StatusCode.XmlText>
                        <cfset despatch.referenceno = child.ReferenceNo.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.despatches, despatch )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>
	<cffunction name="SendDespatchDataWithTemplateCode" access="public" hint="İrsaliye Verisi Gönder">
        <cfargument name="ubl">
		<cfargument name="pref">
        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        <cfset ticket = GetFormsAuthentication()>
        
        <cfxml variable="despatch_data">
            <cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
            <soapenv:Header/>
            <soapenv:Body>
                <tem:SendDespatchDataWithTemplateCode>
                    <tem:Ticket>#ticket#</tem:Ticket>
                    <tem:FileType>UBL</tem:FileType>
                    <tem:despatchRawData>#trim(toBase64(arguments.ubl))#</tem:despatchRawData>
                    <tem:CorporateCode>#authvars.corporateCode#</tem:CorporateCode>
                    <tem:MapCode></tem:MapCode>
                    <tem:ReceiverPostboxName></tem:ReceiverPostboxName>
					<tem:templateCode>#pref#</tem:templateCode> 
                </tem:SendDespatchDataWithTemplateCode>
            </soapenv:Body>
            </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/SendDespatchDataWithTemplateCode", despatch_data)>

            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.despatches = arrayNew(1)>
			
            <cfset resultdata.serviceResult = xmlresult.Envelope.Body.SendDespatchDataWithTemplateCodeResponse.SendDespatchDataWithTemplateCodeResult.serviceResult.XmlText>
            
            <cfif resultdata.serviceResult eq "Error">
                <cfset resultdata.ServiceResultDescription = xmlresult.Envelope.Body.SendDespatchDataWithTemplateCodeResponse.SendDespatchDataWithTemplateCodeResult.ServiceResultDescription.XmlText>
                <cfset resultdata.ErrorCode = xmlresult.Envelope.Body.SendDespatchDataWithTemplateCodeResponse.SendDespatchDataWithTemplateCodeResult.ErrorCode.XmlText>
                <cfset resultdata.statuscode = xmlresult.Envelope.Body.SendDespatchDataWithTemplateCodeResponse.SendDespatchDataWithTemplateCodeResult.Despatches.DespatchStateResult.StatusCode.XmlText>
                <cfset resultdata.uuid = xmlresult.Envelope.Body.SendDespatchDataWithTemplateCodeResponse.SendDespatchDataWithTemplateCodeResult.Despatches.DespatchStateResult.UUID.XmlText>
            <cfelse>
                <cfset resultdata.InstanceIdentifier = xmlresult.Envelope.Body.SendDespatchDataWithTemplateCodeResponse.SendDespatchDataWithTemplateCodeResult.InstanceIdentifier.XmlText>
                <cfloop array="#xmlresult.Envelope.Body.SendDespatchDataWithTemplateCodeResponse.SendDespatchDataWithTemplateCodeResult.Despatches.xmlchildren#" index="child">
                    <cfset despatch = structNew()>
                    <cfset despatch.serviceresult = child.ServiceResult.XmlText>
                    <cfif despatch.serviceresult eq "Error">
                        <cfset despatch.errorcode = child.ErrorCode.XmlText>
                        <cfset despatch.statuscode = child.StatusCode.XmlText>
                    <cfelse>
                        <cfset despatch.ServiceResultDescription = child.ServiceResultDescription.XmlText>
                        <cfset despatch.ServiceStatusDescription = child.StatusDescription.XmlText>
                        <cfset despatch.errorcode = child.ErrorCode.XmlText>
                        <cfset despatch.uuid = child.UUID.XmlText>
                        <cfset despatch.despatchid = child.DespatchId.XmlText>
                        <cfset despatch.statuscode = child.StatusCode.XmlText>
                        <cfset despatch.referenceno = child.ReferenceNo.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.despatches, despatch )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>
    <cffunction name="CheckDespatchState" access="public" hint="İrsaliyenin durumunu sorgular">
        <cfargument name="uuid">
        <cfargument name="direction" default="Outgoing" hint="Giden için Outgoing gelen için Incoming">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:CheckDespatchState>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:UUID>#arguments.uuid#</tem:UUID>
                        <tem:direction>#arguments.direction#</tem:direction>
                    </tem:CheckDespatchState>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/CheckDespatchState", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.CheckDespatchStateResponse.CheckDespatchStateResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.CheckDespatchStateResponse.CheckDespatchStateResult.ErrorCode.XmlText>
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.CheckDespatchStateResponse.CheckDespatchStateResult.ServiceResultDescription.XmlText>
                <cfset resultdata.statuscode = xmlresult.Envelope.Body.CheckDespatchStateResponse.CheckDespatchStateResult.StatusCode.XmlText>
            <cfelse>
                <cfset resultdata.uuid = xmlresult.Envelope.Body.CheckDespatchStateResponse.CheckDespatchStateResult.UUID.XmlText>
                <cfset resultdata.despatchid = xmlresult.Envelope.Body.CheckDespatchStateResponse.CheckDespatchStateResult.DespatchId.XmlText>
                <cfset resultdata.statusdescription = xmlresult.Envelope.Body.CheckDespatchStateResponse.CheckDespatchStateResult.StatusDescription.XmlText>
                <cfset resultdata.statuscode = xmlresult.Envelope.Body.CheckDespatchStateResponse.CheckDespatchStateResult.StatusCode.XmlText>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="CheckReceiptState" access="public" hint="İrsaliye yanıtının durumunu sorgular">
        <cfargument name="uuid">
        <cfargument name="direction" default="Outgoing" hint="Giden için Outgoing gelen için Incoming">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:CheckReceiptState>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:UUID>#arguments.uuid#</tem:UUID>
                        <tem:direction>#arguments.direction#</tem:direction>
                    </tem:CheckReceiptState>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/CheckReceiptState", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.CheckReceiptStateResponse.CheckReceiptStateResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.CheckReceiptStateResponse.CheckReceiptStateResult.ErrorCode.XmlText>
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.CheckReceiptStateResponse.CheckReceiptStateResult.ServiceResultDescription.XmlText>
            <cfelse>
                <cfset resultdata.uuid = xmlresult.Envelope.Body.CheckReceiptStateResponse.CheckReceiptStateResult.UUID.XmlText>
                <cfset resultdata.receipmentid = xmlresult.Envelope.Body.CheckReceiptStateResponse.CheckReceiptStateResult.ReceipmentId.XmlText>
                <cfset resultdata.statusdescription = xmlresult.Envelope.Body.CheckReceiptStateResponse.CheckReceiptStateResult.StatusDescription.XmlText>
                <cfset resultdata.statuscode = xmlresult.Envelope.Body.CheckReceiptStateResponse.CheckReceiptStateResult.StatusCode.XmlText>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="GetAvailableDesptaches" access="public" hint="Gelen irsaliye listesini verir">
        <cfargument name="startdate" default="">
        <cfargument name="enddate" default="">
        
        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        <cfset ticket = GetFormsAuthentication()>

        <cfif len(startdate)>
            <cfreturn GetAvailableDesptachesWithDate(authvars, ticket, arguments.startdate, arguments.enddate)>
        </cfif>

        <cfxml variable="availabledespatches_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:GetAvailableDespatches>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:CorporateCode>#authvars.corporateCode#</tem:CorporateCode>
                    </tem:GetAvailableDespatches>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/GetAvailableDespatches", availabledespatches_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.despatches = arrayNew(1)>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.GetAvailableDespatchesResponse.GetAvailableDespatchesResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.GetAvailableDespatchesResponse.GetAvailableDespatchesResult.ErrorCode.XmlText>
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.GetAvailableDespatchesResponse.GetAvailableDespatchesResult.ServiceResultDescription.XmlText>
            <cfelse>
                <cfloop array="#xmlresult.Envelope.Body.GetAvailableDespatchesResponse.GetAvailableDespatchesResult.Despatches.xmlchildren#" index="child">
                    <cfset despatch = structNew()>
                    <cfset despatch.serviceresult = child.ServiceResult.XmlText>
                    <cfif despatch.serviceresult eq "Error">
                        <cfset despatch.serviceresultdescription = child.ServiceResultDescription.XmlText>
                        <cfset despatch.errorcode = child.ErrorCode.XmlText>
                    <cfelse>
                        <cfset despatch.serviceresultdescription = child.ServiceResultDescription.XmlText>
                        <cfset despatch.uuid = child.UUID.XmlText>
                        <cfset despatch.despatchid = child.DespatchId.XmlText>
                        <cfset despatch.statuscode = child.StatusCode.XmlText>
                        <cfset despatch.statusdescription = child.StatusDescription.XmlText>
                        <cfset despatch.despatchadvicetypecode = child.Despatchadvicetypecode.XmlText>
                        <cfset despatch.sendertaxid = child.Sendertaxid.XmlText>
                        <cfset despatch.receivertaxid = child.Receivertaxid.XmlText>
                        <cfset despatch.profileid = child.Profileid.XmlText>
                        <cfset despatch.issuedate = child.Issuedate.XmlText>
                        <cfset despatch.issuetime = child.Issuetime.XmlText>
                        <cfset despatch.partyname = child.Partyname.XmlText>
                        <cfset despatch.receiverpostboxname = child.ReceiverPostBoxName.XmlText>
                        <cfset despatch.senderpostboxname = child.SenderPostBoxName.XmlText>
                        <cfset despatch.totalamount = child.TotalAmount.XmlText>
                        <cfset despatch.createdate = child.Createdate.XmlText>
                        <cfset despatch.direction = child.Direction.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.despatches, despatch )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="GetAvailableDesptachesWithDate" access="private" hint="Gelen irsaliye listesini verir. GetAvailableDespatches fonksiyonuna tarih belirtildiğinde çalışır">
        <cfargument name="authvars">
        <cfargument name="ticket">
        <cfargument name="startdate">
        <cfargument name="enddate">

        <cfxml variable="availabledespatcheswithdate_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:GetAvailableDespatchesWithDate>
                        <tem:Ticket>#arguments.ticket#</tem:Ticket>
                        <tem:CorporateCode>#arguments.authvars.corporateCode#</tem:CorporateCode>
                        <tem:StartDate>#dateFormat(arguments.startdate, "yyyy-mm-dd")#</tem:StartDate>
                        <tem:EndDate>#dateFormat(arguments.enddate, "yyyy-mm-dd")#</tem:EndDate>
                    </tem:GetAvailableDespatchesWithDate>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/GetAvailableDesptachesWithDate", availabledespatcheswithdate_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.despatches = arrayNew(1)>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.GetAvailableDespatchesResponse.GetAvailableDespatchesResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.GetAvailableDespatchesResponse.GetAvailableDespatchesResult.ErrorCode.XmlText>
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.GetAvailableDespatchesResponse.GetAvailableDespatchesResult.ServiceResultDescription.XmlText>
            <cfelse>
                <cfloop array="#xmlresult.Envelope.Body.GetAvailableDespatchesResponse.GetAvailableDespatchesResult.Despatches.xmlchildren#" index="child">
                    <cfset despatch = structNew()>
                    <cfset despatch.serviceresult = child.ServiceResult.XmlText>
                    <cfif despatch.serviceresult eq "Error">
                        <cfset despatch.serviceresultdescription = child.ServiceResultDescription.XmlText>
                        <cfset despatch.errorcode = child.ErrorCode.XmlText>
                    <cfelse>
                        <cfset despatch.serviceresultdescription = child.ServiceResultDescription.XmlText>
                        <cfset despatch.uuid = child.UUID.XmlText>
                        <cfset despatch.despatchid = child.DespatchId.XmlText>
                        <cfset despatch.statuscode = child.StatusCode.XmlText>
                        <cfset despatch.statusdescription = child.StatusDescription.XmlText>
                        <cfset despatch.despatchadvicetypecode = child.Despatchadvicetypecode.XmlText>
                        <cfset despatch.sendertaxid = child.Sendertaxid.XmlText>
                        <cfset despatch.receivertaxid = child.Receivertaxid.XmlText>
                        <cfset despatch.profileid = child.Profileid.XmlText>
                        <cfset despatch.issuedate = child.Issuedate.XmlText>
                        <cfset despatch.issuetime = child.Issuetime.XmlText>
                        <cfset despatch.partyname = child.Partyname.XmlText>
                        <cfset despatch.receiverpostboxname = child.ReceiverPostBoxName.XmlText>
                        <cfset despatch.senderpostboxname = child.SenderPostBoxName.XmlText>
                        <cfset despatch.totalamount = child.TotalAmount.XmlText>
                        <cfset despatch.createdate = child.Createdate.XmlText>
                        <cfset despatch.direction = child.Direction.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.despatches, despatch )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="GetAvailableReceipts" access="public" hint="İrsaliye yanıt listesini verir">
        <cfargument name="startdate" default="">
        <cfargument name="enddate" default="">

        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        <cfset ticket = GetFormsAuthentication()>

        <cfif len(arguments.startdate)>
            <cfreturn GetAvailableReceiptsWithDate(authvars, ticket, arguments.startdate, arguments.enddate)>
        </cfif>

        <cfxml variable="availablereceipts_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:GetAvailableReceipts>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:CorporateCode>#authvars.corporateCode#</tem:CorporateCode>
                    </tem:GetAvailableReceipts>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/GetAvailableReceipts", availablereceipts_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.receipments = arrayNew(1)>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.GetAvailableReceiptsResponse.GetAvailableReceiptsResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.GetAvailableReceiptsResponse.GetAvailableReceiptsResult.ErrorCode.XmlText>
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.GetAvailableReceiptsResponse.GetAvailableReceiptsResult.ServiceResultDescription.XmlText>
            <cfelse>
                <cfloop array="#xmlresult.Envelope.Body.GetAvailableReceiptsResponse.GetAvailableReceiptsResult.Receipments.xmlchildren#" index="child">
                    <cfset receipment = structNew()>
                    <cfset receipment.serviceresult = child.ServiceResult.XmlText>
                    <cfset receipment.serviceresultdescription = child.ServiceResultDescription.XmlText>
                    <cfif receipment.serviceresult eq "Error">
                        <cfset receipment.errorcode = child.ErrorCode.XmlText>
                    <cfelse>  
                        <cfset receipment.uuid = child.UUID.XmlText>
                        <cfset receipment.receipmentid = child.ReceipmentId.XmlText>
                        <cfset receipment.statuscode = child.StatusCode.XmlText>
                        <cfset receipment.statusdescription = child.StatusDescription.XmlText>
                        <cfset receipment.receiptadvicetypecode = child.Receiptadvicetypecode.XmlText>
                        <cfset receipment.sendertaxid = child.Sendertaxid.XmlText>
                        <cfset receipment.receivertaxid = child.Receivertaxid.XmlText>
                        <cfset receipment.profileid = child.Profileid.XmlText>
                        <cfset receipment.issuedate = child.Issuedate.XmlText>
                        <cfset receipment.issuetime = child.Issuetime.XmlText>
                        <cfset receipment.partyname = child.Partyname.XmlText>
                        <cfset receipment.receiverpostboxname = child.ReceiverPostBoxName.XmlText>
                        <cfset receipment.despatchid = child.DespatchId.XmlText>
                        <cfset receipment.despatchuuid = child.DespatchUUID.XmlText>
                        <cfset receipment.createdate = child.Createdate.XmlText>
                        <cfset receipment.direction = child.Direction.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.receipments, receipment )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="GetAvailableReceiptsWithDate" access="private" hint="İrsaliye yanıt listesini tarih aralığında verir. Dışarıdan erişilmez GetAvailableReceipts tarih verildiğinde çağrılır">
        <cfargument name="authvars">
        <cfargument name="ticket">
        <cfargument name="startdate">
        <cfargument name="enddate">
        <cfxml variable="availablereceiptswithdate_data">
        <cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                <tem:GetAvailableReceiptsWithDate>
                    <tem:Ticket>#arguments.ticket#</tem:Ticket>
                    <tem:CorporateCode>#arguments.authvars.corporateCode#</tem:CorporateCode>
                    <tem:StartDate>#dateFormat(arguments.startdate, "yyyy-mm-dd")#</tem:StartDate>
                    <tem:EndDate>#dateFormat(arguments.enddate, "yyyy-mm-dd")#</tem:EndDate>
                </tem:GetAvailableReceiptsWithDate>
                </soapenv:Body>
            </soapenv:Envelope>
        </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/GetAvailableReceiptsWithDate", availablereceiptswithdate_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            
            
            <cfset resultdata = structNew()>
            <cfset resultdata.receipments = arrayNew(1)>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.GetAvailableReceiptsWithDateResponse.GetAvailableReceiptsWithDateResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.GetAvailableReceiptsWithDateResponse.GetAvailableReceiptsWithDateResult.ErrorCode.XmlText>
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.GetAvailableReceiptsWithDateResponse.GetAvailableReceiptsWithDateResult.ServiceResultDescription.XmlText>
            <cfelse>
                <cfloop array="#xmlresult.Envelope.Body.GetAvailableReceiptsWithDateResponse.GetAvailableReceiptsWithDateResult.Receipments.xmlchildren#" index="child">
                    <cfset receipment = structNew()>
                    <cfset receipment.serviceresult = child.ServiceResult.XmlText>
                    <cfset receipment.serviceresultdescription = child.ServiceResultDescription.XmlText>
                    <cfif receipment.serviceresult eq "Error">
                        <cfset receipment.errorcode = child.ErrorCode.XmlText>
                    <cfelse>
                        <cfset receipment.uuid = child.UUID.XmlText>
                        <cfset receipment.receipmentid = child.ReceiptmentId.XmlText>
                        <cfset receipment.statuscode = child.StatusCode.XmlText>
                        <cfset receipment.statusdescription = child.StatusDescription.XmlText>
                        <cfset receipment.receiptadvicetypecode = child.Receiptadvicetypecode.XmlText>
                        <cfset receipment.sendertaxid = child.Sendertaxid.XmlText>
                        <cfset receipment.receivertaxid = child.Receivertaxid.XmlText>
                        <cfset receipment.profileid = child.Profileid.XmlText>
                        <cfset receipment.issuedate = child.Issuedate.XmlText>
                        <cfset receipment.issuetime = child.Issuetime.XmlText>
                        <cfset receipment.partyname = child.Partyname.XmlText>
                        <cfset receipment.receiverpostboxname = child.ReceiverPostBoxName.XmlText>
                        <cfset receipment.despatchid = child.DespatchId.XmlText>
                        <cfset receipment.despatchuuid = child.DespatchUUID.XmlText>
                        <cfset receipment.createdate = child.Createdate.XmlText>
                        <cfset receipment.direction = child.Direction.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.receipments, receipment )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="GetDespatch" access="public" hint="Sistemde ki irsaliyeyi indirir">
        <cfargument name="direction">
        <cfargument name="value">
        <cfargument name="valuetype" default="UUID">
        <cfargument name="filetype" default="UBL">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="despatch_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:GetDespatch>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:Value>#arguments.value#</tem:Value>
                        <tem:ValueType>#arguments.valuetype#</tem:ValueType>
                        <tem:direction>#arguments.direction#</tem:direction>
                        <tem:FileType>#arguments.filetype#</tem:FileType>
                    </tem:GetDespatch>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/GetDespatch", despatch_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.despatches = arrayNew(1)>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.GetDespatchResponse.GetDespatchResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.GetDespatchResponse.GetDespatchResult.ErrorCode.XmlText>
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.GetDespatchResponse.GetDespatchResult.ServiceResultDescription.XmlText>
            <cfelse>
                <cfloop array="#xmlresult.Envelope.Body.GetDespatchResponse.GetDespatchResult.Despatches.xmlchildren#" index="child">
                    
                    <cfset despatch = structNew()>
                    <cfset despatch.serviceresult = child.ServiceResult.XmlText>
                    <cfset despatch.serviceresultdescription = child.ServiceResultDescription.XmlText>
                    <cfif despatch.serviceresult eq "Error">
                        <cfset despatch.errorcode = child.ErrorCode.XmlText>
                    <cfelse>
                        <cfset despatch.uuid = child.UUID.XmlText>
                        <cfset despatch.despatchid = child.DespatchId.XmlText>
                        <cfset despatch.returnvalue = child.ReturnValue.XmlText>
                        <cfset despatch.statuscode = child.StatusCode.XmlText>
                        <cfset despatch.statusdescription = child.StatusDescription.XmlText>
                        <cfset despatch.despatchadvicetypecode = child.Despatchadvicetypecode.XmlText>
                        <cfset despatch.sendertaxid = child.Sendertaxid.XmlText>
                        <cfset despatch.receivertaxid = child.Receivertaxid.XmlText>
                        <cfset despatch.profileid = child.Profileid.XmlText>
                        <cfset despatch.issuedate = child.Issuedate.XmlText>
                        <cfset despatch.issuetime = child.Issuetime.XmlText>
                        <cfset despatch.partyname = child.Partyname.XmlText>
                        <cfset despatch.totalamount = child.TotalAmount.XmlText>
                        <cfset despatch.createdate = child.Createdate.XmlText>
                        <cfset despatch.direction = child.Direction.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.despatches, despatch )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="CheckCustomerTaxId" access="public" hint="Carinin eirsaliye kullanıcısı olup olmadığını kontrol eder">
        <cfargument name="taxidorpersonalid">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="customertax_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:CheckCustomerTaxId>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:TaxIdOrPersonalId>#arguments.taxidorpersonalid#</tem:TaxIdOrPersonalId>
                    </tem:CheckCustomerTaxId>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/CheckCustomerTaxId", despatch_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.customerinfos = arrayNew(1)>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.CheckCustomerTaxIdResponse.CheckCustomerTaxIdResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.CheckCustomerTaxIdResponse.CheckCustomerTaxIdResult.ErrorCode.XmlText>
            <cfelse>
                <cfloop array="#xmlresult.Envelope.Body.CheckCustomerTaxIdResponse.CheckCustomerTaxIdResult.CustomerInfoList.xmlchildren#" index="child">
                    <cfset customerinfo = structNew()>
                    <cfset customerinfo.isexist = child.IsExist.XmlText>
                    <cfif customerinfo.isexist eq "true">
                        <cfset customerinfo.taxidorpersonalid = child.TaxIdOrPersonalId.XmlText>
                        <cfset customerinfo.alias = child.Alias.XmlText>
                        <cfset customerinfo.type = child.Type.XmlText>
                        <cfset customerinfo.name = child.Name.XmlText>
                        <cfset customerinfo.registertime = child.RegisterTime.XmlText>
                        <cfset customerinfo.aliascreatedate = child.AliasCreateDate.XmlText>
                        <cfset customerinfo.firstcreationtime = child.FirstCreationTime.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.customerinfos, customerinfo )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>
            
            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="CheckGibStatus" access="public" hint="İrsaliyenin GİB durumunu sorgular">
        <cfargument name="guid">
        <cfargument name="guidtype">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="gibstatus_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:CheckGibStatus>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:Guid>#arguments.uuid#</tem:Guid>
                        <tem:GuidType>#arguments.uuidtype#</tem:GuidType>
                    </tem:CheckGibStatus>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/CheckGibStatus", despatch_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.CheckGibStatusResponse.CheckGibStatusResult.ServiceResult.XmlText>
            <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.CheckGibStatusResponse.CheckGibStatusResult.ServiceResultDescription.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.CheckGibStatusResponse.CheckGibStatusResult.ErrorCode.XmlText>
            <cfelse>
                <cfset resultdata.lineresponsecode = xmlresult.Envelope.Body.CheckGibStatusResponse.CheckGibStatusResult.LineResponseCode.XmlText>
                <cfset resultdata.lineresponsedescription = xmlresult.Envelope.Body.CheckGibStatusResponse.CheckGibStatusResult.LineResponseDescription.XmlText>
                <cfset resultdata.guid = xmlresult.Envelope.Body.CheckGibStatusResponse.CheckGibStatusResult.Guid.XmlText>
                <cfset resultdata.guidtype = xmlresult.Envelope.Body.CheckGibStatusResponse.CheckGibStatusResult.GuidType.XmlText>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="SendReceiptAdviceData" access="public" hint="İrsaliye yanıtını gönderir">
        <cfargument name="despatchdata">
        <cfargument name="receiverpostboxname" default="">
        <cfargument name="filetype" default="UBL">
        <cfargument name="mapcode" default="">

        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="receipeadvice_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:SendReceiptAdviceData>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:FileType>#arguments.filetype#</tem:FileType>
                        <tem:despatchRawData>#arguments.despatchdata#</tem:despatchRawData>
                        <tem:CorporateCode>#authvars.corporateCode#</tem:CorporateCode>
                        <tem:MapCode>#arguments.mapcode#</tem:MapCode>
                        <tem:ReceiverPostboxName>#arguments.receiverpostboxname#</tem:ReceiverPostboxName>
                    </tem:SendReceiptAdviceData>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/SendReceiptAdviceData", despatch_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.receipments = arrayNew(1)>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.SendReceiptAdviceDataResponse.SendReceiptAdviceDataResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.SendReceiptAdviceDataResponse.SendReceiptAdviceDataResult.ErrorCode.XmlText>
            <cfelse>
                <cfloop array="#xmlresult.Envelope.Body.SendReceiptAdviceDataResponse.SendReceiptAdviceDataResult.Receipments.xmlchildren#" index="child">
                    <cfset receipment = structNew()>
                    <cfset receipment.serviceresult = child.ServiceResult.XmlText>
                    <cfif receipment.serviceresult eq "Error">
                        <cfset receipment.errorcode = child.ErrorCode.XmlText>
                    <cfelse>
                        <cfset receipment.uuid = child.UUID.XmlText>
                        <cfset receipment.receipmentid = child.ReceipmentId.XmlText>
                        <cfset receipment.statusdescription = child.StatusDescription.XmlText>
                        <cfset receipment.statuscode = child.StatusCode.XmlText>
                        <cfset receipment.referenceno = child.ReferenceNo.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.receipments, receipment )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="GetReceiptAdvice" access="public" hint="İrsliye yanıtını alır">
        <cfargument name="direction">
        <cfargument name="value">
        <cfargument name="valuetype" default="UUID">
        <cfargument name="filetype" default="UBL">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="receiptadvice_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:GetReceiptAdvice>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:Value>#arguments.value#</tem:Value>
                        <tem:ValueType>#arguments.valuetype#</tem:ValueType>
                        <tem:direction>#arguments.direction#</tem:direction>
                        <tem:FileType>#arguments.filetype#</tem:FileType>
                    </tem:GetReceiptAdvice>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/GetReceiptAdvice", receiptadvice_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.receipments = arrayNew(1)>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.GetReceiptAdviceResponse.GetReceiptAdviceResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.GetReceiptAdviceResponse.GetReceiptAdviceResult.ErrorCode.XmlText>
            <cfelse>
                <cfloop array="#xmlresult.Envelope.Body.GetReceiptAdviceResponse.GetReceiptAdviceResult.Receipments.xmlchildren#" index="child">
                    <cfset receipment = structNew()>
                    <cfset receipment.serviceresult = child.ServiceResult.XmlText>
                    <cfif receipment.serviceresult eq "Error">
                        <cfset receipment.serviceresultdescription = child.ServiceResultDescription.XmlText>
                        <cfset receipment.errorcode = child.ErrorCode.XmlText>
                    <cfelse>
                        <cfset receipment.uuid = child.UUID.XmlText>
                        <cfset receipment.receiptmentid = child.ReceiptmentId.XmlText>
                        <cfset receipment.returnvalue = child.ReturnValue.XmlText>
                        <cfset receipment.statuscode = child.StatusCode.XmlText>
                        <cfset receipment.statusdescription = child.StatusDescription.XmlText>
                        <cfset receipment.receiptadvicetypecode = child.Receiptadvicetypecode.XmlText>
                        <cfset receipment.sendertaxid = child.Sendertaxid.XmlText>
                        <cfset receipment.profileid = child.Profileid.XmlText>
                        <cfset receipment.issuedate = child.Issuedate.XmlText>
                        <cfset receipment.issuetime = child.Issuetime.XmlText>
                        <cfset receipment.partyname = child.Partyname.XmlText>
                        <cfset receipment.createdate = child.Createdate.XmlText>
                        <cfset receipment.direction = child.Direction.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.receipments, receipment )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="AcceptDespatch" access="public" hint="Gelen irsaliyenin kabulu için kullanılır">
        <cfargument name="uuid">
        <cfargument name="description" default="">
        <cfargument name="templatecode" default="">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="acceptdespatch_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:AcceptDespatch>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:UUID>#arguments.uuid#</tem:UUID>
                        <tem:TemplateCode>#arguments.templatecode#</tem:TemplateCode>
                        <tem:Description>#arguments.description#</tem:Description>
                    </tem:AcceptDespatch>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/AcceptDespatch", acceptdespatch_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.receipments = arrayNew(1)>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.AcceptDespatchResponse.AcceptDespatchResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.AcceptDespatchResponse.AcceptDespatchResult.ServiceResultDescription.XmlText>
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.AcceptDespatchResponse.AcceptDespatchResult.ErrorCode.XmlText>
            <cfelse>
                <cfset resultdata.acceptorrejectdespatch = xmlresult.Envelope.Body.AcceptDespatchResponse.AcceptDespatchResult.AcceptOrRejectDespatch.XmlText>
                <cfloop array="#xmlresult.Envelope.Body.AcceptDespatchResponse.AcceptDespatchResult.Receipments.xmlchildren#" index="child">
                    <cfset receipment = structNew()>
                    <cfset receipment.serviceresult = child.ServiceResult.XmlText>
                    <cfif receipment.serviceresult eq "Error">
                        <cfset receipment.errorcode = child.ErrorCode.XmlText>
                    <cfelse>
                        <cfset receipment.uuid = child.UUID.XmlText>
                        <cfset receipment.receiptmentid = child.ReceiptmentId.XmlText>
                        <cfset receipment.statuscode = child.StatusCode.XmlText>
                        <cfset receipment.receiptadvicetypecode = child.Receiptadvicetypecode.XmlText>
                        <cfset receipment.sendertaxid = child.Sendertaxid.XmlText>
                        <cfset receipment.receivertaxid = child.Receivertaxid.XmlText>
                        <cfset receipment.profileid = child.Profileid.XmlText>
                        <cfset receipment.issuedate = child.Issuedate.XmlText>
                        <cfset receipment.issuetime = child.Issuetime.XmlText>
                        <cfset receipment.partyname = child.Partyname.XmlText>
                        <cfset receipment.createdate = child.Createdate.XmlText>
                        <cfset receipment.direction = child.Direction.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.receipments, receipment )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="RejectDespatch" access="public" hint="Gelen irsaliyenin reddi için kullanılır">
        <cfargument name="uuid">
        <cfargument name="description" default="">
        <cfargument name="templatecode" default="">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="rejectdespatch_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:RejectDespatch>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:UUID>#arguments.uuid#</tem:UUID>
                        <tem:TemplateCode>#arguments.templatecode#</tem:TemplateCode>
                        <tem:Description>#arguments.description#</tem:Description>
                    </tem:RejectDespatch>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/RejectDespatch", rejectdespatch_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.receipments = arrayNew(1)>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.RejectDespatchResponse.RejectDespatchResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.RejectDespatchResponse.RejectDespatchResult.ServiceResultDescription.XmlText>
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.RejectDespatchResponse.RejectDespatchResult.ErrorCode.XmlText>
            <cfelse>
                <cfset resultdata.acceptorrejectdespatch = xmlresult.Envelope.Body.RejectDespatchResponse.RejectDespatchResult.AcceptOrRejectDespatch.XmlText>
                <cfloop array="#xmlresult.Envelope.Body.RejectDespatchResponse.RejectDespatchResult.Receipments.xmlchildren#" index="child">
                    <cfset receipment = structNew()>
                    <cfset receipment.serviceresult = child.ServiceResult.XmlText>
                    <cfif receipment.serviceresult eq "Error">
                        <cfset receipment.errorcode = child.ErrorCode.XmlText>
                    <cfelse>
                        <cfset receipment.uuid = child.UUID.XmlText>
                        <cfset receipment.receiptmentid = child.ReceiptmentId.XmlText>
                        <cfset receipment.statuscode = child.StatusCode.XmlText>
                        <cfset receipment.receiptadvicetypecode = child.Receiptadvicetypecode.XmlText>
                        <cfset receipment.sendertaxid = child.Sendertaxid.XmlText>
                        <cfset receipment.receivertaxid = child.Receivertaxid.XmlText>
                        <cfset receipment.profileid = child.Profileid.XmlText>
                        <cfset receipment.issuedate = child.Issuedate.XmlText>
                        <cfset receipment.issuetime = child.Issuetime.XmlText>
                        <cfset receipment.partyname = child.Partyname.XmlText>
                        <cfset receipment.createdate = child.Createdate.XmlText>
                        <cfset receipment.direction = child.Direction.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.receipments, receipment )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="SendDespatchDataToVirtualUser" access="public" hint="İrsaliyeyi e-irsaliye mükellefi olmayan gönderimi yapar">
        <cfargument name="ubl">

        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="despatchdatatovirtualuser_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:SendDespatchDataToVirtualUser>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:FileType>UBL</tem:FileType>
                        <tem:despatchRawData>#arguments.ubl#</tem:despatchRawData>
                        <tem:CorporateCode>#authvars.corporateCode#</tem:CorporateCode>
                        <tem:MapCode></tem:MapCode>
                    </tem:SendDespatchDataToVirtualUser>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/SendDespatchData", despatch_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            
            <cfset resultdata = structNew()>
            <cfset resultdata.despatches = arrayNew(1)>

            <cfset resultdata.serviceResult = xmlresult.Envelope.Body.SendDespatchDataToVirtualUserResponse.SendDespatchDataToVirtualUserResult.serviceResult.XmlText>
            
            <cfif resultdata.serviceResult eq "Error">
                <cfset resultdata.ServiceResultDescription = xmlresult.Envelope.Body.SendDespatchDataToVirtualUserResponse.SendDespatchDataToVirtualUserResult.ServiceResultDescription.XmlText>
                <cfset resultdata.ErrorCode = xmlresult.Envelope.Body.SendDespatchDataToVirtualUserResponse.SendDespatchDataToVirtualUserResult.ErrorCode.XmlText>
            <cfelse>
                <cfset resultdata.InstanceIdentifier = xmlresult.Envelope.Body.SendDespatchDataToVirtualUserResponse.SendDespatchDataToVirtualUserResult.InstanceIdentifier.XmlText>
                <cfloop array="#xmlresult.Envelope.Body.SendDespatchDataToVirtualUserResponse.SendDespatchDataToVirtualUserResult.Despatches.xmlchildren#" index="child">
                    <cfset despatch = structNew()>
                    <cfset despatch.errorcode = child.ErrorCode>
                    <cfif despathc.errorcode eq "0">
                        <cfset despatch.uuid = child.UUID>
                        <cfset despatch.despatchid = child.DespatchId>
                        <cfset despatch.statuscode = child.StatusCode>
                        <cfset despatch.referenceno = child.ReferenceNo>
                    </cfif>
                    <cfset arrayAppend( resultdata.despatches, despatch )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="GetEDespatchCustomerFullList" access="public" hint="E-İrsaliye müşteri listesini döndürür">
        <cfargument name="startdate" default="">
        
        <cfif len(startdate)>
            <cfreturn GetEDespatchCustomerListByDate(arguments.startdate)>
        </cfif>

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="despatchcustomerlist_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:GetEDespatchCustomerFullList>
                        <tem:Ticket>#ticket#</tem:Ticket>
                    </tem:GetEDespatchCustomerFullList>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/GetEDespatchCustomerFullList", despatchcustomerlist_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            
            <cfset resultdata = structNew()>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.GetEDespatchCustomerFullListResponse.GetEDespatchCustomerFullListResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.GetEDespatchCustomerFullListResponse.GetEDespatchCustomerFullListResult.ErrorCode.XmlText>
            <cfelse>
                <cfset resultdata.compressedfile = xmlresult.Envelope.Body.GetEDespatchCustomerFullListResponse.GetEDespatchCustomerFullListResult.CompressedFile.XmlText>
            </cfif>

            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="GetEDespatchCustomerListByDate" access="private" hint="E-İrsaliye müşteri listesini başlangıç tarihinden itibaren döndürür. Bu fonksiyona direk erişilmez full list olana tarih belirtildiğinde çalışır">
        <cfargument name="startdate">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="despatchcustomerlist_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:GetEDespatchCustomerListByDate>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:StartDate>#dateFormat(startdate, "yyyy-mm-dd")#</tem:StartDate>
                    </tem:GetEDespatchCustomerListByDate>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/GetEDespatchCustomerListByDate", despatchcustomerlist_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            
            <cfset resultdata = structNew()>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.GetEDespatchCustomerListByDateResponse.GetEDespatchCustomerListByDateResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.GetEDespatchCustomerListByDateResponse.GetEDespatchCustomerListByDateResult.ErrorCode.XmlText>
            <cfelse>
                <cfset resultdata.customerinfolist = arrayNew(1)>
                <cfloop array="#xmlresult.Envelope.Body.GetEDespatchCustomerListByDateResponse.GetEDespatchCustomerListByDateResult.CustomerInfoList.xmlchildren#" index="child">
                    <cfset edespatchcustomerresult = structNew()>
                    <cfset edespatchcustomerresult.taxidorpersonalid = child.TaxIdOrPersonalId.XmlText>
                    <cfset edespatchcustomerresult.alias = child.Alias.XmlText>
                    <cfset edespatchcustomerresult.type = child.Type.XmlText>
                    <cfset edespatchcustomerresult.name = child.Name.XmlText>
                    <cfset edespatchcustomerresult.registertime = child.RegisterTime.XmlText>
                    <cfset edespatchcustomerresult.isexist = child.IsExist.XmlText>
                    <cfset edespatchcustomerresult.firstcreationtime = child.FirstCreationTime.XmlText>
                    <cfset arrayAppend( resultdata.customerinfolist, edespatchcustomerresult )>
                </cfloop>
            </cfif>
        
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

</cfcomponent>