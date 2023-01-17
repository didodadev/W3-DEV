<!---
	TolgaS 20061230 muhasebe kod aktarım dosya formatı ilk satır başlık olacak şekilde 2 satırdan aktarım işlemi başlar ve 
	eğer ana hesap aktarılsın denirse içinde nokta olmayan (misal 100) de kaydedilir 
	format hesap no; hesap ad
	FBS 20081202 ufrs_kod,ufrs_name,ozel_kod,ozel_kod_name alanlari import icin eklendi, duruma gore zorunlu degil.
--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfif not isdefined('attributes.uploaded_file')>
		<cf_box title="#getLang('','Hesap Planı Aktarım','43460')#" closable="0">
			<cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_import_account_plan" enctype="multipart/form-data" method="post">
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
								<a href="/IEF/standarts/import_example_file/Hesap_Plani_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
							</div>
                    	</div>  		
                    	<div class="form-group" id="item-download-link">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43759.Ana Hesaplar Kaydedilsin mi'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" name="is_main" id="is_main"> ( <cf_get_lang dictionary_id='57495.Evet'>)
							</div>
                    	</div>  					
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-format">
							<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
						</div>	
						<div class="form-group" id="item-exp1">
							<cf_get_lang dictionary_id='35657.Dosya uzantısı csv olmalı ve alan araları virgül (;) ile ayrılmalıdır'>.
						</div>		
						<div class="form-group" id="item-exp2">
							<cf_get_lang dictionary_id='53889.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>						
						</div>	
						<div class="form-group" id="item-exp3">
							<cf_get_lang dictionary_id='44332.Belgede toplam 6 sütun olacaktır alanlar sırası ile'>;
						</div>
						<div class="form-group" id="item-exp4">
							1-<cf_get_lang dictionary_id='58178.Hesap No'>*</br>
							2-<cf_get_lang dictionary_id='55271.Hesap Adı'>*</br>		
							3-<cf_get_lang dictionary_id='58130.UFRS Kod'></br>
							4-<cf_get_lang dictionary_id='47551.UFRS Açıklama'>(<cf_get_lang dictionary_id='44725.UFRS kod varsa, açıklaması da olmalıdır!'>)</br>
							5-<cf_get_lang dictionary_id='57789.Özel Kod'></br>
							6-<cf_get_lang dictionary_id='33808.Özel Kod Açıklama'>(<cf_get_lang dictionary_id='44726.Özel Kod Varsa Açıklaması Da Olmalıdır'>)</br>			
						</div>
						<div class="form-group" id="item-exp5">
							<cf_get_lang dictionary_id='44335.Örnek Dosya Formatı'>:</br>
							<cf_get_lang dictionary_id='58178.Hesap No'>;<cf_get_lang dictionary_id='51125.Hesap Adı'>;<cf_get_lang dictionary_id='58130.IFRS Code'>;<cf_get_lang dictionary_id='47551.UFRS Açıklama'>;<cf_get_lang dictionary_id='57789.Özel Kod'>;<cf_get_lang dictionary_id='33808.Özel Kod Açıklama'></br>
							100( <cf_get_lang dictionary_id='40641.Cash Account'>);320.01.02( <cf_get_lang dictionary_id='44723.UFRS Bilgisi'>); 250.01( <cf_get_lang dictionary_id='44724.Özel Kod Bilgisi'>)</br>
							100.001( <cf_get_lang dictionary_id='37345.TL'> <cf_get_lang dictionary_id='44336.Kasa Hesabı'>);
							320.02.01( <cf_get_lang dictionary_id='47551.UFRS Açıklama'>);200.01( <cf_get_lang dictionary_id='33808.Özel Kod Açıklama'>)				
						</div>
						<div class="form-group" id="item-exp6">
							<cf_get_lang dictionary_id='44337.NOT: Aktarım hangi şirket döneminde iseniz ona yapılacaktır. Doğru dönemde olduğunuzdan emin olun'>.
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
					alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>!");
					return false;
				}
					return true;
			}
		</script>
	<cfelse>
		<cfsetting showdebugoutput="no">
		<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
		<cfif not DirectoryExists("#upload_folder_#")>
			<cfdirectory action="create" directory="#upload_folder_#">
		</cfif>
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
					alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>");
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

		<cfloop from="2" to="#line_count#" index="i">
			<cfset j= 1>
			<cfset error_flag = 0>
			<cftry>
				<cfscript>
				counter = counter + 1;
				//hesap_no
				hesap_no = Listgetat(dosya[i],j,";");
				hesap_no =trim(hesap_no);
				j=j+1;
				//hesap_adi
				hesap_adi = Listgetat(dosya[i],j,";");
				hesap_adi = trim(hesap_adi);
				j=j+1;
				//ufrs kod
				if(listlen(dosya[i],';') gte j)
				{
					ufrs_kod = Listgetat(dosya[i],j,";");
					ufrs_kod =trim(ufrs_kod);
				}
				else
					ufrs_kod = "";
				j=j+1;
				//ufrs aciklama
				if(listlen(dosya[i],';') gte j)
				{
					ufrs_aciklama = Listgetat(dosya[i],j,";");
					ufrs_aciklama =trim(ufrs_aciklama);
				}
				else
					ufrs_aciklama = "";
				j=j+1;
				//ozel kod
				if(listlen(dosya[i],';') gte j)
				{
					ozel_kod = Listgetat(dosya[i],j,";");
					ozel_kod = trim(ozel_kod);
				}
				else
					ozel_kod = "";
				j=j+1;
				//ozel aciklama
				if(listlen(dosya[i],';') gte j)
				{
					ozel_aciklama = Listgetat(dosya[i],j,";");
					ozel_aciklama = trim(ozel_aciklama);
				}
				else
					ozel_aciklama = "";
				</cfscript>
				
				<cfcatch type="Any">
					<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
					<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.Satır'> <cf_get_lang dictionary_id='44947.1. adımda sorun oluştu.'><br/>
					<cfset error_flag = 1>
				</cfcatch>
			</cftry>
			<cfif isdefined('attributes.is_main')>
				<cfset add_main=1>
			<cfelse>
				<cfset add_main=0>
			</cfif>
			<cfif len(hesap_no) and len(hesap_adi)>
				<cfscript>
					if(find('.',hesap_no))
					{
						ust_hesap_no = Reverse(hesap_no);
						ust_hesap_no = Reverse(mid(ust_hesap_no,find('.',ust_hesap_no)+1, 1+len(ust_hesap_no)-find('.',ust_hesap_no)));
						error_flag=0;
					}
					else
					{
						ust_hesap_no = '';
					}
					if(len(ufrs_kod) and not len(ufrs_aciklama))
					{
						writeoutput("<cf_get_lang dictionary_id='63148.Girdiğiniz UFRS Kodun Açıklamasını Da Girmelisiniz'>! <br/>");
						error_flag = 1;
					}
					if(isdefined("ozel_kod") and len(ozel_kod) and not len(ozel_aciklama))
					{
						writeoutput("<cf_get_lang dictionary_id='63149.Girdiğiniz Özel Kodun Açıklamasını Da Girmelisiniz'>! <br/>");
						error_flag = 1;
					}
				</cfscript>
				<!---hesap no kontrolü--->
				<cfif error_flag eq 0 and len(hesap_no) and ( find('.',hesap_no) or (not find('.',hesap_no) and add_main))>
					<cfquery name="CHECK_SAME" datasource="#dsn2#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE='#hesap_no#'
					</cfquery>
					<cfif check_same.recordcount>
						<cfset liste=listappend(liste,i&'. satır-hesap no var  <br/>',',')>
						<cfset error_flag = 1>
					</cfif>
				</cfif>
				<!--- ust hesap kontrol --->
				<cfif error_flag eq 0 and len(ust_hesap_no)>
					<cfquery name="CHECK_SAME" datasource="#dsn2#">
						SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE='#ust_hesap_no#'
					</cfquery>
					<cfif NOT check_same.recordcount>
						<cfset liste=listappend(liste,i&'. satır-üst hesap yok  <br/>',',')>
						<cfset error_flag = 1>
					</cfif>
				</cfif>
				<cfif error_flag neq 1 and ((not len(ust_hesap_no) and add_main eq 1) or len(ust_hesap_no))>
					<cftry>
						<cfquery name="add_product" datasource="#dsn2#">
							INSERT INTO
								ACCOUNT_PLAN
								(
									ACCOUNT_CODE,
									ACCOUNT_NAME,
									IFRS_CODE,
									IFRS_NAME,
									ACCOUNT_CODE2,
									ACCOUNT_NAME2,
									SUB_ACCOUNT,
									RECORD_EMP,
									RECORD_IP,
									RECORD_DATE
								)
							VALUES
								(
									'#hesap_no#',
									'#hesap_adi#',
									<cfif isdefined("ufrs_kod") and len(ufrs_kod)>'#ufrs_kod#'<cfelse>NULL</cfif>,
									<cfif isdefined("ufrs_aciklama") and len(ufrs_aciklama)>'#ufrs_aciklama#'<cfelse>NULL</cfif>,
									<cfif isdefined("ozel_kod") and len(ozel_kod)>'#ozel_kod#'<cfelse>NULL</cfif>,
									<cfif isdefined("ozel_aciklama") and len(ozel_aciklama)>'#ozel_aciklama#'<cfelse>NULL</cfif>,
									0,
									#session.ep.userid#,
									'#cgi.remote_addr#',
									#now()#
								)
						</cfquery>
						<cfif len(ust_hesap_no)>
							<cfquery name="UPD_MAIN_ACCOUNT" datasource="#dsn2#">
								UPDATE 
									ACCOUNT_PLAN 
								SET	
									SUB_ACCOUNT = 1,
									UPDATE_EMP = #session.ep.userid#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_DATE = #now()#
								WHERE 
									ACCOUNT_CODE = '#ust_hesap_no#'
							</cfquery>
						</cfif>
						<cfcatch type="Any">
							<cfset liste=ListAppend(liste,i&'. satırda kayıt sırasında hata oldu <br/>',',')>
							<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.Satır'><br/>
						</cfcatch>
					</cftry>
				</cfif>
			<cfelse>
				<cfif find('.',hesap_no) or add_main eq 1><!--- alt hesap veya üst hesap kaydedilsin denmiş ve üst hesapsa --->
					<cfset liste=ListAppend(liste,i&'. satırın hesap no veya adı yok <br/>',',')>
				</cfif>
			</cfif>
		</cfloop>
		<cfoutput>#liste#</cfoutput>
		<cfif error_flag neq 1>
			<cf_get_lang dictionary_id='47470.İşlem Tamamlandı'> (<cf_get_lang dictionary_id='44949.SAYFAYI YENİLEMEYİNİZ, HATALI KAYIT VARSA ONLARI İNCELEYEREK SAYFAYI KAPATINIZ'>)......
		</cfif>
	</cfif>
</div>