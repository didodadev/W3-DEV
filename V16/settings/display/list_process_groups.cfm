<cfparam name="attributes.keyword" default="">
<cfquery name="GET_PROCESS_TYPE" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		PROCESS_TYPE_ROWS_WORKGRUOP
	WHERE
		PROCESS_ROW_ID IS NULL
		<cfif len(attributes.keyword)>AND WORKGROUP_NAME LIKE '%#attributes.keyword#%'</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_process_type.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset adres=''>
<cfif isdefined("attributes.keyword")>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td valign="top">
      <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="headbold"><cf_get_lang dictionary_id='43250.Süreç Grupları'></td>
          <!-- sil -->
          <td align="right" valign="bottom" style="text-align:right;">
            <table>
              <cfform name="search" action="#request.self#?fuseaction=settings.list_process_groups" method="post">
                <tr>
					<td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
					<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
					<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
					<td><cf_wrk_search_button></td>
                </tr>
              </cfform>
            </table>
          </td>
          <!-- sil -->
        </tr>
      </table>
            <table cellspacing="1" cellpadding="2" width="98%" border="0" align="center" class="color-border">
              <tr class="color-header">
                <td class="form-title" width="25"><cf_get_lang dictionary_id='57487.No'></td>
                <td class="form-title"><cf_get_lang dictionary_id='43396.Grup'></td>
                <td class="form-title"><cf_get_lang dictionary_id='43249.Süreçler'></td>
                <td width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_form_add_group','list');"><img src="/images/plus_square.gif" align="absmiddle" border="0"></a></td>
              </tr>
               <cfif get_process_type.recordcount>
                <cfoutput query="get_process_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">                 
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td valign="top" width="30">#workgroup_id#</td>
                    <td width="250" valign="top" class="txtbold">#workgroup_name#</td>
					<cfquery name="GET_PROS" datasource="#dsn#">
						SELECT 
						DISTINCT
							PROCESS_TYPE.PROCESS_NAME
						FROM
							PROCESS_TYPE,
							PROCESS_TYPE_ROWS,
							PROCESS_TYPE_ROWS_WORKGRUOP
						WHERE
							PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = #workgroup_id# AND
							PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
							PROCESS_TYPE_ROWS.PROCESS_ROW_ID = PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID
					</cfquery>
					<td><cfloop query="GET_PROS">#GET_PROS.PROCESS_NAME#<br/></cfloop></td>
                    <td width="15" valign="top"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_form_upd_group&workgroup_id=#workgroup_id#','list');"><img src="/images/update_list.gif" align="absmiddle" border="0"></a></td>
                  </tr>
                 </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
      <cfif attributes.totalrecords gt attributes.maxrows>
        <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
          <tr>
            <td><cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="settings.list_process_groups&adres=#adres#"></td>
            <!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
          </tr>
        </table>
      </cfif>
    </td>
  </tr>
</table>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
