<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfif isdefined("attributes.is_default")>
			<cfquery name="upd_cats" datasource="#dsn#">
				UPDATE SETUP_COMMETHOD SET IS_DEFAULT = 0
			</cfquery>
		</cfif>
		<cfquery name="UPDCOMMETHOD" datasource="#dsn#">
			UPDATE 
				SETUP_COMMETHOD 
			SET 
				COMMETHOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#COMMETHOD#">,
				IS_DEFAULT = <cfif isdefined("attributes.is_default")>1<cfelse>0</cfif>,
				UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
			WHERE 
				COMMETHOD_ID=#COMMETHOD_ID#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_com_method" addtoken="no">
