<!--- Kurumsal Uye Aktarimi, Dosyadan Uye aktarimi icin yapildi,
	Ilce alanı int olduğundan bulunması cok zor o yuzden semt e yaziliyor
--->
<cfquery name="GET_CITY_NAME_ALL" datasource="#DSN#">
	SELECT CITY_NAME,CITY_ID, COUNTRY_ID FROM SETUP_CITY
</cfquery>
<cfquery name="GET_COUNTY_NAME_ALL" datasource="#DSN#">
	SELECT COUNTY_NAME,COUNTY_ID,CITY FROM SETUP_COUNTY
</cfquery>
<cfquery name="GET_DISTRICT_NAME_ALL" datasource="#DSN#">
	SELECT DISTRICT_ID,DISTRICT_NAME,COUNTY_ID FROM SETUP_DISTRICT
</cfquery>
<!--- <cfquery name="GET_SECTOR_ALL" datasource="#dsn#">
	SELECT SECTOR_CAT_ID, SECTOR_CAT FROM SETUP_SECTOR_CATS
</cfquery> --->
<cfquery name="GET_PARTNER_POSITION_ALL" datasource="#DSN#">
	SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION
</cfquery>
<cfquery name="GET_DEP_ALL" datasource="#DSN#">
	SELECT PARTNER_DEPARTMENT_ID,PARTNER_DEPARTMENT FROM SETUP_PARTNER_DEPARTMENT
</cfquery>
<!---<cfquery name="GET_VOCATION_TYPE_ALL" datasource="#DSN#">
	SELECT VOCATION_TYPE_ID,VOCATION_TYPE FROM SETUP_VOCATION_TYPE
</cfquery>--->
<cfif not DirectoryExists("#file_web_path#temp")>
	<cfdirectory action="create" directory="#file_web_path#temp#dir_seperator#">
</cfif>
<cfset upload_folder_ = "#file_web_path#temp#dir_seperator#">

