<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.is_submitted" default="">
<table width="100%" height="100%" align="center" cellpadding="2" cellspacing="1" border="0">
  <tr class="color-row">
    <td valign="top">
      <table>
        <cfform name="search_care_reference" target="frame_care_reference_search" method="post" action="#request.self#?fuseaction=assetcare.popup_list_care_ref_search&is_submitted=1&iframe=1" onsubmit="return(kontrol());">
		  <tr>
			<td width="100"><cf_get_lang no='42.Bakım Tipi'></td>
			<td width="200"><select name="care_type_id" id="care_type_id" style="width:150">
			  <option value=""></option>
			  <option value="1"><cf_get_lang no='378.Periyodik'></option>
			  <option value="2"><cf_get_lang no='379.Yağ'></option>
		    </select></td>
			<td width="50"><cf_get_lang_main no='813.Model'></td>
			<td><select name="make_year" id="make_year" style="width:150px;">
			  <option value=""></option>
			  <cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
			  <cfoutput>
			  <cfloop from="#yil#" to="1970" index="i" step="-1">
				<option value="#i#">#i#</option>
			  </cfloop>
			  </cfoutput>
		      </select></td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></td>
			<td>
			<input type="hidden" name="brand_type_id" id="brand_type_id" value="">
			  <cfinput type="text" name="brand_name" value="" readonly style="width:150px;">
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_brand_type&field_brand_type_id=search_care_reference.brand_type_id&field_brand_name=search_care_reference.brand_name&select_list=2','list','popup_list_brand_type');"> <img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'>" align="absmiddle" border="0"></a>
			</td>
			<td>
			
			</td>
			<td style="text-align:right;">
			<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			<input type="submit" value="Ara">
				
			&nbsp;
			<input type="reset" value="<cf_get_lang_main no='522.Temizle'>"></td>
          </tr>
        </cfform>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">	
function kontrol()
{
	if(document.search_care_reference.maxrows.value>200)
	{
		alert('Maxrows Değerini Kontrol Ediniz !');
		return false;
	}
	return true;
}
</script>

