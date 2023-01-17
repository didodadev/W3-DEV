<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_STOCK_ACTION,
		IS_ACCOUNT_GROUP,
		IS_COST
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfset process_type = get_process_type.PROCESS_TYPE>
<cfset is_cari = get_process_type.IS_CARI>
<cfset is_account = get_process_type.IS_ACCOUNT>
<cfset is_account_group = get_process_type.IS_ACCOUNT_GROUP>
