<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.country_id" default="1">
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT
		CITY_NAME,
		CITY_ID,
		PHONE_CODE
	FROM
		SETUP_CITY
	WHERE
		CITY_NAME IS NOT NULL
		<cfif isdefined("attributes.country_id")>AND COUNTRY_ID = #attributes.country_id#</cfif>
		<cfif len(attributes.keyword)>AND CITY_NAME LIKE '#attributes.keyword#%'</cfif>
	ORDER BY
		CITY_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_city.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset url_str = "&field_name=#attributes.field_name#&field_id1=#attributes.field_id1#&field_id2=#attributes.field_id2#&field_id3=#attributes.field_id3#">
<script type="text/javascript">

	var selectedHashTable1 = new Hashtable();
	var selectedHashTable2 = new Hashtable();
	var selectedHashTable3 = new Hashtable();
	var selectedHashTable4 = new Hashtable();
	var selectedRowIndex   = new Hashtable();
	function gonder(obj, city_name, city_id)
	{
		var county_id = eval("document.getElementById('county_id" + city_id + "')");
		if(!selectedHashTable1.containsKey(city_name)){
			selectedHashTable1.put(city_name, document.all.country_name.value + "/" + city_name + " - " + eval("document.getElementById('county_name" + city_id + "').value"));
			selectedHashTable2.put(city_name, document.all.country_id.value);
			selectedHashTable3.put(city_name, city_id);
			selectedHashTable4.put(city_name, county_id.value);
			selectedRowIndex.put(obj.parentNode.parentNode.rowIndex, '#3399FF');
			setFormValues();
		}
		else{
			selectedHashTable1.remove(city_name);
			selectedHashTable2.remove(city_name);
			selectedHashTable3.remove(city_name);
			selectedHashTable4.remove(city_name);
			selectedRowIndex.remove(obj.parentNode.parentNode.rowIndex);
			setFormValues();
		}
		//obj.parentNode.parentNode.bgColor = '#3399FF';
		//alert(county_id.value);
		//window.close();
	}
	function setFormValues(){
		selectedHashTable1.moveFirst();
		selectedHashTable2.moveFirst();
		selectedHashTable3.moveFirst();
		selectedHashTable4.moveFirst();
		opener.<cfoutput>#attributes.field_name#</cfoutput>.value = '';
		opener.<cfoutput>#attributes.field_id1#</cfoutput>.value  = '';
		opener.<cfoutput>#attributes.field_id2#</cfoutput>.value  = '';
		opener.<cfoutput>#attributes.field_id3#</cfoutput>.value  = '';
		while (selectedHashTable1.next()){
			selectedHashTable2.next();
			selectedHashTable3.next();
			selectedHashTable4.next();
			if(selectedHashTable1.location != 0){
				opener.<cfoutput>#attributes.field_name#</cfoutput>.value = opener.<cfoutput>#attributes.field_name#</cfoutput>.value + '\n' + selectedHashTable1.getValue();
				opener.<cfoutput>#attributes.field_id1#</cfoutput>.value  = opener.<cfoutput>#attributes.field_id1#</cfoutput>.value + ',' + selectedHashTable2.getValue();
				opener.<cfoutput>#attributes.field_id2#</cfoutput>.value  = opener.<cfoutput>#attributes.field_id2#</cfoutput>.value + ',' + selectedHashTable3.getValue();
				opener.<cfoutput>#attributes.field_id3#</cfoutput>.value  = opener.<cfoutput>#attributes.field_id3#</cfoutput>.value + ',' + selectedHashTable4.getValue();
			}
			else{
				opener.<cfoutput>#attributes.field_name#</cfoutput>.value = selectedHashTable1.getValue();
				opener.<cfoutput>#attributes.field_id1#</cfoutput>.value  = selectedHashTable2.getValue();
				opener.<cfoutput>#attributes.field_id2#</cfoutput>.value  = selectedHashTable3.getValue();
				opener.<cfoutput>#attributes.field_id3#</cfoutput>.value  = selectedHashTable4.getValue();
			}
		}
		//alert(opener.<cfoutput>#attributes.field_name#</cfoutput>.value + ' - ' + opener.<cfoutput>#attributes.field_id1#</cfoutput>.value + ' - ' + opener.<cfoutput>#attributes.field_id2#</cfoutput>.value + ' - ' + opener.<cfoutput>#attributes.field_id3#</cfoutput>.value);
	}
	function setCountryName(name){
		document.search_form.country_name.value = name;
	}
	function setCountyName(id, name){
		var county_name = eval("document.search_form.county_name" + id);
		county_name.value = name;
	}
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
<cfform name="search_form" method="post" action="#request.self#?fuseaction=objects.popup_tm_locations#url_str#">
  <tr>
  	<td height="35" class="headbold"><cf_get_lang dictionary_id='59129.İller'></td>
	<td  style="text-align:right;">
	  <input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
	  <input type="hidden" name="country_name" id="country_name" value="Türkiye">
	  <select name="country_id" id="country_id" onChange="setCountryName(this.options[this.selectedIndex].text)" style="width:150px;">
	  <option value="-1"><cf_get_lang dictionary_id='59129.Seçiniz'></option>
	  <cfoutput query="get_country">
		<option value="#country_id#" <cfif country_id eq attributes.country_id>selected</cfif>>#country_name#</option>
	  </cfoutput>
	  </select>
	  <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
	  <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
	  <cf_wrk_search_button>
	</td>
  </tr>
