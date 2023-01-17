<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 01/06/2016			Dev Date	: 01/06/2016		
Description :
	Bu utility avans talebinden oluşturulan havalelerin durumunu güncellemek için kullanılır. applicationStart methodunda create edilir.
Patameters :
		correspondenceId,actionId,actionTypeId,actionPeriodId
		değerlerini alır.
Used :  	updCorrespondencePayment.upd(
				correspondenceId	:	evaluate("attributes.avans_id#i#"),
				actionId			:	add,
				actionTypeId		:	25,
				actionPeriodId		:	new_period_id
			);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
	<cffunction name="upd" access="public" returntype="boolean">
		<cfargument name="correspondenceId" type="numeric" required="no" hint="Avans ID">
        <cfargument name="actionId" type="numeric" required="no" default="0" hint="Banka İşlem ID">
        <cfargument name="multiId" type="numeric" required="no" default="0" hint="Toplu İşlem ID">
        <cfargument name="actionTypeId" type="numeric" required="yes" default="0" hint="İşlem Tipi">
        <cfargument name="actionPeriodId" type="numeric" required="yes" hint="İşlem Dönem ID">
        <cfquery name="upd_corr_payment" datasource="#dsn#">
        	<cfif arguments.multiId eq 0>
                UPDATE
                    CORRESPONDENCE_PAYMENT
                SET
                    <cfif arguments.actionTypeId eq 0>
                        ACTION_ID = NULL,
                        ACTION_TYPE_ID = NULL  
                    <cfelse>
                        ACTION_ID = #arguments.actionId#,
                        ACTION_TYPE_ID = #arguments.actionTypeId#,
                        ACTION_PERIOD_ID = #arguments.actionPeriodId#
                    </cfif>
                WHERE
                    ID = #arguments.correspondenceId#
                    <cfif arguments.actionTypeId eq 0>
                        AND ACTION_ID = #arguments.actionId#
                    </cfif>
            <cfelseif arguments.multiId neq 0>
                UPDATE 
                    CORRESPONDENCE_PAYMENT
                SET
                    ACTION_ID = NULL,
                    ACTION_TYPE_ID = NULL,
                    ACTION_PERIOD_ID = NULL
                WHERE
                    ACTION_ID IN(SELECT ACTION_ID FROM #dsn2#.BANK_ACTIONS WHERE MULTI_ACTION_ID = #arguments.multiId#) AND
                    ACTION_TYPE_ID = #arguments.actionTypeId# AND
                    ACTION_PERIOD_ID = #arguments.actionPeriodId#
            </cfif>
        </cfquery>
		<cfreturn true>
	</cffunction>
</cfcomponent>