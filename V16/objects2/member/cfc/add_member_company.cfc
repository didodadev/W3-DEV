
<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset company_id = session.pp.our_company_id>
        <cfset period_year = session.pp.period_year>
        <cfset language = session.pp.language>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
        <cfset company_id = session.ep.our_company_id>
        <cfset period_year = session.ep.period_year>
        <cfset language = session.ep.language>
    <cfelseif isdefined("session.cp")>
        <cfset session_base = evaluate('session.cp')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
        <cfset company_id = session.ww.our_company_id>
        <cfset period_year = session.ww.period_year>
        <cfset language = session.ww.language>
    </cfif>    

    <cfset dsn1_alias = "#dsn#_product">
    <cfset dsn_alias = '#dsn#'>
    <cfset dsn2 = dsn2_alias = '#dsn#_#session_base.period_year#_#session_base.OUR_COMPANY_ID#' />
    <cfset dsn3 = dsn3_alias = '#dsn#_#session_base.OUR_COMPANY_ID#' />
    <cffunction name="add_company" access="remote" returntype="string" returnformat="json">
        <cftry>
            <cfif isdefined('arguments.is_security') and arguments.is_security eq 1>
                <cf_wrk_captcha name="captcha" action="validate">
                <cfif captcha.validationResult eq false>
                    <cfset result.message = "İşlem Hatalı">
                    <cfset result.status = false>
                    <cfset result.error = cfcatch>
                    <cfabort>
                </cfif>
            </cfif>
            <cfif not isDefined('session.pp.our_company_id') and not isDefined('session.ww.our_company_id')> 	
                <cfset arguments.our_company_id = listgetat(partner_companies,listfind(partner_url,cgi.http_host,';'),';')>
                <cfquery name="GET_PERIOD" datasource="#DSN#">
                    SELECT 
                        PERIOD_ID 
                    FROM 
                        SETUP_PERIOD 
                    WHERE 
                        PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#DateFormat(now(),'yyyy')#"> AND 
                        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
                </cfquery>
                <cfset arguments.period_id = get_period.period_id>
            </cfif>
            <cfquery name="GET_COMP" datasource="#DSN#">
                SELECT 
                    COMPANY_ID
                FROM 
                    COMPANY 
                WHERE 
                    (FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fullname#"> AND 
                    NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#">)
                    <cfif isDefined("arguments.company_code") and len(arguments.company_code)>
                        OR MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_code#">
                    </cfif>
            </cfquery>
            <cfif isdefined('session.pp')>
                <cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.pp.userid#_'&round(rand()*100)>
            <cfelse>
                <cfset wrk_id = ''>
            </cfif>
            <cfset letters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,r,s,t,u,v,y,z,1,2,3,4,5,6,7,8,9,0">
            <cfset password = ''>
            <cfloop from="1" to="8" index="ind">
                <cfset random = RandRange(1, 33)>
                <cfset password = "#password##ListGetAt(letters,random,',')#">
            </cfloop>
            <cf_cryptedpassword	password='#password#' output='PASS' MOD=1>
            <cfquery name="GET_STAGE" datasource="#DSN#" maxrows="1">
                SELECT TOP 1
                    PTR.STAGE,
                    PTR.PROCESS_ROW_ID 
                FROM
                    PROCESS_TYPE_ROWS PTR,
                    PROCESS_TYPE_OUR_COMPANY PTO,
                    PROCESS_TYPE PT
                WHERE
                    PT.IS_ACTIVE = 1 AND
                    PT.PROCESS_ID = PTR.PROCESS_ID AND
                    PT.PROCESS_ID = PTO.PROCESS_ID AND
                    <cfif isdefined("session.pp")>
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
                    <cfelseif isdefined("session.ww")>
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
                    <cfelseif isdefined("session.ep")>
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                    <cfelseif isdefined("arguments.our_company_id")>
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"> AND
                    </cfif>
                    PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_company%">
                ORDER BY 
                    PTR.PROCESS_ROW_ID
            </cfquery>
            <cfif not get_stage.recordcount>
                <cfset result.message = "İşlem Hatalı">
                <cfset result.status = false>
                <cfset result.error = cfcatch>
            <cfelse>
                <cfif isdefined("arguments.currency")>
                    <cfset curr_val = 0>
                <cfelse>
                    <cfset curr_val = 1>
                </cfif>
                <cfquery name="ADD_COMPANY" datasource="#DSN#">
                    INSERT INTO 
                        COMPANY
                        (
                            WRK_ID,
                            COMPANY_STATE,
                            <cfif isdefined('arguments.is_member_hierarchy') and arguments.is_member_hierarchy eq 1>
                                HIERARCHY_ID,
                            </cfif>
                            COUNTY,
                            CITY,
                            COUNTRY,
                            COMPANY_STATUS,
                            <cfif isDefined("arguments.companycat_id")>
                                COMPANYCAT_ID,							
                            </cfif>
                            FULLNAME,
                            NICKNAME,
                            COMPANY_EMAIL,
                            HOMEPAGE,
                            MOBIL_CODE,
                            MOBILTEL,
                            COMPANY_TELCODE,
                            COMPANY_TEL1,
                            COMPANY_FAX,
                            COMPANY_POSTCODE,
                            COMPANY_ADDRESS,
                            START_DATE,
                            RECORD_PAR,
                            RECORD_DATE,
                            RECORD_IP,
                            ISPOTANTIAL,
                            PERIOD_ID,				
                            SECTOR_CAT_ID,
                            COMPANY_SIZE_CAT_ID,
                            TAXOFFICE,
                            TAXNO
                        )
                        VALUES
                        (
                            '#wrk_id#',
                            #get_stage.process_row_id#,
                            <cfif isdefined('arguments.is_member_hierarchy') and arguments.is_member_hierarchy eq 1>
                                <cfif isdefined("session.pp.company_id")>#session.pp.company_id#<cfelse>NULL</cfif>,
                            </cfif>
                            <cfif isdefined("arguments.county_id") and len(arguments.county_id)>#arguments.county_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.city_id") and len(arguments.city_id)>#arguments.city_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.country") and len(arguments.country)>#arguments.country#<cfelse>NULL</cfif>,
                            #variables.curr_val#,
                            <cfif isdefined("arguments.companycat_id")>
                                '#arguments.companycat_id#',
                            </cfif>
                            '#arguments.fullname#',
                            '#arguments.nickname#',
                            <cfif isDefined('arguments.email') and len(arguments.email)>'#trim(arguments.email)#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.homepage")>'#trim(arguments.homepage)#',<cfelse>NULL,</cfif>
                            <cfif len(arguments.mobilcat_id)>'#arguments.mobilcat_id#'<cfelse>NULL</cfif>,
                            <cfif len(arguments.mobiltel)>'#arguments.mobiltel#'<cfelse>NULL</cfif>,
                            '#arguments.telcode#',						
                            '#arguments.tel1#',
                            <cfif isdefined("arguments.fax") and len(trim(arguments.fax))>'#arguments.fax#',<cfelse>NULL,</cfif>
                            <cfif isdefined("arguments.postcode") and len(trim(arguments.postcode))>'#arguments.postcode#',<cfelse>NULL,</cfif>
                            <cfif isdefined("arguments.address")>'#arguments.address#',<cfelse>NULL,</cfif>
                            #now()#,
                            <cfif isdefined('session.pp.userid')>#session.pp.userid#<cfelse>NULL</cfif>,
                            #now()#,
                            '#remote_addr#',
                            #arguments.is_potantial#,						
                            <cfif isdefined("session.pp.period_id")>#session.pp.our_company_id#<cfelseif isDefined('session.ww.our_company_id')>#session.ww.our_company_id#<cfelseif isDefined('arguments.our_company_id')>#arguments.our_company_id#</cfif>,
                            <cfif isdefined("arguments.company_sector") and len(arguments.company_sector)>#arguments.company_sector#,<cfelse>NULL,</cfif>
                            <cfif isdefined("arguments.company_size_cat_id")>#arguments.company_size_cat_id#,<cfelse>NULL,</cfif>
                            <cfif isdefined("arguments.tax_office") and len(arguments.tax_office)>'#arguments.tax_office#',<cfelse>NULL,</cfif>
                            <cfif isdefined("arguments.tax_no") and len(arguments.tax_no)>'#arguments.tax_no#'<cfelse>NULL</cfif>
                        )
                </cfquery>
                <cfquery name="GET_MAX" datasource="#DSN#">
                    SELECT MAX(COMPANY_ID) AS MAX_COMPANY FROM COMPANY WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">
                </cfquery>

                <cfquery name="ADD_PARTNER" datasource="#DSN#">
                    INSERT INTO 
                        COMPANY_PARTNER 
                        (
                            COMPANY_PARTNER_USERNAME,
                            COMPANY_PARTNER_PASSWORD,
                            COMPANY_ID,
                            COMPANY_PARTNER_NAME,
                            COMPANY_PARTNER_SURNAME,
                            TITLE,
                            SEX,
                            DEPARTMENT,
                            COMPANY_PARTNER_ADDRESS,
                            COMPANY_PARTNER_EMAIL,
                            MOBIL_CODE,
                            MOBILTEL,
                            COMPANY_PARTNER_TELCODE,						
                            COMPANY_PARTNER_TEL,
                            COMPANY_PARTNER_FAX,
                            HOMEPAGE,
                            COUNTRY,
                            CITY,
                            COUNTY,
                            RECORD_DATE,
                            RECORD_IP
                        )
                        VALUES
                        (
                            <cfif isDefined('arguments.email') and len(arguments.email)>'#trim(arguments.email)#'<cfelse>NULL</cfif>,
                            '#pass#',
                            #get_max.max_company#,
                            '#arguments.company_partner_name#',
                            '#arguments.company_partner_surname#',
                            <cfif isDefined('arguments.company_partner_title') and len(arguments.company_partner_title)>'#arguments.company_partner_title#'<cfelse>NULL</cfif>,
                            <cfif isDefined('arguments.sex') and len(arguments.sex)>#arguments.sex#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.fax") and isDefined('arguments.department') and len(arguments.department)>#arguments.department#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.part_address")>'#arguments.part_address#',<cfelse>NULL,</cfif>			
                            <cfif isDefined('arguments.email') and len(arguments.email)>'#trim(arguments.email)#'<cfelse>NULL</cfif>,
                            <cfif len(arguments.mobilcat_id)>'#arguments.mobilcat_id#'<cfelse>NULL</cfif>,
                            <cfif len(arguments.mobiltel)>'#arguments.mobiltel#'<cfelse>NULL</cfif>,		
                            <cfif isdefined("arguments.part_telcode") and len(trim(arguments.part_telcode))>'#arguments.part_telcode#'<cfelse>NULL</cfif>,						
                            <cfif isdefined("arguments.part_tel1") and len(trim(arguments.part_tel1))>'#arguments.part_tel1#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.part_fax") and len(trim(arguments.part_fax))>'#arguments.part_fax#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.part_homepage") and len(arguments.part_homepage)>'#arguments.part_homepage#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.part_country") and len(arguments.part_country)>#arguments.part_country#<cfelse>NULL</cfif>,	
                            <cfif isdefined("arguments.part_city_id") and len(arguments.part_city_id)>#arguments.part_city_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.part_county_id") and len(arguments.part_county_id)>#arguments.part_county_id#<cfelse>NULL</cfif>,
                            #now()#,
                            '#CGI.REMOTE_ADDR#'
                        )
                </cfquery>
                
                <cfquery name="GET_MAX_PARTNER" datasource="#DSN#">
                    SELECT MAX(PARTNER_ID) MAX_PART FROM COMPANY_PARTNER
                </cfquery>

                <cfquery name="UPD_RECORD_PAR" datasource="#DSN#">
                    UPDATE 
                        COMPANY_PARTNER 
                    SET 
                        RECORD_PAR = #get_max_partner.max_part#
                    WHERE 
                        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_partner.max_part#">
                </cfquery>
                        
                <cfquery name="ADD_PARTNER_SETTINGS" datasource="#DSN#">
                    INSERT INTO
                        MY_SETTINGS_P
                        (
                            PARTNER_ID,
                            TIME_ZONE,
                            MAXROWS,
                            TIMEOUT_LIMIT
                        )
                        VALUES
                        (
                            #get_max_partner.max_part#,
                            0,
                            20,
                            30
                        )
                </cfquery>
                <cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
                    UPDATE 
                        COMPANY 
                    SET 
                        MEMBER_CODE = 'C#get_max.max_company#',
                        <!---RECORD_PAR = #get_max_partner.max_part#,--->
                        MANAGER_PARTNER_ID = #get_max_partner.max_part#
                    WHERE 
                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">
                </cfquery>
                <cfif isDefined("arguments.acc_code_start") and len(arguments.acc_code_start) and isDefined("arguments.acc_num_count") and len(arguments.acc_num_count)><!--- site xml lerinden geliyor,partnerda otomatik muh. hesabı oluşturmk için..AE--->
                    <cfquery name="ACC_CONTROL" datasource="#DSN#">
                        SELECT ACCOUNT_CODE FROM #dsn2_alias#.ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_code_start#">
                    </cfquery>
                    <cfif acc_control.recordcount><!--- başlangç hesabı hiç yoksa devam etmeyeck--->
                        <cfquery name="ACCOUNT_CODE_QUEE" datasource="#DSN#">
                            SELECT 
                                TOP 1 SUBSTRING(ACCOUNT_CODE,#len(arguments.acc_code_start)+2#,len(ACCOUNT_CODE)) NEW_ACCOUNT_CODE
                            FROM 
                                #dsn2_alias#.ACCOUNT_PLAN
                            WHERE 
                                ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_code_start#%">
                            ORDER BY 
                                ACCOUNT_CODE DESC
                        </cfquery>				
                        <cfquery name="UPD_ACCOUNT_CODE" datasource="#DSN#">
                            UPDATE
                                #dsn2_alias#.ACCOUNT_PLAN
                            SET
                                SUB_ACCOUNT = 1
                            WHERE
                                ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_code_start#"><!--- sonradan değişken değiştigi için burda update edildi --->
                        </cfquery>
                        <cfif not len(account_code_quee.new_account_code)>
                            <cfset new_account_code_num=0>
                        <cfelse>
                            <cfset new_account_code_num=account_code_quee.new_account_code>
                        </cfif>
                        <cfscript>
                            elde = 0;
                            sonuc = '';
                            i_sonuc = 0;
                            for(ki=len(new_account_code_num);ki gte 0;ki=ki-1)
                            { 
                                i_deger = Mid(new_account_code_num,ki+1,1);//her elemanı tek tek alıyoruz..
                                if(i_deger gte 0 and i_deger lte 9 and elde gt -1)
                                {//eleman sayısal ise ve elde işlemi yani önceki elemanlar için bir toplam işlemi yapılmadı ise..
                                    i_sonuc = i_deger+1;//ara işlem sonucu olarak elemanı 1 ile topluyoruz..
                                    //ara işlem sonucumuz  0 dan büyük ise (9+1 = 10) 
                                    //&& ve ana değerimizdeki şu andaki index'in 1 öncesi sayısal ise  toplam işlemi yapılmış olduğunu elde değişkenine 1 atark tutucaz. (T029 daki  örnekte 2'ye bakıyoruz.... )
                                    if(i_sonuc gt 9 and mid(new_account_code_num,ki+1,1) gte 0 and mid(new_account_code_num,ki+1,1) lte 9)
                                    {
                                        elde = 1;
                                        i_sonuc = 0;
                                    }
                                    else
                                        elde = -1;
                                    sonuc = '#i_sonuc##sonuc#';//ifademizi string olarak birleştiriyoruz...
                                }
                                else
                                    sonuc='#Mid(new_account_code_num,ki+1,1)##sonuc#';//eğer sayısal bir ifade değilse sonuc string ifadesi ile birleştiriyoruz.
                            }
                            if(elde eq 0)//bu kısım sadece metin karakterlerinden oluşan degerler için eklendi Örn: ABC  gibi bir değer gelirse ABC1 yapıyoruz..
                                sonuc = '#new_account_code_num#1';
                            else if(elde eq 1 and i_deger eq 9)//9VA gibi yada 9 veya 99 gibi bir değer girildiğinde en son eleman olan 9 üzerinde bir toplam işlemi yapılmış fakat elde işlemi sonuca uygulanamamış oluyordu bu durumu için yazıldı..
                                sonuc = '1#sonuc#';
                            new_account_code_num = sonuc; 	
                            if (not len(account_code_quee.new_account_code))//hiç alt yoksa sadece kendi arttırılır
                                for(i=len(new_account_code_num);i lt arguments.acc_num_count;i=i+1)
                                    new_account_code_num='0'&new_account_code_num;
                            arguments.acc_code_start=arguments.acc_code_start & '.' & new_account_code_num;
                        </cfscript>
                        <cfquery name="INSERT_ACCOUNT_CODE" datasource="#DSN#"><!--- yeni olışturulan hesap, hesap planına da eklenir --->
                            INSERT INTO
                                #dsn2_alias#.ACCOUNT_PLAN
                                (
                                    ACCOUNT_CODE,
                                    ACCOUNT_NAME
                                )
                                VALUES
                                (
                                    '#arguments.acc_code_start#',
                                    '#arguments.fullname#'
                                )
                        </cfquery>
                    </cfif>
                </cfif>
                <cfquery name="ADD_COMP_PERIOD" datasource="#DSN#">
                    INSERT INTO
                        COMPANY_PERIOD
                    (
                        COMPANY_ID,
                        PERIOD_ID,
                        ACCOUNT_CODE
                    )
                    VALUES
                    (
                        #get_max.max_company#,
                        <cfif isdefined("session.pp.period_id")>#session.pp.period_id#<cfelseif isDefined('session.ww.period_id')>#session.ww.period_id#<cfelseif isDefined('arguments.our_company_id')>#arguments.our_company_id#</cfif>,
                        <cfif isDefined("arguments.acc_code_start") and len(arguments.acc_code_start)>'#arguments.acc_code_start#'<cfelse>NULL</cfif>
                    )
                </cfquery>
                <cfif isDefined("arguments.installment_process_info") and arguments.installment_process_info eq 1>
                    <cfquery name="GET_STAGE" datasource="#DSN#" maxrows="1">
                        SELECT TOP 1
                            PTR.STAGE,
                            PTR.PROCESS_ROW_ID 
                        FROM
                            PROCESS_TYPE_ROWS PTR,
                            PROCESS_TYPE_OUR_COMPANY PTO,
                            PROCESS_TYPE PT
                        WHERE
                            PT.IS_ACTIVE = 1 AND
                            PT.PROCESS_ID = PTR.PROCESS_ID AND
                            PT.PROCESS_ID = PTO.PROCESS_ID AND
                            <cfif isdefined("session.pp")>
                                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
                            <cfelseif isdefined("session.ww")>
                                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
                            <cfelseif isdefined("session.ep")>
                                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                            <cfelseif isDefined('arguments.our_company_id')>
                                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"> AND
                            </cfif>
                            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%contract.detail_contract_company%">
                        ORDER BY 
                            PTR.PROCESS_ROW_ID
                    </cfquery>
                    <cfif get_stage.recordcount>
                        <cfquery name="ADD_CREDIT" datasource="#DSN#" result="MAX_ID">
                            INSERT INTO
                                COMPANY_CREDIT
                            (
                                PROCESS_STAGE,
                                COMPANY_ID,
                                OPEN_ACCOUNT_RISK_LIMIT,
                                OPEN_ACCOUNT_RISK_LIMIT_OTHER,
                                FORWARD_SALE_LIMIT,
                                FORWARD_SALE_LIMIT_OTHER,
                                TOTAL_RISK_LIMIT,
                                TOTAL_RISK_LIMIT_OTHER,
                                MONEY,
                                OUR_COMPANY_ID,
                                IS_INSTALMENT_INFO,
                                RECORD_IP,
                                RECORD_PAR,
                                RECORD_DATE
                            )
                            VALUES
                            (
                                #get_stage.process_row_id#,
                                #get_max.max_company#,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                '#session_base.money#',
                                #session_base.our_company_id#,
                                1,
                                '#cgi.remote_addr#',
                                <cfif isDefined("session_base.userid")>#session_base.userid#,<cfelse>NULL,</cfif>
                                #now()#
                            )
                        </cfquery>
                        <cfquery name="GET_MONEY_CREDIT" datasource="#DSN#">
                            SELECT MONEY, RATE1, RATE2 FROM #dsn2_alias#.SETUP_MONEY
                        </cfquery>
                        <cfoutput query="get_money_credit">
                            <cfquery name="ADD_CREDIT_MONEY" datasource="#DSN#">
                                INSERT INTO
                                    COMPANY_CREDIT_MONEY
                                (
                                    MONEY_TYPE,
                                    ACTION_ID,
                                    RATE2,
                                    RATE1,
                                    IS_SELECTED
                                )
                                VALUES
                                (
                                    '#money#',
                                    #max_id.identitycol#,
                                    #rate2#,
                                    #rate1#,
                                    <cfif session_base.money is money>1<cfelse>0</cfif>
                                )
                            </cfquery>
                        </cfoutput>
                    </cfif>
                </cfif>
                <cfset result.message = "İşlem Başarılı">
                <cfset result.status = true>
            </cfif>
            <cfcatch>
                <cfset result.message = "İşlem Hatalı">
                <cfset result.status = false>
                <cfset result.error = cfcatch>
            </cfcatch>
        </cftry>        
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
</cfcomponent>