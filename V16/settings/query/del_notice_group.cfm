<cfquery name="DEL_NOTICE_GROUP" datasource="#DSN#">
  DELETE FROM SETUP_NOTICE_GROUP WHERE NOTICE_CAT_ID = #attributes.notice_cat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_notice_type" addtoken="no">

