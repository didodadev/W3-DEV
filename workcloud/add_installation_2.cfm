<cfscript>
	dosya = ArrayNew(1);
	dosya_acma = "<cfscript>";
	ArrayAppend(dosya,dosya_acma);
	
	dosya_satir = "workcube_version = 'v 16';";
	ArrayAppend(dosya,dosya_satir);
	
	dosya_satir = "server_detail = '#attributes.server_detail#';";
	ArrayAppend(dosya,dosya_satir);
	
	dosya_satir = "database_type = '#attributes.db_type#';";
	ArrayAppend(dosya,dosya_satir);
	
	dosya_satir = "dsn = '#attributes.datasource#';";
	ArrayAppend(dosya,dosya_satir);
	
	dosya_satir = "database_host = '#attributes.db_host#';";
	ArrayAppend(dosya,dosya_satir);
	
	dosya_satir = "database_folder = '#attributes.db_folder#';";
	ArrayAppend(dosya,dosya_satir);
	
	dosya_satir = "database_log_folder = '#attributes.db_folder#';";
	ArrayAppend(dosya,dosya_satir);
	
	dosya_satir = "database_username = '#attributes.db_username#';";
	ArrayAppend(dosya,dosya_satir);
	
	dosya_satir = "database_password = '#attributes.db_password#';";
	ArrayAppend(dosya,dosya_satir);
	
	dosya_satir = "cf_admin_password = '#attributes.cf_admin_password#';";
	ArrayAppend(dosya,dosya_satir);
	
	dosya_satir = "fusebox.server_machine = '1';";
	ArrayAppend(dosya,dosya_satir);
	
	dosya_satir = "fusebox.server_machine_list = '#installUrl#';";
	ArrayAppend(dosya,dosya_satir);
</cfscript>
<cftry>
	<cffile action="delete" file="#index_folder#fbx_workcube_param_gecici.cfm">
	<cfcatch type="Any"></cfcatch>
</cftry>
<cffile action="write" output="#ArrayToList(dosya,CRLF)#" addnewline="yes" file="#index_folder#fbx_workcube_param_gecici.cfm" charset="utf-8">
<cftry>
	<cfquery name="get_" datasource="#attributes.datasource#">
		SELECT TOP 1 EMPLOYEE_ID FROM EMPLOYEES
	</cfquery>
	<cfcatch type="any">
		<cfinclude template="DB/create_main_db.cfm">
		<cfinclude template="DB/create_main_db_2.cfm">
		<cfquery name="ADD_LICENSE" datasource="#attributes.datasource#">
			INSERT INTO 
				WRK_LICENSE(
					WORKCUBE_ID,
					TEL,
					EMAIL,
					WORKCUBE_ID1,
					LICENSE_TYPE,
					RELEASE_NO,
					RELEASE_DATE,
					PROJECT_ID,
					GIT_URL,
					GIT_DIR,
					GIT_BRANCH,
					COMPANY,
					COMPANY_PARTNER,
					GOOGLE_ANALYTICS_ID,
					PARAMS
				)
				VALUES
				(
					<cfqueryparam value = "#attributes.license_code#" CFSQLType = "cf_sql_varchar">,
					<cfqueryparam value = "+90 216 428 39 39" CFSQLType = "cf_sql_varchar">,
					<cfqueryparam value = "info@workcube.com" CFSQLType = "cf_sql_varchar">,
					<cfqueryparam value = "#attributes.license_code#" CFSQLType = "cf_sql_varchar">,
					NULL,
					<cfqueryparam value = "19.1" CFSQLType = "cf_sql_varchar">,
					<cfqueryparam value = "2019-01-07 00:00:00.000" CFSQLType = "cf_sql_varchar">,
					<cfqueryparam value = "1" CFSQLType = "cf_sql_varchar">,
					NULL,
					NULL,
					<cfqueryparam value = "releases/19.1" CFSQLType = "cf_sql_varchar">,
					NULL,
					NULL,
					NULL,
					NULL
				)
		</cfquery>
	</cfcatch>
</cftry>
