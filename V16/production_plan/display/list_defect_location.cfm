<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <cfif fuseaction does not contain "popup">
     <cfinclude template="../../objects/display/tree_back.cfm">
<td <cfoutput>#td_back#</cfoutput>>
      <cfinclude template="prod_plan_definition_left_menu.cfm">
	  </td>
    </cfif>
    <td valign="top" width="100%">
	<cfset url_str = "">
	<cfparam name="attributes.keyword" default="">
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
      <cfif isdefined("attributes.branch_id")>
        <cfset url_str = "#url_str#&branch_id=#attributes.size_type_id#">
      </cfif>
      <cfinclude template="../query/get_defect_location_list.cfm">
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfparam name="attributes.totalrecords" default=#get_defect_location_list.recordcount#>
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
      <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="headbold" height="35"><cf_get_lang dictionary_id='36556.Defo Yerleri'></td>
          <!-- sil -->
          <td align="right" valign="bottom" style="text-align:right;">
            <table>
              <cfform name="form" action="#request.self#?fuseaction=prod.defect_location" method="post">
                <tr>
                  <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
				<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                  <td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                  </td>
                  <td><cf_wrk_search_button> </td>
                  <cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'> </tr>
              </cfform>
            </table>
          </td>
          <!-- sil -->
        </tr>
      </table>
      <table cellspacing="0" cellpadding="0" border="0" width="97%" align="center">
        <tr class="color-border">
          <td>
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header" height="22">
                <td class="form-title" width="10"><cf_get_lang dictionary_id='57487.No'></td>
                <td class="form-title"><cf_get_lang dictionary_id='36559.Defo Yeri'></td>
                <td width="125" class="form-title"><cf_get_lang dictionary_id='36560.Defo Yeri Kodu'></td>
                <td width="25" align="center"> <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_form_add_defect_location</cfoutput>','small');"><img src="/images/plus_square.gif" title="<cf_get_lang dictionary_id='36561.Defo Yeri Ekle'>" border="0"></a></td>
              </tr>
              <cfif get_defect_location_list.recordcount>
                <cfoutput query="get_defect_location_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td>#Currentrow#</td>
                    <td><A  class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_form_upd_defect_location&defect_location_id=#defect_location_id#','small');">#defect_location#</a></td>
                    <td>#defect_location_id#</td>
                    <td align="center"> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_form_upd_defect_location&defect_location_id=#defect_location_id#','small');"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='36562.Defo Yerini Düzenle'>" border="0"></a></td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" >
                  <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
      <cfif get_defect_location_list.recordcount and (attributes.totalrecords gt attributes.maxrows)>
        <table cellpadding="0" cellspacing="0" border="0" width="97%" height="30" align="center">
          <tr>
            <td> 
			<cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="prod.size_types#url_str#"> 
				</td>
            <!-- sil --><td align="right" style="text-align:right;"> 
			<cfoutput>
			<cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
          </tr>
        </table>
      </cfif>
      <br/>
    </td>
  </tr>
</table>

