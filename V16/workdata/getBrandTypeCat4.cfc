<!--- BK 20090710 Fiziki Varlik Arac kategorilerini getirir --->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfargument name="keyword" default="">
        <cfquery name="getBrandTypeCat_" datasource="#DSN#">
            SELECT
               SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME,
				SETUP_BRAND_TYPE_CAT.BRAND_ID,
				SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID,
				SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID,
                REPLACE(SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_WIDTH,'.',',') AS BRAND_TYPE_CAT_WIDTH,
                REPLACE(SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_HEIGHT,'.',',') AS BRAND_TYPE_CAT_HEIGHT,
                REPLACE(SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_WEIGHT,'.',',') AS BRAND_TYPE_CAT_WEIGHT,
                REPLACE(SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_DEPTH,'.',',') AS BRAND_TYPE_CAT_DEPTH,
                SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
                SETUP_BRAND.BRAND_NAME,
  				(SETUP_BRAND.BRAND_NAME + ' - ' + SETUP_BRAND_TYPE.BRAND_TYPE_NAME + ' - ' +  SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME) BRAND_TYPE_CAT_HEAD
            FROM
                SETUP_BRAND_TYPE_CAT,
                SETUP_BRAND_TYPE,
                SETUP_BRAND
            WHERE
                SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
                SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID
			<cfif len(arguments.keyword)>
                AND (SETUP_BRAND_TYPE.BRAND_TYPE_NAME LIKE '%#arguments.keyword#%' OR SETUP_BRAND.BRAND_NAME LIKE '%#arguments.keyword#%' OR SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME LIKE '%#arguments.keyword#%')
            </cfif>
            ORDER BY
                SETUP_BRAND.BRAND_NAME,
                SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
                SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME
        </cfquery>
        <cfreturn getBrandTypeCat_>
    </cffunction>
</cfcomponent>

