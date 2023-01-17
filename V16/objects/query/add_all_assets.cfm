<cfset myImage = CreateObject("Component", "iedit")>
<cfif attributes.property_id eq ''>
	<script type="text/javascript">
	  alert("<cf_get_lang no ='1446.Bu belge düzgün girilmemiş bir belge olduğundan listeye eklenemez'>!!");
	  window.close();
	</script>
	<cfabort>	
</cfif>
<cfif isDefined("attributes.asset_archive")>
	<cftry>
		<cfif FileExists("#upload_folder##attributes.module##dir_seperator##attributes.filename#")>        	  
			<cffile action="copy" source="#attributes.filepath#" destination="#upload_folder#temp#dir_seperator#">
			<cfset file_name = createUUID()>
			<cfset dosya_ad = file_name>
			<cfset asset_real_name_ = attributes.asset_file_real_name>
			<cfif listlen(attributes.filename,'.') eq 2>
				   <cfset extention = ucase(listlast(attributes.filename,'.'))>
			<cfelse>
				   <cfset extention = 'incorrect'>	
			</cfif>
			<cfif ListLen(attributes.filename,'.') gt 1>
				<cfset file_name = file_name & '.' & ListGetAt(attributes.filename,2,'.')>			
			</cfif>		
		
			<cffile action="rename" source="#upload_folder#temp#dir_seperator##attributes.filename#" destination="#upload_folder#temp#dir_seperator##file_name#">
			<cffile action="move" source="#upload_folder#temp#dir_seperator##file_name#" destination="#upload_folder##attributes.module##dir_seperator#">
		
		 	<cfif extention is 'JPG'>
				<cftry>
					<cffile action="copy" destination="#upload_folder##dir_seperator#thumbnails" source="#upload_folder##attributes.module##dir_seperator##file_name#">
					<cfset myImage.SelectImage("#upload_folder##dir_seperator#thumbnails#dir_seperator##file_name#")>
					<cfset myImage.scale(50,50)>
					<cfset myImage.output("#upload_folder##dir_seperator#thumbnails#dir_seperator##file_name#", "jpg",100)>
					<cfcatch type="any"></cfcatch>
				</cftry>
			<cfelseif listfindnocase('PNG,GIF,JPEG','#extention#')>
				<cftry>
					<cffile action="copy" destination="#upload_folder#thumbnails" source="#upload_folder##attributes.module##dir_seperator##file_name#">
					<cfset myImage.SelectImage("#upload_folder#thumbnails#dir_seperator##file_name#")>
					<cfset myImage.scale(50,50)>
					<cfset myImage.output("#upload_folder#thumbnails#dir_seperator##dosya_ad#.jpg", "jpg",100)>
					<cffile action="delete" file="#upload_folder#thumbnails#dir_seperator##file_name#">
					<cfcatch type="any"></cfcatch>
				</cftry>
			<cfelseif extention is 'FLV'>
				<cftry>
					<cf_wrk_video action="createthumb" inputfile="#upload_folder##attributes.module##dir_seperator##file_name#" outputfile="#upload_folder##dir_seperator#thumbnails#dir_seperator##dosya_ad#.jpg" returnvariable="image_file">
					<cfcatch type="any"></cfcatch>
				</cftry>
			</cfif>
		<cfelse>
			<cfset file_name = attributes.filename>
			<cffile action="copy" source="#attributes.filepath#" destination="#upload_folder##attributes.module##dir_seperator#">
		</cfif>	
		<cfcatch type="any">
			<cfoutput>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1448.Dosyanız kopyalanamadı Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			</cfoutput>
			<cfabort>
		</cfcatch>
	</cftry>
