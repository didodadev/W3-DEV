<cf_xml_page_edit fuseact="settings.form_close_cari_consumer">
<cfquery name="get_period" datasource="#dsn#">
	SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD WHERE PERIOD_YEAR <= #year(now())+1# ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
</cfquery>
<cfif is_select_ch_cat eq 1>
		<cfquery name="get_member_cat" datasource="#dsn#">
			SELECT DISTINCT	
				CONSCAT_ID MEMBER_CAT_ID,
				CONSCAT MEMBER_CAT
			FROM
				GET_MY_CONSUMERCAT
			WHERE
				EMPLOYEE_ID = #session.ep.userid# AND
				OUR_COMPANY_ID = #session.ep.company_id#
			ORDER BY
				CONSCAT		
		</cfquery>
</cfif>
<cfsavecontent variable = "title">
	<cf_get_lang no='1556.Bireysel Üye Dönem Açılışı'>
</cfsavecontent>
<cf_form_box title="#title#">
	<cf_area width="50%">
		<cfform name="close_ch" method="post" action="" enctype="multipart/form-data">
			<input type="hidden" value="1" name="is_consumer" id="is_consumer">
			<cfset select_list_ = 3>
			<cfset select_list_2 = 2>
			<cfset url_ = 'popup_list_cons'>
			<input type="hidden" value="" name="is_from_donem" id="is_from_donem">
			<input type="hidden" value="<cfoutput>#xml_money_type#</cfoutput>" name="xml_money_type" id="xml_money_type">
			<table>
				<tr>
					<td class="headbold" nowrap>
						<a href="javascript:show_options_info('from_period');">&raquo;<cf_get_lang no='1069.Dönemden Aktarım'></a><br/>
						<a href="javascript:show_options_info('from_file');">&raquo;<cf_get_lang no='1074.Dosyadan Aktarım'></a>
					</td>
				</tr>
			</table>
			<table id="from_period" style="display:none">
				<tr>
					<td><cf_get_lang dictionary_id="59604.Ödeme Performansına Göre Hesapla"></td>
					<td>
						<input type="checkbox" name="is_make_age" id="is_make_age" value="1" onClick="check_row_info(1);">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="59605.Manuel Ödeme Performansına Göre Hesapla"></td>
					<td>
						<input type="checkbox" name="is_make_age_manuel" id="is_make_age_manuel" value="1" onClick="check_row_info(2);">
					</td>
				</tr>
				<tr>
					<td width="270"><cf_get_lang no='1064.Ödenmemiş Çek\Senetleri Aktarma (Satır Bazında Çek\Senetleri Carileştiren Firmalar İçindir)'></td>
					<td><input type="checkbox" name="is_cheque_voucher_transfer" id="is_cheque_voucher_transfer" value="1"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="59606.Kur Fiş Tarihinden Alınsın"></td>
					<td><input type="checkbox" name="check_date_rate" id="check_date_rate" value="1" checked></td>
				</tr>
				<tr>
					<td><cf_get_lang no='1030.Fiş Tarihi'></td>
					<td><input type="text" name="action_date_rate" id="action_date_rate" value="01/01/<cfoutput>#session.ep.period_year#</cfoutput>" style="width:200px;">
						<cf_wrk_date_image date_field="action_date_rate">
					</td>
				</tr>
			</table>
			<table id="from_file" style="display:none">
				<tr>
					<td width="270"><cf_get_lang no='1030.Fiş Tarihi'></td>
					<td>
						<input type="text" name="action_date" id="action_date" value="01/01/<cfoutput>#session.ep.period_year#</cfoutput>" style="width:200px;">
						<cf_wrk_date_image date_field="action_date">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no='1061.Tüm Açılış Fişlerini Silip Yeniden Oluştur'></td>
					<td><input type="checkbox" name="is_delete_all" id="is_delete_all" value="1" checked="checked"></td>
				</tr>
				<tr>
					<td><cf_get_lang no='1289.Dosyadan Aktar'></td>
					<td><input type="file" style="width:200px;" name="cari_file" id="cari_file"></td>
				</tr>
				<tr>
					<td><cf_get_lang no='1044.Dosya Üye Formatı'></td>
					<td> 
						<select name='file_comp_identifier' id="file_comp_identifier" style="width:200px;">
						
								<option value="0" selected><cf_get_lang_main no='340.Vergi No'></option>
								<option value="1"><cf_get_lang_main no='377.Özel Kod'></option>
								<option value="4"><cf_get_lang_main no='146.Üye No'></option>
						
						</select>
					</td>
				</tr>
			</table>
			<table id="general_options" style="display:none">
				<tr>
					<td width="270"><cf_get_lang no='1288.Muhasebe Dönemi'></td>
					<td>
						<select name="period" id="period" style="width:200px;">
							<option value="" selected><cf_get_lang no='216.Dönemler'></option>
							<cfoutput query="get_period">
								<option value="#PERIOD_ID#;#PERIOD_YEAR#">#PERIOD#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='388.işlem tipi'>*</td>
					<td colspan="2"><cf_workcube_process_cat slct_width="200" module_id='23'></td>
				</tr>
				<cfif is_select_ch eq 1>
					<tr id="from_period2">
						<td><cf_get_lang_main no='107.Cari Hesap'></td>
						<td colspan="2">
							<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'partner'><cfoutput>#attributes.company_id#</cfoutput></cfif>">
							<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'consumer'><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'employee'><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
							<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
							<input type="text" name="company" id="company" style="width:200px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'<cfoutput>#select_list_2#</cfoutput>\',\'0\',\'0\',\'0\',\'2\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','','3','225');" value="<cfif  isdefined("attributes.company") and len(attributes.company)><cfoutput>#URLDecode(attributes.company)#</cfoutput></cfif>" autocomplete="off">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.#url_#&is_company_info=1&field_name=close_ch.company&field_type=close_ch.member_type&field_comp_name=close_ch.company&field_consumer=close_ch.consumer_id&field_emp_id=close_ch.employee_id&field_comp_id=close_ch.company_id&select_list=#select_list_#</cfoutput>','list');"> <img src="/images/plus_thin.gif" border="0" align="absmiddle"> </a>				
						</td>
					</tr>
				</cfif>
				<cfif is_select_ch_cat eq 1 and not isdefined("attributes.is_employee")>
					<tr id="from_period3">
						<td valign="top"><cf_get_lang_main no='1197.üye Kategorisi'></td>
						<td colspan="2">
							<select name="member_cat" id="member_cat" style="width:200px;height:75px;" multiple="multiple">
								<cfoutput query="get_member_cat">
									<option value="#member_cat_id#">&nbsp;#member_cat#</option>
								</cfoutput>						
							</select>						
						</td>
					</tr>
				</cfif>
				<tr>
					<td><cf_get_lang dictionary_id="58121.İşlem Dövizi"></td>
					<td>
						<input type="checkbox" name="is_other_money_transfer" id="is_other_money_transfer" value="1" checked="checked">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="29819.Proje Bazında"></td>
					<td>
						<input type="checkbox" name="is_project_transfer" id="is_project_transfer" value="1">	
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="59602.Hesap Tipi Bazında"></td>
					<td><input type="checkbox" name="is_acc_type_transfer" id="is_acc_type_transfer" value="1"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="59603.Abone Bazında"></td>
					<td><input type="checkbox" name="is_subscription_transfer" id="is_subscription_transfer" value="1"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="35974.Şube Bazında"></td>
					<td>
						<input type="checkbox" name="is_branch_transfer" id="is_branch_transfer" value="1">
					</td>
				</tr>
				<tr id="create_file2" style="display:none;">
					<td><cf_get_lang dictionary_id="29539.Satır Bazında"></td>
					<td>
						<input type="checkbox" name="is_row_info" id="is_row_info">
					</td>
				</tr>
				<tr id="close_demand" style="display:none;">
					<td><cf_get_lang dictionary_id="42334.Ödeme Talepleri Aktarılsın"></td>
					<td>
						<input type="checkbox" name="is_demand_transfer" id="is_demand_transfer" value="1">
					</td>
				</tr>
				<tr><td><br/></td></tr>
				<tr>
					<td style="float:left">
						<cf_workcube_buttons is_upd='0' add_function="kontrol()">
					</td>
				</tr>
			</table>
		</cfform>
	</cf_area>
	<cf_area width="50%">
		<table>
			<tr height="30">
				<td class="headbold" valign="top"><cf_get_lang_main no='21.Yardım'></td>
			</tr>
			<tr>
				<td valign="top"> 
					<cftry>
						<tr>
							<td>
								<br/>1-<cf_get_lang no='2888.Eğer dönemden aktar seçerseniz'>; <cf_get_lang no='2890.seçtiğiniz dönemin mevcut bakiyeleri seçtiğiniz koşullarla ilgili şirketin o dönemden sonraki ilk dönemine aktarılır'>.<br/>
									<br/>a-  <cf_get_lang dictionary_id="846.Ödeme Peformansına Göre Hesapla seçerseniz; önceki dönemdeki açık işlemlerin 
									vadeleri ödeme performansına göre hesaplanarak aktarılır. Seçilmez ise Vade olarak tüm borç ve
									 alacak karakterli işlemlerin ortalama vadesini yazar. Borç Alacak Dökümündeki Ortalama Vade gibi
									  çalışır. Seçilmesi önerilir. İşlemin tamamlanma süresi cari sayısına ve c,d,e,f,g maddelerinin 
									  seçimine göre değişir.">
									<br/><br/>b-<cf_get_lang dictionary_id="847.Ödenmemiş Çek\Senetleri Aktarma seçerseniz; seçtiğiniz dönemdeki ödenmemiş çek senetler, 
									dikkate alınmadan bakiyeler ve vadeler hesaplanır. Çek ve Senetleri devrederken carileştiren firmalar içindir.">
									<br/><br/>c-<cf_get_lang dictionary_id="848.Kur Fiş Tarihinden Alınsın seçerseniz; aktarım İşlem Dövizli yapılıyorsa, seçtiğiniz
									dönemdeki dövizli bakiyelerin TL karşılıkları fiş tarihindeki kura göre tekrar hesaplanarak yeni
									 döneme aktarılır.">
									<br/><br/>d-<cf_get_lang dictionary_id="849.İşlem Dövizli Seçilirse ; seçtiğiniz dönemdeki bakiyeler işlem dövizli olarak yeni
									döneme aktarılır. Seçilmez ise Sistem Para Biriminden aktarılır. Dövizli Borç/Alacak takip eden
									 firmalar içindir.">
									<br/><br/>e-<cf_get_lang dictionary_id="850.Proje Bazında ; seçtiğiniz dönemdeki bakiyeler yeni döneme aktarılırken proje bazında 
									aktarılır. Proje bazlı Borç / Alacak takibi yapan firmalar içindir.">
									<br/><br/>f-<cf_get_lang dictionary_id="851.Şube Bazında ; seçtiğiniz dönemdeki bakiyeler yeni döneme aktarılırken şube bazında aktarılır.
									Şube bazlı Borç / Alacak takibi yapan firmalar içindir.">
									<br/><br/>g-<cf_get_lang dictionary_id="852.Satır Bazında ; seçtiğiniz dönemdeki bakiyeler yeni döneme aktarılırken satır bazında aktarılır.
									Seçtiğiniz dönemde ödeme performansına göre ne kadar açık satır varsa olduğu gibi aktarılır.
									 Ödeme Peformansına Göre Hesapla seçili olmalıdır.">
								
								<br/><br/>2-<cf_get_lang no='2898.Eğer dosyadan aktar seçerseniz; seçtiğiniz dönem için açılış fişi dosyanıza uygun olarak yeniden düzenlenecektir'>.<cf_get_lang no='2900.Ayrıca, açılış fişlerini sil seçeneğini kaldırarak ve fiş tarihi girerek dönem açılışlarından sonra da açılış fişleri oluşturabilirsiniz'>. <br/>
								<br/><cf_get_lang dictionary_id="853.d,e,f maddeleri Dosyadan Aktarım için de geçerlidir.
								Satır bazında aktararak için aynı cari için birden fazla devir bakiyesi girilebilir.">
								<br/><br/>
								<font class="txtboldblue"><cf_get_lang no='1290.Dosya Satır Formatı'> :</font> <br/>"<cf_get_lang no='2901.Üye Kodu,B/A,Sistem Para Birimi Karşılık Tutarı (float), Sistem İkinci Döviz Birimi,Sistem İkinci Döviz Tutarı(float), İşlem Döviz Tutarı (float), İşlem Döviz Birimi, Ödeme Tarihi(dd/mm/yyyy),Proje ID si,Şube ID si" şeklinde olmalıdır'>.<br/><br/> <cf_get_lang no='2903.Dosya satırlarında Sistem İkinci Dövizi ve Tutarı, İşlem Döviz Tutarı, İşlem Döviz Birimi veya Ödeme Tarihi bilgilerinden verilmeyecek olanların yerine 0(sıfır) yazılmalıdır Proje ID ve Şube ID si kullanılmayacaksa boş bırakılabilir'><br/><br/>
								<font color=red> <cf_get_lang no='2904.Örnek Format'> : </font><br/>
								<cf_get_lang no='2905.45654,B,1000,USD,500,1000,YTL,28/02/2007,8--------------------YTL islem dövizi bakiye için'> <br/>
								<cf_get_lang no='2906.B12255,B,1400 32,USD,500,1000,USD,28/02/2007,8-----------------USD islem dövizi bakiye için'> <br/>
								<cf_get_lang no='2907.E-1256,B,1800 53,USD,500,1000,EURO,28/02/2007----------------Euro islem dövizi bakiye için'> <br/>
							</td>
						</tr>
						<!---Yardım Dosya yolu eklenecek--->
						<!---<cfinclude template="#file_web_path#templates/period_help/filename_#session.ep.language#.html">--->
						<cfcatch>
							<script type="text/javascript">
								alert("<cf_get_lang_main no='1963.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
							</script>
						</cfcatch>
					</cftry>
				</td>
				
			</tr>
			<tr>
				<td valign="top">
					<br/>1-<cf_get_lang no='2888.Eğer dönemden aktar seçerseniz'>; <cf_get_lang no='2890.seçtiğiniz dönemin mevcut bakiyeleri seçtiğiniz koşullarla ilgili şirketin o dönemden sonraki ilk dönemine aktarılır'>.<br/>
						<br/>a-<cf_get_lang dictionary_id="846.Ödeme Performansına Göre Hesapla seçerseniz; önceki dönemdeki açık
						işlemlerin vadeleri ödeme performansına göre hesaplanarak aktarılır. Seçilmez ise Vade olarak tüm borç ve
						alacak karakterli işlemlerin ortalama vadesini yazar. Borç Alacak Dökümündeki Ortalama Vade gibi çalışır.
						Seçilmesi önerilir. İşlemin tamamlanma süresi cari sayısına ve  c,d,e,f,g maddelerinin seçimine göre değişir.">
						<br/><br/>b-<cf_get_lang dictionary_id="847.Ödenmemiş Çek\Senetleri Aktarma seçerseniz; seçtiğiniz dönemdeki ödenmemiş çek senetler,
						dikkate alınmadan bakiyeler ve vadeler hesaplanır.Çek ve Senetleri devrederken carileştiren firmalar içindir.">
						<br/><br/>c-<cf_get_lang dictionary_id="848.Kur Fiş Tarihinden Alınsın seçerseniz; aktarım İşlem Dövizli yapılıyorsa,
						seçtiğiniz dönemdeki dövizli bakiyelerin TL karşılıkları fiş tarihindeki kura göre tekrar hesaplanarak yeni döneme aktarılır.">
						<br/><br/>d-<cf_get_lang dictionary_id="849.İşlem Dövizli Seçilirse ; seçtiğiniz dönemdeki bakiyeler işlem dövizli olarak yeni döneme aktarılır.
						Seçilmez ise Sistem Para Biriminden aktarılır. Dövizli Borç/Alacak takip eden firmalar içindir.">
						<br/><br/>e-<cf_get_lang dictionary_id="850.Proje Bazında ; seçtiğiniz dönemdeki bakiyeler yeni döneme aktarılırken proje bazında aktarılır.
						Proje bazlı Borç / Alacak takibi yapan firmalar içindir.">
						<br/><br/>f-<cf_get_lang dictionary_id="851.Şube Bazında ; seçtiğiniz dönemdeki bakiyeler yeni döneme aktarılırken şube bazında aktarılır.
						Şube bazlı Borç / Alacak takibi yapan firmalar içindir.">
						<br/><br/>g-<cf_get_lang dictionary_id="852.Satır Bazında ; seçtiğiniz dönemdeki bakiyeler yeni döneme aktarılırken satır bazında aktarılır.
						Seçtiğiniz dönemde ödeme performansına göre ne kadar açık satır varsa olduğu gibi aktarılır.Ödeme Performansına Göre Hesapla seçili olmalıdır.">
					
					<br/><br/>2-<cf_get_lang no='2898.Eğer dosyadan aktar seçerseniz; seçtiğiniz dönem için açılış fişi dosyanıza uygun olarak yeniden düzenlenecektir'>.<cf_get_lang no='2900.Ayrıca, açılış fişlerini sil seçeneğini kaldırarak ve fiş tarihi girerek dönem açılışlarından sonra da açılış fişleri oluşturabilirsiniz'>. <br/>
					<br/><cf_get_lang dictionary_id="853.d,e,f maddeleri Dosyadan Aktarım için de geçerlidir. Satır bazında aktarak için aynı cari için birden fazla devir bakiyesi
					girilebilir.">
					<br/><br/>
					<font class="txtboldblue"><cf_get_lang no='1290.Dosya Satır Formatı'> :</font> <br/>"<cf_get_lang no='2901.Üye Kodu,B/A,Sistem Para Birimi Karşılık Tutarı (float), Sistem İkinci Döviz Birimi,Sistem İkinci Döviz Tutarı(float), İşlem Döviz Tutarı (float), İşlem Döviz Birimi, Ödeme Tarihi(dd/mm/yyyy),Proje ID si,Şube ID si" şeklinde olmalıdır'>.<br/><br/> <cf_get_lang no='2903.Dosya satırlarında Sistem İkinci Dövizi ve Tutarı, İşlem Döviz Tutarı, İşlem Döviz Birimi veya Ödeme Tarihi bilgilerinden verilmeyecek olanların yerine 0(sıfır) yazılmalıdır Proje ID ve Şube ID si kullanılmayacaksa boş bırakılabilir'><br/><br/>
					<font color=red> <cf_get_lang no='2904.Örnek Format'> : </font><br/>
					<cf_get_lang no='2905.45654,B,1000,USD,500,1000,YTL,28/02/2007,8--------------------YTL islem dövizi bakiye için'> <br/>
					<cf_get_lang no='2906.B12255,B,1400 32,USD,500,1000,USD,28/02/2007,8-----------------USD islem dövizi bakiye için'> <br/>
					<cf_get_lang no='2907.E-1256,B,1800 53,USD,500,1000,EURO,28/02/2007----------------Euro islem dövizi bakiye için'> <br/>
				</td>
			</tr>
		</table
	</cf_area>
</cf_form_box>
<script type="text/javascript">
	function kontrol()
	{
		if(!chk_process_cat('close_ch')) return false;
		alert_info = "<cf_get_lang no='2045.Seçtiğiniz dönemdeki cari hesap bakiyelerini yeni döneme açılış fişi olarak aktarmak üzeresiniz Onaylıyor musunuz'>?";
		if(document.close_ch.period.value == '')
		{
			alert("<cf_get_lang no='1291.Dönem Seçmelisiniz'>!");
			return false;
		}
		if(document.close_ch.is_make_age != undefined && document.close_ch.is_make_age.checked == true && document.close_ch.is_branch_transfer.checked == true && document.close_ch.is_row_info.checked == false)
		{
			alert("<cf_get_lang dictionary_id="862.Ödeme Performansında Şube Bazında Aktarım Yapmak İçin Satır Bazında Aktarım Yapmalısınız"> !");
			return false;
		}
		if(document.close_ch.is_make_age_manuel != undefined && document.close_ch.is_make_age_manuel.checked == true && (document.close_ch.is_other_money_transfer.checked == false || document.close_ch.is_row_info.checked == false))
		{
			alert("<cf_get_lang dictionary_id="863.Manuel Ödeme Performansında İşlem Dövizi ve Satır Bazında Seçenekleri Seçili Olmalıdır"> !");
			return false;
		}
		if(document.close_ch.check_date_rate.checked == true && document.close_ch.action_date_rate.value == '')
		{
			alert(" <cf_get_lang dictionary_id="864.Fiş Tarihi Seçmelisiniz">!");
			return false
		}
		if(document.close_ch.is_from_donem.value == 0)
		{
			if(list_getat(document.close_ch.action_date_rate.value,3,'/') != list_getat(document.close_ch.period.value,2,';'))
			{
				alert("<cf_get_lang dictionary_id="29539.Fiş Tarihi Aktarım Yapılacak Dönem İçerisinde Olmalı">!");
				return false
			}
		}
		else
		{
			if(list_getat(document.close_ch.action_date_rate.value,3,'/') != parseFloat(list_getat(document.close_ch.period.value,2,';'))+1)
			{
				alert("<cf_get_lang dictionary_id="865.Fiş Tarihi Aktarım Yapılacak Dönem İçerisinde Olmalı">!");
				return false
			}
		}
		if((document.close_ch.is_from_donem.value == 0) && (document.close_ch.cari_file.value == ''))
		{
			alert("<cf_get_lang no='1292.Dosya Seçmelisiniz'>!");
			return false;
		}
		if (confirm(alert_info)) 
		{
			windowopen('','small','cc_che');
			close_ch.action='<cfoutput>#request.self#?fuseaction=settings.emptypopup_close_ch</cfoutput>';
			close_ch.target='cc_che';
			close_ch.submit();
			return false;
		}
		else 
			return false;
	}
	function check_row_info(type)
	{
		if(type== 1 && document.close_ch.is_make_age.checked == true)
			document.close_ch.is_make_age_manuel.checked = false;
		else if(type== 2 && document.close_ch.is_make_age_manuel.checked == true)
			document.close_ch.is_make_age.checked = false;
		if(document.close_ch.is_make_age.checked == true || document.close_ch.is_make_age_manuel.checked == true)
			create_file2.style.display = '';
		else
			create_file2.style.display = 'none';
		if(document.close_ch.is_make_age_manuel.checked == true)
			close_demand.style.display = '';
		else
			close_demand.style.display = 'none';
	}
	function show_options_info(table_type_info)
	{
		if(table_type_info == 'from_period')
		{
			document.close_ch.is_from_donem.value = 1;
			from_period.style.display = '';
			<cfif is_select_ch eq 1>
				from_period2.style.display = '';
			</cfif>
			<cfif is_select_ch_cat eq 1 and not isdefined("attributes.is_employee")>
				from_period3.style.display = '';
			</cfif>
			from_file.style.display = 'none';
			general_options.style.display = '';
		}
		else if(table_type_info == 'from_file')
		{
			document.close_ch.is_from_donem.value = 0;
			from_period.style.display = 'none';
			<cfif is_select_ch eq 1>
				from_period2.style.display = 'none';
			</cfif>
			<cfif is_select_ch_cat eq 1 and not isdefined("attributes.is_employee")>
				from_period3.style.display = 'none';
			</cfif>
			from_file.style.display = '';
			general_options.style.display = '';
		}
	}
</script>
