<cfcomponent name="N11Adapter" output="false" hint="N11 Adapter">
    
    <cfproperty name="DataStore" Inject="DataStore" />
    <cfproperty name="ContentServer" Inject="ContentServerAdapter" />
    <cfproperty name="SAP" Inject="SAPAdapter" />
    <cfproperty name="BugLog" Inject="provider:BugLogService@bugloghq" />

    <cfscript>
        variables.partner           = 'N11';
        variables.brand_name        = 'Ruum Store by Doğtaş';
        variables.integration_id    = 12;
        variables.shipmentCompany   = 345; //Aras Kargo
        variables.shipmentTemplate  = 'ARAS';
        variables.list_array        = ArrayNew(1);
    </cfscript>

    <!----------------------------------- CONSTRUCTOR --------------------------------------->

    <cffunction name="init" access="public" returntype="any" output="false" hint="constructor">
        <cfreturn this />
    </cffunction>

    <cffunction name="subCategories" access="public" returntype="any" output="true">
        <cfargument name="id" type="string" required="true" />
        <cfscript>
            wsInfo=DataStore.getData(table="SETUP_INTEGRATIONS",id=variables.integration_id)
        </cfscript>
        <cfoutput>
            <cfsavecontent variable="getProductSubCategorys_Request">
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
                    <soapenv:Header/>
                        <soapenv:Body>
                            <sch:GetSubCategoriesRequest>
                                <auth>
                                    <appKey>#wsInfo.user_name#</appKey>
                                    <appSecret>#wsInfo.passwd#</appSecret>
                                </auth>
                                <categoryId>#arguments.id#</categoryId>
                            </sch:GetSubCategoriesRequest>
                        </soapenv:Body>
                </soapenv:Envelope>
            </cfsavecontent>
        </cfoutput>

        <cfhttp url="#wsInfo.address#/ws/categoryService.wsdl" method="post" result="getProductSubCategorys_Result">
            <cfhttpparam type="header" name="content-type" value="text/xml" />
            <cfhttpparam type="header" name="content-length" value="#Len(getProductSubCategorys_Request)#" />
            <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
            <cfhttpparam type="header" name="charset" value="utf-8" />
            <cfhttpparam type="xml" value="#Trim(getProductSubCategorys_Request)#" />
        </cfhttp>

        <cfscript>
            log_request     = getProductSubCategorys_Request;
            log_status_code = getProductSubCategorys_Result.StatusCode;
            if((Not Len(getProductSubCategorys_Result.ErrorDetail))){
                getProductSubCategorys_Response = xmlParse(getProductSubCategorys_Result.FileContent).Envelope.Body.GetSubCategoriesResponse.category;
                if(StructKeyExists(getProductSubCategorys_Response,"subCategoryList")){
                    getProductSubCategorys_Response =getProductSubCategorys_Response.subCategoryList.XmlChildren;
                }
                for (item in getProductSubCategorys_Response){
                    
                        if(NOT isNull(item.id.XmlText))
                        {
                            list_struct=structNew('ordered');
                            list_struct.PARTNER=variables.partner;
                            list_struct.PARTNER_CAT_ID=item.id.XmlText;
                            list_struct.PARTNER_CATEGORY_NAME="#item.name.XmlText#";
                            list_struct.PARTNER_PARENT_CAT_ID=arguments.id;

                            product_Args=structNew('ordered');
                            product_Args.PARTNER=variables.partner;
                            product_Args.PARTNER_CAT_ID=item.id.XmlText;

                            product_categoryDetail = DataStore.getData(table="PRODUCT_CATEGORY", args=product_Args);
                            if(product_categoryDetail.recordcount eq 0)
                            {
                                product_categoryArgsDetail = DataStore.addData(table="PRODUCT_CATEGORY", args=list_struct,identity_name='CAT_ID');
                            }
                            subCategories(list_struct.PARTNER_CAT_ID);
                        }
                        
                }
                log_is_success  = 1;
                log_response    = getProductCategorys_Result.FileContent;
            }
            else{
                log_is_success  = 0;
                log_response    = getProductCategorys_Result.FileContent;
            }
        </cfscript>
    </cffunction>

    <!----------------------------------- PUBLIC METHODS --------------------------------------->

    <cffunction name="createProducts" access="public" returntype="void" output="false" hint="">
        <cfscript>
            wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=12);
            productChanges  = DataStore.getProductChanges(type="I", type_value=variables.partner);
        </cfscript>

        <cfif productChanges.recordcount>
            <cfloop from="1" to="#productChanges.recordcount#" index="i">
                <cfscript>
                    getProduct          = DataStore.getProduct(code=productChanges.product_code[i]);
                    product_en_base     = getProduct.EN_BASE_UNIT / 10;
                    product_boy_base    = getProduct.BOY_BASE_UNIT / 10;
                    /* HATA YÖNETİMİ */

                    productInfo         = ContentServer.getProductInfov2(product_code=productChanges.product_code[i], partner=variables.partner);

                    price               = DataStore.getPrice(code=getProduct.product_code,price_list=variables.partner);
                    stockAmount         = DataStore.getMaterialStock(material_id=getProduct.product_code);

                    storeProductCatID   = DataStore.getData(table = "PRODUCT_CATEGORY", args = {CAT_CODE = getProduct.mal_grubu, PARTNER = variables.partner}).PARTNER_CAT_ID;

                    createProducts_log_is_success  = 1;
                    createProducts_log_request     = '';
                    createProducts_log_response    = '';
                    createProducts_log_status_code = '';
                    createProducts_log_message     = '';
                </cfscript>

                <cfif Len(storeProductCatID)>
                    <cfscript>
                        createProducts_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='createProducts');
                        args    = structNew();
                        args.PARTNER    = variables.partner;
                        args.CAT_ID     = storeProductCatID;
                        args.IS_REQUIRED= 1;
                        categoryProductAttributes    = DataStore.getData(table='PRODUCT_CATEGORY_ATTRIBUTES', args=args);
                    </cfscript>
                    <cfoutput><cfsavecontent variable="saveProductContent">
                        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
                            <soapenv:Header/>
                            <soapenv:Body>
                                <sch:SaveProductRequest>
                                <auth>
                                    <appKey>#wsInfo.user_name#</appKey>
                                    <appSecret>#wsInfo.passwd#</appSecret>
                                </auth>
                                <product>
                                    <productSellerCode>#getProduct.product_code#</productSellerCode>
                                    <title>#productInfo.product.product_name#</title>
                                    <subtitle>#productInfo.product.short_description#</subtitle>
                                    <description><![CDATA[#productInfo.product.long_description#]]></description> 
                                    <category>
                                        <id>#storeProductCatID#</id>
                                    </category>
                                    <specialProductInfoList/>
                                    <price>#price.list_price#</price>
                                    <currencyType>1</currencyType>
                                    <domestic>true</domestic>
                                    <images>
                                        <cfloop from="1" to="#arrayLen(productInfo.product.images)#" index="img">
                                            <image>
                                                <url>#productInfo.product.images[img].image_path#</url>
                                                <order>#img#</order>
                                            </image>
                                        </cfloop>
                                    </images>
                                    <approvalStatus>2</approvalStatus><!--- beklemede durumu --->
                                    <cfif categoryProductAttributes.RecordCount>
                                    <attributes>
                                        <cfloop query='categoryProductAttributes'>
                                        <attribute>
                                           <name>#categoryProductAttributes.ATTRIBUTE_NAME#</name>
                                        <cfif categoryProductAttributes.ATTRIBUTE_NAME Eq 'Marka'>
                                           <value>#variables.brand_name#</value>
                                        <cfelseif categoryProductAttributes.ATTRIBUTE_NAME Eq 'Ölçüler'>
                                            <value>#product_en_base#X#product_boy_base#</value>
                                        <cfelseif categoryProductAttributes.ATTRIBUTE_NAME Eq 'Materyal'>
                                            <value>Kumaş</value>
                                        <cfelse>
                                            <value></value>
                                        </cfif>
                                        </attribute>
                                        </cfloop>
                                     </attributes>
                                    </cfif>
                                    <saleStartDate></saleStartDate>
                                    <saleEndDate></saleEndDate>
                                    <productionDate></productionDate>
                                    <expirationDate/>
                                    <productCondition>1</productCondition>
                                    <preparingDay>2</preparingDay>
                                    <discount>
                                        <type>3</type>
                                        <value>#price.sales_price#</value>
                                    </discount>
                                    <shipmentTemplate>#variables.shipmentTemplate#</shipmentTemplate>
                                    <stockItems>
                                        <stockItem>
                                            <bundle/>
                                            <mpn/>
                                            <gtin>#getProduct.ean_no#</gtin>
                                            <oem></oem>
                                            <quantity>#stockAmount#</quantity>
                                            <sellerStockCode>#getProduct.product_code#</sellerStockCode>
                                            <attributes/>
                                            <optionPrice/>
                                        </stockItem>
                                    </stockItems>
                                </product>
                                </sch:SaveProductRequest>
                            </soapenv:Body>
                        </soapenv:Envelope> 
                    </cfsavecontent></cfoutput>

                    <cfhttp url="#wsInfo.address#/ws/ProductService.wsdl" method="post" result="res">
                        <cfhttpparam type="header" name="content-type" value="text/xml" />
                        <cfhttpparam type="header" name="content-length" value="#Len(saveProductContent)#" />
                        <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                        <cfhttpparam type="header" name="charset" value="utf-8" />
                        <cfhttpparam type="xml" value="#Trim(saveProductContent)#" />
                    </cfhttp>

                    <cfscript>
                        createProducts_log_request      = saveProductContent;
                        createProducts_log_response     = res.filecontent;

                        createProducts_result           = xmlParse(res.FileContent).Envelope.Body.SaveProductResponse;
                        createProducts_result_status    = createProducts_result.result.status.XmlText;

                        if(createProducts_result_status eq 'success') {
                            DataStore.updateProductChanges(cId=productChanges.ID[i], batch="");
                            createProducts_log_is_success   = 1;
                            createProducts_log_status_code  = res.StatusCode;
                        }
                        else if(createProducts_result_status eq 'failure'){
                            createProducts_log_is_success   = 0;
                            createProducts_log_status_code  = res.StatusCode;
                            createProducts_log_message      = createProducts_result.result.errorMessage.XmlText;
                        }
                        else {
                            createProducts_log_is_success   = 0;
                            createProducts_log_status_code  = res.StatusCode;
                        }

                        DataStore.serviceLog(
                            log_id=createProducts_service_log_id,
                            is_success=createProducts_log_is_success,
                            request=createProducts_log_request,
                            response=createProducts_log_response,
                            status_code=createProducts_log_status_code,
                            message=createProducts_log_message
                        );
                    </cfscript>
                <cfelse>
                    <cfscript>
                        log_message	= variables.partner & " sistemine ürün aktarımı başarısız, ürün kategorisi belirlenemedi.";
                        log_detail  = getProduct.product_name & " ürünü için kategori tanımı bulunamadı. Mal grubu " & getProduct.mal_grubu;
                        BugLog.notifyService(message=log_message, extraInfo=log_detail, severityCode="WARN");
                    </cfscript>
                </cfif>
            </cfloop>
        </cfif>
    </cffunction>
	
	<cffunction name="updateProducts" access="public" returntype="void" output="false" hint="">
        <cfscript>
            wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=12);
            productChanges  = DataStore.getProductChanges(type="U", type_value=variables.partner);
        </cfscript>

        <cfif productChanges.recordcount>
            <cfloop from="1" to="#productChanges.recordcount#" index="i">
                <cfscript>
                    getProduct          = DataStore.getProduct(code=productChanges.product_code[i]);
                    product_en_base     = getProduct.EN_BASE_UNIT / 10;
                    product_boy_base    = getProduct.BOY_BASE_UNIT / 10;
                    /* HATA YÖNETİMİ */

                    productInfo         = ContentServer.getProductInfov2(product_code=productChanges.product_code[i], partner=variables.partner);

                    price               = DataStore.getPrice(code=getProduct.product_code,price_list=variables.partner);
                    stockAmount         = DataStore.getMaterialStock(material_id=getProduct.product_code);

                    storeProductCatID   = DataStore.getData(table = "PRODUCT_CATEGORY", args = {CAT_CODE = getProduct.mal_grubu, PARTNER = variables.partner}).PARTNER_CAT_ID;

                    createProducts_log_is_success  = 1;
                    createProducts_log_request     = '';
                    createProducts_log_response    = '';
                    createProducts_log_status_code = '';
                    createProducts_log_message     = '';
                </cfscript>

                <cfif Len(storeProductCatID)>
					<cfoutput>
						<cfsavecontent variable="getProductAprrovalStatus">
							<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
							   <soapenv:Header/>
							   <soapenv:Body>
								  <sch:GetProductBySellerCodeRequest>
									 <auth>
										<appKey>#wsInfo.user_name#</appKey>
										<appSecret>#wsInfo.passwd#</appSecret>
									 </auth>
									 <sellerCode>#productChanges.product_code[i]#</sellerCode>
								  </sch:GetProductBySellerCodeRequest>
							   </soapenv:Body>
							</soapenv:Envelope>
						</cfsavecontent>
					</cfoutput>
					
					<cfscript>
						getProductAprrovalStatus_service_log_id		= DataStore.serviceLog(partner=variables.partner, logger='getProductAprrovalStatus');
						getProductAprrovalStatus_log_is_success		= 1;
						getProductAprrovalStatus_log_request		= '';
						getProductAprrovalStatus_log_response		= '';
						getProductAprrovalStatus_log_status_code	= '';
						getProductAprrovalStatus_log_message		= '';
						controlProductError							= 0; //ApprovalStatus sorgususunda ürün bulunamazsa tekrar ürün kontrol edilmesin
						approvalStatus								= 2; //Beklemede
					</cfscript>
					
					<cfhttp url="#wsInfo.address#/ws/ProductService.wsdl" method="post" result="res1">
						<cfhttpparam type="header" name="content-type" value="text/xml" />
						<cfhttpparam type="header" name="content-length" value="#Len(getProductAprrovalStatus)#" />
						<cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
						<cfhttpparam type="header" name="charset" value="utf-8" />
						<cfhttpparam type="xml" value="#Trim(getProductAprrovalStatus)#" />
					</cfhttp>
					
					<cfscript>
						response = xmlParse(res1.FileContent).Envelope.Body.GetProductBySellerCodeResponse;

						if(isDefined('response.result.status') and response.result.status.XmlText eq 'failure') {
							getProductAprrovalStatus_log_message = response.result.errorMessage.XmlText;
							getProductAprrovalStatus_log_is_success= 0;
							controlProductError		= 1; 
						} else {
							getProductAprrovalStatus_log_message    = 'Ürün Kabul Durumu Sorgulandı';
							getProductAprrovalStatus_log_is_success	= 1;
							approvalStatus 							= response.product.approvalStatus.XmlText;
						}
						getProductAprrovalStatus_log_request        = getProductAprrovalStatus;
						getProductAprrovalStatus_log_status_code    = res1.Statuscode;
						getProductAprrovalStatus_log_response       = res1.FileContent;

						DataStore.serviceLog(
							log_id		=	getProductAprrovalStatus_service_log_id,
							is_success	=	getProductAprrovalStatus_log_is_success,
							request		=	getProductAprrovalStatus_log_request,
							response	=	getProductAprrovalStatus_log_response,
							status_code	=	getProductAprrovalStatus_log_status_code,
							message 	= 	getProductAprrovalStatus_log_message
						);
					</cfscript>
					<cfif controlProductError eq 0>
						<cfscript>
							createProducts_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='updateProducts');
							args    = structNew();
							args.PARTNER    = variables.partner;
							args.CAT_ID     = storeProductCatID;
							args.IS_REQUIRED= 1;
							categoryProductAttributes    = DataStore.getData(table='PRODUCT_CATEGORY_ATTRIBUTES', args=args);
						</cfscript>
						<cfoutput><cfsavecontent variable="saveProductContent">
							<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
								<soapenv:Header/>
								<soapenv:Body>
									<sch:SaveProductRequest>
									<auth>
										<appKey>#wsInfo.user_name#</appKey>
										<appSecret>#wsInfo.passwd#</appSecret>
									</auth>
									<product>
										<productSellerCode>#getProduct.product_code#</productSellerCode>
										<title>#productInfo.product.product_name#</title>
										<subtitle>#productInfo.product.short_description#</subtitle>
										<description><![CDATA[#productInfo.product.long_description#]]></description> 
										<category>
											<id>#storeProductCatID#</id>
										</category>
										<specialProductInfoList/>
										<price>#price.list_price#</price>
										<currencyType>1</currencyType>
										<domestic>true</domestic>
										<images>
											<cfloop from="1" to="#arrayLen(productInfo.product.images)#" index="img">
												<image>
													<url>#productInfo.product.images[img].image_path#</url>
													<order>#img#</order>
												</image>
											</cfloop>
										</images>
										<approvalStatus>#approvalStatus#</approvalStatus><!--- beklemede durumu --->
										<cfif categoryProductAttributes.RecordCount>
										<attributes>
											<cfloop query='categoryProductAttributes'>
											<attribute>
											   <name>#categoryProductAttributes.ATTRIBUTE_NAME#</name>
											<cfif categoryProductAttributes.ATTRIBUTE_NAME Eq 'Marka'>
											   <value>#variables.brand_name#</value>
											<cfelseif categoryProductAttributes.ATTRIBUTE_NAME Eq 'Ölçüler'>
												<value>#product_en_base#X#product_boy_base#</value>
											<cfelseif categoryProductAttributes.ATTRIBUTE_NAME Eq 'Materyal'>
												<value>Kumaş</value>
											<cfelse>
												<value></value>
											</cfif>
											</attribute>
											</cfloop>
										 </attributes>
										</cfif>
										<saleStartDate></saleStartDate>
										<saleEndDate></saleEndDate>
										<productionDate></productionDate>
										<expirationDate/>
										<productCondition>1</productCondition>
										<preparingDay>2</preparingDay>
										<discount>
											<type>3</type>
											<value>#price.sales_price#</value>
										</discount>
										<shipmentTemplate>#variables.shipmentTemplate#</shipmentTemplate>
										<stockItems>
											<stockItem>
												<bundle/>
												<mpn/>
												<gtin>#getProduct.ean_no#</gtin>
												<oem></oem>
												<quantity>#stockAmount#</quantity>
												<sellerStockCode>#getProduct.product_code#</sellerStockCode>
												<attributes/>
												<optionPrice/>
											</stockItem>
										</stockItems>
									</product>
									</sch:SaveProductRequest>
								</soapenv:Body>
							</soapenv:Envelope> 
						</cfsavecontent></cfoutput>
	
						<cfhttp url="#wsInfo.address#/ws/ProductService.wsdl" method="post" result="res">
							<cfhttpparam type="header" name="content-type" value="text/xml" />
							<cfhttpparam type="header" name="content-length" value="#Len(saveProductContent)#" />
							<cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
							<cfhttpparam type="header" name="charset" value="utf-8" />
							<cfhttpparam type="xml" value="#Trim(saveProductContent)#" />
						</cfhttp>
	
						<cfscript>
							createProducts_log_request      = saveProductContent;
							createProducts_log_response     = res.filecontent;
	
							createProducts_result           = xmlParse(res.FileContent).Envelope.Body.SaveProductResponse;
							createProducts_result_status    = createProducts_result.result.status.XmlText;
	
							if(createProducts_result_status eq 'success') {
								DataStore.updateProductChanges(cId=productChanges.ID[i]);
								createProducts_log_is_success   = 1;
								createProducts_log_status_code  = res.StatusCode;
								createProducts_log_message		= 'Ürün güncellendi';
							}
							else if(createProducts_result_status eq 'failure' And createProducts_result.result.errorCode.xmlText Eq 'SELLER_API.notFound'){
								createProducts_log_is_success   = 0;
								createProducts_log_status_code  = res.StatusCode;
								createProducts_log_message      = createProducts_result.result.errorMessage.XmlText;
								DataStore.updateProductChanges(cId=productChanges.ID[i]);
							}
							else {
								createProducts_log_is_success   = 0;
                                createProducts_log_status_code  = res.StatusCode;
                                createProducts_log_message      = createProducts_result.result.errorMessage.XmlText;
							}
	
							DataStore.serviceLog(
								log_id=createProducts_service_log_id,
								is_success=createProducts_log_is_success,
								request=createProducts_log_request,
								response=createProducts_log_response,
								status_code=createProducts_log_status_code,
								message=createProducts_log_message
							);
						</cfscript>
					</cfif>
                <cfelse>
                    <cfscript>
                        log_message	= variables.partner & " sistemine ürün aktarımı başarısız, ürün kategorisi belirlenemedi.";
                        log_detail  = getProduct.product_name & " ürünü için kategori tanımı bulunamadı. Mal grubu " & getProduct.mal_grubu;
                        BugLog.notifyService(message=log_message, extraInfo=log_detail, severityCode="WARN");
                    </cfscript>
                </cfif>
            </cfloop>
        </cfif>
    </cffunction>
	
	<cffunction name="updatePrice" access="public" returntype="void" output="false" hint="">
		<cfscript>
            wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=12);
            productChanges  = DataStore.getProductChanges(type="P", type_value=variables.partner);
        </cfscript>

        <cfloop index="i" from="1" to="#productChanges.recordcount#">
            <cfscript>
                price[i]                        = DataStore.getPrice(code=productChanges.PRODUCT_CODE[i],price_list=variables.partner);
                getProductList_service_log_id   = DataStore.serviceLog(partner=variables.partner, logger='updatePrice');
                getProductList_log_is_success   = 1;
                getProductList_log_request      = '';
                getProductList_log_response     = '';
                getProductList_log_status_code  = '';
                getProductList_log_message      = '';
            </cfscript>
			
			<cfoutput>
				<cfsavecontent variable="getProductListContent">
					<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
					<soapenv:Header/>
					<soapenv:Body>
						<sch:UpdateProductBasicRequest>
							<auth>
								<appKey>#wsInfo.user_name#</appKey>
								<appSecret>#wsInfo.passwd#</appSecret>
							</auth>
							<productSellerCode>#productChanges.PRODUCT_CODE[i]#</productSellerCode>
							<price>#price[i].LIST_PRICE#</price>
							<currencyType>1</currencyType>
							 <productDiscount>
								<discountType>3</discountType>
								<discountValue>#price[i].SALES_PRICE#</discountValue>
							 </productDiscount>

						</sch:UpdateProductBasicRequest>
					</soapenv:Body>
					</soapenv:Envelope>
				</cfsavecontent>
			</cfoutput>

            <cfhttp url="#wsInfo.address#/ws/ProductService.wsdl" method="post" result="res">
                <cfhttpparam type="header" name="content-type" value="text/xml" />
                <cfhttpparam type="header" name="content-length" value="#Len(getProductListContent)#" />
                <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                <cfhttpparam type="header" name="charset" value="utf-8" />
                <cfhttpparam type="xml" value="#Trim(getProductListContent)#" />
            </cfhttp>
			
            <cfscript>
                getProductList_log_request      = getProductListContent;
                getProductList_log_status_code  = res.Statuscode;
                getProductList_log_response     = res.FileContent;
				
                DataStore.serviceLog(
                    log_id=getProductList_service_log_id,
                    is_success=getProductList_log_is_success,
                    request=getProductList_log_request,
                    response=getProductList_log_response,
                    status_code=getProductList_log_status_code
                );
				
				if(res.Statuscode is '200 OK')
					DataStore.updateProductChanges(cId=productChanges.ID[i], batch="");
            </cfscript>
        </cfloop>
	</cffunction>
	
	<cffunction name="updateStock" access="public" returntype="void" output="false" hint="">
		<cfscript>
            wsInfo 		= DataStore.getData(table="SETUP_INTEGRATIONS", id=12);
            getStocks	= DataStore.getProduct(is_N11="X");
        </cfscript>

        <cfloop index="i" from="1" to="#getStocks.recordcount#">
            <cfscript>
                getProductList_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='updateStock');
                getProductList_log_is_success  = 1;
                getProductList_log_request     = '';
                getProductList_log_response    = '';
                getProductList_log_status_code = '';
                getProductList_log_message     = '';
            </cfscript>
			
			<cfoutput>
				<cfsavecontent variable="getProductListContent">
					<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
					<soapenv:Header/>
					<soapenv:Body>
					  <sch:UpdateStockByStockSellerCodeRequest>
						 <auth>
							<appKey>#wsInfo.user_name#</appKey>
							<appSecret>#wsInfo.passwd#</appSecret>
						 </auth>
						 <stockItems>
							<stockItem>
							   <sellerStockCode>#getStocks.PRODUCT_CODE[i]#</sellerStockCode>
							   <quantity>#getStocks.STOCKAMOUNT[i]#</quantity>
							</stockItem>
						 </stockItems>
					  </sch:UpdateStockByStockSellerCodeRequest>
					</soapenv:Body>
					</soapenv:Envelope>
				</cfsavecontent>
			</cfoutput>

            <cfhttp url="#wsInfo.address#/ws/ProductService.wsdl" method="post" result="res">
                <cfhttpparam type="header" name="content-type" value="text/xml" />
                <cfhttpparam type="header" name="content-length" value="#Len(getProductListContent)#" />
                <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                <cfhttpparam type="header" name="charset" value="utf-8" />
                <cfhttpparam type="xml" value="#Trim(getProductListContent)#" />
            </cfhttp>
			
            <cfscript>
                getProductList_log_request      = getProductListContent;
                getProductList_log_status_code  = res.Statuscode;
                getProductList_log_response     = res.FileContent;
				
                DataStore.serviceLog(
                    log_id=getProductList_service_log_id,
                    is_success=getProductList_log_is_success,
                    request=getProductList_log_request,
                    response=getProductList_log_response,
                    status_code=getProductList_log_status_code
                );
            </cfscript>
        </cfloop>
	</cffunction>
	
	<cffunction name="deleteProduct" access="public" returntype="void" output="false" hint="">
		<cfscript>
            wsInfo 			= DataStore.getData(table="SETUP_INTEGRATIONS", id=12);
            productChanges  = DataStore.getProductChanges(type="D", type_value=variables.partner);
        </cfscript>

        <cfloop index="i" from="1" to="#productChanges.recordcount#">
            <cfscript>
                getProductList_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='deleteProduct');
                getProductList_log_is_success  = 1;
                getProductList_log_request     = '';
                getProductList_log_response    = '';
                getProductList_log_status_code = '';
                getProductList_log_message     = '';
            </cfscript>
			
			<cfoutput>
				<cfsavecontent variable="getProductListContent">
					<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
					   <soapenv:Header/>
					   <soapenv:Body>
						  <sch:DeleteProductBySellerCodeRequest>
							 <auth>
								<appKey>#wsInfo.user_name#</appKey>
								<appSecret>#wsInfo.passwd#</appSecret>
							 </auth>
							 <productSellerCode>#productChanges.product_code[i]#</productSellerCode>
						  </sch:DeleteProductBySellerCodeRequest>
					   </soapenv:Body>
					</soapenv:Envelope>
				</cfsavecontent>
			</cfoutput>

            <cfhttp url="#wsInfo.address#/ws/ProductService.wsdl" method="post" result="res">
                <cfhttpparam type="header" name="content-type" value="text/xml" />
                <cfhttpparam type="header" name="content-length" value="#Len(getProductListContent)#" />
                <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                <cfhttpparam type="header" name="charset" value="utf-8" />
                <cfhttpparam type="xml" value="#Trim(getProductListContent)#" />
            </cfhttp>
			
            <cfscript>
                getProductList_log_request      = getProductListContent;
                getProductList_log_status_code  = res.Statuscode;
                getProductList_log_response     = res.FileContent;
				
				responseStruct = xmlParse(res.fileContent).Envelope.Body.DeleteProductBySellerCodeResponse.result;
				
				if(responseStruct.status.xmlText is 'success'){
					DataStore.updateProductChanges(cId=productChanges.ID[i]);
					message	= 'Ürün Silindi';
				}
				else if(responseStruct.status.xmlText is 'failure' and responseStruct.errorCode.xmlText is 'SELLER_API.notFound'){
					message							= responseStruct.errorMessage.xmlText;
					DataStore.updateProductChanges(cId=productChanges.ID[i]);
				}
				else{
					getProductList_log_is_success 	= 0;
					message							= responseStruct.errorMessage.xmlText;
				}
					
				DataStore.serviceLog(
                    log_id		= getProductList_service_log_id,
                    is_success	= getProductList_log_is_success,
                    request		= getProductList_log_request,
                    response	= getProductList_log_response,
                    status_code	= getProductList_log_status_code,
					message		= message
                );
					
            </cfscript>
        </cfloop>
	</cffunction>

    <cffunction name="updatePriceAndInventory" access="public" returntype="void" output="false" hint="">
        <cfset wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=12) />
        
        <cfset page = 0 />
        <cfset pageSize = 100 />
        <cfset productsInPage = pageSize />

        <cfloop condition="productsInPage gt 0">
            <cfscript>
                getProductList_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='updatePriceAndInventory');
                getProductList_log_is_success  = 1;
                getProductList_log_request     = '';
                getProductList_log_response    = '';
                getProductList_log_status_code = '';
                getProductList_log_message     = '';
            </cfscript>

            <cfoutput><cfsavecontent  variable="getProductListContent">
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
                <soapenv:Header/>
                <soapenv:Body>
                    <sch:GetProductListRequest>
                        <auth>
                            <appKey>#wsInfo.user_name#</appKey>
                            <appSecret>#wsInfo.passwd#</appSecret>
                        </auth>
                        <pagingData>
                            <currentPage>#page#</currentPage>
                            <pageSize>#pageSize#</pageSize>
                        </pagingData>
                    </sch:GetProductListRequest>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfsavecontent></cfoutput>

            <cfhttp url="#wsInfo.address#/ws/ProductService.wsdl" method = "post" result = "res">
                <cfhttpparam type="header" name="content-type" value="text/xml" />
                <cfhttpparam type="header" name="content-length" value="#Len(getProductListContent)#" />
                <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                <cfhttpparam type="header" name="charset" value="utf-8" />
                <cfhttpparam type="xml" value="#Trim(getProductListContent)#" />
            </cfhttp>

            <cfscript>
                getProductList_log_request = getProductListContent;
                getProductList_log_status_code = res.Statuscode;
                getProductList_log_response = res.FileContent;

                productArray = xmlParse(res.FileContent).Envelope.Body.GetProductListResponse.products.XmlChildren;
            </cfscript>

            <cfif arrayLen(productArray) gt 0>
                <cfloop from="1" to="#arrayLen(productArray)#" index="p">
                    <cfscript>
                        realStock       = DataStore.getMaterialStock(material_id=productArray[p].stockItems.stockItem[1].sellerStockCode.XmlText);
                        price           = DataStore.getPrice(code=productArray[p].stockItems.stockItem[1].sellerStockCode.XmlText,price_list=variables.partner);
                        
                        storeListPrice  = productArray[p].stockItems.stockItem[1].currencyAmount.XmlText;
                        storeSalesPrice = productArray[p].stockItems.stockItem[1].displayPrice.XmlText;
                        storeStockAmount= productArray[p].stockItems.stockItem[1].quantity.XmlText;

                        localListPrice  = price.list_price;
                        localSalesPrice = price.sales_price;
                        localStockAmount= realStock;
                    </cfscript>

                    <cfif price.recordcount and (storeListPrice neq localListPrice or storeSalesPrice neq localSalesPrice or storeStockAmount neq localStockAmount)>
                        <cfscript>
                            productInfo         = ContentServer.getProductInfo(productArray[p].stockItems.stockItem[1].sellerStockCode.XmlText);
                            getProduct          = DataStore.getProduct(code=productArray[p].stockItems.stockItem[1].sellerStockCode.XmlText);
                            storeProductCatID   = DataStore.getData(table = "PRODUCT_CATEGORY", args = {CAT_CODE = getProduct.mal_grubu, PARTNER = variables.partner}).PARTNER_CAT_ID;
                            product_en_base     = getProduct.EN_BASE_UNIT / 10;
                            product_boy_base    = getProduct.BOY_BASE_UNIT / 10;
                            /* HATA YÖNETİMİ */
                        </cfscript>

                        <cfoutput><cfsavecontent variable="updateProductContent">
                            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
                                <soapenv:Header/>
                                <soapenv:Body>
                                    <sch:SaveProductRequest>
                                    <auth>
                                        <appKey>#wsInfo.user_name#</appKey>
                                        <appSecret>#wsInfo.passwd#</appSecret>
                                    </auth>
                                    <product>
                                        <productSellerCode>#productArray[p].stockItems.stockItem[1].sellerStockCode.XmlText#</productSellerCode>
                                        <title>#getProduct.product_name#</title>
                                        <subtitle>#getProduct.product_name#</subtitle>
                                        <description><![CDATA[#productInfo.product.description#]]></description> 
                                        <category>
                                            <id>#storeProductCatID#</id>
                                        </category>
                                        <specialProductInfoList/>
                                        <price>#localListPrice#</price>
                                        <currencyType>1</currencyType>
                                        <domestic>true</domestic>
                                        <images>
                                            <cfloop from = "1" to = "#arrayLen(productInfo.product.images)#" index = "img">
                                                <image>
                                                    <url>#productInfo.product.images[img].image_path#</url>
                                                    <order>#img#</order>
                                                </image>
                                            </cfloop>
                                        </images>
                                        <approvalStatus>2</approvalStatus>
                                        <attributes>
                                            <attribute>
                                               <name>Marka</name>
                                               <value>#variables.brand_name#</value>
                                            </attribute>
                                            <attribute>
                                               <name>Ölçüler</name>
                                               <value>#product_en_base#X#product_boy_base#</value>
                                            </attribute>
                                         </attributes>
                                        <saleStartDate></saleStartDate>
                                        <saleEndDate></saleEndDate>
                                        <productionDate></productionDate>
                                        <expirationDate/>
                                        <productCondition>1</productCondition>
                                        <preparingDay>2</preparingDay>
                                        <discount>
                                            <type>3</type>
                                            <value>#localSalesPrice#</value>
                                        </discount>
                                        <shipmentTemplate>#variables.shipmentTemplate#</shipmentTemplate>
                                        <stockItems>
                                            <stockItem>
                                                <bundle/>
                                                <mpn/>
                                                <gtin>#getProduct.ean_no#</gtin>
                                                <oem></oem>
                                                <quantity>#localStockAmount#</quantity>
                                                <sellerStockCode>#getProduct.product_code#</sellerStockCode>
                                                <attributes/>
                                                <optionPrice/>
                                            </stockItem>
                                        </stockItems>
                                    </product>
                                    </sch:SaveProductRequest>
                                </soapenv:Body>
                            </soapenv:Envelope> 
                        </cfsavecontent></cfoutput>

                        <cfscript>
                            updProduct_service_log_id   = DataStore.serviceLog(partner=variables.partner, logger='updatePriceAndInventory');
                            updProduct_log_is_success   = 1;
                            updProduct_log_request      = '';
                            updProduct_log_response     = '';
                            updProduct_log_status_code  = '';
                            updProduct_log_message      = '';
                        </cfscript>

                        <cfhttp  url="#wsInfo.address#/ws/ProductService.wsdl" method="post" result="res">
                            <cfhttpparam type="header" name="content-type" value="text/xml" />
                            <cfhttpparam type="header" name="content-length" value="#Len(updateProductContent)#" />
                            <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                            <cfhttpparam type="header" name="charset" value="utf-8" />
                            <cfhttpparam type="xml" value="#Trim(updateProductContent)#" />
                        </cfhttp>

                        <cfscript>
                            response = xmlParse(res.FileContent).Envelope.Body.SaveProductResponse;

                            if(isDefined('response.result.status') and response.result.status.XmlText eq 'failure') {
                                updProduct_log_message = response.result.errorMessage.XmlText;
                                updProduct_log_is_success= 0;
                            } else {
                                updProduct_log_message     = 'Ürün bilgileri güncellendi.';
                                updProduct_log_is_success= 1;
                            }

                            updProduct_log_request = getProductListContent;
                            updProduct_log_status_code = res.Statuscode;
                            updProduct_log_response = res.FileContent;

                            DataStore.serviceLog(
                                log_id=updProduct_service_log_id,
                                is_success=updProduct_log_is_success,
                                request=updProduct_log_request,
                                response=updProduct_log_response,
                                status_code=updProduct_log_status_code,
                                message = updProduct_log_message
                            );
                        </cfscript>
                    </cfif>
                </cfloop>
            </cfif>

            <cfscript>
                DataStore.serviceLog(
                    log_id=getProductList_service_log_id,
                    is_success=getProductList_log_is_success,
                    request=getProductList_log_request,
                    response=getProductList_log_response,
                    status_code=getProductList_log_status_code
                );

                productsInPage  = arrayLen(productArray);
                page            = page + 1;
            </cfscript>
        </cfloop>
    </cffunction>

    <cffunction name="orders" access="public" returntype="void" output="false" hint="">

        <cfscript>
            wsInfo      = DataStore.getData(table="SETUP_INTEGRATIONS", id=12);
            page        = 0;
            pageSize    = 100;
            ordersInPage= pageSize;
        </cfscript>

        <cfloop condition="ordersInPage eq pageSize">
            <cfscript>
                getOrderList_service_log_id = DataStore.serviceLog(partner=variables.partner, logger='orders');
                getOrderList_log_is_success = 1;
                getOrderList_log_request    = '';
                getOrderList_log_response   = '';
                getOrderList_log_status_code= '';
                getOrderList_log_message    = '';
            </cfscript>

            <cfoutput><cfsavecontent variable="getOrderListContent">
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
                <soapenv:Header/>
                <soapenv:Body>
                    <sch:OrderListRequest>
                        <auth>
                            <appKey>#wsInfo.user_name#</appKey>
                            <appSecret>#wsInfo.passwd#</appSecret>
                        </auth>
                        <searchData></searchData>
                        <pagingData>
                            <currentPage>#page#</currentPage>
                            <pageSize>#pageSize#</pageSize>
                        </pagingData>
                    </sch:OrderListRequest>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfsavecontent></cfoutput>

            <cfhttp url="#wsInfo.address#/ws/OrderService.wsdl" method="post" result="res">
                <cfhttpparam type="header" name="content-type" value="text/xml" />
                <cfhttpparam type="header" name="content-length" value="#Len(getOrderListContent)#" />
                <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                <cfhttpparam type="header" name="charset" value="utf-8" />
                <cfhttpparam type="xml" value="#Trim(getOrderListContent)#" />
            </cfhttp>

            <cfscript>
                getOrderList_log_request    = getOrderListContent;
                getOrderList_log_status_code= res.Statuscode;
                getOrderList_log_response   = res.FileContent;
                orderArray                  = xmlParse(res.FileContent).Envelope.Body.OrderListResponse.orderList.XmlChildren;
            </cfscript>

            <cfif arrayLen(orderArray) gt 0>
                <cfloop from="1" to="#arrayLen(orderArray)#" index="i">
                    <cfscript>
                        orderIndex = orderArray[i];
                        orderArgs = structNew();
                        orderArgs.PARTNER = variables.partner;
                        orderArgs.REF_ORDER_ID = orderIndex.id.XmlText;

                        checkOrder = DataStore.getData(table="ORDERS", args=orderArgs);

                        switch(orderIndex.status.XmlText) {
                            case '1':
                                orderDetail.REF_STATUS_NAME = 'Created';
                            break;
                            case '2':
                                orderDetail.REF_STATUS_NAME = 'Created';
                            break;
                            case '3':
                                orderDetail.REF_STATUS_NAME = 'Cancelled';
                            break;
                            case '4':
                                orderDetail.REF_STATUS_NAME = 'Cancelled';
                            break;
                            case '5':
                                orderDetail.REF_STATUS_NAME = 'ReadyToShip';
                            break;
                            case '6':
                                orderDetail.REF_STATUS_NAME = 'Shipped';
                            break;
                            case '7':
                                orderDetail.REF_STATUS_NAME = 'Delivered';
                            break;
                            case '8':
                                orderDetail.REF_STATUS_NAME = 'Cancelled';
                            break;
                            case '9':
                                orderDetail.REF_STATUS_NAME = 'ReturnDelivered';
                            break;
                            case '10':
                                orderDetail.REF_STATUS_NAME = 'Delivered';
                            break;
                            case '11':
                                orderDetail.REF_STATUS_NAME = 'ReturnAccepted';
                            break;
                            case '12':
                                orderDetail.REF_STATUS_NAME = 'ReturnDelivered';
                            break;
                            case '13':
                                orderDetail.REF_STATUS_NAME = 'ReturnShipped';
                            break;
                            case '14':
                                orderDetail.REF_STATUS_NAME = 'ReadyToShip';
                            break;
                            case '15':
                                orderDetail.REF_STATUS_NAME = 'ReadyToShip';
                            break;
                            case '16':
                                orderDetail.REF_STATUS_NAME = 'ReturnDelivered';
                            break;
                            case '17':
                                orderDetail.REF_STATUS_NAME = 'ReturnAccepted';
                            break;
                        }
                    </cfscript>

                    <cfif not checkOrder.recordcount> <!--- yeni sipariş, ekliyoruz --->
                        <cfscript>
                            getOrderDetail_service_log_id   = DataStore.serviceLog(partner=variables.partner, logger='orders:orderDetail');
                            getOrderDetail_log_is_success   = 1;
                            getOrderDetail_log_request      = '';
                            getOrderDetail_log_response     = '';
                            getOrderDetail_log_status_code  = '';
                            getOrderDetail_log_message      = '';
                        </cfscript>
                        <cfoutput><cfsavecontent variable="getOrderDetailContent">
                            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
                            <soapenv:Header/>
                            <soapenv:Body>
                                <sch:OrderDetailRequest>
                                    <auth>
                                        <appKey>#wsInfo.user_name#</appKey>
                                        <appSecret>#wsInfo.passwd#</appSecret>
                                    </auth>
                                    <orderRequest>
                                        <id>#orderIndex.id.XmlText#</id>
                                    </orderRequest>
                                </sch:OrderDetailRequest>
                            </soapenv:Body>
                            </soapenv:Envelope>
                        </cfsavecontent></cfoutput>

                        <cfhttp url="#wsInfo.address#/ws/OrderService.wsdl" method="post" result="res">
                            <cfhttpparam type="header" name="content-type" value="text/xml" />
                            <cfhttpparam type="header" name="content-length" value="#Len(getOrderDetailContent)#" />
                            <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                            <cfhttpparam type="header" name="charset" value="utf-8" />
                            <cfhttpparam type="xml" value="#Trim(getOrderDetailContent)#" />
                        </cfhttp>

                        <cfscript>
                            getOrderDetail_log_request      = getOrderDetailContent;
                            getOrderDetail_log_status_code  = res.Statuscode;
                            getOrderDetail_log_response     = res.FileContent;
                        </cfscript>

                        <cfscript>
                            order = XmlParse(res.Filecontent).Envelope.Body.OrderDetailResponse.orderDetail;

                            switch(orderIndex.status.XmlText) {
                                case '1':
                                    orderDetail.REF_STATUS_NAME = 'Created';
                                break;
                                case '2':
                                    orderDetail.REF_STATUS_NAME = 'ReadyToShip';
                                break;
                                case '3':
                                    orderDetail.REF_STATUS_NAME = 'Cancelled';
                                break;
                                case '4':
                                    orderDetail.REF_STATUS_NAME = 'Cancelled';
                                break;
                                case '5':
                                    orderDetail.REF_STATUS_NAME = 'Delivered';
                                break;
                            }

                            orderDetail.PARTNER                     = variables.partner;
                            orderDetail.REF_ORDER_ID                = order.id.XmlText;
                            orderDetail.REF_ORDER_NUMBER            = order.orderNumber.XmlText;
                            orderDate                               = listFirst(order.createDate.XmlText,' ');
                            orderTime                               = listLast(order.createDate.XmlText,' ');
                            orderDetail.REF_ORDER_DATE              = '#listGetAt(orderDate,3,'/')#-#listGetAt(orderDate,2,'/')#-#listGetAt(orderDate,1,'/')# #orderTime#:00';
                            orderDetail.REF_CURRENCY_CODE           = 'TRY';
                            orderDetail.REF_CUSTOMER_ID             = order.buyer.id.XmlText;
                            orderDetail.REF_CUSTOMER_FIRST_NAME     = listDeleteAt(order.billingAddress.fullName.XmlText, listLen(order.billingAddress.fullName.XmlText,' '), ' ');
                            orderDetail.REF_CUSTOMER_LAST_NAME      = listLast(order.billingAddress.fullName.XmlText,' ');
                            orderDetail.REF_CUSTOMER_EMAIL          = order.buyer.email.XmlText;
                            orderDetail.REF_TC_IDENTITY_NUMBER      = order.buyer.tcId.XmlText;
                            orderDetail.REF_TOTAL_PRICE             = order.billingTemplate.sellerInvoiceAmount.XmlText - order.billingTemplate.installmentChargeWithVat.XmlText;
                            orderDetail.REF_INSTALLMENT_CHARGE      = order.billingTemplate.installmentChargeWithVat.XmlText;
                            orderDetail.REF_INVOICE_ID              = '';
                            orderDetail.REF_INVOICE_COMPANY         = ''
                            orderDetail.REF_INVOICE_FIRST_NAME      = listDeleteAt(order.billingAddress.fullName.XmlText, listLen(order.billingAddress.fullName.XmlText,' '), ' ');
                            orderDetail.REF_INVOICE_LAST_NAME       = listLast(order.billingAddress.fullName.XmlText,' ');
                            orderDetail.REF_INVOICE_FULL_NAME       = order.billingAddress.fullName.XmlText;
                            orderDetail.REF_INVOICE_ADDRESS_1       = order.billingAddress.address.XmlText;
                            orderDetail.REF_INVOICE_ADDRESS_2       = '';
                            orderDetail.REF_INVOICE_DISTRICT        = order.billingAddress.district.XmlText;
                            orderDetail.REF_INVOICE_CITY            = order.billingAddress.city.XmlText;
                            orderDetail.REF_INVOICE_COUNTRY         = 'Türkiye';
                            orderDetail.REF_INVOICE_FULL_ADDRESS    = order.billingAddress.address.XmlText & ' ' & order.billingAddress.district.XmlText & ' ' & order.billingAddress.city.XmlText & ' Türkiye';
                            orderDetail.REF_INVOICE_PHONE           = order.billingAddress.gsm.XmlText;
                            orderDetail.REF_SHIPMENT_ID             = '';
                            orderDetail.REF_SHIPMENT_FIRST_NAME     = listDeleteAt(order.shippingAddress.fullName.XmlText, listLen(order.shippingAddress.fullName.XmlText,' '), ' ');
                            orderDetail.REF_SHIPMENT_LAST_NAME      = listLast(order.shippingAddress.fullName.XmlText,' ');
                            orderDetail.REF_SHIPMENT_FULL_NAME      = order.shippingAddress.fullName.XmlText;
                            orderDetail.REF_SHIPMENT_ADDRESS_1      = order.shippingAddress.address.XmlText;
                            orderDetail.REF_SHIPMENT_ADDRESS_2      = '';
                            orderDetail.REF_SHIPMENT_DISTRICT_ID    = order.shippingAddress.district.XmlText;
                            orderDetail.REF_SHIPMENT_DISTRICT_NAME  = order.shippingAddress.district.XmlText;
                            orderDetail.REF_SHIPMENT_CITY_ID        = order.shippingAddress.city.XmlText;
                            orderDetail.REF_SHIPMENT_CITY_NAME      = order.shippingAddress.city.XmlText;
                            orderDetail.REF_SHIPMENT_COUNTRY        = 'Türkiye';
                            if (structKeyExists(order.shippingAddress,'postalCode')) {
                                orderDetail.REF_SHIPMENT_POSTAL_CODE= order.shippingAddress.postalCode.XmlText;
                            }
                            orderDetail.REF_SHIPMENT_FULL_ADDRESS   = order.shippingAddress.address.XmlText & ' ' & order.shippingAddress.district.XmlText & ' ' & order.shippingAddress.city.XmlText & ' Türkiye';

                            ORDER_ID[i] = DataStore.addOrder(args=orderDetail);

                            orderRows.rows = structNew();
                            orderRows.rows[i] = structNew();

                            for(j = 1; j lte arrayLen(order.itemList.XmlChildren); j++ ) {
                                orderItem = order.itemList.XmlChildren[j];

                                switch(orderItem.status.XmlText) {
                                    case '1':
                                        orderRows.rows[i].REF_STATUS_NAME = 'Created';
                                    break;
                                    case '2':
                                        orderRows.rows[i].REF_STATUS_NAME = 'Created';
                                    break;
                                    case '3':
                                        orderRows.rows[i].REF_STATUS_NAME = 'Cancelled';
                                    break;
                                    case '4':
                                        orderRows.rows[i].REF_STATUS_NAME = 'Cancelled';
                                    break;
                                    case '5':
                                        orderRows.rows[i].REF_STATUS_NAME = 'ReadyToShip';
                                    break;
                                    case '6':
                                        orderRows.rows[i].REF_STATUS_NAME = 'Shipped';
                                    break;
                                    case '7':
                                        orderRows.rows[i].REF_STATUS_NAME = 'Delivered';
                                    break;
                                    case '8':
                                        orderRows.rows[i].REF_STATUS_NAME = 'Cancelled';
                                    break;
                                    case '9':
                                        orderRows.rows[i].REF_STATUS_NAME = 'ReturnDelivered';
                                    break;
                                    case '10':
                                        orderRows.rows[i].REF_STATUS_NAME = 'Delivered';
                                    break;
                                    case '11':
                                        orderRows.rows[i].REF_STATUS_NAME = 'ReturnAccepted';
                                    break;
                                    case '12':
                                        orderRows.rows[i].REF_STATUS_NAME = 'ReturnDelivered';
                                    break;
                                    case '13':
                                        orderRows.rows[i].REF_STATUS_NAME = 'ReturnShipped';
                                    break;
                                    case '14':
                                        orderRows.rows[i].REF_STATUS_NAME = 'ReadyToShip';
                                    break;
                                    case '15':
                                        orderRows.rows[i].REF_STATUS_NAME = 'ReadyToShip';
                                    break;
                                    case '16':
                                        orderRows.rows[i].REF_STATUS_NAME = 'ReturnDelivered';
                                    break;
                                    case '17':
                                        orderRows.rows[i].REF_STATUS_NAME = 'ReturnAccepted';
                                    break;
                                }

                                orderRows.rows[i].ROW_NUMBER                = j;
                                orderRows.rows[i].ORDER_ID                  = ORDER_ID[i];
                                orderRows.rows[i].REF_ORDER_ID              = order.id.XmlText;
                                orderRows.rows[i].REF_ORDER_NUMBER          = order.orderNumber.XmlText;
                                orderRows.rows[i].REF_ORDER_ROW_ID          = orderItem.id.XmlText;
                                orderRows.rows[i].REF_PRODUCT_ID            = orderItem.productId.XmlText;
                                orderRows.rows[i].REF_PRODUCT_NAME          = orderItem.productName.XmlText;
                                orderRows.rows[i].REF_PRODUCT_CODE          = orderItem.productSellerCode.XmlText;
                                orderRows.rows[i].REF_PRODUCT_COLOR         = '';
                                orderRows.rows[i].REF_PRODUCT_SIZE          = '';
                                orderRows.rows[i].REF_BARCODE               = orderItem.productSellerCode.XmlText;
                                orderRows.rows[i].REF_STOCK_CODE            = orderItem.productSellerCode.XmlText;
                                orderRows.rows[i].REF_MERCHANT_ID           = '';
                                orderRows.rows[i].REF_MERCHANT_STOCK_CODE   = orderItem.productSellerCode.XmlText;
                                orderRows.rows[i].REF_QUANTITY              = orderItem.quantity.XmlText;
                                orderRows.rows[i].REF_PRICE                 = orderItem.sellerInvoiceAmount.XmlText;
                                orderRows.rows[i].REF_TOTAL_PRICE           = orderRows.rows[i].REF_PRICE * orderItem.quantity.XmlText;
                                orderRows.rows[i].REF_VAT_BASE_AMOUNT       = 0;
                                orderRows.rows[i].REF_SALES_CAMPAIGN_ID     = '';

                                DataStore.addOrderRow(args=orderRows.rows[i]);

                                orderDetail.REF_CARGO_TRACKING_NUMBER       = orderItem.shipmentInfo.campaignNumber.XmlText;
                                DataStore.updateOrder(
                                    order_id=ORDER_ID[i],
                                    ref_cargo_tracking_number=orderDetail.REF_CARGO_TRACKING_NUMBER
                                );
                            }

                            DataStore.serviceLog(
                                log_id=getOrderDetail_service_log_id,
                                is_success=getOrderDetail_log_is_success,
                                request=getOrderDetail_log_request,
                                response=getOrderDetail_log_response,
                                status_code=getOrderDetail_log_status_code
                            );
                        </cfscript>
                    <cfelse> <!--- mevcut sipariş, güncelliyoruz --->
                        <cfscript>
                            if(checkOrder.REF_STATUS_NAME Neq orderDetail.REF_STATUS_NAME){
                                // sadece sipariş aşamasıyla ilgili güncelleme var.
                                DataStore.updateOrder(
                                    order_id=checkOrder.ORDER_ID,
                                    ref_status_name=orderDetail.REF_STATUS_NAME
                                );
                            }
                        </cfscript>
                    </cfif>
                </cfloop>
            </cfif>

            <cfscript>
                DataStore.serviceLog(
                    log_id=getOrderList_service_log_id,
                    is_success=getOrderList_log_is_success,
                    request=getOrderList_log_request,
                    response=getOrderList_log_response,
                    status_code=getOrderList_log_status_code
                );

                ordersInPage = arrayLen(orderArray);
                page = page + 1;
            </cfscript>
        </cfloop>
    </cffunction>

    <cffunction name="updatePackage" access="public" returntype="void" output="false" hint="">
        <cfscript>
            args            = structNew();
            args.STATUS     = 1;
            args.REF_SYSTEM = 'SAP';
            args.TAR_SYSTEM = variables.partner;

            getOrderChanges = DataStore.getData(table="ORDER_CHANGES",args=args);

            wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=12);
        </cfscript>

        <cfif getOrderChanges.recordcount>
            <cfloop from="1" to="#getOrderChanges.recordcount#" index="i">
                <cfscript>
                    log_is_success  = 1;
                    log_request     = '';
                    log_response    = '';
                    log_status_code = '';
                    log_message     = '';
                    service_log_id  = DataStore.serviceLog(partner=variables.partner, logger='updatePackage');

                    //siparişte yapacağımız değişiklikleri orderDetail struct'ında yapıyoruz.
                    switch(getOrderChanges.status_name[i]) {
                        case 'ACK':
                            orderDetail.status = 'Created';
                        break;
                        case 'SVK':
                            orderDetail.status = 'ReadyToShip';
                        break;
                        case 'IPTL':
                            orderDetail.status = 'Cancelled';
                        break;
                        case 'FTR':
                            orderDetail.status = 'Shipped';
                        break;
                    }
                </cfscript>

                <cfoutput><cfsavecontent variable="getOrderDetailContent">
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <sch:OrderDetailRequest>
                            <auth>
                                <appKey>#wsInfo.user_name#</appKey>
                                <appSecret>#wsInfo.passwd#</appSecret>
                            </auth>
                            <orderRequest>
                                <id>#getOrderChanges.ref_order_id[i]#</id>
                            </orderRequest>
                        </sch:OrderDetailRequest>
                    </soapenv:Body>
                    </soapenv:Envelope>
                </cfsavecontent></cfoutput>

                <cfhttp url="#wsInfo.address#/ws/OrderService.wsdl" method="post" result="res">
                    <cfhttpparam type="header" name="content-type" value="text/xml" />
                    <cfhttpparam type="header" name="content-length" value="#Len(getOrderDetailContent)#" />
                    <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                    <cfhttpparam type="header" name="charset" value="utf-8" />
                    <cfhttpparam type="xml" value="#Trim(getOrderDetailContent)#" />
                </cfhttp>

                <cfscript>
                    log_is_success  = 1;
                    log_request     = '#wsInfo.address#/api/orders/#getOrderChanges.order_id[i]#';
                    log_response    = res.FileContent;
                    log_status_code = res.StatusCode;
                    
                    DataStore.serviceLog(
                        log_id=service_log_id,
                        is_success=log_is_success,
                        request=log_request,
                        response=log_response,
                        status_code=log_status_code
                    );
                </cfscript>
            </cfloop>
        </cfif>
    </cffunction>

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

    <cffunction name="getTopLevelCategories" access="public" returntype="void" output="false" hint="N11 kategori servisinden zorunlu olan kategori özelliklerini alır">
        <cfscript>
            wsInfo=DataStore.getData(table="SETUP_INTEGRATIONS",id=variables.integration_id)
            log_is_success  = 1;
            log_request     = '';
            log_response    = '';
            log_status_code = '';
            log_message     = '';
            service_log_id  = DataStore.serviceLog(partner=variables.partner, logger='getTopLevelCategories');
        </cfscript>

        <cfoutput>
            <cfsavecontent variable="getProductCategorys_Request">
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
                    <soapenv:Header/>
                        <soapenv:Body>
                            <sch:GetTopLevelCategoriesRequest>
                                <auth>
                                    <appKey>#wsInfo.user_name#</appKey>
                                    <appSecret>#wsInfo.passwd#</appSecret>
                                </auth>
                            </sch:GetTopLevelCategoriesRequest>
                        </soapenv:Body>
                </soapenv:Envelope>
            </cfsavecontent>
        </cfoutput>

        <cfhttp url="#wsInfo.address#/ws/categoryService.wsdl" method="post" result="getProductCategorys_Result">
            <cfhttpparam type="header" name="content-type" value="text/xml" />
            <cfhttpparam type="header" name="content-length" value="#Len(getProductCategorys_Request)#" />
            <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
            <cfhttpparam type="header" name="charset" value="utf-8" />
            <cfhttpparam type="xml" value="#Trim(getProductCategorys_Request)#" />
        </cfhttp>

        <cfset log_request     = getProductCategorys_Request />
        <cfset log_status_code = getProductCategorys_Result.StatusCode />
        <cfif (Not Len(getProductCategorys_Result.ErrorDetail))>
            <cfset getProductCategorys_Response = xmlParse(getProductCategorys_Result.FileContent).Envelope.Body.GetTopLevelCategoriesResponse.categoryList.XmlChildren />
            <cfloop from="1" to="#arrayLen(getProductCategorys_Response)#" index="i">
                <cfoutput>
                <cfset category[i]                        = structNew('ordered') />
                <cfset category[i].PARTNER                = variables.partner  />
                <cfset category[i].PARTNER_CAT_ID         = getProductCategorys_Response[i].XmlChildren[1].XmlText />
                <cfset category[i].PARTNER_CATEGORY_NAME  = getProductCategorys_Response[i].XmlChildren[2].XmlText />
                <cfset category[i].PARTNER_PARENT_CAT_ID  = "" />

                <cfset product_Args                       =structNew('ordered') />
                <cfset product_Args.PARTNER               =variables.partner />
                <cfset product_Args.PARTNER_CAT_ID        =category[i].PARTNER_CAT_ID />
                <cfset product_categoryDetail = DataStore.getData(table="PRODUCT_CATEGORY", args=product_Args) />
                <cfif product_categoryDetail.recordcount eq 0 >
                       <cfset product_categoryArgsDetail = DataStore.addData(table="PRODUCT_CATEGORY", args=category[i],identity_name='CAT_ID') />
                </cfif> 
                <cfscript>
                    subCategories(id=category[i].PARTNER_CAT_ID);
                </cfscript>
                </cfoutput>
            </cfloop>
            <cfset log_is_success  = 1 />
            <cfset log_response    = getProductCategorys_Result.FileContent />
        <cfelse>
            <cfset log_is_success  = 0 />
            <cfset log_response    = getProductCategorys_Result.ErrorDetail />
        </cfif>
            <cfscript>
            DataStore.serviceLog(
                log_id=service_log_id,
                is_success=log_is_success,
                request=log_request,
                response=log_response,
                status_code=log_status_code,
                message=log_message
            );
            </cfscript>
            <cfabort/>
    </cffunction>

    <cffunction name="orderStatus" access="public" returntype="void" output="false" hint="Sipariş N11 ID bilgisi kullanarak sipariş detaylarını almak için kullanılır, sipariş N11 ID bilgisine OrderService OrderList veya DetailedOrderList metotlarıyla ulaşılabilir. Octopustaki siparişlerin durumunu güncellemek için kullanıyoruz.">
        <cfscript>
            orderStatus_args            = structNew();
            orderStatus_args.PARTNER    = variables.partner;
            orderStatus_wsInfo          = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
        </cfscript>

        <cfoutput><cfsavecontent variable="orderStatus_Request"><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
            <soapenv:Header/>
            <soapenv:Body>
                <sch:OrderDetailRequest>
                    <auth>
                        <appKey>#orderStatus_wsInfo.user_name#</appKey>
                        <appSecret>#orderStatus_wsInfo.passwd#</appSecret>
                    </auth>
                    <orderRequest>
                        <id>207725554</id>
                    </orderRequest>
                </sch:OrderDetailRequest>
            </soapenv:Body>
            </soapenv:Envelope></cfsavecontent>
        </cfoutput>
    </cffunction>
    
    <cffunction name="makeOrderItemShipment" access="public" returntype="void" output="false" hint="Sipariş maddesinin n11 ID si kullanılarak kargoya verilmesi için kullanılır. Sipariş n11 ID sine OrderService içinden OrderDetail veya DetailedOrderList metodu kullanılarak erişilir. Ön koşul olarak güncelleme yapılmak istenen sipariş maddesinin durumunun (OrderItemStatus) “Ödendi” veya “Kabul edildi” olması gerekmektedir. Aksi durumda “ön koşullar sağlanamadı” cevabı alınır.">
        <cfscript>
            makeOrderItemShipment_args              = structNew();
            makeOrderItemShipment_args.STATUS       = 1;
            makeOrderItemShipment_args.REF_SYSTEM   = 'SAP';
            makeOrderItemShipment_args.TAR_SYSTEM   = variables.partner;
            makeOrderItemShipment_getOrderChanges   = DataStore.getOrderChanges(status_name="Invoiced", args=makeOrderItemShipment_args);
        </cfscript>
    
        <cfif makeOrderItemShipment_getOrderChanges.RecordCount>
        <cfloop query="makeOrderItemShipment_getOrderChanges">
            <cfscript>
                makeOrderItemShipment_log_is_success    = 1;
                makeOrderItemShipment_log_request       = '';
                makeOrderItemShipment_log_response      = '';
                makeOrderItemShipment_log_status_code   = '';
                makeOrderItemShipment_log_message       = '';
                makeOrderItemShipment_service_log_id    = DataStore.serviceLog(partner=variables.partner, logger='makeOrderItemShipment');
                makeOrderItemShipment_wsInfo = DataStore.getData(table="SETUP_INTEGRATIONS", id=variables.integration_id);
                makeOrderItemShipment_order_args        = structNew();
                makeOrderItemShipment_order_args.ORDER_ID = ORDER_ID;
                makeOrderItemShipment_order             = DataStore.getData(table="ORDERS", args=makeOrderItemShipment_order_args);
            </cfscript>
    
            <cfsavecontent variable="makeOrderItemShipment_Request"><cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.n11.com/ws/schemas">
                <soapenv:Header/>
                <soapenv:Body>
                   <sch:MakeOrderItemShipmentRequest>
                    <auth>
                        <appKey>#makeOrderItemShipment_wsInfo.user_name#</appKey>
                        <appSecret>#makeOrderItemShipment_wsInfo.passwd#</appSecret>
                    </auth>
                      <orderItemList>
                         <orderItem>
                            <id>#REF_ORDER_ROW_ID#</id>
                            <shipmentInfo>
                               <shipmentCompany>
                                  <id>#variables.shipmentCompany#</id>
                               </shipmentCompany>
                               <trackingNumber>#makeOrderItemShipment_order.TAR_ORDER_ID#</trackingNumber>
                               <shipmentMethod>1</shipmentMethod>
                            </shipmentInfo>
                         </orderItem>
                      </orderItemList>
                   </sch:MakeOrderItemShipmentRequest>
                </soapenv:Body>
             </soapenv:Envelope>
             </cfoutput>
            </cfsavecontent>

            <cfhttp url="#makeOrderItemShipment_wsInfo.address#/ws/OrderService.wsdl" method="post" result="makeOrderItemShipment_Result">
                <cfhttpparam type="header" name="content-type" value="text/xml" />
                <cfhttpparam type="header" name="content-length" value="#Len(makeOrderItemShipment_Request)#" />
                <cfhttpparam type="header" name="accept-encoding" value="gzip,deflate" />
                <cfhttpparam type="header" name="charset" value="utf-8" />
                <cfhttpparam type="xml" value="#Trim(makeOrderItemShipment_Request)#" />
            </cfhttp>
    
            <cfscript>
                makeOrderItemShipment_log_request       = makeOrderItemShipment_Request;
                makeOrderItemShipment_log_response      = makeOrderItemShipment_Result.FileContent;
                makeOrderItemShipment_log_status_code   = makeOrderItemShipment_Result.StatusCode;

                makeOrderItemShipment_response          = xmlParse(makeOrderItemShipment_Result.FileContent).Envelope.Body.MakeOrderItemShipmentResponse.result;

                if(makeOrderItemShipment_response.status.xmlText Eq 'success'){
                    DataStore.updateProductChanges(cId=ID);
                    makeOrderItemShipment_log_is_success    = 1;
                    makeOrderItemShipment_log_message       = makeOrderItemShipment_response.errorMessage.xmlText;
                }
                else {
                    makeOrderItemShipment_log_is_success    = 0;
                    makeOrderItemShipment_log_message       = makeOrderItemShipment_Result.ErrorDetail;
                    log_message	= variables.partner & " sistemine sipariş sevk bilgisi gönderilemedi.";
                    log_detail  = makeOrderItemShipment_log_message;
                    BugLog.notifyService(message=log_message, extraInfo=log_detail);
                }

                DataStore.serviceLog(
                    log_id		= makeOrderItemShipment_service_log_id,
                    is_success	= makeOrderItemShipment_log_is_success,
                    request		= makeOrderItemShipment_log_request,
                    response	= makeOrderItemShipment_log_response,
                    status_code	= makeOrderItemShipment_log_status_code,
					message		= makeOrderItemShipment_log_message
                );
            </cfscript>
        </cfloop>
        </cfif>
    </cffunction>

    <!----------------------------------- PRIVATE METHODS --------------------------------------->

</cfcomponent>