<cfinclude template="../query/get_city.cfm">
<cfinclude template="../query/get_sales_zones.cfm">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.fullname" default="">
<cfparam name="attributes.cp_name" default="">
<cfparam name="attributes.cp_surname" default="">
<cfparam name="attributes.zone_director" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.ekip" default="">
<cfparam name="attributes.vergi_no" default="">
<cfparam name="attributes.musteri_grubu" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.customer_type" default="">
<cfparam name="attributes.county" default="">
<cfparam name="attributes.county_id" default="">
<cfquery name="GET_CUSTOM_CAT" datasource="#dsn#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT_ID
</cfquery>
<cfquery name="GET_ZONE" datasource="#dsn#">
	SELECT ZONE_ID, ZONE_NAME FROM ZONE ORDER BY ZONE_NAME
</cfquery>
<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
	SELECT DEPARTMENT_HEAD , DEPARTMENT_ID FROM DEPARTMENT ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfif len(attributes.is_submitted)>
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT
		COMPANY.FULLNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.COMPANY_ID,
		SETUP_IMS_CODE.IMS_CODE,
		SETUP_IMS_CODE.IMS_CODE_NAME,
		SETUP_CITY.CITY_NAME,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_TEL1,
		COMPANY.TAXNO,
		SETUP_COUNTY.COUNTY_NAME
	FROM
		COMPANY,
		COMPANY_PARTNER,
		SETUP_IMS_CODE,
		SETUP_CITY,
		SETUP_COUNTY
	WHERE
		SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY 
		AND SETUP_CITY.CITY_ID = COMPANY.CITY 
		AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
		AND SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID 
		AND COMPANY_PARTNER.IS_MANAGER = 1 
		AND COMPANY.COMPANY_STATE = 1
		<cfif len(attributes.fullname)>AND COMPANY.FULLNAME LIKE '#attributes.fullname#%'</cfif>
		<cfif len(attributes.cp_name)>AND COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '#attributes.cp_name#%'</cfif>
		<cfif len(attributes.cp_surname)>AND COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '#attributes.cp_surname#%'</cfif>
		<cfif len(attributes.city)>AND COMPANY.CITY = #attributes.city#</cfif>
		<cfif len(attributes.county) and len(attributes.county_id)>AND COMPANY.COUNTY = #attributes.county_id#</cfif>
		<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>AND COMPANY.IMS_CODE_ID = #attributes.ims_code_id#</cfif>
		<cfif len(attributes.customer_type)>AND CUSTOMER_TYPE IN (#attributes.customer_type#)</cfif>
		<cfif len(attributes.vergi_no)>AND TAXNO = '#attributes.vergi_no#'</cfif>
		AND IS_POTENTIAL = 1
	ORDER BY
		COMPANY.FULLNAME
</cfquery>
<cfparam name='attributes.totalrecords' default="#get_company.recordcount#">
<cfelse>
  <cfparam name='attributes.totalrecords' default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='498.Yeni Müşteriler'></td>
    <td  style="text-align:right;">
      <!-- sil -->
	  <table>
        <cfform name="search_company"  method="post" action="#request.self#?fuseaction=crm.dsp_new_company">        
        <input type="hidden" name="is_submitted" id="is_submitted" value="1">
        <tr>
          <td><cf_get_lang dictionary_id="57750.İşyeri Adı"></td>
          <td><cfinput type="text" name="fullname" style="width:100px;" value="#attributes.fullname#" maxlength="255"></td>
          <td>&nbsp;<cf_get_lang dictionary_id="57752.Vergi No"></td>
          <td><cfinput type="text" name="vergi_no" value="#attributes.vergi_no#" style="width:85px"></td>
          <td>&nbsp;<cf_get_lang dictionary_id="58192.Müşteri Adı"></td>
          <td><cfinput type="text" name="cp_name" style="width:100px;" value="#attributes.cp_name#" maxlength="255"></td>
          <td>&nbsp;<cf_get_lang dictionary_id="51484.Müşteri Soyadı"></td>
          <td><cfinput type="text" name="cp_surname" value="#attributes.cp_surname#" maxlength="255"style="width:100px;"></td>
          <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
			  <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
          <td><cf_wrk_search_button></td>
          <td><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
        </tr>
      </table>
	  <!-- sil -->
  </tr>
</table>
<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
       <!-- sil -->
	    <tr style="text-align:right;">
          <td height="22" colspan="10" class="color-list">
            <table>
              <tr>
                <td  style="text-align:right;">
                <table>
                    <tr>
                        <td>&nbsp;<cf_get_lang_main no='580.Bölge'></td>
                        <td>
                            <select name="zone_director" id="zone_director" style="width:230px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_sales_zones">
                                <option value="#sz_id#" <cfif sz_id eq attributes.zone_director>selected</cfif>>#sz_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td>&nbsp;<cf_get_lang_main no='1196.İl'></td>
                        <td>
                            <select name="city" id="city" style="width:140px;" value="#attributes.city#" onChange="county_id_clear()">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_city">
                                <option value="#city_id#" <cfif city_id eq attributes.city>selected</cfif>>#city_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td>&nbsp;<cf_get_lang_main no='1226.İlçe'></td>
                        <td>
                            <input type="hidden" name="county_id" id="county_id" readonly="" value=<cfoutput>"#attributes.county_id#"</cfoutput>>
                            <cfinput type="text" name="county" value="#attributes.county#" maxlength="30" style="width:140px;">
                            <a href="javascript://" onClick="pencere_ac2();"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                        </td>
                        <td>&nbsp;<cf_get-lang no='499.IMS Bölge Kodu'></td>
                        <td>
                            <input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
                            <cfinput type="text" name="ims_code_name" style="width:220px;" value="#attributes.ims_code_name#">
                            <a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                        </td>
                    </tr>                                   
                </table>
				</td>
			   </cfform>   
              </tr>
              <tr>
                <td  style="text-align:right;">
				  <cfoutput query="get_custom_cat"> #companycat#&nbsp;
                    <input name="customer_type" id="customer_type" type="checkbox" value="#companycat_id#" <cfif listfind(attributes.customer_type,companycat_id)>checked</cfif>>
                  </cfoutput></td>
              </tr>
            </table>
          </td>
        </tr>
		<!-- sil -->
        <tr class="color-header" height="22">
          <td width="30" class="form-title"><cf_get_lang_main no='75.No'></td>
          <td class="form-title"><cf_get-lang no='33.İşyeri Adı'></td>
          <td width="90" class="form-title"><cf_get_lang_main no='780.Müşteri Adı'></td>
          <td width="90" class="form-title"><cf_get_lang no='37.Müşteri Soyadı'></td>
          <td class="form-title"><cf_get_lang_main no='722.Mikro Bolge Kodu'></td>
          <td class="form-title"><cf_get_lang_main no='340.Vergi No'></td>
          <td class="form-title"><cf_get_lang_main no='1226.İlçe'></td>
          <td class="form-title" width="100"><cf_get_lang_main no='1196.İl'></td>
          <td class="form-title" width="70"><cf_get_lang_main no='87.Telefon'></td>
          <td class="form-title" width="100"><cf_get_lang no='500.Müşteri Cari Hesap No'></td>
        </tr>
        <cfif len(attributes.is_submitted)>
          <cfif get_company.recordcount>
            <cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfquery name="GET_COMPANY_ACCOUNT" datasource="#dsn#">
              	SELECT
					OUR_COMPANY.NICK_NAME,
					COMPANY_BRANCH_RELATED.CARIHESAPKOD
              	FROM
					COMPANY_BRANCH_RELATED,
					OUR_COMPANY
				WHERE
					COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
					COMPANY_BRANCH_RELATED.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID AND
					COMPANY_BRANCH_RELATED.COMPANY_ID = #company_id#
            </cfquery>
              <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td width="30">#currentrow#</td>
                <td><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#" class="tableyazi">#fullname#</a></td>
                <td>#company_partner_name#</td>
                <td>#company_partner_surname#</td>
                <td>#ims_code# #ims_code_name#</td>
                <td>#taxno#</td>
                <td>#county_name#</td>
                <td>#city_name#</td>
                <td>#company_telcode# #company_tel1#</td>
                <td><cfloop query="get_company_account"><cfif len(get_company_account.carihesapkod)>#get_company_account.nick_name# / #get_company_account.carihesapkod#<cfif get_company_account.recordcount neq currentrow>,</cfif></cfif></cfloop></td>
              </tr>
            </cfoutput>
            <cfelse>
            <tr height="22">
              <td colspan="10" class="color-row"><cf_get_lang_main no='1074.Kayıt Bulunamadı'> !</td>
            </tr>
          </cfif>
          <cfelse>
          <tr height="22">
            <td colspan="10" class="color-row"><cf_get_lang_main no='289.Filtre Ediniz'> !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<!-- sil -->
<cfif attributes.totalrecords gt attributes.maxrows>
  <cfscript>
  	url_str = "";
	if(len(attributes.fullname))
		url_str = "#url_str#&fullname=#attributes.fullname#";	
  	if (len(attributes.cp_name))
    	url_str = "#cp_name#&fullname=#attributes.cp_name#";
  	if(len(attributes.cp_surname))
    	url_str = "#url_str#&cp_surname=#attributes.cp_surname#";
	if(len(attributes.is_submitted))
    	url_str = "#url_str#&is_submitted=#attributes.is_submitted#";
	if(len(attributes.zone_director))
    	url_str = "#url_str#&zone_director=#attributes.zone_director#";
  	if(len(attributes.ims_code_id))
    	url_str = "#url_str#&ims_code_id=#attributes.ims_code_id#";
  	if(len(attributes.ims_code_name))
    	url_str = "#url_str#&ims_code_name=#attributes.ims_code_name#";
  	if(len(attributes.ekip))
    	url_str = "#url_str#&ekip=#attributes.ekip#";
  	if(len(attributes.vergi_no))
    	url_str = "#url_str#&vergi_no=#attributes.vergi_no#";
  	if(len(attributes.city))
    	url_str = "#url_str#&city=#attributes.city#";
  	if(len(attributes.county_id))
    	url_str = "#url_str#&county_id=#attributes.county_id#";
  	if(len(attributes.county))
    	url_str = "#url_str#&county=#attributes.county#";
  	if(isDefined('attributes.customer_type'))
    	url_str = "#url_str#&customer_type=#customer_type#";
  </cfscript>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
    <tr>
      <td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="crm.#fusebox.fuseaction##url_str#"></td>
      <td  style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
</cfif>
<script type="text/javascript">
function county_id_clear(){	
	document.search_company.county.value = '';
	document.search_company.county_id.value = '';
	document.search_company.ims_code_id.value = '';
	document.search_company.ims_code_name.value = '';}
function pencere_ac(selfield){	
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=search_company.ims_code_name&field_id=search_company.ims_code_id&is_submitted=1&il_id=' +document.search_company.city.value,'list');}
function pencere_ac2(no){
	x = document.search_company.city.selectedIndex;
	if (document.search_company.city[x].value == ""){
		alert("<cf_get_lang dictionary_id='33180.İlk Olarak İl Seçiniz'>");}
	else{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=search_company.county_id&field_name=search_company.county&city_id=' + document.search_company.city.value,'list');}}
</script>
