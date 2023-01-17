<!--- File:upd_partner.cfm
    Author: Canan Ebret <cananebret@workcube.com>
    Date: 11.10.2019
    Controller: -
    Description: Kurumsal üye çalışan detay, güncelle  sayfası sorguları member_company.cfc dosyasına taşındı .​
 --->

<cf_get_lang_set module_name="member">
<cf_xml_page_edit fuseact="member.detail_partner">
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
<cfinclude template="../../objects/display/imageprocess/imcontrol.cfm">
<cfset session.resim = 1>
<cfif not isDefined("url.brid")>
	<cfset GET_PARTNER = company_cmp.GET_PARTNER_EMP(
						partner_status:'#iIf(isdefined("attributes.partner_status") and len(attributes.partner_status),"attributes.partner_status",DE(""))#',
						is_only_active_partners:'#iIf(isdefined("is_only_active_partners") and len(is_only_active_partners),"is_only_active_partners",DE("0"))#',
						cpid:'#iIf(isdefined("url.cpid") and len(url.cpid),"url.cpid",DE(""))#',
						pid:'#iIf(isdefined("url.pid") and len(url.pid),"url.pid",DE(""))#'
					)> 
<cfelse> 
    <cfset GET_PARTNER = company_cmp.GET_PARTNER_SECOND(
					brid:'#iIf(isdefined("url.brid") and len(url.brid),"url.brid",DE(""))#' 
					)>
</cfif>   
<cfset GET_PARTNER_POSITIONS = company_cmp.GET_PARTNER_POSITIONS()>  
<cfset GET_PARTNER_DEPARTMENTS = company_cmp.GET_PARTNER_DEPARTMENTS()>
<cfset GET_IM = company_cmp.GET_IM()> 
<cfset GET_LANGUAGE = company_cmp.GET_LANGUAGE()>
<cfif isdefined("attributes.pid")>
	<cfset GET_BRANCH = company_cmp.GET_BRANCH(pid:attributes.pid)>
<cfelse>
	<cfset GET_BRANCH = company_cmp.GET_BRANCH_SECOND(zone:attributes.zone)>
</cfif>  
<cfset GET_COUNTRY = company_cmp.GET_COUNTRY_()> 
<cfset GET_STATUS = company_cmp.GET_STATUS()>
<cfset GET_PARTNER_SETTINGS = company_cmp.GET_PARTNER_SETTINGS(pid:attributes.pid)>
<cfset password_style = createObject('component','V16.hr.cfc.add_rapid_emp')><!--- Şifre standartları çekiliyor. --->
<cfset get_password_style = password_style.pass_control()>
<cfset GET_COMPANY = company_cmp.GET_COMPANY_PARTNER(company_id:get_partner.company_id)>
<cfset GET_HIER_PARTNER = company_cmp.GET_HIER_PARTNER(company_id:get_partner.company_id,pid :attributes.pid)> 
<cfif Len(get_company.county)>
 	<cfset GET_COMP_COUNTY = company_cmp.GET_COMP_COUNTY(county:get_company.county)>
</cfif>
<cfif Len(get_company.city)>
	<cfset GET_COMP_CITY = company_cmp.GET_COMP_CITY(city:get_company.city)>  
</cfif>
<cf_catalystHeader>
<!--- Sayfa ana kısım  --->
<div class="col col-9 col-xs-12 uniqueRow">
	<cf_box>
		<!---Geniş alan: içerik---> 
		<cfinclude template="detail_partner_content.cfm">
	</cf_box>
</div>
<div class="col col-3 col-xs-12 uniqueRow">
		<!--- Yan kısım--->
		<cfinclude template="detail_partner_side.cfm">
