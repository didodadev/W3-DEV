<cfif len(attributes.promotion_start)>
	<cf_date tarih="attributes.promotion_start">
</cfif>
<cfif len(attributes.promotion_finish)>
	<cf_date tarih="attributes.promotion_finish">
</cfif>

<cfquery name="add_rank" datasource="#DSN#">
  INSERT INTO
 	EMPLOYEES_RANK_DETAIL
	(
		EMPLOYEE_ID,
		GRADE,
		STEP,
		PROMOTION_START,
		PROMOTION_FINISH,
		PROMOTION_REASON,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
  VALUES
    (
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.grade#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.step#">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#attributes.promotion_start#">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#attributes.promotion_finish#">,
		<cfif len(attributes.promotion_reason)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.promotion_reason#"><cfelse>NULL</cfif>,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#
	)
</cfquery>
<cfif not isdefined("attributes.draggable")>
	<cflocation addtoken="no" url="#request.self#?fuseaction=#fusebox.circuit#.popup_form_add_rank&employee_id=#attributes.employee_id#">
<cfelseif isdefined("attributes.draggable")>
	<script>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</script>
</cfif>