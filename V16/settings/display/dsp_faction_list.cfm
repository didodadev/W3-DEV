<script type="text/javascript">
	function add_faction(f_name)
	{
		
		var x = opener.<cfoutput>#attributes.field_name#</cfoutput>.value;
		if (form1.click_count.value==0)
		{
			form1.click_count.value = 1;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.value = x + f_name;
		}
		else
		{
			opener.<cfoutput>#attributes.field_name#</cfoutput>.value = x + ',' +f_name;
		}
	}
</script>
<cfif isDefined("attributes.module") AND len(attributes.module)>
	<cfquery name="GET_NAME" datasource="#DSN#">
		SELECT MODULE_SHORT_NAME FROM MODULES WHERE MODULE_ID = #attributes.module#
	</cfquery>
</cfif>
<cfinclude template="../query/get_faction.cfm">
<cfquery name="get_modules" datasource="#dsn#">
	SELECT MODULE_SHORT_NAME,MODULE_ID FROM MODULES WHERE MODULE_SHORT_NAME<> '' ORDER BY MODULE_SHORT_NAME
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_faction.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" height="35">
  <cfform name="form1" method="post" action="#request.self#?fuseaction=settings.popup_dsp_faction_list&is_upd=#attributes.is_upd#">
    <input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
	<input type="hidden" name="click_count" id="click_count" value="<cfoutput>#attributes.is_upd#</cfoutput>">
    <tr>
      <td class="headbold"><cf_get_lang no='159.FuseActions'></td>
      <td align="right" style="text-align:right;">
        <table>
          <tr>
            <td><cf_get_lang_main no='48.Filtre'>:</td>
            <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
            <td>
			  <select name="module" id="module">
                <option value="" selected><cf_get_lang no='201.Moduls'></option>
                <cfoutput query="get_modules">
                  <option value="#module_id#" <cfif isDefined('attributes.module') and get_modules.module_id eq attributes.module>selected</cfif>>#module_short_name#</option>
                </cfoutput>
              </select>
			</td>
            <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
              <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
            <td><cf_wrk_search_button></td>
			<td><input type="submit" value="<cf_get_lang no='1649.Seçme İşlemi Bitti'>" onClick="window.close();"></td>
          </tr>
        </table>
      </td>
    </tr>
  </cfform>
</table>
      <table width="98%" cellpadding="2" cellspacing="1" class="color-border" align="center">
        <tr height="22" class="color-header">
          <td class="form-title" width="180"><cf_get_lang no='195.Modul'></td>
          <td class="form-title" width="200"><cf_get_lang no='159.Fuseaction'></td>
          <td class="form-title"><cf_get_lang_main no='217.Açıklama'></td>
        </tr>
        <cfif get_faction.recordcount>
          <cfoutput query="get_faction" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr class="color-row">
              <td>#modul#</td>
              <td height="20"><a href="##" onClick="add_faction('#modul_short_name#.#fuseaction#');" class="tableyazi">#fuseaction#</a></td>
              <td>#fuseaction#</td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row">
            <td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
          </tr>
        </cfif>
      </table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
    <tr>
      <td>
        <cfset adres = "">
        <cfif len(attributes.keyword)>
          <cfset adres = "#adres#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isDefined('attributes.module') and len(attributes.module)>
          <cfset adres = "#adres#&module=#attributes.module#">
        </cfif>
        <cfif len(attributes.field_name)>
          <cfset adres = "#adres#&field_name=#attributes.field_name#">
        </cfif>
		<cfif isdefined("attributes.is_upd") and len(attributes.is_upd)>
			<cfset adres="#adres#&is_upd=#attributes.is_upd#">
		</cfif>
        <cf_pages page="#attributes.page#"
		  maxrows="#attributes.maxrows#"
		  totalrecords="#attributes.totalrecords#"
		  startrow="#attributes.startrow#"
		  adres="settings.popup_dsp_faction_list#adres#"></td>
      <!-- sil -->
      <td colspan="2" align="right" style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
      <!-- sil -->
    </tr>
  </table>
</cfif>
