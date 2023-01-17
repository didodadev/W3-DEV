<cfif (isdefined("attributes.price_catid") and (attributes.price_catid eq -1))>
	<cfquery name="GET_PRODUCT" datasource="#DSN1#">
		SELECT 
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			P.TAX,
			P.PRODUCT_CODE,
			P.PROD_COMPETITIVE,
			PS.RECORD_DATE,
			PS.PRICE,
			PS.IS_KDV,
			PS.PRICE_KDV,
			PS.MONEY,
			PU.ADD_UNIT,
			PU.PRODUCT_UNIT_ID,
			PU.UNIT_MULTIPLIER,
			PU.UNIT_MULTIPLIER_STATIC,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			'Standart alış' PRICECAT
		FROM 
			#dsn3_alias#.PRODUCT P, 
			PRICE_STANDART PS, 
			PRODUCT_CAT PC, 
			PRODUCT_UNIT PU,
			STOCKS
			<cfif isDefined("attributes.barcod") and len(attributes.barcod)>			
			,STOCKS_BARCODES
			</cfif>
		WHERE 
			P.PRODUCT_STATUS = 1 AND
			STOCKS.STOCK_STATUS = 1 AND
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			P.PRODUCT_ID = PS.PRODUCT_ID AND
			PS.PURCHASESALES = 0 AND
			PS.PRICESTANDART_STATUS = 1 AND 
			P.PRODUCT_ID = PU.PRODUCT_ID AND
			PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			STOCKS.PRODUCT_ID = P.PRODUCT_ID AND
			STOCKS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
		<cfif isDefined("attributes.barcod") and len(attributes.barcod)>
			AND STOCKS_BARCODES.STOCK_ID = STOCKS.STOCK_ID
			AND STOCKS_BARCODES.BARCODE = '#attributes.barcod#'
		<cfelse>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND 
				(
				<cfif len(attributes.keyword) eq 1 >
					P.PRODUCT_NAME LIKE '#attributes.keyword#%'
				<cfelseif len(attributes.keyword) gt 1>
					<cfif listlen(attributes.keyword,"+") gt 1>
						(
							<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
								P.PRODUCT_NAME LIKE '%#ListGetAt(attributes.keyword,pro_index,"+")#%' 
								<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
							</cfloop>
						)		
					<cfelse>
						P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
					</cfif>
				</cfif>		
				) 
			</cfif>
			<cfif isdefined("attributes.product_hier") and len(attributes.product_hier) and isdefined("attributes.product_cat") and len(attributes.product_cat)>
				AND PC.HIERARCHY LIKE '#attributes.product_hier#%'
			</cfif>
		</cfif>
		<cfif len(attributes.stock_code)>
			AND STOCKS.STOCK_CODE LIKE '%#attributes.stock_code#%'
		</cfif>
		ORDER BY 
			P.PRODUCT_NAME
		</cfquery>
