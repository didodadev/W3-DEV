<cfscript>

	imageSettings =	{///thumbnail Settings

		1	:	{
			folderName	:	"icon",
			PositionX	:	0,
			PositionY	:	0,
			newWidth	:	128,
			newHeight	:	128
		},
		2	:	{
			folderName	:	"middle",
			PositionX	:	0,
			PositionY	:	0,
			newWidth	:	1024,
			newHeight	:	512
		}
	}; 

</cfscript>

<cfif isdefined("attributes.action_section") and attributes.action_section is 'COMPANY_ID'>
	<cfset attributes.related_company_id = attributes.action_id>
<cfelseif isdefined("attributes.action_section") and attributes.action_section is 'CONSUMER_ID'>
	<cfset attributes.related_consumer_id = attributes.action_id>
</cfif>
<cfif isdefined("attributes.validate_start_date")>
	<cf_date tarih='attributes.validate_start_date'>
</cfif>
<cfif isdefined("attributes.validate_finish_date")>
	<cf_date tarih='attributes.validate_finish_date'>
</cfif>

<cfif ((isdefined("attributes.foldername") and len(attributes.foldername)) and (isdefined('attributes.asset') and len(attributes.asset))) or (isdefined('attributes.stream_name') and len(attributes.stream_name))>
	
	<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>

	<!--- Upload File --->
	<cffunction name="uploadFile">
		<cfargument name="assetInfo" type="struct" />
		
		<!--- Upload File --->
		<cfset fileSystem.rename(assetInfo.filePath,assetInfo.uploadFolder & assetInfo.fileName) />
		
		<!--- create thumbnail --->
		<cfif getTypeOfUploadedFile(assetInfo.fileExtension) eq "image">
			<cfset createThumbnailFromImage(assetInfo) />
			<!---
		<cfelseif getTypeOfUploadedFile(assetInfo.fileExtension) eq "video">
			<cfset createThumbnailFromVideo(assetInfo) />--->
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
		<cfset assetInfo.fileName = "#own_filename#">
		<cfset assetInfo.asset_file_real_name = "#own_filename#">		
		<cffile action="rename" source="#assetInfo.uploadFolder##own_filename#" destination="#assetInfo.uploadFolder##assetInfo.fileName#">
		<cfset saveAssetMetaData(assetInfo) />
	</cffunction>
		
	<!--- UPLOAD LIVE FLASH VIDEO STREAM --->
	<cffunction name="uploadLiveFlvStream">
		<cfargument name="assetInfo" type="struct" />
			<cfset assetInfo.fileSize = -1 />
			<cfset assetInfo.fileName="#attributes.stream_name#.flv" />
			<cfset assetInfo.fileExtension = "flv" />
			<cfset assetInfo.isLive = true />
			<cfset assetInfo.asset_file_real_name = "#attributes.stream_name#.flv">
			<!--- insert AssetInfo --->
			<cfset saveAssetMetaData(assetInfo) />
	</cffunction>
	<!--- UPLOAD RECORDED FLASH VIDEO STREAM --->
