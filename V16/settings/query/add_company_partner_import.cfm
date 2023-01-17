<cfsetting showdebugoutput="no">
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
		alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
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
		<cfset company_id = trim(listgetat(dosya[i],1,';'))>
		<cfset partner_name = trim(listgetat(dosya[i],2,';'))>
		<cfset partner_surname = trim(listgetat(dosya[i],3,';'))>
		<cfset birth_date = trim(listgetat(dosya[i],4,';'))>
		<cfset tc_identity_no = trim(listgetat(dosya[i],5,';'))>
        <cfset position = trim(listgetat(dosya[i],6,';'))>
		<cfset partner_position = trim(listgetat(dosya[i],7,';'))>
		<cfset compbranch_id = trim(listgetat(dosya[i],8,';'))>
		<cfset department = trim(listgetat(dosya[i],9,';'))>
		<cfset sex = trim(listgetat(dosya[i],10,';'))>
		<cfset tel_local = trim(listgetat(dosya[i],11,';'))>
		<cfset email = trim(listgetat(dosya[i],12,';'))>
		<cfset address = trim(listgetat(dosya[i],13,';'))>
		<cfset country_id = trim(listgetat(dosya[i],14,';'))>
		<cfset city_id = trim(listgetat(dosya[i],15,';'))>
		<cfset county_id = trim(listgetat(dosya[i],16,';'))>
		<cfset semt = trim(listgetat(dosya[i],17,';'))>
		<cfset postcode = trim(listgetat(dosya[i],18,';'))>
		<cfif (listlen(dosya[i],';') gte 19)>
			<cfset language_id = trim(listgetat(dosya[i],19,';'))>
		<cfelse>
			<cfset language_id = ''>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
			<cfset error_flag = 1>
		</cfcatch>  
	</cftry>
	<cfif isDefined("birth_date") and len(birth_date)>
		<cf_date tarih="birth_date">
	</cfif>
	<cfif isDefined("partner_position") and len(partner_position) and isNumeric(partner_position)>
		<cfquery name="get_partner_positions" datasource="#DSN#">
			SELECT PARTNER_POSITION_ID FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID IN (#partner_position#)
		</cfquery>
	<cfelse>
		<cfset get_partner_positions.PARTNER_POSITION_ID = ''>
	</cfif>
	<cfif isDefined("compbranch_id") and len(compbranch_id) and isNumeric(compbranch_id) and isDefined("company_id") and len(company_id) and isNumeric(company_id)>
		<cfquery name="get_comp_branch" datasource="#DSN#">
			SELECT COMPBRANCH_ID FROM COMPANY_BRANCH WHERE COMPANY_ID = #company_id# AND COMPBRANCH_ID IN (#compbranch_id#)
		</cfquery>
	<cfelse>
		<cfset get_comp_branch.COMPBRANCH_ID = 0>
	</cfif>
	<cfif isDefined("department") and len(department) and isNumeric(department)>
		<cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#DSN#">
			SELECT PARTNER_DEPARTMENT_ID FROM SETUP_PARTNER_DEPARTMENT WHERE PARTNER_DEPARTMENT_ID IN (#department#)
		</cfquery>
	<cfelse>
		<cfset GET_PARTNER_DEPARTMENTS.PARTNER_DEPARTMENT_ID = ''>
	</cfif>
	<cfif isDefined("country_id") and len(country_id) and isNumeric(country_id)>
		<cfquery name="get_country" datasource="#DSN#">
			SELECT COUNTRY_ID FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_id#)
		</cfquery>
	<cfelse>
		<cfset get_country.country_id = ''>
	</cfif>
	<cfif isDefined("city_id") and len(city_id) and isNumeric(city_id) and isDefined("country_id") and len(country_id) and isNumeric(country_id)>
		<cfquery name="get_city" datasource="#DSN#">
			SELECT CITY_ID FROM SETUP_CITY WHERE COUNTRY_ID = #country_id# AND CITY_ID = #city_id#
		</cfquery>
	<cfelse>
		<cfset get_city.city_id = ''>
	</cfif>
	<cfif (isDefined("city_id") and len(city_id) and isNumeric(city_id)) and (isDefined("country_id") and len(country_id) and isNumeric(country_id)) and (isDefined("county_id") and len(county_id) and isNumeric(county_id))>
		<cfquery name="get_county" datasource="#DSN#">
			SELECT COUNTY_ID FROM SETUP_COUNTY WHERE CITY = #city_id# AND COUNTY_ID = #county_id#
		</cfquery>
	<cfelse>
		<cfset get_county.COUNTY_ID = ''>
	</cfif>
	<cfif isDefined("language_id") and len(language_id) and isNumeric(language_id)>
		<cfquery name="get_lang" datasource="#DSN#">
			SELECT LANGUAGE_ID FROM SETUP_LANGUAGE WHERE LANGUAGE_ID = #language_id#
		</cfquery>
	<cfelse>
		<cfquery name="get_lang" datasource="#DSN#">
			SELECT LANGUAGE_ID FROM SETUP_LANGUAGE WHERE LANGUAGE_SHORT = '#session.ep.language#'
		</cfquery>
	</cfif>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cftry>
				<cfquery name="ADD_PARTNER" datasource="#DSN#">
					INSERT INTO 
						COMPANY_PARTNER 
					(
						COMPANY_ID,
						COMPANY_PARTNER_NAME,
						COMPANY_PARTNER_SURNAME,
						BIRTHDATE,
						TC_IDENTITY,
                        TITLE,
						MISSION,
						COMPBRANCH_ID,
						DEPARTMENT,
						COUNTRY,		
						SEX,
						COMPANY_PARTNER_TEL_EXT,
						COMPANY_PARTNER_EMAIL,
						COMPANY_PARTNER_ADDRESS,
						CITY,
						COUNTY,
						SEMT,
						COMPANY_PARTNER_POSTCODE,
						LANGUAGE_ID,
						RECORD_DATE,				
						RECORD_MEMBER,
						RECORD_IP,
						MEMBER_TYPE
					)
					VALUES
					(
						#company_id#,
						<cfif len(partner_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#partner_name#"></cfif>,
						<cfif len(partner_surname)><cfqueryparam cfsqltype="cf_sql_varchar" value="#partner_surname#"></cfif>,
						<cfif len(birth_date)>#birth_date#<cfelse>NULL</cfif>,
						<cfif len(tc_identity_no) and isNumeric(tc_identity_no)>#tc_identity_no#<cfelse>NULL</cfif>,
                        <cfif len(position)><cfqueryparam cfsqltype="cf_sql_varchar" value="#position#"><cfelse>NULL</cfif>,
						<cfif len(get_partner_positions.PARTNER_POSITION_ID)>#get_partner_positions.PARTNER_POSITION_ID#<cfelse>NULL</cfif>,
						#get_comp_branch.COMPBRANCH_ID#,
						<cfif len(GET_PARTNER_DEPARTMENTS.PARTNER_DEPARTMENT_ID)>#GET_PARTNER_DEPARTMENTS.PARTNER_DEPARTMENT_ID#<cfelse>NULL</cfif>,
						<cfif len(get_country.country_id)>#get_country.country_id#<cfelse>NULL</cfif>,
						<cfif len(sex) and (sex eq 1 or sex eq 2)>#sex#<cfelse>1</cfif>,
						<cfif len(tel_local)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tel_local#"><cfelse>NULL</cfif>,
						<cfif len(email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#email#"><cfelse>NULL</cfif>,
						<cfif len(address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#address#"><cfelse>NULL</cfif>,
						<cfif len(get_city.city_id)>#get_city.city_id#<cfelse>NULL</cfif>,
						<cfif len(get_county.COUNTY_ID)>#get_county.COUNTY_ID#<cfelse>NULL</cfif>,
						<cfif len(semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#semt#"><cfelse>NULL</cfif>,
						<cfif len(postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#postcode#"><cfelse>NULL</cfif>,
						#get_lang.language_id#,
						#now()#,				
						#session.ep.userid#,			
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						1
					)			
				</cfquery>
				<cfquery name="GET_MAX_PARTNER" datasource="#DSN#">
					SELECT MAX(PARTNER_ID) AS MAX_PART FROM COMPANY_PARTNER
				</cfquery>
		
				<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
					UPDATE
						COMPANY_PARTNER
					SET
						MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="CP#get_max_partner.max_part#">
					WHERE
						PARTNER_ID = #get_max_partner.max_part#
				</cfquery>
				<cfcatch type="Any">
					<cfoutput>
						#i#. Satırda <br/>
						<cfif not len(company_id)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Kurumsal Şirket ID Eksik.<br/>
						</cfif> 
						<cfif isDefined("partner_name") and not len(partner_name) >
							&nbsp;&nbsp;&nbsp;&nbsp;*Çalışan Adı Eksik.<br/>
						</cfif> 
						<cfif isDefined("partner_surname") and len(partner_surname)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Çalışan Soyadı Eksik.<br/>
						</cfif> 
                        <cfif isDefined("get_comp_branch.COMPBRANCH_ID") and not len(get_comp_branch.COMPBRANCH_ID)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Kurumsal Üye Şube Bilgisi Eksik.<br/>
						</cfif>
					</cfoutput>	
					<cfset kont=0>
				</cfcatch>
			</cftry>
			<cfif kont eq 1>
				<cfoutput>#i#. Satır İmport Edildi... <br/></cfoutput>
			</cfif>
		</cftransaction>
	</cflock>
</cfloop>
<script>

	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_add_company_partner_import</cfoutput>";

</script>