<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="Yes">
<cfif isdefined("attributes.is_xml") and attributes.is_xml eq 'is_image_xml'><!--- İmajlı Ürün Getir Seçilmişse imaj XML i oluşuyor --->
    <cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN1#">
		SELECT
			P.PRODUCT_CODE,
			PI.PATH,
			PI.PATH_SERVER_ID
		FROM
			PRODUCT P,
			<cfif (isDefined("attributes.price_catid") and (attributes.price_catid eq -1)) or (isDefined("attributes.price_catid") and (attributes.price_catid eq -2))>
				PRICE_STANDART PS,
			<cfelseif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				#dsn3_alias#.PRICE PR,
			</cfif>
			PRODUCT_IMAGES PI
		WHERE
			P.PRODUCT_ID = PI.PRODUCT_ID AND
			<cfif (isDefined("attributes.price_catid") and (attributes.price_catid eq -1)) or (isDefined("attributes.price_catid") and (attributes.price_catid eq -2))>
				PS.PURCHASESALES = <cfif isDefined("attributes.price_catid") and (attributes.price_catid eq -1)>0<cfelse>1</cfif> AND
				PS.PRICESTANDART_STATUS = 1 AND
				P.PRODUCT_ID = PS.PRODUCT_ID AND
			<cfelseif isDefined("attributes.price_catid") and len(attributes.price_catid) and attributes.price_catid neq -1 and attributes.price_catid neq -2>
				PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
				PR.STARTDATE <= #now()# AND
				(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
				P.PRODUCT_ID = PR.PRODUCT_ID AND
				ISNULL(PR.STOCK_ID,0)=0 AND
				ISNULL(PR.SPECT_VAR_ID,0)=0 AND
			</cfif>
			P.PRODUCT_STATUS = 1 AND
			PI.IMAGE_SIZE = 1
	</cfquery>
	<cfif isdefined('session.pp')>
		<cfset machine_id = listfindnocase(partner_companies,session.pp.our_company_id,';')>
	<cfelseif isdefined('session.ww.our_company_id')>
		<cfset machine_id = listfindnocase(server_companies,session.ww.our_company_id,';')>
	</cfif>

	<cfif isdefined('session.ep')>
		<cfset machine_name = listgetat(employee_url,1,';')>
	<cfelse>
		<cfset machine_name = listgetat(server_url,machine_id,';')>
	</cfif>
	<cfscript>
		upload_folder = "#upload_folder#product#dir_seperator#";
		file_name = "product_image.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc,"PRODUCTLIST");
		for (k = 1; k lte get_product_images.recordcount; k = k + 1)
		{
			my_doc.xmlRoot.XmlChildren[k] = XmlElemNew(my_doc,"PRODUCT");
			my_doc.xmlRoot.XmlChildren[k].XmlChildren[1] = XmlElemNew(my_doc,"ITEM_CODE");
			my_doc.xmlRoot.XmlChildren[k].XmlChildren[1].XmlText = get_product_images.product_code[k];
			my_doc.xmlRoot.XmlChildren[k].XmlChildren[2] = XmlElemNew(my_doc,"IMAGE_URL");
			my_doc.xmlRoot.XmlChildren[k].XmlChildren[2].XmlText = "http://#machine_name#/documents/product/#get_product_images.PATH[k]#";
		}
	</cfscript>
	<cffile action="write" file="#upload_folder##file_name#" output="#toString(my_doc)#" charset="utf-8">
<cfelseif isdefined("attributes.is_xml") and attributes.is_xml eq 'is_property_xml'><!--- Özellikli ve Fiyatlı Seçilmişse özellik ve fiyat XML i oluşuyor --->
	<cfquery name="GET_PRODUCT_PRICE_PRO" datasource="#DSN1#">
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
			PRODUCT P
            LEFT JOIN PRODUCT_BRANDS PB ON P.BRAND_ID = PB.BRAND_ID,
			PRICE_STANDART PS,
			PRODUCT_CAT PC,
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				#dsn3_alias#.PRICE PR,
			</cfif>
				#dsn2_alias#.GET_STOCK_LAST GT
		WHERE
			P.PRODUCT_STATUS = 1 AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid eq -1)>
				PS.PURCHASESALES = 0 AND
			<cfelse>
				PS.PURCHASESALES = 1 AND
			</cfif>
			PS.PRICESTANDART_STATUS = 1 AND
			P.PRODUCT_ID = PS.PRODUCT_ID AND
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				PR.PRODUCT_ID = P.PRODUCT_ID AND
				ISNULL(PR.STOCK_ID,0)=0 AND
				ISNULL(PR.SPECT_VAR_ID,0)=0 AND
				PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
				PR.STARTDATE <= #now()# AND
				(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
			</cfif>
			P.PRODUCT_ID = GT.PRODUCT_ID
	</cfquery>
    <cfquery name="GET_PROPERTIES" datasource="#DSN1#">
        SELECT
        	PRODUCT_DT_PROPERTIES.PRODUCT_ID,
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
            PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID AND
            PRODUCT_PROPERTY_DETAIL.PRPT_ID = PRODUCT_PROPERTY.PROPERTY_ID
    </cfquery>
	<cfscript>
		upload_folder = "#upload_folder#product#dir_seperator#";
		file_name = "product_property_price.xml";
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
		<cfquery name="GET_PROPERTY" dbtype="query">
			SELECT
				*
			FROM
				GET_PROPERTIES
			WHERE
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_price_pro.product_id#">
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
	<cffile action="write" file="#upload_folder##file_name#" output="#toString(my_doc_1)#" charset="utf-8">
<cfelseif isdefined("attributes.is_xml") and attributes.is_xml eq 'is_cost_xml'><!--- Fiyatlı Seçilmişse fiyat XML i oluşuyor --->
	<cfquery name="GET_PRODUCT_PRICE" datasource="#DSN1#">
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
			PRODUCT P
            LEFT JOIN PRODUCT_BRANDS PB ON P.BRAND_ID = PB.BRAND_ID,
			PRICE_STANDART PS,
			PRODUCT_CAT PC,
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				#dsn3_alias#.PRICE PR,
			</cfif>
				#dsn2_alias#.GET_STOCK_LAST GT
		WHERE
			P.PRODUCT_STATUS = 1 AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid eq -1)>
				PS.PURCHASESALES = 0 AND
			<cfelse>
				PS.PURCHASESALES = 1 AND
			</cfif>
			PS.PRICESTANDART_STATUS = 1 AND
			P.PRODUCT_ID = PS.PRODUCT_ID AND
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				PR.PRODUCT_ID = P.PRODUCT_ID AND
				ISNULL(PR.STOCK_ID,0)=0 AND
				ISNULL(PR.SPECT_VAR_ID,0)=0 AND
				PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
				PR.STARTDATE <= #now()# AND
				(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
			</cfif>
			P.PRODUCT_ID = GT.PRODUCT_ID
	</cfquery>
	<cfscript>
		upload_folder = "#upload_folder#product#dir_seperator#";
		file_name = "product_price.xml";
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
	<cffile action="write" file="#upload_folder##file_name#" output="#toString(my_doc_2)#" charset="utf-8">
<cfelseif isdefined('attributes.is_xml') and attributes.is_xml eq 'is_product_xml'>
	<cfif isdefined('session.pp')>
		<cfset machine_id = listfindnocase(partner_companies,session.pp.our_company_id,';')>
	<cfelseif isdefined('session.ww.our_company_id')>
		<cfset machine_id = listfindnocase(server_companies,session.ww.our_company_id,';')>
	</cfif>

	<cfif isdefined('session.ep')>
		<cfset machine_name = listgetat(employee_url,1,';')>
	<cfelse>
		<cfset machine_name = listgetat(server_url,machine_id,';')>
	</cfif>
	<cfquery name="GET_PRODUCT_PRICE" datasource="#DSN1#">
		SELECT
			P.PRODUCT_ID,
			S.STOCK_ID,
			S.STOCK_CODE,
			P.PRODUCT_NAME,
			PS.PRICE,
			PS.MONEY,
			PB.BRAND_NAME,
			PC.PRODUCT_CAT,
			P.TAX,
			P.PRODUCT_DETAIL,
			S.BARCOD,
			PU.DIMENTION,
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				PR.PRICE AS PR_PRICE,
			<cfelse>
				PS.PRICE AS PR_PRICE,
			</cfif>
			GT.SALEABLE_STOCK
		FROM
			PRODUCT P
			LEFT JOIN PRODUCT_BRANDS PB ON P.BRAND_ID = PB.BRAND_ID,
            STOCKS S,
			PRICE_STANDART PS,
			PRODUCT_CAT PC,
			PRODUCT_UNIT PU,
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				#dsn3_alias#.PRICE PR,
			</cfif>
				#dsn2_alias#.GET_STOCK_LAST GT
		WHERE
			P.PRODUCT_ID=S.PRODUCT_ID AND
			P.PRODUCT_STATUS = 1 AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid eq -1)>
				PS.PURCHASESALES = 0 AND
			<cfelse>
				PS.PURCHASESALES = 1 AND
			</cfif>
			PS.PRICESTANDART_STATUS = 1 AND
			P.PRODUCT_ID = PS.PRODUCT_ID AND
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			P.PRODUCT_ID = PU.PRODUCT_ID AND
			PU.IS_MAIN=1 AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				PR.PRODUCT_ID = P.PRODUCT_ID AND
				ISNULL(PR.STOCK_ID,0)=0 AND
				ISNULL(PR.SPECT_VAR_ID,0)=0 AND
				PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
				PR.STARTDATE <= #now()# AND
				(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
			</cfif>
			P.PRODUCT_ID = GT.PRODUCT_ID
	</cfquery>
	<cfif (isdefined("attributes.company_id") and len(attributes.company_id)) or (isdefined("attributes.consumer_id") and len(attributes.consumer_id))>
		<cfquery name="GET_PRICE_EXCEPTIONS_ALL" datasource="#DSN3#">
			SELECT
				PRODUCT_ID,
                PRODUCT_CATID,
                BRAND_ID
			FROM
				PRICE_CAT_EXCEPTIONS
			WHERE
				ACT_TYPE = 1 AND
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
		</cfquery>
		<cfquery name="GET_PRICE_EXCEPTIONS_PID" dbtype="query">
			SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_ID IS NOT NULL
		</cfquery>
		<cfquery name="GET_PRICE_EXCEPTIONS_PCATID" dbtype="query">
			SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_CATID IS NOT NULL
		</cfquery>
		<cfquery name="GET_PRICE_EXCEPTIONS_BRID" dbtype="query">
			SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE BRAND_ID IS NOT NULL
		</cfquery>
		<cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount or get_price_exceptions_brid.recordcount>
            <cfquery name="GET_PRICE_ALL" datasource="#DSN3#">
                <cfif get_price_exceptions_pid.recordcount>
                    SELECT
                        CATALOG_ID,
                        UNIT,
                        PRICE,
                        PRICE_KDV,
                        PRODUCT_ID,
                        MONEY,
                        PRICE_CATID
                    FROM
                        PRICE
                    WHERE
                        PRICE > 0 AND
                        ISNULL(STOCK_ID,0)=0 AND
                        ISNULL(SPECT_VAR_ID,0)=0 AND
                        STARTDATE <= #now()# AND
                        (FINISHDATE >= #now()# OR FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_pid.recordcount gt 1>(</cfif>
                            <cfoutput query="get_price_exceptions_pid">
                                (PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
                                <cfif get_price_exceptions_pid.recordcount neq get_price_exceptions_pid.currentrow>
                                	OR
                                </cfif>
                            </cfoutput>
                        <cfif get_price_exceptions_pid.recordcount gt 1>)</cfif>
                </cfif>
                <cfif get_price_exceptions_pcatid.recordcount>
                    <cfif get_price_exceptions_pid.recordcount>
                    	UNION
                    </cfif>
                    SELECT
                        P.CATALOG_ID,
                        P.UNIT,
                        P.PRICE PRICE,
                        P.PRICE_KDV,
                        P.PRODUCT_ID,
                        P.MONEY,
                        P.PRICE_CATID
                    FROM
                        PRICE P,
                        PRODUCT PR
                    WHERE
                        PRICE > 0 AND
                        ISNULL(P.STOCK_ID,0)=0 AND
                        ISNULL(P.SPECT_VAR_ID,0)=0 AND
                        <cfif get_price_exceptions_pid.recordcount>
                        P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
                        </cfif>
                        P.PRODUCT_ID = PR.PRODUCT_ID AND
                        P.STARTDATE <= #now()# AND
                        (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_pcatid.recordcount gt 1>(</cfif>
                        <cfoutput query="get_price_exceptions_pcatid">
                            (PR.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_catid#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
                            <cfif get_price_exceptions_pcatid.recordcount neq get_price_exceptions_pcatid.currentrow>
	                            OR
                            </cfif>
                        </cfoutput>
                        <cfif get_price_exceptions_pcatid.recordcount gt 1>)</cfif>
                </cfif>
                <cfif get_price_exceptions_brid.recordcount>
                    <cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount>
                    	UNION
                    </cfif>
                    SELECT
                        P.CATALOG_ID,
                        P.UNIT,
                        P.PRICE PRICE,
                        P.PRICE_KDV,
                        P.PRODUCT_ID,
                        P.MONEY,
                        P.PRICE_CATID
                    FROM
                        PRICE P,
                        PRODUCT PR
                    WHERE
                        PRICE > 0 AND
                        ISNULL(P.STOCK_ID,0)=0 AND
                        ISNULL(P.SPECT_VAR_ID,0)=0 AND
                        <cfif get_price_exceptions_pid.recordcount>
                        	P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
                        </cfif>
                        <cfif get_price_exceptions_pcatid.recordcount>
                        	PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
                        </cfif>
                        P.PRODUCT_ID = PR.PRODUCT_ID AND
                        P.STARTDATE <= #now()# AND
                        (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>
                        <cfoutput query="get_price_exceptions_brid">
                        (PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#brand_id#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
                        <cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
                        OR
                        </cfif>
                        </cfoutput>
                        <cfif get_price_exceptions_brid.recordcount gt 1>)</cfif>
                </cfif>
            </cfquery>
		</cfif>
	</cfif>
	<cfscript>
		GET_PRODUCT_IMAGE_ALL=cfquery(SQLString:'SELECT PIMG.PATH,PIMG.PATH_SERVER_ID,PIMG.PRODUCT_ID FROM PRODUCT_IMAGES PIMG',Datasource:DSN1,is_select:1);
		GET_STOCK_STRATEGY_ALL=cfquery(SQLString:'SELECT PROVISION_TIME,PRODUCT_ID,STOCK_ID FROM STOCK_STRATEGY WHERE DEPARTMENT_ID IS NULL',Datasource:DSN3,is_select:1);
		GET_PRODUCT_GUARANTY_ALL=cfquery(SQLString:'SELECT * FROM PRODUCT_GUARANTY',Datasource:DSN3,is_select:1);
		GET_PRODUCT_PROPERTY_ALL=cfquery(SQLString:'SELECT PRODUCT_DT_PROPERTIES.PRODUCT_ID,PRODUCT_DT_PROPERTIES.DETAIL,PRODUCT_PROPERTY.PROPERTY,PRODUCT_PROPERTY.PROPERTY_ID,PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL FROM PRODUCT_DT_PROPERTIES,PRODUCT_PROPERTY,PRODUCT_PROPERTY_DETAIL WHERE PRODUCT_PROPERTY.IS_ACTIVE = 1 AND PRODUCT_PROPERTY_DETAIL.IS_ACTIVE = 1 AND PRODUCT_DT_PROPERTIES.VARIATION_ID = PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID AND PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID AND PRODUCT_PROPERTY_DETAIL.PRPT_ID = PRODUCT_PROPERTY.PROPERTY_ID',Datasource:DSN1,is_select:1);

		upload_folder = "#upload_folder#product#dir_seperator#";
		file_name = "product_price.xml";
		my_doc_2 = XmlNew();
		my_doc_2.xmlRoot = XmlElemNew(my_doc_2,"PRODUCTLIST");
		for (k = 1; k lte GET_PRODUCT_PRICE.RECORDCOUNT; k = k + 1)
		{
			GET_PRODUCT_IMAGE=cfquery(SQLString:'SELECT PATH,PATH_SERVER_ID FROM GET_PRODUCT_IMAGE_ALL WHERE PRODUCT_ID = '&GET_PRODUCT_PRICE.PRODUCT_ID[k],datasource:'',dbtype:'query',is_select:1);
			GET_STOCK_STRATEGY=cfquery(SQLString:'SELECT PROVISION_TIME FROM GET_STOCK_STRATEGY_ALL WHERE STOCK_ID = '&GET_PRODUCT_PRICE.STOCK_ID[k],Datasource:'',dbtype:'query',is_select:1);
			GET_PRODUCT_GUARANTY=cfquery(SQLString:'SELECT * FROM GET_PRODUCT_GUARANTY_ALL WHERE PRODUCT_ID = '&GET_PRODUCT_PRICE.PRODUCT_ID[k],Datasource:'',dbtype:'query',is_select:1);
			GET_PRODUCT_PROPERTY=cfquery(SQLString:'SELECT * FROM GET_PRODUCT_PROPERTY_ALL WHERE PRODUCT_ID = '&GET_PRODUCT_PRICE.PRODUCT_ID[k],Datasource:'',dbtype:'query',is_select:1);
			my_doc_2.xmlRoot.XmlChildren[k] = XmlElemNew(my_doc_2,"PRODUCT");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[1] = XmlElemNew(my_doc_2,"UrunID");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[1].XmlText = GET_PRODUCT_PRICE.PRODUCT_ID[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[2] = XmlElemNew(my_doc_2,"StokID");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[2].XmlText = GET_PRODUCT_PRICE.STOCK_ID[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[3] = XmlElemNew(my_doc_2,"UrunAdi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[3].XmlText = GET_PRODUCT_PRICE.PRODUCT_NAME[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[4] = XmlElemNew(my_doc_2,"UrunKodu");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[4].XmlText = GET_PRODUCT_PRICE.STOCK_CODE[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[5] = XmlElemNew(my_doc_2,"StokAdedi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[5].XmlText = GET_PRODUCT_PRICE.SALEABLE_STOCK[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[6] = XmlElemNew(my_doc_2,"OzelFiyat");
			if(isdefined("get_price_all"))
			{
				GET_PRODUCT_PRICE=cfquery(SQLString:'SELECT PRICE FROM GET_PRICE_ALL WHERE PRODUCT_ID='&GET_PRODUCT_PRICE.PRODUCT_ID[k],datasource:'',dbtype:'query',is_select:1);
				special_price=GET_PRODUCT_PRICE.PRICE;
			}else
			{
				special_price="";
			}
			if(len(special_price))
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[6].XmlText = special_price;
			else
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[6].XmlText = GET_PRODUCT_PRICE.PR_PRICE[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[7] = XmlElemNew(my_doc_2,"ListeFiyat");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[7].XmlText = GET_PRODUCT_PRICE.PR_PRICE[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[8] = XmlElemNew(my_doc_2,"SonKullaniciFiyat");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[8].XmlText = GET_PRODUCT_PRICE.PRICE[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[9] = XmlElemNew(my_doc_2,"Kur");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[9].XmlText = GET_PRODUCT_PRICE.MONEY[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[10] = XmlElemNew(my_doc_2,"KDV");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[10].XmlText = GET_PRODUCT_PRICE.TAX[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[11] = XmlElemNew(my_doc_2,"KategoriAdi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[11].XmlText = GET_PRODUCT_PRICE.PRODUCT_CAT[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[12] = XmlElemNew(my_doc_2,"EanCode");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[12].XmlText = GET_PRODUCT_PRICE.BARCOD[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[13] = XmlElemNew(my_doc_2,"Marka");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[13].XmlText = GET_PRODUCT_PRICE.BRAND_NAME[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[14] = XmlElemNew(my_doc_2,"StokGelisTarih");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[14].XmlText = "";
			rw =1;
			if(GET_PRODUCT_IMAGE.RECORDCOUNT)
			{
				if(GET_PRODUCT_IMAGE.RECORDCOUNT gt 5) rw_count=5; else rw_count=GET_PRODUCT_IMAGE.RECORDCOUNT;
				for (rw = 1; rw lte rw_count; rw = rw + 1)
				{
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[14+rw] = XmlElemNew(my_doc_2,"ImageName#rw#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[14+rw].XmlText = "http://#machine_name#/documents/product/#GET_PRODUCT_IMAGE.PATH[rw]#";
				}
			}
			for (rw_2 = rw; rw_2 lte 5; rw_2 = rw_2 + 1)
			{
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[14+rw_2] = XmlElemNew(my_doc_2,"ImageName#rw_2#");
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[14+rw_2].XmlText = "";
			}
			if(GET_PRODUCT_PROPERTY.RECORDCOUNT)
			{
				product_detail = "";
				for(pro_rw=1;pro_rw lte GET_PRODUCT_PROPERTY.RECORDCOUNT;pro_rw=pro_rw+1)
					product_detail = product_detail&"    "&GET_PRODUCT_PROPERTY.PROPERTY[pro_rw]&" = "&GET_PRODUCT_PROPERTY.PROPERTY_DETAIL[pro_rw]&" : "&GET_PRODUCT_PROPERTY.DETAIL[pro_rw];
			}else
			{
				product_detail = "";
			}

			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[20] = XmlElemNew(my_doc_2,"UrunAciklamasi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[20].XmlText = product_detail;
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[21] = XmlElemNew(my_doc_2,"Desi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[21].XmlText = GET_PRODUCT_PRICE.DIMENTION[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[22] = XmlElemNew(my_doc_2,"TedarikSuresi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[22].XmlText = GET_STOCK_STRATEGY.PROVISION_TIME;
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[23] = XmlElemNew(my_doc_2,"Garanti");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[23].XmlText = "";//iif(len(GET_PRODUCT_GUARANTY.SUPPORT_DURATION),30,11);
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[24] = XmlElemNew(my_doc_2,"GarantiAciklama");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[24].XmlText = "";

		}
	</cfscript>	

	<cffile action="write" file="#upload_folder##file_name#" output="#toString(my_doc_2)#" charset="utf-8">
<cfelseif isdefined('attributes.is_xml') and attributes.is_xml eq 'is_detail_product_xml'>
	<cfif isdefined('session.pp')>
		<cfset machine_id = listfindnocase(partner_companies,session.pp.our_company_id,';')>
	<cfelseif isdefined('session.ww.our_company_id')>
		<cfset machine_id = listfindnocase(server_companies,session.ww.our_company_id,';')>
	</cfif>

	<cfif isdefined('session.ep')>
		<cfset machine_name = listgetat(employee_url,1,';')>
	<cfelse>
		<cfset machine_name = listgetat(server_url,machine_id,';')>
	</cfif>
	<cfquery name="GET_PRODUCT_PRICE" datasource="#DSN1#">
		SELECT
			P.PRODUCT_ID,
			P.PRODUCT_CODE,
			S.STOCK_ID,
			S.STOCK_CODE,
			P.PRODUCT_NAME,
			PS.PRICE,
			PS.MONEY,
			PB.BRAND_NAME,
			PC.PRODUCT_CAT,
			P.TAX,
			P.PRODUCT_DETAIL,
			S.BARCOD,
			PU.MAIN_UNIT,
			PU.DIMENTION,
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				PR.PRICE AS PR_PRICE,
			<cfelse>
				PS.PRICE AS PR_PRICE,
			</cfif>
			GT.SALEABLE_STOCK
		FROM
			PRODUCT P
			LEFT JOIN PRODUCT_BRANDS PB ON P.BRAND_ID = PB.BRAND_ID,
            STOCKS S,
			PRICE_STANDART PS,
			PRODUCT_CAT PC,
			PRODUCT_UNIT PU,
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				#dsn3_alias#.PRICE PR,
			</cfif>
				#dsn2_alias#.GET_STOCK_LAST GT
		WHERE
			P.PRODUCT_ID=S.PRODUCT_ID AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid eq -1)>
				PS.PURCHASESALES = 0 AND
			<cfelse>
				PS.PURCHASESALES = 1 AND
			</cfif>
			P.PRODUCT_STATUS = 1 AND
			<cfif isdefined("session.pp")>
				P.IS_EXTRANET = 1 AND
			<cfelseif isdefined("session.ww")>
				P.IS_INTERNET = 1 AND
			</cfif>
			PS.PRICESTANDART_STATUS = 1 AND
			P.PRODUCT_ID = PS.PRODUCT_ID AND
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			P.PRODUCT_ID = PU.PRODUCT_ID AND
			PU.IS_MAIN=1 AND
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
				PR.PRODUCT_ID = P.PRODUCT_ID AND
				ISNULL(PR.STOCK_ID,0)=0 AND
				ISNULL(PR.SPECT_VAR_ID,0)=0 AND
				PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
				PR.STARTDATE <= #now()# AND
				(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
			</cfif>
			P.PRODUCT_ID = GT.PRODUCT_ID
	</cfquery>
	<cfif (isdefined("attributes.company_id") and len(attributes.company_id)) or (isdefined("attributes.consumer_id") and len(attributes.consumer_id))>
		<cfquery name="GET_PRICE_EXCEPTIONS_ALL" datasource="#DSN3#">
			SELECT
				PRODUCT_ID,
                PRODUCT_CATID,
                BRAND_ID
			FROM
				PRICE_CAT_EXCEPTIONS
			WHERE
				ACT_TYPE = 1 AND
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
		</cfquery>
		<cfquery name="GET_PRICE_EXCEPTIONS_PID" dbtype="query">
			SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_ID IS NOT NULL
		</cfquery>
		<cfquery name="GET_PRICE_EXCEPTIONS_PCATID" dbtype="query">
			SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_CATID IS NOT NULL
		</cfquery>
		<cfquery name="GET_PRICE_EXCEPTIONS_BRID" dbtype="query">
			SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE BRAND_ID IS NOT NULL
		</cfquery>
		<cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount or get_price_exceptions_brid.recordcount>
            <cfquery name="GET_PRICE_ALL" datasource="#DSN3#">
                <cfif get_price_exceptions_pid.recordcount>
                    SELECT
                        CATALOG_ID,
                        UNIT,
                        PRICE,
                        PRICE_KDV,
                        PRODUCT_ID,
                        MONEY,
                        PRICE_CATID
                    FROM
                        PRICE
                    WHERE
                        PRICE > 0 AND
                        ISNULL(STOCK_ID,0)=0 AND
                        ISNULL(SPECT_VAR_ID,0)=0 AND
                        STARTDATE <= #now()# AND
                        (FINISHDATE >= #now()# OR FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_pid.recordcount gt 1>(</cfif>
                            <cfoutput query="get_price_exceptions_pid">
                            (PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
                            <cfif get_price_exceptions_pid.recordcount neq get_price_exceptions_pid.currentrow>
                            OR
                            </cfif>
                            </cfoutput>
                        <cfif get_price_exceptions_pid.recordcount gt 1>)</cfif>
                </cfif>
                <cfif get_price_exceptions_pcatid.recordcount>
                    <cfif get_price_exceptions_pid.recordcount>
                    	UNION
                    </cfif>
                    SELECT
                        P.CATALOG_ID,
                        P.UNIT,
                        P.PRICE PRICE,
                        P.PRICE_KDV,
                        P.PRODUCT_ID,
                        P.MONEY,
                        P.PRICE_CATID
                    FROM
                        PRICE P,
                        PRODUCT PR
                    WHERE
                        PRICE > 0 AND
                        <cfif get_price_exceptions_pid.recordcount>
                        P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
                        </cfif>
                        P.PRODUCT_ID = PR.PRODUCT_ID AND
                        ISNULL(P.STOCK_ID,0)=0 AND
                        ISNULL(P.SPECT_VAR_ID,0)=0 AND
                        P.STARTDATE <= #now()# AND
                        (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_pcatid.recordcount gt 1>(</cfif>
							<cfoutput query="get_price_exceptions_pcatid">
                            (PR.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_catid#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
							<cfif get_price_exceptions_pcatid.recordcount neq get_price_exceptions_pcatid.currentrow>
                                OR
                            </cfif>
                        	</cfoutput>
                        <cfif get_price_exceptions_pcatid.recordcount gt 1>)</cfif>
                </cfif>
                <cfif get_price_exceptions_brid.recordcount>
                    <cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount>
                    	UNION
                    </cfif>
                    SELECT
                        P.CATALOG_ID,
                        P.UNIT,
                        P.PRICE PRICE,
                        P.PRICE_KDV,
                        P.PRODUCT_ID,
                        P.MONEY,
                        P.PRICE_CATID
                    FROM
                        PRICE P,
                        PRODUCT PR
                    WHERE
                        PRICE > 0 AND
                        <cfif get_price_exceptions_pid.recordcount>
                        P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
                        </cfif>
                        <cfif get_price_exceptions_pcatid.recordcount>
                        PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
                        </cfif>
                        P.PRODUCT_ID = PR.PRODUCT_ID AND
                        ISNULL(P.STOCK_ID,0)=0 AND
                        ISNULL(P.SPECT_VAR_ID,0)=0 AND
                        P.STARTDATE <= #now()# AND
                        (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>
                        <cfoutput query="get_price_exceptions_brid">
                        	(PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#brand_id#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
                        	<cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
                        		OR
                        	</cfif>
                        </cfoutput>
                        <cfif get_price_exceptions_brid.recordcount gt 1>)</cfif>
                </cfif>
            </cfquery>
		</cfif>
	</cfif>
    <cfquery name="GET_PRODUCT_CONTENT_ALL" datasource="#DSN#">
        SELECT
            C.CONT_HEAD,
            C.CONT_BODY,
            C.CONT_SUMMARY,
            C.CONTENT_ID,
            PCR.ACTION_TYPE_ID AS PRODUCT_ID
        FROM
            CONTENT C,
            CONTENT_RELATION PCR
        WHERE
            C.CONTENT_ID = PCR.CONTENT_ID AND
            PCR.ACTION_TYPE_ID IS NOT NULL AND
            PCR.ACTION_TYPE = 'PRODUCT_ID'
    </cfquery>
    <cfquery name="GET_PRODUCT_ASSET_ALL" datasource="#DSN#">
        SELECT
            ACTION_ID,
            ASSET_NAME,
            MODULE_NAME,
            ASSET_FILE_NAME
        FROM
            ASSET
        WHERE
            ACTION_SECTION = 'PRODUCT_ID' AND
            IS_INTERNET  = 1
        ORDER BY
            ACTION_ID
    </cfquery>
	<cfscript>
		GET_PRODUCT_IMAGE_ALL=cfquery(SQLString:'SELECT PIMG.PATH,PIMG.PATH_SERVER_ID,PIMG.PRODUCT_ID FROM PRODUCT_IMAGES PIMG',Datasource:DSN1,is_select:1);
		GET_STOCK_STRATEGY_ALL=cfquery(SQLString:'SELECT PROVISION_TIME,PRODUCT_ID,STOCK_ID FROM STOCK_STRATEGY WHERE DEPARTMENT_ID IS NULL',Datasource:DSN3,is_select:1);
		GET_PRODUCT_GUARANTY_ALL=cfquery(SQLString:'SELECT * FROM PRODUCT_GUARANTY',Datasource:DSN3,is_select:1);
		GET_PRODUCT_PROPERTY_ALL=cfquery(SQLString:'SELECT PRODUCT_DT_PROPERTIES.PRODUCT_ID,PRODUCT_DT_PROPERTIES.DETAIL,PRODUCT_PROPERTY.PROPERTY,PRODUCT_PROPERTY.PROPERTY_ID,PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL FROM PRODUCT_DT_PROPERTIES,PRODUCT_PROPERTY,PRODUCT_PROPERTY_DETAIL WHERE PRODUCT_PROPERTY.IS_ACTIVE = 1 AND PRODUCT_PROPERTY_DETAIL.IS_ACTIVE = 1 AND PRODUCT_DT_PROPERTIES.VARIATION_ID = PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID AND PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID AND PRODUCT_PROPERTY_DETAIL.PRPT_ID = PRODUCT_PROPERTY.PROPERTY_ID',Datasource:DSN1,is_select:1);

		upload_folder = "#upload_folder#product#dir_seperator#";
		file_name = "product_price.xml";
		my_doc_2 = XmlNew();
		my_doc_2.xmlRoot = XmlElemNew(my_doc_2,"PRODUCTLIST");
		for (k = 1; k lte GET_PRODUCT_PRICE.RECORDCOUNT; k = k + 1)
		{
			GET_PRODUCT_IMAGE=cfquery(SQLString:'SELECT PATH,PATH_SERVER_ID FROM GET_PRODUCT_IMAGE_ALL WHERE PRODUCT_ID = '&GET_PRODUCT_PRICE.PRODUCT_ID[k],datasource:'',dbtype:'query',is_select:1);
			GET_PRODUCT_CONTENT=cfquery(SQLString:'SELECT * FROM get_product_content_all WHERE PRODUCT_ID = '&GET_PRODUCT_PRICE.PRODUCT_ID[k],datasource:'',dbtype:'query',is_select:1);
			GET_STOCK_STRATEGY=cfquery(SQLString:'SELECT PROVISION_TIME FROM GET_STOCK_STRATEGY_ALL WHERE STOCK_ID = '&GET_PRODUCT_PRICE.STOCK_ID[k],Datasource:'',dbtype:'query',is_select:1);
			GET_PRODUCT_GUARANTY=cfquery(SQLString:'SELECT * FROM GET_PRODUCT_GUARANTY_ALL WHERE PRODUCT_ID = '&GET_PRODUCT_PRICE.PRODUCT_ID[k],Datasource:'',dbtype:'query',is_select:1);
			GET_PRODUCT_PROPERTY=cfquery(SQLString:'SELECT * FROM GET_PRODUCT_PROPERTY_ALL WHERE PRODUCT_ID = '&GET_PRODUCT_PRICE.PRODUCT_ID[k],Datasource:'',dbtype:'query',is_select:1);
			GET_PRODUCT_ASSET=cfquery(SQLString:'SELECT * FROM GET_PRODUCT_ASSET_ALL WHERE ACTION_ID = '&GET_PRODUCT_PRICE.PRODUCT_ID[k],Datasource:'',dbtype:'query',is_select:1);
			my_doc_2.xmlRoot.XmlChildren[k] = XmlElemNew(my_doc_2,"PRODUCT");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[1] = XmlElemNew(my_doc_2,"UrunID");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[1].XmlText = GET_PRODUCT_PRICE.PRODUCT_ID[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[2] = XmlElemNew(my_doc_2,"StokID");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[2].XmlText = GET_PRODUCT_PRICE.STOCK_ID[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[3] = XmlElemNew(my_doc_2,"UrunAdi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[3].XmlText = GET_PRODUCT_PRICE.PRODUCT_NAME[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[4] = XmlElemNew(my_doc_2,"UrunKodu");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[4].XmlText = GET_PRODUCT_PRICE.PRODUCT_CODE[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[5] = XmlElemNew(my_doc_2,"StokKodu");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[5].XmlText = GET_PRODUCT_PRICE.STOCK_CODE[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[6] = XmlElemNew(my_doc_2,"StokAdedi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[6].XmlText = GET_PRODUCT_PRICE.SALEABLE_STOCK[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[7] = XmlElemNew(my_doc_2,"OzelFiyat");
			if(isdefined("get_price_all"))
			{
				GET_PRODUCT_PRICE=cfquery(SQLString:'SELECT PRICE FROM GET_PRICE_ALL WHERE PRODUCT_ID='&GET_PRODUCT_PRICE.PRODUCT_ID[k],datasource:'',dbtype:'query',is_select:1);
				special_price=GET_PRODUCT_PRICE.PRICE;
			}else
			{
				special_price="";
			}
			if(len(special_price))
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[7].XmlText = special_price;
			else
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[7].XmlText = GET_PRODUCT_PRICE.PR_PRICE[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[8] = XmlElemNew(my_doc_2,"ListeFiyat");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[8].XmlText = GET_PRODUCT_PRICE.PR_PRICE[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[9] = XmlElemNew(my_doc_2,"SonKullaniciFiyat");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[9].XmlText = GET_PRODUCT_PRICE.PRICE[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[10] = XmlElemNew(my_doc_2,"Kur");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[10].XmlText = GET_PRODUCT_PRICE.MONEY[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[11] = XmlElemNew(my_doc_2,"KDV");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[11].XmlText = GET_PRODUCT_PRICE.TAX[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[12] = XmlElemNew(my_doc_2,"KategoriAdi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[12].XmlText = GET_PRODUCT_PRICE.PRODUCT_CAT[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[13] = XmlElemNew(my_doc_2,"EanCode");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[13].XmlText = GET_PRODUCT_PRICE.BARCOD[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[14] = XmlElemNew(my_doc_2,"Marka");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[14].XmlText = GET_PRODUCT_PRICE.BRAND_NAME[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[15] = XmlElemNew(my_doc_2,"StokGelisTarih");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[15].XmlText = "";

			//imajlar
			rw =1;
			if(GET_PRODUCT_IMAGE.RECORDCOUNT)
			{
				if(GET_PRODUCT_IMAGE.RECORDCOUNT gt 5) rw_count=5; else rw_count=GET_PRODUCT_IMAGE.RECORDCOUNT;
				for (rw = 1; rw lte rw_count; rw = rw + 1)
				{
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[15+rw] = XmlElemNew(my_doc_2,"ImageName#rw#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[15+rw].XmlText = "http://#machine_name#/documents/product/#GET_PRODUCT_IMAGE.PATH[rw]#";
				}
			}
			for (rw_2 = rw; rw_2 lte 5; rw_2 = rw_2 + 1)
			{
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[15+rw_2] = XmlElemNew(my_doc_2,"ImageName#rw_2#");
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[15+rw_2].XmlText = "";
			}

			//icerikler
			rw =1;
			if(GET_PRODUCT_CONTENT.RECORDCOUNT)
			{
				if(GET_PRODUCT_CONTENT.RECORDCOUNT gt 5) rw_count=5; else rw_count=GET_PRODUCT_CONTENT.RECORDCOUNT;
				for (rw = 1; rw lte rw_count; rw = rw + 1)
				{
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[21+((rw-1)*4)] = XmlElemNew(my_doc_2,"ContentID#rw#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[21+((rw-1)*4)].XmlText = "#GET_PRODUCT_CONTENT.CONTENT_ID[rw]#";
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[22+((rw-1)*4)] = XmlElemNew(my_doc_2,"ContentHead#rw#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[22+((rw-1)*4)].XmlText = "#GET_PRODUCT_CONTENT.CONT_HEAD[rw]#";
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[23+((rw-1)*4)] = XmlElemNew(my_doc_2,"ContentSummary#rw#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[23+((rw-1)*4)].XmlText = "#GET_PRODUCT_CONTENT.CONT_SUMMARY[rw]#";
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[24+((rw-1)*4)] = XmlElemNew(my_doc_2,"ContentBody#rw#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[24+((rw-1)*4)].XmlText = "#GET_PRODUCT_CONTENT.CONT_BODY[rw]#";
				}
			}
			for (rw_2 = rw; rw_2 lte 5; rw_2 = rw_2 + 1)
				{
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[21+((rw_2-1)*4)] = XmlElemNew(my_doc_2,"ContentID#rw_2#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[21+((rw_2-1)*4)].XmlText = "";
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[22+((rw_2-1)*4)] = XmlElemNew(my_doc_2,"ContentHead#rw_2#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[22+((rw_2-1)*4)].XmlText = "";
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[23+((rw_2-1)*4)] = XmlElemNew(my_doc_2,"ContentSummary#rw_2#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[23+((rw_2-1)*4)].XmlText = "";
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[24+((rw_2-1)*4)] = XmlElemNew(my_doc_2,"ContentBody#rw_2#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[24+((rw_2-1)*4)].XmlText = "";
				}

			//ozellik
			if(GET_PRODUCT_PROPERTY.RECORDCOUNT)
			{
				for(pro_rw=1;pro_rw lte GET_PRODUCT_PROPERTY.RECORDCOUNT;pro_rw=pro_rw+1)
					product_detail = product_detail&"    "&GET_PRODUCT_PROPERTY.PROPERTY[pro_rw]&" = "&GET_PRODUCT_PROPERTY.PROPERTY_DETAIL[pro_rw]&" : "&GET_PRODUCT_PROPERTY.DETAIL[pro_rw];
			}
			else
			{
				product_detail = "";
			}
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[40] = XmlElemNew(my_doc_2,"UrunAciklamasi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[40].XmlText = product_detail;
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[41] = XmlElemNew(my_doc_2,"Desi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[41].XmlText = GET_PRODUCT_PRICE.DIMENTION[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[42] = XmlElemNew(my_doc_2,"Birim");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[42].XmlText = GET_PRODUCT_PRICE.MAIN_UNIT[k];
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[43] = XmlElemNew(my_doc_2,"TedarikSuresi");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[43].XmlText = GET_STOCK_STRATEGY.PROVISION_TIME;
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[44] = XmlElemNew(my_doc_2,"Garanti");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[44].XmlText = "";//iif(len(GET_PRODUCT_GUARANTY.SUPPORT_DURATION),30,11);
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[45] = XmlElemNew(my_doc_2,"GarantiAciklama");
			my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[45].XmlText = "";

			//varliklar
			rw =1;
			if(GET_PRODUCT_ASSET.RECORDCOUNT)
			{
				if(GET_PRODUCT_ASSET.RECORDCOUNT gt 5) rw_count=5; else rw_count=GET_PRODUCT_ASSET.RECORDCOUNT;
				for (rw = 1; rw lte rw_count; rw = rw + 1)
				{
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[46+((rw-1)*2)] = XmlElemNew(my_doc_2,"AssetName#rw#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[46+((rw-1)*2)].XmlText = "http://#machine_name#/documents/product/#GET_PRODUCT_ASSET.ASSET_NAME[rw]#";
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[47+((rw-1)*2)] = XmlElemNew(my_doc_2,"AssetFile#rw#");
					my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[47+((rw-1)*2)].XmlText = "http://#machine_name#/documents/#GET_PRODUCT_ASSET.module_name[rw]#/#GET_PRODUCT_ASSET.asset_file_name[rw]#";
				}
			}
			for (rw_2 = rw; rw_2 lte 5; rw_2 = rw_2 + 1)
			{
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[46+((rw_2-1)*2)] = XmlElemNew(my_doc_2,"AssetName#rw_2#");
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[46+((rw_2-1)*2)].XmlText = "";
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[47+((rw_2-1)*2)] = XmlElemNew(my_doc_2,"AssetFile#rw_2#");
				my_doc_2.xmlRoot.XmlChildren[k].XmlChildren[47+((rw_2-1)*2)].XmlText = "";
			}
		}
	</cfscript>
	<cffile action="write" file="#upload_folder##file_name#" output="#toString(my_doc_2)#" charset="utf-8">
</cfif>
</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">
<cfheader name="Content-Disposition" value="attachment;filename=#download_folder#documents#dir_seperator#product#dir_seperator##file_name#">
<cfcontent file="#download_folder#documents#dir_seperator#product#dir_seperator##file_name#" type="application/octet-stream" deletefile="no">
