<cfquery name="get_allocate" datasource="#dsn#">
	SELECT
			ASSET_P_KM_CONTROL.KM_CONTROL_ID,
			ASSET_P_KM_CONTROL.ASSETP_ID,
			ASSET_P_KM_CONTROL.EMPLOYEE_ID,
			ASSET_P_KM_CONTROL.START_DATE,
			ASSET_P_KM_CONTROL.FINISH_DATE,
			ASSET_P_KM_CONTROL.KM_START,
			ASSET_P_KM_CONTROL.KM_FINISH,
			ASSET_P_KM_CONTROL.ALLOCATE_DETAIL,
			ASSET_P_KM_CONTROL.IS_OFFTIME,
			ASSET_P_KM_CONTROL.RECORD_EMP,
			ASSET_P_KM_CONTROL.RECORD_DATE,
			ASSET_P_KM_CONTROL.UPDATE_EMP,
			ASSET_P_KM_CONTROL.UPDATE_DATE,
			ASSET_P_KM_CONTROL.ALLOCATE_NAME,
			ASSET_P_KM_CONTROL.DESTINATION,
			ASSET_P_KM_CONTROL.PROJECT_ID,
			ASSET_P_KM_CONTROL.PROCESS_ROW_ID,
			ASSET_P.ASSETP,
			ASSET_P_KM_CONTROL.ASSETP_ID,
			ASSET_P_KM_CONTROL.START_DATE,
			ASSET_P_KM_CONTROL.FINISH_DATE,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.BRANCH_NAME,
			ZONE.ZONE_NAME
	FROM 
			ASSET_P_KM_CONTROL,
			ASSET_P,
			EMPLOYEES,
			DEPARTMENT,
			BRANCH,
			ZONE
	WHERE 
			ASSET_P_KM_CONTROL.IS_ALLOCATE = 1
			AND ASSET_P_KM_CONTROL.KM_CONTROL_ID = #attributes.km_control_id#
			AND ASSET_P.ASSETP_ID = ASSET_P_KM_CONTROL.ASSETP_ID
			AND EMPLOYEES.EMPLOYEE_ID = ASSET_P_KM_CONTROL.EMPLOYEE_ID
			AND DEPARTMENT.DEPARTMENT_ID = ASSET_P_KM_CONTROL.DEPARTMENT_ID
			AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
			AND BRANCH.ZONE_ID = ZONE.ZONE_ID
</cfquery>
<cfquery name="get_allocate_reasons" datasource="#dsn#">
	SELECT 
			ALLOCATE_REASON_ID 
	FROM 
			ASSET_P_KM_CONTROL
	WHERE
			KM_CONTROL_ID = #attributes.km_control_id#
</cfquery>
