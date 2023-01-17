<cf_xml_page_edit fuseact="member.detail_company" is_multi_page="1">
<cfscript>
	einvoice_control= createObject("component","V16.e_government.cfc.einvoice");
	einvoice_control.dsn = dsn;
	get_einvoice = einvoice_control.get_einvoice_fnc();
</cfscript>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfif session.ep.member_view_control eq 1>
	<cfset VIEW_CONTROL = company_cmp.VIEW_CONTROL(cpid:attributes.cpid)>
	<cfif not view_control.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='30597.Bu Üyeyi Görmek İçin Yetkiniz Yok'>");
			history.back();
		</script>
	</cfif>
</cfif>
<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined('attributes.cpid') and isnumeric(attributes.cpid)>
	<cfset GET_COMPANYCAT = company_cmp.GET_COMPANYCAT()>
	<cfset company_cat_list = valuelist(get_companycat.companycat_id,',')>
	<cfset GET_OURCMP_INFO = company_cmp.GET_OURCMP_INFO()>
	<cfscript>
		get_company = company_cmp.get_company_list_fnc(
			cpid : '#iif(isdefined("attributes.cpid"),"attributes.cpid",DE(""))#',
			is_store_followup :'#iif(isdefined("get_ourcmp_info.is_store_followup"),"get_ourcmp_info.is_store_followup",DE(""))#' ,
			company_cat_list : '#iif(isdefined("company_cat_list"),"company_cat_list",DE(""))#' ,
			row_block : '#iif((session.ep.our_company_info.sales_zone_followup eq 1),"500",DE(""))#'
		);
		</cfscript>
<cfelse>
	<cfset get_company.recordcount = 0>
