<cfcomponent output="no">
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Inventory Area Graph component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
    <!--- GET BRANCH AND COMPANY LISTS --->
    <cffunction name="getBranchsAndCompanies" access="remote" returntype="struct" output="no">
    	<cfargument name="position_code" type="any" required="yes">
    	
    	<cfquery name="get_branchs" datasource="#dsn#">
        	SELECT BRANCH_ID AS id, BRANCH_NAME AS name FROM BRANCH ORDER BY BRANCH_NAME
        </cfquery>
        
        <cfquery name="get_companies" datasource="#dsn#">
        	SELECT DISTINCT
                O.COMP_ID AS id,
                O.COMPANY_NAME AS name
            FROM 
                SETUP_PERIOD SP, 
                EMPLOYEE_POSITION_PERIODS EP,
                OUR_COMPANY O
            WHERE 
                SP.OUR_COMPANY_ID = O.COMP_ID AND
                EP.PERIOD_ID = SP.PERIOD_ID AND 
                EP.POSITION_ID = #arguments.position_code#
            ORDER BY
                O.COMP_ID,
                O.COMPANY_NAME
        </cfquery>
        
        <cfset result = StructNew()>
        <cfset result["branchs"] = get_branchs>
        <cfset result["companies"] = get_companies>
        <cfreturn result>
    </cffunction>
    
    <!--- GET BRANCH DATA --->
	<cffunction name="getBranchData" access="remote" returntype="array" output="no">
        <cfargument name="branch_id" type="string" required="yes">
        <cfargument name="company_id" type="string" required="yes">
        <cfargument name="branch_company_id" type="string" required="no">
        <cfargument name="is_active" type="int" required="no">
        <cfargument name="period_year" type="string" required="yes">
        
        <cfquery name="get_list" datasource="#dsn#">
            SELECT
                1 AS TYPE,
                D.DEPARTMENT_STATUS,
                D.DEPARTMENT_ID,
                D.DEPARTMENT_HEAD,
                B.BRANCH_ID,
                B.BRANCH_NAME,
                SL.LOCATION_ID,
                SL.DEPARTMENT_ID,
                SL.DEPARTMENT_LOCATION,
                SL.COMMENT,
                SL.WIDTH AS LOCATION_WIDTH,
                SL.HEIGHT AS LOCATION_HEIGHT,
                SL.DEPTH AS LOCATION_DEPTH,
                SL.STATUS,
                PP.PRODUCT_PLACE_ID,
                PP.LOCATION_ID,
                PP.SHELF_TYPE,
                PP.SHELF_CODE,
                PP.DETAIL,
                PP.WIDTH AS SHELF_WIDTH,
                PP.HEIGHT AS SHELF_HEIGHT,
                PP.DEPTH AS SHELF_DEPTH
            FROM 
                DEPARTMENT D,
                BRANCH B,
                STOCKS_LOCATION SL,
                #dsn#_#arguments.company_id#.PRODUCT_PLACE PP
            WHERE
                B.BRANCH_ID = D.BRANCH_ID AND
                <cfif isDefined('arguments.branch_company_id') and len(arguments.branch_company_id)>
                    B.COMPANY_ID = #arguments.branch_company_id# AND
                </cfif>
                D.IS_STORE IN(1,3) AND
                SL.LOCATION_ID = PP.LOCATION_ID  AND
                SL.DEPARTMENT_ID = PP.STORE_ID AND
                SL.DEPARTMENT_ID = D.DEPARTMENT_ID
                AND B.BRANCH_ID = #arguments.branch_id#
                <cfif isDefined('arguments.is_active') and arguments.is_active is 1 or isDefined('arguments.is_active') and arguments.is_active is 0>
                    AND D.DEPARTMENT_STATUS = #arguments.is_active#
                    AND SL.STATUS = #arguments.is_active#
                <cfelse>
                    AND D.DEPARTMENT_STATUS IS NOT NULL
                </cfif>
            UNION
            SELECT 
                2 AS TYPE,
                D.DEPARTMENT_STATUS,
                D.DEPARTMENT_ID,
                D.DEPARTMENT_HEAD,
                B.BRANCH_ID,
                B.BRANCH_NAME,
                0 AS LOCATION_ID,
                0 AS DEPARTMENT_ID,
                '' AS DEPARTMENT_LOCATION,
                '' AS COMMENT,
                0 AS LOCATION_WIDTH,
                0 AS LOCATION_HEIGHT,
                0 AS LOCATION_DEPTH,
                -1 AS STATUS,
                0 AS PRODUCT_PLACE_ID,
                0 AS LOCATION_ID,
                0 AS SHELF_TYPE,
                '' AS SHELF_CODE,
                '' AS DETAIL,
                0 AS SHELF_WIDTH,
                0 AS SHELF_HEIGHT,
                0 AS SHELF_DEPTH
            FROM 
                DEPARTMENT D,
                BRANCH B
            WHERE
                B.BRANCH_ID = D.BRANCH_ID AND
                <cfif isDefined('arguments.branch_company_id') and len(arguments.branch_company_id)>
                    B.COMPANY_ID = #arguments.branch_company_id# AND
                </cfif>
                D.IS_STORE IN(1,3) AND
                D.DEPARTMENT_ID NOT IN
                (
                    SELECT DISTINCT DEPARTMENT_ID FROM STOCKS_LOCATION
                )
                AND B.BRANCH_ID = #arguments.branch_id#
                <cfif isDefined('arguments.is_active') and arguments.is_active is 1 or isDefined('arguments.is_active') and arguments.is_active is 0>
                    AND D.DEPARTMENT_STATUS = #arguments.is_active#
                    AND SL.STATUS = #arguments.is_active#
                <cfelse>
                    AND D.DEPARTMENT_STATUS IS NOT NULL
                </cfif>
            UNION
            SELECT 
                3 AS TYPE,
                D.DEPARTMENT_STATUS,
                D.DEPARTMENT_ID,
                D.DEPARTMENT_HEAD,
                B.BRANCH_ID,
                B.BRANCH_NAME,
                SL.LOCATION_ID,
                SL.DEPARTMENT_ID,
                SL.DEPARTMENT_LOCATION,
                SL.COMMENT,
                SL.WIDTH AS LOCATION_WIDTH,
                SL.HEIGHT AS LOCATION_HEIGHT,
                SL.DEPTH AS LOCATION_DEPTH,
                SL.STATUS,
                0 AS PRODUCT_PLACE_ID,
                0 AS LOCATION_ID,
                0 AS SHELF_TYPE,
                '' AS SHELF_CODE,
                '' AS DETAIL,
                0 AS SHELF_WIDTH,
                0 AS SHELF_HEIGHT,
                0 AS SHELF_DEPTH
            FROM 
                DEPARTMENT D,
                BRANCH B,
                STOCKS_LOCATION SL
            WHERE
                B.BRANCH_ID = D.BRANCH_ID AND
                <cfif isDefined('arguments.branch_company_id') and len(arguments.branch_company_id)>
                    B.COMPANY_ID = #arguments.branch_company_id# AND
                </cfif>
                D.IS_STORE IN(1,3) AND
                SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                SL.LOCATION_ID NOT IN
                (
                    SELECT DISTINCT PP.LOCATION_ID FROM #dsn#_#arguments.company_id#.PRODUCT_PLACE PP WHERE PP.STORE_ID = D.DEPARTMENT_ID
                )
                AND B.BRANCH_ID = #arguments.branch_id#
                <cfif isDefined('arguments.is_active') and arguments.is_active is 1 or isDefined('arguments.is_active') and arguments.is_active is 0>
                    AND D.DEPARTMENT_STATUS = #arguments.is_active#
                    AND SL.STATUS = #arguments.is_active#
                <cfelse>
                    AND D.DEPARTMENT_STATUS IS NOT NULL
                </cfif>
        </cfquery>
        <cfset shelfList = valuelist(get_list.PRODUCT_PLACE_ID,',')>
        
        <cfif get_list.recordcount gt 0>
            <cfquery name="get_products" datasource="#dsn#_#arguments.company_id#">
                SELECT DISTINCT
                    PPR.PRODUCT_ID,
                    S.PRODUCT_NAME,
                    GSL.STOCK_ID,
                    GSL.REAL_STOCK,
                    GSL.RESERVE_SALE_ORDER_STOCK,
                    PPR.PRODUCT_PLACE_ID,
                    S.PROPERTY
                FROM 
                    PRODUCT_PLACE_ROWS PPR,
                    #dsn#_#arguments.company_id#.STOCKS S,
                    #dsn#_#arguments.period_year#_#arguments.company_id#.GET_STOCK_LAST_PROFILE GSL
                WHERE 
                    GSL.STOCK_ID = PPR.STOCK_ID AND
                    PPR.STOCK_ID = S.STOCK_ID AND
                    PPR.PRODUCT_PLACE_ID IN (#shelfList#)
            </cfquery>
        </cfif>
        <cfset departments = ArrayNew(1)>
        <cfset assigned_departments = "">
        <cfloop query="get_list">
			<cfif len(get_list.SHELF_TYPE)>
                <cfquery name="get_shelf_type" datasource="#dsn#">
                    SELECT SHELF_MAIN_ID,SHELF_NAME FROM SHELF WHERE SHELF_MAIN_ID = #get_list.SHELF_TYPE#
                </cfquery>
            <cfelse>
                <cfset get_shelf_type.SHELF_NAME = ''>
            </cfif>
            <cfset department_index = listfind(assigned_departments, get_list.DEPARTMENT_ID, ",")>
            <cfif department_index eq 0>
                <cfset assigned_departments = listappend(assigned_departments, get_list.DEPARTMENT_ID, ",")>
                <cfset department = StructNew()>
                <cfset department["id"] = get_list.DEPARTMENT_ID>
                <cfset department["name"] = get_list.DEPARTMENT_HEAD>
                <cfset department["isActive"] = get_list.DEPARTMENT_STATUS>
                <cfset department["locations"] = ArrayNew(1)>
                <cfset departments[arraylen(departments) + 1] = department>
                <cfset target_department_index = arraylen(departments)>
            <cfelse>
                <cfset target_department_index = department_index>
            </cfif>
            
            <cfif get_list.TYPE neq 2>
				<cfset target_location_index = 0>
                <cfloop from="1" to="#arraylen(departments[target_department_index].locations)#" index="i">
                    <cfif departments[target_department_index].locations[i].id eq get_list.LOCATION_ID>
                        <cfset target_location_index = i>
                        <cfbreak>
                    </cfif>
                </cfloop>
                <cfif target_location_index eq 0>
                    <cfset target_location_index = arraylen(departments[target_department_index].locations) + 1>
                    <cfset location = StructNew()>
                    <cfset location["id"] = get_list.LOCATION_ID>
                    <cfset location["name"] = get_list.COMMENT>
                    <cfset location["shelfs"] = ArrayNew(1)>
                    <cfset departments[target_department_index].locations[target_location_index] = location>
                </cfif>
			</cfif>
            
            <cfif get_list.TYPE eq 1>
				<cfquery name="get_place_products" dbtype="query">
                	SELECT DISTINCT
                    	PRODUCT_ID AS productID,
                        PROPERTY property,
                        PRODUCT_NAME AS productName,
                        STOCK_ID stockID,
                        REAL_STOCK realStock,
                        RESERVE_SALE_ORDER_STOCK reserveStock
                    FROM 
                    	get_products
                    WHERE
                    	PRODUCT_PLACE_ID = #get_list.PRODUCT_PLACE_ID#
                </cfquery>
				<cfset target_shelf_index = 0>
                <cfloop from="1" to="#arraylen(departments[target_department_index].locations[target_location_index].shelfs)#" index="i">
                    <cfif departments[target_department_index].locations[target_location_index].shelfs[i].id eq get_list.PRODUCT_PLACE_ID>
                        <cfset target_shelf_index = i>
                        <cfbreak>
                    </cfif>
                </cfloop>
                <cfif target_shelf_index eq 0>
                    <cfset target_shelf_index = arraylen(departments[target_department_index].locations[target_location_index].shelfs) + 1>
                    <cfset shelf = StructNew()>
                    <cfset shelf["id"] = get_list.PRODUCT_PLACE_ID>
                    <cfset shelf["type"] = get_list.SHELF_TYPE>
                    <cfset shelf["code"] = get_list.SHELF_CODE>
                    <cfset shelf["name"] = get_shelf_type.SHELF_NAME>
                    <cfset shelf["products"] = get_place_products>
                    <cfset departments[target_department_index].locations[target_location_index].shelfs[target_shelf_index] = shelf>
                </cfif>
			</cfif>
        </cfloop>
        
        <cfreturn departments>
    </cffunction>
</cfcomponent>
