<cfquery datasource="#attributes.datasource_name#" name="table_list">
	SELECT 
		sysobjects.id as id,
		sysobjects.name as name,
		sysobjects.xtype,
		sysobjects.crdate,
		sysusers.name as owner_name
	FROM 
		[#attributes.database_name#].sysobjects sysobjects,
		[#attributes.database_name#].sysusers sysusers
	WHERE 
		sysobjects.XTYPE IN ('U','S')
		AND sysusers.uid = sysobjects.uid
	ORDER BY 
		sysobjects.NAME
</cfquery>
