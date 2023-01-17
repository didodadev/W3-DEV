<cfinclude template="../query/get_care_reference_upd.cfm">
<cfsavecontent variable="right"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_care_reference"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></cfsavecontent>
<cf_popup_box title="#getLang('assetcare',381)#" right_images="#right#">
<cfform name="upd_care_reference" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_care_reference">
<input type="hidden" name="care_reference_id" id="care_reference_id" value="<cfoutput>#get_care_reference_upd.care_reference_id#</cfoutput>">			  
	<table>
		<tr>
			<td width="120"><cf_get_lang no='42.Bakım Tipi'> *</td>
			<td width="200"><select name="care_type_id" id="care_type_id" style="width:150">
					<option value=""></option>
					<option value="1" <cfif get_care_reference_upd.care_type_id eq 1>selected</cfif>><cf_get_lang no='378.Periyodik'></option>
					<option value="2" <cfif get_care_reference_upd.care_type_id eq 2>selected</cfif>><cf_get_lang no='379.Yağ'></option>
				</select>
			</td>				  
		</tr>
		<tr>
			<td><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'> *</td>
			<td><input type="hidden" name="brand_type_id" id="brand_type_id" value="<cfoutput>#get_care_reference_upd.brand_type_id#</cfoutput>">
            <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></cfsavecontent>
			<cfinput type="text" name="brand_name" value="#get_care_reference_upd.brand_name# #get_care_reference_upd.brand_type_name#" readonly required="yes" message="#message#" style="width:150px;">
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_brand_type&field_brand_type_id=upd_care_reference.brand_type_id&field_brand_name=upd_care_reference.brand_name','list');"> <img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'>" align="absmiddle" border="0"></a></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='813.Model'> *</td>
			<td><select name="make_year" id="make_year" style="width:150px;">
					<option value=""></option>
					<cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
					<cfoutput>
						<cfloop from="#yil#" to="1970" index="i" step="-1">
							<option value="#i#" <cfif #i# eq get_care_reference_upd.make_year>selected</cfif>>#i#</option>
						</cfloop>
					</cfoutput>
				</select>
			</td>			  
		</tr>
		<tr>
			<td width="80"><cf_get_lang no='231.Başlangıç KM'> *</td>
            <cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='231.Başlangıç KM'></cfsavecontent>
			<td width="140"><cfinput type="text" name="start_km" value="#tlformat(get_care_reference_upd.start_km)#" onKeyup="return(FormatCurrency(this,event));" required="yes" validate="integer" message="#message#" style="width:150px;"></td>
		</tr>
		<tr>
			<td><cf_get_lang no='237.Bitiş KM'> *</td>
            <cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='237.Bitiş KM'></cfsavecontent>
			<td><cfinput  type="text" name="finish_km" value="#tlformat(get_care_reference_upd.finish_km)#" onKeyup="return(FormatCurrency(this,event));" required="yes" validate="integer" message="#message#" style="width:150px;">
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')"></a></td>
		</tr>
		<tr>
			<td><cf_get_lang no='377.Kontrol KM'> *</td>
            <cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='377.Kontrol KM'></cfsavecontent>
			<td><cfinput type="text" name="period_km" value="#tlformat(get_care_reference_upd.period_km)#" onKeyup="return(FormatCurrency(this,event));" required="yes" validate="integer" message="#message#" style="width:150px;"></td>
		</tr>
	</table>
	<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' is_cancel='0' add_function='kontrol()'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
	function kontrol()
	{
		x = document.upd_care_reference.care_type_id.selectedIndex;
		if (document.upd_care_reference.care_type_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='42.Bakım Tipi'>");
			return false;
		}
		
		y = document.upd_care_reference.make_year.selectedIndex;
		if (document.upd_care_reference.make_year[y].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='813.Model'>");
			return false;
		}

		new_start_km = filterNum(document.upd_care_reference.start_km.value);
		new_finish_km = filterNum(document.upd_care_reference.finish_km.value);

		if(parseFloat(new_start_km) >= parseFloat(new_finish_km))
		{
			alert("Başlangış - Bitiş KM Aralığını Kontrol Ediniz!");
			return false;
		}

		new_period_km = filterNum(document.upd_care_reference.period_km.value);

		if(parseFloat(new_period_km) > parseFloat(new_finish_km))
		{
			alert("Kontrol KM Değerini Kontrol Ediniz!");
			return false;
		}	
		
		document.upd_care_reference.start_km.value = new_start_km;
		document.upd_care_reference.finish_km.value = new_finish_km;
		document.upd_care_reference.period_km.value = new_period_km;
		return true;
	}
</script>
