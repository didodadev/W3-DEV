<cfsavecontent variable="message"><cf_get_lang dictionary_id='40770.Özlük Belgeleri'></cfsavecontent>
<cfif not DirectoryExists("#upload_folder#hr")>
	<cfdirectory action="create" directory="#upload_folder#hr">
</cfif>
<cfset upload_folder = "#upload_folder#">
<cfloop from="1" to="#attributes.rowCount#" index="ccc">
	<cfif isDefined("attributes.row_kontrol_#ccc#") and evaluate("attributes.row_kontrol_#ccc#") eq 1 and (len(evaluate("attributes.asset_file#ccc#")) or Len(evaluate("attributes.asset_name#ccc#")))>
		<cfif len(evaluate("attributes.asset_file#ccc#"))>
			<cftry>
				<cffile action = "upload" filefield = "asset_file#ccc#" destination = "#upload_folder#hr#dir_seperator#" nameconflict = "MakeUnique" mode="777" >
				<cfcatch>
					<cfset error=1>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
						history.back();
					</script>
					<cfabort>
				</cfcatch>  
			</cftry>
			
			<cfset 'file_name_#ccc#' = createUUID()>
			<cfset 'file_name_ek_#ccc#' = cffile.serverfileext>
			<cffile action="rename" source="#upload_folder#hr#dir_seperator##cffile.serverfile#" destination="#upload_folder#hr#dir_seperator##evaluate('file_name_#ccc#')#.#cffile.serverfileext#">
		
			<!---Script dosyalarını engelle  02092010 ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder#hr#dir_seperator##evaluate('file_name_#ccc#')#.#cffile.serverfileext#">
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfif isDefined("attributes.asset_cat_id#ccc#") and Len(evaluate("attributes.asset_cat_id#ccc#"))>
			<cfif Len(Evaluate("attributes.asset_date#ccc#"))>
				<cf_date tarih = "attributes.asset_date#ccc#">
				<cfif not len(Evaluate("attributes.asset_finish_date#ccc#"))>
					<cfquery name="get_cat" datasource="#dsn#">
						SELECT USAGE_YEAR FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE ASSET_CAT_ID = #evaluate("attributes.asset_cat_id#ccc#")#
					</cfquery>
					<cfif len(get_cat.usage_year)>
						<cfset finish_ = DateAdd('yyyy',get_cat.usage_year,evaluate("attributes.asset_date#ccc#"))>
					<cfelse>
						<!---<cfset finish_ = DateAdd('yyyy',5,evaluate("attributes.asset_date#ccc#"))>--->
                        <cfset finish_ = "">
					</cfif>
				<cfelseif len(Evaluate("attributes.asset_finish_date#ccc#"))>
					<cf_date tarih = "attributes.asset_finish_date#ccc#">
					<cfset finish_ = Evaluate("attributes.asset_finish_date#ccc#")>
				</cfif>
			</cfif>
			<cfquery name="add_" datasource="#dsn#" result="MAX_ID">
				INSERT INTO 
					EMPLOYEE_EMPLOYMENT_ROWS
				(
					EMPLOYEE_ID,
					ASSET_CAT_ID,
					ASSET_DATE,
					ASSET_FINISH_DATE,
					ASSET_NO,
					ASSET_NAME,
					ASSET_FILE,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE
					<cfif isDefined("attributes.x_employment_assets_process") and attributes.x_employment_assets_process eq 1>
						,EMPLOYMENT_STAGE
					</cfif>
				)
				VALUES
				(
					#attributes.employee_id#,
					#evaluate("attributes.asset_cat_id#ccc#")#,
					<cfif len(evaluate("attributes.asset_date#ccc#"))>#Evaluate("attributes.asset_date#ccc#")#<cfelse>NULL</cfif>,
					<cfif isdefined("finish_") and len(finish_) and len(evaluate("attributes.asset_date#ccc#"))>#finish_#<cfelse>NULL</cfif>,
					'#evaluate("attributes.asset_no#ccc#")#',
					'#evaluate("attributes.asset_name#ccc#")#',
					<cfif isdefined("file_name_#ccc#")>'#evaluate("file_name_#ccc#")#.#evaluate("file_name_ek_#ccc#")#'<cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					<cfif isDefined("attributes.x_employment_assets_process") and attributes.x_employment_assets_process eq 1>
						,<cfif isDefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#listGetAt(attributes.process_stage, ccc)#"><cfelse>NULL</cfif>
					</cfif>
				)
			</cfquery>
           	<cfif isDefined("attributes.x_employment_assets_process") and attributes.x_employment_assets_process eq 1>
				<cf_workcube_process
					is_upd='1'
					data_source='#dsn#'
					old_process_line='0'
					process_stage='#listGetAt(attributes.process_stage, ccc)#'
					record_member='#session.ep.userid#'
					record_date='#now()#'
					action_table='EMPLOYEE_EMPLOYMENT_ROWS'
					action_column='ROW_ID'
					action_id='#MAX_ID.IDENTITYCOL#'
					action_page='#request.self#?fuseaction=hr.popup_form_upd_emp_employment_assets&employee_id=#attributes.EMPLOYEE_ID#'
					warning_description='#message# : #evaluate("attributes.asset_cat_name#ccc#")#'>
			</cfif>
		</cfif>
	</cfif>