</div>
<script type="text/javascript">
	<cfif isdefined("is_tc_number")>
		var is_tc_number = '<cfoutput>#is_tc_number#</cfoutput>';
	<cfelse>
		var is_tc_number = 0;
	</cfif>
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
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.upd_partner.city_id.value = '';
			document.upd_partner.county_id.value = '';
		}
		else
		{
			document.upd_partner.county_id.value = '';
		}	
	}
	function kontrol_et(compbranch_id)
	{
		if(compbranch_id == 0)
		{
			var get_comp_branch = wrk_safe_query("mr_get_comp_branch","dsn",0,document.upd_partner.company_id.value);
			if(get_comp_branch.COUNTRY != '')
			{
				document.upd_partner.country.value = get_comp_branch.COUNTRY;
				LoadCity(get_comp_branch.COUNTRY,'city_id','county_id',0);
			}
			else
				document.upd_partner.country.value = '';
			if(get_comp_branch.CITY != '')
			{
				document.upd_partner.city_id.value = get_comp_branch.CITY;
				LoadCounty(get_comp_branch.CITY,'county_id');
			}
			else
				document.upd_partner.city_id.value = '';
			if(get_comp_branch.COUNTY != '')
				document.upd_partner.county_id.value = get_comp_branch.COUNTY;
			else
				document.upd_partner.county_id.value = '';	
			if(get_comp_branch.COMPANY_ADDRESS != '')
				document.upd_partner.company_partner_address.value = get_comp_branch.COMPANY_ADDRESS;
			else
				document.upd_partner.company_partner_address.value = '';
			if(get_comp_branch.COMPANY_POSTCODE != '')
				document.upd_partner.company_partner_postcode.value = get_comp_branch.COMPANY_POSTCODE;
			else
				document.upd_partner.company_partner_postcode.value = '';
			if(get_comp_branch.SEMT != '')
				document.upd_partner.semt.value = get_comp_branch.SEMT;
			else
				document.upd_partner.semt.value = '';
			if(get_comp_branch.COMPANY_TELCODE != '')
				document.upd_partner.company_partner_telcode.value = get_comp_branch.COMPANY_TELCODE;
			else
				document.upd_partner.company_partner_telcode.value = '';
			if(get_comp_branch.COMPANY_TEL1 != '')
				document.upd_partner.company_partner_tel.value = get_comp_branch.COMPANY_TEL1;
			else
				document.upd_partner.company_partner_tel.value = '';
			if(get_comp_branch.COMPANY_FAX != '')
				document.upd_partner.company_partner_fax.value = get_comp_branch.COMPANY_FAX;
			else
				document.upd_partner.company_partner_fax.value = '';
		}
		else
		{
			var get_company_branch = wrk_safe_query("mr_get_company_branch","dsn",0,compbranch_id);
			if(get_company_branch.COUNTRY_ID != '')
			{
				document.upd_partner.country.value = get_company_branch.COUNTRY_ID;
				LoadCity(get_company_branch.COUNTRY_ID,'city_id','county_id',0);
			}
			else
				document.upd_partner.country.value = '';
			if(get_company_branch.CITY_ID != '')
			{
				document.upd_partner.city_id.value = get_company_branch.CITY_ID;
				LoadCounty(get_company_branch.CITY_ID,'county_id',0);
			}
			else
				document.upd_partner.city_id.value = '';
			if(get_company_branch.COUNTY_ID != '')
				document.upd_partner.county_id.value = get_company_branch.COUNTY_ID;
			else
				document.upd_partner.county_id.value = '';	
			if(get_company_branch.COMPBRANCH_ADDRESS != '')
				document.upd_partner.company_partner_address.value = get_company_branch.COMPBRANCH_ADDRESS;
			else
				document.upd_partner.company_partner_address.value = '';
			if(get_company_branch.COMPBRANCH_POSTCODE != '')
				document.upd_partner.company_partner_postcode.value = get_company_branch.COMPBRANCH_POSTCODE;
			else
				document.upd_partner.company_partner_postcode.value = '';
			if(get_company_branch.SEMT != '')
				document.upd_partner.semt.value = get_company_branch.SEMT;
			else
				document.upd_partner.semt.value = get_company_branch.SEMT;
			if(get_company_branch.COMPBRANCH_TELCODE != '')
				document.upd_partner.company_partner_telcode.value = get_company_branch.COMPBRANCH_TELCODE;
			else
				document.upd_partner.company_partner_telcode.value = '';
			if(get_company_branch.COMPBRANCH_TEL1 != '')
				document.upd_partner.company_partner_tel.value = get_company_branch.COMPBRANCH_TEL1;
			else
				document.upd_partner.company_partner_tel.value = '';
			if(get_company_branch.COMPBRANCH_FAX != '')
				document.upd_partner.company_partner_fax.value = get_company_branch.COMPBRANCH_FAX;
			else
				document.upd_partner.company_partner_fax.value = '';
		}
	}	                                	
	function kontrol()
	{	
		if(!$("#company_partner_surname").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30339.Üye Adı !'></cfoutput>"})    
			return false;
		}
		if(!$("#company_partner_name").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30342.Üye Soyadı!'></cfoutput>"})    
			return false;
		}
		control_ifade_ = $('#company_partner_password').val();
		if ($('#company_partner_password').val().indexOf(" ") != -1)
		{
			alert("Şifre boşluk karakterini içeremez.");
			$('#company_partner_password').focus();
			return false;
		}
		if(($('#company_partner_username').val() != "") && ($('#company_partner_password').val() != "") && ($('#company_partner_username').val() == $('#company_partner_password').val()))
		{
			alert("<cf_get_lang dictionary_id='30952.Şifre Kullanıcı Adıyla Aynı Olamaz !'>");
			$('#company_partner_password').focus();
			return false;
		}
		if ($('#company_partner_password').val() != "")
		{
			<cfif get_password_style.recordcount>
				var number="0123456789";
				var lowercase = "abcdefghijklmnopqrstuvwxyz";
				var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				var ozel="!]'^%&([=?_<£)#$½{\|.:,;/*-+}>";
				var containsNumberCase = contains(control_ifade_,number);
				var containsLowerCase = contains(control_ifade_,lowercase);
				var containsUpperCase = contains(control_ifade_,uppercase);
				var ozl = contains(control_ifade_,ozel);
				<cfoutput>
					if(control_ifade_.length < #get_password_style.password_length#)
					{
						alert("<cf_get_lang dictionary_id='30949.Şifre Karakter Sayısı Az'>! <cf_get_lang dictionary_id='30951.Şifrede Olması Gereken Karakter Sayısı'> : #get_password_style.password_length#");
						document.getElementById('company_partner_password').focus();				
						return false;
					}
					
					if(#get_password_style.password_number_length# > containsNumberCase)
					{
						alert("<cf_get_lang dictionary_id = '30948.Şifrede Olması Gereken Rakam Sayısı'> : #get_password_style.password_number_length#");
						document.getElementById('company_partner_password').focus();
						return false;
					}
					
					if(#get_password_style.password_lowercase_length# > containsLowerCase)
					{
						alert("<cf_get_lang dictionary_id = '30947.Şifrede Olması Gereken Küçük Harf Sayısı'> :#get_password_style.password_lowercase_length#");
						document.getElementById('company_partner_password').focus();				
						return false;
					}
					
					if(#get_password_style.password_uppercase_length# > containsUpperCase)
					{
						alert("<cf_get_lang dictionary_id = '30946.Şifrede Olması Gereken Büyük Harf Sayısı'> : #get_password_style.password_uppercase_length#");
						document.getElementById('company_partner_password').focus();
						return false;
					}
					
					if(#get_password_style.password_special_length# > ozl)
					{
						alert("<cf_get_lang dictionary_id = '30945.Şifrede Olması Gereken Özel Karakter Sayısı'> : #get_password_style.password_special_length#");
						document.getElementById('company_partner_password').focus();
						return false;
					}
				</cfoutput>
			</cfif>
		}
		<cfif isDefined('is_vno_vd_required') and is_vno_vd_required eq 1>
			if(<cfoutput>#get_company.manager_partner_id# == #url.pid#</cfoutput> && <cfoutput>#len(get_company.taxno)# == 0</cfoutput> && document.upd_partner.tc_identity.value.trim() == '')
			{
				alert("<cf_get_lang dictionary_id='59881.Çalışanın yöneticisi olduğu şirketin vergi numarası tanımlı değil'>. <cf_get_lang dictionary_id='54211.TC Kimlik No zorunlu'> !");
				return false;	
			}
		</cfif>
		if(document.upd_partner.company_partner_status.checked == false && <cfoutput>#get_company.manager_partner_id# == #url.pid#</cfoutput>)
		{
			alert("<cf_get_lang dictionary_id='59882.Çalışan Yönetici Olarak Tanımlı. Başka Bir Çalışanı Yönetici Seçtikten Sonra Pasife Alınız'> !");
			return false;
		}		
		if(is_tc_number == 1)
		{
			if(!isTCNUMBER(document.upd_partner.tc_identity)) return false;
		}
		var hierarchy_part_id_list = document.upd_partner.hierarchy_part_id.value;
		var hier_partner_id_ = document.upd_partner.hier_partner_id.value;
		if(document.upd_partner.hier_partner_id.value != "" && list_find(hierarchy_part_id_list,hier_partner_id_,','))
		{
			alert("<cf_get_lang dictionary_id='30737.Aynı Kişiler Birbirine Bağlı Olamaz'>");
			return false;
		}
		if(document.upd_partner.tc_identity.value != "")
		{
			if(document.upd_partner.tc_identity.value.length != 11)
				{
					alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='30574.TC Kimlik Numarası - 11 Hane'> !");
					return false;
				}
		}
		var imcat = document.upd_partner.imcat_id.selectedIndex;
		if(document.upd_partner.imcat_id[imcat].value != "")
		{
			if(document.upd_partner.im.value.length == 0)
				{
					alert("<cf_get_lang dictionary_id='57425.uyarı'>: <cf_get_lang dictionary_id='30738.IMessege 1 Kategorisi seçilmiş fakat Instant Mesaj 1 adresi girilmemiş !'>");
					document.upd_partner.im.focus();
					return false;
				}
		}
		var imcat2 = document.upd_partner.imcat2_id.selectedIndex;
		if(document.upd_partner.imcat2_id[imcat2].value != "")
		{
			if(document.upd_partner.im2.value.length == 0)
				{
					alert("<cf_get_lang dictionary_id='57425.uyarı'>: <cf_get_lang dictionary_id='30739.IMessege 2 Kategorisi seçilmiş fakat Instant Mesaj 2 adresi girilmemiş !'>");
					document.upd_partner.im2.focus();
					return false;
				}
		}
		x = document.upd_partner.compbranch_id.selectedIndex;
		if (document.upd_partner.compbranch_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube adı !'>");
			return false;
		}
	
		x = document.upd_partner.language_id.selectedIndex;
		if (document.upd_partner.language_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58996.Dil !'>");
			return false;
		}
		
		x = (200 - document.upd_partner.company_partner_address.value.length);
		if ( x < 0)
		{ 
			alert ("<cf_get_lang dictionary_id='58723.Adres'>"+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun !'>");
			return false;
		}
		
		x = (document.upd_partner.company_partner_password.value.length);
		if ((document.upd_partner.company_partner_password.value != '') && (x < 4 ))
		{ 
			alert ("<cf_get_lang dictionary_id='57425.uyarı'>: <cf_get_lang dictionary_id='30334.Şifre-En Az Dört Karakter'>");
			return false;
		}
		
		var obj =  document.upd_partner.photo.value;
		if ((obj != "") && !((obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'jpg') || (obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'png')))
		{
			alert("<cf_get_lang dictionary_id='30335.Lütfen bir resim dosyası(gif,jpg veya png) giriniz!!'>");        
			return false;
		}
		if(confirm("<cf_get_lang dictionary_id='30313.Girdiğiniz bilgileri kaydetmek üzeresiniz, lütfen değişiklikleri onaylayın'> !")) return true; else return false;	
	}
	function contains(deger,validChars)						
	{
		var sayac=0;				             
		for (i = 0; i < deger.length; i++)
		{
			var char = deger.charAt(i);
			if (validChars.indexOf(char) > -1)    
				sayac++;
		}
		return(sayac);				
    }
	function get_ims_code()
	{
		get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('district_id').value);
		get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('district_id').value);
		if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
		{		
			document.getElementById('semt').value=get_ims_code_.PART_NAME;
			document.getElementById('company_partner_postcode').value=get_ims_code_.POST_CODE;
		}
		else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
		{
			document.getElementById('semt').value = get_district_.PART_NAME;
			document.getElementById('company_partner_postcode').value = get_district_.POST_CODE;
		}
		else
		{
			document.getElementById('semt').value = '';
			document.getElementById('company_partner_postcode').value = '';
		}
	}
	document.upd_partner.company_partner_name.focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
