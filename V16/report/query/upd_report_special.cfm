<!--- Dosya Upload --->
<cfif len(file_name)>
	<cfset upload_folder2 = "#upload_folder#report#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
		  fileField = "file_name" 
		  destination = "#upload_folder2#" 
		  nameConflict = "MakeUnique" 
		  mode="777">
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang no='16.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !'>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	<cfset file_name = createUUID()>
	<cffile action='rename' source='#upload_folder2##cffile.serverfile#' destination='#upload_folder2##file_name#.#cffile.serverfileext#'>
	<cffile action='read' file='#upload_folder2##file_name#.#cffile.serverfileext#' variable="dosya">
	<cfif not session.ep.admin>
		<cfif (dosya contains "<cfdirectory") or (dosya contains "<cffile") or (dosya contains "<cfexecute")>
			<cffile action="delete" file='#upload_folder2##file_name#.#cffile.serverfileext#' variable="dosya">
			<script type="text/javascript">
				alert("<cf_get_lang no='17.İzin Verilmeyen Fonksiyon İçeren Dosya Upload Etmeye Çalıştınız !'>");
				history.back();
			</script>
			<cfabort>
		</cfif> 
	</cfif>
	
	<!--- Eski dosyanin silinmesi --->
	<cfset form.photo = '#file_name#.#cffile.serverfileext#'>
	
	<cfquery name="GET_FILE" datasource="#DSN#">
		SELECT
			FILE_NAME,
			FILE_SERVER_ID
		FROM
			REPORTS
		WHERE
			REPORT_ID = #attributes.report_id#
	</cfquery>
	<cftry>
		<cf_del_server_file output_file="report#dir_seperator##get_file.file_name#" output_server="#get_file.file_server_id#">
		<cfcatch type="any">
			<cf_get_lang no='19.Dosya Bulunamadı Ama Veritabanından Silindi !'>
		</cfcatch>
	</cftry>
</cfif>
<cfquery name="UPD_REPORT" datasource="#DSN#">
	UPDATE
		REPORTS
	SET
		REPORT_NAME = '#FORM.REPORT_NAME#', 
		REPORT_DETAIL = '#FORM.REPORT_DETAIL#',
	<cfif len(file_name)>
		FILE_NAME = '#FORM.PHOTO#',
		FILE_SERVER_ID=#fusebox.server_machine#,
		CFM_FILE_NAME = '#attributes.cfm_name#',
		CFM_FILE_SERVER_ID=#fusebox.server_machine#,
	</cfif>
		IS_FILE = <cfif isdefined("attributes.is_file")>1,<cfelse>0,</cfif>
		ADMIN_STATUS = <cfif isdefined("attributes.admin_status")>1,<cfelse>0,</cfif>
		REPORT_STATUS = <cfif isdefined("attributes.report_status")>1<cfelse>0</cfif>,
		UPDATE_EMP = #SESSION.EP.USERID#, 
		UPDATE_IP = '#cgi.REMOTE_ADDR#', 
		UPDATE_DATE = #NOW()#,
        REPORT_CAT_ID = <cfif len(attributes.REPORT_CAT_ID)>#attributes.REPORT_CAT_ID#<cfelse>NULL</cfif>,
		MODUL_NO = <cfif isdefined("attributes.module") and len(attributes.module)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.module#"><cfelse>NULL</cfif>
	WHERE
		REPORT_ID = #attributes.report_id#
</cfquery>

<cfquery name="DEL_ACCESS_CONTROL" datasource="#DSN#">
    DELETE FROM
        REPORT_ACCESS_RIGHTS 
    WHERE
        REPORT_ID = #attributes.report_id# AND
        POS_CAT_ID IS NULL
</cfquery>
<cfif isdefined("attributes.to_pos_codes") and len(attributes.to_pos_codes) gt 0>
	<cfloop list="#attributes.to_pos_codes#" index="a">
		<cfquery name="ADD_ACCESS_CONTROL" datasource="#DSN#">
			SELECT
				COUNT(*) AS ACCESS_CONTROL 
			FROM 
				REPORT_ACCESS_RIGHTS 
			WHERE 
				REPORT_ID = #attributes.report_id# AND
				POS_CAT_ID IS NULL AND
				POS_CODE = #a#
		</cfquery>
		
		<cfif add_access_control.access_control neq 1>
			<cfquery name="ADD_ACCESS" datasource="#DSN#">
				INSERT INTO
					REPORT_ACCESS_RIGHTS
				(
					REPORT_ID,
					POS_CAT_ID,
					POS_CODE
				)
				VALUES
				(
				   #attributes.report_id#,
				   NULL,
				   #a#
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
		
<cfif isdefined("attributes.position_cats") and len(attributes.position_cats) gt 0>
	<cfquery name="DEL_ACCESS_CONTROL" datasource="#DSN#">
		DELETE FROM 
			REPORT_ACCESS_RIGHTS 
		WHERE 
			REPORT_ID = #attributes.report_id# AND
			POS_CODE IS NULL
	</cfquery>
	<cfloop list="#attributes.position_cats#" index="a">
		<cfquery name="ADD_ACCESS_CONTROL" datasource="#DSN#">
			SELECT
				COUNT(*) AS ACCESS_CONTROL 
			FROM 
				REPORT_ACCESS_RIGHTS 
			WHERE 
				REPORT_ID = #attributes.report_id# AND
				POS_CAT_ID = #a# AND
				POS_CODE IS NULL 
		</cfquery>
		
		<cfif add_access_control.access_control neq 1>
			<cfquery name="ADD_ACCESS" datasource="#DSN#">
				INSERT INTO
					REPORT_ACCESS_RIGHTS
				(
					REPORT_ID,
					POS_CAT_ID,
					POS_CODE
				)
				VALUES
				(
				   #attributes.report_id#,
				   #a#,
				   NULL
				)
			</cfquery>
		</cfif>
	</cfloop>	
</cfif>
<script>
	window.location='<cfoutput>#request.self#?fuseaction=report.list_reports&event=upd&report_id=#attributes.report_id#</cfoutput>';
</script>

