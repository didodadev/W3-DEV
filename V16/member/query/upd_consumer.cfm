<cfinclude template="../../objects/functions/add_consumer_history.cfm">
<cfif isdefined("attributes.startdate") and len(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif isdefined("attributes.birthdate") and len(attributes.birthdate)><cf_date tarih='attributes.birthdate'></cfif>
<cfif isdefined("attributes.married_date") and len(attributes.married_date)><cf_date tarih='attributes.married_date'></cfif>
<cfif isdefined("attributes.efatura_date") and len(attributes.efatura_date)><cf_date tarih='attributes.efatura_date'></cfif>
<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.consumer_name=replacelist(form.consumer_name,list,list2)>
<cfset attributes.consumer_surname=replacelist(form.consumer_surname,list,list2)>
<cfif isDefined("attributes.home_door_no")>
	<cfset attributes.home_door_no=replacelist(form.home_door_no,list,list2)>
	<cfset attributes.home_door_no=replacelist(attributes.home_door_no,'/','-')>
</cfif>
<cfif isDefined("attributes.work_door_no")>
	<cfset attributes.work_door_no=replacelist(form.work_door_no,list,list2)>
	<cfset attributes.work_door_no=replacelist(attributes.work_door_no,'/','-')>               
</cfif>

<!--- Bireysel Uye Ad ve Soyad Bilgilerinin Yazim Standardi Xml Uzerinden Belirlenerek Sekillenir FBS20110307 --->
<cfif isDefined("x_name_surname_write_standart") and x_name_surname_write_standart eq 1><!--- Sadece Bas Harfler Buyuk --->
	<cfset a = "">
	<cfloop from="1" to="#listlen(attributes.consumer_name,' ')#" index="i">
		<cfif len(listgetat(attributes.consumer_name,i,' ')) gt 1>
			<cfset b = UCASETR(left(listgetat(attributes.consumer_name,i,' '),1)) & LCASETR(right(listgetat(attributes.consumer_name,i,' '),len(listgetat(attributes.consumer_name,i,' '))-1))>
		<cfelse>
			<cfset b = UCASETR(left(listgetat(attributes.consumer_name,i,' '),1))>
		</cfif>
		<cfset a = '#a# #b#'>	
	</cfloop>
	<cfset attributes.consumer_name = trim(a)>
	
	<cfset a = "">
	<cfloop from="1" to="#listlen(attributes.consumer_surname,' ')#" index="i">
		<cfif len(listgetat(attributes.consumer_surname,i,' ')) gt 1>
			<cfset b = UCASETR(left(listgetat(attributes.consumer_surname,i,' '),1)) & LCASETR(right(listgetat(attributes.consumer_surname,i,' '),len(listgetat(attributes.consumer_surname,i,' '))-1))>
		<cfelse>
			<cfset b = UCASETR(left(listgetat(attributes.consumer_surname,i,' '),1))>
		</cfif>
		<cfset a = '#a# #b#'>	
	</cfloop>
	<cfset attributes.consumer_surname = trim(a)>
<cfelseif isDefined("x_name_surname_write_standart") and x_name_surname_write_standart eq 2><!--- Tamami Buyuk --->
	<cfset attributes.consumer_name = trim(UCASETR(attributes.consumer_name))>
	<cfset attributes.consumer_surname = trim(UCASETR(attributes.consumer_surname))>
<cfelseif isDefined("x_name_surname_write_standart") and x_name_surname_write_standart eq 3><!--- Tamami Kucuk --->
	<cfset attributes.consumer_name = trim(LCASETR(attributes.consumer_name))>
	<cfset attributes.consumer_surname = trim(LCASETR(attributes.consumer_surname))>
</cfif>
<!--- //Bireysel Uye Ad ve Soyad Bilgilerinin Yazim Standardi Xml Uzerinden Belirlenerek Sekillenir --->

<cfif isdefined("attributes.consumer_password") and len(attributes.consumer_password)><cf_cryptedpassword password='#attributes.consumer_password#' output='PASS' mod=1></cfif>
<cfif (isdefined("attributes.consumer_username") and len(attributes.consumer_username)) and (isdefined("attributes.consumer_password") and len(attributes.consumer_password))>
<cfquery name="GET_CONS_NAME" datasource="#DSN#">
	SELECT 
		CONSUMER_ID, 
		CONSUMER_USERNAME 
	FROM 
		CONSUMER 
	WHERE 
		CONSUMER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consumer_username#"> AND 
		CONSUMER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pass#"> AND 
		CONSUMER_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
</cfquery>
<cfif get_cons_name.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='139.kullanıcı adı'>/<cf_get_lang_main no='140.şifre'><cf_get_lang_main no='781.tekrarı'>");
		window.history.go(-1);
	</script>
	<cfabort>
</cfif>
</cfif>

<!--- Uye Kodlarinin tekrarini onlemek icin eklenmistir. FB 20070928 --->
<cfif isDefined("attributes.customer_number") and len(attributes.customer_number)>
	<cfquery name="GET_CONSUMER_MEMBER_CODE" datasource="#DSN#">
		SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.customer_number)#">
	</cfquery>
	<cfif get_consumer_member_code.recordcount gte 1>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no ='569.üye kodu'> <cf_get_lang_main no='781.tekrarı'>!");
			history.back();
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
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
</cfquery>
<cfif isdefined("attributes.del_photo")>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="UPD_PHOTO" datasource="#DSN#">
				UPDATE CONSUMER SET PICTURE = '' WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.consumer_id#">
			</cfquery>
		</cftransaction>
	</cflock>
	<cfif len(get_det.picture)>
		<cf_del_server_file output_file="member/consumer/#get_det.picture#" output_server="#get_det.picture_server_id#">
	</cfif> 
</cfif>

<!---<cfset attributes.home_address = ''>
<cfif isdefined("attributes.home_door_no") and len(attributes.home_door_no)>
	<cfset home_door_no = '#attributes.home_door_no#'>
<cfelse>
	<cfset home_door_no = ''>
</cfif>
<cfif isdefined("attributes.home_door_no") and isdefined("attributes.home_district")>
	<cfset attributes.home_address = '#attributes.home_district# #attributes.home_main_street# #attributes.home_street# #home_door_no#'>
<cfelseif isdefined("attributes.home_door_no")>
	<cfset attributes.home_address = '#attributes.home_main_street# #attributes.home_street# #home_door_no#'>
</cfif> 

<cfif not isdefined("attributes.work_address")>
	<cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>
		<cfset work_door_no = '#attributes.work_door_no#'>
	<cfelse>
		<cfset work_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.work_door_no") and isdefined("attributes.work_district")>
		<cfset attributes.work_address = '#attributes.work_district# #attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	<cfelseif isdefined("attributes.work_door_no")>
		<cfset attributes.work_address = '#attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	</cfif>
</cfif>

--->
<cfif isDefined('attributes.is_adres_detail') and attributes.is_adres_detail eq 1>
	<cfset attributes.home_address = ''>
    <cfif isdefined("attributes.home_door_no") and len(attributes.home_door_no)>
        <cfset home_door_no = '#attributes.home_door_no#'>
    <cfelse>
        <cfset home_door_no = ''>
    </cfif>
    <cfif isdefined("attributes.home_semt") and len(attributes.home_semt)>
        <cfset attributes.home_address = '#attributes.home_semt#'>
    <cfelse>
        <cfset attributes.home_address = ''>
    </cfif>
    <cfif isdefined("attributes.home_district") and len(attributes.home_district)>
        <cfset attributes.home_address = '#attributes.home_address# #attributes.home_district# #attributes.home_main_street# #attributes.home_street# #home_door_no#'>
    <cfelse>
        <cfset attributes.home_address = '#attributes.home_address# #attributes.home_main_street# #attributes.home_street# #home_door_no#'>
    </cfif>
</cfif>
<cfif isDefined('attributes.is_adres_detail') and attributes.is_adres_detail eq 1>
	<cfset attributes.work_address = ''>
    <cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>
        <cfset work_door_no = '#attributes.work_door_no#'>
    <cfelse>
        <cfset work_door_no = ''>
    </cfif>
    <cfif isdefined("attributes.work_street") and len(attributes.work_street)>
        <cfset attributes.work_address = '#attributes.work_street#'>
    <cfelse>
        <cfset attributes.work_address = ''>
    </cfif>
    <cfif isdefined("attributes.work_district") and len(attributes.work_district)>
        <cfset attributes.work_address = '#attributes.work_address# #attributes.work_district# #attributes.work_main_street# #attributes.work_street# #work_door_no#'>
    <cfelse>
        <cfset attributes.work_address = '#attributes.work_address# #attributes.work_main_street# #attributes.work_street# #work_door_no#'>
    </cfif>
</cfif>

