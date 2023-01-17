<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
	<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
	<cfset GET_CITY = get_components.GET_CITY(
		city_id: attributes.city_id
	)>
</cfif>
<cfset GET_COUNTY = get_components.GET_COUNTY_WITH_CITY(
	city_id: attributes.city_id,
	keyword: attributes.keyword
)>

<script type="text/javascript">
	<cfif not isdefined("attributes.coklu_secim")>
	function gonder(id,name)
	{
	   <cfif isDefined("attributes.field_id")>
			opener.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			opener.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
		</cfif>
		window.close();
	}
	<cfelse>
	function gonder(county_id,county)
	{
		var kontrol =0;
		uzunluk=opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
		for(i=0;i<uzunluk;i++){
			if(opener.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==county_id){
				kontrol=1;
			}
		}
		if(kontrol==0){
			<cfif isDefined("attributes.field_name")>
				x = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
				opener.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
				opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = county_id;
				opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = county;
			</cfif>
		}
	}
	</cfif>
</script>
<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%;">
  	<tr style="height:35px;">
  		<td class="headbold"><cf_get_lang no='387.İlçeler'> <cfif isdefined("attributes.city_id") and len(attributes.city_id)><cfoutput>: #get_city.city_name#</cfoutput></cfif></td>
  	</tr>
</table>
<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%;">
  	<tr class="color-border">
    	<td>
      		<table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
                <tr class="color-header" style="height:22px;">		
                    <td class="form-title" style="width:30px;"><cf_get_lang_main no='75.No'></td>
                    <td class="form-title"><cf_get_lang_main no='559.İl'></td>
                    <td class="form-title"><cf_get_lang_main no='1226.İlçe'></td>
                </tr>
				<cfif get_county.recordcount>
					<cfoutput query="get_county">		
                        <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
                            <td>#currentrow#</td>
                            <td>#city_name#</td>
                            <td><a href="javascript://" class="tableyazi"  onClick="gonder('#county_id#','#county_name#')">#county_name#</a></td>
                        </tr>		
                    </cfoutput>
                <cfelse>
                    <tr class="color-row" style="height:20px;">
                        <td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
                    </tr>
                </cfif>
			</table>
		</td>
	</tr>
</table>
