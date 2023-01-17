<cfif attributes.edit_no eq 1>
	<cfif isdefined ("attributes.organization_step_no") and len (attributes.organization_step_no)>
		<!--- Eger kademelerini düzenle dediyse numaraları eşit ve üstündeki numaraları bir artırıyor--->
        <cfquery name="upd_org_step" datasource="#DSN#">
            UPDATE 
                SETUP_ORGANIZATION_STEPS
            SET
                ORGANIZATION_STEP_NO = ORGANIZATION_STEP_NO+1
            WHERE
                ORGANIZATION_STEP_NO >= #attributes.organization_step_no#
                AND ORGANIZATION_STEP_ID <> #attributes.organization_step_id#
        </cfquery>
	</cfif>
</cfif>
<cfquery name="UPD_ORGANIZATION_STEP" datasource="#DSN#">
	UPDATE 
		SETUP_ORGANIZATION_STEPS 
	SET 
		ORGANIZATION_STEP_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_step_name#">,
		ORGANIZATION_STEP_NO = <cfif len(attributes.organization_step_no)>#attributes.organization_step_no#<cfelse>NULL</cfif>,
		DETAIL = <cfif isdefined("attributes.detail") and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		ORG_DSP = <cfif isdefined("attributes.organisation_disp")>1<cfelse>0</cfif>
	WHERE 
		ORGANIZATION_STEP_ID = #attributes.organization_step_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_organization_step&organization_step_id=#attributes.organization_step_id#" addtoken="no">
