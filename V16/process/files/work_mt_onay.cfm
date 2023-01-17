<!--- FA isin msteri onayindan gectikten sonra zaman harcamasinda is_valid=1 yapar.  --->
<cfquery name="upd_time_valid" datasource="#attributes.data_source#">
	UPDATE #caller.dsn_alias#.TIME_COST SET IS_VALID = 1 WHERE WORK_ID = #attributes.action_id#
</cfquery>
