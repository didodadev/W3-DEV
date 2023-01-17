<cfif isdefined('attributes.is_security') and attributes.is_security eq 1>
	<cf_wrk_captcha name="captcha" action="validate">
	<cfif captcha.validationResult eq false>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1439.Güvenlik Kodunu Hatalı Girdiniz! Lütfen Düzenleyiniz'>!");
			history.back(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfif not isDefined('session.pp.our_company_id') and not isDefined('session.ww.our_company_id')> 	
	<cfset attributes.our_company_id = listgetat(partner_companies,listfind(partner_url,cgi.http_host,';'),';')>
    <cfquery name="GET_PERIOD" datasource="#DSN#">
    	SELECT 
        	PERIOD_ID 
        FROM 
        	SETUP_PERIOD 
        WHERE 
        	PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#DateFormat(now(),'yyyy')#"> AND 
            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
    </cfquery>
	<cfset attributes.period_id = get_period.period_id>
</cfif>

<cfquery name="GET_COMP" datasource="#DSN#">
	SELECT 
		COMPANY_ID
	FROM 
		COMPANY 
	WHERE 
		(FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fullname#"> AND 
        NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nickname#">)
		<cfif isDefined("form.company_code") and len(form.company_code)>
			OR MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.company_code#">
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
        <cfelseif isdefined("attributes.our_company_id")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_company%">
	ORDER BY 
		PTR.PROCESS_ROW_ID
</cfquery>

<cfif not get_stage.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1427.Müşteri Durumu Bulunamadı! Müşteri Hizmetlerine Başvurunuz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif get_comp.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1401.Şirketin Tam Ünvanı/Kısa Ünvanı veya Üye kodu ile kayıtlı bir Şirket var lutfen kontrol ediniz'>..");
		window.history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfif isdefined("form.currency")>
	<cfset curr_val = 0>
<cfelse>
	<cfset curr_val = 1>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
    <cftransaction>
        <cfquery name="ADD_COMPANY" datasource="#DSN#">
            INSERT INTO 
                COMPANY
                (
                    WRK_ID,
                    COMPANY_STATE,
                    <cfif isdefined('attributes.is_member_hierarchy') and attributes.is_member_hierarchy eq 1>
                        HIERARCHY_ID,
                    </cfif>
                    COUNTY,
                    CITY,
                    COUNTRY,
                    COMPANY_STATUS,
                    <cfif isDefined("form.companycat_id")>
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
                    <cfif isdefined('attributes.is_member_hierarchy') and attributes.is_member_hierarchy eq 1>
                        <cfif isdefined("session.pp.company_id")>#session.pp.company_id#<cfelse>NULL</cfif>,
                    </cfif>
                    <cfif isdefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.city_id") and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.country") and len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
                    #variables.curr_val#,
                    <cfif isdefined("form.companycat_id")>
                        '#form.companycat_id#',
                    </cfif>
                    '#form.fullname#',
                    '#form.nickname#',
                    <cfif isDefined('attributes.email') and len(attributes.email)>'#trim(attributes.email)#'<cfelse>NULL</cfif>,
                    <cfif isdefined("form.homepage")>'#trim(form.homepage)#',<cfelse>NULL,</cfif>
                    <cfif len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
                    <cfif len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
                    '#form.telcode#',						
                    '#form.tel1#',
                    <cfif isdefined("form.fax") and len(trim(form.fax))>'#form.fax#',<cfelse>NULL,</cfif>
                    <cfif isdefined("form.postcode") and len(trim(form.postcode))>'#form.postcode#',<cfelse>NULL,</cfif>
                    <cfif isdefined("form.address")>'#form.address#',<cfelse>NULL,</cfif>
                    #now()#,
                    <cfif isdefined('session.pp.userid')>#session.pp.userid#<cfelse>NULL</cfif>,
                    #now()#,
                    '#remote_addr#',
                    #attributes.is_potantial#,						
                    <cfif isdefined("session.pp.period_id")>#session.pp.our_company_id#<cfelseif isDefined('session.ww.our_company_id')>#session.ww.our_company_id#<cfelseif isDefined('attributes.our_company_id')>#attributes.our_company_id#</cfif>,
                    <cfif isdefined("form.company_sector") and len(form.company_sector)>#form.company_sector#,<cfelse>NULL,</cfif>
                    <cfif isdefined("form.company_size_cat_id")>#form.company_size_cat_id#,<cfelse>NULL,</cfif>
                    <cfif isdefined("attributes.tax_office") and len(attributes.tax_office)>'#attributes.tax_office#',<cfelse>NULL,</cfif>
                    <cfif isdefined("attributes.tax_no") and len(attributes.tax_no)>'#attributes.tax_no#'<cfelse>NULL</cfif>
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
                    <cfif isDefined('attributes.email') and len(attributes.email)>'#trim(attributes.email)#'<cfelse>NULL</cfif>,
                    '#pass#',
                    #get_max.max_company#,
                    '#form.company_partner_name#',
                    '#form.company_partner_surname#',
                    <cfif isDefined('attributes.company_partner_title') and len(attributes.company_partner_title)>'#attributes.company_partner_title#'<cfelse>NULL</cfif>,
                    <cfif isDefined('attributes.sex') and len(attributes.sex)>#attributes.sex#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.fax") and isDefined('attributes.department') and len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.part_address")>'#attributes.part_address#',<cfelse>NULL,</cfif>			
                    <cfif isDefined('attributes.email') and len(attributes.email)>'#trim(attributes.email)#'<cfelse>NULL</cfif>,
                    <cfif len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
                    <cfif len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,		
                    <cfif isdefined("attributes.part_telcode") and len(trim(attributes.part_telcode))>'#attributes.part_telcode#'<cfelse>NULL</cfif>,						
                    <cfif isdefined("attributes.part_tel1") and len(trim(attributes.part_tel1))>'#attributes.part_tel1#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.part_fax") and len(trim(attributes.part_fax))>'#attributes.part_fax#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.part_homepage") and len(attributes.part_homepage)>'#attributes.part_homepage#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.part_country") and len(attributes.part_country)>#attributes.part_country#<cfelse>NULL</cfif>,	
                    <cfif isdefined("attributes.part_city_id") and len(attributes.part_city_id)>#attributes.part_city_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.part_county_id") and len(attributes.part_county_id)>#attributes.part_county_id#<cfelse>NULL</cfif>,
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
        <cfif isDefined("attributes.acc_code_start") and len(attributes.acc_code_start) and isDefined("attributes.acc_num_count") and len(attributes.acc_num_count)><!--- site xml lerinden geliyor,partnerda otomatik muh. hesabı oluşturmk için..AE--->
            <cfquery name="ACC_CONTROL" datasource="#DSN#">
                SELECT ACCOUNT_CODE FROM #dsn2_alias#.ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_start#">
            </cfquery>
            <cfif acc_control.recordcount><!--- başlangç hesabı hiç yoksa devam etmeyeck--->
                <cfquery name="ACCOUNT_CODE_QUEE" datasource="#DSN#">
                    SELECT 
                        TOP 1 SUBSTRING(ACCOUNT_CODE,#len(attributes.acc_code_start)+2#,len(ACCOUNT_CODE)) NEW_ACCOUNT_CODE
                    FROM 
                        #dsn2_alias#.ACCOUNT_PLAN
                    WHERE 
                        ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_start#%">
                    ORDER BY 
                        ACCOUNT_CODE DESC
                </cfquery>				
                <cfquery name="UPD_ACCOUNT_CODE" datasource="#DSN#">
                    UPDATE
                        #dsn2_alias#.ACCOUNT_PLAN
                    SET
                        SUB_ACCOUNT = 1
                    WHERE
                        ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code_start#"><!--- sonradan değişken değiştigi için burda update edildi --->
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
                        for(i=len(new_account_code_num);i lt attributes.acc_num_count;i=i+1)
                            new_account_code_num='0'&new_account_code_num;
                    attributes.acc_code_start=attributes.acc_code_start & '.' & new_account_code_num;
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
                            '#attributes.acc_code_start#',
                            '#attributes.fullname#'
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
                <cfif isdefined("session.pp.period_id")>#session.pp.period_id#<cfelseif isDefined('session.ww.period_id')>#session.ww.period_id#<cfelseif isDefined('attributes.our_company_id')>#attributes.our_company_id#</cfif>,
                <cfif isDefined("attributes.acc_code_start") and len(attributes.acc_code_start)>'#attributes.acc_code_start#'<cfelse>NULL</cfif>
            )
        </cfquery>
        <cfif isDefined("attributes.installment_process_info") and attributes.installment_process_info eq 1>
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
                    <cfelseif isDefined('attributes.our_company_id')>
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#"> AND
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
        <!--- site tanımı için gerekli --->
        <cfset sira_ = 0>
        <cfif isdefined("session.pp.period_id")>
            <cfset this_comp_ = session.pp.our_company_id> 
        <cfelseif isdefined("session.ww.period_id")>
            <cfset this_comp_ = session.ww.our_company_id>
        <cfelseif isDefined('attributes.our_company_id')>
            <cfset this_comp_ = attributes.our_company_id>
        </cfif>
        <cfquery name="GET_MAIN_MENU_DOMAINS" datasource="#DSN#">
        	SELECT 
            	MENU_ID,
                SITE_DOMAIN
            FROM
                MAIN_MENU_SETTINGS
        </cfquery>
        <cfloop list="#partner_url#" delimiters=";" index="puid">
            <cfset sira_ = sira_ + 1>
            <cfif listgetat(partner_companies,sira_,';') eq this_comp_>
            	<cfquery name="GET_MAIN_MENU_DOMAIN" dbtype="query">
                	SELECT * FROM GET_MAIN_MENU_DOMAINS WHERE SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#puid#">
                </cfquery>
                <cfif get_main_menu_domain.recordcount and len(get_main_menu_domain.menu_id)>
                    <cfquery name="ADD_" datasource="#DSN#">
                        INSERT INTO
                            COMPANY_CONSUMER_DOMAINS
                            (
                                PARTNER_ID,
                                MENU_ID,
                                RECORD_DATE,
                                RECORD_PAR,
                                RECORD_IP
                            )
                            VALUES
                            (
                                #get_max_partner.max_part#,
                                #get_main_menu_domain.menu_id#,
                                #now()#,
                                #get_max_partner.max_part#,
                                '#cgi.remote_addr#'
                            )
                    </cfquery>
                </cfif>
            </cfif>
        </cfloop>
        <!--- site tanımı için gerekli --->
        <!--- Üye kaydından sonra etkilesim kaydediyor --->
        <cfif isdefined('attributes.app_subject') and len(attributes.app_subject)>
            <cfquery name="GET_PROCESS" datasource="#DSN#" maxrows="1">
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
                        PTR.IS_PARTNER = 1 AND
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
                    <cfelseif isdefined("session.ww")>
                        PTR.IS_CONSUMER = 1 AND
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
                    <cfelse>
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                    </cfif>
                    PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.popup_add_helpdesk%">
                ORDER BY 
                    PTR.PROCESS_ROW_ID
            </cfquery>
            <cfif not get_process.recordcount>
                <script type="text/javascript">
                    alert("<cf_get_lang no='33.İşlem Tipleri Tanımlı Değil! Lütfen Müşteri Temsilcinize Başvurunuz'>!");
                    history.back();
                </script>
                <cfabort>
            </cfif>
            <cfset my_aplicant_name = '#form.company_partner_name# #form.company_partner_surname#'>
            <cfquery name="ADD_HELP" datasource="#DSN#">
                INSERT INTO
                    CUSTOMER_HELP
                (
                    OUR_COMPANY_ID,
                    SITE_DOMAIN,
                    PARTNER_ID,
                    COMPANY_ID,
                    CONSUMER_ID,
                    APP_CAT,
                    INTERACTION_CAT,
                    SUBJECT,
                    PROCESS_STAGE,
                    APPLICANT_NAME,
                    APPLICANT_MAIL,
                    <cfif isdefined('session.pp.userid')>
                        RECORD_PAR,
                    <cfelseif isdefined('session.ww.userid')>
                        RECORD_CONS,
                    <cfelseif isdefined('session.cp.userid')>
                        RECORD_APP,
                    <cfelse>
                        GUEST,
                    </cfif>
                    INTERACTION_DATE,
                    RECORD_DATE,
                    RECORD_IP,
                    IS_REPLY,
                    IS_REPLY_MAIL
                )
                VALUES
                (
                    #session_base.our_company_id#,
                    '#cgi.http_host#',
                    #get_max_partner.max_part#,
                    #get_max.max_company#,
                    NULL,
                    6,
                    <cfif isDefined('attributes.interaction_cat') and len(attributes.interaction_cat)>#attributes.interaction_cat#<cfelse>NULL</cfif>,
                    '#attributes.app_subject#',
                    #get_process.process_row_id#,
                    '#my_aplicant_name#',
                    <cfif isDefined('attributes.email') and len(attributes.email)>'#trim(attributes.email)#'<cfelse>NULL</cfif>,
                    <cfif isdefined('session.pp.userid')>
                        #session.pp.userid#,
                    <cfelseif isdefined('session.ww.userid')>
                        #session.ww.userid#,
                    <cfelseif isdefined('session.cp.userid')>
                        #session.cp.userid#,
                    <cfelse>
                        1,
                    </cfif>
                    #now()#,
                    #now()#,
                    '#cgi.remote_addr#',
                    0,
                    0
                )
            </cfquery>
        </cfif>
        <!--- Üye kaydından sonra etkilesim kaydediyor --->
        <!--- Üye kaydından sonra fırsat kaydediyor --->
        <cfif isdefined('attributes.opportunity_detail') and len(attributes.opportunity_detail)>
            <cfquery name="GET_STAGE_OPPORTUNITY" datasource="#DSN#" maxrows="1">
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
                    <cfelse>
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                    </cfif>
                    PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.form_add_opportunity%">
                ORDER BY 
                    PTR.PROCESS_ROW_ID
            </cfquery>
            <cf_papers paper_type="OPPORTUNITY">
            <cfset system_paper_no=paper_code & '-' & paper_number>
            <cfset system_paper_no_add=paper_number>
            <cfquery name="ADD_MEMBER_OPPORTUNITY" datasource="#DSN#">
                INSERT INTO
                    #dsn#_#session_base.our_company_id#.OPPORTUNITIES
                    (
                        OPPORTUNITY_TYPE_ID,
                        PARTNER_ID,
                        COMPANY_ID,
                        OPP_STAGE,
                        OPP_DETAIL,
                        OPP_DATE,
                        OPP_HEAD,
                        OPP_STATUS,
                        OPP_NO,
                        RECORD_PAR,
                        RECORD_IP,
                        RECORD_DATE				
                    )
                    VALUES
                    (
                        #attributes.opportunity_type_id#,
                        #get_max_partner.max_part#,
                        #get_max.max_company#,
                        #get_stage_opportunity.process_row_id#,
                        '#attributes.opportunity_detail#',
                        #now()#,
                        '#attributes.fullname#',
                        1,
                        '#system_paper_no#',
                        #get_max_partner.max_part#,
                        '#cgi.remote_addr#',
                        #now()#	
                    )
            </cfquery>
        </cfif>
        <!--- Üye kaydından sonra fırsat kaydediyor --->
    </cftransaction>
</cflock>
<cf_workcube_process 
    is_upd='1' 
    old_process_line='0'
    process_stage='#get_stage.process_row_id#' 
    record_member='#get_max_partner.max_part#' 
    record_date='#now()#' 
    action_table='COMPANY'
    action_column='COMPANY_ID'
    action_id='#get_max.max_company#'
    action_page='#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_max.max_company#' 
    warning_description = 'Kurumsal Üye : #attributes.fullname#'>

<cfif isdefined('attributes.is_member_mail') and attributes.is_member_mail eq 1 and isDefined('attributes.email') and len(attributes.email)>
	<cfquery name="GET_OUR_EMAIL" datasource="#DSN#">
		SELECT
			COMPANY_NAME,
			EMAIL
		FROM
			OUR_COMPANY
		WHERE
			<cfif isdefined("session.pp.period_id")>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
			<cfelseif isDefined('session.ww.pseriod_id')>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
            <cfelseif isDefined('attributes.our_company_id')>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
			</cfif>
	</cfquery>
	<cfsavecontent variable="message"><cf_get_lang_main no='1911.Şifre Bilgilendirme İşlemi'></cfsavecontent>
	<cftry>
		<cfmail
			to = "#attributes.email#"
			from = "#get_our_email.company_name#<#get_our_email.email#>"
			subject = "#cgi.http_host# #message#"
			type="HTML">  
			<style type="text/css">
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color :333333;padding-left: 4px;}
				.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
			</style>
            <cfif isdefined("session.pp.period_id") or isDefined('session.ww.period_id')>
				<cfinclude template="../../objects/display/view_company_logo.cfm">
			</cfif>
            <br/>
			<table align="center" style="width:590px;">
				<tr style="height:35px;">
					<td class="headbold"><strong><cf_get_lang_main no='814.Şifre Hatırlatıcı'><strong></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no ='146.Üye No'>:<strong>C#get_max.max_company#</strong></td>
				</tr> 
				<tr>
					<td><cf_get_lang_main no ='139.Kullanıcı Adınız'>:<strong>#attributes.email#</strong></td>
				</tr>
				<tr>
					<td><cf_get_lang no ='1405.Şifreniz'>:<strong>#password#</strong></td>
				</tr>
				<tr>
					<td><strong>
						!!! Üyeliğiniz aktive edildikten sonra şifreniz kullanıma açık olacaktır.<br />
						Üyeliğiniz aktive edildiğinde tarafınıza email gönderilecektir.
						</strong>
					</td>
				</tr>
			</table>
			<br/>
            <cfif isdefined("session.pp.period_id") or isDefined('session.ww.period_id')>
				<cfinclude template="../../objects/display/view_company_info.cfm">
			</cfif>
        </cfmail>
		&nbsp;			
		<cfcatch type="any">
			<table cellspacing="1" cellpadding="2" class="color-border" style="width:100%; height:100%;">
				<tr class="color-row">
					<td align="center" class="headbold">
						<cf_get_lang no ='1421.Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'>.
					</td>
				</tr>
			</table>
		</cfcatch>
	</cftry>
    <cfif isDefined("session.pp") or isDefined("session.ww")>
        <script type="text/javascript">
            window.location.replace(document.referrer);
        </script>
    <cfelse>
        <script type="text/javascript">
            alert("<cf_get_lang no ='1426.Kaydınız Başarıyla Alındı Üyelik Bilgileriniz Mail Adresinize Gönderildi'>!");
            <cfif not isDefined('session.pp.our_company_id') and not isDefined('session.ww.our_company_id')> 	
                window.close();
            <cfelse>
                window.location.href='<cfoutput><cfif isdefined("attributes.return_adress")>#attributes.return_adress#<cfelse>#request.self#?fuseaction=objects2.welcome</cfif></cfoutput>';
            </cfif>
        </script>
    </cfif>
<cfelse>
    <cfif isDefined("session.pp") or isDefined("session.ww")>
        <script type="text/javascript">
            window.location.replace(document.referrer);
        </script>
    <cfelse>
        <script type="text/javascript">
            alert("<cf_get_lang no ='1426.Kaydınız Başarıyla Alındı Üyelik Bilgileriniz Mail Adresinize Gönderildi'>!");
            <cfif not isDefined('session.pp.our_company_id') and not isDefined('session.ww.our_company_id')> 	
                window.close();
            <cfelse>
                window.location.href='<cfoutput><cfif isdefined("attributes.return_adress")>#attributes.return_adress#<cfelse>#request.self#?fuseaction=objects2.welcome</cfif></cfoutput>';
            </cfif>
        </script>
    </cfif>
</cfif>