<cfif isDefined('attributes.file_format') and len(attributes.file_format) and attributes.file_format eq 'data_import'>
	<cfif isDefined('attributes.import_id') and len(attributes.import_id) and isDefined('attributes.import_dsn') and len(attributes.import_dsn)>
		<cfset get_import_file = createObject("component","WDO.development.cfc.data_import_library").getData(data_import_id : attributes.import_id) />
		<cfset get_data_source = createObject("component","V16.settings.cfc.data_source").getDataSource(data_source_id : attributes.import_dsn) />
		<cfif get_import_file.recordcount and get_data_source.recordcount>

			<cffile action="read" file="#download_folder##get_import_file.FILE_PATH#" variable="dosya">
			<cfset str_sql = "">
			<cfif get_import_file.IS_COMP eq 1 and isDefined('attributes.comp_id') and len(attributes.comp_id)>
				<cfset str_sql = "#str_sql# DECLARE @FirmNr NVARCHAR(3); SET @FirmNr='#numberFormat(attributes.comp_id,"000")#';">
			</cfif>
			<cfif get_import_file.IS_PERIOD eq 1 and isDefined('attributes.period_id') and len(attributes.period_id)>
				<cfset str_sql = "#str_sql# DECLARE @DonemNr NVARCHAR(3); SET @DonemNr='#numberFormat(attributes.period_id,"00")#';">
			</cfif>
			<cfset str_sql = "#str_sql# #dosya#">
			<cfscript>
				queryObj = new Query(
					name="DATA_IMPORT",
					datasource='#get_data_source.DATA_SOURCE_NAME#',
					sql = str_sql
				);
				get_data = queryObj.execute().getResult();
			</cfscript>
		</cfif>
	</cfif>
<cfelse>
	<cfif not DirectoryExists("#upload_folder#settings#dir_seperator#")>
		<cfdirectory action="create" directory="#upload_folder#settings#dir_seperator#">
	</cfif>
	<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
				fileField = "uploaded_file" 
				destination = "#upload_folder#"
				nameConflict = "MakeUnique"  
				mode="777" charset="#attributes.file_format#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
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
		<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
		<cffile action="delete" file="#upload_folder##file_name#">
	<cfcatch>
		<script type="text/javascript">
			alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = isDefined('get_data') ? get_data.recordCount : ArrayLen(dosya);
	satir_baslangic = isDefined('get_data') ? 1 : 2;
	satir_no =0;
	satir_say =0;
</cfscript>
<cflock name="#createuuid()#" timeout="500">
	<cftransaction>
		<cfloop from="#satir_baslangic#" to="#line_count#" index="i">
			<cfset j= 1>
			<cfset error_flag = 0>
			<cftry>
				<cfif isDefined('get_data')>
					<cfscript>
						satir_say=satir_say+1;
						bank_code = get_data.BANKAKODU[i];//banka kodu						
						branch_name = get_data.SUBEADI[i];//şube adı
						branch_code = get_data.SUBEKODU[i];//şube kodu
						branch_city = get_data.SEHIR[i];//şehir						
						branch_contact = get_data.YETKILI[i];//yetkili						
						branch_tel = get_data.TELEFON[i];//telefon						
						branch_adres = get_data.ADRES[i];//adres						
						branch_post = get_data.POSTAKODU[i];//posta kodu
						branch_country = get_data.ULKE[i];//ülke
					</cfscript>
				<cfelse>
					<cfscript>
						satir_say=satir_say+1;
						
						bank_code = Listgetat(dosya[i],j,";");//banka kodu
						bank_code = trim(bank_code);
						j=j+1;
						
						branch_name = Listgetat(dosya[i],j,";");//şube adı
						branch_name = trim(branch_name);
						j=j+1;
						
						branch_code = Listgetat(dosya[i],j,";");//şube kodu
						branch_code = trim(branch_code);
						j=j+1;
						
						branch_city = Listgetat(dosya[i],j,";");//şehir
						branch_city = trim(branch_city);
						j=j+1;
						
						branch_contact = Listgetat(dosya[i],j,";");//yetkili
						branch_contact = trim(branch_contact);
						j=j+1;
						
						branch_tel = Listgetat(dosya[i],j,";");//telefon
						branch_tel = trim(branch_tel);
						j=j+1;
						
						branch_adres = Listgetat(dosya[i],j,";");//adres
						branch_adres = trim(branch_adres);
						j=j+1;
						
						branch_post = Listgetat(dosya[i],j,";");//posta kodu
						branch_post = trim(branch_post);
						j=j+1;					
						
						if(listlen(dosya[i],';') gte j)
						{
							branch_country = Listgetat(dosya[i],j,";");//ülke
							branch_country = trim(branch_country);
						}				
						else
							branch_country = '';
					</cfscript>
				</cfif>
				<cfcatch type="Any">
					<cfoutput>#satir_say#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
					<cfset error_flag = 1>
				</cfcatch>
			</cftry>
			<cfif error_flag neq 1>
				<cfif not len(bank_code) or not len(branch_name) or not len(branch_code) or not len(branch_city)>
					<cfoutput>
						<script type="text/javascript">
							alert("#satir_say#. <cf_get_lang no ='2513.satırdaki zorunlu alanlarda eksik değerler var Lütfen dosyanızı kontrol ediniz'> !");
							window.close();
						</script>
					</cfoutput>
					<cfabort>
				</cfif>
				<cfquery name="get_bank_control" datasource="#dsn3#">
					SELECT BANK_ID,BANK_NAME FROM #dsn_alias#.SETUP_BANK_TYPES WHERE BANK_CODE = '#bank_code#'
				</cfquery>
				<cfif get_bank_control.recordcount>
					<cfset satir_no = satir_no + 1>
					<cfquery name="ADD_BANK" datasource="#dsn3#">
						INSERT INTO
							BANK_BRANCH
							(
								BANK_ID,
								BANK_NAME,
								BANK_BRANCH_NAME,
								BRANCH_CODE,
								BANK_BRANCH_CITY,
								BANK_BRANCH_POSTCODE,
								BANK_BRANCH_ADDRESS,
								BANK_BRANCH_COUNTRY,
								CONTACT_PERSON,
								BANK_BRANCH_TEL,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								#get_bank_control.bank_id#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_bank_control.bank_name#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_name#">,
								<cfqueryparam cfsqltype="cf_sql_varchar"  value="#branch_code#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_city#">,
								<cfif len(branch_post)><cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_post#"><cfelse>NULL</cfif>,
								<cfif len(branch_adres)><cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_adres#"><cfelse>NULL</cfif>,
								<cfif len(branch_country)><cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_country#"><cfelse>NULL</cfif>,
								<cfif len(branch_contact)><cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_contact#"><cfelse>NULL</cfif>,
								<cfif len(branch_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_tel#"><cfelse>NULL</cfif>,								
								#now()#,
								#session.ep.userid#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">	
							)
					</cfquery>
				</cfif>
				<cftry>	
					<cfcatch type="Any">
						<cfoutput>#satir_say#</cfoutput>. satır 2. adımda sorun oluştu.<br/>
					</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cfoutput><cf_get_lang no='2664.İmport edilen satır sayısı'>: #satir_no# !!!</cfoutput><br/>
<cfoutput><cf_get_lang no='2655.Toplam belge satır sayısı'>: #satir_say# !!!</cfoutput>

