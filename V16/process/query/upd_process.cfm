<!--- 	Dikkat : Display file dosyamiz main_action_file alaninda, Action file dosyamiz main_file alanina kayit atmaktadir. 
		Upload edilen dosyalar documents\settings klasorune kaydedilir. BK 20061001 --->

<cfquery name="Get_File_Control" datasource="#dsn#">
	SELECT * FROM PROCESS_TYPE WHERE PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
</cfquery>
<cflock name="#createUUID()#" timeout="60">
<cftransaction>
	<!--- Display File Upload --->
	<cfif (not Len(attributes.main_action_file) and not Len(attributes.main_action_file_rex)) or (Len(attributes.main_action_file_rex) and attributes.is_main_action_file eq 1)>
		<!--- Display file tamamen silindiğinde --->
		<cfif Len(Get_File_Control.main_action_file) and Get_File_Control.is_main_action_file neq 1>
			<cf_del_server_file output_file="settings/#Get_File_Control.main_action_file#" output_server="#Get_File_Control.main_action_file_server_id#">
		</cfif>
	</cfif>
	<cfif Len(attributes.main_action_file) and not Len(attributes.main_action_file_rex)>
		<!--- Yeni Bir Display File Eklendiginde --->
		<cftry>
			<cffile action = "upload" fileField = "main_action_file" destination = "#upload_folder#settings#dir_seperator#" nameConflict = "MakeUnique" mode="777">
			<cfset file_name = createUUID() & '.' & cffile.serverfileext>
			<cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##file_name#">
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang no ='102.Display Dosyanız Upload Edilemedi! Dosyanızı Kontrol Ediniz'>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
		<!--- Güncelleme yapıldığında eski dosya silinir --->
		<cfif len(Get_File_Control.main_action_file)>
			<cf_del_server_file output_file="settings/#Get_File_Control.main_action_file#" output_server="#Get_File_Control.main_action_file_server_id#">
		</cfif>
	</cfif>
	<!--- //Display File Upload --->
	
	<!--- Action File Upload--->
	<cfif (not Len(attributes.main_file) and not Len(attributes.main_file_rex)) or (Len(attributes.main_file_rex) and attributes.is_main_file eq 1)>
		<!--- Action file tamamen silindiğinde --->
		<cfif Len(Get_File_Control.main_file) and Get_File_Control.is_main_file neq 1>
			<cf_del_server_file output_file="settings/#Get_File_Control.main_file#" output_server="#Get_File_Control.main_file_server_id#">
		</cfif>
	</cfif>
	<cfif Len(attributes.main_file) and not Len(attributes.main_file_rex)>
		<!--- Yeni Bir Action File Eklendiginde --->
		<cftry>
			<cffile action = "upload" fileField = "main_file" destination = "#upload_folder#settings#dir_seperator#" nameConflict = "MakeUnique" mode="777">
			<cfset file_name_action = createUUID() & '.' & cffile.serverfileext>
			<cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##file_name_action#">
			
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang no ='103.Action Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
		<!--- Güncelleme yapıldığında eski dosya silinir --->
		<cfif len(Get_File_Control.main_file)>
			<cf_del_server_file output_file="settings/#Get_File_Control.main_file#" output_server="#Get_File_Control.main_file_server_id#">
		</cfif>
	</cfif>
	<!--- //Action File Upload--->
	
	<cfquery name="UPD_PROCESS" datasource="#dsn#">
		UPDATE
			PROCESS_TYPE
		SET
			IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
			PROCESS_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_name#">,
			DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
			FACTION = <cfif len(attributes.module_field_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_field_name#"><cfelse>NULL</cfif>,
			IS_STAGE_BACK = <cfif isdefined("attributes.is_stage_back")>1<cfelse>0</cfif>,
			IS_STAGE_MANUEL_CHANGE = <cfif isdefined("attributes.is_stage_manuel_change")>1<cfelse>0</cfif>,
			<cfif Len(attributes.main_action_file) and not Len(attributes.main_action_file_rex)>
				MAIN_ACTION_FILE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#">,
				MAIN_ACTION_FILE_SERVER_ID = #fusebox.server_machine#,
			<cfelseif Len(attributes.main_action_file_rex)>
				MAIN_ACTION_FILE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_action_file_rex#">,
				MAIN_ACTION_FILE_SERVER_ID = #fusebox.server_machine#,
			<cfelse>
				MAIN_ACTION_FILE = NULL,
				MAIN_ACTION_FILE_SERVER_ID = NULL,
			</cfif>
			IS_MAIN_ACTION_FILE = <cfif isDefined("attributes.is_main_action_file") and Len(attributes.is_main_action_file)>1<cfelse>NULL</cfif>,
			<cfif Len(attributes.main_file) and not Len(attributes.main_file_rex)>
				MAIN_FILE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name_action#">,
				MAIN_FILE_SERVER_ID = #fusebox.server_machine#,
			<cfelseif Len(attributes.main_file_rex)>
				MAIN_FILE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_file_rex#">,
				MAIN_FILE_SERVER_ID = #fusebox.server_machine#,
			<cfelse>
				MAIN_FILE = NULL,
				MAIN_FILE_SERVER_ID = NULL,
			</cfif>
			IS_MAIN_FILE = <cfif isDefined("attributes.is_main_file") and Len(attributes.is_main_file)>1<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			UPDATE_EMP = #session.ep.userid#,
			DEPARTMENT_ID = <cfif isdefined("attributes.department_id") and len(attributes.department_id) and isdefined("attributes.department") and len(attributes.department)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"><cfelse>NULL</cfif>,
			UPPER_DEP_ID = <cfif isdefined("attributes.up_department_id") and len(attributes.up_department_id) and isdefined("attributes.up_department") and len(attributes.up_department)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.up_department_id#"><cfelse>NULL</cfif>,
			RESP_EMP_ID = <cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.employee_name") and len(attributes.employee_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"><cfelse>NULL</cfif>,
			FRIENDLY_URL = <cfif len(attributes.widget_friendly_url)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.widget_friendly_url#"><cfelse>NULL</cfif>,
			PAGE_NAME = <cfif len(attributes.module_page_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_page_name#"><cfelse>NULL</cfif>
		WHERE
			PROCESS_ID = #attributes.process_id#
	</cfquery>
	<cfquery name="main_process_control" datasource="#dsn#">
		SELECT PROCESS_ID FROM PROCESS_MAIN_ROWS WHERE PROCESS_ID = #attributes.process_id#
	</cfquery>
	<cfif main_process_control.recordcount>
		<cfquery name="UPD_MAIN_PROCESS" datasource="#dsn#">
			UPDATE
				PROCESS_MAIN_ROWS
			SET
				PROCESS_MAIN_ID	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.item_process_main_id#">
			WHERE
				PROCESS_ID = #attributes.process_id#
		</cfquery>
	<cfelse>
		<cfquery name="record_main_rows" datasource="#dsn#">
			INSERT INTO
				PROCESS_MAIN_ROWS
				(	
					PROCESS_MAIN_ID,
					PROCESS_ID,
					DISPLAY_HEADER,
					ACTION_HEADER,
					DESIGN_OBJECT_TYPE,
					DESIGN_TITLE,
					DESIGN_XY_COORD,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					<cfif isdefined('attributes.item_process_main_id') and len(attributes.item_process_main_id)>#attributes.item_process_main_id#<cfelse>Null</cfif>,
					#attributes.process_id#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="Display File">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="Action File">,
					0,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_name#">,
					'0,0;;',
					#now()#,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">	
				)
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.is_active")><cfset is_active_ =1><cfelse><cfset is_active_ =0></cfif>
	<cfif isdefined("attributes.is_stage_back")><cfset is_stage_back_ =1><cfelse><cfset is_stage_back_ =0></cfif>
	<cfif 	(Get_File_Control.is_active neq is_active_) or (Get_File_Control.is_stage_back neq is_stage_back_) or
			(Get_File_Control.process_name neq attributes.process_name) or (Get_File_Control.faction neq attributes.module_field_name)>
	
		<cfquery name="ADD_PROCESS_TYPE_HISTORY" datasource="#dsn#">
			INSERT INTO
				PROCESS_TYPE_HISTORY
			(
				PROCESS_ID,
				IS_ACTIVE,
				PROCESS_NAME,
				FACTION,
				IS_STAGE_BACK,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				FRIENDLY_URL,
				PAGE_NAME
			)
			VALUES
			(
				#attributes.process_id#,
				#Get_File_Control.is_active#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_File_Control.process_name#">,
				<cfif len(Get_File_Control.faction)><cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_File_Control.faction#"><cfelse>NULL</cfif>,
				<cfif len(Get_File_Control.is_stage_back)>#Get_File_Control.is_stage_back#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfif len(attributes.widget_friendly_url)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.widget_friendly_url#"><cfelse>NULL</cfif>,
				<cfif len(attributes.module_page_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_page_name#"><cfelse>NULL</cfif>
			)
		</cfquery>
	</cfif>
	<cfif isDefined("attributes.process_our_company_id") and Len(attributes.process_our_company_id)>
		<!--- Iliskili Sirketler --->
		<cfquery name="Del_Process_Type_Our_Company" datasource="#dsn#">
			DELETE FROM PROCESS_TYPE_OUR_COMPANY WHERE PROCESS_ID = #attributes.process_id#
		</cfquery>
		<cfloop list="#attributes.process_our_company_id#" index="poc">
			<cfquery name="Add_Process_Type_Our_Company" datasource="#dsn#">
				INSERT INTO
					PROCESS_TYPE_OUR_COMPANY
				(	PROCESS_ID, OUR_COMPANY_ID	)
				VALUES
				(	#attributes.process_id#, #poc#	)
			</cfquery>
		</cfloop>
	</cfif>
	
	<!--- Calismayi engelledigi ve kaldirilmasi talep edildigi icin kaldirildi FBS 20111007
	<!--- Display File icin Wrk_Query( Kullanimi Engellenir --->
	<cfquery name="Get_File_Content_Control" datasource="#dsn#">
		SELECT MAIN_ACTION_FILE FROM PROCESS_TYPE WHERE PROCESS_ID = #attributes.process_id#
	</cfquery>
	<cfif Len(Get_File_Content_Control.main_action_file)>
		<cffile action="read" file="#upload_folder#settings#dir_seperator##Get_File_Content_Control.main_action_file#" variable="content_control">
		<cfif FindNoCase("wrk_query(",content_control)>
			<script type="text/javascript">
				alert("Dosya İçeriğinde Kullanılmaması Gereken Bir İfade Kullanılmıştır. (wrk_query)\nLütfen Kontrol Ediniz!");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<!--- //Display File icin Wrk_Query( Kullanimi Engellenir ---> --->
	
</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href ="<cfoutput>#request.self#?fuseaction=process.list_process&event=upd&process_id=#attributes.process_id#</cfoutput>";
</script>

