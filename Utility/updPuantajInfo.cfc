<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 02/06/2016			Dev Date	: 02/06/2016		
Description :
	Bu utility puantajdan oluşturulan havaleler için puantaj bilgisini günceller. applicationStart methodunda create edilir.
Patameters :
		actionId,periodId,puantajId,isVirtual
		değerlerini alır.
Used :  updPuantajInfo.upd(
			actionId	:	addMulti,
			periodId	:	new_period_id,
			puantajId	:	attributes.puantaj_id,
			isVirtual	:	attributes.is_virtual
		);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="upd" access="public" returntype="boolean">
		<cfargument name="actionId" type="numeric" required="yes" hint="Toplu İşlem ID">
        <cfargument name="periodId" type="numeric" required="yes" hint="Periyot">
        <cfargument name="puantajId" type="numeric" required="yes" hint="İlgili Puantaj">
        <cfargument name="isVirtual" type="numeric" required="yes" hint="Sanal Puantaj mı?">
        <cfquery name="upd_employee_act" datasource="#dsn#">
            UPDATE
                EMPLOYEES_PUANTAJ_CARI_ACTIONS
            SET
                BANK_ACTION_MULTI_ID = #arguments.actionId#,
                BANK_PERIOD_ID = #arguments.periodId#
            WHERE
                PUANTAJ_ID = #arguments.puantajId#
                AND IS_VIRTUAL = #arguments.isVirtual#
        </cfquery>
		<cfreturn myResult>
	</cffunction>
</cfcomponent>