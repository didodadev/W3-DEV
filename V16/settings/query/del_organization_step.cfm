<cfquery name="DEL_ORGANIZATION_STEP" datasource="#DSN#">
  DELETE FROM SETUP_ORGANIZATION_STEPS WHERE ORGANIZATION_STEP_ID = #URL.ORGANIZATION_STEP_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_organization_step" addtoken="no">

