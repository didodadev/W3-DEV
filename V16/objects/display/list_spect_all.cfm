<cfquery name="GET_SPECT_NAMES" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		SPECT_TYPE
</cfquery>
<cfparam name="attributes.page" default=1>

<cfparam name="attributes.totalrecords" default=#get_spect_names.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
url_string = '';

if (isdefined('attributes.maxrows')) url_string = '#url_string#&maxrows=#attributes.maxrows#';
if (isdefined('attributes.keyword')) url_string = '#url_string#&keyword=#attributes.keyword#';

</cfscript>
<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="headbold" valign="middle"><cf_get_lang dictionary_id='32667.spect nitelikleri'></td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
  <cfform action="#request.self#?fuseaction=objects.emptypopup_add_spect_variation" method="post" name="search">
  <input type="hidden" name="id" id="id" value="<cfoutput>#url.id#</cfoutput>">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header">
          <td height="22" class="form-title" colspan="2"><cf_get_lang dictionary_id='57529.tanımlar'></td>
        </tr>
        <cfif get_spect_names.recordcount>
          <cfoutput query="get_spect_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		   <cfquery name="GET_VARIATION_ID" datasource="#DSN3#">
				SELECT
					*
				FROM
					SPECT_VARIATION_TYPE
				WHERE
					SPECT_VAR_ID=#URL.ID#
				AND
					SPECT_ID=#GET_SPECT_NAMES.SPECT_ID#
			</cfquery>
		   <cfif get_spect_names.spect_id neq get_variation_id.spect_id>
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td width="20"><input type="checkbox" name="spect_name_type_id#currentrow#" id="spect_name_type_id#currentrow#" value="#spect_id#">
              </td>
			  <td>#spect_name#</td>
            </tr>
			</cfif>
          </cfoutput>
          <cfelse>
          <tr>
            <td class="color-row"><cf_get_lang dictionary_id='57484.kayıt yok'></td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
  <tr>
    <td height="30"  style="text-align:right;"><cf_workcube_buttons is_upd='0' insert_alert=''></td>
  </tr>
</table>
</cfform>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
    <tr>
      <td><cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="objects.popup_list_spect_all#url_string#"> </td>
      <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.toplam'>:#get_spect_names.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
    </tr>
  </table>
</cfif>
<br/>

