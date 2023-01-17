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
<cfif len(attributes.old_asset_file) and attributes.old_asset_file neq ''>
	<cf_del_server_file output_file="#get_upload_folder.assetcat_path##dir_seperator##attributes.old_asset_file#" output_server="#attributes.old_asset_file_server_id#">
</cfif>
<cfif attributes.asset_file neq ''>
	<cftry>
		<cffile action = "upload" 
			filefield = "asset_file" 
			destination = "#upload_folder#"
			nameconflict = "MakeUnique"  
			mode="777">
		<cfset filesize = cffile.filesize />
		<cfset file_name = "#createUUID()#">
		<cfset dosya_ad = file_name>
		<cfset extention = ucase(cffile.serverfileext)>
		<cfset file_name = "#file_name#.#cffile.serverfileext#">	
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
                        <cffile action="delete" file="#upload_folder##dir_seperator##file_name#.#cffile.serverfileext#">
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
                        <cffile action="delete" file="#upload_folder##dir_seperator##file_name#.#cffile.serverfileext#">
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
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>

<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_ASSET_FILE" datasource="#DSN#">
			UPDATE
				ASSET
			SET
				<cfif attributes.asset_file neq ''>
					ASSET_FILE_NAME = '#file_name#',
					ASSET_FILE_REAL_NAME = '#cffile.serverfile#',
					ASSET_FILE_SERVER_ID = #fusebox.server_machine#,
				</cfif>
				ASSET_NAME = '#attributes.asset_file_name#',
				ASSET_DETAIL = <cfif len(attributes.detail)>'#left(attributes.detail,500)#'<cfelse>NULL</cfif>,
				PROPERTY_ID = #attributes.property_id#,
				UPDATE_DATE = #now()#,
				<cfif isdefined('session.pp.userid')>
					UPDATE_PAR = #session.pp.userid#,
				<cfelseif isdefined('session.ww.userid')>
					UPDATE_PUB = #session.ww.userid#,
				<cfelseif isdefined('session.pda.userid')>
					UPDATE_EMP = #session.pda.userid#,
				</cfif>
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				SERVER_NAME = '#ucase(server_name)#'
			WHERE
				ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
