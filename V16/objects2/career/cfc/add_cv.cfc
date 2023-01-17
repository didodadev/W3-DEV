<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset fusebox.server_machine = application.systemParam.systemParam().fusebox.server_machine>

    <cfsavecontent variable="warning">
        <cf_get_lang dictionary_id='62565.Kayıt İşlemi Gerçekleşti, Yönlendiriliyorsunuz'>
    </cfsavecontent>

    <!--- Kariyer Başvurusu --->
    <cffunction name="add_cv" access="public" returntype="string" returnformat="json">
        <cftry> 
            <cfif len(arguments.email)>
                <cfquery name="get_empapp_mail" datasource="#dsn#">
                    SELECT
                        EMAIL
                    FROM
                        EMPLOYEES_APP
                    WHERE
                        EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
                </cfquery>
                <cfif get_empapp_mail.recordcount>
                    <cfif get_empapp_mail.recordcount>
                        <cfset result.status = false>
                        <cfset result.danger_message = "<cf_get_lang no ='1411.Girdiğiniz mail adresine ait bir kullanıcı  Aynı mail adresi ile başka bir kullanıcı ekleyemezsiniz'>">
                        <cfset result.error = "<cf_get_lang no ='1411.Girdiğiniz mail adresine ait bir kullanıcı  Aynı mail adresi ile başka bir kullanıcı ekleyemezsiniz'>" >
                        <cfreturn Replace(SerializeJSON(result),'//','')>
                    </cfif>
                </cfif>
            </cfif>
            <cfif isdefined("arguments.photo") and len(arguments.photo)>
                <cftry>
                    <cfset upload_folder = "#upload_folder##dir_seperator#hr#dir_seperator#">
            
                    <CFFILE action = "upload" 
                          filefield = "photo" 
                          destination = "#upload_folder#" 
                          nameconflict = "MakeUnique" 
                          mode="777">
            
                    <cfset file_name = createUUID()>
                    <CFFILE action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
                    <cfset arguments.photo = '#file_name#.#cffile.serverfileext#'>
                    
                    <cfcatch type="Any">
                        <script type="text/javascript">
                            alert("<cf_get_lang no ='1412.Resim yüklenemedi lütfen tekrar deneyiniz'> !");
                            history.back();
                        </script>
                        <cfabort>
                    </cfcatch>
                </cftry>
            <cfelse>
                <cfset arguments.photo = "">
            </cfif>
            
            <cfif len(arguments.birth_date)>
                <cf_date tarih="arguments.birth_date">
            <cfelse>
                <cfset arguments.birth_date = "null">
            </cfif>
            
            <cfif len(arguments.licence_start_date)>
                <cf_date tarih="arguments.licence_start_date">
            </cfif>
            
            <cfif len(arguments.military_finishdate)>
                <cf_date tarih="arguments.military_finishdate">
            <cfelse>
                <cfset arguments.military_finishdate = "NULL">
            </cfif>
            
            <cfif len(arguments.military_delay_date)>
                <cf_date tarih="arguments.military_delay_date">
            <cfelse>
                <cfset arguments.military_delay_date = "NULL">
            </cfif>
            
            <!--- çalışmak istediği departmanlar--->
            <cfquery name="get_cv_unit" datasource="#DSN#">
                SELECT * FROM SETUP_CV_UNIT
            </cfquery>
            
            <cflock name="#CreateUUID()#" timeout="20">
                <cftransaction>
                <cfquery name="ADD_EMP_APP" datasource="#DSN#" result="MAX_ID">
                    INSERT INTO 
                        EMPLOYEES_APP
                        (
                        STEP_NO,
                        APP_STATUS,
                        <cfif isdefined("arguments.sentenced") and len(arguments.sentenced)>SENTENCED,</cfif>		
                        <cfif isdefined("arguments.defected") and len(arguments.defected)>
                        DEFECTED,
                        DEFECTED_LEVEL,
                        </cfif>
                        <cfif isdefined("arguments.sex")>SEX,</cfif>
                        NAME,
                        <cfif len(arguments.worktelcode)>WORKTELCODE,</cfif>
                        <cfif len(arguments.worktel)>WORKTEL,</cfif>
                        SURNAME,
                        <cfif len(arguments.extension)>EXTENSION,</cfif>
                        EMAIL,
                        <cfif len(arguments.mobilcode)>MOBILCODE,</cfif>
                        <cfif len(arguments.mobil)>MOBIL,</cfif>
                        <cfif len(arguments.mobilcode2)>MOBILCODE2,</cfif>
                        <cfif len(arguments.mobil2)>MOBIL2,</cfif>
                        <cfif len(arguments.tax_number)>TAX_NUMBER,</cfif>
                        <cfif len(arguments.tax_office)>TAX_OFFICE,</cfif>
                        IMCAT_ID,
                        IM,
                        PHOTO,
                        PHOTO_SERVER_ID,
                        IDENTYCARD_CAT,
                        IDENTYCARD_NO,
                    <cfif arguments.lang1 gt 0>
                        _LANG1,
                        _LANG1_SPEAK,
                        _LANG1_MEAN,
                        _LANG1_WRITE,
                        _LANG1_WHERE,
                    </cfif>
                    <cfif arguments.lang2 gt 0>
                        _LANG2,
                        _LANG2_SPEAK,
                        _LANG2_MEAN,
                        _LANG2_WRITE,
                        _LANG2_WHERE,
                    </cfif>	
                    <cfif arguments.lang3 gt 0>	
                        _LANG3,
                        _LANG3_SPEAK,
                        _LANG3_MEAN,
                        _LANG3_WRITE,
                        _LANG3_WHERE,
                    </cfif>
                    <cfif arguments.lang4 gt 0>
                        _LANG4,
                        _LANG4_SPEAK,
                        _LANG4_MEAN,
                        _LANG4_WRITE,
                        _LANG4_WHERE,
                    </cfif>
                    <cfif arguments.lang5 gt 0>
                        _LANG5,
                        _LANG5_SPEAK,
                        _LANG5_MEAN,
                        _LANG5_WRITE,
                        _LANG5_WHERE,
                    </cfif>
                        <cfif isdefined("arguments.KURS1") and len(arguments.KURS1)>KURS1,</cfif>
                        <cfif isdefined("arguments.kurs1_yil") and len(arguments.kurs1_yil)>KURS1_YIL,</cfif>
                        <cfif isdefined("arguments.kurs1_yer") and len(arguments.kurs1_yer)>KURS1_YER,</cfif>
                        <cfif isdefined("arguments.kurs1_gun") and len(arguments.kurs1_gun)>KURS1_GUN,</cfif>
                        <cfif isdefined("arguments.KURS2") and len(arguments.KURS2)>KURS2,</cfif>
                        <cfif isdefined("arguments.kurs2_yil") and len(arguments.kurs2_yil)>KURS2_YIL,</cfif>
                        <cfif isdefined("arguments.kurs2_yer") and len(arguments.kurs2_yer)>KURS2_YER,</cfif>
                        <cfif isdefined("arguments.kurs2_gun") and len(arguments.kurs2_gun)>KURS2_GUN,</cfif>
                        <cfif isdefined("arguments.KURS2") and len(arguments.KURS2)>KURS3,</cfif>
                        <cfif isdefined("arguments.kurs3_yil") and len(arguments.kurs3_yil)>KURS3_YIL,</cfif>
                        <cfif isdefined("arguments.kurs3_yer") and len(arguments.kurs3_yer)>KURS3_YER,</cfif>
                        <cfif isdefined("arguments.kurs3_gun") and len(arguments.kurs3_gun)>KURS3_GUN,</cfif>
                        <cfif isdefined("arguments.comp_exp") and len(arguments.comp_exp)>COMP_EXP,</cfif>
                        <cfif isdefined("arguments.hometelcode") and len(arguments.hometelcode)>HOMETELCODE,</cfif>
                        <cfif isdefined("arguments.hometel") and len(arguments.hometel)>HOMETEL,</cfif>
                        HOMEADDRESS,
                        HOMEPOSTCODE,
                        HOMECOUNTY,
                        HOMECITY,
                        HOMECOUNTRY,
                        <cfif isdefined('arguments.prefered_city') and len(arguments.prefered_city)>PREFERED_CITY,</cfif>
                        IS_TRIP,
                        APPLICANT_NOTES,
                        MILITARY_STATUS,
                        MILITARY_DELAY_REASON,
                        MILITARY_DELAY_DATE,
                        MILITARY_FINISHDATE,
                        MILITARY_MONTH,
                        MILITARY_RANK,
                        MILITARY_EXEMPT_DETAIL,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP,
                        RECORD_APP_DATE,
                        RECORD_APP,
                        RECORD_APP_IP,
                        TC_IDENTY_NO,
                        DEFECTED_PROBABILITY,
                        ILLNESS_PROBABILITY,
                        <cfif len(arguments.illness_detail)>ILLNESS_DETAIL,</cfif>
                        <cfif len(arguments.surgical_operation)>SURGICAL_OPERATION,</cfif>	
                        <cfif len(arguments.training_level)>TRAINING_LEVEL,</cfif>
                        <cfif len(arguments.investigation)>INVESTIGATION,</cfif>
                        DRIVER_LICENCE,
                        LICENCECAT_ID,
                        LICENCE_START_DATE,
                        DRIVER_LICENCE_ACTIVED,
                        NATIONALITY,
                        CLUB,
                        USE_CIGARETTE,
                        MARTYR_RELATIVE,
                        HOME_STATUS,
                        <cfif len(arguments.hobby)>HOBBY,</cfif>
                        WORK_STARTED,
                        WORK_FINISHED
                        )
                    VALUES
                        (
                        -1,
                        1,
                    <cfif isdefined("arguments.sentenced") and len(arguments.sentenced)>
                        #arguments.sentenced#,
                    </cfif>	
                    <cfif isDefined("arguments.defected") and len(arguments.defected)>
                        #arguments.defected#,
                        <cfif isdefined('arguments.defected_level') and len(arguments.defected_level)>
                            #arguments.defected_level#,
                        <cfelse>
                            NULL,
                        </cfif>
                    </cfif>		
                    <cfif isDefined("arguments.sex")>
                        #arguments.sex#,
                    </cfif>
                        '#arguments.name#',
                    <cfif len(arguments.worktelcode)>
                        '#arguments.worktelcode#',
                    </cfif>
                    <cfif len(arguments.worktel)>
                        '#arguments.worktel#',
                    </cfif>
                        '#arguments.surname#',
                    <cfif len(arguments.extension)>
                        '#arguments.extension#',
                    </cfif>
                        '#arguments.email#',
                    <cfif len(arguments.mobilcode)>
                        '#arguments.mobilcode#',
                    </cfif>
                    <cfif len(arguments.mobil)>
                        '#arguments.mobil#',
                    </cfif>
                    <cfif len(arguments.mobilcode2)>
                        '#arguments.mobilcode2#',
                    </cfif>
                    <cfif len(arguments.mobil2)>
                        '#arguments.mobil2#',
                    </cfif>
                    <cfif len(arguments.tax_number)>'#arguments.tax_number#',</cfif>
                    <cfif len(arguments.tax_office)>'#arguments.tax_office#',</cfif>
                    <cfif len(arguments.imcat_id)>#arguments.imcat_id#<cfelse>NULL</cfif>,
                    '#arguments.im#',
                    '#arguments.photo#',
                    '#fusebox.server_machine#',
                    <cfif len(arguments.identycard_cat)>#arguments.identycard_cat#<cfelse>NULL</cfif>,
                    '#arguments.identycard_no#',		
                    <cfif arguments.lang1 gt 0>
                        #arguments.lang1#,
                        #arguments.lang1_speak#,
                        #arguments.lang1_mean#,
                        #arguments.lang1_write#,
                        '#arguments.lang1_where#',
                    </cfif>
                    <cfif len(arguments.lang2)>
                        #arguments.lang2#,
                        #arguments.lang2_speak#,
                        #arguments.lang2_mean#,
                        #arguments.lang2_write#,
                        '#arguments.lang2_where#',
                    </cfif>	
                    <cfif len(arguments.lang3)>
                        #arguments.lang3#,
                        #arguments.lang3_speak#,
                        #arguments.lang3_mean#,
                        #arguments.lang3_write#,
                        '#arguments.lang3_where#',
                    </cfif>
                    <cfif len(arguments.lang4)>
                        #arguments.lang4#,
                        #arguments.lang4_speak#,
                        #arguments.lang4_mean#,
                        #arguments.lang4_write#,
                        '#arguments.lang4_where#',
                    </cfif>
                    <cfif len(arguments.lang5)>
                        #arguments.lang5#,
                        #arguments.lang5_speak#,
                        #arguments.lang5_mean#,
                        #arguments.lang5_write#,
                        '#arguments.lang5_where#',
                    </cfif>
                        <cfif isdefined("arguments.KURS1") and len(arguments.KURS1)>'#arguments.KURS1#',</cfif>
                        <cfif isdefined("arguments.kurs1_yil") and len(arguments.kurs1_yil)>{TS '#arguments.kurs1_yil#-01-01 00:00:00'},</cfif>
                        <cfif isdefined("arguments.kurs1_yer") and len(arguments.kurs1_yer)>'#arguments.kurs1_yer#',</cfif>
                        <cfif isdefined("arguments.kurs1_gun") and len(arguments.kurs1_gun)>#arguments.kurs1_gun#,</cfif>
                        <cfif isdefined("arguments.kurs1_yil") and len(arguments.kurs2)>'#arguments.kurs2#',</cfif>
                        <cfif isdefined("arguments.kurs2_yil") and len(arguments.kurs2_yil)>{TS '#arguments.kurs2_yil#-01-01 00:00:00'},</cfif>
                        <cfif isdefined("arguments.kurs2_yer") and len(arguments.kurs2_yer)>'#arguments.kurs2_yer#',</cfif>
                        <cfif isdefined("arguments.kurs2_gun") and len(arguments.kurs2_gun)>#arguments.kurs2_gun#,</cfif>
                        <cfif isdefined("arguments.kurs1_yil") and len(arguments.kurs3)>'#arguments.kurs3#',</cfif>
                        <cfif isdefined("arguments.kurs3_yil") and len(arguments.kurs3_yil)>{TS '#arguments.kurs3_yil#-01-01 00:00:00'},</cfif>
                        <cfif isdefined("arguments.kurs3_yer") and len(arguments.kurs3_yer)>'#arguments.kurs3_yer#',</cfif>
                        <cfif isdefined("arguments.kurs3_gun") and len(arguments.kurs3_gun)>#arguments.KURS3_GUN#,</cfif>			
                        <cfif isdefined("arguments.comp_exp") and len(arguments.comp_exp)>'#arguments.comp_exp#',</cfif>
                        <cfif isdefined("arguments.hometelcode") and len(arguments.hometelcode)>'#arguments.hometelcode#',</cfif>
                        <cfif isdefined("arguments.hometel") and len(arguments.hometel)>'#arguments.hometel#',</cfif>
                        '#arguments.homeaddress#',
                        '#arguments.homepostcode#',
                        '#arguments.homecounty#',
                        <cfif len(arguments.homecity_name) and len(arguments.homecity)>#arguments.homecity#,<cfelse>NULL,</cfif>
                        <cfif len(arguments.homecountry)>#arguments.homecountry#,<cfelse>NULL,</cfif>
                        <cfif isdefined('arguments.prefered_city') and len(arguments.prefered_city)>',#arguments.prefered_city#,',</cfif>
                        #arguments.is_trip#,
                        '#arguments.applicant_notes#',
                        #arguments.military_status#,
                        <cfif arguments.military_status eq 4 and len(arguments.MILITARY_DELAY_REASON)>'#arguments.MILITARY_DELAY_REASON#',<cfelse>NULL,</cfif>
                        <cfif arguments.military_status eq 4 and len(arguments.MILITARY_DELAY_DATE)>#arguments.MILITARY_DELAY_DATE#,<cfelse>NULL,</cfif>
                        <cfif arguments.military_status eq 1 and len(arguments.military_finishdate)>#arguments.military_finishdate#,<cfelse>NULL,</cfif>
                        <cfif arguments.military_status eq 1 and len(arguments.military_month)>#arguments.military_month#,<cfelse>NULL,</cfif>
                        <cfif arguments.military_status eq 1 and isdefined('arguments.military_rank')>#arguments.military_rank#,<cfelse>NULL,</cfif>
                        <cfif arguments.military_status eq 2>'#arguments.military_exempt_detail#',<cfelse>NULL,</cfif>
                        NULL,
                        NULL,
                        NULL,
                        #NOW()#,
                        <cfif isdefined("session.ww.userid") and len(session.ww.userid)>#SESSION.WW.USERID#,<cfelse>NULL,</cfif>
                        '#CGI.REMOTE_ADDR#',
                        <cfif isdefined('#arguments.tc_identy_no#') and len('#arguments.tc_identy_no#')>'#arguments.tc_identy_no#'<cfelse>NULL</cfif>,
                        #arguments.defected_probability#,
                        #arguments.illness_probability#,
                        <cfif len(arguments.illness_detail)>'#arguments.illness_detail#',</cfif>
                        <cfif len(arguments.surgical_operation)>'#arguments.surgical_operation#',</cfif>	
                         <cfif len(arguments.training_level)>#arguments.training_level#,</cfif>
                        <cfif len(arguments.investigation)>'#arguments.investigation#',</cfif>
                        '#arguments.driver_licence#',
                        <cfif len(arguments.driver_licence_type)>#arguments.driver_licence_type#<cfelse>NULL</cfif>,
                        <cfif len(arguments.licence_start_date)>#arguments.licence_start_date#<cfelse>NULL</cfif>,
                        <cfif len(arguments.driver_licence_actived)>#arguments.driver_licence_actived#<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.nationality') and len(arguments.nationality)>#arguments.nationality#<cfelse>NULL</cfif>,
                        '#arguments.club#',
                        #arguments.use_cigarette#,
                        #arguments.martyr_relative#,
                        <cfif isdefined('arguments.home_status')>#arguments.home_status#<cfelse>NULL</cfif>,
                        <cfif len(arguments.hobby)>'#arguments.hobby#',</cfif>
                        0,
                        0
                    ) 
                </cfquery>
                <!--- Bilgisayar Bilgisi --->
                <cfif isdefined("arguments.comp_exp") and  len(arguments.comp_exp)>
                    <cfquery name="ADD_TEACHER_INFO" datasource="#dsn#">
                        INSERT INTO 
                            EMPLOYEES_APP_TEACHER_INFO
                                (
                                 EMPAPP_ID,
                                 COMPUTER_EDUCATION
                                 )
                            VALUES
                                (
                                  #MAX_ID.IDENTITYCOL#,
                                  ',-1,'
                                 )
                    </cfquery>
                </cfif>
                <!--- İş Tecrübeleri --->
                <cfset arguments.exp_fark = "">
                <cfif arguments.row_count gt 0>
                    <cfloop from="1" to="#arguments.row_count#" index="k">
                        <cfif isdefined("arguments.exp_start#k#") and len(evaluate('arguments.exp_start#k#'))>
                            <cfset arguments.exp_start=evaluate('arguments.exp_start#k#')>
                            <cf_date tarih="arguments.exp_start">
                        <cfelse>
                            <cfset arguments.exp_start="">
                        </cfif>
                        <cfif isdefined("arguments.exp_finish#k#") and  len(evaluate('arguments.exp_finish#k#'))>
                            <cfset arguments.exp_finish=evaluate('arguments.exp_finish#k#')>
                            <cf_date tarih="arguments.exp_finish">
                        <cfelse>
                            <cfset arguments.exp_finish="">
                        </cfif>
                        <cfif len(arguments.exp_start) gt 9 and len(arguments.exp_finish) gt 9>
                           <cfset arguments.exp_fark = datediff("d",arguments.exp_start,arguments.exp_finish)>
                        </cfif>
                        <cfif isdefined("arguments.row_kontrol#k#") and evaluate("arguments.row_kontrol#k#")>
                        <cfquery name="ADD_EMPLOYEES_APP_WORK_INFO" datasource="#dsn#">
                            INSERT INTO
                                EMPLOYEES_APP_WORK_INFO
                                (
                                EMPAPP_ID,
                                EMPLOYEE_ID,
                                EXP,
                                EXP_POSITION,
                                EXP_START,
                                EXP_FINISH,
                                EXP_FARK,
                                EXP_REASON,
                                EXP_EXTRA,
                                EXP_TELCODE,
                                EXP_TEL,
                                EXP_SECTOR_CAT,
                                EXP_SALARY,
                                EXP_EXTRA_SALARY,
                                EXP_TASK_ID,
                                IS_CONT_WORK
                                )
                            VALUES
                                (
                                #MAX_ID.IDENTITYCOL#,
                                NULL,
                                <cfif len(evaluate('arguments.exp_name#k#'))>'#wrk_eval('arguments.exp_name#k#')#'<cfelse>NULL</cfif>,
                                <cfif len(evaluate('arguments.exp_position#k#'))>'#wrk_eval('arguments.exp_position#k#')#'<cfelse>NULL</cfif>,
                                <cfif len(arguments.exp_start)>#arguments.exp_start#,<cfelse>NULL,</cfif>
                                <cfif len(arguments.exp_finish)>#arguments.exp_finish#,<cfelse>NULL,</cfif>
                                <cfif len(arguments.exp_fark)>#arguments.exp_fark#<cfelse>NULL</cfif>,
                                <cfif len(evaluate('arguments.exp_reason#k#'))>'#Replace(evaluate('arguments.exp_reason#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
                                <cfif len(evaluate('arguments.exp_extra#k#'))>'#Replace(evaluate('arguments.exp_extra#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
                                <cfif len(evaluate('arguments.exp_telcode#k#'))>'#wrk_eval('arguments.exp_telcode#k#')#'<cfelse>NULL</cfif>,
                                <cfif len(evaluate('arguments.exp_tel#k#'))>'#wrk_eval('arguments.exp_tel#k#')#'<cfelse>NULL</cfif>,
                                <cfif len(evaluate('arguments.exp_sector_cat#k#'))>#evaluate('arguments.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
                                <cfif len(evaluate('arguments.exp_salary#k#'))>#evaluate('arguments.exp_salary#k#')#<cfelse>NULL</cfif>,
                                <cfif len(evaluate('arguments.exp_extra_salary#k#'))>'#wrk_eval('arguments.exp_extra_salary#k#')#'<cfelse>NULL</cfif>,
                                <cfif len(evaluate('arguments.exp_task_id#k#'))>#evaluate('arguments.exp_task_id#k#')#<cfelse>NULL</cfif>,
                                <cfif isdefined("arguments.is_cont_work#k#") and evaluate('arguments.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
                                )
                        </cfquery>
                        </cfif>
                    </cfloop>
                </cfif>
                <!--- İş Tecrübeleri --->
                <!--- Eğitim Bilgileri --->
                <cfif arguments.row_edu gt 0>
                    <cfloop from="1" to="#arguments.row_edu#" index="j">
                        <cfif isdefined("arguments.edu_high_part_id#j#") and  len(evaluate('arguments.edu_high_part_id#j#'))  and evaluate('arguments.edu_type#j#') eq 3>
                            <cfset bolum_id = evaluate('arguments.edu_high_part_id#j#')>
                        <cfelseif isdefined("arguments.edu_part_id#j#") and len(evaluate('arguments.edu_part_id#j#')) >
                            <cfset bolum_id = evaluate('arguments.edu_part_id#j#')>
                        <cfelse>
                            <cfset bolum_id = -1>
                        </cfif>
                        <cfif isdefined("arguments.row_kontrol_edu#j#") and evaluate("arguments.row_kontrol_edu#j#")>
                            <cfquery name="ADD_EMPLOYEES_APP_EDU_INFO" datasource="#dsn#">
                                INSERT INTO
                                    EMPLOYEES_APP_EDU_INFO
                                    (
                                    EMPAPP_ID,
                                    EMPLOYEE_ID,
                                    EDU_TYPE,
                                    EDU_ID,
                                    EDU_NAME,
                                    EDU_PART_ID,
                                    EDU_PART_NAME,
                                    EDU_START,
                                    EDU_FINISH,
                                    EDU_RANK,
                                    IS_EDU_CONTINUE
                                    )
                                    VALUES
                                    (
                                    #MAX_ID.IDENTITYCOL#,
                                    NULL,
                                    #evaluate('arguments.edu_type#j#')#,
                                    <cfif isdefined("arguments.edu_id#j#") and len(evaluate('arguments.edu_id#j#'))>#evaluate('arguments.edu_id#j#')#<cfelseif evaluate('arguments.edu_type#j#') eq 3 or evaluate('arguments.edu_type#j#') eq 4 or evaluate('arguments.edu_type#j#') eq 5 or evaluate('arguments.edu_type#j#') eq 6>-1<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_name#j#") and len(evaluate('arguments.edu_name#j#'))>'#wrk_eval('arguments.edu_name#j#')#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_part_name#j#") and len(evaluate('arguments.edu_part_name#j#'))>'#wrk_eval('arguments.edu_part_name#j#')#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_start#j#") and len(evaluate('arguments.edu_start#j#'))>#evaluate('arguments.edu_start#j#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_finish#j#") and len(evaluate('arguments.edu_finish#j#'))>#evaluate('arguments.edu_finish#j#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_rank#j#") and len(evaluate('arguments.edu_rank#j#'))>'#wrk_eval('arguments.edu_rank#j#')#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.is_edu_continue#j#") and evaluate('arguments.is_edu_continue#j#') eq 1>1<cfelse>0</cfif>
                                    )
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cfif>
                <!--- Eğitim Bilgileri --->
                <cfquery name="ADD_IDENTY" datasource="#dsn#">
                    INSERT INTO
                        EMPLOYEES_IDENTY
                        (
                        EMPAPP_ID,
                        TC_IDENTY_NO,
                    <cfif len(arguments.TAX_NUMBER)>TAX_NUMBER,</cfif>
                    <cfif len(arguments.tax_office)>TAX_OFFICE,</cfif>
                        BIRTH_DATE,
                        BIRTH_PLACE,
                        MARRIED,
                        CITY,
                        RECORD_DATE,
                        RECORD_IP,
                        RECORD_EMP
                        )
                    VALUES
                        (
                        #MAX_ID.IDENTITYCOL#,
                        '#arguments.tc_identy_no#',	
                    <cfif len(arguments.tax_number)>
                        '#arguments.tax_number#',
                    </cfif>
                    <cfif len(arguments.tax_office)>
                        '#arguments.tax_office#',
                    </cfif>
                    <cfif len(arguments.birth_date)>#arguments.birth_date#,<cfelse>NULL,</cfif>
                        '#arguments.birth_place#',
                        #arguments.married#,
                        '#arguments.city#',
                        #now()#,
                        '#cgi.REMOTE_ADDR#',
                        <cfif isdefined("session.ww.userid") and len(session.ww.userid)>#SESSION.WW.USERID#<cfelse>NULL</cfif>
                        )
                </cfquery>
                <!--- çalışmak istediği birimler--->
                    <cfquery name="get_cv_unit" datasource="#DSN#">
                        SELECT * FROM SETUP_CV_UNIT
                    </cfquery>
                     <cfoutput query="get_cv_unit">
                    <cfif isdefined('unit#get_cv_unit.unit_id#') and len(evaluate('unit#get_cv_unit.unit_id#'))>
                        <cfquery name="add_unit" datasource="#dsn#">
                            INSERT 
                                INTO EMPLOYEES_APP_UNIT
                                (
                                    EMPAPP_ID,
                                    UNIT_ID,
                                    UNIT_ROW
                                )
                                VALUES
                                (
                                    #MAX_ID.IDENTITYCOL#,
                                    #get_cv_unit.unit_id#,
                                    #evaluate('unit#get_cv_unit.unit_id#')#
                                )
                        </cfquery> 
                    </cfif>
                    </cfoutput>
                <!--- //çalışmak istediği birimler--->
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