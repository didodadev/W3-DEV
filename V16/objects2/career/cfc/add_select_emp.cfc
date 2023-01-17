<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>

    <cfsavecontent variable="warning">
        <cf_get_lang dictionary_id='62565.Kayıt İşlemi Gerçekleşti, Yönlendiriliyorsunuz'>
    </cfsavecontent>

    <cffunction name="GET_SETUP_WARNING" access="remote" returntype="query" output="no">
        <cfquery name="GET_SETUP_WARNING" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                SETUP_WARNINGS 
            ORDER BY 
                SETUP_WARNING
        </cfquery>
        <cfreturn GET_SETUP_WARNING>
    </cffunction>

    <cffunction name="add_emp_app_select_list" access="public" returntype="string" returnformat="json">
        <cftry>  
            <cfif (isdefined("arguments.exp_year_s1") and len(arguments.exp_year_s1)) or (isdefined("arguments.exp_year_s2") and len(arguments.exp_year_s2))>
                <cfquery name="get_work_info" datasource="#dsn#">
                    SELECT 
                        EMPAPP_ID,
                        SUM(EXP_FARK)/365 
                    FROM 
                        EMPLOYEES_APP_WORK_INFO 
                    GROUP BY 
                        EMPAPP_ID 
                    HAVING 
                        <cfif isdefined("arguments.exp_year_s1") and len(arguments.exp_year_s1)>Sum(EXP_FARK)/365 >= #exp_year_s1#<cfif  isdefined("arguments.exp_year_s2") and len(arguments.exp_year_s2)>AND</cfif></cfif>
                        <cfif isdefined("arguments.exp_year_s2") and len(arguments.exp_year_s2)>Sum(EXP_FARK)/365 <= #exp_year_s2#</cfif>
                </cfquery>
                <cfif get_work_info.recordcount>
                    <cfset exp_app_list = valuelist(get_work_info.empapp_id,',')>
                <cfelse>
                    <cfset exp_app_list = 0>
                </cfif>
            </cfif>
            <cfif ((isdefined("arguments.edu3") and len(arguments.edu3)) or (isdefined("arguments.edu3_part") and len(arguments.edu3_part))) or ((isdefined("arguments.edu4") and len(arguments.edu4)) or (isdefined("arguments.edu4_id") and len(arguments.edu4_id))) or ((isdefined("arguments.edu4_part") and len(arguments.edu4_part)) or (isdefined("arguments.edu4_part_id") and len(arguments.edu4_part_id))) or (isdefined("arguments.edu_finish") and len(arguments.edu_finish))>
                <cfquery name="get_edu_info" datasource="#dsn#">
                    SELECT
                        EMPAPP_ID
                    FROM
                        EMPLOYEES_APP_EDU_INFO
                    WHERE
                        EMPAPP_ID IS NOT NULL
                        AND(
                    <cfif (isdefined("arguments.edu3") and len(arguments.edu3)) or (isdefined("arguments.edu3_part") and len(arguments.edu3_part))>	
                        (EDU_TYPE = 3
                        <cfif isdefined("arguments.edu3") and len(arguments.edu3)>
                            AND EDU_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.edu3#%"> 
                        </cfif>
                        <cfif isdefined("arguments.edu3_part") and len(arguments.edu3_part)>
                            AND EDU_PART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.edu3_part#"> 
                        </cfif>
                        )
                    </cfif>
                    <cfif ((isdefined("arguments.edu3") and len(arguments.edu3)) or (isdefined("arguments.edu3_part") and len(arguments.edu3_part))) and (((isdefined("arguments.edu4") and len(arguments.edu4)) or (isdefined("arguments.edu4_id") and len(arguments.edu4_id))) or ((isdefined("arguments.edu4_part") and len(arguments.edu4_part)) or (isdefined("arguments.edu4_part_id") and len(arguments.edu4_part_id))))>
                        OR
                    </cfif>
                    <cfif ((isdefined("arguments.edu4") and len(arguments.edu4)) or (isdefined("arguments.edu4_id") and len(arguments.edu4_id))) or ((isdefined("arguments.edu4_part") and len(arguments.edu4_part)) or (isdefined("arguments.edu4_part_id") and len(arguments.edu4_part_id)))>
                        (EDU_TYPE = 4
                        <cfif (isdefined("arguments.edu4") and len(arguments.edu4)) or (isdefined("arguments.edu4_id") and len(arguments.edu4_id))>
                            AND
                            (	
                                <cfif isdefined("arguments.edu4") and len(arguments.edu4)>
                                    <cfset count=0>
                                    <cfloop list="#arguments.edu4#" delimiters="," index="i">
                                    <cfset count=count+1>
                                    <cfif count gt 1> OR </cfif>
                                     EDU_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%"> 
                                    </cfloop>
                                </cfif>
                                <cfif isdefined("arguments.edu4_id") and len(arguments.edu4_id)>
                                    <cfif isdefined('count')>OR</cfif> 
                                    EDU_ID IN (#arguments.edu4_id#)
                                </cfif>
                            )
                        </cfif>
                        <cfif (isdefined("arguments.edu4_part") and len(arguments.edu4_part)) or (isdefined("arguments.edu4_part_id") and len(arguments.edu4_part_id))>
                            AND
                            (	
                            <cfif isdefined("arguments.edu4_part") and len(arguments.edu4_part)>
                                <cfset count2=0>
                                <cfloop list="#arguments.edu4_part#" delimiters="," index="i">
                                <cfset count2=count2+1>
                                <cfif count2 gt 1> OR </cfif>
                                   EDU_PART_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%">
                                </cfloop>
                            </cfif>
                            <cfif isdefined("arguments.edu4_part_id") and len(arguments.edu4_part_id)>
                                <cfif isdefined('count2')>OR</cfif> 
                                EDU_PART_ID IN (#arguments.edu4_part_id#)
                            </cfif>
                            )
                        </cfif>
                        )
                    </cfif>
                    )
                    <cfif isdefined("arguments.edu_finish") and len(arguments.edu_finish)>
                        AND	EDU_FINISH =#arguments.edu_finish#
                    </cfif>
                </cfquery>
                <cfif get_edu_info.recordcount>
                    <cfset  edu_app_list = listsort(valuelist(get_edu_info.empapp_id,','),"Numeric","ASC",',')>
                <cfelse>
                    <cfset  edu_app_list = 0>
                </cfif>
            </cfif>
            <cflock name="#CreateUUID()#" timeout="20">
                <cftransaction>
            <cfif not isdefined('arguments.old')>
                <cfquery name="add_list" datasource="#dsn#">
                    INSERT INTO
                        EMPLOYEES_APP_SEL_LIST
                        (
                            LIST_NAME,
                            LIST_DETAIL,
                            LIST_STATUS,
                            <cfif len(arguments.notice_id_list)>NOTICE_ID,</cfif>
                            <!--- <cfif len(arguments.position_id_list)>POSITION_ID,</cfif>
                            <cfif len(arguments.position_cat_id_list)>POSITION_CAT_ID,</cfif>
                            <cfif len(arguments.company_list) and len(arguments.company_id_list)>COMPANY_ID,</cfif> --->
                            <cfif isdefined("arguments.our_company_id_list") and len(arguments.our_company_id_list)>OUR_COMPANY_ID,</cfif>
                            SEL_LIST_STAGE,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        )
                    VALUES
                        (
                            '#arguments.list_name#',
                            '#arguments.list_detail#',
                            <cfif isdefined('arguments.list_status')>1<cfelse>0</cfif>,
                            <cfif len(arguments.notice_id_list)>#arguments.notice_id_list#,</cfif>
                            <!--- <cfif len(arguments.position_id_list)>#arguments.position_id_list#,</cfif>
                            <cfif len(arguments.position_cat_id_list)>#arguments.position_cat_id_list#,</cfif> 
                            <cfif len(arguments.company_list) and len(arguments.company_id_list)>#arguments.company_id_list#,</cfif> --->
                            <cfif isdefined("arguments.our_company_id_list") and len(arguments.our_company_id_list)>#arguments.our_company_id_list#,</cfif>
                            <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>#arguments.process_stage#<cfelse>NULL</cfif>,
                            #now()#,
                            #session.pp.userid#,
                            '#cgi.REMOTE_ADDR#'
                        )
                </cfquery>
                <cfquery name="get_list" datasource="#dsn#">
                    SELECT
                        MAX(LIST_ID) AS MAX_LIST_ID
                    FROM
                        EMPLOYEES_APP_SEL_LIST
                    WHERE 
                        LIST_NAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.list_name#">
                </cfquery>
            <!--- sürecin yetki sorunu nedeni ile action page değeri myhomedan yollanıyor--->	
               <!---  <cf_workcube_process 
                    is_upd='1' 
                    old_process_line='0'
                    process_stage='#arguments.process_stage#' 
                    record_member='#session.pp.userid#' 
                    record_date='#now()#' 
                    action_table='EMPLOYEES_APP_SEL_LIST'
                    action_column='LIST_ID'
                    action_id='#get_list.MAX_LIST_ID#'
                    action_page='#request.self#?fuseaction=myhome.upd_emp_app_select_list&list_id=#get_list.MAX_LIST_ID#'
                    warning_description = 'Şeçim Listesi Kayıt : #arguments.list_name#'> --->
                
            <cfelseif isdefined('arguments.old') and arguments.old eq 1>
                <cfset get_list.MAX_LIST_ID=arguments.list_id>
            </cfif>
            <cfif isdefined("arguments.salary_wanted_money") and len(arguments.salary_wanted_money)>
             <cfquery name="GET_RATE" datasource="#dsn#">
                SELECT
                    RATE1,
                    RATE2,
                    MONEY
                FROM
                    SETUP_MONEY
                WHERE
                    MONEY = '#Trim(arguments.salary_wanted_money)#' AND 
                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.PP.PERIOD_ID#">
             </cfquery>
                <cfset RATE_MAIN =GET_RATE.RATE2/GET_RATE.RATE1>
            </cfif>
            
            <cfif isdefined("arguments.salary_wanted1") and len(arguments.salary_wanted1) and isdefined("RATE_MAIN")>
                <cfset money_min =arguments.salary_wanted1*RATE_MAIN>
            </cfif>
            <cfif isdefined("arguments.salary_wanted2") and len(arguments.salary_wanted2) and isdefined("RATE_MAIN")>
                <cfset money_max =arguments.salary_wanted2*RATE_MAIN>
            </cfif>	
            
            <cfif isdefined("arguments.birth_date2") and len(arguments.birth_date2)>
                <cfset arguments.date_dogum="01/01/#evaluate(session.pp.period_year-arguments.birth_date2)#">
                <cf_date tarih='arguments.date_dogum'>
            </cfif>
            <cfif isdefined("arguments.birth_date1") and len(arguments.birth_date1)>
                <cfset arguments.date_dogum_1="01/01/#evaluate(session.pp.period_year-arguments.birth_date1)#">
                <cf_date tarih='arguments.date_dogum_1'>
            </cfif>
            
            <cfif isdefined('arguments.search_app_pos') and arguments.search_app_pos eq 1>
            <cfquery name="add_list_row_pos" datasource="#dsn#"><!---başvuruları ekliyor--->
                INSERT INTO
                    EMPLOYEES_APP_SEL_LIST_ROWS
                    (
                        EMPAPP_ID,
                        APP_POS_ID,
                        STAGE,
                        ROW_STATUS,
                        LIST_ID,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )	
                    SELECT
                        EMPLOYEES_APP.EMPAPP_ID,
                        EMPLOYEES_APP_POS.APP_POS_ID,
                        NULL,
                        1,
                        #GET_LIST.MAX_LIST_ID#,
                        #now()#,
                        #session.pp.userid#,
                        '#cgi.REMOTE_ADDR#'
                    FROM
                        EMPLOYEES_APP,	
                        EMPLOYEES_APP_POS,
                        EMPLOYEES_IDENTY
                    WHERE	
                    EMPLOYEES_APP.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
                    AND EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP.EMPAPP_ID
                    AND EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
                    <cfif (isdefined("arguments.salary_wanted1") and len(arguments.salary_wanted1)) or (isdefined("arguments.salary_wanted2") and len(arguments.salary_wanted2))>
                        AND (EMPLOYEES_APP_POS.SALARY_WANTED*#RATE_MAIN#) BETWEEN #money_min# AND #money_max#
                    <cfelseif (isdefined("arguments.salary_wanted1") and len(arguments.salary_wanted1)) and not (isdefined("arguments.salary_wanted2")and len(arguments.salary_wanted2)) >
                        AND (EMPLOYEES_APP_POS.SALARY_WANTED*#RATE_MAIN#) >= #money_min# 
                    <cfelseif (isdefined("arguments.salary_wanted2") and len(arguments.salary_wanted2)) and not (isDefined("arguments.salary_wanted1") and len(arguments.salary_wanted1))>
                        AND (EMPLOYEES_APP_POS.SALARY_WANTED*#RATE_MAIN#) <= #money_max#
                    </cfif>		
                    <cfif isdefined("arguments.app_date1") and len(arguments.app_date1) and not (isdefined("arguments.app_date2") and len(arguments.app_date2))>
                       AND EMPLOYEES_APP_POS.APP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.app_date1#">
                    </cfif>
                    <cfif isdefined("arguments.app_date2") and len(arguments.app_date2) and not (isdefined("arguments.app_date1") and len(arguments.app_date1))>
                       AND EMPLOYEES_APP_POS.APP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.app_date2#">
                    </cfif>
                    <cfif (isdefined("arguments.app_date1") and len(arguments.app_date1)) and (isdefined("arguments.app_date2") and len(arguments.app_date2))>
                       AND (EMPLOYEES_APP_POS.APP_DATE  BETWEEN #arguments.app_date1#  AND #arguments.app_date2#)
                    </cfif>	
                    <cfset city_count=0>	
                    <cfif isdefined("arguments.prefered_city") and len(arguments.prefered_city)>
                        AND (
                        <cfloop list="#arguments.prefered_city#" index="i" delimiters=",">
                              PREFERED_CITY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#i#,%"> 
                            <cfset city_count=city_count+1>
                            <cfif listlen(arguments.prefered_city) neq city_count>
                                OR
                            </cfif>
                        </cfloop>
                        )
                    </cfif>
                    <cfif isdefined("arguments.notice_id") and len(arguments.notice_id)>
                      AND EMPLOYEES_APP_POS.NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notice_id#">
                    </cfif>
                    <cfif (isdefined("arguments.position_id") and len(arguments.position_id)) and (isdefined("arguments.app_position") and len(arguments.app_position))>
                        AND EMPLOYEES_APP_POS.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
                    </cfif>
                    <cfif (isdefined("arguments.POSITION_CAT_ID") and len(arguments.POSITION_CAT_ID)) and (isdefined("arguments.POSITION_CAT") and len(arguments.POSITION_CAT))>
                        AND EMPLOYEES_APP_POS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.POSITION_CAT_ID#">
                    </cfif>
                    <cfif isdefined('arguments.status') and len(arguments.status)>
                        AND EMPLOYEES_APP.APP_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
                    <cfelseif isdefined('arguments.status_app_pos') and len(arguments.status_app_pos)>
                        AND EMPLOYEES_APP_POS.APP_POS_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status_app_pos#">
                    </cfif>	
                    <cfif isdefined("arguments.company_id") and len(arguments.company_id) and len(arguments.company)>
                        AND EMPLOYEES_APP_POS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                    </cfif>
                    <cfif isdefined("arguments.department") and len(arguments.department) and isdefined('arguments.department_id') and len(arguments.department_id)>
                        AND EMPLOYEES_APP_POS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                    </cfif>
                    <cfif isdefined("arguments.branch") and len(arguments.branch) and isdefined('arguments.branch_id') and len(arguments.branch_id)>
                        AND EMPLOYEES_APP_POS.BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
                        <cfif isdefined('arguments.our_company_id') and len(arguments.our_company_id)>
                            AND EMPLOYEES_APP_POS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
                        </cfif>	
                    </cfif>
                <cfif (isdefined("arguments.sex") and listlen(arguments.sex))>
                    AND EMPLOYEES_APP.SEX IN (#listsort(arguments.sex,"NUMERIC")#) 
                </cfif>
                <cfif (isdefined("arguments.MARRIED") and listlen(arguments.MARRIED))>
                    AND EMPLOYEES_IDENTY.MARRIED IN (#listsort(arguments.married,"NUMERIC")#)  
                </cfif>
                <cfif (isdefined("arguments.military_status") and listlen(arguments.military_status))>
                    AND EMPLOYEES_APP.MILITARY_STATUS IN (#LISTSORT(arguments.military_status,"NUMERIC")#) 
                </cfif>
                <cfif isdefined("arguments.birth_place") and len(arguments.birth_place)>
                    AND EMPLOYEES_IDENTY.BIRTH_PLACE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.birth_place#%">
                </cfif>
                <cfif isdefined("arguments.city") and len(arguments.city)>
                    AND EMPLOYEES_IDENTY.CITY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.city#%">
                </cfif>
                <cfif ((isdefined("arguments.edu3") and len(arguments.edu3)) or (isdefined("arguments.edu3_part") and len(arguments.edu3_part))) or ((isdefined("arguments.edu4") and len(arguments.edu4)) or (isdefined("arguments.edu4_id") and len(arguments.edu4_id))) or ((isdefined("arguments.edu4_part") and len(arguments.edu4_part)) or (isdefined("arguments.edu4_part_id") and len(arguments.edu4_part_id))) or (isdefined("arguments.edu_finish") and len(arguments.edu_finish))>
                    AND EMPLOYEES_APP.EMPAPP_ID IN (#edu_app_list#)
                </cfif>
                <!--- <cfif isdefined("arguments.edu3") and len(arguments.edu3)>
                    AND EMPLOYEES_APP.EDU3 LIKE '%#arguments.edu3#%'
                </cfif>
                <cfif isdefined("arguments.edu3_part") and len(arguments.edu3_part)>
                    AND EMPLOYEES_APP.EDU3_PART IN (#arguments.edu3_part#)
                </cfif>
                <cfif (isdefined("arguments.edu4") and len(arguments.edu4)) or (isdefined("arguments.edu4_id") and len(arguments.edu4_id))>
                    AND (	
                        <cfif isdefined("arguments.edu4") and len(arguments.edu4)>
                            <cfset count=0>
                            <cfloop list="#arguments.edu4#" delimiters="," index="i">
                            <cfset count=count+1>
                            <cfif count gt 1> OR </cfif>
                             EDU4 LIKE '%#i#%' 
                            </cfloop>
                        </cfif>
                        <cfif isdefined("arguments.edu4_id") and len(arguments.edu4_id)>
                            <cfif isdefined('count')>OR</cfif> 
                            (EDU4_ID IN (#arguments.edu4_id#) OR EDU4_ID_2 IN (#arguments.edu4_id#))
                        </cfif>
                    )
                </cfif>
                
                <cfif (isdefined("arguments.edu4_part") and len(arguments.edu4_part)) or (isdefined("arguments.edu4_part_id") and len(arguments.edu4_part_id))>
                    AND
                    (	
                    <cfif isdefined("arguments.edu4_part") and len(arguments.edu4_part)>
                        <cfset count2=0>
                        <cfloop list="#arguments.edu4_part#" delimiters="," index="i">
                        <cfset count2=count2+1>
                        <cfif count2 gt 1> OR </cfif>
                           EDU4_PART LIKE '%#i#%'
                        </cfloop>
                    </cfif>
                    <cfif isdefined("arguments.edu4_part_id") and len(arguments.edu4_part_id)>
                        <cfif isdefined('count2')>OR</cfif> 
                        (EDU4_PART_ID IN (#arguments.edu4_part_id#) OR EDU4_PART_ID_2 IN (#arguments.edu4_part_id#))
                    </cfif>
                    )
                </cfif> --->
                <cfif isdefined("arguments.lang") and len(arguments.lang)>
                    AND
                    (  
                    <cfset lang_count=0>
                    <cfloop list="#arguments.lang#" delimiters="," index="i">
                        (
                            (
                                LANG1=#i# AND 
                                (LANG1_SPEAK >=#arguments.lang_level# OR
                                LANG1_MEAN >=#arguments.lang_level# OR
                                LANG1_WRITE >=#arguments.lang_level#)
                            ) OR
                            (
                                LANG2=#i# AND
                                (LANG2_SPEAK >=#arguments.lang_level# OR
                                LANG2_MEAN >=#arguments.lang_level# OR
                                LANG2_WRITE >=#arguments.lang_level#)
                            ) OR
                            (
                                LANG3=#i# AND
                                (LANG3_SPEAK >=#arguments.lang_level# OR
                                LANG3_MEAN >=#arguments.lang_level# OR
                                LANG3_WRITE >=#arguments.lang_level#)
                            ) OR
                            (
                                LANG4=#i# AND
                                (LANG4_SPEAK >=#arguments.lang_level# OR
                                LANG4_MEAN >=#arguments.lang_level# OR
                                LANG4_WRITE >=#arguments.lang_level#)
                            ) OR
                            (
                                LANG5=#i# AND
                                (LANG5_SPEAK >=#arguments.lang_level# OR
                                LANG5_MEAN >=#arguments.lang_level# OR
                                LANG5_WRITE >=#arguments.lang_level#)
                            )
                        )
                        <cfset lang_count=lang_count+1>
                        <cfif listlen(arguments.lang) neq lang_count>
                            #arguments.lang_par#
                        </cfif>
                    </cfloop>
                    )
                </cfif>
                <cfif (isdefined("arguments.exp_year_s1") and len(arguments.exp_year_s1)) or (isdefined("arguments.exp_year_s2") and len(arguments.exp_year_s2))>
                    AND EMPLOYEES_APP.EMPAPP_ID IN (#exp_app_list#)
                </cfif>
                <cfif isdefined("arguments.driver_licence_type") and len(arguments.driver_licence_type)>
                    AND DRIVER_LICENCE_TYPE LIKE '%#arguments.driver_licence_type#%'
                </cfif>
                <cfif isdefined("arguments.driver_licence") and len(arguments.driver_licence)>
                    AND (DRIVER_LICENCE <> '' OR DRIVER_LICENCE_TYPE <> '')
                </cfif>
                <cfif isdefined("arguments.sentenced") and len(arguments.sentenced)>
                    AND SENTENCED = #arguments.sentenced#
                </cfif>
                <cfif isdefined("arguments.defected") and len(arguments.defected)>
                   AND DEFECTED = #arguments.defected#
                </cfif>
                <cfif isdefined("arguments.defected_level") and arguments.defected_level gt 0>
                   AND DEFECTED_LEVEL = #arguments.defected_level#
                </cfif>
                <cfif isdefined("arguments.is_trip") and len(arguments.is_trip)>
                   AND IS_TRIP = #arguments.is_trip#
                </cfif>
                <cfif isdefined("arguments.referance") and len(arguments.referance)>
                  AND
                     (
                       REF1 LIKE '%#arguments.referance#%' OR
                       REF2 LIKE '%#arguments.referance#%' OR
                       REF1_EMP LIKE '%#arguments.referance#%' OR
                       REF2_EMP LIKE '%#arguments.referance#%'
                     )
                </cfif>
                <cfif isdefined("arguments.homecity") and len(arguments.homecity)>
                    AND HOMECITY IN (#arguments.homecity#)
                </cfif>
                AND EMPLOYEES_APP_POS.APP_POS_ID IN(#arguments.list_app_pos_id#)
                <cfif isdefined('arguments.old')>
                    AND EMPLOYEES_APP.EMPAPP_ID NOT IN(SELECT EMPAPP_ID FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ID=#get_list.max_list_id#)
                </cfif>
            </cfquery>
            </cfif>
            
            <cfif isdefined('arguments.search_app') and arguments.search_app eq 1><!---özgeçmişleri ekliyor--->
            <cfquery name="add_list_row_app" datasource="#dsn#">
                INSERT INTO
                    EMPLOYEES_APP_SEL_LIST_ROWS
                    (
                        EMPAPP_ID,
                        APP_POS_ID,
                        STAGE,
                        ROW_STATUS,
                        LIST_ID,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )	
                    SELECT
                        EMPLOYEES_APP.EMPAPP_ID,
                        NULL,
                        NULL,
                        1,
                        #GET_LIST.MAX_LIST_ID#,
                        #now()#,
                        #session.pp.userid#,
                        '#cgi.REMOTE_ADDR#'
                    FROM
                        EMPLOYEES_APP,
                        EMPLOYEES_IDENTY
                    WHERE
                        EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP.EMPAPP_ID
                        AND EMPLOYEES_IDENTY.EMPAPP_ID IS NOT NULL
                    <cfif isdefined('arguments.status') and len(arguments.status)>
                        AND EMPLOYEES_APP.APP_STATUS = #arguments.status#
                    <cfelseif isdefined("arguments.status_app") and len(arguments.status_app)>
                        AND EMPLOYEES_APP.APP_STATUS = #arguments.status_app#
                    </cfif>
                    <cfif isdefined("arguments.app_name") and len(arguments.app_name)>
                        AND EMPLOYEES_APP.NAME LIKE '%#arguments.app_name#%'
                    </cfif>
                    <cfif isdefined("arguments.app_surname") and len(arguments.app_surname)>
                        AND EMPLOYEES_APP.SURNAME LIKE '%#arguments.app_surname#%'
                    </cfif>
                    <cfif isdefined("arguments.email") and len(arguments.email)>
                        AND EMPLOYEES_APP.EMAIL LIKE '#arguments.email#'
                    </cfif>
                    <cfif isdefined("arguments.birth_date1") and len(arguments.birth_date1)>
                        AND EMPLOYEES_IDENTY.BIRTH_DATE <= #arguments.date_dogum_1#
                    </cfif>
                     <cfif isdefined("arguments.birth_date2") and len(arguments.birth_date2)>
                        AND EMPLOYEES_IDENTY.BIRTH_DATE >= #arguments.date_dogum#
                    </cfif> 
                    <cfif (isdefined("arguments.sex") and listlen(arguments.sex))>
                        AND EMPLOYEES_APP.SEX IN (#listsort(arguments.sex,"NUMERIC")#) 
                    </cfif>
                    <cfif (isdefined("arguments.MARRIED") and listlen(arguments.MARRIED))>
                        AND EMPLOYEES_IDENTY.MARRIED IN (#listsort(arguments.married,"NUMERIC")#)  
                    </cfif>
                    <cfif (isdefined("arguments.military_status") and listlen(arguments.military_status))>
                        AND EMPLOYEES_APP.MILITARY_STATUS IN (#LISTSORT(arguments.military_status,"NUMERIC")#) 
                    </cfif>
                    <cfif isdefined("arguments.birth_place") and len(arguments.birth_place)>
                        AND EMPLOYEES_IDENTY.BIRTH_PLACE LIKE '%#arguments.birth_place#%'
                    </cfif>
                    <cfif isdefined("arguments.city") and len(arguments.city)>
                        AND EMPLOYEES_IDENTY.CITY LIKE '%#arguments.city#%'
                    </cfif>
                    <cfif isdefined("arguments.app_reply_date1") and len(arguments.app_reply_date1)>
                       AND EMPLOYEES_APP.RECORD_DATE >= #arguments.app_reply_date1# 
                    </cfif>
                    <cfif isdefined("arguments.app_reply_date2") and len(arguments.app_reply_date2)>
                      AND EMPLOYEES_APP.RECORD_DATE <= #arguments.app_reply_date2# 
                    </cfif>
                    <cfif isdefined("arguments.training_level") and len(arguments.training_level)>
                         AND TRAINING_LEVEL IN (#arguments.training_level#)
                        <!--- <cfif isdefined("arguments.edu_finish") and len(arguments.edu_finish)>
                        AND	(EDU1_FINISH = #arguments.edu_finish#
                            OR EDU2_FINISH = #arguments.edu_finish#  
                            OR EDU3_FINISH = #arguments.edu_finish#  
                            OR EDU4_FINISH = #arguments.edu_finish#
                            OR EDU4_FINISH_2 = #arguments.edu_finish# 
                            OR EDU5_FINISH = #arguments.edu_finish#
                            OR EDU7_FINISH = #arguments.edu_finish#)
                        </cfif> --->
                    </cfif>
                    <cfif isdefined("arguments.driver_licence_type") and len(arguments.driver_licence_type)>
                        AND DRIVER_LICENCE_TYPE LIKE '%#arguments.driver_licence_type#%'
                    </cfif>
                    <cfif isdefined("arguments.driver_licence") and len(arguments.driver_licence)>
                        AND (DRIVER_LICENCE <> '' OR DRIVER_LICENCE_TYPE <> '')
                    </cfif>
                    <cfif isdefined("arguments.sentenced") and len(arguments.sentenced)>
                        AND SENTENCED = #arguments.sentenced#
                    </cfif>
                    <cfif isdefined("arguments.defected") and len(arguments.defected)>
                       AND DEFECTED = #arguments.defected#
                    </cfif>
                    <cfif isdefined("arguments.defected_level") and arguments.defected_level gt 0>
                       AND DEFECTED_LEVEL = #arguments.defected_level#
                    </cfif>
                    <cfif isdefined("arguments.is_trip") and len(arguments.is_trip)>
                       AND IS_TRIP = #arguments.is_trip#
                    </cfif>
                    <cfif isdefined("arguments.referance") and len(arguments.referance)>
                      AND
                         (
                           REF1 LIKE '%#arguments.referance#%' OR
                           REF2 LIKE '%#arguments.referance#%' OR
                           REF1_EMP LIKE '%#arguments.referance#%' OR
                           REF2_EMP LIKE '%#arguments.referance#%'
                         )
                    </cfif>
                    <cfif isdefined("arguments.homecity") and len(arguments.homecity)>
                        AND HOMECITY IN (#arguments.homecity#)
                    </cfif>
                    <cfset city_count=0>
                    <cfif isdefined("arguments.prefered_city") and len(arguments.prefered_city)>
                        AND (
                            <cfloop list="#arguments.prefered_city#" index="i" delimiters=",">
                                 PREFERED_CITY LIKE '%,#i#,%'
                                <cfset city_count=city_count+1>
                                <cfif listlen(arguments.prefered_city) neq city_count>
                                OR
                                </cfif>
                            </cfloop>
                            )
                    </cfif>
                    <cfif isdefined("arguments.kurs") and len(arguments.kurs)>
                       <cfloop list="#arguments.kurs#" index="i">
                         AND
                         ( KURS1 LIKE '%,#i#,%' OR
                           KURS2 LIKE '%,#i#,%' OR
                           KURS3 LIKE '%,#i#,%' )
                       </cfloop>
                    </cfif>
                    <cfif (isdefined("arguments.exp_year_s1") and len(arguments.exp_year_s1)) or (isdefined("arguments.exp_year_s2") and len(arguments.exp_year_s2))>
                        AND EMPLOYEES_APP.EMPAPP_ID IN (#exp_app_list#)
                    </cfif>
                    <cfif isdefined("arguments.tool") and listlen(arguments.tool)>
                         AND 
                        (
                        <cfloop list="#listsort(arguments.tool,'textnocase')#" index="tool_index">
                            COMP_EXP LIKE '%#tool_index#%' <cfif ListLast(ListSort(arguments.tool,'textnocase')) neq "#Trim(tool_index)#">OR</cfif>
                        </cfloop>
                        )
                    </cfif> 
                    <cfif isdefined("arguments.lang") and len(arguments.lang)>
                        AND
                        (  
                        <cfset lang_count=0>
                        <cfloop list="#arguments.lang#" delimiters="," index="i">
                            (
                                (
                                    LANG1=#i# AND 
                                    (LANG1_SPEAK >=#arguments.lang_level# OR
                                    LANG1_MEAN >=#arguments.lang_level# OR
                                    LANG1_WRITE >=#arguments.lang_level#)
                                ) OR
                                (
                                    LANG2=#i# AND
                                    (LANG2_SPEAK >=#arguments.lang_level# OR
                                    LANG2_MEAN >=#arguments.lang_level# OR
                                    LANG2_WRITE >=#arguments.lang_level#)
                                ) OR
                                (
                                    LANG3=#i# AND
                                    (LANG3_SPEAK >=#arguments.lang_level# OR
                                    LANG3_MEAN >=#arguments.lang_level# OR
                                    LANG3_WRITE >=#arguments.lang_level#)
                                ) OR
                                (
                                    LANG4=#i# AND
                                    (LANG4_SPEAK >=#arguments.lang_level# OR
                                    LANG4_MEAN >=#arguments.lang_level# OR
                                    LANG4_WRITE >=#arguments.lang_level#)
                                ) OR
                                (
                                    LANG5=#i# AND
                                    (LANG5_SPEAK >=#arguments.lang_level# OR
                                    LANG5_MEAN >=#arguments.lang_level# OR
                                    LANG5_WRITE >=#arguments.lang_level#)
                                )
                            )
                            <cfset lang_count=lang_count+1>
                            <cfif listlen(arguments.lang) neq lang_count>
                                #arguments.lang_par#
                            </cfif>
                        </cfloop>
                        )
                    </cfif>
                    <cfif ((isdefined("arguments.edu3") and len(arguments.edu3)) or (isdefined("arguments.edu3_part") and len(arguments.edu3_part))) or ((isdefined("arguments.edu4") and len(arguments.edu4)) or (isdefined("arguments.edu4_id") and len(arguments.edu4_id))) or ((isdefined("arguments.edu4_part") and len(arguments.edu4_part)) or (isdefined("arguments.edu4_part_id") and len(arguments.edu4_part_id))) or (isdefined("arguments.edu_finish") and len(arguments.edu_finish))>
                        AND EMPLOYEES_APP.EMPAPP_ID IN (#edu_app_list#)
                    </cfif>
                        <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                         AND
                           (
                            EMPLOYEES_APP.NAME LIKE '%#arguments.keyword#%'
                            OR
                            EMPLOYEES_APP.SURNAME LIKE '%#arguments.keyword#%'
                           )	
                        </cfif>
                        <cfif isdefined("arguments.commethod_id") and (arguments.commethod_id neq 0)>
                            AND EMPLOYEES_APP.COMMETHOD_ID = #arguments.commethod_id#
                        </cfif>	   
                        <cfif isdefined("arguments.app_currency_id") and len(arguments.app_currency_id)>
                            AND EMPLOYEES_APP.APP_CURRENCY_ID = #arguments.app_currency_id#
                        </cfif>
                        <cfif isdefined('arguments.martyr_relative') and len(arguments.martyr_relative)>AND EMPLOYEES_APP.MARTYR_RELATIVE =1</cfif>
                        <cfif isdefined('arguments.other') and len(arguments.other)>
                            AND
                            ( (EMPLOYEES_APP.EMPAPP_ID IN(SELECT DISTINCT EMPAPP_ID FROM EMPLOYEES_APP_WORK_INFO
                            WHERE
                            (EXP <cfif arguments.other_if eq 1>NOT</cfif> LIKE '%#arguments.other#%') OR
                            (EXP_POSITION <cfif arguments.other_if eq 1>NOT</cfif> LIKE '%#arguments.other#%') OR
                            (EXP_EXTRA <cfif arguments.other_if eq 1>NOT</cfif> LIKE '%#arguments.other#%')
                            )
                            )
                            OR
                            CLUB <cfif arguments.other_if eq 1>NOT</cfif> LIKE '%#arguments.other#%' OR
                            APPLICANT_NOTES <cfif arguments.other_if eq 1>NOT</cfif> LIKE '%#arguments.other#%'
                            )
                        </cfif>
                        <cfif isdefined("arguments.unit_id") and len(arguments.unit_id) and len(arguments.unit_row)>
                            AND EMPLOYEES_APP.EMPAPP_ID IN(SELECT DISTINCT EAU.EMPAPP_ID FROM EMPLOYEES_APP_UNIT EAU
                                                        WHERE 
                                                            EAU.UNIT_ID IN (#arguments.unit_id#) 
                                                             AND EAU.UNIT_ROW<=#arguments.unit_row#
                                                            )
                        </cfif>
                    AND EMPLOYEES_APP.EMPAPP_ID NOT IN(SELECT EMPAPP_ID FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ID=#get_list.max_list_id#)
                    AND EMPLOYEES_APP.EMPAPP_ID IN(#arguments.list_empapp_id#)
            </cfquery>
            </cfif>
                </cftransaction>
            </cflock>
            
            
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

</cfcomponent>