<cfif isdefined("attributes.is_submitted")>
<cfif isDefined("attributes.start_date")  and len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif isDefined("attributes.finish_date")  and len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfquery name="GET_PUNISHMENT_SEARCH" datasource="#dsn#">
	SELECT 
		ASSET_P_PUNISHMENT.*,
		ASSET_P.ASSETP,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,		
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		SETUP_PUNISHMENT_TYPE.PUNISHMENT_TYPE_NAME
	FROM
		ASSET_P_PUNISHMENT,
		ASSET_P,
		EMPLOYEES,
		BRANCH,
		DEPARTMENT,
		SETUP_PUNISHMENT_TYPE
	WHERE
		<!--- Sadece yetkili olunan şubeler gözüksün. Onur P. --->
		BRANCH.BRANCH_ID IN 
		(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		<cfif len(attributes.branch_id)>AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
		<cfif len(attributes.punishment_type_id)>AND ASSET_P_PUNISHMENT.PUNISHMENT_TYPE_ID =#attributes.punishment_type_id#</cfif>
		<cfif len(attributes.assetp_id) and len(attributes.assetp_name)>AND ASSET_P.ASSETP_ID = #attributes.assetp_id#</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee_name)>AND ASSET_P_PUNISHMENT.EMPLOYEE_ID = #attributes.employee_id#</cfif>
		<cfif isDefined("attributes.start_date") and len(attributes.start_date)> AND <cfif attributes.date_interval eq 1> ASSET_P_PUNISHMENT.PUNISHMENT_DATE <cfelseif attributes.date_interval eq 2> ASSET_P_PUNISHMENT.LAST_PAYMENT_DATE <cfelse> ASSET_P_PUNISHMENT.PAID_DATE </cfif> >= #attributes.start_date#</cfif>
		<cfif isDefined("attributes.finish_date") and len(attributes.finish_date)> AND <cfif attributes.date_interval eq 1> ASSET_P_PUNISHMENT.PUNISHMENT_DATE <cfelseif attributes.date_interval eq 2> ASSET_P_PUNISHMENT.LAST_PAYMENT_DATE <cfelse> ASSET_P_PUNISHMENT.PAID_DATE </cfif> <= #attributes.finish_date#</cfif>
		<cfif isdefined("attributes.accident_relation")><cfif attributes.accident_relation eq 2>AND ASSET_P_PUNISHMENT.ACCIDENT_ID IS NOT NULL<cfelseif attributes.accident_relation eq 3>AND ASSET_P_PUNISHMENT.ACCIDENT_ID IS NULL</cfif></cfif>
		AND ASSET_P_PUNISHMENT.ASSETP_ID = ASSET_P.ASSETP_ID
		AND EMPLOYEES.EMPLOYEE_ID = ASSET_P_PUNISHMENT.EMPLOYEE_ID
		AND ASSET_P.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND SETUP_PUNISHMENT_TYPE.PUNISHMENT_TYPE_ID = ASSET_P_PUNISHMENT.PUNISHMENT_TYPE_ID
	ORDER BY
		ASSET_P_PUNISHMENT.PUNISHMENT_DATE DESC
</cfquery>
</cfif>
