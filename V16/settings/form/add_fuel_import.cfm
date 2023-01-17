<!--- Yakıt İmport --->
<cfif isdefined("attributes.fileUploadControl") and attributes.fileUploadControl eq 1>
	<!--- fiziki varlık import --->
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
			alert("<cf_get_lang_main no='1653.Dosya Okunamadı Karakter Seti Yanlış Seçilmiş Olabilir'>.");
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
		error_flag = 0;
	</cfscript>
	<cfloop from="2" to="#line_count#" index="i">
		<cfset kont=1>
		<cftry>
			<cfset paper_date = trim(listgetat(dosya[i],1,';'))>
			<cfset plaka = trim(listgetat(dosya[i],2,';'))>
			<cfset fuelAmount = trim(listgetat(dosya[i],3,';'))>
			<cfset totalAmount = trim(listgetat(dosya[i],4,';'))>
			<cfset company = trim(listgetat(dosya[i],5,';'))>
			<cfif listlen(dosya[i],';') eq 5>
				<cfset paperNo = ''>
			<cfelse>
				<cfset paperNo = trim(listgetat(dosya[i],5,';'))>
			</cfif>
			<cfif len(plaka)>
				<cfquery name="GET_ASSET_P" datasource="#dsn#">
					SELECT
						ASSETP_ID,
						EMPLOYEE_ID,
						DEPARTMENT_ID,
						FUEL_TYPE
					FROM
						ASSET_P
					WHERE
						ASSETP = '#plaka#'
				</cfquery>
			</cfif>
			<cfif len(company)>
				<cfquery name="GET_COMPANY_INFO" datasource="#DSN#">
					SELECT
						COMPANY_ID
					FROM
						COMPANY
					WHERE
						FULLNAME LIKE '%#company#%' OR
						NICKNAME LIKE '%#company#%'
				</cfquery>
			</cfif>
			<cflock name="#CreateUUID()#" timeout="60">
				<cftransaction>
					<cfif len(paper_date) and len(plaka) and len(fuelAmount) and len(totalAmount) and len(company) and GET_ASSET_P.recordcount and GET_COMPANY_INFO.recordcount>
						<cf_date tarih="paper_date">
						<cfquery name="INSERT_FUEL" datasource="#dsn#">
							INSERT INTO
								ASSET_P_FUEL
							(
								ASSETP_ID,
								EMPLOYEE_ID,
								DEPARTMENT_ID,
								FUEL_DATE,
								FUEL_COMPANY_ID,
								FUEL_TYPE_ID,
								FUEL_AMOUNT,
								TOTAL_AMOUNT,
								TOTAL_CURRENCY,
								DOCUMENT_TYPE_ID,
								RECORD_EMP,
								RECORD_DATE,
								DOCUMENT_NUM
							)
							VALUES
							(
								#GET_ASSET_P.ASSETP_ID#,
								#GET_ASSET_P.EMPLOYEE_ID#,
								#GET_ASSET_P.DEPARTMENT_ID#,
								#paper_date#,
								#GET_COMPANY_INFO.COMPANY_ID#,
								#GET_ASSET_P.FUEL_TYPE#,
								#fuelAmount#,
								#totalAmount#,
								'TL',
								1,
								#session.ep.userid#,
								#now()#,
								<cfif len(paperNo)>'#paperNo#'<cfelse>NULL</cfif>
							)
						</cfquery>
					</cfif>
				</cftransaction>
			</cflock>
			<cfcatch type="Any">
				<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
				<cfset error_flag = 1>
			</cfcatch>
		</cftry>
	</cfloop>
	<cfif error_flag eq 0>
		<cfoutput>
			<cf_get_lang dictionary_id='64287.Aktarım Tamamlanmıştır'>. <cf_get_lang dictionary_id='64288.Aktarılan kayıtları görmek için'>  <a href="#request.self#?fuseaction=assetcare.form_search_fuel" target="_blank"><B><cf_get_lang dictionary_id='35345.tıklayınız'>...</B></a>
		</cfoutput>
	</cfif>
<cfelse>
	<cf_form_box title="#getLang('assetcare',542)#">
		<cfform name="formimport" action="#request.self#?fuseaction=settings.add_fuel_import" enctype="multipart/form-data" method="post">
		<input type="hidden" name="fileUploadControl" id="fileUploadControl" value="0" />
		<cf_area width="300">
			<table>
				<tr>
					<td><cf_get_lang no='1402.Belge Formatı'></td>
					<td><select name="file_format" id="file_format" style="width:200px;">
							<option value="utf-8"><cf_get_lang no='1405.UTF-8'></option>
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='56.Belge'>*</td>
					<td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;"></td>
				</tr>
			</table>
		</cf_area>
		<cf_area>        
			<table>
				<tr height="30">
					<td class="headbold" colspan="2" valign="top"><cf_get_lang_main no='1182.Format'> </td>
				</tr>                       
				<tr>
					<td><cf_get_lang_main no ='217.Açıklama'>:</td>
				</tr>
				<tr>
					<td>
						<cf_get_lang dictionary_id='44342.Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir	'><br/>
						<cf_get_lang no ='2210.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır'>.
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no='2968.Bu belgede olması gereken alan sayısı'> : 6</td>
				</tr>
				<tr>
					<td><cf_get_lang no='2214.Alanlar sırasıyla'>;</td>
				</tr>
				<tr>
					<td>
						1-<cf_get_lang dictionary_id='57073.Belge Tarihi'>*<br/>
						2-<cf_get_lang dictionary_id='41443.Plaka'> *<br/>
						3-<cf_get_lang dictionary_id='48259.Yakıt Miktarı'> *<br/>
						4-<cf_get_lang dictionary_id="51316.KDV'li Toplam"> *<br/>
						5-<cf_get_lang dictionary_id='30117.Yakıt Şirketi '>*<br/>
						6-<cf_get_lang dictionary_id='57880.Belge No'><br/><br />
						<cf_get_lang_main no='55.NOT'>: (*) <cf_get_lang no ='3129.Yıldızlı Olanlar Zorunlu Alanlardır'>.
					</td>
				</tr>
			</table>
		</cf_area>
		<cf_form_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'> 
		</cf_form_box_footer>
		</cfform>
	</cf_form_box>
	<script type="text/javascript">
		function kontrol()
		{
			if(formimport.uploaded_file.value.length==0)
			{
				alert("<cf_get_lang no='1441.Belge Seçmelisiniz'>!");
				return false;
			}
			$("#fileUploadControl").val(1);
		}
	</script>
</cfif>