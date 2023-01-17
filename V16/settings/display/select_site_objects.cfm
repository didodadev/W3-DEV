<cfif listlen(attributes.faction,'.') eq 2>
	<cfset my_faction = listgetat(attributes.faction,2,'.')>
<cfelse>
	<cfset my_faction = attributes.faction>
</cfif>
<cfif isdefined("attributes.faction")>
	<cfquery name="GET_" datasource="#DSN#">
		SELECT 
        	LAYOUT_ID, 
            FACTION, 
            LEFT_WIDTH, 
            RIGHT_WIDTH, 
            CENTER_WIDTH, 
            MARGIN, 
            LEFT_DESIGN_ID, 
            RIGHT_DESIGN_ID, 
            CENTER_DESIGN_ID, 
            LEFT_OBJECT_NAME, 
            RIGHT_OBJECT_NAME, 
            CENTER_OBJECT_NAME, 
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            UPDATE_EMP, 
            UPDATE_IP, 
            UPDATE_DATE, 
            MENU_ID 
        FROM 
    	    MAIN_SITE_LAYOUTS 
        WHERE 
	        FACTION = '#my_faction#' AND MENU_ID = #attributes.menu_id#
	</cfquery>
	<cfquery name="GET_ALTS" datasource="#DSN#">
		SELECT 
        	ROW_ID, 
            OBJECT_POSITION, 
            OBJECT_NAME, 
            FACTION, 
            ORDER_NUMBER, 
            OBJECT_FILE_NAME, 
            MENU_ID, 
            DESIGN_ID 
        FROM 
    	    MAIN_SITE_LAYOUTS_SELECTS 
        WHERE 
	        FACTION = '#my_faction#' AND MENU_ID = #attributes.menu_id# 
        ORDER BY 
        	OBJECT_POSITION DESC,ORDER_NUMBER
	</cfquery>
	<cfquery name="GET_SITE_NAME" datasource="#DSN#">
		SELECT MENU_NAME FROM MAIN_MENU_SETTINGS WHERE MENU_ID = #attributes.menu_id#
	</cfquery>
</cfif>
<cfquery name="get_object_design" datasource="#DSN#">
	SELECT 
    	DESIGN_ID, 
        DESIGN_NAME, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP 
    FROM 
	    MAIN_SITE_OBJECT_DESIGN 
    ORDER BY 
    	DESIGN_ID
</cfquery>
<cfset design_list = valuelist(get_object_design.design_id,',')>