</cfloop>
<cfloop from="1" to="#attributes.sabit_rowCount#" index="ccc">
	<cfif isDefined("attributes.sabit_row_kontrol_#ccc#") and evaluate("attributes.sabit_row_kontrol_#ccc#") eq 1>
		<cfif len(evaluate("attributes.sabit_asset_file#ccc#"))>
			<cfif len(evaluate("attributes.old_file_name#ccc#"))>
				<cftry>
					<cffile action="delete" file="#upload_folder#hr#dir_seperator##evaluate('attributes.old_file_name#ccc#')#">
					<cfcatch type="any"></cfcatch>
				</cftry>
			</cfif>
			<cftry>
				<cffile action = "upload" filefield = "sabit_asset_file#ccc#" destination = "#upload_folder#hr#dir_seperator#" nameconflict = "MakeUnique" mode="777">
				<!---Script dosyalarını engelle  02092010 ND --->
				<cfcatch type="Any">
					<cfset error=1>
					<script type="text/javascript">
						alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz !");
						history.back();
					</script>
				</cfcatch>  
			</cftry>
			<cfset 'sabit_file_name_#ccc#' = createUUID()>
			<cfset 'sabit_file_name_ek_#ccc#' = cffile.serverfileext>
			<cffile action="rename" source="#upload_folder#hr#dir_seperator##cffile.serverfile#" destination="#upload_folder#hr#dir_seperator##evaluate('sabit_file_name_#ccc#')#.#cffile.serverfileext#">
		</cfif>
		<cfif isDefined("attributes.row_id#ccc#") and Len(evaluate("attributes.row_id#ccc#"))>
			<cfif isDefined("attributes.sabit_asset_cat_id#ccc#") and Len(evaluate("attributes.sabit_asset_cat_id#ccc#"))>
				<cfif isDefined("attributes.sabit_asset_date#ccc#") and Len(Evaluate("attributes.sabit_asset_date#ccc#"))>
					<cf_date tarih = "attributes.sabit_asset_date#ccc#">
					<cfif not len(evaluate("attributes.sabit_asset_finish_date#ccc#"))>
						<cfquery name="get_cat" datasource="#dsn#">
							SELECT USAGE_YEAR FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE ASSET_CAT_ID = #evaluate("attributes.sabit_asset_cat_id#ccc#")#
						</cfquery>
						<cfif len(get_cat.usage_year)>
							<cfset finish_ = DateAdd('yyyy',get_cat.usage_year,evaluate("attributes.sabit_asset_date#ccc#"))>
						<cfelse>
							<!---<cfset finish_ = DateAdd('yyyy',5,evaluate("attributes.sabit_asset_date#ccc#"))>--->
                            <cfset finish_ = "">
						</cfif>
					<cfelseif len(evaluate("attributes.sabit_asset_finish_date#ccc#"))>
						<cf_date tarih = "attributes.sabit_asset_finish_date#ccc#">
						<cfset finish_ = evaluate("attributes.sabit_asset_finish_date#ccc#")>
					</cfif>
				</cfif>
				<cfquery name="upd_" datasource="#dsn#">
					UPDATE
						EMPLOYEE_EMPLOYMENT_ROWS
					SET
						<cfif len(evaluate("attributes.sabit_asset_file#ccc#"))>
							ASSET_FILE = '#evaluate("sabit_file_name_#ccc#")#.#evaluate("sabit_file_name_ek_#ccc#")#',
						</cfif>
						ASSET_CAT_ID = #evaluate("attributes.sabit_asset_cat_id#ccc#")#,
						ASSET_DATE = <cfif len(evaluate("attributes.sabit_asset_date#ccc#"))>#evaluate("attributes.sabit_asset_date#ccc#")#<cfelse>NULL</cfif>,
						ASSET_FINISH_DATE = <cfif isdefined("finish_") and len(finish_) and len(evaluate("attributes.sabit_asset_date#ccc#"))>#finish_#<cfelse>NULL</cfif>,
						ASSET_NO = '#evaluate("attributes.sabit_asset_no#ccc#")#',
						ASSET_NAME = '#evaluate("attributes.sabit_asset_name#ccc#")#',
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
						UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						<cfif isDefined("attributes.x_employment_assets_process") and attributes.x_employment_assets_process eq 1>
							,EMPLOYMENT_STAGE = <cfif isDefined("attributes.sabit_process_stage") and len(attributes.sabit_process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#listGetAt(attributes.sabit_process_stage, ccc)#"><cfelse>NULL</cfif>
						</cfif>
					WHERE
						ROW_ID = #evaluate("attributes.row_id#ccc#")#
				</cfquery>
				<cfif isDefined("attributes.x_employment_assets_process") and attributes.x_employment_assets_process eq 1>
					<cfset line_number_ = 0>
					<cfif isDefined('attributes.sabit_old_process_line') and len(attributes.sabit_old_process_line)>
						<cfif listGetAt(attributes.sabit_old_process_line, ccc) neq -1>
							<cfset line_number_ = listGetAt(attributes.sabit_old_process_line, ccc)>
						</cfif>
					</cfif>
					<cf_workcube_process
						is_upd='1'
						data_source='#dsn#'
						old_process_line='#line_number_#'
						process_stage='#listGetAt(attributes.sabit_process_stage, ccc)#'
						record_member='#session.ep.userid#'
						record_date='#now()#'
						action_table='EMPLOYEE_EMPLOYMENT_ROWS'
						action_column='ROW_ID'
						action_id='#evaluate("attributes.row_id#ccc#")#'
						action_page='#request.self#?fuseaction=hr.popup_form_upd_emp_employment_assets&employee_id=#attributes.EMPLOYEE_ID#'
						warning_description='#message# : #evaluate("attributes.sabit_asset_cat_name#ccc#")#'>
				</cfif>
			</cfif>
		</cfif>
	<cfelseif isDefined("attributes.sabit_row_kontrol_#ccc#") and evaluate("attributes.sabit_row_kontrol_#ccc#") neq 1>
		<cfquery name="del_" datasource="#dsn#">
			DELETE FROM EMPLOYEE_EMPLOYMENT_ROWS WHERE ROW_ID = #evaluate("attributes.row_id#ccc#")#
		</cfquery>
		<cfif len(evaluate("attributes.old_file_name#ccc#"))>
			<cftry>
				<cffile action="delete" file="#upload_folder#hr#dir_seperator##evaluate('attributes.old_file_name#ccc#')#">
				<cfcatch type="any"></cfcatch>
			</cftry>
		</cfif>
	</cfif>
</cfloop>
<cfif listfirst(attributes.fuseaction,'.') eq 'myhome'>
	<cfset emp_id = contentEncryptingandDecodingAES(isEncode:1,content:attributes.EMPLOYEE_ID,accountKey:'wrk')>
<cfelse>
	<cfset emp_id = attributes.EMPLOYEE_ID>
</cfif>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_x_employment_assets_pages = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'hr.form_upd_emp',
    property_name : 'x_employment_assets_pages'
)>
<cfif get_x_employment_assets_pages.recordcount>
	<cfset x_employment_assets_pages = get_x_employment_assets_pages.property_value>
<cfelse>
	<cfset x_employment_assets_pages = 0>
</cfif>
<cfif x_employment_assets_pages eq 0>
	<cflocation addtoken="no" url="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.popup_form_emp_employment_assets&employee_id=#emp_id#">
<cfelse>
	<cflocation addtoken="no" url="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.popup_form_upd_emp_employment_assets&employee_id=#emp_id#">
</cfif>