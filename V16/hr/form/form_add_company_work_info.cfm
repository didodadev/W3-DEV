<cfquery name="check" datasource="#DSN#">
    select 
    	COMP_ID, 
        COMPANY_NAME, 
        NICK_NAME, 
        TAX_OFFICE, 
        TAX_NO, 
        TEL_CODE, 
        TEL, 
        FAX, 
        MANAGER, 
        WEB, 
        EMAIL, 
        ADDRESS, 
        ADMIN_MAIL, 
        TEL2, 
        TEL3, 
        TEL4, 
        FAX2, 
        T_NO, 
        SERMAYE, 
        CHAMBER, 
        CHAMBER_NO, 
        CHAMBER2, 
        CHAMBER2_NO, 
        ASSET_FILE_NAME1, 
        ASSET_FILE_NAME1_SERVER_ID, 
        ASSET_FILE_NAME2, 
        ASSET_FILE_NAME2_SERVER_ID, 
        ASSET_FILE_NAME3, 
        ASSET_FILE_NAME3_SERVER_ID 
    from 
	    our_company 
    where 
    	COMP_ID = #session.ep.company_id#
</cfquery>
<cfform name="add_asset" action="#request.self#?fuseaction=settings.emptypopup_upd_our_company"  method="post" enctype="multipart/form-data">
<cfoutput>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55194.Şirket Çalışma Bilgileri"></cfsavecontent>
<cf_form_box title="#message#">
    <input type="Hidden" name="comp_id" id="comp_id" value="#check.comp_id#">
    <table>
        <tr>
            <td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id='57980.Genel Bilgiler'></td>
            <td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id='35131.İletişim Bilgileri'></td>
        </tr>
        <tr>
            <td width="85"><cf_get_lang dictionary_id='55925.Tam Adı'>*</td>
            <td width="170">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='55925.Tam Ad'></cfsavecontent>
                <cfinput type="text" name="company_name" value="#check.company_name#" required="Yes" message="#message#" style="width:150px;">
            </td>
            <td width="85"><cf_get_lang dictionary_id='55920.Telefon Kodu'></td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='55920.Telefon Kodu'></cfsavecontent>
                <cfinput type="text" name="tel_code" value="#check.tel_code#" maxlength="5" style="width:150px;" validate="integer" message="#message#">
            </td>
        </tr>
        <tr>
            <td height="28"><cf_get_lang dictionary_id='55914.Kısa Ünvanı'>*</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='55914.Kısa Ünvanı'></cfsavecontent>
                <cfinput type="text" name="nick_name" value="#check.nick_name#" style="width:150px;" required="yes" message="#message#">
            </td>
            <td><cf_get_lang dictionary_id='48176.Telefon'></td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48176.Telefon no'></cfsavecontent>
                <cfinput type="text" name="tel" value="#check.tel#" style="width:150px;" validate="integer" message="#message#">
            </td>
        </tr>
        <tr>
            <td height="26"> <cf_get_lang dictionary_id='29511.Yönetici'></td>
            <td>
            <cfinput type="text" name="manager" value="#check.manager#" style="width:150px;" maxlength="40">
            </td>
            <td><cf_get_lang dictionary_id='57499.Telefon'> 2</td>
            <td>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48176.Telefon no'></cfsavecontent>
            <cfinput type="text" name="tel2" value="#check.TEL2#" style="width:150px;" validate="integer" message="#message#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
            <td><cfinput type="text" name="tax_office" value="#check.tax_office#" style="width:150px;"></td>
            <td><cf_get_lang dictionary_id='57499.Telefon'> 3</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48176.Telefon no'></cfsavecontent>
                <cfinput type="text" name="tel3" value="#check.TEL3#" style="width:150px;" validate="integer" message="#message#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='340.Vergi No'></td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57752.Vergi No'></cfsavecontent>
                <cfinput type="text" name="tax_no" value="#check.tax_no#" style="width:150px;" validate="integer" message="#message#">
            </td>
            <td><cf_get_lang dictionary_id='57499.Telefon'> 4</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48176.Telefon no'></cfsavecontent>
                <cfinput type="text" name="tel4" value="#check.TEL4#" style="width:150px;" validate="integer" message="#message#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55916.Oda'></td>
            <td><cfinput type="text" name="chamber" value="#check.chamber#" style="width:150px;">
            </td>
            <td><cf_get_lang dictionary_id='57488.Faks'></td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57488.Faks'></cfsavecontent>
                <cfinput type="text" name="fax" value="#check.fax#" style="width:150px;" validate="integer" message="#message#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55917.Oda Sicil No'></td>
            <td><cfinput type="text" name="chamber_no" value="#check.chamber_no#" style="width:150px;">
            </td>
            <td><cf_get_lang dictionary_id='57488.Faks'> 2</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57488.Faks'></cfsavecontent>
                <cfinput type="text" name="FAX2" value="#check.fax2#" style="width:150px;" validate="integer" message="#message#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55916.Oda'> 2</td>
            <td><cfinput type="text" name="chamber2" value="#check.chamber2#" style="width:150px;"></td>
            <td><cf_get_lang dictionary_id='57428.E-mail'></td>
            <td><cfinput type="text" name="email" value="#check.email#"  style="width:150px;"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55917.Oda Sicil No'> 2</td>
            <td><cfinput type="text" name="chamber2_no" value="#check.chamber2_no#" style="width:150px;"></td>
            <td><cf_get_lang dictionary_id='55435.İnternet'></td>
            <td><input type="text" name="web" id="web" value="#check.web#" style="width:150px;"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='58410.Sermaye'></td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58410.Sermaye'></cfsavecontent>
                <cfinput type="text" name="sermaye" value="#check.SERMAYE#" style="width:150px;" validate="integer" message="#message#">
            </td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55918.Ticaret Sicil No'></td>
            <td><input type="text" name="T_NO" id="T_NO" value="#check.T_NO#" style="width:150px;"></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td valign="top"><cf_get_lang dictionary_id='55919.Sistem Yönetici E-Mailleri'></td>
            <td><TEXTAREA name="admin_mail" id="admin_mail" rows="1" style="width:150px;height:60px;">#check.admin_mail#</TEXTAREA></td>
            <td valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
            <td><TEXTAREA name="address" id="address" style="width:150px;height:60px;">#check.address#</TEXTAREA></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>(<cf_get_lang dictionary_id='55927.Mail Adreslerini Tırnak İle Ayırarak Yazınız'>)</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
    </table>
    <cf_form_box_footer><cf_workcube_buttons is_upd='0'></cf_form_box_footer>
