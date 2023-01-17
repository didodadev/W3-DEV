<cfif isdefined("attributes.receiving_detail_id") and len(attributes.receiving_detail_id)>
    <cfset eshipment = createObject("Component","V16.e_government.cfc.eirsaliye.common")>
    <cfset eshipment.dsn = dsn>
    <cfset eshipment.dsn2 = dsn2>
    <cfset GET_ESHIPMENT_DET = eshipment.GET_ESHIPMENT_DETAIL(receiving_detail_id:attributes.receiving_detail_id)>
    <cfquery name="getCompInfo" datasource="#dsn2#">
        SELECT EII.ESHIPMENT_TYPE_ALIAS FROM #dsn#.ESHIPMENT_INTEGRATION_INFO AS EII LEFT JOIN #dsn#.OUR_COMPANY AS C ON EII.COMP_ID = C.COMP_ID JOIN #dsn#.OUR_COMPANY_INFO AS OCI ON C.COMP_ID = OCI.COMP_ID WHERE IS_ESHIPMENT = 1 AND C.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
   <!---  <cfset getCompInfo = eshipment.get_our_company_fnc(company_id:session.ep.company_id)> --->
    <!--- <cffunction name="add_counter" returntype="any">
        <cfargument name="wex_integrator">
         <!--- wex counter kaydı atılıyor --->
            <cftry>
                <cfquery name="get_license_id" datasource="#dsn2#">
                    SELECT TOP 1 WORKCUBE_ID FROM #dsn#.WRK_LICENSE ORDER BY LICENSE_ID DESC
                </cfquery>
                <cfhttp url="http://wex.workcube.com/wex.cfm/e-government_paper/addCounter" charset="utf-8" result="result">
                    <cfhttpparam name="subscription_no" type="formfield" value="#get_license_id.WORKCUBE_ID#" />
                    <cfhttpparam name="domain" type="formfield" value="#cgi.http_host#" />
                    <cfhttpparam name="domain_ip" type="formfield" value="#cgi.local_addr#" />
                    <cfhttpparam name="product_id" type="formfield" value="8780" />
                    <cfhttpparam name="amount" type="formfield" value="1" />
                    <cfhttpparam name="process_type" type="formfield" value="#form.process_cat#" />
                    <cfhttpparam name="process_doc_no" type="formfield" value="#SHIP_NUMBER#" />
                    <cfhttpparam name="process_date" type="formfield" value="#dateFormat(attributes.SHIP_DATE,dateformat_style)#" />
                    <cfhttpparam name="wex_type" type="formfield" value="E-Irsaliye" />
                    <cfhttpparam name="wex_integrator" type="formfield" value="#getCompInfo.eshipment_type_alias#" />
                    <cfhttpparam name="counter_incoming" type="formfield" value="1" />
                </cfhttp>
                <cfset responseService = result.FileContent>
                <cfset responseWex = deserializeJson(responseService) />
                <cfif responseWex.status neq 1>
                    <script type = "text/javascript">
                        alert('İşlem başarılı, ancak wex kaydı yapılamadı! Lütfen sistem yöneticinize bilgi veriniz!');
                    </script>
                </cfif>
                <cfcatch>
                    <cfdump var="#cfcatch#">
                </cfcatch>
            </cftry>
            <!--- //wex counter kaydı atılıyor --->
    </cffunction> --->
    <cfif getCompInfo.eshipment_type_alias eq 'dp'>
        <cfset soap = createObject("Component","V16.e_government.cfc.eirsaliye.soap")>
        <cfset soap.init()>
        <cftry>
            <cfset resultdata = soap.AcceptDespatch(uuid : GET_ESHIPMENT_DET.UUID)>
            <cfcatch>
                <cfoutput>#cfcatch.message#</cfoutput>
            </cfcatch>
        </cftry>
        <!--- hata kodu 30 geliyorsa  7 gun ıcınde onaylanmamıs otomatık olarak onaylanmıstır. sisteme alıyoruz. --->
        <cfif isDefined("resultdata") and ( (resultdata.serviceresult eq 'Successful') or resultdata.errorcode eq 30 ) >  
            <cfset UPD_STATUS = eshipment.UPD_ESHIPMENT_STATUS(receiving_detail_id:attributes.receiving_detail_id, status : 1, ship_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL)>
            <!--- <cfset add_counter()> --->
        <cfelse>
            <cftransaction action="rollback">
            <script>
                alert("<cfoutput>#resultdata.serviceresultdescription#</cfoutput>");
                document.location.href = '/index.cfm?fuseaction=stock.received_eshipment';
            </script>
            <cfabort>
        </cfif>
    <cfelseif getCompInfo.eshipment_type_alias eq 'spr'>
        <cfset soap = createObject("Component","V16.e_government.cfc.super.eshipment.soap")>
        <cfset soap.init()>
        <cftry>
            <cfset resultdata = soap.AcceptDespatch(uuid : GET_ESHIPMENT_DET.UUID)>
            <cfcatch>
                <cfoutput>#cfcatch.message#</cfoutput>
            </cfcatch>
        </cftry>
        <!--- hata kodu 30 geliyorsa  7 gun ıcınde onaylanmamıs otomatık olarak onaylanmıstır. sisteme alıyoruz. --->
        <cfif isDefined("resultdata") and resultdata.serviceresult eq 'Success' >  
            <cfset UPD_STATUS = eshipment.UPD_ESHIPMENT_STATUS(receiving_detail_id:attributes.receiving_detail_id, status : 1, ship_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL)>
            <!--- <cfset add_counter()> --->
        <cfelse>
            <cftransaction action="rollback">
            <script>
                alert("<cfoutput>#resultdata.serviceresult#</cfoutput>");
                document.location.href = '/index.cfm?fuseaction=stock.received_eshipment';
            </script>
            <cfabort>
        </cfif>
    <cfelseif getCompInfo.eshipment_type_alias eq 'dgn'>
        <cfset soap = createObject("Component","V16.e_government.cfc.dogan.eirsaliye.soap")>
        <cfset soap.init()>

        <cfset getCompAddress = eshipment.getCompanyAdrress(company_id:session.ep.company_id)>
        <cfset control = eshipment.ShipmentCancelControl(action_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL)>
        <cfif len(control.COMPANY_ID)>
            <cfset get_ship = eshipment.getShipment(action_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL, company_id : control.COMPANY_ID, temp_currency_code : 0)>
        <cfelseif len(control.CONSUMER_ID)>
            <cfset get_ship = eshipment.getShipment(action_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL, consumer_id : control.CONSUMER_ID, temp_currency_code : 0)>
        <cfelse>
            <cfset get_ship = eshipment.getShipment(action_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL, temp_currency_code : 0 )>
        </cfif>

        <cfset get_ship_row = eshipment.getShipmentRow(ship_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL, temp_currency_code : 0)>
        <cfinclude template="eshipment_receipt_advice.cfm" />

        <cftry>
            <cfset resultdata = soap.AcceptDespatch(
                                                    uuid : GET_ESHIPMENT_DET.UUID,
                                                    sender_vkn : GET_ESHIPMENT.SENDER_TAX_ID,
                                                    sender_alias : GET_ESHIPMENT.SENDER_POSTBOX_NAME,
                                                    receiver_vkn : GET_ESHIPMENT_DET.RECEIVER_TAX_ID,
                                                    receiver_alias : GET_ESHIPMENT_DET.RECEIVER_POSTBOX_NAME,
                                                    ubl : eshipment_data
                                                )>
            <cfcatch>
                <cfoutput>#cfcatch.message#</cfoutput>
            </cfcatch>
        </cftry>
        <cfif isDefined("resultdata") and resultdata.serviceresult eq 'Success' >  
            <cfset UPD_STATUS = eshipment.UPD_ESHIPMENT_STATUS(receiving_detail_id:attributes.receiving_detail_id, status : 1, ship_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL)>
            <!--- <cfset add_counter()> --->
        <cfelse>
            <cftransaction action="rollback">
            <script>
                alert("<cfoutput>#resultdata.serviceresult#</cfoutput>");
                document.location.href = '/index.cfm?fuseaction=stock.received_eshipment';
            </script>
            <cfabort>
        </cfif>
    </cfif>
</cfif>