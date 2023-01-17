<cfif isdefined("attributes.REQ_TYPE_ID")>
   <cfquery name="control" datasource="#dsn#">
    	SELECT * FROM EMPLOYEE_REQUIREMENTS WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# 
   </cfquery>
	<cfif control.recordcount>
		<cfquery name="DEL_ALL" datasource="#DSN#">
			DELETE FROM EMPLOYEE_REQUIREMENTS WHERE REQ_TYPE_ID IN(#attributes.REQ_TYPE_ID#) AND EMPLOYEE_ID = #attributes.EMPLOYEE_ID# 
		</cfquery>
    </cfif>  
    <cfset COUNTER = 1>
	<cfloop list="#attributes.REQ_TYPE_ID#" index="i">
	  <cfif isDefined("FORM.COEFFICIENT") and len(FORM.COEFFICIENT)>
	    <cfset COEFFICIENT_ = LISTGETAT(FORM.COEFFICIENT,COUNTER)>
	  </cfif>
	  <cfquery name="add_req" datasource="#dsn#">
	    INSERT INTO 
		  EMPLOYEE_REQUIREMENTS
		  (
		    EMPLOYEE_ID,
			REQ_TYPE_ID
		  <cfif isDefined("COEFFICIENT_") and len(COEFFICIENT_)>
		    ,COEFFICIENT
		  </cfif>
		  )
		  VALUES
		  (
		   #attributes.EMPLOYEE_ID#,
		   #i#
		  <cfif isDefined("COEFFICIENT_") and len(COEFFICIENT_)>
		    ,#COEFFICIENT_#
		  </cfif>
		  )
	  </cfquery>
	  <cfset COUNTER = COUNTER + 1>
	</cfloop>
</cfif>
 

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
			wrk_opener_reload();
			window.close();
		<cfelseif isdefined("attributes.draggable")>
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
			closeBoxDraggable( 'req_box' );
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_upd_emp_requirement&employee_id=#attributes.employee_id#</cfoutput>','req_box');
	</cfif>
</script>
