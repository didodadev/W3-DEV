<cf_xml_page_edit fuseact='ehesap.import_payments'>
<cfparam name="attributes.related_company" default="">
<cfif month(now()) eq 1>
	<cfparam name="attributes.sal_mon" default="1">
<cfelse>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
</cfif>	
<cfparam name="attributes.process_type" default="1">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfquery name="get_related_company" datasource="#dsn#">
	SELECT DISTINCT
		RELATED_COMPANY
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IS NOT NULL
		<cfif not session.ep.ehesap>
			AND BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
		</cfif>
	ORDER BY 
			RELATED_COMPANY
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53664.İmport İşlemleri"></cfsavecontent>
<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="" name="import_worktimes" method="post" enctype="multipart/form-data">
		<cf_box_elements vertical="1">
			<cfinclude template="../query/get_our_comp_and_branchs.cfm">
			<cfinput type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="form-group">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id ='57800.İşlem Tipi'>*</label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="process_type" id="process_type" onChange="type_gizle(); formatGoster(this.value, this.options[this.selectedIndex].text);">
							<option value="1"><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
							<option value="2"><cf_get_lang dictionary_id ='54068.Ödenek İmport'></option>
							<option value="3"><cf_get_lang dictionary_id ='54069.Kesinti İmport'></option>
							<option value="4"><cf_get_lang dictionary_id ='54070.Vergi İstisnaları İmport'></option>
							<option value="5"><cf_get_lang dictionary_id='65475.Tip 1 - Gün Bazlı import'></option>
							<option value="6"><cf_get_lang dictionary_id='65476.Tip 2 - Tek Gün Tipinde İmport'></option>
							<option value="8"><cf_get_lang dictionary_id='65477.Tip 3 - Ay Bazında Toplamlı'></option>
							<option value="7"><cf_get_lang dictionary_id ='54244.İzin İmport'></option>
							<option value="9"><cf_get_lang dictionary_id ="41795.OKES İmport"></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="is_related_company">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id ='53701.İlgili Şirket'>*</label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="related_company" id="related_company">
							<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
							<cfoutput query="get_related_company">
								<cfif len(related_company)>
									<option value="#related_company#" <cfif attributes.related_company is related_company>selected</cfif>>#related_company#</option>
								</cfif>					
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="is_branch_id">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57453.Şube'>*</label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="branch_id" id="branch_id">
							<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
							<cfoutput query="get_our_comp_and_branchs">
								<option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
							</cfoutput>
						</select>
					</div>			
				</div>
				<div class="form-group" id="is_sal_show" <cfif listfind("1,2,3,4,7,8",attributes.process_type)>style="display:none;"</cfif>>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id ='53808.Ay/Yıl'></label></div>
					<div class="col col-6 col-md-9 col-sm-9 col-xs-12">
						<select name="sal_mon" id="sal_mon">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop from="1" to="12" index="i">
								<cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
							</cfloop>
						</select>
					</div>
					<div class="col col-3 col-md-9 col-sm-9 col-xs-12">
						<input type="text" name="sal_year" id="sal_year" value="<cfif isdefined("attributes.sal_year")><cfoutput>#attributes.sal_year#</cfoutput></cfif>">
					</div>
				</div>
				<div class="form-group" id="is_mesai_type" <cfif listfind("1,2,3,4,7",attributes.process_type)>style="display:none;"</cfif>>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='53599.Mesai Türü'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="mesai_type" id="mesai_type">
							<option value="1"><cf_get_lang dictionary_id='53260.Saatlik'></option>
							<option value="2"><cf_get_lang dictionary_id='54198.Dakikalık'></option>
						</select>
					</div>			
				</div>
				<div class="form-group" id="is_file_format" <cfif listfind("1,2,3,4,7",attributes.process_type)>style="display:none;"</cfif>>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='53723.Belge Formatı'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="file_format" id="file_format">
							<option value="UTF-8"><cf_get_lang dictionary_id='54245.UTF-8'></option>
						</select>
					</div>			
				</div>
				<div class="form-group">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id ='57468.Belge'> *</label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="file" name="uploaded_file" id="uploaded_file" class="custom-file-input">
					</div>			
				</div>
				<div class="form-group" id="is_process" <cfif listfind("1,4,7",attributes.process_type)>style="display:none;"</cfif>>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id ='58859.Süreç'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
					</div>
				</div>
				<div class="form-group" id="is_valid" <cfif listfind("1,2,3,4,7",attributes.process_type)>style="display:none;"</cfif>>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='53042.Onay Durumu'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="valid" id="valid">
							<option value="0"><cf_get_lang dictionary_id='57616.Onaylı'></option>
							<option value="1"><cf_get_lang dictionary_id='53107.Onaysız'></option>
						</select>
					</div>			
				</div>
				<div class="form-group" id="is_validator_position" <cfif listfind("1,2,3,4,7",attributes.process_type)>style="display:none;"</cfif>>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='53995.Onaylayacak'>*</label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="validator_position_code" id="validator_position_code" value="<cfoutput>#session.ep.position_code#</cfoutput>">
							<input type="hidden" name="valid_employee_id" id="valid_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
							<input type="text" name="validator_position" id="validator_position" value="<cfoutput>#get_emp_info(session.ep.position_code,1,0)#</cfoutput>" readonly>
							<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=import_worktimes.validator_position_code&field_emp_name=import_worktimes.validator_position&fiel_id=import_worktimes.valid_employee_id','list');return false"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="is_puantaj" style="display:none">
					<label><input type="checkbox" value="1" name="is_puantaj_off" id="is_puantaj_off"><cf_get_lang dictionary_id ='53662.Puantajda Görüntülenmesin'></label>	
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" id="tdImport">
			</div>
		</cf_box_elements>
		<div class="ui-form-list-btn">
			<div class="form-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='54053.İmport Et'></cfsavecontent>
				<cf_workcube_buttons is_upd='0'insert_info='#message#' is_cancel='0' add_function='import_et()'>
			</div>
		</div>
	</cfform>
