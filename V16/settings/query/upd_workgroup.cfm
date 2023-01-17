<cfscript>
	position_code_non = "";

	if(isdefined("attributes.to_pos_ids_1") and len(attributes.to_pos_ids_1))
	{
		for (i=1; i lte listlen(attributes.to_pos_ids_1,','); i = i+1)
		{
		if(listfind(position_code_non, listgetat(attributes.to_pos_ids_1, i, ","), ",") eq 0)
		position_code_non= listappend(position_code_non, listgetat(attributes.to_pos_ids_1, i, ","), ",");
		}
	}
</cfscript>
<cfquery name="DEL_CAU" datasource="#DSN#">
	DELETE FROM PROCESS_TYPE_ROWS_CAUID WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
</cfquery>
<cfquery name="DEL_INF" datasource="#DSN#">
	DELETE FROM PROCESS_TYPE_ROWS_INFID WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
</cfquery>
<cfquery name="DEL_INF" datasource="#DSN#">
	DELETE FROM PROCESS_TYPE_ROWS_POSID WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
</cfquery>
<cfquery name="ADD_PROCESS_TYPE_WORKGROUP" datasource="#DSN#">
	UPDATE
		PROCESS_TYPE_ROWS_WORKGRUOP
	SET
		WORKGROUP_NAME = '#attributes.grup_isim#'
	WHERE
		WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
</cfquery>
<cfif isdefined("attributes.to_pos_ids") and len(attributes.to_pos_ids)>
	<cfloop from="1" to="#listlen(attributes.to_pos_ids, ',')#" index="i">
		<cfquery name="ADD_PRO_POSITIONS" datasource="#DSN#">
			INSERT
				INTO
				PROCESS_TYPE_ROWS_POSID
				(
					WORKGROUP_ID,
					PRO_POSITION_ID
				)
				VALUES
				(
					#attributes.workgroup_id#,
					#listgetat(attributes.to_pos_ids, i, ',')#
				)
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined("attributes.cc_pos_ids") and len(attributes.cc_pos_ids)>
	<cfloop from="1" to="#listlen(attributes.cc_pos_ids, ',')#" index="i">
		<cfquery name="ADD_INF_POSITIONS" datasource="#DSN#">
			INSERT
				INTO
				PROCESS_TYPE_ROWS_INFID
				(
					WORKGROUP_ID,
					INF_POSITION_ID
				)
				VALUES
				(
					#attributes.workgroup_id#,
					#listgetat(attributes.cc_pos_ids, i, ',')#
				)
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined("attributes.to_pos_ids_1") and len(attributes.to_pos_ids_1)>
	<cfloop from="1" to="#listlen(position_code_non, ',')#" index="i">
		<cfquery name="ADD_CAU_POSITIONS" datasource="#DSN#">
			INSERT
			INTO
				PROCESS_TYPE_ROWS_CAUID
				(
					WORKGROUP_ID,
					CAU_POSITION_ID
				)
				VALUES
				(
					#attributes.workgroup_id#,
					#listgetat(position_code_non, i, ',')#
				)
		</cfquery>
	</cfloop>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
