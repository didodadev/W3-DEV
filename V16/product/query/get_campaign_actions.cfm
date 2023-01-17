<cfquery name="GET_CAMPAIGN_ACTIONS" datasource="#DSN3#">
	SELECT
		CATALOG_PROMOTION.CATALOG_ID,
		CATALOG_PROMOTION.CATALOG_HEAD,
		CATALOG_PROMOTION.STARTDATE,
		CATALOG_PROMOTION.FINISHDATE,
		CATALOG_PROMOTION.KONDUSYON_DATE,
		CATALOG_PROMOTION.KONDUSYON_FINISH_DATE,
		CATALOG_PROMOTION.CAT_PROM_NO,
		CATALOG_PROMOTION.IS_APPLIED,
		CATALOG_PROMOTION.VALIDATOR_POSITION_CODE,
		CATALOG_PROMOTION.VALID,
		CATALOG_PROMOTION.VALID_EMP,
		CATALOG_PROMOTION.VALIDATE_DATE,
		#dsn_alias#.EMPLOYEES.EMPLOYEE_NAME,
		#dsn_alias#.EMPLOYEES.EMPLOYEE_SURNAME,
		#dsn_alias#.SETUP_ACTION_STAGES.STAGE_NAME
	FROM
		CATALOG_PROMOTION,
		#dsn_alias#.EMPLOYEES,
		#dsn_alias#.SETUP_ACTION_STAGES
	WHERE
		CATALOG_PROMOTION.CAMP_ID = #attributes.CAMP_ID# AND
		#dsn_alias#.EMPLOYEES.EMPLOYEE_ID = CATALOG_PROMOTION.RECORD_EMP AND
		#dsn_alias#.SETUP_ACTION_STAGES.STAGE_ID = CATALOG_PROMOTION.STAGE_ID AND
		(CATALOG_PROMOTION.IS_APPLIED IS NULL OR CATALOG_PROMOTION.IS_APPLIED = 0) AND
		CATALOG_PROMOTION.STAGE_ID = -2 
</cfquery>
