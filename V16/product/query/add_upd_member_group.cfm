<cfquery name="del_emp_par" datasource="#dsn3#">
	DELETE FROM PRODUCTGROUP_EMP_PAR WHERE PRODUCT_ID = #attributes.pid#
</cfquery>
<cfloop from="1" to="10" index="x">
	<cfif Len(Evaluate("attributes.member_name#x#")) and (len(Evaluate("attributes.position_code#x#")) or len(Evaluate("attributes.partner_id#x#")))>
		<cfquery name="add_emp_par" datasource="#dsn3#">
			INSERT INTO
				PRODUCTGROUP_EMP_PAR
			(
				PRODUCT_ID,
				ROLE_ID,
				POSITION_CODE,
				PARTNER_ID
			)
			VALUES
			(
				#attributes.pid#,
				<cfif len(Evaluate("attributes.role_id#x#"))>#Evaluate("attributes.role_id#x#")#<cfelse>NULL</cfif>,
				<cfif len(Evaluate("attributes.position_code#x#")) and len(Evaluate("attributes.member_name#x#"))>#Evaluate("attributes.position_code#x#")#<cfelse>NULL</cfif>,
				<cfif len(Evaluate("attributes.partner_id#x#")) and len(Evaluate("attributes.member_name#x#"))>#Evaluate("attributes.partner_id#x#")#<cfelse>NULL</cfif>
			)
		</cfquery>
	</cfif>
</cfloop>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique__product_team_');
	</cfif>
</script>
