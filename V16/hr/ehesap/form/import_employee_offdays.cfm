<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
<cfif not isdefined('attributes.uploaded_file')>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Çalışan Geçmiş Dönem İzin Aktarımı','59620')#">
			<cfform name="formimport" action="#request.self#?fuseaction=ehesap.import_employee_offdays" enctype="multipart/form-data" method="post">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">					
	                    <div class="form-group" id="item-file_format">
                        	<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="file_format" id="file_format">
                                    <option value="UTF-8"><cf_get_lang dictionary_id='32802.UTF-8'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-file_format">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="file" name="uploaded_file" id="uploaded_file">
                            </div>
                        </div>	
                        <div class="form-group" id="item-file_format">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<a href="/IEF/standarts/import_example_file/calisan_gecmis_donem_izin_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
							</div>
                        </div>										
					</div>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-format">
                            <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                        </div>  
						<div class="form-group" id="item-exp1">
							<cf_get_lang dictionary_id='35657.Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>.
						</div>
						<div class="form-group" id="item-exp2">
                            <cf_get_lang dictionary_id ='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.
						</div>
						<div class="form-group" id="item-exp3">
							<cf_get_lang dictionary_id="43804.Bu kolonlardan sıra no ve isim bilgi amaçlıdır.">
						</div>
						<div class="form-group" id="item-exp4">
							<cf_get_lang dictionary_id="35552.Belgede toplam 5 alan olacaktır alanlar sırasi ile">;
						</div>
						<div class="form-group" id="item-exp5">
                            1-<cf_get_lang dictionary_id="31253.Sıra No"><br />
							2-<cf_get_lang dictionary_id="58025.Tc Kimlik No">*<br/>
							3-<cf_get_lang dictionary_id="44688.Çalışan Adı"><br/>
							4-<cf_get_lang dictionary_id="44689.Çalışan Soyadı"><br/>
							5-<cf_get_lang dictionary_id="59623.Gün : 5 (sayısal) formatında olmalıdır."><br/>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
	<script type="text/javascript">
		function kontrol()
		{
			if(formimport.uploaded_file.value.length==0)
			{
				alert("<cf_get_lang dictionary_id='43424.Belge Seçmelisiniz'>!");
				return false;
			}
				return true;
		}
	</script>
<cfelse>
	<cfsetting showdebugoutput="no">
	<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
				filefield = "uploaded_file" 
				destination = "#upload_folder_#"
				nameconflict = "MakeUnique"  
				mode="777" charset="#attributes.file_format#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="#attributes.file_format#">	
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
		<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="#attributes.file_format#">
		<cffile action="delete" file="#upload_folder_##file_name#">
	<cfcatch>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>.");
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
	<cfset error_flag = 0>
	<cfloop from="2" to="#line_count#" index="i">
		<cfset j= 1>
		<cftry>
			<cfscript>
			counter = counter + 1;
			//sıra no
			sira_no = Listgetat(dosya[i],j,";");
			sira_no =trim(sira_no);
			j=j+1;
			//tckimlik_no
			tckimlik_no = Listgetat(dosya[i],j,";");
			tckimlik_no =trim(tckimlik_no);
			j=j+1;
			//calisan adi
			calisan_adi = Listgetat(dosya[i],j,";");
			calisan_adi = trim(calisan_adi);
			j=j+1;
			//çalışan soyadı
			calisan_soyadi = Listgetat(dosya[i],j,";");
			calisan_soyadi =trim(calisan_soyadi);
			j=j+1;
			//Gun bilgisi
			gun_= Listgetat(dosya[i],j,";");
			gun_ =trim(replace(gun_,",","."));
			j=j+1;
			</cfscript>
			
			<cfcatch type="Any">
				<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
				<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
				<cfset error_flag = 1>
			</cfcatch>
		</cftry>
 		<cfif len(tckimlik_no) and len(gun_) and error_flag neq 1>
				<cfquery name="GET_EMPLOYEE_INFO" maxrows="1" datasource="#dsn#">
					SELECT
						EI.EMPLOYEE_ID
					FROM
						EMPLOYEES_IDENTY EI
					WHERE 
						EI.TC_IDENTY_NO = '#tckimlik_no#'
				</cfquery>
				<cfif GET_EMPLOYEE_INFO.recordcount>
					<cftry>
						<cfquery datasource="#dsn#" name="UPD_days">
							UPDATE
								EMPLOYEES
							SET 
								IZIN_DAYS = #gun_#
							WHERE 
								EMPLOYEE_ID = #GET_EMPLOYEE_INFO.EMPLOYEE_ID#
						</cfquery>
					<cfcatch type="Any">
							<cfset liste=ListAppend(liste,i&'. satırda kayıt sırasında hata oldu <br/>',',')>
							<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44948.İkinci adımda sorun oluştu'><br/>
						</cfcatch>
					</cftry>
				<cfelse>
					<cfset liste=ListAppend(liste,i&'. satırın employee_id si yok <br/>',',')>
				</cfif>
			</cfif>
	</cfloop>
	<cfoutput>#liste#</cfoutput>
	<cfif error_flag neq 1>
		<cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'> (<cf_get_lang dictionary_id='44949.SAYFAYI YENİLEMEYİNİZ HATALI KAYIT VARSA ONLARI İNCELEYEREK SAYFAYI KAPATINIZ'>)......
		<script>
			window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_offdays';	
		</script>
	</cfif>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
