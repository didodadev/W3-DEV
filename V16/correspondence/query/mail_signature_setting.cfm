<cfif isdefined("standart_signature")>
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE CUBE_MAIL_SIGNATURE SET STANDART_SIGNATURE = 0 WHERE EMPLOYEE_ID = #attributes.employee_id#
	</cfquery>
</cfif>
<cfquery name="add_signature" datasource="#dsn#">
	INSERT INTO
 		CUBE_MAIL_SIGNATURE
		(
			EMPLOYEE_ID,
			SIGNATURE_NAME,
			SIGNATURE_DETAIL,
			STANDART_SIGNATURE
		)
		VALUES
		(
		#attributes.employee_id#,
		'#attributes.name#',
		'#attributes.detail#',
		<cfif isdefined("standart_signature")>1<cfelse>0</cfif>
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=correspondence.list_mymails&employee_id=#attributes.employee_id#" addtoken="no">
