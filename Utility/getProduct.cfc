<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan	
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility Ürünün stoklarını getirir.
	
Patameters :

----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset product = 'product'>       
    <cfset dsn1 = dsn & '_' & product>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="product_id" type="numeric" default="0" required="yes">
        <cfargument name="product_code" type="string" default="NULL" required="no">
		<cfquery name="get" datasource="#dsn1#">
            SELECT 
            	PRODUCT_CODE,
                *
            FROM 
            	PRODUCT            
            WHERE             
            	PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code#">
           <cfif isdefined("arguments.product_id") and len(arguments.product_id)>
                AND PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
            </cfif>
        </cfquery>        
		<cfreturn get>
	</cffunction>
</cfcomponent>