<!--- Database erisim haklarinin set edilmesi --->
<cfif isdefined("attributes.is_add") and attributes.is_add is 1>
	<cfquery datasource="#attributes.datasource_name#" name="add_login">
		sp_addlogin '#attributes.db_user_name#', '#attributes.db_user_password#'<cfif attributes.database_name NEQ "">, '#attributes.database_name#'</cfif>
	</cfquery>	
</cfif>
<cfif isdefined("attributes.is_add") or isdefined("attributes.is_update") or isdefined("attributes.is_delete")>
	<!--- Database'e erisim verilmesi --->
	<cfif isdefined("attributes.db_access")>
		<cfloop list="#attributes.db_access#" index="i">
			<cfquery datasource="#attributes.datasource_name#" name="check_user">
				select name from [#i#].sysusers where name = '#attributes.db_user_name#' and isaliased = 0
			</cfquery>
			<cfif check_user.recordcount is 0>
				<cfquery datasource="#attributes.datasource_name#" name="give_access">
					[#i#].sp_grantdbaccess N'#attributes.db_user_name#', N'#attributes.db_user_name#'
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<cfquery datasource="#attributes.datasource_name#" name="all_database_list">
		SELECT DBID, NAME FROM [master].sysdatabases ORDER BY NAME
	</cfquery>
	<cfquery dbtype="query" name="database_list">
		SELECT NAME FROM all_database_list
	</cfquery>
	<!--- Database'den izinleri kaldirma islemleri --->
	<cfloop query="database_list">
		<cfquery datasource="#attributes.datasource_name#" name="check_user">
			select name from [#NAME#].sysusers where name = '#attributes.db_user_name#' and isaliased = 0
		</cfquery>
		<cfif isdefined("attributes.db_access")>
			<cfif check_user.recordcount is 1 and FindNoCase(NAME,attributes.db_access) is 0>
				<cfquery datasource="#attributes.datasource_name#" name="give_access">
					[#NAME#].sp_revokedbaccess N'#attributes.db_user_name#'
				</cfquery>
			</cfif>
		<cfelse>
			<cfif check_user.recordcount is 1>
				<cfquery datasource="#attributes.datasource_name#" name="give_access">
					[#NAME#].sp_revokedbaccess N'#attributes.db_user_name#'
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<cfif isdefined("attributes.is_update") and attributes.is_update is 1>
	<!--- default database set edilmesi --->
	<cfquery datasource="#attributes.datasource_name#" name="update_login">
		sp_defaultdb N'#attributes.db_user_name#', N'#attributes.database_name#'
	</cfquery>
	<!--- password set edilmesi --->
	<cfif attributes.db_user_password neq "xxxxxxxxxxxxxxxx">
		<cfquery datasource="#attributes.datasource_name#" name="update_login_pass">
			sp_password NULL, N'#attributes.db_user_password#', N'#attributes.db_user_name#'
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined("attributes.is_delete") and attributes.is_delete is 1>
	<!--- login silinmesi --->
	<cftry>
	<cfquery datasource="#attributes.datasource_name#" name="update_login">
		sp_droplogin N'#attributes.db_user_name#'
	</cfquery>
	<cfcatch type="database">
		<center><font color="#FF0000"><cf_get_lang no='2646.Silmek istediğiniz kullanıcın bir veya daha fazla veritabanında erişim hakları mevcut. Lütfen önce bu hakları kaldırıp kullanıcıyı öyle silmeyi deneyiniz.'></font></center>
		<cfset attributes.login_name = #attributes.db_user_name#>
	</cfcatch>
	</cftry>
</cfif>
<!--- login detaylari --->
<cfquery datasource="#attributes.datasource_name#" name="login_details">
	SELECT 
		dbid
	FROM 
		[master].sysxlogins
	WHERE 
		name='#attributes.login_name#'
</cfquery>
