<cfquery name="GET_IMAGE" datasource="#dsn#">
	SELECT 
		CONTIMAGE_SMALL,
		IMAGE_SERVER_ID
	FROM 
		CONTENT_IMAGE
	WHERE 
		CONTIMAGE_ID = #attributes.CNFID#
</cfquery>   
<cfif FileExists("#upload_folder#content#dir_seperator##GET_IMAGE.CONTIMAGE_SMALL#")>
	<!--- <cffile action="delete" file="#upload_folder#content#dir_seperator##GET_IMAGE.CONTIMAGE_SMALL#"> --->
	<cf_del_server_file output_file="content/#GET_IMAGE.CONTIMAGE_SMALL#" output_server="#GET_IMAGE.image_server_id#">
</cfif>
<cfquery name="DEL_IMAGE" datasource="#dsn#">
	DELETE 
	FROM
		CONTENT_IMAGE
	WHERE 
		CONTIMAGE_ID = #attributes.CNFID#
</cfquery>	
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
  		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique__content_related_images_');
	</cfif>
</script>
