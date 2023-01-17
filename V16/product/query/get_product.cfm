<cfif isDefined("attributes.pid")><!--- urun detay icin --->
	<!---<cfscript>
		GET_PRODUCT = get_product_list_action.get_product_
		(
			module_name : fusebox.circuit,
			pid : attributes.pid
		);
	</cfscript>--->
	<cfquery name="GET_PRODUCT" datasource="#DSN3#">
		SELECT 
			P.*,
			PU.*,
			PC.PROFIT_MARGIN
		FROM 
			PRODUCT P, 
			PRODUCT_UNIT PU,
			PRODUCT_CAT PC
			<cfif session.ep.isBranchAuthorization>
            ,#dsn1_alias#.PRODUCT_BRANCH PBR
            </cfif>
		WHERE
			P.PRODUCT_ID = #attributes.pid# AND
			P.PRODUCT_ID = PU.PRODUCT_ID AND 
			PU.IS_MAIN = 1 AND
			P.PRODUCT_CATID = PC.PRODUCT_CATID
		<cfif session.ep.isBranchAuthorization><!--- yetkili subelerdeki urunler --->
			AND PBR.PRODUCT_ID = P.PRODUCT_ID
			AND PBR.BRANCH_ID IN  (SELECT
										B.BRANCH_ID
									FROM 
										#dsn_alias#.BRANCH B, 
										#dsn_alias#.EMPLOYEE_POSITION_BRANCHES EPB
									WHERE 
										EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
										EPB.BRANCH_ID = B.BRANCH_ID )
		</cfif>			
	</cfquery>
