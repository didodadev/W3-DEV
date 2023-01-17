<cfdump var="#attributes#">
	<cfquery name="GET_PERIOD" datasource="#dsn#">
		SELECT PERIOD_ID FROM SETUP_PERIOD
		WHERE
			PERIOD_YEAR = DATEPART(year, GETDATE())
			AND
			OUR_COMPANY_ID = 1
	</cfquery>
	<cfquery name="GET_PRODUCT" datasource="#dsn#">
		SELECT
			S.PRODUCT_ID,
			S.PRODUCT_DETAIL2,
			(SELECT COUNT(P_IC.PRODUCT_ID) FROM #dsn#_#Year(now())#_1.GET_STOCK_LAST P_IC WHERE P_IC.PRODUCT_ID = P_DIS.PRODUCT_ID) AS STOCK_COUNT,
			P_DIS.PRODUCT_CATID,
			S.PRODUCT_NAME,
			S.BRAND_ID,
			PS.PRICE AS SF_SATIS,
			PS.PRICE_KDV AS SF_SATIS_KDV,
			(PS.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #GET_PERIOD.PERIOD_ID#)) AS SF_SATIS_KDV_TL,
			(PS.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #GET_PERIOD.PERIOD_ID#)) AS SF_SATIS_TL,
			PS.MONEY AS SF_MONEY,
			S.STOCK_ID,
			S.PRODUCT_CODE,
			PC.HIERARCHY,
			PC.IMAGE_CAT
		FROM
			#dsn3_alias#.PRODUCT_CAT PC,
			#dsn3_alias#.PRICE_STANDART PS,
			#dsn3_alias#.STOCKS S,
			#dsn1_alias#.PRODUCT P_DIS
		WHERE
			P_DIS.PRODUCT_ID = S.PRODUCT_ID AND
			PS.PRODUCT_ID = S.PRODUCT_ID AND
			P_DIS.PRODUCT_ID IN(#attributes.PRODUCT_ID_LIST#) AND
			PS.PRICESTANDART_STATUS = 1 AND
			PS.PURCHASESALES = 1 AND
			S.PRODUCT_CATID = PC.PRODUCT_CATID AND
			P_DIS.IS_INTERNET = 1 AND
			P_DIS.PRODUCT_STATUS = 1 AND
			PS.PRICE > 0
	</cfquery>
	<cfquery name="MP_SETTS" datasource="#dsn#">
		SELECT
			MARKET_PLACE_ID,
			MARKET_PLACE,
			API_KEY,
			SECRET_KEY,
			ROLE_NAME,
			ROLE_PASS
		FROM
			MARKET_PLACE_SETTINGS
		WHERE
			MARKET_PLACE_ID = #attributes.currMP#
	</cfquery>
	<cfscript>
		SystemTime = GetTickCount();
		ggSign = hash(MP_SETTS.API_KEY & MP_SETTS.SECRET_KEY & SystemTime);
	</cfscript>
	<cfoutput>#SystemTime# -- #ggSign# -- #GET_PRODUCT.Recordcount#<br></cfoutput>

	<cfif attributes.currMP eq 3><!--- hepsiburada --->
		<cfhttp url="https://listing-external-sit.hepsiburada.com/listings/merchantid/#MP_SETTS.API_KEY#"
				method="get"
				port="80"
				username="#MP_SETTS.ROLE_NAME#"
				password="#MP_SETTS.ROLE_PASS#"
				result="httpResponse">
			<cfhttpparam type="header" name="content-type" value="text/xml">
			<cfhttpparam type="header" name="charset" value="utf-8">
		</cfhttp>
		<cfscript>
			exportedCount = 0; //use to count exported products
			updatedList = '<?xml version="1.0" encoding="utf-8"?><listings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
			HBRes = httpResponse.fileContent;
			if(IsJSON(HBRes)){
				HBQuery = QueryNew("uniqueIdentifier, hepsiburadaSku, merchantSku, price, availableStock, dispatchTime, cargoCompany1, cargoCompany2,
									cargoCompany3, shippingAddressLabel, claimAddressLabel, maximumPurchasableQuantity, pricings, isSalable,
									customizableProperties, deactivationReasons, isSuspended, isLocked, lockReasons, isFrozen, commissionRate, buyboxOrder");
				HBRes = DeserializeJSON(HBRes);
				HBRes = HBRes.listings;
				QueryAddRow(HBQuery, arraylen(HBRes));
				for (i = 1; i lte arraylen(HBRes); i++){
					prod = HBRes[i];
					QuerySetCell(HBQuery, "uniqueIdentifier", prod.uniqueIdentifier, i);
					QuerySetCell(HBQuery, "hepsiburadaSku", prod.hepsiburadaSku, i);
					QuerySetCell(HBQuery, "merchantSku", prod.merchantSku, i);
					QuerySetCell(HBQuery, "price", prod.price, i);
					QuerySetCell(HBQuery, "dispatchTime", prod.dispatchTime, i);
					QuerySetCell(HBQuery, "cargoCompany1", prod.cargoCompany1, i);
					QuerySetCell(HBQuery, "cargoCompany2", prod.cargoCompany2, i);
					QuerySetCell(HBQuery, "cargoCompany3", prod.cargoCompany3, i);
					QuerySetCell(HBQuery, "shippingAddressLabel", prod.shippingAddressLabel, i);
					QuerySetCell(HBQuery, "claimAddressLabel", prod.claimAddressLabel, i);
					QuerySetCell(HBQuery, "maximumPurchasableQuantity", prod.maximumPurchasableQuantity, i);
					QuerySetCell(HBQuery, "pricings", prod.pricings, i);
					QuerySetCell(HBQuery, "isSalable", prod.isSalable, i);
					QuerySetCell(HBQuery, "customizableProperties", prod.customizableProperties, i);
					QuerySetCell(HBQuery, "deactivationReasons", prod.deactivationReasons, i);
					QuerySetCell(HBQuery, "isSuspended", prod.isSuspended, i);
					QuerySetCell(HBQuery, "isLocked", prod.isLocked, i);
					QuerySetCell(HBQuery, "lockReasons", prod.lockReasons, i);
					QuerySetCell(HBQuery, "isFrozen", prod.hepsiburadaSku, i);
					QuerySetCell(HBQuery, "commissionRate", prod.commissionRate, i);
					QuerySetCell(HBQuery, "buyboxOrder", isDefined('prod.buyboxOrder') ? prod.buyboxOrder : '-1', i);
					if(prod.price > 0)
						WriteOutput('----> ' & prod.hepsiburadaSku & ' -- ' & prod.merchantSku & ' -- ' & prod.price);
				}
			}
			newHBQuery = QueryNew("UniqueIdentifier,MerchantSku,HepsiburadaSku,ProductName,AvailableStock,Price,DispatchTime,CargoCompany1,
									ShippingAddressLabel,ClaimAddressLabel,MaximumPurchasableQuantity");
		</cfscript>
	</cfif>

	<cfif attributes.mpProcess eq 'add'>
		<cfloop query="GET_PRODUCT">
			<cfquery name="prodExistControl" datasource="#dsn#">
				SELECT *
				FROM MARKET_PLACE_PRODUCT
				WHERE
				PRODUCT_ID = #PRODUCT_ID#
				AND
				MARKET_PLACE_ID = #attributes.currMP#
			</cfquery>
			<cfif attributes.currMP eq 1> <!--- gittigidiyor --->
				<cfquery name="GET_MPCAT" datasource="#dsn#">
					SELECT *
					FROM
						MARKET_PLACE_PRODUCT_CAT
					WHERE
						PRODUCT_CATID = #PRODUCT_CATID#
				</cfquery>
				<cfoutput>#PRODUCT_CATID# -- #GET_MPCAT.GITTIGIDIYOR_HIERARCHY# --- #PRODUCT_NAME#<br></cfoutput>

				<cfquery name="GET_IMAGES" datasource="#dsn#">
					SELECT PATH FROM #dsn1_alias#.PRODUCT_IMAGES WHERE PRODUCT_ID  = #PRODUCT_ID#
				</cfquery>
				<cfset prodImgs = ''>
				<cfoutput query = "GET_IMAGES"><cfset prodImgs = prodImgs & '<photo photoId="' & (currentrow-1) & '">' & '<url>http://www.bayidestek.com/' & PATH & '</url><base64></base64></photo>'>#currentrow-1# -- #PATH#<br></cfoutput>

				<cfsavecontent variable="soapBody">
					<cfoutput>
						<?xml version="1.0" encoding="utf-8"?>
						<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cat="http://category.anonymous.ws.listingapi.gg.com">
							<soapenv:Header/>
							<soapenv:Body>
								<cat:getCategory>
									<categoryCode>#GET_MPCAT.GITTIGIDIYOR_HIERARCHY#</categoryCode>
									<withSpecs>true</withSpecs>
									<withDeepest>true</withDeepest>
									<withCatalog>true</withCatalog>
									<lang>tr</lang>
								</cat:getCategory>
							</soapenv:Body>
						</soapenv:Envelope>
					</cfoutput>
				</cfsavecontent>

				<cfhttp url="http://dev.gittigidiyor.com:8080/listingapi/ws/CategoryService?wsdl"
						method="post"
						port="8080"
						username="#MP_SETTS.ROLE_NAME#"
						password="#MP_SETTS.ROLE_PASS#"
						result="httpResponse">
					<cfhttpparam type="header" name="content-type" value="text/xml">
					<cfhttpparam type="header" name="SOAPAction" value="">
					<cfhttpparam type="header" name="content-length" value="#len(soapBody)#">
					<cfhttpparam type="header" name="charset" value="utf-8">
					<cfhttpparam type="xml" value="#Trim(soapBody)#">
				</cfhttp>
				<!---<cfdump var="#httpResponse.Filecontent#">--->
				<cfscript>
					soapResponse = xmlParse( httpResponse.fileContent );
					catDetail = soapResponse.XmlRoot["env:body"].XmlChildren[1].XmlChildren[1];
				</cfscript>
				<!---<cfoutput>#soapResponse#<br></cfoutput><cfdump var="#catDetail.categories.category[1].specs.spec[1]#"><cfoutput>#catDetail.categories.category[1].categorycode.xmlText#<br></cfoutput>--->
				<cfset specs = ''>
				<cfif isDefined('catDetail.categories.category[1].specs')>
					<cfloop array="#catDetail.categories.category[1].specs.xmlchildren#" index="spec" >
						<cfif spec.XmlAttributes["required"]>
							<cfset specs = specs & '<spec name="' & spec.XmlAttributes["name"] & '" type="' & spec.XmlAttributes["type"] & '" required="' & spec.XmlAttributes["required"] & '" value="'>
							<cfset specVal = spec.values.xmlchildren[1].xmlText>
							<cfloop array="#spec.values.xmlchildren#" index="val" >
								<cfif (FindNoCase(val.xmlText,PRODUCT_NAME) neq 0) or (FindNoCase(replace(val.xmlText," ", "" , "ALL"),PRODUCT_NAME) neq 0)>
									<cfset specVal = val.xmlText>
								</cfif>
							</cfloop>
							<cfset specs = specs & specVal & '"/>'>
							<cfoutput>---#specVal#<br></cfoutput>
						</cfif>
					</cfloop>
				</cfif>
				<cfoutput>#specs#<br></cfoutput>

				<cfsavecontent variable="insertBody">
					<cfoutput>
						<?xml version="1.0" encoding="utf-8"?>
						<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:prod="https://product.individual.ws.listingapi.gg.com">
							<soapenv:Header/>
							<soapenv:Body>
								<prod:insertProduct>
									<apiKey>#MP_SETTS.API_KEY#</apiKey>
									<sign>#ggSign#</sign>
									<time>#SystemTime#</time>
									<itemId>#PRODUCT_ID#</itemId>
									<product>
										<!--Optional:-->
										<categoryCode>#GET_MPCAT.GITTIGIDIYOR_HIERARCHY#</categoryCode>
										<!--Optional:-->
										<storeCategoryId></storeCategoryId>
										<!--Optional:-->
										<title>#PRODUCT_NAME#</title>
										<!--Optional:-->
										<subtitle></subtitle>
										<!--Optional:-->
										<specs>
											#specs#
										</specs>
										<!--Optional:-->
										<photos>
											<!--Zero or more repetitions:-->
											#prodImgs#
										</photos>
										<!--Optional:-->
										<pageTemplate>1</pageTemplate>
										<!--Optional:-->
										<description>#PRODUCT_NAME#</description>
										<!--Optional:-->
										<startDate></startDate>
										<!--Optional:-->
										<catalogId></catalogId>
										<!--Optional:-->
										<catalogDetail></catalogDetail>
										<!--Optional:-->
										<catalogFilter></catalogFilter>
										<!--Optional:-->
										<format>S</format>
										<!--Optional:-->
										<startPrice></startPrice>
										<!--Optional:-->
										<buyNowPrice>#numberFormat(SF_SATIS_KDV_TL, '__.00')#</buyNowPrice>
										<!--Optional:-->
										<netEarning></netEarning>
										<!--Optional:-->
										<listingDays>30</listingDays>
										<!--Optional:-->
										<productCount>#STOCK_COUNT#</productCount>
										<!--Optional:-->
										<cargoDetail>
											<!--Optional:-->
											<city>34</city>
											<!--Optional:-->
											<cargoCompanies>
												<cargoCompany>aras</cargoCompany>
											</cargoCompanies>
											<!--Optional:-->
											<shippingPayment>B</shippingPayment>
											<!--Optional:-->
											<cargoDescription></cargoDescription>
											<!--Optional:-->
											<shippingWhere>country</shippingWhere>
											<cargoCompanyDetails>
												<!--Zero or more repetitions:-->
												<cargoCompanyDetail>
													<!--Optional:-->
													<name>aras</name>
													<!--Optional:-->
													<value>0</value>
													<!--Optional:-->
													<cityPrice>0</cityPrice>
													<!--Optional:-->
													<countryPrice>0</countryPrice>
												</cargoCompanyDetail>
											</cargoCompanyDetails>
										</cargoDetail>
										<!--Optional:-->
										<affiliateOption>false</affiliateOption>
										<!--Optional:-->
										<boldOption>false</boldOption>
										<!--Optional:-->
										<catalogOption>false</catalogOption>
										<!--Optional:-->
										<vitrineOption>false</vitrineOption>
									</product>
									<forceToSpecEntry>false</forceToSpecEntry>
									<nextDateOption>false</nextDateOption>
									<lang>tr</lang>
								</prod:insertProduct>
							</soapenv:Body>
						</soapenv:Envelope>
					</cfoutput>
				</cfsavecontent>

				<cfhttp url="http://dev.gittigidiyor.com:8080/listingapi/ws/IndividualProductService?wsdl"
						method="post"
						port="8080"
						username="#MP_SETTS.ROLE_NAME#"
						password="#MP_SETTS.ROLE_PASS#"
						result="prodResponse">
					<cfhttpparam type="header" name="content-type" value="text/xml">
					<cfhttpparam type="header" name="SOAPAction" value="">
					<cfhttpparam type="header" name="content-length" value="#len(insertBody)#">
					<cfhttpparam type="header" name="charset" value="utf-8">
					<cfhttpparam type="xml" value="#Trim(insertBody)#">
				</cfhttp>

				<cfdump var="#prodResponse.fileContent#">

				<cfscript>
					soapResponse = xmlParse( prodResponse.fileContent );
					code = soapResponse.XmlRoot["env:body"].XmlChildren[1];
				</cfscript>

				<cfif not isDefined("code.faultcode") or (isDefined("code.return.ackCode") and (code.return.ackCode neq 'failure'))>
					<cfoutput>----#code.return.productId.xmlText#<br></cfoutput>
					<cfquery name="add_mp_product" datasource="#dsn#">
						INSERT INTO
							MARKET_PLACE_PRODUCT
							(
							PRODUCT_ID,
							MP_PRODUCT_CATID,
							MARKET_PLACE_ID,
							PRODUCT_NAME,
							MP_PRICE,
							PSF_PRICE,
							STOCK,
							IS_PUBLISHED,
							PUBLISH_DAYS,
							MP_PRODID,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP
							)
						VALUES
						(
							#PRODUCT_ID#,
							#PRODUCT_CATID#,
							#attributes.currMP#,
							'#PRODUCT_NAME#',
							#SF_SATIS_KDV_TL#,
							#SF_SATIS_KDV_TL#,
							#STOCK_COUNT#,
							0,
							#attributes.listDays#,
							#code.return.productId.xmlText#,
							#session.ep.userid#,
							#now()#,
							'#cgi.remote_addr#'
						)
					</cfquery>
				<cfelse>
					<cfoutput>#code.faultcode.xmlText#<br></cfoutput>
				</cfif>
			<cfelseif attributes.currMP eq 3 and isDefined('HBQuery')>
				<cfquery dbtype="query" name="mpControl">
					SELECT *
					FROM HBQuery
					WHERE merchantSku = <cfqueryparam cfsqltype="cf_sql_varchar" value="HBV#PRODUCT_ID#">
				</cfquery>
				<cfoutput>mpControl ----> #mpControl.recordcount#<br></cfoutput>
				<cfif mpControl.recordCount>
					<cfif prodExistControl.recordCount eq 0>
						<cfquery name="add_mp_product" datasource="#dsn#">
							INSERT INTO
							MARKET_PLACE_PRODUCT
							(
								PRODUCT_ID,
								MP_PRODUCT_CATID,
								MARKET_PLACE_ID,
								PRODUCT_NAME,
								MP_PRICE,
								PSF_PRICE,
								STOCK,
								IS_PUBLISHED,
								PUBLISH_DAYS,
								MP_PRODID,
								RECORD_EMP,
								RECORD_DATE,
								RECORD_IP
							)
							VALUES
							(
								#PRODUCT_ID#,
								#PRODUCT_CATID#,
								#attributes.currMP#,
								'#PRODUCT_NAME#',
								#SF_SATIS_KDV_TL#,
								#SF_SATIS_KDV_TL#,
								#STOCK_COUNT#,
								0,
								#attributes.listDays#,
								#code.return.productId.xmlText#,
								#session.ep.userid#,
								#now()#,
								'#cgi.remote_addr#'
							)
						</cfquery>
					<cfelse>
						<cfscript>
							updatedList = updatedList & '<listing>';
							updatedList = updatedList & '	<HepsiburadaSku>HBV' & #PRODUCT_ID# & '</HepsiburadaSku>';
							updatedList = updatedList & '	<MerchantSku>' & #PRODUCT_ID# & '</MerchantSku>';
							updatedList = updatedList & '	<ProductName>' & #PRODUCT_NAME# & '</ProductName>';
							updatedList = updatedList & '	<Price>' & #SF_SATIS_KDV_TL# & '</Price>';
							updatedList = updatedList & '	<AvailableStock>' & #STOCK_COUNT# & '</AvailableStock>';
							updatedList = updatedList & '	<DispatchTime>0</DispatchTime>';
							updatedList = updatedList & '	<MaximumPurchasableQuantity>' & #STOCK_COUNT# & '</MaximumPurchasableQuantity>';
							updatedList = updatedList & '</listing>';
						</cfscript>
						<cfquery name="upd_mp_product" datasource="#dsn#">
							UPDATE
								MARKET_PLACE_PRODUCT
							SET
								MP_PRICE = #SF_SATIS_KDV_TL#,
								PSF_PRICE = #SF_SATIS_KDV_TL#,
								STOCK = #STOCK_COUNT#,
								UPDATE_EMP = #session.ep.userid#,
								UPDATE_DATE = #now()#,
								UPDATE_IP = '#cgi.remote_addr#'
							WHERE
								PRODUCT_ID = #PRODUCT_ID#
							AND
								MARKET_PLACE_ID = #attributes.currMP#
						</cfquery>
					</cfif>
				<cfelse>
					<cfscript>
						exportedCount++;
						QueryAddRow(newHBQuery, 1);
						QuerySetCell(newHBQuery, "UniqueIdentifier", "", exportedCount);
						QuerySetCell(newHBQuery, "MerchantSku", #PRODUCT_ID#, exportedCount);
						QuerySetCell(newHBQuery, "HepsiburadaSku", "HBV" & #PRODUCT_ID#, exportedCount);
						QuerySetCell(newHBQuery, "ProductName", #PRODUCT_NAME#, exportedCount);
						QuerySetCell(newHBQuery, "AvailableStock", #STOCK_COUNT#, exportedCount);
						QuerySetCell(newHBQuery, "Price", #SF_SATIS_KDV_TL#, exportedCount);
						QuerySetCell(newHBQuery, "DispatchTime", 3, exportedCount);
						QuerySetCell(newHBQuery, "CargoCompany1", "Aras Kargo", exportedCount);
						QuerySetCell(newHBQuery, "ShippingAddressLabel", "", exportedCount);
						QuerySetCell(newHBQuery, "ClaimAddressLabel", "", exportedCount);
						QuerySetCell(newHBQuery, "MaximumPurchasableQuantity", #STOCK_COUNT#, exportedCount);
					</cfscript>
				</cfif>
			</cfif>
		</cfloop>
		<cfif attributes.currMP eq 3><!--- hepsiburada, Excel file is generated if there exist the product(s) which is not listed  --->
			<cfif newHBQuery.recordCount>
				<cfscript>
					///We need an absolute path, so get the current directory path.
					theFile = GetDirectoryFromPath(GetCurrentTemplatePath());
					theFile = Mid(theFile, 1, Find("add_options", theFile) - 5) & "documents\mp\" & Replace(ValueList(newHBQuery.merchantSku), ",","","All") & ".xls";
					//Create a new Excel spreadsheet object.
					theSheet = SpreadsheetNew("Listelerim");
					//Set the value a cell.
					SpreadSheetAddRow(theSheet,"UniqueIdentifier,MerchantSku,HepsiburadaSku,ProductName,AvailableStock,Price,DispatchTime,CargoCompany1,ShippingAddressLabel,ClaimAddressLabel,MaximumPurchasableQuantity");
					SpreadsheetAddRows(theSheet, newHBQuery);
					WriteOutput('<div class="theFile">http://' & CGI.SERVER_NAME & '/documents/mp/' & Replace(ValueList(newHBQuery.merchantSku), ",","","All") & '.xls</div> -- ' & newHBQuery.RecordCount);
					spreadsheetWrite(theSheet, theFile, true);
				</cfscript>
			</cfif>
			<cfif findNoCase("HepsiburadaSku", updatedList)>
				<cfscript>
					updatedList = updatedList & '</listings>';
				</cfscript>
				<cfhttp url="https://listing-external-sit.hepsiburada.com/listings/merchantid/#MP_SETTS.API_KEY#/inventory-uploads"
						method="post"
						port="80"
						username="#MP_SETTS.ROLE_NAME#"
						password="#MP_SETTS.ROLE_PASS#"
						result="prodResponse">
					<cfhttpparam type="header" name="content-type" value="text/xml">
					<cfhttpparam type="header" name="content-length" value="#len(updatedList)#">
					<cfhttpparam type="header" name="charset" value="utf-8">
					<cfhttpparam type="xml" value="#Trim(updatedList)#">
				</cfhttp>
			</cfif>
		</cfif>
	<cfelseif attributes.mpProcess eq 'publish'>
		<cfset publishList = ''>
		<cfloop query="GET_PRODUCT">
			<cfquery name="GET_MPPROD" datasource="#dsn#">
				SELECT *
				FROM
					MARKET_PLACE_PRODUCT
				WHERE
					PRODUCT_ID = #PRODUCT_ID#
				AND
					(IS_PUBLISHED is null
				OR
					IS_PUBLISHED = 0)
			</cfquery>
			<cfif GET_MPPROD.Recordcount>
				<cfscript>
					if(attributes.currMP eq 1) //gittigidiyor
						publishList = publishList & '<item>' & GET_MPPROD.MP_PRODID & '</item>';
					else
					if(attributes.currMP eq 3){ //hepsiburada
						publishList = publishList & '<listing>';
						publishList = publishList & '	<HepsiburadaSku>HBV' & #PRODUCT_ID# & '</HepsiburadaSku>';
						publishList = publishList & '	<MerchantSku>' & #PRODUCT_ID# & '</MerchantSku>';
						publishList = publishList & '	<ProductName>' & #PRODUCT_NAME# & '</ProductName>';
						publishList = publishList & '	<Price>' & #SF_SATIS_KDV_TL# & '</Price>';
						publishList = publishList & '	<AvailableStock>' & #STOCK_COUNT# & '</AvailableStock>';
						publishList = publishList & '	<DispatchTime>3</DispatchTime>';
						publishList = publishList & '	<MaximumPurchasableQuantity>' & #STOCK_COUNT# & '</MaximumPurchasableQuantity>';
						publishList = publishList & '</listing>';
					}
				</cfscript>

				<cfquery name="UPD_MPPROD" datasource="#dsn#">
					UPDATE MARKET_PLACE_PRODUCT
					SET
						IS_PUBLISHED = <cfif (attributes.currMP eq 1) or (attributes.currMP eq 3 and STOCK_COUNT gt 0)>1<cfelseif attributes.currMP eq 3 and STOCK_COUNT eq 0>0</cfif>,
						PUBLISH_DATE = #now()#
					WHERE
						PRODUCT_ID = #PRODUCT_ID#
					AND
						(IS_PUBLISHED is null
						OR
						IS_PUBLISHED = 0)
				</cfquery>
			</cfif>
		</cfloop>
		<cfif len(publishList) and (attributes.currMP eq 1)>
			<cfsavecontent variable="soapBody">
				<cfoutput>
					<?xml version="1.0" encoding="utf-8"?>
					<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:prod="https://product.individual.ws.listingapi.gg.com">
						<soapenv:Header/>
						<soapenv:Body>
							<prod:calculatePriceForShoppingCart>
								<apiKey>#MP_SETTS.API_KEY#</apiKey>
								<sign>#ggSign#</sign>
								<time>#SystemTime#</time>
								<productIdList>
									<!--Zero or more repetitions:-->
									#publishList#
								</productIdList>
								<itemIdList>
									<!--Zero or more repetitions:-->
								</itemIdList>
								<lang>tr</lang>
							</prod:calculatePriceForShoppingCart>
						</soapenv:Body>
					</soapenv:Envelope>
				</cfoutput>
			</cfsavecontent>

			<cfhttp url="http://dev.gittigidiyor.com:8080/listingapi/ws/IndividualProductService?wsdl"
					method="post"
					port="8080"
					username="#MP_SETTS.ROLE_NAME#"
					password="#MP_SETTS.ROLE_PASS#"
					result="httpResponse">
				<cfhttpparam type="header" name="content-type" value="text/xml">
				<cfhttpparam type="header" name="SOAPAction" value="">
				<cfhttpparam type="header" name="content-length" value="#len(soapBody)#">
				<cfhttpparam type="header" name="charset" value="utf-8">
				<cfhttpparam type="xml" value="#Trim(soapBody)#">
			</cfhttp>

			<cfdump var="#httpResponse.fileContent#">

			<cfscript>
				soapResponse = xmlParse( httpResponse.fileContent );
				res = soapResponse.XmlRoot["env:body"].XmlChildren[1].XmlChildren[1];
			</cfscript>
		<cfelseif len(publishList) and attributes.currMP eq 3>
			<cfsavecontent variable="soapBody">
				<cfoutput>
					<?xml version="1.0" encoding="utf-8"?>
					<listings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
					#publishList#
					</listings>
				</cfoutput>
			</cfsavecontent>
			<cfhttp url="https://listing-external-sit.hepsiburada.com/listings/merchantid/#MP_SETTS.API_KEY#/inventory-uploads"
					method="post"
					port="80"
					username="#MP_SETTS.ROLE_NAME#"
					password="#MP_SETTS.ROLE_PASS#"
					result="prodResponse">
				<cfhttpparam type="header" name="content-type" value="text/xml">
				<cfhttpparam type="header" name="content-length" value="#len(soapBody)#">
				<cfhttpparam type="header" name="charset" value="utf-8">
				<cfhttpparam type="xml" value="#Trim(soapBody)#">
			</cfhttp>
		</cfif>

	<cfelseif attributes.mpProcess eq 'del'>

		<cfset delList = ''>
		<cfset delList2 = ''>
		<cfloop query="GET_PRODUCT">
			<cfquery name="GET_MPPROD" datasource="#dsn#">
				SELECT *
				FROM
					MARKET_PLACE_PRODUCT
				WHERE
					PRODUCT_ID = #PRODUCT_ID#
			</cfquery>
			<cfif GET_MPPROD.Recordcount>
				<cfscript>
					if(attributes.currMP eq 1){ //gittigidiyor
						if(GET_MPPROD.IS_PUBLISHED)
							delList = delList & '<item>' & GET_MPPROD.MP_PRODID & '</item>';
						else
							delList2 = delList2 & '<item>' & GET_MPPROD.MP_PRODID & '</item>';
					}
					else
					if(attributes.currMP eq 3){ //hepsiburada
						delList = delList & '<listing>';
						delList = delList & '	<HepsiburadaSku>HBV' & #PRODUCT_ID# & '</HepsiburadaSku>';
						delList = delList & '	<MerchantSku>' & #PRODUCT_ID# & '</MerchantSku>';
						delList = delList & '	<ProductName>' & #PRODUCT_NAME# & '</ProductName>';
						delList = delList & '	<Price>' & #SF_SATIS_KDV_TL# & '</Price>';
						delList = delList & '	<AvailableStock>0</AvailableStock>';
						delList = delList & '	<DispatchTime>0</DispatchTime>';
						delList = delList & '	<MaximumPurchasableQuantity>0</MaximumPurchasableQuantity>';
						delList = delList & '</listing>';
					}
				</cfscript>
				<cfquery name="UPD_MPPROD" datasource="#dsn#">
					UPDATE MARKET_PLACE_PRODUCT
					SET IS_PUBLISHED = 0
					WHERE
						PRODUCT_ID = #PRODUCT_ID#
				</cfquery>
			</cfif>
		</cfloop>
		<cfif attributes.currMP eq 1>
			<cfif len(delList)>
				<cfsavecontent variable="soapBody">
					<cfoutput>
						<?xml version="1.0" encoding="utf-8"?>
						<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:prod="https://product.individual.ws.listingapi.gg.com">
							<soapenv:Header/>
							<soapenv:Body>
								<prod:finishEarlyProducts>
									<apiKey>#MP_SETTS.API_KEY#</apiKey>
									<sign>#ggSign#</sign>
									<time>#SystemTime#</time>
									<productIdList>
										<!--Zero or more repetitions:-->
										#delList#
									</productIdList>
									<itemIdList>
										<!--Zero or more repetitions:-->
									</itemIdList>
									<lang>tr</lang>
								</prod:finishEarlyProducts>
							</soapenv:Body>
						</soapenv:Envelope>
					</cfoutput>
				</cfsavecontent>

				<cfhttp url="http://dev.gittigidiyor.com:8080/listingapi/ws/IndividualProductService?wsdl"
						method="post"
						port="8080"
						username="#MP_SETTS.ROLE_NAME#"
						password="#MP_SETTS.ROLE_PASS#"
						result="httpResponse">
					<cfhttpparam type="header" name="content-type" value="text/xml">
					<cfhttpparam type="header" name="SOAPAction" value="">
					<cfhttpparam type="header" name="content-length" value="#len(soapBody)#">
					<cfhttpparam type="header" name="charset" value="utf-8">
					<cfhttpparam type="xml" value="#Trim(soapBody)#">
				</cfhttp>
			<cfelseif len(delList2)>
				<cfsavecontent variable="soapBody">
					<cfoutput>
						<?xml version="1.0" encoding="utf-8"?>
						<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:prod="https://product.individual.ws.listingapi.gg.com">
							<soapenv:Header/>
							<soapenv:Body>
								<prod:deleteProducts>
									<apiKey>#MP_SETTS.API_KEY#</apiKey>
									<sign>#ggSign#</sign>
									<time>#SystemTime#</time>
									<productIdList>
										<!--Zero or more repetitions:-->
										#delList2#
									</productIdList>
									<itemIdList>
										<!--Zero or more repetitions:-->
									</itemIdList>
									<lang>tr</lang>
								</prod:deleteProducts>
							</soapenv:Body>
						</soapenv:Envelope>
					</cfoutput>
				</cfsavecontent>

				<cfhttp url="http://dev.gittigidiyor.com:8080/listingapi/ws/IndividualProductService?wsdl"
						method="post"
						port="8080"
						username="#MP_SETTS.ROLE_NAME#"
						password="#MP_SETTS.ROLE_PASS#"
						result="httpResponse">
					<cfhttpparam type="header" name="content-type" value="text/xml">
					<cfhttpparam type="header" name="SOAPAction" value="">
					<cfhttpparam type="header" name="content-length" value="#len(soapBody)#">
					<cfhttpparam type="header" name="charset" value="utf-8">
					<cfhttpparam type="xml" value="#Trim(soapBody)#">
				</cfhttp>
			</cfif>
		<cfelseif len(delList) and attributes.currMP eq 3>
			<cfsavecontent variable="soapBody">
				<cfoutput>
					<?xml version="1.0" encoding="utf-8"?>
					<listings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
						#delList#
					</listings>
				</cfoutput>
			</cfsavecontent>
			<cfhttp url="https://listing-external-sit.hepsiburada.com/listings/merchantid/#MP_SETTS.API_KEY#/inventory-uploads"
					method="post"
					port="80"
					username="#MP_SETTS.ROLE_NAME#"
					password="#MP_SETTS.ROLE_PASS#"
					result="prodResponse">
				<cfhttpparam type="header" name="content-type" value="text/xml">
				<cfhttpparam type="header" name="content-length" value="#len(soapBody)#">
				<cfhttpparam type="header" name="charset" value="utf-8">
				<cfhttpparam type="xml" value="#Trim(soapBody)#">
			</cfhttp>
		</cfif>

	</cfif>
