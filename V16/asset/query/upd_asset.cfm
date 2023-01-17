
<cfif isdefined("attributes.change_revision") and len(attributes.change_revision) and attributes.change_revision eq 1>

	<cfinclude template="add_asset.cfm">

<cfelse>

<cfset uploadFolder = application.systemParam.systemParam().upload_folder>
<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>
<cfset asset_component = CreateObject("component","V16.asset.cfc.asset")>

<cf_date tarih='attributes.validate_start_date'>
<cf_date tarih='attributes.validate_finish_date'>
<cfset session.imTempPath = "#upload_folder##createuuid()##dir_seperator#">
<cfquery name="GET_OLD_FILE" datasource="#dsn#">

	SELECT 
		ASCAT.ASSETCAT_PATH,
		ASCAT.ASSETCAT_ID,
		ASSET.ASSET_FILE_NAME,
		ASSET.ASSET_FILE_REAL_NAME,
		ASSET.EMBEDCODE_URL

	FROM
		ASSET_CAT AS ASCAT,
		ASSET AS ASSET
	WHERE
		(ASCAT.ASSETCAT_ID = #attributes.old_asset_catid# and ASSET.ASSET_ID = #attributes.asset_id#) AND (ASCAT.ASSETCAT_ID = #attributes.old_asset_catid#)

</cfquery>

<cfset add_folder_ = "">

<cfif attributes.old_asset_catid lt 0>
	<cfset source_upload_folder = "#add_folder_#">
<cfelse>
	<cfset source_upload_folder = "#add_folder_#asset\">
</cfif>
<cfif not len(GET_OLD_FILE.embedcode_url)> <!--- embed kod olarak eklenmemişse dosya yolu değiştirme kısmına girecek. --->

	<cfif attributes.old_asset_catid neq attributes.assetcat_id><!--- Dosya yolu değişmişse --->
		
		<!--- Onceki klasor ve sonraki klasorlerin pathini bulmak icin eklendi --->
		
		<cfif attributes.assetcat_id lt 0>
			<cfset destination_upload_folder = "#uploadFolder##add_folder_#">
		<cfelse>
			<cfset destination_upload_folder = "#uploadFolder##add_folder_#asset\">
		</cfif>
		
		<!---  bir klasörden diğerine taşı --->
		<cfquery name="GET_NEW_FOLDER" datasource="#DSN#">
			SELECT ASSETCAT_PATH FROM ASSET_CAT WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetcat_id#">
		</cfquery>

		<cftry>
			<cfif not DirectoryExists("#destination_upload_folder##GET_NEW_FOLDER.ASSETCAT_PATH#")>
				<cfdirectory action="create" directory="#destination_upload_folder##GET_NEW_FOLDER.ASSETCAT_PATH#">
			</cfif>

			<cfset fileSystem.rename(filePath:"#source_upload_folder##GET_OLD_FILE.ASSETCAT_PATH##dir_seperator##attributes.asset_old_file#",
									newfilePath:"#destination_upload_folder##GET_NEW_FOLDER.ASSETCAT_PATH##dir_seperator##attributes.asset_old_file#") />

			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang no ='185.Dosyanız taşınamadı'> !");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
			
	</cfif>
</cfif>

<!--- Resim İşlemleri Başladı --->
<cfset session.resim = 1>
<cfquery name="GET_UPLOAD_FOLDER" datasource="#DSN#">
	SELECT 
		ASSETCAT_ID,
		ASSETCAT_PATH
	FROM
		ASSET_CAT
	WHERE
		ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetcat_id#">
</cfquery>
<cfif GET_UPLOAD_FOLDER.ASSETCAT_ID gte 0>
	<cfset path = GET_UPLOAD_FOLDER.ASSETCAT_PATH>
	<cfset folder="#add_folder_#asset#dir_seperator##path#">
<cfelse>
	<cfset folder="#add_folder_##GET_UPLOAD_FOLDER.ASSETCAT_PATH#">
</cfif>

<cfset pathFolder = "#uploadFolder##folder#">

<cfif (((isdefined('attributes.asset') and len(attributes.asset))) or (isdefined('attributes.stream_name') and len(attributes.stream_name)))>
	
<!--- belge upload edilir --->
	
		<cfif isDefined("attributes.stream_name") and attributes.stream_name neq "">
			<!---
			<cfset fileInstance = createObject("java","java.io.File").init(toString("#flashComServerApplicationsPath##attributes.stream_name#.flv")) />
			<cfif fileInstance.isFile()>
				<cfset filesize = fileInstance.length() />
			</cfif>
			<cffile action="move" source="#flashComServerApplicationsPath##attributes.stream_name#.flv" destination="#upload_folder##folder##dir_seperator#">
			<cf_del_server_file output_file="#old_folder##dir_seperator##attributes.asset_old_file#" output_server="#attributes.asset_file_server_id#">
			<cfset file_name="#attributes.stream_name#" />
			<cfset serverfileext = "flv" />
			<cftry>
				<cf_wrk_video action="createthumb" inputfile="#upload_folder##folder##dir_seperator##file_name#.#serverfileext#" outputfile="#upload_folder##dir_seperator#thumbnails#dir_seperator##file_name#.jpg" returnvariable="image_file">
				<cfcatch type="any"></cfcatch>
			</cftry>
			--->
		<cfelse>
			
			<cfif isdefined('attributes.asset') and len(attributes.asset)>

				<cfif not DirectoryExists("#upload_folder##folder##dir_seperator#")>
					<cfdirectory action="create" directory="#upload_folder##folder##dir_seperator#">
				</cfif>
				<cfset fileUploadFolder = "#upload_folder##folder##dir_seperator#" />
				<!---- Dosyayı yükler --->
				<cffile action = "upload" 
						filefield = "asset" 
						destination = "#fileUploadFolder#" 
						nameconflict = "MakeUnique" 
						mode="777">		

				<!--- Dosya yükleme kriterlerine göre dosyayı kontrol eder. --->
				<cfset suitableFile = fileSystem.fileControl(filePath:fileUploadFolder,file:file) >

				<cfif suitableFile["status"] eq true>
				
					<cfset assetInfo = structNew() />
					<cfset assetInfo.uploadFolder = "#upload_folder##folder##dir_seperator#" />
					<cfset assetInfo.fileName = createUUID() />
					<cfset assetInfo.fileExtension = ucase(cffile.serverfileext) />
					<cfset assetInfo.fileFullName = "#assetInfo.fileName#.#assetInfo.fileExtension#" />
					<cfset assetInfo.fileSize = cffile.filesize/>
					<cfset assetInfo.asset_file_real_name = cffile.serverfile />
					<cfset assetInfo.assetTypeName = listlast(cffile.serverfile,'.') />

					<!--- Dosyayı yeniden adlandırır. --->
					<cffile action="rename" source="#fileUploadFolder##cffile.serverfile#" destination="#fileUploadFolder##assetInfo.fileName#.#assetInfo.fileExtension#">
				
					<cfset fileSystem.delete("#source_upload_folder#/#get_old_file.ASSET_FILE_NAME#") /><!--- Eski dosyayı siler --->
					<cfset fileSystem.delete("thumbnails/middle/#attributes.asset_old_file#") /><!--- Eski thumbnaili thumbnails/middle dan siler --->
					<cfset fileSystem.delete("thumbnails/icon/#attributes.asset_old_file#") /><!--- Eski thumbnaili thumbnails/icon dan siler --->

					<!--- Dosya tipini kontrol eder --->
					<cfif fileSystem.fileType(assetInfo.fileExtension)["fileType"] eq "image">

						<!--- Fotoğraf için thumbnail oluşturur --->
						<cfset asset_component.createThumbnailFromImage(assetInfo : assetInfo) /><!--- Fotoğraf thumbnail ---->

					</cfif>

				<cfelse>

					<script type="text/javascript">
						alert('<cfoutput>#suitableFile["message"]#</cfoutput>');
						history.back();
					</script>

				</cfif>

			</cfif>

		</cfif>
		
	
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_ASSET" datasource="#dsn#">
			UPDATE 
				ASSET
			SET
				<!--- neden eklendi anlayamadım , diğer yerlerden çağrıldığında null attığı için sorun oluyor SM 20110425 ACTION_SECTION = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>'PROJECT_ID'<cfelseif isdefined('attributes.action_section') and len(attributes.action_section) and attributes.action_section is 'CONTENT_ID'>'CONTENT_ID'<cfelse>NULL</cfif>,
				ACTION_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelseif isdefined('attributes.action_section') and len(attributes.action_section) and attributes.action_section is 'CONTENT_ID'>#attributes.action_id#<cfelse>NULL</cfif>, --->
				ASSET_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_no#">,
				ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.assetcat_id#">,
				<cfif (((isdefined('attributes.asset') and len(attributes.asset))) or (isdefined('attributes.stream_name') and len(attributes.stream_name)))>
					ASSET_FILE_REAL_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.asset_file_real_name#">,
					ASSET_FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetInfo.fileFullName#">,
					ASSET_FILE_SIZE = #ROUND(assetInfo.fileSize/1024)#,
					ASSET_FILE_SERVER_ID=#fusebox.server_machine#,
				</cfif>
				ASSET_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ASSET_NAME#">,
				PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
				PROJECT_MULTI_ID = <cfif isdefined("attributes.project_multi_id") and len(attributes.project_multi_id)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.project_multi_id#,"><cfelse>NULL</cfif>,
				ASSET_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ASSET_DETAIL#">,
				<!--- ASSET_FILE_PATH_NAME=<cfif isdefined('attributes.asset_path_name') and len(attributes.asset_path_name)>#attributes.asset_path_name#,<cfelse>NULL,</cfif>--->
				IS_INTERNET = <cfif isdefined("attributes.is_internet")>1,<cfelse>0,</cfif>
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				PROPERTY_ID = #attributes.property_id#,
				DEPARTMENT_ID = #listfirst(session.ep.user_location,'-')#,
				BRANCH_ID =	#listgetat(session.ep.user_location,2,'-')#,
				IS_LIVE = <cfif isdefined("attributes.is_live")>1,<cfelse>0,</cfif>
				FEATURED = <cfif isdefined("attributes.featured")>1<cfelse>0</cfif>,
				IS_SPECIAL = <cfif isdefined("attributes.is_special")>1,<cfelse>0,</cfif>
				ASSET_DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ASSET_DESCRIPTION#">,
				<cfif len(attributes.process_stage)>
					ASSET_STAGE = #attributes.process_stage#,
				</cfif>
				<cfif isdefined('mail_receiver_emp_id') and len(mail_receiver_emp_id) and len(mail_receiver)>
					MAIL_RECEIVER_ID = #mail_receiver_emp_id#,
					MAIL_RECEIVER_IS_EMP = 1,
				<cfelseif isdefined('mail_receiver_partner_id') and len(mail_receiver_partner_id) and len(mail_receiver)>
					MAIL_RECEIVER_ID = #mail_receiver_partner_id#,
					MAIL_RECEIVER_IS_EMP = 0,
				<cfelse>
					MAIL_RECEIVER_ID = NULL,
					MAIL_RECEIVER_IS_EMP = NULL,
				</cfif>
				<cfif isdefined('mail_cc_emp_id') and len(mail_cc_emp_id) and len(mail_cc)>
					MAIL_CC_ID = #mail_cc_emp_id#,
					MAIL_CC_IS_EMP = 1,
				<cfelseif isdefined('mail_cc_partner_id') and len(mail_cc_partner_id) and len(mail_cc)>
					MAIL_CC_ID = #mail_cc_partner_id#,
					MAIL_CC_IS_EMP = 0,
				<cfelse>
					MAIL_CC_ID = NULL,
					MAIL_CC_IS_EMP = NULL,
				</cfif>
				PRODUCT_ID = <cfif isdefined('attributes.product_id') and len(attributes.product_id) and len(attributes.product_name)>#attributes.product_id#<cfelse>NULL</cfif>,
				IS_DPL = <cfif isdefined("attributes.is_dpl") and len(attributes.is_dpl)>1<cfelse>0</cfif>,
				REVISION_NO = <cfif isdefined("attributes.revision_no") and len(attributes.revision_no)>#attributes.revision_no#<cfelse>NULL</cfif>,
				LIVE = <cfif isdefined("attributes.live") and len(attributes.live)>1<cfelse>0</cfif>,
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
                VALIDATE_START_DATE = <cfif Len(attributes.validate_start_date)>#attributes.validate_start_date#<cfelse>NULL</cfif>,
                VALIDATE_FINISH_DATE = <cfif Len(attributes.validate_finish_date)>#attributes.validate_finish_date#<cfelse>NULL</cfif>,
				EMBEDCODE_URL = <cfif isdefined("attributes.embcode") and len(attributes.embcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.embcode#"><cfelse>NULL</cfif>
			WHERE
				ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
		</cfquery>

		<!--- iliskili belgelerde update edilir --->
		<cfquery name="get_asset" datasource="#dsn#">
			SELECT * FROM ASSET WHERE ASSET_ID = #attributes.ASSET_ID#
		</cfquery>
		
		<!--- iliskili belgelerde update edilir --->
		<cfquery name="upd_" datasource="#dsn#">
			UPDATE
				ASSET
			SET
				ASSET_FILE_REAL_NAME = '#get_asset.ASSET_FILE_REAL_NAME#',
				ASSET_FILE_NAME = '#get_asset.ASSET_FILE_NAME#',
				<cfif len(get_asset.asset_file_size)>
					ASSET_FILE_SIZE = #get_asset.ASSET_FILE_SIZE#,
				</cfif>
				ASSET_FILE_SERVER_ID=#get_asset.ASSET_FILE_SERVER_ID#,
				ASSET_FILE_PATH_NAME = '#get_asset.ASSET_FILE_PATH_NAME#',
				ASSETCAT_ID = #get_asset.ASSETCAT_ID#
			WHERE
				ASSET_FILE_NAME = '#attributes.asset_old_file#'
		</cfquery>
		
		<cfif isdefined("attributes.is_dpl")>
			<cfinclude template="dpl_copy.cfm">
		</cfif> 
		
		<cfif(((isdefined('attributes.mail_receiver') and len(attributes.mail_receiver)) and ((isdefined('attributes.mail_receiver_emp_id') and len(attributes.mail_receiver_emp_id)) or (isdefined('attributes.mail_receiver_partner_id') and len(attributes.mail_receiver_partner_id)))) or (isdefined('attributes.mail_cc') and len(attributes.mail_cc) and (isdefined("attributes.mail_cc_emp_id") and len(attributes.mail_cc_emp_id)) or (isdefined("attributes.mail_cc_partner_id") and len(attributes.mail_cc_partner_id))))>
			<cfsavecontent variable="mail_logo"><cfinclude template="../../objects/display/view_company_logo.cfm"></cfsavecontent>
			<cfscript>
				asset_component.sendMail(
					mail_receiver : "#iif(isdefined('attributes.mail_receiver') and len(attributes.mail_receiver),"attributes.mail_receiver",DE(''))#", 
					mail_receiver_emp_id :  "#iif(isdefined('attributes.mail_receiver_emp_id') and len(attributes.mail_receiver_emp_id),'attributes.mail_receiver_emp_id',DE(''))#",
					mail_receiver_partner_id : "#iif(isdefined('attributes.mail_receiver_partner_id') and len(attributes.mail_receiver_partner_id),'attributes.mail_receiver_partner_id',DE(''))#",
					mail_cc :  "#iif(isdefined('attributes.mail_cc') and len(attributes.mail_cc),'attributes.mail_cc',DE(''))#",
					mail_cc_emp_id : "#iif(isdefined('attributes.mail_cc_emp_id') and len(attributes.mail_cc_emp_id),'attributes.mail_cc_emp_id',DE(''))#",
					mail_cc_partner_id : "#iif(isdefined('attributes.mail_cc_partner_id') and len(attributes.mail_cc_partner_id),'attributes.mail_cc_partner_id',DE(''))#",
					lang_digitalasset : "Dijital Varlık Bildirimi",
					asset_id : "#iif(isdefined('attributes.asset_id') and len(attributes.asset_id),'attributes.asset_id',DE(''))#",
					user_domain : "#application.systemParam.systemParam().fusebox.server_machine_list#",
					mail_logo : mail_logo
				);
			</cfscript>

		</cfif>
		<cfif len(attributes.process_stage)>
			<cf_workcube_process 
				is_upd='1' 
				old_process_line='#attributes.old_process_line#'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#'
				record_date='#now()#'
				action_table='ASSET'
				action_column='ASSET_ID'
				action_id='#attributes.ASSET_ID#' 
				action_page='#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#attributes.ASSET_ID#&assetcat_id=#attributes.ASSETCAT_ID#'
				warning_description='Varlık : #attributes.ASSET_NAME#'>
		</cfif>
		<cfquery name="del_site_domain" datasource="#dsn#">
			DELETE FROM ASSET_SITE_DOMAIN WHERE ASSET_ID=#attributes.asset_id#
		</cfquery>
		<cfquery name="del_asset_related" datasource="#dsn#">
			DELETE FROM ASSET_RELATED WHERE ASSET_ID = #attributes.asset_id#
		</cfquery>
		<cfif isdefined('attributes.comp_cat') and listlen(attributes.comp_cat)>
			<cfloop list="#attributes.comp_cat#" index="comp_">
				<cfquery name="add_company_cat_id" datasource="#dsn#">
					INSERT INTO
						ASSET_RELATED
						(	
							ASSET_ID,
							COMPANY_CAT_ID
						)
						VALUES
						(
							#attributes.asset_id#,
							#comp_#
						)
				</cfquery>
			</cfloop>
		</cfif>
		<cfif isdefined('attributes.customer_cat') and listlen(attributes.customer_cat)>
			<cfloop list="#attributes.customer_cat#" index="customer_">
				<cfquery name="add_customer_cat" datasource="#dsn#">
					INSERT INTO
						ASSET_RELATED
						(
							ASSET_ID,
							CONSUMER_CAT_ID
						)
						VALUES
						(
							#attributes.asset_id#,
							#customer_#	
						)
				</cfquery>
			</cfloop>
		</cfif>
		<cfif isdefined('attributes.position_cat_ids') and len(attributes.position_cat_ids)>
			<cfloop list="#attributes.position_cat_ids#" index="position_cat">
				<cfquery name="add_position_cat_ids" datasource="#dsn#">
					INSERT INTO
						ASSET_RELATED
						(
							ASSET_ID,
							POSITION_CAT_ID
						)
						VALUES
						(
							#attributes.asset_id#,
							#position_cat#
						)
				</cfquery>
			</cfloop>
		</cfif>
			
		<cfif isdefined('attributes.user_group_ids') and len(attributes.user_group_ids)>	
			<cfloop list="#attributes.user_group_ids#" index="user_group">
				<cfquery name="add_user_group_ids" datasource="#dsn#">
					INSERT INTO
						ASSET_RELATED
						(
							ASSET_ID,
							USER_GROUP_ID
						)
						VALUES
						(
							#attributes.asset_id#,
							#user_group#
						)
				</cfquery>
			</cfloop>
		</cfif>
			
		<cfif isdefined('attributes.employee_view') and len(attributes.employee_view)>	
			<cfquery name="add_all" datasource="#dsn#">
				INSERT INTO
					ASSET_RELATED
					(
						ASSET_ID,
						ALL_EMPLOYEE
					)
					VALUES
					(
						#attributes.asset_id#,
						1
					)
			</cfquery>
		</cfif>
			
		<cfif isdefined('attributes.all_people') and len(attributes.all_people)>	
			<cfquery name="add_all" datasource="#dsn#">
				INSERT INTO
					ASSET_RELATED
					(
						ASSET_ID,
						ALL_PEOPLE
					)
					VALUES
					(
						#attributes.asset_id#,
						1
					)
			</cfquery>
		</cfif>
			
		<cfif isdefined('attributes.internet_view')>
			<cfquery name="add_internet_view" datasource="#dsn#">
				INSERT INTO
					ASSET_RELATED
					(
						ASSET_ID,
						ALL_INTERNET
					)
					VALUES
					(
						#attributes.asset_id#,
						1
					)
			</cfquery>
		</cfif>
		<cfif isdefined('attributes.career_view')>
			<cfquery name="add_career_view" datasource="#dsn#">
				INSERT INTO
					ASSET_RELATED
					(
						ASSET_ID,
						ALL_CAREER
					)
					VALUES
					(
						#attributes.asset_id#,
						1
					)
			</cfquery>
		</cfif>
			
		<cfif isdefined('attributes.digital_assets') and len(attributes.digital_assets)>	
			<cfloop list="#attributes.digital_assets#" index="digital_asset_group">
				<cfquery name="add_digital_asset_group_ids" datasource="#DSN#">
					INSERT INTO
						ASSET_RELATED
						(
							ASSET_ID,
							DIGITAL_ASSET_GROUP_ID
						)
						VALUES
						(
							#attributes.asset_id#,
							#digital_asset_group#
						)
				</cfquery>
			</cfloop>
		</cfif>
			
		<cfif isdefined("attributes.is_internet")>
			<cfquery name="get_company" datasource="#dsn#">
				SELECT 
					MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID
				FROM 
					MAIN_MENU_SETTINGS 
			</cfquery>
			<cfoutput query="get_company">
				<cfif isdefined("attributes.menu_#menu_id#")>
					<cfquery name="asset_site_domain" datasource="#dsn#">
						INSERT INTO
							ASSET_SITE_DOMAIN
							(
								ASSET_ID,		
								SITE_DOMAIN
							)
						VALUES
							(
								#attributes.ASSET_ID#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes['menu_#menu_id#']#">
							)	
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>
	</cftransaction>
</cflock>

<cfset session.imPath = upload_folder>
<cfif isdefined('attributes.action_section') and len(attributes.action_section)>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		
        window.location.href='<cfoutput>#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#attributes.ASSET_ID#&assetcat_id=#attributes.ASSETCAT_ID#</cfoutput>';
    </script>
	<!---<cflocation url="#request.self#?fuseaction=asset.form_upd_asset&asset_id=#attributes.ASSET_ID#&assetcat_id=#attributes.ASSETCAT_ID#" addtoken="no">--->
</cfif>
</cfif><!--- change_revision --->

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
				ASSET_ID = #attributes.asset_id#
</cfquery>