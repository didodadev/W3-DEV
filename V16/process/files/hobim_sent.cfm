<cfquery name="upd_hobim" datasource="#attributes.data_source#">
	UPDATE #caller.dsn2_alias#.FILE_EXPORTS SET IS_SENT = 1, IS_IPTAL = 0,IS_PRINTED = 0 WHERE E_ID = #attributes.action_id#
</cfquery>
