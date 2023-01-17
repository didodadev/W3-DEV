<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1 and isdefined('attributes.price_catid') and attributes.price_catid gt 0>
	<cfquery name="GET_STOCK_SPEC_PRICE" datasource="#DSN3#">
		SELECT
			(CAST(PR.STOCK_ID AS NVARCHAR(50))+ '_'+CAST(PR.UNIT AS NVARCHAR(50))) AS STOCK_UNIT,
			PR.SPECT_VAR_ID
		FROM
			PRICE PR
		WHERE
			PR.STOCK_ID IS NOT NULL
			AND PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">
			AND PR.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			AND (PR.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PR.FINISHDATE IS NULL)
			AND ISNULL(PR.CATALOG_ID,0) IN (SELECT 0 CATALOG_ID UNION ALL SELECT CATALOG_ID FROM CATALOG_PROMOTION WHERE CATALOG_STATUS = 1)
	</cfquery>
</cfif>
<cfquery name="PRODUCTS" datasource="#DSN3#">
	WITH CTE1 AS (
	SELECT 
    <cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
        <cfif is_lot_no_based eq 1> 
		SUM(SR.STOCK_IN - SR.STOCK_OUT) PRODUCT_STOCK, 
       <cfelse>
  		 GS.PRODUCT_STOCK,
        </cfif>
  	<cfelse>
        GS.PRODUCT_STOCK,
  	 </cfif>
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PROPERTY,
		STOCKS.BARCOD,
		PRODUCT.IS_INVENTORY,
        PRODUCT.SHORT_CODE_ID,
		PRODUCT.IS_PRODUCTION,
		--PRODUCT.PRODUCT_NAME,
		#dsn_alias#.Get_Dynamic_Language(PRODUCT.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT.PRODUCT_NAME) AS PRODUCT_NAME,
		PRODUCT.PRODUCT_CODE,
		STOCKS.STOCK_CODE_2 PRODUCT_CODE_2,
		STOCKS.STOCK_CODE_2,
		PRODUCT.PRODUCT_DETAIL,
		<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 0>
			PRODUCT.TAX_PURCHASE AS TAX,
		<cfelse>
			PRODUCT.TAX AS TAX,
		</cfif>
		PRODUCT.OTV,
		PRODUCT.OIV,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.IS_SERIAL_NO,
		STOCKS.MANUFACT_CODE,
	<cfif attributes.price_catid gt 0>
		PRICE.PRICE,
		PRICE.MONEY,
		PRICE.PRICE_CATID,
		PRICE.CATALOG_ID,
	<cfelse>
		PRICE_STANDART.PRICE,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN PRICE_STANDART.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
		<cfelse>
			PRICE_STANDART.MONEY,
		</cfif> 
		-1 AS PRICE_CATID,
		'' AS CATALOG_ID,
	</cfif>			
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.UNIT_ID,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER
		<!--- 1 AS Q_TYPE --->
	<cfif  len(evaluate("attributes.company_id"))>
		,
		CPP.DISCOUNT1,
		CPP.DISCOUNT2,
		CPP.DISCOUNT3,
		CPP.DISCOUNT4,
		CPP.DISCOUNT5,
		CPP.PAYMETHOD_ID,
		CPP.DELIVERY_DATENO,
		CPP.COMPANY_ID,
		CPP.CONTRACT_ID
	<cfelse>
		,
		0 AS DISCOUNT1,
		0 AS DISCOUNT2,
		0 AS DISCOUNT3,
		0 AS DISCOUNT4,
		0 AS DISCOUNT5,
		-100 AS PAYMETHOD_ID,
		0 AS DELIVERY_DATENO,		
		PRODUCT.COMPANY_ID,
		-1 AS CONTRACT_ID		
	</cfif>
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
		,GS.SPECT_VAR_ID
		</cfif>	
        <cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
        <cfif is_lot_no_based eq 1>			
			,LOT_NO
		</cfif>
        </cfif>
	FROM
		PRODUCT
        <cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
            LEFT JOIN  <!--- alt barkoda göre arama yapmak için --->
                             (
                                SELECT D5.PRODUCT_ID,
                                stuff( (
                                                SELECT 
                                                    ';'+GET_STOCK_BARCODES.BARCODE AS BARCODE
                                                           
                                                    FROM 
                                                        #dsn3_alias#.GET_STOCK_BARCODES
                                                    WHERE
                                                        GET_STOCK_BARCODES.PRODUCT_ID = D5.PRODUCT_ID 
                                                        AND GET_STOCK_BARCODES.BARCODE = '#attributes.keyword#'
                                               FOR XML PATH(''), TYPE).value('.', 'varchar(100)'),1,1,'')
                                       AS MY_BARCODE
                                       FROM 
                                       PRODUCT D5
                                ) AS DD5
                             ON
                                DD5.PRODUCT_ID = PRODUCT.PRODUCT_ID
            </cfif>
                ,
		<!--- PRODUCT_CAT, --->
		STOCKS
        <cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
        <cfif is_lot_no_based eq 1>
		LEFT JOIN #dsn2_alias#.STOCKS_ROW SR ON STOCKS.STOCK_ID = SR.STOCK_ID 
		</cfif>
        </cfif>
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
		LEFT JOIN #dsn2_alias#.GET_STOCK_SPECT GS ON GS.STOCK_ID = STOCKS.STOCK_ID
		<cfelse>
		LEFT JOIN #dsn2_alias#.GET_STOCK GS ON GS.STOCK_ID = STOCKS.STOCK_ID
		</cfif>
		,PRODUCT_UNIT,
	<cfif len(evaluate("attributes.company_id"))>CONTRACT_PURCHASE_PROD_DISCOUNT CPP,</cfif>
	<cfif attributes.price_catid gt 0>
		PRICE, PRICE_CAT
	<cfelse>
		PRICE_STANDART
	</cfif>			
	WHERE   
	<cfif len(attributes.serial_number) and listlen(seri_stock_id_list)>
		STOCKS.STOCK_ID IN (#seri_stock_id_list#) AND
	<cfelseif len(attributes.serial_number) and not listlen(seri_stock_id_list)>
		STOCKS.STOCK_ID IS NULL AND
	</cfif>
    <cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount or get_price_exceptions_brid.recordcount OR GET_PRICE_EXCEPTIONS_SHORTCODE.RECORDCOUNT>
			<cfif get_price_exceptions_pid.recordcount>
			PRODUCT.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
			</cfif>
			<cfif get_price_exceptions_pcatid.recordcount>
			 PRODUCT.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
			</cfif>
			<cfif get_price_exceptions_brid.recordcount>
			 ( PRODUCT.BRAND_ID NOT IN (#valuelist(get_price_exceptions_brid.BRAND_ID)#) OR PRODUCT.BRAND_ID IS NULL ) AND
			</cfif>
            <cfif get_price_exceptions_shortcode.recordcount>
			( PRODUCT.SHORT_CODE_ID NOT IN (#valuelist(get_price_exceptions_shortcode.SHORT_CODE_ID)#) OR PRODUCT.SHORT_CODE_ID IS NULL ) AND
			</cfif>
		</cfif>
	<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id) and len(attributes.list_variation_id)>
		PRODUCT.PRODUCT_ID IN
		(
			SELECT
				PRODUCT_ID
			FROM
				#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
			WHERE
				(
			  <cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_index">
				(PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_property_id,pro_index,",")#"> AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_variation_id,pro_index,",")#">)
				<cfif pro_index lt listlen(attributes.list_property_id,',')>OR</cfif>
			  </cfloop>
				)
			GROUP BY
				PRODUCT_ID
			HAVING
				COUNT(PRODUCT_ID)> = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(attributes.list_property_id,',')#">
		) AND
	</cfif>
	<cfif len(evaluate("attributes.company_id"))>CPP.PRODUCT_ID = PRODUCT.PRODUCT_ID AND</cfif>
		PRODUCT.PRODUCT_STATUS = 1 AND 	
		STOCKS.STOCK_STATUS = 1 AND
		PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 		
		<!--- PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND --->
	<cfif not isdefined('attributes.is_condition_sale_or_purchase')><!--- alış veya satış olsada bu deger geldi ise urunlerin alış veya satışlarına bakmaz --->
		<cfif not isdefined("attributes.sepet_process_type") or listfind('-1,73,74,75,76,77,78,80,81,811,761,82,84,86,87',attributes.sepet_process_type,',') or (isdefined('attributes.int_basket_id') and listfind('6,7,20,39',attributes.int_basket_id) )>
			PRODUCT.IS_PURCHASE=1 AND
		</cfif>
	</cfif>
		PRODUCT_UNIT.IS_MAIN =1 
	<cfif attributes.price_catid lt 0>
		AND PRICE_STANDART.PRICESTANDART_STATUS = 1			
	</cfif>
    <cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
        AND PRODUCT.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
    </cfif>	
	<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1 and isdefined("attributes.project_id") and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
		<!--- xml de proje filtresi secilmisse, secilen projenin masraf merkezine baglı urunler listelenir --->
		AND PRODUCT.PRODUCT_ID IN (
									SELECT 
										DISTINCT CP.PRODUCT_ID
									FROM
										#dsn3_alias#.PRODUCT_PERIOD CP,
										#dsn2_alias#.EXPENSE_CENTER EXC,
										#dsn_alias#.PRO_PROJECTS PRJ
									WHERE
										CP.PRODUCT_ID =PRODUCT.PRODUCT_ID
										AND CP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
										AND PRJ.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
										AND (CP.EXPENSE_CENTER_ID=EXC.EXPENSE_ID OR CP.COST_EXPENSE_CENTER_ID=EXC.EXPENSE_ID)
										AND SUBSTRING(PRJ.EXPENSE_CODE,1,3) = EXC.EXPENSE_CODE
									)
	</cfif>
	<cfif attributes.price_catid gt 0><!--- dinamik bir fiyat kategorisi istenmisse --->
		AND PRICE_CAT.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">			
		AND	PRICE_CAT.PRICE_CAT_STATUS = 1
		AND PRICE.PRODUCT_ID = STOCKS.PRODUCT_ID
		<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1><!--- stok ve spec bazında fiyatlar getirilecekse --->
			<cfif GET_STOCK_SPEC_PRICE.recordcount gt 0>
				AND 
				(
					<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
					PRICE.SPECT_VAR_ID=GS.SPECT_VAR_ID
					OR
					</cfif>
					(
						ISNULL(PRICE.SPECT_VAR_ID,0)=0
						AND ISNULL(PRICE.STOCK_ID,0)=STOCKS.STOCK_ID
					)
					OR
					(
						ISNULL(PRICE.SPECT_VAR_ID,0)=0
						AND ((ISNULL(PRICE.STOCK_ID,0) = STOCKS.STOCK_ID AND PRICE.STOCK_ID IS NOT NULL) OR (ISNULL(PRICE.STOCK_ID,0) = 0 AND PRICE.STOCK_ID IS NULL))
						AND (CAST(STOCKS.STOCK_ID AS NVARCHAR(50))+'_'+CAST(PRODUCT_UNIT.PRODUCT_UNIT_ID AS NVARCHAR(50))) NOT IN (
						SELECT
							(CAST(PR.STOCK_ID AS NVARCHAR(50))+ '_'+CAST(PR.UNIT AS NVARCHAR(50)))
						FROM
							PRICE PR
						WHERE
							PR.STOCK_ID IS NOT NULL
							AND PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">
							AND PR.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							AND (PR.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PR.FINISHDATE IS NULL)
							AND ISNULL(PR.CATALOG_ID,0) IN (SELECT 0 CATALOG_ID UNION ALL SELECT CATALOG_ID FROM CATALOG_PROMOTION WHERE CATALOG_STATUS = 1)
						) 
					) 
				)				
			</cfif>
		<cfelse>
			AND ((ISNULL(PRICE.STOCK_ID,0) = STOCKS.STOCK_ID AND PRICE.STOCK_ID IS NOT NULL) OR (ISNULL(PRICE.STOCK_ID,0) = 0 AND PRICE.STOCK_ID IS NULL))
			AND ISNULL(PRICE.SPECT_VAR_ID,0)=0
		</cfif>
		AND	PRICE_CAT.PRICE_CATID = PRICE.PRICE_CATID
		AND PRICE.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		AND (PRICE.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PRICE.FINISHDATE IS NULL)
		AND ISNULL(PRICE.CATALOG_ID,0) IN (SELECT 0 CATALOG_ID UNION ALL SELECT CATALOG_ID FROM CATALOG_PROMOTION WHERE CATALOG_STATUS = 1)
		AND PRICE.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID
		AND PRICE.UNIT = STOCKS.PRODUCT_UNIT_ID
	<cfelseif attributes.price_catid eq '-1'><!--- Standart alis Fiyatlari Default Gelsin --->
		AND PRICE_STANDART.PURCHASESALES = 0
		AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
		<!--- AND PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID ---><!--- bu satirin calismasi icin ürüne yeni bir varyasyonun eklenmis olmali, bu da stocks da birimiyle gözükür. --->
		AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
	<cfelse>
		AND PRICE_STANDART.PURCHASESALES = 0
		AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
		<!--- AND PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID --->
		AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
	</cfif>
	<cfif len(attributes.company_id)>
		AND CPP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfif>
	<cfif len(attributes.product_cat) and len(attributes.product_catid)>
		AND PRODUCT.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=#attributes.product_catid#)+'.%' <!---kategori hiyerarşisine gore arama yapıyor --->
	</cfif>
	<cfif len(attributes.employee) and len(attributes.pos_code)>
		AND PRODUCT.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
	</cfif>
	<cfif len(attributes.get_company) and len(attributes.get_company_id)>
		AND PRODUCT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_company_id#">
	</cfif>
	<cfif len(attributes.brand_id) and len(attributes.brand_name)>
		AND PRODUCT.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
	</cfif>
	<cfif isDefined("attributes.manufact_code") and len(attributes.manufact_code)>
		AND	STOCKS.MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.manufact_code)#">
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
		AND
			(
				(	STOCKS.STOCK_CODE LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%' OR
					STOCKS.STOCK_CODE_2 LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%' OR
					PRODUCT.PRODUCT_DETAIL LIKE '#attributes.keyword#%' OR
					PRODUCT.PRODUCT_CODE_2 LIKE '#attributes.keyword#%' OR
					<!---PRODUCT.PRODUCT_ID IN (SELECT PRODUCT_ID FROM GET_STOCK_BARCODES WHERE BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">) OR--->
					PRODUCT.PRODUCT_NAME + ' ' + STOCKS.PROPERTY LIKE #sql_unicode()#'%#attributes.keyword#%' OR
					STOCKS.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
				OR STOCKS.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> 
				OR STOCKS.MANUFACT_CODE LIKE '#trim(attributes.keyword)#'
				<cfif listfind("17,15,11,37",attributes.int_basket_id)>
					OR PRODUCT.BRAND_ID IN (SELECT BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
				</cfif>
			)
	<cfelseif isDefined("attributes.keyword") and len(attributes.keyword) eq 1>
		AND	PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'#attributes.keyword#%' 
	</cfif>
	<cfif isdefined('attributes.is_store_module') and ( (isdefined('attributes.sepet_process_type') and listfind('49,51,52,54,55,59,591,60,601,63,73,74,75,76,77,80,82,86,87',attributes.sepet_process_type)) or (isdefined('attributes.int_basket_id') and listfind('6,39',attributes.int_basket_id) ) )>
		AND PRODUCT.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH PB WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#"> )
	</cfif>
	<cfif isdefined("sepet_process_type") and not listfind('-1,140',sepet_process_type,',')>
		<cfif ListFind("60,601",sepet_process_type)><!--- 56,58,63, envantere dahil olsada ürünler gelsin kapatılan işlem tiplerinde çünkü artık ürünlerin bu işlem tipleri için muhasebe kodları var--->
			AND PRODUCT.IS_INVENTORY = 0
		</cfif>
	</cfif>
	<cfif isdefined("sepet_process_type") and not listfind('591,140',sepet_process_type,',')>
		<cfif ListFind("52,53,54,55,59,70,71,73,74,75,76,80,81,86,114",sepet_process_type)>
			AND PRODUCT.IS_INVENTORY = 1
		<cfelseif ListFind("60,601",sepet_process_type)>
			AND PRODUCT.IS_INVENTORY = 0
		</cfif>
	</cfif>
    <cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
<cfif is_lot_no_based eq 1>
GROUP BY
STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		PRODUCT.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PROPERTY,
		STOCKS.BARCOD,
		PRODUCT.IS_INVENTORY,
        PRODUCT.SHORT_CODE_ID,
		PRODUCT.IS_PRODUCTION,
		PRODUCT.PRODUCT_NAME,
		PRODUCT.PRODUCT_CODE,
		STOCKS.STOCK_CODE_2 ,
		STOCKS.STOCK_CODE_2,
		PRODUCT.PRODUCT_DETAIL,
		<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 0>
			PRODUCT.TAX_PURCHASE,
		<cfelse>
			PRODUCT.TAX,
		</cfif>
		PRODUCT.OTV,
		PRODUCT.OIV,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.IS_SERIAL_NO,
		STOCKS.MANUFACT_CODE,
	<cfif attributes.price_catid gt 0>
		PRICE.PRICE,
		PRICE.MONEY,
		PRICE.PRICE_CATID,
		PRICE.CATALOG_ID,
	<cfelse>
		PRICE_STANDART.PRICE,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN PRICE_STANDART.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY,
		<cfelse>
			PRICE_STANDART.MONEY,
		</cfif> 
	</cfif>			
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.UNIT_ID,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER
		<!--- 1 AS Q_TYPE --->
	<cfif  len(evaluate("attributes.company_id"))>
		,
		CPP.DISCOUNT1,
		CPP.DISCOUNT2,
		CPP.DISCOUNT3,
		CPP.DISCOUNT4,
		CPP.DISCOUNT5,
		CPP.PAYMETHOD_ID,
		CPP.DELIVERY_DATENO,
		CPP.COMPANY_ID,
		CPP.CONTRACT_ID
	<cfelse>
		,				
		PRODUCT.COMPANY_ID
	</cfif>
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
		,GS.SPECT_VAR_ID
		</cfif>	
        <cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
        <cfif is_lot_no_based eq 1>			
			,LOT_NO
		</cfif>
        </cfif>
</cfif>
</cfif>
<cfif len(attributes.company_id)>
	UNION 
		SELECT  
			<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
        <cfif is_lot_no_based eq 1> 
		SUM(SR.STOCK_IN - SR.STOCK_OUT) PRODUCT_STOCK, 
         <cfelse>
   GS.PRODUCT_STOCK,
        </cfif>
        <cfelse>
        GS.PRODUCT_STOCK,
  
   </cfif>
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			PRODUCT.IS_INVENTORY,
            PRODUCT.SHORT_CODE_ID,
			PRODUCT.IS_PRODUCTION,
			PRODUCT.PRODUCT_NAME,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.PRODUCT_CODE_2,
			STOCKS.STOCK_CODE_2,
			PRODUCT.PRODUCT_DETAIL,
			<cfif isdefined('attributes.sepet_process_type') and attributes.sepet_process_type eq 591>
				0 AS TAX,
			<cfelse>
				PRODUCT.TAX_PURCHASE AS TAX,
			</cfif>
			PRODUCT.OTV,
			PRODUCT.OIV,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.IS_SERIAL_NO,
			STOCKS.MANUFACT_CODE,
		<cfif attributes.price_catid gt 0>
			PRICE.PRICE,
			PRICE.MONEY,
			PRICE.PRICE_CATID,
			PRICE.CATALOG_ID,
		<cfelse>
			PRICE_STANDART.PRICE,
			<cfif session.ep.period_year lt 2009>
				CASE WHEN PRICE_STANDART.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
			<cfelse>
				PRICE_STANDART.MONEY,
			</cfif> 
			-1 AS PRICE_CATID,
			'' AS CATALOG_ID,
		</cfif>			
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.UNIT_ID,
			PRODUCT_UNIT.PRODUCT_UNIT_ID,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.MULTIPLIER,
			<!--- 2 AS Q_TYPE, --->
			0 AS DISCOUNT1,
			0 AS DISCOUNT2,
			0 AS DISCOUNT3,
			0 AS DISCOUNT4,
			0 AS DISCOUNT5,
			-100 AS PAYMETHOD_ID,
			0 AS DELIVERY_DATENO,		
			PRODUCT.COMPANY_ID,
			-1 AS CONTRACT_ID
			<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
			,GS.SPECT_VAR_ID
			</cfif>	
            <cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
            <cfif is_lot_no_based eq 1>			
			,LOT_NO
			</cfif>
            </cfif>
		FROM
			PRODUCT
			<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
                LEFT JOIN  <!--- alt barkoda göre arama yapmak için --->
                                 (
                                    SELECT D5.PRODUCT_ID,
                                    stuff( (
                                                    SELECT 
                                                        ';'+GET_STOCK_BARCODES.BARCODE AS BARCODE
                                                               
                                                        FROM 
                                                            #dsn3_alias#.GET_STOCK_BARCODES
                                                        WHERE
                                                            GET_STOCK_BARCODES.PRODUCT_ID = D5.PRODUCT_ID 
                                                            AND GET_STOCK_BARCODES.BARCODE = '#attributes.keyword#'
                                                   FOR XML PATH(''), TYPE).value('.', 'varchar(100)'),1,1,'')
                                           AS MY_BARCODE
                                           FROM 
                                           PRODUCT D5
                                    ) AS DD5
                                 ON
                                    DD5.PRODUCT_ID = PRODUCT.PRODUCT_ID
                </cfif>
                ,
			<!--- PRODUCT_CAT, --->
			STOCKS
            <cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
            <cfif is_lot_no_based eq 1>
			LEFT JOIN #dsn2_alias#.STOCKS_ROW SR ON STOCKS.STOCK_ID = SR.STOCK_ID  
			</cfif>
            </cfif>
			<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
			LEFT JOIN #dsn2_alias#.GET_STOCK_SPECT GS ON GS.STOCK_ID = STOCKS.STOCK_ID 
			<cfelse>
			LEFT JOIN #dsn2_alias#.GET_STOCK GS ON GS.STOCK_ID = STOCKS.STOCK_ID 
			</cfif>
			,PRODUCT_UNIT,
		<cfif attributes.price_catid gt 0>
			PRICE,PRICE_CAT
		<cfelse>
			PRICE_STANDART
		</cfif>			
		WHERE
			PRODUCT.PRODUCT_STATUS = 1
			<cfif len(attributes.serial_number) and listlen(seri_stock_id_list)>
				AND STOCKS.STOCK_ID IN (#seri_stock_id_list#)
			<cfelseif len(attributes.serial_number) and not listlen(seri_stock_id_list)>
				AND STOCKS.STOCK_ID IS NULL
			</cfif>            
			AND STOCKS.STOCK_STATUS = 1
			AND PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID
			AND PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 
			AND PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID 
			
			<!--- AND PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID --->
			AND PRODUCT_UNIT.IS_MAIN =1
		<cfif not isdefined('attributes.is_condition_sale_or_purchase')><!--- alış veya satış olsada bu deger geldi ise urunlerin alış veya satışlarına bakmaz --->
			<cfif not isdefined("attributes.sepet_process_type") or listfind('-1,73,74,75,76,77,78,80,81,811,761,82,84,86,87',attributes.sepet_process_type,',') or (isdefined('attributes.int_basket_id') and listfind('6,7,20,39',attributes.int_basket_id) )>
				AND PRODUCT.IS_PURCHASE=1
			</cfif>
		</cfif>
		<cfif attributes.price_catid lt 0>
			AND PRICE_STANDART.PRICESTANDART_STATUS = 1			
		</cfif>
        <cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
            AND PRODUCT.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
        </cfif>	
		<cfif attributes.price_catid gt 0><!--- dinamik bir fiyat kategorisi istenmisse --->
			AND PRICE_CAT.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">			
			AND	PRICE_CAT.PRICE_CAT_STATUS = 1
			AND PRICE.PRODUCT_ID = STOCKS.PRODUCT_ID
			AND	PRICE_CAT.PRICE_CATID = PRICE.PRICE_CATID
			AND PRICE.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			AND (PRICE.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PRICE.FINISHDATE IS NULL)
			AND ISNULL(PRICE.CATALOG_ID,0) IN (SELECT 0 CATALOG_ID UNION ALL SELECT CATALOG_ID FROM CATALOG_PROMOTION WHERE CATALOG_STATUS = 1)
			AND PRICE.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID
			AND PRICE.UNIT = STOCKS.PRODUCT_UNIT_ID
			<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1><!--- stok ve spec bazında fiyatlar getirilecekse --->
				<cfif GET_STOCK_SPEC_PRICE.recordcount gt 0>
					AND 
					(
						<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
						PRICE.SPECT_VAR_ID=GS.SPECT_VAR_ID
						OR
						</cfif>
						(
							ISNULL(PRICE.SPECT_VAR_ID,0)=0
							AND ISNULL(PRICE.STOCK_ID,0)=STOCKS.STOCK_ID
						)
						OR
						(
							ISNULL(PRICE.SPECT_VAR_ID,0)=0
							AND ((ISNULL(PRICE.STOCK_ID,0) = STOCKS.STOCK_ID AND PRICE.STOCK_ID IS NOT NULL) OR (ISNULL(PRICE.STOCK_ID,0) = 0 AND PRICE.STOCK_ID IS NULL))
							AND (CAST(STOCKS.STOCK_ID AS NVARCHAR(50))+'_'+CAST(PRODUCT_UNIT.PRODUCT_UNIT_ID AS NVARCHAR(50))) NOT IN (
							SELECT
								(CAST(PR.STOCK_ID AS NVARCHAR(50))+ '_'+CAST(PR.UNIT AS NVARCHAR(50)))
							FROM
								PRICE PR
							WHERE
								PR.STOCK_ID IS NOT NULL
								AND PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">
								AND PR.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								AND (PR.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PR.FINISHDATE IS NULL)
								AND ISNULL(PR.CATALOG_ID,0) IN (SELECT 0 CATALOG_ID UNION ALL SELECT CATALOG_ID FROM CATALOG_PROMOTION WHERE CATALOG_STATUS = 1)
							) 
						) 
					)				
				</cfif>
			<cfelse>
				AND ((ISNULL(PRICE.STOCK_ID,0) = STOCKS.STOCK_ID AND PRICE.STOCK_ID IS NOT NULL) OR (ISNULL(PRICE.STOCK_ID,0) = 0 AND PRICE.STOCK_ID IS NULL))
				AND ISNULL(PRICE.SPECT_VAR_ID,0)=0
			</cfif>
		<cfelseif attributes.price_catid eq '-1'><!--- Standart alis Fiyatlari Default Gelsin --->
			AND PRICE_STANDART.PURCHASESALES = 0
			AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
			<!--- AND PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID ---><!--- bu satirin calismasi icin ürüne yeni bir varyasyonun eklenmis olmali, bu da stocks da birimiyle gözükür. --->
			AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
		<cfelse>
			AND PRICE_STANDART.PURCHASESALES = 0
			AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
			<!--- AND PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID --->
			AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
		</cfif>
		AND PRODUCT.PRODUCT_ID NOT IN (
				SELECT 
					DISTINCT PRODUCT_ID
				FROM 			
					CONTRACT_PURCHASE_PROD_DISCOUNT
				<cfif len(attributes.company_id)>
				WHERE
					COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
			)
		
		<cfif isDefined("attributes.product_cat_code") and len(attributes.product_cat_code)>
			AND PRODUCT.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_cat_code#.%">
		</cfif>
		<cfif len(attributes.brand_id) and len(attributes.brand_name)>
			AND PRODUCT.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
		</cfif>
		<cfif len(attributes.product_cat) and len(attributes.product_catid)>
			AND PRODUCT.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">)+'.%' <!---kategori hiyerarşisine gore arama yapıyor --->
		</cfif>
		<cfif len(attributes.employee) and len(attributes.pos_code)>
			AND PRODUCT.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
		</cfif>
		<cfif len(attributes.get_company) and len(attributes.get_company_id)>
			AND PRODUCT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_company_id#">
		</cfif>
		<cfif isDefined("attributes.manufact_code") and len(attributes.manufact_code)>
			AND	STOCKS.MANUFACT_CODE = '#trim(attributes.manufact_code)#'
		</cfif>
		<cfif isdefined('attributes.is_store_module') and isdefined('attributes.sepet_process_type') and listfind('49,51,52,54,55,59,60,601,63,591',attributes.sepet_process_type)>
			AND PRODUCT.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH PB WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#"> )
		</cfif>
		<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1 and isdefined("attributes.project_id") and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
			<!--- xml de proje filtresi secilmisse, secilen projenin masraf merkezine baglı urunler listelenir --->
			AND PRODUCT.PRODUCT_ID IN (
										SELECT 
											DISTINCT CP.PRODUCT_ID
										FROM
											#dsn3_alias#.PRODUCT_PERIOD CP,
											#dsn2_alias#.EXPENSE_CENTER EXC,
											#dsn_alias#.PRO_PROJECTS PRJ
										WHERE
											CP.PRODUCT_ID =PRODUCT.PRODUCT_ID
											AND CP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
											AND PRJ.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
											AND (CP.EXPENSE_CENTER_ID=EXC.EXPENSE_ID OR CP.COST_EXPENSE_CENTER_ID=EXC.EXPENSE_ID)
											AND SUBSTRING(PRJ.EXPENSE_CODE,1,3) = EXC.EXPENSE_CODE
										)
		</cfif>
		<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id) and len(attributes.list_variation_id)>
			AND
			PRODUCT.PRODUCT_ID IN
			(
				SELECT
					PRODUCT_ID
				FROM
					#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
				WHERE
					(
				  <cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_index">
					(PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_property_id,pro_index,",")#"> AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_variation_id,pro_index,",")#">)
					<cfif pro_index lt listlen(attributes.list_property_id,',')>OR</cfif>
				  </cfloop>
					)
				GROUP BY
					PRODUCT_ID
				HAVING
					COUNT(PRODUCT_ID)> = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(attributes.list_property_id,',')#">
			)
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
			AND
				(
					(	STOCKS.STOCK_CODE LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
						OR STOCKS.STOCK_CODE_2 LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
						<!---OR PRODUCT.PRODUCT_ID IN (SELECT PRODUCT_ID FROM GET_STOCK_BARCODES WHERE BARCODE = '#attributes.keyword#')--->
						OR PRODUCT.PRODUCT_NAME + ' ' + STOCKS.PROPERTY LIKE #sql_unicode()#'%#attributes.keyword#%'
						OR STOCKS.MANUFACT_CODE LIKE '%#attributes.keyword#%'
                        OR PRODUCT.PRODUCT_DETAIL LIKE '%#attributes.keyword#%'  
                      
					)
					OR STOCKS.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> 
					OR STOCKS.MANUFACT_CODE LIKE '#trim(attributes.keyword)#'
					<cfif listfind("17,15,11,37",attributes.int_basket_id)>
						OR PRODUCT.BRAND_ID IN (SELECT BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
					</cfif>
				)
		<cfelseif isDefined("attributes.keyword") and len(attributes.keyword) eq 1>
			AND	(PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'#attributes.keyword#%' 
			 OR STOCKS.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
             OR PRODUCT.PRODUCT_DETAIL LIKE '#attributes.keyword#%' 
             )
		</cfif>
		<cfif isdefined("sepet_process_type") and not listfind('591,140',sepet_process_type,',')>
			<cfif ListFind("52,53,54,55,59,70,71,73,74,75,76,80,81,86,114",sepet_process_type)>
				AND PRODUCT.IS_INVENTORY = 1
			<cfelseif ListFind("60,601",sepet_process_type)>
				AND PRODUCT.IS_INVENTORY = 0
			</cfif>
		</cfif>
</cfif>
<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
<cfif is_lot_no_based eq 1 and len(attributes.company_id)>
GROUP BY
STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			PRODUCT.IS_INVENTORY,
            PRODUCT.SHORT_CODE_ID,
			PRODUCT.IS_PRODUCTION,
			PRODUCT.PRODUCT_NAME,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.PRODUCT_CODE_2,
			STOCKS.STOCK_CODE_2,
			PRODUCT.PRODUCT_DETAIL,
			<cfif isdefined('attributes.sepet_process_type') and attributes.sepet_process_type eq 591>
				
			<cfelse>
				PRODUCT.TAX_PURCHASE,
			</cfif>
			PRODUCT.OTV,
			PRODUCT.OIV,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.IS_SERIAL_NO,
			STOCKS.MANUFACT_CODE,
		<cfif attributes.price_catid gt 0>
			PRICE.PRICE,
			PRICE.MONEY,
			PRICE.PRICE_CATID,
			PRICE.CATALOG_ID,
		<cfelse>
			PRICE_STANDART.PRICE,
			<cfif session.ep.period_year lt 2009>
				CASE WHEN PRICE_STANDART.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY,
			<cfelse>
				PRICE_STANDART.MONEY,
			</cfif> 			
		</cfif>			
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.UNIT_ID,
			PRODUCT_UNIT.PRODUCT_UNIT_ID,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.MULTIPLIER,
			<!--- 2 AS Q_TYPE, --->					
			PRODUCT.COMPANY_ID
			<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
			,GS.SPECT_VAR_ID
			</cfif>	
            <cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
            <cfif is_lot_no_based eq 1>			
			,LOT_NO
			</cfif>
            </cfif>
</cfif>
</cfif>
<!---
<cfif get_price_exceptions_pid.recordcount>
	UNION
		SELECT
			UNIT,
			PRICE,
			PRICE_KDV,
			PRODUCT_ID,
			<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
				ISNULL(STOCK_ID,0) AS STOCK_ID,
				ISNULL(SPECT_VAR_ID,0) AS SPECT_VAR_ID,
			</cfif>
			MONEY,
			PRICE_CATID,
			CATALOG_ID
		FROM
			PRICE
		WHERE 
			P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			AND (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
			<cfif get_price_exceptions_pid.recordcount gt 1>(</cfif>
				<cfoutput query="get_price_exceptions_pid">
				(PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#"> AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
				<cfif get_price_exceptions_pid.recordcount neq get_price_exceptions_pid.currentrow>
				OR
				</cfif>
				</cfoutput>
			<cfif get_price_exceptions_pid.recordcount gt 1>)</cfif>
	</cfif>
	<cfif get_price_exceptions_pcatid.recordcount>
	UNION
		SELECT
			P.UNIT,P.PRICE,P.PRICE_KDV,P.PRODUCT_ID,
			<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
				ISNULL(P.STOCK_ID,0) AS STOCK_ID, ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
			</cfif>
			P.MONEY,P.PRICE_CATID,P.CATALOG_ID
		FROM
			PRICE P,
			PRODUCT PR
		WHERE
			<cfif get_price_exceptions_pid.recordcount>
			P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
			</cfif>
			P.PRODUCT_ID = PR.PRODUCT_ID AND
			P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			AND (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
			<cfif get_price_exceptions_pcatid.recordcount gt 1>(</cfif>
			<cfoutput query="get_price_exceptions_pcatid">
			(PR.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_CATID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
			<cfif get_price_exceptions_pcatid.recordcount neq get_price_exceptions_pcatid.currentrow>
			OR
			</cfif>
			</cfoutput>
			<cfif get_price_exceptions_pcatid.recordcount gt 1>)</cfif>
	</cfif>
	<cfif get_price_exceptions_brid.recordcount>
	UNION
		SELECT  
			P.UNIT,P.PRICE,P.PRICE_KDV,P.PRODUCT_ID,
			<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
				ISNULL(P.STOCK_ID,0) AS STOCK_ID, ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
			</cfif>
			P.MONEY,P.PRICE_CATID,P.CATALOG_ID
		FROM 
			PRICE P,
			PRODUCT PR
		WHERE 
			<cfif get_price_exceptions_pid.recordcount>
			P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
			</cfif>
			<cfif get_price_exceptions_pcatid.recordcount>
			PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
			</cfif>
			P.PRODUCT_ID = PR.PRODUCT_ID AND 
			P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			AND (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
			<cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>		
			<cfoutput query="get_price_exceptions_brid">		
			(PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRAND_ID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
			<cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
			OR
			</cfif>
			</cfoutput>
			<cfif get_price_exceptions_brid.recordcount gt 1>)</cfif>		
	</cfif>
    <cfif get_price_exceptions_shortcode.recordcount>
	UNION
		SELECT  
			P.UNIT,P.PRICE,P.PRICE_KDV,P.PRODUCT_ID,
			<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
				ISNULL(P.STOCK_ID,0) AS STOCK_ID, ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
			</cfif>
			P.MONEY,P.PRICE_CATID,P.CATALOG_ID
		FROM 
			PRICE P,
			PRODUCT PR
		WHERE 
			<cfif get_price_exceptions_pid.recordcount>
			P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
			</cfif>
			<cfif get_price_exceptions_pcatid.recordcount>
			PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
			</cfif>
			P.PRODUCT_ID = PR.PRODUCT_ID AND 
			P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			AND (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
			<cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>		
			<cfoutput query="get_price_exceptions_brid">		
                (PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRAND_ID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
                <cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
                OR
                </cfif>
			</cfoutput>
			<cfif get_price_exceptions_brid.recordcount gt 1>)  AND</cfif>	
			<cfif get_price_exceptions_shortcode.recordcount gt 1>(</cfif>		
			<cfoutput query="get_price_exceptions_shortcode">		
			(PR.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SHORT_CODE_ID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
			<cfif get_price_exceptions_shortcode.recordcount neq get_price_exceptions_shortcode.currentrow>
			OR
			</cfif>
			</cfoutput>
			<cfif get_price_exceptions_shortcode.recordcount gt 1>)</cfif>	
	</cfif>--->
),
CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (
										<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 0>
											 ORDER BY PRODUCT_NAME, PROPERTY
										<cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 1>
											  ORDER BY STOCK_CODE
                                          <cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 3>    
                                              ORDER BY PRODUCT_DETAIL
										<cfelse>
											 ORDER BY STOCK_CODE_2, PRODUCT_NAME
										</cfif>
									) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
</cfquery>

