<!--- 
Kurumsal ve bireysel üye için adres popup ıdır
Kurumsal Uye -- Kurumsal Uye Adresleri + Subeleri 
Bireysel Uye -- Bireysel Uye Ev ve Is adresleri + Subelerinin Adresleri
AE 20051118
 --->
<cfparam name="attributes.is_comp" default="1">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.categories" default=''>
<cfinclude template="../query/get_list_member_adress.cfm">

<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_member.recordcount#'>

<cfset url_string = "">
<cfif isdefined("attributes.basket_cheque")>
	<cfset url_string = "#url_string#&basket_cheque=1">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_adres")>
	<cfset url_string = "#url_string#&field_adres=#attributes.field_adres#">
</cfif>
<cfif isdefined("attributes.field_long_adres")>
	<cfset url_string = "#url_string#&field_long_adres=#attributes.field_long_adres#">
</cfif>
<cfif isdefined("attributes.field_city")>
	<cfset url_string = "#url_string#&field_city=#attributes.field_city#">
</cfif>
<cfif isdefined("attributes.field_city_name")>
	<cfset url_string = "#url_string#&field_city_name=#attributes.field_city_name#">
</cfif>
<cfif isdefined("attributes.field_county")>
	<cfset url_string = "#url_string#&field_county=#attributes.field_county#">
</cfif>
<cfif isdefined("attributes.field_county_name")>
	<cfset url_string = "#url_string#&field_county_name=#attributes.field_county_name#">
</cfif>
<cfif isdefined("attributes.field_country")>
	<cfset url_string = "#url_string#&field_country=#attributes.field_country#">
</cfif>
<cfif isdefined("attributes.field_country_name")>
	<cfset url_string = "#url_string#&field_country_name=#attributes.field_country_name#">
</cfif>
<cfif isdefined("attributes.field_postcode")>
	<cfset url_string = "#url_string#&field_postcode=#attributes.field_postcode#">
</cfif>
<cfif isdefined("attributes.field_semt")>
	<cfset url_string = "#url_string#&field_semt=#attributes.field_semt#">
</cfif>
<cfif isdefined("attributes.field_member_id")>
	<cfset url_string = "#url_string#&field_member_id=#attributes.field_member_id#">
</cfif>
<cfif isdefined("attributes.is_comp")>
	<cfset url_string = "#url_string#&is_comp=#attributes.is_comp#">
</cfif>
<cfif isdefined("attributes.is_store_module")>
	<cfset url_string = "#url_string#&is_store_module=#attributes.is_store_module#">