<cfelseif (isdefined("attributes.price_catid") and (attributes.price_catid eq -2))>
	<cfquery name="GET_PRODUCT" datasource="#DSN1#">
		SELECT 
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			P.PROD_COMPETITIVE,
			P.TAX,
			P.PRODUCT_CODE,
			PS.RECORD_DATE,
			PS.PRICE,
			PS.IS_KDV,
			PS.PRICE_KDV,
			PS.MONEY,
			PU.ADD_UNIT,
			PU.PRODUCT_UNIT_ID,
			PU.UNIT_MULTIPLIER,
			PU.UNIT_MULTIPLIER_STATIC,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			'Standart Satış' PRICECAT
		FROM 
			#dsn3_alias#.PRODUCT P, 
			PRICE_STANDART PS, 
			PRODUCT_CAT PC, 
			PRODUCT_UNIT PU,
			STOCKS
		<cfif isDefined("attributes.barcod") and len(attributes.barcod)>
			,STOCKS_BARCODES
		</cfif>		
		WHERE 
			P.PRODUCT_STATUS = 1 AND
			STOCKS.STOCK_STATUS = 1 AND		
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			P.PRODUCT_ID = PS.PRODUCT_ID AND
			PS.PURCHASESALES = 1 AND
			PS.PRICESTANDART_STATUS = 1 AND 
			P.PRODUCT_ID = PU.PRODUCT_ID AND
			PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			STOCKS.PRODUCT_ID = P.PRODUCT_ID AND
			STOCKS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID 
		<cfif isDefined("attributes.barcod") and len(attributes.barcod)>
			AND STOCKS_BARCODES.STOCK_ID = STOCKS.STOCK_ID
			AND STOCKS_BARCODES.BARCODE = '#attributes.barcod#'
		<cfelse>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND
				<cfif len(attributes.keyword) eq 1 >
					P.PRODUCT_NAME LIKE '#attributes.keyword#%' 
				<cfelseif len(attributes.keyword) gt 1>
					<cfif listlen(attributes.keyword,"+") gt 1>
						(
							<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
								P.PRODUCT_NAME LIKE '%#ListGetAt(attributes.keyword,pro_index,"+")#%' 
								<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
							</cfloop>
						)
					<cfelse>
						P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
					</cfif>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.product_hier") and len(attributes.product_hier) and isdefined("attributes.product_cat") and len(attributes.product_cat)>
				AND PC.HIERARCHY LIKE '#attributes.product_hier#%'
			</cfif>
		</cfif>
		<cfif len(attributes.stock_code)>
			AND STOCKS.STOCK_CODE LIKE '%#attributes.stock_code#%'
		</cfif>
		ORDER BY 
			P.PRODUCT_NAME
	</cfquery>	
