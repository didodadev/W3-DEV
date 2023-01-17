<cfif not IsDefined("dsn")>
	
	<cftransaction>
		<cf_add_dsn_mssql dsn="master" db="master" host="#attributes.db_host#" port="#attributes.db_port#" username="#attributes.db_username#" password="#attributes.db_password#">
		<cfquery name="CREATE_MAIN_DB" datasource="master">
			CREATE DATABASE [#attributes.datasource#]  
			ON 
				(NAME = N'#attributes.datasource#_Data', FILENAME = N'#attributes.db_folder##attributes.datasource#.mdf', SIZE = 5, FILEGROWTH = 524288KB) 
			LOG ON 
				(NAME = N'#attributes.datasource#_Log', FILENAME = N'#attributes.db_log_folder##attributes.datasource#_log.ldf', SIZE = 56, FILEGROWTH = 262144KB)
			
				COLLATE Turkish_CI_AS
		</cfquery>
	</cftransaction>
	<cfset newDsn = attributes.datasource />
	
<cfelse>
	<cfset newDsn = dsn>
</cfif>

<cfset cf_admin_password = attributes.cf_admin_password />
<cf_add_dsn_mssql dsn="_#attributes.datasource#" db="#newDsn#" host="#attributes.db_host#" port="#attributes.db_port#" username="#attributes.db_username#" password="#attributes.db_password#">

<cftransaction>
	<cfquery name="addLogin" datasource="_#attributes.datasource#">
		CREATE LOGIN #attributes.datasource# WITH PASSWORD = '#attributes.db_password#' 
		CREATE LOGIN #attributes.datasource#_product WITH PASSWORD = '#attributes.db_password#' 
	</cfquery>

	<cfquery name="addSchema" datasource="_#attributes.datasource#">
		CREATE SCHEMA #attributes.datasource# 
	</cfquery>

	<cfquery name="addSchema" datasource="_#attributes.datasource#">
		CREATE SCHEMA #attributes.datasource#_product
	</cfquery>

	<cfquery name="addUser" datasource="_#attributes.datasource#">
		CREATE USER [#attributes.datasource#] FOR LOGIN [#attributes.datasource#] WITH DEFAULT_SCHEMA=[#attributes.datasource#]
		ALTER ROLE [db_owner] ADD MEMBER [#attributes.datasource#]
		
		CREATE USER [#attributes.datasource#_product] FOR LOGIN [#attributes.datasource#_product] WITH DEFAULT_SCHEMA=[#attributes.datasource#_product]
		ALTER ROLE [db_owner] ADD MEMBER [#attributes.datasource#_product]
	</cfquery>
	<cf_add_dsn_mssql dsn="#attributes.datasource#" db="#newDsn#" host="#attributes.db_host#" username="#attributes.datasource#" password="#attributes.db_password#">
	<cf_add_dsn_mssql dsn="#attributes.datasource#_product" db="#newDsn#" host="#attributes.db_host#" username="#attributes.datasource#_product" password="#attributes.db_password#">
</cftransaction>