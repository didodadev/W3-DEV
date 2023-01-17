<cfquery name="del_position_cat" datasource="#dsn#">
	DELETE FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID=#POSITION_ID#
</cfquery>
<cfquery name="del_position_cat_departments" datasource="#dsn#">
	DELETE FROM SETUP_POSITION_CAT_DEPARTMENTS WHERE POSITION_CAT_ID = #POSITION_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=hr.form_add_position_cat" addtoken="no">