<table cellspacing="1" cellpadding="2" width="100%" class="color-list" align="center" height="100%">
	<tr class="color-list">
		<td height="35" class="headbold" colspan="2"><cf_get_lang no='1456.Sayfa Tasarımı'>: <cfoutput>#my_faction#  (#get_site_name.menu_name#)</cfoutput></td>
		<td style="text-align:right"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_copy_site_objects&faction=#get_.faction#&old_menu_id=#attributes.menu_id#</cfoutput>','small');"><img src="images/plus.gif" alt="<cf_get_lang_main no='64.Kopyala'>" title="<cf_get_lang_main no='64.Kopyala'>" border="0"></a></td>
 	</tr>
	<tr class="color-row">
		<td valign="top" colspan="3">
			<cfif isdefined("attributes.faction")>
		<table>
		<cfform action="#request.self#?fuseaction=settings.emptypopup_add_site_layout" name="add_main_" method="post">
		<input type="hidden" name="faction" id="faction" value="<cfoutput>#my_faction#</cfoutput>">
		<input type="hidden" name="menu_id" id="menu_id" value="<cfoutput>#attributes.menu_id#</cfoutput>">
		<input type="hidden" name="is_add" id="is_add" value="<cfif get_.recordcount>0<cfelse>1</cfif>">
		<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_alts.recordcount#</cfoutput>">
		<input type="hidden" name="yeni_record_num" id="yeni_record_num" value="0">
            <tr>
                <td></td>
                <td><cf_get_lang_main no='283.Genişlik'> PX</td>
                <td><cf_get_lang_main no='68.Başlık'></td>
                <td><cf_get_lang_main no='1995.Tasarım'></td>
            </tr>
            <tr>
                <td class="txtboldblue"><cf_get_lang no='1628.Sol Blok'></td>
                <cfsavecontent variable="message"><cf_get_lang no ='1987.Sol Uzunluk Giriniz'></cfsavecontent>
                <td><cfinput type="text" name="LEFT_WIDTH" value="#get_.left_width#" validate="integer" message="#message#" style="width:50px;"></td>
                <td><input type="text" name="left_object_name" id="left_object_name" value="<cfoutput>#get_.left_object_name#</cfoutput>" style="width:100px;"></td>
                <td><select name="left_design_id" id="left_design_id" style="width:120px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_object_design">
                            <option value="#design_id#" <cfif get_.left_design_id eq design_id>selected</cfif>>#design_name#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="txtboldblue"><cf_get_lang no='1636.Orta Blok'></td>
                <cfsavecontent variable="message"><cf_get_lang no ='1993.Orta Uzunluk Giriniz'></cfsavecontent>
                <td><cfinput type="text" name="CENTER_WIDTH" value="#get_.center_width#" validate="integer" message="!" style="width:50px;"></td>
                <td><input type="text" name="center_object_name" id="center_object_name" value="<cfoutput>#get_.center_object_name#</cfoutput>" style="width:100px;"></td>
                <td><select name="center_design_id" id="center_design_id" style="width:120px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_object_design">
                            <option value="#design_id#" <cfif get_.center_design_id eq design_id>selected</cfif>>#design_name#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="txtboldblue"><cf_get_lang no ='1992.Sağ Blok'></td>
                <cfsavecontent variable="message"><cf_get_lang no ='1994.Sağ Uzunluk Giriniz'></cfsavecontent>
                <td><cfinput type="text" name="RIGHT_WIDTH" value="#get_.right_width#" validate="integer" message="!" style="width:50px;"></td>
                <td><input type="text" name="right_object_name" id="right_object_name" value="<cfoutput>#get_.right_object_name#</cfoutput>" style="width:100px;"></td>
                <td><select name="right_design_id" id="right_design_id" style="width:120px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_object_design">
                            <option value="#design_id#" <cfif get_.right_design_id eq design_id>selected</cfif>>#design_name#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="txtboldblue"><cf_get_lang_main no='705.Marjin'></td>
                <td><cfinput type="text" name="MARGIN" value="#get_.margin#" validate="integer" style="width:50px;"></td>
                <td colspan="4" align="right" style="text-align:right;"><cf_workcube_buttons is_upd="1" delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_select_site_objects&layout_id=#get_.layout_id#&faction=#get_.faction#&menu_id=#get_.menu_id#'></td>
            </tr>
        </cfform>
        </table>
        	<div style="position:absolute; left:370px; height:50px; background-color:#FFFFFF; top:40px; width:230px; height:150px; z-index:88;overflow:auto;">
            	<iframe src="<cfoutput>#request.self#?fuseaction=settings.popup_view_design&iframe=1&menu_id=#attributes.menu_id#</cfoutput>" frameborder="0" scrolling="yes" width="230" height="150"></iframe>
         	</div>
        <table>
            <tr>
                <td>
					<cfif len(get_.record_emp)><strong><cf_get_lang_main no='71.Kayıt'> :</strong>&nbsp;&nbsp;<cfoutput>#get_emp_info(get_.record_emp,0,0)# - #dateformat(get_.record_date,dateformat_style)#</cfoutput>&nbsp;&nbsp;</cfif><br>
                    <cfif len(get_.update_emp)><strong><cf_get_lang_main no='479.Güncelleyen'> :</strong>&nbsp;&nbsp;<cfoutput>#get_emp_info(get_.update_emp,0,0)# - #dateformat(get_.update_date,dateformat_style)#</cfoutput></cfif>
                </td>
            </tr>
        </table>
        <br>
        <cfquery name="get_4" dbtype="query">
            SELECT * FROM GET_ALTS WHERE OBJECT_POSITION = 4 
        </cfquery>
        <cfquery name="get_3" dbtype="query">
            SELECT * FROM GET_ALTS WHERE OBJECT_POSITION = 3 
        </cfquery>
        <cfquery name="get_2" dbtype="query">
            SELECT * FROM GET_ALTS WHERE OBJECT_POSITION = 2 
        </cfquery>
        <cfquery name="get_1" dbtype="query">
            SELECT * FROM GET_ALTS WHERE OBJECT_POSITION = 1 
        </cfquery>
        <table cellspacing="1" cellpadding="2" width="98%%" align="center" class="color-header">
            <tr class="color-list">		
                <td colspan="3"><input type="button" value="<cf_get_lang no ='1995.Obje Ekle'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_select_site_files&menu_id=#attributes.menu_id#<cfif isdefined("attributes.is_pda") and Len(attributes.is_pda)>&is_pda=1</cfif>&faction=#faction#</cfoutput>','list');"></td>
            </tr>
            <tr height="75" class="color-row">
                <td colspan="3" valign="top" height="75">
                    <table width="99%">
                    <cfoutput query="get_4">
                        <cfquery name="get_design" dbtype="query">
                            SELECT DESIGN_NAME FROM GET_OBJECT_DESIGN WHERE DESIGN_ID = #design_id#
                        </cfquery>
                        <tr title="<cf_get_lang_main no ='2003.Dosya Adı'> : #object_file_name# - <cf_get_lang_main no ='1995.Tasarım'> : #get_design.design_name#" bgcolor="FFFFFF">
                            <td>#order_number#</td>
                            <td><cfif len(object_name)>#object_name#<cfelse>#object_file_name#</cfif></td>
                            <td width="35">
                            <cfsavecontent variable="message"><cf_get_lang no ='1997.Siteye Eklenmiş Olan Objeyi Siliyorsunuz! Emin misiniz'></cfsavecontent>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_select_site_files&row_id=#row_id#&menu_id=#attributes.menu_id#','list');"><img src="images/update_list.gif" border="0"></a>
                            <a href="javascript://" onclick="javascript:if(confirm('#message#')) windowopen('#request.self#?fuseaction=settings.emptypopup_del_site_row&row_id=#row_id#','small'); else return false;"><img src="images/delete_list.gif" border="0"></a>
                            </td>
                        </tr>
                    </cfoutput>
                    </table>
                </td>
            </tr>
            <tr height="75" class="color-row">
                <td width="33%" valign="top">
                    <table width="99%">
                    <cfoutput query="get_1">
                        <cfquery name="get_design" dbtype="query">
                            SELECT DESIGN_NAME FROM get_object_design WHERE DESIGN_ID = #design_id#
                        </cfquery>
                        <tr title="<cf_get_lang_main no ='2003.Dosya Adı'> : #object_file_name# - <cf_get_lang_main no ='1995.Tasarım'>  : #get_design.design_name#" bgcolor="FFFFFF">
                            <td>#order_number#</td>
                            <td><cfif len(object_name)>#object_name#<cfelse>#object_file_name#</cfif></td>
                            <td width="35">
                            <cfsavecontent variable="message"><cf_get_lang no ='1997.Siteye Eklenmiş Olan Objeyi Siliyorsunuz! Emin misiniz'></cfsavecontent>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_select_site_files&row_id=#row_id#&menu_id=#attributes.menu_id#<cfif isdefined("attributes.is_pda") and Len(attributes.is_pda)>&is_pda=1</cfif>','list');"><img src="images/update_list.gif" border="0"></a>
                            <a href="javascript://" onclick="javascript:if(confirm('#message#')) windowopen('#request.self#?fuseaction=settings.emptypopup_del_site_row&row_id=#row_id#','small'); else return false;"><img src="images/delete_list.gif" border="0"></a>
                            </td>
                        </tr>
                    </cfoutput>
                    </table>
                </td>
                <td width="33%" valign="top">
                    <table width="99%">
                    <cfoutput query="get_2">
                        <cfquery name="get_design" dbtype="query">
                            SELECT DESIGN_NAME FROM get_object_design WHERE DESIGN_ID = #design_id#
                        </cfquery>
                        <tr title="<cf_get_lang_main no ='2003.Dosya Adı'> : #object_file_name# - <cf_get_lang_main no ='1995.Tasarım'>  : #get_design.design_name#" bgcolor="FFFFFF">
                            <td>#order_number#</td>
                            <td><cfif len(object_name)>#object_name#<cfelse>#object_file_name#</cfif></td>
                            <td width="35">
                            <cfsavecontent variable="message"><cf_get_lang no ='1997.Siteye Eklenmiş Olan Objeyi Siliyorsunuz! Emin misiniz'></cfsavecontent>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_select_site_files&row_id=#row_id#&menu_id=#attributes.menu_id#','list');"><img src="images/update_list.gif" border="0"></a>
                            <a href="javascript://" onclick="javascript:if(confirm('#message#')) windowopen('#request.self#?fuseaction=settings.emptypopup_del_site_row&row_id=#row_id#','small'); else return false;"><img src="images/delete_list.gif" border="0"></a>
                            </td>
                        </tr>
                    </cfoutput>
                    </table>
                </td>
                <td width="33%" valign="top">
                    <table width="99%">
                    <cfoutput query="get_3">
                        <cfquery name="get_design" dbtype="query">
                            SELECT DESIGN_NAME FROM get_object_design WHERE DESIGN_ID = #design_id#
                        </cfquery>
                        <tr title="<cf_get_lang_main no ='2003.Dosya Adı'> : #object_file_name# - <cf_get_lang_main no ='1995.Tasarım'>: #get_design.design_name#" bgcolor="FFFFFF">
                            <td>#order_number#</td>
                            <td><cfif len(object_name)>#object_name#<cfelse>#object_file_name#</cfif></td>
                            <td width="35">
                            <cfsavecontent variable="message"><cf_get_lang no ='1997.Siteye Eklenmiş Olan Objeyi Siliyorsunuz! Emin misiniz'></cfsavecontent>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_select_site_files&row_id=#row_id#&menu_id=#attributes.menu_id#','list');"><img src="images/update_list.gif" border="0"></a>
                            <a href="javascript://" onclick="javascript:if(confirm('#message#')) windowopen('#request.self#?fuseaction=settings.emptypopup_del_site_row&row_id=#row_id#','small'); else return false;"><img src="images/delete_list.gif" border="0"></a>
                            </td>
                        </tr>
                    </cfoutput>
                    </table>
                    </td>
                </tr>
            </table>
			<cfelse>
			<cf_get_lang no ='1996.Düzenlenecek Sayfa Seçmelisiniz'>!
			</cfif>
		</td>
	</tr>
</table>
