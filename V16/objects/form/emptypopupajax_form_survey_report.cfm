<cfsetting showdebugoutput="no"><!--- ajax sayfa oldg. için --->
<cfquery name="get_target_member" datasource="#dsn#">
	SELECT TARGET_COMPANY,TARGET_CONSUMER,TARGET_EMPLOYEE,TARGET_WEBSITE FROM PUBLISH
</cfquery>
<cfform name="form_survey_report" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_ajax_related_parts">
<table width="99%" align="center">
    <tr height="18"> 
        <td class="txtbold"><cf_get_lang dictionary_id='60270.Form Başlığı'>:<br /></td>
        <td class="txtbold">&nbsp;</td>
    </tr>
    <tr height="18"> 
        <td class="txtbold"><cf_get_lang dictionary_id='60271.Form Detayı'>:<br /></td>
        <td class="txtbold">&nbsp;</td>
    </tr>
    <tr height="18"> 
        <td class="txtbold"><cf_get_lang dictionary_id='60122.Katılımcı Sayısı'>:<br /></td>
        <td class="txtbold">&nbsp;</td>
    </tr>
    <tr height="18"> 
        <td class="txtbold"><cf_get_lang dictionary_id='60272.Bölüm Başlığı'>:<br /></td>
        <td class="txtbold">&nbsp;</td>
    </tr>
    <tr height="18"> 
        <td class="txtbold"><cf_get_lang dictionary_id='60273.Bölüm detayı'>:<br /></td>
        <td class="txtbold">&nbsp;</td>
    </tr>
</table>
<cf_medium_list>
	<thead>
    <tr class="color-header"> 
        <th><cf_get_lang dictionary_id='60274.Şıklar'></th>
        <th><cf_get_lang dictionary_id='57771.Detay'></th>
        <th><cf_get_lang dictionary_id='58984.Puan'></th>
        <th><cf_get_lang dictionary_id='29772.Skorlar'></th>
        <th><cf_get_lang dictionary_id='57467.Not'></th>
        <th><cf_get_lang dictionary_id='60275.Oylama Sayısı'></th>
    </tr>
    </thead>
    <tbody>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
    </tbody>
</cf_medium_list>
</cfform>


