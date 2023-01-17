<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan	
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility Ürün period Kategorisini getirir.Muhasebe kod grubu bilgisini bulmak için kullanıldı.

----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>    
	<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="get" access="public" returntype="query">
    <cfargument name="product_id" type="numeric" default="0" required="yes">
		<cfquery name="get" datasource="#dsn3#">
            SELECT 
            	PRODUCT_PERIOD.PRODUCT_PERIOD_CAT_ID 
            FROM 
            	PRODUCT_PERIOD,
            	#dsn_alias#.SETUP_PERIOD SP 
            WHERE 
                SP.PERIOD_ID = PRODUCT_PERIOD.PERIOD_ID 
                AND SP.PERIOD_YEAR = #session.ep.period_year# 
                AND PRODUCT_PERIOD.PRODUCT_ID = #attributes.pid# 
                AND SP.OUR_COMPANY_ID = #session.ep.company_id#
        </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>