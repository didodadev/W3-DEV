<cfquery name="GET_CATALOG_DETAIL" datasource="#dsn3#">
	SELECT
		CATALOG_ID,
		STAGE_ID,
		CATALOG_STATUS, 
		CATALOG_HEAD, 
		CATALOG_DETAIL,
		BARCOD,
		STARTDATE,
		FINISHDATE,
		TARGET_COMPANY,
		TARGET_CUSTOMER,
		VALIDATOR_POSITION_CODE,
		VALID,
		VALID_EMP,
		VALIDATE_DATE,
		CATALOG_NO,
		RECORD_EMP,
		RECORD_DATE
	FROM
		CATALOG
	WHERE
		CATALOG_ID = #URL.ID#
</cfquery>