<cfif isdefined("attributes.is_tax_address")>
	<cfset attributes.tax_address = attributes.home_address>
	<cfset attributes.tax_postcode = attributes.home_postcode>	
	<cfif isdefined("attributes.home_semt")>
		<cfset attributes.tax_semt = attributes.home_semt>
	</cfif>
	<cfif isdefined("attributes.home_country")>
		<cfset attributes.tax_country = attributes.home_country>
	</cfif>
	<cfif isdefined("attributes.home_county_id")>
		<cfset attributes.tax_county_id = attributes.home_county_id>
	</cfif>
	<cfif isdefined("attributes.home_city_id")>
		<cfset attributes.tax_city_id = attributes.home_city_id>
	</cfif>
	<cfif isdefined("attributes.home_district")>
		<cfset attributes.tax_district = attributes.home_district>
	</cfif>
	<cfif isdefined("attributes.home_district_id")>
		<cfset attributes.tax_district_id = attributes.home_district_id>
	</cfif>
	<cfif isdefined("attributes.home_main_street")>
		<cfset attributes.tax_main_street = attributes.home_main_street>
	</cfif>
	<cfif isdefined("attributes.home_street")>
		<cfset attributes.tax_street = attributes.home_street>
	</cfif>
	<cfif isdefined("attributes.home_door_no")>
		<cfset attributes.tax_door_no = attributes.home_door_no>
	</cfif>
<cfelseif isdefined("attributes.is_tax_address_2")>
	<cfset attributes.tax_address = attributes.work_address>
	<cfset attributes.tax_postcode = attributes.work_postcode>	
    <cfif isDefined('attributes.work_semt')>
		<cfset attributes.tax_semt = attributes.work_semt>
	</cfif>
	<cfset attributes.tax_country = attributes.work_country>
	<cfset attributes.tax_county_id = attributes.work_county_id>
	<cfset attributes.tax_city_id = attributes.work_city_id>
	<cfif isdefined("attributes.work_district")>
		<cfset attributes.tax_district = attributes.work_district>
	</cfif>
	<cfif isdefined("attributes.work_district_id")>
		<cfset attributes.tax_district_id = attributes.work_district_id>
	</cfif>
    <cfif isDefined('attributes.work_main_street')>
		<cfset attributes.tax_main_street = attributes.work_main_street>
	</cfif>
    <cfif isDefined('attributes.work_street')>
		<cfset attributes.tax_street = attributes.work_street>
	</cfif>
    <cfif isDefined('attributes.work_door_no')>
		<cfset attributes.tax_door_no = attributes.work_door_no>
	</cfif>
<cfelse>
	<!---<cfif not isdefined("attributes.tax_address")>
		<cfif isdefined("attributes.tax_door_no") and len(attributes.tax_door_no)>
			<cfset tax_door_no = '#attributes.tax_door_no#'>
		<cfelse>
			<cfset tax_door_no = ''>
		</cfif>
		<cfif isdefined("attributes.tax_door_no") and isdefined("attributes.tax_district")>
			<cfset attributes.tax_address = '#attributes.tax_district# #attributes.tax_main_street# #attributes.tax_street# #tax_door_no#'>
		<cfelseif isdefined("attributes.tax_door_no")>
			<cfset attributes.tax_address = '#attributes.tax_main_street# #attributes.tax_street# #tax_door_no#'>
		</cfif>
	</cfif>--->
    <cfif isDefined('attributes.is_adres_detail') and attributes.is_adres_detail eq 1>
		<cfset attributes.tax_address = ''>
        <cfif isdefined("attributes.tax_door_no") and len(attributes.tax_door_no)>
            <cfset tax_door_no = '#attributes.tax_door_no#'>
        <cfelse>
            <cfset tax_door_no = ''>
        </cfif>
        <cfif isdefined("attributes.tax_street") and len(attributes.tax_street)>
            <cfset attributes.tax_address = '#attributes.tax_street#'>
        <cfelse>
            <cfset attributes.tax_address = ''>
        </cfif>
        <cfif isdefined("attributes.tax_district") and len(attributes.tax_district)>
            <cfset attributes.tax_address = '#attributes.tax_address# #attributes.tax_district# #attributes.tax_main_street# #attributes.tax_street# #tax_door_no#'>
        <cfelse>
            <cfset attributes.tax_address = '#attributes.tax_address# #attributes.tax_main_street# #attributes.tax_street# #tax_door_no#'>
        </cfif>
    </cfif>
</cfif>
<cfif isdefined("attributes.picture") and len(attributes.picture)>
	<cfset file_name = createUUID()>
	<cffile action="UPLOAD" 					 
		nameconflict="MAKEUNIQUE" 
		destination="#upload_folder#member#dir_seperator#consumer#dir_seperator#"
		filefield="picture">
	<cffile action="rename"
		source="#upload_folder#member#dir_seperator#consumer#dir_seperator##cffile.serverfile#" 
		destination="#upload_folder#member#dir_seperator#consumer#dir_seperator##file_name#.#cffile.serverfileext#">
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
					PICTURE_SERVER_ID = #fusebox.server_machine#
				WHERE 
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfquery>
		</cftransaction>
	</cflock>	
</cfif>
<cfscript>
	if (isdefined("attributes.consumer_password") and len(attributes.consumer_password) and attributes.consumer_password contains "***")
		structdelete(form,consumer_password);
	if (isdefined("attributes.del_photo"))
		structdelete(form,"del_photo");
	if (isdefined("attributes.picture"))
		structdelete(form,"picture");
</cfscript>
<cfset source_list ="\,\n,#Chr(13)#,#Chr(10)#"><!--- Newline karakterlerinin database e yazılmaması için eklenmiştir diğer replace ler listeye alınmıştır. --->
<cfset replaced_list = "/, , , "> 
<cfif isdefined("attributes.home_address")>
	<cfset attributes.home_address=replacelist(attributes.home_address,source_list,replaced_list)>
</cfif>
<cfif isdefined("attributes.work_address")>
	<cfset attributes.work_address=replacelist(attributes.work_address,source_list,replaced_list)>
</cfif>
<cfif isdefined("attributes.tax_address")>
	<cfset attributes.tax_address=replacelist(attributes.tax_address,source_list,replaced_list)>
</cfif>
<cfquery name="GET_CAMP_DATE" datasource="#DSN#">
	SELECT CAMP_STARTDATE,CAMP_FINISHDATE,CAMP_ID FROM #dsn3_alias#.CAMPAIGNS WHERE CAMP_STARTDATE < #now()# AND CAMP_FINISHDATE > #now()#
