<cfparam name="attributes.report_type" default="">
<br />
<cf_form_box title="CSV #getLang('main',2310)#">
    <cfform name="search__" action="" method="post">
        <input type="hidden" name="is_submitted" id="is_submitted" value="0">
        <cf_area>
            <table>
                    <tr>
                        <td class="txtbold" nowrap="nowrap"><cf_get_lang_main no='2947.Export Edilecek Dosya Tipi'></td>
                        <td>
                            <select name="report_type" id="report_type" style="width:190px;">
                                <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang_main no='2948.Renk Dosyası'></option>
                                <option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang_main no='2949.Kalınlık Dosyası'></option>
                                <option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang_main no='2950.Default Parça Dosyası'></option>
                                <option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang_main no='2951.PVC Stok Dosyası'></option>
                            </select>
                        </td>
                    </tr>
            </table>
        </cf_area>
        <cf_form_box_footer>
            <cfsavecontent variable="message"><cf_get_lang_main no='1554.Oluştur'></cfsavecontent>
            <cf_workcube_buttons is_upd=1 insert_info='#message#' is_delete=0 add_function='kontrol()'>
        </cf_form_box_footer>
    </cfform>
</cf_form_box>
<cfif isdefined('attributes.report_type') and attributes.report_type eq 1>
	<cfinclude template="exp_ezgi_colors.cfm">	
<cfelseif isdefined('attributes.report_type') and attributes.report_type eq 2>
	<cfinclude template="exp_ezgi_thickness.cfm">	
<cfelseif isdefined('attributes.report_type') and attributes.report_type eq 3>
	<cfinclude template="exp_ezgi_pieces.cfm">
<cfelseif isdefined('attributes.report_type') and attributes.report_type eq 4>
	<cfinclude template="exp_ezgi_stocks.cfm">
</cfif>
<script type="text/javascript">
	function kontrol()
	{
		search__.target='';
		search__.action='';
		return true;
	}
</script>