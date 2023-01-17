<cfset uploadFolder = application.systemParam.systemParam().upload_folder>
<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>
<cfset asset_component = CreateObject("component","V16.asset.cfc.asset")>
<cfset uploadStatus = false ><!--- dosya yoluyla yükleme olmamış, embed kodu ile yükleme olmuş ise --->

<cfif isdefined("attributes.action_section") and attributes.action_section is 'COMPANY_ID'>
	<cfset attributes.related_company_id = attributes.action_id>
<cfelseif isdefined("attributes.action_section") and attributes.action_section is 'CONSUMER_ID'>
	<cfset attributes.related_consumer_id = attributes.action_id>
<cfelseif isdefined("attributes.action_section") and attributes.action_section is 'INTERNALDEMAND_ID'>
	<cfif not isValid("integer", attributes.action_id)>
		<cfset attributes.action_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.action_id,accountKey:'wrk')>
	</cfif>
	<cfset attributes.related_asset_id = attributes.action_id>
</cfif>
<cfif isdefined("attributes.validate_start_date")>
	<cf_date tarih='attributes.validate_start_date'>
</cfif>
<cfif isdefined("attributes.validate_finish_date")>
	<cf_date tarih='attributes.validate_finish_date'>
</cfif>

<cfif ((isdefined("attributes.foldername") and len(attributes.foldername)) and (isdefined('attributes.asset') and len(attributes.asset))) or (isdefined('attributes.stream_name') and len(attributes.stream_name)) or (isdefined("attributes.change_revision") and len(attributes.change_revision) and attributes.change_revision eq 1)>
	
	<!--- Upload File --->
	<cffunction name="uploadFile">
		<cfargument name="assetInfo" type="struct" />
		
		<cfset fileSystem.rename(assetInfo.filePath,assetInfo.uploadFolder & assetInfo.fileFullName) />
	
		<cfif fileSystem.fileType(assetInfo.fileExtension)["fileType"] eq "image">
			<cfset asset_component.createThumbnailFromImage(assetInfo : assetInfo) /><!--- Fotoğraf thumbnail ---->
		</cfif>

		<!--- insert AssetInfo --->
		<cfset saveAssetMetaData(assetInfo) />
	</cffunction>
	
	<cffunction name="own_uploadFile">
		<cfargument name="assetInfo" type="struct" />
		<cfset own_filename = listlast(attributes.asset,'/')>
		<cffile action="copy" source="#download_folder##attributes.asset#" destination="#assetInfo.uploadFolder#">

		<cfset assetInfo.fileSize = 1>
		<cfset assetInfo.fileExtension = ucase(listgetat(own_filename,2,'.'))>
		<cfset assetInfo.fileFullName = "#own_filename#">
		<cfset assetInfo.asset_file_real_name = "#own_filename#">		
		<cffile action="rename" source="#assetInfo.uploadFolder##own_filename#" destination="#assetInfo.uploadFolder##assetInfo.fileFullName#">
		<cfset saveAssetMetaData(assetInfo) />
	</cffunction>
		
	<!--- UPLOAD LIVE FLASH VIDEO STREAM --->
	<cffunction name="uploadLiveFlvStream">
		<cfargument name="assetInfo" type="struct" />
			<cfset assetInfo.fileSize = -1 />
			<cfset assetInfo.fileName="#attributes.stream_name#" />
			<cfset assetInfo.fileExtension = "flv" />
			<cfset assetInfo.fileFullName="#assetInfo.fileName#.#assetInfo.fileExtension#" />
			<cfset assetInfo.isLive = true />
			<cfset assetInfo.asset_file_real_name = "#attributes.stream_name#.flv">
			<!--- insert AssetInfo --->
			<cfset saveAssetMetaData(assetInfo) />
	</cffunction>
	<!--- UPLOAD RECORDED FLASH VIDEO STREAM --->
	<cffunction name="uploadRecordedFlvStream">
		<cfargument name="assetInfo" type="struct" />
			<cfset assetInfo.fileSize = getFileSize("#flashComServerApplicationsPath##dsn#\streams\_definst_\#attributes.stream_name#.flv") />
			<cffile action="move" source="#flashComServerApplicationsPath##dsn#\streams\_definst_\#attributes.stream_name#.flv" destination="#upload_folder#">
			<cfset assetInfo.fileName="#attributes.stream_name#" />
			<cfset assetInfo.fileExtension = "flv" />
			<cfset assetInfo.fileFullName="#assetInfo.fileName#.#assetInfo.fileExtension#" />
			<cfset assetInfo.asset_file_real_name = "#attributes.stream_name#.flv">
			<!--- create thumbnail --->
			<cfset createThumbnailFromVideo(assetInfo) />
			<!--- insert AssetInfo --->
			<cfset saveAssetMetaData(assetInfo) />
	</cffunction>
	<cffunction name="getFileSize" returntype="numeric">
		<cfargument name="fileName" type="string" required="yes" />
		<cfset var fileInstance = createObject("java","java.io.File").init(toString(arguments.fileName)) />
		<cfif fileInstance.isFile()>
			<cfreturn fileInstance.length() />
		<cfelse>
			<cfreturn -1 />
		</cfif>
	</cffunction>
	<cffunction name="AssetInfoNew" returntype="struct" description="Returns new AssetInfo object that contains default values">
		<cfargument name="asset_name" type="string" default="">

		<cfset assetInfo=structNew() />
		<cfset assetInfo.assetId="" />
		<cfset assetInfo.assetName = ( len( arguments.asset_name ) ) ? arguments.asset_name : attributes.ASSET_NAME />
		<cfset assetInfo.assetDescription = attributes.ASSET_DESCRIPTION />
		<cfset assetInfo.assetKeywords = attributes.ASSET_DETAIL />
		
		<cfif isdefined('attributes.asset_cat_id') and len(attributes.asset_cat_id)>
			<cfset assetInfo.assetCategoryId=attributes.asset_cat_id />
		<cfelse>
			<cfset assetInfo.assetCategoryId=attributes.ASSETCAT_ID />
		</cfif>
		<cfif isdefined("session.ep.company_id")>
			<cfset assetInfo.companyId=SESSION.EP.COMPANY_ID />
		<cfelseif isdefined("session.pp.company_id")>
			<cfset assetInfo.companyId=SESSION.PP.COMPANY_ID />
		<cfelseif isdefined("session.ww.OUR_COMPANY_ID")>
			<cfset assetInfo.companyId=SESSION.WW.OUR_COMPANY_ID />
		</cfif>
		<cfset assetInfo.fileName="" />
		<cfset assetInfo.fileSize="" />
		<cfset assetInfo.fileExtension="" />
		<cfset assetInfo.fileFullName = "" />
		<cfset assetInfo.filePath=""/>
		<cfset assetInfo.fileServerId=fusebox.server_machine />
		<cfset assetInfo.uploadFolder=getUploadFolder() />

		<cfif isdefined('attributes.module') and len(attributes.module)>
			<cfset assetInfo.moduleName=attributes.module />
		<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			<cfset assetInfo.moduleName="project" />
		<cfelseif isdefined("attributes.project_multi_id") and len(attributes.project_multi_id)>
			<cfset assetInfo.moduleName="project" />
		<cfelseif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>
			<cfset assetInfo.moduleName="Product" />
		<cfelse>
			<cfset assetInfo.moduleName="Asset" />
		</cfif>
		
		<cfif isdefined('attributes.module_id') and len(attributes.module_id)>
			<cfset assetInfo.moduleId=attributes.module_id />
		<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			<cfset assetInfo.moduleId=1 />
		<cfelseif isdefined("attributes.project_multi_id") and len(attributes.project_multi_id)>
			<cfset assetInfo.moduleId=1 />
		<cfelseif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>
			<cfset assetInfo.moduleId=5 />
		<cfelse>
			<cfset assetInfo.moduleId=8 />
		</cfif>
		<cfif isdefined('attributes.action_section') and len(attributes.action_section)>
			<cfset assetInfo.actionSection=attributes.action_section />
		<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			<cfset assetInfo.actionSection="PROJECT_ID" />
		<cfelseif isdefined("attributes.project_multi_id") and listlen(attributes.project_multi_id)>
			<cfset assetInfo.actionSection="PROJECT_ID" />
		<cfelseif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>
			<cfset assetInfo.actionSection="PRODUCT_ID" />
		<cfelse>
			<cfset assetInfo.actionSection="Asset" />
		</cfif>
		
		<cfif isdefined('attributes.action_type') and attributes.action_type eq 0 and isdefined('attributes.action_id') and len(attributes.action_id)>
			<cfset assetInfo.actionId=attributes.action_id />
		<cfelseif isdefined('attributes.action_type') and attributes.action_type eq 1 and isdefined('attributes.action_id_2') and len(attributes.action_id_2)>
			<cfset assetInfo.actionId=attributes.action_id_2 />
		<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			<cfset assetInfo.actionId=attributes.project_id>
		<cfelseif isdefined("attributes.project_multi_id") and len(attributes.project_multi_id)>
			<cfset assetInfo.actionId= attributes.project_multi_id />
		<cfelse>
			<cfset assetInfo.actionId=-1 />
		</cfif>
		
		<cfif isdefined("attributes.is_internet")>
			<cfset assetInfo.isInternet=true />
		<cfelse>
			<cfset assetInfo.isInternet=false />
		</cfif>
		<cfset assetInfo.recordDate=NOW() />
		
		<cfif isdefined("session.ep.userid")>
			<cfset assetInfo.recordEmployee=SESSION.EP.USERID />
		<cfelseif isdefined("session.ww.userid")>
			<cfset assetInfo.recordEmployee=SESSION.WW.USERID />
		<cfelseif isdefined("session.pp.userid")>
			<cfset assetInfo.recordEmployee=SESSION.PP.USERID />
		</cfif>
		
		<cfset assetInfo.recordIp=CGI.REMOTE_ADDR />
		
		<cfif isdefined("session.ep.userid")>
			<cfset assetInfo.updateEmployee=SESSION.EP.USERID />
		<cfelseif isdefined("session.ww.userid")>
			<cfset assetInfo.updateEmployee=SESSION.WW.USERID />
		<cfelseif isdefined("session.pp.userid")>
			<cfset assetInfo.updateEmployee=SESSION.PP.USERID />
		</cfif>
	
		<cfset assetInfo.updateIp=CGI.REMOTE_ADDR />
		<cfset assetInfo.propertyId=attributes.property_id />
		
		<cfif isdefined("session.ep.user_location")>
			<cfset departmentId = session.ep.user_location />
		<cfelseif isdefined("session.ww.user_location")>
			<cfset departmentId = session.ww.user_location>
		</cfif>
		<cfif isdefined("departmentId")>
			<cfset assetInfo.departmentId=listFirst(departmentId,'-') />
			<cfset assetInfo.branchId=listGetAt(departmentId,2,'-') />
		</cfif>
		<cfif isdefined("attributes.is_live")>
			<cfset assetInfo.isLive=true />
		<cfelse>
			<cfset assetInfo.isLive=false />
		</cfif>
		<cfif isdefined("attributes.featured")>
			<cfset assetInfo.featured=true />
		<cfelse>
			<cfset assetInfo.featured=false />
		</cfif>
		<cfif isdefined("attributes.is_special")>
			<cfset assetInfo.is_special=true />
		<cfelse>
			<cfset assetInfo.is_special=false />
		</cfif>
		<cfreturn assetInfo />
	</cffunction>
	
	<cffunction name="isLiveFlvStream" returntype="boolean">
		<cfif isDefined("attributes.is_live") and attributes.is_live eq true>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<cffunction name="isRecordedFlvStream" returntype="boolean">
		<cfif isDefined("attributes.stream_name") and attributes.stream_name neq "">
			<cfreturn true />
		<cfelse>
			<cfreturn false/>
		</cfif>
	</cffunction>
	
	<cffunction name="isownfile" returntype="boolean">
		<cfif isDefined("attributes.is_own_file") and attributes.is_own_file eq 1>
			<cfreturn true />
		<cfelse>
			<cfreturn false/>
		</cfif>
	</cffunction>

	<cffunction name="getUploadFolder" returntype="string" description="Upload folder is determined by selected category">
		<cfquery name="GET_UPLOAD_FOLDER" datasource="#DSN#">
			SELECT
				ASSETCAT_ID,
				ASSETCAT_PATH
			FROM
				ASSET_CAT
			WHERE
				ASSETCAT_ID = #assetInfo.assetCategoryId#
		</cfquery>
		<cfif company_asset_relation eq 1>
			<cfif assetInfo.assetCategoryId lt 0>
				<cfif isdefined('attributes.action_id') and len(attributes.action_id)>
					<cfset add_folder = "#uploadFolder##get_upload_folder.assetcat_path##dir_seperator##year(now())##dir_seperator##attributes.action_id#">
                <cfelse>
                	<cfset add_folder = "#uploadFolder##get_upload_folder.assetcat_path##dir_seperator##year(now())#">
                </cfif>
			<cfelse>
            	<cfif isdefined('attributes.action_id') and len(attributes.action_id)>
					<cfset add_folder = "#uploadFolder#asset#dir_seperator##get_upload_folder.assetcat_path##dir_seperator##year(now())##dir_seperator##attributes.action_id#">
                <cfelse>
                	<cfset add_folder = "#uploadFolder#asset#dir_seperator##get_upload_folder.assetcat_path##dir_seperator##year(now())#">
                </cfif>
			</cfif>
            <cfif not DirectoryExists("#add_folder#")>
                <cfdirectory action="create" directory="#add_folder#">
            </cfif>
			
			<cfset upload_folder = "#add_folder##dir_seperator#">
		<cfelse>
			<cfif assetInfo.assetCategoryId lt 0>
				<cfif not DirectoryExists("#uploadFolder##get_upload_folder.assetcat_path##dir_seperator#")>
					<cfdirectory action="create" directory="#uploadFolder##get_upload_folder.assetcat_path##dir_seperator#">
				</cfif>
				<cfset upload_folder = "#uploadFolder##get_upload_folder.assetcat_path##dir_seperator#">
			<cfelse>
				<cfset upload_folder = "#uploadFolder#asset#dir_seperator##get_upload_folder.assetcat_path##dir_seperator#">
			</cfif>
		</cfif>
		<cfreturn upload_folder />
	</cffunction>

	<cffunction name="createThumbnailFromVideo">
		<cfargument name="assetInfo" type="struct" required="yes" />
		<cftry>
			<cfset thumbnail_name = replace(assetInfo.fileFullName,'.flv','.jpg')>
			<cfexecute name="#expandPath('/COM_MX/tools/ffmpeg.exe')#" arguments="-i ""#assetInfo.uploadFolder##assetInfo.fileFullName#"" -deinterlace -an -ss 3 -t 00:00:3 -r 1 -y -s 50x50 -vcodec mjpeg -f mjpeg ""#ilk_upload#thumbnails#dir_seperator##thumbnail_name#""" variable="output" timeout="30"/>
			<cfcatch type="any"></cfcatch>
		</cftry>
	</cffunction>
    
	<cffunction name="manipulateImage">
		<cfargument name="assetInfo" type="struct" required="yes" />
		<!--- Resim islemlere tabi tutulacaksa geici bir klasor ailir ve oraya kopyalanir --->
		<cftry>
		<cfif ((assetInfo.fileExtension is "gif") or (assetInfo.fileExtension is "jpg") or
		  (assetInfo.fileExtension is "png") or (assetInfo.fileExtension is "tif") or
		  (assetInfo.fileExtension is "bmp")) and isDefined("attributes.image")>
			<cfset session.imFile = assetInfo.fileFullName>
			<cfif assetInfo.fileExtension eq 'gif'>
				<cfx_WorkcubeImage NAME="image"
                       ACTION="rotate"
                       SRC="#assetInfo.uploadFolder##assetInfo.fileFullName#"
                       DST="#assetInfo.uploadFolder##assetInfo.fileFullName#"
                       PARAMETERS="0">
				<cfset session.imFile = listGetAt(session.imFile,1,".")&"."&"jpg">			
				<cfset assetInfo.fileExtension = 'jpg'>
				<cfset assetInfo.fileFullName = '#ListDeleteAt(assetInfo.fileFullName,ListLen(assetInfo.fileFullName,'.'),'.')#.#assetInfo.fileExtension#'>
			</cfif>
			<cfdirectory action="CREATE" directory="#session.imTempPath#">
			<cffile action="copy"
			  source="#assetInfo.uploadFolder##assetInfo.fileFullName#" 
			  destination="#session.imTempPath#">
		</cfif>
		   <cfcatch type="Any">
		   <cfoutput><b>#assetInfo.uploadFolder##assetInfo.fileFullName# -- #session.imTempPath#</b></cfoutput>
				<cfabort>
		   </cfcatch>
		</cftry>
	</cffunction>
	<cffunction name="saveAssetMetaData" description="All database operations to save AssetInfo object">
		<cfargument name="assetInfo" type="struct">
		<cflock name="#CREATEUUID()#" timeout="20">
			<cftransaction>
				<cfquery name="ADD_ASSET" datasource="#DSN#" result="insertAsset">
					INSERT INTO 
						ASSET
					(
						PERIOD_ID,
						ASSET_NO,
						MODULE_NAME,
						MODULE_ID,
						ACTION_SECTION,
						PROJECT_ID,
						PROJECT_MULTI_ID,
						<cfif (isdefined("attributes.change_revision") and attributes.change_revision eq 0) or (not isdefined("attributes.change_revision"))>
							<cfif (attributes.action_type eq 0)>
								ACTION_ID,
							<cfelseif attributes.action_type eq 1 and len(attributes.action_id_2)>
								ACTION_ID,
							<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
								ACTION_ID,
							<cfelseif isdefined("attributes.project_multi_id") and len(attributes.project_multi_id)>
								ACTION_ID,
							<cfelseif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>
								ACTION_ID,
							<cfelse>
								ACTION_VALUE,
							</cfif>
						</cfif>
						<!--- Action_Id alani cift cekildigi icin hataya sebep oldugundan degistirdim, dogrusunu bilen varsa duzeltsin FBS 20111010
						<cfif attributes.action_type eq 0>ACTION_ID<cfelse>ACTION_VALUE</cfif>,
						<cfif attributes.action_type eq 1 and len(attributes.action_id_2)>ACTION_ID,</cfif>
						<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>ACTION_ID,</cfif>
						 --->
						COMPANY_ID,
						ASSETCAT_ID,
						ASSET_FILE_NAME,
						ASSET_FILE_REAL_NAME,
						<cfif isdefined('attributes.asset_path_name') and len(attributes.asset_path_name)>
                            ASSET_FILE_PATH_NAME,
                        </cfif>
						ASSET_FILE_SIZE,
						ASSET_FILE_SERVER_ID,
						ASSET_NAME,
						ASSET_DETAIL,
						IS_INTERNET,
						RECORD_DATE,
						<cfif isdefined("session.ep.userid")>
						RECORD_EMP,
						<cfelseif isdefined("session.ww.userid")>
						RECORD_PUB,
						<cfelseif isdefined("session.pp.userid")>
						RECORD_PAR,
						</cfif>                
						RECORD_IP,
						PROPERTY_ID,
						<cfif isdefined("assetInfo.departmentId")>
						DEPARTMENT_ID,
						</cfif>
						<cfif isdefined("assetInfo.branchId")>
						BRANCH_ID,
						</cfif>
						ASSET_DESCRIPTION,
						IS_LIVE,
						FEATURED,
						IS_SPECIAL,
						SERVER_NAME,
						IS_IMAGE
						,ASSET_STAGE
						<cfif (isdefined('attributes.mail_receiver_emp_id') and len(attributes.mail_receiver_emp_id)) or (isdefined('attributes.mail_receiver_partner_id') and len(attributes.mail_receiver_partner_id))>
						,MAIL_RECEIVER_ID
						,MAIL_RECEIVER_IS_EMP
						</cfif>
						<cfif (isdefined('attributes.mail_cc_emp_id') and len(attributes.mail_cc_emp_id)) or (isdefined('attributes.mail_cc_partner_id') and len(attributes.mail_cc_partner_id))>
						,MAIL_CC_ID
						,MAIL_CC_IS_EMP
						</cfif>
						,LIVE
						,IS_DPL
						,IS_ACTIVE
						,PRODUCT_ID
						,REVISION_NO
                        ,VALIDATE_START_DATE
                        ,VALIDATE_FINISH_DATE
						<cfif isdefined("attributes.related_company_id") and len(attributes.related_company_id)>,RELATED_COMPANY_ID</cfif>
						<cfif isdefined("attributes.related_consumer_id") and len(attributes.related_consumer_id)>,RELATED_CONSUMER_ID</cfif>
						<cfif isdefined("attributes.related_asset_id") and len(attributes.related_asset_id)>,RELATED_ASSET_ID</cfif>
						,EMBEDCODE_URL
                        ,CONTENT_AUTHOR
					)
					VALUES
					(
						#session.ep.period_id#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_no#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.moduleName#">,
						#assetInfo.moduleId#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.actionSection#">,
						<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.project_multi_id") and len(attributes.project_multi_id)>',#attributes.project_multi_id#,'<cfelse>NULL</cfif>,
						<cfif (isdefined("attributes.change_revision") and attributes.change_revision eq 0) or (not isdefined("attributes.change_revision"))>
							<cfif (attributes.action_type eq 0)>
								#attributes.action_id#,
							<cfelseif attributes.action_type eq 1 and len(attributes.action_id_2)>
								#attributes.action_id_2#,
							<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
								#assetInfo.actionId#,
							<cfelseif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_id#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_id#">,
							</cfif>
						</cfif>	
						<!--- Action_Id alani cift cekildigi icin hataya sebep oldugundan degistirdim, dogrusunu bilen varsa duzeltsin FBS 20111010
						<cfif attributes.action_type eq 0>#attributes.action_id#<cfelse>'#attributes.action_id#'</cfif>,
						<cfif attributes.action_type eq 1 and len(attributes.action_id_2)>#attributes.action_id_2#,</cfif>
						<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#assetInfo.actionId#,</cfif>
						 --->
						#assetInfo.companyId#,
						#assetInfo.assetCategoryId#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.fileFullName#">,
						<cfif isdefined("assetInfo.asset_file_real_name")><cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.asset_file_real_name#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.fileFullName#"></cfif>,
                        <cfif isdefined('attributes.asset_path_name') and len(attributes.asset_path_name)>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_path_name#">,
                        </cfif>
						<cfif isdefined("assetInfo.fileSize") and len(assetInfo.fileSize)>#ROUND(assetInfo.fileSize/1024)#<cfelse>0</cfif>,
						#assetInfo.fileServerId#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.assetName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.assetKeywords#">,
						<cfif assetInfo.isInternet>1<cfelse>0</cfif>,
						#assetInfo.recordDate#,
						#assetInfo.recordEmployee#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.recordIp#">,
						#assetInfo.propertyId#,
						<cfif isdefined("assetInfo.departmentId")>
						#assetInfo.departmentId#,
						</cfif>
						<cfif isdefined("assetInfo.branchId")>
						#assetInfo.branchId#,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.assetDescription#">,
						<cfif assetInfo.isLive>1<cfelse>0</cfif>,
						<cfif assetInfo.featured>1<cfelse>0</cfif>,
						<cfif assetInfo.is_special>1<cfelse>0</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(server_name)#">,
						<cfif isdefined("attributes.is_image") and attributes.is_image eq 1>1<cfelse>0</cfif>
						,#attributes.process_stage#
						<cfif isdefined('attributes.mail_receiver_emp_id') and len(attributes.mail_receiver_emp_id)>
							,#attributes.mail_receiver_emp_id#
							,1
						<cfelseif isdefined('attributes.mail_receiver_partner_id') and len(attributes.mail_receiver_partner_id)>
							,#attributes.mail_receiver_partner_id#
							,0
						</cfif>
						<cfif isdefined('attributes.mail_cc_emp_id') and len(attributes.mail_cc_emp_id)>
							,#attributes.mail_cc_emp_id#
							,1
						<cfelseif isdefined('attributes.mail_cc_partner_id') and len(attributes.mail_cc_partner_id)>
							,#attributes.mail_cc_partner_id#
							,0
						</cfif>
						,<cfif isdefined("attributes.live")>1<cfelse>0</cfif>
						,<cfif isdefined("attributes.is_dpl")>1<cfelse>0</cfif>
						,<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
						,<cfif isdefined("attributes.product_id") and isdefined("attributes.product_name") and len(attributes.product_name) and len(attributes.product_id)>#attributes.product_id#<cfelse>NULL</cfif>
						,<cfif isdefined("attributes.revision_no") and len(attributes.revision_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.revision_no#"><cfelse>NULL</cfif>
                        ,<cfif isdefined("attributes.validate_start_date")>#attributes.validate_start_date#<cfelse>NULL</cfif>
                        ,<cfif isdefined("attributes.validate_finish_date")>#attributes.validate_finish_date#<cfelse>NULL</cfif>
						<cfif isdefined("attributes.related_company_id") and len(attributes.related_company_id)>,#attributes.related_company_id#</cfif>
						<cfif isdefined("attributes.related_consumer_id") and len(attributes.related_consumer_id)>,#attributes.related_consumer_id#</cfif>
						<cfif isdefined("attributes.related_asset_id") and len(attributes.related_asset_id)>,#attributes.related_asset_id#</cfif>
						,<cfif isdefined("attributes.srcembcode") and len(attributes.srcembcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.srcembcode#"><cfelse>NULL</cfif>
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					)
				</cfquery>
				<cfset assetInfo.assetid = insertAsset.IDENTITYCOL>
				<cfquery name="GET_MAX_ID" datasource="#DSN#">
					SELECT MAX(ASSET_ID) AS MAX_ID FROM ASSET
				</cfquery>
				<cfif isdefined("attributes.is_dpl")>
					<cfinclude template="dpl_copy.cfm">
				</cfif>
						<cf_workcube_process 
							is_upd='1'
							old_process_line='0'
							process_stage='#attributes.process_stage#' 
							record_member='#session.ep.userid#' 
							record_date='#now()#'
							action_table='ASSET'
							action_column='ASSET_ID'
							action_id='#GET_MAX_ID.MAX_ID#'
							action_page='#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#GET_MAX_ID.MAX_ID#&assetcat_id=#assetInfo.assetCategoryId#&nogoback=1'
							warning_description='Varlık : #attributes.asset_name#'>
				<cfif isdefined('attributes.is_extranet')>
					<cfif isdefined('attributes.comp_cat') and len(attributes.comp_cat)>
						<cfloop list="#attributes.comp_cat#" index="comp_cat">
							<cfquery name="ADD_COMPANY_CAT_ID" datasource="#DSN#">
								INSERT INTO
									ASSET_RELATED
									(	
										ASSET_ID,
										COMPANY_CAT_ID
									)
									VALUES
									(
										#GET_MAX_ID.MAX_ID#,
										#comp_cat#
									)
							</cfquery>
						</cfloop>
					</cfif>
				</cfif>
				<cfif isdefined('attributes.customer_cat') and len(attributes.customer_cat)>
					<cfloop list="#attributes.customer_cat#" index="customer_cat">
						<cfquery name="ADD_CUSTOMER_CAT" datasource="#DSN#">
							INSERT INTO
								ASSET_RELATED
								(
									ASSET_ID,
									CONSUMER_CAT_ID
								)
								VALUES
								(
									#GET_MAX_ID.MAX_ID#,
									#customer_cat#	
								)
						</cfquery>
					</cfloop>
				</cfif>
				<!---
				<cfif isdefined('attributes.internet_view') and len(attributes.internet_view)>
					<cfquery name="add_internet_view" datasource="#DSN#">
						INSERT INTO
							ASSET_RELATED
							(
								ASSET_ID,
								ALL_INTERNET
							)
							VALUES
							(
								#GET_MAX_ID.MAX_ID#,
								1
							)
					</cfquery>
				</cfif>
				--->
				<cfif isdefined('attributes.career_view') and len(attributes.career_view)>
					<cfquery name="ADD_CAREER_VIEW" datasource="#DSN#">
						INSERT INTO
							ASSET_RELATED
							(
								ASSET_ID,
								ALL_CAREER
							)
							VALUES
							(
								#GET_MAX_ID.MAX_ID#,
								1
							)
					</cfquery>
				</cfif>
				<cfif isdefined('attributes.position_cat_ids') and len(attributes.position_cat_ids)>
					<cfloop list="#attributes.position_cat_ids#" index="position_cat">
						<cfquery name="add_position_cat_ids" datasource="#DSN#">
							INSERT INTO
								ASSET_RELATED
								(
									ASSET_ID,
									POSITION_CAT_ID
								)
								VALUES
								(
									#GET_MAX_ID.MAX_ID#,
									#position_cat#
								)
						</cfquery>
					</cfloop>
				</cfif>
				<cfif isdefined('attributes.user_group_ids') and len(attributes.user_group_ids)>	
					<cfloop list="#attributes.user_group_ids#" index="user_group">
						<cfquery name="ADD_USER_GROUP_IDS" datasource="#DSN#">
							INSERT INTO
								ASSET_RELATED
								(
									ASSET_ID,
									USER_GROUP_ID
								)
								VALUES
								(
									#GET_MAX_ID.MAX_ID#,
									#user_group#
								)
						</cfquery>
					</cfloop>
				</cfif>
				<cfif isdefined('attributes.employee_view') and len(attributes.employee_view)>	
					<cfquery name="ADD_ALL" datasource="#DSN#">
						INSERT INTO
							ASSET_RELATED
							(
								ASSET_ID,
								ALL_EMPLOYEE
							)
							VALUES
							(
								#GET_MAX_ID.MAX_ID#,
								1
							)
					</cfquery>
				</cfif>
				<cfif isdefined('attributes.all_people') and len(attributes.all_people)>	
					<cfquery name="ADD_ALL" datasource="#DSN#">
						INSERT INTO
							ASSET_RELATED
							(
								ASSET_ID,
								ALL_PEOPLE
							)
							VALUES
							(
								#GET_MAX_ID.MAX_ID#,
								1
							)
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.is_internet")>
					<cfquery name="GET_COMPANY" datasource="#DSN#">
						SELECT 
							MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID
						FROM 
							MAIN_MENU_SETTINGS 
					</cfquery>
					<cfoutput query="get_company">
						<cfif isdefined("attributes.menu_#menu_id#")>
							<cfquery name="ASSET_SITE_DOMAIN" datasource="#DSN#">
								INSERT INTO
									ASSET_SITE_DOMAIN
									(
										ASSET_ID,		
										SITE_DOMAIN
									)
								VALUES
									(
										#GET_MAX_ID.MAX_ID#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes['menu_#menu_id#']#">
									)	
							</cfquery>
						</cfif>
					</cfoutput>
				</cfif>
				<cfif isdefined('attributes.digital_assets') and len(attributes.digital_assets)>	
					<cfloop list="#attributes.digital_assets#" index="digital_asset_group">
						<cfquery name="ADD_DIGITAL_ASSET_GROUP_IDS" datasource="#DSN#">
							INSERT INTO
								ASSET_RELATED
								(
									ASSET_ID,
									DIGITAL_ASSET_GROUP_ID
								)
								VALUES
								(
									#GET_MAX_ID.MAX_ID#,
									#digital_asset_group#
								)
						</cfquery>
					</cfloop>
				</cfif>
				<cfquery name="asset_history" datasource="#dsn#">
					INSERT INTO 
						ASSET_HISTORY (
								MODULE_NAME,
									MODULE_ID,
									ACTION_SECTION,
									ACTION_ID,
									ACTION_VALUE,
									ASSETCAT_ID,
									ASSET_ID,
									ASSET_FILE_NAME,
									ASSET_FILE_SIZE,
									ASSET_FILE_SERVER_ID,
									ASSET_FILE_FORMAT,
									ASSET_NAME,
									ASSET_DESCRIPTION,
									ASSET_DETAIL,
									PROPERTY_ID,
									COMPANY_ID,
									RECORD_DATE,
									RECORD_PAR,
									RECORD_PUB,
									RECORD_EMP,
									RECORD_IP,
									UPDATE_DATE,
									UPDATE_PAR,
									UPDATE_PUB,
									UPDATE_EMP,
									UPDATE_IP,
									IS_INTERNET,
									SERVER_NAME,
									DEPARTMENT_ID,
									BRANCH_ID,
									IS_IMAGE,
									IMAGE_SIZE,
									IS_SPECIAL,
									RESPONSED_ASSET_ID,
									IS_LIVE,
									FEATURED,
									DURATION,
									RATING,
									DOWNLOAD_COUNT,
									COMMENT_COUNT,
									FAVORITE_COUNT,
									RATING_COUNT,
									CONSUMER_ID,
									ASSET_FILE_REAL_NAME,
									ASSET_FILE_PATH_NAME,
									ASSET_STAGE,
									MAIL_RECEIVER_ID,
									MAIL_CC_ID,
									MAIL_RECEIVER_IS_EMP,
									MAIL_CC_IS_EMP,
									ASSET_NO,
									PERIOD_ID,
									IS_ACTIVE
						)
							SELECT
									MODULE_NAME,
									MODULE_ID,
									ACTION_SECTION,
									ACTION_ID,
									ACTION_VALUE,
									ASSETCAT_ID,
									ASSET_ID,
									ASSET_FILE_NAME,
									ASSET_FILE_SIZE,
									ASSET_FILE_SERVER_ID,
									ASSET_FILE_FORMAT,
									ASSET_NAME,
									ASSET_DESCRIPTION,
									ASSET_DETAIL,
									PROPERTY_ID,
									COMPANY_ID,
									RECORD_DATE,
									RECORD_PAR,
									RECORD_PUB,
									RECORD_EMP,
									RECORD_IP,
									UPDATE_DATE,
									UPDATE_PAR,
									UPDATE_PUB,
									UPDATE_EMP,
									UPDATE_IP,
									IS_INTERNET,
									SERVER_NAME,
									DEPARTMENT_ID,
									BRANCH_ID,
									IS_IMAGE,
									IMAGE_SIZE,
									IS_SPECIAL,
									RESPONSED_ASSET_ID,
									IS_LIVE,
									FEATURED,
									DURATION,
									RATING,
									DOWNLOAD_COUNT,
									COMMENT_COUNT,
									FAVORITE_COUNT,
									RATING_COUNT,
									CONSUMER_ID,
									ASSET_FILE_REAL_NAME,
									ASSET_FILE_PATH_NAME,
									ASSET_STAGE,
									MAIL_RECEIVER_ID,
									MAIL_CC_ID,
									MAIL_RECEIVER_IS_EMP,
									MAIL_CC_IS_EMP,
									ASSET_NO,
									PERIOD_ID,
									IS_ACTIVE
							FROM
								ASSET
							WHERE
								ASSET_ID = #assetInfo.assetid#
				</cfquery>
			</cftransaction>
		</cflock>
	</cffunction>

	<cfset fileRealName = "">

	<cfif isdefined("attributes.change_revision") and len(attributes.change_revision) and attributes.change_revision eq 1>

		<cfset fileUploadFolder = uploadFolder & "asset_preview">
		<cfset attributes.foldername = createUUID>
		<cfset fileSystem.newFolder(folderPath:fileUploadFolder,folderName:attributes.foldername)>
		<cfset fileRevisionPath = "#fileUploadFolder#/#attributes.foldername#">

		<cfif isdefined('attributes.asset') and len(attributes.asset)>

			<cffile action = "upload" 
					filefield = "asset" 
					destination = "#fileRevisionPath#" 
					nameconflict = "MakeUnique" 
					mode="777">	

			<cfset suitableFile = fileSystem.fileControl(filePath:fileRevisionPath,file:file) >

			<cfif suitableFile["status"] eq false>

				<script type="text/javascript">
					alert('<cfoutput>#suitableFile["message"]#</cfoutput>');
					history.back();
				</script>
			
			</cfif>
		
		<cfelse>

			<cfquery name="GET_OLD_FILE" datasource="#dsn#">

				SELECT 
					ASCAT.ASSETCAT_PATH,
					ASCAT.ASSETCAT_ID,
					ASSET.ASSET_FILE_NAME,
					ASSET.ASSET_FILE_REAL_NAME

				FROM
					ASSET_CAT AS ASCAT,
					ASSET AS ASSET
				WHERE
					(ASCAT.ASSETCAT_ID = #attributes.old_asset_catid# and ASSET.ASSET_ID = #attributes.asset_id#)

			</cfquery>
			
			<cfif attributes.old_asset_catid lt 0>
				<cfset categoryFolder = "">
			<cfelse>
				<cfset categoryFolder = "asset/">
			</cfif>

			<cfif GET_OLD_FILE.recordCount>
				
				<cfset oldFilePath = "#uploadFolder##categoryFolder##GET_OLD_FILE.ASSETCAT_PATH#/#GET_OLD_FILE.ASSET_FILE_NAME#">
				<cfif FileExists(oldFilePath)>

					<cfset fileSystem.copy(filePath:oldFilePath,newfilePath:fileRevisionPath)>
					<cfset fileRealName = GET_OLD_FILE.ASSET_FILE_REAL_NAME>

				<cfelse>

					<script type="text/javascript">
						alert("<cf_get_lang no ='185.Dosyanız taşınamadı'> !");
						history.back();
					</script>
					<cfabort>

				</cfif>
			
			<cfelse>

				<script type="text/javascript">
					alert("<cf_get_lang no ='185.Dosyanız taşınamadı'> !");
					history.back();
				</script>
				<cfabort>
				
			</cfif>

		</cfif>

	</cfif>	
<!--- ADD ASSET using the functions above --->
	<cfsavecontent variable="mail_logo"><cfinclude template="../../objects/display/view_company_logo.cfm"></cfsavecontent>
	<cfscript>
		
		session.imTempPath = "#upload_folder##createuuid()##dir_seperator#";
		folder = "asset_preview/" & attributes.foldername;//dosyaların bulunduğu klasör
		
		if( isdefined('attributes.embcode') and len(attributes.embcode)  and not len(attributes.asset_control))
		{
			assetInfo = AssetInfoNew();
			createId = createUUID();
			assetInfo.fileName = createId;
			assetInfo.fileRealName = createId;
			assetInfo.fileFullName = assetInfo.fileName;
			saveAssetMetaData(assetInfo);
			attributes.embcode = "";
			uploadStatus = true;
			session.imPath = assetInfo.uploadFolder;
		}

		if( isDefined('attributes.is_archive') and len(attributes.is_archive))
		{
			folder = attributes.foldername; // liste arşivleme tarafından geliyor ise dosya yolu değişiyor.
		}
		
		if(directoryexists(uploadFolder & folder)){
			
			fileList = fileSystem.fileListinFolder(folderPath:folder);	

			function addAssetInfo(file) {
				assetInfo = AssetInfoNew( ( not isdefined('attributes.asset_name') or not len(attributes.asset_name) ) ? ListFirst(file.name,".") : "" );
				createId = createUUID();
				assetInfo.fileSize = file.Size;
				assetInfo.fileExtension = ucase(ListLast(file.name,"."));
				assetInfo.fileName = createId;
				assetInfo.fileFullName = assetInfo.fileName & "." & assetInfo.fileExtension;
				if(uploadStatus) assetInfo.uploadFolder	= session.imPath;
				if(len(fileRealName)) assetInfo.asset_file_real_name = fileRealName;
				else assetInfo.asset_file_real_name = file.name;
				assetInfo.filePath = Replace(replaceNoCase( file.Directory, '\', '/', 'All' ),uploadFolder,"") & "/" & file.name;
			}

			if(fileList.recordCount gt 0){

				counter = 0;
				for (file in fileList) {
					
					if (isLiveFlvStream()) {
						uploadLiveFlvStream(assetInfo);
					}
					else if(isRecordedFlvStream())
					{
						uploadRecordedFlvStream(assetInfo);
					} 
					else if(isownfile())
					{
						own_uploadFile(assetInfo);
					}
					else
					{
						addAssetInfo(file);
						uploadFile(assetInfo);
					}
					session.imPath = assetInfo.uploadFolder;

					if(((isdefined('attributes.mail_receiver') and len(attributes.mail_receiver)) and ((isdefined('attributes.mail_receiver_emp_id') and len(attributes.mail_receiver_emp_id)) or (isdefined('attributes.mail_receiver_partner_id') and len(attributes.mail_receiver_partner_id)))) or (isdefined('attributes.mail_cc') and len(attributes.mail_cc) and (isdefined("attributes.mail_cc_emp_id") and len(attributes.mail_cc_emp_id)) or (isdefined("attributes.mail_cc_partner_id") and len(attributes.mail_cc_partner_id)))){
						asset_component.sendMail(
							mail_receiver : "#iif(isdefined('attributes.mail_receiver') and len(attributes.mail_receiver),"attributes.mail_receiver",DE(''))#", 
							mail_receiver_emp_id :  "#iif(isdefined('attributes.mail_receiver_emp_id') and len(attributes.mail_receiver_emp_id),'attributes.mail_receiver_emp_id',DE(''))#",
							mail_receiver_partner_id : "#iif(isdefined('attributes.mail_receiver_partner_id') and len(attributes.mail_receiver_partner_id),'attributes.mail_receiver_partner_id',DE(''))#",
							mail_cc :  "#iif(isdefined('attributes.mail_cc') and len(attributes.mail_cc),'attributes.mail_cc',DE(''))#",
							mail_cc_emp_id : "#iif(isdefined('attributes.mail_cc_emp_id') and len(attributes.mail_cc_emp_id),'attributes.mail_cc_emp_id',DE(''))#",
							mail_cc_partner_id : "#iif(isdefined('attributes.mail_cc_partner_id') and len(attributes.mail_cc_partner_id),'attributes.mail_cc_partner_id',DE(''))#",
							lang_digitalasset : "Dijital Varlık Bildirimi",
							asset_id : "#assetInfo.assetid#",
							user_domain : "#application.systemParam.systemParam().fusebox.server_machine_list#",
							mail_logo : mail_logo
						);

					}
					
					counter++;
					
					try{
						if(fileList.recordCount eq counter) fileSystem.deleteFolder(folder);//dosyaların bulunduğu klasörü siler.
					}catch (any cfcatch) {
					}
					
				}

			}else{
				WriteOutput('<script>alert("#getLang('','Yükleme işlemi sırasında bir hata oluştu',48344)#!");</script>');
			}

		}else{
			if(uploadStatus  == false)
			{
				WriteOutput('<script>alert("#getLang('','Yükleme işlemi sırasında bir hata oluştu',48344)#! CODE:NOFOLDER");</script>');
			}
		}

	</cfscript>

</cfif>

<cf_papers paper_type="ASSET">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfif len(system_paper_no_add)>
	<cfquery name="UPD_GEN_PAP" datasource="#DSN#">
		UPDATE 
			GENERAL_PAPERS_MAIN
		SET
			ASSET_NUMBER = #system_paper_no_add#
		WHERE
			ASSET_NUMBER IS NOT NULL
	</cfquery>
</cfif>

<cfif isdefined('attributes.action_section') and len(attributes.action_section) and  attributes.action_section neq 'INTERNALDEMAND_ID'>
	<script type="text/javascript">
		location.href = '<cfoutput>#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#GET_MAX_ID.MAX_ID#&assetcat_id=#assetInfo.assetCategoryId#&nogoback=1</cfoutput>';
	</script>
<cfelseif isdefined("attributes.is_own_file") and isdefined("attributes.is_upd_detail")>
	<script type="text/javascript">
		window.opener.location='<cfoutput>#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#GET_MAX_ID.MAX_ID#&assetcat_id=#assetInfo.assetCategoryId#&nogoback=1</cfoutput>';
		window.close();
	</script>
<cfelseif isdefined("attributes.is_own_file") or isdefined("attributes.is_archive")>
	<script type="text/javascript">
		alert('Döküman Kaydedildi');
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
        window.location.href='<cfoutput>#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#GET_MAX_ID.MAX_ID#&assetcat_id=#assetInfo.assetCategoryId#&nogoback=1</cfoutput>';
    </script>
</cfif>