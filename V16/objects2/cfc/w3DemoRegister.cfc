<cfcomponent>
    <!--- w3 demo kayıt --->
	
	<cfset dsn = application.systemParam.systemParam().dsn />
    <cfset default_menu = application.systemParam.systemParam().default_menu />
	
    <cffunction name="w3DemoRegister" access="remote" returntype="any">
    	<cfargument name="member_name" type="string"> <!--- Kayıdı Yapılacak Üye Adı ---> 
        <cfargument name="member_surname" type="string"> <!--- Kayıdı Yapılacak Üye Soyadı ---> 
        <cfargument name="employee_username" type="string"> <!--- Üye Kullanıcı Adı ---> 
        <cfargument name="employee_password" type="string"> <!--- Üye Şifresi ---> 
        <cfargument name="employee_password1" type="string"> <!--- Üye Şifresi Tekrar ---> 
        <cfargument name="fullname" type="string"> <!--- Üye Firma Adı ---> 
        <cfargument name="email" type="string"> <!--- Üye E-Mail Adresi ---> 
        <cfargument name="where_did_you_hear" type="string"> <!--- Workcube'ü nereden duydunuz? ---> 
        <cfargument name="is_mail" type="numeric"> <!--- Müşteri Mail istiyormu 0-Hayır 1-Evet --->
        <cfargument name="telno" type="string"><!--- Telefon ---> 
        <cfargument name="lang" type="string" default = "tr"><!--- Dili ---> 
        <cfargument name="interface_id" type="numeric"><!--- Arayüz ---> 
        
        <!--- <cfsavecontent variable="arguman_">
            <cfdump var="#arguments#">
        </cfsavecontent>
        <cfmail from = "Workcube E-İş Sistemleri<workcube@workcube.com>" to="ugurhamurpet@workcube.com" subject="demo argümanları" type="HTML">
            <cfoutput>#arguman_#</cfoutput>
        </cfmail> --->
        <cftry>
			<cfscript>
                xmldoc = '';
                error_code = '';//Hata Kodu
                error_detail = '';//Hata Detayı
                banned_words = 'enlargement,natural,penis,viagra,sex,Pharmacies,modes,Payday,Loans'; //Yasaklı kelimeler
            </cfscript>
            
            <cfset w3_our_company_id = 1>
            <cfset attributes.position_cat_id = 1> <!--- company kontroller --->
            <cfset my_aplicant_name = '#arguments.member_name# #arguments.member_surname#'>
            
            <!--- Yasaklı Kelime Kontrolü --->         
            <cfloop list="#banned_words#" index="i">
                <cfif my_aplicant_name contains i or arguments.fullname contains i>
                    <cfset error_code = 13>
                    <cfset error_detail = "Yanlış Kayıt">
                </cfif>
            </cfloop>
            
            <cfquery name="GET_PERIOD" datasource="#dsn#">
                SELECT TOP 1 OUR_COMPANY_ID, PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR = #year(now())# AND OUR_COMPANY_ID = #w3_our_company_id#
            </cfquery>
             <cfquery name="GET_PERIODS" datasource="#dsn#">
                SELECT OUR_COMPANY_ID, PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR = #year(now())#
            </cfquery>
            <cfquery name="GET_STAGE_EMP" datasource="#dsn#" maxrows="1">
                SELECT
                    PTR.PROCESS_ROW_ID
                FROM
                    PROCESS_TYPE_ROWS PTR,
                    PROCESS_TYPE PT
                WHERE 
                    PTR.PROCESS_ID = PT.PROCESS_ID AND
                    PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%hr.list_hr%">
                ORDER BY
                    PTR.PROCESS_ROW_ID ASC    
            </cfquery>
            
            <cfif not StructKeyExists(arguments, "member_name") or not len(arguments.member_name)>
                <cfset error_code = 3>
                <cfset error_detail = "Lütfen Adınızı Giriniz!">
            <cfelseif not StructKeyExists(arguments,"member_surname") or not len(arguments.member_surname)>
                <cfset error_code = 4>
                <cfset error_detail = "Lütfen Soyadınızı Giriniz!">
            <cfelseif not StructKeyExists(arguments,"employee_username") or not len(arguments.employee_username)>
                <cfset error_code = 5>
                <cfset error_detail = "Lütfen Kullanıcı Adını Giriniz!">
            <cfelseif not StructKeyExists(arguments,"employee_password") or not len(arguments.employee_password)>
                <cfset error_code = 6>
                <cfset error_detail = "Lütfen Kullanıcı Şifrenizi Giriniz!">
            <cfelseif not StructKeyExists(arguments,"employee_password1") or not len(arguments.employee_password1)>
                <cfset error_code = 8>
                <cfset error_detail = "Lütfen Kullanıcı Şifrenizi Giriniz!">
            <cfelseif not StructKeyExists(arguments,"fullname") or not len(arguments.fullname)>
                <cfset error_code = 9>
                <cfset error_detail = "Lütfen Firma Adını Giriniz!">
            <cfelseif not StructKeyExists(arguments,"email") or not len(arguments.email)>
                <cfset error_code = 10>
                <cfset error_detail = "Lütfen E-Mail Adresini Giriniz!">
            </cfif>
            
            <cf_cryptedpassword password="#arguments.employee_password1#" output="sifre" mod="1">     
            <cfquery name="CHECK_NAME" datasource="#dsn#">
                SELECT 
                    EMPLOYEE_ID
                FROM 
                    EMPLOYEES
                WHERE
                    EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.employee_username)#"> OR
                    EMPLOYEE_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.email)#">
            </cfquery>
            <cfif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang eq 'tr'>
                <cfif check_name.recordcount>  
                    <cfset error_code = 14>
                    <cfset error_detail = "Aynı kullanıcı adı veya mail adresi daha önce kaydedilmiştir! Lütfen yeni bir kullanıcı adı veya e-mail Giriniz!">              
                </cfif>
            <cfelseif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang neq 'tr'>
                <cfif check_name.recordcount>
                    <cfset error_code = 14>
                    <cfset error_detail = "Same user name or email address has been used before! Please enter a new user name or email!"> 
                </cfif>
		    <cfelse>
                <cfif check_name.recordcount>  
                    <cfset error_code = 14>
                    <cfset error_detail = "Aynı kullanıcı adı veya mail adresi daha önce kaydedilmiştir! Lütfen yeni bir kullanıcı adı veya e-mail Giriniz!">              
                </cfif>
            </cfif>
            
            <cfif len(error_code)> <!--- Hata Kontrolleri yapılıyor. ---> 
                <cfxml variable="xmldoc" casesensitive="no"><cfoutput> <!--- Eksik veri Girişi Hatası ---> 
                    <Records>
                        <Record>
                            <Result>Error</Result>
                            <ErrorCode>#error_code#</ErrorCode>
                            <ResultDescription>#error_detail#</ResultDescription>
                        </Record>
                    </Records></cfoutput>
                </cfxml>
            <cfelse>
                <cfsavecontent variable="my_company_detail">
                    <cfoutput>
                        FİRMA BİLGİLERİ :
                            Adı : #arguments.fullname#, <br/>
                            Holistic'i Nereden Duydunuz : #arguments.where_did_you_hear# <br/>
                            E mail istiyor : <cfif arguments.is_mail eq 1> Evet <cfelse> Hayır </cfif><br/>
                        ÇALIŞAN BİLGİLERİ : <br/>
                            Ad : #arguments.member_name#, <br/>
                            Soyad : #arguments.member_surname#, <br/>
                            E-Mail : #arguments.email#, <br/>
                            Tel : #arguments.telno# <br/>
                    </cfoutput>
                </cfsavecontent>
                
                <cf_papers paper_type="EMPLOYEE">
                <cfset system_paper_no=paper_code & '-' & paper_number>
                <cfset system_paper_no_add=paper_number>
                <cfset employee_no = system_paper_no> 
                
                <cfquery name="ADD_EMPLOYEES" datasource="#dsn#">
                    INSERT INTO
                        EMPLOYEES
                        (
                            EMPLOYEE_NO,
                            EMPLOYEE_STATUS,
                            EMPLOYEE_NAME,
                            EMPLOYEE_SURNAME,
                            EMPLOYEE_EMAIL,
                            EMPLOYEE_USERNAME,
                            EMPLOYEE_PASSWORD,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP,
                            IS_ACC_INFO,
                            EMPLOYEE_STAGE,
                            MOBILCODE,
                            MOBILTEL
                        )
                        VALUES
                        (
                            '#employee_no#',
                            1,
                            '#arguments.member_name#',
                            '#arguments.member_surname#',
                            '#trim(arguments.email)#',
                            '#employee_username#',
                            '#sifre#',
                            #now()#,
                            1,
                            '#CGI.REMOTE_ADDR#',
                            1,
                            #get_stage_emp.process_row_id#,
                            <cfif len(arguments.telno) eq 11>'#Left(arguments.telno,4)#'<cfelse>'#Left(arguments.telno,3)#'</cfif>,
                            '#Right(arguments.telno,7)#'
                        )
                </cfquery>
                
                <cfquery name="LAST_ID" datasource="#dsn#">
                    SELECT MAX(EMPLOYEE_ID) AS LATEST_RECORD_ID FROM EMPLOYEES
                </cfquery>
                
                <cfquery name="ADD_EMPLOYEES_DETAIL" datasource="#dsn#">
                    INSERT INTO 
                        EMPLOYEES_DETAIL
                        (
                            EMPLOYEE_ID,
                            SEX,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        )
                        VALUES
                        (			
                            #last_id.latest_record_id#,
                            1,
                            #now()#,
                            1,
                            '#CGI.REMOTE_ADDR#'
                        )
                </cfquery>

                <cfquery name="ADD_EMPLOYEES_HISTORY" datasource="#dsn#">
                    INSERT INTO EMPLOYEES_HISTORY
                        (
                            EMPLOYEE_ID
                            ,EMPLOYEE_NAME
                            ,EMPLOYEE_SURNAME
                            ,EMPLOYEE_STATUS
                            ,EMPLOYEE_USERNAME
                            ,MOBILCODE
                            ,MOBILTEL			
                            ,EXPIRY_DATE
                            ,EMPLOYEE_STAGE
                            ,EMPLOYEE_NO
                            ,IS_PASSWORD_CHANGE
                            ,RECORD_DATE
                            ,RECORD_EMP
                            ,RECORD_IP
                        )
                        VALUES
                        (
                            #last_id.latest_record_id#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_surname#">,
                            1,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#employee_username#">,
                            <cfif len(arguments.telno) eq 11>'#Left(arguments.telno,4)#'<cfelse>'#Left(arguments.telno,3)#'</cfif>,
                            '#Right(arguments.telno,7)#',
                            NULL,
                            #get_stage_emp.process_row_id#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#employee_no#">,
                            1,
                            #now()#,
                            NULL,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                        )
                </cfquery>
                
                <cfquery name="ADD_IDENTY" datasource="#dsn#">
                    INSERT INTO
                        EMPLOYEES_IDENTY
                        (
                            EMPLOYEE_ID,
                            RECORD_DATE,
                            RECORD_IP,
                            RECORD_EMP
                        )
                        VALUES
                        (
                            #last_id.latest_record_id#,	
                            #now()#,
                            '#cgi.REMOTE_ADDR#',
                            1
                        )
                </cfquery>
                
                <cfquery name="UPD_MEMBER_CODE" datasource="#dsn#">
                    UPDATE 
                        EMPLOYEES 
                    SET 
                        MEMBER_CODE = 'E#last_id.latest_record_id#'
                    WHERE 
                        EMPLOYEE_ID = #last_id.latest_record_id#
                </cfquery>
                
                <cfquery name="UPD_GEN_PAP" datasource="#dsn#">
                    UPDATE 
                        GENERAL_PAPERS_MAIN
                    SET
                        EMPLOYEE_NUMBER = <cfif len(system_paper_no_add)>#system_paper_no_add#<cfelse>1</cfif>
                    WHERE
                        EMPLOYEE_NUMBER IS NOT NULL
                </cfquery>
                
                <!--- pozisyon aciliyor ---> 
                <cfset new_hie_ = ''>
                <cfquery name="GET_UPPERS" datasource="#dsn#">
                    SELECT 
                        O.HIERARCHY AS HIE1,
                        Z.HIERARCHY AS HIE2,
                        O.HIERARCHY2 AS HIE3,			
                        B.HIERARCHY AS HIE4,
                        D.HIERARCHY AS HIE5
                    FROM
                        DEPARTMENT D,
                        BRANCH B,
                        OUR_COMPANY O,
                        ZONE Z
                    WHERE
                        B.ZONE_ID = Z.ZONE_ID AND
                        D.BRANCH_ID = B.BRANCH_ID AND
                        B.COMPANY_ID = O.COMP_ID AND
                        D.DEPARTMENT_ID = 1 
                </cfquery>
                <cfquery name="GET_POSITION_CAT" datasource="#dsn#">
                    SELECT HIERARCHY FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
                </cfquery>
                <cfquery name="GET_TITLE" datasource="#dsn#">
                    SELECT HIERARCHY,TITLE_ID FROM SETUP_TITLE WHERE TITLE_ID = 1
                </cfquery>
                <cfif get_uppers.recordcount>
                    <cfset new_hie_ = '#get_uppers.hie1#.' & '#get_uppers.hie2#.' & '#get_uppers.hie3#.' & '#get_uppers.hie4#.' & '#get_uppers.hie5#.' & '#get_title.hierarchy#.' & '#get_position_cat.hierarchy#'>
                <cfelse>
                    <cfset new_hie_ = ''>
                </cfif>
                
                <cfquery name="GET_POSITION_NAME" datasource="#dsn#">
                    SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
                </cfquery>
                
                <cfquery name="GET_MAX_POS" datasource="#dsn#">
                    SELECT
                        MAX(POSITION_CODE) AS PCODE
                    FROM
                        EMPLOYEE_POSITIONS
                </cfquery>
                
                <cfif not len(get_max_pos.pcode)>
                    <cfset p=0>
                <cfelse>
                    <cfset p=get_max_pos.pcode>
                </cfif>
                <cfset pcode=evaluate(p + 1)>
                <!--- yeni pozisyonu ekliyor --->
                <cfquery name="ADD_POSITION" datasource="#dsn#">
                    INSERT INTO
                        EMPLOYEE_POSITIONS
                        (
                            POSITION_CODE,
                            POSITION_CAT_ID,
                            POSITION_STATUS,
                            POSITION_STAGE,
                            POSITION_NAME,
                            EMPLOYEE_ID,
                            EMPLOYEE_NAME,
                            EMPLOYEE_SURNAME,
                            EMPLOYEE_EMAIL,
                            DEPARTMENT_ID,
                            EHESAP,
                            TITLE_ID,
                            HIERARCHY,
                            IS_MASTER,
                            PERIOD_ID,
                            USER_GROUP_ID
                        )
                        VALUES
                        (
                            #pcode#,
                            #arguments.position_cat_id#,
                            1,
                            11,
                            '#get_position_name.position_cat#',
                            #last_id.latest_record_id#,
                            '#arguments.member_name#',
                            '#arguments.member_surname#',
                            '#arguments.email#',
                            1,
                            0,
                            1,
                            '#new_hie_#',
                            1,
                            #get_period.period_id#,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#">
                        )
                </cfquery>
                
                <cfquery name="GET_LAST_ID" datasource="#dsn#">
                    SELECT MAX(POSITION_ID) AS POSITION_ID FROM EMPLOYEE_POSITIONS
                </cfquery>
                 <!--- period ekleniyor ---> 
                
                 <cfoutput query="get_periods">
                    <cfquery name="ADD_EMP_PERIODS" datasource="#dsn#">
                        INSERT INTO
                            EMPLOYEE_POSITION_PERIODS
                            (
                                POSITION_ID,
                                PERIOD_ID,
                                PERIOD_DATE,
                                RECORD_EMP,
                                RECORD_DATE,
                                RECORD_IP
                            )
                            VALUES
                            (
                                #get_last_id.position_id#,
                                #get_periods.period_id#,
                                '#year(now())#-01-01',
                                #last_id.latest_record_id#,
                                #now()#,
                                '#cgi.remote_addr#'
                            )
                    </cfquery>
                    
                     <!--- sube ekleniyor ---> 
                    <cfquery name="GET_BRANCHS" datasource="#dsn#">
                        SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID  IN (SELECT OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR = #year(now())#)
                    </cfquery>
                    
                    <cfif get_branchs.recordcount>
                        <cfloop query="get_branchs">
                            <cfquery name="ADD_EMP_BRANCHES" datasource="#dsn#">
                                INSERT INTO
                                    EMPLOYEE_POSITION_BRANCHES
                                    (
                                        POSITION_CODE,
                                        BRANCH_ID,
                                        RECORD_EMP,
                                        RECORD_DATE,
                                        RECORD_IP
                                    )
                                    VALUES
                                    (
                                        #pcode#,
                                        #get_branchs.branch_id#,
                                        #last_id.latest_record_id#,
                                        #now()#,
                                        '#cgi.remote_addr#'
                                    )
                            </cfquery>
                        </cfloop>
                    </cfif>
                </cfoutput>
                <cfquery name="add_user_group_emp" datasource="#dsn#">
                     INSERT INTO
                        user_group_employee
                        (
                            EMPLOYEE_ID,
                            POSITION_ID,
                            USER_GROUP_ID
                        )
                        VALUES
                        (
                            #last_id.latest_record_id#,
                            #get_last_id.position_id#,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#">
                        )
                </cfquery>
                <cfquery name="GET_POS" datasource="#dsn#">
                    SELECT
                        LEVEL_ID,
                        USER_GROUP_ID,
                        EMPLOYEE_ID
                    FROM
                        EMPLOYEE_POSITIONS
                    WHERE
                        POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_last_id.position_id#">
                </cfquery>
        
                <cfif get_pos.employee_id eq last_id.latest_record_id>
                    <cfquery name="UPD_POSITION" datasource="#dsn#">
                        UPDATE
                            EMPLOYEE_POSITIONS
                        SET
                            LEVEL_ID = NULL,
                            UPDATE_EMP = #last_id.latest_record_id#,
                            UPDATE_DATE = #now()#,
                            UPDATE_IP = '#cgi.remote_addr#',
                            COST_DISPLAY_VALID = 0
                        WHERE
                            POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_last_id.position_id#">
                    </cfquery>
                </cfif> 
            <!--- calisan ayarlari ---> 
            <cfset new_color = 1>
            <cfquery name="ADD_TIME_ZONE" datasource="#dsn#">
                INSERT INTO
                    MY_SETTINGS
                    (
                        EMPLOYEE_ID,
                        LANGUAGE_ID,
                        INTERFACE_ID,
                        INTERFACE_COLOR,
                        TIME_ZONE,
                        MAXROWS,
                        TIMEOUT_LIMIT,
                        OZEL_MENU_ID,
                        DAY_AGENDA,
                        MAIN_NEWS,
                        AGENDA,
                        POLL_NOW,
                        MYWORKS,
                        MY_VALIDS,
                        MY_SELLERS,
                        IS_KURAL_POPUP,
                        MARKETS,
                        ANNOUNCEMENT,
                        NOTES,
                        IS_BIRTHDATE,
                        ATTENDING_WORKERS,
                        PROMO_HEAD,
                        PAY,
                        CLAIM,
                        PAY_CLAIM,
                        ORDERS_GIVE,
                        HR,
                        CAMPAIGN_NOW
                    )
                VALUES
                    (
                        #last_id.latest_record_id#,
                        <cfqueryparam value = "#arguments.lang#" cfsqltype = "cf_sql_nvarchar">,
                        <cfqueryparam value = "#arguments.interface_id#" cfsqltype = "cf_sql_integer">,
                        #new_color#,
                        2,
                        20,
                        30,
                        0,
                        1,
                        1,
                        1,
                        1,
                        1,
                        1,
                        1,
                        0,
                        0,
                        1,
                        1,
                        1,
                        1,
                        1,
                        1,
                        1,
                        1,
                        1,
                        1,
                        1
                    )
            </cfquery> 
            
            <cfset columnLeftList = "homebox_pay_claim,homebox_video,homebox_announcement,homebox_notes,homebox_poll_now">
            <cfset columnCenterList = "homebox_main_news,homebox_myworks,homebox_correspondence,homebox_internaldemand,homebox_career,homebox_pot_cons,homebox_pot_partner,homebox_hr,homebox_finished_test_times,homebox_finished_contract,homebox_orders_come,homebox_offer_given,homebox_sell_today,homebox_promo_head,homebox_most_sell_stock,homebox_offer_to_give,homebox_new_stocks,homebox_orders_give,homebox_offer_taken,homebox_come_again_sip,homebox_purchase_today,homebox_more_stocks,homebox_send_order,homebox_offer_to_take,homebox_new_product,homebox_campaign_now,homebox_pre_invoice,homebox_service_head,homebox_call_center_application,homebox_call_center_interaction,homebox_spare_part,homebox_product_orders,homebox_pay,homebox_now_claim,homebox_old_contracts,homebox_forum,homebox_employee_profile,homebox_branch_profile">
            <cfset columnRightList = "homebox_day_agenda,homebox_hr_agenda,homebox_hr_in_out,homebox_birthdate,homebox_attending_workers,homebox_employee_permittion,homebox_markets,homebox_is_permittion,homebox_widget,homebox_social_media">
            
            <cfset openPanels = ListToArray("homebox_main_news")>
            
            <cfset panels = ArrayNew(2)>
            
            <cfset panels[1] = ArrayNew(1)>
            <cfset panels[1] = ListToArray(columnLeftList)>
            
            <cfset panels[2] = ArrayNew(1)>
            <cfset panels[2] = ListToArray(columnCenterList)>
            
            <cfset panels[3] = ArrayNew(1)>
            <cfset panels[3] = ListToArray(columnRightList)>
            
            <cfquery name="FIRST_VIEW_OF_PANEL" datasource="#dsn#">
                SELECT 
                    PANEL_NAME, 
                    COLUMN_INDEX, 
                    SEQUENCE_INDEX, 
                    EMP_ID, 
                    IS_WIDGET, 
                    URL, 
                    IS_CLOSE 
                FROM 
                    MY_SETTINGS_POSITIONS 
                WHERE 
                    EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#last_id.latest_record_id#"> 
                AND 
                    (IS_WIDGET=0 OR IS_WIDGET=NULL)
            </cfquery>
            
            <cfif first_view_of_panel.recordcount eq 0>
                <cfquery datasource="#dsn#">
                    <cfloop index="columnPosition" from="1" to="#ArrayLen(panels)#">		
                        <cfloop index="sequencePosition" from="1" to="#ArrayLen(panels[columnPosition])#">
                            <cfset sequencePositionIndex = sequencePosition - 1>
                            <cfset isColose = 0>
                            <cfif columnPosition eq 2>
                                <cfset isColose =1>
                            </cfif>
                            
                            <!--- Eğer Açık Paneller Arasındaysa ---> 
                            <cfset isOpen = false>
                            <cfloop index="panel" from="1" to="#ArrayLen(openPanels)#">
                                <cfif panels[columnPosition][sequencePosition] is "homebox_main_news">
                                    <cfset isOpen = true>
                                    <cfbreak>
                                </cfif>
                            </cfloop>
                                INSERT INTO MY_SETTINGS_POSITIONS 
                                    (PANEL_NAME,COLUMN_INDEX,SEQUENCE_INDEX,EMP_ID,IS_CLOSE) 
                                VALUES
                                    ('#panels[columnPosition][sequencePosition]#',#columnPosition#,#sequencePositionIndex#,#last_id.latest_record_id#,<cfif isOpen>0<cfelse>#isColose#</cfif>)
                        </cfloop>	
                    </cfloop>
                </cfquery>
            </cfif>
            
            <cfif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang eq 'tr'>
                <cfsavecontent variable="message">W3 Holistic Live Demo Kayıt</cfsavecontent>
            <cfelseif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang neq 'tr'>
                <cfsavecontent variable="message">Your Workcube Holistic Demo Account Login Details</cfsavecontent>
            </cfif>
            <cfif arguments.is_mail eq 1> <!--- Kullanıcı mail bildirimi istiyorsa ---> 
                <!--- workcube kullanıcı hakkında mail atar --->
                <cfmail  
                    to = "#arguments.email#"
                    from = "Workcube E-İş Sistemleri<workcube@workcube.com>"
                    subject = "#message#"
                    type="HTML"> 
                    <style type="text/css">
                        body {
                            padding: 0;
                            margin: 0;
                        }
                        
                        html { -webkit-text-size-adjust:none; -ms-text-size-adjust: none;}
                        @media only screen and (max-device-width: 680px), only screen and (max-width: 680px) { 
                            *[class="table_width_100"] {
                                width: 96% !important;
                            }
                            *[class="border-right_mob"] {
                                border-right: 1px solid ##dddddd;
                            }
                            *[class="mob_100"] {
                                width: 100% !important;
                            }
                            *[class="mob_center"] {
                                text-align: center !important;
                            }
                            *[class="mob_center_bl"] {
                                float: none !important;
                                display: block !important;
                                margin: 0px auto;
                            }	
                            .iage_footer a {
                                text-decoration: none;
                                color: ##929ca8;
                            }
                            img.mob_display_none {
                                width: 0px !important;
                                height: 0px !important;
                                display: none !important;
                            }
                            img.mob_width_50 {
                                width: 40% !important;
                                height: auto !important;
                            }
                        }
                        .table_width_100 {
                            width: 680px;
                        }
                    </style>
                    
                    <div id="mailsub" class="notification" align="center">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="min-width: 320px;"><tr><td align="center">
                        <tr><td>

                        <table border="0" cellspacing="0" cellpadding="0" class="table_width_100" width="100%" style="max-width: 680px; min-width: 300px;">
                            <tr><td>
                            <!-- padding --><div style="height: 80px; line-height: 80px; font-size: 10px;"></div>
                            </td></tr>
                            <!--header -->
                            <tr><td align="center">
                                <!-- padding --><div style="height: 30px; line-height: 30px; font-size: 10px;"></div>
                                <table width="90%" border="0" cellspacing="0" cellpadding="0">
                                    <tr><td align="left"><!-- 
                        
                                        Item --><div class="mob_center_bl" style="float: left; display: inline-block; width: 115px;">
                                            <table class="mob_center" width="115" border="0" cellspacing="0" cellpadding="0" align="left" style="border-collapse: collapse;">
                                                <tr><td align="left" valign="middle">
                                                    <!-- padding --><div style="height: 20px; line-height: 20px; font-size: 10px;"></div>
                                                    <table width="115" border="0" cellspacing="0" cellpadding="0" >
                                                        <tr><td align="left" valign="top" class="mob_center">
                                                            <a href="https://www.workcube.com/" target="_blank"  style="color: ##596167; font-family: Arial, Helvetica, sans-serif; font-size: 13px;">
                                                            <font face="Arial, Helvetica, sans-seri; font-size: 13px;" size="3" color="##596167">
                                                                <cfif default_menu eq 1>
                                                                    <img src="https://www.workcube.com/assets/img/workcube-logo.png" width="90" height="74" alt="WORKCUBE" border="0" style="display: block;" />
                                                                <cfelseif default_menu eq 2>
                                                                    <img src="https://www.workcube.com/assets/img/watom.png" width="256" height="62" alt="WORKCUBE" border="0" style="display: block;" />
                                                                <cfelse>
                                                            </font></a>
                                                        </td></tr>
                                                    </table>						
                                                </td></tr>
                                            </table></div><!-- Item END--><!--[if gte mso 10]>
                                            </td>
                                            <td align="right">
                                        <![endif]--><!-- 
                        
                                        Item --><div class="mob_center_bl" style="float: right; display: inline-block; width: 276px;">
                                            <table width="276" border="0" cellspacing="0" cellpadding="0" align="right" style="border-collapse: collapse;">
                                                <tr><td align="right" valign="middle">
                                                    <!-- padding --><div style="height: 20px; line-height: 20px; font-size: 10px;"></div>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                                                        <tr><td align="right">
                                                            <!--social -->
                                                        
                                                            <!--social END-->
                                                        </td></tr>
                                                    </table>
                                                </td></tr>
                                            </table></div><!-- Item END--></td>
                                    </tr>
                                </table>
                                <!-- padding --><div style="height: 50px; line-height: 50px; font-size: 10px;"></div>
                            </td></tr>
                            <!--header END-->
                            <!--content 1 -->
                            <tr><td align="center">
                                <table width="90%" border="0" cellspacing="0" cellpadding="0">
                                    <tr><td align="center">
                                        <!-- padding --><div style="height: 10px; line-height: 10px; font-size: 10px;"></div>
                                        <div style="line-height: 44px;">
                                            <font face="Arial, Helvetica, sans-serif" size="5" color="##57697e" style="font-size: 34px;">
                                            <span style="font-family: Arial, Helvetica, sans-serif; font-size: 34px; color: ##57697e;">
                                                
                                            </span></font>
                                        </div>
                                        <!-- padding --><div style="height: 40px; line-height: 40px; font-size: 10px;"></div>
                                    </td></tr>
                                    <tr><td align="left">
                                        <div style="line-height: 24px;">
                                        <cfif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang eq 'tr'>
                                            <font face="Arial, Helvetica, sans-serif" size="4" color="##57697e" style="font-size: 12px;">
                                                <span style="font-family: Arial, Helvetica, sans-serif; font-size: 15px; color: ##57697e;">
                                                    Sayın #arguments.member_name# #arguments.member_surname#;<br><br>
                                                    <cfif default_menu eq 1>
                                                        Holistic'e gösterdiğiniz ilgi için teşekkür ederiz.<br><br>
                                                        Holistic'i canlı olarak inceleyebilmeniz için <a href="https://holistic.workcube.com">holistic.workcube.com</a> adresinden aşağıdaki kullanıcı adı ve şifre bilgileriniz ile giriş yapabilirsiniz.<br><br>
                                                    <cfelseif default_menu eq 2>
                                                        Watom'a gösterdiğiniz ilgi için teşekkür ederiz.<br><br>
                                                        Watom'u canlı olarak inceleyebilmeniz için <a href="https://watom.workcube.com">watom.workcube.com</a> adresinden aşağıdaki kullanıcı adı ve şifre bilgileriniz ile giriş yapabilirsiniz.<br><br>
                                                    </cfif>
                                                    <strong>Kullanıcı Bilgileri;</strong><br>
                                                    <strong>Kullanıcı Adı :</strong>#arguments.employee_username#<br>
                                                    <strong>Şifre :</strong>#arguments.employee_password#<br><br>
                                                    <cfif default_menu eq 1>
                                                        Holistic hakkında daha detaylı bilgi sahibi olmak için <a href="https://www.workcube.com">www.workcube.com</a> sitesini ziyaret edebilirsiniz.<br>
                                                    <cfelseif default_menu eq 2>
                                                        Watom hakkında daha detaylı bilgi sahibi olmak için <a href="https://www.workcube.com">www.workcube.com</a> sitesini ziyaret edebilirsiniz.<br>
                                                    </cfif>
                                                    Her türlü soru, görüş ve önerilerinizi <a href="mailto:workcube@workcube.com">workcube@workcube.com</a> veya 0850 4412323 no'lu telefondan satış ekibimize iletebilirsiniz.<br><br>
                                                    <strong>Saygılarımızla</strong>
                                                </span>
                                            </font>
                                        <cfelseif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang neq 'tr'>
                                            <font face="Arial, Helvetica, sans-serif" size="4" color="##57697e" style="font-size: 12px;">
                                                <span style="font-family: Arial, Helvetica, sans-serif; font-size: 15px; color: ##57697e;">
                                                Hello #arguments.member_name# #arguments.member_surname#;<br><br>
                                                <cfif default_menu eq 1>
                                                    Thank you for registering at Workcube Holistic Demo Site.<br><br>
                                                    To start exploring Workcube Holistic all you need to do is to click the link below and login with your user name and password.<br>
                                                <cfelseif default_menu eq 2>
                                                    Thank you for registering at Workcube Watom Demo Site.<br><br>
                                                    To start exploring Workcube Watom all you need to do is to click the link below and login with your user name and password.<br>
                                                </cfif>
                                                <cfif default_menu eq 1>
                                                    <a href="https://holistic.workcube.com/?lang=en">holistic.workcube.com</a><br><br>
                                                <cfelseif default_menu eq 2>
                                                    <a href="https://watom.workcube.com">watom.workcube.com</a>
                                                </cfif>
                                                <strong>Username</strong> : #arguments.employee_username#<br>
                                                <strong>Password</strong> : #arguments.employee_password#<br><br>
                                                Please visit <a href="https://www.workcube.com">www.workcube.com</a> to learn more about Workcube Holistic.<br>
                                                You can forward any question, comment and suggestion to our team by sending an email to workcube@workcube.com.<br><br>
                                                <strong>Best Regards​</strong>
                                                </span>
                                            </font>
                                        </cfif>
                                        </div>
                                        <!-- padding --><div style="height: 40px; line-height: 40px; font-size: 10px;"></div>
                                    </td></tr>
                                    <tr><td align="center">
                                        <div style="line-height: 24px;">
                                            <cfif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang eq 'tr'>
                                                <cfif default_menu eq 1>
                                                    <a href="https://holistic.workcube.com" target="_blank" style="color: ##596167; font-family: Arial, Helvetica, sans-serif; font-size: 13px;  text-decoration: none;">
                                                <cfelseif default_menu eq 2>
                                                    <a href="https://watom.workcube.com" target="_blank" style="color: ##596167; font-family: Arial, Helvetica, sans-serif; font-size: 13px;  text-decoration: none;">
                                                </cfif>
                                            <cfelseif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang neq 'tr'>
                                                <cfif default_menu eq 1>
                                                    <a href="https://holistic.workcube.com/?lang=en" target="_blank" style="color: ##596167; font-family: Arial, Helvetica, sans-serif; font-size: 13px;  text-decoration: none;">
                                                <cfelseif default_menu eq 2>
                                                    <a href="https://watom.workcube.com/?lang=en" target="_blank" style="color: ##596167; font-family: Arial, Helvetica, sans-serif; font-size: 13px;  text-decoration: none;">
                                                </cfif>
                                            </cfif>
                                                <font face="Arial, Helvetica, sans-seri; font-size: 13px;" size="3" color="##596167; text-decoration: none;">
                                                    <span style="background-color: ##FF6B57; width: 193px; line-height: 43px; display: block; text-align: center; border-radius: 4px; color: white; font-weight: 700;" alt="WORKCUBE">DEMO</span>
                                                </font>
                                            </a>
                                        </div>
                                        <!-- padding --><div style="height: 60px; line-height: 60px; font-size: 10px;"></div>
                                    </td></tr>
                                </table>		
                            </td></tr>
                            <!--content 1 END-->
                            <!--brands -->
                            <cfif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang eq 'tr'>
                                <tr><td align="center" bgcolor="##ffffff" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: ##eff2f4;">
                                    <table width="94%" border="0" cellspacing="0" cellpadding="0">
                                        <tr><td align="center" style="padding-top: 30px;">
                                        <font face="Arial, Helvetica, sans-serif" size="3" color="##96a5b5" style="font-size: 13px;">
                                            <div class="mob_100" style="float: left; display: inline-block; width: 33%; margin-bottom: 7px;">
                                            Tel:&nbsp;&nbsp;(0850) - 441&nbsp;2323
                                            </div>
                            
                                            <div class="mob_100" style="float: left; display: inline-block; width: 34%; margin-bottom: 7px;">
                                            Mail:&nbsp;&nbsp;workcube@workcube.com
                                            </div>
                                            
                                        </font>
                                        </td></tr>
                                        <tr><td><!-- padding --><div style="height: 28px; line-height: 28px; font-size: 10px;"></div></td></tr>
                                    </table>		
                                </td></tr>
                            </cfif>
                            <!--brands END-->
                            <!--footer -->
                            <tr><td class="iage_footer" align="center" bgcolor="##ffffff">
                                <div style="height: 50px; line-height: 50px; font-size: 10px;">  
                        
                                </div>	
                                
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                    <td align="center">
                                        <font face="Arial, Helvetica, sans-serif" size="3" color="##96a5b5" style="font-size: 13px;">
                                        <span style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; color: ##96a5b5;">
                                            <cfif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang eq 'tr'>
                                                Workcube E-İş Sistemleri San. Ve Tic. A.Ş. © 2022
                                            <cfelseif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang neq 'tr'>
                                                Workcube Inc. © 2022
                                            </cfif>
                                        </span></font>				
                                        </td>
                                    </tr>	
                                </table>
                                <!-- padding --><div style="height: 30px; line-height: 30px; font-size: 10px;"></div>	
                            </td></tr>
                            <!--footer END-->
                            <tr><td>
                            <!-- padding --><div style="height: 80px; line-height: 80px; font-size: 10px;"></div>
                            </td></tr>
                        </table>
                        
                        </td></tr>
                        </table>     
                    </div> 
               </cfmail>
                <!--- workcube kullanıcı hakkında mail atar --->
            </cfif> 
            
             <!--- workcube kullanıcı hakkında mail atar --->
             <cfmail  
                to = "satiyeketenci@workcube.com,ozlemacikel@workcube.com,omerturhan@workcube.com"
                from = "Workcube E-İş Sistemleri<workcube@workcube.com>"
                subject = "W3 Holistic Live Demo Kayıt"
                type="HTML"> 
                                       
                    
                    <style type="text/css">
                    body {
                        padding: 0;
                        margin: 0;
                    }
                    
                    html { -webkit-text-size-adjust:none; -ms-text-size-adjust: none;}
                    @media only screen and (max-device-width: 680px), only screen and (max-width: 680px) { 
                        *[class="table_width_100"] {
                            width: 96% !important;
                        }
                        *[class="border-right_mob"] {
                            border-right: 1px solid ##dddddd;
                        }
                        *[class="mob_100"] {
                            width: 100% !important;
                        }
                        *[class="mob_center"] {
                            text-align: center !important;
                        }
                        *[class="mob_center_bl"] {
                            float: none !important;
                            display: block !important;
                            margin: 0px auto;
                        }	
                        .iage_footer a {
                            text-decoration: none;
                            color: ##929ca8;
                        }
                        img.mob_display_none {
                            width: 0px !important;
                            height: 0px !important;
                            display: none !important;
                        }
                        img.mob_width_50 {
                            width: 40% !important;
                            height: auto !important;
                        }
                    }
                    .table_width_100 {
                        width: 680px;
                    }
                    </style>
                    
                    
                    <div id="mailsub" class="notification" align="center">
                    
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="min-width: 320px;"><tr><td align="center" bgcolor="##eff3f8">
                    <tr><td>
                    
                    <table border="0" cellspacing="0" cellpadding="0" class="table_width_100" width="100%" style="max-width: 680px; min-width: 300px;">
                        <tr><td>
                        <!-- padding --><div style="height: 80px; line-height: 80px; font-size: 10px;"></div>
                        </td></tr>
                        <!--header -->
                        <tr><td align="center" bgcolor="##2979ff">
                            <!-- padding --><div style="height: 30px; line-height: 30px; font-size: 10px;"></div>
                            <table width="90%" border="0" cellspacing="0" cellpadding="0">
                                <tr><td align="left"><!-- 
                    
                                    Item --><div class="mob_center_bl" style="float: left; display: inline-block; width: 115px;">
                                        <table class="mob_center" width="115" border="0" cellspacing="0" cellpadding="0" align="left" style="border-collapse: collapse;">
                                            <tr><td align="left" valign="middle">
                                                <!-- padding --><div style="height: 20px; line-height: 20px; font-size: 10px;"></div>
                                                <table width="115" border="0" cellspacing="0" cellpadding="0" >
                                                    <tr><td align="left" valign="top" class="mob_center">
                                                        <a href="http://www.workcube.com/" target="_blank"  style="color: ##596167; font-family: Arial, Helvetica, sans-serif; font-size: 13px;">
                                                        <font face="Arial, Helvetica, sans-seri; font-size: 13px;" size="3" color="##596167">
                                                        <img src="http://www.workcube.com/wp-content/themes/workcube-catalyst/img/logo.png" width="115" height="19" alt="WORKCUBE" border="0" style="display: block;" />
                                                        </font></a>
                                                    </td></tr>
                                                </table>						
                                            </td></tr>
                                        </table></div><!-- Item END--><!--[if gte mso 10]>
                                        </td>
                                        <td align="right">
                                    <![endif]--><!-- 
                    
                                    Item --><div class="mob_center_bl" style="float: right; display: inline-block; width: 276px;">
                                        <table width="276" border="0" cellspacing="0" cellpadding="0" align="right" style="border-collapse: collapse;">
                                            <tr><td align="right" valign="middle">
                                                <!-- padding --><div style="height: 20px; line-height: 20px; font-size: 10px;"></div>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                                                    <tr><td align="right">
                                                        <!--social -->
                                                       
                                                        <!--social END-->
                                                    </td></tr>
                                                </table>
                                            </td></tr>
                                        </table></div><!-- Item END--></td>
                                </tr>
                            </table>
                            <!-- padding --><div style="height: 50px; line-height: 50px; font-size: 10px;"></div>
                        </td></tr>
                        <!--header END-->
                        <!--content 1 -->
                        <tr><td align="center" bgcolor="##fbfcfd">
                            <table width="90%" border="0" cellspacing="0" cellpadding="0">
                                <tr><td align="center">
                                    <!-- padding --><div style="height: 10px; line-height: 10px; font-size: 10px;"></div>
                                    <div style="line-height: 44px;">
                                        <font face="Arial, Helvetica, sans-serif" size="5" color="##57697e" style="font-size: 34px;">
                                        <span style="font-family: Arial, Helvetica, sans-serif; font-size: 34px; color: ##57697e;">
                                            
                                        </span></font>
                                    </div>
                                    <!-- padding --><div style="height: 40px; line-height: 40px; font-size: 10px;"></div>
                                </td></tr>
                                <tr><td align="left">
                                    <div style="line-height: 24px;">
                                        <font face="Arial, Helvetica, sans-serif" size="4" color="##57697e" style="font-size: 12px;">
                                        <span style="font-family: Arial, Helvetica, sans-serif; font-size: 15px; color: ##57697e;">
                                            <cfoutput>#my_company_detail#</cfoutput>
                                        </span></font>
                                    </div>
                                    <!-- padding --><div style="height: 40px; line-height: 40px; font-size: 10px;"></div>
                                </td></tr>
                            </table>		
                        </td></tr>
                        <!--content 1 END-->
                        <!--brands -->
                        <tr><td align="center" bgcolor="##ffffff" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: ##eff2f4;">
                            <table width="94%" border="0" cellspacing="0" cellpadding="0">
                                <tr><td align="center" style="padding-top: 30px;">
                                <font face="Arial, Helvetica, sans-serif" size="3" color="##96a5b5" style="font-size: 13px;">
                                    <div class="mob_100" style="float: left; display: inline-block; width: 33%; margin-bottom: 7px;">
                                    Tel:&nbsp;&nbsp;(850) - 441&nbsp;2323
                                    </div>
                    
                                 
                                    <div class="mob_100" style="float: left; display: inline-block; width: 34%; margin-bottom: 7px;">
                                    Mail:&nbsp;&nbsp;workcube@workcube.com
                                    </div>
                    
                                    <div class="mob_100" style="float: left; display: inline-block; width: 100%;">
                                    Adres:&nbsp;&nbsp;Katip Salih Sokak. No: 2, 34718 Koşuyolu - İstanbul 
                                    </div>
                                </font>
                                </td></tr>
                                <tr><td><!-- padding --><div style="height: 28px; line-height: 28px; font-size: 10px;"></div></td></tr>
                            </table>		
                        </td></tr>
                        <!--brands END-->
                        <!--footer -->
                        <tr><td class="iage_footer" align="center" bgcolor="##ffffff">
                            <div style="height: 50px; line-height: 50px; font-size: 10px;">  
                    
                            </div>	
                            
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td align="center">
                                    <font face="Arial, Helvetica, sans-serif" size="3" color="##96a5b5" style="font-size: 13px;">
                                    <span style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; color: ##96a5b5;">
                                        <cfif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang eq 'tr'>                                    
                                            Workcube Topluluğu
                                        <cfelseif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang neq 'tr'>
                                            Workcube Community
                                        </cfif>
                                    </span></font>				
                                </td></tr>	
                                 <tr>
                                <td align="center" valign="middle" style="font-size: 12px; line-height: 22px; padding-top: 10px;">
                                    <font face="Tahoma, Arial, Helvetica, sans-serif" size="2" color="##282f37" style="font-size: 12px; ">
                                    <span style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: ##5b9bd1;">
                                          <a href="http://www.workcube.com/urunler/" target="_blank" style="color: ##5b9bd1; text-decoration: none;">Ürünler</a>
                                          |
                                          <a href="http://www.workcube.com/sektorler/" target="_blank" style="color: ##5b9bd1; text-decoration: none;">Sektörler</a>
                                          |
                                          <a href="http://www.workcube.com/hizmetler/" target="_blank" style="color: ##5b9bd1; text-decoration: none;">Hizmetler</a>
                                          |
                                          <a href="http://www.workcube.com/referanslar/" target="_blank" style="color: ##5b9bd1; text-decoration: none;">Referanslar</a>
                                          |
                                          <a href="http://www.workcube.com/is-ortakligi/" target="_blank" style="color: ##5b9bd1; text-decoration: none;">İş Ortaklığı</a>
                                          |
                                          <a href="http://www.workcube.com/hakkimizda/" target="_blank" style="color: ##5b9bd1; text-decoration: none;">Hakkımızda</a>
                                          |
                                          <a href="http://www.workcube.com/blog/" target="_blank" style="color: ##5b9bd1; text-decoration: none;">Blog</a>
                                  </span></font>
                                </td>
                              </tr> 		
                            </table>
                            
                            <!-- padding --><div style="height: 30px; line-height: 30px; font-size: 10px;"></div>	
                        </td></tr>
                        <!--footer END-->
                        <tr><td>
                        <!-- padding --><div style="height: 80px; line-height: 80px; font-size: 10px;"></div>
                        </td></tr>
                    </table>
                    
                    </td></tr>
                    </table>
                                
                    </div> 
               </cfmail>
             <!--- workcube kullanıcı hakkında mail atar --->
            
            <cfxml variable="xmldoc" casesensitive="no">
                <cfif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang eq 'tr'>
                    <Records>
                        <Record>
                            <Result>Success</Result>
                            <ErrorCode>0</ErrorCode>
                            <ResultDescription>Demo kullanıcı hesabı başarı ile oluşturuldu! Kullanıcı adı ve şifrenizle giriş yapabilirsiniz!</ResultDescription>
                        </Record>
                    </Records>
                <cfelseif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang neq 'tr'>
                    <Records>
                        <Record>
                            <Result>Success</Result>
                            <ErrorCode>0</ErrorCode>
                            <ResultDescription>Demo user account has been created successfully! You can login with your username and password!</ResultDescription>
                        </Record>
                    </Records>
                </cfif>
            </cfxml>
        </cfif>
             <cfcatch>
                <cfdump var="#cfcatch#">
                    <cfif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang eq 'tr'>
                        <cfxml variable="xmldoc" casesensitive="no">
                            <Records>
                                <Record>
                                    <Result>Error</Result>
                                    <ErrorCode>1</ErrorCode>
                                    <ResultDescription>Oppps bir hata oluştu!'</ResultDescription>
                                </Record>
                            </Records>
                        </cfxml>
                    <cfelseif isdefined('arguments.lang') and len(arguments.lang) and arguments.lang neq 'tr'>
                        <cfxml variable="xmldoc" casesensitive="no">
                            <Records>
                                <Record>
                                    <Result>Error</Result>
                                    <ErrorCode>1</ErrorCode>
                                    <ResultDescription>Opps something went wrong!</ResultDescription>
                                </Record>
                            </Records>
                        </cfxml>
                    </cfif>
                    
                        <cfmail from="bugmail@workcube.com" to="workcube@workcube.com,pinaryildiz@workcube.com" subject="w3 demo hata">
                            <cfdump var="#cfcatch#">
                        </cfmail>
                    
                
             </cfcatch>
         
         </cftry>
	<cfreturn xmldoc>    
	</cffunction>
    <!--- w3 demo kayıt --->
    
</cfcomponent>