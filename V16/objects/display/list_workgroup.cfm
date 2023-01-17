<cfparam name="attributes.keyword" default="">
<cfquery name="GET_WORK_GROUP" datasource="#DSN#">
	SELECT WORKGROUP_NAME, WORKGROUP_ID FROM WORK_GROUP WHERE WORKGROUP_ID IS NOT NULL <cfif len(attributes.keyword)>AND WORKGROUP_NAME LIKE '%#attributes.keyword#%'</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_work_group.recordcount#>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	function gonder(no,deger)
	{
		<cfif isDefined("attributes.field_id")>
			opener.<cfoutput>#attributes.field_id#</cfoutput>.value=no;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			opener.<cfoutput>#attributes.field_name#</cfoutput>.value=deger;
		</cfif>
		window.close();
	}
</script>
<cfset url_string = "">
<cfif isdefined("field_id")>
  <cfset url_string = "#url_string#&field_id=#field_id#">
</cfif>
<cfif isdefined("field_name")>
  <cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang dictionary_id='29818.İş Grupları'></td>
    <td width="250"  style="text-align:right;">
      <table>
        <tr>
          <cfform name="search_con" action="#request.self#?fuseaction=objects.popup_list_workgroup" method="post">
            <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
            <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
              <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
            <td><cf_wrk_search_button></td>
          </cfform>
        </tr>
      </table>
    </td>
  </tr>
</table>
<table cellpadding="0" cellspacing="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
      <table cellpadding="2" cellspacing="1" border="0" width="100%">
        <tr height="22" class="color-header">
          <td width="100" class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
          <td class="form-title"><cf_get_lang dictionary_id='58140.İş Grubu'></td>
        </tr>
        <cfif get_work_group.recordcount>
          <cfoutput query="get_work_group" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td><a href="javascript://" onclick="gonder('#workgroup_id#','#workgroup_name#');" class="tableyazi">#workgroup_id#</a></td>
              <td><a href="javascript://" onclick="gonder('#workgroup_id#','#workgroup_name#');" class="tableyazi">#workgroup_name#</a></td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row">
            <td colspan="2" height="20"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.maxrows lt attributes.totalrecords>
  <table width="98%" border="0" cellpadding="0" cellspacing="0" height="35" align="center">
    <tr>
      <td><cf_pages
	  page="#attributes.page#" 
	  maxrows="#attributes.maxrows#" 
	  totalrecords="#attributes.totalrecords#" 
	  startrow="#attributes.startrow#" 
	  adres="objects.popup_list_workgroup#url_string#&keyword=#attributes.keyword#"></td>
      <!-- sil -->
      <td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
      <!-- sil -->
    </tr>
  </table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
