<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_widget.cfm">
<div style="background-color:white; width:100%; height:100%;" align="center" id="add_form">
<cfform name="widget_form" id="widget_form" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_widget" target="widget_ekle_iframe">
	<input type="hidden" name="sequence" id="sequence" value="<cfoutput>#get_widget_pos.sequence_index#</cfoutput>" />
	<input type="hidden" name="column" id="column" value="<cfoutput>#get_widget_pos.column_index#</cfoutput>" />	
	<cfif get_module_power_user(47)>
	<table width="100%">
		<tr>
			<td>	
			<table>	
				<tr>
					<td width="80"><cf_get_lang dictionary_id="58820.Header">*</td>
					<td><input type="text" name="widget_head" id="widget_head" maxlength="75" width="100%"></td>			
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='29761.URL'>*</td>
                    <td><input type="text" name="widget_url" id="widget_url" maxlength="300" width="100%"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='29811.Script'>*</td>
                    <td><textarea name="widget_script" id="widget_script" width="100%"></textarea></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='29762.İmaj'></td>
					<td>
						<select name="widget_show_image" id="widget_show_image">
							<option value="0"><cf_get_lang dictionary_id='29813.Gösterme'></option>
							<option value="1"><cf_get_lang dictionary_id='58596.Göster'></option>
						</select>
				  	</td>			
				</tr>		
				<tr>
					<td><cf_get_lang dictionary_id='58829.Kayıt Sayısı'></td>
					<td>
						<select name="widget_record_count" id="widget_record_count">
							<option value="1">1</option>
							<option value="5">5</option>
							<option value="10">10</option>
							<option value="15">15</option>
						</select>
					</td>
				</tr>		
				<tr>
                    <td><div id="widget_add_div" style="display:none;"><iframe name="widget_ekle_iframe" id="widget_ekle_iframe" width="80" height="20" frameborder="0" scrolling="0"></iframe></div></td>
                    <td align="left">
                        <input type="button" id="form_widget_add_button" value="<cf_get_lang dictionary_id='29812.Widget Ekle'>" onclick="add_widget_submit()">
                    </td>
				</tr>
			</table>	
			</td>
		</tr>
		<tr>
			<td>
			<cfset is_add_ = "">
			<cfinclude template="widget_rss_list.cfm">	
			</td>
		</tr>
	</table>
	<cfelse>
	<cfset is_add_ = "">
	<cfinclude template="widget_rss_list.cfm">
	</cfif>
</cfform>	
</div>
<script language="javascript">
function add_widget_submit()
{
	if (document.getElementById('widget_head').value.length < 3){
		alert("<cf_get_lang dictionary_id='60246.En az 3 karakterden oluşan bir başlık girmelisiniz'>!");
		return false;			
	}
	if(document.getElementById('widget_url').value.length < 1 && document.getElementById('widget_script').value.length < 1)
	{
		alert("<cf_get_lang dictionary_id='60247.Url ya da script alanını doldurunuz'>!");
		return false;
	}
	document.widget_form.submit();		
	document.getElementById('widget_add_div').style.display='';
}
</script>
