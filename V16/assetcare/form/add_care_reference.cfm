<cfparam name="attributes.make_year" default="">
<cfparam name="attributes.care_type_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.brand_type_id" default="">
<cf_popup_box>
<cfform name="add_care_reference" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_care_reference" onSubmit="return(unformat_fields());">
<input type="hidden" name="is_detail" id="is_detail" value="0">
<input type="hidden" name="is_submit" id="is_submit" value="">
	<table>
			<cfif isdefined("attributes.is_submit")>
				<cfquery name="get_start_km" datasource="#dsn#">
				SELECT 
					MAX(FINISH_KM) AS MAX_FINISH_KM
				FROM
					ASSET_P_CARE_REFERENCE
				WHERE
					CARE_TYPE_ID = #attributes.care_type_id# AND
					BRAND_TYPE_ID = #attributes.brand_type_id# AND
					MAKE_YEAR = #attributes.make_year#
				</cfquery>
			</cfif>
		<tr>
			<td width="80"><cf_get_lang no='42.Bakım Tipi'> *</td>
			<td width="200"><select name="care_type_id" id="care_type_id" style="width:150" onChange="bakim_kontrol();">
					<option value=""></option>
					<option value="1" <cfif attributes.care_type_id eq 1>selected</cfif>><cf_get_lang no='378.Periyodik'></option>
					<option value="2" <cfif attributes.care_type_id eq 2>selected</cfif>><cf_get_lang no='379.Yağ'></option>
				</select></td>
			<td width="80"><cf_get_lang no='231.Başlangıç KM'> *</td>
			<td width="140">
				<cfif isDefined("attributes.is_submit")>
					<input type="text" name="start_km" id"start_km" onKeyup='return(FormatCurrency(this,event));' style="width:100px;" value="<cfoutput>#TLFormat(get_start_km.max_finish_km,0)#</cfoutput>" <cfif len(get_start_km.max_finish_km)>readonly</cfif>>
				<cfelse>
					<input type="text" name="start_km" id="start_km" onKeyup='return(FormatCurrency(this,event));' style="width:100px;">
				</cfif>
			</td>
		</tr>
		<tr>
			<td width="100"><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'> *</td>
			<td><input type="hidden" name="brand_type_id" id="brand_type_id" value="<cfoutput>#attributes.brand_type_id#</cfoutput>">
			  <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></cfsavecontent>
			<cfinput type="text" name="brand_name" value="#attributes.brand_name#" readonly required="yes" message="#message#" style="width:150px;">
			<a href="javascript://" onClick="pencere_ac();"> <img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'>" align="absmiddle" border="0"></a></td>
			<td><cf_get_lang no='237.Bitiş KM '>*</td>
			  <cfsavecontent variable="message"><cf_get_lang no='654.Bitiş KM Giriniz'></cfsavecontent>
			<td><cfinput  type="text" name="finish_km" onKeyup="return(FormatCurrency(this,event,0));" required="yes" message="#message#" style="width:100px;">
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')"></a></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='813.Model'> *</td>
			<td><select name="make_year" id="make_year" style="width:150px;" onchange="model_kontrol();">
				<option value=""></option>
				<cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
					<cfoutput>
						<cfloop from="#yil#" to="1970" index="i" step="-1">
						  <option value="#i#" <cfif i eq attributes.make_year>selected</cfif>>#i#</option>
						</cfloop>
					</cfoutput>
				</select></td>
			<td><cf_get_lang no='377.Kontrol KM'> *</td>
			  <cfsavecontent variable="message"><cf_get_lang no='684.Kontrol KM Giriniz'></cfsavecontent>
			<td><cfinput type="text" name="period_km" onKeyup="return(FormatCurrency(this,event,0));" required="yes" message="#message#" style="width:100px;"></td>
		</tr>
	</table>
	<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='0' is_cancel='0' is_reset='0' add_function='kontrol()'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
	  var fld = document.add_care_reference.start_km;
	  var fld2 = document.add_care_reference.finish_km;
	  var fld3 = document.add_care_reference.period_km;
	function unformat_fields()
	{
	  fld.value = filterNum(fld.value);
	  fld2.value = filterNum(fld2.value);
	  fld3.value  = filterNum(fld3.value);
	}
	function pencere_ac()
	{
		a = document.add_care_reference.care_type_id.selectedIndex;
		if (document.add_care_reference.care_type_id[a].value == "")
		{
			document.add_care_reference.brand_name.value = "" ;
			document.add_care_reference.brand_type_id.value = "" ;
			alert("<cf_get_lang no='558.Öncellikle Bakım Tipi Girmelisiniz'>!");
			return false;
		}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_brand_type&field_brand_type_id=add_care_reference.brand_type_id&field_brand_name=add_care_reference.brand_name&is_calistir=1&select_list=2','list');
	}
	function bakim_kontrol()
	{
		if(document.add_care_reference.care_type_id.value != "" && document.add_care_reference.brand_name.value != "" && document.add_care_reference.make_year.value != "")
		{
			add_care_reference.action = "";
			add_care_reference.submit() ;
		}
	}
	function marka_kontrol()
	{
		if(document.add_care_reference.care_type_id.value != "" && document.add_care_reference.brand_name.value != "" && document.add_care_reference.make_year.value != "")
		{
			add_care_reference.action = "";
			add_care_reference.submit();
		}
	}
	function model_kontrol()
	{
		if(document.add_care_reference.make_year.value == "")
		{
			document.add_care_reference.make_year.options[0].selected = true;
			alert("<cf_get_lang no='226.Model Girmelisiniz'>!");
			return false;
		}
		if(document.add_care_reference.brand_type_id.value == "")
		{
			document.add_care_reference.make_year.options[0].selected = true;
			alert("<cf_get_lang no='748.Marka / Marka Tipi Girmelisiniz'>!");
			return false;
		}
		if(document.add_care_reference.care_type_id.value != "" && document.add_care_reference.brand_name.value != "" && document.add_care_reference.make_year.value != "")
		{
			add_care_reference.action = "";
			add_care_reference.submit();
		}
	}
	function kontrol()
	{
		a = filterNum(fld.value);
	  	b = filterNum(fld2.value);
	    c  = filterNum(fld3.value);
		x = document.add_care_reference.care_type_id.selectedIndex;
		if (document.add_care_reference.care_type_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='42.Bakım Tipi'>");
			return false;
		}
		
		y = document.add_care_reference.make_year.selectedIndex;
		if (document.add_care_reference.make_year[y].value == "")
		{ 
			alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='813.Model'>");
			return false;
		}
		if(a >= b)
		{
			alert("<cf_get_lang no='698.Başlangış - Bitiş KM Aralığını Kontrol Ediniz'>!");
			return false;
		}
		
		if(c > (b - a))
		{
			alert("<cf_get_lang no='701.Kontrol KM Değerini Kontrol Ediniz'>!");
			return false;
		}
		return true;
	}
</script>
