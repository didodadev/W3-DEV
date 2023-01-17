<cfquery name="GET_CLASS_TRAINING_REQUEST_ROWS" datasource="#dsn#">
	SELECT CLASS_ID,EMPLOYEE_ID FROM TRAINING_REQUEST_ROWS WHERE CLASS_ID = #attributes.class_id# AND EMPLOYEE_ID = #session.ep.userid#
</cfquery>

	<cfif not get_class_training_request_rows.recordcount>
	<cfform name="inspection_class" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_class_join_request&class_id=#url.class_id#&is_class_detail_form=1" method="post">
		<cfinput type="hidden" name="emp_id" value="#session.ep.userid#">
		<cf_workcube_buttons is_upd='0'> 
	</cfform>
	<cfelse>
		<p>Bu eğitim için talepte bulundunuz!</p>
	</cfif>
	

