<cfset error = 0>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="GET_FILE" datasource="#DSN#">
			SELECT MODUL_SHORT_NAME,FOLDER,FILE_NAME FROM WRK_OBJECTS WHERE WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.woid#">
		</cfquery>
        <cfquery name="GET_FILE_COUNT" datasource="#DSN#">
			SELECT 
                MODUL_SHORT_NAME,
                FOLDER,
                FILE_NAME,
                WRK_OBJECTS_ID,
                FRIENDLY_URL 
            FROM 
            	WRK_OBJECTS 
            WHERE 
            	FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_FILE.FILE_NAME#"> AND
                MODUL_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_FILE.MODUL_SHORT_NAME#"> AND
				FOLDER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_FILE.FOLDER#">
		</cfquery>
		<cfoutput query="GET_FILE">
			<cfif modul_short_name eq 'call'>
				<cfset get_file.modul_short_name = 'callcenter'>
			<cfelseif modul_short_name eq 'dev'>
				<cfset get_file.modul_short_name = 'development'>
			<cfelseif modul_short_name eq 'prod'>
				<cfset get_file.modul_short_name = 'production_plan'>
			<cfelseif modul_short_name eq 'ehesap'>
				<cfset get_file.modul_short_name = 'hr/ehesap'>
			<cfelseif modul_short_name eq 'rule'>
				<cfset get_file.modul_short_name = 'rules'>
			<cfelseif modul_short_name eq 'account'>
				<cfset get_file.modul_short_name = 'account/account'>
			<cfelseif modul_short_name eq 'pda'>
				<cfset get_file.modul_short_name = 'workcube_pda'>
			</cfif>
		</cfoutput>
		<cfif get_file_count.recordcount gt 1 and not isdefined("attributes.del_check")>
        	<script type="text/javascript">
    			if (confirm('Dosya Başka Fuseaction Tanımında Kullanılmıştır Fuseaction Kaydı Silinecek Emin misiniz ?') == false)
					history.back();
				else
					window.location='<cfoutput>#request.self#?fuseaction=dev.emptypopup_del_fuseaction&woid=#attributes.woid#&del_check=1</cfoutput>';
			</script>
			<cfabort>
		<cfelseif get_file_count.recordcount eq 1 and not isdefined("attributes.del_check")>
			<script type="text/javascript">
    			if (confirm('Fuseaction ve Dosya Silinecek Emin misiniz?') == false)
					history.back();
				else
					window.location='<cfoutput>#request.self#?fuseaction=dev.emptypopup_del_fuseaction&woid=#attributes.woid#&del_check=1</cfoutput>';
			</script>
			<cfabort>
        </cfif>
        <!--- <cfloop query="GET_FILE_COUNT"> --->
        <cfif get_file_count.recordcount>
        	<cfset temp_wrk_objects_id = get_file_count.wrk_objects_id>
        <cfelse>
        	<cfset temp_wrk_objects_id = attributes.woid>        
        </cfif>
            <cf_wrk_get_history 
                datasource= '#DSN#'
                source_table= 'WRK_OBJECTS'
                target_table= 'WRK_OBJECTS_HISTORY'
                record_id= '#temp_wrk_objects_id#'
                record_name='WRK_OBJECTS_ID'>
            <cfquery name="del_fuseaction_relation" datasource="#DSN#">
                DELETE FROM WRK_OBJECTS_RELATION WHERE WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#temp_wrk_objects_id#">
            </cfquery>
            
            <cfquery name="add_wrk_objects" datasource="#DSN#">
                DELETE FROM WRK_OBJECTS	WHERE WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#temp_wrk_objects_id#">			
            </cfquery>
            
            <cfif isdefined("attributes.user_url_id")>
                <cfquery name="UPD_USER_FRIENDLY_URL" datasource="#DSN#">
                    DELETE FROM	USER_FRIENDLY_URLS WHERE USER_URL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_file_count.FRIENDLY_URL#">
                </cfquery>
            </cfif>
            
			<!--- BK kapatti 20120424 6 aya silinsin
			<cfquery name="DEL_PROCESS_CAT_ROWS" datasource="#DSN#">
				DELETE FROM FUSEACTION_POS_ID WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#temp_wrk_objects_id#">
			</cfquery> --->
            <cfif get_file_count.recordcount eq 1>
				<cftry>
					<cffile action="copy" source="#index_folder##get_file_count.modul_short_name#\#get_file_count.folder#\#get_file_count.file_name#" destination="#index_folder##get_file_count.modul_short_name#\#dateformat(now(),'ddmmyyyy')#_#get_file.file_name#" charset="utf-8">
					<cffile action="delete" file="#index_folder##get_file_count.modul_short_name#\#get_file_count.folder#\#get_file_count.file_name#">
				<cfcatch>
					<cfset error =1>
				</cfcatch>
				</cftry>
			</cfif>
        <!--- </cfloop> --->
	</cftransaction>
</cflock>

<cfif error eq 1>
	<script type="text/javascript">
	alert('Dosya Silme Sırasında Hata Oldu.Dosya Kullanımda yada Bulunamamış Olabilir');
		window.location='<cfoutput>#request.self#?fuseaction=dev.list_wbo</cfoutput>';
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=dev.list_wbo" addtoken="no">
</cfif>

