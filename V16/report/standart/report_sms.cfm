<!--- TolgaS:20080909 workcube den yollanan smsler raporu --->
<!--- FBS Dataport, Turatel ve 3GBilisim Icin Duzenlemeler Yapildi, Rapor Iyilestirildi --->
<cfparam name="attributes.module_id_control" default="2">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_comp_id" default="">
<cfparam name="attributes.member_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.send_member_comp_id" default="">
<cfparam name="attributes.send_member_id" default="">
<cfparam name="attributes.send_member_type" default="">
<cfparam name="attributes.send_member_name" default="">
<cfparam name="attributes.sms_type" default="">
<cfparam name="attributes.sms_send_receive" default="">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">

<cfset dataport_error_codes = "	
	999|Gateway Sistem Hatası;
	701|Yanlış Telefon Numarası Formatı;
	702|Küfür veya Siyasi İçerikli Bir Mesaj İçeriği;
	703|Gönderilmek İstenen Telefon Numarası Kara Listede;
	704|Geçersiz Tarih (SendDate/DeleteDate) Formatı;
	705|Geçersiz Karakter İçeren Bir Mesaj İçeriği veya Boş Mesaj İçeriği;
	801|Mesaj Gönderebilmek İçin Verilen Bilgiler Doğrultusunda Yetki Alınamadı;
	802|Çok Fazla Başarısız Bağlantı Girişimi. (IP Adresi Bir Süreliğine Engellenir)
">
<cfset turatel_error_codes = "
	01|Yanlış Username/PassWord Yanlış Girilmiş;
	02|Kredisi Yeterli Değil;
	03|Geçersiz İçerik;
	04|Bilinmeyen SMS Tipi;
	05|Yanlış Originator Seçimi Yapılmış;
	06|Mesaj Metni yada Numaralar Boş Girilmiş;
	07|İçerik Uzun Fakat Concat Özelliği Ayarlanmadığından Mesaj Birleştirilemiyor;
	08|Kullanıcının Mesaj Göndereceği Gateway Tanımlı Değil veya Şu Anda Çalışmıyor;
	09|Yanlış Tarih Formatı, Tarihler ddmmyyyyhhmm Formatında Olmalıdır;
	11|TCKimlikNo Gönderimi Yetkisi Yok;
	20|Bilinmeyen Hata;
	21|Yanlış XML Formatı;
	22|Kullanıcı Aktif Değil;
	23|Kullanıcı Zaman Aşımı
">

<cfset dorukHaberlesme_error_codes = "
	100|Başarılı;
	101|Sistem/XML Hatası;
	102|Kullanıcı adı veya şifreniz yanlış;
	103|Maximum karakter ve SMS sayısı limitini aştınız. Lütfen mesajınızı kontrol ediniz;
	104|Sizin için belirlenen günler dışında isteğinizi gerçekleştiremiyoruz;
	105|Sizin için belirlenen saatler dışında isteğinizi gerçekleştiremiyoruz;
	106|Sizin için belirlenen günlük SMS limitinin dolmuş olmasından dolayı şu an isteğinizi gerçekleştiremiyoruz;
	107|Böyle bir Originator tanımlı değil;
	108|Cep Telefon Numaraları boş olamaz. Virgül (,) ile ayırarak birden fazla numara yazabilirsiniz;
	109|Mesaj bölümü boş bırakılamaz;
	110|Kriterlere uygun listelenecek rapor bulunamadı;
	111|Belirtilen cep telefon numarasına ait bir kayıt bulunamadı;
	112|Max 30 günlük tarih aralığı içerisinde arama yapabilirsiniz;
	113|Yeterli Krediniz Bulunmuyor;
	114|Tarih Değerleri boş gelmemeli;
	115|Tanımsız veya Uygun olmayan Cep Telefon Numarası;
	116|Üyeliğinize kayıtlı herhangi bir grup bulunamadı;
	117|Belirttiğiniz gruba dahil herhangi bir müşteri kayıdı bulunamadı;
	118|Zorunlu olan bir yada daha fazla parametre boş gönderildi;
	120|Numara Kara Listede Bulunuyor;
	121|Numara Kara Listede Bulunmuyor;
	122|Numara Kara Listeye Eklendi;
	123|Numara Kara Listeden Çıkartıldı;
	500|Bağlantı Hatası
