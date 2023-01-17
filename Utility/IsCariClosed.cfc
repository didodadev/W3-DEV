<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility belgeye ait fatura kapama bilgilerini döndürür. applicationStart methodunda create edilir.
Patameters :
		actionId,actionTypeId değerlerini alır.
Used :  get_closed = IsCariClosed.get(
			actionId : get_action_detail.action_id,
			actionTypeId : get_action_detail.action_type_id
		);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
	<cffunction name="get" access="public" returntype="query">
		<cfargument name="actionId" type="string" required="yes" hint="İşlem Id">
        <cfargument name="actionTypeId" type="numeric" required="yes" hint="İşlem Tipi">
		<cfquery name="getClosed" datasource="#dsn2#">
            SELECT 
                CARI_CLOSED.CLOSED_ID
            FROM 
                CARI_CLOSED_ROW
                LEFT JOIN CARI_CLOSED ON CARI_CLOSED.CLOSED_ID = CARI_CLOSED_ROW.CLOSED_ID
            WHERE 
                CARI_CLOSED.IS_CLOSED = 1 AND
                CARI_CLOSED_ROW.ACTION_ID IN (#arguments.actionId#) AND
                CARI_CLOSED_ROW.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.actionTypeId#">
        </cfquery>
		<cfreturn getClosed>
	</cffunction>
</cfcomponent>