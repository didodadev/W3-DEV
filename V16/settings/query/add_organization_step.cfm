<cfif attributes.edit_no eq 1>
	<cfif isdefined ("attributes.organization_step_no") and len (attributes.organization_step_no)>
	<!--- eğer kademelerini düzenle dediyse numaraları eşit ve üstündeki numaraları bir artırıyor--->
		<cfquery name="upd_org_step" datasource="#dsn#">
			UPDATE 
            	SETUP_ORGANIZATION_STEPS
			SET
				ORGANIZATION_STEP_NO=ORGANIZATION_STEP_NO+1
			WHERE
				ORGANIZATION_STEP_NO >= #attributes.organization_step_no#
		</cfquery>
	</cfif>
</cfif>
<cfquery name="ADD_ORGANIZATION_STEP" datasource="#DSN#">
	INSERT INTO 
		SETUP_ORGANIZATION_STEPS
	(
		ORGANIZATION_STEP_NAME,
		ORGANIZATION_STEP_NO,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP,
		ORG_DSP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_step_name#">,
		<cfif len(attributes.organization_step_no)>#attributes.organization_step_no#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.detail") and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#,
		<cfif isdefined("attributes.organisation_disp")>1<cfelse>0</cfif>
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_organization_step" addtoken="no">
