<cfif isdefined("attributes.is_submitted")>
<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfquery name="GET_ACCIDENT_SEARCH" datasource="#dsn#">
	SELECT 
		ASSET_P_ACCIDENT.*,
		ASSET_P.ASSETP,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		SETUP_ACCIDENT_TYPE.ACCIDENT_TYPE_NAME,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		ASSET_P_ACCIDENT.DOCUMENT_TYPE_ID
	FROM
		ASSET_P,
		ASSET_P_ACCIDENT,
		EMPLOYEES,
		SETUP_ACCIDENT_TYPE,
		BRANCH,
		DEPARTMENT
	WHERE
		<!--- Sadece yetkili olunan şubeler gözüksün.--->
		BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		<cfif len(attributes.branch_id)>AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
		<cfif isdefined("attributes.accident_type_id") and len(attributes.accident_type_id)>AND ASSET_P_ACCIDENT.ACCIDENT_TYPE_ID = #attributes.accident_type_id#</cfif>
		<cfif len(attributes.assetp_id) and len(attributes.assetp_name)>AND ASSET_P.ASSETP_ID = #attributes.assetp_id#</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee_name)>AND ASSET_P_ACCIDENT.EMPLOYEE_ID = #attributes.employee_id#</cfif>
		<cfif len(attributes.document_type_id)>
		<cfif (attributes.document_type_id eq 3)>AND ASSET_P_ACCIDENT.DOCUMENT_TYPE_ID = 3
			<cfelseif (attributes.document_type_id eq 4)>AND ASSET_P_ACCIDENT.DOCUMENT_TYPE_ID = 4
		</cfif>		
		</cfif>
		<cfif len(attributes.document_num)>AND ASSET_P_ACCIDENT.DOCUMENT_NUM LIKE '%#attributes.document_num#%'</cfif>
		<cfif (attributes.is_insurance_payment eq 2)>AND ASSET_P_ACCIDENT.INSURANCE_PAYMENT = 1
			<cfelseif (attributes.is_insurance_payment eq 3)>AND ASSET_P_ACCIDENT.INSURANCE_PAYMENT <> 1
		</cfif>
		<cfif len(attributes.start_date)>AND ASSET_P_ACCIDENT.ACCIDENT_DATE >= #attributes.start_date#</cfif>
		<cfif len(attributes.finish_date)>AND ASSET_P_ACCIDENT.ACCIDENT_DATE <= #attributes.finish_date#</cfif>
		<cfif len(attributes.record_num)>AND ASSET_P_ACCIDENT.ACCIDENT_ID = #attributes.record_num#</cfif>
		AND ASSET_P.ASSETP_ID = ASSET_P_ACCIDENT.ASSETP_ID
		AND EMPLOYEES.EMPLOYEE_ID = ASSET_P_ACCIDENT.EMPLOYEE_ID
		AND SETUP_ACCIDENT_TYPE.ACCIDENT_TYPE_ID = ASSET_P_ACCIDENT.ACCIDENT_TYPE_ID
		AND ASSET_P_ACCIDENT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID		
	ORDER BY
		ASSET_P_ACCIDENT.ACCIDENT_DATE DESC
</cfquery>
</cfif>
