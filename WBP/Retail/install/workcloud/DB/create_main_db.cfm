

<cfset newDsn = dsn>
<cfset cf_admin_password = attributes.cf_admin_password />
<cf_add_dsn_mssql dsn="_#attributes.datasource#" db="#newDsn#" host="#attributes.db_host#" port="#attributes.db_port#" username="#attributes.db_username#" password="#attributes.db_password#">
<cfset retail_ds = "#attributes.datasource#_retail">
<cftransaction>
	<cfquery name="addLogin" datasource="_#attributes.datasource#">
		CREATE LOGIN #retail_ds# WITH PASSWORD = '#attributes.db_password#' 
	</cfquery>

	<cfquery name="addSchema" datasource="_#attributes.datasource#">
		CREATE SCHEMA #retail_ds# 
	</cfquery>

	<cfquery name="addUser" datasource="_#attributes.datasource#">
		CREATE USER [#retail_ds#] FOR LOGIN [#retail_ds#] WITH DEFAULT_SCHEMA=[#retail_ds#]
		ALTER ROLE [db_owner] ADD MEMBER [#retail_ds#]
	</cfquery>
	<cf_add_dsn_mssql dsn="#attributes.datasource#" db="#retail_ds#" host="#attributes.db_host#" username="#attributes.datasource#" password="#attributes.db_password#">
</cftransaction>
<cfset newDsn = ( IsDefined("dsn") ) ? dsn : attributes.datasource />
<cflock name="#CreateUUID()#" timeout="500">
<cftry>
	<cftransaction>
		<cfset acilis_codu_ = '<cfquery name="CREATE_MAIN_DB" datasource="#newDsn#">'>
		<cfset kapanis_codu_ = '</cfquery>'>
		<cfsavecontent variable="product_db_tables_icerik"><cfinclude template="schema.txt"></cfsavecontent>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'SET ANSI_NULLS ON GO SET QUOTED_IDENTIFIER ON GO','','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'ON [PRIMARY] GO','ON [PRIMARY]','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'CREATE','#kapanis_codu_##acilis_codu_# CREATE','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'workcube_devcatalyst_retail','#attributes.datasource#','all')>
		<cfset product_db_tables_icerik = '#product_db_tables_icerik##kapanis_codu_#'>
		<cfset product_db_tables_icerik = '#replace(product_db_tables_icerik,'</cfquery>','','one')#'>
		<cffile action="write" output="#product_db_tables_icerik#" addnewline="yes" file="#index_folder_ilk_#/DB/islem_yap_2.cfm" charset="utf-8">
		<cfinclude template="islem_yap_2.cfm">
		<cffile action="delete" file="#index_folder_ilk_#/DB/islem_yap_2.cfm" charset="utf-8">
	</cftransaction>
<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>
</cflock>