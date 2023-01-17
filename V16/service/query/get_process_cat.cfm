<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_STOCK_ACTION,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>

