<cfsetting showdebugoutput="no">
<cfparam name="attributes.panelName" default="">
<cfif not len(attributes.panelName)><cfdump var="#attributes#">Workcube Hata<cfabort></cfif>
<cfinclude template="../query/get_widget.cfm">
<div style="background-color:white; width:100%; height:100%;" align="center">
<cfform id="upd_widget_form" name="upd_widget_form" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_widget" target="widget_upd_iframe">	
	<input type="hidden" name="menu_position_id" id="menu_position_id" value="<cfoutput>#get_widget_pos_upd.menu_position_id#</cfoutput>" />
	<table align="center">	
		<tr>
			<td><cf_get_lang dictionary_id='58820.Başlık'>*</td>
			<td><input type="text" id="upd_widget_head" name="upd_widget_head" maxlength="75" value="<cfoutput>#get_widget_pos_upd.widget_head#</cfoutput>" width="100%"></td>			
		</tr>		
		<tr> 
			<td><cf_get_lang dictionary_id='29762.İmaj'></td>
			<td>
				<select name="upd_widget_show_image" id="upd_widget_show_image">
					<option value="0" <cfif get_widget_pos_upd.WIDGET_SHOW_IMAGE eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='29813.Gösterme'></option>
					<option value="1" <cfif get_widget_pos_upd.WIDGET_SHOW_IMAGE eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='58596.Göster'></option>
				</select>
			</td>			
		</tr>		
		<tr>
			<td><cf_get_lang dictionary_id='58829.Kayıt Sayısı'></td><td>
				<select name="upd_widget_record_count" id="upd_widget_record_count">
					<option value="1" <cfif get_widget_pos_upd.widget_record_count eq 1>selected="selected"</cfif>>1</option>
					<option value="5" <cfif get_widget_pos_upd.widget_record_count eq 5>selected="selected"</cfif>>5</option>
					<option value="10" <cfif get_widget_pos_upd.widget_record_count eq 10>selected="selected"</cfif>>10</option>
					<option value="15" <cfif get_widget_pos_upd.widget_record_count eq 15>selected="selected"</cfif>>15</option>
				</select>
			</td>
		</tr>		
		<tr>
			<td colspan="2">			
			<table>
				<tr>
				  <td width="123"><div id="widget_upd_div" style="display:none;"><iframe name="widget_upd_iframe" id="widget_upd_iframe" width="100%" height="20" frameborder="0" scrolling="0"></iframe></div></td>
				  <td width="116" align="left">
				  <input type="button" id="form_widget_upd_button" name="form_widget_upd_button" value="<cf_get_lang dictionary_id='57464.Güncelle'>" onclick="upd_widget_submit()">
				 </td>
				</tr>
			</table>					
			</td>
		</tr>
	</table>
</cfform>
</div>

<script language="javascript">
function upd_widget_submit()
{
	var url = /^(((ht|f){1}(tp:[/][/]){1})|((www.){1}))[-a-zA-Z0-9@:%_\+.~#?&//=]+$/;	
	if (document.getElementById('upd_widget_head').value.length<3){	
		alert("<cf_get_lang dictionary_id='60246.En az 3 karakterden oluşan bir başlık girmelisiniz'>!");
		return false;			
	}	
	
	document.upd_widget_form.submit();		
	document.getElementById('widget_upd_div').style.display='';
	
}
</script>
