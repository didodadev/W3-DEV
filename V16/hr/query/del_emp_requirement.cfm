<cf_box scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
  <cfquery name="DEL_EMP_REQ" datasource="#DSN#">
    DELETE FROM EMPLOYEE_REQUIREMENTS WHERE REQ_ID = #URL.REQ_ID#
  </cfquery>
</cf_box>

<script type="text/javascript">
  /* wrk_opener_reload(); */
  <cfif not isdefined("attributes.draggable")>
			window.close();
		<cfelseif isdefined("attributes.draggable")>
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
			closeBoxDraggable( 'req_box' );
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_upd_emp_requirement&employee_id=#attributes.employee_id#</cfoutput>','req_box');
	</cfif>
</script>
