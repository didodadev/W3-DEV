<cftransaction>
<cfquery name="GET_CARE_NAME" datasource="#DSN3#">
	SELECT
		*
	FROM
		SERVICE_CARE_CAT
</cfquery>
<cfloop query="get_care_name">
	<cfset care_value = 'attributes.care_id'&currentrow>
	<cfif isdefined("#care_value#")>
	<cfset value = evaluate(care_value)>
 	<cfquery name="ADD_CARE_VAR_NAME" datasource="#DSN3#">
		INSERT
		INTO
			#dsn_alias#.CARE_STATES
		(
			CARE_TYPE_ID,
			SERVICE_ID,
			CARE_STATE_ID,
			IS_ACTIVE
		)
		VALUES
		(
			3,
			#attributes.id#,
			#VALUE#,
			1
		)
	</cfquery>
	</cfif>
	<script type="text/javascript">
/* 		wrk_opener_reload();
 */		<cfif not isdefined("attributes.draggable")>
			window.close();
		<cfelse>
			closeBoxDraggable( '<cfoutput>#attributes.care_id#</cfoutput>' );
		</cfif>
		window.location.href="<cfoutput>#request.self#?fuseaction=service.list_care&event=upd&id=#attributes.id#</cfoutput>";
	</script>
</cfloop>


