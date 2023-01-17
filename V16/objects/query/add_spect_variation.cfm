<cfoutput>
<cftransaction>
<cfquery name="GET_SPECT_NAME" datasource="#DSN3#">
	SELECT
		*
	FROM
		SPECT_TYPE
</cfquery>
<cfloop query="get_spect_name">
	<cfset spect_value = 'attributes.spect_name_type_id'&currentrow>
	<cfif isdefined("#spect_value#")>
	<cfset value = evaluate(spect_value)>
 	<cfquery name="ADD_SPECT_VAR_NAME" datasource="#DSN3#">
		INSERT INTO
			SPECT_VARIATION_TYPE
		(
			SPECT_VAR_ID,
			SPECT_ID
		)
		VALUES
		(
			#attributes.ID#,
			#VALUE#
		)
	</cfquery>
	</cfif>
</cfloop>
</cftransaction>
</cfoutput>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