</cfif>
<cfif not get_company.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58001.Böyle Bir Üye Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfset GET_WORK_POS = company_cmp.GET_WORK_POS(cpid:attributes.cpid)>

	<cfif isdefined("attributes.type")>
		<cfset GET_COMPANYCAT = company_cmp.GET_COMPANYCAT_TYPE()>
	<cfelse>
		<cfset GET_COMPANYCAT = company_cmp.GET_COMPANYCAT()>
	</cfif>

	<cfset get_partner_ = company_cmp.get_partner_(cpid:attributes.cpid)>

	<cfset GET_COMPANY_SIZE = company_cmp.GET_COMPANY_SIZE()>
	<cfset GET_COUNTRY = company_cmp.GET_COUNTRY_()>
	<cfset GET_COMPANY_SECTOR = company_cmp.GET_COMPANY_SECTOR()>
	<cfset GET_CUSTOMER_VALUE = company_cmp.GET_CUSTOMER_VALUE()>

	<cfset getProductCat = createObject("component","V16.worknet.query.worknet_member").getProductCat(company_id:attributes.cpid) />
	<cfset getRelatedBrands = createObject("component","V16.member.cfc.setupRelatedBrands").getRelatedBrands(company_id:attributes.cpid) />
	<cfset GET_PARTNER_ID = company_cmp.GET_PARTNER_ID(cpid:attributes.cpid)>
	
	<cfset GET_USER_URL = company_cmp.GET_USER_URL(cpid:attributes.cpid)>

	<cfset GET_COMPANYCAT_ID = company_cmp.GET_COMPANYCAT_ID(cpid:attributes.cpid)>

	<cfif get_partner_id.recordcount>
		<cfset par_ids = valuelist(get_partner_id.partner_id)>
		<cfset DENIED_PAGE = company_cmp.DENIED_PAGE(par_ids:par_ids, companycat_id:get_companycat_id.companycat_id)>
	</cfif>
	<!--- Sayfa başlığı ve ikonlar --->
	<cfif not fusebox.circuit eq 'crm' >
    	<cf_catalystHeader>
	</cfif>
    <div class="row"> 
    	<div class="col col-9 col-xs-12 uniqueRow" id="content">
			<!--- Sayfa ana kısım  --->
            <cfinclude template="detail_company_content.cfm">
        </div>
        <div class="col col-3 col-xs-12 uniqueRow" id="side">
            <!--- Yan kısım--->
            <cfinclude template="detail_company_side.cfm">
        </div>
    </div>
	<script type="text/javascript">
		function connectAjax(div_id,data,assetpId)
		{
			if (div_id == 'LIST_COMPANY_PARTNERS')//sistem
				var page = '<cfoutput>#request.self#?fuseaction=member.popupajax_my_company_partners&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#</cfoutput>';
			if (div_id == 'LIST_MY_COMPANY_SYSTEMS')//sistem
				var page = '<cfoutput>#request.self#?fuseaction=member.popupajax_my_company_systems&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#</cfoutput>';
			if (div_id == 'ADD_MY_COMPANY_SYSTEMS')//sistem ekle
				var page = '<cfoutput>#request.self#?fuseaction=member.popupajax_add_company_subscription&cpid=#attributes.cpid#&get_company.manager_partner_id=#get_company.manager_partner_id#</cfoutput>';
			if (div_id == 'LIST_MY_COMPANY_ASSETS')//fiziki varlıklar
				var page = '<cfoutput>#request.self#?fuseaction=member.popupajax_my_company_assets&cpid=#attributes.cpid#</cfoutput>';
			if (div_id == 'ADD_MY_COMPANY_ASSETS')//fiziki varlık ekle
				var page = '<cfoutput>#request.self#?fuseaction=member.popupajax_add_company_physical_assets&cpid=#attributes.cpid#</cfoutput>';
			if (div_id == 'UPD_MY_COMPANY_ASSETS'+assetpId+'')//fiziki varlık ekle
				var page = '<cfoutput>#request.self#?fuseaction=member.popupajax_upd_company_physical_assets&cpid=#attributes.cpid#&assetp_id='+assetpId+'</cfoutput>';
			AjaxPageLoad(page,''+div_id+'',1);
		}

		function kontrol()
		{
			
			<cfif get_company.use_efatura neq 1>
				<cfif session.ep.our_company_info.is_earchive eq 1>
					if(document.getElementById('earchive_sending_type').value == '1' && document.getElementById('company_email').value == '')
					{
						alert("<cf_get_lang dictionary_id='29707.Lütfen e-mail adresinizi giriniz!'>");
						return false;
					}
				</cfif>
			</cfif>
			<cfif isDefined("is_vno_vd_required") and is_vno_vd_required eq 1>
				var get_charnumber = wrk_query("SELECT TC_CHARNUMBER,VKN_CHARNUMBER FROM SETUP_COUNTRY WHERE COUNTRY_ID = "+document.getElementById('country').value,"dsn");
				tc_charnumber=document.getElementById('tckimlikno').value;
				vkn_charnumber=document.getElementById('taxno').value;
				if(tc_charnumber.length != get_charnumber.TC_CHARNUMBER && vkn_charnumber.length != get_charnumber.VKN_CHARNUMBER && (get_charnumber.VKN_CHARNUMBER !="" || get_charnumber.TC_CHARNUMBER !=""))
				{
					alert("<cf_get_lang dictionary_id='65102.Kimlik no veya Vergi kimlik No karakter sayısı hatalı'> !");
							return false;   
				}
				if(document.getElementById('tckimlikno').value == "" && (document.getElementById('taxoffice').value == "" || document.getElementById('taxno').value == "") && document.getElementById("ispotantial").checked == false)
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58762.Vergi Dairesi'>, <cf_get_lang dictionary_id='57752.Vergi No'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='58025.TC Kimlik No'>!");
					return false;      
				}
			</cfif>
			<cfif get_einvoice.recordcount>
				if(document.getElementById("is_buyer").checked == true || document.getElementById("is_seller").checked == true || document.getElementById("ispotantial").checked == false)
				{
					if(document.getElementById("is_person").checked == true)
					{
						if(document.getElementById('taxno').value != "")
						{
							alert("<cf_get_lang dictionary_id='59878.Şahıs Firmasına Vergi No Giremezsiniz'>!");
							return false;	
						}
					}
					else 
					{
						if( (document.getElementById("is_buyer").checked == false || document.getElementById("is_seller").checked == false) && document.getElementById("ispotantial").checked == false)
						{
							if(document.getElementById('taxoffice').value == "" && document.getElementById('country').value == 1)
								{
									alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58762.Vergi Dairesi'>");
									return false;
								}
						}
					}
				}
			</cfif>
			if((document.form_upd_company.coordinate_1.value.length != "" && document.form_upd_company.coordinate_2.value.length == "") || (document.form_upd_company.coordinate_1.value.length == "" && document.form_upd_company.coordinate_2.value.length != ""))
			{
				alert ("<cf_get_lang dictionary_id='59880.Lütfen koordinat değerlerini eksiksiz giriniz'>!");
				return false;
			}
		
			x = document.form_upd_company.companycat_id.selectedIndex;
			if (document.form_upd_company.companycat_id[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30269.Sirket Kategorisi '>");
				return false;
			}
			if (document.getElementById('manager_partner_id').value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30367.Yonetici '>");
				return false;
			}
			t = (200 - document.form_upd_company.company_address.value.length);
			if ( t < 0 )
			{ 
				alert ("<cf_get_lang dictionary_id='58723.Adres'> "+ ((-1) * t) +" <cf_get_lang dictionary_id='29538.Karakter Uzun !'>");
				return false;
			}
			if(document.getElementById("hierarchy_company").value != '' && document.form_upd_company.company_id.value == document.form_upd_company.hierarchy_id.value)
			{ 
				alert ("<cf_get_lang dictionary_id='30312.Üst Şirket Şirketin Kendisi Olamaz'>");
				return false;
			}
			<cfif session.ep.our_company_info.sales_zone_followup eq 1> 
				x = document.form_upd_company.sales_county.selectedIndex;
				if (document.form_upd_company.sales_county[x].value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57659.satış Bölgesi'> !");
					return false;
				}
				if(document.form_upd_company.ims_code_id.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58134.Micro Bölge Kodu'> !");
					return false;
				}
			</cfif>	
			<!---
			<cfif isDefined("is_vno_vd_required") and is_vno_vd_required eq 1>
				if(document.getElementById('tckimlikno').value == "" && (document.getElementById('taxoffice').value == "" || document.getElementById('taxno').value == ""))
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1350.Vergi Dairesi'> ve <cf_get_lang_main no='340.Vergi No'>, veya TC Kimlik No!");
					return false;	
				}
				if(document.getElementById('tckimlikno').value != "" && document.getElementById('tckimlikno').value.length != 11)
				{
					alert("TC Kimlik No 11 haneli olmalı!");
					return false;	
				}					
			</cfif>
			--->
			<cfif isdefined("attributes.type")><!--- Hedef tarafi icin kullaniliyor --->
				if(document.form_upd_company.glncode.value != '' && document.form_upd_company.glncode.value.length != 13)
				{
					alert("<cf_get_lang dictionary_id='30293.GLN Kod Alanı 13 Hane Olmalıdır'> !");
					document.form_upd_company.glncode.focus();
					return false;
				}
				if(form_upd_company.company_telcode.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30316.Telefon Kodu'> !");
					return false;
				}
				if(form_upd_company.company_tel1.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57499.Telefon'> !");
					return false;
				}
				x = document.form_upd_company.country.selectedIndex;
				if (document.form_upd_company.country[x].value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58219.Ülke'> !");
					return false;
				}
				if(form_upd_company.city_id.value == "")
				{
					alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='58608.il'> !");
					return false;
				}
				if(form_upd_company.county_id.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58638.İlçe'> !");
					return false;
				}
				if(form_upd_company.semt.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58132.Semt'> !");
					return false;
				}
				if(form_upd_company.semt.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58132.Semt'> !");
					return false;
				}
				if(form_upd_company.ims_code_id.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58134.Micro Bölge Kodu'> !");
					return false;
				}
				if(form_upd_company.ozel_kod.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30155.Cari Hesap Kodu'> !");
					return false;
				}
				else if(form_upd_company.ozel_kod.value.length != 10)
				{
					alert("<cf_get_lang dictionary_id='30155.Cari Hesap Kodu'><cf_get_lang dictionary_id ='30585.Alanı 10 Karakter Olmalıdır'>!");
					return false;
				}
			<cfif not fusebox.circuit eq 'crm' >
				if(form_upd_company.ozel_kod_1.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58811.Muhasebe Kodu'> !");
					return false;
				}
				else if(form_upd_company.ozel_kod_1.value.length != 10)
				{
					alert("<cf_get_lang dictionary_id='58811.Muhasebe Kodu'> <cf_get_lang dictionary_id ='30585.Alanı 10 Karakter Olmalıdır'>!");
					return false;
				}
			</cfif>
			</cfif>
			<cfif x_is_product_category eq 1>
				select_all('product_category');
			</cfif>
			<cfif x_is_upper_sector eq 1>
				select_all('upper_sector_cat');
			</cfif>
			<cfif x_is_related_brands eq 1>
				select_all('related_brand_id');
			</cfif>
			<cfif get_einvoice.recordcount>
				if(document.getElementById('country').value == 1 && document.getElementById('city_id').value == "")
				{
					alert("<cf_get_lang dictionary_id='30499.Lutfen Şehir Seciniz'> !");
					return false;
				}			
				if(document.getElementById('country').value == 1 && document.getElementById('county_id').value == "")
				{
					alert("<cf_get_lang dictionary_id='30538.Lutfen İlce Seciniz'> !");
					return false;
				}
			</cfif>
			
			if(process_cat_control())
			{
				if(confirm("<cf_get_lang dictionary_id='30313.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")) 
					return true; 
				else 
					return false; 
			}
			else
			{
				return false;
			}
		}
		form_upd_company.fullname.focus();

		function remove_field(field_option_name)
		{
			field_option_name_value = document.getElementById(field_option_name);
			for (i=field_option_name_value.options.length-1;i>-1;i--)
			{
				if (field_option_name_value.options[i].selected==true)
				{
					field_option_name_value.options.remove(i);
				}	
			}
		}
		function select_all(selected_field)
		{
			var m = eval("document.form_upd_company." + selected_field + ".length");
			for(i=0;i<m;i++)
			{
				eval("document.form_upd_company."+selected_field+"["+i+"].selected=true");
			}
		}
		
		function LoadPhone(x)
		{
			if(x != '')
			{
				get_phone_no = wrk_safe_query("mr_get_phone_no","dsn",0,x);
	
				if(get_phone_no.COUNTRY_PHONE_CODE != undefined && get_phone_no.COUNTRY_PHONE_CODE != '')
					document.getElementById('load_phone').innerHTML = '(' + get_phone_no.COUNTRY_PHONE_CODE + ')';
				else
					document.getElementById('load_phone').innerHTML = '';
			}
			else
				document.getElementById('load_phone').innerHTML = '';
		}
		
		function get_ims_code()
		{
			get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('district_id').value);
			get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('district_id').value);
			if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
			{		
				document.getElementById('semt').value=get_ims_code_.PART_NAME;
				document.getElementById('company_postcode').value=get_ims_code_.POST_CODE;
			}
			else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
			{
				document.getElementById('semt').value = get_district_.PART_NAME;
				document.getElementById('company_postcode').value = get_district_.POST_CODE;
			}
			else
			{
				document.getElementById('semt').value = '';
				document.getElementById('company_postcode').value = '';
			}
		}
		
		function getTc()
		{			
			var get_tc_identy = wrk_query("SELECT TC_IDENTITY FROM COMPANY_PARTNER WHERE PARTNER_ID = "+document.getElementById('manager_partner_id').value,"dsn");
			if(get_tc_identy.TC_IDENTITY != undefined)
			{
				document.getElementById('tckimlikno').value = get_tc_identy.TC_IDENTITY;
			}
			else
				document.getElementById('tckimlikno').value = '';
		}

		function mukellefSorgula() {
			$("#working_div_main").show();
			let vkn = $("#taxno").val();
			$.ajax("/wex.cfm/customerinfo/mukellefsorgulama",{ 
				method: "POST",
				contentType: "application/json",
				data: JSON.stringify({ mukkelleftip: "tuzel", vkn: vkn })
			}).done(function (d) {
				let jd = JSON.parse(d);
				$("#working_div_main").hide();
				if (jd.status == 0) {
					$('.ui-cfmodal__alert .required_list li').remove();
					$('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i>'+jd.message+'</li>');
					$('.ui-cfmodal__alert').fadeIn();
				} else {
					$("#taxoffice").val(jd.result.VERGIDAIRESIADI);
					if ( typeof(jd.result.UNVAN) != "undefined" ) {
						$("#fullname").val(jd.result.UNVAN);
					}
					$("#country").find("option:contains(Türkiye)")[0].selected = true;
					$("#country").change();
					setTimeout(() => {
						let city = $("#city_id").find("option:contains("+jd.result.ISADRESI.ILADI+")");
						if (city.length > 0) {
							$(city)[0].selected = true;
							$("#city_id").change();
							setTimeout(() => {
								let county = $("#county_id").find("option:contains("+jd.result.ISADRESI.ILCEADI+")");
								if (county.length > 0) {
									$(county)[0].selected = true;
									$("#county_id").change();
									setTimeout(() => {
										let district = $("#district_id").find("option:contains("+jd.result.ISADRESI.MAHALLESEMT+")");
										if (district.length > 0) {
											$(district)[0].selected = true;
										}
									}, 1000);
								}
							}, 1000);
						}	
					}, 1000);
					$("#semt").val(jd.result.ISADRESI.MAHALLESEMT);
				}
			})
		}
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
