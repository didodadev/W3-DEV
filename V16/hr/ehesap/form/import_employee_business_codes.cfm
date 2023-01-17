<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
	<cfif not isdefined('attributes.uploaded_file')>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box title="#getLang('','Çalışan Meslek Kodu Aktarım','42834')#">
				<cfform name="formimport" action="#request.self#?fuseaction=ehesap.import_employee_business_codes" enctype="multipart/form-data" method="post">
					<cf_box_elements>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-file">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="file" name="uploaded_file" id="uploaded_file">
								</div>
							</div>		
							<div class="form-group" id="item-file_format">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<a href="/IEF/standarts/import_example_file/calisan_Meslek_Kodu_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
								</div>
							</div>											
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-format">
								<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
							</div> 	
							<div class="form-group"	id="item-exp1">
								<cf_get_lang dictionary_id ='35657.Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>
							</div>		
							<div class="form-group" id="item-exp2">
								<cf_get_lang dictionary_id ='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.
							</div>	
							<div class="form-group"	id="item-exp3">
								<cf_get_lang dictionary_id="35628.Belgede toplam 2 alan olacaktır alanlar sırasi ile">;
							</div>
							<div class="form-group" id="item-exp4">
								1-<cf_get_lang dictionary_id="58025.Tc Kimlik No">*<br/>
								2-<cf_get_lang dictionary_id="59614.Meslek Kodu (4220.05 şeklinde kod olarak girilmelidir.)">
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
				alert("<cf_get_lang dictionary_id='57455.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>");
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
				//tckimlik_no
				tckimlik_no = Listgetat(dosya[i],j,";");
				tckimlik_no =trim(tckimlik_no);
				j=j+1;				
				//meslek kodu
				business_code_ = Listgetat(dosya[i],j,";");
				business_code_ =trim(business_code_);
				j=j+1;			
				//alanlar bitti
				</cfscript>				
				<cfcatch type="Any">
					<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
					<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
					<cfset error_flag = 1>
					<script>
						window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_business_codes';
					</script>
				</cfcatch>
			</cftry>
			<cfif error_flag eq 0>
					<cfquery name="GET_EMPLOYEE_INFO" maxrows="1" datasource="#dsn#">
						SELECT 
							EIO.IN_OUT_ID
						FROM
							EMPLOYEES E,
							EMPLOYEES_IDENTY EI,
							EMPLOYEES_IN_OUT EIO
						WHERE 
							E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
							E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
							EI.TC_IDENTY_NO = '#tckimlik_no#' AND
							EIO.FINISH_DATE IS NULL
					</cfquery>
				<cfif GET_EMPLOYEE_INFO.recordcount>
						<cftry>
							<cfquery name="get_b_name" dbtype="query">
								SELECT BUSINESS_CODE_ID FROM get_business_codes WHERE BUSINESS_CODE = '#business_code_#'
							</cfquery>
							<cfquery name="upd_" datasource="#dsn#">
								UPDATE
									EMPLOYEES_IN_OUT
								SET
									BUSINESS_CODE_ID = <cfif get_b_name.recordcount>#get_b_name.BUSINESS_CODE_ID#<cfelse>NULL</cfif>,
									UPDATE_EMP = #session.ep.userid#,
									UPDATE_IP = '#cgi.REMOTE_ADDR#',
									UPDATE_DATE = #now()#
								WHERE
									IN_OUT_ID = #GET_EMPLOYEE_INFO.IN_OUT_ID#	
							</cfquery>
						<cfcatch type="Any">
								<cfset liste=ListAppend(liste,i&'. satırda kayıt sırasında hata oldu <br/>',',')>
								<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44948.İkinci adımda sorun oluştu'><br/>
							</cfcatch>
						</cftry>
				<cfelse>
					<cfset liste=ListAppend(liste,i&'. satırın in_out si yok <br/>',',')>
				</cfif>
			</cfif>
		</cfloop>
		<cfoutput>#liste#</cfoutput>
		<cfif error_flag neq 1>
			<cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'> (<cf_get_lang dictionary_id='44949.SAYFAYI YENİLEMEYİNİZ HATALI KAYIT VARSA ONLARI İNCELEYEREK SAYFAYI KAPATINIZ'>)......
			<script>
				window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_business_codes';
			</script>
		</cfif>
	</cfif>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	