<cfif len(attributes.template_file)>
  <cftry>
    <cfset file_name = createUUID()>
    <cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="template_file" destination="#upload_folder#settings">
    <cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##file_name#.#cffile.serverfileext#">
    <cfif FileExists("#upload_folder#settings#dir_seperator##attributes.old_template_file#")>
	<cf_del_server_file output_file="settings/#attributes.old_template_file#" output_server="#attributes.old_template_file_server_id#">
    </cfif>
    <cfcatch>
 	  <script type="text/javascript">
		alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
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
		<cfquery name="upd_print_files" datasource="#dsn3#">
			UPDATE
				SETUP_PRINT_FILES
			SET 
				ACTIVE = <cfif isdefined("attributes.active")>1,<cfelse>0,</cfif>
				NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.template_head#">,
				<cfif len(attributes.template_file)>
					TEMPLATE_FILE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
				<cfelseif len(attributes.file_name)>		
					TEMPLATE_FILE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#">,
				</cfif>
				TEMPLATE_FILE_SERVER_ID =#fusebox.server_machine#,
				DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
				IS_DEFAULT = <cfif isdefined("attributes.is_default")>1<cfelse>0</cfif>,
				IS_PARTNER= <cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
				IS_STANDART = <cfif isdefined("attributes.is_standart") and attributes.is_standart eq 1>1<cfelse>0</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				PROCESS_TYPE = #listfirst(attributes.process_type,'-')#, 
				MODULE_ID = #listlast(attributes.process_type,'-')#
			WHERE
				FORM_ID = #attributes.form_id#
		</cfquery>
		<cfif fusebox.use_period>
			<cfquery name="DEL_TEAM" datasource="#dsn3#">
				DELETE FROM SETUP_PRINT_FILES_QUALITY WHERE FORM_ID = #attributes.form_id#
			</cfquery>
			<cfif len(attributes.record_num) and attributes.record_num neq "">
				<cfloop from="1" to="#attributes.record_num#" index="i">
					<cfif evaluate("attributes.row_kontrol#i#")>
						<cfscript>
							form_quality_no = evaluate("attributes.quality_no#i#");
							form_startdate = evaluate("attributes.startdate#i#");
						</cfscript>
						<cf_date tarih="form_startdate">
						<cfif len(form_quality_no) and len(form_startdate)>
							<cfquery name="ADD_PRINT_FILES_QUALITY" datasource="#dsn3#">
								INSERT INTO
									SETUP_PRINT_FILES_QUALITY
									 (
										FORM_ID,
										QUALITY_NO,
										START_DATE
									 )
									 VALUES
									 (
										#attributes.form_id#,
										'#form_quality_no#',
										#form_startdate#
									 )
							</cfquery>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>  
		</cfif> 
        <cfquery name="DEL_PRINT_FILES_CONTROL" datasource="#dsn3#">
            DELETE FROM
                #dsn_alias#.SETUP_PRINT_FILES_POSITION 
            WHERE
                FORM_ID = #attributes.form_id# AND
                POS_CAT_ID IS NULL AND
                OUR_COMPANY_ID = #session.ep.company_id#                
        </cfquery>	            
		<cfif isdefined("attributes.to_pos_codes") and len(attributes.to_pos_codes) gt 0>
            <cfloop list="#attributes.to_pos_codes#" index="a">
                <cfquery name="ADD_PRINT_FILES_CONTROL" datasource="#dsn3#">
                    SELECT
                        COUNT(*) AS PRINT_FILES_CONTROL 
                    FROM 
                        #dsn_alias#.SETUP_PRINT_FILES_POSITION 
                    WHERE 
                        FORM_ID = #attributes.form_id# AND
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
                           #attributes.form_id#,
                           NULL,
                           #a#,
                           #session.ep.company_id#
                        )
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>
        <cfif isdefined("attributes.position_cats") and len(attributes.position_cats) gt 0>
            <cfquery name="DEL_PRINT_FILES_CONTROL" datasource="#dsn3#">
                DELETE FROM 
                    #dsn_alias#.SETUP_PRINT_FILES_POSITION 
                WHERE 
                    FORM_ID = #attributes.form_id# AND
                    POS_CODE IS NULL AND
                    OUR_COMPANY_ID = #session.ep.company_id#                    
            </cfquery>
            <cfloop list="#attributes.position_cats#" index="a">
                <cfquery name="ADD_PRINT_FILES_CONTROL" datasource="#dsn3#">
                    SELECT
                        COUNT(*) AS PRINT_FILES_CONTROL 
                    FROM 
                        #dsn_alias#.SETUP_PRINT_FILES_POSITION 
                    WHERE 
                        FORM_ID = #attributes.form_id# AND
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
                           #attributes.form_id#,
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
