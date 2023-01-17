<cfif not (isDefined('attributes.consumer_cat_id') and len(attributes.consumer_cat_id))>
	<script>
		alert("<cf_get_lang_main no ='1301.Lütfen bir bireysel üye kategorisi seçiniz!'>");
		history.back(-1);
	</script>
	<cfabort>
</cfif>
<cfinclude template="../../objects/functions/add_consumer_history.cfm">
<cfif isdefined('attributes.birthdate') and len(attributes.birthdate)><cf_date tarih='attributes.birthdate'></cfif>
<cfset list="',""">
<cfset list2=" , ">
<cfif isdefined('form.consumer_name')>
	<cfset attributes.consumer_name=replacelist(form.consumer_name,list,list2)>
</cfif>
<cfif isdefined('form.consumer_name')>
	<cfset attributes.consumer_surname=replacelist(form.consumer_surname,list,list2)>
</cfif>
<cfset a = "">
<cfif isdefined('attributes.consumer_name')>
	<cfloop from="1" to="#listlen(attributes.consumer_name,' ')#" index="i">
		<cfif len(listgetat(attributes.consumer_name,i,' ')) gt 1>
			<cfset b = ucase(left(listgetat(attributes.consumer_name,i,' '),1)) & lcase(right(listgetat(attributes.consumer_name,i,' '),len(listgetat(attributes.consumer_name,i,' '))-1))>
		<cfelse>
			<cfset b = ucase(left(listgetat(attributes.consumer_name,i,' '),1))>
		</cfif>
		<cfset a = '#a# #b#'>
	</cfloop>
	<cfset attributes.consumer_name = trim(a)>
</cfif>
<cfset a = "">
<cfif isdefined('attributes.consumer_surname')>
	<cfloop from="1" to="#listlen(attributes.consumer_surname,' ')#" index="i">
		<cfif len(listgetat(attributes.consumer_surname,i,' ')) gt 1>
			<cfset b = ucase(left(listgetat(attributes.consumer_surname,i,' '),1)) & lcase(right(listgetat(attributes.consumer_surname,i,' '),len(listgetat(attributes.consumer_surname,i,' '))-1))>
		<cfelse>
			<cfset b = ucase(left(listgetat(attributes.consumer_surname,i,' '),1))>
		</cfif>
		<cfset a = '#a# #b#'>
	</cfloop>
