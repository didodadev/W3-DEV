<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='1683 .Menkul Kıymet Tipi Güncelle'></td>
    <td align="right" class="headbold" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_stockbond_type"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a>
    </td>
  </tr>
</table>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <tr class="color-row" valign="top">
          <td width="200"><cfinclude template="../display/list_stockbond_types.cfm">
          </td>
          <td>
            <table>
              <cfform name="form" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_stockbond_type&stockbond_type_id=#URL.stockbond_type_id#">
			  <input type="hidden" name="stockbond_type_id" id="stockbond_type_id" value="<cfoutput>#URL.stockbond_type_id#</cfoutput>">
                <cfquery name="STOCKBOND_TYPES" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						SETUP_STOCKBOND_TYPE
					WHERE 
						STOCKBOND_TYPE_ID=#URL.STOCKBOND_TYPE_ID#
                </cfquery>
                <tr>
				 <td width="50"><cf_get_lang_main no='218.Tip'> <font color=black>*</font></td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='1474.Menkul Kıymet Tipi Girmelisiniz'></cfsavecontent>
				  <cfinput type="text" name="stockbond_type" size="30" value="#STOCKBOND_TYPES.STOCKBOND_TYPE#" required="Yes" message="#message#" style="width:150px;">
                  </td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea name="detail" id="detail" style="width:150px;height:80px;"><cfoutput>#STOCKBOND_TYPES.DETAIL#</cfoutput></textarea>
                  </td>
                </tr>
                <tr>
				<td align="right">&nbsp;</td>
                  <td align="right" height="35">
				   <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_stockbond_type&stockbond_type_id=#url.stockbond_type_id#'>
                  </td>
				<tr>
                  <td colspan="3" align="left"><p><br/>
				  	<cfoutput>
				 	<cfif len(STOCKBOND_TYPES.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(STOCKBOND_TYPES.record_emp,0,0)# - #dateformat(STOCKBOND_TYPES.record_date,dateformat_style)#
					</cfif><br/>
				 	<cfif len(STOCKBOND_TYPES.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(STOCKBOND_TYPES.update_emp,0,0)# - #dateformat(STOCKBOND_TYPES.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
			      </td>
				</tr>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
