<cfquery name="get_headers" datasource="#dsn_dev#">
	SELECT * FROM SEARCH_TABLES_COLOUMS ORDER BY ROW_ID ASC
</cfquery>
<cf_form_box title="Tablo İsimlendirme">
<cfform name="add_form" action="">
    <cfoutput>#htmlcodeformat("<br>")#</cfoutput> ifadesiyle kolon isimlerinde satır atlama yapabilirsiniz.
    <br>
    <table>
    	<tr>
        	<td class="formbold">Kolon Adı</td>
            <td class="formbold">Kolon Özel Adı</td>
            <td class="formbold">Filtre</td>
            <td class="formbold">Filtre Tipi</td>
            <td class="formbold">Genişlik</td>
            <td class="formbold">Sabitle</td>
            <td class="formbold">Hizalama</td>
            <td class="formbold">Arkaplan</td>
            <td class="formbold">Yazı Rengi</td>
        </tr>
        <cfoutput query="get_headers">
        <tr>
        	<td>
            	<input type="hidden" name="row_id_#row_id#" value="#row_id#">
                <input type="text" value="#kolon_ad#" name="kolon_ad_#row_id#" style="width:150px;" readonly>
            </td>
            <td><input type="text" value="#kolon_ozelad#" name="kolon_ozelad_#row_id#" style="width:150px;"></td>
            <td><input type="checkbox" value="1" name="kolon_filtre_#row_id#" <cfif kolon_filtre eq 1>checked</cfif>></td>
            <td>
            	<select name="kolon_filtre_tipi_#row_id#">
                	<option value="" <cfif not len(kolon_filtre_tipi)>selected</cfif>>Text Arama</option>
                    <option value="number" <cfif kolon_filtre_tipi is 'number'>selected</cfif>>Sayısal Arama</option>
                    <option value="bool" <cfif kolon_filtre_tipi is 'bool'>selected</cfif>>Mantıksal Arama</option>
                    <option value="checkedlist" <cfif kolon_filtre_tipi is 'checkedlist'>selected</cfif>>Seçenekli Arama</option>
                </select>
            </td>
            <td><input type="text" value="#kolon_en#" name="kolon_en_#row_id#" style="width:35px;"></td>
            <td><input type="checkbox" value="1" name="kolon_sabit_#row_id#" <cfif kolon_sabit eq 1>checked</cfif>></td>
            <td>
            	<select name="kolon_align_#row_id#">
                	<option value="left" <cfif kolon_align is 'left'>selected</cfif>>Sola Dayalı</option>
                    <option value="right" <cfif kolon_align is 'right'>selected</cfif>>Sağa Dayalı</option>
                    <option value="center" <cfif kolon_align is 'center'>selected</cfif>>Ortalanmış</option>
                </select>
            </td>
            <td>
            <cf_workcube_color_picker name="kolon_arka_#row_id#" value="#kolon_arka#" width="50">
            </td>
            <td>
            <cf_workcube_color_picker name="kolon_yazi_#row_id#" value="#kolon_yazi#" width="50">
            </td>
        </tr>
        </cfoutput>
    </table>
    
    <cf_form_box_footer>
    	<cf_workcube_buttons>
    </cf_form_box_footer>
</cfform>
</cf_form_box>