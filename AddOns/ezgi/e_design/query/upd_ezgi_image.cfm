﻿    <cfif attributes.image_type eq "brand"><!--- Parça İse --->
        <cfset table = "EZGI_DESIGN_PIECE_IMAGES">
        <cfset identity_column = "DESIGN_PIECE_ROW_ID">
        <cfset ezgidsn = #dsn3#>
    <cfelseif attributes.image_type eq "product"><!--- Modül İse--->
        <cfset table = "EZGI_DESIGN_MAIN_IMAGES">
        <cfset identity_column = "DESIGN_MAIN_ROW_ID">
        <cfset ezgidsn = #dsn3#>
  	<cfelseif attributes.image_type eq "package"><!--- Paket İse --->
        <cfset table = "EZGI_DESIGN_PACKAGE_IMAGES">
        <cfset identity_column = "DESIGN_PACKAGE_ROW_ID">
        <cfset ezgidsn = #dsn3#>
   	<cfelseif attributes.image_type eq "lift_sub"><!--- Amortisör İse --->
        <cfset table = "EZGI_LIFT_IMAGES">
        <cfset identity_column = "DESIGN_LIFT_TYPE_ID">
        <cfset ezgidsn = #dsn#>
   	<cfelseif attributes.image_type eq "lift_offer"><!--- Amortisör Teklif İse --->
        <cfset table = "EZGI_LIFT_IMAGES">
        <cfset identity_column = "ORDER_ROW_ID">
        <cfset ezgidsn = #dsn#>
    </cfif>
	<cfif isDefined("attributes.image_file")  and len(attributes.image_file) and isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
		<cfset file_name = createUUID()>
		<cfif isDefined("form.image_file") and len(form.image_file)>
			<cffile action="UPLOAD" 
				destination="#upload_folder#product#dir_seperator#" 
				filefield="image_file"  
				nameconflict="MAKEUNIQUE" accept="image/*">
				
			<cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfquery name="UPD_UNIT" datasource="#ezgidsn#">
			UPDATE 
				#table# 
			SET 
				PATH_SERVER_ID = '#fusebox.server_machine#',
				PATH = '#file_name#.#cffile.serverfileext#',
				PRD_IMG_NAME = '#FORM.IMAGE_NAME#',
				<cfif not isDefined("form.image_file") and not len(form.image_file)> PATH_SERVER_ID = NULL,</cfif>
				VIDEO_PATH = '#attributes.image_url_link#',
				IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
				DETAIL = '#form.detail#',
				IMAGE_SIZE = <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
				LANGUAGE_ID = '#attributes.language_id#',
				UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				IS_EXTERNAL_LINK = 1,
				VIDEO_LINK =   <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>
			WHERE 
				#identity_column# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
                <cfif attributes.image_type eq "lift_offer">
                	AND EZGI_LIFT_IMAGE_DEFAULT_ID = #attributes.lift_default_id#
                </cfif>
		</cfquery>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	<cfelseif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
		<cfquery name="UPD_UNIT" datasource="#DSN3#">
			UPDATE 
					#table# 
				SET 
					PATH_SERVER_ID = '#fusebox.server_machine#',
					PATH = NULL,
					PRD_IMG_NAME = '#FORM.IMAGE_NAME#',
					<cfif not isDefined("form.image_file") and not len(form.image_file)> PATH_SERVER_ID = NULL,</cfif>
					VIDEO_PATH = '#attributes.image_url_link#',
					IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
					DETAIL = '#form.detail#',
					IMAGE_SIZE = <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
					LANGUAGE_ID = '#attributes.language_id#',
					UPDATE_DATE = #NOW()#,
					UPDATE_EMP = #SESSION.EP.USERID#,
					UPDATE_IP = '#CGI.REMOTE_ADDR#',
					IS_EXTERNAL_LINK = 1,
					VIDEO_LINK =   <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>
				WHERE 
					#identity_column# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
                    <cfif attributes.image_type eq "lift_offer">
                        AND EZGI_LIFT_IMAGE_DEFAULT_ID = #attributes.lift_default_id#
                    </cfif>
			</cfquery>
			<script type="text/javascript">
				wrk_opener_reload();
				window.close();
			</script>
	<cfelse>
		<cfset file_name = createUUID()>
		<cfif isDefined("form.image_file") and len(form.image_file)>
			<cffile action="UPLOAD" 
				destination="#upload_folder#product#dir_seperator#" 
				filefield="image_file"  
				nameconflict="MAKEUNIQUE" accept="image/*">
				
			<cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfquery name="UPD_UNIT" datasource="#ezgidsn#">
			UPDATE 
				#table# 
			SET 
				PRD_IMG_NAME = '#FORM.IMAGE_NAME#',
				<cfif isDefined("form.image_file") and len(form.image_file)>
					PATH_SERVER_ID = '#fusebox.server_machine#',
					PATH = '#file_name#.#cffile.serverfileext#',
				</cfif>
				<cfif len(attributes.image_url_link)>
					<cfif not isDefined("form.image_file") and not len(form.image_file)> PATH_SERVER_ID = NULL,</cfif>
					VIDEO_PATH = '#attributes.image_url_link#',
				<cfelse>
					VIDEO_PATH = NULL,
				</cfif>
				IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
				DETAIL = '#form.detail#',
				IMAGE_SIZE = <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#<cfelse>NULL</cfif>,
				LANGUAGE_ID = '#attributes.language_id#',
				UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				IS_EXTERNAL_LINK = 0,
				VIDEO_LINK =   <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>
			WHERE 
				#identity_column# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_action_id#">
		</cfquery>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	</cfif>
