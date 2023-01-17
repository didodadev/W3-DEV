<cfif not isdefined('attributes.uploaded_file')>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Çalışan Oryantasyon Eğitimi Aktarımı','45165')#" closable="0">
			<cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_employee_orientation_edu_import" enctype="multipart/form-data" method="post">
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
								<a  href="/IEF/standarts/import_example_file/calisan_Oryantasyon_Egitimi_Aktarim.csv"><strong><cf_get_lang no='1692.İndir'></strong></a>
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
							<cf_get_lang dictionary_id='35552.Belgede toplam 5 alan olacaktır alanlar sırasi ile'>;					
						</div>						
						<div class="form-group" id="item-exp3">
							1-<cf_get_lang dictionary_id='54211.TC Kimlik No (Zorunlu)'><br/>
							2-<cf_get_lang dictionary_id='57480.Konu'>(<cf_get_lang dictionary_id='63370.Oryantasyon Eğitim Konusu'>)<br/>
							3-<cf_get_lang dictionary_id='57544.Sorumlu'>(<cf_get_lang dictionary_id='63373.Firma Çalışanının ID si'>)<br/>	
							4-<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'><br/>
							5-<cf_get_lang dictionary_id='57700.Bitiş Tarihi'><br/>  
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
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>!");
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
					mode="777" charset="utf-8">
			<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
			<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
			<cfset file_size = cffile.filesize>
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='63329.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz'>!");
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
				alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>");
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
		<cfset kont=1>
		<cfloop from="2" to="#line_count#" index="i">
			<cftry>
				<cfset tc_kimlik_no = trim(listgetat(dosya[i],1,';'))>
				<cfset orientation_head = trim(listgetat(dosya[i],2,';'))>
				<cfset trainer_emp_id = trim(listgetat(dosya[i],3,';'))>
				<cfif (listlen(dosya[i],';') gte 4)>
					<cfset start_date = trim(listgetat(dosya[i],4,';'))>
				<cfelse>
					<cfset start_date = ''>
				</cfif>
				<cfif (listlen(dosya[i],';') gte 5)>
					<cfset finish_date = trim(listgetat(dosya[i],5,';'))>
				<cfelse>
					<cfset finish_date = ''>
				</cfif>
				<cfcatch type="Any">
					<cfoutput>#i#. Satır Hatalı<br/></cfoutput>	
					<cfset kont=0>
				</cfcatch>  
			</cftry>
			<cftry>
				<cfif len(start_date)>
					<cfset gun = listfirst(start_date,'.')>
					<cfset ay = listgetat(start_date,2,'.')>
					<cfset yil = listlast(start_date,'.')>
					<cfset baslama_tarih = '#ay#/#gun#/#yil#'>
					<cfset baslama_gun = createodbcdatetime(baslama_tarih)>
				<cfelse>
					<cfset baslama_gun = ''>
				</cfif>
				<cfif len(finish_date)>
					<cfset gun2 = listfirst(finish_date,'.')>
					<cfset ay2 = listgetat(finish_date,2,'.')>
					<cfset yil2 = listlast(finish_date,'.')>
					<cfset bitis_tarih = '#ay2#/#gun2#/#yil2#'>
					<cfset bitis_gun = createodbcdatetime(bitis_tarih)>
				<cfelse>
					<cfset bitis_gun = ''>
				</cfif>
				<cfquery name="get_employee" datasource="#dsn#">
					SELECT EMPLOYEE_ID FROM EMPLOYEES_IDENTY WHERE TC_IDENTY_NO = '#tc_kimlik_no#'
				</cfquery>
				<cfcatch type="Any">
					<cfset kont=1>
				</cfcatch>
				</cftry>
				<cflock name="#CreateUUID()#" timeout="60">
				<cftransaction>
					<cftry>
					<cfquery name="add_orientation" datasource="#dsn#">
						INSERT INTO
							TRAINING_ORIENTATION
							(
								ORIENTATION_HEAD,
								START_DATE,
								FINISH_DATE,
								TRAINER_EMP,
								ATTENDER_EMP,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#orientation_head#">,
								<cfif len(baslama_gun)>#baslama_gun#<cfelse>NULL</cfif>,
								<cfif len(bitis_gun)>#bitis_gun#<cfelse>NULL</cfif>,
								<cfif len(trainer_emp_id)>#trainer_emp_id#<cfelse>NULL</cfif>,
								#get_employee.employee_id#,
								#now()#,
								#session.ep.userid#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
							)
					</cfquery>
					<cfcatch type="Any">
						<cfoutput>#i#. Satır Hatalı<br/></cfoutput>	
						<cfset kont=0>
						<script>window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_employee_orientation_edu_import"</script>
					</cfcatch>  
					</cftry>
				</cftransaction>
				</cflock>
		</cfloop>
		<cfif kont eq 1>
			<cfoutput> Satır İmport Edildi... <br/></cfoutput>
			<script>window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_employee_orientation_edu_import"</script>
		</cfif>
</cfif>
