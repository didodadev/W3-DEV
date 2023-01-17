			<cfquery name="ADD_TEMPLATES" datasource="#DSN#">
				INSERT INTO 
						EMPLOYEE_ACCIDENT_SECURITY
					(
					ACCIDENT_SECURITY,
					ACCIDENT_DETAIL
					)
					VALUES
					(
					'#attributes.ACCIDENT_SECURITY#',
					'#attributes.ACCIDENT_DETAIL#'
					)				
			</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=ehesap.form_add_accident_security">
