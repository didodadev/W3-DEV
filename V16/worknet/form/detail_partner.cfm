<cf_xml_page_edit fuseact="member.detail_partner">
<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
<cfset getPartner = cmp.getPartner(partner_id:attributes.pid) />
<!---<cfset getMobilcat = cmp.getMobilcat() />--->
<cfset getCountry = cmp.getCountry() />
<cfset getPartnerPositions = cmp.getPartnerPositions() />
<cfset getPartnerDepartments = cmp.getPartnerDepartments() />
<cfset getLanguage = cmp.getLanguage() />
<cfset getCompanyBranch = cmp.getCompanyBranch(partner_id:attributes.pid) />

<table border="0" width="98%" class="headbold" cellpadding="0" cellspacing="0" align="center">
<cfform name="upd_partner" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_company_partner">
  	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getPartner.company_id#</cfoutput>">
	<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#attributes.pid#</cfoutput>">
	<tr>
		<td height="35">
			<cfoutput>
				#getPartner.company_partner_name#&nbsp;#getPartner.company_partner_surname# / <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_company&cpid=#getPartner.company_id#">#getPartner.fullname#</a>
			</cfoutput>
		</td>
	</tr>
</table>
<table width="98%" align="center">
	<tr>
		<td>
			<cfinclude template="detail_partner_content.cfm">
		</td>
		<td width="15"></td>
		<td width="300" valign="top" align="right">
            <cfinclude template="detail_partner_right.cfm">
		</td>
	</tr>
</cfform>
</table>
<br />
<script type="text/javascript">
var is_tc_number = 1;
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
		document.getElementById('city_id').value = '';
		document.getElementById('county_id').value = '';
		document.getElementById('telcod').value = '';
	}
	else
	{
		document.getElementById('county_id').value = '';
	}	
}

function kontrol_et(compbranch_id)
{
	if(compbranch_id == 0)
	{
		get_comp_branch = wrk_safe_query("mr_get_comp_branch","dsn",0,document.getElementById('company_id').value);
		if(get_comp_branch.COUNTRY != '')
		{
			document.getElementById('country').value = get_comp_branch.COUNTRY;
			LoadCity(get_comp_branch.COUNTRY,'city_id','county_id',0);
		}
		else
			document.getElementById('country').value = '';
		if(get_comp_branch.CITY != '')
		{
			document.getElementById('city_id').value = get_comp_branch.CITY;
			LoadCounty(get_comp_branch.CITY,'county_id');
		}
		else
			document.getElementById('city_id').value = '';
		if(get_comp_branch.COUNTY != '')
			document.getElementById('county_id').value = get_comp_branch.COUNTY;
		else
			document.getElementById('county_id').value = '';	
		if(get_comp_branch.COMPANY_ADDRESS != '')
			document.getElementById('adres').value = get_comp_branch.COMPANY_ADDRESS;
		else
			document.getElementById('adres').value = '';
		if(get_comp_branch.COMPANY_POSTCODE != '')
			document.getElementById('postcod').value = get_comp_branch.COMPANY_POSTCODE;
		else
			document.getElementById('postcod').value = '';
		if(get_comp_branch.SEMT != '')
			document.getElementById('semt').value = get_comp_branch.SEMT;
		else
			document.getElementById('semt').value = '';
		if(get_comp_branch.COMPANY_TELCODE != '')
			document.getElementById('telcod').value = get_comp_branch.COMPANY_TELCODE;
		else
			document.getElementById('telcod').value = '';
		if(get_comp_branch.COMPANY_TEL1 != '')
			document.getElementById('tel').value = get_comp_branch.COMPANY_TEL1;
		else
			document.getElementById('tel').value = '';
		if(get_comp_branch.COMPANY_FAX != '')
			document.getElementById('fax').value = get_comp_branch.COMPANY_FAX;
		else
			document.getElementById('fax').value = '';
	}
	else
	{ 
		getCompany_branch = wrk_safe_query("mr_get_company_branch","dsn",0,compbranch_id);
		if(getCompany_branch.COUNTRY_ID != '')
		{
			document.getElementById('country').value = getCompany_branch.COUNTRY_ID;
			LoadCity(getCompany_branch.COUNTRY_ID,'city_id','county_id',0);
		}
		else
			document.getElementById('country').value = '';
		if(getCompany_branch.CITY_ID != '')
		{
			document.getElementById('city_id').value = getCompany_branch.CITY_ID;
			LoadCounty(getCompany_branch.CITY_ID,'county_id',0);
		}
		else
			document.getElementById('city_id').value = '';
		if(getCompany_branch.COUNTY_ID != '')
			document.getElementById('county_id').value = getCompany_branch.COUNTY_ID;
		else
			document.getElementById('county_id').value = '';	
		if(getCompany_branch.COMPBRANCH_ADDRESS != '')
			document.getElementById('adres').value = getCompany_branch.COMPBRANCH_ADDRESS;
		else
			document.getElementById('adres').value = '';
		if(getCompany_branch.COMPBRANCH_POSTCODE != '')
			document.getElementById('postcod').value = getCompany_branch.COMPBRANCH_POSTCODE;
		else
			document.getElementById('postcod').value = '';
		if(getCompany_branch.SEMT != '')
			document.getElementById('semt').value = getCompany_branch.SEMT;
		else
			document.getElementById('semt').value = getCompany_branch.SEMT;
		if(getCompany_branch.COMPBRANCH_TELCODE != '')
			document.getElementById('telcod').value = getCompany_branch.COMPBRANCH_TELCODE;
		else
			document.getElementById('telcod').value = '';
		if(getCompany_branch.COMPBRANCH_TEL1 != '')
			document.getElementById('tel').value = getCompany_branch.COMPBRANCH_TEL1;
		else
			document.getElementById('tel').value = '';
		if(getCompany_branch.COMPBRANCH_FAX != '')
			document.getElementById('fax').value = getCompany_branch.COMPBRANCH_FAX;
		else
			document.getElementById('fax').value = '';
	}
}	

function kontrol ()
{	
	if(document.getElementById('tc_identity').value != "")
	{
		if(!isTCNUMBER(document.getElementById('tc_identity'))) return false;
		if(document.getElementById('tc_identity').value.length != 11)
			{
				alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='436.TC Kimlik Numarası - 11 Hane'> !");
				return false;
			}
	}
	
	x = document.getElementById('language_id').selectedIndex;
	if (document.upd_partner.language_id[x].value == "")
	{ 
		alert ("<cf_get_lang no='195.Kullanıcı İçin Dil Seçmediniz !'>");
		return false;
	}
	x = (100 - document.getElementById('adres').value.length);
	if ( x < 0)
	{ 
		alert ("<cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
		return false;
	}
	y = (document.getElementById('password').value.length);
	if ((document.getElementById('password').value != '')  && ( y < 4 ))
	{ 
		alert ("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='196.Şifre-En Az Dört Karakter'>");
		return false;
	}
	
	var obj =  document.getElementById('photo').value;
	if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4) == 'gif').toLowerCase() || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
	{
		alert("<cf_get_lang no='197.Lütfen bir resim dosyası(gif,jpg veya png) giriniz!!'>");
		return false;
	}	
	
	if (confirm("<cf_get_lang no='175.Girdiğiniz bilgileri kaydetmek üzeresiniz, Lütfen yeni kullanıcı kaydını onaylayın!'>")) return true; else return false;
}
document.getElementById('name').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
