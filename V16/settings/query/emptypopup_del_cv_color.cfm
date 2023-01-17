<cfquery name="get_cv_status" datasource="#dsn#">
	SELECT ICON_NAME FROM SETUP_CV_STATUS WHERE STATUS_ID = #attributes.file_status_id#
</cfquery>
<cfset icon = get_cv_status.icon_name>
<cftry>
	<cffile action="DELETE" file="#upload_folder#hr#dir_seperator#cv_image#dir_seperator##icon#">
	<cfcatch type="Any">
		<cfoutput>#get_cv_status.icon_name# => Dosya bulunamadı  ! <br/></cfoutput>
	</cfcatch>
</cftry><!---silinen kayda ait folderdaki img da silinir. --->
<cfquery name="DELFORMAT" datasource="#dsn#">
	DELETE FROM SETUP_CV_STATUS WHERE STATUS_ID=#attributes.file_status_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_cv_color_format" addtoken="no">
