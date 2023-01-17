<cfparam name="attributes.page" default=1>
<cfparam name="attributes.startrow" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.asset_cat_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_view" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.property_id" default="">
<cfparam name="attributes.record_par_id" default="">
<cfparam name="attributes.record_member" default="">
<cfparam name="attributes.record_date1" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.validate_date1" default="">
<cfparam name="attributes.validate_date2" default="">
<cfparam name="attributes.validate_date3" default="">
<cfparam name="attributes.validate_date4" default="">
<cfparam name="attributes.sort_type" default="1">
<cfparam name="attributes.x_show_by_digital_asset_group" default="0">
<cfset x_show_by_digital_asset_group = attributes.x_show_by_digital_asset_group>
<cfparam name="attributes.x_dont_show_file_by_digital_asset_group" default="0">
<cfset x_dont_show_file_by_digital_asset_group = attributes.x_dont_show_file_by_digital_asset_group>
<cfif isdefined("attributes.record_date1") and isdate(attributes.record_date1)><cf_date tarih = "attributes.record_date1"></cfif>
<cfif isdefined("attributes.record_date2") and isdate(attributes.record_date2)><cf_date tarih = "attributes.record_date2"></cfif>
<cfif isdefined("attributes.validate_date1") and isdate(attributes.validate_date1)><cf_date tarih = "attributes.validate_date1"></cfif>
<cfif isdefined("attributes.validate_date2") and isdate(attributes.validate_date2)><cf_date tarih = "attributes.validate_date2"></cfif>
<cfif isdefined("attributes.validate_date3") and isdate(attributes.validate_date3)><cf_date tarih = "attributes.validate_date3"></cfif>
<cfif isdefined("attributes.validate_date4") and isdate(attributes.validate_date4)><cf_date tarih = "attributes.validate_date4"></cfif>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1 >

<cfset uploadFolder = application.systemParam.systemParam().upload_folder />
<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system") />
<cfset imageOperations = CreateObject("Component","cfc.image_operations") />

<cfquery name="GET_POSITION_COMPANIES" datasource="#DSN#">
    SELECT DISTINCT
        SP.OUR_COMPANY_ID,
        O.NICK_NAME
    FROM
        EMPLOYEE_POSITIONS EP,
        SETUP_PERIOD SP,
        EMPLOYEE_POSITION_PERIODS EPP,
        OUR_COMPANY O
    WHERE 
        SP.OUR_COMPANY_ID = O.COMP_ID AND
        SP.PERIOD_ID = EPP.PERIOD_ID AND
        EP.POSITION_ID = EPP.POSITION_ID AND
        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	ORDER BY
		O.NICK_NAME
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%asset.list_asset%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_COMPANY_SITES" datasource="#DSN#">
	SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL ORDER BY SITE_DOMAIN
</cfquery>
<cfinclude template="../../asset/query/get_assets.cfm">
<cfquery name="FORMAT" datasource="#dsn#">
	SELECT FORMAT_SYMBOL FROM SETUP_FILE_FORMAT ORDER BY FORMAT_SYMBOL
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_ASSETS.recordcount#">

