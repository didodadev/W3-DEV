<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 01/06/2016			Dev Date	: 01/06/2016		
Description :
	Bu utility periyot bilgisi döndürür. applicationStart methodunda create edilir.
Patameters :
		branchId,date,period_id değerlerini alır.
Used :  get_period_id = getSetupPeriod.get(
			branchId	:	branch_id_info,
			date		:	attributes.action_date,
			period_id	:	session.ep.period_id
		);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get" access="public" returntype="query">
		<cfargument name="branchId" type="numeric" required="no" default="0" hint="Şube">
        <cfargument name="date" type="string" required="no" hint="Tarih">
        <cfargument name="period_id" type="numeric" required="no" default="0" hint="Periyod Id">
        <cfquery name="get_period_id" datasource="#dsn#">
            SELECT
                PERIOD_ID,
                PERIOD_YEAR,
                OUR_COMPANY_ID,
                INVENTORY_CALC_TYPE
            FROM
                SETUP_PERIOD
            WHERE
            	1=1
                <cfif arguments.branchId neq 0>
                	AND OUR_COMPANY_ID = (SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #arguments.branchId#)
                </cfif>
                <cfif len(arguments.date)>
                    AND (PERIOD_YEAR = #year(arguments.date)# OR YEAR(FINISH_DATE) = #year(arguments.date)#)
                    AND (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= #arguments.date#))
                </cfif>
                <cfif arguments.period_id neq 0>
                	AND PERIOD_ID = #session.ep.period_id#
                </cfif>
        </cfquery>
		<cfreturn get_period_id>
	</cffunction>
</cfcomponent>