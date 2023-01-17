<cfquery name="GET_OPPORTUNITY_TYPE" datasource="#dsn3#">
	SELECT
		OPPORTUNITY_TYPE_ID,
		OPPORTUNITY_TYPE,
		OPPORTUNITY_TYPE_DETAIL,
		IS_INTERNET,
		IS_SALES,
		IS_PURCHASE,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM 
		SETUP_OPPORTUNITY_TYPE
	WHERE
		OPPORTUNITY_TYPE_ID = #attributes.opportunity_type_id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
    <td  class="headbold"><cf_get_lang no='936.Fırsat Kategorileri'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_opportunity_type"><img src="/images/plus1.gif" border="0"></a></td>
  </tr>
</table>
      <table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
        <tr class="color-row">
          <td width="200" valign="top"><cfinclude template="../display/list_opportunity_type.cfm"></td>
          <td valign="top" >
            <table border="0">
              <cfform name="upd_opportunity" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_opportunity_type">
			  <input type="hidden" name="opportunity_type_id" id="opportunity_type_id" value="<cfoutput>#attributes.opportunity_type_id#</cfoutput>">
                <tr>
                  <td width="100"><cf_get_lang no='20.Kategori Adı'> *</td>
                  <td><cfsavecontent variable="message"><cf_get_lang_main no='1143.Kategori Girmelisiniz!'> </cfsavecontent>
				  <cfinput type="text" name="opportunity_type" value="#get_opportunity_type.opportunity_type#" maxlength="30" required="yes" message="#message#" style="width:175px;"></td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea name="detail" id="detail" value="" style="width:175px;"><cfoutput>#get_opportunity_type.opportunity_type_detail#</cfoutput></textarea></td>
                </tr>
				<tr>
					<td><cf_get_lang no='1495.İnternette Yayınlansın'></td>
					<td><input type="Checkbox" name="is_internet" id="is_internet" value="0" <cfif get_opportunity_type.is_internet eq 1>checked</cfif>>&nbsp;
						<cf_get_lang_main no='36.Satış'>&nbsp;<input type="checkbox" name="is_sales" id="is_sales" value="0" <cfif get_opportunity_type.is_sales eq 1>checked</cfif>>&nbsp;
						<cf_get_lang_main no='37.Satınalma'>&nbsp;<input type="checkbox" name="is_purchase" id="is_purchase" value="0" <cfif get_opportunity_type.is_purchase eq 1>checked</cfif>>
					</td>
				</tr>
                <tr height="35">
				  <td></td>
				  <cfquery name="get_opp" datasource="#dsn3#">
				  	SELECT OPP_ID FROM OPPORTUNITIES WHERE OPPORTUNITY_TYPE_ID = #attributes.opportunity_type_id#
				  </cfquery>
				  <cfif get_opp.recordcount>
                  	<td><cf_workcube_buttons is_upd='1' is_delete="0" add_function='kontrol()'></td>
				  <cfelse>
                  	<td><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_upd_opportunity_type&opportunity_type_id=#attributes.opportunity_type_id#&is_del=1' add_function='kontrol()'></td>
				  </cfif>
                </tr>
				<tr>
					<td align="left" colspan="2"><p><br/>
					<cfoutput>
					<cfif len(get_opportunity_type.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_opportunity_type.record_emp,0,0)# - #dateformat(get_opportunity_type.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(get_opportunity_type.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_opportunity_type.update_emp,0,0)# - #dateformat(get_opportunity_type.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
					</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
<script type="text/javascript">
	function kontrol()
	{
		x = (30 - upd_opportunity.detail.value.length);
		if ( x < 0 )
		{ 
		alert ("<cf_get_lang_main no='359.Detay'> "+ ((-1) * x) +"<cf_get_lang_main no='1741.Karakter Uzun'> ");
		return false;
		}
		return true;
	}
</script>
