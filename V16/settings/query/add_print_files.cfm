<cfif attributes.is_standart eq 0>
	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="template_file" destination="#upload_folder#settings">
		<cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##file_name#.#cffile.serverfileext#">
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<!--- Bu blok default olarak secilmisse digerlerinin IS_DEFAULT durumunu iptal eder. --->
		<cfif isdefined("attributes.is_default")>
			<cfquery name="UPD_PRINT_FILES" datasource="#dsn3#">
				UPDATE
					SETUP_PRINT_FILES
				SET
					IS_DEFAULT = 0
				WHERE
					PROCESS_TYPE = #listfirst(attributes.process_type,'-')#
			</cfquery>
		</cfif>
		<cfquery name="ADD_PRINT_FILES" datasource="#dsn3#"  result="MAX_ID">
			INSERT INTO
				SETUP_PRINT_FILES
			(
				PROCESS_TYPE,
				MODULE_ID,
				ACTIVE,	
				NAME,
				TEMPLATE_FILE,
				TEMPLATE_FILE_SERVER_ID,
				DETAIL,
				IS_DEFAULT,
				IS_PARTNER,
				IS_STANDART,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)   
			VALUES
			(
				#listfirst(attributes.process_type,'-')#,
				#listlast(attributes.process_type,'-')#,
				<cfif isdefined("attributes.active")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.template_head#">,
				<cfif isdefined("attributes.is_standart") and len(attributes.is_standart) and attributes.is_standart eq 1>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.file_name#">
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">
				</cfif>,
				#fusebox.server_machine#,
				<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_default")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_standart") and len(attributes.is_standart) and attributes.is_standart eq 1>1<cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
        
        <cfif isdefined("attributes.to_pos_codes") and len(attributes.to_pos_codes) gt 0>
            <cfloop list="#attributes.to_pos_codes#" index="a">
                <cfquery name="ADD_PRINT_FILES_CONTROL" datasource="#dsn3#">
                    SELECT
                        COUNT(*) AS PRINT_FILES_CONTROL 
                    FROM 
                        #dsn_alias#.SETUP_PRINT_FILES_POSITION 
                    WHERE 
                        FORM_ID = #MAX_ID.IDENTITYCOL# AND
                        POS_CAT_ID IS NULL AND
                        POS_CODE = #a# AND
                        OUR_COMPANY_ID = #session.ep.company_id#
                </cfquery>
                
                <cfif add_print_files_control.print_files_control neq 1>
                    <cfquery name="ADD_PRINT_FILES" datasource="#dsn3#">
                        INSERT INTO
                            #dsn_alias#.SETUP_PRINT_FILES_POSITION
                        (
                            FORM_ID,
                            POS_CAT_ID,
                            POS_CODE,
                            OUR_COMPANY_ID
                        )
                        VALUES
                        (
                           #MAX_ID.IDENTITYCOL#,
                           NULL,
                           #a#,
                           #session.ep.company_id#
                        )
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>
        <cfif isdefined("attributes.position_cats") and len(attributes.position_cats) gt 0>
            <cfloop list="#attributes.position_cats#" index="a">
                <cfquery name="ADD_PRINT_FILES_CONTROL" datasource="#dsn3#">
                    SELECT
                        COUNT(*) AS PRINT_FILES_CONTROL 
                    FROM 
                        #dsn_alias#.SETUP_PRINT_FILES_POSITION 
                    WHERE 
                        FORM_ID = #MAX_ID.IDENTITYCOL# AND
                        POS_CAT_ID = #a# AND
                        POS_CODE IS NULL AND
                        OUR_COMPANY_ID = #session.ep.company_id#
                </cfquery>
                
                <cfif add_print_files_control.print_files_control neq 1>
                    <cfquery name="ADD_PRINT_FILES" datasource="#dsn3#">
                        INSERT INTO
                            #dsn_alias#.SETUP_PRINT_FILES_POSITION
                        (
                            FORM_ID,
                            POS_CAT_ID,
                            POS_CODE,
                            OUR_COMPANY_ID
                        )
                        VALUES
                        (
                           #MAX_ID.IDENTITYCOL#,
                           #a#,
                           NULL,
                           #session.ep.company_id#
                        )
                    </cfquery>
                </cfif>
            </cfloop>	
        </cfif>
	</cftransaction>
</cflock>
<cflocation url="#cgi.http_referer#" addtoken="no">
