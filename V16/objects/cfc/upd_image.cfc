<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset DSN1 = '#application.systemParam.systemParam().dsn#_product'>

    <cffunction  name="UPD_UNIT" access="remote" returntype="any">
            <cfargument  name="is_internet" default="">
            <cfargument  name="image_action_id" default="">
            <cfargument  name="size" default="">
            <cfargument  name="image_type" default="">
            <cfargument  name="stock_id" default="">
            <cfargument name="language_id" default="">
            <cfargument name="image_url_link" default="">
            <cfargument name="identity_column" default="">
            <cfargument name="file_name" default="">
            <cfargument name="is_stock_picture" default="">
        <cfquery name="UPD_UNIT" datasource="#DSN1#">

			UPDATE 
				#table# 
			SET 
				PATH_SERVER_ID =<cfif isDefined("form.image_file") and len(form.image_file)><cfqueryparam value="#arguments.server_machine#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
				PATH = <cfif isDefined("form.image_file") and len(form.image_file )><cfqueryparam value="#arguments.file_name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
				PRD_IMG_NAME = <cfif len(FORM.IMAGE_NAME) and isDefined("FORM.IMAGE_NAME")>
               <cfqueryparam value="#encodeForHTML(FORM.IMAGE_NAME)#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
				VIDEO_PATH = <cfqueryparam value="#arguments.image_url_link#" cfsqltype="cf_sql_nvarchar">,
				IS_INTERNET = <cfif isdefined("arguments.is_internet")>1<cfelse>0</cfif>,
				DETAIL = <cfqueryparam value="#encodeForHTML(FORM.DETAIL)#" cfsqltype="cf_sql_nvarchar">,
				IMAGE_SIZE = <cfif isdefined("arguments.size") and len(arguments.size)><cfqueryparam value="#arguments.size#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
				<cfif arguments.image_type eq "product">
					STOCK_ID = <cfif isdefined("arguments.stock_id")><cfqueryparam value="#encodeForHTML(arguments.stock_id)#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>
				</cfif>,
				LANGUAGE_ID = <cfqueryparam value="#arguments.language_id#" cfsqltype="cf_sql_nvarchar">,
				UPDATE_DATE =<cfqueryparam value="#NOW()#" cfsqltype="cf_sql_date">,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
                IS_EXTERNAL_LINK =<cfif isDefined("attributes.image_file")  and len(attributes.image_file) and isDefined("attributes.image_url_link")  and len(attributes.image_url_link OR isDefined("attributes.image_url_link")  and len(attributes.image_url_link))> 1 <cfelse> 0 </cfif> ,
				VIDEO_LINK =   <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>
			WHERE 
                #identity_column# = <cfqueryparam value="#arguments.image_action_id#" cfsqltype="cf_sql_integer">
                
		</cfquery>
    </cffunction>
	<cffunction name="UPD_IMAGE" access="remote" returntype="any">
		<cfargument  name="size" default="">
        <cfargument  name="process_id" default="">
        <cfargument  name="image_name" default="">
        <cfargument  name="video_link" default="">
        <cfargument  name="image_url_link" default="">
        <cfargument name="language_id">
		<cfargument name="file_name">
		<cfargument  name="image_action_id" default="">

		<cfquery name="UPD_IMAGE" datasource="#DSN#">
            UPDATE
                CONTENT_IMAGE 
            SET
				IMAGE_SIZE = <cfif len(arguments.size)><cfqueryparam value="#arguments.size#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
				CONTENT_ID = <cfqueryparam value="#encodeForHTML(arguments.process_id)#" cfsqltype="cf_sql_integer">,
				CNT_IMG_NAME = <cfqueryparam value="#encodeForHTML(arguments.image_name)#" cfsqltype="cf_sql_nvarchar">, 
				CONTIMAGE_SMALL = <cfif isDefined("arguments.file_name") and len(arguments.file_name)><cfqueryparam value="#arguments.file_name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
				IMAGE_SERVER_ID =  <cfqueryparam value="#arguments.server_machine#" cfsqltype="cf_sql_nvarchar">,
				DETAIL = <cfqueryparam value="#encodeForHTML(arguments.detail)#" cfsqltype="cf_sql_nvarchar">,
				ASSET_FILE_SIZE =<cfif isDefined("arguments.image_file")  and len(arguments.image_file) and isDefined("arguments.image_url_link")  and len(arguments.image_url_link)><cfqueryparam value="#ROUND(CFFILE.FILESIZE/1024)#" cfsqltype="cf_sql_integer"><cfelseif isDefined("arguments.image_url_link")  and len(arguments.image_url_link)>NULL<cfelse><cfqueryparam value="#ROUND(CFFILE.FILESIZE/1024)#" cfsqltype="cf_sql_integer"></cfif>,
				UPDATE_DATE =<cfqueryparam value="#NOW()#" cfsqltype="cf_sql_date">,
				UPDATE_EMP =<cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
				UPDATE_IP = <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">,
				IS_EXTERNAL_LINK =<cfif isDefined("arguments.image_file")  and len(arguments.image_file) and isDefined("arguments.image_url_link") OR isDefined("arguments.image_url_link")  and len(arguments.image_url_link)>1 <cfelse>0</cfif>,
				VIDEO_LINK = <cfif isdefined('arguments.video_link') and len(arguments.video_link)>1<cfelse>0</cfif>,
				PATH =<cfif len(arguments.image_url_link)><cfqueryparam value="#arguments.image_url_link#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
				LANGUAGE_ID =<cfqueryparam value="#arguments.language_id#" cfsqltype="cf_sql_nvarchar">
			WHERE 
				CONTIMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.image_action_id#">
        </cfquery>
	</cffunction>
</cfcomponent>