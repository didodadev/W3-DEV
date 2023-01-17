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
<cffunction name="addProduct"  access="remote" returntype="any" returnFormat="json">
	<cfargument name="sales_emp_id" required="true">
	<cfargument name="sales_emp" required="true">
	<cfargument name="product_cat_id" required="no" default="">
	<cfargument name="product_name" required="no" default="">
	<cfargument name="short_code" required="no" default="">
	<cfargument name="short_code_id" required="no" default="">
	<cfargument name="ref_no" required="no" default="">
	<cfargument name="is_copy" required="no" default="">
	<cfargument name="brand_name" required="no" default="">
	<cfargument name="brand_id" required="no" default="">
	
	<cfscript>
		arguments.sales_emp_id =arguments.sales_emp_id;
		arguments.sales_emp = arguments.sales_emp;
		arguments.product_status=1;
		FORM.PRODUCT_CATID=arguments.product_cat_id;
		//arguments.PRODUCT_NAME=arguments.product_name;
		arguments.short_code=arguments.short_code;
		arguments.short_code_id=arguments.short_code_id;
		FORM.TAX=8;					
		FORM.TAX_PURCHASE=8;
		FORM.BARCOD="";
		FORM.PRODUCT_DETAIL="numune";
		FORM.PRODUCT_DETAIL2="";
	</cfscript>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn_alias = application.systemParam.systemParam().dsn>
	<cfset dsn1="#dsn#_product">
	<cfset dsn1_alias="#dsn#_product">
	<cfset dsn3="#dsn#_#session.ep.company_id#">
	<cfset dsn3_alias="#dsn#_#session.ep.company_id#">
	<cfset form.IS_INVENTORY=1>
	<cfset FORM.IS_ZERO_STOCK=1>
	<cfset form.IS_SALES=1>
	<CFSET FORM.IS_PRODUCTION=1>
	<cfset FORM.COMPANY_ID="">
	<cfset FORM.PRODUCT_CODE="">
	<cfset FORM.MANUFACT_CODE="">
	<cfset FORM.SHELF_LIFE="">
		
	<cfset arguments.process_stage="">
	<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
		SELECT
		TOP 1
			PTR.STAGE,
			PTR.PROCESS_ROW_ID
		FROM
			PROCESS_TYPE_ROWS PTR,
			PROCESS_TYPE PT
		WHERE
			PTR.PROCESS_ID = PT.PROCESS_ID AND
			PT.FACTION LIKE '%product.list_product%'
			ORDER BY PROCESS_ROW_ID 
	</cfquery>
	<cfif len(GET_PROCESS_TYPE.PROCESS_ROW_ID)>
		<cfset arguments.process_stage=GET_PROCESS_TYPE.PROCESS_ROW_ID>
	</cfif>
		
		
		
	<cfset arguments.product_code_2="">
	<cfset UNIT_ID="1,Adet">
	<cfset FORM.DIMENTION="">
	<cfset FORM.WEIGHT="">
	<cfset arguments.VOLUME="">
	<cfset arguments.PURCHASE=0>
	<cfset arguments.IS_TAX_INCLUDED_PURCHASE=1>
	<cfset arguments.tax_purchase=8>
	<cfset FORM.MONEY_ID_SA='#session.ep.money#'>
	<cfset arguments.price=0>
	<cfset arguments.IS_TAX_INCLUDED_SALES=0>
	<cfset arguments.tax=8>
	<cfset arguments.PRODUCT_CATID=arguments.product_cat_id>
	<cfset arguments.BRAND_CODE="">
	<cfset FORM.SHORT_CODE=arguments.short_code>
	<cfset DATEFORMAT_STYLE="DD/MM/YYYY">
	<cfset FORM.MONEY_ID_SS='#session.ep.money#'>
	<cfset DATABASE_TYPE="MSSQL">
	<cfset REQUEST.SELF="#application.systemParam.systemParam().employee_url#/index.cfm">
	<cfset arguments.fuseaction="textile.list_sample_request">

		
		<!--- ürün kodunu hierarchye göre oluşturalım --->
	<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
		SELECT IS_BRAND_TO_CODE,IS_PRODUCT_COMPANY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
		SELECT HIERARCHY,PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#">
	</cfquery>
	<cfset form.product_code="#get_product_cat.hierarchy#">
	<!---.#form.short_code#--->
	<cfset product_code_2_format="#get_product_cat.hierarchy#.#form.product_code#">

	<cfinclude template="/V16/objects/functions/get_product_no.cfm">
	<cfinclude template="/V16/objects/functions/get_barcode_no.cfm">
	
	<cfset product_no = get_product_no(action_type:'product_no')>
	<cfset form.product_code="#form.product_code#.#product_no#">
	<cfset	FORM.BARCOD=get_barcode_no(2)>
	<cfset product_code_2_format=form.product_code>
		
	<!--- ürün kodu oluştu --->
	<cfquery name="CHECK_SAME" datasource="#DSN1#">
		SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT.PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.product_code#">
	</cfquery>
	<cfif check_same.recordcount>
		<!---<script type="text/javascript">
			alert("<cf_get_lang no ='883.Girdiğiniz Ürün Kodu Başka Bir Ürün Tarafından Kullanılmakta Lütfen Başka Bir Ürün Kodu Giriniz'> !");
			history.back();
		</script>
		<cfabort>--->
	</cfif>

	<cfset bugun_00 = DateFormat(now(),dateformat_style)>
	<cf_date tarih='bugun_00'>
		
		
	<!---<cfif isdefined('arguments.acc_code_cat') and len(arguments.acc_code_cat)>
		<cfquery name="GET_CODES" datasource="#DSN3#">
			SELECT * FROM SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_code_cat#">
		</cfquery>
		<cfquery name="GET_OTHER_PERIOD" datasource="#DSN3#">
			SELECT PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
		</cfquery>
	<cfelse>
		<cfset get_codes.recordcount = 0>
	</cfif>--->
	<cfif len(GET_PRODUCT_CAT.PRODUCT_CAT)>
		<cfquery name="GET_CODES" datasource="#DSN3#">
			SELECT * FROM SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CAT_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#GET_PRODUCT_CAT.PRODUCT_CAT#">
		</cfquery>
		<cfif GET_CODES.recordcount> 
			<cfset arguments.acc_code_cat=GET_CODES.PRO_CODE_CATID>
		</cfif>
		<cfquery name="GET_OTHER_PERIOD" datasource="#DSN3#">
			SELECT PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
		</cfquery>
	<cfelse>
		<cfset get_codes.recordcount = 0>
	</cfif>
	
	
	<!---
	<cfquery name="get_model_count" datasource="#DSN3#">
		select COUNT(PRODUCT_ID) AS COUNT_ from PRODUCT WHERE SHORT_CODE_ID=#arguments.short_code_id#
	</cfquery>
	<cfset pname="#arguments.short_code#-#get_model_count.count_#">
	--->
	
	<cfset pname="#ref_no#">
	
	<!---<cfif isDefined("arguments.is_copy") and  arguments.is_copy neq 0>
		<cfquery name="get_req" datasource="#DSN3#">
			select PRODUCT.PRODUCT_NAME,PRODUCT.PRODUCT_ID  from TEXTILE_SAMPLE_REQUEST,PRODUCT where TEXTILE_SAMPLE_REQUEST.PRODUCT_ID=PRODUCT.PRODUCT_ID AND REQ_ID=#arguments.is_copy#
		</cfquery>
		<cfquery name="get_model_count" datasource="#DSN3#">
			select COUNT(PRODUCT_ID) AS COUNT_ from PRODUCT WHERE PRODUCT_NAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(get_req.product_name,'.')#"> and PRODUCT_ID<>#get_req.PRODUCT_ID#
		</cfquery>
		<cfif get_model_count.recordcount gt 0>
			<cfset psay=get_model_count.COUNT_+1>
		<cfelse>
			<cfset psay=1>
		</cfif>
					
		<cfset pname="#ListFirst(get_req.PRODUCT_NAME,'.')#"&"."&"#psay#">
	</cfif>--->
	
	<cfset arguments.PRODUCT_NAME=pname>
	<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PRODUCT" datasource="#DSN3#">
			INSERT INTO 
				#dsn1_alias#.PRODUCT
			(
				PRODUCT_STATUS,
				IS_QUALITY,
				IS_COST,
				IS_INVENTORY,
				IS_PRODUCTION,
				IS_SALES,
				IS_PURCHASE,
				IS_PROTOTYPE,
				IS_TERAZI,
				IS_SERIAL_NO,
				IS_ZERO_STOCK,
				IS_KARMA,
				IS_LIMITED_STOCK,
                IS_LOT_NO,
				PRODUCT_CATID,
				PRODUCT_NAME,
				TAX,
				TAX_PURCHASE,
				BARCOD,
				PRODUCT_DETAIL,
                PRODUCT_DETAIL2,
				COMPANY_ID,
				BRAND_ID,
				RECORD_DATE,
				RECORD_MEMBER,
				MEMBER_TYPE,
				PRODUCT_CODE,
				MANUFACT_CODE,
				SHELF_LIFE,
				<cfif isDefined('arguments.SEGMENT_ID') and len(arguments.SEGMENT_ID)>
				SEGMENT_ID,
				</cfif>
				<cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER)>
				PRODUCT_MANAGER,
				</cfif>
				IS_INTERNET,
				IS_EXTRANET,
				PROD_COMPETITIVE,
				PRODUCT_STAGE,
				MIN_MARGIN,
				MAX_MARGIN,
				OTV,
				PRODUCT_CODE_2,
				SHORT_CODE,
				SHORT_CODE_ID,
				WORK_STOCK_ID,
				WORK_STOCK_AMOUNT,
				RECORD_BRANCH_ID,
                PACKAGE_CONTROL_TYPE,
				IS_COMMISSION,
				IS_GIFT_CARD,
				GIFT_VALID_DAY,
				CUSTOMS_RECIPE_CODE
			)
			VALUES 
			(
                <cfif isDefined("arguments.product_status") and arguments.product_status eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("form.is_quality") and form.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_COST") and FORM.IS_COST eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_INVENTORY") and FORM.IS_INVENTORY eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_PRODUCTION") and FORM.IS_PRODUCTION eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_SALES") and FORM.IS_SALES eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_PURCHASE") and FORM.IS_PURCHASE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_PROTOTYPE") and FORM.IS_PROTOTYPE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_TERAZI") and FORM.IS_TERAZI eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_SERIAL_NO") and FORM.IS_SERIAL_NO eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_ZERO_STOCK") and FORM.IS_ZERO_STOCK eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_KARMA") and FORM.IS_KARMA eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("arguments.is_limited_stock") and arguments.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("FORM.IS_LOT_NO") and FORM.IS_LOT_NO eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.PRODUCT_CATID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_NAME#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#FORM.TAX#">,					
				<cfqueryparam cfsqltype="cf_sql_float" value="#FORM.TAX_PURCHASE#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_DETAIL#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_DETAIL2#">,
				<cfif FORM.COMPANY_ID is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.COMPANY_ID#"></cfif>,
				<cfif len(arguments.brand_name) and len(arguments.brand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.BRAND_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_CODE#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MANUFACT_CODE#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SHELF_LIFE#">,
				<cfif isDefined('arguments.SEGMENT_ID') and len(arguments.SEGMENT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SEGMENT_ID#">,</cfif>
				<cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#">,</cfif>
				<cfif isDefined('arguments.is_internet') and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1">,<cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0">,</cfif>
				<cfif isDefined('arguments.is_extranet') and arguments.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1">,<cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0">,</cfif>
					<cfif isDefined('arguments.prod_comp') and len(arguments.prod_comp)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_comp#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="1">,</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				<cfif isDefined('arguments.MIN_MARGIN') and len(arguments.MIN_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_margin#"><cfelse>0</cfif>,
				<cfif isDefined('arguments.MAX_MARGIN') and len(arguments.MAX_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_margin#"><cfelse>0</cfif>,
				<cfif isDefined('arguments.OTV') and len(arguments.OTV)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.OTV#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
					<cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
			
				<cfif len(arguments.short_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHORT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				<cfif len(arguments.short_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.short_code_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif isdefined('arguments.work_product_name') and len(arguments.work_product_name) and len(arguments.work_stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_stock_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif isdefined('arguments.work_product_name') and len(arguments.work_product_name) and len(arguments.work_stock_id) and len(arguments.work_stock_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.work_stock_amount#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
				<cfif session.ep.isBranchAuthorization><cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif isdefined('arguments.PACKAGE_CONTROL_TYPE') and len(arguments.PACKAGE_CONTROL_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PACKAGE_CONTROL_TYPE#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,</cfif>
				<cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined("arguments.is_gift_card") and arguments.is_gift_card eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>,				
				<cfif isdefined("arguments.customs_recipe_code") and len(arguments.customs_recipe_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.customs_recipe_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>
			)
        	SELECT @@IDENTITY AS MAX_PRODUCT_ID
		</cfquery>
		<cfquery name="GET_PID" datasource="#DSN3#">
			SELECT MAX(PRODUCT_ID) AS PRODUCT_ID FROM #dsn1_alias#.PRODUCT
		</cfquery>
		<cfset pid = GET_PID.PRODUCT_ID>
       	<!--- <cfif GET_OUR_COMPANY_INFO.IS_PRODUCT_COMPANY EQ 1>
			<cfquery name="add_general_parameters2" datasource="#dsn3#">
                INSERT INTO #dsn1_alias#.PRODUCT_GENERAL_PARAMETERS
                (
                    PRODUCT_ID,
                    COMPANY_ID, 
                    OUR_COMPANY_ID,
                    PRODUCT_MANAGER,
                    PRODUCT_STATUS, 
                    IS_INVENTORY, 
                    IS_PRODUCTION, 
                    IS_SALES, 
                    IS_PURCHASE, 
                    IS_PROTOTYPE,
                    IS_INTERNET, 
                    IS_EXTRANET, 
                    IS_TERAZI, 
                    IS_KARMA, 
                    IS_ZERO_STOCK, 
                    IS_LIMITED_STOCK, 
                    IS_SERIAL_NO, 
                    IS_COST, 
                    IS_QUALITY, 
                    IS_COMMISSION,
                    IS_ADD_XML,
                    IS_GIFT_CARD,
                    IS_LOT_NO,
                    GIFT_VALID_DAY
                )
                VALUES
                (
                    #pid#, 
                    <cfif FORM.COMPANY_ID is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.COMPANY_ID#"></cfif>,
                    #session.ep.company_id#,
                    <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#"><cfelse>NULL</cfif>,
                    <cfif isDefined("arguments.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_inventory") and form.is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_production") and form.is_production eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("form.is_sales") and form.is_sales eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("form.is_purchase") and form.is_purchase eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("form.is_prototype") and form.is_prototype eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_internet") and form.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_extranet") and form.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("form.is_terazi") and form.is_terazi eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_karma") and form.is_karma eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_zero_stock") and form.is_zero_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_limited_stock") and form.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_serial_no") and form.is_serial_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_cost") and form.is_cost eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_quality") and form.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_commission") and form.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("form.is_add_xml") and form.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined('arguments.is_gift_card')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                    <cfif isDefined("form.is_lot_no") and form.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>
                )
			</cfquery>
        </cfif>--->
		<cfif GET_CODES.recordcount and GET_OTHER_PERIOD.recordcount>
			<cfloop list="#ValueList(GET_OTHER_PERIOD.PERIOD_ID)#" index="i">
				<cfquery name="ADD_MAIN_UNIT" datasource="#DSN3#">
					INSERT INTO
						PRODUCT_PERIOD
					(
						PRODUCT_ID,  
						PERIOD_ID,
						ACCOUNT_CODE,
						ACCOUNT_CODE_PUR,
						ACCOUNT_DISCOUNT,
						ACCOUNT_PRICE,
						ACCOUNT_PUR_IADE,
						ACCOUNT_IADE,
						ACCOUNT_DISCOUNT_PUR,
						ACCOUNT_YURTDISI,					
						ACCOUNT_YURTDISI_PUR,
						EXPENSE_CENTER_ID,
						EXPENSE_ITEM_ID,
						INCOME_ITEM_ID,
						EXPENSE_TEMPLATE_ID,
						ACTIVITY_TYPE_ID,
						COST_EXPENSE_CENTER_ID,
						INCOME_ACTIVITY_TYPE_ID,
						INCOME_TEMPLATE_ID,
						ACCOUNT_LOSS,
						ACCOUNT_EXPENDITURE,
						OVER_COUNT,
						UNDER_COUNT,
						PRODUCTION_COST,
						HALF_PRODUCTION_COST,
						SALE_PRODUCT_COST,
						MATERIAL_CODE,
						KONSINYE_PUR_CODE,
						KONSINYE_SALE_CODE,
						KONSINYE_SALE_NAZ_CODE,
						DIMM_CODE,
						DIMM_YANS_CODE,
						PROMOTION_CODE,
						PRODUCT_PERIOD_CAT_ID,
                        ACCOUNT_PRICE_PUR,
                        MATERIAL_CODE_SALE,
                        PRODUCTION_COST_SALE,
                        SALE_MANUFACTURED_COST,
                        PROVIDED_PROGRESS_CODE,
                        SCRAP_CODE_SALE,
                        SCRAP_CODE,
                        PROD_GENERAL_CODE,
                        PROD_LABOR_COST_CODE,
                        RECEIVED_PROGRESS_CODE,
                        INVENTORY_CAT_ID,
                        INVENTORY_CODE,
                        AMORTIZATION_METHOD_ID,
                        AMORTIZATION_TYPE_ID,
                        AMORTIZATION_EXP_CENTER_ID,
                        AMORTIZATION_EXP_ITEM_ID,
                        AMORTIZATION_CODE
					)
					VALUES 
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PID.PRODUCT_ID#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
						<cfif len(GET_CODES.ACCOUNT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.ACCOUNT_CODE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.ACCOUNT_DISCOUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.ACCOUNT_PRICE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.ACCOUNT_PUR_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PUR_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.ACCOUNT_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.ACCOUNT_DISCOUNT_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.ACCOUNT_YURTDISI)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.ACCOUNT_YURTDISI_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.INC_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.INC_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.EXP_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.EXP_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.INC_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.INC_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.ACCOUNT_LOSS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_LOSS#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.ACCOUNT_EXPENDITURE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_EXPENDITURE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.OVER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.OVER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.UNDER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.UNDER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.HALF_PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.HALF_PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.SALE_PRODUCT_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_PRODUCT_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.MATERIAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.KONSINYE_PUR_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_PUR_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.KONSINYE_SALE_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.KONSINYE_SALE_NAZ_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_NAZ_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.DIMM_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.DIMM_YANS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_YANS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.PROMOTION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROMOTION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif isdefined('arguments.acc_code_cat') and len(arguments.acc_code_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_code_cat#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.ACCOUNT_PRICE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.MATERIAL_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.PRODUCTION_COST_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.SALE_MANUFACTURED_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_MANUFACTURED_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.PROVIDED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROVIDED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.SCRAP_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.SCRAP_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.PROD_GENERAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_GENERAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.PROD_LABOR_COST_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_LABOR_COST_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.RECEIVED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.RECEIVED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.INVENTORY_CAT_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CAT_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.INVENTORY_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.AMORTIZATION_METHOD_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_METHOD_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.AMORTIZATION_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.AMORTIZATION_EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.AMORTIZATION_EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
						<cfif len(GET_CODES.AMORTIZATION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>
                   
                    )
				</cfquery>
			</cfloop>
		</cfif>
		<cfquery name="ADD_MAIN_UNIT" datasource="#DSN3#">
			INSERT INTO
				#dsn1_alias#.PRODUCT_UNIT 
			(
				PRODUCT_ID, 
				PRODUCT_UNIT_STATUS, 
				MAIN_UNIT_ID, 
				MAIN_UNIT, 
				UNIT_ID, 
				ADD_UNIT,
				DIMENTION,
				WEIGHT,
                VOLUME,
				IS_MAIN,
				IS_SHIP_UNIT,
                RECORD_EMP,
                RECORD_DATE

			)
			VALUES 
			(
				#GET_PID.PRODUCT_ID#,
				1,
				#LISTGETAT(UNIT_ID,1)#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#LISTGETAT(UNIT_ID,2)#">,
				#LISTGETAT(UNIT_ID,1)#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#LISTGETAT(UNIT_ID,2)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.DIMENTION#">,
				<cfif len(FORM.WEIGHT)>#FORM.WEIGHT#<cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.volume#" null="#not len(arguments.volume)#">,
				1,
				<cfif isdefined('is_ship_unit')>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			)					
		</cfquery>
		<cfquery name="GET_MAX_UNIT" datasource="#DSN3#">
			SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM #dsn1_alias#.PRODUCT_UNIT
		</cfquery>
		<cfscript>
			if (isnumeric(arguments.PURCHASE))
				if (arguments.is_tax_included_purchase eq 1)
				{
					purchase_kdvsiz = (arguments.PURCHASE*100/(arguments.tax_purchase+100));
					purchase_kdvli = arguments.PURCHASE;
					purchase_is_tax_included = 1;
				}
				else
				{
					purchase_kdvsiz = arguments.PURCHASE;
					purchase_kdvli =  arguments.PURCHASE*(1+(arguments.tax_purchase/100));
					purchase_is_tax_included = 0;
				}
			else
			{
				purchase_kdvsiz = 0;
				purchase_kdvli = 0;
				purchase_is_tax_included = 0;
			}					
		</cfscript>
		<!--- purchasesales is 0 / alış fiyatı --->
		<cfquery name="ADD_STD_PRICE" datasource="#DSN3#">
			INSERT INTO
				#dsn1_alias#.PRICE_STANDART
			(
				PRODUCT_ID, 
				PURCHASESALES, 
				PRICE, 
				PRICE_KDV,
				IS_KDV,
				ROUNDING,
				MONEY,
				START_DATE,
				RECORD_DATE,
				PRICESTANDART_STATUS,
				UNIT_ID,
				RECORD_EMP
			)
			VALUES
			(
				#GET_PID.PRODUCT_ID#,
				0,
				#purchase_kdvsiz#,
				#purchase_kdvli#,
				#purchase_is_tax_included#,
				0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MONEY_ID_SA#">,
				#NOW()#,
				#NOW()#,
				1,
				#GET_MAX_UNIT.MAX_UNIT#,
				#SESSION.EP.USERID#
			)
		</cfquery>

		<cfscript>
			if (isnumeric(arguments.PRICE))
				if (arguments.is_tax_included_sales eq 1)
				{
					price_kdvsiz = arguments.PRICE*100/(arguments.tax+100);
					price_kdvli = arguments.PRICE;
					price_is_tax_included = 1;
				}
				else
				{
					price_kdvsiz = arguments.PRICE;
					price_kdvli = arguments.PRICE*(1+(arguments.tax/100));
					price_is_tax_included = 0;
				}
			else
			{
				price_kdvsiz = 0;
				price_kdvli = 0;
				price_is_tax_included = 0;
			}					
		</cfscript>
		
		<!--- purchasesales is 1 / satış fiyatı --->
		<cfquery name="ADD_STD_PRICE" datasource="#DSN3#">
			INSERT INTO 
				#dsn1_alias#.PRICE_STANDART
			(
				PRODUCT_ID, 
				PURCHASESALES, 
				PRICE, 
				PRICE_KDV,
				IS_KDV,
				ROUNDING,
				MONEY,
				START_DATE,
				RECORD_DATE,
				PRICESTANDART_STATUS,
				UNIT_ID,
				RECORD_EMP
			)
			VALUES
			(
				#GET_PID.PRODUCT_ID#,
				1,
				#price_kdvsiz#,
				#price_kdvli#,
				#price_is_tax_included#,
				0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MONEY_ID_SS#">,
				#bugun_00#,
				#NOW()#,
				1,
				#GET_MAX_UNIT.MAX_UNIT#,
				#SESSION.EP.USERID#
			)
		</cfquery>
		
		<cfquery name="ADD_STOCKS" datasource="#DSN3#">
			INSERT INTO
				#dsn1_alias#.STOCKS
			(
				STOCK_CODE,
				STOCK_CODE_2,
				PRODUCT_ID,
				PROPERTY,
				BARCOD,					
				PRODUCT_UNIT_ID,
				STOCK_STATUS,
				MANUFACT_CODE,
				RECORD_EMP, 
				RECORD_IP,
				RECORD_DATE
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_CODE#">,
				<cfif get_our_company_info.is_brand_to_code eq 1>
					<cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#product_code_2_format#"></cfif>,
				<cfelse>
					<cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse>NULL</cfif>,
				</cfif>
				#GET_PID.PRODUCT_ID#,
				'', <!--- property degeri null oldugunda raporlar, urun agacı gibi bir cok ekranda property le beraber cekilen urun isminde sorun oluyordu ---><!--- '-',  boş olarak eklenmesi terch edildi--->
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">,
				#GET_MAX_UNIT.MAX_UNIT#,
				1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MANUFACT_CODE#">,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
				#now()#
			)
		</cfquery>
		
		<cfquery name="GET_MAX_STCK" datasource="#DSN3#">
			SELECT MAX(STOCK_ID) AS MAX_STCK FROM #dsn1_alias#.STOCKS
		</cfquery>
		<cfquery name="ADD_STOCK_BARCODE" datasource="#DSN3#">
			INSERT INTO 
				#dsn1_alias#.STOCKS_BARCODES
			(
				STOCK_ID,
				BARCODE,
				UNIT_ID
			)
			VALUES 
			(
				#GET_MAX_STCK.MAX_STCK#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">,
				#GET_MAX_UNIT.MAX_UNIT#
			)
		</cfquery>

		<cfquery name="ADD_PRODUCT_OUR_COMPANY_ID" datasource="#DSN3#">
			INSERT INTO 
				#dsn1_alias#.PRODUCT_OUR_COMPANY
				(
					PRODUCT_ID,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
		</cfquery>
		
		<!--- FB 20070702 urune sessiondaki branch ekleniyor --->
		<cfquery name="add_product_branch_id" datasource="#DSN3#">
			INSERT INTO
				#dsn1_alias#.PRODUCT_BRANCH
			(
				PRODUCT_ID,
				BRANCH_ID,
				RECORD_EMP, 
				RECORD_IP,
				RECORD_DATE
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
				#now()#				
			)
		</cfquery>
		<cfquery name="get_my_periods" datasource="#DSN3#">
			SELECT * FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID#
		</cfquery>
		<cfloop query="get_my_periods">
			<cfif database_type is "MSSQL">
				<cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#SESSION.EP.COMPANY_ID#">
			<cfelseif database_type is "DB2">
				<cfset temp_dsn = "#dsn#_#SESSION.EP.COMPANY_ID#_#right(period_year,2)#">
			</cfif>
			<cfquery name="INSRT_STK_ROW" datasource="#DSN3#">
				INSERT INTO #temp_dsn#.STOCKS_ROW 
					(
						STOCK_ID,
						PRODUCT_ID
					)
				VALUES 
					(
						#GET_MAX_STCK.MAX_STCK#,
						#GET_PID.PRODUCT_ID#
					)
			</cfquery>
		</cfloop>
        <!--- Stok Stratejisi Ekliyor! --->
        <cfquery name="ADD_STK_STRATEGY" datasource="#DSN3#">
			INSERT INTO
				STOCK_STRATEGY 
			(
				PRODUCT_ID,
				STOCK_ID,
				MINIMUM_ORDER_UNIT_ID,
				STRATEGY_TYPE,
                IS_LIVE_ORDER
				
			)
			VALUES
			(
				#pid#,
				#GET_MAX_STCK.MAX_STCK#,
				#GET_MAX_UNIT.MAX_UNIT#,
				1,
                0
			)
		</cfquery>
		<cfif isDefined("arguments.block_stock_value") and len(arguments.block_stock_value)>
			<cfquery name="GET_MAX_STRATEGY" datasource="#DSN3#">
				SELECT MAX(STOCK_STRATEGY_ID) MAX_ID FROM STOCK_STRATEGY WHERE STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STCK.MAX_STCK#">
			</cfquery>
			<cfquery name="ADD_STK_STRATEGY" datasource="#DSN3#">
				INSERT INTO
					ORDER_ROW_RESERVED 
				(
					STOCK_STRATEGY_ID,
					STOCK_ID,
					PRODUCT_ID,
					RESERVE_STOCK_IN,
					RESERVE_STOCK_OUT,
					STOCK_IN,
					STOCK_OUT
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STRATEGY.MAX_ID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STCK.MAX_STCK#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#pid#">,
					0,
					#arguments.block_stock_value#,
					0,
					0
				)
			</cfquery>
		</cfif>
		<cfquery name="get_property_detail" datasource="#DSN3#">
			select 
				PP.PROPERTY,
				PP.PROPERTY_ID
			from 
				#dsn#_product.PRODUCT_PROPERTY PP
			WHERE 
				(PP.PROPERTY_SIZE=1 OR PP.PROPERTY_COLOR=1  OR PP.PROPERTY_LEN=1)
				<cfif isdefined("arguments.prop_id") and len(arguments.prop_id)>
					AND PP.PROPERTY_ID=#arguments.prop_id#
				</cfif>
			
		</cfquery>
		<cfloop from="1" to="#get_property_detail.recordcount#" index="z">
		    <cfquery name="ADD_PROPERTY" datasource="#DSN3#">
				INSERT INTO
					#dsn1_alias#.PRODUCT_DT_PROPERTIES
				(
					PRODUCT_ID,
					PROPERTY_ID,
					VARIATION_ID,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					#GET_PID.PRODUCT_ID#,
					#get_property_detail.property_id[z]#,
					NULL,
					#session.ep.userid#,
					#now()#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfloop>
	</cftransaction>
	</cflock>

	<cfif isdefined("arguments.USER_FRIENDLY_URL") and len(arguments.USER_FRIENDLY_URL)> 
		<cf_workcube_user_friendly user_friendly_url='#arguments.user_friendly_url#' action_type='PRODUCT_ID' action_id='#pid#' action_page='objects2.detail_product&product_id=#pid#'>
		<cfquery name="upd_product_" datasource="#dsn1#">
			UPDATE PRODUCT SET USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_#"> WHERE PRODUCT_ID = #pid#
		</cfquery>
	</cfif>
	<cfquery name="GET_STCK" datasource="#DSN3#">
		SELECT STOCKS.STOCK_ID,PRODUCT.PRODUCT_ID,PRODUCT.PRODUCT_NAME FROM #dsn1_alias#.STOCKS,#dsn1_alias#.PRODUCT
		WHERE PRODUCT.PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#pid#"> AND STOCKS.STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STCK.MAX_STCK#">
	</cfquery>
	<cfreturn GET_STCK>
</cffunction>

