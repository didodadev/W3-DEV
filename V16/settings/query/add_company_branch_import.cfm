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
		<cfset compbranch_name = trim(listgetat(dosya[i],2,';'))>
		<cfset compbranch_telcode = trim(listgetat(dosya[i],3,';'))>
		<cfset compbranch_tel1 = trim(listgetat(dosya[i],4,';'))>
		<cfset compbranch_tel2 = trim(listgetat(dosya[i],5,';'))>
		<cfset compbranch_fax = trim(listgetat(dosya[i],6,';'))>
		<cfset mobil_code = trim(listgetat(dosya[i],7,';'))>
		<cfset mobiltel = trim(listgetat(dosya[i],8,';'))>
		<cfset compbranch_email = trim(listgetat(dosya[i],9,';'))>
		<cfset homepage = trim(listgetat(dosya[i],10,';'))>
		<cfset compbranch_nickname = trim(listgetat(dosya[i],11,';'))>
		<cfset manager = trim(listgetat(dosya[i],12,';'))>
		<cfset employee_id = trim(listgetat(dosya[i],13,';'))>
		<cfset country_id = trim(listgetat(dosya[i],14,';'))>
		<cfset city_id = trim(listgetat(dosya[i],15,';'))>
		<cfset county_id = trim(listgetat(dosya[i],16,';'))>
		<cfset semt = trim(listgetat(dosya[i],17,';'))>
		<cfset compbranch_postcode = trim(listgetat(dosya[i],18,';'))>
		<cfset compbranch_address = trim(listgetat(dosya[i],19,';'))>
		<cfif (listlen(dosya[i],';') gte 20)>
			<cfset address = trim(listgetat(dosya[i],20,';'))>
		<cfelse>
			<cfset address = ''>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
			<cfset error_flag = 1>
		</cfcatch>  
	</cftry>
	<cfif len(country_id) and isNumeric(country_id)>
		<cfquery name="get_country" datasource="#DSN#">
			SELECT COUNTRY_ID FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_id#)
		</cfquery>
	<cfelse>
		<cfset get_country.country_id = ''>
	</cfif>
	<cfif len(city_id) and isNumeric(city_id) and len(country_id) and isNumeric(country_id)>
		<cfquery name="get_city" datasource="#DSN#">
			SELECT CITY_ID FROM SETUP_CITY WHERE COUNTRY_ID = #country_id# AND CITY_ID = #city_id#
		</cfquery>
	<cfelse>
		<cfset get_city.city_id = ''>
	</cfif>
	<cfif (len(city_id) and isNumeric(city_id)) and (len(country_id) and isNumeric(country_id)) and (len(county_id) and isNumeric(county_id))>
		<cfquery name="get_county" datasource="#DSN#">
			SELECT COUNTY_ID FROM SETUP_COUNTY WHERE CITY = #city_id# AND COUNTY_ID = #county_id#
		</cfquery>
	<cfelse>
		<cfset get_county.COUNTY_ID = ''>
	</cfif>
	<cfif len(manager) and isNumeric(manager) and len(company_id) and isNumeric(company_id)>
		<cfquery name="get_partner" datasource="#dsn#">
			SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = #company_id# AND PARTNER_ID = #manager#
		</cfquery>
	<cfelse>
		<cfset get_partner.partner_id = ''>
	</cfif>
	<cfif len(employee_id) and isNumeric(employee_id)>
		<cfquery name="get_employee" datasource="#dsn#">
			SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = #employee_id#
		</cfquery>
	<cfelse>
		<cfset get_employee.employee_id = ''>
	</cfif>
	<cfif len(address) and address eq 2>
		<cfset is_ship_address = 1>
		<cfset is_invoice_address = 0>
	<cfelseif len(address) and address eq 3>
		<cfset is_ship_address = 0>
		<cfset is_invoice_address = 1>
	<cfelse>
		<cfset is_ship_address = 0>
		<cfset is_invoice_address = 0>
	</cfif>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cftry>
				<cfquery name="ADD_COMPANY_BRANCH" datasource="#DSN#">
					INSERT INTO
						COMPANY_BRANCH
					(
						COMPBRANCH_STATUS,
						COMPANY_ID,	
						COMPBRANCH__NAME,
						COMPBRANCH_TELCODE,
						COMPBRANCH_TEL1,
						COMPBRANCH_TEL2,
						COMPBRANCH_FAX,
						COMPBRANCH_MOBIL_CODE,
						COMPBRANCH_MOBILTEL,
						COMPBRANCH_EMAIL,
						HOMEPAGE,
           				COMPBRANCH__NICKNAME,
						MANAGER_PARTNER_ID,
						POS_CODE,
						COUNTRY_ID,
						CITY_ID,
						COUNTY_ID,
						SEMT,
						COMPBRANCH_POSTCODE,
						COMPBRANCH_ADDRESS,
						IS_SHIP_ADDRESS,
						IS_INVOICE_ADDRESS,
						RECORD_DATE,	
						RECORD_MEMBER,
						RECORD_IP
					)
						VALUES
					(
						1,
						#company_id#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#compbranch_name#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#compbranch_telcode#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#compbranch_tel1#">,
						<cfif len(compbranch_tel2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#compbranch_tel2#"><cfelse>NULL</cfif>,
						<cfif len(compbranch_fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#compbranch_fax#"><cfelse>NULL</cfif>,
						<cfif len(mobil_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#mobil_code#"><cfelse>NULL</cfif>,
						<cfif len(mobiltel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#mobiltel#"><cfelse>NULL</cfif>,
						<cfif len(compbranch_email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#compbranch_email#"><cfelse>NULL</cfif>,
						<cfif len(homepage)><cfqueryparam cfsqltype="cf_sql_varchar" value="#homepage#"><cfelse>NULL</cfif>,
       				    <cfif len(compbranch_nickname)><cfqueryparam cfsqltype="cf_sql_varchar" value="#compbranch_nickname#"><cfelse>NULL</cfif>,
						<cfif len(get_partner.partner_id)>#get_partner.partner_id#<cfelse>NULL</cfif>,
						<cfif len(get_employee.employee_id)>#get_employee.employee_id#<cfelse>NULL</cfif>,
						<cfif len(get_country.country_id)>#get_country.country_id#<cfelse>NULL</cfif>,
						<cfif len(get_city.city_id)>#get_city.city_id#<cfelse>NULL</cfif>,
						<cfif len(get_county.county_id)>#get_county.county_id#<cfelse>NULL</cfif>,
						<cfif len(semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#semt#"><cfelse>NULL</cfif>,
						<cfif len(compbranch_postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#compbranch_postcode#"><cfelse>NULL</cfif>,
						<cfif len(compbranch_address)><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("compbranch_address")#'><cfelse>NULL</cfif>,
						#is_ship_address#,
						#is_invoice_address#,
						#now()#,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfquery>
				<cfcatch type="Any">
					<cfoutput>
						#i#. Satırda <br/>
						<cfif not len(company_id)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Kurumsal Şirket ID Eksik.<br/>
						</cfif> 
						<cfif not len(compbranch_name)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Şube Adı Eksik.<br/>
						</cfif> 
						<cfif not len(compbranch_telcode)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Telefon Kodu Eksik.<br/>
						</cfif> 
						<cfif not len(compbranch_tel1)>
							&nbsp;&nbsp;&nbsp;&nbsp;*Telefon 1 Eksik.<br/>
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
