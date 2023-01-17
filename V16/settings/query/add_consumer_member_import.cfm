<!--- Bireysel Uye Aktarim Query si  hgul20111010--->
<cfquery name="GET_CITY_NAME_ALL" datasource="#DSN#">
	SELECT CITY_NAME,CITY_ID, COUNTRY_ID FROM SETUP_CITY
</cfquery>
<cfquery name="GET_COUNTY_NAME_ALL" datasource="#DSN#">
	SELECT COUNTY_NAME,COUNTY_ID,CITY FROM SETUP_COUNTY
</cfquery>
<cfquery name="GET_DISTRICT_NAME_ALL" datasource="#DSN#">
	SELECT DISTRICT_ID,DISTRICT_NAME,COUNTY_ID FROM SETUP_DISTRICT
</cfquery>
<cfquery name="GET_SECTOR_ALL" datasource="#DSN#">
	SELECT SECTOR_CAT_ID, SECTOR_CAT FROM SETUP_SECTOR_CATS
</cfquery>
<cfquery name="GET_PARTNER_POSITION_ALL" datasource="#DSN#">
	SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION
</cfquery>
<cfquery name="GET_DEP_ALL" datasource="#DSN#">
	SELECT PARTNER_DEPARTMENT_ID,PARTNER_DEPARTMENT FROM SETUP_PARTNER_DEPARTMENT
</cfquery>
<cfquery name="GET_SOCIETIES" datasource="#DSN#">
	SELECT SOCIETY_ID, SOCIETY FROM SETUP_SOCIAL_SOCIETY
</cfquery>
<cfquery name="GET_VOCATION_TYPE_ALL" datasource="#DSN#">
	SELECT VOCATION_TYPE_ID,VOCATION_TYPE FROM SETUP_VOCATION_TYPE
</cfquery>
<cfif not DirectoryExists("#upload_folder#temp#dir_seperator#")>
	<cfdirectory action="create" directory="#upload_folder#temp#dir_seperator#">
