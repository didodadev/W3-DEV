<!--- Pınar Yıldız 250320
Bütçe Tarih Kısıtlama Tarihini Çeken Fonksiyon --->
<cfset dsn = application.systemParam.systemParam().dsn>
<cffunction name="get_budget_period_date" access="public" returnType="query" output="yes">
	<!---<cfargument  name="position_code" value="#session.ep.position_code#">--->
	<cfquery name="get_date" datasource="#dsn#">
		SELECT
			BUDGET_PERIOD_DATE 
		FROM 
			EMPLOYEE_POSITION_PERIODS EPP
			JOIN EMPLOYEE_POSITIONS EP ON  EP.POSITION_ID = EPP.POSITION_ID 
		WHERE 
			EP.POSITION_CODE = #session.ep.position_code#
			AND EPP.PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfreturn get_date>
</cffunction>

