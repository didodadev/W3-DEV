<!--- bu sayfaının nerde ise aynısı myhome modülündede var bu sayfada yapılan değişiklikler myhome deki dosyayada taşınsın--->
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55267.Seçim Listesinde Aday Ara"></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=hr.popup_select_list_search&list_id=#attributes.list_id#">
    <table width="100%">
        <tr>
            <td><cf_get_lang dictionary_id='57756.durum'></td>
            <td>
                <select name="status" id="status">
                    <option value="" selected><cf_get_lang dictionary_id='57708.Tümü'>	
                    <option value="1"><cf_get_lang dictionary_id='57493.Aktif'>
                    <option value="0"><cf_get_lang dictionary_id='57494.Pasif'>			                        
                </select> 	 
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55329.Çalışmak İstediği Yer'></td>
            <cfquery name="get_city" datasource="#dsn#">
                SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
            </cfquery>
            <td colspan="3">
                <select name="prefered_city" id="prefered_city" style="width:150px;">
                    <option value=""><cf_get_lang dictionary_id='56175.TÜM TÜRKİYE'></option>
                    <cfoutput query="get_city">
                        <option value="#city_id#">#city_name#</option>
                    </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
            <td width="125"><cf_get_lang dictionary_id='57631.Ad'></td>
            <td><input type="text" name="app_name" id="app_name" value="" style="width:150px;"></td>
        </tr>
        <tr>
            <td width="125"><cf_get_lang dictionary_id='58726.Soyad'></td>
            <td><input type="text" name="app_surname" id="app_surname" value="" style="width:150px;"></td>
        </tr>
        <tr>
            <td width="125"><cf_get_lang dictionary_id='55745.Yaş'></td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='55741.Yaş rakamla girmelisiniz'></cfsavecontent>
                <cfinput type="text" style="width:70px;" name="birth_date1" value="" validate="integer" range="1," maxlength="2" message="#message#">
                /
                <cfinput type="text" style="width:70px;" name="birth_date2" value="" validate="integer" range="1," maxlength="2" message="#message#">
            </td>
            </tr>
            <tr>
            <td><cf_get_lang dictionary_id='55654.Medeni Durum'></td>
            <td>
                <input type="checkbox" name="married" id="married" value="0">
                <cf_get_lang dictionary_id='55744.Bekar'>
                <input type="checkbox" name="married" id="married" value="1">
                <cf_get_lang dictionary_id='55743.Evli'> </td>
        </tr>
        <tr>
            <td width="125"><cf_get_lang dictionary_id='57764.Cinsiyet'></td>
            <td><input type="checkbox" name="sex" id="sex" value="1">
                <cf_get_lang dictionary_id='58959.Erkek'>
                <input type="checkbox" name="sex" id="sex" value="0">
                <cf_get_lang dictionary_id='55621.Kadın'> </td>
        </tr>
        <tr>
            <td width="85"><cf_get_lang dictionary_id='31705.Seyahat Edebilir misiniz'>?</td>
            <td><input type="checkbox" name="is_trip" id="is_trip" value="1"></td>
        </tr>
        <tr>
            <td width="85"><cf_get_lang dictionary_id='55255.Ehliyeti Var mı'>?</td>
            <td><input type="checkbox" name="driver_licence" id="driver_licence" value="1">
            <cf_get_lang dictionary_id='35233.Ehliyet Sınıf'> <cfinput type="Text" name="driver_licence_type" maxlength="15"  style="width:45px;">
            </td>
        </tr>
        <tr height="22">
            <td height="21"><cf_get_lang dictionary_id='55619.Askerlik'></td>
            <td>
                <input type="checkbox" name="military_status" id="military_status" value="0">
                <cf_get_lang dictionary_id='55624.Yapmadı'>
                <input type="checkbox" name="military_status" id="military_status" value="1">
                <cf_get_lang dictionary_id='55625.Yaptı'>
                <input type="checkbox" name="military_status" id="military_status" value="2">
                <cf_get_lang dictionary_id='55626.Muaf'>
                <input type="checkbox" name="military_status" id="military_status" value="3">
                <cf_get_lang dictionary_id='55627.Yabancı'> 
                <input type="checkbox" name="military_status" id="military_status" value="4">
                <cf_get_lang dictionary_id='55340.Tecilli'>
            </td>
        </tr>
        <tr>
            <td width="125"><cf_get_lang dictionary_id='55307.Deneyim'> </td>
            <td colspan="3">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='55256.Deneyimi rakamla giriniz'>!</cfsavecontent>
                <cfinput name="exp_year_s1" style="width:70px;" value="" validate="integer" range="0,99" maxlength="2" message="#message#"> 
                / <cfinput name="exp_year_s2" style="width:70px;" value="" validate="integer" range="0,99" maxlength="2" message="#message#"> <cf_get_lang dictionary_id='1043.yıl'>
            </td>
        </tr>
            <cfquery name="GET_EDU4" datasource="#DSN#">
                SELECT
                    SCHOOL_ID,
                    SCHOOL_NAME
                FROM
                    SETUP_SCHOOL
                ORDER BY SCHOOL_NAME
            </cfquery>
        <tr>
            <td><cf_get_lang dictionary_id='29755.Üniversite'></td>
            <td>
                <select name="edu4" id="edu4">
                <option value=""><cf_get_lang dictionary_id='29755.Üniversite'></option>
                <cfloop query="GET_EDU4">
                <option value="<cfoutput>#GET_EDU4.SCHOOL_ID#</cfoutput>"><cfoutput>#GET_EDU4.SCHOOL_NAME#</cfoutput></option>
                </cfloop>
                </select>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='57995.Bölüm'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <cfsavecontent variable="text"><cf_get_lang dictionary_id='57995.Bölüm'></cfsavecontent>
                <cf_wrk_combo
                    name="edu4_part"
                    query_name="GET_SCHOOL_PART"
                    option_name="PART_NAME"
                    option_value="PART_ID"
                    option_text="#text#">
            </td>
        </tr>
    </table>
    <cf_popup_box_footer>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57565.Ara'></cfsavecontent>
        <cf_workcube_buttons is_upd='0' insert_info='#message#' insert_alert='' >
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>
