<cfquery name="upd_hobim" datasource="#attributes.data_source#">
	UPDATE #caller.dsn2_alias#.FILE_EXPORTS SET IS_IPTAL = 1 WHERE E_ID = #attributes.action_id#
</cfquery>
