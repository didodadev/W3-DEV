<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfargument name="keyword" default="">
        <cfquery name="getProductBrand_" datasource="#dsn#_#session.ep.company_id#">
           SELECT
                PB.BRAND_ID,
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE BRAND_NAME
                END AS BRAND_NAME,
                PB.BRAND_CODE,
                CASE WHEN (PB.IS_INTERNET = 1) 
                  THEN
                    'Webde Görünür'
                  ELSE
                    'Webde Görünmez'
                  END AS IS_INTERNET  
            FROM
                PRODUCT_BRANDS PB
                	LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = BRAND_ID
                    AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="BRAND_NAME">
                    AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_BRANDS">
                    AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
            WHERE
				PB.IS_ACTIVE = 1 AND
                BRAND_NAME LIKE '%#arguments.keyword#%'
            ORDER BY 
				BRAND_NAME
        </cfquery>
        <cfreturn getProductBrand_>
    </cffunction>
</cfcomponent>

