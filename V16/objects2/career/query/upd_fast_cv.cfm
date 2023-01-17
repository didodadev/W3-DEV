<cfif not isdefined('session.cp.userid')>
	<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>
<cfset upload_folder = "#upload_folder#hr#dir_seperator#">
<cfif isdefined("attributes.old_photo") and len(attributes.old_photo)>
	<cfif len(attributes.photo)>
		<cffile action="delete" file="#upload_folder##attributes.old_photo#">
		<cfset attributes.old_photo = "">
	<cfelse>
		<cfif isdefined("del_photo")>
			<cffile action="delete" file="#upload_folder##attributes.old_photo#">
			<cfset attributes.old_photo = "">
		</cfif>
	</cfif>
</cfif>
<cfif len(attributes.photo)>
	<cftry>
		<cffile action = "upload"
			  filefield = "photo"
			  destination = "#upload_folder#" 
			  nameconflict = "MakeUnique" 
			  accept="image/*"
			  mode="777">

		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upLOAD_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset attributes.photo = '#file_name#.#cffile.serverfileext#'>
	
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang no ='1412.Resim yüklenemedi lütfen tekrar deneyiniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
<cfelse>
	<cfset attributes.photo = attributes.old_photo>
</cfif>
<!--- FS 20080806 ucasede tirnakli ifadeler kaydedilirken sorun oluyor bu yuzden once baska bi yerde tanimlamak gerekiyor --->
<cfif len(attributes.head_cv)><cfset head_cv_ = UCASETR(attributes.head_cv)></cfif>
<cfif len(attributes.lang1)><cfset lang1_where_ = UCASETR(attributes.lang1_where)></cfif>
<cfif len(attributes.lang2)><cfset lang2_where_ = UCASETR(attributes.lang2_where)></cfif>
<cfif len(attributes.lang3)><cfset lang3_where_ = UCASETR(attributes.lang3_where)></cfif>
<cfif len(attributes.kurs1)><cfset kurs1_ = UCASETR(attributes.kurs1)></cfif>
<cfif len(attributes.kurs2)><cfset kurs2_ = UCASETR(attributes.kurs2)></cfif>
<cfif len(attributes.kurs3)><cfset kurs3_ = UCASETR(attributes.kurs3)></cfif>
<cfif len(attributes.kurs1_yer)><cfset kurs1_yer_ = UCASETR(attributes.kurs1_yer)></cfif>
<cfif len(attributes.kurs2_yer)><cfset kurs2_yer_ = UCASETR(attributes.kurs2_yer)></cfif>
<cfif len(attributes.kurs3_yer)><cfset kurs3_yer_ = UCASETR(attributes.kurs3_yer)></cfif>
<cfif isdefined("attributes.comp_exp") and len(attributes.comp_exp)><cfset comp_exp_ = UCASETR(attributes.comp_exp)></cfif>
<cfif len(attributes.licence_start_date)><cf_date tarih="attributes.licence_start_date"></cfif>