</cfif>
<cfset attributes.consumer_surname = trim(a)>
<cfif isdefined('attributes.consumer_password') and  len(attributes.consumer_password)><cf_cryptedpassword password='#attributes.consumer_password#' output='PASS' mod=1></cfif>
<cfif  isdefined('attributes.consumer_username') and len(attributes.consumer_username) and len(attributes.consumer_password)>
	<cfquery name="GET_CONS_NAME" datasource="#DSN#">
		SELECT
			CONSUMER_ID,
			CONSUMER_USERNAME
		FROM
			CONSUMER
		WHERE
			CONSUMER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consumer_username#"> AND
			CONSUMER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pass#"> AND
			CONSUMER_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<cfif get_cons_name.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1446.Girdiğiniz Kullanıcı Adı ve Şifre Kullanılıyor Lütfen Geri Dönüp Kontrol Ediniz'>");
			window.history.go(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="GET_DET" datasource="#DSN#">
	SELECT
		PICTURE,
		PICTURE_SERVER_ID,
		CONSUMER_USERNAME
	FROM
		CONSUMER
	WHERE
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
</cfquery>
<cfif isdefined("attributes.del_photo")>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="UPD_PHOTO" datasource="#DSN#">
				UPDATE 
					CONSUMER 
				SET 
					PICTURE = ''
				WHERE 
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfquery>
		</cftransaction>
	</cflock>
	<cfif len(get_det.picture)>
		<cf_del_server_file output_file="member/consumer/#get_det.picture#" output_server="#get_det.picture_server_id#">
	</cfif> 
</cfif>

<cfif isdefined("attributes.picture") and len(attributes.picture)>
	<cfset file_name = createUUID()>
	<cffile action="UPLOAD" 					 
		nameconflict="MAKEUNIQUE" 
		destination="#upload_folder#member#dir_seperator#consumer#dir_seperator#"
		filefield="picture"
		accept = "image/*">
	<cffile action="rename"
		source="#upload_folder#member#dir_seperator#consumer#dir_seperator##cffile.serverfile#" 
		destination="#upload_folder#member#dir_seperator#consumer#dir_seperator##file_name#.#cffile.serverfileext#">
	<!---Script dosyalarını engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder#member#dir_seperator#consumer#dir_seperator##file_name#.#cffile.serverfileext#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfset cffile.serverfile = "#file_name#.#cffile.serverfileext#">
	<cfif len(get_det.picture)>
		<cf_del_server_file output_file="member/consumer/#get_det.picture#" output_server="#get_det.picture_server_id#">
	</cfif> 
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="UPD_PHOTO" datasource="#DSN#">
				UPDATE 
					CONSUMER 
				SET 
					PICTURE = '#cffile.serverfile#',
					PICTURE_SERVER_ID=#fusebox.server_machine#
				WHERE 
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfquery>
		</cftransaction>
	</cflock>	
</cfif>
<cfif not isdefined("attributes.home_address")>
	<cfif isdefined("attributes.home_door_no") and len(attributes.home_door_no)>
		<cfset home_door_no = '#attributes.home_door_no#'>
	<cfelse>
		<cfset home_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.home_district")>
		<cfset attributes.home_address = '#attributes.home_district# #attributes.home_main_street# #attributes.home_street# #home_door_no#'>
	<cfelseif isdefined("attributes.home_main_street")>
		<cfset attributes.home_address = '#attributes.home_main_street# #attributes.home_street# #home_door_no#'>
	</cfif>
</cfif>
<cfif not isdefined("attributes.work_address")>
	<cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>
		<cfset work_door_no = '#attributes.work_door_no#'>
	<cfelse>
		<cfset work_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.work_district")>
		<cfset attributes.work_address = '#attributes.work_district# #attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	<cfelseif isdefined("attributes.work_main_street")>
		<cfset attributes.work_address = '#attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	</cfif>
</cfif>
<cfif not isdefined("attributes.tax_address")>
	<cfif isdefined("attributes.tax_door_no") and len(attributes.tax_door_no)>
		<cfset tax_door_no = '#attributes.tax_door_no#'>
	<cfelse>
		<cfset tax_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.tax_district")>
		<cfset attributes.tax_address = '#attributes.tax_district# #attributes.tax_main_street# #attributes.tax_street# #tax_door_no#'>
	<cfelseif isdefined("attributes.tax_main_street")>
		<cfset attributes.tax_address = '#attributes.tax_main_street# #attributes.tax_street# #tax_door_no#'>
	</cfif>
</cfif>
<cfif isdefined("attributes.is_tax_address")>
	<cfset attributes.tax_address = attributes.home_address>
	<cfset attributes.tax_postcode = attributes.home_postcode>	
	<cfset attributes.tax_semt = attributes.home_semt>
	<cfset attributes.tax_country = attributes.home_country>
	<cfset attributes.tax_county_id = attributes.home_county_id>
	<cfset attributes.tax_city_id = attributes.home_city_id>
	<cfif isdefined("attributes.home_district")>
		<cfset attributes.tax_district = attributes.home_district>
	</cfif>
	<cfif isdefined("attributes.home_district_id")>
		<cfset attributes.tax_district_id = attributes.home_district_id>
	</cfif>
	<cfset attributes.tax_main_street = attributes.home_main_street>
	<cfset attributes.tax_street = attributes.home_street>
	<cfset attributes.tax_door_no = attributes.home_door_no>
<cfelseif isdefined("attributes.is_tax_address_2")>
	<cfset attributes.tax_address = attributes.work_address>
	<cfset attributes.tax_postcode = attributes.work_postcode>	
	<cfset attributes.tax_semt = attributes.work_semt>
	<cfset attributes.tax_country = attributes.work_country>
	<cfset attributes.tax_county_id = attributes.work_county_id>
	<cfset attributes.tax_city_id = attributes.work_city_id>
	<cfif isdefined("attributes.work_district")>
		<cfset attributes.tax_district = attributes.work_district>
	</cfif>
	<cfif isdefined("attributes.work_district_id")>
		<cfset attributes.tax_district_id = attributes.work_district_id>
	</cfif>
	<cfset attributes.tax_main_street = attributes.work_main_street>
	<cfset attributes.tax_street = attributes.work_street>
	<cfset attributes.tax_door_no = attributes.work_door_no>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
  <cftransaction>
	<!--- History - Belirtilen kosullarda degisiklik varsa history ye kayit atiyor (insert kodu functionda) FBS 20081216 --->
	<cfquery name="hist_cont" datasource="#dsn#">
		SELECT * FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<cfif 	(isdefined("attributes.consumer_cat_id") and attributes.consumer_cat_id neq hist_cont.consumer_cat_id) or 
			(attributes.consumer_name neq hist_cont.consumer_name) or (attributes.consumer_surname neq hist_cont.consumer_surname) or
			attributes.consumer_email neq hist_cont.consumer_email or (attributes.mobilcat_id neq hist_cont.mobil_code) or
			(isdefined("attributes.home_telcode") and attributes.home_telcode neq hist_cont.consumer_hometelcode) or (isdefined("attributes.home_tel") and attributes.home_tel neq hist_cont.consumer_hometel) or
			(isdefined("attributes.home_semt") and attributes.home_semt neq hist_cont.homesemt) or (isdefined("attributes.home_county_id") and attributes.home_county_id neq hist_cont.home_county_id) or
			(isdefined("attributes.home_city_id") and attributes.home_city_id neq hist_cont.home_city_id) or (isdefined("attributes.home_country") and attributes.home_country neq hist_cont.home_country_id) or
			(isdefined("attributes.home_address") and attributes.home_address neq hist_cont.homeaddress) or (isdefined("attributes.home_postcode") and attributes.home_postcode neq hist_cont.homepostcode) or
			(isdefined("attributes.home_district") and  attributes.home_district neq hist_cont.home_district) or (isdefined("attributes.home_district_id") and  attributes.home_district_id neq hist_cont.home_district_id) or
			(isdefined("attributes.home_main_street") and  attributes.home_main_street neq hist_cont.home_main_street) or (isdefined("attributes.home_street") and  attributes.home_street neq hist_cont.home_street) or			
			(isdefined("attributes.home_door_no") and  attributes.home_door_no neq hist_cont.home_door_no) or
			(isDefined("attributes.work_telcode") and attributes.work_telcode neq hist_cont.consumer_worktelcode) or (isdefined("attributes.work_tel") and attributes.work_tel neq hist_cont.consumer_worktel) or
			(isdefined("attributes.work_address") and attributes.work_address neq hist_cont.workaddress) or (isdefined("attributes.work_postcode") and attributes.work_postcode neq hist_cont.workpostcode) or 
			(isdefined("attributes.work_semt") and attributes.work_semt neq hist_cont.worksemt) or (isdefined("attributes.work_county_id") and attributes.work_county_id neq hist_cont.work_county_id) or
			(isdefined("attributes.work_city_id") and attributes.work_city_id neq hist_cont.work_city_id) or (isdefined("attributes.work_country") and attributes.work_country neq hist_cont.work_country_id) or
			(isdefined("attributes.work_district") and  attributes.work_district neq hist_cont.work_district) or (isdefined("attributes.work_district_id") and  attributes.work_district_id neq hist_cont.work_district_id) or
			(isdefined("attributes.work_main_street") and  attributes.work_main_street neq hist_cont.work_main_street) or (isdefined("attributes.work_street") and  attributes.work_street neq hist_cont.work_street) or
			(isdefined("attributes.work_door_no") and  attributes.work_door_no neq hist_cont.work_door_no) or
			(isdefined("attributes.tax_office") and attributes.tax_office neq hist_cont.tax_office) or (isdefined("attributes.tax_no") and attributes.tax_no neq hist_cont.tax_no) or 
			(isdefined("attributes.tax_address") and attributes.tax_address neq hist_cont.tax_adress) or (isdefined("attributes.tax_district") and attributes.tax_district neq hist_cont.tax_district) or
			(isdefined("attributes.tax_district_id") and attributes.tax_district_id neq hist_cont.tax_district_id) or (isdefined("attributes.tax_postcode") and attributes.tax_postcode neq hist_cont.tax_postcode) or (isdefined("attributes.tax_semt") and attributes.tax_semt neq hist_cont.tax_semt) or
			(isdefined("attributes.tax_county_id") and attributes.tax_county_id neq hist_cont.tax_county_id) or (isdefined("attributes.tax_city_id") and attributes.tax_city_id neq hist_cont.tax_city_id) or (isdefined("attributes.tax_country") and attributes.tax_country neq hist_cont.tax_country_id) or
			(isdefined("attributes.vocation_type") and attributes.vocation_type neq hist_cont.vocation_type_id) or (isdefined("attributes.tc_identity_no") and attributes.tc_identity_no neq hist_cont.tc_identy_no) or
			(isdefined("attributes.consumer_password") and attributes.consumer_password neq hist_cont.consumer_password) or
			(isdefined("attributes.mobiltel") and attributes.mobiltel neq hist_cont.mobiltel) or
			(isdefined("attributes.mobiltel_2") and attributes.mobiltel_2 neq hist_cont.mobiltel_2)>
			<cfoutput query="hist_cont">
				<cfscript>
					add_consumer_history(consumer_id:hist_cont.consumer_id);
				</cfscript>
			</cfoutput>
	</cfif>
	<cfquery name="UPD_CONSUMER" datasource="#DSN#">
		UPDATE
			CONSUMER
		SET
			CONSUMER_CAT_ID = <cfif isdefined('attributes.consumer_cat_id') and len(attributes.consumer_cat_id)>#attributes.consumer_cat_id#</cfif>,
			BIRTHDATE = <cfif isdefined('attributes.birthdate') and len(attributes.birthdate)>#attributes.birthdate#<cfelse>NULL</cfif>,
			BIRTHPLACE = <cfif isdefined('attributes.birthplace') and len(attributes.birthplace)>'#attributes.birthplace#'<cfelse>NULL</cfif>,
			CHILD = <cfif isdefined('attributes.child') and len(attributes.child)>'#attributes.child#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.company")>COMPANY = <cfif len(attributes.company)>'#attributes.company#'<cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.company_size_cat_id")>COMPANY_SIZE_CAT_ID = <cfif len(attributes.company_size_cat_id)>#attributes.company_size_cat_id#<cfelse>NULL</cfif>,</cfif>
			CONSUMER_EMAIL = <cfif isdefined('attributes.consumer_email') and  len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.homepage")>HOMEPAGE = '#attributes.homepage#',</cfif>
			CONSUMER_HOMETEL = <cfif isdefined("attributes.home_tel") and  len(attributes.home_tel)>'#attributes.home_tel#'<cfelse>NULL</cfif>,
			CONSUMER_HOMETELCODE = <cfif isdefined('attributes.home_telcode') and  len(attributes.home_telcode)>'#attributes.home_telcode#'<cfelse>NULL</cfif>,
			CONSUMER_NAME = '#attributes.consumer_name#',
			<cfif isdefined('attributes.consumer_password') and  len(attributes.consumer_password)>
				CONSUMER_PASSWORD = '#pass#',
				LAST_PASSWORD_CHANGE = #now()#,
			</cfif>
			CONSUMER_SURNAME = '#attributes.consumer_surname#',
			<cfif isdefined('attributes.consumer_username') and len(attributes.consumer_username)>CONSUMER_USERNAME = '#attributes.consumer_username#',</cfif>
			<cfif isdefined("attributes.timeout_limit")>TIMEOUT_LIMIT = #attributes.timeout_limit#,</cfif>
			CONSUMER_WORKTEL = <cfif isdefined("attributes.work_tel") and len(attributes.work_tel)>'#attributes.work_tel#'<cfelse>NULL</cfif>,
			CONSUMER_WORKTELCODE = <cfif isdefined('attributes.work_telcode') and len(attributes.work_telcode)>'#attributes.work_telcode#'<cfelse>NULL</cfif>,
			EDUCATION_ID = <cfif isdefined('attributes.education_level') and len(attributes.education_level)>#attributes.education_level#<cfelse>NULL</cfif>,
			HOMEADDRESS = <cfif isdefined("attributes.home_address") and len(attributes.home_address)>'#attributes.home_address#'<cfelse>NULL</cfif>,
			HOMEPOSTCODE = <cfif isdefined('attributes.home_postcode') and len(attributes.home_postcode)>'#attributes.home_postcode#'<cfelse>NULL</cfif>,				
			HOMESEMT = <cfif isdefined('attributes.home_semt') and len(attributes.home_semt)>'#attributes.home_semt#'<cfelse>NULL</cfif>,  
			HOME_COUNTY_ID = <cfif isdefined('attributes.home_county_id') and len(attributes.home_county_id)>#attributes.home_county_id#<cfelse>NULL</cfif>,
			HOME_CITY_ID = <cfif isdefined('attributes.home_city_id') and len(attributes.home_city_id)>#attributes.home_city_id#<cfelse>NULL</cfif>,
			HOME_COUNTRY_ID = <cfif isdefined('attributes.home_country') and len(attributes.home_country)>#attributes.home_country#<cfelse>NULL</cfif>,
			HOME_DISTRICT = <cfif isdefined("attributes.home_district") and len(attributes.home_district)>'#attributes.home_district#'<cfelse>NULL</cfif>,
			HOME_DISTRICT_ID = <cfif isdefined("attributes.home_district_id") and len(attributes.home_district_id)>#attributes.home_district_id#<cfelse>NULL</cfif>,
			HOME_MAIN_STREET = <cfif isdefined("attributes.home_main_street") and len(attributes.home_main_street)>'#attributes.home_main_street#'<cfelse>NULL</cfif>,
			HOME_STREET = <cfif isdefined("attributes.home_street") and len(attributes.home_street)>'#attributes.home_street#'<cfelse>NULL</cfif>,
			HOME_DOOR_NO = <cfif isdefined("attributes.home_door_no") and len(attributes.home_door_no)>'#attributes.home_door_no#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.department")>DEPARTMENT = <cfif len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.title")>TITLE = '#attributes.title#',</cfif>
			<cfif isdefined("attributes.mission")>MISSION = <cfif len(attributes.mission)>#attributes.mission#<cfelse>NULL</cfif>,</cfif>
			MOBIL_CODE = <cfif isdefined('attributes.mobilcat_id') and  len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
			MOBILTEL = <cfif isdefined('attributes.mobiltel') and len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
			MOBIL_CODE_2 = <cfif isdefined('attributes.mobilcat_id_2') and len(attributes.mobilcat_id_2)>'#attributes.mobilcat_id_2#'<cfelse>NULL</cfif>,
			MOBILTEL_2 = <cfif isdefined('attributes.mobiltel_2') and len(attributes.mobiltel_2)>'#attributes.mobiltel_2#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.del_photo")>PICTURE = NULL,</cfif>
			<cfif isdefined("attributes.del_photo")>PICTURE_SERVER_ID = NULL,</cfif>
			SECTOR_CAT_ID = <cfif isdefined("attributes.sector_cat_id") and len(attributes.sector_cat_id)>#attributes.sector_cat_id#<cfelse>NULL</cfif>,
			SEX = <cfif isdefined("attributes.sex") and attributes.sex eq 1>1<cfelse>0</cfif>,
			WORKPOSTCODE = <cfif isdefined('attributes.work_postcode') and len(attributes.work_postcode)>'#attributes.work_postcode#'<cfelse>NULL</cfif>,
			WORKSEMT = <cfif isdefined("attributes.work_semt") and len(attributes.work_semt)>'#attributes.work_semt#'<cfelse>NULL</cfif>,
			WORKADDRESS = <cfif isdefined('attributes.work_address') and len(attributes.work_address)>'#attributes.work_address#'<cfelse>NULL</cfif>,
			WORK_COUNTY_ID = <cfif isdefined('attributes.work_county_id') and len(attributes.work_county_id)>#attributes.work_county_id#<cfelse>NULL</cfif>,			
			WORK_CITY_ID = <cfif isdefined('attributes.work_city_id') and len(attributes.work_city_id)>#attributes.work_city_id#<cfelse>NULL</cfif>,
			WORK_COUNTRY_ID = <cfif isdefined('attributes.work_country') and len(attributes.work_country)>#attributes.work_country#<cfelse>NULL</cfif>,
			WORK_DISTRICT = <cfif isdefined("attributes.work_district") and len(attributes.work_district)>'#attributes.work_district#'<cfelse>NULL</cfif>,
			WORK_DISTRICT_ID = <cfif isdefined("attributes.work_district_id") and len(attributes.work_district_id)>#attributes.work_district_id#<cfelse>NULL</cfif>,
			WORK_MAIN_STREET = <cfif isdefined("attributes.work_main_street") and len(attributes.work_main_street)>'#attributes.work_main_street#'<cfelse>NULL</cfif>,
			WORK_STREET = <cfif isdefined("attributes.work_street") and len(attributes.work_street)>'#attributes.work_street#'<cfelse>NULL</cfif>,
			WORK_DOOR_NO = <cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>'#attributes.work_door_no#'<cfelse>NULL</cfif>,
			TAX_OFFICE = <cfif isdefined("attributes.tax_office")>'#attributes.tax_office#'<cfelse>NULL</cfif>,
			TAX_NO = <cfif isdefined("attributes.tax_no")>'#attributes.tax_no#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.tax_address") and len(attributes.tax_address)>TAX_ADRESS = '#attributes.tax_address#',</cfif>
			<cfif isdefined("attributes.tax_postcode") and len(attributes.tax_postcode)>TAX_POSTCODE = '#attributes.tax_postcode#',</cfif>
			<cfif isdefined("attributes.tax_semt") and len(attributes.tax_semt)>TAX_SEMT = '#attributes.tax_semt#',</cfif>
			<cfif isdefined("attributes.tax_county_id") and len(attributes.tax_county_id)>TAX_COUNTY_ID = #attributes.tax_county_id#,</cfif>
			<cfif isdefined("attributes.tax_city_id") and len(attributes.tax_city_id)>TAX_CITY_ID = #attributes.tax_city_id#,</cfif>
			<cfif isdefined("attributes.tax_country") and len(attributes.tax_country)>TAX_COUNTRY_ID = #attributes.tax_country#,</cfif>
			<cfif isdefined("attributes.tax_district") and len(attributes.tax_district)>TAX_DISTRICT = '#attributes.tax_district#',</cfif>
			<cfif isdefined("attributes.tax_district_id") and len(attributes.tax_district_id)>TAX_DISTRICT_ID = '#attributes.tax_district_id#',</cfif>
			<cfif isdefined("attributes.tax_main_street") and len(attributes.tax_main_street)>TAX_MAIN_STREET = '#attributes.tax_main_street#',</cfif>
			<cfif isdefined("attributes.tax_street") and len(attributes.tax_street)>TAX_STREET = '#attributes.tax_street#',</cfif>
			<cfif isdefined("attributes.tax_door_no") and len(attributes.tax_door_no)>TAX_DOOR_NO = '#attributes.tax_door_no#',</cfif>
			IS_CARI = <cfif isDefined("attributes.is_cari")>1<cfelse>0</cfif>,
			MARRIED = <cfif isDefined("attributes.married")>1<cfelse>0</cfif>,	
			<cfif isdefined('attributes.tc_identity_no') and len(attributes.tc_identity_no)>	
				TC_IDENTY_NO = '#attributes.tc_identity_no#',
			</cfif>
			<cfif isDefined("attributes.vocation_type")>VOCATION_TYPE_ID = <cfif len(attributes.vocation_type)>#attributes.vocation_type#<cfelse>NULL</cfif>,</cfif>
			<cfif isDefined("attributes.nationality")>NATIONALITY = <cfif len(attributes.nationality)>#attributes.nationality#<cfelse>NULL</cfif>,</cfif>
			TAX_ADDRESS_TYPE=<cfif isdefined("attributes.is_tax_address")>1<cfelseif isdefined("attributes.is_tax_address_2")>2<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
            UPDATE_EMP = NULL,
			UPDATE_CONS = #session.ww.userid#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<!--- hoby kayİt --->
	<cfquery name="DEL_CONSUMER_HOBBY" datasource="#dsn#"> 
		DELETE FROM CONSUMER_HOBBY WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<cfoutput>
		<cfif isDefined('attributes.hobby')>
		<cfloop from="1" to="#Listlen(attributes.hobby)#" index="i"> 
			<cfset liste = ListGetAt(form.hobby,i)>
			<cfquery name="add_consumer_hobbies" datasource="#dsn#"> 
				INSERT INTO
					CONSUMER_HOBBY
				(
					CONSUMER_ID,
					HOBBY_ID
				)
				VALUES
				(
					#session.ww.userid#,
					#liste#
				)
			 </cfquery> 
		 </cfloop>
		</cfif>
	</cfoutput>

	<!--- yetkinlik kayıt --->
	<cfquery name="del_consumer_req" datasource="#dsn#"> 
		DELETE FROM MEMBER_REQ_TYPE WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<cfoutput>
		<cfif isDefined('attributes.req')>
			<cfloop from="1" to="#Listlen(attributes.req)#" index="i"> 
				<cfset liste = ListGetAt(attributes.req,i)>
				<cfquery name="add_consumer_req" datasource="#dsn#"> 
				INSERT INTO MEMBER_REQ_TYPE
					(
						CONSUMER_ID,
						REQ_ID
					)
				VALUES
					(
						#session.ww.userid#,
						#liste#
					)
				</cfquery> 
			</cfloop>
		</cfif>
	</cfoutput>
	<!--- yetkinlik kayıt --->
	<!--- egitim kayıt --->
	<cfquery name="del_cons_education_info" datasource="#dsn#">
		DELETE FROM CONSUMER_EDUCATION_INFO WHERE CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<cfquery name="add_cons_education_info" datasource="#dsn#">
		INSERT INTO 
			CONSUMER_EDUCATION_INFO
			(
				CONS_ID,
				EDU1,
				EDU1_START,
				EDU1_FINISH,
				EDU2,
				EDU2_START,
				EDU2_FINISH,
				EDU3,
				EDU3_START,
				EDU3_FINISH,
				EDU4_ID,
				EDU4_START,
				EDU4_FINISH,
				EDU5,
				EDU5_START,
				EDU5_FINISH,
				EDU4,
				RECORD_CON,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				#session.ww.userid#,
				<cfif isdefined('attributes.EDU1') and len(attributes.EDU1)>'#attributes.EDU1#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU1_START') and len(attributes.EDU1_START)>#attributes.EDU1_START#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU1_FINISH') and len(attributes.EDU1_FINISH)>#attributes.EDU1_FINISH#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU2') and len(attributes.EDU2)>'#attributes.EDU2#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU2_START') and len(attributes.EDU2_START)>#attributes.EDU2_START#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU2_FINISH') and len(attributes.EDU2_FINISH)>#attributes.EDU2_FINISH#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU3') and len(attributes.EDU3)>'#attributes.EDU3#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU3_START') and len(attributes.EDU3_START)>#attributes.EDU3_START#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU3_FINISH') and len(attributes.EDU3_FINISH)>#attributes.EDU3_FINISH#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU4_ID') and len(attributes.EDU4_ID)>#attributes.EDU4_ID#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU4_START') and len(attributes.EDU4_START)>#attributes.EDU4_START#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU4_FINISH') and len(attributes.EDU4_FINISH)>#attributes.EDU4_FINISH#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU5') and len(attributes.EDU5)>'#attributes.EDU5#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU5_START') and len(attributes.EDU5_START)>#attributes.EDU5_START#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU5_FINISH') and len(attributes.EDU5_FINISH)>#attributes.EDU5_FINISH#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.EDU4') and len(attributes.EDU4)>'#attributes.EDU4#'<cfelse>NULL</cfif>,
				#SESSION.ww.USERID#, 
				#now()#,
				'#CGI.REMOTE_ADDR#'
			)
	</cfquery>
	<!--- Diğer adres kayıt --->
	<cfif isdefined("attributes.is_other_address") and attributes.is_other_address eq 1 and isdefined("attributes.contact_name") and isdefined("attributes.add_adres") and attributes.add_adres eq 1>
		<cfif not isdefined("attributes.contact_address")>
			<cfif len(attributes.door_no)>
				<cfset door_no = 'No: #attributes.door_no#'>
			</cfif>
			<cfif isdefined("attributes.district")>
				<cfset attributes.contact_address = '#attributes.district# #attributes.main_street# #attributes.street# #door_no#'>
			<cfelse>
				<cfset attributes.contact_address = '#attributes.main_street# #attributes.street# #door_no#'>
			</cfif>
		</cfif>
		<cfquery name="ADD_CONSUMER_CONTACT" datasource="#DSN#">
			INSERT INTO
				CONSUMER_BRANCH
			(
				CONSUMER_ID,
				STATUS,
				CONTACT_NAME,
				CONTACT_EMAIL,
				CONTACT_TELCODE,
				CONTACT_TEL1,
				CONTACT_TEL2,
				CONTACT_TEL3,
				CONTACT_FAX,
				CONTACT_ADDRESS,
				CONTACT_POSTCODE,
				CONTACT_COUNTY_ID,
				CONTACT_CITY_ID,
				CONTACT_COUNTRY_ID,
				CONTACT_SEMT,		
				CONTACT_DISTRICT,
				CONTACT_DISTRICT_ID,
				CONTACT_MAIN_STREET,
				CONTACT_STREET,
				CONTACT_DOOR_NO,
				CONTACT_DELIVERY_NAME,
				CONTACT_DETAIL,
				RECORD_DATE,	
				RECORD_CONS,
				RECORD_IP
			)
				VALUES
			(
				#session.ww.userid#,
				<cfif isdefined("attributes.contact_status")>1<cfelse>0</cfif>,
				'#attributes.contact_name#',
				'#attributes.contact_email#',
				'#attributes.contact_telcode#',
				'#attributes.contact_tel1#',
				'#attributes.contact_tel2#',
				'#attributes.contact_tel3#',
				'#attributes.contact_fax#',
				<cfif len(attributes.contact_address)>'#attributes.contact_address#'<cfelse>NULL</cfif>,
				'#attributes.contact_postcode#',
				<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
				<cfif len(attributes.contact_semt)>'#attributes.contact_semt#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.district") and len(attributes.district)>'#attributes.district#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.district_id") and len(attributes.district_id)>#attributes.district_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.main_street") and len(attributes.main_street)>'#attributes.main_street#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.street") and len(attributes.street)>'#attributes.street#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.door_no") and len(attributes.door_no)>'#attributes.door_no#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.contact_delivery_name") and len(attributes.contact_delivery_name)>'#attributes.contact_delivery_name#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.contact_detail") and len(attributes.contact_detail)>'#attributes.contact_detail#'<cfelse>NULL</cfif>,
				#now()#,
				#session.ww.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
	</cfif>
	<!--- Diğer adres Güncelleme --->
	<cfif isdefined("attributes.is_other_address") and attributes.is_other_address eq 1 and isdefined("attributes.address_count") and attributes.address_count gt 0>
		<cfloop from="1" to="#attributes.address_count#" index="add_indx">
			<cfif isdefined("attributes.contact_name#add_indx#") and evaluate("attributes.row_kontrol#add_indx#") eq 1>
				<cfif not isdefined("attributes.contact_address#add_indx#")>
					<cfif len(evaluate("attributes.door_no#add_indx#"))>
						<cfset door_no = 'No: #evaluate("attributes.door_no#add_indx#")#'>
					<cfelse>
						<cfset door_no = ''>
					</cfif>
					<cfif isdefined("attributes.district#add_indx#")>
						<cfset "attributes.contact_address#add_indx#" = '#evaluate("attributes.district#add_indx#")# #evaluate("attributes.main_street#add_indx#")# #evaluate("attributes.street#add_indx#")# #door_no#'>
					<cfelse>
						<cfset "attributes.contact_address#add_indx#" = '#evaluate("attributes.main_street#add_indx#")# #evaluate("attributes.street#add_indx#")# #door_no#'>
					</cfif>
				</cfif>
				<cfquery name="UPD_CONSUMER_CONTACT" datasource="#DSN#">
					UPDATE
						CONSUMER_BRANCH
					SET
						CONSUMER_ID = #session.ww.userid#,
						STATUS = <cfif isdefined("attributes.contact_status#add_indx#")>1<cfelse>0</cfif>,
						CONTACT_NAME = '#wrk_eval("attributes.contact_name#add_indx#")#',
						CONTACT_EMAIL = '#wrk_eval("attributes.contact_email#add_indx#")#',
						CONTACT_TELCODE = '#wrk_eval("attributes.contact_telcode#add_indx#")#',
						CONTACT_TEL1 = '#wrk_eval("attributes.contact_tel1#add_indx#")#',
						CONTACT_TEL2 = '#wrk_eval("attributes.contact_tel2#add_indx#")#',
						CONTACT_TEL3 = '#wrk_eval("attributes.contact_tel3#add_indx#")#',
						CONTACT_FAX = '#wrk_eval("attributes.contact_fax#add_indx#")#',
						CONTACT_ADDRESS = <cfif len(evaluate("attributes.contact_address#add_indx#"))>'#wrk_eval("attributes.contact_address#add_indx#")#'<cfelse>NULL</cfif>,
						CONTACT_POSTCODE = '#wrk_eval("attributes.contact_postcode#add_indx#")#',
						CONTACT_COUNTY_ID = <cfif len(evaluate("attributes.county_id#add_indx#"))>#evaluate("attributes.county_id#add_indx#")#<cfelse>NULL</cfif>,
						CONTACT_CITY_ID = <cfif len(evaluate("attributes.city_id#add_indx#"))>#evaluate("attributes.city_id#add_indx#")#<cfelse>NULL</cfif>,
						CONTACT_COUNTRY_ID = <cfif len(evaluate("attributes.country#add_indx#"))>#evaluate("attributes.country#add_indx#")#<cfelse>NULL</cfif>,
						CONTACT_SEMT = <cfif len(evaluate("attributes.contact_semt#add_indx#"))>'#wrk_eval("attributes.contact_semt#add_indx#")#'<cfelse>NULL</cfif>,
						CONTACT_DISTRICT = <cfif isdefined("attributes.district#add_indx#") and len(evaluate("attributes.district#add_indx#"))>'#wrk_eval("attributes.district#add_indx#")#'<cfelse>NULL</cfif>,
						CONTACT_DISTRICT_ID = <cfif isdefined("attributes.district_id#add_indx#") and len(evaluate("attributes.district_id#add_indx#"))>'#wrk_eval("attributes.district_id#add_indx#")#'<cfelse>NULL</cfif>,
						CONTACT_MAIN_STREET = <cfif isdefined("attributes.main_street#add_indx#") and len(evaluate("attributes.main_street#add_indx#"))>'#wrk_eval("attributes.main_street#add_indx#")#'<cfelse>NULL</cfif>,
						CONTACT_STREET = <cfif isdefined("attributes.street#add_indx#") and len(evaluate("attributes.street#add_indx#"))>'#wrk_eval("attributes.street#add_indx#")#'<cfelse>NULL</cfif>,
						CONTACT_DOOR_NO = <cfif isdefined("attributes.door_no#add_indx#") and len(evaluate("attributes.door_no#add_indx#"))>'#wrk_eval("attributes.door_no#add_indx#")#'<cfelse>NULL</cfif>,
						CONTACT_DELIVERY_NAME =  <cfif isdefined("attributes.contact_delivery_name#add_indx#") and len(evaluate("attributes.contact_delivery_name#add_indx#"))>'#wrk_eval("attributes.contact_delivery_name#add_indx#")#'<cfelse>NULL</cfif>,
						CONTACT_DETAIL = <cfif isdefined("attributes.contact_detail") and len(attributes.contact_detail)>'#attributes.contact_detail#'<cfelse>NULL</cfif>,
						UPDATE_DATE = #now()#,
						UPDATE_CONS = #session.ww.userid#,
						UPDATE_IP = '#cgi.remote_addr#'
					WHERE 
						CONTACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.address_id#add_indx#")#">
				</cfquery>
			<cfelseif isdefined("attributes.address_id#add_indx#") and evaluate("attributes.row_kontrol#add_indx#") eq 0>
				<cfquery name="del_address" datasource="#dsn#">
					DELETE FROM CONSUMER_BRANCH WHERE CONTACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.address_id#add_indx#")#">
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif not isDefined("attributes.company")><cfset attributes.company = ""></cfif>
	<cfif not isDefined("attributes.title")><cfset attributes.title = ""></cfif>
	<cfif not isDefined("attributes.work_telcode")><cfset attributes.work_telcode = ""></cfif>
	<cfif not isDefined("attributes.work_tel")><cfset attributes.work_tel = ""></cfif>
	<cfif not isDefined("attributes.homepage")><cfset attributes.homepage = ""></cfif>
	<cfif not isDefined("attributes.work_postcode")><cfset attributes.work_postcode = ""></cfif>
	<cfif not isDefined("attributes.work_address")><cfset attributes.work_address = ""></cfif>
	<cfif not isDefined("attributes.work_semt")><cfset attributes.work_semt = ""></cfif>
	<cfif not isDefined("attributes.work_county_id")><cfset attributes.work_county_id = ""></cfif>
	<cfif not isDefined("attributes.work_city_id")><cfset attributes.work_city_id = ""></cfif>
	<cfif not isDefined("attributes.work_country")><cfset attributes.work_country = ""></cfif>
	<cfif not isDefined("attributes.sector_cat_id")><cfset attributes.sector_cat_id = ""></cfif>
	<!--- Adres Defteri --->
	<cf_addressbook
		design		= "2"
		type		= "3"
		type_id		= "#session.ww.userid#"
		name		= "#attributes.consumer_name#"
		surname		= "#attributes.consumer_surname#"
		sector_id	= "#attributes.sector_cat_id#"
		company_name= "#attributes.company#"
		title		= "#attributes.title#"
		email		= "#attributes.consumer_email#"
		telcode		= "#attributes.work_telcode#"
		telno		= "#attributes.work_tel#"
		mobilcode	= "#attributes.mobilcat_id#"
		mobilno		= "#attributes.mobiltel#"
		web			= "#attributes.homepage#"
		postcode	= "#attributes.work_postcode#"
		address		= "#wrk_eval('attributes.work_address')#"
		semt		= "#attributes.work_semt#"
		county_id	= "#attributes.work_county_id#"
		city_id		= "#attributes.work_city_id#"
		country_id	= "#attributes.work_country#">
	
	<cfquery name="get_stage" datasource="#DSN#">
		SELECT CONSUMER_STAGE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<!--- old_process_line='0' --->
	<cf_workcube_process is_upd='1' 
		data_source='#dsn#' 
		old_process_line='1' 
		process_stage='#get_stage.consumer_stage#' 
		record_member='#session_base.userid#' 
		record_date='#now()#' 
		action_table='CONSUMER'
		action_column='CONSUMER_ID'
		action_id='#session.ww.userid#'
		action_page='#request.self#?fuseaction=member.consumer_list&event=det&cid=#session.ww.userid#' 
		warning_description='Bireysel Üye : #session.ww.userid#'>
  </cftransaction>
</cflock>		
<cfif isdefined('attributes.orderww_back') and attributes.orderww_back eq 1>
	<cflocation url="#request.self#?fuseaction=objects2.form_add_orderww&grosstotal=#attributes.grosstotal#" addtoken="No">
<cfelse>
	<cflocation url="#request.self#?fuseaction=objects2.me" addtoken="No">
</cfif>
