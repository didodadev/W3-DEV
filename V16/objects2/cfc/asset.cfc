<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
	<cfset dir_seperator="/">
	<cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.cp")>
        <cfset session_base = evaluate('session.cp')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    </cfif>
	<cfset upload_folder="#application.systemParam.systemParam().upload_folder#">
	<cffunction name="addAsset" access="remote" returntype="string" returnformat="json">


		<cfif not len(arguments.asset_cat_id)>
			<cfset result.status = false>
			<cfset result.danger_message = "Dijital Varlık Kategorisi Tanımlı Olmayan Bir Sayfadan Ekleme Yapıyorsunuz. Lütfen Bu İşleme Nasıl Ulaştığınızı Sistem Yöneticisine Bildiriniz...">
			<cfreturn Replace(SerializeJSON(result),'//','')>
		</cfif>

		<cfquery name="GET_UPLOAD_FOLDER" datasource="#DSN#">
			SELECT 
				ASSETCAT_ID,
				ASSETCAT_PATH
			FROM
				ASSET_CAT
			WHERE
				ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_cat_id#">
		</cfquery>
		<cfif arguments.asset_cat_id lt 0>
			<cfset upload_folder = "#upload_folder##get_upload_folder.assetcat_path##dir_seperator#">
		<cfelse>
			<cfset upload_folder = "#upload_folder#asset#dir_seperator##get_upload_folder.assetcat_path##dir_seperator#">
		</cfif>

		<cftry>
			<cfif form.asset_file neq "undefined">
				<cffile action = "upload" 
					filefield = "form.asset_file" 
					destination = "#upload_folder#"
					nameconflict = "Overwrite"  
				>
				<cfset filesize = cffile.filesize />
				<cfset file_name = "#createUUID()#">
				<cfset dosya_ad = file_name>
				<cfset extention = ucase(cffile.serverfileext)>
				<cfset file_name = "#file_name#.#cffile.serverfileext#">
				<cfset moduleName=arguments.module>	
				<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">
				<!---Script dosyalarını engelle  02092010 FA-ND --->
				<cfset assetTypeName = listlast(cffile.serverfile,'.')>

				<cfquery name="GET_FILE_SIZE_COMP" datasource="#DSN#">
					SELECT 
						FILE_SIZE,
						IS_FILE_SIZE 
					FROM 
						OUR_COMPANY_INFO 
					WHERE
						<cfif isdefined('session.pp.our_company_id')> 
							COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
						<cfelse>
							COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
						</cfif>
				</cfquery>
				
				<cfif  get_file_size_comp.recordcount and get_file_size_comp.is_file_size eq 1>
					<cfquery name="GET_FILE_SIZE" datasource="#DSN#">
						SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetTypeName#">
					</cfquery>
					<cfif get_file_size.recordcount and len(get_file_size.format_size)>
						<cfset dt_size = get_file_size.format_size * 1048576>
						<cfif int(dt_size) lte int(filesize)>
							<cfif FileExists("#upload_folder##dir_seperator##file_name#.#cffile.serverfileext#")>
								<cffile action="delete" file="#assetInfo.uploadFolder##assetInfo.fileName#">
							</cfif> 
							<cfset result.status = false>
							<cfset result.danger_message = "Dosya boyutu #get_file_size.format_size#MB dan fazla olmamalıdır.">       
							<cfreturn Replace(SerializeJSON(result),'//','')>        
						</cfif>
					<cfelse>
						<cfset dt_size=get_file_size_comp.file_size * 1048576>
						<cfif len(get_file_size_comp.file_size) and  dt_size lte filesize>
							<cfif FileExists("#upload_folder##dir_seperator##file_name#.#cffile.serverfileext#")>
								<cffile action="delete" file="#assetInfo.uploadFolder##assetInfo.fileName#">
							</cfif>
							<cfset result.status = false>
							<cfset result.danger_message = "Dosya boyutu #get_file_size_comp.file_size#MB dan fazla olmamalıdır.">       
							<cfreturn Replace(SerializeJSON(result),'//','')>
						</cfif>
					</cfif>
				</cfif>
					
				<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
				<cfif listfind(blackList,assetTypeName,',')>
					<cffile action="delete" file="#upload_folder##file_name#">
					<cfset result.status = false>
					<cfset result.danger_message = "\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!">       
					<cfreturn Replace(SerializeJSON(result),'//','')>
				</cfif>
			</cfif>

			<cflock name="#CreateUUID()#" timeout="60">
				<cftransaction>
					<cfquery name="ADD_ASSET_FILE" datasource="#DSN#" result="MAX_ID">
						INSERT INTO
							ASSET
							(
								IS_ACTIVE,
								MODULE_NAME,
								MODULE_ID,
								ACTION_SECTION,
								ACTION_ID,
								COMPANY_ID,
								PERIOD_ID,
								ASSETCAT_ID,
								ASSET_FILE_NAME,
								ASSET_FILE_REAL_NAME,
								ASSET_FILE_SERVER_ID,
								ASSET_NAME,
								EMBEDCODE_URL,
								ASSET_DETAIL,
								PROPERTY_ID,
								IS_SPECIAL,
								IS_INTERNET,
								RECORD_DATE,
								<cfif isdefined('session.pp.userid')>
									RECORD_PAR,
								<cfelseif isdefined('session.ww.userid')>
									RECORD_PUB,
								<cfelseif isdefined('session.pda.userid')>
									RECORD_EMP,
								</cfif>
								RECORD_IP,
								SERVER_NAME
							)
							VALUES
							(
								1,
								<cfif len(arguments.module)>'#arguments.module#'<cfelse>NULL</cfif>,
								NULL,
								<cfif len(arguments.action_section)>'#arguments.action_section#'<cfelse>NULL</cfif>,
								<cfif len(arguments.action_id)>#arguments.action_id#<cfelse>NULL</cfif>,
								#session_base.our_company_id#,
								#session_base.period_id#,
								<cfif len(arguments.asset_cat_id)>#arguments.asset_cat_id#<cfelse>NULL</cfif>,
								<cfif isdefined("file_name")>'#file_name#'<cfelse>''</cfif>,
								<cfif isdefined("cffile.serverfile") and len(cffile.serverfile)>'#cffile.serverfile#'<cfelse>NULL</cfif>,
								NULL,
								<cfif len(arguments.asset_file_name)>'#arguments.asset_file_name#'<cfelse>NULL</cfif>,
								<cfif len(arguments.url)>'#arguments.url#'<cfelse>NULL</cfif>,
								<cfif len(arguments.detail)>'#left(arguments.detail,500)#'<cfelse>NULL</cfif>,
								<cfif len(arguments.property_id)>#arguments.property_id#<cfelse>NULL</cfif>,
								0,
								1,
								#now()#,
								<cfif isdefined('session.pp.userid')>
									#session.pp.userid#,
								<cfelseif isdefined('session.ww.userid')>
									#session.ww.userid#,
								<cfelseif isdefined('session.pda.userid')>
									#session.pda.userid#,
								</cfif>
								'#CGI.REMOTE_ADDR#',
								'#UCASE(server_name)#'
							)
					</cfquery>
					<cfquery name="ASSET_SITE_DOMAIN" datasource="#DSN#">
						INSERT INTO
							ASSET_SITE_DOMAIN
							(
								ASSET_ID,		
								SITE_DOMAIN
							)
						VALUES
							(
								#max_id.identitycol#,
								<cfif isdefined('session.pp.userid')>'#cgi.HTTP_HOST#'<cfelseif isdefined('session.ww.userid')>'#cgi.HTTP_HOST#'<cfelse>NULL</cfif>
							)	
					</cfquery>
				</cftransaction>
			</cflock>
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
			<cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
			<cfset actions = 'OPP_ID,G_SERVICE_ID,WORK_ID'>
            <cfset result.identity = (ListContains(actions,arguments.action_section))?CreateObject("component", "WMO.functions").contentEncryptingandDecodingAES(isEncode:1,content:arguments.action_id,accountKey:"wrk"):arguments.action_id>
			<cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Suanda islem yapilamiyor.">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>
	<cffunction name="delAsset" access="remote" returntype="string" returnformat="json">		
		<cftry>
			<!--- belgenin kaydedilecegi klasör --->
			<cfset uploadFolder = application.systemParam.systemParam().upload_folder />
			<cfset path=''>
			<cflock timeout="20">
				<cftransaction>
					<cfquery name="GET_UPLOAD_FOLDER" datasource="#dsn#">
						SELECT 
							ASSETCAT_ID,
							ASSETCAT_PATH
						FROM
							ASSET_CAT
						WHERE
							ASSETCAT_ID = #arguments.ASSETCAT_ID#
					</cfquery>
					<cfquery name="GET_FILE" datasource="#dsn#">
						SELECT
							ASSET_ID,
							ASSET_FILE_NAME,
							ASSET_FILE_SERVER_ID,
							ASSET_NO,
							ASSETCAT_ID,
							ASSET_STAGE,
							ACTION_ID,
							RECORD_DATE,
							RELATED_ASSET_ID
						FROM
							ASSET
						WHERE
							ASSET_ID = #arguments.ASSET_ID#
					</cfquery>
					<cfquery name="control_" datasource="#dsn#">
						SELECT
							ASSET_ID
						FROM
							ASSET
						WHERE
							ASSET_ID <> #arguments.ASSET_ID# AND
							ASSET_FILE_NAME = '#GET_FILE.ASSET_FILE_NAME#'
					</cfquery>
					
					<cfif GET_UPLOAD_FOLDER.ASSETCAT_ID gte 0>
						<cfset path = "asset/#GET_UPLOAD_FOLDER.ASSETCAT_PATH#">
					<cfelse>
						<cfset path = GET_UPLOAD_FOLDER.ASSETCAT_PATH>
					</cfif>
					<cfset folder="#path#">
					<cfquery name="DEL_ASSET" datasource="#dsn#">
						DELETE FROM ASSET WHERE ASSET_ID = #arguments.ASSET_ID#
					</cfquery>
					<cfif not control_.recordcount><!--- sadece database silinir ... aynı dosya başka bir kayıtta da kullanılıyor... --->
						<cfif DirectoryExists( 	"#uploadFolder#/#folder#/#get_file.asset_file_name#" ) and len(GET_FILE.ASSET_FILE_NAME)>
							<cffile action="DELETE" file="#uploadFolder#/#folder#/#get_file.asset_file_name#">
						</cfif>
					</cfif>
				</cftransaction>
			</cflock>
			<cfset result.status = true>
            <cfset result.success_message = "Silme işlemi başarılı, Yönlendiriliyor">
			<cfset actions = 'OPP_ID,G_SERVICE_ID,WORK_ID'>
            <cfset result.identity = (ListContains(actions,arguments.action_section))?CreateObject("component", "WMO.functions").contentEncryptingandDecodingAES(isEncode:1,content:arguments.action_id,accountKey:"wrk"):arguments.action_id>
			<cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Suanda islem yapilamiyor.">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>
</cfcomponent>
