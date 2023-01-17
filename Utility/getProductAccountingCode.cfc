<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan		
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility Ürün Muhasebe Kod Listesini getirir.
----------------------------------------------------------------------->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>    
	<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="active_cat" type="numeric" default="" required="no">
        <cfargument name="keyword" type="string" default="" required="no">
            <cfquery name="get" datasource="#dsn3#">
                SELECT
                    *
                FROM
                    SETUP_PRODUCT_PERIOD_CAT
                WHERE
                    1 = 1
                <cfif isdefined('arguments.active_cat')>    
                    AND IS_ACTIVE = 1
                </cfif>
                <cfif isdefined('arguments.keyword') and len(arguments.keyword)>
                    AND PRO_CODE_CAT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                ORDER BY
                    PRO_CODE_CAT_NAME
            </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>