<cffunction name="get_product_" returntype="query">
	<cfargument name="pid" default="">
    <cfargument name="startrow" default="1">
    <cfargument name="maxrows" default="#session.ep.maxrows#">
	<cfquery name="GET_PRODUCT" datasource="#this.DSN1#">
		WITH CTE1 AS (
        SELECT 
            P.PRODUCT_ID,
            P.PRODUCT_STATUS,
            P.PRODUCT_CODE,
            P.COMPANY_ID,
            P.PRODUCT_CATID,
            PC.PRODUCT_CAT,
            PC.HIERARCHY,
            P.BARCOD,
            CASE
                WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                ELSE PRODUCT_NAME
            END AS PRODUCT_NAME,
            CASE
                WHEN LEN(SLI2.ITEM) > 0 THEN SLI2.ITEM
                ELSE PRODUCT_DETAIL
            END AS PRODUCT_DETAIL,
            CASE
                WHEN LEN(SLI3.ITEM) > 0 THEN SLI3.ITEM
                ELSE PRODUCT_DETAIL2
            END AS PRODUCT_DETAIL2,
            P.TAX,
            P.TAX_PURCHASE,
            P.IS_INVENTORY,
            P.IS_PRODUCTION,
            P.SHELF_LIFE,
            P.IS_SALES,
            P.IS_PURCHASE,
            P.MANUFACT_CODE,
            P.IS_PROTOTYPE,
            P.PRODUCT_TREE_AMOUNT,
            P.PRODUCT_MANAGER,
            P.SEGMENT_ID,
            P.IS_INTERNET,
            P.PROD_COMPETITIVE,
            P.PRODUCT_STAGE,
            P.IS_TERAZI,
            P.BRAND_ID,
            P.IS_SERIAL_NO,
            P.IS_ZERO_STOCK,
            P.MIN_MARGIN,
            P.MAX_MARGIN,
            P.OTV,
            P.IS_KARMA,
            P.PRODUCT_CODE_2,
            P.SHORT_CODE,
            P.IS_COST,
            P.WORK_STOCK_ID,
            P.WORK_STOCK_AMOUNT,
            P.IS_EXTRANET,
            P.IS_KARMA_SEVK,
            P.RECORD_BRANCH_ID,
            P.RECORD_MEMBER,
            P.RECORD_DATE,
            P.MEMBER_TYPE,
            P.UPDATE_DATE,
            P.UPDATE_EMP,
            P.UPDATE_PAR,
            P.UPDATE_IP,
            CASE
                WHEN LEN(SLI4.ITEM) > 0 THEN SLI4.ITEM
                ELSE P.USER_FRIENDLY_URL
            END AS USER_FRIENDLY_URL,
            P.PACKAGE_CONTROL_TYPE,
            P.IS_LIMITED_STOCK,
            P.SHORT_CODE_ID,
            P.IS_COMMISSION,
            P.CUSTOMS_RECIPE_CODE,
            P.IS_ADD_XML,
            P.IS_GIFT_CARD,
            P.GIFT_VALID_DAY,
            P.REF_PRODUCT_CODE,
            P.IS_QUALITY,
            P.QUALITY_START_DATE,
            P.IS_LOT_NO,            
            PU.PRODUCT_UNIT_ID, 
            PU.PRODUCT_UNIT_STATUS,  
            PU.MAIN_UNIT_ID, 
            PU.MAIN_UNIT, 
            PU.UNIT_ID, 
            PU.ADD_UNIT, 
            PU.MULTIPLIER, 
            PU.DIMENTION, 
            PU.DESI_VALUE, 
            PU.WEIGHT, 
            PU.IS_MAIN, 
            PU.IS_SHIP_UNIT, 
            PU.UNIT_MULTIPLIER, 
            PU.UNIT_MULTIPLIER_STATIC, 
            PU.VOLUME, 
            PU.RECORD_EMP, 
            PU.IS_ADD_UNIT,
			PC.PROFIT_MARGIN,
            PB.BRAND_NAME,
            PB.BRAND_CODE,
            PBM.MODEL_NAME,
            C.FULLNAME COMPANY
		FROM 
			PRODUCT P
            	JOIN PRODUCT_OUR_COMPANY ON PRODUCT_OUR_COMPANY.PRODUCT_ID  = P.PRODUCT_ID AND PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #session.ep.company_id#
            	LEFT JOIN PRODUCT_BRANDS PB ON P.BRAND_ID = PB.BRAND_ID
                LEFT JOIN PRODUCT_BRANDS_MODEL PBM ON P.SHORT_CODE_ID = PBM.MODEL_ID
                LEFT JOIN #this.dsn_alias#.COMPANY C ON C.COMPANY_ID = P.COMPANY_ID
            	LEFT JOIN #this.dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = P.PRODUCT_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_NAME">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
                LEFT JOIN #this.dsn_alias#.SETUP_LANGUAGE_INFO SLI2 ON SLI2.UNIQUE_COLUMN_ID = P.PRODUCT_ID
                AND SLI2.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_DETAIL">
                AND SLI2.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT">
                AND SLI2.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
                LEFT JOIN #this.dsn_alias#.SETUP_LANGUAGE_INFO SLI3 ON SLI3.UNIQUE_COLUMN_ID = P.PRODUCT_ID
                AND SLI3.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_DETAIL2">
                AND SLI3.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT">
                AND SLI3.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
                LEFT JOIN #this.dsn_alias#.SETUP_LANGUAGE_INFO SLI4 ON SLI4.UNIQUE_COLUMN_ID = P.PRODUCT_ID
                AND SLI4.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="USER_FRIENDLY_URL">
                AND SLI4.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT">
                AND SLI4.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
                ,			 
			PRODUCT_UNIT PU,
			PRODUCT_CAT PC
			<cfif session.ep.isBranchAuthorization>
           		,PRODUCT_BRANCH PBR
            </cfif>
		WHERE
			P.PRODUCT_ID = #pid# AND
			P.PRODUCT_ID = PU.PRODUCT_ID AND 
			PU.IS_MAIN = 1 AND
			P.PRODUCT_CATID = PC.PRODUCT_CATID
			<cfif session.ep.isBranchAuthorization> <!--- BK 20070702 yetkili subelerdeki urunler --->
				AND PBR.PRODUCT_ID = P.PRODUCT_ID
				AND PBR.BRANCH_ID IN  (SELECT
											B.BRANCH_ID
										FROM 
											#this.dsn_alias#.BRANCH B, 
											#this.dsn_alias#.EMPLOYEE_POSITION_BRANCHES EPB
										WHERE 
											EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
											EPB.BRANCH_ID = B.BRANCH_ID )
			</cfif>
         ),
             CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (	ORDER BY PRODUCT_ID ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
	</cfquery>
	<cfreturn GET_PRODUCT/>
</cffunction>

<cffunction name="get_product2_" returntype="query">
	<cfargument name="price_catid" default="">
	<cfargument name="product_status" default="">
    <cfargument name="product_name" default="">
    <cfargument name="barcode" default="">
	<cfargument name="product_types" default="">
	<cfargument name="pos_code" default="">
	<cfargument name="product_stages" default="">
	<cfargument name="record_emp_id" default="">
	<cfargument name="company_id" default="">
	<cfargument name="brand_id" default="">
	<cfargument name="brand_name" default="">
	<cfargument name="short_code_id" default="">
	<cfargument name="short_code_name" default="">
	<cfargument name="cat" default="">
	<cfargument name="category_name" default="">
	<cfargument name="keyword" default="">
	<cfargument name="special_code" default="">
	<cfargument name="list_property_id" default="">
	<cfargument name="list_variation_id" default="">
	<cfargument name="sort_type" default="">
    <cfargument name="startrow" default="">
    <cfargument name="BARCODE1" default="">
    <cfargument name="PRODUCT_NAME1" default="">
    <cfargument name="SPECIAL_CODE1" default="">
    <cfargument name="MANUFACT_CODE1" default="">
    <cfargument name="USER_FRIENDLY_URL1" default="">
    <cfargument name="PRODUCT_CODE1" default="">
    <cfargument name="PRODUCT_DETAIL1" default="">
    <cfargument name="COMPANY_STOCK_CODE1" default="">
    <cfargument name="COMPANY_PRODUCT_NAME1" default="">
    <cfargument name="maxrows" default="">
    <cfif len(arguments.PRODUCT_NAME1) or len(arguments.BARCODE1) or len(arguments.SPECIAL_CODE1) or len(arguments.MANUFACT_CODE1) or len(arguments.USER_FRIENDLY_URL1) or len(arguments.PRODUCT_CODE1) or len(arguments.PRODUCT_DETAIL1) or len(arguments.COMPANY_STOCK_CODE1) or len(arguments.COMPANY_PRODUCT_NAME1)>  
		<cfelse>
        	<cfset arguments.BARCODE1 = 1 >            
            <cfset arguments.PRODUCT_NAME1 = 1 >
            <cfset arguments.SPECIAL_CODE1 = 1 >
            <cfset arguments.MANUFACT_CODE1 = 1 >
            <cfset arguments.USER_FRIENDLY_URL1 = 1 >
            <cfset arguments.PRODUCT_CODE1 = 1 >
            <cfset arguments.PRODUCT_DETAIL1 = 1 >
            <cfset arguments.COMPANY_STOCK_CODE1 = 1 >
            <cfset arguments.COMPANY_PRODUCT_NAME1 = 1 >
    </cfif>
	<cfquery name="GET_PRODUCT" datasource="#this.DSN3#">
		WITH CTE1 AS (
        SELECT
			<cfif session.ep.isBranchAuthorization>DISTINCT</cfif><!--- FB 20070702 sube icin --->
            P.PRODUCT_ID,
			P.PRODUCT_CODE,
			P.PRODUCT_CODE_2,
			P.MANUFACT_CODE,
            SLI.ITEM,
            CASE
                WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                ELSE PRODUCT_NAME
            END AS PRODUCT_NAME,
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
		<cfif (isDefined("price_catid") and (price_catid eq -1)) or (not isdefined("price_catid")) or (isDefined("price_catid") and (price_catid eq -2))>
			PS.PRICE,
			PS.PRICE_KDV,
			PS.IS_KDV,
			PS.MONEY,
		<cfelseif isDefined("price_catid") and len(price_catid) and (price_catid neq -1) and (price_catid neq -2)>
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
			PRODUCT P
	            LEFT JOIN #this.dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = P.PRODUCT_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_NAME">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">,
		<cfif (isDefined("price_catid") and (price_catid eq -1)) or (not isdefined("price_catid")) or (isDefined("price_catid") and (price_catid eq -2))>
			PRICE_STANDART PS,
		<cfelseif isDefined("price_catid") and len(price_catid) and (price_catid neq -1) and (price_catid neq -2)>
			PRICE PR,
		</cfif>
		<cfif session.ep.isBranchAuthorization>#this.dsn1_alias#.PRODUCT_BRANCH PBR,</cfif><!--- FB 20070702 sube icin --->
			PRODUCT_UNIT PU
		WHERE
			P.PRODUCT_ID = PU.PRODUCT_ID AND
			PU.PRODUCT_UNIT_STATUS = 1 AND
		<cfif (isDefined("product_status") and (product_status neq 2))>
			PRODUCT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#product_status#"> AND
		</cfif>
		<cfif isdefined('product_types') and (product_types eq 1)>
			P.IS_PURCHASE = 1 AND
		<cfelseif isdefined('product_types') and (product_types eq 2)>
			P.IS_INVENTORY = 0 AND
		<cfelseif isdefined('product_types') and (product_types eq 3)>
			P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
		<cfelseif isdefined('product_types') and (product_types eq 4)>
			P.IS_TERAZI = 1 AND
		<cfelseif isdefined('product_types') and (product_types eq 5)>
			P.IS_PURCHASE = 0 AND
		<cfelseif isdefined('product_types') and (product_types eq 6)>
			P.IS_PRODUCTION = 1 AND
		<cfelseif isdefined('product_types') and (product_types eq 7)>
			P.IS_SERIAL_NO = 1 AND
		<cfelseif isdefined('product_types') and (product_types eq 8)>
			P.IS_KARMA = 1 AND
		<cfelseif isdefined('product_types') and (product_types eq 9)>
			P.IS_INTERNET = 1 AND
		<cfelseif isdefined('product_types') and (product_types eq 10)>
			P.IS_PROTOTYPE = 1 AND
		<cfelseif isdefined('product_types') and (product_types eq 11)>
			P.IS_ZERO_STOCK = 1 AND
		<cfelseif isdefined('product_types') and (product_types eq 12)>
			P.IS_EXTRANET = 1 AND
		<cfelseif isdefined('product_types') and (product_types eq 13)>
			P.IS_COST = 1 AND
		<cfelseif isdefined('product_types') and (product_types eq 14)>
			P.IS_SALES = 1 AND
        <cfelseif isdefined('product_types') and (product_types eq 15)>
			P.IS_QUALITY = 1 AND
        <cfelseif isdefined('product_types') and (product_types eq 16)>
			P.IS_INVENTORY = 1 AND
        <cfelseif isdefined('product_types') and (product_types eq 17)>
			P.IS_LOT_NO = 1 AND
	<cfelseif isdefined('product_types') and (product_types eq 18)>
			P.IS_LIMITED_STOCK = 1 AND
		</cfif>
		<cfif isdefined("pos_code") and len(pos_code)>
			P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#"> AND
		</cfif>
		<cfif isdefined('product_stages') and len(product_stages)>
			PRODUCT_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_stages#"> AND
		</cfif>
		<cfif isdefined("record_emp_id") and len(record_emp_id)>
			P.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_emp_id#"> AND
		</cfif>
		<cfif isdefined("company_id") and len(company_id)>
			(
				P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"> OR
				P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM CONTRACT_PURCHASE_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"> AND START_DATE <= #now()# AND FINISH_DATE >= #now()#)
			)
			AND
		</cfif>
		<cfif isdefined("brand_id") and len(brand_id) and len(brand_name)>
			P.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#brand_id#"> AND
		</cfif>
		<cfif isdefined("short_code_id") and len(short_code_id) and len(short_code_name)>
			P.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#short_code_id#"> AND
		</cfif>				
		<cfif isdefined("cat") and len(cat) and len(category_name)>
			P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#cat#.%"> AND
		</cfif>
		<cfif (isDefined("price_catid") and (price_catid eq -1)) or (not isdefined("price_catid")) or (isDefined("price_catid") and (price_catid eq -2))>
			PS.PURCHASESALES = <cfif isDefined("price_catid") and (price_catid eq -1)>0<cfelse>1</cfif> AND
			PS.PRICESTANDART_STATUS = 1 AND	
			P.PRODUCT_ID = PS.PRODUCT_ID AND
			PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			PU.PRODUCT_UNIT_STATUS = 1
		<cfelseif isDefined("price_catid") and len(price_catid) and (price_catid neq -1) and (price_catid neq -2)>
			PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#"> AND
			PR.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			(PR.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PR.FINISHDATE IS NULL) AND
			P.PRODUCT_ID = PR.PRODUCT_ID AND
			ISNULL(PR.STOCK_ID,0) = 0 AND
			ISNULL(PR.SPECT_VAR_ID,0) = 0 AND
			PR.UNIT = PU.PRODUCT_UNIT_ID AND
			PU.PRODUCT_UNIT_STATUS = 1
		</cfif>
			<cfif isdefined('arguments.keyword') and len(arguments.keyword)>
				<cfif ListLen(arguments.keyword,';') gt 1>
                    AND
                    (
                    <cfset p_sayac = 0>
                    <cfloop list="#arguments.keyword#" index="pro_index">
                    <cfset p_sayac = p_sayac+1>
                    (
                    	 CASE    
                         	WHEN LEN(SLI.ITEM) > 0 
                         THEN 
                         	SLI.ITEM 
                		ELSE
                    	P.PRODUCT_NAME
                        END
                        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#"> 
                        OR BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#">
                        OR PRODUCT_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#">
                        OR MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#"> 
                        OR USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#"> 
                        OR PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#">
                        OR PRODUCT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#"> 
                        OR P.PRODUCT_ID IN (SELECT STOCKS.PRODUCT_ID FROM STOCKS,#this.dsn1_alias#.SETUP_COMPANY_STOCK_CODE SCSC WHERE STOCKS.STOCK_ID = SCSC.STOCK_ID AND SCSC.COMPANY_PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#">))
               
                     <cfif ListLen(arguments.keyword) gt p_sayac>OR </cfif>
                    </cfloop>
                    )
                <cfelse><!--- tek bir tane ise like ile baksın.. --->
                    AND 
                    (
                         (1=2)  
                        <cfif len(arguments.PRODUCT_NAME1)>
                            OR (
                            	 CASE    
                                    WHEN LEN(SLI.ITEM) > 0 
                                 THEN 
                                    SLI.ITEM 
                                ELSE
                                P.PRODUCT_NAME 
                                END
                                LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                            ) 
                        </cfif>                                
                        <cfif len(arguments.BARCODE1)>
                            OR (P.BARCOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                        </cfif> 
                        <cfif len(arguments.SPECIAL_CODE1)>
                            OR (P.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                        </cfif> 
                        <cfif len(arguments.MANUFACT_CODE1)>
                            OR (P.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                        </cfif>
                        <cfif len(arguments.USER_FRIENDLY_URL1)>
                            OR (P.USER_FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                        </cfif>
                        <cfif len(arguments.PRODUCT_CODE1)>
                            OR (P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                        </cfif>
                         <cfif len(arguments.PRODUCT_DETAIL1)>
                            OR (
                            
                             CASE    
                                    WHEN LEN(SLI.ITEM) > 0 
                                 THEN 
                                    SLI.ITEM 
                                ELSE
                                P.PRODUCT_DETAIL 
                                END
                                LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                            )									
                        </cfif>
                         <cfif len(arguments.COMPANY_STOCK_CODE1)>
                            OR P.PRODUCT_ID IN (SELECT STOCKS.PRODUCT_ID FROM STOCKS,#this.dsn1_alias#.SETUP_COMPANY_STOCK_CODE SCSC WHERE STOCKS.STOCK_ID = SCSC.STOCK_ID AND (SCSC.COMPANY_STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">))									
                        </cfif>
                          <cfif len(arguments.COMPANY_PRODUCT_NAME1)>
                       		OR P.PRODUCT_ID IN (SELECT STOCKS.PRODUCT_ID FROM STOCKS,#this.dsn1_alias#.SETUP_COMPANY_STOCK_CODE SCSC WHERE STOCKS.STOCK_ID = SCSC.STOCK_ID AND SCSC.COMPANY_PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                        </cfif>
                     )
                </cfif>
             </cfif>
		<cfif isDefined("special_code") and len(special_code)>
			AND P.PRODUCT_CODE_2 LIKE '<cfif len(special_code) gt 2>%</cfif>#special_code#%'
		</cfif>
        <cfif isdefined("list_property_id") and len(list_property_id) and len(list_variation_id)>
                    AND P.PRODUCT_ID IN
                    (
                        SELECT
                            PRODUCT_ID
                        FROM
                            #this.dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
                        WHERE
                            <cfloop from="1" to="#listlen(list_property_id,',')#" index="pro_index">
                            PRODUCT_ID IN (

                                            SELECT 
                                                PRODUCT_ID
                                            FROM
                                                #this.dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES 
                                            WHERE
                                                (
                                                PROPERTY_ID = #ListGetAt(list_property_id,pro_index,",")# AND VARIATION_ID = #ListGetAt(list_variation_id,pro_index,",")#
                                                <cfif ListGetAt(list_property_value,pro_index,",") neq 'empty'>AND(TOTAL_MAX=#ListGetAt(list_property_value,pro_index,",")# OR TOTAL_MIN=#ListGetAt(list_property_value,pro_index,",")#)</cfif>
                                                )
                                              GROUP BY 
                                                PRODUCT_ID  
                                        ) 
                            <cfif pro_index lt listlen(list_property_id,',')>AND</cfif>
                            </cfloop>
                    )
                </cfif>

		<cfif session.ep.isBranchAuthorization> <!--- FB 20070702 yetkili subelerdeki urunler --->
			AND PBR.PRODUCT_ID = P.PRODUCT_ID
			AND PBR.BRANCH_ID IN  (SELECT
										B.BRANCH_ID
									FROM 
										#this.dsn_alias#.BRANCH B, 
										#this.dsn_alias#.EMPLOYEE_POSITION_BRANCHES EPB
									WHERE 
										EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
										EPB.BRANCH_ID = B.BRANCH_ID )	
		</cfif>
            
           ),
           CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	ORDER BY
											<cfif Len(sort_type) and sort_type eq 1>
                                                CASE WHEN LEN(ITEM) > 0 THEN ITEM ELSE 
                                                 PRODUCT_NAME
                                                 END DESC
                                            <cfelseif  Len(sort_type) and sort_type eq 2>
                                                PRODUCT_CODE
                                            <cfelseif  Len(sort_type) and sort_type eq 3>
                                                PRODUCT_CODE DESC
                                            <cfelseif  Len(sort_type) and sort_type eq 4>
                                                PRODUCT_CODE_2 
                                            <cfelseif  Len(sort_type) and sort_type eq 5>
                                                PRODUCT_CODE_2 DESC
                                            <cfelseif  Len(sort_type) and sort_type eq 6>
                                                BARCOD 
                                            <cfelseif  Len(sort_type) and sort_type eq 7>
                                                BARCOD DESC
                                            <cfelseif  Len(sort_type) and sort_type eq 8>
                                                ISNULL(UPDATE_DATE,RECORD_DATE)
                                            <cfelseif  Len(sort_type) and sort_type eq 9>
                                                ISNULL(UPDATE_DATE,RECORD_DATE) DESC
                                            <cfelse>
                                                CASE WHEN LEN(ITEM) > 0 THEN ITEM ELSE 
                                                 PRODUCT_NAME
                                                 END
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
				RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
	</cfquery>
	<cfreturn GET_PRODUCT>
</cffunction>
