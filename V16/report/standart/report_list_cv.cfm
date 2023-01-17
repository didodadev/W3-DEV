<!--- EÖ Cv Report 07102010 --->
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.startdate" default="1/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.finishdate" default="#day(now())#/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.is_excel" default="">

<cfif len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "">
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate="">
</cfif>

<cfif not isdefined("attributes.keyword")>
	<cfset filtered = 0>
<cfelse>
	<cfset filtered = 1>
</cfif>

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword2" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.emp_app_type" default="">
<cfparam name="attributes.cv_status" default="">
<cfquery name="get_cv_status_query" datasource="#dsn#">
	SELECT 
		STATUS_ID,STATUS,ICON_NAME
	FROM 
		SETUP_CV_STATUS
	ORDER BY
		STATUS_ID
</cfquery>
<cfquery name="get_cv_unit" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_CV_UNIT
	WHERE IS_ACTIVE =1
</cfquery>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='29767.CV'></cfsavecontent>
<cfform name="theForm" method="post" action="#request.self#?fuseaction=report.report_list_cv">
	<cf_report_list_search title="#head#">
        <cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
							<div class="col col-4 col-md-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255">
											</div>	
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id="58726.Soyad"></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<cfinput type="text" name="keyword2" value="#attributes.keyword2#" maxlength="255">
											</div>	
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<div class="col col-6 col-md-12 col-xs-12">
												<label class="col col-12 col-md-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id="58053.başlangıç tarihi">*</label>
												<div class="input-group">		
													<cfsavecontent variable="alert"><cf_get_lang dictionary_id='57276.Başlangıç Tarihi Hatalı'></cfsavecontent>
													<cfif len(attributes.startdate) gt 5>
														<cfinput type="text" name="startdate" maxlength="10" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#alert#">
													<cfelse>
														<cfinput type="text" name="startdate" maxlength="10" value="" validate="#validate_style#" message="#alert#">
													</cfif>
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="startdate">
													</span>
												</div>		
											</div>
											<div class="col col-6 col-md-12 col-xs-12">
												<label class="col col-12 col-md-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id="57700.bitiş tarihi">*</label>
												<div class="input-group">		
													<cfsavecontent variable="alert"><cf_get_lang dictionary_id='58767.Bitiş Tarihi Hatalı'></cfsavecontent>
													<cfif len(attributes.finishdate) gt 5>
														<cfinput type="text" name="finishdate" style="width:65px;" maxlength="10" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" message="#alert#">
													<cfelse>
														<cfinput type="text" name="finishdate" style="width:65px;" maxlength="10" value="" validate="#validate_style#" message="#alert#">
													</cfif>
													<span class="input-group-addon">	
														<cf_wrk_date_image date_field="finishdate">
													</span>	
												</div>		
											</div>
										</div>
										<div class="form-group">	
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='33134.Geçerlilik'></label>
											<div class="col col-12">
												<select name="status">
													<option value="" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id="57708.Tümü">	
													<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id="57493.Aktif">
													<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id="57494.Pasif">		                        
												</select>
											</div>		
										</div>

									</div>
								</div>
							</div>
							<div class="col col-4 col-md-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">	
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='33436.İş Başvuruları'></label>	
											<div class="col col-12">
												<select name="emp_app_type">
													<option value="" <cfif attributes.emp_app_type eq 2>selected</cfif>><cf_get_lang dictionary_id="57708.Tümü">	
													<option value="1" <cfif attributes.emp_app_type eq 1>selected</cfif>><cf_get_lang dictionary_id="39199.İK Arşivi">
													<option value="0" <cfif attributes.emp_app_type eq 0>selected</cfif>><cf_get_lang dictionary_id="39200.İnternet Başvuruları">		                        
												</select>
											</div>
										</div>
										<div class="form-group">	
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>	
											<div class="col col-12">
												<select name="cv_status">
													<option value=""><cf_get_lang dictionary_id="57708.Tümü"></option>
													<cfoutput query="get_cv_status_query">
														<option value="#status_id#" <cfif status_id eq attributes.cv_status>selected</cfif>>#STATUS#</option>
													</cfoutput>
												</select>		
											</div>					
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<cfinput type="hidden" name="form_submited" id="is_form_submited" value="1">
							<cf_wrk_report_search_button button_type='1' is_excel="0" search_function="control()"> 
							
                        </div>
                    </div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<!---excel kodları başlangıç--->

<!---excel kodları bitiş--->

<!---filtrele--->

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("form_submited")>
	<cfquery name="get_cv" datasource="#dsn#">
		SELECT 
			AP.*,
			EI.BIRTH_PLACE,
			EI.BIRTH_DATE,
			EI.CITY ,
			EI.MARRIED,
			EI.SERIES,
			EI.BLOOD_TYPE,
			EI.MOTHER,
			EI.MOTHER_JOB,
			EI.FATHER_JOB,
			EI.LAST_SURNAME,
			EI.FATHER,
			EI.COUNTY,
			EI.RELIGION,
			EI.FAMILY,
			EI.WARD,
			EI.VILLAGE,
			EI.CUE,
			EI.GIVEN_PLACE,
			EI.BINDING,
			EI.RECORD_NUMBER,
			EI.GIVEN_REASON,
			EI.GIVEN_DATE
		FROM
			EMPLOYEES_APP AP,
			EMPLOYEES_IDENTY EI
		WHERE
			AP.EMPAPP_ID IS NOT NULL 
			AND AP.EMPAPP_ID = EI.EMPAPP_ID
			<cfif len(attributes.keyword)>
			 AND (AP.NAME LIKE '#attributes.keyword#%')
			</cfif>
			<cfif len(attributes.keyword2)>
			 AND (AP.SURNAME LIKE '#attributes.keyword2#%')
			</cfif>
			<cfif len(attributes.cv_status)>
			AND AP.APP_COLOR_STATUS = #attributes.cv_status#
			</cfif>
			<cfif len(attributes.status)>
			 AND AP.APP_STATUS=#attributes.status#
			</cfif>
			<cfif len(attributes.emp_app_type) and attributes.emp_app_type eq 1>
			 AND AP.RECORD_APP_IP IS NULL
			 AND AP.RECORD_IP IS NOT NULL
			<cfelseif len(attributes.emp_app_type) and attributes.emp_app_type eq 0>
			 AND AP.RECORD_IP IS NULL
			 AND AP.RECORD_APP_IP IS NOT NULL
			</cfif>
			<cfif isDefined('attributes.startdate') and len(attributes.startdate) and isdate(attributes.startdate)>
	    	AND AP.RECORD_DATE >= #attributes.startdate#
		    </cfif>
		    <cfif isDefined('attributes.finishdate') and len(attributes.finishdate) and isdate(attributes.finishdate)>
		    AND AP.RECORD_DATE < #DATEADD('d',1,attributes.finishdate)#
		    </cfif>
			ORDER BY 
			NAME
	</cfquery>
	<cfif get_cv.recordcount>
		<cfset attributes.totalrecords = #get_cv.recordcount#>
	</cfif>