<cfelse>
	<cfquery name="GET_PRODUCT" datasource="#dsn1#">
			SELECT
				P.PRODUCT_ID,
				P.TAX,
				P.PRODUCT_NAME,
				P.PROD_COMPETITIVE,
				P.PRODUCT_CODE,
				PR.RECORD_DATE,
				PR.PRICE,
				PR.PRICE_KDV,
				PR.IS_KDV,
				PR.MONEY,
				PU.ADD_UNIT,
				PU.PRODUCT_UNIT_ID,
				PU.UNIT_MULTIPLIER,
				PU.UNIT_MULTIPLIER_STATIC,
				STOCKS.STOCK_CODE,
				STOCKS.PROPERTY,
				STOCKS.BARCOD,
				PRICE_CAT.PRICE_CAT PRICECAT
			FROM 
				PRODUCT P,  
				#dsn3_alias#.PRICE PR, 
				PRODUCT_CAT PC,
				PRODUCT_UNIT PU,
				#dsn3_alias#.PRICE_CAT PRICE_CAT,
				STOCKS
			<cfif isDefined("attributes.barcod") and len(attributes.barcod)>
				,STOCKS_BARCODES
			</cfif>		
			WHERE 
				P.PRODUCT_STATUS = 1 AND
				STOCKS.STOCK_STATUS = 1 AND
				PC.PRODUCT_CATID = P.PRODUCT_CATID AND
				P.PRODUCT_ID = PR.PRODUCT_ID AND
				ISNULL(PR.STOCK_ID,0)=0 AND 
				ISNULL(PR.SPECT_VAR_ID,0)=0 AND 
				<cfif len(attributes.price_catid)>
					PR.PRICE_CATID = #attributes.price_catid# AND
				<cfelse>
					PR.PRICE_CATID IN(SELECT
											PRICE_CATID
										FROM
											#dsn3_alias#.PRICE_CAT
										WHERE
											BRANCH LIKE '%,#attributes.branch_id#,%') AND
				</cfif>
				PR.STARTDATE <= #now()# AND
				(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
				P.PRODUCT_ID = PU.PRODUCT_ID AND
				PR.UNIT = PU.PRODUCT_UNIT_ID AND
				STOCKS.PRODUCT_ID = P.PRODUCT_ID AND
				STOCKS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
				PRICE_CAT.PRICE_CAT_STATUS = 1 AND
				PRICE_CAT.PRICE_CATID = PR.PRICE_CATID
			<cfif isDefined("attributes.barcod") and len(attributes.barcod)>
				AND STOCKS_BARCODES.STOCK_ID = STOCKS.STOCK_ID
				AND STOCKS_BARCODES.BARCODE = '#attributes.barcod#'
			<cfelse>
				<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
					AND 
					(
					<cfif len(attributes.keyword) eq 1 >
						P.PRODUCT_NAME LIKE '#attributes.keyword#%' 
					<cfelseif len(attributes.keyword) gt 1>
						<cfif listlen(attributes.keyword,"+") gt 1>
							(
								<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
									P.PRODUCT_NAME LIKE '%#ListGetAt(attributes.keyword,pro_index,"+")#%' 
									<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
								</cfloop>
							)		
						<cfelse>
							P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
						</cfif>
					</cfif>		
					) 
				</cfif>
				<cfif isdefined("attributes.product_hier") and len(attributes.product_hier) and isdefined("attributes.product_cat") and len(attributes.product_cat)>
					AND PC.HIERARCHY LIKE '#attributes.product_hier#%'
				</cfif>
			</cfif>	
			<cfif len(attributes.stock_code)>
				AND STOCKS.STOCK_CODE LIKE '%#attributes.stock_code#%'
			</cfif>
      <cfif not len(attributes.price_catid)>
        UNION ALL
            SELECT 
				P.PRODUCT_ID,
				P.TAX,
				P.PRODUCT_NAME,
				P.PROD_COMPETITIVE,
				P.PRODUCT_CODE,
				PS.RECORD_DATE,
				PS.PRICE,
				PS.PRICE_KDV,
				PS.IS_KDV,
				PS.MONEY,
				PU.ADD_UNIT,
				PU.PRODUCT_UNIT_ID,
				PU.UNIT_MULTIPLIER,
				PU.UNIT_MULTIPLIER_STATIC,
				STOCKS.STOCK_CODE,
				STOCKS.PROPERTY,
				STOCKS.BARCOD,
                'Standart Satış' PRICECAT
            FROM 
                #dsn3_alias#.PRODUCT P, 
                PRICE_STANDART PS, 
                PRODUCT_CAT PC, 
                PRODUCT_UNIT PU,
                STOCKS
            <cfif isDefined("attributes.barcod") and len(attributes.barcod)>
                ,STOCKS_BARCODES
            </cfif>		
            WHERE 
                P.PRODUCT_STATUS = 1 AND
                STOCKS.STOCK_STATUS = 1 AND		
                PC.PRODUCT_CATID = P.PRODUCT_CATID AND
                P.PRODUCT_ID = PS.PRODUCT_ID AND
                PS.PURCHASESALES = 1 AND
                PS.PRICESTANDART_STATUS = 1 AND 
                P.PRODUCT_ID = PU.PRODUCT_ID AND
                PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
                STOCKS.PRODUCT_ID = P.PRODUCT_ID AND
                STOCKS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID 
            <cfif isDefined("attributes.barcod") and len(attributes.barcod)>
                AND STOCKS_BARCODES.STOCK_ID = STOCKS.STOCK_ID
                AND STOCKS_BARCODES.BARCODE = '#attributes.barcod#'
            <cfelse>
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    AND
                    <cfif len(attributes.keyword) eq 1 >
                        P.PRODUCT_NAME LIKE '#attributes.keyword#%' 
                    <cfelseif len(attributes.keyword) gt 1>
                        <cfif listlen(attributes.keyword,"+") gt 1>
                            (
                                <cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
                                    P.PRODUCT_NAME LIKE '%#ListGetAt(attributes.keyword,pro_index,"+")#%' 
                                    <cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
                                </cfloop>
                            )
                        <cfelse>
                            P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
                        </cfif>
                    </cfif>
                </cfif>
                <cfif isdefined("attributes.product_hier") and len(attributes.product_hier) and isdefined("attributes.product_cat") and len(attributes.product_cat)>
                    AND PC.HIERARCHY LIKE '#attributes.product_hier#%'
                </cfif>
            </cfif>
            <cfif len(attributes.stock_code)>
                AND STOCKS.STOCK_CODE LIKE '%#attributes.stock_code#%'
            </cfif>
         </cfif>
            ORDER BY 
                P.PRODUCT_NAME
		</cfquery>
</cfif>