<cfelse>
	<!--- urunler search icin --->
	<cfquery name="GET_PRODUCT" datasource="#DSN3#">
		SELECT
			<cfif session.ep.isBranchAuthorization>DISTINCT</cfif>
            P.PRODUCT_ID,
			P.PRODUCT_CODE,
			P.PRODUCT_CODE_2,
			P.MANUFACT_CODE,
			P.PRODUCT_NAME,
			P.BARCOD,
			P.TAX,
			P.IS_ADD_XML,
			P.BRAND_ID,
			P.RECORD_MEMBER,
			P.RECORD_DATE,
			P.UPDATE_DATE,
			P.PROD_COMPETITIVE,
			P.MAX_MARGIN,
			P.MIN_MARGIN,
			P.IS_ZERO_STOCK,
			P.RECORD_BRANCH_ID,
			P.PRODUCT_STAGE,
			P.SHORT_CODE_ID,
            P.PRODUCT_DETAIL,
            P.PRODUCT_MANAGER,
		<cfif (isDefined("attributes.price_catid") and (attributes.price_catid eq -1)) or (not isdefined("attributes.price_catid")) or (isDefined("attributes.price_catid") and (attributes.price_catid eq -2))>
			PS.PRICE,
			PS.PRICE_KDV,
			PS.IS_KDV,
			PS.MONEY,
		<cfelseif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
			PR.MONEY,
			PR.PRICE,
			PR.PRICE_KDV,
			PR.IS_KDV,
		</cfif>
			PU.PRODUCT_UNIT_ID,
			PU.ADD_UNIT,
			PU.MAIN_UNIT,
            P.PACKAGE_CONTROL_TYPE,
			P.CUSTOMS_RECIPE_CODE
		FROM 
			PRODUCT P,
		<cfif (isDefined("attributes.price_catid") and (attributes.price_catid eq -1)) or (not isdefined("attributes.price_catid")) or (isDefined("attributes.price_catid") and (attributes.price_catid eq -2))>
			PRICE_STANDART PS,
		<cfelseif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
			PRICE PR,
		</cfif>
		<cfif session.ep.isBranchAuthorization>#dsn1_alias#.PRODUCT_BRANCH PBR,</cfif>
			PRODUCT_UNIT PU
		WHERE
			P.PRODUCT_ID = PU.PRODUCT_ID AND
			PU.PRODUCT_UNIT_STATUS = 1 AND
		<cfif (isDefined("attributes.product_status") and (attributes.product_status neq 2))>
			PRODUCT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.product_status#"> AND
		</cfif>
		<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
			P.IS_PURCHASE = 1 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
			P.IS_INVENTORY = 0 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
			P.IS_INVENTORY = 1 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
			P.IS_TERAZI = 1 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
			P.IS_PURCHASE = 0 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
			P.IS_PRODUCTION = 1 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
			P.IS_SERIAL_NO = 1 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
			P.IS_KARMA = 1 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
			P.IS_INTERNET = 1 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
			P.IS_PROTOTYPE = 1 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
			P.IS_ZERO_STOCK = 1 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
			P.IS_EXTRANET = 1 AND
		<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
			P.IS_COST = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
			P.IS_SALES = 1 AND
		</cfif>
		<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
			P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND
		</cfif>
		<cfif isdefined('attributes.product_stages') and len(attributes.product_stages)>
			PRODUCT_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_stages#"> AND
		</cfif>
		<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)>
			P.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#"> AND
		</cfif>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			(
				P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> OR
				P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM CONTRACT_PURCHASE_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND START_DATE <= #now()# AND FINISH_DATE >= #now()#)
			)
			AND
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
			P.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> AND
		</cfif>
		<cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
			P.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#"> AND
		</cfif>				
		<cfif isdefined("attributes.cat") and len(attributes.cat) and len(attributes.category_name)>
			P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat#.%"> AND
		</cfif>
		<cfif (isDefined("attributes.price_catid") and (attributes.price_catid eq -1)) or (not isdefined("attributes.price_catid")) or (isDefined("attributes.price_catid") and (attributes.price_catid eq -2))>
			PS.PURCHASESALES = <cfif isDefined("attributes.price_catid") and (attributes.price_catid eq -1)>0<cfelse>1</cfif> AND
			PS.PRICESTANDART_STATUS = 1 AND	
			P.PRODUCT_ID = PS.PRODUCT_ID AND
			PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			PU.PRODUCT_UNIT_STATUS = 1
		<cfelseif isDefined("attributes.price_catid") and len(attributes.price_catid) and (attributes.price_catid neq -1) and (attributes.price_catid neq -2)>
			PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
			PR.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			(PR.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PR.FINISHDATE IS NULL) AND
			P.PRODUCT_ID = PR.PRODUCT_ID AND
			<!---ISNULL(PR.STOCK_ID,0) = 0 AND--->
			ISNULL(PR.SPECT_VAR_ID,0) = 0 AND
			PR.UNIT = PU.PRODUCT_UNIT_ID AND
			PU.PRODUCT_UNIT_STATUS = 1
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND 
			(
				<cfif isnumeric(attributes.keyword) and int(attributes.keyword) gt 0>
				<!--- .123 seklinde arama yapildiginda isnumericten gectigi icin hata olusuyordu int de eklenerek bu sekilde degistirildi FBS 20100603 
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#"> .123 şeklinde arama yapıldığında hata vermiyor fakat barcode aratınca hata veriyor 
				bundan sebep <cfqueryparam cfsqltype="cf_sql_numeric" şeklinde yapıldı EÖ 20100920--->
				( P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.keyword#">) )  OR
				</cfif>
				(
					<cfif listlen(attributes.keyword,"+") gt 1>
						(
							<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
								P.PRODUCT_NAME LIKE #sql_unicode()#'<cfif pro_index neq 1>%</cfif>#ListGetAt(attributes.keyword,pro_index,"+")#%' 
								<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
							</cfloop>
						)		
					<cfelse>
						P.PRODUCT_NAME LIKE #sql_unicode()#'%#attributes.keyword#%' OR
						P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#replace(attributes.keyword,'+','')#%"> OR
						P.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR 
						P.PRODUCT_ID IN (SELECT STOCKS.PRODUCT_ID FROM STOCKS,#dsn1_alias#.SETUP_COMPANY_STOCK_CODE SCSC WHERE STOCKS.STOCK_ID = SCSC.STOCK_ID AND (SCSC.COMPANY_STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR SCSC.COMPANY_PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">))
					</cfif>
				)
			)
		</cfif>
		<cfif isDefined("attributes.special_code") and len(attributes.special_code)>
			AND P.PRODUCT_CODE_2 LIKE '<cfif len(attributes.special_code) gt 2>%</cfif>#attributes.special_code#%'
		</cfif>
		<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id) and len(attributes.list_variation_id)>
			AND P.PRODUCT_ID IN
			(
				SELECT
					PRODUCT_ID
				FROM
					#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
				WHERE
					(
				  <cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_index">
					(PROPERTY_ID = #ListGetAt(attributes.list_property_id,pro_index,",")# AND VARIATION_ID = #ListGetAt(attributes.list_variation_id,pro_index,",")#)
                    <cfif ListGetAt(attributes.list_property_value,pro_index,",") neq 'empty'>AND(TOTAL_MAX=#ListGetAt(attributes.list_property_value,pro_index,",")# OR TOTAL_MIN=#ListGetAt(attributes.list_property_value,pro_index,",")#)</cfif>
					<cfif pro_index lt listlen(attributes.list_property_id,',')>OR</cfif>
				  </cfloop>
					)
				GROUP BY
					PRODUCT_ID
				HAVING
					COUNT(PRODUCT_ID)> = #listlen(attributes.list_property_id,',')#
			)
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND PBR.PRODUCT_ID = P.PRODUCT_ID
			AND PBR.BRANCH_ID IN  (SELECT
										B.BRANCH_ID
									FROM 
										#dsn_alias#.BRANCH B, 
										#dsn_alias#.EMPLOYEE_POSITION_BRANCHES EPB
									WHERE 
										EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
										EPB.BRANCH_ID = B.BRANCH_ID )	
		</cfif>
		ORDER BY
			<cfif isdefined("attributes.sort_type") and Len(attributes.sort_type) and attributes.sort_type eq 1>
				PRODUCT_NAME DESC
			<cfelseif isdefined("attributes.sort_type") and Len(attributes.sort_type) and attributes.sort_type eq 2>
				PRODUCT_CODE
			<cfelseif isdefined("attributes.sort_type") and Len(attributes.sort_type) and attributes.sort_type eq 3>
				PRODUCT_CODE DESC
			<cfelseif isdefined("attributes.sort_type") and Len(attributes.sort_type) and attributes.sort_type eq 4>
				PRODUCT_CODE_2 
			<cfelseif isdefined("attributes.sort_type") and Len(attributes.sort_type) and attributes.sort_type eq 5>
				PRODUCT_CODE_2 DESC
			<cfelseif isdefined("attributes.sort_type") and Len(attributes.sort_type) and attributes.sort_type eq 6>
				BARCOD 
			<cfelseif isdefined("attributes.sort_type") and Len(attributes.sort_type) and attributes.sort_type eq 7>
				BARCOD DESC
			<cfelseif isdefined("attributes.sort_type") and Len(attributes.sort_type) and attributes.sort_type eq 8>
				ISNULL(P.UPDATE_DATE,P.RECORD_DATE)
			<cfelseif isdefined("attributes.sort_type") and Len(attributes.sort_type) and attributes.sort_type eq 9>
				ISNULL(P.UPDATE_DATE,P.RECORD_DATE) DESC
			<cfelse>
				PRODUCT_NAME
			</cfif>
	</cfquery>
</cfif>
