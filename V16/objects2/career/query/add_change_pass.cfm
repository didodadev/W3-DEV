<cfif isdefined("attributes.username")>
	<cf_cryptedpassword password="#attributes.old_password#" output="sifre">
	<cfquery name="get_user" datasource="#dsn#">
		SELECT
			EMPAPP_ID,
			NAME
		FROM
			EMPLOYEES_APP
		WHERE
			EMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.username#"> <!--- AND
			EMPAPP_PASSWORD='#sifre#' --->
	</cfquery>
	<cfif get_user.recordcount>
		<cfif isdefined("attributes.new_username") and len(attributes.new_username)>
			<cfquery name="GET_MAIL" datasource="#dsn#">
				SELECT EMAIL FROM EMPLOYEES_APP WHERE EMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.new_username#"> AND EMPAPP_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_user.empapp_id#">
			</cfquery>
			<cfif get_mail.recordcount>
				<script type="text/javascript">
					{
						alert("<cf_get_lang no ='1486.Mail Adresine Sahip Kullanıcı Sisteme Kayıtlı'>!");
						history.go(-1);
					}
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfif attributes.new_password eq attributes.new_password2>
			<cf_cryptedpassword password="#attributes.new_password#" output="yeni_sifre">
			<cfquery name="upd_pass" datasource="#dsn#">
				UPDATE 
					EMPLOYEES_APP 
				SET
					NAME = '#get_user.name#'
					<cfif isdefined("attributes.new_password") and len(attributes.new_password)>,EMPAPP_PASSWORD='#yeni_sifre#'</cfif>
					<cfif isdefined("attributes.new_username") and len(attributes.new_username)>
					,EMAIL = '#attributes.new_username#'
					</cfif>
				WHERE
					EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_user.empapp_id#">
			</cfquery>
			<cflocation url="#request.self#?fuseaction=objects2.welcome" addtoken="no">
		<cfelse>
			<cfsavecontent variable="session.error_text"><cf_get_lang no ='1484.Yeni Şifre ve Yeni Şifre Tekrar Alanlarını Kontrol Ediniz'>.</cfsavecontent>
			<cflocation url="#request.self#?fuseaction=objects2.change_pass" addtoken="no">
		</cfif>
	<cfelse>
		<cfsavecontent variable="session.error_text"><cf_get_lang no ='1485.Girdiğiniz E-posta Adresi Veya Şifreniz Hatalı, Tekrar Kontrol Ediniz'>.</cfsavecontent>
		<cflocation url="#request.self#?fuseaction=objects2.change_pass" addtoken="no">
	</cfif>
<cfelse>
<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>
