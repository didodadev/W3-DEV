<cfparam name="attributes.date_1" default="">
<cfparam name="attributes.date_2" default="">
<cfparam name="attributes.category" default="1">
<cfparam name="attributes.service_company_id" default="">
<cfif len(attributes.date_1)>
	<cf_date tarih='attributes.date_1'>
</cfif>
<cfif len(attributes.date_2)>
	<cf_date tarih='attributes.date_2'>
</cfif>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td valign="top" height="35">
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
        <tr>
          <td class="headbold"><cf_get_lang no='3.Kurumsal Üye Analizi'></td>		  
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign="top">
      <table cellspacing="0" cellpadding="0" border="0" width="98%" align="center" height="100%">
        <tr class="color-border">
          <td valign="top">
            <table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
              <tr class="color-list">
                <td height="22" colspan="2" style="text-align:right;">
                  <table>
                    <cfform name="form" action="#request.self#?fuseaction=crm.display_member_analysis" method="post">
                      <tr>
                        <td><cf_get_lang_main no='48.Filtre'>:</td>
                        <td>
						  <input type="hidden" name="service_company_id" id="service_company_id" value="<cfif len(attributes.service_company_id)><cfoutput>#attributes.service_company_id#</cfoutput></cfif>">
                          <input type="text" name="service_company" id="service_company" value="<cfif len(attributes.service_company_id)><cfoutput>#get_par_info(attributes.service_company_id,1,1,0)#</cfoutput></cfif>" style="width:180">
                          <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=form.service_company&field_comp_id=form.service_company_id&is_crm_module=1&select_list=2,3,5,6','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></td>
						<td colspan="11"  style="text-align:right;">
						<cfif len(attributes.date_1)>
							<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen Tarih Giriniz !'></cfsavecontent>
							<cfinput type="text" name="date_1" value="#dateformat(attributes.date_1,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;" message="#message#">
						<cfelse>
							<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen Tarih Giriniz !'></cfsavecontent>
							<cfinput type="text" name="date_1" value="" maxlength="10" validate="#validate_style#" style="width:65px;" message="#message#">
						</cfif>
						  <cf_wrk_date_image date_field="date_1">
						<cfif len(attributes.date_2)>
							<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen Tarih Giriniz !'></cfsavecontent>
							<cfinput type="text" name="date_2" value="#dateformat(attributes.date_2,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;" message="#message#">
						<cfelse>
							<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen Tarih Giriniz !'></cfsavecontent>
							<cfinput type="text" name="date_2" value="" maxlength="10" validate="#validate_style#" style="width:65px;" message="#message#">
						</cfif>
						  <cf_wrk_date_image date_field="date_2"></td>
                        <td><cf_wrk_search_button search_function='kontrol()'></td>
                        <cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
					</tr>
                    </cfform>
                  </table>
                </td>
              </tr>
              <tr class="color-row">
                <td width="170" nowrap>
				<div id="tra_sol" style="position:absolute;width:99%;height:99%; z-index:88;overflow:scroll;">
					<cfinclude template="analyse_bar.cfm">
				</div></td>
                <td width="100%">
				<cfif attributes.category eq 4>
					<iframe src="<cfoutput>#request.self#?fuseaction=objects.popup_member_financial_analyse&company_id=#attributes.service_company_id#</cfoutput>" width="100%" height="100%" frameborder="0"  scrolling="auto" name="iframe" id="iframe"></iframe>
				<cfelse>
					<iframe src="<cfoutput>#request.self#?fuseaction=crm.popup_analyse_result&iframe=1&category=#attributes.category#&date_1=#attributes.date_1#&date_2=#attributes.date_2#&service_company_id=#attributes.service_company_id#</cfoutput>" width="100%" height="100%" frameborder="0"  scrolling="auto" name="iframe" id="iframe"></iframe>
				</cfif>
				</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
	function kontrol()
	{
	if ( (form.date_1.value.length != 0)&&(form.date_2.value.length != 0) )
		return date_check(form.date_1,form.date_2,"<cf_get_lang no ='418.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
	return true;
	}
</script>

