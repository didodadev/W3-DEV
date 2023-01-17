<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
	<cfif not isdefined('attributes.uploaded_file')>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box title="#getLang('','Bağlantı Kurulacak Kişi Aktarım','45474')#" closable="0">
				<cfform name="formimport" action="#request.self#?fuseaction=ehesap.import_employee_contact_person" enctype="multipart/form-data" method="post">
					<cf_box_elements>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-uploaded_file">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>		
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12">		
									<input type="file" name="uploaded_file" id="uploaded_file">		
								</div>		
							</div>  
							<div class="form-group" id="item-download-link">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>		
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12">		
									<a  href="/IEF/standarts/import_example_file/Baglanti_Kurulacak_Kisi_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
								</div>		
							</div> 
						</div>
						<div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-format">
								<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>		
							</div>  
							<div class="form-group" id="item-exp1">
								<cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır . Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır .'>
							</div>
							<div class="form-group" id="item-exp2">
								<cf_get_lang dictionary_id='35596.Belgede toplam 7 alan olacaktır alanlar sırasi ile'>;	
							</div>
							<div class="form-group" id="item-exp3">
								1-<cf_get_lang dictionary_id='54213.Çalışan Ad-Soyad (Zorunlu)'></br>
								2-<cf_get_lang dictionary_id='54211.TC Kimlik No (Zorunlu)'></br>
								3-<cf_get_lang dictionary_id='31268.Bağlantı Kurulacak Kişi'>*</br>
								4-<cf_get_lang dictionary_id='31269.Yakınlık'></br>
								5-<cf_get_lang dictionary_id='32407.Tel Kod'>*</br>
								6-<cf_get_lang dictionary_id='49272.Tel'>*</br>
								7-<cf_get_lang dictionary_id='57428.E-posta'></br>
							</div>
						</div>
					</cf_box_elements>	
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0'>
					</cf_box_footer>				
				</cfform>
			</cf_box>
		</div>
<cfelse>
	<cfsetting showdebugoutput="no">
	<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
				filefield = "uploaded_file" 
				destination = "#upload_folder_#"
				nameconflict = "MakeUnique"  
				mode="777"  charset="utf-8">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='57455.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
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
			alert("<cf_get_lang dictionary_id='59615.Dosya Okunamadı'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
	</cftry>
	<cfquery name="get_business_codes" datasource="#DSN#">
		SELECT	
			BUSINESS_CODE_ID,
			BUSINESS_CODE,
			BUSINESS_CODE_NAME 
		FROM 
			SETUP_BUSINESS_CODES 
		ORDER BY
			BUSINESS_CODE_NAME
	</cfquery>	
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
		counter = 0;
		liste = "";
	</cfscript>
	<cfset error_flag = 0>
	<cfloop from="2" to="#line_count#" index="i">
		<cfset j= 1>
		<cftry>
			<cfscript>
			counter = counter + 1;
			//calisan_ad_soyad
			calisan_ad = Listgetat(dosya[i],j,";");
			calisan_ad = trim(calisan_ad);
			j=j+1;
			//tckimlik_no
			tckimlik_no = Listgetat(dosya[i],j,";");
			tckimlik_no = trim(tckimlik_no);
			j=j+1;
			//kisi_ad_soyad
			kisi_adi = Listgetat(dosya[i],j,";");
			kisi_adi = trim(kisi_adi);
			j=j+1;
			//yakinlik
			yakinlik = Listgetat(dosya[i],j,";");
			yakinlik = trim(yakinlik);
			j=j+1;
			//tel_code
			tel_code = Listgetat(dosya[i],j,";");
			tel_code = trim(tel_code);
			j=j+1;
			//tel
			tel = Listgetat(dosya[i],j,";");
			tel = trim(tel);
			j=j+1;
			//email
			if(listlen(dosya[i],';') gte j)
			{
				email = Listgetat(dosya[i],j,";");
			}else
				email = '';
			j=j+1;	
			//alanlar bitti
			</cfscript>			
			<cfcatch type="Any">
				<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
				<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
				<cfset error_flag = 1>
				<script>
					window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_contact_person';
				</script>
			</cfcatch>
		</cftry>
		<cfif error_flag eq 0>
			<cfif not len(tel) or not len(tel_code) or not len(tckimlik_no) or not len(kisi_adi)>
				<cfoutput>
					<script type="text/javascript">
						alert("#i#." "<cf_get_lang dictionary_id='44496.satırdaki zorunlu alanlarda eksik değerler var. Lütfen dosyanızı kontrol ediniz'>!");
						history.back();
					</script>
				</cfoutput>
				<cfabort>
			</cfif>
			<cfquery name="get_emp" maxrows="1" datasource="#dsn#">
				SELECT
					E.EMPLOYEE_ID
				FROM
					EMPLOYEES E
					INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
				WHERE
					EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tckimlik_no#">
			</cfquery>
			<cfif get_emp.recordcount>
				<cfquery name="get_detail" datasource="#dsn#">
					SELECT CONTACT1 FROM EMPLOYEES_DETAIL WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.employee_id#">
			    </cfquery>
				<cftry>
					<cfquery name="upd" datasource="#dsn#">
						UPDATE
				        	EMPLOYEES_DETAIL
				        SET
				        <cfif not len(trim(get_detail.contact1))>
				            CONTACT1 = '#kisi_adi#',
				            CONTACT1_EMAIL = <cfif len(email)>'#email#'<cfelse>NULL</cfif>,
				            CONTACT1_RELATION = <cfif len(yakinlik)>'#yakinlik#'<cfelse>NULL</cfif>,
				            CONTACT1_TEL = <cfif len(tel)>'#tel#'<cfelse>NULL</cfif>,
				            CONTACT1_TELCODE = <cfif len(tel_code)>'#tel_code#'<cfelse>NULL</cfif>
						<cfelse>
				            CONTACT2 = '#kisi_adi#',
				            CONTACT2_EMAIL =<cfif len(email)>'#email#'<cfelse>NULL</cfif>,
				            CONTACT2_RELATION = <cfif len(yakinlik)>'#yakinlik#'<cfelse>NULL</cfif>,
				            CONTACT2_TEL =<cfif len(tel)>'#tel#'<cfelse>NULL</cfif>,
				            CONTACT2_TELCODE =<cfif len(tel_code)>'#tel_code#'<cfelse>NULL</cfif>
						</cfif>
				        WHERE
				        	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.employee_id#">
				    </cfquery>
					<cfcatch type="Any">
						<cfset liste=ListAppend(liste,i&'. satırda kayıt sırasında hata oldu <br/>',',')>
						<cfoutput>#i#</cfoutput>. <cf_get_lang_main no='1096.satır'> <cf_get_lang no='2965.İkinci adımda sorun oluştu'><br/>
					</cfcatch>
				</cftry>
			<cfelse>
				<cfset liste=ListAppend(liste,i&'. satırın employee_id si yok <br/>',',')>
			</cfif>
		</cfif>
	</cfloop>
	<cfoutput>#liste#</cfoutput>
	<cfif error_flag neq 1>
		<cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'>
	</cfif>	
	<script>
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_contact_person';
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
