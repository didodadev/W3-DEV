<cfif len(form.plus_date)>
	<cf_date tarih="attributes.plus_date">
</cfif>
<cfswitch expression="#FORM.PLUS_TYPE#">
	<cfcase value="ORDER">
		<cfquery name="UPD_ORDER_PLUS" datasource="#dsn3#">
			UPDATE 
				ORDER_PLUS 
			SET
				PLUS_DATE = <cfif len(attributes.plus_date)>'#attributes.plus_date#'<cfelse>NULL</cfif>,
				COMMETHOD_ID = #FORM.COMMETHOD_ID#,
				EMPLOYEE_ID = <cfif Len(FORM.EMPLOYEE_ID)>#SESSION.EP.USERID#<cfelse>#FORM.EMPLOYEE_ID#</cfif>,
				PLUS_CONTENT = '#FORM.PLUS_CONTENT#',
				UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#REMOTE_ADDR#'
			WHERE
				ORDER_PLUS_ID = #FORM.PLUS_ID#					  	
		</cfquery>
	</cfcase>
	<cfcase value="offer">
		<cfquery name="UPD_OFFER_PLUS" datasource="#dsn3#">
			UPDATE 
				OFFER_PLUS 
			SET 
				PLUS_DATE = <cfif len(form.plus_date)>#attributes.plus_date#<cfelse>NULL</cfif>,
				COMMETHOD_ID = <cfif FORM.COMMETHOD_ID IS "0">17<cfelse>#FORM.COMMETHOD_ID#</cfif>,	
				EMPLOYEE_ID = #FORM.EMPLOYEE_ID#,
				SUBJECT = <cfif len(form.header)>'#form.header#'<cfelse>NULL</cfif>,
				PLUS_CONTENT = '#FORM.PLUS_CONTENT#',
				UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#REMOTE_ADDR#'
			WHERE 
				OFFER_PLUS_ID = #FORM.PLUS_ID#					  	
		</cfquery>
	</cfcase>
</cfswitch>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
