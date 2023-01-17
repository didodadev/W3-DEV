<cf_del_server_file output_file="content/banner/#attributes.banner_file#" output_server="#attributes.banner_file_server_id#">
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="add_banner" datasource="#dsn#">
			DELETE 
			FROM
				CONTENT_BANNERS
			WHERE 
				BANNER_ID   = #attributes.banner_id#
		</cfquery>
		<cfquery name="add_banner" datasource="#dsn#">
			DELETE 
			FROM
				CONTENT_BANNERS_USERS
			WHERE 
				BANNER_ID   = #attributes.banner_id#
		</cfquery>
	 <cf_add_log  log_type="-1" action_id="#attributes.banner_id#" action_name="#attributes.head#">
	</cftransaction>
</cflock> 
<cflocation url="#request.self#?fuseaction=content.list_banners" addtoken="no">
