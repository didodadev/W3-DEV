<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.city_id")>
	<cfquery name="GET_CITY" datasource="#dsn#">
		SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#"> 
	</cfquery>
</cfif>
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
		<cfif isdefined("attributes.city_id")>AND SC.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#"></cfif>
		<cfif len(attributes.keyword)>AND SC.COUNTY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
	ORDER BY
		SC.COUNTY_NAME
</cfquery>
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
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
  	<td height="35" class="headbold"><h5><cf_get_lang no='387.İlçeler'> <cfif isdefined("attributes.city_id")><cfoutput>: #get_city.city_name#</cfoutput></cfif></h5></td>
  </tr>
</table>
<table cellpadding="5" cellspacing="0" width="95%" border="0">
	<tr height="22" bgcolor="#FFB74A">		
        <td class="form-title" width="30"><cf_get_lang_main no='75.No'></td>
		<td class="form-title"><cf_get_lang_main no='559.İl'></td>
		<td class="form-title"><cf_get_lang_main no='1226.İlçe'></td>
	</tr>
</table>
<table cellspacing="1" cellpadding="2" width="95%" border="0" class="ik1">
	<cfif get_county.recordcount>
		<cfoutput query="get_county">		
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td width="30">#currentrow#</td>
				<td>#CITY_NAME#</td>
				<td><a href="javascript://" class="tableyazi"  onClick="gonder('#county_id#','#county_name#')">#county_name#</a></td>
			</tr>		
		</cfoutput>
	<cfelse>
		<tr class="color-row">
			<td colspan="3" height="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
		</tr>
	</cfif>
</table>

