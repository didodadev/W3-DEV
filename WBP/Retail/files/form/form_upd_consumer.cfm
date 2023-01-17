<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="member.form_add_consumer">
<cf_get_lang_set module_name="member">
<cfif isDefined('session.ep.member_view_control') and session.ep.member_view_control eq 1>
	<cfquery name="view_control" datasource="#dsn#">
		SELECT
			IS_MASTER
		FROM
			WORKGROUP_EMP_PAR
		WHERE
			CONSUMER_ID = #attributes.cid# AND
			OUR_COMPANY_ID = #session.ep.company_id# AND
			POSITION_CODE = #session.ep.position_code#
	</cfquery>
	<cfif not view_control.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='459.Bu Üyeyi Görmek İçin Yetkiniz Yok'>");
			history.back();
		</script>
	</cfif>
</cfif>
<cfif isnumeric(attributes.cid)>
	<cfinclude template="/member/query/get_consumer.cfm">
<cfelse>
	<cfset get_consumer.recordcount = 0>
</cfif>
<cfif not get_consumer.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='589.Böyle Bir Üye Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfinclude template="../../objects/display/imageprocess/imcontrol.cfm">
	<cfset session.resim = 1>
	<cfinclude template="/member/query/get_company_cat.cfm">
	<cfinclude template="/member/query/get_im.cfm">
	<cfinclude template="/member/query/get_bank_cons.cfm">
	<cfinclude template="/member/query/get_company_size.cfm">
	<cfinclude template="/member/query/get_partner_positions.cfm">
	<cfinclude template="/member/query/get_partner_departments.cfm">
	<cfinclude template="/member/query/get_societies.cfm">
	<cfinclude template="/member/query/get_income_level.cfm">
	<cfinclude template="/member/query/get_country.cfm">
	<cfinclude template="/member/query/get_consumer_value.cfm">
	<cfinclude template="/member/query/get_edu_level.cfm">

	<cfquery name="GET_WORK_POS" datasource="#DSN#">
		SELECT
			CONSUMER_ID,
			OUR_COMPANY_ID,
			POSITION_CODE,
			IS_MASTER
		FROM
			WORKGROUP_EMP_PAR
		WHERE
			CONSUMER_ID IS NOT NULL AND
			CONSUMER_ID = #attributes.cid# AND
			OUR_COMPANY_ID = #session.ep.company_id# AND
			IS_MASTER = 1
	</cfquery>
	<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1>
		<cfquery name="get_zone_kontrol" datasource="#dsn#">
			SELECT
				SZ.CITY_ID
			FROM
				SALES_ZONES S,
				SALES_ZONE_GROUP SG,
				SALES_ZONES_TEAM SZ,
				SALES_ZONES_TEAM_ROLES SZR
			WHERE
				S.SZ_ID = SG.SZ_ID AND
				S.SZ_ID = SZ.SALES_ZONES AND
				SZ.TEAM_ID = SZR.TEAM_ID AND
				(SZ.LEADER_POSITION_CODE = #session.ep.position_code# OR SZR.POSITION_CODE = #session.ep.position_code# OR SG.POSITION_CODE = #session.ep.position_code#) AND
				SZ.CITY_ID IS NOT NULL
		</cfquery>
		<cfif get_zone_kontrol.recordcount>
			<cfset kontrol_zone = ''>
			<cfoutput query="get_zone_kontrol">
				<cfquery name="get_city_code" datasource="#dsn#">
					SELECT PLATE_CODE FROM SETUP_CITY WHERE CITY_ID =#get_zone_kontrol.city_id#
				</cfquery>
				<cfif get_city_code.plate_code eq 34>
					<cfquery name="get_citys" datasource="#dsn#">
						SELECT CITY_ID FROM SETUP_CITY WHERE PLATE_CODE ='#get_city_code.plate_code#'
					</cfquery>
					<cfloop query="get_citys">
						<cfset kontrol_zone = listappend(kontrol_zone,get_citys.city_id,',')>
					</cfloop>
				<cfelse>
					<cfset kontrol_zone = listappend(kontrol_zone,get_zone_kontrol.city_id,',')>
				</cfif>
			</cfoutput>
		<cfelse>
			<cfset kontrol_zone = -1>
		</cfif>
	</cfif>
	<cfset consumer = get_consumer.consumer_name & ' ' & get_consumer.consumer_surname>
	<!--- Sayfa başlığı ve ikonlar --->
	<table class="dph">
		<tr>
			<td class="dpht">
				<cfinclude template="detail_consumer_head.cfm">
			</td>
			<td class="dphb">
				<cfinclude template="detail_consumer_icons.cfm">
			</td>
		</tr>
	</table>
	<!--- Sayfa ana kısım  --->
	<table class="dpm">
		<tr>
			<td valign="top" class="dpml">
				<!---Geniş alan: içerik---> 
				<cfinclude template="detail_consumer_content.cfm">
			</td>
			<td valign="top" class="dpmr">
				<!--- Yan kısım--->
				<cfinclude template="upd_consumer_right.cfm">
			</td>
		</tr>
	</table>
	<script type="text/javascript">
		function sayfa_getir()
		{
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=member.emptypopup_create_password','SHOW_PASSWORD',1);
		}
		<cfif isdefined("is_adres_detail")>
			var is_adres_detail = '<cfoutput>#is_adres_detail#</cfoutput>';
		<cfelse>
			var is_adres_detail = 0;
		</cfif>
		<cfif isdefined("is_residence_select")>
			var is_residence_select = '<cfoutput>#is_residence_select#</cfoutput>';
		<cfelse>
			var is_residence_select = 0;
		</cfif>
		
		<cfif isdefined("is_req_reference_member")>
			var is_req_reference_member = '<cfoutput>#is_req_reference_member#</cfoutput>';
		<cfelse>
			var is_req_reference_member = 0;
		</cfif>
		<cfif isdefined("is_dsp_reference_member")>
			var is_dsp_reference_member = '<cfoutput>#is_dsp_reference_member#</cfoutput>';
		<cfelse>
			var is_dsp_reference_member = 0;
		</cfif>
		<cfif isdefined("is_dsp_category")>
			var is_dsp_category = '<cfoutput>#is_dsp_category#</cfoutput>';
		<cfelse>
			var is_dsp_category = 0;
		</cfif>
		<cfif isdefined("is_dsp_personal_info")>
			var is_dsp_personal_info = '<cfoutput>#is_dsp_personal_info#</cfoutput>';
		<cfelse>
			var is_dsp_personal_info = 0;
		</cfif>
		<cfif isdefined("is_dsp_homeaddress_info")>
			var is_dsp_homeaddress_info = '<cfoutput>#is_dsp_homeaddress_info#</cfoutput>';
		<cfelse>
			var is_dsp_homeaddress_info = 0;
		</cfif>
		<cfif isdefined("is_dsp_workaddress_info")>
			var is_dsp_workaddress_info = '<cfoutput>#is_dsp_workaddress_info#</cfoutput>';
		<cfelse>
			var is_dsp_workaddress_info = 0;
		</cfif>
		<cfif isdefined("is_dsp_photo")>
			var is_dsp_photo = '<cfoutput>#is_dsp_photo#</cfoutput>';
		<cfelse>
			var is_dsp_photo = 0;
		</cfif>
		<cfif isdefined("is_invoice_info_detail")>
			var is_invoice_info_detail = '<cfoutput>#is_invoice_info_detail#</cfoutput>';
		<cfelse>
			var is_invoice_info_detail = 0;
		</cfif>
		<cfif isdefined("is_birthday")>
			var is_birthday = '<cfoutput>#is_birthday#</cfoutput>';
		<cfelse>
			var is_birthday = 0;
		</cfif>
		<cfif isdefined("is_home_telephone")>
			var is_home_telephone = '<cfoutput>#is_home_telephone#</cfoutput>';
		<cfelse>
			var is_home_telephone = 0;
		</cfif>
		<cfif isdefined("is_cari_working")>
			var is_cari_working = '<cfoutput>#is_cari_working#</cfoutput>';
		<cfelse>
			var is_cari_working = 0;
		</cfif>

		if(is_dsp_workaddress_info == 1)
		{
			var work_country_= document.upd_consumer.work_country.value;
			<cfif not len(get_consumer.work_city_id)>
				if(work_country_.length)
					LoadCity(work_country_,'work_city_id','work_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>)
			</cfif>

			var work_city_= document.upd_consumer.work_city_id.value;
			<cfif not len(get_consumer.work_county_id)>
				if(work_city_.length)
					LoadCounty(work_city_,'work_county_id')
			</cfif>

			if(document.upd_consumer.work_district_id != undefined)
			{
				var work_county_= document.upd_consumer.work_county_id.value;
				<cfif not len(get_consumer.work_district_id)>
					if(work_county_.length)
						LoadDistrict(work_county_,'work_district_id')
				</cfif>
			}
		}
		
		if(is_dsp_homeaddress_info == 1)
		{
			var home_country_= document.upd_consumer.home_country.value;
			<cfif not len(get_consumer.home_city_id)>
				if(home_country_.length)
					LoadCity(home_country_,'home_city_id','home_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>)
			</cfif>

			var home_city_= document.upd_consumer.home_city_id.value;
			<cfif not len(get_consumer.home_county_id)>
				if(home_city_.length)
					LoadCounty(home_city_,'home_county_id')
			</cfif>

			if(document.upd_consumer.home_district_id != undefined)
			{
				var home_county_= document.upd_consumer.home_county_id.value;
				<cfif not len(get_consumer.home_district_id)>
					if(home_county_.length)
						LoadDistrict(home_county_,'home_district_id')
				</cfif>
			}
		}
		
		var tax_country_= document.upd_consumer.tax_country.value;
		<cfif not len(get_consumer.tax_city_id)>
			if(tax_country_.length)
				LoadCity(tax_country_,'tax_city_id','tax_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>)
		</cfif>
		
		var tax_city_= document.upd_consumer.tax_city_id.value;
		<cfif not len(get_consumer.tax_county_id)>
			if(tax_city_.length)
				LoadCounty(tax_city_,'tax_county_id')
		</cfif>	
		
		if(document.upd_consumer.tax_district_id != undefined)
		{
			var tax_county_= document.upd_consumer.tax_county_id.value;
			<cfif not len(get_consumer.tax_district_id)>
				if(tax_county_.length)
					LoadDistrict(tax_county_,'tax_district_id')
			</cfif>
		}
		
		<cfif isdefined('attributes.sub_id')>
			if(<cfoutput>#attributes.sub_id#</cfoutput> != "")
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=sales.upd_subscription_contract&subscription_id=<cfoutput>#attributes.sub_id#</cfoutput>','list','upd_subscription_contract');//location.href=""
			}
		</cfif>	
		document.all.upload_status.style.display = 'none';
		function kontrol()
		{
			if(document.getElementById('consumer_name').value=='')
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='219.Ad'>");
				return false;
			}
			if(document.getElementById('consumer_surname').value=='')
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1314.Soyad'>");
				return false;
			}
			// uye kategorisi gorunsun mu
			if(is_dsp_category == 1 && document.upd_consumer.consumer_cat_id != undefined)
			{
				x = document.upd_consumer.consumer_cat_id.selectedIndex;
				if (document.upd_consumer.consumer_cat_id[x].value == "")
				{ 
					alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1197.Üye Kategorisi'>!");
					return false;
				}
			}
			<cfif xml_mobile_tel_required eq 1>
				if(document.getElementById('mobiltel').value=='')
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='116.Kod/ Mobil tel'>");
					return false;
				}
			</cfif>
			<cfif xml_only_numeric_password eq 1>
				if(isNaN(document.getElementById('consumer_password').value))
				{
					alert("<cf_get_lang no= '610.Lütfen Numeric Bir Şifre Değeri Giriniz'> !");
					return false;
				}
			</cfif>
			<cfif is_adres_detail eq 1>
			if((document.upd_consumer.coordinate_1.value.length != "" && document.upd_consumer.coordinate_2.value.length == "") || (document.upd_consumer.coordinate_1.value.length == "" && document.upd_consumer.coordinate_2.value.length != ""))
			{
				alert ("Lütfen koordinat değerlerini eksiksiz giriniz!");
				return false;
			}
			</cfif>
			
			<cfif isdefined("is_tc_number") and is_tc_number eq 1>
					var is_tc_number = 1;
			<cfelse>
				var is_tc_number = 0;
			</cfif>
			
			if(is_dsp_personal_info == 1 && is_tc_number == 1)
			{
				if(!isTCNUMBER(document.upd_consumer.tc_identity_no)) return false;
			}
			
			// uye kategorisi gorunsun mu
			if(is_dsp_category == 1)
			{
				x = document.upd_consumer.consumer_cat_id.selectedIndex;
				if (document.upd_consumer.consumer_cat_id[x].value == "")
				{ 
					alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='298.Bireysel Üye Kategori'>");
					return false;
				}
			}
			
			//referans uye gosterilsin mi // zorunlu olsun mu
			if(is_dsp_reference_member == 1 && is_req_reference_member == 1 && document.upd_consumer.ref_pos_code_name.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1224.Referans Üye'>!");
				document.getElementById('ref_pos_code_name').focus();				
				return false;
			}
			
			if(is_dsp_reference_member == 1)
			{
				if(<cfoutput>#session.ep.admin#</cfoutput> == 1 && document.upd_consumer.ref_pos_code.value != '' && document.upd_consumer.ref_pos_code_name.value == '')
				{
					if((document.upd_consumer.ref_pos_code_row != undefined && document.upd_consumer.ref_pos_code_row.value == '' && document.upd_consumer.is_upper_member.checked == false) || document.upd_consumer.ref_pos_code_row == undefined)
					{
						var get_consumer = wrk_safe_query('mr_get_consumer',"dsn",0,document.upd_consumer.consumer_id.value);
						if(get_consumer.recordcount)
						{
							alert("<cf_get_lang no ='515.Referans Üye Bağlantısını Kopardınız! İlgili Üyenin Referans Olduğu Üyeler İçin Referans Bilgisi Girmelisiniz'> !");
							document.upd_consumer.consumer_name.focus();
							document.getElementById('open_process').style.display ='';
							AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=member.emptypopup_add_reference_member','open_process',1);
							return false;
						}
					}
				}
				else if(<cfoutput>#session.ep.admin#</cfoutput> == 0 && document.upd_consumer.ref_pos_code.value != '' && document.upd_consumer.ref_pos_code_name.value == '')
					document.upd_consumer.is_upper_ref.value = 1;
				if(<cfoutput>#session.ep.admin#</cfoutput> == 1 && document.upd_consumer.hidden_reference_code.value != '' && document.upd_consumer.reference_code.value != document.upd_consumer.hidden_reference_code.value)
				{
					if((document.upd_consumer.ref_pos_code_row != undefined && document.upd_consumer.ref_pos_code_row.value == '' && document.upd_consumer.is_upper_member != undefined && document.upd_consumer.is_upper_member.checked == false && document.upd_consumer.is_ref_member != undefined && document.upd_consumer.is_ref_member.checked == false) || document.upd_consumer.ref_pos_code_row == undefined)
					{
						var get_consumer = wrk_safe_query('mr_get_consumer',"dsn",0,document.upd_consumer.consumer_id.value);
						if(get_consumer.recordcount)
						{
							alert("<cf_get_lang no ='514.Referans Üye Bağlantısını Değiştirdiniz! İlgili Üyenin Referans Olduğu Üyeler İçin Referans Bilgisi Girmelisiniz '>!");
							document.upd_consumer.ref_pos_code_name.focus();
							document.getElementById('open_process').style.display ='';
							AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=member.emptypopup_add_reference_member&is_upd=1','open_process',1);
							return false;
						}
					}
				}
				else if(<cfoutput>#session.ep.admin#</cfoutput> == 1 && document.upd_consumer.hidden_reference_code.value != '' && document.upd_consumer.reference_code.value != document.upd_consumer.hidden_reference_code.value)
					document.upd_consumer.is_upper_ref.value = 1;
			}
			
			//fatura bilgileri zorunlu olsun mu
			if(is_invoice_info_detail == 1)
			{
				if(document.upd_consumer.tax_office.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1350.vergi dairesi'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_office').focus();					
					return false;
				}
				if(document.upd_consumer.tax_no.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='340.vergi no'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_no').focus();					
					return false;
				}
				if(document.upd_consumer.tax_postcode.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='60.posta kodu'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_postcode').focus();					
					return false;
				}
				if(document.upd_consumer.tax_country.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='807.ülke'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					return false;
				}
				
				if(document.upd_consumer.tax_city_id.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='559.şehir'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					return false;
				}
				
				if(document.upd_consumer.tax_county_id.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1226.ilçe'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					return false;
				}
				if(document.upd_consumer.tax_semt.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='720.semt'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_semt').focus();
					return false;
				}
				if(is_adres_detail == 0)
				{
					if(document.upd_consumer.tax_address.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='123.fatura adresi'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_address').focus();						
						return false;
					}
				}
				else if(is_adres_detail == 1)
				{
					if((is_residence_select == 0 && document.upd_consumer.tax_district.value == "") || (is_residence_select == 1 && document.upd_consumer.tax_district_id.value == ""))
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1323.mahalle'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						if(is_residence_select == 0)
						{
							document.getElementById('tax_district').focus();							
						}
						return false;
					}
					if(document.upd_consumer.tax_main_street.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='491.cadde'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_main_street').focus();
						return false;
					}
					if(document.upd_consumer.tax_street.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='492.sokak'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_street').focus();
						return false;
					}
					if(document.upd_consumer.tax_door_no.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='75.no'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_door_no').focus();						
						return false;
					}
				}
			}
			//dogum tarihi zorunlu olsun mu (kisisel bilgiler varsa)
			if(is_dsp_personal_info == 1 && is_birthday == 1 && document.upd_consumer.birthdate.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1315.Doğum Tarihi!'>!");
				document.getElementById('birthdate').focus();
				return false;
			}
			//Evlilik durumu kontrolleri (kisisel bilgiler varsa)
			/* Evlilik tarihi zorunlulugu kaldirildi, evli oldugu bilinip tarihi bilinmeyen uyeler mevcut, 120 gune silinsin fbs 20100621
			if(is_dsp_personal_info == 1 && (document.upd_consumer.married.checked == true && document.upd_consumer.married_date.value == ''))
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='2114.Evlilik Tarihi'>!");
				document.getElementById('married_date').focus();
				return false;
			}
			*/
			if(is_dsp_personal_info == 1 && (document.upd_consumer.married.checked == false && document.upd_consumer.married_date.value != ''))
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='375.Medeni Durumu'>!");
				document.getElementById('married_date').focus();
				return false;
			}
			
			//ev telefonu zorunlu olsun mu (kisisel bilgiler varsa)
			if(is_dsp_homeaddress_info == 1 && is_home_telephone == 1)
			{
				if(document.upd_consumer.home_telcode.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='178.Telefon Kodu'>!");
					document.getElementById('home_telcode').focus();
					return false;
				}
				if(document.upd_consumer.home_tel.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='1402.Telefon no'>!");
					document.getElementById('home_tel').focus();
					return false;
				}
			}
			
			if(is_cari_working == 1)
			{
				if(document.upd_consumer.is_cari.checked == false)
				{
					alert("Çalışılabilir Alanı Seçili Olmalıdır !");
					return false;
				}
			}	
			
			if(document.upd_consumer.work_address != undefined)
			{
				y = (75 - document.upd_consumer.work_address.value.length);
				if ( y < 0 )
				{ 
					alert ("<cf_get_lang no='469.İş Adresi'><cf_get_lang_main no='798.Alanındaki Fazla Karakter Sayısı'>"+ ((-1) * y));
					return false;
				}
			}
			if(document.upd_consumer.home_address != undefined)
			{
				z = (750 - document.upd_consumer.home_address.value.length);
				if ( z < 0 )
				{ 
					alert ("<cf_get_lang no='468.Ev Adresi'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayısı'>"+ ((-1) * z));
					return false;
				}
			}
			if(document.upd_consumer.tax_address != undefined)
			{
				v = (750 - document.upd_consumer.tax_address.value.length);
				if ( v < 0 )
				{ 
					alert ("<cf_get_lang no='123.Fatura Adresi'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayısı'>"+ ((-1) * v));
					return false;
				}
			}
			// is_zone_info Dore firması icin eklendi BK 20101028
			<cfif session.ep.our_company_info.sales_zone_followup eq 1 and not isdefined("attributes.is_zone_info")>	
			if(document.upd_consumer.sales_county!=undefined)
			{
				x = document.upd_consumer.sales_county.selectedIndex;
				if (document.upd_consumer.sales_county[x].value == "")
				{ 
					alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='247.Satış Bölgesi '>");
					return false;
				}
				if(document.upd_consumer.ims_code_id.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='722.Micro Bölge Kodu'>");
					return false;
				}
				}
			</cfif>			
			if(is_dsp_photo == 1)
			{
				var obj =  document.upd_consumer.picture.value;
				if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
				{
					alert("<cf_get_lang no='197.Lütfen bir resim dosyası(gif,jpg veya png) giriniz !'>");
					return false;
				}
				else if ((obj != "") && ((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
					document.all.upload_status.style.display = '';
			}
			<cfif xml_check_cell_phone eq 1>
				if(document.getElementById('mobilcat_id').value != "" && document.getElementById('mobiltel').value != "")
				{
					
					var listParam = document.getElementById('consumer_id').value + "*" +document.getElementById('mobilcat_id').value + "*" + document.getElementById('mobiltel').value;
					var get_results = wrk_safe_query('mr_upd_cell_phone',"dsn",0,listParam);
					if(get_results.recordcount>0)
					{
						  alert("Girdiginiz Cep Telefonuna Kayitli Baska Temsilci Bulunmaktadir!");
						  document.getElementById('mobiltel').focus();
						  return false;
					}              
				}
			</cfif>
			<cfif xml_use_efatura>
				document.getElementById('use_efatura').disabled = false;
			</cfif>
			process_cat_control()
		}
		function kontrol_ref_member(type)
		{
			if(type == 0)
			{
				kontrol_inf = 0;
				if(document.upd_consumer.consumer_id.value == document.upd_consumer.ref_pos_code.value)
				{
					alert("<cf_get_lang no ='513.Üyeyi Kendisi İçin Referans Üye Olarak Ekleyemezsiniz'> !");
					kontrol_inf = 1;
				}
				if(kontrol_inf == 0)
				{
					var get_consumer = wrk_safe_query('mr_get_consumer',"dsn",0,document.upd_consumer.ref_pos_code.value);
					if(get_consumer.recordcount)
					{	
						if(list_find(get_consumer.CONSUMER_REFERENCE_CODE[0],document.upd_consumer.consumer_id.value,'.'))
						{
							alert("<cf_get_lang no ='512.Üyeyi Referans Olduğu Üyeye Bağlayamazsınız'> !");
							kontrol_inf = 1;
						}
					}
				}
				if(kontrol_inf == 1)
				{
					document.upd_consumer.ref_pos_code.value = '';
					document.upd_consumer.ref_pos_code_name.value = '';
					document.upd_consumer.reference_code.value = '';
					document.upd_consumer.dsp_reference_code.value = '';
				}
			}
			else
			{
				kontrol_ = 0;
				if(document.upd_consumer.consumer_id.value == document.upd_consumer.ref_pos_code_row.value)
				{
					alert("<cf_get_lang no ='513.Üyeyi Kendisi İçin Referans Üye Olarak Ekleyemezsiniz'> !");
					kontrol_ = 1;
				}
				if(kontrol_ == 0)
				{
					var get_consumer =  wrk_safe_query('mr_get_consumer',"dsn",0,document.upd_consumer.ref_pos_code_row.value);								
					if(get_consumer.recordcount)
					{	
						if(list_find(get_consumer.CONSUMER_REFERENCE_CODE[0],document.upd_consumer.consumer_id.value,'.'))
						{
							alert("<cf_get_lang no ='512.Üyeyi Referans Olduğu Üyeye Bağlayamazsınız'> !");
							kontrol_ = 1;
						}
					}
				}
				if(kontrol_ == 1)
				{
					document.upd_consumer.ref_pos_code_row.value = '';
					document.upd_consumer.ref_pos_code_name_row.value = '';
					document.upd_consumer.reference_code_row.value = '';
					document.upd_consumer.dsp_reference_code_row.value = '';
				}
			}	
		}
		
		function LoadPhone(x,y)
		{
			if(x != '')
			{
				get_phone_no = wrk_safe_query("mr_get_phone_no","dsn",0,x);
				if(get_phone_no.COUNTRY_PHONE_CODE != undefined && get_phone_no.COUNTRY_PHONE_CODE != '')
					document.getElementById('load_phone_'+y).innerHTML = '(' + get_phone_no.COUNTRY_PHONE_CODE + ')';
				else
					document.getElementById('load_phone_'+y).innerHTML = '';
			}
			else
				document.getElementById('load_phone_'+y).innerHTML = '';
		}
		function get_ims_code(type)
		{
			if(type == 1)
			{
				get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('home_district_id').value);
				get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('home_district_id').value);
				if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
				{		
					document.getElementById('home_semt').value=get_ims_code_.PART_NAME;
					document.getElementById('home_postcode').value=get_ims_code_.POST_CODE;
				}
				else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
				{
					document.getElementById('home_semt').value = get_district_.PART_NAME;
					document.getElementById('home_postcode').value = get_district_.POST_CODE;
				}
				else
				{
					document.getElementById('home_semt').value = '';
					document.getElementById('home_postcode').value = '';
				}
			}
			else if(type == 2)
			{
				get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('work_district_id').value);
				get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('work_district_id').value);
				if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
				{		
					document.getElementById('work_semt').value=get_ims_code_.PART_NAME;
					document.getElementById('work_postcode').value=get_ims_code_.POST_CODE;
				}
				else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
				{
					document.getElementById('work_semt').value = get_district_.PART_NAME;
					document.getElementById('work_postcode').value = get_district_.POST_CODE;
				}
				else
				{
					document.getElementById('work_semt').value = '';
					document.getElementById('work_postcode').value = '';
				}
			}
			else
			{
				get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('tax_district_id').value);
				get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('tax_district_id').value);
				if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
				{		
					document.getElementById('tax_semt').value=get_ims_code_.PART_NAME;
					document.getElementById('tax_postcode').value=get_ims_code_.POST_CODE;
				}
				else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
				{
					document.getElementById('tax_semt').value = get_district_.PART_NAME;
					document.getElementById('tax_postcode').value = get_district_.POST_CODE;
				}
				else
				{
					document.getElementById('tax_semt').value = '';
					document.getElementById('tax_postcode').value = '';
				}
			}
		}
		upd_consumer.consumer_name.focus();
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">