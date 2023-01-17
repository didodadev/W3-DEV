<!--- functions --->
<!--- UPLOAD FILE --->
<cffunction name="uploadFile">
	<cfargument name="assetInfo" type="struct" />
	<!--- upload the file --->
    <cffile action = "upload" 
		  fileField = "asset" 
		  destination = "#assetInfo.uploadFolder#"
		  nameConflict = "MakeUnique"
		  mode="777">
		<cfset assetInfo.fileSize = cffile.filesize />
		<cfset assetInfo.fileExtension = ucase(cffile.serverfileext)>
		<cfset assetInfo.fileName = "#createUUID()#.#cffile.serverfileext#">
		<cffile action="rename" source="#assetInfo.uploadFolder##cffile.serverfile#" destination="#assetInfo.uploadFolder##assetInfo.fileName#">
    	<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		
		<!---Büyük dosya Boyutlarını Engelle --->
        <cfquery name="get_file_size_comp" datasource="#dsn#">
            SELECT FILE_SIZE,IS_FILE_SIZE FROM OUR_COMPANY_INFO WHERE COMP_ID=#session.ep.company_id#
        </cfquery>
        <cfif  get_file_size_comp.is_file_size>
            <cfquery name="get_file_size" datasource="#dsn#">
                SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#assetTypeName#'
            </cfquery>
            <cfif get_file_size.recordcount and len(get_file_size.format_size)>
                <cfset dt_size=get_file_size.format_size * 1048576>
                <cfif INT(dt_size) lte INT(filesize)>
                <cfif FileExists("#assetInfo.uploadFolder##assetInfo.fileName#")>
                    <cffile action="delete" file="#assetInfo.uploadFolder##assetInfo.fileName#">
				</cfif>
                        <script type="text/javascript">
                            alert('Dosya boyutu ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
                            history.back();
                        </script>
                    <cfabort>
                </cfif>
            <cfelse>
                <cfset dt_size=get_file_size_comp.file_size * 1048576>
                <cfif len(get_file_size_comp.file_size) and  dt_size lte filesize>
                <cfif FileExists("#upload_folder##folder##dir_seperator##file_name#.#cffile.serverfileext#")>
                    <cffile action="delete" file="#assetInfo.uploadFolder##assetInfo.fileName#">
				</cfif>
                        <script type="text/javascript">
                            alert('Dosya boyutu ' + <cfoutput>#get_file_size_comp.file_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
                            history.back();
                        </script>
                    <cfabort>
                </cfif>  
            </cfif>
        </cfif>
		
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#assetInfo.uploadFolder##assetInfo.fileName#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
	<!--- create thumbnail --->
    <cfif getTypeOfUploadedFile(assetInfo.fileExtension) eq "image">
    	<cfset createThumbnailFromImage(assetInfo) />
    <cfelseif getTypeOfUploadedFile(assetInfo.fileExtension) eq "video">
     	<cfset createThumbnailFromVideo(assetInfo) />
    </cfif>
    
	<!--- insert AssetInfo --->
    <cfset saveAssetMetaData(assetInfo) />
</cffunction>

<!--- UPLOAD RECORDED FLASH VIDEO STREAM --->
<cffunction name="uploadRecordedFlvStream">
	<cfargument name="assetInfo" type="struct" />
  		
		<!--- move the recorded stream --->
    	<cfset fileInstance = createObject("java","java.io.File").init(toString("#flashComServerApplicationsPath##attributes.stream_name#.flv")) />
		<cfif fileInstance.isFile()>
			<cfset assetInfo.fileSize = fileInstance.length() />
		</cfif>
		<cffile action="move" source="#flashComServerApplicationsPath##attributes.stream_name#.flv" destination="#upload_folder#">
		<cfset assetInfo.fileName="#attributes.stream_name#.flv" />
		<cfset assetInfo.fileExtension = "flv" />
        
        <!--- create thumbnail --->
		<cfset createThumbnailFromVideo(assetInfo) />
    
		<!--- insert AssetInfo --->
        <cfset saveAssetMetaData(assetInfo) />
</cffunction>

<cffunction name="AssetInfoNew" returntype="struct" description="Returns new AssetInfo object that contains default values">
	<cfset assetInfo=structNew() />
    <cfset assetInfo.assetId="" />
    <cfset assetInfo.assetName=form.ASSET_NAME />
    <cfset assetInfo.assetDescription=form.ASSET_DESCRIPTION />
    <cfset assetInfo.assetKeywords=form.ASSET_DETAIL />
    <cfset assetInfo.assetCategoryId=attributes.ASSETCAT_ID />
    <cfset assetInfo.companyId=SESSION.EP.COMPANY_ID />
    <cfset assetInfo.fileName="" />
    <cfset assetInfo.fileSize="" />
    <cfset assetInfo.fileExtension="" />
    <cfset assetInfo.fileServerId=fusebox.server_machine />
    <cfset assetInfo.uploadFolder=getUploadFolder() />
    <cfset assetInfo.moduleName="Asset" />
    <cfset assetInfo.moduleId=8 />
    <cfset assetInfo.actionSection="Asset" />
    <cfset assetInfo.actionId=-1 />
    <cfif isdefined("attributes.is_internet")>
	    <cfset assetInfo.isInternet=true />
    <cfelse>
    	<cfset assetInfo.isInternet=false />
	</cfif>
    <cfset assetInfo.recordDate=NOW() />
    <cfset assetInfo.recordEmployee=SESSION.EP.USERID />
    <cfset assetInfo.recordIp=CGI.REMOTE_ADDR />
    <cfset assetInfo.updateDate=NOW() />
    <cfset assetInfo.updateEmployee=SESSION.EP.USERID />
    <cfset assetInfo.updateIp=CGI.REMOTE_ADDR />
    <cfset assetInfo.propertyId=attributes.property_id />
    <cfset assetInfo.departmentId=listFirst(session.ep.user_location,'-') />
    <cfset assetInfo.branchId=listGetAt(session.ep.user_location,2,'-') />
    <cfif structKeyExists(variables,"SITE_DOMAIN")>
    	<cfset assetInfo.siteDomain=SITE_DOMAIN />
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
    
    <cfif isdefined("session.ww.userid")>
    	<cfset assetInfo.consumerId = session.ww.userid />
    <cfelse>
    	<cfset assetInfo.consumerId = "" />
    </cfif>
    <cfreturn assetInfo />
</cffunction>

<cffunction name="validate">
<cfif not isDefined("attributes.ASSETCAT_ID")>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1394.Lütfen ayarlar dan Elektronik Varlik Kategorisi Ekleyiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
</cffunction>

<cffunction name="isRecordedFlvStream" returntype="boolean">
	<cfif isDefined("attributes.stream_name") and attributes.stream_name neq "">
    	<cfreturn true />
    <cfelse>
    	<cfreturn false />
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
	<cfquery name="GET_UPLOAD_FOLDER" datasource="#dsn#">
        SELECT 
            ASSETCAT_ID,
            ASSETCAT_PATH
        FROM
            ASSET_CAT
        WHERE
            ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetcat_id#">
    </cfquery>
    <cfset ilk_upload = "#upload_folder#">
	<cfif attributes.assetcat_id lt 0>
        <cfset upload_folder = "#upload_folder##get_upload_folder.assetcat_path##dir_seperator#">
    <cfelse>
        <cfset upload_folder = "#upload_folder#asset#dir_seperator##get_upload_folder.assetcat_path##dir_seperator#">
    </cfif>
	<cfreturn upload_folder />
</cffunction>

<cffunction name="createThumbnailFromImage">
	<cfargument name="assetInfo" type="struct" required="yes" />
		<cftry>
            <cffile action="copy" destination="#ilk_upload#thumbnails" source="#assetInfo.uploadFolder##assetInfo.fileName#">
           <!--- <cfset myImage = CreateObject("Component", "iedit")>
            <cfset myImage.SelectImage("#ilk_upload#thumbnails#dir_seperator##assetInfo.fileName#")>
            <cfset myImage.scale(50,50)>
            <cfset myImage.output("#ilk_upload#thumbnails#dir_seperator##assetInfo.fileName#.jpg", "jpg",100)>   --->
            <cfif assetInfo.fileExtension neq "jpg">
            <cffile action="delete" file="#ilk_upload#thumbnails#dir_seperator##assetInfo.fileName#">
            </cfif>
            <cfcatch type="any"></cfcatch>
        </cftry>
</cffunction>

<cffunction name="createThumbnailFromVideo">
	<cfargument name="assetInfo" type="struct" required="yes" />
    <cftry>
        <cf_wrk_video action="createthumb" inputfile="#assetInfo.uploadFolder##assetInfo.fileName#" outputfile="#ilk_upload#thumbnails#dir_seperator##assetInfo.fileName#.jpg" returnvariable="image_file">
        <cfcatch type="any"></cfcatch>
    </cftry>
</cffunction>

<cffunction name="manipulateImage">
	<cfargument name="assetInfo" type="struct" required="yes" />
    <!--- Resim islemlere tabi tutulacaksa geçici bir klasör açilir ve oraya kopyalanir --->
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
            <cfset  session.imFile = listGetAt(session.imFile,1,".")&"."&"jpg">			
            <cfset assetInfo.fileExtension = 'jpg'>
            <cfset assetInfo.fileName = '#ListGetAt(assetInfo.fileName,1,'.')#.#assetInfo.fileExtension#'>
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
	<cfargument name="assetInfo" type="struct" />
    <cfquery name="ADD_ASSET" datasource="#dsn#" result="MAX_ID">
	INSERT INTO 
		ASSET(
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
			ASSET_DETAIL,
			IS_INTERNET,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			UPDATE_DATE,
			UPDATE_EMP,
			UPDATE_IP,
			PROPERTY_ID,
			DEPARTMENT_ID,
			BRANCH_ID,
            ASSET_DESCRIPTION,
            IS_LIVE,
            FEATURED,
            CONSUMER_ID
			)
	VALUES(
			'#assetInfo.moduleName#',
			#assetInfo.moduleId#,
			'#assetInfo.actionSection#',
			#assetInfo.actionId#,
			#assetInfo.companyId#,
			#assetInfo.assetCategoryId#,
			'#assetInfo.fileName#',
			#ROUND(assetInfo.fileSize/1024)#,
			#assetInfo.fileServerId#,
			'#assetInfo.assetName#',
			'#assetInfo.assetKeywords#',
			<cfif assetInfo.isInternet>1<cfelse>0</cfif>,
			#assetInfo.recordDate#,
			#assetInfo.recordEmployee#,
			'#assetInfo.recordIp#',
			#assetInfo.updateDate#,
			#assetInfo.updateEmployee#,
			'#assetInfo.updateIp#',
			#assetInfo.propertyId#,
			#assetInfo.departmentId#,
			#assetInfo.branchId#,
            '#assetInfo.assetDescription#',
            <cfif assetInfo.isLive>1<cfelse>0</cfif>,
            <cfif assetInfo.featured>1<cfelse>0</cfif>,
            <cfif assetInfo.consumerId neq "">#assetInfo.consumerId#<cfelse>NULL</cfif>)
</cfquery>
<cfif assetInfo.isInternet>
	<cfquery name="get_company" datasource="#dsn#">
		SELECT 
			MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID
		FROM 
			MAIN_MENU_SETTINGS 
		WHERE 
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetinfo.companyid#">
	</cfquery>
	<cfloop query="get_company">
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
						#MAX_ID.IDENTITYCOL#,
						'#assetInfo.siteDomain#'
					)	
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
</cffunction>

<!--- ADD ASSET using the functions above --->
<cfscript>
	session.imTempPath = "#upload_folder##createuuid()##dir_seperator#";
	session.resim = 1;
	ilk_upload = "#upload_folder#";
	
	// validate request, upload and save the asset
	validate();
	assetInfo = AssetInfoNew();
	if (isRecordedFlvStream()) {
		uploadRecordedFlvStream(assetInfo);
	} else {
		uploadFile(assetInfo);
	}
	session.imPath = assetInfo.uploadFolder;
</cfscript>
