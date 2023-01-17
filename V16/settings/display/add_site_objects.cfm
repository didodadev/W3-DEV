<cfquery name="get_main_menu" datasource="#dsn#">
	SELECT MENU_NAME, MENU_ID FROM MAIN_MENU_SETTINGS ORDER BY MENU_NAME
</cfquery>
<table cellspacing="1" cellpadding="2" width="100%" class="color-border" align="center" height="100%">
	<tr class="color-list">
		<td height="35">
        <table width="100%">
            <tr>
                <td class="headbold"><cf_get_lang no='1456.Sayfa Tasarımı'></td>
            </tr>
        </table>
		</td>
	</tr>
	<tr class="color-row">
		<td valign="top">
        <table>
            <cfform action="#request.self#?fuseaction=settings.emptypopup_add_site_layout" name="add_main_" method="post">
            <input type="hidden" name="is_add" id="is_add" value="1">
            <tr>
                <td><cf_get_lang no='891.Menu'> *</td>
                <td colspan="4">
                    <select name="menu_id" id="menu_id" style="width:200px;">
                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                    <cfoutput query="get_main_menu">
                        <option value="#menu_id#">#menu_name#</option>
                    </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang no='159.Fuseaction'> *</td>                
                <td colspan="6">
                	<cfsavecontent variable="message"><cf_get_lang no ='1986.Fuseaction Tanımlamalısınız'></cfsavecontent>
                	<cfinput name="faction" type="text" value="" style="width:200px;" required="yes" message="#message#">
                    <cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_list_select_switch&selected_link=add_main_.faction&is_faction=1','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></cfoutput>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><cf_get_lang_main no='283.Genişlik'> PX</td>
                <td><cf_get_lang_main no='68.Başlık'></td>
                <td><cf_get_lang_main no ='1995.Tasarım'></td>
            </tr>
            <tr>
                <td class="txtboldblue"><cf_get_lang no ='1628.Sol Blok'></td>
                <cfsavecontent variable="message"><cf_get_lang no ='1987.Sol Uzunluk Giriniz'></cfsavecontent>
                <td><cfinput type="text" name="LEFT_WIDTH" validate="integer" message="#message#" style="width:65px;"></td>
                <td><input type="text" name="left_object_name" id="left_object_name" style="width:100px;"></td>
                <td>
                	<select name="left_design_id" id="left_design_id" style="width:120px;">
                        <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                        <option value="1"><cf_get_lang no ='1640.Çerçevesiz Başlıklı'></option>
                        <option value="2"><cf_get_lang no ='1641.Çerçevesiz Başlıksız'></option>
                        <option value="3"><cf_get_lang no='2682.Double 1px'></option>
                        <option value="4"><cf_get_lang no='2683.Dotted 1px'></option>
                        <option value="5"><cf_get_lang no='2003.Radius Başlıklı'></option>
                        <option value="6"><cf_get_lang no='2684.Solid top-bottom 3px'></option>
                        <option value="7"><cf_get_lang no='2685.Solid bottom 3px'></option>
                        <option value="8"><cf_get_lang no='2686.Dotted bottom 3px'></option>
                        <option value="9"><cf_get_lang no ='1988.Double 1px Başlıksız'></option>
                        <option value="10"><cf_get_lang no ='1989.Windows Ürünler İçin'></option>
                        <option value="11"><cf_get_lang_main no ='1262.Yeni'></option>
                        <option value="12"><cf_get_lang no ='1642.Özel Arkaplan'></option>
                        <option value="13"><cf_get_lang no ='1643.Özel Ürün Göster'></option>
                        <option value="14"><cf_get_lang no ='1644.İmaj Bazlı Tasarım'></option>
                        <option value="15"><cf_get_lang no ='1645.Çerçeve Alt Oval'></option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="txtboldblue"><cf_get_lang no ='1636.Orta Blok'></td>
                <cfsavecontent variable="message"><cf_get_lang no ='1993.Orta Uzunluk Giriniz'></cfsavecontent>
                <td><cfinput type="text" name="CENTER_WIDTH" validate="integer" message="#message#" style="width:65px;"></td>
                <td><input type="text" name="center_object_name" id="center_object_name" style="width:100px;"></td>
                <td>
                	<select name="center_design_id" id="center_design_id" style="width:120px;">
                        <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                        <option value="1"><cf_get_lang no ='1640.Çerçevesiz Başlıklı'></option>
                        <option value="2"><cf_get_lang no ='1641.Çerçevesiz Başlıksız'></option>
                        <option value="3"><cf_get_lang no='2682.Double 1px'></option>
                        <option value="4"><cf_get_lang no='2683.Dotted 1px'></option>
                        <option value="5"><cf_get_lang no='2003.Radius Başlıklı'></option>
                        <option value="6"><cf_get_lang no='2684.Solid top-bottom 3px'></option>
                        <option value="7"><cf_get_lang no='2685.Solid bottom 3px'></option>
                        <option value="8"><cf_get_lang no='2686.Dotted bottom 3px'></option>
                        <option value="9"><cf_get_lang no ='1988.Double 1px Başlıksız'></option>
                        <option value="10"><cf_get_lang no ='1989.Windows Ürünler İçin'></option>
                        <option value="11"><cf_get_lang_main no ='1262.Yeni'></option>
                        <option value="12"><cf_get_lang no ='1642.Özel Arkaplan'></option>
                        <option value="13"><cf_get_lang no ='1643.Özel Ürün Göster'></option>
                        <option value="14"><cf_get_lang no ='1644.İmaj Bazlı Tasarım'></option>
                        <option value="15"><cf_get_lang no ='1645.Çerçeve Alt Oval'></option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="txtboldblue"><cf_get_lang no ='1992.Sağ Blok'></td>
                <cfsavecontent variable="message"><cf_get_lang no ='1994.Sağ Uzunluk Giriniz'></cfsavecontent>
                <td><cfinput type="text" name="RIGHT_WIDTH" validate="integer" message="#message#" style="width:65px;"></td>
                <td><input type="text" name="right_object_name" id="right_object_name"  style="width:100px;"></td>
                <td>
                	<select name="right_design_id" id="right_design_id" style="width:120px;">
                        <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                        <option value="1"><cf_get_lang no ='1640.Çerçevesiz Başlıklı'></option>
                        <option value="2"><cf_get_lang no ='1641.Çerçevesiz Başlıksız'></option>
                        <option value="3"><cf_get_lang no='2682.Double 1px'></option>
                        <option value="4"><cf_get_lang no='2683.Dotted 1px'></option>
                        <option value="5"><cf_get_lang no='2003.Radius Başlıklı'></option>
                        <option value="6"><cf_get_lang no='2684.Solid top-bottom 3px'></option>
                        <option value="7"><cf_get_lang no='2685.Solid bottom 3px'></option>
                        <option value="8"><cf_get_lang no='2686.Dotted bottom 3px'></option>
                        <option value="9"><cf_get_lang no ='1988.Double 1px Başlıksız'></option>
                        <option value="10"><cf_get_lang no ='1989.Windows Ürünler İçin'></option>
                        <option value="11"><cf_get_lang_main no ='1262.Yeni'></option>
                        <option value="12"><cf_get_lang no ='1642.Özel Arkaplan'></option>
                        <option value="13"><cf_get_lang no ='1643.Özel Ürün Göster'></option>
                        <option value="14"><cf_get_lang no ='1644.İmaj Bazlı Tasarım'></option>
                        <option value="15"><cf_get_lang no ='1645.Çerçeve Alt Oval'></option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="txtboldblue"><cf_get_lang_main no='705.Marjin'></td>
                <td><cfinput type="text" name="MARGIN" validate="integer" style="width:65px;"></td>
                <td colspan="4" align="right" style="text-align:right;"><cf_workcube_buttons is_upd="0" add_function='kontrol()'></td>
            </tr>
            </cfform>
        </table>
		</td>
	</tr>
</table>
<script type="text/javascript">
function kontrol()
{
	if(document.add_main_.menu_id.value == '')
	{
		alert("<cf_get_lang no ='1991.Menu Seçiniz'> !");
		return false;
	} 
}
</script>
