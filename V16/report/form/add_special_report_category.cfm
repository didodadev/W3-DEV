<cfquery name="get_special_report_cats" datasource="#dsn#" >
    SELECT
        REPORT_CAT_ID,
        REPORT_CAT,
        UPPER_CAT_ID,
        HIERARCHY
    FROM
        SETUP_REPORT_CAT
    ORDER BY
    	HIERARCHY
</cfquery>
<cf_popup_box title='Kategori Ekle'>
    <cfform name="add_special_report_category" method="post" action="#request.self#?fuseaction=report.emptypopup_add_special_report_category">
        <table>
            <tr>
                <td width="100"><cf_get_lang dictionary_id='29736.Üst Kategori'></td>
                <td>                	
                    <select name="upper_cat_id" id="upper_cat_id" style="width:200px;">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_special_report_cats">
                        	<option value="#hierarchy#">
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
                <td nowrap><input type="text" name="report_cat" id="report_cat" style="width:200px;"></td>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                <td><textarea name="report_cat_detail" id="report_cat_detail" style="width:200px;;height:60px;"></textarea></td>
            </tr>			
        </table>
        <br/>

		<cf_popup_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script language="javascript">
	function kontrol()
	{
		if(document.add_special_report_category.report_cat.value == '')
		{
			alert("<cf_get_lang dictionary_id='58947.Lütfen Kategori Seçiniz!'>");
			return false;
		}
		return true;
	}
</script>
