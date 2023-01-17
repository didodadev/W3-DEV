<cfparam name="attributes.keyword" default="">

<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset GET_CITY = get_components.GET_CITY(
	country_id: attributes.country_id,
	keyword: attributes.keyword
)>
<cfset url_str = "&field_name=#attributes.field_name#&field_id=#attributes.field_id#">
<cfif isdefined("attributes.country_id")>
	<cfset url_str = "#url_str#&country_id=#attributes.country_id#">
</cfif>
<cfif isdefined("attributes.field_phone_code")>
	<cfset url_str = "#url_str#&field_phone_code=#attributes.field_phone_code#">
</cfif>
<cfif isdefined("attributes.field_phone_code2")>
	<cfset url_str = "#url_str#&field_phone_code2=#attributes.field_phone_code2#">
</cfif>
<cfif isdefined("attributes.coklu_secim")>
	<cfset url_str = "#url_str#&coklu_secim=#attributes.coklu_secim#">
</cfif>
<script type="text/javascript">
<cfif not isdefined("attributes.coklu_secim")>
	function gonder(city_id,city,phone_code)
	{
		opener.<cfoutput>#attributes.field_name#</cfoutput>.value=city;
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value=city_id;
		<cfif isdefined("attributes.field_phone_code")>
			opener.<cfoutput>#attributes.field_phone_code#</cfoutput>.value=phone_code;
		</cfif>
		<cfif isdefined("attributes.field_phone_code2")>
			opener.<cfoutput>#attributes.field_phone_code2#</cfoutput>.value=phone_code;
		</cfif>
		window.close();
	}
<cfelse>
	function gonder(city_id,city,phone_code)
	{
		var kontrol =0;
		uzunluk=opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
		for(i=0;i<uzunluk;i++){
			if(opener.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==city_id){
				kontrol=1;
			}
		}
		if(kontrol==0)
		{
			<cfif isDefined("attributes.field_name")>
				x = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
				opener.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
				opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = city_id;
				opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = city;
			</cfif>
			}
		}
	</cfif>
</script>

<cfform name="search_form" method="post" action="#request.self#?fuseaction=objects2.popup_dsp_city#url_str#">
	<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%;">
  		<tr style="height:35px;">
  			<td class="headbold"><cf_get_lang dictionary_id='34345.Cities'></td>
			<td  style="text-align:right;">
	  			<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
	  			<cf_wrk_search_button>
			</td>
  		</tr>
	</table>
</cfform>
<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%;">
  	<tr class="color-border">
		<td>
			<table cellspacing="1" cellpadding="2" style="width:100%;">
	  			<tr class="color-header" style="height:22px;">		
                    <td class="form-title" style="width:30px;"><cf_get_lang dictionary_id='57487.Number'></td>
                    <td class="form-title"><cf_get_lang dictionary_id='57971.Province'></td>
	  			</tr>
				<cfif get_city.recordcount>
                <cfoutput query="get_city">		
                    <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
                        <td style="width:30px;">#currentrow#</td>
                        <td><a href="javascript://" class="tableyazi" onClick="gonder('#city_id#','#trim(city_name)#','#phone_code#')">#city_name#</a></td>
                    </tr>		
                </cfoutput>
                <cfelse>
                    <tr class="color-row" style="height:20px;">
                    	<td colspan="3"><cf_get_lang dictionary_id='57484.No record'> !</td>
                    </tr>
                </cfif>
                <cfif len(attributes.keyword)>
                	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
                </cfif>
			</table>
   		</td>
  	</tr>
</table>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
