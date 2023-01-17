<cfparam name="attributes.keyword" default="">
<cfquery name="GET_CITIES" datasource="#dsn#">
	SELECT 
		CITY_ID,
		CITY_NAME
	FROM 
		SETUP_CITY	
	<cfif len(attributes.keyword)>
		WHERE CITY_NAME LIKE '%#attributes.keyword#%'
	</cfif>
	ORDER BY
		CITY_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_CITIES.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	function gonder(city_id,city)
	{
	var kontrol =0;
	uzunluk=opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++){
		if(opener.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==city_id){
			kontrol=1;
		}
	}
	if(kontrol==0){
		<cfif isDefined("attributes.field_name")>
			x = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = city_id;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = city;
		</cfif>
		}
	}
</script>
<cfset url_string = "">
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>

<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="headbold"><cf_get_lang dictionary_id='57971.Sehir'></td>
	<!-- sil -->
    <td  class="headbold" style="text-align:right;"><table>
      <cfform action="#request.self#?fuseaction=objects.popup_list_cities#url_string#" method="post" name="search">
        <tr>
          <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
          <td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255"></td>
          <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
          <td><cf_wrk_search_button></td>          
        </tr>
      </cfform>
    </table></td>
	<!-- sil -->
  </tr>
</table>

<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-header">
          <td height="22" class="form-title"><cf_get_lang dictionary_id='57453.Şube'></td>
        </tr>
        <cfif get_cities.recordcount>
          <cfoutput query="get_cities" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
             <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
               <td>
				<a href="javascript://" onClick="gonder('#city_id#','#city_name#');" class="tableyazi">#city_name#</a>
				</td>
              </tr>
          </cfoutput>
        <cfelse>
          <tr height="20" class="color-row">
            <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif len(attributes.keyword)>
  <cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" border="0" cellpadding="0" cellspacing="0" height="35" align="center">
    <tr>
      <td><cf_pages 
		  page="#attributes.page#" 
		  maxrows="#attributes.maxrows#" 
		  totalrecords="#attributes.totalrecords#" 
		  startrow="#attributes.startrow#" 
		  adres="objects.popup_list_cities#url_string#"></td>
      <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
