<cftransaction>
<cfset ilk_upload = "#upload_folder#">
<cfset upload_folder = "#upload_folder#training#dir_seperator#">
<cfset flashComServerPath = "#flashComServerApplicationsPath#white_board\streams\_definst_\">
<cffunction name="getFileSize" returntype="numeric">
	<cfargument name="fileName" type="string" required="yes" />
    <cfset var fileInstance = createObject("java","java.io.File").init(toString(arguments.fileName)) />
		<cfif fileInstance.isFile()>
			<cfreturn fileInstance.length() />
        <cfelse>
        	<cfreturn -1 />
		</cfif>
</cffunction>

<cftry>
	<cfset filesize = getFileSize("#flashComServerPath##session.ep.username#_rec.flv") />
    <cffile action="move" source="#flashComServerPath##session.ep.username#_rec.flv" destination="#upload_folder#">
	<cfset file_name = "#createUUID()#">
	<cfset dosya_ad = file_name>
	<cfset extention = "FLV">
	<cfset file_name = "#file_name#.#extention#">
	<cffile action="rename" source="#upload_folder##session.ep.username#_rec.flv" destination="#upload_folder##file_name#">
	<!--- tumbnail uretiyor --->
	<cfmodule template="convert_video.cfm" action="CreateThumb" inputfile="#upload_folder##file_name#" outputfile="#ilk_upload#thumbnails#dir_seperator##file_name#.jpg">
	<cfcatch>
    <cfrethrow />
		<script type="text/javascript">
			alert("<cf_get_lang_main no='785.başarısız'>:<cf_get_lang no ='522.Dosyanız Kaydedilemedi'> !");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>
</cftransaction>

<cfquery name="get_class_" datasource="#dsn#">
	SELECT CLASS_NAME FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#
</cfquery>

<cfset asset_file_name_ = '#get_class_.class_name# #dateformat(now(),dateformat_style)#'>

<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="add_asset_training" datasource="#dsn#">
			INSERT INTO 
				ASSET
			(
				MODULE_NAME,
				MODULE_ID,
				ACTION_SECTION,
				ACTION_ID,
				COMPANY_ID,
				ASSETCAT_ID,
				ASSET_FILE_NAME,
				ASSET_FILE_SIZE,
				ASSET_FILE_SERVER_ID,
				ASSET_NAME,
				IS_INTERNET,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				PROPERTY_ID,
				IS_SPECIAL
			)
			VALUES
			(
				'training',
				34,
				'CLASS_ID',
				#attributes.class_id#,
				#session.ep.company_id#,
				-20,
				'#file_name#',
				#filesize#,
				#fusebox.server_machine#,
				'#asset_file_name_#',
				0,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#',
				18,
				0
			)
		</cfquery>
    </cftransaction>
</cflock>
