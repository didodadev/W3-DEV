<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 19/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility kasaları getirir applicationStart methodunda create edilir.
	
Patameters :
		status : 1/0 default olarak statusu 1 olan kasaları getirir değer gönderilmez ise statusu 1 olan kasaları getirir
		to_cash_id : 1/0 default olarak id ye bakmaksızın kasaları getirir değer gönderilmez ise statusu 1 olan kasaları getirir

Used : getAllCash.get();
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
	<cffunction name="get" access="public" returntype="query">
    	<cfargument name="status" type="numeric" default="1" required="no" hint="Kasa statüsüne bakar.">
        <cfargument name="to_cash_id" type="numeric" default="0" required="no" hint="Kasa id">
    	<cfquery name="get_all_cash" datasource="#dsn2#">
            SELECT 
            	CASH_ID,
                CASH_NAME,
                CASH_CURRENCY_ID,
                BRANCH_ID,
                CASH_ACC_CODE
            FROM 
            	CASH 
            WHERE 
            	1=1 
                <cfif  len(arguments.status)>
            		AND CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.status#">
                </cfif>
                <cfif session.ep.isBranchAuthorization>
            		AND BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
                </cfif>
                <cfif  arguments.to_cash_id neq 0>
                	AND CASH_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.to_cash_id#">
                </cfif>
        </cfquery>
        <cfreturn get_all_cash>
    </cffunction>
</cfcomponent>