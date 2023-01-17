<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3="#dsn#_#session.ep.company_id#">
<cfset dsn1="#dsn#_product">
    <cffunction name="get_stock_property" access="public">
	  <cfargument name="pid">
        <cfquery name="query_result" datasource="#dsn3#">
            SELECT
						RENK.PROPERTY_DETAIL AS RENK_,
						RENK.PROPERTY_DETAIL_ID AS RENK_ID,
						BEDEN.PROPERTY_DETAIL AS BEDEN_,
						BEDEN.PROPERTY_DETAIL_ID AS BEDEN_ID,
						BEDEN.PROPERTY_DETAIL_CODE,
						BOY.PROPERTY_DETAIL AS BOY_,
						BOY.PROPERTY_DETAIL_ID AS BOY_ID,
						STOCKS.STOCK_ID<!---,
						ASSORTMENT.ORDER_AMOUNT,
						ISNULL(ASSORTMENT.ASSORTMENT_AMOUNT,1) AS SUM_ASSORTMENT_AMOUNT,
						ISNULL(STOCKS.ASSORTMENT_AMOUNT,0) AS ASSORTMENT_AMOUNT--->
					FROM 
						#dsn1#.STOCKS
						OUTER APPLY
						(
							SELECT 
								PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
								PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
								PPD.PRPT_ID,
								PPD.PROPERTY_DETAIL_CODE
							FROM
								#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
								#dsn1#.PRODUCT_PROPERTY PRP,
								STOCKS_PROPERTY SP
							WHERE
								PRP.PROPERTY_ID = PPD.PRPT_ID AND
								SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
								PRP.PROPERTY_COLOR = 1 AND 
								SP.STOCK_ID = STOCKS.STOCK_ID 
						) AS RENK
						OUTER APPLY
						(
							SELECT 
								PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
								PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
								PPD.PRPT_ID,
								PPD.PROPERTY_DETAIL_CODE
							FROM
								#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
								#dsn1#.PRODUCT_PROPERTY PRP,
								STOCKS_PROPERTY SP
							WHERE
								PRP.PROPERTY_ID = PPD.PRPT_ID AND
								SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
								PRP.PROPERTY_SIZE = 1 AND 
								SP.STOCK_ID = STOCKS.STOCK_ID 
						) AS BEDEN
						OUTER APPLY
						(
							SELECT 
								PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
								PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
								PPD.PRPT_ID,
								PPD.PROPERTY_DETAIL_CODE
							FROM
								#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
								#dsn1#.PRODUCT_PROPERTY PRP,
								STOCKS_PROPERTY SP
							WHERE
								PRP.PROPERTY_ID = PPD.PRPT_ID AND
								SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
								PRP.PROPERTY_LEN = 1 AND 
								SP.STOCK_ID = STOCKS.STOCK_ID 
						) AS BOY
						
					WHERE 
						STOCKS.STOCK_STATUS = 1 AND
						STOCKS.PRODUCT_ID=#arguments.pid# AND
						RENK.PROPERTY_DETAIL_ID IS NOT NULL AND
						BEDEN.PROPERTY_DETAIL IS NOT NULL
						ORDER BY RENK.PROPERTY_DETAIL

        </cfquery>
        <cfreturn query_result>
    </cffunction>

    <cffunction name="get_measure_rows" access="public">
         <cfargument name="req_id">
        <cfquery name="query_result" datasource="#dsn3#">
            SELECT * FROM TEXTILE_MEASUREMENT_ROWS
            WHERE REQUEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
        </cfquery>
        <cfreturn query_result>
    </cffunction>

    <cffunction name="delete_measure_rows" access="public">
        <cfargument name="req_id">
        <cfquery name="query_result" datasource="#dsn3#">
            DELETE FROM TEXTILE_MEASUREMENT_ROWS WHERE REQUEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="insert_measure_rows" access="public">
         <cfargument name="req_id">
        <cfargument name="size">
        <cfargument name="detail">
        <cfargument name="detailen">
        <cfargument name="target">
        <cfargument name="yoh">
        <cfargument name="yog">
        <cfargument name="yod">
        <cfargument name="uoh">
        <cfargument name="uog">
        <cfargument name="uod">
        <cfargument name="ush">
        <cfargument name="usg">
        <cfargument name="usd">
        <cfquery name="query_result" datasource="#dsn3#">
            INSERT INTO 
				TEXTILE_MEASUREMENT_ROWS
					(
					REQUEST_ID, 
					STOCK_ID, 
					Detail, 
					DetailEN, 
					Target, 
					YOH, 
					YOG, 
					YOD, 
					UOH, 
					UOG, 
					UOD, 
					USH, 
					USG, 
					USD
					) 
				VALUES
					( 
					<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>, 
					<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.size#'>, 
					<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.detail#'>, 
					<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.detailen#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.target, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.yoh, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.yog, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.yod, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.uoh, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.uog, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.uod, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.ush, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.usg, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.usd, ',', '.')#'>
					)
        </cfquery>
		
    </cffunction>
</cfcomponent>