<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 02/06/2016			Dev Date	: 02/06/2016		
Description :
	Bu utility havalenin banka talimatından oluşup oluşmadığının kontrolünü yapar. applicationStart methodunda create edilir.
Patameters :
		multiId,actionId,dsn,orderId
		değerlerini alır.
Used : getOrderId.get(
		multiId	: 3,
		actionId	: 4,
		dsn	:	new_dsn2
);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
	<cffunction name="get" access="public" returntype="any"> 
		<cfargument name="multiId" type="numeric" required="no" default="0" hint="Toplu İşlem ID">
        <cfargument name="actionId" type="numeric" required="no" default="0" hint="İşlem ID">
        <cfargument name="orderId" type="numeric" required="no" default="0" hint="Talimat ID">
        <cfargument name="old_process_type" type="numeric" required="no" default="0" hint="Talimat ID">
        <cfargument name="dsn" type="string" required="no" default="#dsn2#" hint="Datasource Name">
        <cfquery name="CHECK_BANK_ORDERS" datasource="#arguments.dsn#">
        	<cfif arguments.orderId eq 0>
                SELECT	
                    BANK_ORDER_ID
                FROM
                    BANK_ACTIONS
                WHERE
                	<cfif arguments.multiId neq 0>
                         MULTI_ACTION_ID = #arguments.multiId#
                        <cfif arguments.actionId neq 0>
                            AND ACTION_ID = #arguments.actionId#
                        </cfif>
                    <cfelse>
                    	ACTION_ID = #arguments.actionId#                 	
                    </cfif>
            <cfelseif arguments.orderId neq 0>
            	SELECT
                	BANK_ORDER_TYPE,
                    BANK_ORDER_TYPE_ID,
                    IS_PAID
                FROM
                	BANK_ORDERS
                WHERE
                	BANK_ORDER_ID = #arguments.orderId#  
                    AND BANK_ORDER_TYPE=#arguments.old_process_type#          	
            </cfif>
        </cfquery>
		<cfreturn CHECK_BANK_ORDERS>
	</cffunction>
</cfcomponent>