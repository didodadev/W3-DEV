<!--- <cfif len(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif> --->
<cfif len(attributes.birthdate)><cf_date tarih='attributes.birthdate'></cfif>
<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.consumer_name=replacelist(form.consumer_name,list,list2)>
<cfset attributes.consumer_surname=replacelist(form.consumer_surname,list,list2)>
<cfset a = "">
<cfloop from="1" to="#listlen(attributes.consumer_name,' ')#" index="i">
	<cfif len(listgetat(attributes.consumer_name,i,' ')) gt 1>
		<cfset b = ucase(left(listgetat(attributes.consumer_name,i,' '),1)) & lcase(right(listgetat(attributes.consumer_name,i,' '),len(listgetat(attributes.consumer_name,i,' '))-1))>
	<cfelse>
		<cfset b = ucase(left(listgetat(attributes.consumer_name,i,' '),1))>
	</cfif>
	<cfset a = '#a# #b#'>	
</cfloop>
<cfset attributes.consumer_name = trim(a)>
<cfset a = "">
<cfloop from="1" to="#listlen(attributes.consumer_surname,' ')#" index="i">
	<cfif len(listgetat(attributes.consumer_surname,i,' ')) gt 1>
		<cfset b = ucase(left(listgetat(attributes.consumer_surname,i,' '),1)) & lcase(right(listgetat(attributes.consumer_surname,i,' '),len(listgetat(attributes.consumer_surname,i,' '))-1))>
	<cfelse>
		<cfset b = ucase(left(listgetat(attributes.consumer_surname,i,' '),1))>
	</cfif>
	<cfset a = '#a# #b#'>	
</cfloop>
<cfset attributes.consumer_surname = trim(a)>
<cfif len(attributes.consumer_password)><cf_cryptedpassword password='#attributes.consumer_password#' output='PASS' mod=1></cfif>
<cfif len(attributes.consumer_username) and len(attributes.consumer_password)>
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
<cfif isdefined("attributes.picture") and len(attributes.picture)>
	<cfif isdefined("attributes.old_photo") and len(attributes.old_photo)>
		<cf_del_server_file output_file="member/consumer/#attributes.old_photo#" output_server="#attributes.old_photo_server_id#">
		<cfset attributes.old_photo = "">
	</cfif>
	<cfset file_name = createUUID()>
	<cffile action="UPLOAD" 					 
	  nameconflict="MAKEUNIQUE" 
	   destination="#upload_folder#member#dir_seperator#consumer#dir_seperator#"
		 filefield="picture" accept="image/*">
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
	<cfset path = "#upload_folder#member#dir_seperator##CFFILE.ServerFile#">
	<cfset attributes.picture = "#cffile.serverfile#">
</cfif>
<cfif not isdefined("attributes.home_address")>
	<cfif len(attributes.home_door_no)>
		<cfset home_door_no = '#attributes.home_door_no#'>
	<cfelse>
		<cfset home_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.home_district")>
		<cfset attributes.home_address = '#attributes.home_district# #attributes.home_main_street# #attributes.home_street# #home_door_no#'>
	<cfelse>
		<cfset attributes.home_address = '#attributes.home_main_street# #attributes.home_street# #home_door_no#'>
	</cfif>
</cfif>
<cfif not isdefined("attributes.work_address")>
	<cfif len(attributes.work_door_no)>
		<cfset work_door_no = '#attributes.work_door_no#'>
	<cfelse>
		<cfset work_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.work_district")>
		<cfset attributes.work_address = '#attributes.work_district# #attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	<cfelse>
		<cfset attributes.work_address = '#attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	</cfif>
</cfif>
<cfif not isdefined("attributes.tax_address")>
	<cfif len(attributes.tax_door_no)>
		<cfset tax_door_no = '#attributes.tax_door_no#'>
	<cfelse>
		<cfset tax_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.tax_district")>
		<cfset attributes.tax_address = '#attributes.tax_district# #attributes.tax_main_street# #attributes.tax_street# #tax_door_no#'>
	<cfelse>
		<cfset attributes.tax_address = '#attributes.tax_main_street# #attributes.tax_street# #tax_door_no#'>
	</cfif>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
  <cftransaction>
	<cfquery name="UPD_CONSUMER" datasource="#DSN#">
		UPDATE
			CONSUMER 
		SET
			CONSUMER_CAT_ID = #attributes.consumer_cat_id#,
			BIRTHDATE = <cfif len(attributes.birthdate)>#attributes.birthdate#<cfelse>NULL</cfif>,
			BIRTHPLACE = <cfif len(attributes.birthplace)>'#attributes.birthplace#'<cfelse>NULL</cfif>,
			CHILD = <cfif len(attributes.child)>'#attributes.child#'<cfelse>NULL</cfif>,
			COMPANY = <cfif len(attributes.company)>'#attributes.company#'<cfelse>NULL</cfif>,
			COMPANY_SIZE_CAT_ID = <cfif len(attributes.company_size_cat_id)>#attributes.company_size_cat_id#<cfelse>NULL</cfif>,
			CONSUMER_EMAIL = <cfif len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
			HOMEPAGE = '#attributes.homepage#',	
			CONSUMER_HOMETEL = <cfif len(attributes.home_tel)>'#attributes.home_tel#'<cfelse>NULL</cfif>,
			CONSUMER_HOMETELCODE = <cfif len(attributes.home_telcode)>'#attributes.home_telcode#'<cfelse>NULL</cfif>,
			CONSUMER_NAME = '#attributes.consumer_name#',
			<cfif len(attributes.consumer_password)>CONSUMER_PASSWORD = '#pass#',</cfif>
			CONSUMER_SURNAME = '#attributes.consumer_surname#',
			CONSUMER_USERNAME = <cfif len(attributes.consumer_username)>'#attributes.consumer_username#'<cfelse>NULL</cfif>,
			CONSUMER_WORKTEL = <cfif isdefined("attributes.work_tel") and len(attributes.work_tel)>'#attributes.work_tel#'<cfelse>NULL</cfif>,
			CONSUMER_WORKTELCODE = <cfif len(attributes.work_telcode)>'#attributes.work_telcode#'<cfelse>NULL</cfif>,
			EDUCATION_ID = <cfif len(attributes.education_level)>#attributes.education_level#<cfelse>NULL</cfif>,
			HOMEADDRESS = <cfif isdefined("attributes.home_address") and len(attributes.home_address)>'#attributes.home_address#'<cfelse>NULL</cfif>,
			HOMEPOSTCODE = <cfif len(attributes.home_postcode)>'#attributes.home_postcode#'<cfelse>NULL</cfif>,				
			HOMESEMT = <cfif len(attributes.home_semt)>'#attributes.home_semt#'<cfelse>NULL</cfif>,  
			HOME_COUNTY_ID = <cfif len(attributes.home_county_id)>#attributes.home_county_id#<cfelse>NULL</cfif>,
			HOME_CITY_ID = <cfif len(attributes.home_city_id)>#attributes.home_city_id#<cfelse>NULL</cfif>,
			HOME_COUNTRY_ID = <cfif len(attributes.home_country)>#attributes.home_country#<cfelse>NULL</cfif>,
			HOME_DISTRICT = <cfif isdefined("attributes.home_district") and len(attributes.home_district)>'#attributes.home_district#'<cfelse>NULL</cfif>,
			HOME_DISTRICT_ID = <cfif isdefined("attributes.home_district_id") and len(attributes.home_district_id)>#attributes.home_district_id#<cfelse>NULL</cfif>,
			HOME_MAIN_STREET = <cfif isdefined("attributes.home_main_street") and len(attributes.home_main_street)>'#attributes.home_main_street#'<cfelse>NULL</cfif>,
			HOME_STREET = <cfif isdefined("attributes.home_street") and len(attributes.home_street)>'#attributes.home_street#'<cfelse>NULL</cfif>,
			HOME_DOOR_NO = <cfif isdefined("attributes.home_door_no") and len(attributes.home_door_no)>'#attributes.home_door_no#'<cfelse>NULL</cfif>,
			DEPARTMENT = <cfif len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
			TITLE = '#attributes.title#',
			MISSION = <cfif len(attributes.mission)>#attributes.mission#<cfelse>NULL</cfif>,
			MOBIL_CODE = <cfif len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
			MOBILTEL = <cfif len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
			PICTURE = <cfif len(attributes.picture)>'#attributes.picture#'<cfelse>NULL</cfif>,
			PICTURE_SERVER_ID = <cfif len(attributes.picture)>#fusebox.server_machine#<cfelse>NULL</cfif>,
			SECTOR_CAT_ID = <cfif  isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>#attributes.sector_cat_id#<cfelse>NULL</cfif>,
			SEX = <cfif isdefined("attributes.sex") and attributes.sex eq 1>1<cfelse>0</cfif>,
			WORKPOSTCODE = <cfif len(attributes.work_postcode)>'#attributes.work_postcode#'<cfelse>NULL</cfif>,
			WORKSEMT = <cfif isdefined("attributes.work_semt") and len(attributes.work_semt)>'#attributes.work_semt#'<cfelse>NULL</cfif>,
			WORKADDRESS = <cfif len(attributes.work_address)>'#attributes.work_address#'<cfelse>NULL</cfif>,
			WORK_COUNTY_ID = <cfif len(attributes.work_county_id)>#attributes.work_county_id#<cfelse>NULL</cfif>,			
			WORK_CITY_ID = <cfif len(attributes.work_city_id)>#attributes.work_city_id#<cfelse>NULL</cfif>,
			WORK_COUNTRY_ID = <cfif len(attributes.work_country)>#attributes.work_country#<cfelse>NULL</cfif>,
			WORK_DISTRICT = <cfif isdefined("attributes.work_district") and len(attributes.work_district)>'#attributes.work_district#'<cfelse>NULL</cfif>,
			WORK_DISTRICT_ID = <cfif isdefined("attributes.work_district_id") and len(attributes.work_district_id)>#attributes.work_district_id#<cfelse>NULL</cfif>,
			WORK_MAIN_STREET = <cfif isdefined("attributes.work_main_street") and len(attributes.work_main_street)>'#attributes.work_main_street#'<cfelse>NULL</cfif>,
			WORK_STREET = <cfif isdefined("attributes.work_street") and len(attributes.work_street)>'#attributes.work_street#'<cfelse>NULL</cfif>,
			WORK_DOOR_NO = <cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>'#attributes.work_door_no#'<cfelse>NULL</cfif>,
			TAX_OFFICE = <cfif len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,	
			TAX_NO = <cfif len(attributes.tax_no)>'#attributes.tax_no#'<cfelse>NULL</cfif>,
			TAX_ADRESS = <cfif len(attributes.tax_address)>'#attributes.tax_address#'<cfelse>NULL</cfif>,
			TAX_POSTCODE = <cfif len(attributes.tax_postcode)>'#attributes.tax_postcode#'<cfelse>NULL</cfif>,
			TAX_SEMT = <cfif len(attributes.tax_semt)>'#attributes.tax_semt#'<cfelse>NULL</cfif>,
			TAX_COUNTY_ID = <cfif len(attributes.tax_county_id)>#attributes.tax_county_id#<cfelse>NULL</cfif>,
			TAX_CITY_ID = <cfif len(attributes.tax_city_id)>#attributes.tax_city_id#<cfelse>NULL</cfif>,
			TAX_COUNTRY_ID = <cfif len(attributes.tax_country)>#attributes.tax_country#<cfelse>NULL</cfif>,
			TAX_DISTRICT = <cfif isdefined("attributes.tax_district") and len(attributes.tax_district)>'#attributes.tax_district#'<cfelse>NULL</cfif>,
			TAX_DISTRICT_ID = <cfif isdefined("attributes.tax_district_id") and len(attributes.tax_district_id)>'#attributes.tax_district_id#'<cfelse>NULL</cfif>,
			TAX_MAIN_STREET = <cfif isdefined("attributes.tax_main_street") and len(attributes.tax_main_street)>'#attributes.tax_main_street#'<cfelse>NULL</cfif>,
			TAX_STREET = <cfif isdefined("attributes.tax_street") and len(attributes.tax_street)>'#attributes.tax_street#'<cfelse>NULL</cfif>,
			TAX_DOOR_NO = <cfif isdefined("attributes.tax_door_no") and len(attributes.tax_door_no)>'#attributes.tax_door_no#'<cfelse>NULL</cfif>,
			IS_CARI = <cfif isDefined("attributes.is_cari")>1<cfelse>0</cfif>,
			MARRIED = <cfif isDefined("attributes.married")>1<cfelse>0</cfif>,		
			TC_IDENTY_NO = '#attributes.tc_identity_no#',
			VOCATION_TYPE_ID = <cfif len(attributes.vocation_type)>#attributes.vocation_type#<cfelse>NULL</cfif>,
			NATIONALITY = <cfif len(attributes.nationality)>#attributes.nationality#<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			<cfif isdefined('session.pp')>
			UPDATE_EMP = #session.pp.userid#,
            UPDATE_CONS = NULL,
			<cfelse>
			UPDATE_EMP = #session.ww.userid#,
            UPDATE_CONS = NULL,
			</cfif>
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
  </cftransaction>
</cflock>			
<cflocation url="#request.self#?fuseaction=objects2.upd_my_consumer&consumer_id=#attributes.consumer_id#" addtoken="No">
