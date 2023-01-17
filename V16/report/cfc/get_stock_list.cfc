<!--- ISBAK İsbak Stoklar Özel Raporu created by : MCP 20130916 --->
<cffunction name="GET_PRODUCT_fnc" returntype="query">
	<cfargument name="list_type" default="0">
	<cfargument name="amount_flag" default=""/>
	<cfargument name="is_saleable_stock" default=""/>
	<cfargument name="group_unit_2" default=""/>
	<cfargument name="x_include_scrap_location" default=""/>
	<cfargument name="product_types" default=""/>
	<cfargument name="date1" default=""/>
	<cfargument name="date2" default=""/>
	<cfargument name="is_stock_active" default=""/>
	<cfargument name="employee" default=""/>
	<cfargument name="employee_id" default=""/>
	<cfargument name="company_id" default=""/>
	<cfargument name="company" default=""/>
	<cfargument name="search_product_catid" default=""/>
	<cfargument name="product_cat" default=""/>
	<cfargument name="product_brand_id" default=""/>
	<cfargument name="product_brand_name" default=""/>
	<cfargument name="product_model_id" default=""/>
	<cfargument name="product_model_name" default=""/>
	<cfargument name="barcod" default=""/>
	<cfargument name="keyword" default=""/>
	<cfargument name="shelf_number" default=""/>
	<cfargument name="shelf_number_txt" default=""/>
	<cfargument name="stock_code" default=""/>
	<cfargument name="ozel_kod" default=""/>
	<cfargument name="department_id" default=""/>
	<cfargument name="list_property_id" default=""/>
	<cfargument name="property_search_type" default=""/>
	<cfargument name="list_property_name" default=""/>
	<cfargument name="list_variation_code" default=""/>
	<cfargument name="list_variation_id" default=""/>
	<cfargument name="strategy_type" default=""/>
    <cfargument name="shelf" default=""/> 
	<cfargument name="sort_type" default=""/>
	<cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
    <cfargument name="location_id" default="">
    
	<!--- amount_flag =2: strateji bazında
        arguments.list_type = 1:stok bazında,2:spec bazında,3 Karma Koli Bazında! --->
    <cfquery name="GET_PRODUCT" datasource="#this.dsn3#">
       <!--- WITH CTE1 AS (--->
		<cfif arguments.list_type eq 3>
            SELECT
             TABLE1.KARMA_PRODUCT_ID, 
             TABLE1.PRODUCT_AMOUNT, 
             TABLE1.MAIN_UNIT, 
             TABLE1.PRODUCT_ID, 
             TABLE1.STOCK_CODE_2, 
             TABLE1.PRODUCT_NAME, 
             TABLE1.STOCK_ID, 
             TABLE1.BARCOD, 
             TABLE1.STOCK_CODE, 
             TABLE1.PROPERTY, 
             TABLE1.PRODUCT_STOCK,
             <cfif arguments.list_type eq 1 and isdefined("arguments.amount_flag") and arguments.amount_flag eq 2>
                <cfif isdefined("arguments.is_saleable_stock")>
                    TABLE1.REAL_STOCK,
                </cfif>
            </cfif>
            <cfif isDefined("arguments.x_include_scrap_location") and arguments.x_include_scrap_location eq 0>
                <!--- Xml Hurda Lokasyonu Miktara Dahil Edilsin Mi --->
                TABLE1.HURDA_STOCK,
            </cfif>
             TABLE1.KARMA_STOCK,
             SS.STOCK_ID KARMA_STOCK_ID,
             SS.BARCOD AS KARMA_BARKOD,
             SS.PRODUCT_NAME KARMA_PRODUCT_NAME,
             SS.STOCK_CODE_2 AS KARMA_STOCK_CODE_2,
             SS.STOCK_CODE AS KARMA_STOCK_CODE,
             SS.PROPERTY AS KARMA_PROPERTY
             FROM 
            (
        </cfif>
            SELECT
                <cfif arguments.list_type eq 2>
                SR.SPECT_VAR_ID,
                <cfelseif arguments.list_type eq 3>
                KP.KARMA_PRODUCT_ID,
                KP.PRODUCT_AMOUNT,
                <cfelseif arguments.list_type eq 4>
                SR.SHELF_NUMBER,
                </cfif>
                PU.MAIN_UNIT,
                S.PRODUCT_ID,
                S.STOCK_CODE_2,
                S.PRODUCT_NAME,
                S.STOCK_ID,
                S.BARCOD,
                S.STOCK_CODE,
                S.PROPERTY,
                <cfif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 2>
                GS_STRATEGY.MAXIMUM_STOCK,
                GS_STRATEGY.REPEAT_STOCK_VALUE,
                GS_STRATEGY.MINIMUM_STOCK,
                GS_STRATEGY.PROVISION_TIME,
                GS_STRATEGY.MINIMUM_ORDER_STOCK_VALUE,
                GS_STRATEGY.BLOCK_STOCK_VALUE,
                GS_STRATEGY.STOCK_ACTION_ID,
                </cfif>
                <cfif isdefined('arguments.group_unit_2') and arguments.group_unit_2 eq 1>
               	ISNULL(SR.UNIT2,PU.MAIN_UNIT) UNIT2,
                SUM(CASE WHEN (SR.STOCK_IN - SR.STOCK_OUT) < 0 THEN ISNULL(SR.AMOUNT2,ABS(SR.STOCK_IN - SR.STOCK_OUT))*-1 WHEN (SR.STOCK_IN - SR.STOCK_OUT) > 0 THEN ISNULL(SR.AMOUNT2,ABS(SR.STOCK_IN - SR.STOCK_OUT)) END) AMOUNT2,
                </cfif>
                0 HURDA_STOCK,
                <cfif listfind('1,2,3,4',arguments.list_type,',')>
                    <cfif arguments.list_type eq 1 and isdefined("arguments.amount_flag") and arguments.amount_flag eq 2>
                        <cfif isdefined("arguments.is_saleable_stock")>
                            SUM(SR.SALEABLE_STOCK) AS PRODUCT_STOCK, <!--- stok stratejisi satılabilir stoga gore calıstıgı icin listeye de satılabilir stok miktarı getiriliyor --->
                            SUM(SR.PRODUCT_STOCK) AS REAL_STOCK
                        <cfelse>
                            SUM(SR.PRODUCT_STOCK) AS PRODUCT_STOCK
                        </cfif>
                    <cfelseif arguments.list_type eq 3>	
                        SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                        SUM(SR.STOCK_IN - SR.STOCK_OUT)/KP.PRODUCT_AMOUNT KARMA_STOCK
                    <cfelse>	
                        SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK
                    </cfif>
                <cfelse>
                    SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK
                </cfif>
            FROM 
                STOCKS S,
                PRODUCT_UNIT PU,
                <cfif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 2>
                #this.dsn2_alias#.GET_STOCK_STRATEGY GS_STRATEGY,
                </cfif>
                <cfif arguments.list_type eq 1 and isdefined("arguments.amount_flag") and arguments.amount_flag eq 2>
					 #this.dsn2_alias#.GET_STOCK_LAST_LOCATION SR
                <cfelse>
                    #this.dsn2_alias#.STOCKS_ROW SR
                </cfif>
                <cfif arguments.list_type eq 3>
                    ,#this.dsn1_alias#.KARMA_PRODUCTS KP
                </cfif>
            WHERE
                S.IS_INVENTORY = 1 AND 
                PU.IS_MAIN = 1 AND
				<cfif arguments.list_type eq 4 and len(arguments.shelf)>
              	  SR.SHELF_NUMBER IN (SELECT PP.PRODUCT_PLACE_ID FROM PRODUCT_PLACE PP WHERE PP.PRODUCT_PLACE_ID = SR.SHELF_NUMBER AND PP.SHELF_TYPE IN (#arguments.shelf#)) AND
                </cfif>
                <cfif isdefined('arguments.product_types') and len(arguments.product_types)>
                    <cfif isdefined('arguments.product_types') and (arguments.product_types eq 1)>
                        S.IS_PURCHASE = 1 AND
                    <cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 4)>
                        S.IS_TERAZI = 1 AND
                    <cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 5)>
                        S.IS_PURCHASE = 0 AND
                    <cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 6)>
                        S.IS_PRODUCTION = 1 AND
                    <cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 7)>
                        S.IS_SERIAL_NO = 1 AND
                    <cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 8)>
                        S.IS_KARMA = 1 AND
                    <cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 9)>
                        S.IS_INTERNET = 1 AND
                    <cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 10)>
                        S.IS_PROTOTYPE = 1 AND
                    <cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 11)>
                        S.IS_ZERO_STOCK = 1 AND
                    <cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 12)>
                        S.IS_EXTRANET = 1 AND
                    <cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 13)>
                        S.IS_COST = 1 AND
                    <cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 14)>
                        S.IS_SALES = 1 AND
                    </cfif>
                </cfif>
              <cfif isdefined('arguments.date1') and len(arguments.date1) and  isdefined('arguments.date2') and len(arguments.date2)>
                SR.PROCESS_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date2#"> AND
              </cfif>
              <cfif arguments.list_type neq 3><!--- Karma Koli İse Bu bloğa girmesin,buraya girerse karma koliyi oluşturan ürün özelliklerine göre arama yapmış olur bize gereken bu değil!Ana ürün İçin Yapması Gerekiyor Dolayısı ile bu bloklar aşağıda çalışacak.. --->
                  <cfif isDefined("arguments.is_stock_active") and arguments.is_stock_active neq 2>
                    S.PRODUCT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_stock_active#"> AND
                    S.STOCK_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_stock_active#"> AND
                  </cfif>
                  <cfif isDefined("arguments.employee_id") and len(arguments.employee_id) and isnumeric(arguments.employee_id) and len(arguments.employee)>
                    S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND 
                  </cfif>
                  <cfif isDefined("arguments.company_id") and len(arguments.company_id) and isnumeric(arguments.company_id) and len(arguments.company)>
                    (
                        S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> OR
                        S.PRODUCT_ID IN (SELECT PRODUCT_ID FROM CONTRACT_PURCHASE_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
                    ) 
                    AND
                  </cfif>
                  <cfif isDefined("arguments.search_product_catid") and len(arguments.search_product_catid) and len(arguments.product_cat)>
                    S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.search_product_catid#%"> AND
                  </cfif>
                  
                  <cfif isDefined("arguments.product_brand_id") and len(arguments.product_brand_id) and len(arguments.product_brand_name)>
                    S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_brand_id#"> AND
                  </cfif>
                  <cfif isDefined("arguments.product_model_id") and len(arguments.product_model_id) and len(arguments.product_model_name)>
                    S.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_model_id#"> AND
                  </cfif>
                  <cfif isDefined("arguments.barcod") and len(arguments.barcod)>
                    S.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.barcod#"> AND
                  <cfelseif isDefined("arguments.keyword") and len(arguments.keyword)>
                    (	
                      <cfif isnumeric(arguments.keyword) and int(arguments.keyword) gt 0>
                        (S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.keyword#">) OR
                      </cfif>
                     (
                      <cfif len(arguments.keyword) lte 3>
                        (S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)	
                      <cfelseif len(arguments.keyword) gt 3 or listlen(arguments.keyword,"+")>
                        (
                            (
                              <cfloop from="1" to="#listlen(arguments.keyword,'+')#" index="pro_index">
                                S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ListGetAt(arguments.keyword,pro_index,'+')#%">
                                <cfif pro_index neq listlen(arguments.keyword,'+')>AND</cfif>
                              </cfloop>
                            )		
                            OR S.STOCK_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                        )				
                      </cfif>
                        )
                        OR S.MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">
                    ) AND
                  </cfif>
                  <cfif arguments.list_type eq 4 and isdefined("arguments.shelf_number") and len(arguments.shelf_number) and len(arguments.shelf_number_txt)>
                    SR.SHELF_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.shelf_number#"> AND
                  </cfif>
                  <cfif isDefined("arguments.stock_code") and len(arguments.stock_code)>
                    S.STOCK_CODE LIKE '<cfif len(arguments.stock_code) gt 3>%</cfif>#arguments.stock_code#%' AND
                  </cfif>
                  <cfif isDefined("arguments.ozel_kod") and len(arguments.ozel_kod)>
                    S.STOCK_CODE_2 LIKE '<cfif len(arguments.ozel_kod) gt 3>%</cfif>#arguments.ozel_kod#%' AND
                  </cfif>
              </cfif>
                SR.STOCK_ID = S.STOCK_ID AND
                <cfif arguments.list_type eq 3>
                    KP.STOCK_ID = SR.STOCK_ID AND
                </cfif>
                <cfif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 2>
                    S.PRODUCT_ID = GS_STRATEGY.PRODUCT_ID AND
                    S.STOCK_ID = GS_STRATEGY.STOCK_ID AND
                    <cfif isdefined('arguments.department_id') and len(arguments.department_id)>
                        GS_STRATEGY.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"> AND
                    <cfelse>
                        GS_STRATEGY.DEPARTMENT_ID IS NULL AND 
                    </cfif>
                </cfif>
                S.PRODUCT_ID = PU.PRODUCT_ID
                <cfif len(arguments.department_id)>
                        <cfif arguments.amount_flag eq 2 and arguments.list_type eq 1>
                            AND SR.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                        <cfelse>
                            AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                        </cfif>
                    <cfif len(arguments.location_id)>
                        <cfif arguments.amount_flag eq 2 and arguments.list_type eq 1 >
                            AND SR.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                            AND SR.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#">
                        <cfelse>
                            AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                            AND SR.STORE_lOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#">
                        </cfif>
                    </cfif>
                </cfif>	
				<cfif isDefined("x_include_scrap_location") and x_include_scrap_location eq 0>
					 <cfif arguments.amount_flag eq 2 and arguments.list_type eq 1>
						 AND SR.LOCATION_ID NOT IN
						 (
						 	SELECT
								SL.LOCATION_ID
							FROM
								#this.dsn_alias#.STOCKS_LOCATION SL 
							WHERE
								SL.DEPARTMENT_ID = SR.DEPARTMENT_ID
								AND ISNULL(SL.IS_SCRAP,0)=1
						 )
					 <cfelse>
						 AND SR.STORE_lOCATION NOT IN
							 (
								SELECT
									SL.LOCATION_ID
								FROM
									#this.dsn_alias#.STOCKS_LOCATION SL 
								WHERE
									SL.DEPARTMENT_ID = SR.STORE
									AND ISNULL(SL.IS_SCRAP,0)=1
							 )
					 </cfif>
				</cfif>
                <cfif len(arguments.list_property_id)><!--- stok ozelliklerine gore arama --->
                    <cfif arguments.property_search_type eq 1>
                        AND S.STOCK_ID IN 
                        (
                            SELECT
                                STOCK_ID
                            FROM
                                STOCKS_PROPERTY
                            WHERE
                                (
                                  <cfloop from="1" to="#listlen(arguments.list_property_id,',')#" index="pro_index">
                                    (	
                                        PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(arguments.list_property_id,pro_index,',')#"> AND 
                                        PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(arguments.list_variation_id,pro_index,',')#">
                                    )
                                    <cfif pro_index lt listlen(arguments.list_property_id,',')>OR</cfif>
                                  </cfloop>
                                )
                            GROUP BY
                                STOCK_ID
                            HAVING
                                COUNT(STOCK_ID)> = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(arguments.list_property_id,',')#">
                        )
                    <cfelseif arguments.property_search_type eq 2>
                        AND
                        <cfloop list="#arguments.list_property_name#" index="pro_index" delimiters="|,|">
                        S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#pro_index#%">
                        <cfif pro_index neq listlast(arguments.list_property_name,'|,|')>AND</cfif>
                        </cfloop>
                    <cfelseif arguments.property_search_type eq 3>
                        AND
                        SR.SPECT_VAR_ID IN 
                        (SELECT SPECT_MAIN_ID FROM SPECT_MAIN WHERE
                            <cfloop list="#arguments.list_variation_code#" index="pro_index" delimiters="|,|">
                                SPECT_MAIN_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#pro_index#%">
                                <cfif pro_index neq listlast(arguments.list_variation_code,'|,|')>AND</cfif>
                            </cfloop>
                        )
                    <cfelseif arguments.property_search_type eq 4>
                        AND
                        SR.SPECT_VAR_ID IN
                        (
                        SELECT 
                            SPECT_MAIN.SPECT_MAIN_ID
                        FROM 
                            #this.dsn3_alias#.SPECT_MAIN_ROW SPECT_MAIN_ROW,
                            #this.dsn3_alias#.SPECT_MAIN SPECT_MAIN
                        WHERE
                            SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID AND
                            (
                                <cfloop from="1" to="#listlen(arguments.list_property_id,',')#" index="pro_index">
                                    (
                                        SPECT_MAIN_ROW.IS_PROPERTY=1
                                        <cfif isdefined('arguments.list_property_id') and listgetat(arguments.list_property_id,pro_index,',') gt 0>
                                            AND SPECT_MAIN_ROW.PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.list_property_id,pro_index,',')#">
                                        </cfif>
                                        <cfif isdefined('arguments.list_variation_id') and listgetat(arguments.list_variation_id,pro_index,',') gt 0>
                                            AND SPECT_MAIN_ROW.VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.list_variation_id,pro_index,',')#">
                                        </cfif>
                                    ) 
                                    <cfif listlen(arguments.list_property_id,',') gt pro_index>OR</cfif>
                                </cfloop>
                            )
                        GROUP BY SPECT_MAIN.SPECT_MAIN_ID
                        HAVING COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(arguments.list_property_id,',')#">
                        )
                    </cfif>
                </cfif>
            GROUP BY
                PU.MAIN_UNIT,
                S.PRODUCT_ID,
                S.PRODUCT_NAME,
                S.STOCK_CODE_2,
                S.STOCK_ID,
                S.BARCOD,
                <cfif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 2 >
                    GS_STRATEGY.STRATEGY_TYPE,
                    GS_STRATEGY.MAXIMUM_STOCK,
                    GS_STRATEGY.REPEAT_STOCK_VALUE,
                    GS_STRATEGY.MINIMUM_STOCK,
                    GS_STRATEGY.PROVISION_TIME,
                    GS_STRATEGY.MINIMUM_ORDER_STOCK_VALUE,
                    GS_STRATEGY.BLOCK_STOCK_VALUE,
                    GS_STRATEGY.STOCK_ACTION_ID,
                </cfif>
                S.STOCK_CODE,
                S.PROPERTY
                <cfif listfind('1,2,3,4',arguments.list_type,',')>
                    <cfif len(arguments.department_id)>
                            <cfif arguments.amount_flag eq 2 and arguments.list_type eq 1>
                                ,SR.DEPARTMENT_ID
                            <cfelse>
                                ,SR.STORE
                            </cfif>
                        <cfif len(arguments.location_id)>
                            <cfif arguments.amount_flag eq 2 and arguments.list_type eq 1>
                                ,SR.DEPARTMENT_ID
                                ,SR.LOCATION_ID
                            <cfelse>
                                ,SR.STORE
                                ,SR.STORE_lOCATION
                            </cfif>
                        </cfif>					
                    </cfif>
                    <cfif arguments.list_type eq 2>
                    ,SR.SPECT_VAR_ID
                    <cfelseif arguments.list_type eq 3>
                    ,KP.KARMA_PRODUCT_ID
                    ,KP.PRODUCT_AMOUNT
                    <cfelseif arguments.list_type eq 4>
                    ,SR.SHELF_NUMBER
                    </cfif>
                </cfif>
                <cfif isdefined('arguments.group_unit_2') and arguments.group_unit_2 eq 1>
                ,ISNULL(SR.UNIT2,PU.MAIN_UNIT)
                </cfif>
            <cfif arguments.list_type eq 1>          
                <cfif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 0>
                    HAVING SUM(SR.STOCK_IN - SR.STOCK_OUT) < 0
                <cfelseif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 1>
                    HAVING SUM(SR.STOCK_IN - SR.STOCK_OUT) > 0
                <cfelseif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 3><!--- sıfır stok --->
                    HAVING round(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) = 0
                <cfelseif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 2>
                    <cfif isdefined("arguments.is_saleable_stock")> <!---strateji satılabilir stok uzerinden hesaplanır --->
                        <cfif isdefined('arguments.strategy_type') and arguments.strategy_type eq 1><!--- fazla stok --->
                            HAVING SUM(SALEABLE_STOCK) >= GS_STRATEGY.MAXIMUM_STOCK
                        <cfelseif isdefined('arguments.strategy_type') and arguments.strategy_type eq 2><!--- eksik stok --->
                            HAVING SUM(SALEABLE_STOCK) <= GS_STRATEGY.MINIMUM_STOCK	
                        <cfelseif isdefined('arguments.strategy_type') and arguments.strategy_type eq 3><!--- yeniden siparis noktasına gelen urunler --->
                            HAVING SUM(SALEABLE_STOCK) <= GS_STRATEGY.REPEAT_STOCK_VALUE AND SUM(SALEABLE_STOCK) > GS_STRATEGY.MINIMUM_STOCK
                        </cfif>
                    <cfelseif not len(arguments.department_id)>
                        <cfif isdefined('arguments.strategy_type') and arguments.strategy_type eq 1><!--- fazla stok --->
                            HAVING
                                SUM(PRODUCT_STOCK) >= GS_STRATEGY.MAXIMUM_STOCK AND
                                SUM(PRODUCT_STOCK) > 0 AND
                                SUM(PRODUCT_STOCK) >= GS_STRATEGY.MINIMUM_STOCK
                        <cfelseif isdefined('arguments.strategy_type') and arguments.strategy_type eq 2><!--- eksik stok --->
                            HAVING SUM(PRODUCT_STOCK) <= GS_STRATEGY.MINIMUM_STOCK	
                        <cfelseif isdefined('arguments.strategy_type') and arguments.strategy_type eq 3><!--- yeniden siparis noktasına gelen urunler --->
                            HAVING SUM(PRODUCT_STOCK) <= GS_STRATEGY.REPEAT_STOCK_VALUE AND SUM(PRODUCT_STOCK) > GS_STRATEGY.MINIMUM_STOCK
                        </cfif>
                    <cfelse>
                        <cfif isdefined('arguments.strategy_type') and arguments.strategy_type eq 1><!--- fazla stok --->
                            HAVING SUM(PRODUCT_STOCK) >= GS_STRATEGY.MAXIMUM_STOCK
                        <cfelseif isdefined('arguments.strategy_type') and arguments.strategy_type eq 2><!--- eksik stok --->
                            HAVING SUM(PRODUCT_STOCK) <= GS_STRATEGY.MINIMUM_STOCK	
    
                        <cfelseif isdefined('arguments.strategy_type') and arguments.strategy_type eq 3><!--- yeniden siparis noktasına gelen urunler --->
                            HAVING SUM(PRODUCT_STOCK) <= GS_STRATEGY.REPEAT_STOCK_VALUE AND SUM(PRODUCT_STOCK) > GS_STRATEGY.MINIMUM_STOCK
                        </cfif>
                        
                    </cfif>
                </cfif>
            <cfelse>
                <cfif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 0 >
                    HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) < 0
                <cfelseif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 1 >
                    HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) > 0
                <cfelseif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 3 ><!--- sıfır stok --->
                    HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) = 0
                <cfelseif isDefined("arguments.amount_flag") and  arguments.amount_flag eq 2 >
                    <cfif isdefined('arguments.strategy_type') and arguments.strategy_type eq 2><!--- eksik stok --->
                        HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) <= GS_STRATEGY.MINIMUM_STOCK	
                    <cfelseif isdefined('arguments.strategy_type') and arguments.strategy_type eq 3><!--- yeniden siparis noktasına gelen urunler --->
                        HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) <= GS_STRATEGY.REPEAT_STOCK_VALUE AND SUM(SR.STOCK_IN - SR.STOCK_OUT) > GS_STRATEGY.MINIMUM_STOCK
                    <cfelseif isdefined('arguments.strategy_type') and arguments.strategy_type eq 1><!--- fazla stok --->
                        HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) >= GS_STRATEGY.MAXIMUM_STOCK
                    </cfif>
                </cfif>
            </cfif>
            
        <cfif arguments.list_type eq 3>
            ) TABLE1,
              STOCKS SS
            WHERE 
            <!--- Bu Alttaki Where Bloğundakiler Yukardaki Where Bloğunun Kopyası.Yukarda bakarken S.STOCK_CODE diye bakıyor burda ise SS.STOCK_CODE diye... --->
            <cfif isDefined("arguments.is_stock_active") and arguments.is_stock_active neq 2>
                SS.PRODUCT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_stock_active#"> AND
                SS.STOCK_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_stock_active#"> AND
            </cfif>
            <cfif isDefined("arguments.employee_id") and len(arguments.employee_id) and isnumeric(arguments.employee_id) and len(arguments.employee)>
                SS.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND 
            </cfif>
            <cfif isDefined("arguments.company_id") and len(arguments.company_id) and isnumeric(arguments.company_id) and len(arguments.company)>
                (
                    SS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> OR
                    SS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM CONTRACT_PURCHASE_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
                )
                AND
            </cfif>
            <cfif isDefined("arguments.search_product_catid") and len(arguments.search_product_catid) and len(arguments.product_cat)>
                SS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.search_product_catid#%"> AND
            </cfif>
            <cfif isDefined("arguments.product_brand_id") and len(arguments.product_brand_id) and len(arguments.product_brand_name)>
                SS.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_brand_id#"> AND
            </cfif>
            <cfif isDefined("arguments.product_model_id") and len(arguments.product_model_id) and len(arguments.product_model_name)>
                SS.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_model_id#"> AND
            </cfif>
            <cfif isDefined("arguments.barcod") and len(arguments.barcod)>
                SS.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.barcod#"> AND
            <cfelseif isDefined("arguments.keyword") and len(arguments.keyword)>
            (	
              <cfif isnumeric(arguments.keyword) and int(arguments.keyword) gt 0>
                (SS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.keyword#">) OR
              </cfif>
                (
              <cfif len(arguments.keyword) lte 3 >
                (SS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">)	
              <cfelseif len(arguments.keyword) gt 3 or listlen(arguments.keyword,"+")>
                (
                    (
                      <cfloop from="1" to="#listlen(arguments.keyword,'+')#" index="pro_index">
                        SS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ListGetAt(arguments.keyword,pro_index,'+')#%">
                        <cfif pro_index neq listlen(arguments.keyword,'+')>AND</cfif>
                      </cfloop>
                    )		
                    OR SS.STOCK_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                )				
              </cfif>
                )
                OR SS.MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">
            ) AND
            </cfif>
            <cfif isDefined("arguments.stock_code") and len(arguments.stock_code)>
                SS.STOCK_CODE LIKE '<cfif len(arguments.stock_code) gt 3>%</cfif>#arguments.stock_code#%' AND
            </cfif>
            <cfif isDefined("arguments.ozel_kod") and len(arguments.ozel_kod)>
                SS.STOCK_CODE_2 LIKE '<cfif len(arguments.ozel_kod) gt 3>%</cfif>#arguments.ozel_kod#%' AND
            </cfif>
        SS.PRODUCT_ID = TABLE1.KARMA_PRODUCT_ID  
			
			
        </cfif> <!---), <!--- İsbak Stoklar Özel raporundaki excel aktarımında tüm listeye atma gerekliliğinden dolayı kullanılmıyor.16/09/2013 --->
		CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (
						<cfif arguments.list_type eq 3>
							ORDER BY KARMA_PRODUCT_ID asc
						</cfif>
						<cfif arguments.list_type neq 3>
							<cfif isdefined('arguments.sort_type') and arguments.sort_type eq 0>
							 ORDER BY PRODUCT_NAME,PROPERTY
							<cfelseif isdefined('arguments.sort_type') and arguments.sort_type eq 1>
							  ORDER BY STOCK_CODE ASC
							<cfelseif isdefined('arguments.sort_type') and arguments.sort_type eq 3 and arguments.list_type eq 4>
							  ORDER BY SHELF_NUMBER ASC
							<cfelseif isdefined('arguments.sort_type') and arguments.sort_type eq 4 and arguments.list_type eq 4>
							  ORDER BY SHELF_NUMBER DESC
							<cfelse>
							 ORDER BY STOCK_CODE_2, PRODUCT_NAME
							</cfif>
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
				RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)       --->
    </cfquery>
    <cfreturn GET_PRODUCT/>
</cffunction>
