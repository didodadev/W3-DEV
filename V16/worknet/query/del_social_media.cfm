<cfquery name="del_social_media" datasource="#dsn#">
	DELETE FROM SOCIAL_MEDIA_REPORT WHERE SID = #attributes.sid#
</cfquery>
<cflocation url="#request.self#?fuseaction=worknet.list_social_media">

				
