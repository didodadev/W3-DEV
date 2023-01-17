<br />
<cfquery name="get_search_layouts" datasource="#dsn_dev#">
SELECT
    LAYOUT_ID,
    LAYOUT_NAME
FROM
    SEARCH_TABLES_LAYOUTS
ORDER BY
   	LAYOUT_NAME
</cfquery>
<cfinclude template="coloum_positions.cfm">
<div class="col col-12">
	<cf_box draggable="1" title="Görünüm" closable="1">
<cfform name="add_" action="" method="post">
<input type="hidden" name="form_page_hide_col_list" id="form_page_hide_col_list" value="<cfoutput>#hide_col_list#</cfoutput>">
<input type="hidden" name="form_page_col_sort_list" id="form_page_col_sort_list" value="<cfoutput>#page_col_sort_list#</cfoutput>">
	<table>
    	<tr>
        	<td colspan="2">
            	<input type="radio" name="record_type" value="1" <cfif not len(attributes.layout_id)>checked</cfif> onclick="set_action();"/> Yeni Kayıt
                <input type="radio" name="record_type" value="2" <cfif len(attributes.layout_id)>checked</cfif> onclick="set_action();"/> Güncelleme
            </td>
        </tr>
        <tr style="<cfif len(attributes.layout_id)>display:none;</cfif>" id="new_record">
        	<td>Yeni Layout İsmi</td>
            <td><cfinput type="text" name="layout_name" value=""></td>
        </tr>
        <tr style="<cfif not len(attributes.layout_id)>display:none;</cfif>" id="upd_record">
        	<td>Eski Layout İsmi</td>
            <td>
            	<select name="old_layout_id" id="old_layout_id">
                    <option value="">Seçiniz</option>
                    <cfoutput query="get_search_layouts">
                        <option value="#layout_id#" <cfif attributes.layout_id eq layout_id>selected</cfif>>#layout_name#</option>
                    </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
        	<td style="text-align:right;" colspan="2">
            	<input type="button" value="Kaydet" onclick="save_layout_src();"/>
            </td>
        </tr>
        <tr>	
        	<td colspan="2">
            	<div id="hide_col_list_action_div"></div>
            </td>
        </tr>
    </table>
</cfform>
</cf_box>
</div>
<script>
function set_action()
{
	if(document.add_.record_type[0].checked == true)
	{
		show('new_record');
		hide('upd_record');	
	}
	else
	{
		hide('new_record');
		show('upd_record');	
	}	
}
function save_layout_src()
{
	if(document.getElementById('layout_name').value == '' && document.add_.record_type[0].checked == true)
	{
		alert('Layout Giriniz!');
		return false;	
	}
	
	if(document.getElementById('old_layout_id').value == '' && document.add_.record_type[1].checked == true)
	{
		alert('Eski Layout Seçiniz!');
		return false;	
	}
	AjaxFormSubmit('add_','hide_col_list_action_div',1,'Kaydediliyor','Kaydedildi');	
}
</script>