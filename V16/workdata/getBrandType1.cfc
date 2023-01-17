<!--- BK 20090710 Fiziki Varlik Arac kategorilerini getirir --->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfargument name="keyword" default="">
        <cfquery name="getBrandType_" datasource="#DSN#">
            SELECT
                SETUP_BRAND_TYPE.BRAND_TYPE_ID,
                SETUP_BRAND_TYPE.BRAND_ID,
                SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
                SETUP_BRAND.BRAND_NAME,
  				(SETUP_BRAND.BRAND_NAME + ' - ' + SETUP_BRAND_TYPE.BRAND_TYPE_NAME) BRAND_TYPE_CAT_HEAD
            FROM
                SETUP_BRAND_TYPE,
                SETUP_BRAND
            WHERE
                SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND
                SETUP_BRAND.MOTORIZED_VEHICLE = 1
			<cfif len(arguments.keyword)>
                AND (SETUP_BRAND_TYPE.BRAND_TYPE_NAME LIKE '%#arguments.keyword#%' OR SETUP_BRAND.BRAND_NAME LIKE '%#arguments.keyword#%')
            </cfif>
            ORDER BY
                SETUP_BRAND.BRAND_NAME,
                SETUP_BRAND_TYPE.BRAND_TYPE_NAME
        </cfquery>
        <cfreturn getBrandType_>
    </cffunction>
</cfcomponent>

