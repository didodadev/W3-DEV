<cfcomponent name="TrendyolAdapter" output="false" hint="Trendyol Adapter">
    
    <cfproperty name="DataStore" Inject="DataStore" />
    <cfproperty name="ContentServer" Inject="ContentServerAdapter" />
    <cfproperty name="SAP" Inject="SAPAdapter" />

    <cfscript>
        variables.partner           = 'TRENDYOL';
        variables.integration_id    = 2;
        variables.productBrandId    = 31650;/* Ruumstore(43549) Ruum Store By Doğtaş(31650) marka ID */
        variables.cargoCompanyId    = 10;/* MNG kargo ID */
        variables.shipmentAddressId = 143510;/* Ürün Trendyol sistemindeki sevkiyat depo adresi ID bilgisidir */
        variables.returningAddressId= 147001;/* Ürün Trendyol sistemindeki iade depo adresi ID bilgisidir */
        variables.list_array        = ArrayNew(1);
    </cfscript>

<!----------------------------------- CONSTRUCTOR --------------------------------------->

<cffunction name="init" access="public" returntype="any" output="false" hint="constructor">
    <cfreturn this />
</cffunction>

<cffunction name="subCategories" access="public" returntype="any" output="true">
    <cfargument name="liste" type="array" required="true" />
    <cfscript>
        for (item in arguments.liste)
        {   
            list_struct=structNew();
            list_struct.id=item.id;
            list_struct.name=item.name;
            if(StructKeyExists(item, "parentId")){
                list_struct.parentId=item.parentId;
            }
            ArrayAppend(variables.list_array,list_struct);
            if(ArrayLen(item.subCategories) > 0)
            {
                subCategories(liste=item.subCategories);
            }
        }
    </cfscript>
</cffunction>
<!----------------------------------- PUBLIC METHODS --------------------------------------->