</cfif>

	<cfif attributes.is_excel eq 1>
        <cfset type_ = 1>
        <cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-8">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <cfelse>
        <cfset type_ = 0>
    </cfif>
<cfif isdefined("form_submited")>
<cf_report_list>
	<thead>
		<tr>
			<!--- genel bilgiler --->
			<th width="50"><cf_get_lang dictionary_id="57487.No"></th>
			<th><cf_get_lang dictionary_id="58025.TC Kimlik No"></th>
			<th><cf_get_lang dictionary_id="57637.Seri No"></th>
			<th><cf_get_lang dictionary_id="57570.Ad Soyad"></th>
			<th><cf_get_lang dictionary_id="39204.Kimlik Kartı Numarası"></th>
			<th><cf_get_lang dictionary_id="57709.Okul"> / <cf_get_lang dictionary_id="57995.Bölüm"></th>
			<th><cf_get_lang dictionary_id="39398.Yaş"></th>
			<th><cf_get_lang dictionary_id="39704.Ev Tel"></th>
			<th><cf_get_lang dictionary_id="58813.Cep Tel"></th>
			<th><cf_get_lang dictionary_id="58813.Cep Tel">2</th>
			<th><cf_get_lang dictionary_id="39205.Direkt Tel"></th>
			<th><cf_get_lang dictionary_id="39209.Dahili Tel"></th>
			<th><cf_get_lang dictionary_id="39210.Email"></th>
			<th><cf_get_lang dictionary_id="39211.Ev Adresi"></th>
			<th><cf_get_lang dictionary_id="57472.Postakodu"></th>
			<th><cf_get_lang dictionary_id="58638.İlçe"></th>
			<th><cf_get_lang dictionary_id="57971.Şehir"></th>
			<th><cf_get_lang dictionary_id="58219.Ülke"></th>
			<th><cf_get_lang dictionary_id="39212.Ev Mülkiyeti"></th>
			<th><cf_get_lang dictionary_id="58762.Vergi Dairesi"></th>
			<th><cf_get_lang dictionary_id="57752.Vergi No"></th>
			<th><cf_get_lang dictionary_id="58727.Doğum Tarihi"></th>
			<th><cf_get_lang dictionary_id="57790.Doğum Yeri"></th>
			<th><cf_get_lang dictionary_id="39213.Uyruğu"></th>
			<th><cf_get_lang dictionary_id="39214.Kimlik Kart Tipi"></th>
			<th><cf_get_lang dictionary_id="39219.Kimlik Kart No"></th>
			<th><cf_get_lang dictionary_id="39220.Nüfusa Kayıtlı Olduğu İl"></th>
			<!--- kimlik Detay --->
			<th><cf_get_lang dictionary_id="58441.Kan Grubu"></th>
			<th><cf_get_lang dictionary_id="58033.Baba Adı"></th>
			<th><cf_get_lang dictionary_id="39221.Baba İş"></th>
			<th><cf_get_lang dictionary_id="58440.Ana Adı"></th>
			<th><cf_get_lang dictionary_id="39222.Anne İş"></th>
			<th><cf_get_lang dictionary_id="39226.Önceki Soyadı"></th>
			<th><cf_get_lang dictionary_id="39227.Dini"></th>
			<th><cf_get_lang dictionary_id="39233.Nüfusa Kayıtlı Olduğu İlçe"></th>
			<th><cf_get_lang dictionary_id="39236.Cilt No"></th>
			<th><cf_get_lang dictionary_id="58735.Mahalle"></th>
			<th><cf_get_lang dictionary_id="55656.Aile Sıra No"></th>
			<th><cf_get_lang dictionary_id="55645.Köy"></th>
			<th><cf_get_lang dictionary_id="55657.Sıra No"></th>
			<th><cf_get_lang dictionary_id="60696.Cüzdanın verildiği Yer"></th>
			<th><cf_get_lang dictionary_id="55658.Kayıt No"></th>
			<th><cf_get_lang dictionary_id="55648.Veriliş Nedeni"></th>
			<th><cf_get_lang dictionary_id="55659.Veriliş Tarihi"></th>
			
			<!--- Kişisel bilgiler --->
			<th><cf_get_lang dictionary_id="57764.Cinsiyet"></th>
			<th><cf_get_lang dictionary_id="46539.Medeni Durum"></th>
			<th><cf_get_lang dictionary_id="56136.Eşinin Adı"></th>
			<th><cf_get_lang dictionary_id="55618.Eşinin Çalıştığı Şirket"></th>
			<th><cf_get_lang dictionary_id="55633.Eşinin Pozisyonu"></th>
			<th><cf_get_lang dictionary_id="56137.Çocuk Sayısı"></th>
			<th><cf_get_lang dictionary_id="56138.Sigara"></th>
			<th><cf_get_lang dictionary_id="56139.Şehit Yakını mısınız"></th>
			<th><cf_get_lang dictionary_id="55614.Engelli"></th>
			<th><cf_get_lang dictionary_id="55136.Psikoteknik"></th>
			<th><cf_get_lang dictionary_id="55432.Göçmen"></th>
			<th><cf_get_lang dictionary_id="43320.Tutukluluk ve Mahkumiyet"></th>
			<th><cf_get_lang dictionary_id="55629.Ehliyet Tip / Yıl"> </th>
			<th><cf_get_lang dictionary_id="55630.Ehliyet No"></th>
			<th><cf_get_lang dictionary_id="60805.Aktif Araç Kullanım Süresi"></th>
			<th><cf_get_lang dictionary_id="56141.Kovuşturma"></th>
			<th><cf_get_lang dictionary_id="55659.Hastalık veya Bedensel Engel Var mı"></th>
			<th><cf_get_lang dictionary_id="46629.Hastalık"> <cf_get_lang dictionary_id="57998.Veya"> <cf_get_lang dictionary_id='35234.Fiziksel Engel'></th>
			<th><cf_get_lang dictionary_id="55619.Askerlik"></th>
			<!--- Eğitim --->
			<th><cf_get_lang dictionary_id="55337.Eğitim Seviyesi"></th>
			<cfloop from="1" to="4" index="ed">
				<th><cf_get_lang dictionary_id="56481.Okul Türü"></th>
				<th><cf_get_lang dictionary_id="56482.Okul Adı"></th>
				<th><cf_get_lang dictionary_id="35159.Başlama yılı"></th>
				<th><cf_get_lang dictionary_id="56484.Bitiş Yılı"></th>
				<th><cf_get_lang dictionary_id="56153.Not Ortalaması"></th>
				<th><cf_get_lang dictionary_id="57995.Bölüm"></th>
			</cfloop>
			<!--- Dil --->						
			<th><cf_get_lang dictionary_id="58996.Dil"></th>
			<th><cf_get_lang dictionary_id="56158.Konuşma"></th>
			<th><cf_get_lang dictionary_id="56159.Anlama"></th>
			<th><cf_get_lang dictionary_id="56160.Yazma"></th>
			<th><cf_get_lang dictionary_id="56161.Öğrenildiği Yer"></th>
			
			<th><cf_get_lang dictionary_id="58996.Dil"> 2</th>
			<th><cf_get_lang dictionary_id="56158.Konuşma"> 2</th>
			<th><cf_get_lang dictionary_id="56159.Anlama"> 2</th>
			<th><cf_get_lang dictionary_id="56160.Yazma"> 2</th>
			<th><cf_get_lang dictionary_id="56161.Öğrenildiği Yer"> 2</th>
			
			<th><cf_get_lang dictionary_id="58996.Dil"> 3</th>
			<th><cf_get_lang dictionary_id="56158.Konuşma"> 3</th>
			<th><cf_get_lang dictionary_id="56159.Anlama"> 3</th>
			<th><cf_get_lang dictionary_id="56160.Yazma"> 3</th>
			<th><cf_get_lang dictionary_id="56161.Öğrenildiği Yer"> 3</th>
			<cfloop from="1" to="3" index="co">
				<th><cf_get_lang dictionary_id="60806.Kurs Eğitim Konusu"></th>
				<th><cf_get_lang dictionary_id="37611.Eğitim Veren Kurum"></th>
				<th><cf_get_lang dictionary_id="57629.Açıklama"></th>
				<th><cf_get_lang dictionary_id="58455.yıl"></th>
				<th><cf_get_lang dictionary_id="29513.Süre"></th>
			</cfloop>

			<th><cf_get_lang dictionary_id="55957.Bilgisayar Bilgisi"></th>
			<th><cf_get_lang dictionary_id="38610.Paket Program Bilgisi"></th>
			<th><cf_get_lang dictionary_id="37597.Ofis Araçları Bilgisi"></th>
			
			
			<!--- İş Tecrübrsi --->
			<cfloop from="1" to="3" index="ex">
				<th><cf_get_lang dictionary_id="56485.Çalışılan yer"></th>
				<th><cf_get_lang dictionary_id="58497.Pozisyon"></th>
				<th><cf_get_lang dictionary_id="57655.Başlama Yarihi"></th>
				<th><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></th>
			</cfloop>
			<!--- Referans Bilgileri --->
				<th><cf_get_lang dictionary_id="37595.Grup şirketinde çalışan yakınınızın ismi"></th>
				<th><cf_get_lang dictionary_id="60807.Şirketi"></th>
			<cfloop from="1" to="3" index="r">
				<th><cf_get_lang dictionary_id="55240.Referans Tipi"> <cfoutput>#r#</cfoutput></th>
				<th><cf_get_lang dictionary_id="57570.Ad Soyad"> <cfoutput>#r#</cfoutput></th>
				<th><cf_get_lang dictionary_id="57574.Şirket"> <cfoutput>#r#</cfoutput></th>
				<th><cf_get_lang dictionary_id="29429.Tel. Kodu"> <cfoutput>#r#</cfoutput></th>
				<th><cf_get_lang dictionary_id="57499.Telefon"> <cfoutput>#r#</cfoutput></th>
				<th><cf_get_lang dictionary_id="58497.Pozisyon"> <cfoutput>#r#</cfoutput></th>
				<th><cf_get_lang dictionary_id="39210.Email"> <cfoutput>#r#</cfoutput></th>
			</cfloop>
			<!--- özel ilgi alanları --->
			<th><cf_get_lang dictionary_id="56168.Özel İlgi Alanları"></th>
			<th><cf_get_lang dictionary_id="56169.Üye Olunan Klüp ve Dernekler"></th>
			
			<!--- Aile bilgileri --->
			<cfloop from="1" to="3" index="f">
				<th><cf_get_lang dictionary_id="57570.Ad Soyad"></th>
				<th><cf_get_lang dictionary_id="56171.Yakınlık Derecesi"></th>
				<th><cf_get_lang dictionary_id="58727.Doğum Tarihi"></th>
				<th><cf_get_lang dictionary_id="57790.Doğum Yeri"></th>
				<th><cf_get_lang dictionary_id="57419.Eğitim"></th>
				<th><cf_get_lang dictionary_id="55494.Meslek"></th>
				<th><cf_get_lang dictionary_id="57574.Şirket"></th>
				<th><cf_get_lang dictionary_id="58497.Pozisyon"></th>
			</cfloop>
				<!---Çalışılmak istenen Birimler 
			<cfloop query="get_cv_unit">
				<th>Çalışılmak İstenen Birimler</th>
				<th>Öncelik</th>
			</cfloop>--->
			<!--- Çalışmak İstediği Şube --->
			<th><cf_get_lang dictionary_id="56519.Çalışmak İstediği Şube"></th>
			<!--- Ek Bilgiler --->
			<th><cf_get_lang dictionary_id="55329.Çalışmak İstediği Yer"></th>
			<th><cf_get_lang dictionary_id="55328.Seyahat Edebilirmisiniz"> ?</th>
			<th><cf_get_lang dictionary_id="56489.İstenilen ücret"></th>
			<th><cf_get_lang dictionary_id="58053.Başlayabileceği Tarih"></th>
			<th><cf_get_lang dictionary_id="55326.Eklemek İstedikleriniz"></th>
			<th><cf_get_lang dictionary_id="55785.Mulakat Görüşü"></th>							
		</tr>
	</thead>
	<body>	
		<cfif get_cv.recordcount>
			<cfset app_color_status_list =''>
			<cfset ilce_id="">
			<cfset ulke_id="">
			<cfset sehir_id="">
			<cfset uyrugu_id="">
			<cfset kimlik_kart_tip_id="">
			<cfset heliyet_tip_id="">
			<cfset edu_level_id="">
			<cfset emp_app_id="">
			<cfset money_type_="">
			<cfoutput query="get_cv" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(app_color_status) and (not listfind(app_color_status_list,app_color_status))>
					<cfset app_color_status_list = listappend(app_color_status_list,get_cv.app_color_status,',')>
				</cfif>
				<cfif len(homecounty) and (not listfind(ilce_id,homecounty))>
					<cfset ilce_id = listappend(ilce_id,homecounty)>
				</cfif>
				<cfif len(homecountry) and (not listfind(ulke_id,homecountry))>
					<cfset ulke_id = listappend(ulke_id,homecountry)>
				</cfif>
				<cfif len(homecity) and (not listfind(sehir_id,homecity))>
					<cfset sehir_id = listappend(sehir_id,homecity)>
				</cfif>
				<cfif len(nationality) and (not listfind(uyrugu_id,nationality))>
					<cfset uyrugu_id = listappend(uyrugu_id,nationality)>
				</cfif>
				<cfif len(identycard_cat) and (not listfind(kimlik_kart_tip_id,identycard_cat))>
					<cfset kimlik_kart_tip_id = listappend(kimlik_kart_tip_id,identycard_cat)>
				</cfif>
				<cfif len(licencecat_id) and (not listfind(heliyet_tip_id,licencecat_id))>
					<cfset heliyet_tip_id = listappend(heliyet_tip_id,licencecat_id)>
				</cfif>
				<cfif len(training_level) and (not listfind(edu_level_id,training_level))>
					<cfset edu_level_id = listappend(edu_level_id,training_level)>
				</cfif>
				<cfif len(training_level) and (not listfind(edu_level_id,training_level))>
					<cfset edu_level_id = listappend(edu_level_id,training_level)>
				</cfif>
				<cfif len(empapp_id) and (not listfind(emp_app_id,empapp_id))>
					<cfset emp_app_id = listappend(emp_app_id,empapp_id)>
				</cfif>
				<cfif len(expected_money_type) and (not listfind(money_type_,expected_money_type))>
					<cfset money_type_ = listappend(money_type_,expected_money_type)>
				</cfif>
			</cfoutput>

			<cfif len(money_type_)>
				<cfquery name="GET_MONEY" datasource="#dsn#">
					SELECT MONEY, MONEY_ID FROM SETUP_MONEY	 WHERE MONEY IN ('#money_type_#') AND PERIOD_ID = #SESSION.EP.PERIOD_ID# ORDER BY MONEY_ID
				</cfquery>
				<cfset money_type_ = listsort(valuelist(GET_MONEY.MONEY_ID,','),"numeric","ASC",',')>
			</cfif>
			<cfif len(edu_level_id)>
				<cfquery name="get_edu_level" datasource="#DSN#">
					SELECT EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID IN (#edu_level_id#) ORDER BY EDU_LEVEL_ID
				</cfquery>
				<cfset edu_level_id = listsort(valuelist(get_edu_level.EDU_LEVEL_ID,','),"numeric","ASC",',')>								
			</cfif>
			<cfif len(heliyet_tip_id)>
				<cfquery name="get_driver_lis_type" datasource="#dsn#">
					SELECT LICENCECAT_ID, LICENCECAT FROM SETUP_DRIVERLICENCE WHERE LICENCECAT_ID IN (#heliyet_tip_id#) ORDER BY LICENCECAT_ID
				</cfquery>
				<cfset heliyet_tip_id = listsort(valuelist(get_driver_lis_type.LICENCECAT_ID,','),"numeric","ASC",',')>	
			</cfif>
			<cfif len(kimlik_kart_tip_id)>
				<cfquery name="GET_ID_CARD_CATS" datasource="#dsn#">
					SELECT IDENTYCAT_ID,IDENTYCAT FROM SETUP_IDENTYCARD WHERE IDENTYCAT_ID IN (#kimlik_kart_tip_id#) ORDER BY IDENTYCAT_ID
				</cfquery>
				<cfset kimlik_kart_tip_id = listsort(valuelist(GET_ID_CARD_CATS.IDENTYCAT_ID,','),"numeric","ASC",',')>						
			</cfif>
			<cfif len(uyrugu_id)>
				<cfquery name="get_uyrugu" datasource="#dsn#">
					SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#uyrugu_id#) ORDER BY COUNTRY_ID
				</cfquery>
				<cfset uyrugu_id = listsort(valuelist(get_uyrugu.COUNTRY_ID,','),"numeric","ASC",',')>
			</cfif>
			<cfif len(sehir_id)>
				<cfquery name="get_city" datasource="#dsn#">
					SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID FROM SETUP_CITY WHERE CITY_ID IN (#sehir_id#) ORDER BY CITY_ID
				</cfquery>
				<cfset sehir_id = listsort(valuelist(get_city.city_id,','),"numeric","ASC",',')>							
			</cfif>
			<cfif len(ulke_id)>
				<cfquery name="get_country" datasource="#dsn#">
					SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#ulke_id#) ORDER BY COUNTRY_ID
				</cfquery>
				<cfset ulke_id = listsort(valuelist(get_country.COUNTRY_ID,','),"numeric","ASC",',')>
			</cfif>
			<cfif len(ilce_id)>
				<cfquery name="GET_COUNTY" datasource="#DSN#">
					SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#ilce_id#) ORDER BY COUNTY_ID
				</cfquery>
				<cfset ilce_id = listsort(valuelist(GET_COUNTY.COUNTY_ID,','),"numeric","ASC",',')>
			</cfif>	
			<cfif listlen(app_color_status_list)>
				<cfquery name="get_cv_status" datasource="#dsn#">
					SELECT 
						STATUS_ID,
						STATUS,
						ICON_NAME
					FROM 
						SETUP_CV_STATUS
					WHERE 
						STATUS_ID IN (#app_color_status_list#)
					ORDER BY 
						STATUS_ID
				</cfquery>
				<cfset app_color_status_list = listsort(valuelist(get_cv_status.status_id,','),"numeric","ASC",',')>
			</cfif>
		</cfif>
		<cfif get_cv.recordcount>
		<cfoutput query="get_cv" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<tr>
			<td>#currentrow#</td>
			<td><cf_duxi name='identity_no' class="tableyazi" type="label" value="#tc_identy_no#" gdpr="2"></td>
			<td><cfif len(series)>#series#</cfif></td>
			<td>#NAME# #SURNAME#</td>
			<td><cf_duxi name='identitycard_no' class="tableyazi" type="label" value="#IDENTYCARD_NO#" gdpr="2"></td>
			<td>
				<cfquery name="get_app_edu_info" datasource="#dsn#" maxrows="1">
					SELECT EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EDU_START DESC
				</cfquery>
				<cfif get_app_edu_info.recordcount> #get_app_edu_info.edu_name# / #get_app_edu_info.edu_part_name#</cfif>
			</td>							
			<td>
			<cfquery name="get_birth_date" datasource="#dsn#">
				SELECT BIRTH_DATE FROM EMPLOYEES_IDENTY WHERE EMPAPP_ID IS NOT NULL AND EMPAPP_ID = #empapp_id# 
			</cfquery>
			<cfif get_birth_date.recordcount and len(get_birth_date.birth_date)>
				<cfset YAS = datediff("yyyy",get_birth_date.birth_date,now())>
				<cfif YAS neq 0>
					#YAS#
				</cfif>	
			</cfif>	
			</td>
			<td><cfif len(hometelcode) and len(hometel)><cf_duxi name='home_tel_code' class="tableyazi" type="label" value="( #hometelcode# )" gdpr="1"><cf_duxi name='home_tel' class="tableyazi" type="label" value="#hometel#" gdpr="1"></cfif></td>
			<td><cfif (len(mobilcode) and len(mobil)) and (session.ep.our_company_info.sms eq 1)><cf_duxi name='mobilcode' class="tableyazi" type="label" value="( #mobilcode# )" gdpr="1"><cf_duxi name='mobil' class="tableyazi" type="label" value="#mobil#" gdpr="1"></cfif></td>
			<td><cfif len(mobilcode2) and len(mobil2) ><cf_duxi name='mobilcode2' class="tableyazi" type="label" value="( #mobilcode2# )" gdpr="1"><cf_duxi name='mobil2' class="tableyazi" type="label" value="#mobil2#" gdpr="1"></cfif></td>
			<td><cfif len(worktelcode)><cf_duxi name='worktelcode' class="tableyazi" type="label" value="( #worktelcode# )" gdpr="1"><cf_duxi name='worktel' class="tableyazi" type="label" value="#worktel#" gdpr="1"></cfif></td>
			<td><cfif len(extension)>#extension#</cfif></td>
			<td><cfif len(get_cv.email)>#get_cv.email#</cfif></td>
			<td><cf_duxi name='home_address' class="tableyazi" type="label" value="#HOMEADDRESS#" gdpr="1"></td>
			<td><cfif len(homepostcode)>#homepostcode#</cfif></td>
			<td><cfif len(homecounty)>#GET_COUNTY.COUNTY_NAME[listfind(ilce_id,homecounty,',')]#</cfif></td>
			<td><cfif len(homecity)>#get_city.city_name[listfind(sehir_id,homecity,',')]#</cfif></td>
			<td><cfif len(homecountry)>#get_country.country_name[listfind(ulke_id,homecountry,',')]#</cfif></td>
			<td><cfif len(home_status) and home_status eq 1>Kendisinin<cfelseif home_status eq 2> Aile<cfelseif home_status eq 3>Kira</cfif></td>
			<td><cfif len(tax_office)>#tax_office#</cfif></td>
			<td><cfif len(tax_number)>#tax_number#</cfif></td>
			<td><cfif len(birth_date)>#dateformat(birth_date,dateformat_style)#</cfif></td>
			<td><cfif len(birth_place)>#birth_place#</cfif></td>
			<td><cfif len(uyrugu_id)>#get_uyrugu.country_name[listfind(uyrugu_id,nationality,',')]#</cfif></td>
			<td><cfif len(kimlik_kart_tip_id)>#GET_ID_CARD_CATS.IDENTYCAT[listfind(kimlik_kart_tip_id,identycard_cat,',')]#</cfif></td>
			<td><cfif len(identycard_no)><cf_duxi name='identitycard_no_' class="tableyazi" type="label" value="#IDENTYCARD_NO#" gdpr="3"></cfif></td>
			<td><cfif len(city)>#city#</cfif></td>
			<td>
				<cfif blood_type eq 0>0 Rh+<cfelseif blood_type eq 1>0 Rh-<cfelseif blood_type eq 2>A Rh+<cfelseif blood_type eq 3>A Rh-<cfelseif blood_type eq 4>B Rh+<cfelseif blood_type eq 5>B Rh-<cfelseif blood_type eq 6>AB Rh+<cfelseif blood_type eq 7>AB Rh-</cfif>
			</td>							
			<td><cfif len(father)>#father#</cfif></td>
			<td><cfif len(father_job)>#father_job#</cfif></td>
			<td><cfif len(mother)>#mother#</cfif></td>
			<td><cfif len(mother_job)>#mother_job#</cfif></td>
			<td><cfif len(last_surname)>#last_surname#</cfif></td>
			<td><cfif len(religion)>#religion#</cfif></td>
			<td><cfif len(county)>#county#</cfif></td>
			<td><cfif len(binding)>#binding#</cfif></td>
			<td><cfif len(ward)>#ward#</cfif></td>
			<td><cfif len(family)>#family#</cfif></td>
			<td><cfif len(village)>#village#</cfif></td>
			<td><cfif len(cue)>#cue#</cfif></td>
			<td><cfif len(given_place)>#given_place#</cfif></td>
			<td><cfif len(record_number)>#record_number#</cfif></td>
			<td><cfif len(given_reason)>#given_reason#</cfif></td>
			<td><cfif len(given_date)>#dateformat(given_date,dateformat_style)#</cfif></td>		 				
			
			<td><cfif sex eq 1><cf_get_lang dictionary_id='58959.Erkek'><cfelse><cf_get_lang dictionary_id='58958.Kadın'></cfif></td>
			<td><cfif married eq 0><cf_get_lang dictionary_id='55744.Bekar'><cfelseif married eq 1><cf_get_lang dictionary_id='55743.Evli'></cfif></td>
			<td><cfif len(partner_name)>#partner_name#</cfif></td>
			<td><cfif len(partner_company)>#partner_company#</cfif></td>
			<td><cfif len(partner_position)>#partner_position#</cfif></td>
			<td><cfif len(child)>#child#</cfif></td>
			<td><cfif use_cigarette eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelseif use_cigarette eq 0><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
			<td><cfif martyr_relative eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelseif martyr_relative eq 0><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
			<td><cfif defected eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelseif defected eq 0><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
			<td><cfif is_psicotechnic eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelseif is_psicotechnic eq 0><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
			<td><cfif immigrant eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelseif immigrant eq 0><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
			<td><cfif defected_probability eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelseif defected_probability eq 0><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>  
			<td><cfif len(licencecat_id)>#get_driver_lis_type.licencecat[listfind(heliyet_tip_id,licencecat_id,',')]#</cfif>/ <cfif len(licence_start_date)>#DateFormat(licence_start_date,dateformat_style)#</cfif></td>
			<td><cfif len(driver_licence)>#driver_licence#</cfif></td>
			<td><cfif len(driver_licence_actived)>#driver_licence_actived#</cfif></td>
			<td><cfif len(INVESTIGATION)>#INVESTIGATION#</cfif></td>
			<td><cfif illness_probability eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelseif illness_probability eq 0><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
			<td><cfif len(illness_detail)><cf_duxi name='illness_detail' class="tableyazi" type="label" value="#illness_detail#" gdpr="10"></cfif></td>
			<td><cfif military_status eq 0><cf_get_lang dictionary_id='55624.Yapmadı'><cfelseif military_status eq 1><cf_get_lang dictionary_id='55625.Yaptı'><cfelseif military_status eq 2><cf_get_lang dictionary_id='55626.Muaf'><cfelseif military_status eq 3><cf_get_lang dictionary_id='55627.Yabancı'><cfelseif military_status eq 4><cf_get_lang dictionary_id='55340.Tecilli'></cfif></td>
			<td><cfif len(training_level)>#get_edu_level.education_name[listfind(edu_level_id,training_level,',')]#</cfif></td>
				<cfquery name="get_edu_info" datasource="#DSN#">
					SELECT TOP 4 * FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #empapp_id#
				</cfquery>
			<cfloop from="1" to="4" index="ed">
				<cfif len(get_edu_info.edu_type[ed])>
					<cfquery name="get_education_level_name" datasource="#dsn#">
						SELECT EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#get_edu_info.edu_type[ed]#
					</cfquery>
				</cfif>
				<cfif len(get_edu_info.edu_id[ed]) and get_edu_info.edu_id[ed] neq -1>
					<cfquery name="get_unv_name" datasource="#dsn#">
						SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #get_edu_info.edu_id[ed]#
					</cfquery>
						<cfset edu_name_degisken = get_unv_name.SCHOOL_NAME>
				<cfelse>
				<cfset edu_name_degisken = get_edu_info.edu_name[ed]>
				</cfif> 
					<cfif (len(get_edu_info.edu_part_id[ed]) and get_edu_info.edu_part_id[ed] neq -1)>
						<cfif get_edu_info.edu_type[ed] eq 2>
								<cfquery name="get_high_school_part_name" datasource="#dsn#">
									SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #get_edu_info.edu_part_id[ed]#
								</cfquery>
								<cfset edu_part_name_degisken = get_high_school_part_name.HIGH_PART_NAME>
						<cfelseif len(get_edu_info.edu_part_id[ed])>
								<cfquery name="get_school_part_name" datasource="#dsn#">
									SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #get_edu_info.edu_part_id[ed]#
								</cfquery>
								<cfset edu_part_name_degisken = get_school_part_name.PART_NAME>
						</cfif>
					<cfelseif len(get_edu_info.edu_part_name[ed])>
							<cfset edu_part_name_degisken = get_edu_info.edu_part_name[ed]>
					<cfelse>
							<cfset edu_part_name_degisken = "">
					</cfif>						
				<td><cfif len(get_edu_info.edu_type[ed])>#get_education_level_name.education_name#</cfif></td>
				<td>#edu_name_degisken#</td>
				<td>#get_edu_info.edu_start#</td>
				<td>#get_edu_info.edu_finish#</td>
				<td>#get_edu_info.edu_rank#</td>
				<td>#edu_part_name_degisken#</td>
			</cfloop>
			<!--- Dil  --->
				<cfquery name="get_language" datasource="#dsn#">
					SELECT 
						TOP 3
						(SELECT LANGUAGE_SET FROM SETUP_LANGUAGE WHERE LANGUAGE_ID = LANG_ID) AS LANG,
						(SELECT KNOWLEVEL FROM SETUP_KNOWLEVEL WHERE KNOWLEVEL_ID = LANG_SPEAK) AS LANG_SPEAK,
						(SELECT KNOWLEVEL FROM SETUP_KNOWLEVEL WHERE KNOWLEVEL_ID = LANG_MEAN) AS LANG_MEAN,
						(SELECT KNOWLEVEL FROM SETUP_KNOWLEVEL WHERE KNOWLEVEL_ID = LANG_WRITE) AS LANG_WRITE,
						LANG_WHERE
					FROM 
						EMPLOYEES_APP_LANGUAGE
					WHERE 
						EMPAPP_ID = #empapp_id#
				</cfquery>
				<cfloop from="1" to="3" index="lan">
					<td><cfif len(get_language.LANG[lan])>#get_language.LANG[lan]#</cfif></td>
					<td><cfif len(get_language.LANG_SPEAK[lan])>#get_language.LANG_SPEAK[lan]#</cfif></td>
					<td><cfif len(get_language.LANG_MEAN[lan])>#get_language.LANG_MEAN[lan]#</cfif></td>
					<td><cfif len(get_language.LANG_WRITE[lan])>#get_language.LANG_WRITE[lan]#</cfif></td>
					<td><cfif len(get_language.LANG_WHERE[lan])>#get_language.LANG_WHERE[lan]#</cfif></td>
				</cfloop>
			
			<cfquery name="get_extra_course" datasource="#dsn#">
				SELECT TOP 3 * FROM EMPLOYEES_COURSE WHERE EMPAPP_ID = #empapp_id#
			</cfquery>
			<cfloop from="1" to="3" index="co">
				<td><cfif len(get_extra_course.COURSE_SUBJECT[co])>#get_extra_course.COURSE_SUBJECT[co]#</cfif></td>
				<td><cfif len(get_extra_course.course_location[co])>#get_extra_course.course_location[co]#</cfif></td>
				<td><cfif len(get_extra_course.COURSE_EXPLANATION[co])>#get_extra_course.COURSE_EXPLANATION[co]#</cfif></td>
				<td><cfif len(get_extra_course.course_year[co])>#left(get_extra_course.course_year[co],4)#</cfif></td>
				<td><cfif len(get_extra_course.course_period[co])>#get_extra_course.course_period[co]#</cfif></td>
			</cfloop>
			<td><cfif len(comp_exp)>#comp_exp#</cfif></td>
			<td><cfif len(com_packet_pro)>#com_packet_pro#</cfif></td>
			<td><cfif len(electronic_tools)>#electronic_tools#</cfif></td>
			
			<!--- İş Tecrübesi --->
		   <cfquery name="get_work_info" datasource="#DSN#">
				SELECT TOP 3 EMPAPP_ID,EXP,EXP_POSITION,EXP_START,EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID=#empapp_id#
			</cfquery>	
			<cfloop from="1" to="3" index="ex">
				<td>#get_work_info.exp[ex]#</td>
				<td>#get_work_info.exp_position[ex]#</td>
				<td>#dateformat(get_work_info.exp_start[ex],dateformat_style)#</td>
				<td>#dateformat(get_work_info.exp_finish[ex],dateformat_style)#</td>
			</cfloop>	
				
			<!--- Referans Bilgileri --->
			<cfquery name="get_emp_reference" datasource="#dsn#">
				SELECT  TOP 3 * FROM EMPLOYEES_REFERENCE WHERE EMPAPP_ID = #empapp_id#
			</cfquery>
			<cfset ref_type_list = "">			
			<cfloop query="get_emp_reference">
				<cfif len(reference_type) and not listfind(ref_type_list,reference_type,',')>
					<cfset ref_type_list = listappend(ref_type_list,reference_type,',')>
				</cfif>
			</cfloop>
			<cfif listlen(ref_type_list)>
				<cfquery name="get_ref_type" datasource="#dsn#">
					SELECT REFERENCE_TYPE_ID,REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE WHERE REFERENCE_TYPE_ID IN(#ref_type_list#) ORDER BY REFERENCE_TYPE_ID
				</cfquery>
				<cfset ref_type_list = listsort(valuelist(get_ref_type.REFERENCE_TYPE_ID,','),"numeric","ASC",',')>
			</cfif>
			<td><cfif len(related_ref_name)>#related_ref_name#</cfif></td>
			<td><cfif len(related_ref_company)>#related_ref_company#</cfif></td>
			<cfloop from="1" to="3" index="y">
				<td>
					<!--- <cfif len(get_emp_reference.REFERENCE_TYPE[y]) and (get_emp_reference.REFERENCE_TYPE[y] eq 1)>Gurup İçi<cfelseif len(get_emp_reference.REFERENCE_TYPE[y]) and (get_emp_reference.REFERENCE_TYPE[y] eq 2)>Diğer</cfif> --->
					<cfif len(get_emp_reference.REFERENCE_TYPE[y])>
						#get_ref_type.reference_type[listfind(ref_type_list,get_emp_reference.REFERENCE_TYPE[y],',')]#
					</cfif>
				</td>
				<td><cfif len(get_emp_reference.REFERENCE_NAME[y])>#get_emp_reference.REFERENCE_NAME[y]#</cfif></td>
				<td>#get_emp_reference.REFERENCE_COMPANY[y]#</td>
				<td>#get_emp_reference.REFERENCE_TELCODE[y]#</td>
				<td>#get_emp_reference.REFERENCE_TEL[y]#</td>
				<td>#get_emp_reference.REFERENCE_POSITION[y]#</td>
				<td>#get_emp_reference.REFERENCE_EMAIL[y]#</td> 
			</cfloop>
			
			<!--- özel ilgi alanları --->
			<td><cfif len(hobby)>#hobby#</cfif></td>
			<td><cfif len(club)>#club#</cfif></td>
			
			<!--- Aile bilgileri --->
			<cfquery name="get_relatives" datasource="#DSN#">
				SELECT 
				TOP 3 
				EMPAPP_ID,
				NAME,
				SURNAME,
				RELATIVE_LEVEL,
				EDUCATION,
				BIRTH_DATE,
				BIRTH_PLACE,
				JOB,
				COMPANY,
				JOB_POSITION 
				FROM EMPLOYEES_RELATIVES WHERE EMPAPP_ID=#empapp_id#
			</cfquery>
			<cfloop from="1" to="3" index="y">
			<td>#get_relatives.name[y]# #get_relatives.surname[y]#</td>
			<td>
				<cfif get_relatives.relative_level[y] eq 1><cf_get_lang dictionary_id='53262.Baba'><cfelseif get_relatives.relative_level[y] eq 2><cf_get_lang dictionary_id='53272.Anne'><cfelseif get_relatives.relative_level[y] eq 3><cf_get_lang dictionary_id='55275.Eşi'><cfelseif get_relatives.relative_level[y] eq 4><cf_get_lang dictionary_id='55253.Oğlu'><cfelseif get_relatives.relative_level[y] eq 5><cf_get_lang dictionary_id='55234.Kızı'><cfelseif get_relatives.relative_level[y] eq 6><cf_get_lang dictionary_id='56360.Kardeşi'></cfif>
			</td>
			<td>#dateformat(get_relatives.birth_date[y],dateformat_style)#</td>
			<td>#get_relatives.BIRTH_PLACE[y]#</td>
			<cfif len(get_relatives.EDUCATION[y])>
				<cfquery name="get_edu_level" datasource="#dsn#">
					SELECT EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID = #get_relatives.EDUCATION[y]#
				</cfquery> 
			</cfif>
				<td><cfif len(get_relatives.EDUCATION[y])>#get_edu_level.education_name#</cfif></td> 
				<td>#get_relatives.job[y]#</td>
				<td>#get_relatives.company[y]#</td>
				<td>#get_relatives.job_position[y]#</td>
			</cfloop>
			<cfquery name="get_app_unit" datasource="#dsn#"> 
			SELECT UNIT_ID,UNIT_ROW FROM EMPLOYEES_APP_UNIT WHERE EMPAPP_ID =#empapp_id#
			</cfquery>
			<cfif len(get_app_unit.unit_id) and len(get_app_unit.unit_row)>
				<cfset liste = valuelist(get_app_unit.unit_id)>
				<cfset liste_row = valuelist(get_app_unit.unit_row)>					
			<cfelse>
				<cfset liste ="">
				<cfset liste_row ="">					
			</cfif>
			
			<!--- Çalışılmak istenenn Birimler --->
				<!---<cfloop query="get_cv_unit">
				<td>#get_cv_unit.unit_name#</td>
				<td>
					<cfif listfind(liste,get_cv_unit.unit_id,',')>
						#ListGetAt(liste_row,listfind(liste,get_cv_unit.unit_id,','),',')#
					<cfelse>
						-
					</cfif>
				</td>
			</cfloop>--->
			
			<!--- Çalışmak İstediği Şube  --->
			<td>
				<cfif len(preference_branch)>
					<cfloop list="#preference_branch#" delimiters="," index="i"><cfquery name="get_branch" datasource="#dsn#">SELECT BRANCH_ID, BRANCH_NAME, BRANCH_CITY FROM BRANCH WHERE BRANCH_ID=#i# AND BRANCH_STATUS =1 ORDER BY BRANCH_NAME</cfquery>#get_branch.branch_name# - #get_branch.branch_city#,</cfloop>
				</cfif>	
			</td>
			<!--- Ek Bilgiler --->
			<td>
			<cfif len(prefered_city)>
				<cfloop list="#prefered_city#" delimiters="," index="i"><cfquery name="get_city" datasource="#dsn#">SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID FROM SETUP_CITY WHERE CITY_ID=#i#</cfquery>#get_city.city_name#,</cfloop>
			</cfif>	
			</td>
			<td><cfif is_trip eq 1>Evet<cfelseif is_trip eq 0>Hayır</cfif></td>
			<td><cfif len(expected_price)>#TLFormat(expected_price)#</cfif> <!--- <cfif len(expected_money_type)>#get_money.money[listfind(money_type_,expected_money_type,',')]#</cfif> ---></td>
			<td><cfif len(work_start_date)>#dateformat(work_start_date,dateformat_style)#</cfif></td>
			<td><cfif len(APPLICANT_NOTES)>#APPLICANT_NOTES#</cfif></td>
			<td><cfif len(interview_result)>#interview_result#</cfif></td>
		</tr>
		</cfoutput>
		<cfelse>
		<tr>
			<td colspan="189"><cfif filtered><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
		</tr>
		</cfif>
	</body>
</cf_report_list>
</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif isdefined("attributes.form_submited") and len(attributes.form_submited)>
                <cfset url_str = "#url_str#&form_submited=#attributes.form_submited#">
            </cfif>
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
			<cfif isdefined("attributes.keyword2") and len(attributes.keyword2)>
                <cfset url_str = "#url_str#&keyword2=#attributes.keyword2#">
            </cfif>
			<cfif isdefined("attributes.status") and len(attributes.status)>
                <cfset url_str = "#url_str#&status=#attributes.status#">
            </cfif>
			<cfif isdefined("attributes.cv_status") and len(attributes.cv_status)>
                <cfset url_str = "#url_str#&cv_status=#attributes.cv_status#">
            </cfif>
			<cfif isdefined("attributes.emp_app_type") and len(attributes.emp_app_type)>
                <cfset url_str = "#url_str#&emp_app_type=#attributes.emp_app_type#">
            </cfif>
            <cfif len(attributes.startdate)>
                <cfset url_str = '#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
            </cfif>
            <cfif len(attributes.finishdate)>
                <cfset url_str = '#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
            </cfif>
            
                <cf_paging page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#attributes.fuseaction#&#url_str#"> 
               
                <!-- sil --><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput><!-- sil -->
            </tr>
            </table>
        </cfif>
<script type="text/javascript">
function control()	{
		if(theForm.startdate.value == "" || theForm.finishdate.value == "")
		{
			alert("<cf_get_lang dictionary_id ='58492.Tarih Filtesini Kontrol Ediniz'>!");
			return false;
		}
		theForm.startdate.value = fix_date_value(theForm.startdate.value);
		theForm.finishdate.value = fix_date_value(theForm.finishdate.value);
		if(!date_check(theForm.startdate,theForm.finishdate,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}

		if(document.theForm.is_excel.checked==false)
		{
			document.theForm.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.theForm.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_report_list_cv</cfoutput>"
					}
</script>

		