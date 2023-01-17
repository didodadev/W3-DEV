<cfif DATABASE_TYPE IS "MSSQL">
	<cfquery name="GET_LANGUAGE_DB" datasource="#DSN#">
		SELECT * FROM 	sysobjects 
		WHERE id = object_id(N'[#NEW_DB_NAME#]') and OBJECTPROPERTY(id, N'IsUserTable') = 1
	</cfquery>
	<cfif NOT GET_LANGUAGE_DB.RECORDCOUNT>
		<cfquery name="ADD_LANGUAGE_DB" datasource="#DSN#">
			CREATE TABLE [#NEW_DB_NAME#] (
				[ITEM_ID] [int] NULL ,
				[MODULE_ID] [nvarchar] (50) COLLATE Turkish_CI_AS NULL ,
				[ITEM] [nvarchar] (500) COLLATE Turkish_CI_AS NULL 
			) ON [PRIMARY]
		</cfquery>
	</cfif>
<cfelseif DATABASE_TYPE IS "DB2">
	<cfquery name="GET_LANGUAGE_DB" datasource="#DSN#">
		SELECT TBNAME FROM SYSIBM.SYSCOLUMNS WHERE TBNAME='#NEW_DB_NAME#'
	</cfquery>
	<cfif NOT GET_LANGUAGE_DB.RECORDCOUNT>
		<cfquery name="ADD_LANGUAGE_DB" datasource="#DSN#">
			CREATE TABLE #NEW_DB_NAME# (
				ITEM_ID INTEGER ,
				MODULE_ID VARGRAPHIC (50) ,
				ITEM VARGRAPHIC (500)  
			) 
		</cfquery>
	</cfif>
</cfif>
