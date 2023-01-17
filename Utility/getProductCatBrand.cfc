<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Pınar Yıldız			Developer	: Pınar Yıldız	
Analys Date : 06/06/2016			Dev Date	: 06/06/2016		
Description :
	Bu utility Ürün Kategori ile İlişkili Marka Bilgilerini getirir.

----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>    
	<cfset dsn1 = '#dsn#_product'>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="categoryId" type="numeric" default="0" required="yes" hint="Ürün Kategori ID">
        <cfquery name="GET_PRODUCT_CAT_BRAND" datasource="#dsn1#">
           SELECT
                PRODUCT_BRANDS.BRAND_ID,
                PRODUCT_BRANDS.BRAND_NAME
            FROM
                PRODUCT_CAT_BRANDS,
                PRODUCT_BRANDS
            WHERE
            	<cfif len(arguments.categoryId)>
                    PRODUCT_CAT_ID = #arguments.categoryId# AND
                </cfif>
                PRODUCT_CAT_BRANDS.BRAND_ID = PRODUCT_BRANDS.BRAND_ID
        </cfquery>
		<cfreturn GET_PRODUCT_CAT_BRAND>
	</cffunction>
</cfcomponent>