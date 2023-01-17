<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
    <cfif not isdefined('attributes.uploaded_file')>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="Asgari Ücret Kümülatif Vergi Matrahı Aktarım">
			<cfform name="formimport" action="#request.self#?fuseaction=ehesap.import_minimum_wage_cumulative_tax_base" enctype="multipart/form-data" method="post">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-file_format">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="file_format" id="file_format">
									<option value="UTF-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
								</select>
							</div>
						</div> 
						<div class="form-group" id="item-file">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="file" name="uploaded_file" id="uploaded_file">
							</div>
						</div>
						<div class="form-group" id="item-example_file">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
							<div class="col col-6 col-md-8 col-sm-8">
								<a href="/IEF/standarts/import_example_file/minimum_wage_cumulative_tax_base.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
							</div>
						</div>  						
					</div> 	
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">		
						<div class="form-group" id="item-format">
							<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
						</div> 	
						<div class="form-group" id="item-exp1">
							<cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır . Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır .'>
						</div>
						<div class="form-group" id="item-exp3">
							<cf_get_lang dictionary_id ="43804.Sıra No ve isim bilgi amaçlıdır.">
						</div>
						<div class="form-group" id="item-exp4">
							Asgari Ücret Kümülatif Vergi Matrahı ondalık şekilde yazılacaksa (.) kullanılmalıdır, (,) kullanılmamalıdır.
						</div>
						<div class="form-group" id="item-exp6">
							<cf_get_lang dictionary_id='35552.Belgede toplam 5 alan olacaktır alanlar sırasi ile'>;
						</div>
						<div class="form-group" id="item-exp7">
							1-<cf_get_lang dictionary_id ="31253.Sıra No"></br>
							2-<cf_get_lang dictionary_id ="58025.Tc Kimlik No">*</br>
							3-<cf_get_lang dictionary_id ="44688.Çalışan Adı"></br>
							4-<cf_get_lang dictionary_id ="44689.Çalışan Soyadı"></br>
							5-Asgari Ücret Kümülatif Vergi Matrahı (<cf_get_lang dictionary_id='59663.Tutar 192.45 formatında olmalıdır'>)*</br>
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
				alert("<cf_get_lang dictionary_id='43424.Belge Seçiniz'>!");
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
				alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>.");
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
			alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.'>");
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
                //Asgari Ücret Kümülatif Vergi Matrahı
                asgari_ucret_kumulatif_vergi_matrahi = Listgetat(dosya[i],j,";");
                asgari_ucret_kumulatif_vergi_matrahi =trim(asgari_ucret_kumulatif_vergi_matrahi);
                j=j+1;
			</cfscript>
			<cfcatch type="Any">
				<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
				<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
				<cfset error_flag = 1>
			</cfcatch>
		</cftry>
 		<cfif len(tckimlik_no) and len(asgari_ucret_kumulatif_vergi_matrahi) and error_flag neq 1>
				<cfquery name="GET_EMPLOYEE_INFO" maxrows="1" datasource="#dsn#">
					SELECT 
						EIO.IN_OUT_ID,
						EIO.EMPLOYEE_ID
					FROM
						EMPLOYEES_IN_OUT EIO,
						EMPLOYEES_IDENTY EI
					WHERE 
						EIO.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
						EI.TC_IDENTY_NO = '#tckimlik_no#'
					ORDER BY
						EIO.IN_OUT_ID DESC
				</cfquery>
				<cfif GET_EMPLOYEE_INFO.recordcount>
					<cftry>
						<cfquery datasource="#dsn#" name="UPD_CUMULATIVE_TAX">
							UPDATE
								EMPLOYEES_IN_OUT
							SET 
								START_CUMULATIVE_WAGE_TOTAL = #asgari_ucret_kumulatif_vergi_matrahi#
							WHERE 
								IN_OUT_ID = #GET_EMPLOYEE_INFO.IN_OUT_ID#
						</cfquery>
					<cfcatch type="Any">
							<cfset liste=ListAppend(liste,i&'. satırda kayıt sırasında hata oldu <br/>',',')>
							<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44948.İkinci adımda sorun oluştu'><br/>
						</cfcatch>
					</cftry>
				<cfelse>
					<cfset liste=ListAppend(liste,i&'. satırın employee_id veya in_out_id si yok <br/>',',')>
				</cfif>
		<cfelse>
			<cfset liste=ListAppend(liste,i&'. satırın tc kimlik numarası veya asgari ücret kümülatif vergi matrahı alanlarından herhangi biri eksiktir <br/>',',')>	
		</cfif>
	</cfloop>
	<cfoutput>#liste#</cfoutput>
	<cfif error_flag neq 1>
		<cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'>.....
	</cfif>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_minimum_wage_cumulative_tax_base';
	</script><abort>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
