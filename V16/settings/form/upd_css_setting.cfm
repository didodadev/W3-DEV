<cfquery name="get_css_setting" datasource="#dsn#">
	SELECT 
	    CSS_ID, 
        CSS_NAME,
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        IS_ACTIVE, 
        LINK_SIZE, 
        LINK_FONT, 
        LINK_COLOR, 
        TABLE_SIZE, 
        TABLE_FONT, 
        TABLE_COLOR, 
        HEAD_SIZE, 
        HEAD_FONT, 
        HEAD_COLOR, 
        TABLE_LINE_COLOR, 
        TABLE_HEAD_COLOR, 
        TABLE_LIST_COLOR, 
        TABLE_ROW_COLOR, 
        POSITION_CAT_IDS, 
        USER_GROUP_IDS, 
        TO_EMPS 
    FROM 
    	CSS_SETTINGS 
    WHERE 
	    CSS_ID = #ATTRIBUTES.css_id#
</cfquery>
<cfquery name="GET_USER_GROUPS" datasource="#dsn#">
	SELECT 
	    USER_GROUP_ID, 
        USER_GROUP_NAME, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	USER_GROUP 
    ORDER BY 
	    USER_GROUP_NAME
</cfquery>

<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT 
    	POSITION_CAT_ID, 
        POSITION_CAT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
	    SETUP_POSITION_CAT 
    ORDER BY 
    	POSITION_CAT 
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='2638.CSS Tasarımcısı'></td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
<cfform name="user_group" action="#request.self#?fuseaction=settings.emptypopup_upd_css_setting" method="post" enctype="multipart/form-data"> 
    <tr valign="top">
        <td class="color-border">
            <table width="100%" height="100%"  border="0" cellpadding="2" cellspacing="1">
                <tr class="color-row">
                    <td valign="top" width="375" nowrap>
                    <input name="CSS_ID" id="CSS_ID" type="hidden" value="<cfoutput>#get_css_setting.css_id#</cfoutput>">
                        <table>
                            <tr>
                                <td width="75">&nbsp;</td>
                                <td>
                                    <cf_get_lang_main no='81.Aktif'> <input name="is_active" id="is_active" type="checkbox" value="1" <cfif get_css_setting.is_active eq 1>checked</cfif>>&nbsp;&nbsp;&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang no='891.Menü'></td>
                                    <cfsavecontent variable="message"><cf_get_lang no='1330.Css Adı Girmelisiniz!'></cfsavecontent>                    
                                <td><cfinput type="text" name="css_name" value="#get_css_setting.css_name#" style="width:170px;" required="yes" message="#message#" maxlength="100"></td>
                            </tr>                 
                            <tr>
                                <td><cf_get_lang no='2639.Link Rengi'></td>
                                <td> 
                                    Size: <select name="link_size" id="link_size">
                                    <cfloop index="i" from="8" to="30">					  
                                        <option value="<cfoutput>#i#</cfoutput>" <cfif get_css_setting.link_size is '#i#'> selected </cfif>><cfoutput>#i#</cfoutput></option>
                                    </cfloop> 
                                    </select> 
                                        Font: <select name="link_font" id="link_font">
                                        <option value="Arial" <cfif get_css_setting.link_font is 'Arial'>selected</cfif>> Arial</option>
                                        <option value="Times" <cfif get_css_setting.link_font is 'Times'>selected</cfif>> Times</option>
                                        <option value="Courier" <cfif get_css_setting.link_font is 'Courier'>selected</cfif>> Courier</option>
                                        <option value="Georgia" <cfif get_css_setting.link_font is 'Georgia'>selected</cfif>> Georgia</option>
                                        <option value="Verdana" <cfif get_css_setting.link_font is 'Verdana'>selected</cfif>> Verdana</option>
                                        <option value="Helvetica" <cfif get_css_setting.link_font is 'Helvetica'>selected</cfif>> Helvetica</option>
                                    </select> 
                                    Color:<cfinput type="text" name="link_color" value="#get_css_setting.link_color#" style="width:40px" maxlength="6">  
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang no='2642.Tablo Yazısı'></td>
                                <td> 
                                    Size: <select name="table_size" id="table_size">
                                        <cfloop index="i" from="8" to="30">					  
                                            <option value="<cfoutput>#i#</cfoutput>" <cfif get_css_setting.table_size is '#i#'> selected </cfif>><cfoutput>#i#</cfoutput></option>
                                        </cfloop> 
                                    </select> 
                                    </select> 
                                        Font: <select name="table_font" id="table_font">
                                        <option value="Arial" <cfif get_css_setting.table_font is 'Arial'>selected</cfif>> Arial</option>
                                        <option value="Times" <cfif get_css_setting.table_font is 'Times'>selected</cfif>> Times</option>
                                        <option value="Courier" <cfif get_css_setting.table_font is 'Courier'>selected</cfif>> Courier</option>
                                        <option value="Georgia" <cfif get_css_setting.table_font is 'Georgia'>selected</cfif>> Georgia</option>
                                        <option value="Verdana" <cfif get_css_setting.table_font is 'Verdana'>selected</cfif>> Verdana</option>
                                        <option value="Helvetica" <cfif get_css_setting.table_font is 'Helvetica'>selected</cfif>> Helvetica</option>
                                    </select> 
                                    Color: <cfinput type="text" name="table_color" value="#get_css_setting.table_color#" style="width:40px" maxlength="6">  
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang no='2641.Başlık Yazısı'></td>
                                <td> 
                                    Size: <select name="head_size" id="head_size">  
                                        <cfloop index="i" from="8" to="30">					  
                                            <option value="<cfoutput>#i#</cfoutput>" <cfif get_css_setting.head_size is '#i#'> selected </cfif>><cfoutput>#i#</cfoutput></option>
                                        </cfloop> 
                                    </select>
                                    Font: <select name="head_font" id="head_font">
                                        <option value="Arial" <cfif get_css_setting.head_font is 'Arial'>selected</cfif>> Arial</option>
                                        <option value="Times" <cfif get_css_setting.head_font is 'Times'>selected</cfif>> Times</option>
                                        <option value="Courier" <cfif get_css_setting.head_font is 'Courier'>selected</cfif>> Courier</option>
                                        <option value="Georgia" <cfif get_css_setting.head_font is 'Georgia'>selected</cfif>> Georgia</option>
                                        <option value="Verdana" <cfif get_css_setting.head_font is 'Verdana'>selected</cfif>> Verdana</option>
                                        <option value="Helvetica" <cfif get_css_setting.head_font is 'Helvetica'>selected</cfif>> Helvetica</option>
                                    </select>
                                    Color: <cfinput type="text" name="head_color" value="#get_css_setting.head_color#" style="width:40px" maxlength="6">  
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang no='2640.Tablo Rengi'></td>
                                <td nowrap>
                                    <cf_get_lang_main no='255.Çizgi'>: <cfinput type="text" name="table_line_color" value="#get_css_setting.table_line_color#" style="width:40px" maxlength="6">&nbsp;
                                    <cf_get_lang_main no='1408.Başlık'>: <cfinput type="text" name="table_head_color" value="#get_css_setting.table_head_color#" style="width:40px" maxlength="6">    
                                    <cf_get_lang_main no='97.Liste'>: <cfinput type="text" name="table_list_color" value="#get_css_setting.table_list_color#" style="width:40px" maxlength="6">
                                    <cf_get_lang_main no='1096.Satır'>: <cfinput type="text" name="table_row_color" value="#get_css_setting.table_row_color#" style="width:40px" maxlength="6">  
                                </td>
                            </tr>
                        <td id="pick"></td>
                        <td colspan="2">
                            <table border=1 bgcolor="#CCCCCC" cellpadding="0" cellspacing="0" width="74">
                                <tr>
                                <input type="text" name="colour" id="colour" size="8" value="#000000" style="width:74px;" readonly>
                                <tr>
                                    <td style="background-color:#FF0000;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#FF0000')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#ff00cc;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#ff00cc')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#ff99ff;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#ff99ff')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#ffff00;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#ffff00')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#cc6600;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#cc6600')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#cccc66;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#cccc66')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#006600;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#006600')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#339900;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#339900')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#33cc69;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#33cc69')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#000099;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#000099')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#0099ff;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#0099ff')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#6699cc;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#6699cc')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#999999;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#999999')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#996666;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#996666')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#000000;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#000000')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                </tr>
                                <tr>
                                    <td style="background-color:#990000;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#990000')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#ff6666;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#ff6666')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#990099;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#990099')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#ffcc00;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#ffcc00')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#663300;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#663300')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#ff9966;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#ff9966')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#006666;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#006666')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#666600;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#666600')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#99cc00;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#99cc00')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#333366;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#333366')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#6633cc;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#6633cc')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#9999ff;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#9999ff')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#999966;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#999966')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#cccc99;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#cccc99')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                    <td style="background-color:#666666;" width="12"><a href="javascript://" onClick="ColorPalette_OnClick('#666666')"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0></a></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>	
            </td>
            <td valign="top" width="25%">
                <div id="yetki" style="position:absolute;width:100%;height:99%; z-index:88;overflow:auto;" >
                    <table>
                        <tr>
                            <td class="formbold"><cf_get_lang no='161.Yetki Grupları'></td>
                        </tr>
                            <cfoutput query="get_user_groups">
                                <tr>
                                    <td><input type="checkbox" name="user_group_ids" id="user_group_ids" value="#user_group_id#" <cfif listfind(get_css_setting.USER_GROUP_IDS,user_group_id)>checked</cfif>> #user_group_name#</td>
                                </tr>   
                            </cfoutput>						
                    </table>
                </div>
            </td>
            <td valign="top" width="25%">
                <div id="pozisyon" style="position:absolute;width:100%;height:99%; z-index:88;overflow:auto;">
                    <table>
                    <tr>
                    <td class="formbold"><cf_get_lang_main no='367.Pozisyon Tipleri'></td>
                    </tr>
                    <cfoutput query="GET_POSITION_CATS">
                    <tr>
                    <td><input type="checkbox" name="position_cat_ids" id="position_cat_ids" value="#POSITION_CAT_ID#" <cfif listfind(get_css_setting.position_cat_ids,POSITION_CAT_ID)>checked</cfif>> #POSITION_CAT#</td>
                    </tr>   
                    </cfoutput>	
                    </table>
                </div>
            </td>			
            <td valign="top" width="25%">			  	
                <div id="calisan" style="position:absolute;width:100%;height:99%; z-index:88;overflow:auto;">
                    <cfsavecontent variable="txt_1"><cf_get_lang_main no='1463.Çalışanlar'></cfsavecontent>
                    <cf_workcube_to_cc 
                        is_update = "1" 
                        to_dsp_name = "#txt_1#" 
                        form_name = "user_group" 
                        str_list_param = "1"
                        action_dsn = "#DSN#"
                        str_action_names = "TO_EMPS AS TO_EMP"
                        action_table = "CSS_SETTINGS"
                        action_id_name = "CSS_ID"
                        action_id = "#attributes.css_id#"
                        data_type = "1"
                        str_alias_names = "">
                </div>
            </td> 
                <tr class="color-row">
                    <td height="30" colspan="4">
                        <table width="99%">
                            <tr>
                                <td class="txtbold">
                                    <cfoutput><cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_css_setting.record_emp,0,0)# - #dateformat(get_css_setting.record_date,dateformat_style)#</cfoutput>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cfoutput><cf_get_lang_main no='638.Son Güncelleme'> : #get_emp_info(get_css_setting.update_emp,0,0)# - #dateformat(get_css_setting.update_date,dateformat_style)#</cfoutput>	
                                </td>
                                <td align="right" style="text-align:right;">
                                    <cf_workcube_buttons is_upd='1' is_delete='0'>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr> 
</table>
</cfform>
<script type="text/javascript">
function ColorPalette_OnClick(colorString){
	document.getElementById('pick').style.backgroundColor = colorString;
	document.user_group.colour.value=colorString;	
}
</script>