<cfelse>
	<cfset file_name = createUUID()>
	<cfif isDefined("attributes.stream_name") and attributes.stream_name neq "">
		<cfset fileInstance = createObject("java","java.io.File").init(toString("#flashComServerApplicationsPath##attributes.stream_name#.flv")) />
		<cfif fileInstance.isFile()>
			<cfset filesize = fileInstance.length() />
		<cfelse>
			<cfset filesize = '' />
		</cfif>
		<cffile action="move" source="#flashComServerApplicationsPath##dsn#\streams\_definst_\#attributes.stream_name#.flv" destination="#upload_folder##attributes.module##dir_seperator#">
		<cfset file_name=attributes.stream_name />
		<cfset serverfileext = "flv" />
		<cftry>
			<cf_wrk_video action="createthumb" inputfile="#upload_folder##attributes.module##dir_seperator##file_name#.#serverfileext#" outputfile="#upload_folder##dir_seperator#thumbnails#dir_seperator##file_name#.jpg" returnvariable="image_file">
			<cfcatch type="any"></cfcatch>
		</cftry>
		<cfset asset_real_name_ = '#file_name#.#serverfileext#'>
	<cfelse>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="asset_file" destination="#upload_folder##attributes.module#">
		<cffile action="rename" source="#upload_folder##attributes.module##dir_seperator##cffile.serverfile#" destination="#upload_folder##attributes.module##dir_seperator##file_name#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##attributes.module##dir_seperator##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset dosya_ad = file_name>
		<cfset extention = cffile.serverfileext>
		
		<cfif isdefined("attributes.is_image")>	
			<cfif not listfindnocase('PNG,BMP,GIF,TIF,TIFF,JPG,JPEG','#UCASE(cffile.serverfileext)#')>
				<CFFILE action="delete" file="#upload_folder##attributes.module##dir_seperator##file_name#.#cffile.serverfileext#">
				<script type="text/javascript">
					alert("<cf_get_lang no ='1447.İmaj Upload Etmelisiniz! Dosyanızı kontrol ediniz '>!!!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		
		<cfif extention is 'JPG'>
			<cftry>
				<cffile action="copy" destination="#upload_folder##dir_seperator#thumbnails" source="#upload_folder##attributes.module##dir_seperator##file_name#.#cffile.serverfileext#">
				<cfset myImage.SelectImage("#upload_folder##dir_seperator#thumbnails#dir_seperator##file_name#.#cffile.serverfileext#")>
				<cfset myImage.scale(50,50)>
				<cfset myImage.output("#upload_folder##dir_seperator#thumbnails#dir_seperator##file_name#.#cffile.serverfileext#", "jpg",100)>
				<cfcatch type="any"></cfcatch>
			</cftry>
		<cfelseif listfindnocase('PNG,GIF,JPEG','#extention#')>
			<cftry>
				<cffile action="copy" destination="#upload_folder#thumbnails" source="#upload_folder##attributes.module##dir_seperator##file_name#.#cffile.serverfileext#">
				<cfset myImage.SelectImage("#upload_folder#thumbnails#dir_seperator##file_name#.#cffile.serverfileext#")>
				<cfset myImage.scale(50,50)>
				<cfset myImage.output("#upload_folder#thumbnails#dir_seperator##dosya_ad#.jpg", "jpg",100)>
				<cffile action="delete" file="#upload_folder#thumbnails#dir_seperator##file_name#.#cffile.serverfileext#">
				<cfcatch type="any"></cfcatch>
			</cftry>
		<cfelseif extention is 'FLV'>
			<cftry>
				<cf_wrk_video action="createthumb" inputfile="#upload_folder##attributes.module##dir_seperator##file_name#.#cffile.serverfileext#" outputfile="#upload_folder##dir_seperator#thumbnails#dir_seperator##dosya_ad#.jpg" returnvariable="image_file">
				<cfcatch type="any"></cfcatch>
			</cftry>
		</cfif>
		<cfset serverfileext = cffile.serverfileext>
		<cfset filesize = cffile.filesize>
		<cfset asset_real_name_ = cffile.serverfile>
	</cfif>	
</cfif>
<cfquery name="ADD_ASSET" datasource="#DSN#" result="MAX_ID">
	INSERT INTO 
		ASSET
	(
	   PERIOD_ID,
	   MODULE_NAME,
	   MODULE_ID,
	   ACTION_SECTION,
	   <cfif attributes.action_type eq 0>ACTION_ID<cfelse>ACTION_VALUE</cfif>,
	   <cfif attributes.action_type eq 1 and len(attributes.action_id_2)>ACTION_ID,</cfif>
	   ASSETCAT_ID, 
	   ASSET_NAME,
	   ASSET_FILE_NAME,
	   ASSET_FILE_REAL_NAME,
	   ASSET_FILE_SERVER_ID,
	   ASSET_FILE_SIZE,
	   ASSET_DETAIL,
	   RECORD_DATE,
	   <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
		   RECORD_EMP,
	   <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
		   RECORD_PAR,
	   </cfif>
	   RECORD_IP,
	   PROPERTY_ID,
	   IS_INTERNET,
	   IS_SPECIAL,
	   SERVER_NAME,
	   IS_IMAGE,
	   IMAGE_SIZE,
	   COMPANY_ID
	)
	VALUES
	(
	   #session.ep.period_id#,
	   '#attributes.module#',
	   #attributes.module_id#,
	   '#UCASE(attributes.action_section)#',
	   <cfif attributes.action_type eq 0>#attributes.action_id#<cfelse>'#attributes.action_id#'</cfif>,
	   <cfif attributes.action_type eq 1 and len(attributes.action_id_2)>#attributes.action_id_2#,</cfif>
	 <cfif isDefined("attributes.asset_archive")> 
	 	#attributes.asset_cat_id#,
	  <cfelse>
	   #attributes.my_assetcat_id#,
	   </cfif>
	<cfif isDefined("attributes.asset_archive")>
	   '#attributes.asset_name#',		   
	   '#file_name#',
	   <cfif isdefined('asset_real_name_') and len(asset_real_name_)>'#asset_real_name_#'<cfelse>'#attributes.asset_name#'</cfif>,
	   #fusebox.server_machine#,
	<cfif len(attributes.filesize)>
		#attributes.filesize#,
	<cfelse>
		NULL,
	</cfif>
	<cfelse>
	   #sql_unicode()#'#attributes.asset_name#',
	   '#file_name#.#serverfileext#',
	   '#asset_real_name_#',
	   #fusebox.server_machine#,
   <cfif isdefined(FILESIZE) and len(FILESIZE)>
	   #ROUND(FILESIZE/1024)#,
	<cfelse>
		NULL,
   </cfif>
	</cfif>			   
	   '#attributes.keyword#',				   
	   #now()#,
	<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
	   #session.ep.userid#,
	<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
	   #session.pp.userid#,
	</cfif>
	   '#cgi.remote_addr#',
	   #attributes.PROPERTY_ID#,
	   <cfif isdefined("attributes.is_internet")>1,<cfelse>0,</cfif>
	   <cfif isdefined("attributes.is_special")>1,<cfelse>0,</cfif>
	   '#ucase(server_name)#',
	   <cfif isdefined("attributes.is_image") and attributes.is_image eq 1>1,<cfelse>0,</cfif>
	   <cfif isdefined("attributes.is_image") and len(attributes.image_size)>#attributes.image_size#,<cfelse>NULL,</cfif>
	   #session.ep.company_id#	
	)
</cfquery>
<cfif isdefined("attributes.asset_id")>
	<cfquery name="get_asset_rel" datasource="#DSN#">
		SELECT * FROM ASSET_RELATED WHERE ASSET_ID = #attributes.asset_id#
	</cfquery>
	<cfif get_asset_rel.recordcount>
		<cfoutput query="get_asset_rel">
			<cfquery name="ADD_ASSET" datasource="#DSN#">
				INSERT INTO 
					ASSET_RELATED
				(
					COMPANY_CAT_ID,
					CONSUMER_CAT_ID,
					ALL_INTERNET,
					ALL_CAREER,
					POSITION_CAT_ID,
					USER_GROUP_ID,
					ALL_EMPLOYEE,
					ALL_PEOPLE,
					ASSET_ID
				)
				VALUES
				(
					<cfif len(COMPANY_CAT_ID)>#COMPANY_CAT_ID#,<cfelse>NULL,</cfif>
					<cfif len(CONSUMER_CAT_ID)>#CONSUMER_CAT_ID#,<cfelse>NULL,</cfif>
					<cfif len(ALL_INTERNET)>1,<cfelse>NULL,</cfif>
					<cfif len(ALL_CAREER)>1,<cfelse>NULL,</cfif>
					<cfif len(POSITION_CAT_ID)>#POSITION_CAT_ID#,<cfelse>NULL,</cfif>
					<cfif len(USER_GROUP_ID)>#USER_GROUP_ID#,<cfelse>NULL,</cfif>
					<cfif len(ALL_EMPLOYEE)>1,<cfelse>NULL,</cfif>
					<cfif len(ALL_PEOPLE)>1,<cfelse>NULL,</cfif>
					#MAX_ID.IDENTITYCOL#				
				)
			</cfquery>
		</cfoutput>
	</cfif>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
