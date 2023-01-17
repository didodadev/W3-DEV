<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Pınar Yıldız			Developer	: Pınar Yıldız	
Analys Date : 06/06/2016			Dev Date	: 06/06/2016		
Description :
	Bu utility Ürün Kategori Sorumluları Bilgisini getirir.

----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>    
	<cfset dsn1 = '#dsn#_product'>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="categoryId" type="numeric" default="0" required="yes" hint="Ürün Kategori ID">
        <cfquery name="getResponsibles" datasource="#DSN1#">
            SELECT 
                PCP.POSITION_CODE,
                PCP.SEQUENCE_NO,
                EMP.EMPLOYEE_NAME,
                EMP.EMPLOYEE_SURNAME 
            FROM 
                PRODUCT_CAT_POSITIONS PCP
                LEFT JOIN #dsn#.EMPLOYEE_POSITIONS EMP ON PCP.POSITION_CODE = EMP.POSITION_CODE
            WHERE
                PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.categoryId#">
        </cfquery>
		<cfreturn getResponsibles>
	</cffunction>
</cfcomponent>