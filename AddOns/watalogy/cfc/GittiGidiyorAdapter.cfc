<cfcomponent name="GittiGidiyorAdapter" output="false" hint="GittiGidiyor MarkepPlace Adapter">

    <cfproperty name="DataStore" Inject="DataStore" />
    <cfproperty name="ContentServer" Inject="ContentServerAdapter" />
    <cfproperty name="SAP" Inject="SAPAdapter" />

    <cfset variables.partner = 'GITTIGIDIYOR' />
    <cfset variables.integration_id = 13 />

    <!----------------------------------- CONSTRUCTOR --------------------------------------->

    <cffunction name="init" access="public" returntype="any" output="false" hint="constructor">
        <cfreturn this />
    </cffunction>

    <!----------------------------------- PUBLIC METHODS --------------------------------------->

    <cffunction name="getCategoryAttributesId" access="public" returntype="void" output="false" hint="N11 kategori servisinden zorunlu olan kategori özelliklerini alır">
        <cfscript>
            args            = structNew();
            args.PARTNER    = variables.partner;
            getProductCategory = DataStore.getData(table="PRODUCT_CATEGORY",args=args);
            wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=12);
        </cfscript>

        <cfif getProductCategory.recordcount>
            <cfloop from="1" to="#getProductCategory.recordcount#" index="e">
                <cfscript>
                    log_is_success  = 1;
                    log_request     = '';
                    log_response    = '';
                    log_status_code = '';
                    log_message     = '';
                    service_log_id  = DataStore.serviceLog(partner=variables.partner, logger='getCategoryAttributesId');
                </cfscript>

                <cfoutput><cfsavecontent variable="getProductCategory_Request">
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
                    <soapenv:Header/>
                    <soapenv:Body>
                       <sch:GetCategoryAttributesIdRequest>
                          <auth>
                            <appKey>#wsInfo.user_name#</appKey>
                            <appSecret>#wsInfo.passwd#</appSecret>
                          </auth>
                          <categoryId>#getProductCategory.PARTNER_CAT_ID[e]#</categoryId>
                       </sch:GetCategoryAttributesIdRequest>
                    </soapenv:Body>
                    </soapenv:Envelope></cfsavecontent>
                </cfoutput>

                <cfhttp url="#wsInfo.address#/ws/categoryService.wsdl" method="post" result="getProductCategory_Result">
                    <cfhttpparam type="header" name="content-type" value="text/xml" />
                    <cfhttpparam type="header" name="content-length" value="#Len(getProductCategory_Request)#" />
                    <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                    <cfhttpparam type="header" name="charset" value="utf-8" />
                    <cfhttpparam type="xml" value="#Trim(getProductCategory_Request)#" />
                </cfhttp>

                <cfscript>
                    log_request     = getProductCategory_Request;
                    log_status_code = getProductCategory_Result.StatusCode;
                    
                    if (Not Len(getProductCategory_Result.ErrorDetail)) {
                        getProductCategory_Response = xmlParse(getProductCategory_Result.FileContent).Envelope.Body.GetCategoryAttributesIdResponse.categoryProductAttributeList.XmlChildren;
                        for (i=1; i<=ArrayLen(getProductCategory_Response); i++) {
                            categoryProductAttribute[i]                 = structNew('ordered');
                            categoryProductAttribute[i].PARTNER         = variables.partner;
                            categoryProductAttribute[i].CAT_ID          = getProductCategory.PARTNER_CAT_ID[e];
                            categoryProductAttribute[i].ATTRIBUTE_ID    = getProductCategory_Response[i].XmlChildren[1].XmlText;
                            categoryProductAttribute[i].ATTRIBUTE_NAME  = getProductCategory_Response[i].XmlChildren[4].XmlText;
                            categoryProductAttribute[i].IS_REQUIRED     = getProductCategory_Response[i].XmlChildren[2].XmlText;
                            categoryProductAttribute[i].IS_MULTIPLE_SELECT= getProductCategory_Response[i].XmlChildren[3].XmlText;
                            
                            dataArgs                        = structNew();
                            dataArgs.PARTNER                = categoryProductAttribute[i].PARTNER;
                            dataArgs.CAT_ID                 = categoryProductAttribute[i].CAT_ID;
                            dataArgs.ATTRIBUTE_ID           = categoryProductAttribute[i].ATTRIBUTE_ID;
                            categoryProductAttributeData[i] = DataStore.getData(table='PRODUCT_CATEGORY_ATTRIBUTES', args=dataArgs);

                            if (categoryProductAttributeData[i].RecordCount) {
                                if (categoryProductAttributeData[i].IS_REQUIRED Neq categoryProductAttribute[i].IS_REQUIRED) {
                                    DataStore.updateData(table='PRODUCT_CATEGORY_ATTRIBUTES', update_args={IS_REQUIRED=categoryProductAttribute[i].IS_REQUIRED}, where_args=dataArgs);
                                    //log_message = categoryProductAttribute[i].CAT_ID & ' kategorisi için ' & categoryProductAttribute[i].ATTRIBUTE_ID ' özellik değeri güncellendi'
                                }
                            }
                            else {
                                DataStore.addData(table='PRODUCT_CATEGORY_ATTRIBUTES', args=categoryProductAttribute[i], identity_name='ID');
                                //log_message = categoryProductAttribute[i].CAT_ID & ' kategorisi için ' & categoryProductAttribute[i].ATTRIBUTE_ID ' özellik değeri eklendi'
                            }
                        }
                        log_is_success  = 1;
                        log_response    = getProductCategory_Result.FileContent;
                    }
                    else {
                        log_is_success  = 0;
                        log_response    = getProductCategory_Result.ErrorDetail;
                    }
                    
                    DataStore.serviceLog(
                        log_id=service_log_id,
                        is_success=log_is_success,
                        request=log_request,
                        response=log_response,
                        status_code=log_status_code,
                        message=log_message
                    );
                </cfscript>
            </cfloop>
        </cfif>
    </cffunction>
    
    <cffunction name="insertProduct" access="public" returntype="void" output="true" hint="GittiGidiyor üzerinde ürün listelemek için bu metot kullanılır. Girilen ürün, GittiGidiyor Bana Özel sayfasında Yeni Listelenenler bölümünde görünecektir.">
        <cfscript>
            insertProduct_wsInfo        = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
            insertProduct_getChanges    = DataStore.getProductChanges(type="I", type_value=variables.partner);

            if(insertProduct_getChanges.recordcount){
                for(i = 1; i lte insertProduct_getChanges.recordcount; i++ ){
                    /* for(i = 1; i lte insertProduct_getChanges.recordcount; i++ ){ */

                    insertProduct_error = structNew("ordered");

                    insertProduct_getProduct[i]     = DataStore.getProduct(code=insertProduct_getChanges.product_code[i]);
                    insertProduct_price[i]          = DataStore.getPrice(code=insertProduct_getProduct[i].product_code, price_list=variables.partner);
                    insertProduct_stockAmount[i]    = DataStore.getMaterialStock(material_id=insertProduct_getProduct[i].product_code);
                    insertProduct_productInfo[i]    = ContentServer.getProductInfov2(product_code=insertProduct_getProduct[i].PRODUCT_CODE, partner=variables.partner);
                    insertProduct_storeProductCatID[i]= DataStore.getData(table="PRODUCT_CATEGORY", args={CAT_CODE=insertProduct_getProduct[i].MAL_GRUBU, PARTNER=variables.partner}).PARTNER_CAT_ID;

                    if (Not Len(insertProduct_storeProductCatID[i])){
                        insertProduct_error.error_subject       = variables.partner & ' Ürün Yaratma Servisi Hata - Kategori';
                        insertProduct_error.error_description   = insertProduct_getProduct[i].PRODUCT_CODE & ' ' & insertProduct_getProduct[i].PRODUCT_NAME & ' ürünü ' & insertProduct_getProduct[i].MAL_GRUBU & ' Mal grubu için #variables.partner# kategori ID belirlenemedi.'
                    }
                    else if (Not Len(insertProduct_price[i].sales_price)){
                        insertProduct_error.error_subject      = variables.partner & ' Ürün Yaratma Servisi Hata - Fiyat';
                        insertProduct_error.error_description  = insertProduct_getProduct[i].PRODUCT_CODE & ' ' & insertProduct_getProduct[i].PRODUCT_NAME & ' ürünü #variables.partner# satış fiyatı mevcut değil.'
                    }

                    if (structIsEmpty(insertProduct_error)){
                        insertProduct_service_log_id[i] = DataStore.serviceLog(partner=variables.partner, logger='insertProduct');
                        insertProduct_log_is_success[i] = 1;
                        insertProduct_log_request[i]    = '';
                        insertProduct_log_response[i]   = '';
                        insertProduct_log_status_code[i]= '';
                        insertProduct_log_message[i]    = '';

                        insertProduct_images[i]    = '';
                        for (img=1; img<=arrayLen(insertProduct_productInfo[i].product.images) ; img++){
                            insertProduct_images[i] = insertProduct_images[i] & '<photo photoId="#img#"><url>#insertProduct_productInfo[i].product.images[img].image_path#</url><base64></base64></photo>';
                        }

                        insertProduct_time[i]   = GetTickCount();
                        insertProduct_sign[i]   = hash(insertProduct_wsInfo.CLIENT_ID & insertProduct_wsInfo.CLIENT_SECRET & insertProduct_time[i]);

                        insertProduct_productBody[i] = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:prod="https://product.individual.ws.listingapi.gg.com">
                        <soapenv:Header/>
                        <soapenv:Body>
                           <prod:insertProductWithNewCargoDetail>
                              <apiKey>#insertProduct_wsInfo.CLIENT_ID#</apiKey>
                              <sign>#insertProduct_sign[i]#</sign>
                              <time>#insertProduct_time[i]#</time>
                              <itemId>#insertProduct_getProduct[i].product_code#</itemId>
                              <product>
                                 <categoryCode>#insertProduct_storeProductCatID[i]#</categoryCode>
                                 <storeCategoryId></storeCategoryId>
                                 <title>#insertProduct_productInfo[i].product.product_name#</title>
                                 <subtitle>#insertProduct_productInfo[i].product.short_description#</subtitle>
                                 <specs>
                                     <spec name="Durumu" value="Kullanılmış" type="Combo" required="true" />
                                     <spec name="Çözünürlük(Megapiksel)" value="10.0-11.9MP" type="Combo" required="true" />
                                     <spec name="Marka" value="Kodak" type="Combo" required="true" />
                                 </specs>
                                 <photos>
                                    #insertProduct_images[i]#
                                 </photos>
                                 <pageTemplate>1</pageTemplate>
                                 <description><![CDATA[#insertProduct_productInfo[i].product.long_description#]]></description>
                                 <startDate></startDate>
                                 <catalogId></catalogId>
                                 <newCatalogId></newCatalogId>
                                 <catalogDetail></catalogDetail>
                                 <catalogFilter></catalogFilter>
                                 <format>S</format>
                                 <startPrice></startPrice>
                                 <buyNowPrice>#insertProduct_price[i].sales_price#100</buyNowPrice>
                                 <netEarning></netEarning>
                                 <listingDays>60</listingDays>
                                 <productCount>#insertProduct_stockAmount[i]#</productCount>
                                 <cargoDetail>
                                 <city>34</city>
                                 <shippingPayment>B</shippingPayment>
                                 <shippingWhere>country</shippingWhere>
                                 <cargoCompanyDetails>
                                    <cargoCompanyDetail>
                                       <name>aras</name>
                                       <cityPrice>3.00</cityPrice>
                                       <countryPrice>5.00</countryPrice>
                                    </cargoCompanyDetail>
                                     </cargoCompanyDetails>
                                     <shippingTime>
                                    <days>today</days>
                                    <beforeTime>02:15</beforeTime>
                                     </shippingTime>
                              	</cargoDetail>
                                    <affiliateOption>false</affiliateOption>
                                    <boldOption>false</boldOption>
                                    <catalogOption>false</catalogOption>
                                    <vitrineOption>false</vitrineOption>
                                </product>
                                <forceToSpecEntry>false</forceToSpecEntry>
                                <nextDateOption>false</nextDateOption>
                                <lang>tr</lang>
                            </prod:insertProductWithNewCargoDetail>
                            </soapenv:Body>
                        </soapenv:Envelope>';
                        
                        insertProduct_url[i]    = '#insertProduct_wsInfo.address#product?method=insertProduct&inputCT=json&outputCT=json&apiKey=#insertProduct_wsInfo.CLIENT_ID#&sign=#insertProduct_sign[i]#&time=#insertProduct_time[i]#&itemId=#insertProduct_getProduct[i].product_code#&lang=tr&forceToSpecEntry=false&nextDateOption=false';
                        insertProduct_result    = 'result#i#';

                        insertProduct_log_request[i]    = insertProduct_productBody[i];
                        cfhttp(
                            url="#insertProduct_wsInfo.address#IndividualProductService?wsdl",
                            method="POST",
                            username="#insertProduct_wsInfo.USER_NAME#",
                            password="#insertProduct_wsInfo.PASSWD#",
                            result="#insertProduct_result#"){
                            cfhttpparam(type="header", name="Content-Type", value="text/xml");
                            cfhttpparam(type="header", name="SOAPAction", value="");
                            cfhttpparam(type="header", name="content-length", value="#Len(insertProduct_productBody[i])#");
                            cfhttpparam(type="header", name="charset", value="utf-8");
                            cfhttpparam(type="xml", value="#Trim(insertProduct_productBody[i])#");
                        }

                        insertProduct_result_detail = evaluate('#insertProduct_result#');
                        writedump(xmlparse(insertProduct_result_detail.FileContent)); abort;
                        insertProduct_log_status_code[i]= insertProduct_result_detail.StatusCode;

                        if(structKeyExists(insertProduct_result_detail, 'FileContent')){
                            if(isJSON(insertProduct_result_detail.FileContent)){
                                resultStruct[i] = deserializeJSON(insertProduct_result_detail.FileContent);
                                if (resultStruct[i].ackCode Eq 'success') {
                                    DataStore.updateProductChanges(cId=insertProduct_getChanges.ID);
                                    insertProduct_productId[i] = resultStruct[i].productId;
                                    DataStore.addPartnerProduct(partner= variables.partner, product_code= insertProduct_getProduct[i].product_code, partner_product_id= insertProduct_productId[i]);
                                    insertProduct_log_is_success[i] = 1;
                                    insertProduct_log_message[i]    = resultStruct[i].result;
                                }
                                else if (resultStruct[i].ackCode Eq 'failure') {
                                    insertProduct_log_is_success[i] = 0;
                                    insertProduct_log_response[i]   = insertProduct_result_detail.FileContent;
                                    insertProduct_log_status_code[i]= resultStruct[i].error.errorId;
                                    insertProduct_log_message[i]    = resultStruct[i].error.errorCode & " " & resultStruct[i].error.message & " " & resultStruct[i].error.viewMessage;
                                }
                            }
                            else {
                                insertProduct_log_is_success[i] = 0;
                                insertProduct_log_response[i]   = insertProduct_result_detail.errordetail;
                            }
                        }
                        else {
                            insertProduct_log_is_success[i] = 0;
                            insertProduct_log_response[i]   = insertProduct_result_detail.errordetail;
                        }

                        DataStore.serviceLog(
                            log_id=insertProduct_service_log_id[i],
                            is_success=insertProduct_log_is_success[i],
                            request=insertProduct_log_request[i],
                            response=insertProduct_log_response[i],
                            status_code=insertProduct_log_status_code[i],
                            message=insertProduct_log_message[i]);
                    }
                    else {
                        DataStore.logError(subject=insertProduct_error.error_subject, message=insertProduct_error.error_description, product_code= insertProduct_getProduct[i].PRODUCT_CODE);
                    }
                    structClear(insertProduct_error);
                }
            }
        </cfscript>
    </cffunction>

    <cffunction name="updateProduct" access="public" returntype="void" output="true" hint="Satıştaki veya yeni listelenmiş ürünleri güncellemek için kullanılır.">
        <cfscript>
            updateProduct_wsInfo        = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
            updateProduct_getChanges    = DataStore.getProductChanges(type="U", type_value=variables.partner);
        </cfscript>
    </cffunction>

    <cffunction name="deleteProduct" access="public" returntype="void" output="true" hint="Ürün/ürünleri silmek için kullanılır.">
        <cfscript>
            deleteProduct_wsInfo        = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
            deleteProduct_getChanges    = DataStore.getProductChanges(type="D", type_value=variables.partner);
        </cfscript>
    </cffunction>

    <cffunction name="getProducts" access="public" returntype="void" output="true" hint="GittiGidiyor, Bana Özel sayfasında yer alan: Aktif Satışlarım, Yeni Listelenenler, Satılanlar, Satılmayanlar bölümündeki ürün bilgilerine ulaşmak için kullanılır.">
        <cfscript>
            getProducts_wsInfo  = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
        </cfscript>
    </cffunction>

    <cffunction name="updatePrice" access="public" returntype="void" output="true" hint="Ürün fiyat bilgilerini parasal olarak güncellemek için kullanılır.">
        <cfscript>
            updatePrice_wsInfo      = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
            updatePrice_getChanges  = DataStore.getProductChanges(type="P", type_value=variables.partner);
        </cfscript>
    </cffunction>

    <cffunction name="updateStock" access="public" returntype="void" output="true" hint="Stok bilgilerini güncellemek için kullanılır.">
        <cfscript>
            updateStock_wsInfo  = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
        </cfscript>
    </cffunction>

    <cffunction name="relistProducts" access="public" returntype="void" output="true" hint="Satılmamış ürünleri tekrar satışa çıkartmak için kullanılır.">
        <cfscript>
            relistProducts_wsInfo   = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
        </cfscript>
    </cffunction>

    <cffunction name="getSales" access="public" returntype="void" output="true" hint="Satıcı konumundaki kullanıcı bu servis aracılığı ile GittiGidiyor Bana Özel sayfasında yer alan Sattıklarım bölümünde sunulan bilgilerin tamamını elde edebilir, bilgileri filtreleyebilir ve sıralayabilir.">
        <cfscript>
            getSales_wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
        </cfscript>
    </cffunction>

    <cffunction name="sendCargoInformation" access="public" returntype="void" output="true" hint="İlgili satış kodu girildikten sonra, satış bilgisine kargo bilgisi eklemek için kullanılır. Bu metot satıcılar tarafından kullanılır.">
        <cfscript>
            sendCargoInformation_wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
        </cfscript>
    </cffunction>
</cfcomponent>