</cf_form_box><br />
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55921.Logolar"></cfsavecontent>
<cf_form_box title="#message#">
    <table>
        <tr>
            <td width="125" class="txtbold"><cf_get_lang dictionary_id='55922.Büyük Logo'></td>
            <td><input type="FILE" style="width:200px;" name="asset1" id="asset1"></td>
        </tr>
        <tr>
            <td colspan="2"><a href="javascript://" onClick="windowopen('#file_web_path#settings/#check.asset_file_name1#','medium')"><cf_get_server_file output_file="settings/#check.asset_file_name1#" output_server="#check.asset_file_name1_server_id#" output_type="0" image_width="30" image_height="40" image_link="1"></a><br/>
            </td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='55923.Orta Logo'></td>
            <td><input type="FILE" style="width:200px;" name="asset2" id="asset2"></td>
        </tr>
        <tr>
            <td colspan="2"><a href="javascript://" onClick="windowopen('#file_web_path#settings/#check.asset_file_name2#','medium')"><cf_get_server_file output_file="settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="0" image_width="25" image_height="35"   image_link="1"></a><br/>
            </td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='55924.Küçük Logo'></td>
            <td><input type="FILE" style="width:200px;" name="asset3" id="asset3"></td>
        </tr>
        <tr>
        <td colspan="2">
            <a href="javascript://" onClick="windowopen('#file_web_path#settings/#check.asset_file_name3#','medium')"><cf_get_server_file output_file="settings/#check.asset_file_name3#" output_server="#check.asset_file_name3_server_id#" output_type="0" image_width="20" image_height="30"  image_link="1"></a></td>
        </tr>
    </table>
    <cf_form_box_footer><cf_workcube_buttons is_upd='0'></cf_form_box_footer>
</cf_form_box>
</cfoutput>
</cfform><br />

