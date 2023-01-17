<cfparam name="attributes.keyword" default="">
<cfquery name="get_city" datasource="#dsn#">
	SELECT
		S.CITY_NAME,
		S.CITY_ID
	FROM
		SETUP_CITY S
	WHERE
		S.CITY_NAME IS NOT NULL
		<cfif isdefined("attributes.country_id")>AND S.COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#"></cfif>
		<cfif len(attributes.keyword)>AND S.CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
	ORDER BY
		S.CITY_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.cp.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_city.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "&field_name=#attributes.field_name#&field_id=#attributes.field_id#&country_id=#attributes.country_id#">
<script type="text/javascript">
	function gonder(city_id,city)
	{
		opener.<cfoutput>#attributes.field_name#</cfoutput>.value=city;
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value=city_id;
		window.close();
	}
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
<cfform action="#request.self#?fuseaction=objects2.popup_dsp_city_ik#url_str#" name="search_form" method="post">
  <tr>
  	<td height="35" class="headbold"><h5><cf_get_lang no='24.İller'></h5></td>
	<td  style="text-align:right;">
		<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
		<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
		<cf_wrk_search_button>
	</td>
  </tr>
</cfform>
</table>
<table cellpadding="5" cellspacing="0" width="95%" border="0">
  <tr bgcolor="#FFB74A">
	<td class="form-title" width="30"><cf_get_lang_main no='75.No'></td>
	<td class="form-title"><cf_get_lang_main no='559.İl'></td>
  </tr>
</table>
<table cellspacing="1" cellpadding="2" width="95%" border="0" class="ik1">
	<cfif get_city.recordcount>
	<cfoutput query="get_city" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
		<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<td width="30">#currentrow#</td>
			<td><a href="javascript://" class="tableyazi" onClick="gonder('#city_id#','#trim(city_name)#')">#CITY_NAME#</a></td>
		</tr>		
	</cfoutput>
	<cfelse>
	<tr class="color-row">
		<td colspan="2" height="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
	</tr>
	</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
</table>
<table width="100%">
     <tr>
		<td colspan="2">
			<cfif attributes.totalrecords gt attributes.maxrows>
				<table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center" bgcolor="#FFFFFF">
					<tr bgcolor="#FFFFFF">
					  <td> <cf_pages 
							page="#attributes.page#" 
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="objects2.popup_dsp_city_ik#url_str#"> </td>
					  <td  style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
					</tr>
				</table>
		  </cfif>
		</td>
	</tr>
</table>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
