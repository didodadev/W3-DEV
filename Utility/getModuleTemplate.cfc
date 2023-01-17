<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 19/05/2016			Dev Date	: 19/05/2016		
Description :
	Bu utility module ait tanımlanmış belge şablonlarını getirir applicationStart methodunda create edilir.
	
Patameters :
		moduleType : moduleId değerini alır.
		tempLate Id : ilgili belge şablonunun detayını getirir.

Used : getModuleTemplate.get(moduleType:27);
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="moduleType" type="numeric" default="0" required="no">
        <cfargument name="templateId" type="numeric" default="0" required="no">
        
		<cfquery name="get" datasource="#DSN#">
            SELECT 
            	TEMPLATE_ID,
                TEMPLATE_HEAD,
                ISNULL(IS_LOGO,0) AS IS_LOGO,
                TEMPLATE_CONTENT
            FROM 
            	TEMPLATE_FORMS 
            WHERE 
            	1 = 1
				<cfif arguments.moduleType neq 0>
	                AND TEMPLATE_MODULE = #arguments.moduleType#
                </cfif>
                <cfif arguments.templateId neq 0>
	                AND TEMPLATE_ID = #arguments.templateId#
                </cfif>
            ORDER BY
            	TEMPLATE_HEAD
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>