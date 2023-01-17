<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan	
Analys Date : 26/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility Şirket Bilgilerini getirir.
	
Patameters :

Used : getOurCompanyInfo.get();
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="get" access="public" returntype="query">
    <cfargument name="type" type="numeric" default="0" required="yes"><!--- work_stock_id null olmayan kayıtları cekmek ve  buna stock bazında bakmak için kullanıldı  --->
		<cfquery name="get" datasource="#dsn#">
            SELECT 
            	IS_BRAND_TO_CODE,
                IS_BARCOD_REQUIRED,
                IS_GUARANTY_FOLLOWUP,
                IS_PRODUCT_COMPANY,
                WORK_STOCK_ID 
                <cfif type neq 0 and type eq 2>
                    ,STOCKS.PRODUCT_NAME
                    ,STOCKS.PROPERTY
                </cfif>
            FROM 
            	OUR_COMPANY_INFO
            <cfif type neq 0 and type eq 2>
            	,#dsn3#.STOCKS STOCKS
            </cfif> 
            <cfif type neq 0 and type eq 1>
            WHERE 
            	WORK_STOCK_ID IS NOT NULL
            <cfelseif type neq 0 and type eq 2>
            WHERE	
                OUR_COMPANY_INFO.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                STOCKS.STOCK_ID = OUR_COMPANY_INFO.WORK_STOCK_ID AND
                OUR_COMPANY_INFO.WORK_STOCK_ID IS NOT NULL
            <cfelse>
            WHERE 
            	COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            </cfif>            
        </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>