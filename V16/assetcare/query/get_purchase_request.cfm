<cfquery name="GET_REQUEST_ROWS" datasource="#DSN#">
	SELECT
		ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID,
		ASSET_P_REQUEST_ROWS.ASSETP_CATID,
		ASSET_P_REQUEST_ROWS.USAGE_PURPOSE_ID,
		ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID,
		ASSET_P_REQUEST_ROWS.MAKE_YEAR,
		ASSET_P_REQUEST_ROWS.PERT_ID,
		ASSET_P_REQUEST_ROWS.ASSETP_ID,
		ASSET_P_REQUEST_ROWS.EMPLOYEE_ID,
		ASSET_P_REQUEST_ROWS.BRANCH_ID,
		ASSET_P_REQUEST_ROWS.DETAIL,
		ASSET_P_REQUEST_ROWS.REQUEST_DATE,
		ASSET_P_REQUEST_ROWS.REQUEST_STATE,
		ASSET_P_REQUEST_ROWS.RECORD_EMP,
		ASSET_P_REQUEST_ROWS.RECORD_IP,
		ASSET_P_REQUEST_ROWS.RECORD_DATE,
		ASSET_P_REQUEST_ROWS.UPDATE_DATE,
		ASSET_P_REQUEST_ROWS.UPDATE_EMP,
		ASSET_P_REQUEST_ROWS.UPDATE_IP,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		SETUP_BRAND.BRAND_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		BRANCH.BRANCH_NAME,
		PROCESS_TYPE_ROWS.LINE_NUMBER,
		ASSET_P.ASSETP
	FROM 
		ASSET_P_REQUEST_ROWS,
		SETUP_BRAND_TYPE,
		SETUP_BRAND,
		EMPLOYEES,
		BRANCH,
		PROCESS_TYPE_ROWS,
		ASSET_P
	WHERE 
		ASSET_P_REQUEST_ROWS.REQUEST_ID = #attributes.request_id# AND
		ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID = #attributes.request_row_id# AND
		ASSET_P_REQUEST_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		ASSET_P_REQUEST_ROWS.BRANCH_ID = BRANCH.BRANCH_ID AND
		ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
		SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND
		ASSET_P_REQUEST_ROWS.PERT_ID  = ASSET_P.ASSETP_ID AND
		ASSET_P_REQUEST_ROWS.REQUEST_STATE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
		
	UNION ALL
	
	SELECT
		ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID,
		ASSET_P_REQUEST_ROWS.ASSETP_CATID,
		ASSET_P_REQUEST_ROWS.USAGE_PURPOSE_ID,
		ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID,
		ASSET_P_REQUEST_ROWS.MAKE_YEAR,
		ASSET_P_REQUEST_ROWS.PERT_ID,
		ASSET_P_REQUEST_ROWS.ASSETP_ID,
		ASSET_P_REQUEST_ROWS.EMPLOYEE_ID,
		ASSET_P_REQUEST_ROWS.BRANCH_ID,
		ASSET_P_REQUEST_ROWS.DETAIL,
		ASSET_P_REQUEST_ROWS.REQUEST_DATE,
		ASSET_P_REQUEST_ROWS.REQUEST_STATE,
		ASSET_P_REQUEST_ROWS.RECORD_EMP,
		ASSET_P_REQUEST_ROWS.RECORD_IP,
		ASSET_P_REQUEST_ROWS.RECORD_DATE,
		ASSET_P_REQUEST_ROWS.UPDATE_DATE,
		ASSET_P_REQUEST_ROWS.UPDATE_EMP,
		ASSET_P_REQUEST_ROWS.UPDATE_IP,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		SETUP_BRAND.BRAND_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		BRANCH.BRANCH_NAME,
		PROCESS_TYPE_ROWS.LINE_NUMBER,
		'' AS ASSETP
	FROM 
		ASSET_P_REQUEST_ROWS,
		SETUP_BRAND_TYPE,
		SETUP_BRAND,
		EMPLOYEES,
		PROCESS_TYPE_ROWS,
		BRANCH
	WHERE 
		ASSET_P_REQUEST_ROWS.REQUEST_ID = #attributes.request_id# AND
		ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID = #attributes.request_row_id# AND
		ASSET_P_REQUEST_ROWS.PERT_ID IS NULL AND
		ASSET_P_REQUEST_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		ASSET_P_REQUEST_ROWS.BRANCH_ID = BRANCH.BRANCH_ID AND
		ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
		SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND
		ASSET_P_REQUEST_ROWS.REQUEST_STATE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
	ORDER BY
		REQUEST_ROW_ID
</cfquery>