</cf_box>
<div id="tanimlar" style="display:none;">
	<div id="td2">
		<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='30106.Dosya uzantısı csv olmalı kaydedilirken karakter desteği olarak UTF-8 seçilmelidir Alan araları noktalı virgül ile ayrılmalı sayısal değerler için nokta  ayrac olarak kullanılmalıdır'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54238.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'><br/>
		&nbsp;&nbsp;- <cf_get_lang dictionary_id="59311.Ödenek Tipi">(<cf_get_lang dictionary_id="29801.Zorunlu">) : <cf_get_lang dictionary_id="41793.Yapılacak ödenek importunun tipi belirtilmelidir. E-Hesap tanımlar sayfasında  tanımlanan ödenek tipinin ID 'si yazılır."><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54228.Form üzerinden import tipi(kesinti,ödenek,vergi istisnası) seçilir.'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54201.Form üzerinden import işleminin yapılacağı şube ve ilişkili şirket seçilir Buradaki seçime göre belgedeki çalışanlara import yapılır.'><br/>
		&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='54202.Bu yüzden şubelerin çalışanları için ayrı ayrı dosya hazırlanmalıdır.'><br/>
		&nbsp;&nbsp;<cf_get_lang dictionary_id='54207.Belgede toplam'> <font color="FFF0000"><b>13</b></font> <cf_get_lang dictionary_id='54208.alan olacaktır alanlar sırasi ile;'>;<br/>
		&nbsp;&nbsp;1-<cf_get_lang dictionary_id='54209.No(Zorunlu)'> :  <cf_get_lang dictionary_id='54210.Satırların sıra nosunu belirtir.'><br/>
		&nbsp;&nbsp;2-<cf_get_lang dictionary_id='54229.Ödenek/Kesinti Tipi(Zorunlu)'> : <cf_get_lang dictionary_id='54230.Yapılacak ödenek ya da kesintinin tipi belirtilmelidir E-Hesap tanımlardan tanımlanan kesinti veya'> 
		&nbsp;&nbsp;<cf_get_lang dictionary_id='54231.ödenek tiplerini ID si yazılır.'> <br/>
		&nbsp;&nbsp;3-<cf_get_lang dictionary_id='54211.TC Kimlik No (Zorunlu)'>  : <cf_get_lang dictionary_id='54212.İmport işlemi yapılacak çalışanın TC Kimlik No su girilmelidir'><br/>
		&nbsp;&nbsp;4-<cf_get_lang dictionary_id='54213.Çalışan Ad-Soyad (Zorunlu)'> : <cf_get_lang dictionary_id='54214.İmport işlemi yapılacak çalışanın adı soyadı girilmelidir.'><br/>
		&nbsp;&nbsp;5-<cf_get_lang dictionary_id='54215.Çalışan Şube(Zorunlu)'> : <cf_get_lang dictionary_id='54216.Çalışanın bağlı olduğu şubesi girilmelidir.'><br/>
		&nbsp;&nbsp;6-<cf_get_lang dictionary_id='54217.Çalışan Pozisyon(Zorunlu)'> : <cf_get_lang dictionary_id='54218.Çalışanın pozisyonu girilmelidir.'><br/>
		&nbsp;&nbsp;7-<cf_get_lang dictionary_id='54232.Tutar (Zorunlu)'> : <cf_get_lang dictionary_id='54233.Ödenek veya kesinti tutarı girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 250.5<br/>
		&nbsp;&nbsp;8-<cf_get_lang dictionary_id='54234.Ay (Zorunlu)'> : <cf_get_lang dictionary_id='54235.Ödenek veya kesintinin uygulanacağı ay sayı olarak girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 5<br/>
		&nbsp;&nbsp;9-<cf_get_lang dictionary_id="57502.Bitiş"> <cf_get_lang dictionary_id='54234.Ay (Zorunlu)'> : <cf_get_lang dictionary_id='54235.Ödenek veya kesintinin uygulanacağı ay sayı olarak girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 5<br/>
		&nbsp;&nbsp;10-<cf_get_lang dictionary_id='54236.Yıl(Zorunlu)'> : <cf_get_lang dictionary_id='54237.Ödenek veya kesintinin uygulanacağı yıl sayı olarak girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 2012	<br />
		&nbsp;&nbsp;11-<cf_get_lang dictionary_id="41780.Ücret Kartı ID"> (<cf_get_lang dictionary_id="41775.Birden fazla ücret kartı olan çalışanların hangi ücret kartına eklenmesi isteniyorsa o ücret kartının in_out_id'si girilmelidir">.)<br>	
		&nbsp;&nbsp;12-<cf_get_lang dictionary_id='63052.Proje ID'> (<cf_get_lang dictionary_id='63053.Ödeneğin bağlı olacağı Proje ID girilmelidir.(Memur Bordrosu)'>.)<br>
		&nbsp;&nbsp;13-<cf_get_lang dictionary_id='58859.Süreç '> : <cf_get_lang dictionary_id='44142.Süreç ID girmelisiniz'><br/>	
	</div>

	<div id="td3">
		<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='30106.Dosya uzantısı csv olmalı kaydedilirken karakter desteği olarak UTF-8 seçilmelidir Alan araları noktalı virgül ile ayrılmalı sayısal değerler için nokta ayrac olarak kullanılmalıdır'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54238.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'><br/>
		&nbsp;&nbsp;- <cf_get_lang dictionary_id="54229.Ödenek/Kesinti Tipi(Zorunlu)"> : <cf_get_lang dictionary_id="41772.Yapılacak kesinti  importunun tipi belirtilmelidir. E-Hesap tanımlar sayfasında  tanımlanan kesinti tipinin ID 'si yazılır."><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54228.Form üzerinden import tipi(kesinti,ödenek,vergi istisnası) seçilir.'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54201.Form üzerinden import işleminin yapılacağı şube ve ilişkili şirket seçilir Buradaki seçime göre belgedeki çalışanlara import yapılır.'><br/>
		&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='54202.Bu yüzden şubelerin çalışanları için ayrı ayrı dosya hazırlanmalıdır.'><br/>
		&nbsp;&nbsp;<cf_get_lang dictionary_id='54207.Belgede toplam'> <font color="FFF0000"><b>12</b></font> <cf_get_lang dictionary_id='54208.alan olacaktır alanlar sırasi ile;'>;<br/>
		&nbsp;&nbsp;1-<cf_get_lang dictionary_id='54209.No(Zorunlu)'> :  <cf_get_lang dictionary_id='54210.Satırların sıra nosunu belirtir.'><br/>
		&nbsp;&nbsp;2-<cf_get_lang dictionary_id='54229.Ödenek/Kesinti Tipi(Zorunlu)'> : <cf_get_lang dictionary_id='54230.Yapılacak ödenek ya da kesintinin tipi belirtilmelidir E-Hesap tanımlardan tanımlanan kesinti veya'> 
		&nbsp;&nbsp;<cf_get_lang dictionary_id='54231.ödenek tiplerini ID si yazılır.'> <br/>
		&nbsp;&nbsp;3-<cf_get_lang dictionary_id='54211.TC Kimlik No (Zorunlu)'>  : <cf_get_lang dictionary_id='54212.İmport işlemi yapılacak çalışanın TC Kimlik No su girilmelidir'><br/>
		&nbsp;&nbsp;4-<cf_get_lang dictionary_id='54213.Çalışan Ad-Soyad (Zorunlu)'> : <cf_get_lang dictionary_id='54214.İmport işlemi yapılacak çalışanın adı soyadı girilmelidir.'><br/>
		&nbsp;&nbsp;5-<cf_get_lang dictionary_id='54215.Çalışan Şube(Zorunlu)'> : <cf_get_lang dictionary_id='54216.Çalışanın bağlı olduğu şubesi girilmelidir.'><br/>
		&nbsp;&nbsp;6-<cf_get_lang dictionary_id='54217.Çalışan Pozisyon(Zorunlu)'> : <cf_get_lang dictionary_id='54218.Çalışanın pozisyonu girilmelidir.'><br/>
		&nbsp;&nbsp;7-<cf_get_lang dictionary_id='54232.Tutar (Zorunlu)'> : <cf_get_lang dictionary_id='54233.Ödenek veya kesinti tutarı girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 250.5<br/>
		&nbsp;&nbsp;8-<cf_get_lang dictionary_id='54234.Ay (Zorunlu)'> : <cf_get_lang dictionary_id='54235.Ödenek veya kesintinin uygulanacağı ay sayı olarak girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 5<br/>
		&nbsp;&nbsp;9-<cf_get_lang dictionary_id="57502.Bitiş"> <cf_get_lang dictionary_id='54234.Ay (Zorunlu)'> : <cf_get_lang dictionary_id='54235.Ödenek veya kesintinin uygulanacağı ay sayı olarak girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 5<br/>
		&nbsp;&nbsp;10-<cf_get_lang dictionary_id='54236.Yıl(Zorunlu)'> : <cf_get_lang dictionary_id='54237.Ödenek veya kesintinin uygulanacağı yıl sayı olarak girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 2007	<br/>
		&nbsp;&nbsp;11-<cf_get_lang dictionary_id="41780.Ücret Kartı ID"> (<cf_get_lang dictionary_id="41775.Birden fazla ücret kartı olan çalışanların hangi ücret kartına eklenmesi isteniyorsa o ücret kartının in_out_id'si girilmelidir">.)<br>	
		&nbsp;&nbsp;12-<cf_get_lang dictionary_id='58859.Süreç '> : <cf_get_lang dictionary_id='44142.Süreç ID girmelisiniz'><br/>
	</div>
	<div id="td4">
		<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='30106.Dosya uzantısı csv olmalı kaydedilirken karakter desteği olarak UTF-8 seçilmelidir Alan araları noktalı virgül(;) ile ayrılmalı sayısal değerler için nokta(.) ayrac olarak kullanılmalıdır'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54238.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id="53017.Vergi istisnası">(<cf_get_lang dictionary_id="29801.Zorunlu">) : <cf_get_lang dictionary_id="41770.Yapılacak vergi istisnası importunun tipi belirtilmelidir. E-Hesap tanımlar sayfasında  tanımlanan vergi istisnası  tipinin ID 'si yazılır."><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54228.Form üzerinden import tipi(kesinti,ödenek,vergi istisnası) seçilir.'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54201.Form üzerinden import işleminin yapılacağı şube ve ilişkili şirket seçilir Buradaki seçime göre belgedeki çalışanlara import yapılır.'><br/>
		&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='54202.Bu yüzden şubelerin çalışanları için ayrı ayrı dosya hazırlanmalıdır.'><br/>
		&nbsp;&nbsp;<cf_get_lang dictionary_id='54207.Belgede toplam'> <font color="FFF0000"><b>10</b></font> <cf_get_lang dictionary_id='54208.alan olacaktır alanlar sırasi ile;'>;<br/>
		&nbsp;&nbsp;1-<cf_get_lang dictionary_id='54209.No(Zorunlu)'> :  <cf_get_lang dictionary_id='54210.Satırların sıra nosunu belirtir.'><br/>
		&nbsp;&nbsp;2-<cf_get_lang dictionary_id='54229.Ödenek/Kesinti Tipi(Zorunlu)'> : <cf_get_lang dictionary_id='54230.Yapılacak ödenek ya da kesintinin tipi belirtilmelidir E-Hesap tanımlardan tanımlanan kesinti veya'> 
		&nbsp;&nbsp;<cf_get_lang dictionary_id='54231.ödenek tiplerini ID si yazılır.'> <br/>
		&nbsp;&nbsp;3-<cf_get_lang dictionary_id='54211.TC Kimlik No (Zorunlu)'>  : <cf_get_lang dictionary_id='54212.İmport işlemi yapılacak çalışanın TC Kimlik No su girilmelidir'><br/>
		&nbsp;&nbsp;4-<cf_get_lang dictionary_id='54213.Çalışan Ad-Soyad (Zorunlu)'> : <cf_get_lang dictionary_id='54214.İmport işlemi yapılacak çalışanın adı soyadı girilmelidir.'><br/>
		&nbsp;&nbsp;5-<cf_get_lang dictionary_id='54215.Çalışan Şube(Zorunlu)'> : <cf_get_lang dictionary_id='54216.Çalışanın bağlı olduğu şubesi girilmelidir.'><br/>
		&nbsp;&nbsp;6-<cf_get_lang dictionary_id='54217.Çalışan Pozisyon(Zorunlu)'> : <cf_get_lang dictionary_id='54218.Çalışanın pozisyonu girilmelidir.'><br/>
		&nbsp;&nbsp;7-<cf_get_lang dictionary_id='54232.Tutar (Zorunlu)'> : <cf_get_lang dictionary_id='54233.Ödenek veya kesinti tutarı girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 250.5<br/>
		&nbsp;&nbsp;8-<cf_get_lang dictionary_id='54234.Ay (Zorunlu)'> : <cf_get_lang dictionary_id='54235.Ödenek veya kesintinin uygulanacağı ay sayı olarak girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 5<br/>
		&nbsp;&nbsp;9-<cf_get_lang dictionary_id='54234.Ay (Zorunlu)'> : <cf_get_lang dictionary_id='54235.Ödenek veya kesintinin uygulanacağı ay sayı olarak girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 5<br/>
		&nbsp;&nbsp;10-<cf_get_lang dictionary_id='54236.Yıl(Zorunlu)'> : <cf_get_lang dictionary_id='54237.Ödenek veya kesintinin uygulanacağı yıl sayı olarak girilmelidir.'> <cf_get_lang dictionary_id='54221.Örn'> : 2012	
	</div>
	<div id="td5">
		<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='30106.Dosya uzantısı csv olmalı kaydedilirken karakter desteği olarak UTF-8 seçilmelidir Alan araları noktalı virgül(;) ile ayrılmalı sayısal değerler için nokta(.) ayrac olarak kullanılmalıdır'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54200.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54201.Form üzerinden import işleminin yapılacağı şube ve ilişkili şirket seçilir Buradaki seçime göre belgedeki çalışanlara import yapılır.'><br/>
		&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='54202.Bu yüzden şubelerin çalışanları için ayrı ayrı dosya hazırlanmalıdır.'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54203.Form üzerinden import işleminin yapılacağı ay ve yıl değerleri girilir.'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54204.Belgede ilk 5 alan çalışan bilgilerini belirtir. 6. alan Süreci 7. alan Mesai Karşılığını belirtir. Sonraki alanlarda 1 den 31 e kadar her gün için mesai saati girilir. Olmayan günler için'> 
		&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='54205.Sıfır değeri girilmelidir.'><br/>
		&nbsp;&nbsp;-<cf_get_lang dictionary_id='54206.Son alanda ise toplam mesai saati belirtilir.'>
		&nbsp;&nbsp;<cf_get_lang dictionary_id='54207.Belgede toplam'> <font color="FFF0000"><b>39</b></font> <cf_get_lang dictionary_id='54208.alan olacaktır alanlar sırasi ile'>;<br/>
		&nbsp;&nbsp;1-<cf_get_lang dictionary_id='54209.No(Zorunlu)'> :  <cf_get_lang dictionary_id='54210.Satırların sıra nosunu belirtir.'><br/>
		&nbsp;&nbsp;2-<cf_get_lang dictionary_id='54211.TC Kimlik No (Zorunlu)'>  : <cf_get_lang dictionary_id='54212.İmport işlemi yapılacak çalışanın TC Kimlik No su girilmelidir.'><br/>
		&nbsp;&nbsp;3-<cf_get_lang dictionary_id='54213.Çalışan Ad-Soyad (Zorunlu)'> : <cf_get_lang dictionary_id='54214.İmport işlemi yapılacak çalışanın adı soyadı girilmelidir.'><br/>
		&nbsp;&nbsp;4-<cf_get_lang dictionary_id='54215.Çalışan Şube(Zorunlu)'> <cfif x_branch_req  eq 0>(<cf_get_lang dictionary_id='44685.Please enter ID'>)</cfif> : <cf_get_lang dictionary_id='54216.Çalışanın bağlı olduğu şubesi girilmelidir.'><br/>
		&nbsp;&nbsp;5-<cf_get_lang dictionary_id='54217.Çalışan Pozisyon(Zorunlu)'> : <cf_get_lang dictionary_id='54218.Çalışanın pozisyonu girilmelidir.'><br/>
		&nbsp;&nbsp;6-<cf_get_lang dictionary_id='58859.Süreç '> : <cf_get_lang dictionary_id='44142.Süreç ID girmelisiniz'><br/>
		&nbsp;&nbsp;7-<cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'> : <cf_get_lang dictionary_id='61426.Mesai Karşılığı Alanına 1 veya 2 değerleri girilmelidir; 1- Serbest Zaman , 2 - Ücrete Eklensin.'><br/>
		&nbsp;&nbsp;8-<cf_get_lang dictionary_id='54219.Mesai Saat(Zorunlu)'> : <cf_get_lang dictionary_id='54220.Birinci gün yapılan mesai.'> <cf_get_lang dictionary_id='54221.Örn'> : 3<br/>
		&nbsp;&nbsp;9-<cf_get_lang dictionary_id='54219.Mesai Saat(Zorunlu)'> : <cf_get_lang dictionary_id='54222.İkinci gün yapılan mesai.'> <cf_get_lang dictionary_id='54221.Örn'> : 5<br/>
		&nbsp;&nbsp;.<br/>
		&nbsp;&nbsp;.<br/>
		&nbsp;&nbsp;.<br/>
		&nbsp;&nbsp;38-<cf_get_lang dictionary_id='54219.Mesai Saat(Zorunlu)'> : <cf_get_lang dictionary_id='54223.otuzbirinci gün yapılan mesai(31 çekmeyen aylar için 0 girilmelidir).'> <cf_get_lang dictionary_id='54221.Örn'> : 5<br/>	
		&nbsp;&nbsp;39-<cf_get_lang dictionary_id='54224.Toplam Mesai(Zorunlu)'> : <cf_get_lang dictionary_id='54225.Ay boyunca çalışanın yaptığı toplam mesai.'> <cf_get_lang dictionary_id='54221.Örn'> : 14
		<br/><br/>
		&nbsp;&nbsp;
		<b><cf_get_lang dictionary_id='57467.Not'> :</b> <cf_get_lang dictionary_id='54226.Saatlik Fazla mesai için dakika girmek isterseniz 1:37 (1 saat 37 dakika) şeklinde giriş yapabilirsiniz'>!
	</div>

	<div id="td6">
		<cf_get_lang dictionary_id ='53850.Bu belgede olması gereken alan sayısı'>:7 <br/>
		<cf_get_lang dictionary_id='53860.Alanlar sırasıyla'>; <br/>
		1_<cf_get_lang dictionary_id ='53109.Sıra No'><br/>
		2_<cf_get_lang dictionary_id ='54211.Tc Kimlik No'> <br />
		3_<cf_get_lang dictionary_id ='57570.Ad Soyad'><br/>
		4_<cf_get_lang dictionary_id ='53718.Fazla Mesai Tutarı'>(<cf_get_lang dictionary_id='58827.dk'>) (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
		5_<cf_get_lang dictionary_id ='58543.Mesai Tipi'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)
		(0 - <cf_get_lang dictionary_id='53014.Normal Gün'>, 1 - <cf_get_lang dictionary_id='53015.Hafta Sonu'>, 2 - <cf_get_lang dictionary_id='53016.Resmi Tatil'>)<br/>
		(<cf_get_lang dictionary_id='53105.Farklı bir değer girerseniz, importunuz geçersiz olur ve hesaba giremez.'>)<br/>
		6_<cf_get_lang dictionary_id='58859.Süreç '> : <cf_get_lang dictionary_id='44142.Süreç ID girmelisiniz'><br/>
		7_<cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'> : <cf_get_lang dictionary_id='61426.Mesai Karşılığı Alanına 1 veya 2 değerleri girilmelidir; 1- Serbest Zaman , 2 - Ücrete Eklensin.'><br/><br/>
		<cf_get_lang dictionary_id ='35657.Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>.<cf_get_lang dictionary_id ='53875.Format UTF-8 olmalıdır'>.<br/>
		<cf_get_lang dictionary_id ='53889.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.<br/>
	</div>
	
	<div id="td8">
		<cf_get_lang dictionary_id ='53850.Bu belgede olması gereken alan sayısı'>:9 <br/>
		<cf_get_lang dictionary_id='53860.Alanlar sırasıyla'>; <br/>
		1_<cf_get_lang dictionary_id ='53109.Sıra No'><br/>
		2_<cf_get_lang dictionary_id ='54211.Tc Kimlik No'> <br />
		3_<cf_get_lang dictionary_id ='57570.Ad Soyad'><br/>
		4_<cf_get_lang dictionary_id='53014.Normal Gün'>(<cf_get_lang dictionary_id='57491.Saat'>)<br/>
		5_<cf_get_lang dictionary_id='53015.Hafta Sonu'>(<cf_get_lang dictionary_id='57491.Saat'>)<br/>
		6_<cf_get_lang dictionary_id='53016.Resmi Tatil'>(<cf_get_lang dictionary_id='57491.Saat'>)<br/>
		7_<cf_get_lang dictionary_id='54251.Gece Çalışması'>(<cf_get_lang dictionary_id='57491.Saat'>)<br/>
		(<cf_get_lang dictionary_id='53105.Farklı bir değer girerseniz, importunuz geçersiz olur ve hesaba giremez.'>)<br/><br/>
		8_<cf_get_lang dictionary_id='58859.Süreç '> : <cf_get_lang dictionary_id='44142.Süreç ID girmelisiniz'><br/>
		9_<cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'> : <cf_get_lang dictionary_id='61426.Mesai Karşılığı Alanına 1 veya 2 değerleri girilmelidir; 1- Serbest Zaman , 2 - Ücrete Eklensin.'><br/><br/>
		(<cf_get_lang dictionary_id='53105.Farklı bir değer girerseniz, importunuz geçersiz olur ve hesaba giremez.'>)<br/><br/>
		<cf_get_lang dictionary_id ='35657.NOT:Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>.<cf_get_lang dictionary_id ='53875.Format UTF-8 olmalıdır'>.<br/>
		<cf_get_lang dictionary_id ='53889.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.<br/>
	</div>

	<div id="td7">
		<cf_get_lang dictionary_id ='53850.Bu belgede olması gereken alan sayısı'>:11 <br/>
		<cf_get_lang dictionary_id='53860.Alanlar sırasıyla'>; <br/>
		1_<cf_get_lang dictionary_id ='53109.Sıra No'><br/>
		2_<cf_get_lang dictionary_id ='54211.Tc Kimlik No'> <br />
		3_<cf_get_lang dictionary_id ='57570.Ad Soyad'><br/>
		4_<cf_get_lang dictionary_id ='53900.İzin Başlama Tarihi'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)(gg.aa.yyyy)<br/>
		5_<cf_get_lang dictionary_id ='54247.İzin Başlama Saati'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)(ss:dd)<br/>
		6_<cf_get_lang dictionary_id ='53932.İzin Bitiş Tarihi'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)(gg.aa.yyyy)<br/>
		7_<cf_get_lang dictionary_id ='54248.İzin Bitiş Saati'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)(ss:dd)<br/>
		8_<cf_get_lang dictionary_id ='53817.İşe Başlama Tarihi'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)(gg.aa.yyyy)<br/>
		9_<cf_get_lang dictionary_id ='54249.İşe Başlama Saati'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)(ss:dd)<br/>
		10_<cf_get_lang dictionary_id ='53818.İzin Kategori Id'> (<cf_get_lang dictionary_id='53820.id girilmelidir'>)<br/>
		11_<cf_get_lang dictionary_id='58575.İzin'><cf_get_lang dictionary_id='43130.Alt Ketgori'><cf_get_lang dictionary_id='58527.ID'> (<cf_get_lang dictionary_id='53820.id girilmelidir'>)<br/>
		12_<cf_get_lang dictionary_id ='57453.Şube'> (<cf_get_lang dictionary_id='53820.id girilmelidir'>)<br/>
		<br/>
		<cf_get_lang dictionary_id ='35657.NOT:Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>.<cf_get_lang dictionary_id ='53875.Format UTF-8 olmalıdır'>.<br/>
		<cf_get_lang dictionary_id ='53889.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.<br/>
	</div>
	
	<div id="td9">
		<cf_get_lang dictionary_id ='53850.Bu belgede olması gereken alan sayısı'>:7 <br/>
		<cf_get_lang dictionary_id='53860.Alanlar sırasıyla'>; <br/>
		1_<cf_get_lang dictionary_id ='53109.Sıra No'><br/>
		2_<cf_get_lang dictionary_id ='54211.Tc Kimlik No'> (<cf_get_lang dictionary_id='29801.Zorunlu'>). <br/>
		3_<cf_get_lang dictionary_id ='57570.Ad Soyad'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id="54214.İmport işlemi yapılacak çalışanın adı soyadı girilmelidir"> <br />
		4_<cf_get_lang dictionary_id ="41769.OKES Kesinti Yüzdesi"> (<cf_get_lang dictionary_id='29801.Zorunlu'>): % <cf_get_lang dictionary_id="41768.kaç kesinti yapılacağına dair sayı girilmelidir."><br/>
		5_<cf_get_lang dictionary_id ="31579.Başlangıç Ay"> (<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id="41761.OKES in uygulanacağı ilk ay sayı olarak girilmelidir."><br/>
		6_<cf_get_lang dictionary_id ="39990.Bitiş Ay"> (<cf_get_lang dictionary_id='29801.Zorunlu'>) <cf_get_lang dictionary_id="41751.OKES in uygulanacağı son ay sayı olarak girilmelidir."><br/>
		7_<cf_get_lang dictionary_id ="58455.Yıl">(<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id="41749.OKES in uygulanacağı yıl sayı olarak girilmelidir."><br/>
		<br/>
		<cf_get_lang dictionary_id ='35657.NOT:Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>.<cf_get_lang dictionary_id ='53875.Format UTF-8 olmalıdır'>.<br/>
		<cf_get_lang dictionary_id ='53889.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.<br/>
	</div>
</div>	
<script type="text/javascript">
function import_et()
{
	<cfif x_branch_req eq 1>
		if(document.getElementById('branch_id').value == "" || document.getElementById('related_company').value == "")
		{
			alert("<cf_get_lang dictionary_id ='54051.Lütfen Şube veya İlgili Şirket Seçiniz'> !");
			return false;
		}
	</cfif>
	if(document.getElementById('uploaded_file').value == "")
	{
		alert("<cf_get_lang dictionary_id ='54052.Lütfen İmport Edilecek Belge Giriniz'> !");
		return false;
	}
	if(document.getElementById('process_type').value == 1)
	{
		alert("<cf_get_lang dictionary_id='36740.İşlem Tipi Girmelisiniz'> !");
		return false;
	}
	
	//windowopen('','small','cc_paym');
	if (list_find("2,3,4",document.getElementById('process_type').value))
		import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_import_payments</cfoutput>';
	else if (document.getElementById('process_type').value == 5)
		import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_import_worktimes</cfoutput>';
	else if (document.getElementById('process_type').value == 6)
		import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_add_ext_worktime_import_2</cfoutput>';
	else if (document.getElementById('process_type').value == 8)
		import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_add_ext_worktime_import_3</cfoutput>';
	else if (document.getElementById('process_type').value == 9)
		import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_add_okes_import</cfoutput>';
	else if (document.getElementById('process_type').value == 7)
	{
		import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_add_offtime_import</cfoutput>';}
	return true;
}
function formatGoster(type,text)
{
	document.getElementById('tdImport').innerHTML = "";
	document.getElementById('tdImport').innerHTML = "<strong>" + text + ":</strong><br /><br />";

	if (type == "")
		document.getElementById('tdImport').innerHTML = "";
	else if (type == 2)
		document.getElementById('tdImport').innerHTML += document.getElementById('td2').innerHTML;
	else if (type == 3)
		document.getElementById('tdImport').innerHTML += document.getElementById('td3').innerHTML;
	else if (type == 4)
		document.getElementById('tdImport').innerHTML += document.getElementById('td4').innerHTML;
	else if (type == 5)
		document.getElementById('tdImport').innerHTML += document.getElementById('td5').innerHTML;
	else if (type == 6)
		document.getElementById('tdImport').innerHTML += document.getElementById('td6').innerHTML;
	else if (type == 8)
		document.getElementById('tdImport').innerHTML += document.getElementById('td8').innerHTML;
	else if (type == 7)
		document.getElementById('tdImport').innerHTML += document.getElementById('td7').innerHTML;
	else if (type == 9)
		document.getElementById('tdImport').innerHTML += document.getElementById('td9').innerHTML;
}
function type_gizle()
{
	if (document.getElementById('process_type').value == 5)
		is_mesai_type.style.display = "";
	else
		is_mesai_type.style.display = "none";
		
	if (document.getElementById('process_type').value == 5 || document.getElementById('process_type').value == 6 || document.getElementById('process_type').value == 8)
	{
		is_sal_show.style.display = "";
		is_puantaj.style.display = "";
		is_process.style.display = "";
	}
	
	else
		{ 
			is_process.style.display = "none";
			is_sal_show.style.display = "none";
		}
		
	if (document.getElementById('process_type').value == 6 || document.getElementById('process_type').value == 7)
	{
		/* is_related_company.style.display = "none";
		is_branch_id.style.display = "none"; */
		is_file_format.style.display = "";
	}
	else
	{
		/* is_related_company.style.display = "";
		is_branch_id.style.display = ""; */
		is_file_format.style.display = "none";
	}
	if (document.getElementById('process_type').value == 7)
	{
		is_process.style.display = "";
		is_valid.style.display = "";
		is_validator_position.style.display = "";
		is_puantaj.style.display = "";
	}
	else if(document.getElementById('process_type').value == 2 || document.getElementById('process_type').value == 3){
		is_process.style.display = "";
	}
	else
	{
		is_process.style.display = "none";
		is_valid.style.display = "none";
		is_validator_position.style.display = "none";
	}
		
}
</script> 