<cfcomponent name="YurticiKargoAdapter" output="false" hint="Yurtici Kargo Connector">
    
    <cfproperty name="DataStore" Inject="DataStore" />

    <cfset variables.partner = 'YURTICIKARGO' />
    <cfset variables.integration_id = 17 />

    <!----------------------------------- CONSTRUCTOR --------------------------------------->

    <cffunction name="init" access="public" returntype="any" output="false" hint="constructor">
        <cfreturn this />
    </cffunction>

    <!----------------------------------- PUBLIC METHODS --------------------------------------->

    <cffunction name="createShipment" access="public" returntype="void" output="false" hint="Kargo siparişi gönderi oluşturmak için kullanılır.">
        <cfparam name="createShipment_log_is_success" type="boolean" default="1" />
        <cfparam name="createShipment_log_status_code" type="string" default="" />
        <cfparam name="createShipment_log_message" type="string" default="" />

        <cfscript>
            createShipment_args             = structNew();
            createShipment_args.STATUS      = 1;
            createShipment_args.REF_SYSTEM  = 'SAP';
            createShipment_args.TAR_SYSTEM  = variables.partner;
            createShipment_getOrderChanges  = DataStore.getData(table="ORDER_CHANGES",args=createShipment_args);
            structClear(createShipment_args);
            createShipment_order_list  = valueList(createShipment_getOrderChanges.ORDER_ID);
            createShipment_order_list  = listRemoveDuplicates(createShipment_order_list);

            createShipment_wsInfo      = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
        </cfscript>

        <cfloop list="#createShipment_order_list#" index="item">
                <cfscript>
                    createShipment_log_is_success  = 1;
                    createShipment_log_status_code = '';
                    createShipment_log_message     = '';
                    createShipment_SOAP_Content     = '';
                    createShipment_SOAP_Result      = '';

                    createShipment_args.ORDER_ID    = item;
                    createShipment_order            = DataStore.getData(table="ORDERS", args=createShipment_args);
                    structClear(createShipment_args);
                </cfscript>

                <cfif createShipment_order.recordcount>
                    <cfoutput>
                        <cfsavecontent variable="createShipment_SOAP_Content">
                            <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
                            <soap:Body>
                                <createShipment xmlns="http://yurticikargo.com.tr/ShippingOrderDispatcherServices">
                                <wsUserName xmlns="">#createShipment_wsInfo.USER_NAME#</wsUserName>
                                <wsPassword xmlns="">#createShipment_wsInfo.PASSWD#</wsPassword>
                                <userLanguage xmlns="">TR</userLanguage>
                                <ShippingOrderVO xmlns="">
                                    <cargoKey>#createShipment_order.REF_CARGO_TRACKING_NUMBER#</cargoKey>
                                    <invoiceKey>#createShipment_order.REF_CARGO_TRACKING_NUMBER#</invoiceKey>
                                    <receiverCustName>#createShipment_order.REF_CUSTOMER_FIRST_NAME# #createShipment_order.REF_CUSTOMER_LAST_NAME#</receiverCustName>
                                    <receiverAddress>#createShipment_order.REF_SHIPMENT_FULL_ADDRESS#</receiverAddress>
                                    <cityName>#createShipment_order.REF_SHIPMENT_CITY_NAME#</cityName>
                                    <townName>#createShipment_order.REF_SHIPMENT_DISTRICT_NAME#</townName>
                                    <receiverPhone1>#createShipment_order.REF_SHIPMENT_PHONE#</receiverPhone1>
                                    <taxOfficeId>0</taxOfficeId>
                                    <cargoCount>0</cargoCount>
                                    <ttDocumentId>0</ttDocumentId>
                                    <dcSelectedCredit>0</dcSelectedCredit>
                                    <dcCreditRule>0</dcCreditRule>
                                </ShippingOrderVO>
                                </createShipment>
                            </soap:Body>
                            </soap:Envelope>
                        </cfsavecontent>
                    </cfoutput>

                    <cfset createShipment_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='createShipment', request=createShipment_SOAP_Content) />

                    <cfhttp url="#createShipment_wsInfo.address#" method="post" result="createShipment_SOAP_Result">
                        <cfhttpparam type="header" name="content-type" value="text/xml" />
                        <cfhttpparam type="header" name="content-length" value="#Len(createShipment_SOAP_Content)#" />
                        <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                        <cfhttpparam type="header" name="charset" value="utf-8" />
                        <cfhttpparam type="xml" value="#Trim(createShipment_SOAP_Content)#" />
                    </cfhttp>

                    <cfscript>
                        createShipment_log_status_code = createShipment_SOAP_Result.StatusCode;

                        if (Not Len(createShipment_SOAP_Result.ErrorDetail)) {
    
                            getCreateShipment_Response = xmlParse(createShipment_SOAP_Result.FileContent).Envelope.Body.createShipmentResponse.ShippingOrderResultVO;
                            responseData    = getCreateShipment_Response.outFlag.XmlText;
                            errCode         = getCreateShipment_Response.shippingOrderDetailVO.errCode.XmlText;//errCode is '60020' talep nolu(JOB_ID) barkodlu(CARGO_KEY) gönderi sistemde mevcuttur.
                            if(responseData is '0' Or errCode is '60020')
                            {
                                createShipment_log_is_success  = 1;
                                createShipment_log_message    = responseData;
    
                                createShipment_args.STATUS      = 1;
                                createShipment_args.REF_SYSTEM  = 'SAP';
                                createShipment_args.TAR_SYSTEM  = variables.partner;
                                createShipment_args.ORDER_ID    = item;
                                createShipment_getOrderChanges  = DataStore.getData(table="ORDER_CHANGES",args=createShipment_args);
                                structClear(createShipment_args);
                                for (i=1; i <=createShipment_getOrderChanges.recordcount; i++) {
                                    DataStore.updateOrderChanges(cId=createShipment_getOrderChanges.ID[i]);
                                }
                            }
                            else {
                                createShipment_log_is_success  = 0;
                                createShipment_log_message     = responseData;
                            }
                        }
                        else {
                            createShipment_log_is_success  = 0;
                            createShipment_log_message    = createShipment_SOAP_Result.FileContent;
                            
                        }
                        DataStore.serviceLog(
                                log_id=createShipment_service_log_id,
                                is_success=createShipment_log_is_success,
                                request=DataStore.clearJSONContent(JSONContent=createShipment_SOAP_Content),
                                response=DataStore.clearJSONContent(JSONContent=createShipment_SOAP_Result.FileContent),
                                status_code=createShipment_log_status_code,
                                message=createShipment_log_message
                        );
                    </cfscript>
                </cfif>
        </cfloop>

    </cffunction>

    <!----------------------------------- PRIVATE METHODS --------------------------------------->

</cfcomponent>