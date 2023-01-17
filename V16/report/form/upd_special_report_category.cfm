<cfquery name="get_special_report_cats" datasource="#dsn#">
	SELECT 
    	REPORT_CAT_ID, 
        REPORT_CAT, 
        HIERARCHY 
    FROM 
    	SETUP_REPORT_CAT
    ORDER BY
    	HIERARCHY 
</cfquery>
<cfquery name="get_my_special_report_cat" datasource="#dsn#">
	SELECT * FROM SETUP_REPORT_CAT WHERE REPORT_CAT_ID = #attributes.report_cat_id#
</cfquery>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='57486.Kategori'> <cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
<cf_popup_box title='#title#'>
  <cfform name="upd_special_report_category" method="post" action="#request.self#?fuseaction=report.emptypopup_upd_special_report_category">
			<table>
                <input type="hidden" name="report_cat_id" id="report_cat_id" value="<cfoutput>#attributes.report_cat_id#</cfoutput>">
                <tr>
                	<td width="100"><cf_get_lang dictionary_id='29736.Üst Kategori'></td>
                    <td>                	
                        <select name="upper_cat_id" id="upper_cat_id" style="width:200px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_special_report_cats">
                                <option value="#hierarchy#" <cfif listlen(get_my_special_report_cat.hierarchy,".") gt 1 and ListGetAt(get_my_special_report_cat.hierarchy,listlen(get_my_special_report_cat.hierarchy,'.')-1,'.') eq report_cat_id>selected</cfif>>
                                    <cfif ListLen(HIERARCHY,".") neq 1>
                                        <cfloop from="1" to="#ListLen(HIERARCHY,".")#" index="i">&nbsp;</cfloop>
                                    </cfif>
                                    #report_cat#
                                </option>
                            </cfoutput>
                        </select>
                    </td>
              </tr>
              <tr>
                    <td><cf_get_lang dictionary_id='57486.Kategori'> *</td>
                    <td nowrap> <input value="<cfoutput>#get_my_special_report_cat.report_cat#</cfoutput>" type="text" name="report_cat" id="report_cat" style="width:200px;"></td>
                </tr>
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                    <td><textarea name="detail" id="detail" style="width:200px;;height:60px;"><cfoutput>#get_my_special_report_cat.detail#</cfoutput></textarea></td>
                </tr>			
			</table>
			<br/>
	<cf_popup_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=report.emptypopup_del_special_report_category&report_cat_id=#attributes.report_cat_id#'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script language="javascript">
	function kontrol()
	{
		if(document.upd_special_report_category.report_cat.value == '')
		{
			alert("<cf_get_lang dictionary_id='53158.Lütfen Kategori Giriniz'>!");
			return false;
		}
		return true;
	}
</script>
