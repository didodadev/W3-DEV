<cfcomponent name="MNGKargoAdapter" output="false" hint="MNG Kargo Connector">
    
    <cfproperty name="DataStore" Inject="DataStore" />
    <cfproperty name="OMailService" Inject="provider:mailService@cbmailservices" />
    <cfproperty name="appName" inject="coldbox:setting:appName" />
    <cfproperty name="alertEmails" inject="coldbox:setting:alertEmails" />

    <cfset variables.partner = 'MNG' />
    <cfset variables.integration_id = 11 />

    <!----------------------------------- CONSTRUCTOR --------------------------------------->

    <cffunction name="init" access="public" returntype="any" output="false" hint="constructor">
        <cfreturn this />
    </cffunction>

    <!----------------------------------- PUBLIC METHODS --------------------------------------->

    <cffunction name="siparisGirisiDetayliV3" access="public" returntype="void" output="false" hint="Kargo siparişi yaratma isteği gönderir.">

        <cfparam name="log_is_success" type="boolean" default="1" />
        <cfparam name="log_status_code" type="string" default="" />
        <cfparam name="log_message" type="string" default="" />

        <cfscript>
            siparisGirisiDetayliV3_args             = structNew();
            siparisGirisiDetayliV3_args.STATUS      = 1;
            siparisGirisiDetayliV3_args.REF_SYSTEM  = 'SAP';
            siparisGirisiDetayliV3_args.TAR_SYSTEM  = variables.partner;
            siparisGirisiDetayliV3_getOrderChanges  = DataStore.getData(table="ORDER_CHANGES",args=siparisGirisiDetayliV3_args);
            structClear(siparisGirisiDetayliV3_args);
            siparisGirisiDetayliV3_order_list  = valueList(siparisGirisiDetayliV3_getOrderChanges.ORDER_ID);
            siparisGirisiDetayliV3_order_list  = listRemoveDuplicates(siparisGirisiDetayliV3_order_list);

            siparisGirisiDetayliV3_wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
        </cfscript>

        <cfloop list="#siparisGirisiDetayliV3_order_list#" index="item">
            <cfscript>
                siparisGirisiDetayliV3_log_is_success   = 1;
                siparisGirisiDetayliV3_log_status_code  = '';
                siparisGirisiDetayliV3_log_message      = '';
                siparisGirisiDetayliV3_SOAP_Content     = '';
                siparisGirisiDetayliV3_SOAP_Result      = '';

                siparisGirisiDetayliV3_args.ORDER_ID    = item;
                siparisGirisiDetayliV3_order_row        = DataStore.getData(table="ORDER_ROWS", args=siparisGirisiDetayliV3_args);
                structClear(siparisGirisiDetayliV3_args);

                parcaIcerikList = '';
                for (i=1; i<=siparisGirisiDetayliV3_order_row.recordcount; i++) {
                    siparisGirisiDetayliV3_args.PRODUCT_CODE= siparisGirisiDetayliV3_order_row.REF_PRODUCT_CODE[i];
                    siparisGirisiDetayliV3_product[i]   = DataStore.getData(table="PRODUCT", args=siparisGirisiDetayliV3_args);
                    //siparisGirisiDetayliV3_desi             = (siparisGirisiDetayliV3_product.EN_BASE_UNIT * siparisGirisiDetayliV3_product.BOY_BASE_UNIT * siparisGirisiDetayliV3_product.U_BASE_UNIT) / 30000;
                    structClear(siparisGirisiDetayliV3_args);
                    parcaIcerikList = parcaIcerikList & '#Int(siparisGirisiDetayliV3_product[i].AGIRLIK_B_BASE_UNIT)#:1:1:#siparisGirisiDetayliV3_product[i].PRODUCT_NAME#:#siparisGirisiDetayliV3_order_row.REF_QUANTITY[i]#:;';
                }

                siparisGirisiDetayliV3_args.ORDER_ID    = item;
                siparisGirisiDetayliV3_order            = DataStore.getData(table="ORDERS", args=siparisGirisiDetayliV3_args);
                structClear(siparisGirisiDetayliV3_args);
            </cfscript>

            <cfif siparisGirisiDetayliV3_order.recordcount>
                <cfsavecontent variable="siparisGirisiDetayliV3_SOAP_Content"><cfoutput>
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <tem:SiparisGirisiDetayliV3>
                            <tem:pChIrsaliyeNo></tem:pChIrsaliyeNo>
                            <tem:pPrKiymet></tem:pPrKiymet>
                            <tem:pChBarkod></tem:pChBarkod>
                            <tem:pChIcerik>#siparisGirisiDetayliV3_order_row.REF_PRODUCT_NAME#</tem:pChIcerik>
                            <tem:pGonderiHizmetSekli>NORMAL</tem:pGonderiHizmetSekli>
                            <tem:pTeslimSekli>1</tem:pTeslimSekli>
                            <tem:pFlAlSms>0</tem:pFlAlSms>
                            <tem:pFlGnSms>0</tem:pFlGnSms>
                            <tem:pKargoParcaList>#parcaIcerikList#</tem:pKargoParcaList>
                            <tem:pAliciMusteriMngNo></tem:pAliciMusteriMngNo>
                            <tem:pAliciMusteriBayiNo></tem:pAliciMusteriBayiNo>
                            <tem:pAliciMusteriAdi>#siparisGirisiDetayliV3_order.REF_CUSTOMER_FIRST_NAME# #siparisGirisiDetayliV3_order.REF_CUSTOMER_LAST_NAME#</tem:pAliciMusteriAdi>
                            <tem:pChSiparisNo>#siparisGirisiDetayliV3_order.TAR_ORDER_ID#</tem:pChSiparisNo>
                            <tem:pLuOdemeSekli>P</tem:pLuOdemeSekli>
                            <tem:pFlAdresFarkli>1</tem:pFlAdresFarkli>
                            <tem:pChIl>#siparisGirisiDetayliV3_order.REF_SHIPMENT_CITY_NAME#</tem:pChIl>
                            <tem:pChIlce>#siparisGirisiDetayliV3_order.REF_SHIPMENT_DISTRICT_NAME#</tem:pChIlce>
                            <tem:pChAdres>#siparisGirisiDetayliV3_order.REF_SHIPMENT_ADDRESS_1#</tem:pChAdres>
                            <tem:pChSemt></tem:pChSemt>
                            <tem:pChMahalle></tem:pChMahalle>
                            <tem:pChMeydanBulvar></tem:pChMeydanBulvar>
                            <tem:pChCadde></tem:pChCadde>
                            <tem:pChSokak></tem:pChSokak>
                            <tem:pChTelEv></tem:pChTelEv>
                            <tem:pChTelCep>#siparisGirisiDetayliV3_order.REF_SHIPMENT_PHONE#</tem:pChTelCep>
                            <tem:pChTelIs></tem:pChTelIs>
                            <tem:pChFax></tem:pChFax>
                            <tem:pChEmail></tem:pChEmail>
                            <tem:pChVergiDairesi></tem:pChVergiDairesi>
                            <tem:pChVergiNumarasi></tem:pChVergiNumarasi>
                            <tem:pFlKapidaOdeme>0</tem:pFlKapidaOdeme>
                            <tem:pMalBedeliOdemeSekli></tem:pMalBedeliOdemeSekli>
                            <tem:pPlatformKisaAdi><cfif siparisGirisiDetayliV3_order.PARTNER is 'N11'>#siparisGirisiDetayliV3_order.PARTNER#</cfif></tem:pPlatformKisaAdi>
                            <tem:pPlatformSatisKodu><cfif siparisGirisiDetayliV3_order.PARTNER is 'N11'></cfif></tem:pPlatformSatisKodu>
                            <tem:pKullaniciAdi>#siparisGirisiDetayliV3_wsInfo.USER_NAME#</tem:pKullaniciAdi>
                            <tem:pSifre>#siparisGirisiDetayliV3_wsInfo.PASSWD#</tem:pSifre>
                        </tem:SiparisGirisiDetayliV3>
                    </soapenv:Body>
                    </soapenv:Envelope></cfoutput>
                </cfsavecontent>

                <cfset siparisGirisiDetayliV3_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='siparisGirisiDetayliV3', request=siparisGirisiDetayliV3_SOAP_Content) />

                <cfhttp
                    url="#siparisGirisiDetayliV3_wsInfo.ADDRESS#"
                    method="POST"
                    result="siparisGirisiDetayliV3_SOAP_Result">
                    <cfhttpparam type="xml" value="#Trim(siparisGirisiDetayliV3_SOAP_Content)#" />
                </cfhttp>

                <cfscript>
                    siparisGirisiDetayliV3_log_status_code = siparisGirisiDetayliV3_SOAP_Result.StatusCode;
                    siparisGirisiDetayliV3_responseData = xmlParse(siparisGirisiDetayliV3_SOAP_Result.FileContent).Envelope.Body.SiparisGirisiDetayliV3Response;
                    if(structKeyExists(siparisGirisiDetayliV3_responseData,"SiparisGirisiDetayliV3Result")){
                        responseData = siparisGirisiDetayliV3_responseData.SiparisGirisiDetayliV3Result.XmlText;

                        if(responseData Eq 1 Or responseData Eq 'E005:BU SİPARİS NUMARASINA AİT KAYIT ZATEN VAR! [5]'){
                            siparisGirisiDetayliV3_log_is_success  = 1;
                            siparisGirisiDetayliV3_log_message     = responseData;

                            siparisGirisiDetayliV3_args.STATUS      = 1;
                            siparisGirisiDetayliV3_args.REF_SYSTEM  = 'SAP';
                            siparisGirisiDetayliV3_args.TAR_SYSTEM  = variables.partner;
                            siparisGirisiDetayliV3_args.ORDER_ID    = item;
                            siparisGirisiDetayliV3_getOrderChanges  = DataStore.getData(table="ORDER_CHANGES",args=siparisGirisiDetayliV3_args);
                            structClear(siparisGirisiDetayliV3_args);
                            for (i=1; i <=siparisGirisiDetayliV3_getOrderChanges.recordcount; i++) {
                                DataStore.updateOrderChanges(cId=siparisGirisiDetayliV3_getOrderChanges.ID[i]);
                            }
                        }
                        else{
                            siparisGirisiDetayliV3_log_is_success  = 0;
                            siparisGirisiDetayliV3_log_message     = responseData;
                        }
                    }
                    else{
                        siparisGirisiDetayliV3_log_is_success  = 0;
                        siparisGirisiDetayliV3_log_message     = siparisGirisiDetayliV3_responseData;
                    }

                    DataStore.serviceLog(
                        log_id=siparisGirisiDetayliV3_service_log_id,
                        is_success=siparisGirisiDetayliV3_log_is_success,
                        response=siparisGirisiDetayliV3_SOAP_Result.FileContent,
                        status_code=siparisGirisiDetayliV3_log_status_code,
                        message=siparisGirisiDetayliV3_log_message
                    );
                </cfscript>
            </cfif>
            <cfset parcaIcerikList = '' />
        </cfloop>

    </cffunction>

    <cffunction name="kargoBilgileriByReferans" access="public" returntype="void" output="false" hint="Kargo takip no alanı boş olan siparişlerin MNG Kargo sistemindeki kargo bilgilerini alır ve sipariş üzerindeki kargo takip no alanını günceller.">

        <cfparam name="KargoBilgileriByReferans_log_is_success" type="boolean" default="1" />
        <cfparam name="KargoBilgileriByReferans_log_status_code" type="string" default="" />
        <cfparam name="KargoBilgileriByReferans_log_message" type="string" default="" />

        <cfscript>
            KargoBilgileriByReferans_args                   = structNew();
            KargoBilgileriByReferans_args.PARTNER           = 'RUUMSTORE';
            KargoBilgileriByReferans_args.REF_STATUS_NAME   = 'ReadyToShip';
            KargoBilgileriByReferans_args_isnull            = 'REF_CARGO_TRACKING_NUMBER';
            KargoBilgileriByReferans_args_isnotnull         = 'TAR_ORDER_ID';
            KargoBilgileriByReferans_orders                 = DataStore.getData(table="ORDERS", args=KargoBilgileriByReferans_args, args_isnull=KargoBilgileriByReferans_args_isnull, args_isnotnull=KargoBilgileriByReferans_args_isnotnull);
            KargoBilgileriByReferans_wsInfo                 = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
        </cfscript>

        <cfif KargoBilgileriByReferans_orders.recordcount>
            <cfloop query="KargoBilgileriByReferans_orders">
                <cfscript>
                    KargoBilgileriByReferans_log_is_success = 1;
                    KargoBilgileriByReferans_log_status_code = '';
                    KargoBilgileriByReferans_log_message = '';
                    KargoBilgileriByReferans_SOAP_Content = '';
                    KargoBilgileriByReferans_SOAP_Result = '';
                </cfscript>

                <cfsavecontent variable="KargoBilgileriByReferans_SOAP_Content"><cfoutput>
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <tem:KargoBilgileriByReferans>
                            <tem:pMusteriNo>#KargoBilgileriByReferans_wsInfo.USER_NAME#</tem:pMusteriNo>
                            <tem:pSifre>#KargoBilgileriByReferans_wsInfo.PASSWD#</tem:pSifre>
                            <tem:pSiparisNo>#TAR_ORDER_ID#</tem:pSiparisNo>
                            <tem:pGonderiNo></tem:pGonderiNo>
                            <tem:pFaturaSeri></tem:pFaturaSeri>
                            <tem:pFaturaNo></tem:pFaturaNo>
                            <tem:pIrsaliyeNo></tem:pIrsaliyeNo>
                            <tem:pEFaturaNo></tem:pEFaturaNo>
                            <tem:pRaporType></tem:pRaporType>
                        </tem:KargoBilgileriByReferans>
                    </soapenv:Body>
                    </soapenv:Envelope></cfoutput>
                </cfsavecontent>

                <cfset KargoBilgileriByReferans_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='kargoBilgileriByReferans', request=KargoBilgileriByReferans_SOAP_Content) />

                <cfhttp
                    url="#KargoBilgileriByReferans_wsInfo.ADDRESS#"
                    method="POST"
                    result="KargoBilgileriByReferans_SOAP_Result">
                    <cfhttpparam type="xml" value="#Trim(KargoBilgileriByReferans_SOAP_Content)#" />
                </cfhttp>

                <cfscript>
                    KargoBilgileriByReferans_log_status_code = KargoBilgileriByReferans_SOAP_Result.StatusCode;
                    KargoBilgileriByReferans_responseData = xmlParse(KargoBilgileriByReferans_SOAP_Result.FileContent).Envelope.Body.KargoBilgileriByReferansResponse;

                    if(structKeyExists(KargoBilgileriByReferans_responseData,"KargoBilgileriByReferansResult")){
                        KargoBilgileriByReferans_responseData = KargoBilgileriByReferans_responseData.KargoBilgileriByReferansResult.diffgram.NewDataSet.Table1.XmlChildren;
                        KargoBilgileriByReferans_responseCount = arrayLen(KargoBilgileriByReferans_responseData);
                    
                        MNG_GONDERI_NO  = '';
                        KARGO_TAKIP_URL = '';

                        for(e=1; e <=KargoBilgileriByReferans_responseCount; e++){
                            if(KargoBilgileriByReferans_responseData[e].XmlName is 'MNG_GONDERI_NO'){
                                MNG_GONDERI_NO  = KargoBilgileriByReferans_responseData[e].XmlText;
                            }
                            if(KargoBilgileriByReferans_responseData[e].XmlName is 'KARGO_TAKIP_URL'){
                                KARGO_TAKIP_URL = KargoBilgileriByReferans_responseData[e].XmlText;
                            }
                        }

                        if (Len(MNG_GONDERI_NO) And Len(KARGO_TAKIP_URL)) {
                            DataStore.updateOrder(order_id=ORDER_ID,ref_cargo_tracking_number=MNG_GONDERI_NO, ref_cargo_tracking_url=KARGO_TAKIP_URL);
                        }

                        KargoBilgileriByReferans_log_is_success  = 1;
                        MNG_GONDERI_NO  = '';
                        KARGO_TAKIP_URL = '';
                    }
                    else if(structKeyExists(KargoBilgileriByReferans_responseData,"pWsError")){
                        DataStore.updateOrder(order_id=ORDER_ID,ref_cargo_tracking_number='0', ref_cargo_tracking_url='0');
                    }
                    else {
                        KargoBilgileriByReferans_log_is_success  = 0;
                    }

                    DataStore.serviceLog(
                        log_id=KargoBilgileriByReferans_service_log_id,
                        is_success=KargoBilgileriByReferans_log_is_success,
                        response=KargoBilgileriByReferans_SOAP_Result.FileContent,
                        status_code=KargoBilgileriByReferans_log_status_code
                    );
                </cfscript>
            </cfloop>
        </cfif>

    </cffunction>

    <cffunction name="kargoDurumSorgula" access="public" returntype="void" output="false" hint="Kargo durumunu sorgular ve Octopus üzerinde siparişi günceller.">

        <cfparam name="kargoDurumSorgula_log_is_success" type="boolean" default="1" />
        <cfparam name="kargoDurumSorgula_log_status_code" type="string" default="" />
        <cfparam name="kargoDurumSorgula_log_message" type="string" default="" />

        <cfscript>
            kargoDurumSorgula_args                      = structNew();
            kargoDurumSorgula_args.PARTNER              = 'RUUMSTORE';
            kargoDurumSorgula_args_in.REF_STATUS_NAME   = 'Created,ReadyToShip,Invoiced,Shipped';
            kargoDurumSorgula_orders                    = DataStore.getData(table="ORDERS", args=kargoDurumSorgula_args, args_in=kargoDurumSorgula_args_in);
            kargoDurumSorgula_wsInfo                    = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
        </cfscript>

        <cfif kargoDurumSorgula_orders.recordcount>
            <cfloop query="kargoDurumSorgula_orders">
                <cfscript>
                    kargoDurumSorgula_log_is_success    = 1;
                    kargoDurumSorgula_log_status_code   = '';
                    kargoDurumSorgula_log_message       = '';
                    kargoDurumSorgula_SOAP_Content      = '';
                    kargoDurumSorgula_SOAP_Result       = '';
                </cfscript>

                <cfsavecontent variable="kargoDurumSorgula_SOAP_Content"><cfoutput>
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <tem:KargoBilgileriByReferans>
                            <tem:pMusteriNo>#kargoDurumSorgula_wsInfo.USER_NAME#</tem:pMusteriNo>
                            <tem:pSifre>#kargoDurumSorgula_wsInfo.PASSWD#</tem:pSifre>
                            <tem:pSiparisNo>#TAR_ORDER_ID#</tem:pSiparisNo>
                            <tem:pGonderiNo></tem:pGonderiNo>
                            <tem:pFaturaSeri></tem:pFaturaSeri>
                            <tem:pFaturaNo></tem:pFaturaNo>
                            <tem:pIrsaliyeNo></tem:pIrsaliyeNo>
                            <tem:pEFaturaNo></tem:pEFaturaNo>
                            <tem:pRaporType></tem:pRaporType>
                        </tem:KargoBilgileriByReferans>
                    </soapenv:Body>
                    </soapenv:Envelope></cfoutput>
                </cfsavecontent>

                <cfset kargoDurumSorgula_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='kargoDurumSorgula', request=kargoDurumSorgula_SOAP_Content) />

                <cfhttp
                    url="#kargoDurumSorgula_wsInfo.ADDRESS#"
                    method="POST"
                    result="kargoDurumSorgula_SOAP_Result">
                    <cfhttpparam type="xml" value="#Trim(kargoDurumSorgula_SOAP_Content)#" />
                </cfhttp>

                <cfscript>
                    kargoDurumSorgula_log_status_code = kargoDurumSorgula_SOAP_Result.StatusCode;
                    kargoDurumSorgula_responseData = xmlParse(kargoDurumSorgula_SOAP_Result.FileContent).Envelope.Body.KargoBilgileriByReferansResponse;

                    if(structKeyExists(kargoDurumSorgula_responseData,"KargoBilgileriByReferansResult")){
                        kargoDurumSorgula_responseData = kargoDurumSorgula_responseData.KargoBilgileriByReferansResult.diffgram.NewDataSet.Table1.XmlChildren;
                        kargoDurumSorgula_responseCount = arrayLen(kargoDurumSorgula_responseData);
                    
                        KARGO_STATU     = 0;

                        for(e=1; e <=kargoDurumSorgula_responseCount; e++){
                            if(kargoDurumSorgula_responseData[e].XmlName is 'KARGO_STATU'){
                                KARGO_STATU     = kargoDurumSorgula_responseData[e].XmlText;
                            }
                        }

                        if (KARGO_STATU Eq 1 And REF_STATUS_NAME Neq 'Shipped') {//kargoya verildi
                            DataStore.updateOrder(order_id=ORDER_ID, ref_status_name='Shipped');

                            if (PARTNER Eq 'RUUMSTORE') {
                                args    = structNew();
                                args.ORDER_ID   = ORDER_ID;
                                get_order_row   = DataStore.getData(table='ORDER_ROWS', args=args);
                                DataStore.addOrderChanges(
                                    order_id=ORDER_ID,
                                    row_number=get_order_row.ROW_NUMBER,
                                    ref_order_id=REF_ORDER_ID,
                                    ref_order_row_id=get_order_row.REF_ORDER_ROW_ID,
                                    ref_system=variables.partner,
                                    tar_system=PARTNER,
                                    quantity=get_order_row.REF_QUANTITY,
                                    status_name='Shipped');
                            }
                        }
                        else if ((KARGO_STATU Eq 5 Or KARGO_STATU Eq 7) And REF_STATUS_NAME Neq 'Delivered') {//teslim edildi
                            DataStore.updateOrder(order_id=ORDER_ID, ref_status_name='Delivered');

                            if (PARTNER Eq 'RUUMSTORE') {
                                args    = structNew();
                                args.ORDER_ID   = ORDER_ID;
                                get_order_row   = DataStore.getData(table='ORDER_ROWS', args=args);
                                DataStore.addOrderChanges(
                                    order_id=ORDER_ID,
                                    row_number=get_order_row.ROW_NUMBER,
                                    ref_order_id=REF_ORDER_ID,
                                    ref_order_row_id=get_order_row.REF_ORDER_ROW_ID,
                                    ref_system=variables.partner,
                                    tar_system=PARTNER,
                                    quantity=get_order_row.REF_QUANTITY,
                                    status_name='Delivered');
                            }
                        }

                        kargoDurumSorgula_log_is_success  = 1;
                        KARGO_STATU     = 0;
                    }
                    else {
                        kargoDurumSorgula_log_is_success  = 0;
                    }

                    DataStore.serviceLog(
                        log_id=kargoDurumSorgula_service_log_id,
                        is_success=kargoDurumSorgula_log_is_success,
                        response=kargoDurumSorgula_SOAP_Result.FileContent,
                        status_code=kargoDurumSorgula_log_status_code
                    );
                </cfscript>
            </cfloop>
        </cfif>

    </cffunction>

    

    <!----------------------------------- PRIVATE METHODS --------------------------------------->

</cfcomponent>