<cffunction name="createProducts" access="public" returntype="void" output="false" hint="Ürünler Trendyol sistemine ilk olarak bu method yardımıyla iletilecektir. Tekli ve çoklu ürün gönderimini desteklemektedir, RESTful isteğinin POST yöntemi ile gönderilmesi gerekir.">

    <cfscript>
        createProducts_wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=2);
        createProducts_getChanges  = DataStore.getProductChanges(type="I", type_value=variables.partner);//Trendyol için insert olarak gelen değişiklikleri alıyoruz
    </cfscript>

    <cfif createProducts_getChanges.RecordCount>

        <cfloop query="createProducts_getChanges">
            <cfscript>
                updateProducts_error    = structNew("ordered");
                getProduct      = DataStore.getProduct(code=PRODUCT_CODE);
                productCatID = DataStore.getData(table="PRODUCT_CATEGORY", args={cat_code=getProduct.mal_grubu, partner=variables.partner}).PARTNER_CAT_ID;
                if (Not Len(productCatID)) {
                    updateProducts_error.error_subject      = variables.partner & ' Ürün Yaratma Servisi Hata';
                    updateProducts_error.error_description  = getProduct.PRODUCT_CODE & ' ' & getProduct.PRODUCT_NAME & ' ürünü ' & getProduct.mal_grubu & ' Mal grubu için Trendyol kategori ID belirlenemedi.'
                }
                createProducts_log_is_success  = 1;
                createProducts_log_request     = '';
                createProducts_log_response    = '';
                createProducts_log_status_code = '';
                createProducts_log_message     = '';
                product_attributes  = '';
            </cfscript>

            <cfif structIsEmpty(updateProducts_error)>
                <cfset createProducts_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='createProducts') />
                <cfset productInfo = ContentServer.getProductInfov2(product_code=PRODUCT_CODE, partner= variables.partner) />
                <cfif listFind('1850,1879',productCatID)>
                    <cfsavecontent variable="product_attributes">
                        "attributes": [
                        {
                            "attributeId": 338,<!--- Beden --->
                            "attributeValueId": 6821<!--- Tek ebat --->
                        },
                        {
                            "attributeId": 47,
                            "customAttributeValue": "Beyaz"
                        }
                        ],</cfsavecontent>
                </cfif>

                <cfsavecontent variable="createProducts_REST_Content"><cfoutput>{"items": [{"barcode": "#getProduct.EAN_NO#","title": "#productInfo.product.product_name#","productMainId": "#getProduct.PRODUCT_CODE#","brandId": #variables.productBrandId#,"categoryId": #productCatId#,"cargoCompanyId": #variables.cargoCompanyId#,"currencyType": "TRY",<cfif structKeyExists(productInfo, "product")>"description": "#productInfo.product.long_description#","images": [<cfloop array="#productInfo.product.images#" index="i" item="item">{"url": "#item.image_path#"}<cfif i Lt arrayLen(productInfo.product.images)>,</cfif></cfloop>],<cfelse>"description": "","images": [],</cfif><cfif Len(product_attributes)>#product_attributes#</cfif>"dimensionalWeight": "#getProduct.AGIRLIK_B_BASE_UNIT#",<cfset list_price = DataStore.getPrice(code=PRODUCT_CODE,price_list=variables.partner).LIST_PRICE /><cfset sales_price = DataStore.getPrice(code=PRODUCT_CODE,price_list=variables.partner).SALES_PRICE /><cfif Not Len(list_price)><cfset list_price = 0 /></cfif><cfif Not Len(sales_price)><cfset sales_price = 0 /></cfif>"listPrice": #list_price#,<cfset stock = DataStore.getMaterialStock(material_id="#getProduct.PRODUCT_CODE#") />"quantity": #stock#,"salePrice": #sales_price#,"stockCode": "#getProduct.PRODUCT_CODE#",<cfif getProduct.TAX Eq 3><cfset tax = 18 /><cfelseif getProduct.TAX Eq 2><cfset tax = 8 /><cfelseif getProduct.TAX Eq 1><cfset tax = 1 /><cfelse><cfset tax = 0 /></cfif>"vatRate": "#tax#","shipmentAddressId": #variables.shipmentAddressId#,"returningAddressId": #variables.returningAddressId#}],"notificationEmails": ["#createProducts_wsInfo.PERSON_EMAIL#"],"sourceType": "API","supplierId": #createProducts_wsInfo.USER_ID#}</cfoutput></cfsavecontent>

                <cfset createProducts_REST_Content = DataStore.clearJSONContent(JSONContent=createProducts_REST_Content) />
                <cfset createProducts_wsAddr  = "#createProducts_wsInfo.ADDRESS#suppliers/#createProducts_wsInfo.USER_ID#/v2/products" />

                <cfhttp
                    url="#createProducts_wsAddr#"
                    method="POST"
                    username="#createProducts_wsInfo.USER_NAME#"
                    password="#createProducts_wsInfo.PASSWD#"
                    result="createProducts_REST_Result">
                    <cfhttpparam type = "header" name = "Content-Type" value = "application/json;charset=UTF-8" />
                    <cfhttpparam type = "body" value = "#Trim(createProducts_REST_Content)#" />
                </cfhttp>

                <cfscript>
                    createProducts_log_request = createProducts_REST_Content;

                    if(structKeyExists(createProducts_REST_Result, "FileContent")){
                        if(isJSON(createProducts_REST_Result.FileContent)){
                            resultStruct = deserializeJSON(createProducts_REST_Result.FileContent);

                            if(isStruct(resultStruct)){
                                if(structKeyExists(resultStruct, "batchRequestId")){
                                    DataStore.updateProductChanges(cId=ID, batch="#resultStruct.batchRequestId#");
                                    createProducts_log_is_success = 1;
                                    createProducts_log_status_code = createProducts_REST_Result.StatusCode;
                                }
                                else if(structKeyExists(resultStruct, "errors")){
                                    createProducts_log_is_success = 0;
                                    createProducts_log_status_code = createProducts_REST_Result.StatusCode;
                                }
                            }
                            createProducts_log_response = createProducts_REST_Result.FileContent;
                        }
                        else{
                            createProducts_log_is_success = 0;
                            createProducts_log_response = createProducts_REST_Result.FileContent;
                            createProducts_log_status_code = createProducts_REST_Result.StatusCode;
                        }
                    }
                    else{
                        createProducts_log_is_success = 0;
                        createProducts_log_response = createProducts_REST_Result.errordetail;
                        createProducts_log_status_code = createProducts_REST_Result.StatusCode;
                    }
                </cfscript>

                <cfset DataStore.serviceLog(
                    log_id=createProducts_service_log_id,
                    is_success=createProducts_log_is_success,
                    request=createProducts_log_request,
                    response=createProducts_log_response,
                    status_code=createProducts_log_status_code
                ) />
            <cfelse>
                <cfset DataStore.logError(subject=updateProducts_error.error_subject, message=updateProducts_error.error_description, product_code=PRODUCT_CODE) />
            </cfif>
            <cfscript>
                createProducts_log_is_success  = 1;
                createProducts_log_request     = '';
                createProducts_log_response    = '';
                createProducts_log_message     = '';
                createProducts_log_status_code = '';
                createProducts_service_log_id  = '';
                structClear(updateProducts_error);
            </cfscript>
        </cfloop>
    </cfif>

</cffunction>

<cffunction name="updateProducts" access="public" returntype="void" output="false" hint="Bu method ile Trendyol mağazasında createProduct servisiyle oluşturulan ürünler güncellenecektir, RESTful isteğinin PUT yöntemi ile gönderilmesi gerekir.">

    <cfscript>
        updateProducts_wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=2);
        updateProducts_getChanges  = DataStore.getProductChanges(type="U", type_value=variables.partner);//Trendyol için update olarak gelen değişiklikleri alıyoruz
    </cfscript>

    <cfif updateProducts_getChanges.RecordCount>
        <cfloop query="updateProducts_getChanges">
        <cfscript>
            updateProducts_error    = structNew("ordered");
            getProduct      = DataStore.getProduct(code=PRODUCT_CODE);
            productCatID = DataStore.getData(table="PRODUCT_CATEGORY", args={cat_code=getProduct.mal_grubu, partner=variables.partner}).PARTNER_CAT_ID;
            if (Not Len(productCatID)) {
                updateProducts_error.error_subject      = variables.partner & ' Ürün Güncelleme Servisi Hata';
                updateProducts_error.error_description  = getProduct.PRODUCT_CODE & ' ' & getProduct.PRODUCT_NAME & ' ürünü ' & getProduct.mal_grubu & ' Mal grubu için Trendyol kategori ID belirlenemedi.'
            }
            updateProducts_log_is_success  = 1;
            updateProducts_log_request     = '';
            updateProducts_log_response    = '';
            updateProducts_log_status_code = '';
            updateProducts_log_message     = '';
        </cfscript>

        <cfif structIsEmpty(updateProducts_error)>
            <cfset updateProducts_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='updateProducts') />
            <cfset productInfo = ContentServer.getProductInfov2(product_code=PRODUCT_CODE, partner= variables.partner) />

            <cfsavecontent variable="updateProducts_REST_Content"><cfoutput>{"items": [{"barcode": "#getProduct.EAN_NO#","title": "#getProduct.PRODUCT_NAME#","productMainId": "#getProduct.PRODUCT_CODE#","brandId": #variables.productBrandId#,"categoryId": #productCatId#,"cargoCompanyId": #variables.cargoCompanyId#,<cfif structKeyExists(productInfo, "product")>"description": "#productInfo.product.long_description#","images": [<cfloop array="#productInfo.product.images#" index="i" item="item">{"url": "#item.image_path#"}<cfif i Lt arrayLen(productInfo.product.images)>,</cfif></cfloop>],<cfelse>"description": "","images": [],</cfif>"dimensionalWeight": "#getProduct.AGIRLIK_B_BASE_UNIT#","stockCode": "#getProduct.PRODUCT_CODE#",<cfif getProduct.TAX Eq 3><cfset tax = 18 /><cfelseif getProduct.TAX Eq 2><cfset tax = 8 /><cfelseif getProduct.TAX Eq 1><cfset tax = 1 /><cfelse><cfset tax = 0 /></cfif>"vatRate": "#tax#","shipmentAddressId": #variables.shipmentAddressId#,"returningAddressId": #variables.returningAddressId#}],"notificationEmails": ["#updateProducts_wsInfo.PERSON_EMAIL#"],"sourceType": "API","supplierId": #updateProducts_wsInfo.USER_ID#}</cfoutput></cfsavecontent>

            <cfset updateProducts_REST_Content = DataStore.clearJSONContent(JSONContent=updateProducts_REST_Content) />
            <cfset updateProducts_wsAddr  = "#updateProducts_wsInfo.ADDRESS#suppliers/#updateProducts_wsInfo.USER_ID#/v2/products" />

            <cfhttp
                url="#updateProducts_wsAddr#"
                method="PUT"
                username="#updateProducts_wsInfo.USER_NAME#"
                password="#updateProducts_wsInfo.PASSWD#"
                result="updateProducts_REST_Result">
                <cfhttpparam type = "header" name = "Content-Type" value = "application/json;charset=UTF-8" />
                <cfhttpparam type = "body" value = "#Trim(updateProducts_REST_Content)#" />
            </cfhttp>

            <cfscript>
                updateProducts_log_request = updateProducts_REST_Content;

                if(structKeyExists(updateProducts_REST_Result, "FileContent")){
                    if(isJSON(updateProducts_REST_Result.FileContent)){
                        resultStruct = deserializeJSON(updateProducts_REST_Result.FileContent);

                        if(isStruct(resultStruct)){
                            if(structKeyExists(resultStruct, "batchRequestId")){
                                DataStore.updateProductChanges(cId=ID, batch="#resultStruct.batchRequestId#");
                                updateProducts_log_is_success = 1;
                                updateProducts_log_status_code = updateProducts_REST_Result.StatusCode;
                            }
                            else if(structKeyExists(resultStruct, "errors")){
                                updateProducts_log_is_success = 0;
                                updateProducts_log_status_code = updateProducts_REST_Result.StatusCode;
                            }
                        }
                        updateProducts_log_response = updateProducts_REST_Result.FileContent;
                    }
                    else{
                        updateProducts_log_is_success = 0;
                        updateProducts_log_response = updateProducts_REST_Result.FileContent;
                        updateProducts_log_status_code = updateProducts_REST_Result.StatusCode;
                    }
                }
                else{
                    updateProducts_log_is_success = 0;
                    updateProducts_log_response = updateProducts_REST_Result.errordetail;
                    updateProducts_log_status_code = updateProducts_REST_Result.StatusCode;
                }
            </cfscript>

            <cfset DataStore.serviceLog(
                log_id=updateProducts_service_log_id,
                is_success=updateProducts_log_is_success,
                request=updateProducts_log_request,
                response=updateProducts_log_response,
                status_code=updateProducts_log_status_code
            ) />
        <cfelse>
            <cfset DataStore.logError(subject=updateProducts_error.error_subject, message=updateProducts_error.error_description, product_code=PRODUCT_CODE) />
        </cfif>

        <cfscript>
            updateProducts_log_is_success  = 1;
            updateProducts_log_request     = '';
            updateProducts_log_response    = '';
            updateProducts_log_message     = '';
            updateProducts_log_status_code = '';
            updateProducts_service_log_id  = '';
            structClear(updateProducts_error);
        </cfscript>
        </cfloop>
    </cfif>

</cffunction>

<cffunction name="getCategoryTree" access="public" returntype="void" output="true" hint="Bu method ile Trendyol mağazasının categorileri Rest ile çekilmiştir.">
    <cfparam name="productCategory_log_is_success" type="boolean" default="1" />
    <cfparam name="productCategory_log_request" type="string" default="" />
    <cfparam name="productCategory_log_response" type="string" default="" />
    <cfparam name="productCategory_log_status_code" type="string" default="" />

    <cfset productCategory_wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id) />
    <cfset totalRows = 100 />
    <cfset productCategory_service_log_id = DataStore.serviceLog(partner=variables.partner,logger="getCategoryTree") />

    <cfhttp
        url="#productCategory_wsInfo.ADDRESS#product-categories"
        method="GET"
        result="productsCategory_REST_Result">
        <cfhttpparam type = "header" name = "Content-Type" value = "application/json;charset=UTF-8" />
    </cfhttp>

    <cfscript>
        productCategory_log_request = "#productCategory_wsInfo.ADDRESS#product-categories";

        if(isJSON(productsCategory_REST_Result.FileContent)){
            productsCategory_resultStruct = deserializeJSON(productsCategory_REST_Result.FileContent).categories;
            //productsCategory_count=arrayLen(productsCategory_resultStruct);
            subCategories(liste=productsCategory_resultStruct);
            if(isArray(variables.list_array)){
                for(i=1; i <= arrayLen(variables.list_array); i++){
                    product_categoryArgs                         = structNew();
                    product_categoryArgs.PARTNER                 = variables.partner;
                    product_categoryArgs.PARTNER_CAT_ID          = variables.list_array[i].ID;
                    product_categoryArgs.PARTNER_CATEGORY_NAME   = variables.list_array[i].name;
                    if(StructKeyExists(variables.list_array[i], "parentId")){
                        product_categoryArgs.PARTNER_PARENT_CAT_ID   = variables.list_array[i].parentId;
                    }
                    product_Args                                 =structNew();
                    product_Args.PARTNER                         =variables.partner;
                    product_Args.PARTNER_CAT_ID                  =variables.list_array[i].ID;
                    product_categoryDetail = DataStore.getData(table="PRODUCT_CATEGORY", args=product_Args);
                    if(product_categoryDetail.recordCount eq 0)
                    {
                        product_categoryArgsDetail = DataStore.addData(table="PRODUCT_CATEGORY", args=product_categoryArgs,identity_name='CAT_ID');
                    }
                }
                productCategory_log_is_success = 1;
                productCategory_log_response = productsCategory_REST_Result.FileContent;
                productCategory_log_status_code = productsCategory_REST_Result.StatusCode;
            }
            else{
                productCategory_log_is_success = 0;
                productCategory_log_response = productsCategory_REST_Result.FileContent;
                productCategory_log_status_code = productsCategory_REST_Result.StatusCode;
            }
            DataStore.serviceLog(
                log_id=productCategory_service_log_id,
                is_success=productCategory_log_is_success,
                request=productCategory_log_request,
                response=productCategory_log_response,
                status_code=productCategory_log_status_code
            );

            productCategory_log_is_success = 1;
            productCategory_log_request = "";
            productCategory_log_response = "";
            productCategory_log_status_code = "";
        }
    </cfscript>
</cffunction>

<cffunction name="filterProducts" access="public" returntype="any" output="false" hint="Trendyol’a aktarılan ürünler, Trendyol tarafından yayına alınmadan önce kontrol edilerek onaylanır. Onaylanmış ürünler artık real-time stok ve fiyat güncellemelerini alabilecek statüdedir, RESTful isteğinin GET yöntemi ile gönderilmesi gerekir.">

    <cfreturn this />

</cffunction>

<cffunction name="updatePriceAndInventory" access="public" returntype="void" output="false" hint="Ürün stok ve fiyat bilgisi güncelleme, RESTful isteğinin POST yöntemi ile gönderilmesi gerekir.">

    <cfparam name="updatePriceAndInventory_log_is_success" type="boolean" default="1" />
    <cfparam name="updatePriceAndInventory_log_request" type="string" default="" />
    <cfparam name="updatePriceAndInventory_log_response" type="string" default="" />
    <cfparam name="updatePriceAndInventory_log_status_code" type="string" default="" />
    <cfparam name="updatePriceAndInventory_log_message" type="string" default="" />

    <cfscript>
        updatePriceAndInventory_service_log_id  = DataStore.serviceLog(partner=variables.partner, logger='updatePriceAndInventory');
        updatePriceAndInventory_wsInfo          = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
        updatePriceAndInventory_products        = DataStore.getProduct(is_trendyol="X");
    </cfscript>

    <cfif updatePriceAndInventory_products.RecordCount>
        <cfsavecontent variable="updatePriceAndInventory_REST_Content"><cfoutput>{
                "items": [
                    <cfloop from="1" to="#updatePriceAndInventory_products.RecordCount#" index="i">
                    <cfscript>
                        product_code[i]    = updatePriceAndInventory_products.PRODUCT_CODE[i];
                        product_price[i]   = DataStore.getPrice(code=product_code[i], price_list=variables.partner);
                        sales_price[i]     = product_price[i].SALES_PRICE;
                        list_price[i]      = product_price[i].LIST_PRICE;
                        stock[i]           = DataStore.getMaterialStock(material_id="#updatePriceAndInventory_products.PRODUCT_CODE[i]#")
                    </cfscript>
                    <cfoutput>
                    {
                    "barcode": "#updatePriceAndInventory_products.EAN_NO[i]#",
                    <cfif Not Len(stock[i])>
                        <cfset stock[i] = 0 />
                    </cfif>
                    "quantity": "#stock[i]#",
                    <cfif Not Len(sales_price[i])>
                        <cfset sales_price[i] = 0 />
                    </cfif>
                    <cfif Not Len(list_price[i])>
                        <cfset list_price[i] = 0 />
                    </cfif>
                    "salePrice": "#sales_price[i]#",
                    "listPrice": "#list_price[i]#"
                    }<cfif updatePriceAndInventory_products.RecordCount Gt 1 And i Lt updatePriceAndInventory_products.RecordCount>,</cfif>
                    </cfoutput>
                    <cfscript>
                        product_code[i]    = '';
                        product_price[i]   = '';
                        sales_price[i]     = '';
                        list_price[i]      = '';
                        stock[i]           = '';
                    </cfscript>
                    </cfloop>
                ]
            }</cfoutput>
        </cfsavecontent>

        <cfset updatePriceAndInventory_REST_Content = DataStore.clearJSONContent(JSONContent=updatePriceAndInventory_REST_Content) />
        <cfset updatePriceAndInventory_log_request  = updatePriceAndInventory_REST_Content />

        <cfhttp
            url="#updatePriceAndInventory_wsInfo.ADDRESS#suppliers/#updatePriceAndInventory_wsInfo.USER_ID#/products/price-and-inventory"
            method="POST"
            username="#updatePriceAndInventory_wsInfo.USER_NAME#"
            password="#updatePriceAndInventory_wsInfo.PASSWD#"
            result="updatePriceAndInventory_REST_Result">
            <cfhttpparam type = "header" name = "Content-Type" value = "application/json;charset=UTF-8" />
            <cfhttpparam type = "body" value = "#Trim(updatePriceAndInventory_REST_Content)#" />
        </cfhttp>

        <cfscript>
            updatePriceAndInventory_log_response = updatePriceAndInventory_REST_Result.FileContent;
            updatePriceAndInventory_log_status_code = updatePriceAndInventory_REST_Result.StatusCode;

            if(isJSON(updatePriceAndInventory_REST_Result.FileContent)){
                updatePriceAndInventory_resultStruct = deserializeJSON(updatePriceAndInventory_REST_Result.FileContent);

                if(isStruct(updatePriceAndInventory_resultStruct)){
                    if(structKeyExists(updatePriceAndInventory_resultStruct, "batchRequestId")){
                        updatePriceAndInventory_log_is_success = 1;
                    }
                    else if(structKeyExists(updatePriceAndInventory_resultStruct, "errors")){
                        updatePriceAndInventory_log_is_success = 0;
                    }
                }
            }
            else{
                updatePriceAndInventory_log_is_success = 0;
            }
        </cfscript>
    </cfif>

    <cfscript>
        DataStore.serviceLog(
            log_id=updatePriceAndInventory_service_log_id,
            is_success=updatePriceAndInventory_log_is_success,
            request=updatePriceAndInventory_log_request,
            response=updatePriceAndInventory_log_response,
            status_code=updatePriceAndInventory_log_status_code
        );
        updatePriceAndInventory_log_is_success = 1;
        updatePriceAndInventory_log_request = "";
        updatePriceAndInventory_log_response = "";
        updatePriceAndInventory_log_message = "";
        updatePriceAndInventory_log_status_code = "";
    </cfscript>

</cffunction>

<cffunction name="updatePrices" access="public" returntype="void" output="false" hint="Ürün fiyat bilgisi güncelleme, RESTful isteğinin POST yöntemi ile gönderilmesi gerekir.">

    <cfreturn this />

</cffunction>

<cffunction name="orders" access="public" returntype="void" output="false" hint="Siparişlerin alınması, RESTful isteğinin POST yöntemi ile gönderilmesi gerekir.">

    <cfparam name="orders_log_is_success" type="boolean" default="1" />
    <cfparam name="orders_log_request" type="string" default="" />
    <cfparam name="orders_log_response" type="string" default="" />
    <cfparam name="orders_log_status_code" type="string" default="" />

    <cfset orders_wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=2) />
   
    <cfset pageSize = 50 />
    <cfset page = 0 />
    <cfset totalRows = 100 />

    <cfloop condition="page lt ceiling(totalRows/pageSize)">
        <cfset orders_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='orders') />

        <cfhttp
            url="#orders_wsInfo.ADDRESS#suppliers/#orders_wsInfo.USER_ID#/orders?page=#page#&size=#pageSize#"
            method="GET"
            username="#orders_wsInfo.USER_NAME#"
            password="#orders_wsInfo.PASSWD#"
            result="orders_REST_Result">
            <cfhttpparam type = "header" name = "Content-Type" value = "application/json;charset=UTF-8" />
        </cfhttp>

        <cfscript>
            if(isJSON(orders_REST_Result.FileContent)){
                orders_resultStruct = deserializeJSON(orders_REST_Result.FileContent);
                if(page eq 0) {
                    totalRows = orders_resultStruct.totalElements;
                }
                if(isStruct(orders_resultStruct)){
                    if(structKeyExists(orders_resultStruct, "content")){
                        for(i=1; i <= arrayLen(orders_resultStruct.content); i++){

                            orders_orderArgs                = structNew();
                            orders_orderArgs.PARTNER        = variables.partner;
                            orders_orderArgs.REF_ORDER_ID   = orders_resultStruct.content[i].id;
                            orders_orderDetail = DataStore.getData(table="ORDERS", args=orders_orderArgs);

                            if(Not orders_orderDetail.RecordCount){
                                orders_args                            =   structNew();
                                orders_args.PARTNER                    =   variables.partner;
                                orders_args.REF_STATUS_NAME            =   orders_resultStruct.content[i].shipmentPackageStatus;
                                orders_args.REF_ORDER_ID               =   orders_resultStruct.content[i].id;
                                orders_args.REF_ORDER_NUMBER           =   orders_resultStruct.content[i].orderNumber;
                                orders_args.REF_ORDER_DATE             =   dateTimeFormat(dateAdd("s", orders_resultStruct.content[i].orderDate/1000, "1970-01-01"),'yyyy-mm-dd hh:nn:ss');
                                orders_args.REF_CARGO_TRACKING_NUMBER  =   orders_resultStruct.content[i].cargoTrackingNumber;
                                orders_args.REF_CURRENCY_CODE          =   orders_resultStruct.content[i].currencyCode;
                                orders_args.REF_CUSTOMER_ID            =   orders_resultStruct.content[i].customerId;
                                orders_args.REF_CUSTOMER_FIRST_NAME    =   orders_resultStruct.content[i].customerFirstName;
                                orders_args.REF_CUSTOMER_LAST_NAME     =   orders_resultStruct.content[i].customerLastName;
                                orders_args.REF_CUSTOMER_EMAIL         =   orders_resultStruct.content[i].customerEmail;
                                orders_args.REF_TC_IDENTITY_NUMBER     =   orders_resultStruct.content[i].tcIdentityNumber;
                                orders_args.REF_TOTAL_PRICE            =   orders_resultStruct.content[i].totalPrice;
                                orders_args.REF_INVOICE_ID             =   orders_resultStruct.content[i].invoiceAddress.id;
                                orders_args.REF_INVOICE_COMPANY        =   orders_resultStruct.content[i].invoiceAddress.company;
                                orders_args.REF_INVOICE_FIRST_NAME     =   orders_resultStruct.content[i].invoiceAddress.firstName;
                                orders_args.REF_INVOICE_LAST_NAME      =   orders_resultStruct.content[i].invoiceAddress.lastName;
                                orders_args.REF_INVOICE_FULL_NAME      =   orders_resultStruct.content[i].invoiceAddress.fullName;
                                orders_args.REF_INVOICE_ADDRESS_1      =   orders_resultStruct.content[i].invoiceAddress.address1;
                                if(StructKeyExists(orders_resultStruct.content[i].invoiceAddress,"address2")){
                                    orders_args.REF_INVOICE_ADDRESS_2      =   orders_resultStruct.content[i].invoiceAddress.address2;
                                }
                                orders_args.REF_INVOICE_DISTRICT       =   orders_resultStruct.content[i].invoiceAddress.district;
                                orders_args.REF_INVOICE_CITY           =   orders_resultStruct.content[i].invoiceAddress.city;
                                orders_args.REF_INVOICE_COUNTRY        =   UCase(orders_resultStruct.content[i].invoiceAddress.countryCode);
                                orders_args.REF_INVOICE_FULL_ADDRESS   =   orders_resultStruct.content[i].invoiceAddress.fullAddress;
                                if(StructKeyExists(orders_resultStruct.content[i].invoiceAddress,"phone"))
                                    orders_args.REF_INVOICE_PHONE      =   orders_resultStruct.content[i].invoiceAddress.phone;
                                else
                                    orders_args.REF_INVOICE_PHONE      =   '';
                                orders_args.REF_SHIPMENT_ID            =   orders_resultStruct.content[i].shipmentAddress.id;
                                orders_args.REF_SHIPMENT_FIRST_NAME    =   orders_resultStruct.content[i].shipmentAddress.firstName;
                                orders_args.REF_SHIPMENT_LAST_NAME     =   orders_resultStruct.content[i].shipmentAddress.lastName;
                                orders_args.REF_SHIPMENT_FULL_NAME     =   orders_resultStruct.content[i].shipmentAddress.fullName;
                                orders_args.REF_SHIPMENT_ADDRESS_1     =   orders_resultStruct.content[i].shipmentAddress.address1;
                                if(StructKeyExists(orders_resultStruct.content[i].shipmentAddress,"address2")){
                                    orders_args.REF_INVOICE_ADDRESS_2      =   orders_resultStruct.content[i].shipmentAddress.address2;
                                }

                                if(StructKeyExists(orders_resultStruct.content[i].shipmentAddress,"districtId")){
                                    orders_args.REF_SHIPMENT_DISTRICT_ID   =   orders_resultStruct.content[i].shipmentAddress.districtId;
                                }

                                orders_args.REF_SHIPMENT_DISTRICT_NAME =   orders_resultStruct.content[i].shipmentAddress.district;

                                if(StructKeyExists(orders_resultStruct.content[i].shipmentAddress,"cityCode")){
                                    orders_args.REF_SHIPMENT_CITY_ID       =   orders_resultStruct.content[i].shipmentAddress.cityCode;
                                }

                                orders_args.REF_SHIPMENT_CITY_NAME     =   orders_resultStruct.content[i].shipmentAddress.city;
                                orders_args.REF_SHIPMENT_COUNTRY       =   UCase(orders_resultStruct.content[i].shipmentAddress.countryCode);
                                //orders_args.REF_SHIPMENT_POSTAL_CODE   =   orders_resultStruct.content[i].shipmentAddress.postalCode;
                                orders_args.REF_SHIPMENT_FULL_ADDRESS  =   orders_resultStruct.content[i].shipmentAddress.fullAddress;

                                ORDER_ID[i] = DataStore.addOrder(args=orders_args);

                                orders_orderRows[i] = structNew();

                                if(arrayLen(orders_resultStruct.content[i].lines)){
                                    for(e=1; e <= arrayLen(orders_resultStruct.content[i].lines); e++){
                                        orders_orderRows[i].ROW_NUMBER                 =   e;
                                        orders_orderRows[i].ORDER_ID                   =   ORDER_ID[i];
                                        orders_orderRows[i].REF_ORDER_ID               =   orders_resultStruct.content[i].id;
                                        orders_orderRows[i].REF_ORDER_NUMBER           =   orders_resultStruct.content[i].orderNumber;
                                        orders_orderRows[i].REF_ORDER_ROW_ID           =   orders_resultStruct.content[i].lines[e].id;
                                        orders_orderRows[i].REF_PRODUCT_ID             =   orders_resultStruct.content[i].lines[e].productId;
                                        orders_orderRows[i].REF_PRODUCT_NAME           =   orders_resultStruct.content[i].lines[e].productName;
                                        orders_orderRows[i].REF_PRODUCT_CODE           =   orders_resultStruct.content[i].lines[e].merchantSku;
                                        orders_orderRows[i].REF_PRODUCT_COLOR          =   orders_resultStruct.content[i].lines[e].productColor;
                                        orders_orderRows[i].REF_PRODUCT_SIZE           =   orders_resultStruct.content[i].lines[e].productSize;
                                        orders_orderRows[i].REF_BARCODE                =   orders_resultStruct.content[i].lines[e].barcode;
                                        orders_orderRows[i].REF_STOCK_CODE             =   orders_resultStruct.content[i].lines[e].sku;
                                        orders_orderRows[i].REF_MERCHANT_ID            =   orders_resultStruct.content[i].lines[e].merchantId;
                                        orders_orderRows[i].REF_MERCHANT_STOCK_CODE    =   orders_resultStruct.content[i].lines[e].merchantSku;
                                        orders_orderRows[i].REF_STATUS_NAME            =   orders_resultStruct.content[i].lines[e].orderLineItemStatusName;
                                        orders_orderRows[i].REF_QUANTITY               =   orders_resultStruct.content[i].lines[e].quantity;
                                        orders_orderRows[i].REF_PRICE                  =   orders_resultStruct.content[i].lines[e].price;
                                        orders_orderRows[i].REF_TOTAL_PRICE            =   orders_resultStruct.content[i].lines[e].price * orders_resultStruct.content[i].lines[e].quantity;
                                        orders_orderRows[i].REF_VAT_BASE_AMOUNT        =   orders_resultStruct.content[i].lines[e].vatBaseAmount;
                                        orders_orderRows[i].REF_SALES_CAMPAIGN_ID      =   orders_resultStruct.content[i].lines[e].salesCampaignId;
                                        
                                        DataStore.addOrderRow(args=orders_orderRows[i]);
                                    }
                                }

                                orders_orderHistory[i] = structNew();

                                if(arrayLen(orders_resultStruct.content[i].packageHistories)){
                                    for(a=1; a <= arrayLen(orders_resultStruct.content[i].packageHistories); a++){
                                        orders_orderHistory[i].ORDER_ID    =   ORDER_ID[i];
                                        //orders_orderHistory[i].CREATE_DATE =   DateTimeFormat(dateAdd("s", Left(orders_resultStruct.content[i].packageHistories[a].createdDate,10), "1970-01-01 00:00:00"),"YYYY-MM-DD HH:mm:ss");
                                        orders_orderHistory[i].STATUS      =   orders_resultStruct.content[i].packageHistories[a].status;
                                        DataStore.addOrderHistory(args=orders_orderHistory[i]);
                                    }
                                }
                            }
                            else{//Sipariş daha önce kayıt edilmiş, durum güncellemesi yapıyoruz
                                if(orders_orderDetail.REF_STATUS_NAME Neq orders_resultStruct.content[i].shipmentPackageStatus){
                                    DataStore.updateOrder(
                                        order_id=orders_orderDetail.ORDER_ID,
                                        ref_status_name=orders_resultStruct.content[i].shipmentPackageStatus
                                    );
                                }
                                if(arrayLen(orders_resultStruct.content[i].lines)){//İptal olan sipariş kalemi var ise güncelliyoruz
                                    for(e=1; e <= arrayLen(orders_resultStruct.content[i].lines); e++){
                                        orders_orderRows[i] = structNew();
                                        orders_orderRows[i].REF_ORDER_ID       =   orders_resultStruct.content[i].id;
                                        orders_orderRows[i].REF_ORDER_NUMBER   =   orders_resultStruct.content[i].orderNumber;
                                        orders_orderRows[i].REF_ORDER_ROW_ID   =   orders_resultStruct.content[i].lines[e].id;
                                        orders_getOrderRow = DataStore.getData(table="ORDER_ROWS",args=orders_orderRows[i]);
                                        orders_orderRows[i].REF_STATUS_NAME    =   orders_resultStruct.content[i].lines[e].orderLineItemStatusName;
                                        if(orders_getOrderRow.RecordCount){
                                            if(orders_orderRows[i].REF_STATUS_NAME Eq 'Cancelled' And orders_getOrderRow.REF_STATUS_NAME Neq 'Cancelled'){
                                                DataStore.updateOrderRowStatus(row_id=orders_getOrderRow.ROW_ID,status_name='Cancelled');
                                                DataStore.addOrderChanges(
                                                    order_id=orders_getOrderRow.ORDER_ID,
                                                    row_number=orders_getOrderRow.ROW_NUMBER,
                                                    ref_order_id=orders_getOrderRow.REF_ORDER_ID,
                                                    ref_order_row_id=orders_getOrderRow.REF_ORDER_ROW_ID,
                                                    ref_system=variables.partner,
                                                    tar_system='SAPCRM',
                                                    quantity=orders_getOrderRow.REF_QUANTITY,
                                                    status_name='Cancelled'
                                                );
                                            }
                                            else if(orders_orderRows[i].REF_STATUS_NAME Eq 'ReturnReadyToShip' And orders_getOrderRow.REF_STATUS_NAME Neq 'ReturnReadyToShip'){
                                                DataStore.updateOrderRowStatus(row_id=orders_getOrderRow.ROW_ID,status_name='ReturnReadyToShip');
                                                DataStore.addOrderChanges(
                                                    order_id=orders_getOrderRow.ORDER_ID,
                                                    row_number=orders_getOrderRow.ROW_NUMBER,
                                                    ref_order_id=orders_getOrderRow.REF_ORDER_ID,
                                                    ref_order_row_id=orders_getOrderRow.REF_ORDER_ROW_ID,
                                                    ref_system=variables.partner,
                                                    tar_system='SAPCRM',
                                                    quantity=orders_getOrderRow.REF_QUANTITY,
                                                    status_name='ReturnReadyToShip'
                                                );
                                            }
                                            else if(orders_orderRows[i].REF_STATUS_NAME Eq 'ReturnShipped' And orders_getOrderRow.REF_STATUS_NAME Neq 'ReturnShipped'){
                                                DataStore.updateOrderRowStatus(row_id=orders_getOrderRow.ROW_ID,status_name='ReturnShipped');
                                                DataStore.addOrderChanges(
                                                    order_id=orders_getOrderRow.ORDER_ID,
                                                    row_number=orders_getOrderRow.ROW_NUMBER,
                                                    ref_order_id=orders_getOrderRow.REF_ORDER_ID,
                                                    ref_order_row_id=orders_getOrderRow.REF_ORDER_ROW_ID,
                                                    ref_system=variables.partner,
                                                    tar_system='SAPCRM',
                                                    quantity=orders_getOrderRow.REF_QUANTITY,
                                                    status_name='ReturnShipped'
                                                );
                                            }
                                        }
                                    }
                                }
                                if(arrayLen(orders_resultStruct.content[i].packageHistories)){//Gelen history kayıtlarını ekliyoruz
                                    for(a=1; a <= arrayLen(orders_resultStruct.content[i].packageHistories); a++){
                                        orders_orderHistory[i] = structNew();
                                        orders_orderHistory[i].ORDER_ID    =   orders_orderDetail.ORDER_ID;
                                        //orders_orderHistory[i].CREATE_DATE =   DateTimeFormat(dateAdd("s", Left(orders_resultStruct.content[i].packageHistories[a].createdDate,10), "1970-01-01 00:00:00"),"YYYY-MM-DD HH:mm:ss");
                                        orders_orderHistory[i].STATUS      =   orders_resultStruct.content[i].packageHistories[a].status;
                                        DataStore.addOrderHistory(args=orders_orderHistory[i]);
                                    }
                                }
                            }
                        }

                        orders_log_is_success = 1;
                        orders_log_request = "#orders_wsInfo.ADDRESS#suppliers/#orders_wsInfo.USER_ID#/orders?page=#page#&size=#pageSize#";
                        orders_log_response = orders_REST_Result.FileContent;
                        orders_log_status_code = orders_REST_Result.StatusCode;
                    }
                    else if(structKeyExists(orders_resultStruct, "errors")){
                        orders_log_is_success = 0;
                        orders_log_request = "#orders_wsInfo.ADDRESS#suppliers/#orders_wsInfo.USER_ID#/orders?page=#page#&size=#pageSize#";
                        orders_log_response = orders_REST_Result.FileContent;
                        orders_log_status_code = orders_REST_Result.StatusCode;
                    }
                }
            }
            else{
                orders_log_is_success = 0;
                orders_log_request = "#orders_wsInfo.ADDRESS#suppliers/#orders_wsInfo.USER_ID#/orders?page=#page#&size=#pageSize#";
                orders_log_response = orders_REST_Result.FileContent;
                orders_log_status_code = orders_REST_Result.StatusCode;
            }

            DataStore.serviceLog(
                log_id=orders_service_log_id,
                is_success=orders_log_is_success,
                request=orders_log_request,
                response=orders_log_response,
                status_code=orders_log_status_code
            );

            orders_log_is_success = 1;
            orders_log_request = "";
            orders_log_response = "";
            orders_log_status_code = "";

            page = page + 1;
        </cfscript>
    </cfloop>
    
</cffunction>

<cffunction name="updatePackage" access="public" returntype="void" output="false" hint="Oluşturulan sipariş paketinin faturasının kesilmesi işleminin Trendyol’a bildirilebilmesi için kullanılır. Fatura kesme işleminin bildirilmesi, Trendyol Müşteri Hizmetlerine ulaşan, müşteri kaynaklı iptallerin önlenmesi için bir referanstır, RESTful isteğinin PUT yöntemi ile gönderilmesi gerekir.">
    <cfscript>
        updatePackage_args    = structNew();
        updatePackage_args.STATUS = 1;
        updatePackage_args.REF_SYSTEM = 'SAP';
        updatePackage_args.TAR_SYSTEM = variables.partner;
        updatePackage_getOrderChanges = DataStore.getData(table="ORDER_CHANGES",args=updatePackage_args);
    </cfscript>

    <cfif updatePackage_getOrderChanges.RecordCount>
    <cfloop query="updatePackage_getOrderChanges">
        <cfscript>
            updatePackage_log_is_success  = 1;
            updatePackage_log_request     = '';
            updatePackage_log_response    = '';
            updatePackage_log_status_code = '';
            updatePackage_log_message     = '';
            updatePackage_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='updatePackage');
            updatePackage_wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=2);
        </cfscript>

        <cfsavecontent variable="updatePackage_REST_Content"><cfoutput>
            {
                "lines": [
                    {
                    "lineId": #REF_ORDER_ROW_ID#,
                    "quantity": #QUANTITY#
                    }
                ],
                "params": {},
                "status": "#STATUS_NAME#"
            }</cfoutput>
        </cfsavecontent>

        <cfset updatePackage_REST_Content = DataStore.clearJSONContent(JSONContent=updatePackage_REST_Content,  delete_spaces=1) />

        <cfhttp
            url="#updatePackage_wsInfo.ADDRESS#suppliers/#updatePackage_wsInfo.USER_ID#/shipment-packages/#REF_ORDER_ID#"
            method="PUT"
            username="#updatePackage_wsInfo.USER_NAME#"
            password="#updatePackage_wsInfo.PASSWD#"
            result="updatePackage_REST_Result">
            <cfhttpparam type="header" name="Content-Type" value="application/json;charset=UTF-8" />
            <cfhttpparam type="body" value="#Trim(updatePackage_REST_Content)#" />
        </cfhttp>

        <cfscript>
            updatePackage_log_is_success = 1;
            updatePackage_log_request = updatePackage_REST_Content;
            updatePackage_log_response = updatePackage_REST_Result.FileContent;
            updatePackage_log_status_code = updatePackage_REST_Result.StatusCode;

            DataStore.updateOrderChanges(cId=ID);

            DataStore.serviceLog(
                log_id=updatePackage_service_log_id,
                is_success=updatePackage_log_is_success,
                request=updatePackage_log_request,
                response=updatePackage_log_response,
                status_code=updatePackage_log_status_code
            );

            updatePackage_log_request = "";
            updatePackage_log_response = "";
            updatePackage_log_message = "";
            updatePackage_log_status_code = "";
        </cfscript>
    </cfloop>
    </cfif>
