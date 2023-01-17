<cfset upload_folder2 = "#upload_folder#">
<cfset upload_folder = "#upload_folder#report#dir_seperator#">
 <cftry>
    <cffile action = "upload" 
        fileField = "file_name" 
        destination = "#upload_folder#" 
        nameConflict = "MakeUnique" 
        mode="777">
    <cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !'>");
			history.back();
        </script>
        <cfabort>
    </cfcatch>  
</cftry> 
<cfset file_name = createUUID()>
<cffile action='rename' source='#upload_folder##cffile.serverfile#' destination='#upload_folder##file_name#.#cffile.serverfileext#'>

<cffile action='read' file='#upload_folder##file_name#.#cffile.serverfileext#' variable="dosya">
<cfif not session.ep.admin>
 <cfif (dosya contains "<cfdirectory") or (dosya contains "<cffile") or (dosya contains "<cfexecute")>
	<cffile action="delete" file='#upload_folder##file_name#.#cffile.serverfileext#' variable="dosya">
	<script type="text/javascript">
		alert("<cf_get_lang no='17.İzin Verilmeyen Fonksiyon İçeren Dosya Upload Etmeye Çalıştınız !'>");
		history.back();
	</script>
	<cfabort>
</cfif> 
</cfif>
<cfset form.report_file = '#file_name#.#cffile.serverfileext#'>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>

	<cfquery name="ADD_REPORT" datasource="#DSN#" result="MAX_ID">
		INSERT INTO
			REPORTS
		(
			REPORT_NAME, 
			REPORT_DETAIL,
			FILE_NAME,
			FILE_SERVER_ID,
			CFM_FILE_NAME,
			CFM_FILE_SERVER_ID,
			IS_SPECIAL,
			IS_FILE,
			ADMIN_STATUS,
			REPORT_STATUS,
			RECORD_EMP, 
			RECORD_IP, 
			RECORD_DATE,
            REPORT_CAT_ID,
			MODUL_NO
		)
		VALUES
		(
			'#FORM.REPORT_NAME#', 
			'#FORM.REPORT_DETAIL#', 
			'#FORM.report_file#',
			#fusebox.server_machine#,
			'#cffile.serverFile#',
			#fusebox.server_machine#,
			1,
			<cfif isdefined("attributes.is_file")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.admin_status")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.report_status")>1<cfelse>0</cfif>,
			#SESSION.EP.USERID#, 
			'#cgi.REMOTE_ADDR#', 
			#NOW()# ,
			<cfif len(FORM.REPORT_CAT_ID)>#attributes.REPORT_CAT_ID#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.module") and len(attributes.module)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.module#"><cfelse>NULL</cfif>
			)
	</cfquery>
	<cfif isdefined("attributes.to_pos_codes") and len(attributes.to_pos_codes) gt 0>
	  <cfloop list="#attributes.to_pos_codes#" index="a">
		<cfquery name="ADD_ACCESS_CONTROL" datasource="#DSN#">
			SELECT
				COUNT(*) AS ACCESS_CONTROL 
			FROM 
				REPORT_ACCESS_RIGHTS 
			WHERE 
				REPORT_ID = #MAX_ID.IDENTITYCOL# AND
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
				   #MAX_ID.IDENTITYCOL#,
				   NULL,
				   #a#
				)
			</cfquery>
		</cfif>
	  </cfloop>
	</cfif>
		
	<cfif isdefined("attributes.position_cats") and len(attributes.position_cats) gt 0>
	  <cfloop list="#attributes.position_cats#" index="a">
		<cfquery name="ADD_ACCESS_CONTROL" datasource="#DSN#">
			SELECT
				COUNT(*) AS ACCESS_CONTROL 
			FROM 
				REPORT_ACCESS_RIGHTS 
			WHERE 
				REPORT_ID = #MAX_ID.IDENTITYCOL# AND
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
				   #MAX_ID.IDENTITYCOL#,
				   #a#,
				   NULL
				)
			</cfquery>
		</cfif>
		
	  </cfloop>	
	</cfif>
	</cftransaction>
</cflock>
<script>
	window.location='<cfoutput>#request.self#?fuseaction=report.list_reports&event=upd&report_id=#max_id.identitycol#</cfoutput>';
</script>