<cflock timeout="20">
	<cftransaction>
		<cfquery name="UPD_FAST_CV" datasource="#DSN#">
            UPDATE 
                EMPLOYEES_APP
            SET
                HEAD_CV = <cfif len(attributes.head_cv)>'#head_cv_#'<cfelse>NULL</cfif>,
                NAME = '#UCASETR(attributes.emp_name)#',
                SURNAME = '#UCASETR(attributes.emp_surname)#',
                PHOTO= <cfif len(attributes.photo)>'#attributes.photo#'<cfelse>NULL</cfif>,
                PHOTO_SERVER_ID= <cfif len(attributes.photo)>#fusebox.server_machine#<cfelse>NULL</cfif>,
                SEX = <cfif isdefined("attributes.sex") and len(attributes.sex)>#attributes.sex#<cfelse>0</cfif>,
                <cfif isdefined("attributes.defected")>
                    DEFECTED = #attributes.defected#,
                    <cfif isdefined('attributes.defected_level')>DEFECTED_LEVEL = #attributes.defected_level#,</cfif>
                <cfelse>
                    DEFECTED = 0,
                    DEFECTED_LEVEL = 0,
                </cfif>
                LICENCECAT_ID = <cfif len(attributes.driver_licence_type)>#attributes.driver_licence_type#<cfelse>NULL</cfif>,
                LICENCE_START_DATE = <cfif len(attributes.licence_start_date)>#attributes.licence_start_date#<cfelse>NULL</cfif>,
                MILITARY_STATUS = <cfif isdefined("attributes.military_status") and len(attributes.military_status)>#attributes.military_status#<cfelse>0</cfif>,
                MOBILCODE = <cfif len(attributes.mobilcode)>'#attributes.mobilcode#'<cfelse>NULL</cfif>,
                MOBIL = <cfif len(attributes.mobil)> '#attributes.mobil#'<cfelse>NULL</cfif>,
                HOMETELCODE = <cfif len(attributes.hometelcode)>'#attributes.hometelcode#'<cfelse>NULL</cfif>,
                HOMETEL = <cfif len(attributes.hometel)>'#attributes.hometel#'<cfelse>NULL</cfif>,
                EMAIL = <cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
                HOMEADDRESS = '#attributes.homeaddress#',
                HOMECOUNTY = '#attributes.homecounty#',
                HOMECITY= <cfif len(attributes.homecity)>#attributes.homecity#<cfelse>NULL</cfif>,
                HOMECOUNTRY = <cfif len(attributes.homecountry)>#attributes.homecountry#<cfelse>NULL</cfif>,
                PREFERENCE_BRANCH = <cfif isdefined("attributes.preference_branch") and len(attributes.preference_branch)>',#attributes.preference_branch#,'<cfelse>NULL</cfif>,
                TRAINING_LEVEL = <cfif len(attributes.training_level)>#attributes.training_level#<cfelse>NULL</cfif>,
                KURS1 = <cfif len(attributes.kurs1)>'#kurs1_#'<cfelse>NULL</cfif>,
                KURS1_YIL = <cfif len(attributes.kurs1_yil) eq 4>{TS '#attributes.kurs1_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
                KURS1_YER = <cfif len(attributes.kurs1_yer)>'#kurs1_yer_#'<cfelse>NULL</cfif>,
                KURS1_GUN = <cfif len(attributes.kurs1_gun)>'#attributes.kurs1_gun#'<cfelse>NULL</cfif>,
                KURS2 = <cfif len(attributes.kurs2)>'#kurs2_#'<cfelse>NULL</cfif>,
                KURS2_YIL = <cfif len(attributes.kurs2_yil) eq 4>{TS '#attributes.kurs2_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
                KURS2_YER = <cfif len(attributes.kurs2_yer)>'#kurs2_yer_#'<cfelse>NULL</cfif>,
                KURS2_GUN = <cfif len(attributes.kurs2_gun)>'#attributes.kurs2_gun#'<cfelse>NULL</cfif>,
                KURS3 = <cfif len(attributes.kurs3)>'#kurs3_#'<cfelse>NULL</cfif>,
                KURS3_YIL = <cfif len(attributes.kurs3_yil) eq 4>{TS '#attributes.kurs3_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
                KURS3_YER = <cfif len(attributes.kurs3_yer)>'#kurs3_yer_#'<cfelse>NULL</cfif>,
                KURS3_GUN = <cfif len(attributes.kurs3_gun)>'#attributes.kurs3_gun#'<cfelse>NULL</cfif>,
                COMP_EXP = <cfif isdefined("attributes.comp_exp") and len(attributes.comp_exp)>'#comp_exp_#'<cfelse>NULL</cfif>,
                APP_STATUS = 1,
                UPDATE_IP = '#cgi.REMOTE_ADDR#',
                UPDATE_DATE = #now()#,
                UPDATE_EMP = NULL,
                UPDATE_APP_DATE = #now()#,
                UPDATE_APP_IP = '#cgi.remote_addr#',
                UPDATE_APP = #session.cp.userid#
            WHERE
                EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
        </cfquery>

        <cfloop from="1" to="5" index="i">
            <cfif (not len(evaluate('attributes.lang_id#i#'))) and len(evaluate('attributes.lang#i#'))>
                <cfquery name="ADD_LANGS" datasource="#DSN#">
                    INSERT INTO
                        EMPLOYEES_APP_LANGUAGE
                        (
                            EMPAPP_ID,
                            LANG_ID,
                            LANG_SPEAK,
                            LANG_MEAN,
                            LANG_WRITE,
                            LANG_WHERE,
                            RECORD_DATE,
                            RECORD_IP
                        )
                        VALUES
                        (
                            #session.cp.userid#,
                            #evaluate('attributes.lang#i#')#,
                            <cfif len(evaluate('attributes.lang#i#_speak'))>#evaluate('attributes.lang#i#_speak')#<cfelse>NULL</cfif>,
                            <cfif len(evaluate('attributes.lang#i#_mean'))>#evaluate('attributes.lang#i#_mean')#<cfelse>NULL</cfif>,
                            <cfif len(evaluate('attributes.lang#i#_write'))>#evaluate('attributes.lang#i#_write')#<cfelse>NULL</cfif>,
                            <cfif len(evaluate('attributes.lang#i#_where'))>'#evaluate('attributes.lang#i#_where')#'<cfelse>NULL</cfif>	,
                            #now()#,
                            '#cgi.remote_addr#'	
                        )
                </cfquery>
            <cfelseif len(evaluate('attributes.lang_id#i#')) and len(evaluate('attributes.lang#i#'))>
                <cfquery name="UPDA_LANG" datasource="#DSN#">
                    UPDATE
                        EMPLOYEES_APP_LANGUAGE
                    SET
                        LANG_SPEAK = <cfif len(evaluate('attributes.lang#i#_speak'))>#evaluate('attributes.lang#i#_speak')#<cfelse>NULL</cfif>,
                        LANG_MEAN = <cfif len(evaluate('attributes.lang#i#_mean'))>#evaluate('attributes.lang#i#_mean')#<cfelse>NULL</cfif>,
                        LANG_WRITE = <cfif len(evaluate('attributes.lang#i#_write'))>#evaluate('attributes.lang#i#_write')#<cfelse>NULL</cfif>,
                        LANG_WHERE = <cfif len(evaluate('attributes.lang#i#_where'))>'#evaluate('attributes.lang#i#_where')#'<cfelse>NULL</cfif>,
                        UPDATE_DATE = #now()#,
                        UPDATE_IP = '#cgi.remote_addr#'
                    WHERE
                        EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#"> AND
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.lang_id#i#')#">
                </cfquery>
            <cfelseif (not len(evaluate('attributes.lang#i#'))) and len(evaluate('attributes.lang_id#i#'))>
                <cfquery name="DEL_LANGS" datasource="#DSN#">
                    DELETE FROM EMPLOYEES_APP_LANGUAGE
                    WHERE
                        EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#"> AND
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.lang_id#i#')#">
                </cfquery>
            </cfif>
        </cfloop>
            
        <cfquery name="DELETE_EMP_REFERENCE" datasource="#DSN#">
            DELETE EMPLOYEES_REFERENCE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
        </cfquery>		
        <cfloop from="1" to="#attributes.add_ref_info#" index="r">
            <cfif isdefined('attributes.del_ref_info#r#') and  evaluate('attributes.del_ref_info#r#') eq 1><!--- silinmemiş ise.. --->
                <cfquery name="ADD_EMPLOYEES_REFERENCE" datasource="#DSN#">
                    INSERT INTO
                        EMPLOYEES_REFERENCE
                         (
                            EMPAPP_ID,
                            EMPLOYEE_ID,
                            REFERENCE_TYPE,
                            REFERENCE_NAME,
                            REFERENCE_COMPANY,
                            REFERENCE_POSITION,
                            REFERENCE_TELCODE,
                            REFERENCE_TEL,
                            REFERENCE_EMAIL
                         )
                         VALUES
                         (
                            #session.cp.userid#,
                            NULL,
                            <cfif len(wrk_eval('attributes.ref_type#r#'))>#wrk_eval('attributes.ref_type#r#')#<cfelse>NULL</cfif>,<!--- '#wrk_eval('attributes.ref_type#r#')#', --->
                            <cfif len(wrk_eval('attributes.ref_name#r#'))>'#wrk_eval('attributes.ref_name#r#')#'<cfelse>NULL</cfif>,
                            <cfif len(wrk_eval('attributes.ref_company#r#'))>'#wrk_eval('attributes.ref_company#r#')#'<cfelse>NULL</cfif>,
                            <cfif len(wrk_eval('attributes.ref_position#r#'))>'#wrk_eval('attributes.ref_position#r#')#'<cfelse>NULL</cfif>,
                            <cfif len(wrk_eval('attributes.ref_telcode#r#'))>'#wrk_eval('attributes.ref_telcode#r#')#'<cfelse>NULL</cfif>,
                            <cfif len(wrk_eval('attributes.ref_tel#r#'))>'#wrk_eval('attributes.ref_tel#r#')#'<cfelse>NULL</cfif>,
                            <cfif len(wrk_eval('attributes.ref_mail#r#'))>'#wrk_eval('attributes.ref_mail#r#')#'<cfelse>NULL</cfif>
                         )
                </cfquery>
            </cfif>
        </cfloop>
            
        <cfif len(attributes.birth_date)>
            <cf_date tarih="attributes.birth_date">
        </cfif>
        <cfif not isdefined("attributes.married")>
            <cfset attributes.married = 0>
        </cfif>
        <cfquery name="UPD_IDENTY" datasource="#DSN#">
            UPDATE
                EMPLOYEES_IDENTY
            SET
                <cfif len(attributes.tc_identy_no)>
                    TC_IDENTY_NO = '#attributes.tc_identy_no#',
                <cfelse>
                    TC_IDENTY_NO = NULL, 
                </cfif>
                BIRTH_DATE = <cfif len(attributes.birth_date)>#attributes.birth_date#<cfelse>NULL</cfif>,
                BIRTH_PLACE = '#attributes.birth_place#',
                MARRIED = #attributes.married#,
                UPDATE_DATE = #now()#,
                UPDATE_IP = '#cgi.remote_addr#',
                UPDATE_EMP = #session.cp.userid#
            WHERE
                EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
        </cfquery>
        
            <!--- Egitim Bilgileri Lise --->
        <cfif isdefined("attributes.edu_id_lise") and len(attributes.edu_id_lise) and isdefined("attributes.empapp_edu_row_id_lise")>
            <cfif isdefined("attributes.edu_part_id_lise") and len(attributes.edu_part_id_lise) and attributes.edu_part_id_lise neq -1>
                <cfquery name="GET_EDU_HIGH_PART_NAME" datasource="#DSN#">
                    SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.edu_part_id_lise#">
                </cfquery>
                <cfset 'attributes.edu_part_name_lise' = get_edu_high_part_name.high_part_name>
            <cfelse>
                <cfset 'attributes.edu_part_name_lise' = attributes.edu_part_name_lise>
            </cfif>
            <cfif isdefined("attributes.edu_id_lise") and len(attributes.edu_id_lise) and isdefined("attributes.edu_name_lise") and len(attributes.edu_name_lise)>
                <cfquery name="UPD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                    UPDATE
                        EMPLOYEES_APP_EDU_INFO
                    SET
                        EDU_TYPE = 3,
                        EDU_ID = <cfif isdefined("attributes.edu_id_lise") and len(attributes.edu_id_lise)>#attributes.edu_id_lise#<cfelse>-1</cfif>,
                        EDU_NAME = <cfif isdefined("attributes.edu_name_lise") and len(evaluate('attributes.edu_name_lise'))>'#attributes.edu_name_lise#'<cfelse>NULL</cfif>,
                        EDU_PART_ID = <cfif isdefined("attributes.edu_part_id_lise") and len(evaluate('attributes.edu_part_id_lise'))>#attributes.edu_part_id_lise#<cfelse>NULL</cfif>,
                        EDU_PART_NAME = <cfif isdefined("attributes.edu_part_name_lise") and len(evaluate('attributes.edu_part_name_lise'))>'#attributes.edu_part_name_lise#'<cfelse>NULL</cfif>,
                        EDU_START = <cfif isdefined("attributes.edu_start_lise") and len(attributes.edu_start_lise)>#attributes.edu_start_lise#<cfelse>NULL</cfif>,
                        EDU_FINISH = <cfif isdefined("attributes.edu_finish_lise") and len(attributes.edu_finish_lise)>#attributes.edu_finish_lise#<cfelse>NULL</cfif>,
                        EMPAPP_ID = #session.cp.userid#,
                        IS_EDU_CONTINUE = 0
                    WHERE
                        EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_edu_row_id_lise#">
                </cfquery>
            </cfif>
        <cfelseif isdefined("attributes.edu_id_lise") and len(attributes.edu_id_lise) and not isdefined("attributes.empapp_edu_row_id_lise")>
            <cfif isdefined("attributes.edu_part_id_lise") and len(attributes.edu_part_id_lise) and attributes.edu_part_id_lise neq -1>
                <cfquery name="GET_EDU_HIGH_PART_NAME" datasource="#DSN#">
                    SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.edu_part_id_lise#">
                </cfquery>
                <cfset 'attributes.edu_part_name_lise' = get_edu_high_part_name.high_part_name>
            <cfelse>
                <cfset 'attributes.edu_part_name_lise' = attributes.edu_part_name_lise>
            </cfif>
            <cfif isdefined("attributes.edu_id_lise") and listlen(evaluate("attributes.edu_id_lise"),';') and isdefined("attributes.edu_name_lise") and len(evaluate("attributes.edu_name_lise"))>
                <cfquery name="ADD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                    INSERT INTO
                        EMPLOYEES_APP_EDU_INFO
                    (
                        EMPAPP_ID,
                        EDU_TYPE,
                        EDU_ID,
                        EDU_NAME,
                        EDU_PART_ID,
                        EDU_PART_NAME,
                        EDU_START,
                        EDU_FINISH,
                        IS_EDU_CONTINUE
                    )
                    VALUES
                    (
                        #session.cp.userid#,
                        3,
                        #attributes.edu_id_lise#,
                        <cfif isdefined("attributes.edu_name_lise") and len(attributes.edu_name_lise)>'#UCASETR(attributes.edu_name_lise)#'<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.edu_part_id_lise") and len(attributes.edu_part_id_lise)>#attributes.edu_part_id_lise#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.edu_part_name_lise") and len(attributes.edu_part_name_lise)>'#UCASETR(attributes.edu_part_name_lise)#'<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.edu_start_lise") and len(attributes.edu_start_lise)>#attributes.edu_start_lise#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.edu_finish_lise") and len(attributes.edu_finish_lise)>#attributes.edu_finish_lise#<cfelse>NULL</cfif>,
                        0
                    )
                </cfquery>
            </cfif>
        <cfelseif not (isdefined("attributes.edu_id_lise") and len(attributes.edu_id_lise)) and isdefined("attributes.empapp_edu_row_id_lise")>
            <cfquery name="DEL_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                DELETE FROM
                    EMPLOYEES_APP_EDU_INFO
                WHERE
                    EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_edu_row_id_lise#">
            </cfquery>
        </cfif>
        
        <!--- is Tecrubeleri --->
        <cfif not isdefined("attributes.is_exp")>
            <cfloop from="1" to="#attributes.row_count#" index="k">
                 <cfif isdefined("attributes.row_kontrol#k#") and evaluate("attributes.row_kontrol#k#")>
                    <cfif isdate(evaluate('attributes.exp_start#k#'))>
                        <cfset attributes.exp_start=evaluate('attributes.exp_start#k#')>
                        <cf_date tarih="attributes.exp_start">
                    <cfelse>
                        <cfset attributes.exp_start="">
                    </cfif>
                    <cfif isdate(evaluate('attributes.exp_finish#k#'))>
                        <cfset attributes.exp_finish=evaluate('attributes.exp_finish#k#')>
                        <cf_date tarih="attributes.exp_finish">
                    <cfelse>
                        <cfset attributes.exp_finish="">
                    </cfif>
                    <cfif len(attributes.exp_start) gt 9 and len(attributes.exp_finish) gt 9>
                       <cfset attributes.exp_fark = datediff("d",attributes.exp_start,attributes.exp_finish)>
                     <cfelse>
                        <cfset attributes.exp_fark="">
                    </cfif>
                    <cfif isDefined("attributes.empapp_row_id#k#") and len(evaluate("attributes.empapp_row_id#k#"))>
                        <cfif len(evaluate('attributes.exp_name#k#'))>
                            <cfset exp_name_ = UCaseTR(evaluate('attributes.exp_name#k#'))>
                            <cfquery name="UPD_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
                                UPDATE
                                    EMPLOYEES_APP_WORK_INFO
                                SET
                                    EXP = <cfif len(evaluate('attributes.exp_name#k#'))>'#exp_name_#'<cfelse>NULL</cfif>,
                                    EXP_START = <cfif isdate(attributes.exp_start)>#attributes.exp_start#<cfelse>NULL</cfif>,
                                    EXP_FINISH = <cfif isdate(attributes.exp_finish)>#attributes.exp_finish#<cfelse>NULL</cfif>,
                                    EXP_FARK = <cfif len(attributes.exp_fark)>#attributes.exp_fark#<cfelse>NULL</cfif>,
                                    EXP_REASON_ID = <cfif len(evaluate('attributes.exp_reason_id#k#'))>#evaluate('attributes.exp_reason_id#k#')#<cfelse>NULL</cfif>,
                                    EXP_SECTOR_CAT= <cfif len(evaluate('attributes.exp_sector_cat#k#'))>#evaluate('attributes.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
                                    EXP_TASK_ID = <cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
                                    IS_CONT_WORK = <cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>,
                                    EMPAPP_ID = #session.cp.userid#
                                WHERE
                                    EMPAPP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.empapp_row_id#k#")#">
                            </cfquery>
                        <cfelse>
                            <cfquery name="DEL_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
                                DELETE FROM
                                    EMPLOYEES_APP_WORK_INFO
                                WHERE
                                    EMPAPP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.empapp_row_id#k#")#">
                            </cfquery>
                        </cfif>
                    <cfelseif len(evaluate('attributes.exp_name#k#'))>
                        <cfset exp_name_ = UCaseTR(evaluate('attributes.exp_name#k#'))>
                        <cfquery name="ADD_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
                            INSERT INTO
                                EMPLOYEES_APP_WORK_INFO
                                (
                                    EMPAPP_ID,
                                    EXP,
                                    EXP_START,
                                    EXP_FINISH,
                                    EXP_FARK,
                                    EXP_REASON_ID,
                                    EXP_SECTOR_CAT,
                                    EXP_TASK_ID,
                                    IS_CONT_WORK
                                    )
                                VALUES
                                (
                                    #session.cp.userid#,
                                     <cfif len(evaluate('attributes.exp_name#k#'))>'#exp_name_#'<cfelse>NULL</cfif>,
                                    <cfif isdate(attributes.exp_start)>#attributes.exp_start#<cfelse>NULL</cfif>,
                                    <cfif isdate(attributes.exp_finish)>#attributes.exp_finish#<cfelse>NULL</cfif>,
                                    <cfif len(attributes.exp_fark)>#attributes.exp_fark#<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('attributes.exp_reason_id#k#'))>'#UCASETR(evaluate('attributes.exp_reason_id#k#'))#'<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('attributes.exp_sector_cat#k#'))>#evaluate('attributes.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
                                )
                        </cfquery>
                    </cfif>
                 </cfif>
            </cfloop>
        </cfif>
        <!--- EGitim Bilgileri --->
        <cfloop from="1" to="#attributes.row_edu#" index="j">
            <cfif isdefined("attributes.row_kontrol_edu#j#") and evaluate("attributes.row_kontrol_edu#j#")>
                <cfif isdefined("attributes.edu_part_id#j#") and len(evaluate('attributes.edu_part_id#j#')) >
                    <cfset bolum_id = evaluate('attributes.edu_part_id#j#')>
                <cfelse>
                    <cfset bolum_id = -1>
                </cfif>
                <cfif isDefined("attributes.empapp_edu_row_id#j#") and len(evaluate("attributes.empapp_edu_row_id#j#"))>
                    <cfif len(evaluate('attributes.edu_name#j#'))>
                        <cfquery name="UPD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                                UPDATE
                                    EMPLOYEES_APP_EDU_INFO
                                SET
                                    EDU_TYPE = #evaluate('attributes.edu_type#j#')#,
                                    EDU_ID = <cfif isdefined("attributes.edu_id#j#") and len(evaluate('attributes.edu_id#j#'))>#evaluate('attributes.edu_id#j#')#<cfelse>-1</cfif>,
                                    EDU_NAME = <cfif isdefined("attributes.edu_name#j#") and len(evaluate('attributes.edu_name#j#'))>'#UCASETR(evaluate('attributes.edu_name#j#'))#'<cfelse>NULL</cfif>,
                                    EDU_PART_ID = <cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
                                    EDU_PART_NAME = <cfif isdefined("attributes.edu_part_name#j#") and len(evaluate('attributes.edu_part_name#j#'))>'#UCASETR(evaluate('attributes.edu_part_name#j#'))#'<cfelse>NULL</cfif>,
                                    EDU_START = <cfif isdefined("attributes.edu_start#j#") and len(evaluate('attributes.edu_start#j#'))>#evaluate('attributes.edu_start#j#')#<cfelse>NULL</cfif>,
                                    EDU_FINISH = <cfif isdefined("attributes.edu_finish#j#") and len(evaluate('attributes.edu_finish#j#'))>#evaluate('attributes.edu_finish#j#')#<cfelse>NULL</cfif>,
                                    EMPAPP_ID = #session.cp.userid#
                                WHERE
                                    EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.empapp_edu_row_id#j#")#">
                        </cfquery>
                    <cfelse>
                        <cfif isDefined("attributes.empapp_edu_row_id#j#") and len(evaluate("attributes.empapp_edu_row_id#j#"))>
                            <cfquery name="DEL_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                                DELETE FROM
                                    EMPLOYEES_APP_EDU_INFO
                                WHERE
                                    EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.empapp_edu_row_id#j#")#">
                            </cfquery>
                        </cfif>
                    </cfif>
                <cfelseif len(evaluate('attributes.edu_name#j#'))>
                    <cfquery name="ADD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                        INSERT INTO
                            EMPLOYEES_APP_EDU_INFO
                        (
                            EMPAPP_ID,
                            EDU_TYPE,
                            EDU_ID,
                            EDU_NAME,
                            EDU_PART_ID,
                            EDU_PART_NAME,
                            EDU_START,
                            EDU_FINISH
                        )
                            VALUES
                        (
                            #session.cp.userid#,
                            #evaluate('attributes.edu_type#j#')#,
                            <cfif isdefined("attributes.edu_id#j#") and len(evaluate('attributes.edu_id#j#'))>#evaluate('attributes.edu_id#j#')#<cfelse>-1</cfif>,
                            <cfif isdefined("attributes.edu_name#j#") and len(evaluate('attributes.edu_name#j#'))>'#UCASETR(evaluate('attributes.edu_name#j#'))#'<cfelse>NULL</cfif>,
                            <cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.edu_part_name#j#") and len(evaluate('attributes.edu_part_name#j#'))>'#UCASETR(evaluate('attributes.edu_part_name#j#'))#'<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.edu_start#j#") and len(evaluate('attributes.edu_start#j#'))>#evaluate('attributes.edu_start#j#')#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.edu_finish#j#") and len(evaluate('attributes.edu_finish#j#'))>#evaluate('attributes.edu_finish#j#')#<cfelse>NULL</cfif>
                        )
                    </cfquery>
                </cfif>
            </cfif>
        </cfloop>
        
        <!---dosya sil--->
        <cfif isdefined("attributes.old_asset_file") and len(attributes.old_asset_file) and isdefined("attributes.del_asset_file") and len(attributes.del_asset_file)>
            <cfset upload_folder = "#upload_folder#">
            <cfif FileExists("#upload_folder##attributes.old_asset_file#")>
                <cffile action="delete" file="#upload_folder##attributes.old_asset_file#">
            </cfif>
            <cfquery name="DEL_ASSET" datasource="#DSN#">
                DELETE FROM ASSET WHERE ASSET_ID = #attributes.del_asset_file#
            </cfquery>
        </cfif>
        
        <!---dosya ekle--->
        <cfif isdefined("attributes.asset_file") and len(attributes.asset_file) and isdefined('attributes.asset_file_name') and len(attributes.asset_file_name)>
            <cfset upload_folder = "#upload_folder##dir_seperator#">
            <cftry>
                <cfset file_name = createUUID()>
                <cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="asset_file" destination="#upload_folder#" mode="777">
                <cffile action="rename" source="#upload_folder##dir_seperator##cffile.serverfile#" destination="#upload_folder##dir_seperator##file_name#.#cffile.serverfileext#">
                <!---Script dosyalarını engelle  02092010 FA-ND --->
                <cfset assetTypeName = listlast(cffile.serverfile,'.')>
                <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
                <cfif listfind(blackList,assetTypeName,',')>
                    <cffile action="delete" file="#upload_folder##dir_seperator##file_name#.#cffile.serverfileext#">
                    <script type="text/javascript">
                        alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                        history.back();
                    </script>
                    <cfabort>
                </cfif>
                <cfcatch type="any">
                    <script type="text/javascript">
                        alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
                        history.back();
                    </script>
                    <cfabort>
                </cfcatch>
            </cftry>
            <!--- PROPERTY_ID belge tipi 1 set ediliyor ancak 1 olmaya bilir dbde kariyer belgeleri için seçilen belge no ona göre ayarlanmalı--->
            <cfquery name="ADD_ASSET" datasource="#DSN#">
                INSERT INTO 
                    ASSET
                    (
                       MODULE_NAME,
                       MODULE_ID,
                       ACTION_SECTION,
                       ACTION_ID,
                       ASSETCAT_ID, 
                       ASSET_NAME,
                       ASSET_FILE_NAME,
                       ASSET_FILE_SIZE,
                       ASSET_DETAIL,
                       IS_SPECIAL,
                       RECORD_DATE,
                       RECORD_PUB,
                       RECORD_IP,
                       PROPERTY_ID,
                       COMPANY_ID,
                       ASSET_FILE_SERVER_ID
                    )
                    VALUES
                    (
                       'HR',
                       3,
                       'EMPLOYEES_APP_ID',
                       #session.cp.userid#,
                       -8,
                       <cfif isdefined('attributes.asset_file_name') and len(attributes.asset_file_name)>'#attributes.asset_file_name#'<cfelse>NULL</cfif>,
                       '#file_name#.#cffile.serverfileext#',
                       #ROUND(CFFILE.FILESIZE/1024)#,
                       'Kariyer portalından eklenen dosya',
                       0,
                       #now()#,
                       #session.cp.userid#,
                       '#CGI.REMOTE_ADDR#',
                       1,
                       1,
                       #fusebox.server_machine#
                    )
            </cfquery>
        </cfif>
        
        <!--- Brans Bilgileri --->
        <cfquery name="DEL_EMPLOYEES_APP_INFO" datasource="#DSN#"> 
            DELETE FROM EMPLOYEES_APP_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
        </cfquery>
        <cfif isdefined("attributes.branch_row_count")>
            <cfloop from="1" to="#attributes.branch_row_count#" index="i">
                <cfset branches_id = evaluate("attributes.branches_id_#i#")>
                <cfif isdefined('attributes.emp_app_info_#branches_id#') and len(evaluate("attributes.emp_app_info_#branches_id#"))>
                    <cfset row_branches_id = evaluate("attributes.emp_app_info_#branches_id#")>
                    <cfloop list="#row_branches_id#" delimiters="," index="row_i">
                    	<cfif isDefined('attributes.other_branches_name_#branches_id#')>
							<cfset other_branches_name_id_ = evaluate('attributes.other_branches_name_#branches_id#')>
                            <cfquery name="ADD_EMPLOYEES_APP_INFO" datasource="#DSN#">
                                INSERT INTO 
                                    EMPLOYEES_APP_INFO
                                (
                                     EMPAPP_ID,
                                     BRANCHES_ID,
                                     BRANCHES_ROW_ID,
                                     BRANCHES_ROW_OTHER
                                )
                                VALUES
                                (
                                    #session.cp.userid#,
                                    #branches_id#,
                                    #row_i#,
                                    <cfif isdefined("attributes.other_branches_name_#branches_id#") and len(evaluate('attributes.other_branches_name_#branches_id#'))>'#other_branches_name_id_#'<cfelse>NULL</cfif>
                                )
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cfif>
            </cfloop>
        </cfif>
        
        <cfif attributes.teacher_info_record eq 0>
            <cfquery name="ADD_TEACHER_INFO" datasource="#DSN#">
                INSERT INTO 
                    EMPLOYEES_APP_TEACHER_INFO
                (
                    EMPAPP_ID,
                    COMPUTER_EDUCATION,
                    SALARY_RANGE,
                    IS_FORMATION,
                    INTERNSHIP,
                    FORMATION_TYPE
                )
                VALUES
                (
                    #session.cp.userid#,
                    <cfif isdefined("attributes.computer_education") and len(attributes.computer_education)>',#attributes.computer_education#,'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.salary_range") and len(attributes.salary_range)>'#attributes.salary_range#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.formation") and len(attributes.formation)>#attributes.formation#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.internship") and len(attributes.internship)>#attributes.internship#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.formation_typee") and len(attributes.formation_typee)>',#attributes.formation_typee#,'<cfelse>NULL</cfif>
                )
            </cfquery>
        <cfelse>
            <cfquery name="UPD_TEACHER_INFO" datasource="#DSN#">
                UPDATE
                    EMPLOYEES_APP_TEACHER_INFO
                SET
                    COMPUTER_EDUCATION = <cfif isdefined("attributes.computer_education") and len(attributes.computer_education)>',#attributes.computer_education#,'<cfelse>NULL</cfif>,
                    SALARY_RANGE =  <cfif isdefined("attributes.salary_range") and len(attributes.salary_range)>'#attributes.salary_range#'<cfelse>NULL</cfif>,
                    IS_FORMATION = <cfif isdefined("attributes.formation") and len(attributes.formation)>#attributes.formation#<cfelse>NULL</cfif>,
                    INTERNSHIP = <cfif isdefined("attributes.internship") and len(attributes.internship)>#attributes.internship#<cfelse>NULL</cfif>,
                    FORMATION_TYPE = <cfif isdefined("attributes.formation_typee") and len(attributes.formation_typee)>',#attributes.formation_typee#,'<cfelse>NULL</cfif>
                WHERE
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
        </cfif>
        
        <!--- calısmak istedigi birimler--->
        <cfquery name="DEL_EMPLOYEES_APP_UNIT" datasource="#DSN#"> 
            DELETE FROM 
                EMPLOYEES_APP_UNIT 
            WHERE 
                EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
        </cfquery>
        <cfquery name="GET_CV_UNIT" datasource="#DSN#">
            SELECT 
                UNIT_ID 
            FROM 
                SETUP_CV_UNIT
        </cfquery>
        <cfoutput query="get_cv_unit">
            <cfif isdefined('unit#get_cv_unit.unit_id#') and len(evaluate('unit#get_cv_unit.unit_id#'))>
                <cfquery name="add_unit" datasource="#DSN#">
                    INSERT 
                        INTO EMPLOYEES_APP_UNIT
                        (
                            EMPAPP_ID,
                            UNIT_ID,
                            UNIT_ROW
                        )
                        VALUES
                        (
                            #session.cp.userid#,
                            #get_cv_unit.unit_id#,
                            #evaluate('unit#get_cv_unit.unit_id#')#
                        )
                </cfquery> 
            </cfif>
        </cfoutput>
    </cftransaction>
</cflock>
<script type="text/javascript">
	alert("<cf_get_lang no ='1490.Güncelleme İşlemi Başarıyla Gerçekleşmiştir'>!");
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.dsp_cv';
</script>
