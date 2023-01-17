<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Göksenin Sönmez Özkorucu		
Analys Date : 19/05/2016			Dev Date	: 27/05/2016		
Description :
	Bu utility Hedef Kategorilerine ait bilgileri getirir applicationStart methodunda create edilir.

Used : getTargetCat.get();
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- get --->
    <cffunction name="get" access="public" returntype="query">
    	<cfargument name="isActive" type="string" default="" required="no">
        <cfquery name="GET_TARGET_CATS" datasource="#dsn#">
            SELECT 
                TARGETCAT_ID,
                TARGETCAT_NAME
            FROM	
                TARGET_CAT
          	WHERE
				1 = 1
                <cfif len(arguments.isActive)>
            		AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isActive#">
             	</cfif>
        </cfquery>
        
        <cfreturn GET_TARGET_CATS>
    </cffunction>
</cfcomponent>