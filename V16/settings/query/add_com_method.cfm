 <cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfif isdefined("attributes.is_default")>
			<cfquery name="upd_cats" datasource="#dsn#">
				UPDATE SETUP_COMMETHOD SET IS_DEFAULT = 0
			</cfquery>
		</cfif>
		<cfquery name="INSCOMMETHOD" datasource="#dsn#">
			INSERT INTO 
				SETUP_COMMETHOD
				(
					COMMETHOD,
					IS_DEFAULT,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				) 
				VALUES 
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#COMMETHOD#">,
					<cfif isdefined("attributes.IS_DEFAULT")>1<cfelse>0</cfif>,
					#NOW()#,
					#SESSION.EP.USERID#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
				)
		</cfquery>
	
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_com_method" addtoken="no">








