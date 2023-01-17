<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 03/06/2016			Dev Date	: 03/06/2016		
Description :
	Bu utility banka talimatından oluşturulan havalelerin cari işlemini güncellemek için kullanılır. applicationStart methodunda create edilir.
Patameters :
		isProcessed,actionId,actionTypeId,dsn
		değerlerini alır.
Used :  setCariProcessedInfo.upd(
			isProcessed	:	1,
			actionId	:	evaluate("attributes.bank_order_id#i#"),
			actionTypeId	:	bank_order_process_type,
			dsn			:	new_dsn2
		);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
	<cffunction name="upd" access="public" returntype="boolean">
		<cfargument name="isProcessed" type="numeric" required="yes" hint="İşlem Yapıldı mı?">
        <cfargument name="actionId" type="numeric" required="yes" hint="İşlem ID">
        <cfargument name="actionTypeId" type="numeric" required="yes" hint="İşlem Tipi">
        <cfargument name="dsn" type="string" required="no" default="#dsn2#" hint="Datasource">
        <cfquery name="upd_cari" datasource="#arguments.dsn#">
            UPDATE
                CARI_ROWS
            SET 
                IS_PROCESSED = #arguments.isProcessed#
            WHERE 
                ACTION_ID = #arguments.actionId#
                AND ACTION_TYPE_ID = #arguments.actionTypeId#
        </cfquery>
		<cfreturn true>
	</cffunction>
</cfcomponent>