</cfform>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
	<td>
	<table cellspacing="1" cellpadding="2" width="100%" border="0">
	  <tr height="22" class="color-header">		
		<td class="form-title" width="30"><cf_get_lang dictionary_id='57487.No'></td>
		<td class="form-title"><cf_get_lang dictionary_id='58608.İl'></td>
		<td class="form-title"><cf_get_lang dictionary_id='58638.İlçe'></td>
	  </tr>
	  <cfif get_city.recordcount>
	  <cfoutput query="get_city"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
	  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="if(selectedRowIndex.containsKey(this.rowIndex)) this.bgColor=selectedRowIndex.getValue(); else this.className='color-row';" class="color-row">
		<td width="30">#currentrow#</td>
		<td><a href="javascript://" class="tableyazi" onClick="gonder(this, '#trim(city_name)#', '#trim(city_id)#')">#city_name#</a></td>
		<td width="100">
			<cfquery name="GET_COUNTY" datasource="#dsn#">
				SELECT
					SC.COUNTY_ID,
					SC.COUNTY_NAME,
					S.CITY_NAME
				FROM
					SETUP_COUNTY SC,
					SETUP_CITY S
				WHERE
					SC.CITY = S.CITY_ID
				AND 
					SC.CITY = #city_id#
				ORDER BY
					SC.COUNTY_NAME
			</cfquery>
		  <input type="hidden" name="county_name#city_id#" id="county_name#city_id#" value="">
		  <select name="county_id#city_id#" id="county_id#city_id#" onChange="setCountyName('#trim(city_id)#', this.options[this.selectedIndex].text)" style="width:150px;">
		  	<option value="-1">Seçiniz</option>
		  <cfset index = 1>
		  <cfloop query="GET_COUNTY">
			<option value="#GET_COUNTY.COUNTY_ID[index]#">#GET_COUNTY.COUNTY_NAME[index]#</option>
		  <cfset index = index + 1>
		  </cfloop>
		  </select>
		</td>
	  </tr>
	  </cfoutput>
	  <cfelse>
	  <tr class="color-row">
		<td colspan="3" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
	  </tr>
	  </cfif>
	  <cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	  </cfif>
	</table>
   </td>
  </tr>
  <tr>
	<td>
	  <cfif attributes.totalrecords gt attributes.maxrows>
	  <table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center" bgcolor="#FFFFFF">
		<tr bgcolor="#FFFFFF">
		  <td>
		      <cf_pages page = "#attributes.page#"
		  			 maxrows = "#attributes.maxrows#"
				totalrecords = "#attributes.totalrecords#" 
				    startrow = "#attributes.startrow#" 
					   adres = "objects.popup_dsp_city#url_str#">
		  </td>
		  <td  style="text-align:right;"><cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	  </table>
	  </cfif>
	</td>
</tr>
</table>
