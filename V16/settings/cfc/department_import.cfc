<!--- Departman Aktarım
settings.department_import --->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder />
    <cfset file_web_path = application.systemParam.systemParam().file_web_path />
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator />
    <cfset request.self = application.systemParam.systemParam().request.self />
	<cfset filterNum = CreateObject("component","WMO.functions").filterNum>
    <cfset wrk_round = CreateObject("component","WMO.functions").wrk_round>
    <cffunction name="add_department" access="remote">
        <cfset attributes = arguments>
        <cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
        <cftry>
            <cffile action = "upload" 
                    fileField = "uploaded_file" 
                    destination = "#upload_folder_#"
                    nameConflict = "MakeUnique"  
                    mode="777" charset="utf-8">
            <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
            <cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
            <cfset file_size = cffile.filesize>
            <cfcatch type="Any">
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>  
        </cftry>
        <cftry>
            <cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
            <cffile action="delete" file="#upload_folder_##file_name#">
            <cfcatch>
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>.");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>

        <cfscript>
            CRLF = Chr(13) & Chr(10);// satır atlama karakteri
            dosya = Replace(dosya,';;','; ;','all');
            dosya = Replace(dosya,';;','; ;','all');
            dosya = ListToArray(dosya,CRLF);
            line_count = ArrayLen(dosya);
            counter = 0;
            liste = "";
        </cfscript>

        <cfloop from="2" to="#line_count#" index="i">
            <cfset error_flag = 0>
            <cftry>
                <cfset department_name= trim(listgetat(dosya[i],1,';'))>
                <cfset branch_id = trim(listgetat(dosya[i],2,';'))>
                <cfset is_store = trim(listgetat(dosya[i],3,';'))>
                <cfset department_cat = trim(listgetat(dosya[i],4,';'))>
                <cfset department_type = trim(listgetat(dosya[i],5,';'))>
                <cfset upper_department = trim(listgetat(dosya[i],6,';'))>
                <cfset total_emp_count = trim(listgetat(dosya[i],7,';'))>
                <cfset eposta = trim(listgetat(dosya[i],8,';'))>
                <cfset detail = trim(listgetat(dosya[i],9,';'))>
                <cfset admin_1 = trim(listgetat(dosya[i],10,';'))>
                <cfset admin_2 = trim(listgetat(dosya[i],11,';'))>
                <cfset level_no = trim(listgetat(dosya[i],12,';'))> <!--- kademe numarası --->
                <cfset hierarchy = trim(listgetat(dosya[i],13,';'))>
                <cfset special_code_1 = trim(listgetat(dosya[i],14,';'))>
                <cfset special_code_2 = trim(listgetat(dosya[i],15,';'))>
                <cfset is_production = trim(listgetat(dosya[i],16,';'))>
                <cfif (listlen(dosya[i],';') gte 17)>
                    <cfset is_organization = trim(listgetat(dosya[i],17,';'))>
                <cfelse>
                    <cfset is_organization = ''>
                </cfif>
                <cfif not len(department_name)>
                    <cfoutput>#i#. <cf_get_lang dictionary_id='64638.satırda Departman alanını kontrol ediniz.'></cfoutput><br />
                    <cfset error_flag = 1>
                </cfif>
                <cfif  not len(branch_id)>
                    <cfoutput>#i#. <cf_get_lang dictionary_id='64639.satırda Şube ID alanını kontrol ediniz.'></cfoutput><br />
                    <cfset error_flag = 1>
                </cfif>
                <cfif len(upper_department) and len(level_no)>
                    <cfquery name="get_up_dep_level_no" datasource="#DSN#">
                        SELECT LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID= <cfqueryparam value="#upper_department#" cfsqltype="cf_sql_integer">
                    </cfquery>
                    <cfif get_up_dep_level_no.LEVEL_NO gte level_no>
                        <cfoutput>#i#. <cf_get_lang dictionary_id='64664.satırda Üst Departmanın Kademe Numarası daha küçük olmalıdır'>.</cfoutput><br />
                        <cfset error_flag = 1>
                    </cfif>
                </cfif>
                <cfcatch type="Any">
                    <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='63328.satır 1. adımda sorun oluştu'>.<br/>
                    <cfset error_flag = 1>
                </cfcatch>  
            </cftry>
            <cfif error_flag neq 1>
                <cflock name="#CreateUUID()#" timeout="60">
                    <cftransaction>
                        <cftry>
                            <cfquery name="ADD_DEPARTMENT" datasource="#DSN#" result="MAX_ID">
                                INSERT INTO 
                                    DEPARTMENT
                                (
                                    DEPARTMENT_STATUS,
                                    DEPARTMENT_HEAD,
                                    BRANCH_ID,
                                    IS_STORE,
                                    DEPARTMENT_CAT,
                                    DEPARTMENT_TYPE,
                                    DEPARTMENT_EMAIL,
                                    DEPARTMENT_DETAIL,
                                    ADMIN1_POSITION_CODE,
                                    ADMIN2_POSITION_CODE,	
                                    LEVEL_NO,
                                    HIERARCHY,
                                    SPECIAL_CODE,
                                    SPECIAL_CODE2,
                                    IS_PRODUCTION,
                                    IS_ORGANIZATION,
                                    RECORD_DATE,
                                    RECORD_EMP,
                                    RECORD_IP
                                )
                                VALUES
                                (
                                    1,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#department_name#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#branch_id#">,
                                    <cfif len(is_store)><cfqueryparam cfsqltype="cf_sql_integer" value="#is_store#"><cfelse>NULL</cfif>,
                                    <cfif len(department_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#department_cat#"><cfelse>NULL</cfif>,
                                    <cfif len(department_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#department_type#"><cfelse>NULL</cfif>,
                                    <cfif len(eposta)><cfqueryparam cfsqltype="cf_sql_varchar" value="#eposta#" ><cfelse>NULL</cfif>,
                                    <cfif len(detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(detail,100)#"><cfelse>NULL</cfif>,
                                    <cfif len(admin_1)><cfqueryparam cfsqltype="cf_sql_integer" value="#admin_1#"><cfelse>NULL</cfif>,
                                    <cfif len(admin_2)><cfqueryparam cfsqltype="cf_sql_integer" value="#admin_2#"><cfelse>NULL</cfif>,
                                    <cfif len(level_no)><cfqueryparam cfsqltype="cf_sql_bigint" value="#filterNum(level_no)#"><cfelse>NULL</cfif>,
                                    <cfif len(hierarchy)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hierarchy#"><cfelse>NULL</cfif>,
                                    <cfif len(special_code_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_1#"><cfelse>NULL</cfif>,
                                    <cfif len(special_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_2#"><cfelse>NULL</cfif>,
                                    <cfif len(is_production)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_production#"><cfelse>NULL</cfif>,
                                    <cfif len(is_organization)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_organization#"><cfelse>NULL</cfif>,
                                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                                )
                            </cfquery>
                            <cfif  len(upper_department)>
                                <cfquery name="get_hier" datasource="#DSN#">
                                    SELECT
                                        HIERARCHY_DEP_ID
                                    FROM
                                        DEPARTMENT
                                    WHERE
                                        DEPARTMENT_ID = <cfqueryparam value="#upper_department#" cfsqltype="cf_sql_integer">
                                </cfquery>
                                <cfif len(get_hier.HIERARCHY_DEP_ID)>
                                    <cfset hier = get_hier.HIERARCHY_DEP_ID & "." & MAX_ID.IDENTITYCOL>
                                <cfelse>
                                    <cfset hier = upper_department & "." & MAX_ID.IDENTITYCOL>	
                                </cfif>
                            <cfelse>
                                <cfset hier = MAX_ID.IDENTITYCOL>
                            </cfif>

                            <cfquery name="get_max" datasource="#DSN#">
                                UPDATE
                                    DEPARTMENT
                                SET
                                    HIERARCHY_DEP_ID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#hier#">
                                WHERE
                                    DEPARTMENT_ID=<cfqueryparam value="#MAX_ID.IDENTITYCOL#" cfsqltype="cf_sql_integer">
                            </cfquery>

                            <cfquery name="add_dept_history" datasource="#dsn#">
                                INSERT INTO DEPARTMENT_HISTORY (IS_PRODUCTION,IS_STORE,BRANCH_ID,DEPARTMENT_ID,DEPARTMENT_HEAD,DEPARTMENT_DETAIL,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,HIERARCHY_DEP_ID,HIERARCHY,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_ORGANIZATION,LEVEL_NO,EMP_COUNT) 
                                SELECT IS_PRODUCTION,IS_STORE,BRANCH_ID,DEPARTMENT_ID,DEPARTMENT_HEAD,DEPARTMENT_DETAIL,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,HIERARCHY_DEP_ID,HIERARCHY,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_ORGANIZATION,LEVEL_NO,<cfif len(total_emp_count)>#total_emp_count#<cfelse>NULL</cfif> FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam value="#MAX_ID.IDENTITYCOL#" cfsqltype="cf_sql_integer">
                            </cfquery>
                            <cfset counter++>
                            <cfcatch type="Any">
                                <cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='44948.2. adımda sorun oluştu.'><br/>
                                <cfset error_flag = 1>
                            </cfcatch>
                        </cftry>
                    </cftransaction>
                </cflock>
            </cfif>
        </cfloop>

        <cfoutput>#counter# ** <cf_get_lang dictionary_id='62781.satır import edildi'> !!!</cfoutput>
            <script>
                location.href= document.referrer;
            </script>
    </cffunction>
</cfcomponent>