</cffunction>

<cffunction name="deleteProduct" access="public" returntype="void" output="false" hint="product_changes TYPE D olan ürünler için updatePriceAndInventory metodu price ve quantity 0 gönderilerek ürün silinir, RESTful isteğinin POST yöntemi ile gönderilmesi gerekir.">

    <cfscript>
        deleteProduct_wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=2);
        deleteProduct_changes = DataStore.getProductChanges(type="D",type_value=variables.partner);
    </cfscript>

    <cfif deleteProduct_changes.RecordCount>
        <cfscript>
            deleteProduct_log_is_success  = 1;
            deleteProduct_log_request     = '';
            deleteProduct_log_response    = '';
            deleteProduct_log_status_code = '';
            deleteProduct_log_message     = '';
            deleteProduct_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='deleteProduct');
        </cfscript>
        <cfsavecontent variable="deleteProduct_REST_Content"><cfoutput>{
                "items": [
                    <cfloop query="#deleteProduct_changes#">
                    <cfset deleteProduct_product = Datastore.getProduct(code=PRODUCT_CODE) />
                    <cfoutput>
                    {
                    "barcode": "#deleteProduct_product.EAN_NO#",
                    "quantity": "0",
                    "salePrice": "0",
                    "listPrice": "0"
                    }<cfif deleteProduct_changes.RecordCount Gt 1 And CurrentRow Lt deleteProduct_changes.RecordCount>,</cfif>
                    </cfoutput>
                    </cfloop>
                ]
            }</cfoutput>
        </cfsavecontent>

        <cfset deleteProduct_REST_Content = DataStore.clearJSONContent(JSONContent=deleteProduct_REST_Content, delete_spaces=1) />

        <cfhttp
            url="#deleteProduct_wsInfo.ADDRESS#suppliers/#deleteProduct_wsInfo.USER_ID#/products/price-and-inventory"
            method="POST"
            username="#deleteProduct_wsInfo.USER_NAME#"
            password="#deleteProduct_wsInfo.PASSWD#"
            result="deleteProduct_REST_Result">
            <cfhttpparam type="header" name="Content-Type" value="application/json;charset=UTF-8" />
            <cfhttpparam type="body" value="#Trim(deleteProduct_REST_Content)#" />
        </cfhttp>

        <cfscript>
            if(isJSON(deleteProduct_REST_Result.FileContent)){
                deleteProduct_resultStruct = deserializeJSON(deleteProduct_REST_Result.FileContent);

                if(isStruct(deleteProduct_resultStruct)){
                    if(structKeyExists(deleteProduct_resultStruct, "batchRequestId")){
                        for(deleteProduct_change in deleteProduct_changes){
                            DataStore.updateProductChanges(cId=deleteProduct_change.ID, batch="#deleteProduct_resultStruct.batchRequestId#");
                        }
                        deleteProduct_log_is_success = 1;
                        deleteProduct_log_request = deleteProduct_REST_Content;
                        deleteProduct_log_response = deleteProduct_REST_Result.FileContent;
                        deleteProduct_log_status_code = deleteProduct_REST_Result.StatusCode;
                    }
                    else if(structKeyExists(deleteProduct_resultStruct, "errors")){
                        deleteProduct_log_is_success = 0;
                        deleteProduct_log_request = deleteProduct_REST_Content;
                        deleteProduct_log_response = deleteProduct_REST_Result.FileContent;
                        deleteProduct_log_status_code = deleteProduct_REST_Result.StatusCode;
                    }
                }
            }
            else{
                deleteProduct_log_is_success = 0;
                deleteProduct_log_request = deleteProduct_REST_Content;
                deleteProduct_log_response = deleteProduct_REST_Result.FileContent;
                deleteProduct_log_status_code = deleteProduct_REST_Result.StatusCode;
            }

            DataStore.serviceLog(
                log_id=deleteProduct_service_log_id,
                is_success=deleteProduct_log_is_success,
                request=deleteProduct_log_request,
                response=deleteProduct_log_response,
                status_code=deleteProduct_log_status_code
            );

            deleteProduct_log_is_success = 1;
            deleteProduct_log_request = "";
            deleteProduct_log_response = "";
            deleteProduct_log_message = "";
            deleteProduct_log_status_code = "";
        </cfscript>
    </cfif>

</cffunction>

<!----------------------------------- PRIVATE METHODS --------------------------------------->

</cfcomponent>