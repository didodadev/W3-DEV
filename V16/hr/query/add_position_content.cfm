<cflock timeout="20">
<cfquery name="add_position_authority" datasource="#DSN#" result="MAX_ID">
	INSERT INTO
		EMPLOYEE_AUTHORITY
	(
		AUTHORITY_HEAD,
		AUTHORITY_DETAIL,
		RECORD_DATE,
		RECORD_MEMBER 
	)
	VALUES
	(
		'#attributes.content_head#',
		'#attributes.content_topic#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
</cflock>
<cfquery name="ADD_POSITIONS_AUTHORITY" datasource="#DSN#">
	INSERT INTO 
		EMPLOYEE_POSITIONS_AUTHORITY
	(
		AUTHORITY_ID,
		<cfif isdefined("attributes.position_id")>
		POSITION_ID
		<cfelse>
		POSITION_CAT_ID
		</cfif>	
	)
	VALUES
	(
		#max_id.identitycol#,
		<cfif isdefined("attributes.position_id")>
		#attributes.position_id#
		<cfelse>
		#attributes.position_cat_id#
		</cfif>
	)
</cfquery>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
		location.reload();
	</cfif>
</script>
