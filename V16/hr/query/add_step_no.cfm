<cfif attributes.type eq 0 >
	<cfquery name="ADD_LINE_PLUS" datasource="#dsn#">
		UPDATE 
			EMPLOYEE_CAREER 
		SET
			STEP_NO = #attributes.step_no+1#
		WHERE 
			POSITION_CAT_ID = #attributes.pcat_id# AND
			STEP_NO = #attributes.step_no# AND
			RELATED_POS_CAT_ID = #attributes.rel_pos_id# AND
			STATE=<cfif attributes.is_ust eq 1>1<cfelse>0</cfif>
	</cfquery>
	<cfquery name="ADD_LINE_DESC" datasource="#dsn#">
		UPDATE 
			EMPLOYEE_CAREER  
		SET
			STEP_NO = #attributes.step_no#
		WHERE 
			POSITION_CAT_ID = #attributes.pcat_id# AND
			STEP_NO  = #attributes.step_no+1# AND
			RELATED_POS_CAT_ID <> #attributes.rel_pos_id# AND
			STATE=<cfif attributes.is_ust eq 1>1<cfelse>0</cfif>
	</cfquery>
</cfif>
<cfif attributes.type eq 1>
	<cfquery name="ADD_LINE_PLUS" datasource="#dsn#">
		UPDATE 
			EMPLOYEE_CAREER  
		SET
			STEP_NO = #attributes.step_no-1#
		WHERE 
			POSITION_CAT_ID = #attributes.pcat_id# AND
			STEP_NO = #attributes.step_no# AND
			RELATED_POS_CAT_ID = #attributes.rel_pos_id# AND
			STATE=<cfif attributes.is_ust eq 1>1<cfelse>0</cfif>
			
	</cfquery>
	<cfquery name="ADD_LINE_MINUS" datasource="#dsn#">
		UPDATE 
			EMPLOYEE_CAREER 
		SET
			STEP_NO = #attributes.step_no#
		WHERE 
			POSITION_CAT_ID = #attributes.pcat_id# AND
			STEP_NO = #attributes.step_no-1# AND
			RELATED_POS_CAT_ID <> #attributes.rel_pos_id# AND
			STATE=<cfif attributes.is_ust eq 1>1<cfelse>0</cfif>
	</cfquery>
</cfif>
<cfif isDefined('attributes.modal_id')>
	<script>
		<cfoutput>
			openBoxDraggable('#request.self#?fuseaction=hr.popup_add_employee_career&position_cat_id=#attributes.pcat_id#','#attributes.modal_id#');
		</cfoutput>
	</script>
<cfelse>

	<cflocation url="#request.self#?fuseaction=hr.popup_add_employee_career&position_cat_id=#attributes.pcat_id#" addtoken="no">

</cfif>