</cfquery>
<cflock name="#CreateUUID()#" timeout="20">
  <cftransaction>
	<!--- History - Belirtilen kosullarda degisiklik varsa history ye kayit atiyor FBS 20080409 --->
	<cfquery name="HIST_CONT" datasource="#DSN#">
		SELECT
			*,
			(SELECT MAX(POSITION_CODE) POS_CODE FROM WORKGROUP_EMP_PAR WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND IS_MASTER = 1) AGENT_POS_CODE
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
	<cfif 	(isdefined("attributes.consumer_cat_id") and attributes.consumer_cat_id neq hist_cont.consumer_cat_id) or 
			(attributes.consumer_name neq hist_cont.consumer_name) or (attributes.consumer_surname neq hist_cont.consumer_surname) or
			(isdefined("attributes.customer_number") and attributes.customer_number neq hist_cont.member_code) or (attributes.process_stage neq hist_cont.consumer_stage) or
			attributes.consumer_email neq hist_cont.consumer_email or (attributes.mobilcat_id neq hist_cont.mobil_code) or (attributes.mobiltel neq hist_cont.mobiltel) or
			(isdefined("attributes.home_telcode") and attributes.home_telcode neq hist_cont.consumer_hometelcode) or (isdefined("attributes.home_tel") and attributes.home_tel neq hist_cont.consumer_hometel) or
			(isdefined("attributes.home_semt") and attributes.home_semt neq hist_cont.homesemt) or (isdefined("attributes.home_county_id") and attributes.home_county_id neq hist_cont.home_county_id) or
			(isdefined("attributes.home_city_id") and attributes.home_city_id neq hist_cont.home_city_id) or (isdefined("attributes.home_country") and attributes.home_country neq hist_cont.home_country_id) or
			(isdefined("attributes.home_address") and attributes.home_address neq hist_cont.homeaddress) or (isdefined("attributes.home_postcode") and attributes.home_postcode neq hist_cont.homepostcode) or
			(isdefined("attributes.home_district") and  attributes.home_district neq hist_cont.home_district) or (isdefined("attributes.home_district_id") and  attributes.home_district_id neq hist_cont.home_district_id) or
			(isdefined("attributes.home_main_street") and  attributes.home_main_street neq hist_cont.home_main_street) or (isdefined("attributes.home_street") and  attributes.home_street neq hist_cont.home_street) or			
			(isdefined("attributes.home_door_no") and  attributes.home_door_no neq hist_cont.home_door_no) or
			(isdefined("attributes.work_faxcode") and attributes.work_faxcode neq hist_cont.consumer_faxcode) or (isdefined("attributes.work_fax") and attributes.work_fax neq hist_cont.consumer_fax) or
			(isDefined("attributes.work_telcode") and attributes.work_telcode neq hist_cont.consumer_worktelcode) or (isdefined("attributes.work_tel") and attributes.work_tel neq hist_cont.consumer_worktel) or
			(isdefined("attributes.work_tel_ext") and attributes.work_tel_ext neq hist_cont.consumer_tel_ext) or (isdefined("attributes.work_address") and attributes.work_address neq hist_cont.workaddress) or
			(isdefined("attributes.work_postcode") and attributes.work_postcode neq hist_cont.workpostcode) or (isdefined("attributes.work_semt") and attributes.work_semt neq hist_cont.worksemt) or
			(isdefined("attributes.work_county_id") and attributes.work_county_id neq hist_cont.work_county_id) or (isdefined("attributes.work_city_id") and attributes.work_city_id neq hist_cont.work_city_id) or
			(isdefined("attributes.work_country") and attributes.work_country neq hist_cont.work_country_id) or (isdefined("attributes.work_district") and  attributes.work_district neq hist_cont.work_district) or
			(isdefined("attributes.work_district_id") and  attributes.work_district_id neq hist_cont.work_district_id) or (isdefined("attributes.work_main_street") and  attributes.work_main_street neq hist_cont.work_main_street) or
			(isdefined("attributes.work_street") and  attributes.work_street neq hist_cont.work_street) or (isdefined("attributes.work_door_no") and  attributes.work_door_no neq hist_cont.work_door_no) or
			(attributes.tax_office neq hist_cont.tax_office) or (attributes.tax_no neq hist_cont.tax_no) or 
			(isdefined("attributes.is_taxpayer") and attributes.is_taxpayer neq hist_cont.is_taxpayer) or
			(isdefined("attributes.tax_address") and attributes.tax_address neq hist_cont.tax_adress) or (isdefined("attributes.tax_district") and  attributes.tax_district neq hist_cont.tax_district) or
			(isdefined("attributes.tax_district_id") and  attributes.tax_district_id neq hist_cont.tax_district_id) or (attributes.tax_postcode neq hist_cont.tax_postcode) or (isDefined('attributes.tax_semt') and attributes.tax_semt neq hist_cont.tax_semt) or
			(attributes.tax_county_id neq hist_cont.tax_county_id) or (attributes.tax_city_id neq hist_cont.tax_city_id) or (attributes.tax_country neq hist_cont.tax_country_id) or
			(isdefined("attributes.vocation_type") and attributes.vocation_type neq hist_cont.vocation_type_id) or (isdefined("attributes.tc_identity_no") and attributes.tc_identity_no neq hist_cont.tc_identy_no) or 
			(isdefined("attributes.father") and attributes.father neq hist_cont.father) or (isdefined("attributes.mother") and attributes.mother neq hist_cont.mother) or
			(isdefined("attributes.sales_county") and attributes.sales_county neq hist_cont.sales_county) or (isdefined("attributes.consumer_status") and attributes.consumer_status neq hist_cont.consumer_status) or 
			(isdefined("attributes.ispotantial") and attributes.ispotantial neq hist_cont.ispotantial) or (isdefined("attributes.is_cari") and attributes.is_cari neq hist_cont.is_cari) or 
			(isdefined("attributes.is_related_consumer") and attributes.is_related_consumer neq hist_cont.is_related_consumer) or
			(isdefined("attributes.consumer_password") and attributes.consumer_password neq hist_cont.consumer_password) or
			(isdefined("attributes.reference_code") and attributes.reference_code neq hist_cont.consumer_reference_code) or 
			(isdefined("attributes.ref_pos_code") and attributes.ref_pos_code neq hist_cont.ref_pos_code) or
			(isdefined("attributes.pos_code") and attributes.pos_code neq hist_cont.agent_pos_code) or
			(isdefined("attributes.proposer_cons_id") and attributes.proposer_cons_id neq hist_cont.proposer_cons_id) or
			(isdefined("attributes.mobiltel") and attributes.mobiltel neq hist_cont.mobiltel) or
			(isdefined("attributes.mobiltel_2") and attributes.mobiltel_2 neq hist_cont.mobiltel_2)>
			<cfoutput query="hist_cont">
				<cfif (isdefined("attributes.consumer_password") and attributes.consumer_password neq hist_cont.consumer_password)>
					<cf_cryptedpassword password='#hist_cont.consumer_password#' output='hist_pass' mod='1'>
				</cfif>
				<cfquery name="ADD_CONSUMER_HIST" datasource="#DSN#">
					INSERT INTO
						CONSUMER_HISTORY
					(
						CONSUMER_ID,
						PERIOD_ID,
						CONSUMER_CAT_ID,
						CONSUMER_NAME,
						CONSUMER_SURNAME,
						MEMBER_CODE,
						AGENT_POS_CODE,
						COMPANY,
						CONSUMER_STAGE,
						CONSUMER_EMAIL,
						MOBIL_CODE,
						MOBILTEL,
						MOBIL_CODE_2,
						MOBILTEL_2,
						CONSUMER_FAXCODE,
						CONSUMER_FAX,
						CONSUMER_HOMETELCODE,
						CONSUMER_HOMETEL,
						HOMEADDRESS,
						HOMEPOSTCODE,
						HOMESEMT,
						HOME_COUNTY_ID,
						HOME_CITY_ID,
						HOME_COUNTRY_ID,
						HOME_DISTRICT,
						HOME_DISTRICT_ID,
						HOME_MAIN_STREET,
						HOME_STREET,
						HOME_DOOR_NO,
						CONSUMER_WORKTELCODE,
						CONSUMER_WORKTEL,
						CONSUMER_TEL_EXT,
						WORKADDRESS,
						WORKPOSTCODE,
						WORKSEMT,
						WORK_COUNTY_ID,
						WORK_CITY_ID,
						WORK_COUNTRY_ID,
						WORK_DISTRICT,
						WORK_DISTRICT_ID,
						WORK_MAIN_STREET,
						WORK_STREET,
						WORK_DOOR_NO,
						TAX_OFFICE,
						TAX_NO,
						TAX_ADRESS,
						TAX_POSTCODE,
						TAX_SEMT,
						TAX_COUNTY_ID,
						TAX_CITY_ID,
						TAX_COUNTRY_ID,
						TAX_DISTRICT,
						TAX_DISTRICT_ID,
						TAX_MAIN_STREET,
						TAX_STREET,
						TAX_DOOR_NO,
						VOCATION_TYPE_ID,
						TC_IDENTY_NO,
						FATHER,
						MOTHER,
						SALES_COUNTY,
						CONSUMER_STATUS,
						IS_TAXPAYER,
						ISPOTANTIAL,
						IS_CARI,
						IS_RELATED_CONSUMER,
						<cfif isdefined("attributes.consumer_password") and len(consumer_password)>CONSUMER_PASSWORD,</cfif>
						CONSUMER_REFERENCE_CODE,
						REF_POS_CODE,
						PROPOSER_CONS_ID,
						MARRIED,
						MARRIED_DATE,
                        USE_EFATURA,
                        EFATURA_DATE,
						MEMBER_UPDATE_EMP,
						MEMBER_UPDATE_DATE,
						MEMBER_UPDATE_IP,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#consumer_id#,
						<cfif len(period_id)>#period_id#<cfelse>NULL</cfif>,
						#consumer_cat_id#,
						#sql_unicode()#'#consumer_name#',
						#sql_unicode()#'#consumer_surname#',
						<cfif len(member_code)>'#trim(member_code)#'<cfelse>'B#consumer_id#'</cfif>,
						<cfif len(agent_pos_code)>#agent_pos_code#<cfelse>NULL</cfif>,
						<cfif len(company)>'#company#'<cfelse>NULL</cfif>,
						#consumer_stage#,
						<cfif len(consumer_email)>'#consumer_email#'<cfelse>NULL</cfif>,
						<cfif len(mobil_code)>'#mobil_code#'<cfelse>NULL</cfif>,
						<cfif len(mobiltel)>'#mobiltel#'<cfelse>NULL</cfif>,
						<cfif len(mobil_code_2)>'#mobil_code_2#'<cfelse>NULL</cfif>,
						<cfif len(mobiltel_2)>'#mobiltel_2#'<cfelse>NULL</cfif>,
						<cfif len(consumer_faxcode)>'#consumer_faxcode#'<cfelse>NULL</cfif>,
						<cfif len(consumer_fax)>'#consumer_fax#'<cfelse>NULL</cfif>,
						<cfif len(consumer_hometelcode)>'#consumer_hometelcode#'<cfelse>NULL</cfif>,
						<cfif len(consumer_hometel)>'#consumer_hometel#'<cfelse>NULL</cfif>,
						<cfif len(homeaddress)>'#homeaddress#'<cfelse>NULL</cfif>,
						<cfif len(homepostcode)>'#homepostcode#'<cfelse>NULL</cfif>,				
						<cfif len(homesemt)>'#homesemt#'<cfelse>NULL</cfif>,  
						<cfif len(home_county_id)>#home_county_id#<cfelse>NULL</cfif>,
						<cfif len(home_city_id)>#home_city_id#<cfelse>NULL</cfif>,
						<cfif len(home_country_id)>#home_country_id#<cfelse>NULL</cfif>,
						<cfif len(home_district)>'#home_district#'<cfelse>NULL</cfif>,
						<cfif len(home_district_id)>'#home_district_id#'<cfelse>NULL</cfif>,
						<cfif len(home_main_street)>'#home_main_street#'<cfelse>NULL</cfif>,
						<cfif len(home_street)>'#home_street#'<cfelse>NULL</cfif>,
						<cfif len(home_door_no)>'#wrk_eval("home_door_no")#'<cfelse>NULL</cfif>,
						<cfif len(consumer_worktelcode)>'#consumer_worktelcode#'<cfelse>NULL</cfif>,
						<cfif len(consumer_worktel)>'#consumer_worktel#'<cfelse>NULL</cfif>,
						<cfif len(consumer_tel_ext)>'#consumer_tel_ext#'<cfelse>NULL</cfif>,
						<cfif len(workaddress)>'#workaddress#'<cfelse>NULL</cfif>,
						<cfif len(workpostcode)>'#workpostcode#'<cfelse>NULL</cfif>,
						<cfif len(worksemt)>'#worksemt#'<cfelse>NULL</cfif>,
						<cfif len(work_county_id)>#work_county_id#<cfelse>NULL</cfif>,			
						<cfif len(work_city_id)>#work_city_id#<cfelse>NULL</cfif>,
						<cfif len(work_country_id)>#work_country_id#<cfelse>NULL</cfif>,
						<cfif len(work_district)>'#work_district#'<cfelse>NULL</cfif>,
						<cfif len(work_district_id)>'#work_district_id#'<cfelse>NULL</cfif>,
						<cfif len(work_main_street)>'#work_main_street#'<cfelse>NULL</cfif>,
						<cfif len(work_street)>'#work_street#'<cfelse>NULL</cfif>,
						<cfif len(work_door_no)>'#wrk_eval("work_door_no")#'<cfelse>NULL</cfif>,
						<cfif len(tax_office)>'#tax_office#'<cfelse>NULL</cfif>,
						<cfif len(tax_no)>'#tax_no#'<cfelse>NULL</cfif>,
						<cfif len(tax_adress)>'#tax_adress#'<cfelse>NULL</cfif>,
						<cfif len(tax_postcode)>'#tax_postcode#'<cfelse>NULL</cfif>,
						<cfif len(tax_semt)>'#tax_semt#'<cfelse>NULL</cfif>,
						<cfif len(tax_county_id)>#tax_county_id#<cfelse>NULL</cfif>,
						<cfif len(tax_city_id)>#tax_city_id#<cfelse>NULL</cfif>,
						<cfif len(tax_country_id)>#tax_country_id#<cfelse>NULL</cfif>,
						<cfif len(tax_district)>'#tax_district#'<cfelse>NULL</cfif>,
						<cfif len(tax_district_id)>'#tax_district_id#'<cfelse>NULL</cfif>,
						<cfif len(tax_main_street)>'#tax_main_street#'<cfelse>NULL</cfif>,
						<cfif len(tax_street)>'#tax_street#'<cfelse>NULL</cfif>,
						<cfif len(tax_door_no)>'#tax_door_no#'<cfelse>NULL</cfif>,
						<cfif len(vocation_type_id)>#vocation_type_id#<cfelse>NULL</cfif>,
						'#tc_identity_no#',
						<cfif len(father)>'#father#'<cfelse>NULL</cfif>,
						<cfif len(mother)>'#mother#'<cfelse>NULL</cfif>,
						<cfif len(sales_county)>#sales_county#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.consumer_status") and len(attributes.consumer_status)>1<cfelse>0</cfif>,
						<cfif len(is_taxpayer)>#is_taxpayer#<cfelse>NULL</cfif>,
						<cfif len(ispotantial)>#ispotantial#<cfelse>NULL</cfif>,
						<cfif len(is_cari)>#is_cari#<cfelse>NULL</cfif>,
						<cfif len(is_related_consumer)>#is_related_consumer#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.consumer_password") and len(consumer_password)>'#hist_pass#',</cfif>
						<cfif isdefined("attributes.reference_code") and len(attributes.reference_code) and isdefined("attributes.ref_pos_code") and len(attributes.ref_pos_code)>
							<cfif not listfind(attributes.reference_code,attributes.ref_pos_code,'.')>
								'#attributes.reference_code#.#attributes.ref_pos_code#'
							<cfelse>
								'#attributes.reference_code#'
							</cfif>
						<cfelseif isdefined("attributes.ref_pos_code") and len(attributes.ref_pos_code) and  not len(attributes.reference_code)>
							'#attributes.ref_pos_code#'
						<cfelse>
						NULL
						</cfif>,
						<cfif isdefined("attributes.ref_pos_code") and len(attributes.ref_pos_code)>#attributes.ref_pos_code#<cfelse>NULL</cfif>,
						<cfif len(proposer_cons_id)>#proposer_cons_id#<cfelse>NULL</cfif>,
						<cfif isdefined("married") and married eq 1>1<cfelse>0</cfif>,
						<cfif isDefined("married") and isdefined("married_date") and len(married_date)>#CreateOdbcDatetime(married_date)#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.use_efatura")>1<cfelse>0</cfif>,
                        <cfif isdefined("attributes.efatura_date") and len(attributes.efatura_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.efatura_date#"><cfelse>NULL</cfif>,
						<cfif len(update_emp)><cfqueryparam cfsqltype="cf_sql_integer" value="#update_emp#"><cfelse>NULL</Cfif>,
						<cfif len(update_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDatetime(update_date)#"><cfelse>NULL</cfif>,
						<cfif len(update_ip)><cfqueryparam cfsqltype="cf_sql_varchar" value="#Update_ip#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfif isDefined('cgi.remote_addr') and len(cgi.remote_addr)><cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"><cfelse>NULL</cfif>
					)
				</cfquery>
			</cfoutput>
	</cfif>
	
	<cfquery name="UPD_CONSUMER" datasource="#DSN#">
		UPDATE
			CONSUMER 
		SET
			CONSUMER_STAGE = #attributes.process_stage#,
			<cfif isdefined("attributes.consumer_cat_id")>CONSUMER_CAT_ID = #attributes.consumer_cat_id#,</cfif>
			MEMBER_CODE = <cfif isdefined("attributes.customer_number") and len(attributes.customer_number)>'#trim(attributes.customer_number)#'<cfelse>'B#attributes.consumer_id#'</cfif>,
			BIRTHDATE = <cfif isdefined("attributes.birthdate") and len(attributes.birthdate)>#attributes.birthdate#<cfelse>NULL</cfif>,
			BIRTHPLACE = <cfif isdefined("attributes.birthplace") and len(attributes.birthplace)>'#attributes.birthplace#'<cfelse>NULL</cfif>,
			CHILD = <cfif isdefined("attributes.child") and len(attributes.child)>'#attributes.child#'<cfelse>NULL</cfif>,
			COMPANY = <cfif isdefined("attributes.company") and len(attributes.company)>'#attributes.company#'<cfelse>NULL</cfif>,
			COMPANY_SIZE_CAT_ID = <cfif isdefined("attributes.company_size_cat_id") and len(attributes.company_size_cat_id)>#attributes.company_size_cat_id#<cfelse>NULL</cfif>,
			CONSUMER_EMAIL = <cfif len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
			CONSUMER_KEP_ADDRESS = <cfif isDefined("attributes.consumer_kep_address") and len(attributes.consumer_kep_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.consumer_kep_address)#"><cfelse>NULL</cfif>,
			HOMEPAGE = '#attributes.homepage#',			
			CONSUMER_FAX = <cfif isdefined("attributes.work_fax") and len(attributes.work_fax)>'#attributes.work_fax#'<cfelse>NULL</cfif>,
			CONSUMER_FAXCODE = <cfif isdefined("attributes.work_faxcode") and len(attributes.work_faxcode)>'#attributes.work_faxcode#'<cfelse>NULL</cfif>,
			CONSUMER_HOMETEL = <cfif isdefined("attributes.home_tel") and len(attributes.home_tel)>'#attributes.home_tel#'<cfelse>NULL</cfif>,
			CONSUMER_HOMETELCODE = <cfif isdefined("attributes.home_telcode") and len(attributes.home_telcode)>'#attributes.home_telcode#'<cfelse>NULL</cfif>,
			CONSUMER_NAME = #sql_unicode()#'#attributes.consumer_name#',
			<cfif isdefined("attributes.consumer_password") and len(attributes.consumer_password)>CONSUMER_PASSWORD = '#pass#',</cfif>
			CONSUMER_SURNAME = #sql_unicode()#'#attributes.consumer_surname#',
			CONSUMER_TEL_EXT = <cfif isdefined("attributes.work_tel_ext") and len(attributes.work_tel_ext)>'#attributes.work_tel_ext#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.consumer_username") and len(attributes.consumer_username)>CONSUMER_USERNAME = #sql_unicode()#'#attributes.consumer_username#',</cfif>
<!---		CONSUMER_USERNAME = <cfif isdefined("attributes.consumer_username") and len(attributes.consumer_username)>#sql_unicode()#'#attributes.consumer_username#'<cfelse>NULL</cfif>,--->
			CONSUMER_WORKTEL = <cfif isdefined("attributes.work_tel") and len(attributes.work_tel)>'#attributes.work_tel#'<cfelse>NULL</cfif>,
			CONSUMER_WORKTELCODE = <cfif isdefined("attributes.work_telcode") and len(attributes.work_telcode)>'#attributes.work_telcode#'<cfelse>NULL</cfif>,
			EDUCATION_ID = <cfif isdefined("attributes.education_level") and len(attributes.education_level)>#attributes.education_level#<cfelse>NULL</cfif>,
			HOMEADDRESS = <cfif isdefined("attributes.home_address") and len(attributes.home_address)>'#wrk_eval("attributes.home_address")#'<cfelse>NULL</cfif>,
			HOMEPOSTCODE = <cfif isdefined("attributes.home_postcode") and len(attributes.home_postcode)>'#attributes.home_postcode#'<cfelse>NULL</cfif>,				
			HOMESEMT = <cfif isdefined("attributes.home_semt") and len(attributes.home_semt)>'#attributes.home_semt#'<cfelse>NULL</cfif>,  
			HOME_COUNTY_ID = <cfif isdefined("attributes.home_county_id") and len(attributes.home_county_id)>#attributes.home_county_id#<cfelse>NULL</cfif>,
			HOME_CITY_ID = <cfif isdefined("attributes.home_city_id") and len(attributes.home_city_id)>#attributes.home_city_id#<cfelse>NULL</cfif>,
			HOME_COUNTRY_ID = <cfif isdefined("attributes.home_country") and len(attributes.home_country)>#attributes.home_country#<cfelse>NULL</cfif>,
			HOME_DISTRICT = <cfif isdefined("attributes.home_district") and len(attributes.home_district)>'#attributes.home_district#'<cfelse>NULL</cfif>,
			HOME_DISTRICT_ID = <cfif isdefined("attributes.home_district_id") and len(attributes.home_district_id)>#attributes.home_district_id#<cfelse>NULL</cfif>,
			HOME_MAIN_STREET = <cfif isdefined("attributes.home_main_street") and len(attributes.home_main_street)>'#attributes.home_main_street#'<cfelse>NULL</cfif>,
			HOME_STREET = <cfif isdefined("attributes.home_street") and len(attributes.home_street)>'#attributes.home_street#'<cfelse>NULL</cfif>,
			HOME_DOOR_NO = <cfif isdefined("attributes.home_door_no") and len(attributes.home_door_no)>'#wrk_eval("attributes.home_door_no")#'<cfelse>NULL</cfif>,
			IDENTYCARD_CAT = <cfif isdefined("attributes.identycard_cat") and len(attributes.identycard_cat)>'#attributes.identycard_cat#'<cfelse>NULL</cfif>,
			IDENTYCARD_NO = <cfif isdefined("attributes.identycard_no") and len(attributes.identycard_no)>'#attributes.identycard_no#'<cfelse>NULL</cfif>,
			IM = <cfif len(attributes.im)>'#attributes.im#'<cfelse>NULL</cfif>,
			IMCAT_ID = <cfif len(attributes.imcat_id)>#attributes.imcat_id#<cfelse>NULL</cfif>,
			<!---<cfif is_dsp_status_check eq 1>--->CONSUMER_STATUS = <cfif isdefined("attributes.consumer_status") and len(attributes.consumer_status)>1<cfelse>0</cfif>,<!---</cfif>--->
			ISPOTANTIAL = <cfif isDefined("attributes.ispotantial") and len(attributes.ispotantial)>1<cfelse>0</cfif>,				
			DEPARTMENT = <cfif isdefined("attributes.department") and len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
			TITLE = <cfif isdefined("attributes.title") and len(attributes.title)>'#attributes.title#'<cfelse>NULL</cfif>,
			MISSION = <cfif isdefined("attributes.mission") and len(attributes.mission)>#attributes.mission#<cfelse>NULL</cfif>,
			MOBIL_CODE = <cfif len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
			MOBILTEL = <cfif len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
			MOBIL_CODE_2 = <cfif len(attributes.mobilcat_id_2)>'#attributes.mobilcat_id_2#'<cfelse>NULL</cfif>,
			MOBILTEL_2 = <cfif len(attributes.mobiltel_2)>'#attributes.mobiltel_2#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.del_photo")>PICTURE = NULL,</cfif>
			<cfif isdefined("attributes.del_photo")>PICTURE_SERVER_ID = NULL,</cfif>
			SECTOR_CAT_ID = <cfif isdefined("attributes.sector_cat_id") and len(attributes.sector_cat_id)>#attributes.sector_cat_id#<cfelse>NULL</cfif>,
			SEX = <cfif isdefined("attributes.sex") and attributes.sex eq 1>1<cfelse>0</cfif>,
			WORKPOSTCODE = <cfif isdefined("attributes.work_postcode") and len(attributes.work_postcode)>'#attributes.work_postcode#'<cfelse>NULL</cfif>,
			WORKSEMT = <cfif isdefined("attributes.work_semt") and len(attributes.work_semt)>'#attributes.work_semt#'<cfelse>NULL</cfif>,
			WORKADDRESS = <cfif isdefined("attributes.work_address") and len(attributes.work_address)>'#attributes.work_address#'<cfelse>NULL</cfif>,
			WORK_COUNTY_ID = <cfif isdefined("attributes.work_county_id") and len(attributes.work_county_id)>#attributes.work_county_id#<cfelse>NULL</cfif>,			
			WORK_CITY_ID = <cfif isdefined("attributes.work_city_id") and len(attributes.work_city_id)>#attributes.work_city_id#<cfelse>NULL</cfif>,
			WORK_COUNTRY_ID = <cfif isdefined("attributes.work_country") and len(attributes.work_country)>#attributes.work_country#<cfelse>NULL</cfif>,
			WORK_DISTRICT = <cfif isdefined("attributes.work_district") and len(attributes.work_district)>'#attributes.work_district#'<cfelse>NULL</cfif>,
			WORK_DISTRICT_ID = <cfif isdefined("attributes.work_district_id") and len(attributes.work_district_id)>#attributes.work_district_id#<cfelse>NULL</cfif>,
			WORK_MAIN_STREET = <cfif isdefined("attributes.work_main_street") and len(attributes.work_main_street)>'#attributes.work_main_street#'<cfelse>NULL</cfif>,
			WORK_STREET = <cfif isdefined("attributes.work_street") and len(attributes.work_street)>'#attributes.work_street#'<cfelse>NULL</cfif>,
			WORK_DOOR_NO = <cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>'#wrk_eval("attributes.work_door_no")#'<cfelse>NULL</cfif>,
			TAX_OFFICE = <cfif len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,	
			TAX_NO = <cfif len(attributes.tax_no)>'#attributes.tax_no#'<cfelse>NULL</cfif>,
			TAX_ADRESS = <cfif isdefined("attributes.tax_address") and len(attributes.tax_address)>'#attributes.tax_address#'<cfelse>NULL</cfif>,
			TAX_POSTCODE = <cfif len(attributes.tax_postcode)>'#attributes.tax_postcode#'<cfelse>NULL</cfif>,
			TAX_SEMT = <cfif isDefined('attributes.tax_semt') and len(attributes.tax_semt)>'#attributes.tax_semt#'<cfelse>NULL</cfif>,
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
			MARRIED_DATE = <cfif isDefined("attributes.married") and isdefined("attributes.married_date") and len(attributes.married_date)>#attributes.married_date#<cfelse>NULL</cfif>,
			IS_TAXPAYER = <cfif isDefined("attributes.is_taxpayer")>1<cfelse>0</cfif>,
			SALES_COUNTY = <cfif isDefined("attributes.sales_county") and len(attributes.sales_county)>#attributes.sales_county#<cfelse>NULL</cfif>,
			HIERARCHY_ID = <cfif isDefined("attributes.hierarchy_id") and len(attributes.hierarchy_id)>#attributes.hierarchy_id#<cfelse>NULL</cfif>,
			OZEL_KOD = <cfif isDefined("attributes.ozel_kod")>'#attributes.ozel_kod#'<cfelse>NULL</cfif>,
			CONSUMER_REFERENCE_CODE = 
			<cfif isdefined("attributes.ref_pos_code") and len(attributes.ref_pos_code) and len(attributes.ref_pos_code_name) and len(attributes.reference_code)>
				<cfif not listfind(attributes.reference_code,attributes.ref_pos_code,'.')>
					'#attributes.reference_code#.#attributes.ref_pos_code#'
				<cfelse>
					'#attributes.reference_code#'
				</cfif>
			<cfelseif isdefined("attributes.ref_pos_code") and len(attributes.ref_pos_code) and len(attributes.ref_pos_code_name) and not len(attributes.reference_code)>
				'#attributes.ref_pos_code#'
			<cfelse>
				NULL
			</cfif>,
			TC_IDENTY_NO = <cfif isdefined("attributes.tc_identity_no") and len(attributes.tc_identity_no)>'#attributes.tc_identity_no#'<cfelse>NULL</cfif>,
			SOCIAL_SOCIETY_ID = <cfif isdefined("attributes.social_society_id") and len(attributes.social_society_id)>#attributes.social_society_id#<cfelse>NULL</cfif>,
			START_DATE = <cfif isdefined("attributes.startdate") and len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
			IS_RELATED_CONSUMER = <cfif isdefined("attributes.is_related_consumer") and len(attributes.is_related_consumer)>1<cfelse>0</cfif>,
			IMS_CODE_ID = <cfif isDefined("attributes.ims_code_name") and len(attributes.ims_code_name) and len(attributes.ims_code_id)>#attributes.ims_code_id#<cfelse>NULL</cfif>,
			SOCIAL_SECURITY_NO = <cfif isdefined("attributes.social_security_no") and len(attributes.social_security_no)>'#attributes.social_security_no#'<cfelse>NULL</cfif>,
			INCOME_LEVEL_ID = <cfif isdefined("attributes.income_level") and len(attributes.income_level)>#attributes.income_level#<cfelse>NULL</cfif>,
			VOCATION_TYPE_ID = <cfif isdefined("attributes.vocation_type") and len(attributes.vocation_type)>#attributes.vocation_type#<cfelse>NULL</cfif>,
			NATIONALITY = <cfif isdefined("attributes.nationality") and len(attributes.nationality)>#attributes.nationality#<cfelse>NULL</cfif>,
			RESOURCE_ID = <cfif isdefined("attributes.resource") and len(attributes.resource)>#attributes.resource#<cfelse>NULL</cfif>,
			CUSTOMER_VALUE_ID = <cfif isDefined("attributes.customer_value") and len(attributes.customer_value)>#attributes.customer_value#<cfelse>NULL</cfif>,
		    BLOOD_TYPE = <cfif isdefined("attributes.blood_type") and len(attributes.blood_type)>#attributes.blood_type#<cfelse>NULL</cfif>,
			REF_POS_CODE = <cfif isdefined("attributes.ref_pos_code") and len(attributes.ref_pos_code) and len(attributes.ref_pos_code_name)>#attributes.ref_pos_code#<cfelse>NULL</cfif>,
			WANT_EMAIL = <cfif isdefined('attributes.not_want_email')>0<cfelse>1</cfif>,
			WANT_SMS = <cfif isdefined('attributes.not_want_sms')>0<cfelse>1</cfif>,
			<cfif isDefined("attributes.timeout_limit")>TIMEOUT_LIMIT = #attributes.timeout_limit#,</cfif>
			FATHER = <cfif isdefined("attributes.father") and len(attributes.father)>'#attributes.father#'<cfelse>NULL</cfif>,
			MOTHER = <cfif isdefined("attributes.mother") and len(attributes.mother)>'#attributes.mother#'<cfelse>NULL</cfif>,
			PROPOSER_CONS_ID = <cfif isDefined("attributes.proposer_cons_id") and len(attributes.proposer_cons_id) and len(attributes.proposer_cons_name)>#attributes.proposer_cons_id#<cfelse>NULL</cfif>,
			MEMBER_ADD_OPTION_ID = <cfif len(attributes.member_add_option_id)>#attributes.member_add_option_id#<cfelse>NULL</cfif>,
			TAX_ADDRESS_TYPE = <cfif isdefined("attributes.is_tax_address")>1<cfelseif isdefined("attributes.is_tax_address_2")>2<cfelse>NULL</cfif>,
			CAMPAIGN_ID = <cfif isdefined('attributes.camp_name') and len(attributes.camp_name) and isdefined('attributes.camp_id') and Len(attributes.camp_id)>#attributes.camp_id#<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
            UPDATE_CONS = NULL,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#',
			COORDINATE_1=<cfif isdefined("attributes.coordinate_1") and len(attributes.coordinate_1)>'#attributes.coordinate_1#'<cfelse>NULL</cfif>,
			COORDINATE_2=<cfif isdefined("attributes.coordinate_2") and len(attributes.coordinate_2)>'#attributes.coordinate_2#'<cfelse>NULL</cfif>,
			USE_EFATURA = <cfif isdefined("attributes.use_efatura")>1<cfelse>0</cfif>,
            EFATURA_DATE=<cfif isdefined("attributes.efatura_date") and len(attributes.efatura_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.efatura_date#"><cfelse>NULL</cfif>,
            USE_EARCHIVE = <cfif isdefined("attributes.use_earchive")>1<cfelse>0</cfif>,
            EARCHIVE_SENDING_TYPE = <cfif isdefined("attributes.earchive_sending_type") and len(attributes.earchive_sending_type)>#earchive_sending_type#<cfelse>NULL</cfif>,
			WANT_CALL = <cfif isdefined('attributes.not_want_call')>0<cfelse>1</cfif>
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
	
	<!--- Bireysel Uyenin Iliskili Oldugu Partner Varsa Bilgiler Update Edilir FBS 20110131 --->
	<cfquery name="GET_RELATED_PARTNER_CONTROL" datasource="#DSN#">
		SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND RELATED_CONSUMER_ID IS NOT NULL
	</cfquery>
	<cfif get_related_partner_control.recordcount>
		<cfloop query="get_related_partner_control">
			<cfquery name="UPD_RELATED_PARTNER" datasource="#DSN#">
				UPDATE
					COMPANY_PARTNER
				SET
					MEMBER_CODE = <cfif isdefined("attributes.customer_number") and len(attributes.customer_number)>'#trim(attributes.customer_number)#'<cfelse>'B#attributes.consumer_id#'</cfif>,
					COMPANY_PARTNER_EMAIL = <cfif len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
					HOMEPAGE = '#attributes.homepage#',			
					COMPANY_PARTNER_FAX = <cfif isdefined("attributes.work_fax") and len(attributes.work_fax)>'#attributes.work_fax#'<cfelse>NULL</cfif>,
					COMPANY_PARTNER_NAME = #sql_unicode()#'#attributes.consumer_name#',
					<cfif isdefined("attributes.consumer_password") and len(attributes.consumer_password)>COMPANY_PARTNER_PASSWORD = '#pass#',</cfif>
					COMPANY_PARTNER_SURNAME = #sql_unicode()#'#attributes.consumer_surname#',
					COMPANY_PARTNER_TEL_EXT = <cfif isdefined("attributes.work_tel_ext") and len(attributes.work_tel_ext)>'#attributes.work_tel_ext#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.consumer_username") and len(attributes.consumer_username)>COMPANY_PARTNER_USERNAME = #sql_unicode()#'#attributes.consumer_username#',</cfif>
					COMPANY_PARTNER_TEL = <cfif isdefined("attributes.work_tel") and len(attributes.work_tel)>'#attributes.work_tel#'<cfelse>NULL</cfif>,
					COMPANY_PARTNER_TELCODE = <cfif isdefined("attributes.work_telcode") and len(attributes.work_telcode)>'#attributes.work_telcode#'<cfelse>NULL</cfif>,
					IM = <cfif len(attributes.im)>'#attributes.im#'<cfelse>NULL</cfif>,
					IMCAT_ID = <cfif len(attributes.imcat_id)>#attributes.imcat_id#<cfelse>NULL</cfif>,
					<cfif is_dsp_status_check eq 1>COMPANY_PARTNER_STATUS = <cfif isdefined("attributes.consumer_status") and len(attributes.consumer_status)>1<cfelse>0</cfif>,</cfif>
					DEPARTMENT = <cfif isdefined("attributes.department") and len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
					TITLE = <cfif isdefined("attributes.title") and len(attributes.title)>'#attributes.title#'<cfelse>NULL</cfif>,
					MISSION = <cfif isdefined("attributes.mission") and len(attributes.mission)>#attributes.mission#<cfelse>NULL</cfif>,
					MOBIL_CODE = <cfif len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
					MOBILTEL = <cfif len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
					SEX = <cfif isdefined("attributes.sex") and attributes.sex eq 1>1<cfelse>0</cfif>,
					COMPANY_PARTNER_ADDRESS = <cfif isdefined("attributes.tax_address") and len(attributes.tax_address)>'#attributes.tax_address#'<cfelse>NULL</cfif>,
					COMPANY_PARTNER_POSTCODE = <cfif len(attributes.tax_postcode)>'#attributes.tax_postcode#'<cfelse>NULL</cfif>,
					SEMT = <cfif isDefined('attributes.tax_semt') and len(attributes.tax_semt)>'#attributes.tax_semt#'<cfelse>NULL</cfif>,
					COUNTY = <cfif len(attributes.tax_county_id)>#attributes.tax_county_id#<cfelse>NULL</cfif>,
					CITY = <cfif len(attributes.tax_city_id)>#attributes.tax_city_id#<cfelse>NULL</cfif>,
					COUNTRY = <cfif len(attributes.tax_country)>#attributes.tax_country#<cfelse>NULL</cfif>,
					TC_IDENTITY = <cfif isdefined("attributes.tc_identity_no") and len(attributes.tc_identity_no)>'#attributes.tc_identity_no#'<cfelse>NULL</cfif>,
					START_DATE = <cfif isdefined("attributes.startdate") and len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
					UPDATE_DATE = #now()#,
					UPDATE_MEMBER = #session.ep.userid#,
					UPDATE_IP = '#cgi.remote_addr#'
				WHERE
					PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_partner_control.partner_id#">
			</cfquery>
		</cfloop>
	</cfif>
	<!--- //Bireysel Uyenin Iliskili Oldugu Partner Varsa Bilgiler Update Edilir FBS 20110131 --->
    
	<!--- Referans bilgileri değiştiğinde referans olunan üyeler de değişiyor --->
	<cfquery name="GET_ALL_CONSUMERS" datasource="#DSN#">
		SELECT CONSUMER_ID,CONSUMER_REFERENCE_CODE,REF_POS_CODE FROM CONSUMER WHERE '.'+CONSUMER_REFERENCE_CODE+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#attributes.consumer_id#.%">
	</cfquery>
	<cfquery name="UPD_HIST" datasource="#DSN#">
		UPDATE 
			CONSUMER_HISTORY
		SET 
			REF_POS_CODE = (SELECT REF_POS_CODE FROM CONSUMER WHERE CONSUMER_ID = CONSUMER_HISTORY.CONSUMER_ID)
		WHERE
			CONSUMER_HISTORY_ID = (SELECT MAX(CHH.CONSUMER_HISTORY_ID) FROM CONSUMER_HISTORY CHH WHERE CHH.CONSUMER_ID = CONSUMER_HISTORY.CONSUMER_ID) AND
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
	<cfif isdefined("attributes.is_ref_member") and attributes.is_ref_member eq 1>
		<cfquery name="GET_CONS_CODE" datasource="#DSN#">
			SELECT CONSUMER_REFERENCE_CODE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfquery>
		<cfoutput query="get_all_consumers">
			<cfset new_pos_code = replace(get_all_consumers.consumer_reference_code,'.#attributes.hidden_reference_code#.#attributes.consumer_id#.','.#get_cons_code.consumer_reference_code#.#attributes.consumer_id#.')>			
			<cfset new_pos_code = replace(new_pos_code,'.#attributes.hidden_reference_code#.#attributes.consumer_id#','.#get_cons_code.consumer_reference_code#.#attributes.consumer_id#')>			
			<cfset new_pos_code = replace(new_pos_code,'#attributes.hidden_reference_code#.#attributes.consumer_id#.','#get_cons_code.consumer_reference_code#.#attributes.consumer_id#.')>			
			<cfif get_all_consumers.ref_pos_code eq attributes.consumer_id>
				<cfset new_pos_code = '#get_cons_code.consumer_reference_code#.#attributes.consumer_id#'>
			</cfif>			
			<cfquery name="UPD_CONS" datasource="#DSN#">
				UPDATE CONSUMER SET CONSUMER_REFERENCE_CODE = '#new_pos_code#' WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_consumers.consumer_id#">
			</cfquery>
			<cfscript>
				add_consumer_history(consumer_id:get_all_consumers.consumer_id);
			</cfscript>
			<cfif get_camp_date.recordcount>
				<cfquery name="GET_ALL_INVOICE" datasource="#DSN#">
					SELECT 
						INVOICE_ID
					FROM
						#dsn2_alias#.INVOICE
					WHERE
						IS_IPTAL = 0 AND
						INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)# AND
						CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_consumers.consumer_id#">
				</cfquery>
				<cfloop query="get_all_invoice">
					<cfquery name="UPD_ALL_INVOICE" datasource="#DSN#">
						UPDATE 
							#dsn2_alias#.INVOICE 
						SET 
							CONSUMER_REFERENCE_CODE = (SELECT C.CONSUMER_REFERENCE_CODE FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_ID = INVOICE.CONSUMER_ID)
						WHERE
							INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_invoice.invoice_id#">
					</cfquery>
					<cfquery name="add_multilevel_sales" datasource="#DSN#">
						#dsn2_alias#.add_multilevel_sales
							#get_all_invoice.invoice_id#
					</cfquery>
					<cfquery name="add_multilevel_premium" datasource="#DSN#">
						#dsn2_alias#.add_multilevel_premium
							#get_all_invoice.invoice_id#
					</cfquery>
				</cfloop>
			</cfif>
		</cfoutput>
	<cfelseif (isdefined("attributes.is_upper_member") and attributes.is_upper_member eq 1) or attributes.is_upper_ref eq 1>
		<cfoutput query="get_all_consumers">
			<cfset new_pos_code = listdeleteat(get_all_consumers.consumer_reference_code,listfind(get_all_consumers.consumer_reference_code,attributes.consumer_id,'.'),'.')>
			<cfquery name="UPD_CONS" datasource="#DSN#">
				UPDATE CONSUMER SET CONSUMER_REFERENCE_CODE = '#new_pos_code#',REF_POS_CODE = #listlast(new_pos_code,'.')# WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_consumers.consumer_id#">
			</cfquery>
			<cfscript>
				add_consumer_history(consumer_id:get_all_consumers.consumer_id);
			</cfscript>	
			<cfif get_camp_date.recordcount>
				<cfquery name="GET_ALL_INVOICE" datasource="#DSN#">
					SELECT 
						INVOICE_ID
					FROM
						#dsn2_alias#.INVOICE
					WHERE
						IS_IPTAL = 0 AND
						INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)# AND
						CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_consumers.consumer_id#">
				</cfquery>
				<cfloop query="get_all_invoice">
					<cfquery name="UPD_ALL_INVOICE" datasource="#DSN#">
						UPDATE 
							#dsn2_alias#.INVOICE 
						SET 
							CONSUMER_REFERENCE_CODE = (SELECT C.CONSUMER_REFERENCE_CODE FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_ID = INVOICE.CONSUMER_ID)
						WHERE
							INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_invoice.invoice_id#">
					</cfquery>
					<cfquery name="add_multilevel_sales" datasource="#DSN#">
						#dsn2_alias#.add_multilevel_sales
							#get_all_invoice.invoice_id#
					</cfquery>
					<cfquery name="add_multilevel_premium" datasource="#DSN#">
						#dsn2_alias#.add_multilevel_premium
							#get_all_invoice.invoice_id#
					</cfquery>
				</cfloop>
			</cfif>
		</cfoutput>
	<cfelseif isdefined("attributes.ref_pos_code_row") and len(attributes.ref_pos_code_row)>
		<cfoutput query="get_all_consumers">
			<cfset new_pos_code = replace(get_all_consumers.consumer_reference_code,'.#attributes.hidden_reference_code#.#attributes.consumer_id#.','.#attributes.reference_code_row#.#attributes.ref_pos_code_row#.')>			
			<cfset new_pos_code = replace(new_pos_code,'.#attributes.hidden_reference_code#.#attributes.consumer_id#','.#attributes.reference_code_row#.#attributes.ref_pos_code_row#')>			
			<cfset new_pos_code = replace(new_pos_code,'#attributes.hidden_reference_code#.#attributes.consumer_id#.','#attributes.reference_code_row#.#attributes.ref_pos_code_row#.')>			
			<cfif get_all_consumers.ref_pos_code eq attributes.consumer_id>
				<cfset new_pos_code = '#attributes.reference_code_row#.#attributes.ref_pos_code_row#'>
			</cfif>
			<cfquery name="UPD_CONS" datasource="#DSN#">
				UPDATE CONSUMER SET CONSUMER_REFERENCE_CODE = '#new_pos_code#',REF_POS_CODE = #attributes.ref_pos_code_row# WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_consumers.consumer_id#">
			</cfquery>
			<cfscript>
				add_consumer_history(consumer_id:get_all_consumers.consumer_id);
			</cfscript>
			<cfif get_camp_date.recordcount>
				<cfquery name="GET_ALL_INVOICE" datasource="#DSN#">
					SELECT 
						INVOICE_ID
					FROM
						#dsn2_alias#.INVOICE
					WHERE
						IS_IPTAL = 0 AND
						INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)# AND
						CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_consumers.consumer_id#">
				</cfquery>
				<cfloop query="get_all_invoice">
					<cfquery name="UPD_ALL_INVOICE" datasource="#DSN#">
						UPDATE 
							#dsn2_alias#.INVOICE 
						SET 
							CONSUMER_REFERENCE_CODE = (SELECT C.CONSUMER_REFERENCE_CODE FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_ID = INVOICE.CONSUMER_ID)
						WHERE
							INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_invoice.invoice_id#">
					</cfquery>
					<cfquery name="ADD_MULTILEVEL_SALES" datasource="#DSN#">
						#dsn2_alias#.add_multilevel_sales
							#get_all_invoice.invoice_id#
					</cfquery>
					<cfquery name="ADD_MULTILEVEL_PREMIUM" datasource="#DSN#">
						#dsn2_alias#.add_multilevel_premium
							#get_all_invoice.invoice_id#
					</cfquery>
				</cfloop>
			</cfif>
		</cfoutput>
	</cfif>
	<cfif get_camp_date.recordcount and isdefined("attributes.ref_pos_code") and len(attributes.ref_pos_code) and len(attributes.ref_pos_code_name)>
		<cfquery name="GET_ALL_INVOICE" datasource="#DSN#">
			SELECT 
				INVOICE_ID
			FROM
				#dsn2_alias#.INVOICE
			WHERE
				IS_IPTAL = 0 AND
				INVOICE_DATE BETWEEN #createodbcdatetime(get_camp_date.camp_startdate)# AND #createodbcdatetime(get_camp_date.camp_finishdate)# AND
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfquery>
		<cfloop query="get_all_invoice">
			<cfquery name="UPD_ALL_INVOICE" datasource="#DSN#">
				UPDATE 
					#dsn2_alias#.INVOICE 
				SET 
					CONSUMER_REFERENCE_CODE = (SELECT C.CONSUMER_REFERENCE_CODE FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_ID = INVOICE.CONSUMER_ID)
				WHERE
					INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_invoice.invoice_id#">
			</cfquery>
			<cfquery name="ADD_MULTILEVEL_SALES" datasource="#DSN#">
				#dsn2_alias#.add_multilevel_sales
					#get_all_invoice.invoice_id#
			</cfquery>
			<cfquery name="ADD_MULTILEVEL_PREMIUM" datasource="#DSN#">
				#dsn2_alias#.add_multilevel_premium
					#get_all_invoice.invoice_id#
			</cfquery>
		</cfloop>	
	</cfif>
	<!--- Bireysel uye temsilcisinin degismesi durumunda uye ekibine is_master olarak uye atiliyor --->
	<cfif isDefined("attributes.pos_code") and len(attributes.consumer_id) and len(attributes.pos_code) and (attributes.pos_code neq attributes.old_pos_code)>
		<cfquery name="GET_WORKGROUP_MASTER" datasource="#DSN#">
			SELECT 
				CONSUMER_ID,
				OUR_COMPANY_ID,
				IS_MASTER 
			FROM 
				WORKGROUP_EMP_PAR 
			WHERE
				IS_MASTER = 1 AND
				CONSUMER_ID IS NOT NULL AND
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfif get_workgroup_master.recordcount>
			<cfquery name="UPD_IS_MASTER" datasource="#DSN#">
				UPDATE 
					WORKGROUP_EMP_PAR 
				SET 
					IS_MASTER = 0 
				WHERE 
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
					OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			</cfquery>
		</cfif>
		
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
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">,
				1,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			)
		</cfquery>
	</cfif>
	
	<!--- Muhasebe ve Calisma Donemi icin eklendi.Eger iliski yoksa is_cari degiskenine baglı olarak donem ile iliskisi kuruluyor. BK 20070227 --->
	<cfif isdefined('attributes.is_cari')>
		<cfquery name="GET_CONSUMER_PERIOD" datasource="#DSN#">
			SELECT CONSUMER_ID FROM CONSUMER_PERIOD WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfquery>
		
		<cfif not get_consumer_period.recordcount>
			<cfquery name="GET_ACC_INFO" datasource="#DSN#">
				SELECT PUBLIC_ACCOUNT_CODE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			</cfquery>
			<cfquery name="ADD_CONS_PERIOD" datasource="#DSN#">
				INSERT INTO
					CONSUMER_PERIOD
				(
					CONSUMER_ID,
					PERIOD_ID,
					ACCOUNT_CODE
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">,
					#session.ep.period_id#,
					<cfif len(get_acc_info.public_account_code)>'#get_acc_info.public_account_code#'<cfelse>NULL</cfif>
				)
			</cfquery>
		</cfif>		
	</cfif>
	<!---Ek Bilgiler--->
	<cfset attributes.info_id =  attributes.consumer_id>
    <cfset attributes.is_upd = 1>
    <cfset attributes.info_type_id = -2>
    <cfinclude template="../../objects/query/add_info_plus2.cfm">
    <!---Ek Bilgiler--->
	<!--- Adres Defteri --->
	<cfif not isDefined("attributes.consumer_status")><cfset attributes.status_ = 0><cfelse><cfset attributes.status_ = 1></cfif>
	<cfif not isDefined("attributes.company")><cfset attributes.company = ""></cfif>
	<cfif not isDefined("attributes.title")><cfset attributes.title = ""></cfif>
	<cfif not isDefined("attributes.consumer_email")><cfset attributes.consumer_email = ""></cfif>
	<cfif not isDefined("attributes.work_telcode")><cfset attributes.work_telcode = ""></cfif>
	<cfif not isDefined("attributes.work_tel")><cfset attributes.work_tel = ""></cfif>
	<cfif not isDefined("attributes.work_fax")><cfset attributes.work_fax = ""></cfif>
	<cfif not isDefined("attributes.homepage")><cfset attributes.homepage = ""></cfif>
	<cfif not isDefined("attributes.work_postcode")><cfset attributes.work_postcode = ""></cfif>
	<cfif not isDefined("attributes.work_address")><cfset attributes.work_address = ""></cfif>
	<cfif not isDefined("attributes.work_semt")><cfset attributes.work_semt = ""></cfif>
	<cfif not isDefined("attributes.work_county_id")><cfset attributes.work_county_id = ""></cfif>
	<cfif not isDefined("attributes.work_city_id")><cfset attributes.work_city_id = ""></cfif>
	<cfif not isDefined("attributes.work_country")><cfset attributes.work_country = ""></cfif>
	<cfif not isDefined("attributes.sector_cat_id")><cfset attributes.sector_cat_id = ""></cfif>
	<!--- //Bireysel Uye mükellef mi değil mi kontrolü --->
    <cf_addressbook
		design		= "2"
		type		= "3"
		type_id		= "#attributes.consumer_id#"
		active		= "#attributes.status_#"
		name		= "#attributes.consumer_name#"
		surname		= "#attributes.consumer_surname#"
		sector_id	= "#attributes.sector_cat_id#"
		company_name= "#attributes.company#"
		title		= "#attributes.title#"
		email		= "#attributes.consumer_email#"
		telcode		= "#attributes.work_telcode#"
		telno		= "#attributes.work_tel#"
		faxno		= "#attributes.work_fax#"
		mobilcode	= "#attributes.mobilcat_id#"
		mobilno		= "#attributes.mobiltel#"
		web			= "#attributes.homepage#"
		postcode	= "#attributes.work_postcode#"
		address		= "#wrk_eval('attributes.work_address')#"
		semt		= "#attributes.work_semt#"
		county_id	= "#attributes.work_county_id#"
		city_id		= "#attributes.work_city_id#"
		country_id	= "#attributes.work_country#">

	<cf_workcube_process is_upd='1' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='CONSUMER'
		action_column='CONSUMER_ID'
		action_id='#attributes.consumer_id#'
		action_page='#request.self#?fuseaction=member.consumer_list&event=det&cid=#attributes.consumer_id#' 
		warning_description='Bireysel Üye : #attributes.consumer_name# #attributes.consumer_surname#'>
  	</cftransaction>
</cflock>
	<cfif session.ep.our_company_info.is_efatura>
		<cfscript>
			ws = createobject("component","V16.member.cfc.CheckCustomerTaxId").CheckCustomerTaxIdMain(Action_Type:"CONSUMER",Action_id:attributes.consumer_id,TCKN:attributes.tc_identity_no);
		</cfscript>
	</cfif>	
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=member.consumer_list&event=det&cid=#attributes.consumer_id#</cfoutput>';
</script>

