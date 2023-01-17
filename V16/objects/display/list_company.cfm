<cfinclude template="../query/get_list_companies.cfm">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_company.recordcount#">

<script type="text/javascript">
function add_company(id,adres,name)
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
	<cfif isdefined("attributes.basket_cheque")>
		opener.reload_basket();
	</cfif>
	window.close();
}
</script>

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

<table cellspacing="0" cellpadding="0" border="0" width="100%"> 
  <tr class="color-border">
	<td> 
      <table cellspacing="1" cellpadding="2" border="0" width="100%">
        <tr class="color-row">
		<cfoutput>
          <td>&nbsp;</td>
		  <td align="center" width="30"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#">123</a></td>
		  <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=A">A</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=B">B</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=C">C</a><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=Ç">Ç</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=D">D</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=E">E</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=F">F</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=G">G</a><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=Ğ">Ğ</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=H">H</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=I">I</a><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=İ">İ</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=J">J</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=K">K</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=L">L</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=M">M</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=N">N</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=O">O</a><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=Ö">Ö</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=P">P</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=Q">Q</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=R">R</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=S">S</a><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=Ş">Ş</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=T">T</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=U">U</a><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=Ü">Ü</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=V">V</a><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=W">W</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=Y">Y</a></td>
          <td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_comps#url_string#&keyword=Z">Z</a></td>
		  <td>&nbsp;</td>
		</cfoutput>
        </tr>
      </table>
	</td>
  </tr>
</table>
<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></td>
	<td  valign="bottom" style="text-align:right;"> 
      <table>
        <cfform name="search_comp" action="#request.self#?fuseaction=objects.popup_list_comps" method="post">
			<cfif isdefined("attributes.field_adres")>
			<input  type="hidden" name="field_adres" id="field_adres" value="<cfoutput>#attributes.field_adres#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_name")>
				<input  type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_id")>
				<input  type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
			</cfif>
          <tr> 
            <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
            <td><cfinput name="keyword" type="text" maxlength="255" value="#attributes.keyword#"></td>
            <td><cf_wrk_search_button></td>
		  </tr>
        </cfform>
      </table>
    </td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border"> 
    <td> 
      <table cellpadding="2" cellspacing="1" border="0" width="100%" align="center">
        <tr class="color-header" height="22"> 
			<td width="75" class="form-title"><cf_get_lang dictionary_id='32688.Şirket No'></td>
			<td class="form-title"><cf_get_lang dictionary_id='58485.Şirket Adı'></td>
			<td class="form-title"><cf_get_lang dictionary_id='32689.Şirket Adresi'></td>
			<td class="form-title" width="100"><cf_get_lang dictionary_id='32851.kod / telefon'></td>
		</tr>
		<cfif get_company.recordcount>
			<cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset cname = company_address>
				<cfset rm = '#chr(10)#'>
				<cfset cname = ReplaceList(cname,rm,'')>
				<cfset str_company_address = ReplaceList(company_address,rm,'')>				
				<cfset rm = '#chr(13)#'>
				<cfset cname = ReplaceList(cname,rm,'')>			
				<cfset str_company_address = ReplaceList(str_company_address,rm,'')>
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td height="20">#member_code#</td>
					<td><a href="javascript://" onClick="add_company('#company_id#','#str_company_address# #country#/#CITY# <cf_get_lang dictionary_id='49272.Tel'>/<cf_get_lang dictionary_id='31264.Posta Kod'> : #COMPANY_TELCODE#/#COMPANY_POSTCODE#','#fullname#');" class="tableyazi">#fullname#</a></td>
					<td>#company_address# #COMPANY_POSTCODE# #CITY# #country#</td>
					<td>#COMPANY_TELCODE# #COMPANY_TEL1#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr class="color-row">
				<td height="20" colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
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
			adres="objects.popup_list_comps#url_string#">
	</td>
	<!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
  </tr>
</table>
</cfif>
