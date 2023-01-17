<cftry>
	<cfif isdefined("attributes.work_id") and len(attributes.work_id)>
		 <cfquery name="GetWorkModul" datasource="#dsn#">
			SELECT WORK_CIRCUIT,WORK_FUSEACTION FROM PRO_WORKS WHERE WORK_ID=#attributes.work_id#
		</cfquery>
	</cfif>
	<cfquery name="saveWork" datasource="#dsn#">
		INSERT INTO TEST_CHECK_MAIN
		(
			<cfif isdefined("attributes.work_id") and len(attributes.work_id)>
				WORK_ID,
				FUSEACTION,
				MODUL_SHORT_NAME,
			<cfelse>
				FUSEACTION,
				MODUL_SHORT_NAME,
			</cfif>
			IS_ALL_CHECK,
			RECORD_DATE,
			RECORD_ID,
			RECORD_EMP
		)
		VALUES
		(	
			<cfif isdefined("attributes.work_id") and len(attributes.work_id)>
				#attributes.work_id#,
				<cfif isdefined("GetWorkModul") and  len(GetWorkModul.work_fuseaction)>'#GetWorkModul.work_fuseaction#'<cfelse>NULL</cfif>,
				<cfif isdefined("GetWorkModul") and  len(GetWorkModul.work_circuit)>'#GetWorkModul.work_circuit#'<cfelse>NULL</cfif>,
			<cfelse>
				'#attributes.faction#',
				'#attributes.modul_short_name#',
			</cfif>
			#attributes.is_yes#,	
			#now()#,
			'#cgi.remote_addr#',
			#session.ep.userid#
		)
		SELECT SCOPE_IDENTITY() AS MAX_ID
	</cfquery>
	<cfloop from="1" to="#attributes.row#" index="row">
		<cfquery name="addCheckRow" datasource="#dsn#">
			INSERT INTO TEST_CHECK_ROW
			(
				SUBJECT_ID,
				STATUS,
				DETAIL,
				CHECK_ID
			)
			VALUES
			(	
				#evaluate("attributes.subject_id_#row#")#,
				<cfif isdefined("chk_yes_#row#")>#evaluate("chk_yes_#row#")#<cfelseif isdefined("chk_no_#row#")>#evaluate("chk_no_#row#")#<cfelse>NULL</cfif>,
				'#evaluate("detail_#row#")#',
				#saveWork.max_id#
			)	
		</cfquery>
	</cfloop>
	<script type="text/javascript">
		//wrk_opener_reload();
		window.close();
	</script>
    <cfcatch>
        <script type="text/javascript">
            alert("<cf_get_lang_main no='56.Belge'> <cf_get_lang no='75.Kaydedilmedi'>!");
            history.back();
        </script>
        <cfabort>
    </cfcatch>
</cftry>

