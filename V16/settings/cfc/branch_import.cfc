<!--- Şube Aktarım
settings.branch_import --->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder />
    <cfset file_web_path = application.systemParam.systemParam().file_web_path />
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator />
    <cfset request.self = application.systemParam.systemParam().request.self />
    <cfset filterNum = CreateObject("component","WMO.functions").filterNum>
    <cfset wrk_round = CreateObject("component","WMO.functions").wrk_round>
    <cffunction name="add_branch" access="remote">
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
                <cfset branch_full_name = trim(listgetat(dosya[i],1,';'))>
                <cfset branch_name = trim(listgetat(dosya[i],2,';'))>
                <cfset admin_1 = trim(listgetat(dosya[i],3,';'))>
                <cfset admin_2 = trim(listgetat(dosya[i],4,';'))>
                <cfset hierarchy_1 = trim(listgetat(dosya[i],5,';'))>
                <cfset hierarchy_2 = trim(listgetat(dosya[i],6,';'))>
                <cfset country = trim(listgetat(dosya[i],7,';'))>
                <cfset city = trim(listgetat(dosya[i],8,';'))>
                <cfset county = trim(listgetat(dosya[i],9,';'))>
                <cfset zip_code = trim(listgetat(dosya[i],10,';'))>
                <cfset related_company = trim(listgetat(dosya[i],11,';'))>
                <cfset special_code = trim(listgetat(dosya[i],12,';'))>
                <cfset related_branch_id = trim(listgetat(dosya[i],13,';'))>
                <cfset company_id = trim(listgetat(dosya[i],14,';'))>
                <cfset tel_code = trim(listgetat(dosya[i],15,';'))>
                <cfset tel_1 = trim(listgetat(dosya[i],16,';'))>
                <cfset tel_2 = trim(listgetat(dosya[i],17,';'))>
                <cfset tel_3 = trim(listgetat(dosya[i],18,';'))>
                <cfset fax = trim(listgetat(dosya[i],19,';'))>
                <cfset e_posta = trim(listgetat(dosya[i],20,';'))>
                <cfset tax_office = trim(listgetat(dosya[i],21,';'))>
                <cfset tax_no = trim(listgetat(dosya[i],22,';'))>
                <cfset address = trim(listgetat(dosya[i],23,';'))>
                <cfset branch_cat_id = trim(listgetat(dosya[i],24,';'))>
                <cfset is_production = trim(listgetat(dosya[i],25,';'))>
                <cfset is_organization = trim(listgetat(dosya[i],26,';'))>
                <cfset zone_id = trim(listgetat(dosya[i],27,';'))>
                <cfset CAL_BOL_MUD_NAME = trim(listgetat(dosya[i],28,';'))>
                <cfset real_work = trim(listgetat(dosya[i],29,';'))>
                <cfset branch_work = trim(listgetat(dosya[i],30,';'))>
                <cfset danger_degree_no = trim(listgetat(dosya[i],31,';'))>
                <cfset is_sakat_kontrol = trim(listgetat(dosya[i],32,';'))>
                
                <cfif (listlen(dosya[i],';') gte 33)>
                    <cfset file_no = trim(listgetat(dosya[i],33,';'))>
                <cfelse>
                    <cfset file_no = ''>
                </cfif>
                <cfif not len(branch_full_name)>
                    <cfoutput>#i#. <cf_get_lang dictionary_id='65013.satırda Şube Adı alanını kontrol ediniz.'></cfoutput><br />
                    <cfset error_flag = 1>
                </cfif>
                <cfif  not len(branch_name)>
                    <cfoutput>#i#. <cf_get_lang dictionary_id='65014.satırda Şube Kısa Adı alanını kontrol ediniz.'></cfoutput><br />
                    <cfset error_flag = 1>
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
                            <cfquery name="ADD_BRANCH" datasource="#DSN#" result="MAX_ID">
                                INSERT INTO
                                    BRANCH 
                                ( 
                                    BRANCH_STATUS,
                                    BRANCH_FULLNAME,
                                    BRANCH_NAME, 
                                    IS_ORGANIZATION,
                                    IS_PRODUCTION,
                                    ZONE_ID, 
                                    ADMIN1_POSITION_CODE,
                                    ADMIN2_POSITION_CODE,
                                    BRANCH_EMAIL,
                                    BRANCH_TELCODE, 
                                    BRANCH_TEL1,
                                    BRANCH_TEL2, 
                                    BRANCH_TEL3,
                                    BRANCH_FAX, 
                                    BRANCH_ADDRESS, 
                                    BRANCH_POSTCODE, 
                                    BRANCH_COUNTY, 
                                    BRANCH_CITY,
                                    BRANCH_COUNTRY,
                                    BRANCH_TAX_OFFICE,
                                    BRANCH_TAX_NO,
                                    HIERARCHY,
                                    HIERARCHY2,
                                    COMPANY_ID,
                                    RELATED_COMPANY,
                                    RELATED_BRANCH_ID,
                                    BRANCH_CAT_ID,
                                    OZEL_KOD,				
                                    RECORD_EMP,
                                    RECORD_DATE,
                                    RECORD_IP,
                                    CAL_BOL_MUD_NAME,
                                    REAL_WORK,
                                    BRANCH_WORK,
                                    DANGER_DEGREE_NO,
                                    IS_SAKAT_KONTROL,
                                    FILE_NO
                                )       
                                VALUES
                                (
                                    1,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_full_name#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_name#">,
                                    <cfif len(is_organization)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_organization#"><cfelse>NULL</cfif>,
                                    <cfif len(is_production)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_production#"><cfelse>NULL</cfif>,
                                    <cfif len(zone_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#zone_id#"><cfelse>NULL</cfif>,
                                    <cfif len(admin_1)><cfqueryparam cfsqltype="cf_sql_integer" value="#admin_1#" ><cfelse>NULL</cfif>,
                                    <cfif len(admin_2)><cfqueryparam cfsqltype="cf_sql_integer" value="#admin_2#"><cfelse>NULL</cfif>,
                                    <cfif len(e_posta)><cfqueryparam cfsqltype="cf_sql_varchar" value="#e_posta#"><cfelse>NULL</cfif>,
                                    <cfif len(tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tel_code#"><cfelse>NULL</cfif>,
                                    <cfif len(tel_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tel_1#"><cfelse>NULL</cfif>,
                                    <cfif len(tel_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tel_2#"><cfelse>NULL</cfif>,
                                    <cfif len(tel_3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tel_3#"><cfelse>NULL</cfif>,
                                    <cfif len(fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#fax#"><cfelse>NULL</cfif>,
                                    <cfif len(address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#address#"><cfelse>NULL</cfif>,
                                    <cfif len(zip_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#zip_code#"><cfelse>NULL</cfif>,
                                    <cfif len(county)><cfqueryparam cfsqltype="cf_sql_varchar" value="#county#"><cfelse>NULL</cfif>,
                                    <cfif len(city)><cfqueryparam cfsqltype="cf_sql_varchar" value="#city#"><cfelse>NULL</cfif>,
                                    <cfif len(country)><cfqueryparam cfsqltype="cf_sql_varchar" value="#country#"><cfelse>NULL</cfif>,
                                    <cfif len(tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_office#"><cfelse>NULL</cfif>,
                                    <cfif len(tax_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_no#"><cfelse>NULL</cfif>,
                                    <cfif len(hierarchy_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hierarchy_1#"><cfelse>NULL</cfif>,
                                    <cfif len(hierarchy_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hierarchy_2#"><cfelse>NULL</cfif>,
                                    <cfif len(company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"><cfelse>NULL</cfif>,
                                    <cfif len(related_company)><cfqueryparam cfsqltype="cf_sql_varchar" value="#related_company#"><cfelse>NULL</cfif>,
                                    <cfif len(related_branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#related_branch_id#"><cfelse>NULL</cfif>,
                                    <cfif len(branch_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#branch_cat_id#"><cfelse>NULL</cfif>,
                                    <cfif len(special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code#"><cfelse>NULL</cfif>,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                                    <cfif len(CAL_BOL_MUD_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CAL_BOL_MUD_NAME#"><cfelse>NULL</cfif>,
                                    <cfif len(real_work)><cfqueryparam cfsqltype="cf_sql_varchar" value="#real_work#"><cfelse>NULL</cfif>,
                                    <cfif len(branch_work)><cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_work#"><cfelse>NULL</cfif>,
                                    <cfif len(danger_degree_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(danger_degree_no)#"><cfelse>NULL</cfif>,
                                    <cfif len(is_sakat_kontrol)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_sakat_kontrol#"><cfelse>NULL</cfif>,
                                    <cfif len(file_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#file_no#"><cfelse>NULL</cfif>
                                )
                            </cfquery>
                            <cfquery name="ADD_LAST_NUMBER" datasource="#DSN#">
                                INSERT INTO 
                                    SETUP_BRANCH_PRICE_CHANGE_NO
                                (
                                    BRANCH_ID,
                                    SON_BELGE_NO
                                )
                                VALUES
                                (
                                    #MAX_ID.IDENTITYCOL#, 
                                    '1'
                                )
                            </cfquery>
                            <cfquery name="ADD_BRANCH_HISTORY" datasource="#DSN#">
                                INSERT INTO
                                    BRANCH_HISTORY 
                                (
                                    BRANCH_STATUS,ZONE_ID,COMPANY_ID,BRANCH_ID,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,BRANCH_NAME,BRANCH_FULLNAME,BRANCH_EMAIL,BRANCH_TELCODE,BRANCH_TEL1,BRANCH_TEL2,BRANCH_TEL3,BRANCH_FAX,BRANCH_ADDRESS,BRANCH_POSTCODE,BRANCH_COUNTY,BRANCH_CITY,BRANCH_COUNTRY,BRANCH_WORK,SSK_OFFICE,SSK_NO,SSK_M,SSK_JOB,SSK_BRANCH,SSK_BRANCH_OLD,SSK_CITY,SSK_COUNTRY,
                                    SSK_CD,SSK_AGENT,WORK_ZONE_M,WORK_ZONE_JOB,WORK_ZONE_FILE,WORK_ZONE_CITY,DANGER_DEGREE,DANGER_DEGREE_NO,ASSET_FILE_NAME1,ASSET_FILE_NAME1_SERVER_ID,ASSET_FILE_NAME2,ASSET_FILE_NAME2_SERVER_ID,FOUNDATION_DATE,ISKUR_BRANCH_NAME,ISKUR_BRANCH_NO,CAL_BOL_MUD_NAME,REAL_WORK,CAL_BOL_MUD_NO,IS_INTERNET,HIERARCHY,HIERARCHY2,KANUN_5084_ORAN,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_SAKAT_KONTROL,RELATED_COMPANY,OZEL_KOD,IS_ORGANIZATION,RELATED_BRANCH_ID,BRANCH_CAT_ID,IS_PRODUCTION
                                ) 
                                    SELECT BRANCH_STATUS,ZONE_ID,COMPANY_ID,BRANCH_ID,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,BRANCH_NAME,BRANCH_FULLNAME,BRANCH_EMAIL,BRANCH_TELCODE,BRANCH_TEL1,BRANCH_TEL2,BRANCH_TEL3,BRANCH_FAX,BRANCH_ADDRESS,BRANCH_POSTCODE,BRANCH_COUNTY,BRANCH_CITY,BRANCH_COUNTRY,BRANCH_WORK,SSK_OFFICE,SSK_NO,SSK_M,SSK_JOB,SSK_BRANCH,SSK_BRANCH_OLD,SSK_CITY,SSK_COUNTRY,SSK_CD,SSK_AGENT,WORK_ZONE_M,WORK_ZONE_JOB,WORK_ZONE_FILE,WORK_ZONE_CITY,DANGER_DEGREE,DANGER_DEGREE_NO,ASSET_FILE_NAME1,ASSET_FILE_NAME1_SERVER_ID,ASSET_FILE_NAME2,ASSET_FILE_NAME2_SERVER_ID,FOUNDATION_DATE,ISKUR_BRANCH_NAME,ISKUR_BRANCH_NO,CAL_BOL_MUD_NAME,REAL_WORK,CAL_BOL_MUD_NO,IS_INTERNET,HIERARCHY,HIERARCHY2,KANUN_5084_ORAN,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_SAKAT_KONTROL,RELATED_COMPANY,OZEL_KOD,IS_ORGANIZATION,RELATED_BRANCH_ID,BRANCH_CAT_ID,IS_PRODUCTION FROM BRANCH WHERE BRANCH_ID = #MAX_ID.IDENTITYCOL#
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