</cfif>
<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
  <tr height="35">
  	<td class="headbold"><cf_get_lang no='235.Adreslerim'></td>
  </tr>
  <tr>
	<td  valign="bottom" style="text-align:right;"> 
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border"> 
    <td> 
      <table cellpadding="2" cellspacing="1" border="0" width="100%" align="center">
        <tr class="color-header" height="22"> 
			<td width="40" class="form-title"><cf_get_lang_main no='75.No'></td>
			<td class="form-title" width="225"><cf_get_lang_main no='246.Üye'></td>
			<td class="form-title"><cf_get_lang_main no='1311.Adreslerim'></td>
			<td class="form-title" width="65"><cf_get_lang_main no='87.Telefon'></td>
			<td></td>
		</tr>
		<cfif get_member.recordcount>
			<cfset county_id_list=''>
			<cfset city_id_list=''>
			<cfset country_id_list=''>
		  <cfoutput query="get_member" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
			<cfif len(county) and not listfind(county_id_list,county)>
			  <cfset county_id_list=listappend(county_id_list,county)>
			</cfif>
			<cfif len(city) and not listfind(city_id_list,city)>
			  <cfset city_id_list=listappend(city_id_list,city)>
			</cfif>
			<cfif len(country) and not listfind(country_id_list,country)>
			  <cfset country_id_list=listappend(country_id_list,country)>
			</cfif>
		  </cfoutput>
          <cfif len(county_id_list)>
            <cfset county_id_list=listsort(county_id_list,"numeric","ASC",",")>
            <cfquery name="get_county_detail" datasource="#dsn#">
            	SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_id_list#) ORDER BY COUNTY_ID
            </cfquery>
          </cfif>
		  <cfif len(city_id_list)>
            <cfset city_id_list=listsort(city_id_list,"numeric","ASC",",")>
            <cfquery name="get_city_detail" datasource="#dsn#">
            	SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_id_list#) ORDER BY	CITY_ID
            </cfquery>
          </cfif>
		  <cfif len(country_id_list)>
            <cfset country_id_list=listsort(country_id_list,"numeric","ASC",",")>
            <cfquery name="get_country_detail" datasource="#dsn#">
            	SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_id_list#) ORDER BY COUNTRY_ID
            </cfquery>
          </cfif>
			<cfoutput query="get_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset str_company_address ="#ADDRESS#">
				<cfset str_company_address = replace(str_company_address,"#Chr(13)##chr(10)#"," ","all")>
				<cfset str_company_address = replace(str_company_address,"'"," ","all")>
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				  <td>#member_code#</td>
				  <td>
					<a href="javascript://" onClick="add_company('#member_id#','#fullname#','#str_company_address#','#str_company_address# #postcode# #semt# <cfif len(county)>#get_county_detail.county_name[listfind(county_id_list,county,',')]#</cfif> <cfif len(city)>#get_city_detail.city_name[listfind(city_id_list,city,',')]#</cfif> <cfif len(country)>#get_country_detail.country_name[listfind(country_id_list,country,',')]#</cfif>','#city#','<cfif len(city)>#get_city_detail.city_name[listfind(city_id_list,city,',')]#</cfif>','#county#','<cfif len(county)>#get_county_detail.county_name[listfind(county_id_list,county,',')]#</cfif>','#country#','<cfif len(country)>#get_country_detail.country_name[listfind(country_id_list,country,',')]#</cfif>','#postcode#','#semt#');" class="tableyazi">#fullname# - #address_type#</a>
				  </td>
				  <td>#address# - #semt# 
					<br/>- #postcode#  <cfif len(county)>-#get_county_detail.county_name[listfind(county_id_list,county,',')]#</cfif>
					<cfif len(city)> - #get_city_detail.city_name[listfind(city_id_list,city,',')]#</cfif>
					<cfif len(country)> - #get_country_detail.country_name[listfind(country_id_list,country,',')]#</cfif>
				  </td>
				  <td>#telcode# #tel#</td>
				  <td width="15">
				  	<cfif attributes.is_comp eq 0>                                  
				  	  <cfif branch_id eq -1>
					  	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_adress&cid=#member_id#','medium');"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>" border="0" align="absmiddle"></a>
					  </cfif>
					  <cfif branch_id neq -1>	
					  	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_adress&contactid=#branch_id#&cid=#member_id#','medium');"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>" border="0" align="absmiddle"></a>
					  </cfif>
					<cfelse>
					  <cfif branch_id eq -1>
					  	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_branch&cpid=#member_id#','medium');"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>" border="0" align="absmiddle"></a>
					  </cfif>	
					  <cfif branch_id neq -1>				  
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_branch&brid=#branch_id#&cpid=#member_id#','medium');"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>" border="0" align="absmiddle"></a>
					 </cfif>
					</cfif>
				  </td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr class="color-row">
				<td height="20" colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	   </table>
	  </td>
	</tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" height="35">
  <tr height="2"> 
	<td>
		<cf_pages page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="objects.popup_list_member_address#url_string#">
	</td>
	<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
  </tr>
</table>
</cfif>
<script type="text/javascript">
function form_cagir(member_type)
{ 
	if (member_type == 1)
		document.search_comp.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(document.search_comp.keyword.value);
	else 		
		document.search_comp.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(document.search_comp.keyword.value);
	
	document.search_comp.submit();
}
function add_company(id,name,adres,long_adres,city,city_name,county,county_name,country,country_name,postcode,semt)
{
	<cfif isdefined("attributes.field_name")>
		opener.<cfoutput>#field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		opener.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_adres")>
	
		opener.<cfoutput>#field_adres#</cfoutput>.value = adres;
	</cfif>
	<cfif isdefined("attributes.field_long_adres")>
		opener.<cfoutput>#field_long_adres#</cfoutput>.value = long_adres;
	</cfif>
	<cfif isdefined("attributes.field_city")>
		opener.<cfoutput>#field_city#</cfoutput>.value = city;
	</cfif>
	<cfif isdefined("attributes.field_city_name")>
		opener.<cfoutput>#field_city_name#</cfoutput>.value = city_name;
	</cfif>
	<cfif isdefined("attributes.field_county")>
		opener.<cfoutput>#field_county#</cfoutput>.value = county;
	</cfif>
	<cfif isdefined("attributes.field_county_name")>
		opener.<cfoutput>#field_county_name#</cfoutput>.value = county_name;
	</cfif>
	<cfif isdefined("attributes.field_country")>
		opener.<cfoutput>#field_country#</cfoutput>.value = country;
	</cfif>
	<cfif isdefined("attributes.field_country_name")>
		opener.<cfoutput>#field_country_name#</cfoutput>.value = country_name;
	</cfif>
	<cfif isdefined("attributes.field_postcode")>
		opener.<cfoutput>#field_postcode#</cfoutput>.value = postcode;
	</cfif>
	<cfif isdefined("attributes.field_semt")>
		opener.<cfoutput>#field_semt#</cfoutput>.value = semt;
	</cfif>
	<cfif isdefined("attributes.basket_cheque")>
		opener.reload_basket();
	</cfif>
	window.close();
}
</script>
