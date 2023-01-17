<cfquery name="DEL_WORKGROUP_TYPE" datasource="#DSN#">
  DELETE FROM SETUP_WORKGROUP_TYPE WHERE WORKGROUP_TYPE_ID = #URL.WORKGROUP_TYPE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_workgroup_type" addtoken="no">

