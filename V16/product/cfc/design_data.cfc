<!---
    File: V16\product\cfc\design_data.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2022-04-12
    Description: Design data for product

--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = "#dsn#_product">
    <cfset dsn3 = '#dsn#_#session.ep.company_id#' />

    <cffunction name="GET_DESIGN_DATA_SETTINGS" access="remote" returntype="any" returnformat="JSON">
        <cfparam name="data_type" default = "" type="string">

        <cfquery name="GET_DESIGN_DATA_SETTINGS" datasource="#dsn1#">
            SELECT PRODUCT_DESIGN_DATA_SETTINGS_ID FROM PRODUCT_DESIGN_DATA_SETTINGS WHERE APPLICATION_TYPE = <cfqueryparam value = "#arguments.data_type#" CFSQLType = "cf_sql_varchar">
        </cfquery>
       
        <cfreturn  Replace(SerializeJSON(GET_DESIGN_DATA_SETTINGS.recordcount),'//','')>
    </cffunction>

    <cffunction name="GET_DESIGN_DATA_SETTINGS_ALL" access="public" returntype="any">
        <cfparam name="data_type" default = "" type="string">

        <cfquery name="GET_DESIGN_DATA_SETTINGS_ALL" datasource="#dsn1#">
            SELECT * FROM PRODUCT_DESIGN_DATA_SETTINGS WHERE APPLICATION_TYPE = <cfqueryparam value = "#arguments.data_type#" CFSQLType = "cf_sql_varchar">
        </cfquery>
       
        <cfreturn  GET_DESIGN_DATA_SETTINGS_ALL>
    </cffunction>

    <!--- Bileşen Tipleri --->
    <cffunction name="GET_TREE_TYPES" access="public" returntype="any">

        <cfquery name="GET_TREE_TYPES" datasource="#dsn#">
            SELECT TYPE_ID,
            #dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','PRODUCT_TREE_TYPE','TYPE',NULL,NULL,TYPE) AS TYPE
              FROM PRODUCT_TREE_TYPE
        </cfquery>

        <cfreturn GET_TREE_TYPES>
    </cffunction>

    <cffunction name="ADD_DESIGN_DATA_SETTINGS" access="remote" returntype="any">
        <cfargument name="data_type" type="string">
        <cfset responseStruct = structNew()>
        <cftry>
            <cfset application_type = arguments.data_type>

            <cfset arguments_ = Replace(SerializeJSON(arguments),'//','')>

            <cfquery name="ADD_DESIGN_DATA_SETTINGS" datasource="#dsn1#" result="MAX_ID">
                INSERT INTO 
                    PRODUCT_DESIGN_DATA_SETTINGS
                    (
                        APPLICATION_TYPE
                        ,DESIGN_DATA_JSON
                        ,RECORD_EMP
                        ,RECORD_DATE
                        ,RECORD_IP
                    )
                VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value='#application_type#'>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value='#arguments_#'>,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>
                    )
            </cfquery>

            <cfset responseStruct.identity = MAX_ID.IDENTITYCOL>
            <cfset responseStruct.message = 'İşlem başarılı'>
            <cfset responseStruct.status = true>
            <cfset responseStruct.draggable = true>          

        <cfcatch>
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
            <cfset responseStruct.modal_id = arguments.modal_id>
            <cfset responseStruct.draggable = true>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="UPD_DESIGN_DATA_SETTINGS" access="remote" returntype="any">
        <cfargument name="data_type" type="string">
        <cfargument name="product_design_data_settings_id" type="integer">
        <cfset responseStruct = structNew()>
        <cftry>
            <cfset application_type = arguments.data_type>

            <cfset arguments_ = Replace(SerializeJSON(arguments),'//','')>

            <cfquery name="upd_emp_daily_in_out" datasource="#dsn1#">
                UPDATE 
                    PRODUCT_DESIGN_DATA_SETTINGS
                SET
                    DESIGN_DATA_JSON = <cfqueryparam cfsqltype="cf_sql_varchar" value='#arguments_#'>,
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    UPDATE_DATE =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>
                WHERE
                    APPLICATION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value='#application_type#'>
            </cfquery>

            <cfset responseStruct.identity = arguments.product_design_data_settings_id>
            <cfset responseStruct.message = 'İşlem başarılı'>
            <cfset responseStruct.status = true>
            <cfset responseStruct.draggable = true>          

        <cfcatch>
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
            <cfset responseStruct.modal_id = arguments.modal_id>
            <cfset responseStruct.draggable = true>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="DEL_DESIGN_DATA_SETTINGS" access="remote" returntype="any">
        <cfargument name="product_design_data_settings_id" type="integer">
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="DEL_DESIGN_DATA_SETTINGS" datasource="#dsn1#">
              DELETE FROM 
                PRODUCT_DESIGN_DATA_SETTINGS
              WHERE
                PRODUCT_DESIGN_DATA_SETTINGS_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value='#arguments.product_design_data_settings_id#'>
            </cfquery>

            <cfset responseStruct.identity = arguments.product_design_data_settings_id>
            <cfset responseStruct.message = 'İşlem başarılı'>
            <cfset responseStruct.status = true>        

        <cfcatch>
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>


    <cffunction name="GET_PRODUCT_SAMPLE"  access="remote" returntype="any">
        <cfargument  name="product_sample_id" default="">
        <cfargument  name="opp_id" default="">
        <cfquery name="GET_PRODUCT_SAMPLE" datasource="#dsn3#">
            SELECT 
                PRODUCT_SAMPLE_NAME,
                REFERENCE_PRODUCT_ID
            FROM 
                PRODUCT_SAMPLE 
            WHERE
                PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_sample_id#"> 
        </cfquery>
        <cfreturn GET_PRODUCT_SAMPLE>
    </cffunction> 

    <cffunction name="GET_ALTERNATIVE_QUESTION"  access="public" returntype="any">
        <cfquery name="GET_ALTERNATIVE_QUESTION" datasource="#dsn#">
            SELECT QUESTION_ID,QUESTION_NAME FROM SETUP_ALTERNATIVE_QUESTIONS
        </cfquery>
        <cfreturn GET_ALTERNATIVE_QUESTION>
    </cffunction> 

    <cffunction name="ADD_DESIGN_DATA_IMPORT" access="remote" returntype="any">
        <cfargument name="design_data_file_path" type="string" default="">
        <cfargument name="product_id" default="">
        <cfargument name="product_desing_data_settings_id" type="integer" default="">
        <cfset responseStruct = structNew()>
        <cftry>
            
            <cfquery name="ADD_DESIGN_DATA_IMPORT" datasource="#dsn1#" result="MAX_ID">
                INSERT INTO 
                PRODUCT_DESIGN_DATA
                (
                    PRODUCT_ID
                    ,PRODUCT_DESIGN_DATA_SETTINGS_ID
                    ,DESIGN_DATA_FILE_PATH
                    ,RECORD_DATE
                    ,RECORD_EMP
                    ,RECORD_IP
                )
                VALUES
                (

                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"  null="#len(arguments.product_id)?'false':'true'#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_desing_data_settings_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.design_data_file_path#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>
                )
            </cfquery>

            <cfset responseStruct.identity = MAX_ID.IDENTITYCOL>
            <cfset responseStruct.message = 'İşlem başarılı'>
            <cfset responseStruct.status = true>     

        <cfcatch>
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="ADD_SUB_PRODUCT" access="remote" returntype="any">
        <cfset responseStruct = structNew()>
        <cftry>
            <cfset count = 1>
            <cfloop from = "1" to = "#arguments.row_count#" index = "i">
                <cfif isdefined("arguments.row_#i#")>
                    
                    <cfif len(evaluate('arguments.stock_id_#i#')) and len(evaluate('arguments.product_name_#i#'))>
                        <cfquery name="check_sub" datasource="#dsn3#">
                            SELECT
                                PRODUCT_ID
                            FROM
                                PRODUCT_TREE
                            WHERE
                                RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MAIN_STOCK_ID#">
                            AND
                                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.stock_id_#i#')#">
                        </cfquery>
                        <cfif check_sub.recordcount or (arguments.PRODUCT_ID eq arguments.MAIN_PRODUCT_ID)>
                            <script type="text/javascript">
                               <cfset responseStruct.message = "<cf_get_lang no ='627.Bu ürünü eklerseniz Ürün Ağacınızda Hirerarşi sorunu oluşur'>!">
                                <cfset responseStruct.status = false>
                                <cfset responseStruct.error = cfcatch>
                            </script>
                             <cfreturn responseStruct>
                        </cfif>
                    </cfif>
                    <cfif arguments.MAIN_STOCK_ID neq evaluate('arguments.stock_id_#i#')>
                        <cfset stock_id_ary=''>
                        <cfset dtime=now()>
                        <cfif isdefined("arguments.stock_id_#i#") and len(evaluate('arguments.stock_id_#i#'))>
                            <cfset MAIN_STOCK_ID_ = evaluate('arguments.stock_id_#i#')>
                        <cfelseif arguments.MAIN_STOCK_ID eq 0 and isdefined('arguments.HISTORY_STOCK')>
                            <cfset MAIN_STOCK_ID_ = arguments.history_stock>
                        <cfelse>
                            <cfset MAIN_STOCK_ID_ = arguments.main_stock_id>
                        </cfif>
                        <cfquery name="stock_control" datasource="#dsn3#">
                            SELECT PRODUCT_TREE_ID FROM PRODUCT_TREE WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAIN_STOCK_ID_#">
                        </cfquery>
                        <cfif stock_control.recordcount>
                            <cfquery name="stock_control_history" datasource="#dsn3#">
                                UPDATE 
                                    PRODUCT_TREE 
                                SET 
                                    HISTORY_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dtime#">,
                                    HISTORY_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                WHERE
                                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAIN_STOCK_ID_#">
                            </cfquery>
                            <cf_wrk_get_history datasource="#dsn3#" source_table="PRODUCT_TREE" target_table="PRODUCT_TREE_HISTORY" record_id="#MAIN_STOCK_ID_#" record_name="STOCK_ID">
                        </cfif>
                        <cfif len(stock_id_ary)>
                            <cfquery name="stock_relation_history" datasource="#dsn3#">
                                UPDATE 
                                    PRODUCT_TREE 
                                SET 
                                    HISTORY_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dtime#">,
                                    HISTORY_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                WHERE
                                    PRODUCT_TREE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id_ary#" list="yes">) 
                            </cfquery>
                            <cf_wrk_get_history datasource="#dsn3#" source_table="PRODUCT_TREE" target_table="PRODUCT_TREE_HISTORY" record_id=#stock_id_ary#  record_name="PRODUCT_TREE_ID">
                        </cfif>
                        <cfquery name="add_sub" datasource="#dsn3#" result="MAX_ID">
                            INSERT INTO
                                PRODUCT_TREE
                                (
                                    STOCK_ID,
                                    PRODUCT_ID,
                                    RELATED_ID,
                                    AMOUNT,
                                    UNIT_ID,
                                    SPECT_MAIN_ID,
                                    IS_CONFIGURE,
                                    IS_SEVK,
                                    LINE_NUMBER,
                                    OPERATION_TYPE_ID,
                                    IS_PHANTOM,
                                    RELATED_PRODUCT_TREE_ID,
                                    QUESTION_ID,
                                    PROCESS_STAGE,
                                    MAIN_STOCK_ID,
                                    IS_FREE_AMOUNT,
                                    FIRE_AMOUNT,
                                    FIRE_RATE,
                                    DETAIL,
                                    RECORD_EMP,
                                    RECORD_DATE,
                                    TREE_TYPE
                                )
                            VALUES
                                (
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_stock_id#">,
                                    <cfif  isdefined('arguments.product_id_#i#') and len(evaluate('arguments.product_id_#i#')) and len(evaluate('arguments.product_name_#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.product_id_#i#')#"><cfelse>NULL</cfif>,
                                    <cfif len(evaluate('arguments.stock_id_#i#')) and len(evaluate('arguments.product_name_#i#'))>#evaluate('arguments.stock_id_#i#')#<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('arguments.quantity_wrk_#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.quantity_wrk_#i#')#"><cfelse>1</cfif>,
                                    <cfif len(evaluate('arguments.unit_id_#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.unit_id_#i#')#"><cfelse>NULL</cfif>,
                                    <cfif len(evaluate('arguments.spect_main_id_#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.spect_main_id_#i#')#"><cfelse>NULL</cfif>,
                                    1,
                                    0,
                                    #count#,
                                    <cfif isdefined('arguments.operation_type_id_#i#') and len(evaluate('arguments.operation_type_id_#i#')) and not len(evaluate('arguments.product_name_#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.operation_type_id_#i#')#"><cfelse>NULL</cfif>,
                                    0,
                                    NULL,
                                    <cfif isdefined('arguments.alternative_questions_#i#') and len(evaluate('arguments.alternative_questions_#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.alternative_questions_#i#')#"><cfelse>NULL</cfif>,
                                    <cfif len(MAIN_STOCK_ID_)><cfqueryparam cfsqltype="cf_sql_integer" value="#MAIN_STOCK_ID_#"><cfelse>NULL</cfif>,
                                    NULL,
                                    0,
                                    NULL,
                                    NULL,
                                    <cfif isdefined('arguments.detail_#i#') and len(evaluate('arguments.detail_#i#'))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('arguments.detail_#i#')#"><cfelse>NULL</cfif>,
                                    #session.ep.userid#,
                                    #now()#,
                                    <cfif isdefined('arguments.tree_types_#i#') and len(evaluate('arguments.tree_types_#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.tree_types_#i#')#"><cfelse>NULL</cfif>   
                                )
                        </cfquery>
                        <cfset count++>
                    <cfelse>
                        <cfset responseStruct.message = "<cf_get_lang no ='628.Ürüne Kendisini Ekleyemezsiniz'>">
                        <cfset responseStruct.status = false>
                        <cfset responseStruct.error = cfcatch>
                        <cfreturn responseStruct>
                    </cfif>
                </cfif>
            </cfloop>

            <cfset responseStruct.identity = ''>
            <cfset responseStruct.message = 'İşlem başarılı'>
            <cfset responseStruct.status = true>

        <cfcatch>
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

</cfcomponent>