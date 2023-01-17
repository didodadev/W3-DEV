<!--- 
    Author : Uğur Hamurpet
    Create Date : 13/04/2020
    Desc :  This component name is WOC.
            WOC manage WOC processes 
            WOC extends WMO.functions because some print templates needs to functions in WMO.functions. 
            WOC adds a new output job, create a new document in pdf, xls and doc formats.
            WOC has 9 methods.
    methods : {
        select : 'Select Woc',
        counter : 'Counter Woc',
        getMail : 'Get mail address by wo and action id',
        insert : 'Insert Woc',
        complete : 'Complete Woc',
        preview : 'Preview woc template',
        create : 'Create woc document',
        download : 'Download woc document',
        print_counter : 'Print Counter',
        run : 'Run Woc',
        returnResult : 'Return all response ( Success, Error )'
    }
--->
<cfcomponent extends = "WMO.functions">

    <cf_get_lang_set_main>

    <!--- print template içerisinde ve cfc içerisinde kullanılan global değişkenler dahil edilir --->
    <cfset dsn = dsn_alias = application.systemParam.systemParam().dsn />
    <cfset dsn1 = dsn_product = dsn1_alias = '#dsn#_product' />
	<cfif application.systemParam.systemParam().fusebox.use_period eq false>
        <cfset dsn2 = dsn>
		<cfset dsn3 = dsn />
    <cfelse>
        <cfset dsn2 = dsn2_alias = '#dsn#_#session.ep.period_year#_#session.ep.company_id#' />
		<cfset dsn3 = dsn3_alias = '#dsn#_#session.ep.company_id#' />
    </cfif>   
    <cfset database_type = 'MSSQL' />
    <cfset upload_folder = application.systemParam.systemParam().upload_folder />
    <cfset file_web_path = application.systemParam.systemParam().file_web_path />
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator />
    <cfset user_domain = (( cgi.server_port eq 443 ) ? 'https://' : 'http://') & cgi.server_name >
    <cfset fusebox = application.systemParam.systemParam().fusebox />
    <cfset request.self = application.systemParam.systemParam().request.self />
    <cfset dateformat_style = ( isdefined("session.ep.dateformat_style") and len(session.ep.dateformat_style) ) ? session.ep.dateformat_style : 'dd/mm/yyyy' />
    <cfset validate_style = ( dateformat_style eq 'dd/mm/yyyy' ) ? 'eurodate' : 'date' />
    <cfset timeformat_style = ( isdefined("session.ep.timeformat_style") and len(session.ep.timeformat_style) ) ? session.ep.timeformat_style : 'HH:MM' />
    <cfset outputTypes = {1 : { val : 'PDF', ext : 'pdf' }, 2 : { val : 'EXCEL', ext : 'xls' }, 3 : { val : 'DOC', ext : 'doc' }} />
    <cfset queryJsonConverter = createObject("component","cfc.queryJSONConverter") />
    <cfset fileSystem = createObject("component","V16/asset/cfc/file_system") />
    <cfset structAppend(variables,application.hrFunctions)/>
    <cfset SCHEMA_ORG.SCHEMA_TYPE = 'no'>

    <cffunction name = "select" access = "public" hint = "Select Woc">
        <cfargument name="woj_id" type="numeric" default="0" required="false">
        <cfargument name="is_completed" type="boolean" default="0" required="false">
        <cfargument name="is_new_template" default="0" required="false">

        <cfquery name = "select_woc" datasource="#dsn#">

            SELECT 
                WOJ.WOJ_ID
                ,WOJ.TEMPLATE_ID
                ,WOJ.WOJ_PARAMETERS
                ,WOJ.WOJ_OUTPUT_TYPE
                ,WOJ.WOJ_DELIVERY_TYPE
                ,WOJ.WOJ_FUSEACTION
                ,WOJ.WOJ_ACTION_ID
                ,WOJ.WOJ_FILE_NAME
                ,WOJ.WOJ_FILE_ENCRYPTED_NAME
                ,WOJ.WOJ_IS_GROUP
                ,WOJ.WOJ_GROUP_KEY
                ,WOJ.COMPANY_ID
                ,WOJ.PERIOD_ID
                ,ISNULL(WOJ.MAIL_TRAIL,0) AS MAIL_TRAIL
                ,WOJ.MAIL_SEND_TYPE
                ,WOJ.MAIL_TO
                ,WOJ.MAIL_CC
                ,WOJ.MAIL_BCC
                ,WOJ.MAIL_SUBJECT
                ,WOJ.MAIL_CONTENT
                ,ASSET_AUTO_DOWNLOAD
                ,WOJ.ASSET_NO
                ,WOJ.ASSET_STAGE_ID
                ,WOJ.ASSET_CAT_ID
                ,WOJ.ASSET_PROPERTY_ID
                ,WOJ.ASSET_GROUP
                ,WOJ.IS_COMPLETE
                ,WOJ.RUN_DATE
                ,WOJ.RUN_EMP
                ,WOJ.RUN_IP
                ,WOJ.RECORD_DATE
                ,WOJ.RECORD_EMP
                ,WOJ.RECORD_IP
                ,WOJ.UPDATE_DATE
                ,WOJ.UPDATE_EMP
                ,WOJ.UPDATE_IP
                ,WOJ.IS_NEW_TEMPLATE
                ,EMP.EMPLOYEE_NAME
                ,EMP.EMPLOYEE_SURNAME
                <cfif arguments.is_new_template eq 0>
                    ,SPF.IS_STANDART
                    ,SPF.TEMPLATE_FILE
                    ,SPF.NAME
                <cfelseif arguments.is_new_template eq 1>
                    ,WOT.OUTPUT_TEMPLATE_PATH TEMPLATE_FILE
                    ,WOT.WRK_OUTPUT_TEMPLATE_NAME AS NAME
                    ,1 IS_STANDART
                </cfif>

            FROM WRK_OUTPUT_JOB AS WOJ
            JOIN EMPLOYEES AS EMP ON WOJ.RECORD_EMP = EMP.EMPLOYEE_ID
            <cfif arguments.is_new_template eq 0>
                LEFT JOIN #dsn3#.SETUP_PRINT_FILES SPF ON WOJ.TEMPLATE_ID = SPF.FORM_ID
            <cfelseif arguments.is_new_template eq 1>
                LEFT JOIN WRK_OUTPUT_TEMPLATES WOT ON WOJ.TEMPLATE_ID = WOT.WRK_OUTPUT_TEMPLATE_ID AND WOJ.IS_NEW_TEMPLATE = 1
            </cfif>
            WHERE 
                WOJ.IS_COMPLETE = <cfqueryparam value = "#arguments.is_completed#" CFSQLType = "cf_sql_integer">
                <cfif arguments.woj_id neq 0>
                AND WOJ.WOJ_ID = <cfqueryparam value = "#arguments.woj_id#" CFSQLType = "cf_sql_integer">
                </cfif>

        </cfquery>

        <cfreturn select_woc />

    </cffunction>
    
    <cffunction name = "counter" access = "public" hint = "Counter Woc">

        <cfquery name = "counter_woc" datasource="#dsn#">
            SELECT TOP 1
                ( SELECT COUNT(WOJ_ID) AS COMPLETED_COUNT FROM WRK_OUTPUT_JOB WHERE IS_COMPLETE = 1 ) AS COMPLETED_COUNT,
                ( SELECT COUNT(WOJ_ID) AS WAITING_COUNT FROM WRK_OUTPUT_JOB WHERE IS_COMPLETE = 0 ) AS WAITING_COUNT
            FROM WRK_OUTPUT_JOB
        </cfquery>

        <cfreturn counter_woc />

    </cffunction>

    <cffunction name = "getMail" access = "remote" hint = "Get mail address by wo and action id" returnFormat = "JSON">
        <cfargument name="wo" type="string" required="true">
        <cfargument name="action_id" type="numeric" required="true">

        <cfset mailManager = createObject("component","cfc.mail_manager").init( wo : arguments.wo, action_id : arguments.action_id ) />
        <cfset getMail = mailManager.get_mail_info() />

        <cfset response = structNew() />

        <cfif getMail.recordcount>
            <cfset response.status = true>
            <cfset response.data = queryJsonConverter.returnData( Replace( SerializeJson( getMail ), "//", "" ) ) >
        <cfelse>
            <cfset response.status = false>
        </cfif>

        <cfreturn LCase(Replace(SerializeJson(response),"//","")) />

    </cffunction>

    <cffunction name = "insert" access = "remote" hint = "Insert Woc" returnFormat="JSON">
        <cfargument name="is_new_template" default="0" required="false">
        <cfset response = structNew()>
        <cfset response.status = true>
        <cftry>
            <cfset file_name = encrypted_file_name = "" />
            <cfif ( arguments.delivery_type eq 1 or arguments.delivery_type eq 3 or arguments.delivery_type eq 4 ) and isdefined("arguments.output_file_name") and len( arguments.output_file_name )>
                <cfset file_name = arguments.output_file_name />
                <cfset encrypted_file_name = createUUID() />
            </cfif>

            <cftransaction>

                <cfquery name = "insert_woc" datasource = "#dsn#" result="result">
                    INSERT INTO WRK_OUTPUT_JOB
                    (
                        TEMPLATE_ID
                        ,WOJ_PARAMETERS
                        ,WOJ_OUTPUT_TYPE
                        ,WOJ_DELIVERY_TYPE
                        ,WOJ_FUSEACTION
                        ,WOJ_ACTION_ID
                        ,WOJ_FILE_NAME
                        ,WOJ_FILE_ENCRYPTED_NAME
                        ,WOJ_IS_GROUP
                        ,WOJ_GROUP_KEY
                        ,COMPANY_ID
                        ,PERIOD_ID
                        ,IS_COMPLETE
                        <cfif arguments.delivery_type eq 1>
                        ,MAIL_TRAIL
                        ,MAIL_SEND_TYPE
                        ,MAIL_TO
                        ,MAIL_CC
                        ,MAIL_BCC
                        ,MAIL_SUBJECT
                        ,MAIL_CONTENT
                        <cfelseif arguments.delivery_type eq 3>
                        ,ASSET_AUTO_DOWNLOAD
                        ,ASSET_NO
                        ,ASSET_STAGE_ID
                        ,ASSET_CAT_ID
                        ,ASSET_PROPERTY_ID
                        ,ASSET_GROUP
                        </cfif>
                        ,RECORD_DATE
                        ,RECORD_EMP
                        ,RECORD_IP
                        ,IS_NEW_TEMPLATE
                    )
                    VALUES
                    (
                        <cfqueryparam value = "#listLast(arguments.form_type)#" CFSQLType = "cf_sql_integer">
                        ,<cfqueryparam value = "#arguments.parameters#" CFSQLType = "cf_sql_nvarchar">
                        ,<cfif arguments.delivery_type eq 1 or arguments.delivery_type eq 3 or arguments.delivery_type eq 4><cfqueryparam value = "#arguments.output_type#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                        ,<cfqueryparam value = "#arguments.delivery_type#" CFSQLType = "cf_sql_integer">
                        ,<cfif isdefined("arguments.output_fuseaction") and len( arguments.output_fuseaction )><cfqueryparam value = "#arguments.output_fuseaction#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>
                        ,<cfqueryparam value = "#arguments.action_id#" CFSQLType = "cf_sql_integer">
                        ,<cfif len(file_name)><cfqueryparam value = "#file_name#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>
                        ,<cfif len(encrypted_file_name)><cfqueryparam value = "#encrypted_file_name#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>
                        ,<cfif isdefined("arguments.group_key") and len( arguments.group_key )>1<cfelse>0</cfif>
                        ,<cfif isdefined("arguments.group_key") and len( arguments.group_key )><cfqueryparam value = "#arguments.group_key#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>
                        ,<cfqueryparam value = "#session.ep.company_id#" CFSQLType = "cf_sql_integer">
                        ,<cfqueryparam value = "#session.ep.period_id#" CFSQLType = "cf_sql_integer">
                        ,<cfif arguments.delivery_type eq 2 || arguments.delivery_type eq 4>1<cfelse>0</cfif>
                        <cfif arguments.delivery_type eq 1>
                        ,<cfif isdefined("arguments.trail")><cfqueryparam value = "#arguments.trail#" CFSQLType = "cf_sql_bit"><cfelse>0</cfif>
                        ,<cfif isdefined("arguments.mail_send_type")><cfqueryparam value = "#arguments.mail_send_type#" CFSQLType = "cf_sql_bit"><cfelse>0</cfif>
                        ,<cfif isdefined("arguments.emp_name") and len( arguments.emp_name )><cfqueryparam value = "#arguments.emp_name#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>
                        ,<cfif isdefined("arguments.emp_name_cc") and len( arguments.emp_name_cc )><cfqueryparam value = "#arguments.emp_name_cc#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>
                        ,<cfif isdefined("arguments.emp_name_bcc") and len( arguments.emp_name_bcc )><cfqueryparam value = "#arguments.emp_name_bcc#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>
                        ,<cfif isdefined("arguments.subject") and len( arguments.subject )><cfqueryparam value = "#arguments.subject#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>
                        ,<cfif isdefined("arguments.mail_detail") and len( arguments.mail_detail )><cfqueryparam value = "#arguments.mail_detail#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>
                        <cfelseif arguments.delivery_type eq 3>
                        ,<cfif isdefined("arguments.asset_auto_download")><cfqueryparam value = "#arguments.asset_auto_download#" CFSQLType = "cf_sql_bit"><cfelse>0</cfif>
                        ,<cfif isdefined("arguments.asset_no") and len( arguments.asset_no )><cfqueryparam value = "#arguments.asset_no#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>
                        ,<cfif isdefined("arguments.process_stage") and len( arguments.process_stage )><cfqueryparam value = "#arguments.process_stage#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                        ,<cfif isdefined("arguments.assetcat_id") and len( arguments.assetcat_id ) and isdefined("arguments.assetcat_name") and len( arguments.assetcat_name )><cfqueryparam value = "#arguments.assetcat_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                        ,<cfif isdefined("arguments.property_id") and len( arguments.property_id )><cfqueryparam value = "#arguments.property_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                        ,<cfif isdefined("arguments.digital_assets") and len( arguments.digital_assets )><cfqueryparam value = "#arguments.digital_assets#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>
                        </cfif>
                        ,#now()#
                        ,#session.ep.userid#
                        ,'#cgi.REMOTE_ADDR#'
                        ,<cfif len(arguments.is_new_template)><cfqueryparam value = "#arguments.is_new_template#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                    )
                </cfquery>

                <cfif arguments.delivery_type eq 3>
                    <cf_papers paper_type="ASSET">
                    <cfset system_paper_no_add = paper_number>
                    <cfif len(system_paper_no_add)>
                        <cfquery name="UPD_GEN_PAPER" datasource="#DSN#">
                            UPDATE GENERAL_PAPERS_MAIN SET ASSET_NUMBER = #system_paper_no_add# WHERE ASSET_NUMBER IS NOT NULL
                        </cfquery>
                    </cfif>
                </cfif>
                
            </cftransaction>

            <cfset response.status = true>
            <cfset response.data = queryJsonConverter.returnData( Replace( SerializeJson( this.select( woj_id : result.identitycol, is_completed : (arguments.delivery_type eq 2 || arguments.delivery_type eq 4) ? 1 : 0 , is_new_template: arguments.is_new_template) ), "//", "" ) ) >
            <cfcatch type = "any">
                <cfset response.status = false>
            </cfcatch>
        </cftry>
        <cfreturn LCase( Replace( SerializeJson( response ), "//", "" ) )>
    </cffunction>

    <cffunction name = "delete" access = "remote" hint = "Delete Woc" returnFormat="JSON">
        <cfargument name="woj_id" type="numeric" required="true">

        <cfset response = structNew()>
        <cfset response.status = true>

        <cftry>
            <cfquery name = "delete_woc" datasource = "#dsn#">
                DELETE FROM WRK_OUTPUT_JOB WHERE WOJ_ID = <cfqueryparam cfsqltype = "cf_Sql_integer" value = "#arguments.woj_id#">
            </cfquery>
            <cfcatch>
                <cfset response.status = true>
            </cfcatch>
        </cftry>

        <cfreturn LCase(Replace(SerializeJson(response),"//","")) />

    </cffunction>

    <cffunction name = "insert_asset" access = "remote" hint = "Insert Asset">
        <cfargument name="asset_cat_id" type="numeric" required="true">
        <cfargument name="property_id" type="numeric" required="true">
        <cfargument name="filePath" type="string" required="true">
        <cfargument name="asset_name" type="string" required="true">
        <cfargument name="asset_file_name" type="string" required="true">
        <cfargument name="asset_file_real_name" type="string" required="true">
        <cfargument name="process_stage" type="numeric" required="true">
        <cfargument name="asset_no" type="string" required="true">
        <cfargument name="asset_group" type="string" default="" required="false">

        <cfset response = structNew()>
        
        <cftry>

            <cfset fileSystem.newFolder( upload_folder, "reserve_files" ) />
            <cfset newFolderName = "#Year(Now())##Month(Now())##Day(Now())#" />
            <cfset fileSystem.newFolder( "#upload_folder#reserve_files", newFolderName ) />
            <cfset fileSystem.copy( filePath, "#upload_folder#reserve_files/#newFolderName#" ) />

            <cfquery name = "get_asset_cat" datasource="#dsn#">
                SELECT ASSETCAT, ASSETCAT_PATH FROM ASSET_CAT WHERE ASSETCAT_ID = <cfqueryparam value = "#arguments.asset_cat_id#" CFSQLType = "cf_sql_integer">
            </cfquery>

            <cfif get_asset_cat.recordcount>

                <cfset newfilepath = upload_folder & (( arguments.asset_cat_id gt 0 ) ? "asset/" : "") & get_asset_cat.ASSETCAT_PATH />
                <cfset fileSystem.copy( filePath, newfilepath ) />

                <cftransaction>

                    <cfquery name = "insert_asset" datasource = "#dsn#" result="result">
                        INSERT INTO 
                        ASSET
                        (
                            MODULE_NAME,
                            MODULE_ID,
                            ACTION_SECTION,
                            ASSETCAT_ID,
                            PROPERTY_ID,
                            ASSET_NAME,
                            ASSET_FILE_NAME,
                            ASSET_FILE_REAL_NAME,
                            ASSET_FILE_SIZE,
                            ASSET_FILE_SERVER_ID,
                            ASSET_STAGE,
                            COMPANY_ID,
                            PERIOD_ID,
                            ASSET_NO,
                            IS_ACTIVE,
                            RECORD_DATE,
                            RECORD_EMP,                
                            RECORD_IP
                        )VALUES(
                            'Asset'
                            ,8
                            ,'Asset'
                            ,<cfqueryparam value = "#arguments.asset_cat_id#" CFSQLType = "cf_sql_integer">
                            ,<cfqueryparam value = "#arguments.property_id#" CFSQLType = "cf_sql_integer">
                            ,<cfqueryparam value = "#arguments.asset_name#" CFSQLType = "cf_sql_nvarchar">
                            ,<cfqueryparam value = "#arguments.asset_file_name#" CFSQLType = "cf_sql_nvarchar">
                            ,<cfqueryparam value = "#arguments.asset_file_real_name#" CFSQLType = "cf_sql_nvarchar">
                            ,0
                            ,#fusebox.server_machine#
                            ,<cfqueryparam value = "#arguments.process_stage#" CFSQLType = "cf_sql_integer">
                            ,#session.ep.company_id#
                            ,#session.ep.period_id#
                            ,<cfqueryparam value = "#arguments.asset_no#" CFSQLType = "cf_sql_nvarchar">
                            ,1
                            ,#now()#
                            ,#session.ep.userid#
                            ,'#cgi.REMOTE_ADDR#'
                        )
                    </cfquery>
    
                    <cfif len(arguments.asset_group)>
                        <cfloop list="#arguments.asset_group#" index="digital_asset_group">
                            <cfquery name="ADD_DIGITAL_ASSET_GROUP_IDS" datasource="#DSN#">
                                INSERT INTO ASSET_RELATED( ASSET_ID, DIGITAL_ASSET_GROUP_ID ) VALUES( #result.identitycol#, #digital_asset_group# )
                            </cfquery>
                        </cfloop>
                    </cfif>
                    
                </cftransaction>

                <cfset response.status = true>
                <cfset response.result = result>

            <cfelse>
                <cfsavecontent variable = "message"><cf_get_lang dictionary_id='60848.Kategori mevcut değil'>!</cfsavecontent>
                <cfset response.status = false>
                <cfset response.message = message>
                <cfset response.error = {}>
            </cfif>

        <cfcatch type = "any">
            <cfset response.status = false>
            <cfset response.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn response />

    </cffunction>

    <cffunction name = "complete" access = "public" hint = "Complete Woc">
        <cfargument name="woj_id" type="numeric" default="0" required="false">

        <cftry>

            <cfquery name = "complete_woc" datasource = "#dsn#">
                UPDATE 
                    WRK_OUTPUT_JOB 
                SET 
                    IS_COMPLETE = 1,
                    RUN_DATE = #now()#,
                    RUN_EMP = #session.ep.userid#,
                    RUN_IP = '#cgi.REMOTE_ADDR#'
                WHERE WOJ_ID = #arguments.woj_id#
            </cfquery>
            
            <cfreturn true />

            <cfcatch type = "any">
                <cfreturn false />
            </cfcatch>

        </cftry>

    </cffunction>

    <cffunction name = "preview" access = "remote" hint = "Preview woc template">
        <cfargument name="form_type" required="false">
        <cfargument name="action" type="string" default="">
        <cfargument name="template_id" type="numeric" required="false">
        <cfargument name="is_new_template" default="0" required="false">

        <cfset getPrintTemplate = createObject("component","cfc.get_print_template")>
        <cfif isdefined("arguments.form_type") and len(arguments.form_type)>
            <cfset get_det_form = getPrintTemplate.GET( form_type : arguments.form_type ) />
            <cfset get_print_positions = getPrintTemplate.get_print_positions(form_type : arguments.form_type )>
            <cfif get_print_positions.recordcount>
                <cfset get_pos = getPrintTemplate.get_pos()>
                <cfset print_position_control = getPrintTemplate.print_position_control(form_type : arguments.form_type, position_code : get_pos.position_code, position_cat_id : get_pos.position_cat_id)>	
                <cfif print_position_control.recordcount eq 0>
                    <div style="text-align:center;padding:70px 0;"><h4><cf_get_lang dictionary_id='60110.Önizleme Yapılamıyor'>!</h4><h5><cf_get_lang dictionary_id='61174.'>!</h5></div>
                    <cfabort>
                </cfif>
            </cfif>
        </cfif>
        <cfif isdefined('arguments.template_id') and len(arguments.template_id)>
            <cfset get_templates_css = getPrintTemplate.get_template( template_id : arguments.template_id )>
        <cfelse>
            <cfset get_templates_css.recordcount = 0>
        </cfif>
       
        <!--- Şablonun ihtiyaç duyduğu parametreleri attributes'e doldurur --->
        <cfif listLen( cgi.QUERY_STRING, "&" )>
            <cfloop list="#cgi.QUERY_STRING#" index="value" delimiters="&">
				<cfif listlen(value,"=") eq 2 and listFirst(value,"=") neq listLast(value,"=")>
					<cfset "attributes.#listFirst( value, "=" )#" = listLast( value, "=" ) />
					<cfset "url.#listFirst( value, "=" )#" = listLast( value, "=" ) />
					<cfset "#listFirst( value, "=" )#" = listLast( value, "=" ) />
				<cfelse>
					<cfset "attributes.#listFirst( value, "=" )#" = ""/>
					<cfset "url.#listFirst( value, "=" )#" = ""/>
					<cfset "#listFirst( value, "=" )#" = ""/>
				</cfif>
            </cfloop>
        </cfif>

        <cfif isdefined('get_det_form') and get_det_form.recordcount>
            <cfset fileDir =  get_det_form.is_standart ? "/#get_det_form.template_file#" : "#file_web_path#settings/#get_det_form.template_file#" /> 
        <cfelseif get_templates_css.recordcount neq 0>
                <!--- Görüntülenecek şablonun dosya yolunu alır --->
                <cfset fileDir =  "/#get_templates_css.OUTPUT_TEMPLATE_PATH#" />           
        </cfif>
        <!--- include edilen şablonların içerisinde kullanılan <cf_get_lang> ihtiyaç duyuyor  --->
        <cfset attributes.fuseaction = 'objects.popup_print_files' />
        <cfif get_templates_css.recordcount or (isDefined('get_det_form') and get_det_form.recordcount)>
            <cftry>
                <cfscript>
                    use_logo = 1;
                    use_adress = 1;
                    rule_unit = "mm";
                    page_width = 210;
                    page_height  = "";
                    page_header_height = "";
                    page_footer_height = "";
                    page_margin_left = "";
                    page_margin_right = "";
                    page_margin_top = "";
                    page_margin_bottom = "";  
                    if (get_templates_css.recordcount neq 0){
                        colNames = listToArray(get_templates_css.columnList);
                        for(i in colNames){
                            if(len(evaluate("get_templates_css.#i#"))) "#i#" = evaluate("get_templates_css.#i#");
                        }
                        if(rule_unit eq 2) rule_unit = 'in';
                        else rule_unit = 'mm';
                    }                        
                </cfscript>         
                <div id="woc_preview">
                    <cfinclude template="../display/woc_asset.cfm">
                    <cfif isdefined('arguments.template_id') and len(arguments.template_id)>
                        <script type="text/javascript" src="/JS/assets/lib/jquery/jquery-min.js"></script>
                        <table class="print_page">
                            <tr>
                                <td>
                                    <cfinclude template="#fileDir#">
                                </td>
                            </tr>
                        </table>
                        <script>
                            $(function() {
                                <cfif len(get_templates_css.data_design)>   
                                    var design = JSON.parse(<cfoutput>#get_templates_css.data_design#</cfoutput>);
                                    for(var i = 0; i < design.length; i++) {
                                        $('#' + design[i].key).attr('style',design[i].value);
                                    }
                                </cfif>
                            })
                        </script>
                        <cfloop array="#structKeyArray(SCHEMA_ORG)#" item="item">
                            <cfset schema = evaluate("SCHEMA_ORG.#item#")>
                            <script type="application/ld+json"><cfoutput>#replace(serializeJSON(schema), "//", "")#</cfoutput></script>
                        </cfloop>
                    <cfelse>
                        <cfinclude template="#fileDir#">
                    </cfif>
                </div>
            <cfcatch>
                <div style="text-align:center;padding:70px 0;"><h4><cf_get_lang dictionary_id='60110.Önizleme Yapılamıyor'>!</h4><h5><cf_get_lang dictionary_id='54834.Şablon Bulunamadı'>!</h5></div>
            </cfcatch>
            </cftry>
        <cfelse>
            <div style="text-align:center;padding:70px 0;"><h4><cf_get_lang dictionary_id='60110.Önizleme Yapılamıyor'>!</h4><h5><cf_get_lang dictionary_id='54834.Şablon Bulunamadı'>!</h5></div>
        </cfif>

    </cffunction>

    <cffunction name = "create" access = "public" hint = "Create woc document">
        <cfargument name="outputType" type="numeric" required="true">
        <cfargument name="filename" type="string" required="true">
        <cfargument name="parameters" type="string" required="true">
        <cfargument name="template" type="struct" required="true">

        <cfset response = structNew() />
        <cfset response.status = true />

        <cftry>

            <!--- documents altında gerekli klasörler yoksa açar --->
            <cfset fileSystem.newFolder( upload_folder, "woc" ) />
            <cfset fileSystem.newFolder( "#upload_folder#woc", "pdf" ) />
            <cfset fileSystem.newFolder( "#upload_folder#woc", "excel" ) />
            <cfset fileSystem.newFolder( "#upload_folder#woc", "doc" ) />

            <!--- Doküman ayarları yapılır --->
            <cfset documentSettings = structNew() />
            <cfset documentSettings = { 
                filename : "#upload_folder#woc/#LCase(outputTypes[outputType].val)#/#arguments.filename#.#LCase(outputTypes[outputType].ext)#",
                format : outputTypes[outputType].val, 
                pagetype : "A4", 
                orientation : "portrait", 
                marginTop : 0,
                marginRight : 0,
                marginBottom : 0,
                marginLeft : 0
            } />

            <!--- Şablonun ihtiyaç duyduğu parametreleri attributes'e doldurur --->
            <cfif listLen( arguments.parameters, "&" )>
                <cfloop list="#arguments.parameters#" index="value" delimiters="&">
                    <cfset "attributes.#listFirst( value, "=" )#" = listLast( value, "=" ) />
                    <cfset "url.#listFirst( value, "=" )#" = listLast( value, "=" ) />
                    <cfset "#listFirst( value, "=" )#" = listLast( value, "=" ) />
                </cfloop>
            </cfif>

            <!--- Kaydedilecek içeriğin dosya yolunu alır --->
            <cfset fileDir =  arguments.template.is_standart eq 1 ? "/#arguments.template.template_file#" : "#file_web_path#settings/#arguments.template.template_file#" />

            <!--- include edilen şablonların içerisinde kullanılan <cf_get_lang> ihtiyaç duyuyor  --->
            <cfset attributes.fuseaction = 'objects.popup_print_files' />

            <cfsavecontent variable = "templateContent">
                <cfif isdefined('arguments.action') and len(arguments.action)>
                    <cfset getPrintTemplate = createObject("component","cfc.get_print_template")>
                    <cfset get_templates_css = getPrintTemplate.get_templates_css( action : arguments.action )>
                    <cfscript>
                        use_logo = 1;
                        use_adress = 1;
                        rule_unit = "mm";
                        page_width = 210;
                        page_height  = "";
                        page_header_height = "";
                        page_footer_height = "";
                        page_margin_left = "";
                        page_margin_right = "";
                        page_margin_top = "";
                        page_margin_bottom = "";  
                        if (get_templates_css.recordcount neq 0){
                            colNames = listToArray(get_templates_css.columnList);
                            for(i in colNames){
                                if(len(evaluate("get_templates_css.#i#"))) "#i#" = evaluate("get_templates_css.#i#");
                            }
                            if(rule_unit eq 2) rule_unit = 'in';
                            else rule_unit = 'mm';
                        }                        
                    </cfscript>       
                    <div id="woc_preview">
                        <cfset SCHEMA_TYPE = '#get_templates_css.SCHEMA_MARKUP#'>
                        <cfinclude template="../display/woc_asset.cfm">
                        <table class="print_page">
                            <tr>
                                <td>
                                    <cfinclude template="#fileDir#">
                                </td>
                            </tr>
                        </table>
                        <cfloop array="#structKeyArray(SCHEMA_ORG)#" item="item">
                            <cfset schema = evaluate("SCHEMA_ORG.#item#")>
                            <script type="application/ld+json"><cfoutput>#replace(serializeJSON(schema), "//", "")#</cfoutput></script>
                        </cfloop>
                    </div>
                <cfelse>
                    <!--- !!pdf üretiminde sorun yaratıyor!! --->
                    <!--- <cfinclude template="../display/woc_asset.cfm"> --->

                     <!--- Wuxi tagleri hataya düştüğü için eklendi --->
                    <cfset attributes.template_id = template.template_id>
                    <cfinclude template="#fileDir#">
                </cfif>
            </cfsavecontent>

            <!--- Dosya formatına göre üretim işlemleri yapılır --->
            <cfif outputTypes[outputType].val eq 'PDF' >

                <cfdocument 
                    filename="#documentSettings.filename#" 
                    format = "#documentSettings.format#" 
                    pagetype="#documentSettings.pagetype#" 
                    orientation="#documentSettings.orientation#" 
                    marginBottom = "#documentSettings.marginBottom#" 
                    marginLeft = "#documentSettings.marginLeft#" 
                    marginRight = "#documentSettings.marginRight#" 
                    marginTop = "#documentSettings.marginTop#"
                    overwrite = "yes">

                    <cfoutput>#templateContent#</cfoutput>
                    
                </cfdocument>

            <cfelseif outputTypes[outputType].val eq 'EXCEL'>
                <cfset fileSystem.write( documentSettings.filename, templateContent, "utf-16" ) />
            <cfelseif outputTypes[outputType].val eq 'DOC'>
                <cfset fileSystem.write( documentSettings.filename, templateContent, "utf-16" ) />
            </cfif>

            <cfcatch type = "any">
                <cfset response.status = false />
                <cfset response.error = cfcatch />
            </cfcatch>
    
        </cftry>
        
        <cfreturn response />

    </cffunction>

    <cffunction name = "download" access = "remote" hint = "Download woc document">
        <cfargument name="woj_id" type="numeric" required="true">
        <cfset woc = this.select( woj_id : arguments.woj_id, is_completed : 1 ,is_new_template: arguments.is_new_template) />
        <cfset fileUrl = "#user_domain#/documents/woc/#LCase(outputTypes[woc.WOJ_OUTPUT_TYPE].val)#/#woc.WOJ_FILE_ENCRYPTED_NAME#.#LCase(outputTypes[woc.WOJ_OUTPUT_TYPE].ext)#" />
        
        <cfheader name="Content-Disposition" value="attachment; filename=#woc.WOJ_FILE_NAME#.#outputTypes[woc.WOJ_OUTPUT_TYPE].ext#" charset="utf-8">

        <cfif outputTypes[woc.WOJ_OUTPUT_TYPE].ext eq 'pdf'><cfcontent type = "application/pdf;charset=utf-16" file = "#fileUrl#">
        <cfelseif outputTypes[woc.WOJ_OUTPUT_TYPE].ext eq "xls"><cfcontent type = "application/vnd.ms-excel; charset=utf-16" file = "#fileUrl#">
        <cfelseif outputTypes[woc.WOJ_OUTPUT_TYPE].ext eq "doc"><cfcontent type = "application/vnd.ms-word;charset=utf-16" file = "#fileUrl#">
        </cfif>

    </cffunction>  

    <cffunction name = "print_counter" access = "remote" hint = "Print counter">
        <cfargument name="woj_id" type="numeric" default="0" required="false">
        <cfargument name="wo" type="string" default="" required="false">
        <cfargument name="action_id" type="numeric" default="0" required="false">
        <cfargument name="is_new_template" default="0" required="false">
        
        <cfif arguments.woj_id neq 0>
            <cfset woc = this.select( woj_id : arguments.woj_id, is_completed : 1, is_new_template: arguments.is_new_template) />
            <cfset arguments.wo = woc.WOJ_FUSEACTION />
            <cfset arguments.action_id = woc.WOJ_ACTION_ID />
        </cfif>
        
        <cfset response = true />

        <cfswitch expression="#arguments.wo#">
            <!--- Fatura --->
            <cfcase value="invoice.list_bill,invoice.form_add_bill,invoice.detail_invoice_purchase,invoice.form_add_bill_purchase,invoice.detail_invoice_sale">
                <cfquery name="UPD_PRINT_COUNT" datasource="#dsn2#">
                    UPDATE INVOICE SET PRINT_COUNT = ISNULL(PRINT_COUNT,0) + 1 WHERE INVOICE_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.action_id#">
                </cfquery>
            </cfcase>
            <!--- İrsaliye --->
            <cfcase value="stock.list_purchase,stock.form_add_sale,stock.form_upd_sale,stock.form_add_purchase,stock.form_upd_purchase,stock.form_add_fis,stock.form_upd_fis,stock.form_add_ship_open_fis,stock.form_upd_open_fis,stock.form_add_order_sale,stock.detail_order,stock.form_add_order_purchase,stock.detail_orderp">
                <cfquery name="UPD_PRINT_COUNT" datasource="#dsn2#">
                    UPDATE SHIP SET PRINT_COUNT = ISNULL(PRINT_COUNT,0) + 1 WHERE SHIP_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.action_id#">
                </cfquery>
            </cfcase>
            <!--- Sevk Emri - Sipariş --->
            <cfcase value="stock.list_command,purchase.list_order">
                <cfquery name="UPD_PRINT_COUNT" datasource="#dsn3#">
                    UPDATE ORDERS SET PRINT_COUNT = ISNULL(PRINT_COUNT,0) + 1 WHERE ORDER_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.action_id#">
                </cfquery>
            </cfcase>
            <cfdefaultcase><cfset response = false /></cfdefaultcase>
        </cfswitch>
        <cfreturn response>
    </cffunction>

    <cffunction name = "run" access = "remote" hint = "Run Woc" returnFormat="JSON">
        <cfargument name="woj_id" type="numeric" required="true">
        <cfargument name="is_completed" type="boolean" default="0" required="false">
        <cfargument name="is_new_template" default="0" required="false">
        
        <cfset response = structNew()>
        <cfset response.status = true>

        <cfset deliveryTypes = {1 : { val : 'Mail' }, 2 : { val : 'Print' }, 3 : { val : 'Archive' }} />
        <cfset getWoc = this.select( woj_id : arguments.woj_id, is_completed : arguments.is_completed ,is_new_template: arguments.is_new_template) />
        <cfif getWoc.recordcount>

            <!--- Gönderi Tipi olarak Mail ya da arşiv seçilmişse dosya üretilir --->
            <cfif getWoc.WOJ_DELIVERY_TYPE eq 1 or getWoc.WOJ_DELIVERY_TYPE eq 3 or getWoc.WOJ_DELIVERY_TYPE eq 4>

                <cfset response = this.create( 
                    outputType : getWoc.WOJ_OUTPUT_TYPE,
                    filename : getWoc.WOJ_FILE_ENCRYPTED_NAME,
                    parameters : getWoc.WOJ_PARAMETERS,
                    template : { 
                        is_standart :  getWoc.IS_STANDART,
                        template_file :  getWoc.TEMPLATE_FILE,
                        name :  getWoc.NAME,
                        is_new_template : getWoc.IS_NEW_TEMPLATE,
                        template_id : getWoc.TEMPLATE_ID
                    }
                )/>

                <cfif response.status>
                    
                    <cfif getWoc.WOJ_DELIVERY_TYPE eq 1><!--- Gönderi Tipi olarak Mail seçilmişse mail gönderim işlemleri yapılır --->
                        
                        <cfset mailManager = createObject("component","cfc.mail_manager").init(
                            wo : getWoc.WOJ_FUSEACTION, 
                            action_id : getWoc.WOJ_ACTION_ID,
                            wocSettings : {
                                isGroup : getWoc.WOJ_IS_GROUP,
                                groupKey : getWoc.WOJ_GROUP_KEY
                            },
                            mailSettings : {
                                trail : getWoc.MAIL_TRAIL,
                                send_type : getWoc.MAIL_SEND_TYPE,
                                mail_to : getWoc.MAIL_TO,
                                mail_cc : getWoc.MAIL_CC,
                                mail_bcc : getWoc.MAIL_BCC
                            }
                        ) />

                        <cfset sendMail = mailManager.send_mail(
                            subject : getWoc.MAIL_SUBJECT,
                            content : getWoc.MAIL_CONTENT,
                            file : {
                                name : "#getWoc.WOJ_FILE_NAME#.#LCase(outputTypes[getWoc.WOJ_OUTPUT_TYPE].ext)#",
                                path : "#upload_folder#woc/#LCase(outputTypes[getWoc.WOJ_OUTPUT_TYPE].val)#/#getWoc.WOJ_FILE_ENCRYPTED_NAME#.#LCase(outputTypes[getWoc.WOJ_OUTPUT_TYPE].ext)#"
                            }
                        ) />
                        
                        <cfif !sendMail.status>
                            <cfreturn this.returnResult( status : false, woc: { woj_id : arguments.woj_id }, message : sendMail.message, error : sendMail.error ) />
                        </cfif>

                    <cfelseif getWoc.WOJ_DELIVERY_TYPE eq 3><!--- Gönderi Tipi olarak Archive seçilmişse doküman dijital arşive kaydedilir --->

                        <cfset insertAsset = this.insert_asset(
                            asset_cat_id : getWoc.ASSET_CAT_ID,
                            property_id : getWoc.ASSET_PROPERTY_ID,
                            filePath : "#upload_folder#woc/#LCase(outputTypes[getWoc.WOJ_OUTPUT_TYPE].val)#/#getWoc.WOJ_FILE_ENCRYPTED_NAME#.#LCase(outputTypes[getWoc.WOJ_OUTPUT_TYPE].ext)#",
                            asset_name : getWoc.WOJ_FILE_NAME,
                            asset_file_name : getWoc.WOJ_FILE_ENCRYPTED_NAME & "." & outputTypes[getWoc.WOJ_OUTPUT_TYPE].ext,
                            asset_file_real_name : getWoc.WOJ_FILE_NAME & "." & outputTypes[getWoc.WOJ_OUTPUT_TYPE].ext,
                            process_stage : getWoc.ASSET_STAGE_ID,
                            asset_no : getWoc.ASSET_NO,
                            asset_group : getWoc.ASSET_GROUP
                        ) />

                        <cfif !insertAsset.status>
                            <cfreturn this.returnResult( status : false, woc: { woj_id : arguments.woj_id }, message : ( structKeyExists( insertAsset, "message" ) ? insertAsset.message : "Dosyanız arşivlenirken bir sorun oluştu!" ), error : insertAsset.error ) />
                        </cfif>

                    </cfif>

                    <cfif this.complete( woj_id : arguments.woj_id )>
                        <cfset this.print_counter( woj_id : arguments.woj_id , is_new_template:getWoc.IS_NEW_TEMPLATE ) />
                        <cfreturn this.returnResult( status: true, woc: { woj_id : arguments.woj_id, delivery_type : getWoc.WOJ_DELIVERY_TYPE, asset_auto_download : getWoc.ASSET_AUTO_DOWNLOAD } ) />
                    <cfelse>
                        <cfsavecontent variable = "message"><cf_get_lang dictionary_id='60849.İşleminiz tamamlanamadı'>!</cfsavecontent>
                        <cfreturn this.returnResult( status: false, woc: { woj_id : arguments.woj_id }, message: message ) />
                    </cfif>

                <cfelse>

                    <cfsavecontent variable = "message"><cf_get_lang dictionary_id='60850.Dosyanız üretilirken bir sorun oluştu'>!</cfsavecontent>
                    <cfreturn this.returnResult(
                        status: false,
                        woc: { woj_id : arguments.woj_id },
                        message: message,
                        error : response.error
                    ) />

                </cfif>

            </cfif>

        <cfelse>
            <cfsavecontent variable = "message"><cf_get_lang dictionary_id='60851.Çalıştırmak istediğiniz görev mevcut değil'>!</cfsavecontent>
            <cfreturn this.returnResult(
                status: false,
                woc: { woj_id : arguments.woj_id },
                message: message
            ) />
        </cfif>

    </cffunction>
    <cffunction name = "design" access = "remote" hint = "Design woc template" returnformat="JSON">
        <cfargument name="template_id" type="numeric" required="true">
        <cfargument name="objects" type="any" required="false" default="">
        <cfquery name="design" datasource="#dsn#">
            UPDATE WRK_OUTPUT_TEMPLATES SET DATA_DESIGN = <cfif len(arguments.objects)><cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(serializeJSON(arguments.objects), "//", "")#"><cfelse>NULL</cfif> WHERE WRK_OUTPUT_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.template_id#">
        </cfquery>

        <cfreturn true />
    </cffunction>
    <cfscript>
        public any function returnResult( boolean status, struct woc, string message = "", any error = "" ) returnformat = "JSON" {
            response = structNew();
            response = {
                status: status,
                woc: woc,
                message: message,
                error: error
            };
    
            return LCase(Replace(SerializeJSON(response),"//",""));
        }
    </cfscript>

</cfcomponent>