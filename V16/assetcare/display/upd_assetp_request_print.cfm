<cfinclude template="../query/get_request_print.cfm">

<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td valign="top">
      <table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" height="100%">
        <tr class="color-border">
          <td>
            <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
              <tr class="color-list" valign="middle">
                <td height="35">
                  <table width="100%">
                    <tr>
                      <td class="headbold"><cf_get_lang no='29.Talepler'></td>
					  <!-- sil -->	
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
					<!-- sil -->	
					</tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td valign="top" class="color-row">
                  <cfform name="request_print" method="post" action="">
                    <input type="hidden" name="request_id" id="request_id" value="<cfoutput>#attributes.request_id#</cfoutput>">
                    <cfoutput query="get_request_print" maxrows="1">
                      <table>
                        <tr>
                          <td class="txtbold" width="120px"><cf_get_lang_main no='74.Kategori'></td>
                          <td width="200px">#assetp_cat#</td>
                          <td class="txtbold" width="80px"><cf_get_lang_main no='344.Durum'></td>
						  <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td class="txtbold"><cf_get_lang_main no='160.Departman'></td>
                          <td>#branch_name#-#department_head#</td>
                          <td class="txtbold"><cf_get_lang_main no='1435.Marka'></td>
                          <td><cfif len(brand_id)>
                              <cfset attributes.brand_id = brand_id>
                              <cfinclude template="../query/get_brand.cfm">#get_brand.brand_name#</cfif></td>
                        </tr>
                        <tr>
                          <td class="txtbold"><cf_get_lang no='82.Talep Eden'></td>
                          <td>#get_emp_info(employee_id,0,0)#</td>
                          <td class="txtbold"><cf_get_lang_main no='2244.Marka Tipi'></td>
                          <td>#brand_type#</td>
                        </tr>
                        <tr>
                          <td class="txtbold"><cf_get_lang no='127.Kullanım Amacı'></td>
                          <td>#usage_purpose#</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td class="txtbold"><cf_get_lang no='123.Talep Tarihi'></td>
                          <td>#dateformat(request_date,dateformat_style)#</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
                        </tr>
						<tr>
						  <td class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						</tr>
						<tr>
						  <td colspan="4">#detail#</td>
						</tr>
						<tr>
						  <td class="txtbold"><cf_get_lang_main no='272.Sonuç'></td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						</tr>
						<tr>
						  <td colspan="4">#result_detail#</td>
						</tr>
						<tr>
						  <td class="txtbold" colspan="4"><cf_get_lang no='199.Talebiniz '><cfswitch expression="#result_id#">
			  				  <cfcase value="1"><cf_get_lang no='202.Kabul edilmiştir'>.</cfcase>
							  <cfcase value="-1"><cf_get_lang_main no='205.Ret edilmiştir'>.</cfcase>
			                  <cfcase value="0"><cf_get_lang no='203.Beklemede konumundadır'>.</cfcase>
			                  <cfdefaultcase><cf_get_lang no='204.Değerlendirme Aşamasındadır'>.</cfdefaultcase></cfswitch></td>
						</tr>
                      </table>
                    </cfoutput>
                  </cfform>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
  </tr>
 </td>
</table>
