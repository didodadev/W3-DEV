<cfif not isDefined('attributes.password')>
	<script language="javascript">
        window.close();
    </script>
    <cfabort>
</cfif>
<cf_cryptedpassword password="#attributes.password#" output="employee_password">
<cfif attributes.user_type eq 0>
	<cfset use_standart_login = 1>
	<cfif use_active_directory eq 1>
		<cfset use_standart_login = 0>
		<cftry>
		    <cfldap action="QUERY"
			  	name="auth"
			  	attributes="#active_directory_atrr#"
			  	start="#active_directory_start#"
			  	server="#active_directory_server#"
			  	username="#active_directory_server_add##form.username#"
			  	password="#form.password#">
			<cfset isAuthenticated="yes">
			<cfcatch type="ANY">
			   <cfset isAuthenticated="no">
			   <cfset use_standart_login = 1>
			</cfcatch>
		</cftry>
	<cfelseif use_active_directory eq 2>
		<cfset isAuthenticated="yes">
		<cfset use_standart_login = 0>
		<cfif isdefined("attributes.password")>
			<cftry>
				<cfldap action="QUERY"
                    name="auth"
                    attributes="#active_directory_atrr#"
                    start="#active_directory_start#"
                    server="#active_directory_server#"
                    username="#active_directory_server_add##form.username#"
                    password="#form.password#">
				<cfset isAuthenticated="yes">
				<cfcatch type="ANY">
				    <cfset isAuthenticated="no">
				    <cfset use_standart_login = 1>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelseif use_active_directory eq 3>
		<cfset isAuthenticated="yes">
		<cfset use_standart_login = 0>
		<cfif isdefined("attributes.password")>
			<cftry>
			   <cfldap action="QUERY"
				  name="auth"
				  attributes="#active_directory_atrr#"
				  start="#active_directory_start#"
				  server="#active_directory_server#"
				  username="#active_directory_server_add##form.username#"
				  password="#form.password#">
				<cfset isAuthenticated="yes">
				<cfcatch type="ANY">
				   <cfset isAuthenticated="no">
				   <cfsavecontent variable="session.error_text"><cf_get_lang_main no="2265.Active Directory altında böyle bir kullanıcı bulunamadı."></cfsavecontent>
				   <cfset use_standart_login = 2><!--- Sadece Active Directory ile girişler sağlanacak. workcube şifresine bakmayacak. --->
				   <cfset EMPLOYEE_PASSWORD = CreateUUID()>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelse>
		<cfset use_standart_login = 1>
	</cfif>
	<cfif use_standart_login eq 1>
		<cf_cryptedpassword password="#password#" output="employee_password">
	<cfelse>
		<cfset employee_password = ''>
	</cfif>
	<cfquery name="LOGIN_CONTROL" datasource="#DSN#">
		SELECT 
			EMPLOYEE_ID,
			EMPLOYEE_USERNAME,
			EMPLOYEE_PASSWORD,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM 
			EMPLOYEES
		WHERE 
			EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#"> 
			<cfif use_standart_login eq 1>
				AND EMPLOYEE_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#employee_password#">
			</cfif>
	</cfquery>
	<cfset session_user_id = login_control.employee_id>
<cfelseif attributes.user_type eq 1>
	<cfquery name="LOGIN_CONTROL" datasource="#DSN#">
		SELECT
			COMPANY_PARTNER.PARTNER_ID
		FROM
			COMPANY_PARTNER,
			COMPANY
		WHERE
			COMPANY.MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> AND 
			COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
			COMPANY_PARTNER.COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#"> AND
			COMPANY_PARTNER.COMPANY_PARTNER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#employee_password#">
	</cfquery>
	<cfset session_user_id = login_control.partner_id>
</cfif>

<cfif isdefined("login_control.recordcount") and len(session_user_id)>
	<cfquery name="DEL_WRK_APP" datasource="#DSN#">
		DELETE FROM WRK_SESSION WHERE USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_user_id#"> AND USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.user_type#">
	</cfquery>
	<script type="text/javascript">
		<cfif isDefined('attributes.is_lightbox') and attributes.is_lightbox eq 1>
			window.parent.document.login_form.member_code.value = '<cfoutput>#attributes.member_code#</cfoutput>';
			window.parent.document.login_form.username.value = '<cfoutput>#attributes.username#</cfoutput>';
			window.parent.document.login_form.password.value = '<cfoutput>#attributes.password#</cfoutput>';

			window.parent.document.login_form.submit();
			window.close();
		<cfelseif attributes.user_type eq 0>
			window.parent.document.form_login.username.value = '<cfoutput>#attributes.username#</cfoutput>';
			window.parent.document.form_login.password.value = '<cfoutput>#attributes.password#</cfoutput>';
			window.parent.document.form_login.submit();
		<cfelse>
			window.parent.document.login_form.member_code.value = '<cfoutput>#attributes.member_code#</cfoutput>';
			window.parent.document.login_form.username.value = '<cfoutput>#attributes.username#</cfoutput>';
			window.parent.document.login_form.password.value = '<cfoutput>#attributes.password#</cfoutput>';

			window.parent.document.login_form.submit();
		</cfif>
	</script>
<cfelse>
	<script type="text/javascript">
		alert('Oturum Bulunamadı!\nSisteme Giriş Yapabilirsiniz!');
		<cfif attributes.user_type eq 0>
			window.parent.gizle_iframe2();
		</cfif>
	</script>
</cfif>