<cftry>
	<cffile action = "upload" 
			filefield = "uploaded_file" 
			destination = "#upload_folder_#"
			nameconflict = "MakeUnique"  
			mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
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
		alert("<cf_get_lang_main no='1653.Dosya Okunamadı Karakter Seti Yanlış Seçilmiş Olabilir'>.");
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
    <cftry>
        <cfset comp_nick_name = trim(listgetat(dosya[i],1,';'))>
        <cfset comp_name = trim(listgetat(dosya[i],2,';'))>
        <cfset comp_addres = trim(listgetat(dosya[i],3,';'))>
        
        <cfset comp_county_id = trim(listgetat(dosya[i],4,';'))>
        <cfset comp_city = trim(listgetat(dosya[i],5,';'))>
        <cfset comp_county = trim(listgetat(dosya[i],6,';'))>
        <cfset district_id = trim(listgetat(dosya[i],7,';'))>
        <cfset comp_country = trim(listgetat(dosya[i],8,';'))>
        <cfset comp_tel_code = trim(listgetat(dosya[i],9,';'))>
        <cfset comp_tel_1 = trim(listgetat(dosya[i],10,';'))>
        <cfset comp_tel_2 = trim(listgetat(dosya[i],11,';'))>
        <cfset comp_tel_3 = trim(listgetat(dosya[i],12,';'))>
        <cfset comp_fax = trim(listgetat(dosya[i],13,';'))>
        <cfset comp_email = trim(listgetat(dosya[i],14,';'))>
        <cfset homepage = trim(listgetat(dosya[i],15,';'))>
        <cfset mobil_code = trim(listgetat(dosya[i],16,';'))>
        <cfset mobiltel = trim(listgetat(dosya[i],17,';'))>
        <cfset sales_county = trim(listgetat(dosya[i],18,';'))>
        <cfset ims_code_id = trim(listgetat(dosya[i],19,';'))>
        <cfset resource_id = trim(listgetat(dosya[i],20,';'))>
        <cfset comp_stage_id = trim(listgetat(dosya[i],21,';'))>
        <cfset companycat_id = trim(listgetat(dosya[i],22,';'))>
        <cfset our_company_id_ = trim(listgetat(dosya[i],23,';'))>
        <cfset tax_office = trim(listgetat(dosya[i],24,';'))>
        <cfset tax_no = trim(listgetat(dosya[i],25,';'))>
        <cfset sector = trim(listgetat(dosya[i],26,';'))>
        <cfset sex = trim(listgetat(dosya[i],27,';'))>
        <cfset name = trim(listgetat(dosya[i],28,';'))>
        <cfset surname = trim(listgetat(dosya[i],29,';'))>
        <cfset position = trim(listgetat(dosya[i],30,';'))>
        <cfset department = trim(listgetat(dosya[i],31,';'))>
        <cfset per_email = trim(listgetat(dosya[i],32,';'))>
        <cfset tel_code = trim(listgetat(dosya[i],33,';'))>
        <cfset tel = trim(listgetat(dosya[i],34,';'))>
        <cfset company_partner_tel_ext = trim(listgetat(dosya[i],35,';'))>
        <cfset mobil_tel_code = trim(listgetat(dosya[i],36,';'))>
        <cfset mobil_tel = trim(listgetat(dosya[i],37,';'))>
        <cfset home_addres = trim(listgetat(dosya[i],38,';'))>
        <cfset home_code = trim(listgetat(dosya[i],39,';'))>
        <cfset home_post_code = trim(listgetat(dosya[i],40,';'))>
        <cfset home_tel = trim(listgetat(dosya[i],41,';'))>
        <cfset home_county = trim(listgetat(dosya[i],42,';'))>
        <cfset home_county_id = trim(listgetat(dosya[i],43,';'))>
        <cfset home_city = trim(listgetat(dosya[i],44,';'))>
        <cfset home_country = trim(listgetat(dosya[i],45,';'))>
        <cfset company_value_id = trim(listgetat(dosya[i],46,';'))>
        <cfset tc_identy_no = trim(listgetat(dosya[i],47,';'))>
        <cfset member_note_head = trim(listgetat(dosya[i],48,';'))>
        <cfset member_note = trim(listgetat(dosya[i],49,';'))>
        <cfset member_note_head_2 = trim(listgetat(dosya[i],50,';'))>
        <cfset member_note_2 = trim(listgetat(dosya[i],51,';'))>
        <cfset member_date = trim(listgetat(dosya[i],52,';'))>
        <cfset member_code = trim(listgetat(dosya[i],53,';'))>
        <cfset agent_id = trim(listgetat(dosya[i],54,';'))>
        <cfset special_code = trim(listgetat(dosya[i],55,';'))>
        <cfset special_code_1 = trim(listgetat(dosya[i],56,';'))>
        <cfif (listlen(dosya[i],';') gte 57)>
            <cfset special_code_2 = trim(listgetat(dosya[i],57,';'))>
        <cfelse>
            <cfset special_code_2 = ''>
        </cfif>
        <cfif (listlen(dosya[i],';') gte 58)>
            <cfset comp_kep_address = trim(listgetat(dosya[i],58,';'))>
        <cfelse>
            <cfset comp_kep_address = ''>
        </cfif>
        <cfcatch type="Any">
            <cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
            <cfset error_flag = 1>
            <script>
                window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_member_import</cfoutput>";
            </script>
        </cfcatch>  
    </cftry>
	<cfif len(companycat_id) and isNumeric(companycat_id)>		
		<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
			SELECT
				COMPANYCAT_ID
			FROM 
				GET_MY_COMPANYCAT
			WHERE 
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
				COMPANYCAT_ID IN (#companycat_id#) 
			ORDER BY COMPANYCAT
		</cfquery>
	<cfelse>
		<cfset get_companycat.companycat_id = ''>
	</cfif>
	<cfif len(comp_stage_id) and isNumeric(comp_stage_id)>		
		<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
			SELECT PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#comp_stage_id#)
		</cfquery>
	<cfelse>
		<cfset get_process_stage.process_row_id = ''>
	</cfif>
	<cfif len(comp_nick_name) and len(comp_name) and len(name) and len(surname)>
		<cfquery name="GET_COMP" datasource="#DSN#">
			SELECT COMPANY_ID FROM COMPANY WHERE FULLNAME = '#comp_name#' AND NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_nick_name#">
		</cfquery>
		<cfif len(member_code)>
			<cfquery name="GET_MEMBER_CODE_COMPANY" datasource="#DSN#">
				SELECT 
                	MEMBER_CODE 
                FROM 
                	COMPANY 
                WHERE 
                	MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> OR 
                    MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="C#member_code#">
			</cfquery>
		<cfelse>
			<cfset get_member_code_company.recordcount = 0>	
		</cfif>
		<cftry>
		<cfif get_member_code_company.recordcount eq 0 <!---or not len(get_member_code_company.member_code)--->>
			<cfif (len(tax_no) eq 0) or (len(tax_no) eq 10)>
                <cfif get_comp.recordcount eq 0>
                    <cfif len(comp_country) and isnumeric(comp_country)>
                        <cfif len(comp_city) and isnumeric(comp_city)>
                            <cfquery name="GET_CITY_NAME" dbtype="query">
                                SELECT
                                    CITY_ID,
                                    COUNTRY_ID
                                FROM
                                    GET_CITY_NAME_ALL
                                WHERE
                                    CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#comp_city#"> AND
                                    COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#comp_country#">
                            </cfquery>
                            <cfif len(comp_county_id) and isnumeric(comp_county_id)>
                                <cfquery name="GET_COUNTY_NAME" dbtype="query">
                                    SELECT
                                        COUNTY_ID
                                    FROM
                                        GET_COUNTY_NAME_ALL
                                    WHERE
                                        COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#comp_county_id#"> AND
                                        CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#comp_city#">
                                </cfquery>
                                <cfset comp_county_id_ = get_county_name.county_id>
                                <cfif len(district_id) and isnumeric(district_id)>
                                    <cfquery name="GET_DISTRICT_NAME" dbtype="query">
                                        SELECT
                                            DISTRICT_ID
                                        FROM
                                            GET_DISTRICT_NAME_ALL
                                        WHERE
                                            DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#district_id#"> AND
                                            COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#comp_county_id#">
                                    </cfquery>
                                    <cfset comp_district_id = get_district_name.district_id>
                                <cfelse>
                                    <cfset comp_district_id = "">
                                </cfif>
                            <cfelse>
                                <cfset comp_county_id_ = "">
                                <cfset comp_district_id = "">
                            </cfif>
                            <cfset comp_city_ = get_city_name.city_id>
                        <cfelse>
                            <cfset comp_city_ = "">
                            <cfset comp_county_id_ = "">
                            <cfset comp_district_id = "">
                        </cfif>
                    <cfelse>
                        <cfset comp_city_ = "">
                        <cfset comp_county_id_ = "">
                        <cfset comp_district_id = "">
                    </cfif>
                    <cfif len(member_date)><cf_date tarih='member_date'></cfif>
                    <cfif len(get_companycat.companycat_id)>
                    	<cfif len(get_process_stage.PROCESS_ROW_ID)>
                            <cfquery name="GET_COMP_PARTNER" datasource="#DSN#">
                                SELECT 	
                                    COMPANY_PARTNER.PARTNER_ID 
                                FROM 
                                    COMPANY_PARTNER,
                                    COMPANY
                                WHERE 
                                    COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
                                    COMPANY.NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_nick_name#"> AND
                                    COMPANY_PARTNER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#"> AND
                                    COMPANY_PARTNER_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#surname#">
                            </cfquery>
                            <cfif get_comp_partner.recordcount eq 0>
                                <cfquery name="ADD_COMPANY" datasource="#DSN#">
                                    INSERT INTO 
                                        COMPANY
                                        (
                                            COMPANY_STATUS,
                                            COMPANYCAT_ID,
                                            PERIOD_ID,
                                            NICKNAME,
                                            FULLNAME,
                                            COMPANY_EMAIL,
                                            COMPANY_TELCODE,
                                            COMPANY_TEL1,
                                            COMPANY_TEL2,
                                            COMPANY_TEL3,
                                            COMPANY_FAX,
                                            COMPANY_ADDRESS,
                                            TAXOFFICE,
                                            TAXNO,
                                            COUNTY,
                                            CITY,
                                            COUNTRY,
                                            ISPOTANTIAL,
                                            RECORD_EMP,
                                            RECORD_IP,
                                            RECORD_DATE,
                                            SEMT,
                                            DISTRICT_ID,
                                            COMPANY_STATE,
                                            OZEL_KOD,
                                            OZEL_KOD_1,
                                            OZEL_KOD_2,
                                            START_DATE,
                                            HOMEPAGE,
                                            MOBIL_CODE,
                                            MOBILTEL,
                                            SALES_COUNTY,
                                            RESOURCE_ID,
                                            OUR_COMPANY_ID,
                                            IMS_CODE_ID,
                                            COMPANY_VALUE_ID,
                                            IS_PERSON,
                                            COMPANY_KEP_ADDRESS
                                        )
                                        VALUES
                                        (
                                            <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
                                            <cfif len(get_companycat.companycat_id)>#get_companycat.companycat_id#</cfif>,
                                            #attributes.period_id#,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_nick_name#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_name#">,
                                            <cfif len(comp_email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(comp_email)#"><cfelse>NULL</cfif>,
                                            <cfif len(comp_tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_tel_code#"><cfelse>NULL</cfif>,
                                            <cfif len(comp_tel_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_tel_1#"><cfelse>NULL</cfif>,
                                            <cfif len(comp_tel_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_tel_2#"><cfelse>NULL</cfif>,
                                            <cfif len(comp_tel_3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_tel_3#"><cfelse>NULL</cfif>,
                                            <cfif len(comp_fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_fax#"><cfelse>NULL</cfif>,
                                            <cfif len(comp_addres)><cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_addres#"><cfelse>NULL</cfif>,
                                            <cfif len(tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_office#"><cfelse>NULL</cfif>,
                                            <cfif len(tax_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_no#"><cfelse>NULL</cfif>,
                                            <cfif len(comp_county_id_)>#comp_county_id_#<cfelse>NULL</cfif>,
                                            <cfif len(comp_city_)>#comp_city_#<cfelse>NULL</cfif>,
                                            <cfif len(comp_country)>#comp_country#<cfelse>NULL</cfif>,
                                            <cfif isdefined("attributes.ispotential")>1<cfelse>0</cfif>,
                                            #session.ep.userid#,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
                                            #NOW()#,
                                            <cfif len(comp_county)><cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_county#"><cfelse>NULL</cfif>,
                                            <cfif len(comp_district_id)>#comp_district_id#<cfelse>NULL</cfif>,
                                            <cfif len(get_process_stage.PROCESS_ROW_ID)>#get_process_stage.process_row_id#</cfif>,
                                            <cfif isdefined('special_code') and len(special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code#"><cfelse>NULL</cfif>,
                                            <cfif isdefined('special_code_1') and len(special_code_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_1#"><cfelse>NULL</cfif>,
                                            <cfif isdefined('special_code_2') and len(special_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_2#"><cfelse>NULL</cfif>,
                                            <cfif len(member_date)>#member_date#<cfelse>NULL</cfif>,
                                            <cfif len(homepage)><cfqueryparam cfsqltype="cf_sql_varchar" value="#homepage#"><cfelse>NULL</cfif>,
                                            <cfif isdefined('mobil_code') and len(mobil_code) and isnumeric(mobil_code)>#mobil_code#<cfelse>NULL</cfif>,
                                            <cfif len(mobiltel) and isnumeric(mobiltel)>#mobiltel#<cfelse>NULL</cfif>,
                                            <cfif len(sales_county) and isnumeric(sales_county)>#sales_county#<cfelse>NULL</cfif>,
                                            <cfif len(resource_id) and isnumeric(resource_id)>#resource_id#<cfelse>NULL</cfif>,
                                            <cfif len(our_company_id_) and isnumeric(our_company_id_)>#our_company_id_#<cfelse>NULL</cfif>,
                                            <cfif len(ims_code_id) and isnumeric(ims_code_id)>#ims_code_id#<cfelse>NULL</cfif>,
                                            <cfif len(company_value_id) and isnumeric(company_value_id)>#company_value_id#<cfelse>NULL</cfif>,
                                            <cfif isdefined('tc_identy_no') and len(tc_identy_no) and not len(tax_no)>1<cfelse>0</cfif>,
                                            <cfif isdefined('comp_kep_address') and len(comp_kep_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(comp_kep_address)#"><cfelse>NULL</cfif>
                                        )
                                </cfquery>
                            </cfif>                            
                        <cfelse>
                        	<cfset liste=ListAppend(liste,#i#&'. Belirttiğiniz Aşama Sistemde Tanımlı Değil',',')>
                        </cfif>
                    <cfelse>
                    	<cfset liste=ListAppend(liste,i&'. Üye Kategorisi Sistemde Tanımlı Değil ',',')>
                    </cfif>
                    <cfquery name="GET_MAX" datasource="#DSN#">
                        SELECT MAX(COMPANY_ID) AS MAX_COMPANY FROM COMPANY
                    </cfquery>
                    <cfif len(sector)>
                        <cfquery name="ADD_COMP_SECTOR" datasource="#DSN#">
                            INSERT INTO 
                                COMPANY_SECTOR_RELATION
                            (
                                SECTOR_ID,
                                COMPANY_ID
                            )
                            VALUES
                            (
                                #sector#,
                                #get_max.max_company#
                            )
                        </cfquery>
                    </cfif>
                    <!--- uye temsilci FA--->
                    <cfif len(agent_id)>
                        <cfquery name="GET_POS_CODE" datasource="#DSN#">
                            SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#agent_id#">
                        </cfquery>
                        <cfif len(get_pos_code.position_code)>
                            <cfquery name="ADD_WORK_MEMBER" datasource="#DSN#">
                                INSERT INTO
                                    WORKGROUP_EMP_PAR
                                (
                                    COMPANY_ID,
                                    OUR_COMPANY_ID,
                                    POSITION_CODE,
                                    IS_MASTER,
                                    RECORD_EMP,
                                    RECORD_IP,
                                    RECORD_DATE
                                )
                                VALUES
                                (
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                                    <cfif len(get_pos_code.position_code)></cfif><cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos_code.position_code#">,
                                    1,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                )
                            </cfquery>
                        </cfif>
                    </cfif>
    
                    <!--- uye iliskili not --->
                    <cfif len(member_note_head) and len(member_note)>
                        <cfquery name="ADD_NOTE" datasource="#DSN#">
                            INSERT INTO 
                                NOTES
                            (
                                ACTION_SECTION,
                                ACTION_ID,
                                NOTE_HEAD,
                                NOTE_BODY,
                                IS_SPECIAL,
                                IS_WARNING,
                                COMPANY_ID,
                                RECORD_EMP,
                                RECORD_DATE,
                                RECORD_IP
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="COMPANY_ID">,
                                #GET_MAX.MAX_COMPANY#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_note_head#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_note#">,
                                0,
                                0,
                                #session.ep.company_id#,
                                #session.ep.userid#,
                                #now()#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                            )
                        </cfquery>
                    </cfif>
                    <cfif len(member_note_head_2) and len(member_note_2)>
                        <cfquery name="ADD_NOTE" datasource="#DSN#">
                            INSERT INTO 
                                NOTES
                            (
                                ACTION_SECTION,
                                ACTION_ID,
                                NOTE_HEAD,
                                NOTE_BODY,
                                IS_SPECIAL,
                                IS_WARNING,
                                COMPANY_ID,
                                RECORD_EMP,
                                RECORD_DATE,
                                RECORD_IP
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="COMPANY_ID">,
                                #get_max.max_company#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_note_head_2#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_note_2#">,
                                0,
                                0,
                                #session.ep.company_id#,
                                #session.ep.userid#,
                                #now()#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                            )
                        </cfquery>
                    </cfif>
                    <!---// uye iliskili not --->
                    <cfif len(attributes.location)>
                        <cfquery name="ADD_COMP_BRANCH_RELATED" datasource="#DSN#">
                            INSERT INTO
                                COMPANY_BRANCH_RELATED
                            (
                                COMPANY_ID,
                                OUR_COMPANY_ID,
                                BRANCH_ID,
                                OPEN_DATE,
                                RECORD_IP,
                                RECORD_EMP
                            )
                            VALUES
                            (
                                #get_max.max_company#,
                                #ListGetAt(attributes.location,1,',')#,
                                #ListGetAt(attributes.location,3,',')#,
                                #NOW()#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
                                #SESSION.EP.USERID#
                            )
                        </cfquery>
                    </cfif>
                    <cfquery name="ADD_COMP_PERIOD" datasource="#DSN#">
                        INSERT INTO
                            COMPANY_PERIOD
                        (
                            COMPANY_ID,
                            PERIOD_ID
                        )
                        VALUES
                        (
                            #get_max.max_company#,
                            #attributes.period_id#
                        )
                    </cfquery>
                    <cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
                        UPDATE 
                            COMPANY 
                        SET		
                            MEMBER_CODE = <cfif len(member_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="C#GET_MAX.MAX_COMPANY#"></cfif>
                        WHERE 
                            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">
                    </cfquery>	
                    <cfif len(name) and len(surname)>
                        <cfif get_comp.recordcount><cfset get_max.max_company=get_comp.company_id></cfif>
                        <cfquery name="GET_COMP_PARTNER" datasource="#DSN#">
                            SELECT 	
                                COMPANY_PARTNER.PARTNER_ID 
                            FROM 
                                COMPANY_PARTNER,
                                COMPANY
                            WHERE 
                                COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
                                COMPANY.NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#comp_nick_name#"> AND
                                COMPANY_PARTNER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#"> AND
                                COMPANY_PARTNER_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#surname#">
                        </cfquery>
                        <cfif get_comp_partner.recordcount eq 0>
                            <cfif len(position)>
                                <cfquery name="GET_PARTNER_POSITION" dbtype="query">
                                    SELECT PARTNER_POSITION_ID, PARTNER_POSITION FROM GET_PARTNER_POSITION_ALL WHERE PARTNER_POSITION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#position#">
                                </cfquery>
                            <cfelse>
                                <cfset get_partner_position.partner_position_id=''>
                            </cfif>
                            <cfif len(home_city)>
                                <cfquery name="GET_HOME_CITY_NAME" dbtype="query">
                                    SELECT
                                        CITY_ID,
                                        COUNTRY_ID
                                    FROM
                                        GET_CITY_NAME_ALL
                                    WHERE
                                        <cfif isNumeric(home_city)>
                                            CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#home_city#">
                                        <cfelse>
                                            CITY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#home_city#">
                                        </cfif>
                                </cfquery>
                                <cfif len(home_county_id)>
                                    <cfquery name="GET_COUNTY_NAME" dbtype="query">
                                        SELECT
                                            COUNTY_ID
                                        FROM
                                            GET_COUNTY_NAME_ALL
                                        WHERE
                                            <cfif isNumeric(home_county_id)>
                                                COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#home_county_id#">
                                            <cfelse>
                                                COUNTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#home_county_id#">
                                            </cfif>
                                    </cfquery>
                                    <cfset home_county_id = get_county_name.county_id>
                                <cfelse>
                                    <cfset home_county_id = "">
                                </cfif>
                                <cfset home_city = get_home_city_name.city_id>
                                <cfset home_country = get_home_city_name.country_id>
                            <cfelse>
                                <cfset home_city = "">
                                <cfset home_country = "">
                            </cfif>
                            <cfif len(trim(department)) and isNumeric(department)>
                                <cfquery name="GET_DEP" dbtype="query">
                                    SELECT PARTNER_DEPARTMENT_ID,PARTNER_DEPARTMENT FROM GET_DEP_ALL WHERE PARTNER_DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department#">
                                </cfquery>
                            <cfelse>
                                <cfset get_dep.partner_department_id = ''>				
                            </cfif>
                            <cfquery name="ADD_PARTNER" datasource="#DSN#">
                                INSERT INTO 
                                    COMPANY_PARTNER 
                                    (
                                        COMPANY_ID,
                                        COMPANY_PARTNER_NAME,
                                        COMPANY_PARTNER_SURNAME,
                                        TITLE,
                                        SEX,
                                        MOBIL_CODE,
                                        MOBILTEL,
                                        COMPANY_PARTNER_TELCODE,
                                        COMPANY_PARTNER_TEL,
                                        MISSION,
                                        COMPANY_PARTNER_EMAIL,
                                        COMPANY_PARTNER_ADDRESS,
                                        COMPANY_PARTNER_POSTCODE,
                                        COUNTY,
                                        CITY,
                                        COUNTRY,
                                        SEMT,
                                        DEPARTMENT,
                                        TC_IDENTITY,
                                        WANT_EMAIL,
                                        RECORD_DATE,
                                        MEMBER_TYPE,
                                        RECORD_MEMBER,
                                        RECORD_IP,
                                        COMPANY_PARTNER_TEL_EXT
                                    )
                                VALUES
                                    (
                                        #GET_MAX.MAX_COMPANY#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#surname#">,
                                        <cfif len(position)><cfqueryparam cfsqltype="cf_sql_varchar" value="#position#"><cfelse>NULL</cfif>,
                                        <cfif sex eq 'Bayan' or sex eq 0>2<cfelse>1</cfif>,
                                        <cfif len(mobil_tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#mobil_tel_code#"><cfelse>NULL</cfif>,
                                        <cfif len(mobil_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#mobil_tel#"><cfelse>NULL</cfif>,
                                        <cfif len(tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tel_code#"><cfelse>NULL</cfif>,
                                        <cfif len(tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tel#"><cfelse>NULL</cfif>,
                                        <cfif len(get_partner_position.partner_position_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_partner_position.partner_position_id#"><cfelse>NULL</cfif>,
                                        <cfif len(per_email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#per_email#"><cfelse>NULL</cfif>,
                                        <cfif len(home_addres)><cfqueryparam cfsqltype="cf_sql_varchar" value="#home_addres#"><cfelse>NULL</cfif>,
                                        <cfif len(home_post_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#home_post_code#"><cfelse>NULL</cfif>,
                                        <cfif len(home_county_id)>#home_county_id#<cfelse>NULL</cfif>,
                                        <cfif len(home_city)>#home_city#<cfelse>NULL</cfif>,
                                        <cfif len(home_country)>#home_country#<cfelse>NULL</cfif>,
                                        <cfif len(home_county)><cfqueryparam cfsqltype="cf_sql_varchar" value="#home_county#"><cfelse>NULL</cfif>,
                                        <cfif len(get_dep.partner_department_id)>#get_dep.partner_department_id#<cfelse>NULL</cfif>,
                                        <cfif isdefined('tc_identy_no') and len(tc_identy_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(tc_identy_no,11)#"><cfelse>NULL</cfif>,
                                        1,
                                        #NOW()#,
                                        1,
                                        #session.ep.userid#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
                                        <cfif isdefined('company_partner_tel_ext') and len(company_partner_tel_ext)><cfqueryparam cfsqltype="cf_sql_varchar" value="#company_partner_tel_ext#"><cfelse>NULL</cfif>
                                    )
                            </cfquery>
                            <cfquery name="GET_MAXPARTNER" datasource="#DSN#">
                                SELECT MAX(PARTNER_ID) MAX_PARTNER_ID FROM COMPANY_PARTNER
                            </cfquery>
                            <cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
                                UPDATE 
                                    COMPANY_PARTNER 
                                SET 
                                    MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="CP#get_maxpartner.max_partner_id#">
                                WHERE 
                                    PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_maxpartner.max_partner_id#">
                            </cfquery>
                            <cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#DSN#">
                                INSERT INTO
                                    COMPANY_PARTNER_DETAIL
                                    (
                                        PARTNER_ID,
                                        HOMETELCODE,
                                        HOMETEL
                                    )
                                    VALUES
                                    (
                                        #get_maxpartner.max_partner_id#,
                                        <cfif len(home_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#home_code#"><cfelse>NULL</cfif>,
                                        <cfif len(home_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#home_tel#"><cfelse>NULL</cfif>
                                    )
                            </cfquery>
                            <cfquery name="ADD_PART_SETTINGS" datasource="#DSN#">
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
                                            #get_maxpartner.max_partner_id#,
                                            0,
                                            20,
                                            30
                                        )
                            </cfquery>
    
                            
                            
                            <!--- Adres Defteri --->
                            <cf_addressbook
                                design		= "1"
                                type		= "2"
                                type_id		= "#get_maxpartner.max_partner_id#"
                                active		= "1"
                                name		= "#name#"
                                surname		= "#surname#"
                                sector_id	= "#ListFirst(sector)#"
                                company_name= "#comp_name#"
                                title		= "#position#"
                                email		= "#per_email#"
                                telcode		= "#tel_code#"
                                telno		= "#tel#"
                                faxno		= "#comp_fax#"
                                mobilcode	= "#mobil_tel_code#"
                                mobilno		= "#mobil_tel#"
                                postcode	= "#home_post_code#"
                                address		= "#home_addres#"
                                semt		= "#home_county#"
                                county_id	= "#home_county_id#"
                                city_id		= "#home_city#"
                                country_id	= "#home_country#">
            
                            
                            <cfif not get_comp.recordcount>
                                <cfquery name="UPD_MANAGER_PARTNER" datasource="#DSN#">
                                    UPDATE
                                        COMPANY
                                    SET
                                        MANAGER_PARTNER_ID = #get_maxpartner.max_partner_id#
                                    WHERE
                                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">
                                </cfquery>
                            </cfif>
                        <cfelse>
                            <cfset liste=ListAppend(liste,i&'. Satırdaki Kurumsal Üye Sistemde Kayıtlı',',')>
                        </cfif>
                    <cfelse>
                        <cfset liste=ListAppend(liste,i&'. Satırdaki Ad Soyad Bilgileri Eksik',',')>				
                    </cfif>
                <cfelse>
                    <cfset liste=ListAppend(liste,i&'. Satırdaki Kurumsal Üye Sistemde Kayıtlı',',')>                
                </cfif>
                <cfset counter = counter + 1>
            <cfelse>
                <cfset liste=ListAppend(liste,i&'. Vergi Numarası 10 Haneli Olmalıdır!',',')>
            </cfif>
		<cfelse>
			<cfset liste=ListAppend(liste,i&'. Satırdaki Üye Kodu Sistemde Mevcut!',',')>
		</cfif>    
		<cfcatch type="any">
			<cfset liste=ListAppend(liste,i&'. Satırda Yazma İşlemi Sırasında Hata Oldu ',',')>
		</cfcatch> 
		</cftry>
	<cfelse>
		<cfset liste=ListAppend(liste,#i#&'. Satırda Üye İsim Bilgileri Eksik',',')>
	</cfif>
</cfloop>
<cfoutput>
	<cfif listlen(liste,',') gt 0>
		&nbsp;#listlen(liste,',')# Kayıtta Sorun Oluştu. <br/>
		Sorunlu Kayıtlar Aşağıdaki Gibidir, Lütfen Kontrol Ediniz :<br/><br/>
		<cfloop list="#liste#" index="i">&nbsp;#i#,<br/></cfloop>
		<br/>
	<cfelse>
		&nbsp; Sorunsuz Kayıt Yapıldı !!!
	</cfif>
</cfoutput>
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_member_import</cfoutput>";
</script>
