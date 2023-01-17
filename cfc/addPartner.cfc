<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="addPartner" access="public" returntype="any">
    	<cfargument name="attributes">
        
        <cfset list="',""">
		<cfset list2=" , ">
        <cfset attributes.name=replacelist(trim(attributes.name),list,list2)>
        <cfset attributes.soyad=replacelist(trim(attributes.soyad),list,list2)>
        
        <cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
		<cfif isdefined("attributes.birthdate") and len(attributes.birthdate)><cf_date tarih='attributes.birthdate'></cfif>
        <cfif isdefined('form.password') and len(form.password)>
            <cf_cryptedpassword	password='#form.password#' output='PASS' mod=1>
        </cfif>
        
        <!--- pdks no kontrol --->
        <cfif isDefined('session.ep') and len(attributes.pdks_number)>
            <cfquery name="get_par_pdks_number" datasource="#this.dsn#">
                SELECT
                    COMPANY_PARTNER_NAME,
                    COMPANY_PARTNER_SURNAME
                FROM
                    COMPANY_PARTNER
                WHERE
                    PDKS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pdks_number#"> AND
                    COMPANY_PARTNER_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            </cfquery>
            <cfif get_par_pdks_number.recordcount>
                <script type="text/javascript">
                    alert('<cfoutput>#get_par_pdks_number.COMPANY_PARTNER_NAME# #get_par_pdks_number.COMPANY_PARTNER_SURNAME# Adlı Çalışan Aynı PDKS Numarası İle Kayıtlı</cfoutput>! Lütfen Düzeltiniz!');
                    history.back();
                </script>
                <cfabort>
            </cfif>
        </cfif>
        <!----------------------->
        
        <cfif len(attributes.username) and len(attributes.password)>
            <cfquery name="CHECK_USERNAME" datasource="#this.dsn#">
                SELECT 
                    COMPANY_PARTNER_USERNAME 
                FROM 
                    COMPANY_PARTNER
                WHERE 
                    COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.username#"> AND 
                    COMPANY_PARTNER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="'#pass#'">
            </cfquery>
            <cfif check_username.recordcount>
                <script type="text/javascript">
                    alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='139.kullanıcı adı'>/<cf_get_lang_main no='140.şifre'><cf_get_lang_main no='781.tekrarı'>");
                    window.history.go(-1);
                </script>
              <cfabort>
            </cfif>
        </cfif>
        <cfset list="\n,#Chr(13)#,#Chr(10)#"> <!--- Newline karakterlerinin database e yazılmaması için eklenmiştir. --->
        <cfset list2=" , , ">
        <cfset adres=replacelist(attributes.adres,list,list2)>
        <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
        <cfset upload_folder = application.systemParam.systemParam().upload_folder>
        <cfset fusebox.server_machine = application.systemParam.systemParam().fusebox.server_machine>
        <cfif isDefined("form.photo") and len(form.photo)>
            <cftry>
                <cfset file_name = createUUID()>
                <cffile action="UPLOAD" filefield="photo" nameconflict="MAKEUNIQUE"
                    destination="#upload_folder#member#dir_seperator#" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*">   <!--- accept="image/*" --->
                <cffile action="rename" source="#upload_folder#member#dir_seperator##cffile.serverfile#"
                    destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">		
                <!---Script dosyalarını engelle  02092010 FA-ND --->
                <cfset assetTypeName = listlast(cffile.serverfile,'.')>
                <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
                <cfif listfind(blackList,assetTypeName,',')>
                    <cffile action="delete" file="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
                    <script type="text/javascript">
                        alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                        history.back();
                    </script>
                    <cfabort>
                </cfif>
                <cfcatch>
                    <script type="text/javascript">
                        alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz!");
                        window.history.go(-1);
                    </script>
                    <cfabort>
                </cfcatch>
            </cftry>	
        </cfif>

        <cflock name="#CreateUUID()#" timeout="20">
            <cftransaction>
                <cfquery name="ADD_PARTNER" datasource="#this.dsn#" result="my_result">
                    INSERT INTO 
                        COMPANY_PARTNER 
                    (
                        COMPANY_ID,
                        COMPANY_PARTNER_USERNAME,
                        COMPANY_PARTNER_PASSWORD,
                        TC_IDENTITY,
                        COMPANY_PARTNER_NAME,
                        COMPANY_PARTNER_SURNAME,
                        TITLE,
                        SEX,
                        DEPARTMENT,
                        COMPANY_PARTNER_EMAIL,
                        PARTNER_KEP_ADRESS,
                        IMCAT_ID,
                        IM,
                        IMCAT2_ID,
                        IM2,
                        MOBIL_CODE,
                        MOBILTEL,
                        COMPANY_PARTNER_TELCODE,
                        COMPANY_PARTNER_TEL,
                        COMPANY_PARTNER_TEL_EXT,
                        COMPANY_PARTNER_FAX,
                        HOMEPAGE,
                        MISSION,
                        LANGUAGE_ID,
                        COMPBRANCH_ID,
                        IS_SEND_FINANCE_MAIL,
                        IS_SEND_EARCHIVE_MAIL,
                        PHOTO,
                        PHOTO_SERVER_ID,
                        COMPANY_PARTNER_ADDRESS,
                        COMPANY_PARTNER_POSTCODE,
                        COUNTY,
                        CITY,
                        COUNTRY,	
                        SEMT,
                        DISTRICT_ID,
                        START_DATE,
                        HIERARCHY_PARTNER_ID,
                        RELATED_CONSUMER_ID,
                        MEMBER_TYPE,
                        PDKS_NUMBER,
                        PDKS_TYPE_ID,
                        BIRTHDATE,
                        RECORD_DATE,				
                        <cfif isDefined('session.ep')>RECORD_MEMBER,<cfelse>RECORD_PAR,</cfif>
                        RECORD_IP,
						RESOURCE_ID
                    )
                    VALUES
                    (
                        <cfqueryparam value="#attributes.company_id#" cfsqltype="cf_sql_integer" >,
                        <cfif len(attributes.username)><cfqueryparam value="#attributes.username#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.password)><cfqueryparam value="#PASS#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.tc_identity") and len(attributes.tc_identity)><cfqueryparam value="#attributes.tc_identity#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,   
                        <cfqueryparam value="#attributes.name#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#attributes.soyad#" cfsqltype="cf_sql_varchar">,
                        <cfif len(attributes.title)><cfqueryparam value="#attributes.title#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfqueryparam value="#attributes.sex#" cfsqltype="cf_sql_integer">,
                        <cfif len(attributes.department)><cfqueryparam value="#attributes.department#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfif len(attributes.email)><cfqueryparam value="#attributes.email#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.partner_kep_adress)><cfqueryparam value="#attributes.partner_kep_adress#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.imcat_id) and attributes.imcat_id neq 0><cfqueryparam value="#attributes.imcat_id#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfif len(attributes.im)><cfqueryparam value="#attributes.im#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.imcat2_id") and attributes.imcat2_id neq 0><cfqueryparam value="#attributes.imcat2_id#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.im2") and len(attributes.im2)><cfqueryparam value="#attributes.im2#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.mobilcat_id)><cfqueryparam value="#attributes.mobilcat_id#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.mobiltel)><cfqueryparam value="#attributes.mobiltel#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.telcod)><cfqueryparam value="#attributes.telcod#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.tel)><cfqueryparam value="#attributes.tel#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.tel_local)><cfqueryparam value="#attributes.tel_local#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.fax)><cfqueryparam value="#attributes.fax#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.homepage)><cfqueryparam value="#attributes.homepage#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.mission)><cfqueryparam value="#attributes.mission#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfqueryparam value="#attributes.language_id#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#listfirst(attributes.compbranch_id,';')#" cfsqltype="cf_sql_integer">,
                        <cfif isdefined('attributes.send_finance_mail')>1<cfelse>0</cfif>,
                        <cfif isdefined('attributes.send_earchive_mail')>1<cfelse>0</cfif>,
                        <cfif len(attributes.photo)><cfqueryparam value="#file_name#.#cffile.serverfileext#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif len(attributes.photo)><cfqueryparam value="#fusebox.server_machine#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfqueryparam value="#adres#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#attributes.postcod#" cfsqltype="cf_sql_varchar">,
                        <cfif len(attributes.county_id)><cfqueryparam value="#attributes.county_id#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfif len(attributes.city_id)><cfqueryparam value="#attributes.city_id#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfif len(attributes.country)><cfqueryparam value="#attributes.country#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfif len(attributes.semt)><cfqueryparam value="#attributes.semt#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.district_id") and Len(attributes.district_id)><cfqueryparam value="#attributes.district_id#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.start_date") and len(attributes.start_date)><cfqueryparam value="#attributes.start_date#" cfsqltype="cf_sql_date"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.hier_partner_id") and len(attributes.hier_partner_id)><cfqueryparam value="#attributes.hier_partner_id#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.related_consumer_id") and Len(attributes.related_consumer_id)><cfqueryparam value="#attributes.related_consumer_id#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        1,
                        <cfif isDefined('attributes.pdks_number') and len(attributes.pdks_number)><cfqueryparam value="#attributes.pdks_number#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
                        <cfif isDefined('attributes.pdks_type_id') and len(attributes.pdks_type_id)><cfqueryparam value="#attributes.pdks_type_id#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.birthdate") and len(attributes.birthdate)><cfqueryparam value="#attributes.birthdate#" cfsqltype="cf_sql_date"><cfelse>NULL</cfif>,
                        <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                        <cfif isDefined('session.ep')><cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer"><cfelseif isDefined('session.pp')><cfqueryparam value="#session.pp.userid#" cfsqltype="cf_sql_integer"><cfelse><cfqueryparam value="#session.pda.userid#" cfsqltype="cf_sql_integer"></cfif>,                        			
                        <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">,
						<cfif isdefined('arguments.resource') and len(arguments.resource)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.resource#"><cfelse>NULL</cfif>
                    )				
                </cfquery>
                
                <cfquery name="GET_MAX_PARTNER" datasource="#this.dsn#">
                    SELECT MAX(PARTNER_ID) AS MAX_PART FROM COMPANY_PARTNER
                </cfquery>
                
        		<cfif isdefined('session.pda')>
                    <cfquery name="GET_MENU_ID" datasource="#DSN#">
                        SELECT MENU_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">
                    </cfquery>
                </cfif>
                
                <cfif not isdefined('session.ep')>
					<!--- domain yazılıyor --->
                    <cfquery name="GET_SITE_DOMAIN" datasource="#DSN#">
                        INSERT INTO
                            COMPANY_CONSUMER_DOMAINS
                            (
                                PARTNER_ID,
                                <!---SITE_DOMAIN,--->
                                MENU_ID,
                                RECORD_DATE,
                                RECORD_IP
                            )
                            VALUES
                            (
                                <cfqueryparam value="#get_max_partner.max_part#" cfsqltype="cf_sql_integer">,
                                <cfif isdefined('session.pda')><cfqueryparam value="#get_menu_id.menu_id#" cfsqltype="cf_sql_integer"><cfelse><cfqueryparam value="#session.pp.menu_id#" cfsqltype="cf_sql_integer"></cfif>,
                                <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_date">,
                                <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_varchar">
                            )
                    </cfquery>
                    <!------------------------>
        		</cfif>
                
                <cfquery name="UPD_MEMBER_CODE" datasource="#this.dsn#">
                    UPDATE
                        COMPANY_PARTNER
                    SET
                        MEMBER_CODE = <cfqueryparam value="CP#my_result.IDENTITYCOL#" cfsqltype="cf_sql_varchar">
                    WHERE
                        PARTNER_ID = <cfqueryparam value="#my_result.IDENTITYCOL#" cfsqltype="cf_sql_integer">
                </cfquery>                
                
                <cfquery name="get_company_name" datasource="#DSN#">
                    SELECT 
                        TOP 1 CSR.SECTOR_ID,
                        C.FULLNAME 
                    FROM 
                        COMPANY C LEFT JOIN COMPANY_SECTOR_RELATION CSR ON C.COMPANY_ID = CSR.COMPANY_ID
                    WHERE 
                        C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                </cfquery>
                <!--- Adres Defteri --->
                <cf_addressbook
                    design		= "1"
                    type		= "2"
                    type_id		= "#get_max_partner.max_part#"
                    active		= "1"
                    name		= "#attributes.name#"
                    surname		= "#attributes.soyad#"
                    sector_id	= "#ListFirst(get_company_name.SECTOR_ID)#"
                    company_name= "#get_company_name.fullname#"
                    title		= "#attributes.title#"
                    email		= "#attributes.email#"
                    telcode		= "#attributes.telcod#"
                    telno		= "#attributes.tel#"
                    faxno		= "#attributes.fax#"
                    mobilcode	= "#attributes.mobilcat_id#"
                    mobilno		= "#attributes.mobiltel#"
                    web			= "#attributes.homepage#"
                    postcode	= "#attributes.postcod#"
                    address		= "#adres#"
                    semt		= "#attributes.semt#"
                    county_id	= "#attributes.county_id#"
                    city_id		= "#attributes.city_id#"
                    country_id	= "#attributes.country#"
                    kep_address = "#attributes.partner_kep_adress#">
                
                <cfquery name="ADD_PART_SETTINGS" datasource="#this.dsn#">
                    INSERT INTO 
                        MY_SETTINGS_P 
                    (
                        PARTNER_ID,
                        TIME_ZONE,
                        LANGUAGE_ID,
                        MAXROWS,
                        TIMEOUT_LIMIT
                    ) 
                    VALUES 
                    (
                        <cfqueryparam value="#my_result.IDENTITYCOL#" cfsqltype="cf_sql_integer">,
                        <cfif isdefined('session.ep')>2,<cfelse>0,</cfif>
                        <cfqueryparam value="#language_id#" cfsqltype="cf_sql_varchar">,
                        20,
                        30
                    )
                </cfquery>
                
				<cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#this.dsn#">
                    INSERT INTO
                        COMPANY_PARTNER_DETAIL
                    (
                        PARTNER_ID
                    )
                    VALUES
                    (
                        <cfqueryparam value="#my_result.IDENTITYCOL#" cfsqltype="cf_sql_integer">
                    )
                </cfquery>

            </cftransaction>
        </cflock>
              
		<cfreturn my_result.IDENTITYCOL>
	</cffunction>
    
</cfcomponent>
