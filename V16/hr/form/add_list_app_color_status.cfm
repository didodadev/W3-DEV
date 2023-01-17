<!--- sayfa secim listesinden cagrildi ise ve list_row_id leri bos ise--->
<cfif (isdefined("attributes.is_sel_list") and not isdefined("attributes.list_row_id"))>
	<script type="text/javascript">
		{
			alert("<cf_get_lang dictionary_id='30942.Listeden Satır Seçmelisiniz'>!");
			window.close();
		}
	</script>
	<cfabort>
</cfif>
<cfif isdefined("attributes.list_row_id") and len(attributes.list_row_id)><!--- secim listesinden gelen row larin empapp_id lerini bulur--->
	<cfquery name="get_list_row" datasource="#dsn#">
		SELECT EMPAPP_ID FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ROW_ID IN (#attributes.list_row_id#)
	</cfquery>
	<cfset list_empapp_id = valuelist(get_list_row.empapp_id,',')>
</cfif>
<!--- toplu renk degistirme ekranı basvuru sonuclari ve secim listesi ekranlarindan cagiriliyor. senay 20070529--->
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55566.CV Renk Durumu Güncelle"></cfsavecontent>
<cf_popup_box title="#message#">
    <cfform name="add_form" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_app_color">
    <table border="0">
    <input type="hidden" name="list_empapp_id" id="list_empapp_id" value="<cfoutput>#list_empapp_id#</cfoutput>">			  
    <tr>
        <td width="75">CV Durum</td>
        <td>
            <cfquery name="get_cv_status" datasource="#dsn#">
                SELECT STATUS_ID,STATUS FROM SETUP_CV_STATUS ORDER BY STATUS_ID
            </cfquery>							
            <select name="status_id" id="status_id" style="width:230px;">
            <cfoutput query="get_cv_status">
                <option value="#status_id#">#status#
            </cfoutput>
            </select>
        </td>
    </tr>
    </table>
    <cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
    </cfform>
</cf_popup_box>