">

<cfset sms3g_error_codes ="
	0|Kullanıcı Bilgileri Boş; 
	1|Kullanıcı Bilgileri Hatalı;
	2|Hesap Kapalı;
	3|Kontör Hatası;
	4|Bayi Kodunuz Hatalı;
	5|Originator Bilginiz Hatalı;
	6|Yapılan İşlem İçin Yetkiniz Yok;
	10|Geçersiz IP Adresi;
	14|Mesaj Metni Girilmemiş;
	15|GSM Numarası Girilmemiş;
	20|Rapor Hazır Değil;
	27|Aylık Atım Limitiniz Yetersiz;
	100|XML Hatası;
	999|Cep Tel Numaranızı kontrol ediniz!
">
<cfset get_sms.recordcount = 0>
<cfif isdefined("attributes.form_submit")>
	<cfquery name="get_sms" datasource="#dsn3#">
		SELECT 
			* 
		FROM 
			SMS_SEND_RECEIVE
		WHERE
			1=1
			<cfif len(attributes.sms_type)>
				AND SMS_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sms_type#">
			</cfif>
			<cfif Len(attributes.sms_send_receive)>
				AND IS_SEND_RECEIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.sms_send_receive#">
			</cfif>
			<cfif len(attributes.start_date)>
				AND SEND_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
			</cfif>
			<cfif len(attributes.finish_date)>
				AND SEND_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD('d',1,attributes.finish_date)#">
				AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD('d',1,attributes.finish_date)#">
			</cfif>
			<cfif len(attributes.member_type) and len(attributes.member_name)>
				<cfif attributes.member_type eq 'employee' and len(attributes.member_id)>
					AND RECEIVE_EMPOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
				<cfelseif attributes.member_type eq 'consumer' and len(attributes.member_id)>
					AND RECEIVE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
				<cfelseif attributes.member_type eq 'partner' and len(attributes.member_id)>
					AND RECEIVE_COMPANY_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
				</cfif>
			</cfif>
			<cfif len(attributes.send_member_type) and len(attributes.send_member_name)>
				<cfif attributes.send_member_type eq 'employee' and len(attributes.send_member_id)>
					AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.send_member_id#">
				<cfelseif attributes.send_member_type eq 'consumer' and len(attributes.send_member_id)>
					AND RECORD_CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.send_member_id#">
				<cfelseif attributes.send_member_type eq 'partner' and len(attributes.send_member_id)>
					AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.send_member_id#">
				</cfif>
			</cfif>
			<cfif len(attributes.order_type)>
				ORDER BY
				<cfif attributes.order_type eq 0>
					SEND_DATE
				<cfelseif attributes.order_type eq 1>
					SEND_DATE DESC
				<cfelseif attributes.order_type eq 2>
					RECORD_DATE
				<cfelseif attributes.order_type eq 3>
					RECORD_DATE DESC
				</cfif>
			</cfif>
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_sms.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">	
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="sms_report" action="">
			<cf_box_search>
				<input type="hidden" name="form_submit" id="form_submit" value="1">
				<div class="form-group">
					<input type="checkbox" name="is_campaign_info" id="is_campaign_info" value="1" <cfif isDefined("attributes.is_campaign_info")>checked</cfif>><cf_get_lang dictionary_id='40116.Kampanya Bilgileri'>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="member_comp_id" id="member_comp_id" value="<cfif isdefined('attributes.member_comp_id') and len(attributes.member_comp_id) and len(attributes.member_name)><cfoutput>#attributes.member_comp_id#</cfoutput></cfif>">
						<input type="hidden" name="member_id" id="member_id" value="<cfif isdefined('attributes.member_id') and len(attributes.member_id) and len(attributes.member_name)><cfoutput>#attributes.member_id#</cfoutput></cfif>">
						<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined('attributes.member_type') and len(attributes.member_type) and len(attributes.member_name)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
						<input type="text" placeholder="<cf_get_lang dictionary_id ='40112.Sms Gönderilen'>" name="member_name" id="member_name" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\'','MEMBER_TYPE,PARTNER_ID2,COMPANY_ID,MEMBER_PARTNER_NAME2','member_type,member_id,member_comp_id,member_name','','3','200');" style="width:120px;" value="<cfif isdefined('attributes.member_name') and len(attributes.member_name) and len(attributes.member_type)><cfoutput>#attributes.member_name#</cfoutput></cfif>">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_emp_id=sms_report.member_id&field_id=sms_report.member_id&field_comp_id=sms_report.member_comp_id&field_name=sms_report.member_name&field_type=sms_report.member_type&select_list=1,7,8&keyword='+encodeURIComponent(document.sms_report.member_name.value));"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="send_member_comp_id" id="send_member_comp_id" value="<cfif isdefined('attributes.send_member_comp_id') and len(attributes.send_member_comp_id) and len(attributes.send_member_name)><cfoutput>#attributes.send_member_comp_id#</cfoutput></cfif>">
						<input type="hidden" name="send_member_id" id="send_member_id" value="<cfif isdefined('attributes.send_member_id') and len(attributes.send_member_id) and len(attributes.send_member_name)><cfoutput>#attributes.send_member_id#</cfoutput></cfif>">
						<input type="hidden" name="send_member_type" id="send_member_type" value="<cfif isdefined('attributes.send_member_type') and len(attributes.send_member_type) and len(attributes.send_member_name)><cfoutput>#attributes.send_member_type#</cfoutput></cfif>">
						<input type="text" placeholder="<cf_get_lang dictionary_id ='40119.SMS Gönderen'>" name="send_member_name" id="send_member_name" onfocus="AutoComplete_Create('send_member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\'','MEMBER_TYPE,PARTNER_ID2,COMPANY_ID,MEMBER_PARTNER_NAME2','send_member_type,send_member_id,send_member_comp_id,send_member_name','','3','200');" autocomplete="off" value="<cfif isdefined('attributes.send_member_name') and len(attributes.send_member_name) and len(attributes.send_member_type)><cfoutput>#attributes.send_member_name#</cfoutput></cfif>">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_emp_id=sms_report.send_member_id&field_id=sms_report.send_member_id&field_comp_id=sms_report.send_member_comp_id&field_name=sms_report.send_member_name&field_type=sms_report.send_member_type&select_list=1,7,8&keyword='+encodeURIComponent(document.sms_report.send_member_name.value));"></span>
					</div>
				</div>
				<div class="form-group medium">
					<div class="input-group">
						<cfsavecontent variable="message1"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
						<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cfset startdate=attributes.start_date><cfelse><cfset startdate=''></cfif>
						<cfinput type="text" placeholder="#getLang('','Başlangıç Tarihi','58053')#" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message1#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group medium">
					<div class="input-group">
						<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cfset finishdate=attributes.finish_date><cfelse><cfset finishdate=''></cfif>
						<cfinput type="text" placeholder="#getLang('','Bitiş Tarihi','57700')#" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" message="#message1#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
					
				</div>
				<div class="form-group">
					<select name="sms_send_receive"  id="sms_send_receive">
						<option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
						<option value="1" <cfif Len(attributes.sms_send_receive) and attributes.sms_send_receive eq 1>selected</cfif>><cf_get_lang dictionary_id='58974.Gelen'><cf_get_lang dictionary_id='49523.SMS'></option>
						<option value="0" <cfif Len(attributes.sms_send_receive) and attributes.sms_send_receive eq 0>selected</cfif>><cf_get_lang dictionary_id='58975.Giden'><cf_get_lang dictionary_id='49523.SMS'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="order_type" id="order_type">
						<option value=""><cf_get_lang dictionary_id='58924.Sıralama'></option>
						<option value="0" <cfif not isdefined('attributes.order_type') or attributes.order_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='40106.Gönderim Tarihi Artan'></option>
						<option value="1" <cfif isdefined('attributes.order_type') and attributes.order_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='40107.Gönderim Tarihi Azalan'></option>
						<option value="2" <cfif isdefined('attributes.order_type') and attributes.order_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='40108.Kayıt Tarihi Artan'></option>
						<option value="3" <cfif isdefined('attributes.order_type') and attributes.order_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='40109.Kayıt Tarihi Azalan'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="sms_type" id="sms_type"><!--- <cf_get_lang dictionary_id ='40111.SMS Durum'> --->
						<option value=""><cf_get_lang dictionary_id ='40111.SMS Durum'></option>
						<option value="0" <cfif len(attributes.sms_type) and attributes.sms_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='40103.Gönderilmedi'></option>
						<option value="1" <cfif len(attributes.sms_type) and attributes.sms_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='40102.Gönderildi'></option>
						<option value="2" <cfif len(attributes.sms_type) and attributes.sms_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='40127.Beklemede'></option>
						<option value="3" <cfif len(attributes.sms_type) and attributes.sms_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='40129.Gönderilemedi'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type='4'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','SMS Raporu','39920')#" uidrop="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id ='57487.No'></th>
					<th><cf_get_lang dictionary_id ='39021.Gonderici Firma'></th>
					<th><cf_get_lang dictionary_id ='40110.SMS Tip'></th>
					<th><cf_get_lang dictionary_id ='40111.SMS Durum'></th>
					<th><cf_get_lang dictionary_id ='40112.SMS Gönderilen'></th>
					<th><cf_get_lang dictionary_id ='40113.SMS Gönderilen Numara'></th>
					<th><cf_get_lang dictionary_id ='36168.SMS Şablonu'></th>
					<cfif isDefined("attributes.is_campaign_info")>
						<th><cf_get_lang dictionary_id ='57446.Kampanya'></th>
						<th><cf_get_lang dictionary_id ='40116.Kampanya İçeriği'></th>
					</cfif>
					<th><cf_get_lang dictionary_id ='58610.SMS İçeriği'></th>
					<th><cf_get_lang dictionary_id ='40119.SMS Gönderen'></th>
					<th><cf_get_lang dictionary_id ='40122.SMS Gönderim Tarihi'></th>
					<th><cf_get_lang dictionary_id ='40123.SMS Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id ='40568.Hata Kodu'></th>
				</tr>
			</thead>
			<cfif isdefined("attributes.form_submit") and get_sms.recordcount>
				<cfset employees_list="">
				<cfset consumer_list="">
				<cfset company_list="">
				<cfset campaign_list="">
				<cfset template_list="">
				<cfset cont_list="">
				<cfset rec_emp_list="">
				<cfset rec_con_list="">
				<cfset rec_par_list="">
				<cfoutput query="get_sms" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(RECORD_EMP) and not listfind (rec_emp_list,RECORD_EMP)>
						<cfset rec_emp_list= listappend (rec_emp_list,RECORD_EMP)>
					<cfelseif len (RECORD_CON) and not listfind(rec_con_list,RECORD_CON)>
						<cfset rec_con_list=listappend (rec_con_list,RECORD_CON)>
					<cfelseif len(RECORD_PAR) and not listfind (rec_par_list,RECORD_PAR)>
						<cfset rec_par_list = listappend(rec_par_list,RECORD_PAR)>
					</cfif>
					<cfif isDefined("attributes.is_campaign_info")>
						<cfif len(SMS_CONT_ID) and not listfind (cont_list,SMS_CONT_ID)>
							<cfset cont_list = listappend (cont_list,SMS_CONT_ID)>
						</cfif>
						<cfif len(CAMP_ID) and not listfind(campaign_list,CAMP_ID)>
							<cfset campaign_list = listappend(campaign_list,CAMP_ID)>
						</cfif>
					</cfif>
					<cfif len (SMS_TEMPLATE_ID) and not listfind (template_list,SMS_TEMPLATE_ID)>
						<cfset template_list = listappend(template_list,SMS_TEMPLATE_ID)>
					</cfif>
					<cfif len(RECEIVE_EMPOYEE_ID)and not listfind(employees_list,RECEIVE_EMPOYEE_ID)>
						<cfset employees_list = listappend(employees_list,RECEIVE_EMPOYEE_ID)>
					<cfelseif len (RECEIVE_CONSUMER_ID) and not listfind(consumer_list,RECEIVE_CONSUMER_ID)>
						<cfset consumer_list = listappend (consumer_list,RECEIVE_CONSUMER_ID)>
					<cfelseif len(RECEIVE_COMPANY_PARTNER_ID) and not listfind(company_list,RECEIVE_COMPANY_PARTNER_ID)>
						<cfset company_list = listappend (company_list,RECEIVE_COMPANY_PARTNER_ID)>
					</cfif>
				</cfoutput>
				<cfif len(rec_par_list)>
					<cfset rec_par_list = listsort(rec_par_list,"numeric","ASC",",")>
					<cfquery name="get_par" datasource="#dsn#">
							SELECT
								CP.PARTNER_ID,
								C.COMPANY_ID,
								C.FULLNAME,
								CP.COMPANY_PARTNER_NAME,
								CP.COMPANY_PARTNER_SURNAME
							FROM
								COMPANY_PARTNER AS CP,
								COMPANY AS C
							WHERE
								CP.PARTNER_ID IN (#rec_par_list#) AND
								C.COMPANY_ID = CP.COMPANY_ID
							ORDER BY
								CP.PARTNER_ID
					</cfquery>
					<cfset rec_par_list= listsort(listdeleteduplicates(valuelist(get_par.partner_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(rec_con_list)>
					<cfset rec_con_list = listsort(rec_con_list,"numeric","ASC",",")>
					<cfquery name="get_con" datasource="#dsn#">
						SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#rec_con_list#) ORDER BY CONSUMER_ID
					</cfquery>
					<cfset rec_con_list= listsort(listdeleteduplicates(valuelist(get_con.consumer_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(rec_emp_list)>
					<cfset rec_emp_list = listsort(rec_emp_list,"numeric","ASC",",")>
					<cfquery name="get_emp" datasource="#dsn#">
						SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#rec_emp_list#) ORDER BY EMPLOYEE_ID
					</cfquery>
					<cfset rec_emp_list= listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>	
				</cfif>
				<cfif len (template_list)>
					<cfset template_list = listsort(template_list,"numeric","ASC",",")>
					<cfquery name="get_template" datasource="#dsn#">
						SELECT SMS_TEMPLATE_ID, SMS_TEMPLATE_NAME FROM SMS_TEMPLATE WHERE SMS_TEMPLATE_ID IN(#template_list#) ORDER BY SMS_TEMPLATE_ID
					</cfquery>
					<cfset template_list = listsort (listdeleteduplicates(valuelist(get_template.SMS_TEMPLATE_ID,',')),'numeric','ASC',',')>
				</cfif>
				<cfif isDefined("attributes.is_campaign_info")>
					<cfif len(campaign_list)>
						<cfset campaign_list= listsort(campaign_list,"numeric","ASC",",")>
						<cfquery name="get_campaign" datasource="#DSN3#">
							SELECT CAMP_ID, CAMP_HEAD, CAMP_OBJECTIVE FROM CAMPAIGNS WHERE CAMP_ID IN (#campaign_list#) ORDER BY CAMP_ID
						</cfquery>
						<cfset campaign_list= listsort (listdeleteduplicates(valuelist(get_campaign.camp_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(cont_list)>
						<cfset cont_list = listsort (cont_list,"numeric","ASC",",")>
						<cfquery name="get_cont" datasource="#dsn3#">
							SELECT SMS_CONT_ID, SMS_BODY FROM CAMPAIGN_SMS_CONT WHERE SMS_CONT_ID IN (#cont_list#) ORDER BY SMS_CONT_ID
						</cfquery>
						<cfset cont_list = listsort (listdeleteduplicates(valuelist(get_cont.SMS_CONT_ID,',')),'numeric','ASC',',')>
					</cfif>
				</cfif>
				<cfif len(company_list)>
					<cfset company_list = listsort(company_list,"numeric","ASC",",")>
					<cfquery name="get_partner" datasource="#dsn#">
							SELECT
								CP.PARTNER_ID,
								C.COMPANY_ID,
								C.FULLNAME,
								CP.COMPANY_PARTNER_NAME,
								CP.COMPANY_PARTNER_SURNAME
							FROM
								COMPANY_PARTNER AS CP,
								COMPANY AS C
							WHERE
								CP.PARTNER_ID IN (#company_list#) AND
								C.COMPANY_ID = CP.COMPANY_ID
							ORDER BY
								CP.PARTNER_ID
					</cfquery>
					<cfset company_list= listsort(listdeleteduplicates(valuelist(get_partner.partner_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(consumer_list)>
					<cfset consumer_list = listsort(consumer_list,"numeric","ASC",",")>
					<cfquery name="get_consumer" datasource="#dsn#">
						SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
					</cfquery>
					<cfset consumer_list= listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(employees_list)>
					<cfset employees_list = listsort(employees_list,"numeric","ASC",",")>
					<cfquery name="get_employee" datasource="#dsn#">
						SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employees_list#) ORDER BY EMPLOYEE_ID
					</cfquery>
					<cfset employees_list= listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>	
				</cfif>
				<cfoutput query="GET_SMS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" >		
				<cfset title_ = "">
				
				<cfif Len(error_code)>
					<cfif error_code eq -1>
						<cfsavecontent variable="send_message"><cf_get_lang dictionary_id ='40102.Gönderildi'></cfsavecontent>
						<cfset title_ = send_message>
					<cfelse>
						<cfif get_sms.sms_type_id eq 1>
							<cfloop list="#dataport_error_codes#" index="ec" delimiters=";">
								<cfif ListFirst(ec,'|') eq error_code>
									<cfset title_ = "(DataPort) " & ListLast(ec,'|')>
								</cfif>
							</cfloop>
						<cfelseif get_sms.sms_type_id eq 2>
							<cfloop list="#turatel_error_codes#" index="ec" delimiters=";">
								<cfif ListFirst(ec,'|') eq error_code>
									<cfset title_ = "(TuraTel) " & ListLast(ec,'|')>
								</cfif>
							</cfloop>
						<cfelseif get_sms.sms_type_id eq 3>
							<cfloop list="#dorukHaberlesme_error_codes#" index="ec" delimiters=";">
								<cfif ListFirst(ec,'|') eq error_code>
									<cfset title_ = "(DorukHaberlesme) " & ListLast(ec,'|')>
								</cfif>
							</cfloop>
						<cfelseif get_sms.sms_type_id eq 4>
							<cfloop list="#sms3g_error_codes#" index="ec" delimiters=";">
								<cfif ListFirst(ec,'|') eq error_code>
									<cfset title_ =  "(3GSMS) " & ListLast(ec,'|')>
								</cfif>
							</cfloop>
						</cfif>
				</cfif>
				</cfif>
				<tbody>
				<tr <cfif Len(error_code)>title="<cf_get_lang dictionary_id ='40568.Hata Kodu'> #error_code# : #title_#"</cfif>>
					<td>#CURRENTROW#</td>
					<td><cfif get_sms.sms_type_id eq 1>Dataport<cfelseif get_sms.sms_type_id eq 2>Turatel<cfelseif get_sms.sms_type_id eq 3>Doruk Haberleşme<cfelseif get_sms.sms_type_id eq 4>3GSMS</cfif></td>
					<td><cfif IS_SEND_RECEIVE eq 1><cf_get_lang dictionary_id='58974.Gelen'><cfelse><cf_get_lang dictionary_id='58975.Giden'></cfif></td>
					<td><cfif SMS_STATUS eq 0><cf_get_lang dictionary_id ='40103.Gönderilmedi'><cfelseif SMS_STATUS eq 1><cf_get_lang dictionary_id ='40102.Gönderildi'><cfelseif SMS_STATUS eq 2><cf_get_lang dictionary_id ='40127.Beklemede'><cfelseif SMS_STATUS eq 3><cf_get_lang dictionary_id ='40129.Gönderilemedi'></cfif></td>
					<td nowrap>
						<cfif len(RECEIVE_EMPOYEE_ID)>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECEIVE_EMPOYEE_ID#','medium');">
								#get_employee.employee_name[listfind(employees_list,RECEIVE_EMPOYEE_ID)]# #get_employee.employee_surname[listfind(employees_list,RECEIVE_EMPOYEE_ID)]#
							</a>
						<cfelseif len(RECEIVE_CONSUMER_ID)>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id= #RECEIVE_CONSUMER_ID#','medium');">#get_consumer.consumer_name[listfind(consumer_list,RECEIVE_CONSUMER_ID)]# #get_consumer.consumer_surname[listfind(consumer_list,RECEIVE_CONSUMER_ID)]#</a>
						<cfelseif len(RECEIVE_COMPANY_PARTNER_ID)>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#RECEIVE_COMPANY_ID#','medium');">
								#get_partner.fullname[listfind(company_list,RECEIVE_COMPANY_PARTNER_ID)]#
								#get_partner.COMPANY_PARTNER_NAME[listfind(company_list,RECEIVE_COMPANY_PARTNER_ID)]# #get_partner.COMPANY_PARTNER_SURNAME[listfind(company_list,RECEIVE_COMPANY_PARTNER_ID)]#
							</a>
						</cfif>
					</td>
					<td>#PHONE_NUMBER#</td>
					<td><cfif len(SMS_TEMPLATE_ID)>#get_template.sms_template_name[listfind(template_list,SMS_TEMPLATE_ID)]#</cfif></td>
					<cfif isDefined("attributes.is_campaign_info")>
						<td><cfif len(CAMP_ID)>#get_campaign.CAMP_HEAD[listfind(campaign_list,CAMP_ID,',')]#</cfif></td>
						<td><cfif len(SMS_CONT_ID)>#get_cont.sms_body[listfind(cont_list,SMS_CONT_ID,',')]#</cfif></td>
					</cfif>
					<td>#SMS_BODY#</td>
					<td nowrap>
						<cfif len(RECORD_EMP)>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#','medium');">
								#get_emp.employee_name[listfind(rec_emp_list,RECORD_EMP)]# #get_emp.employee_surname[listfind(rec_emp_list,RECORD_EMP)]#
							</a>
						<cfelseif len(RECORD_CON)>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id= #RECORD_CON#','medium');">
								#get_con.consumer_name[listfind(rec_con_list,RECORD_CON)]# #get_con.consumer_surname[listfind(rec_con_list,RECORD_CON)]#
							</a>
						<cfelseif len(RECORD_PAR)>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#RECORD_PAR#','medium');">
								#get_par.fullname[listfind(rec_par_list,RECORD_PAR)]#
								#get_par.COMPANY_PARTNER_NAME[listfind(rec_par_list,RECORD_PAR)]# #get_par.COMPANY_PARTNER_SURNAME[listfind(rec_par_list,RECORD_PAR)]#
							</a>
						</cfif>
					</td>
					<td nowrap>#DateFormat(SEND_DATE,dateformat_style)# #TimeFormat(SEND_DATE,timeformat_style)#</td>
					<td nowrap>#DateFormat(RECORD_DATE,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,RECORD_DATE),timeformat_style)#</td>
					<td><cfif error_code eq -1><cf_get_lang dictionary_id ='40102.Gönderildi'><cfelse>#error_code# : #title_#</cfif></td>
				</tr>
				</tbody>
				</cfoutput>
			</cfif>
		</cf_grid_list>
		<cfif not get_sms.recordcount>
			<div class="ui-info-bottom">
				<p><cfif isdefined ("attributes.form_submit")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</p>
			</div>
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "report.report_sms&form_submit=1">
			<cfif isDefined("attributes.is_campaign_info")><cfset adres = "#adres#&is_campaign_info=#attributes.is_campaign_info#"></cfif>
			<cfif isdate(attributes.start_date)><cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#"></cfif>
			<cfif isdate(attributes.finish_date)><cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#"></cfif>
			<cfif len(attributes.sms_type)><cfset adres = "#adres#&sms_type=#attributes.sms_type#"></cfif>
			<cfif len(attributes.sms_send_receive)><cfset adres = "#adres#&sms_send_receive=#attributes.sms_send_receive#"></cfif>
			<cfif len(attributes.order_type)><cfset adres = "#adres#&order_type=#attributes.order_type#"></cfif>
			<cfif len(attributes.member_type) and len(attributes.member_name)>
				<cfset adres = "#adres#&member_comp_id=#attributes.member_comp_id#&member_id=#attributes.member_id#">
				<cfset adres = "#adres#&member_type=#attributes.member_type#&member_name#attributes.member_name#">
			</cfif>
			<cfif len(attributes.send_member_type) and len(attributes.send_member_name)>
				<cfset adres = "#adres#&send_member_comp_id=#attributes.send_member_comp_id#&send_member_id=#attributes.send_member_id#">
				<cfset adres = "#adres#&send_member_type=#attributes.send_member_type#&send_member_name=#attributes.send_member_name#">
			</cfif>
			<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			startrow="#attributes.startrow#"
			totalrecords="#attributes.totalrecords#" 
			adres="#adres#">
		</cfif>
	</cf_box>
</div>

