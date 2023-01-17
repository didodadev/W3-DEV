<!---Görev degisikligi tablosu icin yapilmistir SG20120725 --->
<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
	<cfif not isdefined('attributes.uploaded_file')>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box title="#getLang('','Görev Değişikliği Aktarım','42830')#">
				<cfform name="formimport" action="#request.self#?fuseaction=ehesap.import_employee_position_history" enctype="multipart/form-data" method="post">
					<cf_box_elements>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-file_format">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
									<select name="file_format" id="file_format">
										<option value="UTF-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
									</select>
								</div>
							</div> 	
							<div class="form-group" id="item-file">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
									<input type="file" name="uploaded_file" id="uploaded_file">
								</div>
							</div>   
							<div class="form-group" id="item-example_file">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
									<a href="/IEF/standarts/import_example_file/Gorev_Degisikligi_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
								</div>
							</div>                                                                                 
						</div>											
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-format">
								<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
							</div>  
							<div class="form-group" id="item-exp1">
								<cf_get_lang dictionary_id ='35657.Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>
							</div>
							<div class="form-group" id="item-exp2">
								<cf_get_lang dictionary_id ='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.
							</div>
							<div class="form-group" id="item-exp3">
								<cf_get_lang dictionary_id ="56627.Belgede toplam 11 alan olacaktır alanlar sırası ile">;
							</div>
							<div class="form-group" id="item-exp4">
								1-<cf_get_lang dictionary_id ="58025.Tc Kimlik No">*<br/>
								2-<cf_get_lang dictionary_id ="57572.Departman"> <cf_get_lang dictionary_id ="58527.ID"> *</br>
								3-<cf_get_lang dictionary_id ="58497.Pozisyon"> <cf_get_lang dictionary_id ="57897.Adı"> *</br>
								4-<cf_get_lang dictionary_id ="59004.Pozisyon Tipi"> <cf_get_lang dictionary_id ="58527.ID"> *</br>
								5-<cf_get_lang dictionary_id ="59624.Başlama tarihi dd.mm.yyyy formatında olmalıdır">*</br>
								6-<cf_get_lang dictionary_id ="59625.Bitiş tarihi dd.mm.yyyy formatında olmalıdır"></br>
								7-<cf_get_lang dictionary_id ="59144.Fonksiyon Id"></br>
								8-<cf_get_lang dictionary_id ="59142.Ünvan Id">*</br>
								9-<cf_get_lang dictionary_id ="30937.Gerekçe"> <cf_get_lang dictionary_id ="58527.ID"></br>
								10-<cf_get_lang dictionary_id ="59146.Kademe Id"></br>
								11-<cf_get_lang dictionary_id ="56063.Yaka Tipi"> <cf_get_lang dictionary_id ="58527.ID"></br>
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
				//tckimlik_no
				tckimlik_no = Listgetat(dosya[i],j,";");
				tckimlik_no =trim(tckimlik_no);
				j=j+1;
				//department id
				department_id = Listgetat(dosya[i],j,";");
				department_id =trim(department_id);
				j=j+1;
				//position_name
				position_name = Listgetat(dosya[i],j,";");
				position_name =trim(position_name);
				j=j+1;
				//positioncat id
				position_cat_id = Listgetat(dosya[i],j,";");
				position_cat_id =trim(position_cat_id);
				j=j+1;
				//başlama tarihi
				start_date = Listgetat(dosya[i],j,";");
				j=j+1;
				//bitiş tarihi
				finish_date = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//func_id
				func_id = Listgetat(dosya[i],j,";");
				func_id =trim(func_id);
				j=j+1;
				//title_id
				title_id = Listgetat(dosya[i],j,";");
				title_id =trim(title_id);
				j=j+1;
				//reason_id
				reason_id = Listgetat(dosya[i],j,";");
				reason_id =trim(reason_id);
				j=j+1;
				//organization_step_id
				organization_step_id = Listgetat(dosya[i],j,";");
				organization_step_id =trim(organization_step_id);
				j=j+1;
				//collar_type
				collar_type = Listgetat(dosya[i],j,";");
				collar_type =trim(collar_type);
				j=j+1;
				</cfscript>
				<cfcatch type="Any">
					<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
					<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
					<cfset error_flag = 1>
					<script>
						window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_position_history';
					</script>
				</cfcatch>
			</cftry>
			<cftry>
			 <cfif len(tckimlik_no) and len(department_id) and len(position_name) and len(position_cat_id) and len(title_id) and len(start_date) and error_flag neq 1>
					<cfquery name="GET_EMPLOYEE_INFO" maxrows="1" datasource="#dsn#">
						SELECT 
							E.EMPLOYEE_ID
						FROM
							EMPLOYEES E,
							EMPLOYEES_IDENTY EI
						WHERE 
							E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
							EI.TC_IDENTY_NO = '#tckimlik_no#'
					</cfquery>
					<cfif GET_EMPLOYEE_INFO.recordcount>
						<cftry>
							<cfquery datasource="#dsn#" name="add_position_in">
								INSERT INTO 
									EMPLOYEE_POSITIONS_CHANGE_HISTORY
										(
										EMPLOYEE_ID,
										DEPARTMENT_ID,
										POSITION_ID,
										POSITION_NAME,
										POSITION_CAT_ID,
										TITLE_ID,
										FUNC_ID,
										START_DATE,
										FINISH_DATE,
										RECORD_IP,
										RECORD_EMP,
										RECORD_DATE,
										REASON_ID,
										ORGANIZATION_STEP_ID,
										COLLAR_TYPE
										)
									VALUES
										(
										#get_employee_info.employee_id#,
										#department_id#,
										0,
										'#position_name#',
										#position_cat_id#,
										#title_id#,
										<cfif len(func_id)>#func_id#<cfelse>NULL</cfif>,
										#CreateDate(listgetat(start_date,3,'.'),listgetat(start_date,2,'.'),listgetat(start_date,1,'.'))#,
										<cfif len(finish_date) gt 0>#CreateDate(listgetat(finish_date,3,'.'),listgetat(finish_date,2,'.'),listgetat(finish_date,1,'.'))#<cfelse>NULL</cfif>,
										'#cgi.remote_addr#',
										#session.ep.userid#,
										#now()#,
										<cfif len(reason_id)>#reason_id#<cfelse>NULL</cfif>,
										<cfif len(organization_step_id)>#organization_step_id#<cfelse>NULL</cfif>,
										<cfif len(collar_type)>#collar_type#<cfelse>NULL</cfif>
										)
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
				<cfcatch type="Any">
					<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
					<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
					<cfset error_flag = 1>
				</cfcatch>
			</cftry>
		</cfloop>
		<cfoutput>#liste#</cfoutput>
		<cfif error_flag neq 1>
			<cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'> (<cf_get_lang dictionary_id='44949.SAYFAYI YENİLEMEYİNİZ HATALI KAYIT VARSA ONLARI İNCELEYEREK SAYFAYI KAPATINIZ'>)......
			<script>
				window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_position_history';
			</script>
		</cfif>
	</cfif>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	