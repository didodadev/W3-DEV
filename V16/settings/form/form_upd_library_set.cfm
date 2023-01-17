<cfquery name="GET_LIB_CAT_ID" datasource="#DSN#" maxrows="1">
	SELECT
		LIB_ASSET_CAT
	FROM
		LIBRARY_ASSET
	WHERE
		LIB_ASSET_CAT=#URL.ID#
</cfquery>
<cfquery name="GET_LIB_CAT" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		LIBRARY_CAT 
	WHERE 
		LIBRARY_CAT_ID =#URL.ID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="2" width="98%" height="35" align="center">
  <tr>
    <td class="headbold"><cf_get_lang no='643.Kütüphane Kategorisi Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_library_set"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <tr class="txtbold">
          <td valign="top" width="200" class="color-row">
            <cfinclude template="../display/lib_cat.cfm">
          </td>
          <td valign="top" class="color-row">
            <table border="0">
              <cfform name="care_form" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_lib_cat&id=#GET_LIB_CAT.library_cat_id#">
                <tr>
                  <td><cf_get_lang no='20.Kategori Adı'></td>
                  <td><cfinput  type="Text" name="libcat" value="#GET_LIB_CAT.LIBRARY_CAT#" maxlength="50"  style="width:150px;">
                  </td>
                </tr>
                <tr>
                  <td width="100" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea name="DETAIL" id="DETAIL" style="width:150px;height:60px;"><cfoutput>#GET_LIB_CAT.DETAIL#</cfoutput></textarea>
                  </td>
                </tr>
                <tr>
				<td></td>
                  <td colspan="2" height="35">
				  <cfif get_lib_cat_id.recordcount>
				  <cf_workcube_buttons is_upd='1' is_delete='0'> 
				  <cfelse>
				  <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_lib_cat&id=#url.id#'>
				  </cfif>
				  </td>
                </tr>
				<tr>
                  <td colspan="2"><p><br/>
				  	<cfoutput>
				 	<cfif len(GET_LIB_CAT.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(GET_LIB_CAT.record_emp,0,0)# - #dateformat(GET_LIB_CAT.record_date,dateformat_style)#
					</cfif><br/>
				 	<cfif len(GET_LIB_CAT.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(GET_LIB_CAT.update_emp,0,0)# - #dateformat(GET_LIB_CAT.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
			      </td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>

