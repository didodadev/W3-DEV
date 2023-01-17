<cfif attributes.type eq 1><!--- 1 ise display --->
	<cfset file_names = attributes.display_file_name>
<cfelseif attributes.type eq 2><!--- 2 ise action --->
	<cfset file_names = attributes.file_name>
</cfif>
<!--- History için kayıtlar atılıyor. --->
<cfif isdefined('attributes.process_id_') or isdefined('attributes.process_row_id_')>
	<cfquery name="ADD_PROCESS_HOSTORY" datasource="#DSN#">
		INSERT INTO
			PROCESS_FILE_HISTORY
		(
			TYPE,
			PROCESS_ID,
			PROCESS_ROW_ID,
			<cfif attributes.type eq 1>
			DISPLAY_FILE_NAME,
			DISPLAY_FILE,
			<cfelseif attributes.type eq 2>
			ACTION_FILE_NAME,
			ACTION_FILE,
			</cfif>
			UPDATE_EMP,
			UPDATE_IP,
			UPDATE_DATE
		)
		VALUES
		(
			<cfif attributes.type eq 1>1<cfelse>0</cfif>,
			<cfif isdefined('attributes.process_id_')>#attributes.process_id_#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.process_row_id_')>#attributes.process_row_id_#<cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#file_names#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dosya_icerik#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#now()#
		)	
	</cfquery>
<cfelseif isdefined('attributes.process_cat_id_')>
	<cfquery name="ADD_PROCESS_CAT_HISTORY_FILE" datasource="#DSN3#">
		INSERT INTO
			PROCESS_CAT_HISTORY_FILE
		(
			TYPE,
			PROCESS_CAT_ID,
			<cfif attributes.type eq 1>
			DISPLAY_FILE_NAME,
			DISPLAY_FILE,
			<cfelseif attributes.type eq 2>
			ACTION_FILE_NAME,
			ACTION_FILE,
			</cfif>
			UPDATE_EMP,
			UPDATE_IP,
			UPDATE_DATE
		)
		VALUES
		(
			<cfif attributes.type eq 1>1<cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_id_#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#file_names#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dosya_icerik#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#now()#
		)
	</cfquery>
</cfif>
<cfif attributes.ftype eq 1>
	<cffile action="write" file="#index_folder#process#dir_seperator#files#dir_seperator##file_names#" output="#attributes.dosya_icerik#" charset="utf-16">
<cfelse>
	<cffile action="write" file="#upload_folder#settings#dir_seperator##file_names#" output="#attributes.dosya_icerik#" charset="utf-16">
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
	<cfelse>
		history.go(-1);
    	window.close();
	</cfif>
</script>
