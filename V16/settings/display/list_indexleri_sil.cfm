<!---<cflock name="#CREATEUUID()#">
<cftransaction>
<cfquery name="drop_index_eski_sec" datasource="#dsn#">
SELECT 
	sysobjects.NAME + '.'+sysindexes.NAME AS DROP_NAME
FROM        
 	sysobjects,
 	sysindexes
WHERE     
 sysobjects.id = sysindexes.id AND
 (sysobjects.xtype = 'U') AND
 (sysindexes.name LIKE 'IX_%')
ORDER BY 
 sysobjects.NAME,sysindexes.NAME
</cfquery>
<cfoutput query="drop_index_eski_sec">
	#DROP_NAME#
	<cfquery name="drop_index_eski_sil" datasource="#dsn#">
		DROP INDEX #DROP_NAME#
	</cfquery>
</cfoutput>
</cflock></cftransaction>--->
