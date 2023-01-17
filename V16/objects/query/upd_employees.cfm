<cfif len(employee_password)>
	<cf_cryptedpassword password="#employee_password#" output="employee_password" mod="1">
</cfif>

<cfif len(attributes.employee_password) and len(attributes.EMPLOYEE_USERNAME)>
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
<cfquery name="upd_employees" datasource="#dsn#">
	UPDATE
		EMPLOYEES
	SET
		<cfif len(EMPLOYEE_USERNAME)>EMPLOYEE_USERNAME = '#EMPLOYEE_USERNAME#',<cfelse>EMPLOYEE_USERNAME = NULL,</cfif>
		<cfif len(EMPLOYEE_PASSWORD)>EMPLOYEE_PASSWORD = '#employee_password#'</cfif>
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