</cfif>
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
	<cfset kont=1>
	<cftry>
		<cfset name = trim(listgetat(dosya[i],1,';'))>
		<cfset surname = trim(listgetat(dosya[i],2,';'))>
		<cfset consumercat_id = trim(listgetat(dosya[i],3,';'))>
		<cfset Process_cat = trim(listgetat(dosya[i],4,';'))>
		<cfset Tc_Identy_No = trim(listgetat(dosya[i],5,';'))>
		<cfset ozel_kod = trim(listgetat(dosya[i],6,';'))>
		<cfset customer_value = trim(listgetat(dosya[i],7,';'))>
		<cfset home_country = trim(listgetat(dosya[i],8,';'))>
		<cfset home_city_id = trim(listgetat(dosya[i],9,';'))>
		<cfset home_county_id = trim(listgetat(dosya[i],10,';'))>
		<cfset home_semt = trim(listgetat(dosya[i],11,';'))>
		<cfset home_district = trim(listgetat(dosya[i],12,';'))>
		<cfset home_address = trim(listgetat(dosya[i],13,';'))>
		<cfset home_postcode = trim(listgetat(dosya[i],14,';'))>
		<cfset home_telcode = trim(listgetat(dosya[i],15,';'))>
		<cfset home_tel = trim(listgetat(dosya[i],16,';'))>
		<cfset consumer_email = trim(listgetat(dosya[i],17,';'))>
		<cfset Homepage = trim(listgetat(dosya[i],18,';'))>
		<cfset mobil_code = trim(listgetat(dosya[i],19,';'))>
		<cfset mobiltel = trim(listgetat(dosya[i],20,';'))>
		<cfset sex = trim(listgetat(dosya[i],21,';'))>
		<cfset company = trim(listgetat(dosya[i],22,';'))>
		<cfset position = trim(listgetat(dosya[i],23,';'))>
		<cfset department = trim(listgetat(dosya[i],24,';'))>
		<cfset sector = trim(listgetat(dosya[i],25,';'))>
		<cfset vocation = trim(listgetat(dosya[i],26,';'))>
		<cfset work_country = trim(listgetat(dosya[i],27,';'))>
		<cfset work_city_id = trim(listgetat(dosya[i],28,';'))>
		<cfset work_county_id = trim(listgetat(dosya[i],29,';'))>
		<cfset work_semt = trim(listgetat(dosya[i],30,';'))>
		<cfset work_district = trim(listgetat(dosya[i],31,';'))>
		<cfset work_address = trim(listgetat(dosya[i],32,';'))>
		<cfset work_postcode = trim(listgetat(dosya[i],33,';'))>
		<cfset work_telcode = trim(listgetat(dosya[i],34,';'))>
		<cfset work_tel = trim(listgetat(dosya[i],35,';'))>
		<cfset work_faxcode = trim(listgetat(dosya[i],36,';'))>
		<cfset work_fax = trim(listgetat(dosya[i],37,';'))>
		<cfset resource_id = trim(listgetat(dosya[i],38,';'))>
		<cfset tax_office = trim(listgetat(dosya[i],39,';'))>
		<cfset tax_no = trim(listgetat(dosya[i],40,';'))>
		
		<cfset tax_address = trim(listgetat(dosya[i],41,';'))>
		<cfset tax_country = trim(listgetat(dosya[i],42,';'))>
		<cfset tax_city_id = trim(listgetat(dosya[i],43,';'))>
		<cfset tax_county_id = trim(listgetat(dosya[i],44,';'))>
		<cfset tax_semt = trim(listgetat(dosya[i],45,';'))>
		<cfset tax_district = trim(listgetat(dosya[i],46,';'))>
		<cfset tax_address_2 = trim(listgetat(dosya[i],47,';'))>
		<cfset tax_postcode = trim(listgetat(dosya[i],48,';'))>

		<cfset member_note_head = trim(listgetat(dosya[i],49,';'))>
		<cfset member_note = trim(listgetat(dosya[i],50,';'))>
		<cfset member_note_head_2 = trim(listgetat(dosya[i],51,';'))>
		<cfset member_note_2 = trim(listgetat(dosya[i],52,';'))>
		<cfset member_code = trim(listgetat(dosya[i],53,';'))>
		<cfset member_date = trim(listgetat(dosya[i],54,';'))>
		<cfset social_society = trim(listgetat(dosya[i],55,';'))>
		<cfset social_society_no = trim(listgetat(dosya[i],56,';'))>
		<cfset blood_type = trim(listgetat(dosya[i],57,';'))>
		<cfset mother_name = trim(listgetat(dosya[i],58,';'))>
		<cfset father_name = trim(listgetat(dosya[i],59,';'))>
		<cfset sales_county = trim(listgetat(dosya[i],60,';'))>
		<cfif (listlen(dosya[i],';') gte 61)>
			<cfset agent_id = trim(listgetat(dosya[i],61,';'))>
		<cfelse>
			<cfset agent_id = ''>
		</cfif>
		<cfif (listlen(dosya[i],';') gte 62)>
			<cfset consumer_username = trim(listgetat(dosya[i],62,';'))>
		<cfelse>
			<cfset consumer_username = ''>
		</cfif>
        <cfif listlen(dosya[i],';') gte 63 and len(trim(listgetat(dosya[i],63,';')))>
			<cfset consumer_password = trim(listgetat(dosya[i],63,';'))>
            <cf_cryptedpassword password='#consumer_password#' output='PASS' mod=1>
		<cfelse>
			<cfset consumer_password = ''>
		</cfif>
        <cfif (listlen(dosya[i],';') gte 64)>
			<cfset menu_id = trim(listgetat(dosya[i],64,';'))>
		<cfelse>
			<cfset menu_id = ''>
		</cfif>

		<cfif (listlen(dosya[i],';') gte 65)>
			<cfset birthdate = trim(listgetat(dosya[i],65,';'))>
		<cfelse>
			<cfset birthdate = "">
		</cfif>

		<cfset want_email = trim(listgetat(dosya[i],66,';'))>
		<cfset want_sms = trim(listgetat(dosya[i],67,';'))>
		<cfset consumer_status = trim(listgetat(dosya[i],68,';'))>
		<cfif listlen(dosya[i],';') gte 69>
		        <cfset ref_member_code = trim(listgetat(dosya[i],69,';'))>
		<cfelse>
			<cfset ref_member_code = "">
		</cfif>	
		<cfif listlen(dosya[i],';') gte 70>
		        <cfset member_add_option_id = trim(listgetat(dosya[i],70,';'))>
		<cfelse>
			<cfset member_add_option_id = "">
        </cfif>	
        <cfif (listlen(dosya[i],';') gte 71)>
			<cfset kep_address = trim(listgetat(dosya[i],71,';'))>
		<cfelse>
			<cfset kep_address = "">
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
			<cfset error_flag = 1>
		</cfcatch>  
	</cftry>
	<cfif len(name)>
		<cfif len(member_code)>
			<cfquery name="GET_MEMBER_CODE_CONSUMER" datasource="#DSN#">
				SELECT MEMBER_CODE FROM CONSUMER WHERE MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> OR MEMBER_CODE = 'B#member_code#'
			</cfquery>
		<cfelse>
			<cfset get_member_code_consumer.recordcount = 0>
		</cfif>
	<cftry>
		<cfif not get_member_code_consumer.recordcount>
			<cfif len(tc_identy_no) and not isdefined("attributes.is_tcnum_control")><!--- Aynı tc kimlik nolu Bireysel Üyeler İmport Edilebilsin seçeneği seçilmemişse ve Tc kimlik numarası varmı- Varsa tc kimlik noya göre üyelere bak yoksa isim ve soy isime göre üyelere bak --->
				<cfquery name="GET_CONS_INFO" datasource="#DSN#"><!--- Bu bireysel üye varmı --->
					SELECT CONSUMER_ID FROM CONSUMER WHERE TC_IDENTY_NO = '#left(tc_identy_no,11)#'
				</cfquery>
			<cfelse>
				<cfif not isdefined("attributes.is_consumer_name_control")><!--- Aynı İsimli Bireysel Üyeler İmport Edilebilsin seçeneği seçilmemişse aynı isimli var mı diye kontrol ediyor --->
					<cfquery name="GET_CONS_INFO" datasource="#DSN#"><!--- Bu bireysel üye varmı --->
						SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#"> AND CONSUMER_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#surname#">
					</cfquery>
				</cfif>
			</cfif>
			<cfif (isdefined("get_cons_info.recordcount") and not get_cons_info.recordcount) or not isdefined("get_cons_info.recordcount")>
				<cfif (len(tax_no) eq 0) or (len(tax_no) eq 10)>
                    <cfif len(home_country) and isnumeric(home_country)>
                        <cfif len(home_city_id) and isNumeric(home_city_id)>
                            <cfquery name="GET_CITY_NAME" dbtype="query">
                                SELECT
                                    CITY_ID,
                                    COUNTRY_ID
                                FROM
                                    GET_CITY_NAME_ALL
                                WHERE
                                    CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#home_city_id#">
                            </cfquery>
                            <cfif len(home_county_id) and isNumeric(home_county_id)>
                                <cfquery name="GET_COUNTY_NAME" dbtype="query">
                                    SELECT
                                        COUNTY_ID
                                    FROM
                                        GET_COUNTY_NAME_ALL
                                    WHERE
                                        COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#home_county_id#"> AND
                                        CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#home_city_id#">
                                </cfquery>
                                <cfset home_county_id_ = get_county_name.county_id>
                                <cfif len(home_district) and isnumeric(home_district)>
                                    <cfquery name="GET_DISTRICT_NAME" dbtype="query">
                                        SELECT
                                            DISTRICT_ID
                                        FROM
                                            GET_DISTRICT_NAME_ALL
                                        WHERE
                                            DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#home_district#"> AND
                                            COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#home_county_id#">
                                    </cfquery>
                                    <cfset home_district_ = get_district_name.district_id>
                                <cfelse>
                                    <cfset home_district_ = "">
                                </cfif>
                            <cfelse>
                                <cfset home_county_id_ = "">
                                <cfset home_district_ = "">
                            </cfif>
                            <cfset home_city_id = get_city_name.city_id>
                            <cfset home_country_id_ = get_city_name.country_id>
                        <cfelse>
                            <cfset home_city_id = "">
                            <cfset home_county_id_ = "">
                            <cfset home_country_id_ = "">
                            <cfset home_district_ = "">
                        </cfif>
                    <cfelse>
                        <cfset home_city_id = "">
                        <cfset home_county_id_ = "">
                        <cfset home_country_id_ = "">
                        <cfset home_district_ = "">
                    </cfif>
                    <cfif len(work_city_id) and isNumeric(work_city_id)>
                        <cfquery name="GET_CITY_NAME" dbtype="query">
                            SELECT
                                CITY_ID,
                                COUNTRY_ID
                            FROM
                                GET_CITY_NAME_ALL
                            WHERE
                                CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#work_city_id#">
                        </cfquery>
                        <cfif len(work_county_id) and isNumeric(work_county_id)>
                            <cfquery name="GET_COUNTY_NAME" dbtype="query">
                                SELECT
                                    COUNTY_ID
                                FROM
                                    GET_COUNTY_NAME_ALL
                                WHERE
                                    COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#work_county_id#">
                            </cfquery>
                            <cfset work_county_id = get_county_name.county_id>
                            <cfif len(work_district) and isnumeric(work_district)>
                                <cfquery name="GET_DISTRICT_NAME" dbtype="query">
                                    SELECT
                                        DISTRICT_ID
                                    FROM
                                        GET_DISTRICT_NAME_ALL
                                    WHERE
                                        DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#work_district#"> AND
                                        COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#work_county_id#">
                                </cfquery>
                                <cfset work_district = get_district_name.district_id>
                            <cfelse>
                                <cfset work_district = "">
                            </cfif>
                        <cfelse>
                            <cfset work_county_id = "">
                            <cfset work_district = "">
                        </cfif>
                        <cfset work_city_id = get_city_name.city_id>
                        <cfset work_country_id = get_city_name.country_id>
                    <cfelse>
                        <cfset work_city_id = "">
                        <cfset work_county_id = "">
                        <cfset work_country_id = "">
                        <cfset work_district = "">
                    </cfif>
                    
                    <cfif len(tax_city_id) and isNumeric(tax_city_id)><!--- fatura adresi icin --->
                        <cfquery name="GET_CITY_NAME_T" dbtype="query">
                            SELECT
                                CITY_ID,
                                COUNTRY_ID
                            FROM
                                GET_CITY_NAME_ALL
                            WHERE
                                CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#tax_city_id#">
                        </cfquery>
                        <cfif len(tax_county_id) and isNumeric(tax_county_id)>
                            <cfquery name="GET_COUNTY_NAME_T" dbtype="query">
                                SELECT
                                    COUNTY_ID
                                FROM
                                    GET_COUNTY_NAME_ALL
                                WHERE
                                    COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#tax_county_id#">
                            </cfquery>
                            <cfset tax_county_id = get_county_name_t.county_id>
                            <cfif len(tax_district) and isnumeric(tax_district) and len(tax_county_id)>
                                <cfquery name="GET_DISTRICT_NAME_T" dbtype="query">
                                    SELECT
                                        DISTRICT_ID
                                    FROM
                                        GET_DISTRICT_NAME_ALL
                                    WHERE
                                        DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#tax_district#"> AND
                                        COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#tax_county_id#">
                                </cfquery>
                                <cfset tax_district = get_district_name_t.district_id>
                            <cfelse>
                                <cfset tax_district = "">
                            </cfif>
                        <cfelse>
                            <cfset tax_county_id = "">
                            <cfset tax_district = "">
                        </cfif>
                        <cfset tax_city_id = get_city_name_t.city_id>
                        <cfset tax_country_id = get_city_name_t.country_id>
                    <cfelse>
                        <cfset tax_city_id = "">
                        <cfset tax_country_id = "">
                        <cfset tax_county_id = "">
                        <cfset tax_district = "">
                    </cfif>
                    
                    <cfif len(consumercat_id) and isnumeric(consumercat_id)>
                        <cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
                            SELECT CONSCAT_ID, CONSCAT FROM CONSUMER_CAT WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#consumercat_id#">
                        </cfquery>
                        <cfset consumer_cat_id = GET_CONSUMER_CAT.CONSCAT_ID>
                    <cfelse>
                        <cfset liste=ListAppend(liste,#i#&'. Üye Kategorisi Alanı Boş Bırakılamaz ',',')>
                        <cfset consumer_cat_id =''>
                    </cfif>
                    <cfif len(process_cat) and isnumeric(process_cat)>
                        <cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
                            SELECT
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
                                PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_cat#"> AND
                                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.consumer_list%">
                        </cfquery>
                        <cfset consumer_stage = get_process_type.process_row_id>
                    <cfelse>
                        <cfset consumer_stage = "">
                        <cfset liste=ListAppend(liste,#i#&'. Aşama Alanı Boş Bırakılamaz ',',')>
                    </cfif>
                    <cfif len(sector) and isnumeric(sector)>
                        <cfquery name="GET_SECTOR" dbtype="query">
                            SELECT SECTOR_CAT_ID, SECTOR_CAT FROM GET_SECTOR_ALL WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sector#">
                        </cfquery>
                    <cfelse>
                        <cfset get_sector.sector_cat_id=''>
                    </cfif>
                    <!--- Meslek Tipi Uyuşuyorsa Set Ediliyor. --->
                    <cfif len(vocation) and isnumeric(vocation)>
                        <cfquery name="GET_VOCATION_TYPE" dbtype="query">
                            SELECT VOCATION_TYPE_ID,VOCATION_TYPE FROM GET_VOCATION_TYPE_ALL WHERE VOCATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vocation#">
                        </cfquery>
                    <cfelse>
                        <cfset get_vocation_type.vocation_type_id = ''>
                    </cfif>
                    <cfif len(position)>
                        <cfquery name="GET_CONS_POSITION" dbtype="query">
                            SELECT PARTNER_POSITION_ID, PARTNER_POSITION FROM GET_PARTNER_POSITION_ALL WHERE PARTNER_POSITION = '#position#'
                        </cfquery>
                    <cfelse>
                        <cfset GET_CONS_POSITION.PARTNER_POSITION_ID=''>
                    </cfif>
                    <cfif len(department) and isnumeric(department)>
                        <cfquery name="GET_DEP" dbtype="query">
                            SELECT PARTNER_DEPARTMENT_ID,PARTNER_DEPARTMENT FROM GET_DEP_ALL WHERE PARTNER_DEPARTMENT_ID=#department#
                        </cfquery>
                    <cfelse>
                        <cfset GET_DEP.PARTNER_DEPARTMENT_ID=''>
                    </cfif>
                    <cfif len(social_society) and isnumeric(social_society)>
                        <cfquery name="GET_SOCIAL" dbtype="query">
                            SELECT SOCIETY_ID FROM GET_SOCIETIES WHERE SOCIETY_ID = #social_society#
                        </cfquery>
                    <cfelse>
                        <cfset GET_SOCIAL.SOCIETY_ID=''>
                    </cfif>
                    <cfif len(resource_id) and isnumeric(resource_id)>
                        <cfquery name="get_resource" datasource="#dsn#">
                            SELECT RESOURCE_ID FROM COMPANY_PARTNER_RESOURCE WHERE RESOURCE_ID = #resource_id#
                        </cfquery>
                    <cfelse>
                        <cfset get_resource.RESOURCE_ID=''>
                    </cfif>
                    <cfif len(sales_county) and isnumeric(sales_county)>
                        <cfquery name="get_saleszone" datasource="#dsn#">
                            SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE SZ_ID = #sales_county#
                        </cfquery>
                    <cfelse>
                        <cfset get_saleszone.SZ_ID=''>
                    </cfif>
                    <cfif len(member_date)><cf_date tarih='member_date'></cfif>
                    <cfif isdefined("birthdate") and len(birthdate)><cf_date tarih='birthdate'></cfif>
                    <cfif len(ref_member_code)>
                        <cfquery name="GET_REF_CONS" datasource="#DSN#">
                            SELECT CONSUMER_REFERENCE_CODE,REF_POS_CODE,CONSUMER_ID FROM CONSUMER WHERE MEMBER_CODE = '#ref_member_code#'
                        </cfquery>
                        <cfif GET_REF_CONS.recordcount>
                            <cfset consumer_reference_code = "#GET_REF_CONS.CONSUMER_REFERENCE_CODE#.#GET_REF_CONS.CONSUMER_ID#">
                            <cfset ref_pos_code = GET_REF_CONS.CONSUMER_ID>
                        <cfelse>
                            <cfset consumer_reference_code = ref_member_code>
                            <cfset ref_pos_code = "">
                        </cfif>
                    <cfelse>
                        <cfset consumer_reference_code = "">
                        <cfset ref_pos_code = "">
                    </cfif>
                    <cfif Len(member_add_option_id) and isNumeric(member_add_option_id)>
                        <cfquery name="get_member_add_options" datasource="#dsn#">
                            SELECT MEMBER_ADD_OPTION_ID FROM SETUP_MEMBER_ADD_OPTIONS WHERE MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#member_add_option_id#">
                        </cfquery>
                        <cfif not get_member_add_options.recordcount><cfset member_add_option_id = ""></cfif>
                    </cfif>
                    <cfif len(consumer_cat_id)>
                    	<cfif len(consumer_stage)> 
                            <cfquery name="ADD_CONSUMER" datasource="#DSN#">
                                INSERT INTO
                                    CONSUMER
                                (
                                    CONSUMER_NAME,
                                    CONSUMER_SURNAME,
                                    CONSUMER_CAT_ID,
                                    CONSUMER_STAGE,
                                    PERIOD_ID,
                                    TC_IDENTY_NO,
                                    OZEL_KOD,
                                    CUSTOMER_VALUE_ID,
                                    HOME_COUNTRY_ID,
                                    HOME_CITY_ID,
                                    HOME_COUNTY_ID,
                                    HOMESEMT,
                                    HOME_DISTRICT_ID,
                                    HOMEADDRESS,
                                    HOMEPOSTCODE,
                                    CONSUMER_HOMETELCODE,
                                    CONSUMER_HOMETEL,
                                    CONSUMER_EMAIL,
                                    CONSUMER_KEP_ADDRESS,
                                    HOMEPAGE,
                                    MOBIL_CODE,
                                    MOBILTEL,
                                    SEX,
                                    COMPANY,
                                    TITLE,
                                    MISSION,
                                    DEPARTMENT,
                                    SECTOR_CAT_ID,
                                    VOCATION_TYPE_ID,
                                    WORK_COUNTRY_ID,
                                    WORK_CITY_ID,
                                    WORK_COUNTY_ID,
                                    WORKSEMT,
                                    WORK_DISTRICT_ID,
                                    WORKADDRESS,
                                    WORKPOSTCODE,
                                    CONSUMER_WORKTELCODE,
                                    CONSUMER_WORKTEL,
                                    CONSUMER_FAXCODE,
                                    CONSUMER_FAX,
                                    RESOURCE_ID,
                                    TAX_OFFICE,
                                    TAX_NO,
                                    TAX_ADRESS,
                                    TAX_COUNTRY_ID,
                                    TAX_CITY_ID,
                                    TAX_COUNTY_ID,
                                    TAX_SEMT,
                                    TAX_DISTRICT_ID,
                                    TAX_DOOR_NO,
                                    TAX_POSTCODE,
                                    ISPOTANTIAL,
                                    IS_CARI,
                                    WANT_EMAIL,
                                    RECORD_IP,
                                    RECORD_MEMBER,
                                    RECORD_DATE,
                                    START_DATE,
                                    SOCIAL_SOCIETY_ID,
                                    SOCIAL_SECURITY_NO,
                                    BLOOD_TYPE,
                                    MOTHER,
                                    FATHER,
                                    CONSUMER_USERNAME,
                                    CONSUMER_PASSWORD,
                                    BIRTHDATE,
                                    WANT_SMS,
                                    CONSUMER_STATUS,
                                    SALES_COUNTY,
                                    REF_POS_CODE,
                                    CONSUMER_REFERENCE_CODE,
                                    MEMBER_ADD_OPTION_ID
                                )
                                VALUES
                                (
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#surname#">,
                                    #consumer_cat_id#,
                                    #consumer_stage#,
                                    #attributes.period_id#,
                                    <cfif isdefined('tc_identy_no') and len(tc_identy_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(tc_identy_no,11)#"><cfelse>NULL</cfif>,		
                                    <cfif isdefined('ozel_kod') and len(ozel_kod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ozel_kod#"><cfelse>NULL</cfif>,	
                                    <cfif isdefined('customer_value') and len(customer_value) and isnumeric(customer_value)>#customer_value#<cfelse>NULL</cfif>,	
                                    <cfif len(home_country)>#home_country#<cfelse>NULL</cfif>,		
                                    <cfif len(home_city_id)>#home_city_id#<cfelse>NULL</cfif>,	
                                    <cfif len(home_county_id_)>#home_county_id_#<cfelse>NULL</cfif>,	
                                    <cfif len(home_semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#home_semt#"><cfelse>NULL</cfif>,
                                    <cfif len(home_district_)>#home_district_#<cfelse>NULL</cfif>,
                                    <cfif len(home_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#home_address#"><cfelse>NULL</cfif>,							
                                    <cfif len(home_postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#home_postcode#"><cfelse>NULL</cfif>,	
                                    <cfif len(home_telcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#home_telcode#"><cfelse>NULL</cfif>,			
                                    <cfif len(home_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#home_tel#"><cfelse>NULL</cfif>,			
                                    <cfif len(consumer_email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#consumer_email#"><cfelse>NULL</cfif>,
                                    <cfif len(kep_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#kep_address#"><cfelse>NULL</cfif>,
                                    <cfif len(homepage)><cfqueryparam cfsqltype="cf_sql_varchar" value="#homepage#"><cfelse>NULL</cfif>,
                                    <cfif len(mobil_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#mobil_code#"><cfelse>NULL</cfif>,
                                    <cfif len(mobiltel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#mobiltel#"><cfelse>NULL</cfif>,
                                    <cfif sex eq 'Bayan' or sex eq 0>0<cfelse>1</cfif>,
                                    <cfif len(company)><cfqueryparam cfsqltype="cf_sql_varchar" value="#company#"><cfelse>NULL</cfif>,
                                    <cfif len(position)><cfqueryparam cfsqltype="cf_sql_varchar" value="#position#"><cfelse>NULL</cfif>,
                                    <cfif len(GET_CONS_POSITION.PARTNER_POSITION_ID)>#GET_CONS_POSITION.PARTNER_POSITION_ID#<cfelse>NULL</cfif>,
                                    <cfif len(GET_DEP.PARTNER_DEPARTMENT_ID)>#GET_DEP.PARTNER_DEPARTMENT_ID#<cfelse>NULL</cfif>,
                                    <cfif len(GET_SECTOR.SECTOR_CAT_ID)>#GET_SECTOR.SECTOR_CAT_ID#<cfelse>NULL</cfif>,
                                    <cfif len(GET_VOCATION_TYPE.VOCATION_TYPE_ID)>#GET_VOCATION_TYPE.VOCATION_TYPE_ID#<cfelse>NULL</cfif>,
                                    <cfif len(work_country)>#work_country#<cfelse>NULL</cfif>,
                                    <cfif len(work_city_id)>#work_city_id#<cfelse>NULL</cfif>,
                                    <cfif len(work_county_id)>#work_county_id#<cfelse>NULL</cfif>,
                                    <cfif len(work_semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#work_semt#"><cfelse>NULL</cfif>,		
                                    <cfif len(work_district)>#work_district#<cfelse>NULL</cfif>,
                                    <cfif len(work_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#work_address#"><cfelse>NULL</cfif>,
                                    <cfif len(work_postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#work_postcode#"><cfelse>NULL</cfif>,	
                                    <cfif len(work_telcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#work_telcode#"><cfelse>NULL</cfif>,
                                    <cfif len(work_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#work_tel#"><cfelse>NULL</cfif>,		
                                    <cfif len(work_faxcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#work_faxcode#"><cfelse>NULL</cfif>,
                                    <cfif len(work_fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#work_fax#"><cfelse>NULL</cfif>,
                                    <cfif len(get_resource.RESOURCE_ID)>#get_resource.RESOURCE_ID#<cfelse>NULL</cfif>,
                                    <cfif len(tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_office#"><cfelse>NULL</cfif>,				
                                    <cfif len(tax_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_no#"><cfelse>NULL</cfif>,
                                    <cfif len(tax_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_address#"><cfelse>NULL</cfif>,
                                    <cfif len(tax_country)>#tax_country#<cfelse>NULL</cfif>,
                                    <cfif len(tax_city_id)>#tax_city_id#<cfelse>NULL</cfif>,
                                    <cfif len(tax_county_id)>#tax_county_id#<cfelse>NULL</cfif>,
                                    <cfif len(tax_semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_semt#"><cfelse>NULL</cfif>,		
                                    <cfif len(tax_district)>#tax_district#<cfelse>NULL</cfif>,
                                    <cfif len(tax_address_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_address_2#"><cfelse>NULL</cfif>,
                                    <cfif len(tax_postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_postcode#"><cfelse>NULL</cfif>,	
                                    <cfif isDefined("attributes.ispotential")>1<cfelse>0</cfif>,
                                    <cfif isDefined("attributes.is_cari")>1<cfelse>0</cfif>,
                                    <cfif want_email eq 'Evet' or want_email eq 1>1<cfelse>0</cfif>,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                    #session.ep.userid#,
                                    #now()#,
                                    <cfif len(member_date)>#member_date#<cfelse>NULL</cfif>,
                                    <cfif len(GET_SOCIAL.SOCIETY_ID)>#GET_SOCIAL.SOCIETY_ID#<cfelse>NULL</cfif>,
                                    <cfif len(social_society_no)>#social_society_no#<cfelse>NULL</cfif>,
                                    <cfif len(blood_type) and isnumeric(blood_type)>#blood_type#<cfelse>NULL</cfif>,
                                    <cfif len(mother_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#mother_name#"><cfelse>NULL</cfif>,
                                    <cfif len(father_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#father_name#"><cfelse>NULL</cfif>,
                                    <cfif len(consumer_username)>'#consumer_username#'<cfelse>NULL</cfif>,
                                    <cfif len(consumer_password)>'#PASS#'<cfelse>NULL</cfif>,
                                    <cfif len(birthdate)>#birthdate#<cfelse>NULL</cfif>,
                                    <cfif want_sms eq 'Evet' or want_sms eq 1>1<cfelse>0</cfif>,
                                    <cfif consumer_status eq 'Evet' or consumer_status eq 1>1<cfelse>0</cfif>,
                                    <cfif len(get_saleszone.SZ_ID)>#get_saleszone.SZ_ID#<cfelse>NULL</cfif>,
                                    <cfif len(ref_pos_code)>#ref_pos_code#<cfelse>NULL</cfif>,
                                    <cfif len(consumer_reference_code)>'#consumer_reference_code#'<cfelse>NULL</cfif>,
                                    <cfif Len(member_add_option_id) and isNumeric(member_add_option_id)>#member_add_option_id#<cfelse>NULL</cfif>
                                )
                                SELECT SCOPE_IDENTITY() AS MAX_CONS
                            </cfquery>
                        <cfelse>
                        	<cfset liste=ListAppend(liste,#i#&'. Belirttiğiniz Aşama Sistemde Tanımlı Değil',',')>
                        </cfif>
                    <cfelse>
                    	<cfset liste=ListAppend(liste,#i#&'. Üye Kategorisi Sistemde Tanımlı Değil',',')>
                    </cfif>
                    <cfset get_max_cons.max_cons = ADD_CONSUMER.MAX_CONS>
                    <cfif Len(menu_id)>
                        <cfquery name="INS_DOMAIN" datasource="#DSN#">
                            INSERT INTO 
                                COMPANY_CONSUMER_DOMAINS
                                (
                                    CONSUMER_ID,
                                    MENU_ID,
                                    RECORD_DATE,
                                    RECORD_EMP,
                                    RECORD_IP
                                )
                                VALUES
                                (
                                    #get_max_cons.max_cons#,
                                    <cfif len(menu_id)>#menu_id#<cfelse>NULL</cfif>,
                                    #now()#,
                                    #session.ep.userid#,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                                )
                        </cfquery>
                    </cfif>
                    <!--- uye temsilci FA--->
                    <cfif len(agent_id)>
                        <cfquery name="get_pos_code" datasource="#dsn#">
                            SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #agent_id#
                        </cfquery>
                        <cfquery name="ADD_WORK_MEMBER" datasource="#DSN#">
                            INSERT INTO
                                WORKGROUP_EMP_PAR
                            (
                                CONSUMER_ID,
                                OUR_COMPANY_ID,
                                POSITION_CODE,
                                IS_MASTER,
                                RECORD_EMP,
                                RECORD_IP,
                                RECORD_DATE
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_CONS.MAX_CONS#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos_code.position_code#">,
                                1,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                            )
                        </cfquery>
                    </cfif>
                    
                    <!--- uye iliskili not --->
                    <cfif len(member_note_head) and len(member_note)>
                        <cfquery name="ADD_NOTE" datasource="#dsn#">
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
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="CONSUMER_ID">,
                                    #GET_MAX_CONS.MAX_CONS#,
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
                        <cfquery name="ADD_NOTE" datasource="#dsn#">
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
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="CONSUMER_ID">,
                                    #GET_MAX_CONS.MAX_CONS#,
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
                    <cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
                        UPDATE 
                            CONSUMER 
                        SET 
                            MEMBER_CODE = <cfif len(member_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="B#get_max_cons.max_cons#"></cfif>
                        WHERE 
                            CONSUMER_ID = #get_max_cons.max_cons#
                    </cfquery>
                    <cfquery name="ADD_CONS_PERIOD" datasource="#DSN#">
                        INSERT INTO
                            CONSUMER_PERIOD
                            (
                                CONSUMER_ID,
                                PERIOD_ID
                            )
                            VALUES
                            (
                                #get_max_cons.max_cons#,
                                #attributes.period_id#
                            )
                    </cfquery>
                                    
                    <!--- Adres Defteri --->
                    <cf_addressbook
                        design		= "1"
                        type		= "3"
                        type_id		= "#get_max_cons.max_cons#"
                        name		= "#name#"
                        surname		= "#surname#"
                        sector_id	= "#get_sector.sector_cat_id#"
                        company_name= "#company#"
                        title		= "#position#"
                        email		= "#consumer_email#"
                        telcode		= "#work_telcode#"
                        telno		= "#work_tel#"
                        faxno		= "#work_fax#"
                        mobilcode	= "#mobil_code#"
                        mobilno		= "#mobiltel#"
                        web			= "#homepage#"
                        postcode	= "#work_postcode#"
                        address		= "#work_address#"
                        semt		= "#work_semt#"
                        county_id	= "#work_county_id#"
                        city_id		= "#work_city_id#"
                        country_id	= "#work_country#">
                    
                    <cfset counter = counter + 1>
                <cfelse>
                    <cfset liste=ListAppend(liste,#i#&'. Vergi Numarası 10 Haneli Olmalıdır!',',')>
                </cfif>
			<cfelse>
				<cfset liste=ListAppend(liste,#i#&'. Satırdaki Bireysel Üye Sistemde Kayıtlı ',',')>
			</cfif>
		<cfelse>
			<cfset liste=ListAppend(liste,#i#&'. Satırdaki Üye Kodu Sistemde Mevcut',',')>
		</cfif>
		<cfcatch type="any">
			<cfset liste=ListAppend(liste,#i#&'. Satırda Yazma İşlemi Sırasında Hata Oldu ',',')>
		</cfcatch> 
		</cftry>
	<cfelse>
		<cfset liste=ListAppend(liste,#i#&'. Satırda Ad ve Soyad Bilgileri Eksik',',')>
	</cfif>
</cfloop>
<cfoutput>
	<cfif listlen(liste,',') gt 0>
		&nbsp;#listlen(liste,',')# Kayıtta Sorun Oluştu. <br/>
		Sorunlu Kayıtlar Aşağıdaki Gibidir, Lütfen Kontrol Ediniz :<br/><br/>
		<cfloop list="#liste#" index="i">&nbsp;#i#,<br/></cfloop>
		<br/>
	<cfelse>
		&nbsp;#counter# <cf_get_lang dictionary_id='63248.Sorunsuz Kayıt Yapıldı'>!!!
        <script>
        	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_add_consumer_member_import</cfoutput>";
        </script>
	</cfif>
</cfoutput>
