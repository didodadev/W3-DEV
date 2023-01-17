<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 31/05/2016			Dev Date	: 31/05/2016		
Description :
	Bu utility belirtilen işlem ve işlem tipi id'lerine ait cari işlem bilgilerini döndürür. applicationStart methodunda create edilir.
Patameters :
		actionId,actionType
		değerlerini alır.
Used :  GET_CARI_INFO = getCariActionId.get(
			actionId : add,
			actionType : process_type
		);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
	<cffunction name="get" access="public" returntype="query">
		<cfargument name="actionId" type="numeric" required="yes" hint="İşlem Id">
        <cfargument name="actionType" type="numeric" required="yes" hint="İşlem Tipi">
        <cfquery name="GET_CARI_INFO" datasource="#dsn2#">
            SELECT 
                CARI_ACTION_ID,
                ACTION_VALUE,
                OTHER_CASH_ACT_VALUE,
                OTHER_MONEY,
                DUE_DATE
            FROM 
                CARI_ROWS 
            WHERE 
                ACTION_ID = #arguments.actionId# AND 
                ACTION_TYPE_ID = #arguments.actionType#
        </cfquery>
		<cfreturn GET_CARI_INFO>
	</cffunction>
</cfcomponent>