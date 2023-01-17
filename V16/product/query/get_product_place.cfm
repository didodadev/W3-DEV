<cfquery name="GET_PRODUCT_PLACE" datasource="#DSN3#">
    SELECT
        P.*,
		<cfif isDefined("attributes.pid") and len(attributes.pid)>
			PR.AMOUNT,
		</cfif>
        S.SHELF_NAME
    FROM
        PRODUCT_PLACE P,
		<cfif isDefined("attributes.pid") and len(attributes.pid)>
			PRODUCT_PLACE_ROWS PR,
		</cfif>
        #dsn_alias#.SHELF S,
        #dsn_alias#.STOCKS_LOCATION SL
    WHERE
        P.SHELF_TYPE = S.SHELF_ID AND
        SL.LOCATION_ID = P.LOCATION_ID AND
		SL.DEPARTMENT_ID = P.STORE_ID
    <cfif isDefined("attributes.product_place_id") and len(attributes.product_place_id)>
        AND P.PRODUCT_PLACE_ID = #attributes.product_place_id#
    </cfif>
    <cfif isDefined("attributes.pid") and len(attributes.pid)>
        AND P.PRODUCT_PLACE_ID=PR.PRODUCT_PLACE_ID
        AND PR.PRODUCT_ID = #attributes.pid#
    </cfif>
    <cfif isDefined("attributes.shelf_type") and  len(attributes.shelf_type)>
        AND P.SHELF_TYPE = #attributes.shelf_type#
    </cfif>
    <cfif isDefined("attributes.store") and len(attributes.store)>
        AND P.STORE_ID = #attributes.store#
    </cfif>
    <cfif isDefined("attributes.place_status") and len(attributes.place_status)>
        AND P.PLACE_STATUS = <cfif attributes.place_status eq 1>1<cfelse>0</cfif>
    </cfif>
    <cfif session.ep.isBranchAuthorization>
        AND D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
    </cfif>		
	<cfif isDefined('attributes.store_loc_id')>
		<cfif not isnumeric(attributes.store_loc_id)>
			<cfset attributes.store_loc_id=listfirst(attributes.store_loc_id,"-")>
			AND P.STORE_ID = #attributes.store_loc_id#
		<cfelse>
			AND P.STORE_ID = #attributes.store_loc_id#
		</cfif>
	</cfif>
</cfquery>

<cfif len(GET_PRODUCT_PLACE.PRODUCT_PLACE_ID)>
	<cfquery name="GET_PROD_PLACE_ROWS" datasource="#DSN3#">
		SELECT
			PP.PRODUCT_PLACE_ID,
			PP.PRODUCT_ID,
			PP.STOCK_ID,
			PP.AMOUNT,
			S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'') AS PRODUCT_NAME,
			S.STOCK_CODE,
			P.PRODUCT_CODE_2 AS SPECIAL_CODE
		FROM
			PRODUCT_PLACE_ROWS PP,
			STOCKS S
			LEFT JOIN PRODUCT AS P ON P.PRODUCT_ID = S.PRODUCT_ID
		WHERE
			PP.PRODUCT_ID = S.PRODUCT_ID AND
			PP.STOCK_ID = S.STOCK_ID AND
			PP.PRODUCT_PLACE_ID = #GET_PRODUCT_PLACE.PRODUCT_PLACE_ID#
	</cfquery>
<cfelse>
	<cfset GET_PROD_PLACE_ROWS.recordcount = 0>
</cfif>
