<cfquery name="DEL_SCHOOL_PART" datasource="#DSN#">
  DELETE FROM SETUP_SCHOOL_PART WHERE PART_ID = #attributes.part_id#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_school_part" addtoken="no">
