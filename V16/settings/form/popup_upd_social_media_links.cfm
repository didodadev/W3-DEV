<!--- Sosyal Medya Link Ekleme Popup --->
<cfparam name="comp_id_list" default="">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="74%" height="35" class="headbold"><cf_get_lang no='4.Sosyal Medya Bilgileri'></td>
  </tr>
	<cfform name="comp_link" action="#request.self#?fuseaction=settings.emptypopup_upd_social_media_cat_links" method="post">
	<input type="hidden" name="smcat_id" id="smcat_id" value="<cfoutput>#attributes.id#</cfoutput>">
	  <tr class="color-border"> 
		<td>
			<table width="100%" cellpadding="2" cellspacing="1" border="0">

				<tr class="color-header" height="20">
					<td class="form-title"><cf_get_lang_main no='1073.Sirket Adi'></td>
					<td class="form-title"><cf_get_lang no='388.Link'></td>
					<td class="form-title"><cf_get_lang_main no='667.Internet'>
						<input type="checkbox" name="allSelectLink" id="allSelectLink" onClick="check_all();">                
					</td>
				</tr>
				<cfquery name="check_link" datasource="#dsn#">
					SELECT 
						ISNULL(SSM.LINK,'http://') LINK,
						SSM.IS_INTERNET,
						OC.NICK_NAME,
						OC.COMP_ID
					FROM 
						OUR_COMPANY OC
						LEFT JOIN SETUP_SOCIAL_MEDIA_CAT_LINK SSM ON OC.COMP_ID = SSM.OUR_COMPANY_ID AND SSM.SMCAT_ID= #attributes.id#
				</cfquery>
				<cfif check_link.recordcount>
					<input type="hidden" name="rowcount" id="rowcount" value="<cfoutput>#check_link.recordcount#</cfoutput>"/>
					<cfoutput query="check_link" > 
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td><cfinput type="hidden" name="comp_id_#currentrow#" id="comp_id_#currentrow#" value="#comp_id#">#nick_name#</td>
							<td>
								<input type="text" name="link_#currentrow#" id="link_#currentrow#" value="#check_link.link#" style="width:150px;" maxlength="100"> 
							</td>
							<td align="center"> <input type="checkbox" name="is_internet_#currentrow#" id="is_internet_#currentrow#" <cfif is_internet eq 1>checked="checked"</cfif> value="1"> </td>  
						</tr>
					</cfoutput> 
				<cfelse>
					<tr class="color-row"> 
						<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
				<tr height="35" class="color-row">
					<td colspan="3" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
				</tr>
			</table>
		</td>
	  </tr>
</cfform>
</table>
<script type="text/javascript">
	function check_all()
	{
		if(document.getElementById('allSelectLink').checked == true)
		{
			for(i=1;i<=document.getElementById('rowcount').value;++i)
			{
				document.getElementById('is_internet_'+i).checked=true;
			}
		}
		else
		{
			for(i=1;i<=document.getElementById('rowcount').value;++i)
			{
				document.getElementById('is_internet_'+i).checked=false;
			}
		}
	}
</script>
