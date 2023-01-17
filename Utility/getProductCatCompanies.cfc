<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Pınar Yıldız			Developer	: Pınar Yıldız	
Analys Date : 06/06/2016			Dev Date	: 06/06/2016		
Description :
	Bu utility Ürün Kategorisi ile İlişkili Şirket Bilgilerini getirir.

----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>    
	<cfset dsn1 = '#dsn#_product'>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="categoryId" type="numeric" default="0" required="yes" hint="Ürün Kategori ID">
        <cfquery name="getProductCatCompanies" datasource="#DSN1#">
            SELECT 
                OUR_COMPANY_ID 
            FROM 
                PRODUCT_CAT_OUR_COMPANY 
            WHERE 
            	PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.categoryId#">
        </cfquery>
		<cfreturn getProductCatCompanies>
	</cffunction>
</cfcomponent>