<cfset mediaplayer_extensions = ".asf,.wma,.avi,.mp3,.mp2,.mpa,.mid,.midi,.rmi,.aif,.aifc,aiff,.au,.snd,.wav,.cda,.wmv,.wm,.dvr-ms,.mpe,.mpeg,.mpg,.m1v,.vob" />
	
	<cfif get_assets.recordcount>
			<cfset get_emp_list = ''>
			<cfset get_cons_list = ''>
			<cfset get_par_list = ''>
			<cfset get_emp_list_2 = ''>
			<cfset get_cons_list_2 = ''>
			<cfset get_par_list_2 = ''>
			<cfset property_list = ''>
			<cfset page_id_list = ''>
			<cfset project_list = ''>
			<cfoutput query="get_assets">
				<cfif len(record_emp) and not listfind(get_emp_list,record_emp)>
					<cfset get_emp_list=listappend(get_emp_list,record_emp)>
				</cfif>
				<cfif len(record_pub) and not listfind(get_cons_list,record_pub)>
					<cfset get_cons_list=listappend(get_cons_list,record_pub)>
				</cfif>
				<cfif len(record_par) and not listfind(get_cons_list,record_par)>
					<cfset get_par_list=listappend(get_par_list,record_par)>
				</cfif>
				<cfif len(property_id) and not listfind(property_list,property_id)>
					<cfset property_list=listappend(property_list,property_id)>
				</cfif>
				<cfif isdefined("project_id") and len(project_id) and not listfind(project_list,project_id)>
					<cfset project_list=listappend(project_list,project_id)>
				</cfif>
				<cfif isdefined("project_multi_id") and len(project_multi_id) and not listfind(project_list,project_id)>
					<cfset project_list=listappend(project_list,mid(project_multi_id,2,len(project_multi_id)-2))>
				</cfif>
			</cfoutput>		
			<cfif len(get_emp_list)>
				<cfquery name="GET_EMP" datasource="#DSN#">
					SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#get_emp_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset get_emp_list_2 = listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(get_cons_list)>
				<cfquery name="GET_CONS" datasource="#DSN#">
					SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#get_cons_list#) ORDER BY CONSUMER_ID
				</cfquery>
				<cfset get_cons_list_2 = listsort(listdeleteduplicates(valuelist(get_cons.consumer_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(get_par_list)>
				<cfquery name="GET_PAR" datasource="#DSN#">
					SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#get_par_list#) ORDER BY PARTNER_ID
				</cfquery>
				<cfset get_par_list_2 = listsort(listdeleteduplicates(valuelist(get_par.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(property_list)>
				<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
					SELECT CONTENT_PROPERTY_ID,NAME FROM CONTENT_PROPERTY WHERE CONTENT_PROPERTY_ID IN (#property_list#) ORDER BY CONTENT_PROPERTY_ID
				</cfquery> 
				<cfset property_list = listsort(listdeleteduplicates(valuelist(get_content_property.content_property_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(project_list)>
				<cfquery name="GET_PROJECT_NAME" datasource="#DSN#">
					SELECT PROJECT_NUMBER,PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_list#) ORDER BY PROJECT_ID
				</cfquery> 
				<cfset project_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfset i = "1">
			
			<cfoutput query="get_assets">
			
            	<cfif assetcat_id gte 0>
					<cfset path_ = "asset/#assetcat_path#">
                <cfelse>
                    <cfset path_ = "#assetcat_path#">
                </cfif>
                <cfif company_asset_relation eq 1>
					<cfif len(get_assets.related_asset_id)>
                        <cfquery name="getAssetRelated" datasource="#DSN#">
                            SELECT ACTION_ID,RECORD_DATE FROM ASSET WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assets.related_asset_id#">
                        </cfquery>
                        <cfif len(getAssetRelated.action_id)>
                            <cfset url_ = "#file_web_path#/#path_#/#year(getAssetRelated.record_date)#/#getAssetRelated.action_id#/">
		                    <cfset path = "#upload_folder##path_##dir_seperator##year(getAssetRelated.record_date)##dir_seperator##getAssetRelated.action_id##dir_seperator#">
                        <cfelse>
                            <cfset url_ = "#file_web_path#/#path_#/#year(get_assets.record_date)#/">
		                    <cfset path = "#upload_folder##path_##dir_seperator##year(get_assets.record_date)##dir_seperator#">
                        </cfif>
                    <cfelseif len(get_assets.action_id)>
                        <cfset url_ = "#file_web_path#/#path_#/#year(get_assets.record_date)#/#get_assets.action_id#/">
	                    <cfset path = "#upload_folder##path_##dir_seperator##year(get_assets.record_date)##dir_seperator##get_assets.action_id##dir_seperator#">
                    <cfelse>
                        <cfset url_ = "#file_web_path#/#path_#/#year(get_assets.record_date)#/">
	                    <cfset path = "#upload_folder##path_##dir_seperator##year(get_assets.record_date)##dir_seperator#">
                    </cfif>
                <cfelse>
					<cfset url_ = "#file_web_path#/#path_#/">
                    <cfset path = "#upload_folder##path_##dir_seperator#">
                </cfif>

				<cfset file_path = '#path##asset_file_name#'>
				<cfset rm = '#chr(13)#'>
				<cfset desc = ReplaceList(description,rm,'')>
				<cfset rm = '#chr(10)#'>
				<cfset desc = ReplaceList(desc,rm,'')>
				<cfif desc is ''><cfset desc = 'image'></cfif>
				<cfif not isDefined("attributes.asset_archive")>
					<cfif assetcat_id gte 0>
						<cfset file_add_ = "asset/">
					<cfelse>
						<cfset file_add_ = "">
					</cfif>
				</cfif>

				<cfset file_size = "#asset_file_size# KB">
				<cfif isdefined("attributes.fuseaction") and attributes.fuseaction eq 'asset.tv'>	
					<cfset file_size = "#wrk_round(asset_file_size/0.9765625,2)# MB"> 
				</cfif>
				<cfscript>
					file_icon = "<i class='catalyst-cloud-download'></i>";
					ext = lcase(listlast(asset_file_name, '.'));
					icon = false;
					fileType = "";
					mimeType = "";
					videoConter = 0;
					imagePath = "";

					if(FileExists(file_path)){

						fileSysType = fileSystem.fileType(ext);
						fileType = fileSysType["fileType"];
						
						if(fileSysType["fileType"] eq "document" or fileSysType["fileType"] eq "other"){

							imagePath = "css/assets/icons/catalyst-icon-svg/#ext#.svg";
							icon = true;

						}else if(fileSysType["fileType"] eq "video"){

							imagePath = url_ & asset_file_real_name & "##t=1";
							fileType = "video";

							if (ext eq "mp4"){
								mimeType = "video/mp4";
							}else if(ext eq "mpeg"){
								mimeType = "video/mpeg";
							}
							
						}else if(fileSysType["fileType"] eq "audio"){

							imagePath = url_ & asset_file_name;
							fileType = "audio";

							if (ext eq "ogg"){
								mimeType = "audio/ogg";
							}else if(ext eq "mp3"){
								mimeType = "audio/mpeg";
							}else if(ext eq "wav"){
								mimeType = "audio/wav";
							}

						}else if(fileSysType["fileType"] eq "image"){

							if(FileExists("#upload_folder#thumbnails/middle/#asset_file_name#")){
								
								imagePath = "documents/thumbnails/middle/#asset_file_name#";

							}else{
								
								fileSystem.newFolder("#uploadFolder#","thumbnails"); ///upload folder --- /documents klasörü
								fileSystem.newFolder("#uploadFolder#thumbnails","icon");
								fileSystem.newFolder("#uploadFolder#thumbnails","middle");

								imageOperations.imageCrop(
													imagePath : "#file_path#",
													imageThumbPath : "#upload_folder#thumbnails/icon/#asset_file_name#",
													imageCropType	:	1, ///Orantılı boyutlandır
													newWidth :128,
													newHeight : 128
													);
								imageOperations.imageCrop(
													imagePath : "#file_path#",
													imageThumbPath : "#upload_folder#thumbnails/middle/#asset_file_name#",
													imageCropType	:	1, ///Orantılı boyutlandır
													newWidth :1024,
													newHeight : 512
													);

								imagePath = "documents/thumbnails/middle/#asset_file_name#";

							}
							
						}else{

							icon = true;

						}

					}
					
					else{
						if(isdefined("get_assets.EMBEDCODE_URL") and len(get_assets.EMBEDCODE_URL))
						{	
							if(get_assets.EMBEDCODE_URL contains 'docs.google.com/spreadsheets'){
								imagePath = "css/assets/icons/catalyst-icon-svg/XLS.svg" ;
								icon = true;
							}								
							else if (get_assets.EMBEDCODE_URL contains 'docs.google.com/document'){
								imagePath = "css/assets/icons/catalyst-icon-svg/DOC.svg" ;
								icon = true;
							}								
							else if (get_assets.EMBEDCODE_URL contains 'docs.google.com/forms'){
								imagePath = "css/assets/icons/catalyst-icon-svg/RTF.svg" ;
								icon = true;
							}								
							else if (get_assets.EMBEDCODE_URL contains 'docs.google.com/presentation'){
								imagePath = "css/assets/icons/catalyst-icon-svg/PPT.svg" ;
								icon = true;
							}								
							else if (get_assets.EMBEDCODE_URL contains 'iframe'){
								imagePath = "#get_assets.EMBEDCODE_URL#";
								fileType = "embed";
							}
							else{
								imagePath = "css/assets/icons/catalyst-icon-svg/UNKOWN.svg" ;
								icon = true;
							}												
								file_icon = "<i class='catalyst-eye'></i>";
								
						}
						else{
						imagePath = "/images/intranet/no-image.png";
						icon = true;
						}
					}

					data[#i#] = {
						assetid			:	'#asset_id#',
						assetcatid		:	'#assetcat_id#',
						assetcat		:	'#assetcat#',
						icon			:	icon,
						doctype			:	(len(property_list) ? '#get_content_property.name[listfind(property_list,property_id,',')]#' : ''),
						validity_date	:	(len(validity_date) ? "#dateformat(validity_date,dateformat_style)#" : ""),
						revision_date	:	(len(revision_date) ? "#dateformat(revision_date,dateformat_style)#" : ""),
						file_icon       :   file_icon,
						file			:	{

											asset_name		:	"#asset_name#",
											fileType		:	fileType,
											mimeType		:	mimeType,
											title			:	"#asset_file_real_name#",
											fileurl			:	"#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#asset_id#&assetcat_id=#assetcat_id#",
											image			:	"#imagePath#",
											ext				:	"#ext#",
											fileSize		:	"#file_size#"
												
						},				
						date			:	"#dateformat(record_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#"				

					};

					if(live eq 1){
						
						data[#i#]["ASSETNO"] = '(G)#asset_no#' & ((revision_no neq 0) ? '-#revision_no#' : '');

					}else{

						data[#i#]["ASSETNO"] = '#asset_no#' & ((revision_no neq 0) ? '-#revision_no#' : '');

					}

					if(isdefined("get_assets.EMBEDCODE_URL") and len(get_assets.EMBEDCODE_URL)){
						data[#i#]["FILE"]["FILEPATH"]	=	'#get_assets.EMBEDCODE_URL#';
					}
					else if(fileType eq "video"){

						if(len(asset_file_path_name)){

							 my_video_file_path = #asset_file_path_name#;

						}else{

							my_video_file_path = '/documents/#file_add_##assetcat_path#/#asset_file_name#';

						}

						data[#i#]["FILE"]["FILEPATH"]	=	'index.cfm?fuseaction=objects.popup_flvplayer&video=#my_video_file_path#&ext=#ext#&content_id=#asset_id#';
						data[#i#]["FILE"]["FILEPOPTYPE"]	=	'video';

					}					
					else{

						data[#i#]["FILE"]["FILEPATH"]	=	'#request.self#?fuseaction=objects.popup_download_file&' & ((ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif") ? 'direct_show=1&' : '') & 'file_name=#url_##asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#';
						data[#i#]["FILE"]["FILEPOPTYPE"]	=	'medium';

					}
					
					if (len(record_emp)){
						
						data[#i#]["USER"]["USERNAME"]		=	"#get_emp.employee_name[listfind(get_emp_list_2,record_emp,',')]# #get_emp.employee_surname[listfind(get_emp_list_2,record_emp,',')]#";
						data[#i#]["USER"]["USERLINK"]		=	"#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(get_emp_list_2,record_emp,',')]#";
						
					}else if(len(record_pub)){

						data[#i#]["USER"]["USERNAME"]		=	"#get_cons.consumer_name[listfind(get_cons_list_2,record_pub,',')]# #get_cons.consumer_surname[listfind(get_cons_list_2,record_pub,',')]#";
						data[#i#]["USER"]["USERLINK"]		=	"#request.self#?fuseaction=objects.popup_con_det&con_id=#get_cons.consumer_id[listfind(get_cons_list_2,record_pub,',')]#";
							
					}else if(len(record_par)){

						data[#i#]["USER"]["USERNAME"]		=	"#get_par.company_partner_name[listfind(get_par_list_2,record_par,',')]# #get_par.company_partner_surname[listfind(get_par_list_2,record_par,',')]#";
						data[#i#]["USER"]["USERLINK"]		=	"#request.self#?fuseaction=objects.popup_par_det&par_id=#get_par.partner_id[listfind(get_par_list_2,record_par,',')]#";
						
					}
					else{
						data[#i#]["USER"]["USERNAME"]		=	"<br>"; 
					}
					//data["status"]	=	true;			
				</cfscript>

				
				<cfset i = i + 1>
				</cfoutput>
				
		<cfelse>
			
			<cfscript>
				data	=	{
					status	:	false,
					message :	"#getLang('assetcare',492)#"
				};
				
			</cfscript>
			
		</cfif>	

		<cfoutput>#Replace(SerializeJSON(data),'//','')#</cfoutput>
		