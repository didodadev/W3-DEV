<cfset dsn1 = '#dsn#_product'>
<cfset dsn3 = '#dsn#_3'>
<cfset dsn2 = '#dsn#_2007_3'>
<cfset attributes.price_catid=3>
<cfprocessingdirective suppresswhitespace="Yes">
    <cfquery name="GET_PRODUCT_IMAGES" datasource="#dsn1#">
		SELECT 
			P.PRODUCT_CODE,
			PI.PATH,
			PI.PATH_SERVER_ID 
		FROM 
			PRODUCT P,
			<cfif (isDefined("attributes.price_catid") and (attributes.price_catid eq -1)) or (isDefined("attributes.price_catid") and (attributes.price_catid eq -2))>
				PRICE_STANDART PS,
			<cfelseif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				#dsn3#.PRICE PR,
			</cfif>
			PRODUCT_IMAGES PI
		WHERE 
			P.PRODUCT_ID = PI.PRODUCT_ID AND
			<cfif (isDefined("attributes.price_catid") and (attributes.price_catid eq -1)) or (isDefined("attributes.price_catid") and (attributes.price_catid eq -2))>
				PS.PURCHASESALES = <cfif isDefined("attributes.price_catid") and (attributes.price_catid eq -1)>0<cfelse>1</cfif> AND
				PS.PRICESTANDART_STATUS = 1 AND	
				P.PRODUCT_ID = PS.PRODUCT_ID AND
			<cfelseif isDefined("attributes.price_catid") and len(attributes.price_catid) and attributes.price_catid neq -1 and attributes.price_catid neq -2>
				PR.PRICE_CATID = #attributes.price_catid# AND
				PR.STARTDATE <= #now()# AND
				(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
				P.PRODUCT_ID = PR.PRODUCT_ID AND
				ISNULL(P.STOCK_ID,0)=0 AND
				ISNULL(P.SPECT_VAR_ID,0)=0 AND
			</cfif>	
			P.PRODUCT_STATUS = 1 AND
			PI.IMAGE_SIZE = 1
	</cfquery>
	<cfscript>
		upload_folder = "#upload_folder##dir_seperator#";
		file_name1 = "urun_image_url.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc,"PRODUCTLIST");
		for (k = 1; k lte get_product_images.recordcount; k = k + 1)
		{
			machine_id = get_product_images.PATH_SERVER_ID[k];
	    	machine_name = listgetat(fusebox.server_machine_list,machine_id,';');
			my_doc.xmlRoot.XmlChildren[k] = XmlElemNew(my_doc,"PRODUCT");
			my_doc.xmlRoot.XmlChildren[k].XmlChildren[1] = XmlElemNew(my_doc,"ITEM_CODE");
			my_doc.xmlRoot.XmlChildren[k].XmlChildren[1].XmlText = get_product_images.product_code[k];
			my_doc.xmlRoot.XmlChildren[k].XmlChildren[2] = XmlElemNew(my_doc,"IMAGE_URL");
			my_doc.xmlRoot.XmlChildren[k].XmlChildren[2].XmlText = "#machine_name#/documents/product/#get_product_images.PATH[k]#";
		}
	</cfscript>
	<cffile action="write" file="#upload_folder##file_name1#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="GET_PRODUCT_PRICE_PRO" datasource="#dsn1#">
		SELECT 
			P.PRODUCT_ID,
			P.PRODUCT_CODE,
			P.PRODUCT_NAME,
			PS.PRICE,
			PS.MONEY,
			PB.BRAND_NAME,
			PC.PRODUCT_CAT,
			P.IS_SALES,
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				PR.PRICE AS PR_PRICE,
			<cfelse>
				PS.PRICE AS PR_PRICE,
			</cfif>
			GT.SALEABLE_STOCK
		FROM 
			PRODUCT P, 
			PRICE_STANDART PS,
			PRODUCT_BRANDS PB,
			PRODUCT_CAT PC,
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				#dsn3#.PRICE PR,
			</cfif>
				#dsn2#.GET_STOCK_LAST GT
		WHERE
			P.PRODUCT_STATUS = 1 AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid eq -1)>
				PS.PURCHASESALES = 0 AND
			<cfelse>
				PS.PURCHASESALES = 1 AND
			</cfif>
			PS.PRICESTANDART_STATUS = 1 AND	
			P.PRODUCT_ID = PS.PRODUCT_ID AND
			P.BRAND_ID = PB.BRAND_ID AND
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				PR.PRODUCT_ID = P.PRODUCT_ID AND
				ISNULL(PR.STOCK_ID,0)=0 AND
				ISNULL(PR.SPECT_VAR_ID,0)=0 AND
				PR.PRICE_CATID = #attributes.price_catid# AND
				PR.STARTDATE <= #now()# AND
				(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
			</cfif>
			P.PRODUCT_ID = GT.PRODUCT_ID
	</cfquery>
	<cfscript>
		file_name2 = "urun_katalogu_v2.xml";
		my_doc_1 = XmlNew();
		my_doc_1.xmlRoot = XmlElemNew(my_doc_1,"PRODUCTLIST");
	</cfscript>
	<cfoutput query="get_product_price_pro">
		<cfscript>
				my_doc_1.xmlRoot.XmlChildren[currentrow] = XmlElemNew(my_doc_1,"PRODUCT");
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[1] = XmlElemNew(my_doc_1,"ITEM_CODE");
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[1].XmlText = get_product_price_pro.product_code;
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[2] = XmlElemNew(my_doc_1,"ITEM_DESC");
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[2].XmlText = get_product_price_pro.product_name;
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[3] = XmlElemNew(my_doc_1,"COMMODITY_CODE");
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[3].XmlText = get_product_price_pro.brand_name;	
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[4] = XmlElemNew(my_doc_1,"SKU_CODE");
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[4].XmlText = get_product_price_pro.product_cat;
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[5] = XmlElemNew(my_doc_1,"QTY");
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[5].XmlText = get_product_price_pro.saleable_stock;
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[6] = XmlElemNew(my_doc_1,"PRICE");
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[6].XmlText = get_product_price_pro.pr_price;
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[7] = XmlElemNew(my_doc_1,"USER_PRICE");
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[7].XmlText = get_product_price_pro.price;
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[8] = XmlElemNew(my_doc_1,"CURRENCY_CODE");
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[8].XmlText = get_product_price_pro.money;
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[9] = XmlElemNew(my_doc_1,"IN_USE");
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[9].XmlText = get_product_price_pro.is_sales;
				my_doc_1.xmlRoot.XmlChildren[currentrow].XmlChildren[10] = XmlElemNew(my_doc_1,"INFO");
		</cfscript>
		<cfquery name="get_property" datasource="#dsn1#">
			SELECT
				PRODUCT_DT_PROPERTIES.DETAIL,
				PRODUCT_PROPERTY.PROPERTY,
				PRODUCT_PROPERTY.PROPERTY_ID,
				PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL
			FROM
				PRODUCT_DT_PROPERTIES,
				PRODUCT_PROPERTY,
				PRODUCT_PROPERTY_DETAIL
			WHERE
				PRODUCT_PROPERTY.IS_ACTIVE = 1 AND
				PRODUCT_PROPERTY_DETAIL.IS_ACTIVE = 1 AND
				PRODUCT_DT_PROPERTIES.VARIATION_ID = PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID AND
				PRODUCT_DT_PROPERTIES.PRODUCT_ID = #get_product_price_pro.product_id# AND
				PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID AND
				PRODUCT_PROPERTY_DETAIL.PRPT_ID = PRODUCT_PROPERTY.PROPERTY_ID
		</cfquery>
		<cfif get_property.recordcount>
		<cfset deger = 1>
			<cfloop query="get_property">
				<cfscript>
						my_doc_1.xmlRoot.XmlChildren[get_product_price_pro.currentrow].XmlChildren[10].XmlChildren[deger] = XmlElemNew(my_doc_1,"TITLE#get_property.currentrow#");
						my_doc_1.xmlRoot.XmlChildren[get_product_price_pro.currentrow].XmlChildren[10].XmlChildren[deger].XmlText = get_property.property[get_property.currentrow];
						my_doc_1.xmlRoot.XmlChildren[get_product_price_pro.currentrow].XmlChildren[10].XmlChildren[deger+1] = XmlElemNew(my_doc_1,"DESC#get_property.currentrow#");
						my_doc_1.xmlRoot.XmlChildren[get_product_price_pro.currentrow].XmlChildren[10].XmlChildren[deger+1].XmlText = get_property.property_detail[get_property.currentrow]&" "&get_property.detail[get_property.currentrow];
				</cfscript>
				<cfset deger = deger+2>
			</cfloop>
		</cfif>
	</cfoutput>
	<cffile action="write" file="#upload_folder##file_name2#" output="#toString(my_doc_1)#" charset="utf-8">
	<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn1#">
		SELECT 
			P.PRODUCT_ID,
			P.PRODUCT_CODE,
			P.PRODUCT_NAME,
			PS.PRICE,
			PS.MONEY,
			PB.BRAND_NAME,
			PC.PRODUCT_CAT,
			P.IS_SALES,
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				PR.PRICE AS PR_PRICE,
			<cfelse>
				PS.PRICE AS PR_PRICE,
			</cfif>
			GT.SALEABLE_STOCK
		FROM 
			PRODUCT P, 
			PRICE_STANDART PS,
			PRODUCT_BRANDS PB,
			PRODUCT_CAT PC,
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				#dsn3#.PRICE PR,
			</cfif>
				#dsn2#.GET_STOCK_LAST GT
		WHERE
			P.PRODUCT_STATUS = 1 AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid eq -1)>
				PS.PURCHASESALES = 0 AND
			<cfelse>
				PS.PURCHASESALES = 1 AND
			</cfif>
			PS.PRICESTANDART_STATUS = 1 AND	
			P.PRODUCT_ID = PS.PRODUCT_ID AND
			P.BRAND_ID = PB.BRAND_ID AND
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				PR.PRODUCT_ID = P.PRODUCT_ID AND
				ISNULL(PR.STOCK_ID,0)=0 AND
				ISNULL(PR.SPECT_VAR_ID,0)=0 AND
				PR.PRICE_CATID = #attributes.price_catid# AND
				PR.STARTDATE <= #now()# AND
				(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
			</cfif>
			P.PRODUCT_ID = GT.PRODUCT_ID
	</cfquery>
	<cfscript>
		file_name3 = "urun_katalogu.xml";
		my_doc_2 = XmlNew();
		my_doc_2.xmlRoot = XmlElemNew(my_doc_2,"PRODUCTLIST");	
		for (k = 1; k lte get_product_price.recordcount; k = k + 1)
		{
			my_doc_2.xmlRoot.XmlChildren[k] = XmlElemNew(my_doc_2,"PRODUCT");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[1] = XmlElemNew(my_doc_2,"ITEM_CODE");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[1].XmlText = get_product_price.product_code[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[2] = XmlElemNew(my_doc_2,"ITEM_DESC");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[2].XmlText = get_product_price.product_name[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[3] = XmlElemNew(my_doc_2,"COMMODITY_CODE");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[3].XmlText = get_product_price.brand_name[k];	
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[4] = XmlElemNew(my_doc_2,"SKU_CODE");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[4].XmlText = get_product_price.product_cat[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[5] = XmlElemNew(my_doc_2,"QTY");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[5].XmlText = get_product_price.saleable_stock[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[6] = XmlElemNew(my_doc_2,"PRICE");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[6].XmlText = get_product_price.pr_price[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[7] = XmlElemNew(my_doc_2,"USER_PRICE");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[7].XmlText = get_product_price.price[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[8] = XmlElemNew(my_doc_2,"CURRENCY_CODE");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[8].XmlText = get_product_price.money[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[9] = XmlElemNew(my_doc_2,"IN_USE");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[9].XmlText = get_product_price.is_sales[k];
		}
	</cfscript>
	<cffile action="write" file="#upload_folder##file_name3#" output="#toString(my_doc_2)#" charset="utf-8">
</cfprocessingdirective>

