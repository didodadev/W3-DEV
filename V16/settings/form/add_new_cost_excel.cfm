<!--- 
	Mahmut ER
	Excel ile Maliyet Aktarımı için Yapıldı!
	20 05 2009
 --->
<cfparam name="attributes.department_id" default="">
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD,
		D.DEPARTMENT_STATUS
	FROM
		BRANCH B,
		DEPARTMENT D 
	WHERE
		B.COMPANY_ID = #session.ep.company_id# AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
    	ID, 
        LOCATION_ID, 
        DEPARTMENT_ID,
        COMPANY_ID, 
        COMMENT, 
        STATUS 
    FROM 
	    STOCKS_LOCATION 
    ORDER BY 
    	COMMENT
</cfquery>	
<cfflush interval="1000">
<cfparam name="attributes.date1" default="">
<cfsavecontent variable="title_">
	<cf_get_lang_main no='846.Maliyet'> <cf_get_lang no='1548.Aktarım'>
</cfsavecontent>
<cf_form_box title="#title_#" nofooter="1">
	<cfform name="excel_import" action="#request.self#?fuseaction=settings.add_new_cost_excel_query" enctype="multipart/form-data" method="post">
		<cf_area width="280">
			<table>
				<tr>
					<td class="txtbold" colspan="2"><cf_get_lang_main no='56.Belge'></td>
				</tr>
				<tr>
					<td nowrap="nowrap"><cf_get_lang_main no ='641.Başlangıç Tarihi'></td>
					<td style="width:250px;">
						<cfsavecontent variable="message"><cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="date1" id="date1" value="#attributes.date1#" validate="#validate_style#" message="#message#" style="width:65px;">
						<cf_wrk_date_image date_field="date1">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no="1447.Süreç"></td>
					<td><cf_workcube_process is_upd='0' process_cat_width='85' is_detail='0'></td>
				</tr>
				<tr>
					<td> <cf_get_lang no='2945.Key'></td>
					<td>
						<select name="paper_key" id="paper_key" style="width:85px;">
							<option value="1"><cf_get_lang_main no='106.Stok Kodu'></option>
							<option value="2"><cf_get_lang_main no='377.Özel Kod'></option>
						</select>
					</td>
				</tr>
				<tr>
					<td width="200"><cf_get_lang no='1402.Belge Formatı'></td>
					<td>
						<select name="file_format" id="file_format" style="width:85px;">
							<option value="UTF-8"><cf_get_lang no='1405.UTF-8'></option>
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='56.Belge'>*</td>
					<td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200;"></td>
				</tr>
				<tr>
					<td width="200"><cf_get_lang_main no ='2234.Departman-Lokasyon'></td>
					<td>
						<select name="department_id" id="department_id" style="width:180px;">
							<option value=""><cf_get_lang_main no ='322.Seciniz'></option>
							<cfoutput query="get_department">
								<optgroup label="#department_head#" <cfif DEPARTMENT_STATUS neq 1>style="color:##FF0000"</cfif>>
								<cfquery name="get_location" dbtype="query">
									SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = #get_department.department_id[currentrow]#
								</cfquery>
								<cfif get_location.recordcount>
									<cfloop from="1" to="#get_location.recordcount#" index="s">
										<option <cfif get_location.status neq 1>style="color:##FF0000"</cfif> value="#department_id#-#get_location.location_id[s]#" <cfif listfind(attributes.department_id,'#department_id#-#get_location.location_id[s]#',',')>selected</cfif>>&nbsp;&nbsp;#get_location.comment[s]#</option>
									</cfloop>
								</cfif>
								</optgroup>					  
							</cfoutput>
						</select>
					</td>	
				</tr>		
				<tr>
					<td colspan="2" style="text-align:right;width:250px;"><input type="button" value="<cf_get_lang_main no ='1264.Aktar'>" onClick="control();">&nbsp;</td>
				</tr>
			</table>
		</cf_area>
		<cf_area>
			<table>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='1182.Format'></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no ='217.Açıklama'>:</td>
				</tr>
				<tr>
					<td><cf_get_lang no ='2359.Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>.<br/>
						<cf_get_lang no ='2210.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır'>.
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no='2968.Bu belgede olması gereken alan sayısı'> : 8</td>
				</tr>
				<tr>
					<td><cf_get_lang no='2214.Alanlar sırasıyla'>;</td>
				</tr>
				<tr>
					<td>
						1-<cf_get_lang no='2947.Stok Kodu Yada Özel Kod(zorunlu alan,bir belgedeki tüm kodlar ya Stok Kodu yada Özel Kod olmalıdır)'><br/>
						2- Maliyet * <br/>
						3- Ek Maliyet <br/>
						4- Sistem Para Birimli Net Maliyet * <br/>
						5- Sistem Para Birimli Ek Maliyet <br/>
						6- Sistem Döviz Birimi Net Maliyet (Değer girilmez ise sistem 2. döviz birimi satış kurunu baz alarak hesaplanır)<br/>
						7- Sistem Döviz Birimi Ek Maliyet (Değer girilmez ise sistem 2. döviz birimi satış kurunu baz alarak hesaplanır)<br/>
						8- Spec Main ID (Girilmezse üretiliyor olup özelleştirilmeyen ürünler için son Spec bilgisi yazılır.)<br/><br/><br/>
						NOT : * olan alanlar zorunludur. Maliyet verileri yazılırken ondalıklı sayı içeren ifadelerde ayraç olarak virgül (,) kullanılmalıdır ve kesinlikle nokta kullanılmamalıdır! [ör:1251,6]
					</td>
				</tr>
				<tr>
					<td>
						<a target="_blank" href="/settings/form/MaliyetExcelFormat.xlsx">
							<font color="red"> <cf_get_lang no='2950.Örnek Excel Dosyası'></font>
						</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a target="_blank" href="/settings/form/MaliyetExcelFormat.csv">
							<font color="red"> <cf_get_lang no='2951.Örnek CSV Dosyası'></font>
						</a><br />
					</td>
				</tr>
			</table>
		</cf_area>
	</cfform>
</cf_form_box>
<script type="text/javascript">
	function control(){
		if(document.getElementById('uploaded_file').value == ""){
			alert("<cf_get_lang no='1441.Belge Seçiniz'>");
			return false;
		}	
		if(document.getElementById('date1').value == ""){
			alert("<cf_get_lang_main no='1091.Tarih Giriniz'>!");
			return false;
		}
		if(document.getElementById('process_stage').value == ""){
			alert("<cf_get_lang no='1414.Maliyet Süreç Yetkiniz Yok'>!!");
			return false;
		}
		document.excel_import.submit();
	}
</script>