<!---	<cffunction name="uploadRecordedFlvStream">
		<cfargument name="assetInfo" type="struct" />
			<cfset assetInfo.fileSize = getFileSize("#flashComServerApplicationsPath##dsn#\streams\_definst_\#attributes.stream_name#.flv") />
			<cffile action="move" source="#flashComServerApplicationsPath##dsn#\streams\_definst_\#attributes.stream_name#.flv" destination="#upload_folder#">
			<cfset assetInfo.fileName="#attributes.stream_name#.flv" />
			<cfset assetInfo.fileExtension = "flv" />
			<cfset assetInfo.asset_file_real_name = "#attributes.stream_name#.flv">
			<!--- create thumbnail --->
			<cfset createThumbnailFromVideo(assetInfo) />
			<!--- insert AssetInfo --->
			<cfset saveAssetMetaData(assetInfo) />
	</cffunction>--->
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
		<cfset assetInfo=structNew() />
		<cfset assetInfo.assetId="" />
		<cfset assetInfo.assetName=form.ASSET_NAME />
		<cfset assetInfo.assetDescription=form.ASSET_DESCRIPTION />
		<cfset assetInfo.assetKeywords=form.ASSET_DETAIL />
		
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
		<cfset assetInfo.filePath=""/>
		<cfset assetInfo.fileServerId=fusebox.server_machine />
		<cfset assetInfo.uploadFolder=getUploadFolder() />

		<cfif isdefined('attributes.module') and len(attributes.module)>
			<cfset assetInfo.moduleName=attributes.module />
		<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			<cfset assetInfo.moduleName="project" />
		<cfelse>
			<cfset assetInfo.moduleName="Asset" />
		</cfif>
		
		<cfif isdefined('attributes.module_id') and len(attributes.module_id)>
			<cfset assetInfo.moduleId=attributes.module_id />
		<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			<cfset assetInfo.moduleId=1 />
		<cfelse>
			<cfset assetInfo.moduleId=8 />
		</cfif>
		<cfif isdefined('attributes.action_section') and len(attributes.action_section)>
			<cfset assetInfo.actionSection=form.action_section />
		<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			<cfset assetInfo.actionSection="PROJECT_ID" />
		<cfelse>
			<cfset assetInfo.actionSection="Asset" />
		</cfif>
		
		<cfif isdefined('attributes.action_type') and attributes.action_type eq 0 and isdefined('attributes.action_id') and len(attributes.action_id)>
			<cfset assetInfo.actionId=form.action_id />
		<cfelseif isdefined('attributes.action_type') and attributes.action_type eq 1 and isdefined('attributes.action_id_2') and len(attributes.action_id_2)>
			<cfset assetInfo.actionId=form.action_id_2 />
		<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			<cfset assetInfo.actionId=attributes.project_id>
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
	<cffunction name="validate">
	<cfif not len("assetInfo.assetCategoryId")>
		<script type="text/javascript">
			alert("!!!<cf_get_lang no ='182.Lütfen ayarlar dan Elektronik Varlik Kategorisi Ekleyiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
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

	<cffunction name="getTypeOfUploadedFile" returntype="string">
		<cfargument name="fileExtension" required="no" type="string" default="" />
		<cfif isDefined("attributes.stream_name") and attributes.stream_name neq "">
			<cfreturn "recordedflvstream" />
		<cfelseif listFindNoCase('PNG,GIF,JPEG','#arguments.fileExtension#')>
			<cfreturn "image" />
		 <cfelseif listFindNoCase('FLV,WMV,AVI,MOV,MPG','#arguments.fileExtension#')>
			<cfreturn "video" />
		<cfelse>
			<cfreturn "file" />
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
		<cfset ilk_upload = "#upload_folder#">
		<cfif company_asset_relation eq 1>
			<cfif assetInfo.assetCategoryId lt 0>
				<cfif isdefined('attributes.action_id') and len(attributes.action_id)>
					<cfset add_folder = "#ilk_upload##get_upload_folder.assetcat_path##dir_seperator##year(now())##dir_seperator##attributes.action_id#">
                <cfelse>
                	<cfset add_folder = "#ilk_upload##get_upload_folder.assetcat_path##dir_seperator##year(now())#">
                </cfif>
			<cfelse>
            	<cfif isdefined('attributes.action_id') and len(attributes.action_id)>
					<cfset add_folder = "#ilk_upload#asset#dir_seperator##get_upload_folder.assetcat_path##dir_seperator##year(now())##dir_seperator##attributes.action_id#">
                <cfelse>
                	<cfset add_folder = "#ilk_upload#asset#dir_seperator##get_upload_folder.assetcat_path##dir_seperator##year(now())#">
                </cfif>
			</cfif>
            <cfif not directoryexists("#add_folder#")>
                <cfdirectory action="create" directory="#add_folder#">
            </cfif>
 		
			<cfset upload_folder = "#add_folder##dir_seperator#">
		<cfelse>
			<cfif assetInfo.assetCategoryId lt 0>
				<cfset upload_folder = "#ilk_upload##get_upload_folder.assetcat_path##dir_seperator#">
			<cfelse>
				<cfset upload_folder = "#ilk_upload#asset#dir_seperator##get_upload_folder.assetcat_path##dir_seperator#">
			</cfif>
		</cfif>
		<cfreturn upload_folder />
	</cffunction>

	<cffunction name="createThumbnailFromImage">
		<cfargument name="assetInfo" type="struct" required="yes" />

			<cftry>

				<cfset fileSystem.newFolder("#uploadFolder#","thumbnails") /> <!---upload folder --- /documents klasörü ---->
				<cfset fileSystem.newFolder("#uploadFolder#thumbnails","icon") />
				<cfset fileSystem.newFolder("#uploadFolder#thumbnails","middle") />

				<cfset imageOperations = CreateObject("Component","cfc.image_operations") />

				<cfloop from="1" to="#imageSettings.count()#" index="row">
					
					<cfset imageOperations.imageCrop(
															imagePath : "#assetInfo.uploadFolder##assetInfo.fileName#",
															imageThumbPath : "#uploadFolder#thumbnails/" & imageSettings[row]["folderName"] &"/#assetInfo.fileName#",
															imageCropType	:	1, <!--- Orantılı boyutlandır --->
															newWidth : #imageSettings[row]["newWidth"]#,
															newHeight : #imageSettings[row]["newHeight"]#
															) />

				</cfloop>

				<cfcatch type="any"></cfcatch>

			</cftry>
			
	</cffunction>
	<cffunction name="createThumbnailFromVideo">
		<cfargument name="assetInfo" type="struct" required="yes" />
		<cftry>
			<cfset thumbnail_name = replace(assetInfo.fileName,'.flv','.jpg')>
			<cfexecute name="#expandPath('/COM_MX/tools/ffmpeg.exe')#" arguments="-i ""#assetInfo.uploadFolder##assetInfo.fileName#"" -deinterlace -an -ss 3 -t 00:00:3 -r 1 -y -s 50x50 -vcodec mjpeg -f mjpeg ""#ilk_upload#thumbnails#dir_seperator##thumbnail_name#""" variable="output" timeout="30"/>
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
			<cfset session.imFile = assetInfo.fileName>
			<cfif assetInfo.fileExtension eq 'gif'>
				<cfx_WorkcubeImage NAME="image"
                       ACTION="rotate"
                       SRC="#assetInfo.uploadFolder##assetInfo.fileName#"
                       DST="#assetInfo.uploadFolder##assetInfo.fileName#"
                       PARAMETERS="0">
				<cfset session.imFile = listGetAt(session.imFile,1,".")&"."&"jpg">			
				<cfset assetInfo.fileExtension = 'jpg'>
				<cfset assetInfo.fileName = '#ListDeleteAt(assetInfo.fileName,ListLen(assetInfo.fileName,'.'),'.')#.#assetInfo.fileExtension#'>
			</cfif>
			<cfdirectory action="CREATE" directory="#session.imTempPath#">
			<cffile action="copy"
			  source="#assetInfo.uploadFolder##assetInfo.fileName#" 
			  destination="#session.imTempPath#">
		</cfif>
		   <cfcatch type="Any">
		   <cfoutput><b>#assetInfo.uploadFolder##assetInfo.fileName# -- #session.imTempPath#</b></cfoutput>
				<cfabort>
		   </cfcatch>
		</cftry>
	</cffunction>
	<cffunction name="saveAssetMetaData" description="All database operations to save AssetInfo object">
		<cfargument name="assetInfo" type="struct">
		<cflock name="#CREATEUUID()#" timeout="20">
			<cftransaction>
				<cfquery name="ADD_ASSET" datasource="#DSN#">
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
						<cfif (attributes.action_type eq 0)>
							ACTION_ID,
						<cfelseif attributes.action_type eq 1 and len(attributes.action_id_2)>
							ACTION_ID,
						<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
							ACTION_ID,
						<cfelse>
							ACTION_VALUE,
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
						<cfif (attributes.action_type eq 0)>
							#attributes.action_id#,
						<cfelseif attributes.action_type eq 1 and len(attributes.action_id_2)>
							#attributes.action_id_2#,
						<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
							#assetInfo.actionId#,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_id#">,
						</cfif>
						<!--- Action_Id alani cift cekildigi icin hataya sebep oldugundan degistirdim, dogrusunu bilen varsa duzeltsin FBS 20111010
						<cfif attributes.action_type eq 0>#attributes.action_id#<cfelse>'#attributes.action_id#'</cfif>,
						<cfif attributes.action_type eq 1 and len(attributes.action_id_2)>#attributes.action_id_2#,</cfif>
						<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#assetInfo.actionId#,</cfif>
						 --->
						#assetInfo.companyId#,
						#assetInfo.assetCategoryId#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.fileName#">,
						<cfif isdefined("assetInfo.asset_file_real_name")><cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.asset_file_real_name#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.fileName#"></cfif>,
                        <cfif isdefined('attributes.asset_path_name') and len(attributes.asset_path_name)>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_path_name#">,
                        </cfif>
						#ROUND(assetInfo.fileSize/1024)#,
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
						,<cfif isdefined("attributes.revision_no") and len(attributes.revision_no)>#attributes.revision_no#<cfelse>NULL</cfif>
                        ,<cfif isdefined("attributes.validate_start_date")>#attributes.validate_start_date#<cfelse>NULL</cfif>
                        ,<cfif isdefined("attributes.validate_finish_date")>#attributes.validate_finish_date#<cfelse>NULL</cfif>
						<cfif isdefined("attributes.related_company_id") and len(attributes.related_company_id)>,#attributes.related_company_id#</cfif>
						<cfif isdefined("attributes.related_consumer_id") and len(attributes.related_consumer_id)>,#attributes.related_consumer_id#</cfif>
						<cfif isdefined("attributes.related_asset_id") and len(attributes.related_asset_id)>,#attributes.related_asset_id#</cfif>
					)
				</cfquery>
				<cfquery name="GET_MAX_ID" datasource="#DSN#">
					SELECT MAX(ASSET_ID) AS MAX_ID FROM ASSET
				</cfquery>
				<cfif isdefined("attributes.is_dpl")>
					<cfinclude template="dpl_copy.cfm">
				</cfif>
						<!---<cf_workcube_process 
							is_upd='1'
							old_process_line='0'
							process_stage='#attributes.process_stage#' 
							record_member='#session.ep.userid#' 
							record_date='#now()#'
							action_table='ASSET'
							action_column='ASSET_ID'
							action_id='#GET_MAX_ID.MAX_ID#'
							action_page='#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#GET_MAX_ID.MAX_ID#&assetcat_id=#assetInfo.assetCategoryId#&nogoback=1'
							warning_description='Varlık : #attributes.asset_name#'>--->
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
							ASSET_RELATEDASSET_RELATED
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
			</cftransaction>
		</cflock>
	</cffunction>
	
	<cffunction name="sendMail" access="private" output="no">
        <cfif (isDefined('attributes.mail_receiver') and len(attributes.mail_receiver)) and ((isDefined('attributes.mail_receiver_emp_id') and len(attributes.mail_receiver_emp_id)) or (isDefined('attributes.mail_receiver_partner_id') and len(attributes.mail_receiver_partner_id)))>
            <cfquery name="GET_RECEIVER_MAIL" datasource="#DSN#">
                <cfif isdefined('attributes.mail_receiver_emp_id') and len(attributes.mail_receiver_emp_id)>
                    SELECT
                        EMPLOYEE_ID,
                        EMPLOYEE_EMAIL
                    FROM
                        EMPLOYEES
                    WHERE
                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mail_receiver_emp_id#">
                <cfelseif isdefined('attributes.mail_receiver_partner_id') and len(attributes.mail_receiver_partner_id)> 
                    SELECT 
                        PARTNER_ID,
                        COMPANY_PARTNER_EMAIL AS EMPLOYEE_EMAIL
                    FROM    
                        COMPANY_PARTNER 
                    WHERE   
                        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mail_receiver_partner_id#">
                </cfif>
            </cfquery>
            <cfset asset_receiver_email = get_receiver_mail.employee_email>
            
            <cfif (isDefined('attributes.mail_cc') and len(attributes.mail_cc)) and ((isDefined('attributes.mail_cc_emp_id') and len(attributes.mail_cc_emp_id)) or (isDefined('attributes.mail_cc_partner_id') and len(attributes.mail_cc_partner_id)))>
                <cfquery name="GET_CC_MAIL" datasource="#DSN#">
                    <cfif isdefined('attributes.mail_cc_emp_id') and len(attributes.mail_cc_emp_id)>
                        SELECT
                            EMPLOYEE_ID,
                            EMPLOYEE_EMAIL
                        FROM
                            EMPLOYEES
                        WHERE
                            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mail_cc_emp_id#">
                    <cfelseif isdefined('attributes.mail_cc_partner_id') and len(attributes.mail_cc_partner_id)> 
                        SELECT 
                            PARTNER_ID,
                            COMPANY_PARTNER_EMAIL AS EMPLOYEE_EMAIL
                        FROM    
                            COMPANY_PARTNER 
                        WHERE   
                            PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mail_cc_partner_id#">
                    </cfif>
                </cfquery>
                <cfset asset_cc_email = get_cc_mail.employee_email>
            <cfelse>
                <cfset asset_cc_email = "">
            </cfif>
            
            <cfif len(asset_receiver_email)>
                <cfsavecontent variable="mail_subject"><cf_get_lang no='191.Dijital Varlık Bildirimi'></cfsavecontent>
                <cfmail
                    to="#asset_receiver_email#"
                    cc="#asset_cc_email#"
                    from="#session.ep.company#<#session.ep.company_email#>"
                    subject="#mail_subject#" 
                    type="HTML">
                    <cfinclude template="send_asset_mail.cfm">
                </cfmail>
            </cfif>
        </cfif>
    </cffunction>​

	<!--- ADD ASSET using the functions above --->
	<cfscript>
		uploadFolder = application.systemParam.systemParam().upload_folder;
		session.imTempPath = "#upload_folder##createuuid()##dir_seperator#";
		session.resim = 1;
		ilk_upload = "#upload_folder#";
		// validate request, upload and save the asset
		validate();

		folder = "asset_preview/" & attributes.foldername;//dosyaların bulunduğu klasör
		
		if(directoryexists(uploadFolder & folder)){
			
			fileList = fileSystem.fileListinFolder(folderPath:folder);

			
			assetInfo = AssetInfoNew();
			
			function addAssetInfo(file) {
				
				createId = createUUID();
				assetInfo.fileSize = file.Size;
				assetInfo.fileExtension = ucase(ListLast(file.name,"."));
				assetInfo.fileName = createId & "." & assetInfo.fileExtension;
				assetInfo.asset_file_real_name = createId & "." & assetInfo.fileExtension;
				assetInfo.filePath = Replace(file.Directory,uploadFolder,"") & "/" & file.name;

			}

			if(fileList.recordCount gt 0){

				counter = 0;
				for (file in fileList) {
					
					if (isLiveFlvStream()) {
						uploadLiveFlvStream(assetInfo);
					}
					else if(isRecordedFlvStream()) 
					{
						//uploadRecordedFlvStream(assetInfo);
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
				//	sendMail();
					counter++;
					
					try{
						if(fileList.recordCount eq counter) fileSystem.deleteFolder(folder);//dosyaların bulunduğu klasörü siler.
					}catch (any cfcatch) {
					}
					
				}

			}else{
				
				WriteOutput('<script>alert("#getLang('assetcare',473)#!");</script>');

			}

		}else{
				
				WriteOutput('<script>alert("#getLang('assetcare',473)#! CODE:NOFOLDER");</script>');

			}

	</cfscript>
<!--- Video Çekimi --->	
<!----
<cfelse>
	<cfset assetInfo.assetCategoryId = attributes.ASSETCAT_ID>
	<cfset asset_file_name_ = listlast(attributes.asset_path_name,"/")>
	<cfset asset_thumbnail_name_ = replace(asset_file_name_,'.flv','','all')>
    <cfset fixed_asset_path_name = #replace(attributes.asset_path_name, ':/', '$/', 'all')#>
    <cfset fixed_asset_path_name = "\\#replacelist(fixed_asset_path_name, "/", "\")#">

	<cftry>
		<cfmodule template="convert_video.cfm" action="CreateThumb" inputfile="#fixed_asset_path_name#" outputfile="#upload_folder#thumbnails#dir_seperator##asset_thumbnail_name_#.jpg">
		<cfmodule template="convert_video.cfm" action="GetDuration" inputfile="#fixed_asset_path_name#" returnvariable="duration">
		<cfcatch type="any">
       	</cfcatch>
	</cftry>
    <cflock name="#CREATEUUID()#" timeout="20">
        <cftransaction>
        	<cfquery name="ADD_ASSET" datasource="#DSN#" result="MAX_ID">
                INSERT INTO 
                    ASSET
                (
                    PERIOD_ID,
                    ASSET_NO,
                    MODULE_NAME,
                    MODULE_ID,
                    ACTION_SECTION,
                    ACTION_ID,
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
                    RECORD_EMP,
                    RECORD_IP,
                    PROPERTY_ID,
                    ASSET_DESCRIPTION,
                    IS_LIVE,
                    FEATURED,
                    DURATION,
                    IS_IMAGE,
                    ASSET_STAGE,
                    SERVER_NAME,
                    IS_DPL,
                    IS_ACTIVE,
                    PRODUCT_ID,
                    REVISION_NO,
                    PROJECT_MULTI_ID,
                    RELATED_ASSET_ID
                )
                VALUES
                (
                    #session.ep.period_id#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_no#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="ASSET">,
                    8,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="ASSET">,
                    -1,
                    #session.ep.company_id#,
                    #attributes.ASSETCAT_ID#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#asset_file_name_#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#asset_file_name_#">,
                    <cfif isdefined('attributes.asset_path_name') and len(attributes.asset_path_name)>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_path_name#">,
                    <cfelse>
                        NULL,
                    </cfif>
                    0,
                    #fusebox.server_machine#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ASSET_NAME#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ASSET_DETAIL#">,
                    <cfif isdefined('attributes.is_internet') and attributes.is_internet eq 1>1<cfelse>0</cfif>,
                    #now()#,
                    #session.ep.userid#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                    #attributes.property_id#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ASSET_DESCRIPTION#">,
                    <cfif isdefined('attributes.isLive') and  attributes.isLive eq 1>1<cfelse>0</cfif>,
                    <cfif isdefined('attributes.featured') and  attributes.featured eq 1>1<cfelse>0</cfif>,
                    <cfif isdefined('duration') and len(duration)><cfqueryparam cfsqltype="cf_sql_varchar" value="#duration#"><cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.is_image") and attributes.is_image eq 1>1,<cfelse>0,</cfif>
                    <cfif isdefined('attributes.process_stage')>#attributes.process_stage#<cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(server_name)#">,
                    <cfif isdefined('attributes.is_dpl')>1<cfelse>0</cfif>,
                    <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.product_id") and isdefined("attributes.product_name") and len(attributes.product_id) and len(attributes.product_name)>#attributes.product_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.revision_no") and len(attributes.revision_no)>#attributes.revision_no#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.project_multi_id") and len(attributes.project_multi_id)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.project_multi_id#,"><cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.realted_asset_id") and len(attributes.realted_asset_id)>#attributes.realted_asset_id#</cfif>
                )
            </cfquery>
            <cfset GET_MAX_ID.MAX_ID = MAX_ID.IDENTITYCOL>
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
            <cfif isdefined('attributes.internet_view') and len(attributes.internet_view)>
                <cfquery name="ADD_INTERNET_VIEW" datasource="#DSN#">
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
                    <cfquery name="ADD_POSITION_CAT_IDS" datasource="#DSN#">
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
            
            <cfif isdefined('attributes.digital_asset_employees') and len(attributes.digital_asset_employees)>	
                <cfloop list="#attributes.digital_asset_employees#" index="asset_emp">
                    <cfquery name="ADD_USER_GROUP_IDS" datasource="#DSN#">
                        INSERT INTO
                            ASSET_RELATED
                            (
                                ASSET_ID,
                                EMP_PAR_ID,
                                MEMBER_TYPE
                            )
                            VALUES
                            (
                                #GET_MAX_ID.MAX_ID#,
                                #listfirst(asset_emp,';')#,
                                '#listlast(asset_emp,';')#'
                            )
                    </cfquery>
                </cfloop>
            </cfif>
            
            
            <cfif isdefined('attributes.is_internet') and attributes.is_internet eq 1>
                <cfquery name="GET_COMPANY" datasource="#DSN#">
                    SELECT 
                        MENU_ID,
                        SITE_DOMAIN,
                        OUR_COMPANY_ID
                    FROM 
                        MAIN_MENU_SETTINGS 
                </cfquery>
                <cfloop query="get_company">
                    <cfif isdefined("attributes.menu_#menu_id#")>
                        <cfquery name="ADD_ASSET_SITE_DOMAIN" datasource="#DSN#">
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
                </cfloop>
            </cfif>
        </cftransaction>
    </cflock>
	---->
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

<!---
<cfif isdefined('attributes.action_section') and len(attributes.action_section)>
	<script type="text/javascript">
		try
		{
			window.opener.reload_get_related_assets();	
		}
		catch(e)
		{
			wrk_opener_reload();
		}
		$('#reload_get_related_assets').css('background-color','red');
		window.close();
	</script>
<cfelseif isdefined("attributes.is_own_file") and isdefined("attributes.is_upd_detail")>
	<script type="text/javascript">
		window.opener.location='<cfoutput>#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#GET_MAX_ID.MAX_ID#&assetcat_id=#assetInfo.assetCategoryId#&nogoback=1</cfoutput>';
		window.close();
	</script>
<cfelseif isdefined("attributes.is_own_file")>
	<script type="text/javascript">
		alert('Döküman Kaydedildi');
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
        window.location.href='<cfoutput>#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#GET_MAX_ID.MAX_ID#&assetcat_id=#assetInfo.assetCategoryId#&nogoback=1</cfoutput>';
    </script>
</cfif>

--->

