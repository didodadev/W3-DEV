<cfif attributes.operation eq 'upd'>
<cfif isdefined("standart_signature")>
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE CUBE_MAIL_SIGNATURE SET STANDART_SIGNATURE = 0 WHERE EMPLOYEE_ID = #attributes.employee_id#
	</cfquery>
</cfif>
<cfquery name="upd_emp_mail_signature" datasource="#DSN#">  
	UPDATE 
		CUBE_MAIL_SIGNATURE
	SET	
		EMPLOYEE_ID=#attributes.employee_id#,
		SIGNATURE_NAME='#attributes.name#',
		SIGNATURE_DETAIL='#attributes.detail#',
		STANDART_SIGNATURE = <cfif isdefined("standart_signature")>1<cfelse>0</cfif>
	WHERE 
		SIGNATURE_ID=#attributes.signature_id#
</cfquery>
<cfelseif attributes.operation eq 'del'>
		<cfquery name="del_emp_mail_signature" datasource="#DSN#">  
		  DELETE FROM
			CUBE_MAIL_SIGNATURE
		  WHERE
			SIGNATURE_ID = #attributes.signature_id# AND EMPLOYEE_ID=#attributes.employee_id#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=correspondence.list_mymails&employee_id=#attributes.employee_id#" addtoken="no">
