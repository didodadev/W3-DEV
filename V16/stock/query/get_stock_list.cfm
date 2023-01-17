<cfparam name="attributes.list_type" default="0">
<!--- amount_flag =2: strateji bazında
	attributes.list_type = 1:stok bazında,2:spec bazında,3 Karma Koli Bazında! --->
<cfquery name="GET_PRODUCT" datasource="#dsn3#">
	<cfif attributes.list_type eq 3>
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
		 <cfif attributes.list_type eq 1 and isdefined("attributes.amount_flag") and attributes.amount_flag eq 2>
			<cfif isdefined("attributes.is_saleable_stock")>
				TABLE1.REAL_STOCK,
			</cfif>
		</cfif>
		<cfif isDefined("x_include_scrap_location") and x_include_scrap_location eq 0>
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
            <cfif attributes.list_type eq 2>
            SR.SPECT_VAR_ID,
            <cfelseif attributes.list_type eq 3>
            KP.KARMA_PRODUCT_ID,
            KP.PRODUCT_AMOUNT,
            <cfelseif attributes.list_type eq 4>
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
            <cfif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 2>
            GS_STRATEGY.MAXIMUM_STOCK,
            GS_STRATEGY.REPEAT_STOCK_VALUE,
            GS_STRATEGY.MINIMUM_STOCK,
            GS_STRATEGY.PROVISION_TIME,
            GS_STRATEGY.MINIMUM_ORDER_STOCK_VALUE,
			GS_STRATEGY.BLOCK_STOCK_VALUE,
			GS_STRATEGY.STOCK_ACTION_ID,
            </cfif>
            <cfif isdefined('attributes.group_unit_2')>
            SR.UNIT2,
            SUM(CASE WHEN (SR.STOCK_IN - SR.STOCK_OUT) < 0 THEN SR.AMOUNT2*-1 WHEN (SR.STOCK_IN - SR.STOCK_OUT) > 0 THEN SR.AMOUNT2 END) AMOUNT2,
            </cfif>
			<cfif isDefined("x_include_scrap_location") and x_include_scrap_location eq 0>
			<!--- Xml Hurda Lokasyonu Miktara Dahil Edilsin Mi --->
			ISNULL((SELECT 
						SUM(STOCK_IN - SR.STOCK_OUT) HURDA_STOCK
					FROM 
						#dsn2_alias#.STOCKS_ROW SR,
						#dsn_alias#.STOCKS_LOCATION SL 
					WHERE 
						SR.STOCK_ID = S.STOCK_ID AND
						SR.STORE = SL.DEPARTMENT_ID AND
						SR.STORE_LOCATION = SL.LOCATION_ID AND
						ISNULL(SL.IS_SCRAP,0)=1
				),0) HURDA_STOCK,
			</cfif>
			<cfif listfind('1,2,3,4',attributes.list_type,',')>
				<cfif attributes.list_type eq 1 and isdefined("attributes.amount_flag") and attributes.amount_flag eq 2>
					<cfif isdefined("attributes.is_saleable_stock")>
						SUM(SR.SALEABLE_STOCK) AS PRODUCT_STOCK, <!--- stok stratejisi satılabilir stoga gore calıstıgı icin listeye de satılabilir stok miktarı getiriliyor --->
						SUM(SR.PRODUCT_STOCK) AS REAL_STOCK
					<cfelse>
						SUM(SR.PRODUCT_STOCK) AS PRODUCT_STOCK
					</cfif>
				<cfelseif attributes.list_type eq 3>	
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
            <cfif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 2>
            #dsn2_alias#.GET_STOCK_STRATEGY GS_STRATEGY,
            </cfif>
            <cfif attributes.list_type eq 1 and isdefined("attributes.amount_flag") and attributes.amount_flag eq 2>
                <cfif len(attributes.department_id)>
                    #dsn2_alias#.GET_STOCK_LAST_LOCATION SR
                <cfelse>
                    #dsn2_alias#.GET_STOCK_LAST SR
                </cfif>
            <cfelse>
                #dsn2_alias#.STOCKS_ROW SR
            </cfif>
            <cfif attributes.list_type eq 3>
                ,#dsn1_alias#.KARMA_PRODUCTS KP
            </cfif>
        WHERE
            S.IS_INVENTORY = 1 AND 
            PU.IS_MAIN = 1 AND
          	<cfif isdefined('attributes.product_types') and len(attributes.product_types)>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
					S.IS_PURCHASE = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
					S.IS_TERAZI = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
					S.IS_PURCHASE = 0 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
					S.IS_PRODUCTION = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
					S.IS_SERIAL_NO = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
					S.IS_KARMA = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
					S.IS_INTERNET = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
					S.IS_PROTOTYPE = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
					S.IS_ZERO_STOCK = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
					S.IS_EXTRANET = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
					S.IS_COST = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
					S.IS_SALES = 1 AND
				</cfif>
			</cfif>
		  <cfif isdefined('attributes.date1') and len(attributes.date1) and  isdefined('attributes.date2') and len(attributes.date2)>
            SR.PROCESS_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
          </cfif>
          <cfif attributes.list_type neq 3><!--- Karma Koli İse Bu bloğa girmesin,buraya girerse karma koliyi oluşturan ürün özelliklerine göre arama yapmış olur bize gereken bu değil!Ana ürün İçin Yapması Gerekiyor Dolayısı ile bu bloklar aşağıda çalışacak.. --->
			  <cfif isDefined("attributes.is_stock_active") and attributes.is_stock_active neq 2>
                S.PRODUCT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_stock_active#"> AND
              </cfif>
              <cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and isnumeric(attributes.employee_id) and len(attributes.employee)>
                S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
              </cfif>
              <cfif isDefined("attributes.company_id") and len(attributes.company_id) and isnumeric(attributes.company_id) and len(attributes.company)>
                (
					S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> OR
					S.PRODUCT_ID IN (SELECT PRODUCT_ID FROM CONTRACT_PURCHASE_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
				) 
				AND
              </cfif>
              <cfif isDefined("attributes.search_product_catid") and len(attributes.search_product_catid) and len(attributes.product_cat)>
                S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"> AND
              </cfif>
			  
			  <cfif isDefined("attributes.product_brand_id") and len(attributes.product_brand_id) and len(attributes.product_brand_name)>
                S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_brand_id#"> AND
              </cfif>
			  <cfif isDefined("attributes.product_model_id") and len(attributes.product_model_id) and len(attributes.product_model_name)>
                S.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_model_id#"> AND
              </cfif>
              <cfif isDefined("attributes.barcod") and len(attributes.barcod)>
                S.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.barcod#"> AND
              <cfelseif isDefined("attributes.keyword") and len(attributes.keyword)>
                (	
                  <cfif isnumeric(attributes.keyword) and int(attributes.keyword) gt 0>
                    (S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#">) OR
                  </cfif>
				 (
                  <cfif len(attributes.keyword) lte 3>
                    (S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)	
                  <cfelseif len(attributes.keyword) gt 3 or listlen(attributes.keyword,"+")>
                    (
                        (
                          <cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
                            S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ListGetAt(attributes.keyword,pro_index,'+')#%">
                            <cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
                          </cfloop>
                        )		
                        OR S.STOCK_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    )				
                  </cfif>
                    )
                    OR S.MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                ) AND
              </cfif>
			  <cfif attributes.list_type eq 4 and isdefined("attributes.shelf_number") and len(attributes.shelf_number) and len(attributes.shelf_number_txt)>
			  	SR.SHELF_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.shelf_number#"> AND
			  </cfif>
              <cfif isDefined("attributes.stock_code") and len(attributes.stock_code)>
                S.STOCK_CODE LIKE '<cfif len(attributes.stock_code) gt 3>%</cfif>#attributes.stock_code#%' AND
              </cfif>
              <cfif isDefined("attributes.ozel_kod") and len(attributes.ozel_kod)>
                S.STOCK_CODE_2 LIKE '<cfif len(attributes.ozel_kod) gt 3>%</cfif>#attributes.ozel_kod#%' AND
              </cfif>
          </cfif>
            SR.STOCK_ID = S.STOCK_ID AND
            <cfif attributes.list_type eq 3>
            	KP.STOCK_ID = SR.STOCK_ID AND
            </cfif>
			<cfif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 2>
				S.PRODUCT_ID = GS_STRATEGY.PRODUCT_ID AND
				S.STOCK_ID = GS_STRATEGY.STOCK_ID AND
				<cfif isdefined('attributes.department_id') and len(attributes.department_id)>
					GS_STRATEGY.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListFirst(attributes.department_id,'-')#"> AND
				<cfelse>
					GS_STRATEGY.DEPARTMENT_ID IS NULL AND 
				</cfif>
			</cfif>
            S.PRODUCT_ID = PU.PRODUCT_ID
			<cfif len(attributes.department_id)>
				<cfif listlen(attributes.department_id,'-') eq 1>
					<cfif attributes.amount_flag eq 2 and attributes.list_type eq 1>
						AND SR.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
					<cfelse>
						AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
					</cfif>
				<cfelseif listlen(attributes.department_id,'-') eq 2>
					<cfif attributes.amount_flag eq 2 and attributes.list_type eq 1 >
						AND SR.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_id,'-')#">
						AND SR.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department_id,'-')#">
					<cfelse>
						AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_id,'-')#">
						AND SR.STORE_lOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department_id,'-')#">
					</cfif>
				</cfif>
			</cfif>	
			<cfif len(attributes.list_property_id)><!--- stok ozelliklerine gore arama --->
				<cfif attributes.property_search_type eq 1>
					AND S.STOCK_ID IN 
					(
						SELECT
							STOCK_ID
						FROM
							STOCKS_PROPERTY
						WHERE
							(
							  <cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_index">
								(	
									PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_property_id,pro_index,',')#"> AND 
									PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_variation_id,pro_index,',')#">
								)
								<cfif pro_index lt listlen(attributes.list_property_id,',')>OR</cfif>
							  </cfloop>
							)
						GROUP BY
							STOCK_ID
						HAVING
							COUNT(STOCK_ID)> = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(attributes.list_property_id,',')#">
					)
				<cfelseif attributes.property_search_type eq 2>
					AND
					<cfloop list="#attributes.list_property_name#" index="pro_index" delimiters="|,|">
					S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#pro_index#%">
					<cfif pro_index neq listlast(attributes.list_property_name,'|,|')>AND</cfif>
					</cfloop>
				<cfelseif attributes.property_search_type eq 3>
					AND
					SR.SPECT_VAR_ID IN 
					(SELECT SPECT_MAIN_ID FROM SPECT_MAIN WHERE
						<cfloop list="#attributes.list_variation_code#" index="pro_index" delimiters="|,|">
							SPECT_MAIN_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#pro_index#%">
							<cfif pro_index neq listlast(attributes.list_variation_code,'|,|')>AND</cfif>
						</cfloop>
					)
				<cfelseif attributes.property_search_type eq 4>
					AND
					SR.SPECT_VAR_ID IN
					(
					SELECT 
						SPECT_MAIN.SPECT_MAIN_ID
					FROM 
						#dsn3_alias#.SPECT_MAIN_ROW SPECT_MAIN_ROW,
						#dsn3_alias#.SPECT_MAIN SPECT_MAIN
					WHERE
						SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID AND
						(
							<cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_index">
								(
									SPECT_MAIN_ROW.IS_PROPERTY=1
									<cfif isdefined('attributes.list_property_id') and listgetat(attributes.list_property_id,pro_index,',') gt 0>
										AND SPECT_MAIN_ROW.PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.list_property_id,pro_index,',')#">
									</cfif>
									<cfif isdefined('attributes.list_variation_id') and listgetat(attributes.list_variation_id,pro_index,',') gt 0>
										AND SPECT_MAIN_ROW.VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.list_variation_id,pro_index,',')#">
									</cfif>
								) 
								<cfif listlen(attributes.list_property_id,',') gt pro_index>OR</cfif>
							</cfloop>
						)
					GROUP BY SPECT_MAIN.SPECT_MAIN_ID
					HAVING COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(attributes.list_property_id,',')#">
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
            <cfif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 2 >
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
            <cfif listfind('1,2,3,4',attributes.list_type,',')>
                <cfif len(attributes.department_id)>
					<cfif listlen(attributes.department_id,'-') eq 1>
						<cfif attributes.amount_flag eq 2 and attributes.list_type eq 1>
							,SR.DEPARTMENT_ID
						<cfelse>
							,SR.STORE
						</cfif>
					<cfelseif listlen(attributes.department_id,'-') eq 2>
						<cfif attributes.amount_flag eq 2 and attributes.list_type eq 1>
							,SR.DEPARTMENT_ID
							,SR.LOCATION_ID
						<cfelse>
							,SR.STORE
							,SR.STORE_lOCATION
						</cfif>
					</cfif>					
                </cfif>
                <cfif attributes.list_type eq 2>
                ,SR.SPECT_VAR_ID
                <cfelseif attributes.list_type eq 3>
                ,KP.KARMA_PRODUCT_ID
                ,KP.PRODUCT_AMOUNT
				<cfelseif attributes.list_type eq 4>
				,SR.SHELF_NUMBER
                </cfif>
            </cfif>
            <cfif isdefined('attributes.group_unit_2')>
            ,SR.UNIT2
            </cfif>
        <cfif attributes.list_type eq 1>          
		    <cfif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 0>
                HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) < 0
            <cfelseif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 1>
                HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) > 0
            <cfelseif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 3><!--- sıfır stok --->
                HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) = 0
   			<cfelseif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 2>
                <cfif isdefined("attributes.is_saleable_stock")> <!---strateji satılabilir stok uzerinden hesaplanır --->
                    <cfif isdefined('attributes.strategy_type') and attributes.strategy_type eq 1><!--- fazla stok --->
                        HAVING SUM(SALEABLE_STOCK) >= GS_STRATEGY.MAXIMUM_STOCK
                    <cfelseif isdefined('attributes.strategy_type') and attributes.strategy_type eq 2><!--- eksik stok --->
                        HAVING SUM(SALEABLE_STOCK) <= GS_STRATEGY.MINIMUM_STOCK	
                    <cfelseif isdefined('attributes.strategy_type') and attributes.strategy_type eq 3><!--- yeniden siparis noktasına gelen urunler --->
                        HAVING SUM(SALEABLE_STOCK) <= GS_STRATEGY.REPEAT_STOCK_VALUE AND SUM(SALEABLE_STOCK) > GS_STRATEGY.MINIMUM_STOCK
                    </cfif>
                <cfelseif not len(attributes.department_id)>
                    <cfif isdefined('attributes.strategy_type') and attributes.strategy_type eq 1><!--- fazla stok --->
                        HAVING
							SUM(PRODUCT_STOCK) >= GS_STRATEGY.MAXIMUM_STOCK AND
							SUM(PRODUCT_STOCK) > 0 AND
							SUM(PRODUCT_STOCK) >= GS_STRATEGY.MINIMUM_STOCK
                    <cfelseif isdefined('attributes.strategy_type') and attributes.strategy_type eq 2><!--- eksik stok --->
                        HAVING SUM(PRODUCT_STOCK) <= GS_STRATEGY.MINIMUM_STOCK	
                    <cfelseif isdefined('attributes.strategy_type') and attributes.strategy_type eq 3><!--- yeniden siparis noktasına gelen urunler --->
                        HAVING SUM(PRODUCT_STOCK) <= GS_STRATEGY.REPEAT_STOCK_VALUE AND SUM(PRODUCT_STOCK) > GS_STRATEGY.MINIMUM_STOCK
                    </cfif>
                <cfelse>
                    <cfif isdefined('attributes.strategy_type') and attributes.strategy_type eq 1><!--- fazla stok --->
                        HAVING SUM(PRODUCT_STOCK) >= GS_STRATEGY.MAXIMUM_STOCK
                    <cfelseif isdefined('attributes.strategy_type') and attributes.strategy_type eq 2><!--- eksik stok --->
                        HAVING SUM(PRODUCT_STOCK) <= GS_STRATEGY.MINIMUM_STOCK	
                    <cfelseif isdefined('attributes.strategy_type') and attributes.strategy_type eq 3><!--- yeniden siparis noktasına gelen urunler --->
                        HAVING SUM(PRODUCT_STOCK) <= GS_STRATEGY.REPEAT_STOCK_VALUE AND SUM(PRODUCT_STOCK) > GS_STRATEGY.MINIMUM_STOCK
                    </cfif>
                    
                </cfif>
            </cfif>
        <cfelse>
            <cfif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 0 >
                HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) < 0
            <cfelseif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 1 >
                HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) > 0
            <cfelseif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 3 ><!--- sıfır stok --->
                HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) = 0
            <cfelseif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 2 >
                <cfif isdefined('attributes.strategy_type') and attributes.strategy_type eq 2><!--- eksik stok --->
                    HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) <= GS_STRATEGY.MINIMUM_STOCK	
                <cfelseif isdefined('attributes.strategy_type') and attributes.strategy_type eq 3><!--- yeniden siparis noktasına gelen urunler --->
                    HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) <= GS_STRATEGY.REPEAT_STOCK_VALUE AND SUM(SR.STOCK_IN - SR.STOCK_OUT) > GS_STRATEGY.MINIMUM_STOCK
                <cfelseif isdefined('attributes.strategy_type') and attributes.strategy_type eq 1><!--- fazla stok --->
                    HAVING ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) >= GS_STRATEGY.MAXIMUM_STOCK
                </cfif>
            </cfif>
        </cfif>
        <cfif attributes.list_type neq 3>
			<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 0>
                 ORDER BY S.PRODUCT_NAME, S.PROPERTY
            <cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 1>
                  ORDER BY S.STOCK_CODE
            <cfelse>
				 ORDER BY S.STOCK_CODE_2, S.PRODUCT_NAME
			</cfif>
        </cfif>
    <cfif attributes.list_type eq 3>
		) TABLE1,
          STOCKS SS
        WHERE 
        <!--- Bu Alttaki Where Bloğundakiler Yukardaki Where Bloğunun Kopyası.Yukarda bakarken S.STOCK_CODE diye bakıyor burda ise SS.STOCK_CODE diye... --->
		<cfif isDefined("attributes.is_stock_active") and attributes.is_stock_active neq 2>
            SS.PRODUCT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_stock_active#"> AND
        </cfif>
        <cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and isnumeric(attributes.employee_id) and len(attributes.employee)>
            SS.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
        </cfif>
        <cfif isDefined("attributes.company_id") and len(attributes.company_id) and isnumeric(attributes.company_id) and len(attributes.company)>
            (
				SS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> OR
				SS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM CONTRACT_PURCHASE_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			)
			AND
        </cfif>
        <cfif isDefined("attributes.search_product_catid") and len(attributes.search_product_catid) and len(attributes.product_cat)>
            SS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"> AND
        </cfif>
		<cfif isDefined("attributes.product_brand_id") and len(attributes.product_brand_id) and len(attributes.product_brand_name)>
            SS.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_brand_id#"> AND
        </cfif>
		<cfif isDefined("attributes.product_model_id") and len(attributes.product_model_id) and len(attributes.product_model_name)>
            SS.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_model_id#"> AND
        </cfif>
        <cfif isDefined("attributes.barcod") and len(attributes.barcod)>
            SS.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.barcod#"> AND
        <cfelseif isDefined("attributes.keyword") and len(attributes.keyword)>
        (	
          <cfif isnumeric(attributes.keyword) and int(attributes.keyword) gt 0>
			(SS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#">) OR
		  </cfif>
            (
          <cfif len(attributes.keyword) lte 3 >
            (SS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">)	
          <cfelseif len(attributes.keyword) gt 3 or listlen(attributes.keyword,"+")>
            (
                (
                  <cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
                    SS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ListGetAt(attributes.keyword,pro_index,'+')#%">
                    <cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
                  </cfloop>
                )		
                OR SS.STOCK_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            )				
          </cfif>
            )
            OR SS.MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
        ) AND
        </cfif>
        <cfif isDefined("attributes.stock_code") and len(attributes.stock_code)>
            SS.STOCK_CODE LIKE '<cfif len(attributes.stock_code) gt 3>%</cfif>#attributes.stock_code#%' AND
        </cfif>
        <cfif isDefined("attributes.ozel_kod") and len(attributes.ozel_kod)>
            SS.STOCK_CODE_2 LIKE '<cfif len(attributes.ozel_kod) gt 3>%</cfif>#attributes.ozel_kod#%' AND
        </cfif>
	SS.PRODUCT_ID = TABLE1.KARMA_PRODUCT_ID    
        ORDER BY
	        TABLE1.KARMA_PRODUCT_ID
	</cfif>        
</cfquery>
