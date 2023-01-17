<!---
Description :   
    Writes phases over related phase file
Parameters :
    action       --> Phase File Action    'required
	                 ... write_single : write only one phase over related phase file
	                 ... write_all    : write all phases over related phase file
    phase_file   --> Phase File Name     'required
    phase_id     --> Phase ID            'required for write_single action
    phase_name   --> Phase Text          'required for write_single action
    phase_detail --> Phase Detail        'required for write_single action
Syntax :
	<cf_phase_file action       = "<Phase File Action>"
				   phase_file   = "<Phase File Name>"
				   phase_id     = "<Phase ID>"
				   phase_name   = "<Phase Text>"
				   phase_detail = "<Phase Detail>">
Sample :
	<cf_phase_file action       = "write_single"
				   phase_file   = "employ"
				   phase_id     = "#attributes.TR_ID#"
				   phase_name   = "#attributes.TR_NAME#"
				   phase_detail = "#attributes.TR_DETAIL#">
	created Ömür Camcı 20030723
	modified Ömür Camcı 20030723 sayfa düzenleme yapıldı
 --->

<cfset upload_folder = caller.upload_folder & ".." & "/workcubeanalyse/properties/phases/">
<cfif attributes.action eq 'write_single'>
	<cfif not FileExists("#upload_folder##attributes.phase_file#.properties")>
		<cffile action="write" 
				file="#upload_folder##attributes.phase_file#.properties" 
				output="process.phase#attributes.phase_id#=#attributes.phase_name#;#attributes.phase_detail#"
				charset="UTF-8" mode="777">
	<cfelse>
		<cffile action="append" 
				file="#upload_folder##attributes.phase_file#.properties" 
				output="process.phase#attributes.phase_id#=#attributes.phase_name#;#attributes.phase_detail#"
				charset="UTF-8" mode="777">			 
	</cfif>
<cfelseif attributes.action eq 'write_all'>
	<cfquery name="get_position_track_rows" datasource="#caller.dsn#">
		#attributes.query#
	</cfquery>
	<cfset ind = 0 >
	<cfloop query="get_position_track_rows">
			<cfif ind eq 0>
				<cffile action="write" 
						file="#upload_folder##attributes.phase_file#.properties" 
						output="process.phase#ind#=#TR_NAME#;#TR_DETAIL#"
						charset="UTF-8" mode="777">
			<cfelse>
				<cffile action="append" 
						file="#upload_folder##attributes.phase_file#.properties" 
						output="process.phase#ind#=#TR_NAME#;#TR_DETAIL#"
						charset="UTF-8" mode="777">			 
			</cfif>
			<cfset ind = ind + 1 >
	</cfloop>
</cfif>

<cfquery name="GET_PHASESS" datasource="#CALLER.DSN#">
	SELECT
		PHASE_SECTION,
		PHASE_MODULE
	FROM
		SETUP_PHASE_TABLE
	WHERE
		PHASE_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.phase_file#">
</cfquery>

<cfif get_phases.RecordCount eq 0>
	<cfquery name="SET_PHASE_TABLE" datasource="#CALLER.DSN#">
		INSERT INTO 
        	SETUP_PHASE_TABLE
        (
            PHASE_SECTION,
            PHASE_MODULE
        )
		VALUES
        (
            '#attributes.phase_file#' ,
            '#caller.fusebox.circuit#'
        )
	</cfquery>
</cfif>
