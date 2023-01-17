<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
<cfif not isdefined('attributes.uploaded_file')>
	<cf_box title="#getLang('','Çalışan Eğitim Bilgileri Aktarım','42833')#" closable="0">
        <cfform name="formimport" action="#request.self#?fuseaction=ehesap.import_employee_edu_info" enctype="multipart/form-data" method="post">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-file_format">	
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>	
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">	
							<select name="file_format" id="file_format">	
								<option value="UTF-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>	
							</select>	
						</div>	
					</div>  				
					<div class="form-group" id="item-uploaded_file">	
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>	
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">	
							<input type="file" name="uploaded_file" id="uploaded_file">	
						</div>	
					</div>  
					<div class="form-group" id="item-download-link">	
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>	
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">	
							<a  href="/IEF/standarts/import_example_file/calisan_Egitim_Bilgileri_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
						</div>	
					</div>	
				</div>
				<div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-format">
						<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>	
					</div> 					
					<div class="form-group" id="item-exp1">
						<cf_get_lang dictionary_id='33719.NOT: Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır. Format UTF-8 Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'>
					</div> 					
					<div class="form-group" id="item-exp2">
						1-<cf_get_lang dictionary_id='58025.TC Kimlik No'>*</br>
						2-<cf_get_lang dictionary_id='31551.Okul Türü'>*(
							<cfquery name="get_education_level" datasource="#dsn#">
								SELECT 
								EDU_LEVEL_ID,
								#DSN#.#dsn#.Get_Dynamic_Language(EDU_LEVEL_ID,'#session.ep.language#','SETUP_EDUCATION_LEVEL','EDUCATION_NAME',NULL,NULL,SETUP_EDUCATION_LEVEL.EDUCATION_NAME ) AS EDUCATION_NAME 
								
								FROM 
								SETUP_EDUCATION_LEVEL
							</cfquery>
							<cfoutput query="get_education_level">
							#education_name#=#edu_level_id#,
							</cfoutput>)</br>
						3-<cf_get_lang dictionary_id='30645.Okul Adı'>*</br>	
						4-<cf_get_lang dictionary_id='57709.Okul'>ID(<cf_get_lang dictionary_id='59617.Bu alan Üniversite Bilgilerinde mutlaka girilmelidir'>)</br>
						5-<cf_get_lang dictionary_id='40788.Bölüm Adı'>(<cf_get_lang dictionary_id='59618.Bu alan Lise ve Üniversite bilgilerinde girilmeli'>)</br>
						6-<cf_get_lang dictionary_id='57995.Bölüm'>ID</br>
						7-<cf_get_lang dictionary_id='31556.Giriş Yılı'></br>
						8-<cf_get_lang dictionary_id='31050.Mezuniyet Yılı'></br>
						9-<cf_get_lang dictionary_id='31482.Not Ort'></br>
						10-<cf_get_lang dictionary_id='59616.Eğitim Dili'></br>
						11-<cf_get_lang dictionary_id='59619.Eğitim Süresi'></br>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
		</cfform>
	</cf_box>
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
			//tckimlik_no
			tckimlik_no = Listgetat(dosya[i],j,";");
			tckimlik_no =trim(tckimlik_no);
			j=j+1;
			//okul türü
			edu_type = Listgetat(dosya[i],j,";");
			edu_type =trim(edu_type);
			j=j+1;
			//okul adı
			edu_name = Listgetat(dosya[i],j,";");
			edu_name =trim(edu_name);
			j=j+1;
			//okul id
			edu_id = Listgetat(dosya[i],j,";");
			edu_id =trim(edu_id);
			j=j+1;
			//bölüm adı
			edupart_name = Listgetat(dosya[i],j,";");
			edupart_name =trim(edupart_name);
			j=j+1;
			//bölüm id
			edupart_id = Listgetat(dosya[i],j,";");
			edupart_id =trim(edupart_id);
			j=j+1;
			//giriş yılı
			edu_start = Listgetat(dosya[i],j,";");
			edu_start =trim(edu_start);
			j=j+1;
			//mezuniyet yılı
			edu_finish = Listgetat(dosya[i],j,";");
			edu_finish =trim(edu_finish);
			j=j+1;
			//not ort
			if(listlen(dosya[i],';') gte j)
			{
				edu_rank = Listgetat(dosya[i],j,";");
				edu_rank =trim(edu_rank);
			}
			else edu_rank ='';
			j=j+1;
			//eğitim dili
			if(listlen(dosya[i],';') gte j)
			{
				edu_lang = Listgetat(dosya[i],j,";");
				edu_lang =trim(edu_lang);
			}
			else edu_lang ='';
			j=j+1;
			//eğitim süresi
			if(listlen(dosya[i],';') gte j)
			{
				edu_time = Listgetat(dosya[i],j,";");
				edu_time =trim(edu_time);
			}
			else edu_time ='';
			j=j+1;
			//alanlar bitti
			</cfscript>
			
			<cfcatch type="Any">
				<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
				<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
				<cfset error_flag = 1>
				<script>
					window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_edu_info';
				</script>
			</cfcatch>
		</cftry>
		<cftry>
			<cfif len(tckimlik_no) and len(edu_type) and len(edu_name) and error_flag neq 1>
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
						<cfquery name="get_emp_edu" datasource="#dsn#">
							SELECT
								*
							FROM
								EMPLOYEES_APP_EDU_INFO
							WHERE
								EMPLOYEE_ID = #GET_EMPLOYEE_INFO.employee_id#
								AND EDU_TYPE = #edu_type#
						</cfquery>
						<cfif get_emp_edu.recordcount gt 0>
							<cfquery name="upd_edu_info" datasource="#dsn#">
								UPDATE 
									EMPLOYEES_APP_EDU_INFO
								SET
									EMPLOYEE_ID = #GET_EMPLOYEE_INFO.employee_id#,
									EDU_TYPE = #edu_type#,
									EDU_NAME = '#edu_name#',
									EDU_ID = <cfif len(edu_id)>#edu_id#<cfelse>NULL</cfif>,
									EDU_PART_NAME = <cfif len(edupart_name)>'#edupart_name#'<cfelse>NULL</cfif>,
									EDU_PART_ID = <cfif len(edupart_id)>#edupart_id#<cfelse>NULL</cfif>,
									EDU_START = <cfif len(edu_start)>#edu_start#<cfelse>NULL</cfif>,
									EDU_FINISH = <cfif len(edu_finish)>#edu_finish#<cfelse>NULL</cfif>,
									EDU_RANK = <cfif len(edu_rank)>'#edu_rank#'<cfelse>NULL</cfif>,
									EDUCATION_LANG = '#edu_lang#',
									EDUCATION_TIM = #edu_time#
								WHERE
									EMPLOYEE_ID = #GET_EMPLOYEE_INFO.employee_id#
									AND EDU_TYPE = #edu_type#			
							</cfquery>
						<cfelse>
							<cfquery name="add_edu_info" datasource="#dsn#">
								INSERT INTO 
									EMPLOYEES_APP_EDU_INFO
										(
										EMPLOYEE_ID,
										EDU_TYPE,
										EDU_NAME,
										EDU_ID,
										EDU_PART_NAME,
										EDU_PART_ID,
										EDU_START,
										EDU_FINISH,
										EDU_RANK,
										EDUCATION_LANG,
										EDUCATION_TIME
										)
									VALUES
										(
											#GET_EMPLOYEE_INFO.employee_id#,
											#edu_type#,
											'#edu_name#',
											<cfif len(edu_id)>#edu_id#<cfelse>NULL</cfif>,
											<cfif len(edupart_name)>'#edupart_name#'<cfelse>NULL</cfif>,
											<cfif len(edupart_id)>#edupart_id#<cfelse>NULL</cfif>,
											<cfif len(edu_start)>#edu_start#<cfelse>NULL</cfif>,
											<cfif len(edu_finish)>#edu_finish#<cfelse>NULL</cfif>,
											<cfif len(edu_rank)>'#edu_rank#'<cfelse>NULL</cfif>,
											'#edu_lang#',
											#edu_time#
										)
							</cfquery>
						</cfif>
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
			<cfset error_flag = 1>
		</cfcatch>
		</cftry>
	</cfloop>
	<cfoutput>#liste#</cfoutput>
	<cfif error_flag neq 1>
		<cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'>
	</cfif>
	<script>
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_edu_info';
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
