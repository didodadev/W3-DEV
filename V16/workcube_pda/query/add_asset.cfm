<cfquery name="GET_UPLOAD_FOLDER" datasource="#DSN#">
	SELECT 
		ASSETCAT_ID,
		ASSETCAT_PATH
	FROM
		ASSET_CAT
	WHERE
		ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_cat_id#">
</cfquery>
<cfif attributes.asset_cat_id lt 0>
	<cfset upload_folder = "#upload_folder##get_upload_folder.assetcat_path##dir_seperator#">
<cfelse>
	<cfset upload_folder = "#upload_folder#asset#dir_seperator##get_upload_folder.assetcat_path##dir_seperator#">
</cfif>

<cftry>
	<cffile action = "upload" 
		fileField = "asset_file" 
		destination = "#upload_folder#"
		nameConflict = "MakeUnique"  
		mode="777" >
	<cfset filesize = cffile.filesize />
	<cfset file_name = "#createUUID()#">
	<cfset dosya_ad = file_name>
	<cfset extention = ucase(cffile.serverfileext)>
	<cfset file_name = "#file_name#.#cffile.serverfileext#">
	<cfset moduleName=attributes.module>	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">
	<!---Script dosyalarını engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>

	<cfif isdefined('attributes.is_file_upload_size') and attributes.is_file_upload_size eq 1>
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
					<cfif FileExists("#upload_folder##dir_seperator##file_name#.#cffile.serverfileext#")>
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
	</cfif>
		
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfcatch>
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'> !");
			backing();
		</script>
		<cfabort>
	</cfcatch>
</cftry>

<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_ASSET_FILE" datasource="#DSN#">
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
					ASSET_FILE_REAL_NAME,
					ASSET_FILE_SERVER_ID,
					ASSET_NAME,
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
					'#moduleName#',
					#attributes.module_id#,
					'#attributes.action_section#',
					#attributes.action_id#,
					<cfif isdefined('session.pp.userid')>#session.pp.our_company_id#<cfelseif isdefined('session.ww.userid')>#session.ww.our_company_id#<cfelseif isdefined('session.pda.userid')>#session.pda.our_company_id#</cfif>,
					#attributes.asset_cat_id#,
					'#file_name#',
					'#cffile.serverfile#',
					#fusebox.server_machine#,
					'#attributes.asset_file_name#',
					<cfif len(attributes.detail)>'#left(attributes.detail,500)#'<cfelse>NULL</cfif>,
					#attributes.property_id#,
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
		<cfquery name="GET_MAX_ID" datasource="#DSN#">
			SELECT MAX(ASSET_ID) AS MAX_ID FROM ASSET
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
					#get_max_id.max_id#,
					<cfif isdefined('session.pp.userid')>'#cgi.HTTP_HOST#'<cfelseif isdefined('session.ww.userid')>'#cgi.HTTP_HOST#'<cfelse>NULL</cfif>
				)	
		</cfquery>
		<cf_workcube_process 
            is_upd='1'
            old_process_line='0'
            process_stage='8' 
            record_member='#session.pda.userid#' 
            record_date='#now()#'
            action_table='ASSET'
            action_column='ASSET_ID'
            action_id='#get_max_id.max_id#'
            action_page='#request.self#?fuseaction=objects2.popup_add_asset'
            warning_description='Varlık : #file_name#'>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
