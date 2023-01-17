<cfquery datasource="workcube_db_admin" name="table_list">
	SELECT 
		cols.name as name, 
		cols.colid as colid, 
		cols.id as id,
		props.value as col_description,
		types.name as type_name,
		cols.prec as type_length
	FROM 
		[#attributes.database_name#].syscolumns as cols
	LEFT JOIN
		[#attributes.database_name#].sysproperties as props
		ON
			props.id = cols.id
			and props.smallid = cols.colid
			and props.type = 4
	LEFT JOIN
		[#attributes.database_name#].systypes as types
		ON
			cols.xtype = types.xtype
			and types.xusertype = types.xtype
	WHERE 
		cols.id = #attributes.table_id#
	ORDER BY
		cols.name
</cfquery>
