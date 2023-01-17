<cfif len(employee_password)>
	<cf_cryptedpassword password="#employee_password#" output="employee_password" mod="1">
</cfif>

<cfif len(attributes.EMPLOYEE_USERNAME)>
	<cfquery name="CHECK_USERNAME" datasource="#DSN#">
		SELECT
			EMPLOYEES.EMPLOYEE_ID
		FROM
			EMPLOYEES
		WHERE
			EMPLOYEES.EMPLOYEE_ID <> #attributes.EMPLOYEE_ID# AND
			EMPLOYEES.EMPLOYEE_USERNAME = '#EMPLOYEE_USERNAME#'
	</cfquery>

	<cfif check_username.recordcount>
		<cfoutput>
			<script type="text/javascript">
				alert("Lütfen Başka Bir Kullanıcı Adı Girin!");
				history.back();
			</script>
			<cfabort>
		</cfoutput>
	</cfif>
</cfif>
<cfquery name="UPD_EMPLOYEES" datasource="#DSN#">
	UPDATE
		EMPLOYEES
	SET
	<cfif len(EMPLOYEE_PASSWORD)>EMPLOYEE_PASSWORD = '#employee_password#',</cfif>
	<cfif len(EMPLOYEE_USERNAME)>EMPLOYEE_USERNAME = '#EMPLOYEE_USERNAME#'<cfelse>EMPLOYEE_USERNAME = NULL</cfif>
	WHERE
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
<cf_add_log  log_type="0" action_id="#attributes.EMPLOYEE_ID#" action_name="Kullanıcı Adı Şifre Güncelle :#get_emp_info(attributes.employee_id,0,0)#(#attributes.employee_id#)">

<cflocation url="#cgi.http_referer#" addtoken="No">

