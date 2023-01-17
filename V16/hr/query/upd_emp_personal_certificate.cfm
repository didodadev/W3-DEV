<cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
	SELECT
		LICENCECAT_ID, 
        LICENCECAT, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE, 
        IS_LAST_YEAR_CONTROL, 
        USAGE_YEAR
	FROM
		SETUP_DRIVERLICENCE
	ORDER BY
		IS_LAST_YEAR_CONTROL ASC,
		LICENCECAT
</cfquery>
<cfset temp = 1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='55367.Yetkinlik belgeleri'></cfsavecontent>
<cfoutput query="GET_DRIVER_LIS">
	<cfif isdefined("attributes.licence_type_#LICENCECAT_ID#")>
		<cfquery name="get_old_rows" datasource="#dsn#">
			SELECT 
        	    EMPLOYEE_ID, 
                LICENCECAT_ID, 
                LICENCE_START_DATE, 
                LICENCE_FINISH_DATE, 
                LICENCE_NO, 
                UPDATE_EMP, 
                UPDATE_DATE, 
                UPDATE_IP, 
                LICENCE_FILE,
				DRIVERLICENCE_ID
            FROM 
    	        EMPLOYEE_DRIVERLICENCE_ROWS 
            WHERE 
	            EMPLOYEE_ID = #attributes.EMPLOYEE_ID# 
            AND 
            	LICENCECAT_ID = #LICENCECAT_ID#
		</cfquery>
		<cfif len(evaluate("attributes.licence_file_#LICENCECAT_ID#"))>
			<cfif get_old_rows.recordcount and len(get_old_rows.licence_file)>
				<cftry>
					<cffile action="delete" file="#upload_folder#hr#dir_seperator##get_old_rows.licence_file#">
					<cfcatch type="any"></cfcatch>
				</cftry>
			</cfif>
			<cfset upload_folder = "#upload_folder#">
			<cftry>
				<cffile action = "upload" 
				  filefield = "licence_file_#LICENCECAT_ID#" 
				  destination = "#upload_folder#hr#dir_seperator#" 
				  nameconflict = "MakeUnique" 
				  mode="777">
				<cfcatch type="Any">
					<cfset error=1>
					<script type="text/javascript">
						alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz !");
						history.back();
					</script>
				</cfcatch>  
			</cftry>
			<cfset file_name = createUUID()>
			<cffile action="rename" source="#upload_folder#hr#dir_seperator##cffile.serverfile#" destination="#upload_folder#hr#dir_seperator##file_name#.#cffile.serverfileext#">
		</cfif>
		<cf_date tarih = "attributes.driver_licence_start_date_#LICENCECAT_ID#">
		<cf_date tarih = "attributes.driver_licence_finish_date_#LICENCECAT_ID#">
		<cfif len(usage_year)>
			<cfset finish_ = date_add('yyyy',usage_year,evaluate("attributes.driver_licence_start_date_#LICENCECAT_ID#"))>
		<cfelse>
			<cfset finish_ = date_add('yyyy',5,evaluate("attributes.driver_licence_start_date_#LICENCECAT_ID#"))>
		</cfif>
		<cfif get_old_rows.recordcount>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE 
					EMPLOYEE_DRIVERLICENCE_ROWS
				SET
					<cfif len(evaluate("attributes.licence_file_#LICENCECAT_ID#"))>LICENCE_FILE = '#file_name#.#cffile.serverfileext#',</cfif>
					EMPLOYEE_ID = #attributes.EMPLOYEE_ID#,
					LICENCECAT_ID = #LICENCECAT_ID#,
					LICENCE_START_DATE = #evaluate("attributes.driver_licence_start_date_#LICENCECAT_ID#")#,
					LICENCE_FINISH_DATE = <cfif len(evaluate("attributes.driver_licence_finish_date_#LICENCECAT_ID#"))>#evaluate("attributes.driver_licence_finish_date_#LICENCECAT_ID#")#<cfelse>NULL</cfif>,
					LICENCE_NO = '#evaluate("attributes.licence_no_#LICENCECAT_ID#")#',
					UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					UPDATE_IP  = <cfqueryparam cfsqltype="nvarchar" value="#cgi.REMOTE_ADDR#">
					<cfif isDefined("attributes.x_employment_assets_process") and attributes.x_employment_assets_process eq 1>
						,LICENCE_STAGE = <cfif isDefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#listGetAt(attributes.process_stage, temp)#"><cfelse>NULL</cfif>
					</cfif>
				WHERE
					EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND 
					LICENCECAT_ID = #LICENCECAT_ID#
			</cfquery>
			<cfif isDefined("attributes.x_employment_assets_process") and attributes.x_employment_assets_process eq 1>
				<cfset line_number_ = 0>
				<cfif isDefined('attributes.old_process_line') and len(attributes.old_process_line)>
					<cfif listGetAt(attributes.old_process_line, temp) neq -1>
						<cfset line_number_ = listGetAt(attributes.old_process_line, temp)>
					</cfif>
				</cfif>
				<cf_workcube_process
					is_upd='1'
					data_source='#dsn#'
					old_process_line='#line_number_#'
					process_stage='#listGetAt(attributes.process_stage, temp)#'
					record_member='#session.ep.userid#'
					record_date='#now()#'
					action_table='EMPLOYEE_DRIVERLICENCE_ROWS'
					action_column='DRIVERLICENCE_ID'
					action_id='#get_old_rows.DRIVERLICENCE_ID#'
					action_page='#request.self#?fuseaction=hr.popup_form_upd_emp_personal_certificate&employee_id=#attributes.EMPLOYEE_ID#'
					warning_description='#message# : #LICENCECAT#'>
			</cfif>
		<cfelse>
			<cfquery name="add_" datasource="#dsn#" result="MAX_ID">
				INSERT INTO
					EMPLOYEE_DRIVERLICENCE_ROWS
					(
					LICENCE_FILE,
					EMPLOYEE_ID,
					LICENCECAT_ID,
					LICENCE_START_DATE,
					LICENCE_FINISH_DATE,
					LICENCE_NO,
					UPDATE_EMP,
					UPDATE_DATE,
					UPDATE_IP
					<cfif isDefined("attributes.x_employment_assets_process") and attributes.x_employment_assets_process eq 1>
						,LICENCE_STAGE
					</cfif>
					)
					VALUES
					(
					<cfif len(evaluate("attributes.licence_file_#LICENCECAT_ID#"))>'#file_name#.#cffile.serverfileext#',<cfelse>NULL,</cfif>
					#attributes.EMPLOYEE_ID#,
					#LICENCECAT_ID#,
					#evaluate("attributes.driver_licence_start_date_#LICENCECAT_ID#")#,
					<cfif len(evaluate("attributes.driver_licence_finish_date_#LICENCECAT_ID#"))>#evaluate("attributes.driver_licence_finish_date_#LICENCECAT_ID#")#<cfelse>NULL</cfif>,
					'#evaluate("attributes.licence_no_#LICENCECAT_ID#")#',
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="nvarchar" value="#cgi.REMOTE_ADDR#">
					<cfif isDefined("attributes.x_employment_assets_process") and attributes.x_employment_assets_process eq 1>
						,<cfif isDefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#listGetAt(attributes.process_stage, temp)#"><cfelse>NULL</cfif>
					</cfif>
					)
			</cfquery>
			<cfif isDefined("attributes.x_employment_assets_process") and attributes.x_employment_assets_process eq 1>
				<cf_workcube_process
					is_upd='1'
					data_source='#dsn#'
					old_process_line='0'
					process_stage='#listGetAt(attributes.process_stage, temp)#'
					record_member='#session.ep.userid#'
					record_date='#now()#'
					action_table='EMPLOYEE_DRIVERLICENCE_ROWS'
					action_column='DRIVERLICENCE_ID'
					action_id='#MAX_ID.IDENTITYCOL#'
					action_page='#request.self#?fuseaction=hr.popup_form_upd_emp_personal_certificate&employee_id=#attributes.EMPLOYEE_ID#'
					warning_description='#message# : #LICENCECAT#'>
			</cfif>
		</cfif>
	<cfelse>
		<cfquery name="get_old_rows" datasource="#dsn#">
			SELECT 
        	    EMPLOYEE_ID, 
                LICENCECAT_ID, 
                LICENCE_START_DATE, 
                LICENCE_FINISH_DATE, 
                LICENCE_NO, 
                UPDATE_EMP, 
                UPDATE_DATE, 
                UPDATE_IP, 
                LICENCE_FILE 
            FROM
    	        EMPLOYEE_DRIVERLICENCE_ROWS 
            WHERE 
	            EMPLOYEE_ID = #attributes.EMPLOYEE_ID# 
            AND 
            	LICENCECAT_ID = #LICENCECAT_ID#
		</cfquery>
		<cfif get_old_rows.recordcount>
			<cfif len(get_old_rows.licence_file)>
				<cftry>
					<cffile action="delete" file="#upload_folder#hr#dir_seperator##get_old_rows.licence_file#">
					<cfcatch type="any"></cfcatch>
				</cftry>
			</cfif>
			<cfquery name="del_old_row" datasource="#dsn#">
				DELETE FROM EMPLOYEE_DRIVERLICENCE_ROWS WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND LICENCECAT_ID = #LICENCECAT_ID#
			</cfquery>
		</cfif>
	</cfif>
	<cfset temp++>
</cfoutput>
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
	<cflocation addtoken="no" url="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.popup_form_upd_emp_personal_certificate&employee_id=#emp_id#">
</cfif>