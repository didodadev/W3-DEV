<cfparam name="attributes.department_id" default="0">
<cfparam name="attributes.start_date" default="#now()#">
<cfquery name="STORES" datasource="#DSN#">
	SELECT
		*
	FROM
		DEPARTMENT
	WHERE 
		IS_STORE <> 2
		AND	DEPARTMENT_STATUS = 1
		AND BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = #SESSION.EP.COMPANY_ID#)
	ORDER BY
		DEPARTMENT_HEAD
</cfquery>
<cfif isdate(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date, "dd/mm/yyyy")>
</cfif>
<cf_popup_box title="Sayım Belgesi Birleştir">
<cfform name="form_basket" action="#request.self#?fuseaction=retail.emptypopup_add_del_fileimports_total_all" method="post" onsubmit="return ( kontrol());">
<input type="hidden" name="is_del_file" id="is_del_file" value="0">
    <table>
        <tr>
            <td><cf_get_lang_main no='1351.Depo'></td>
            <td>
                <cf_wrkdepartmentlocation 
                    returnInputValue="location_id,departman_name,department_id"
                    returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                    fieldName="departman_name"
                    fieldid="location_id"
                    department_fldId="department_id"
                    branch_fldId="branch_id"
                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                    width="135">
            </td>
        </tr>  
		<td>Kategori</td>
		<td>
			<input type="hidden" name="product_catid" id="product_catid" value="">
			<input type="text" name="product_cat" id="product_cat" value="" style="width:135px;">
			<a href="javascript://"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=product_catid&field_name=form_basket.product_cat','list');"><img src="/images/plus_thin.gif" border="0" title="<cf_get_lang no='146.Ürün Kategorisi Ekle'>!" align="absbottom"></a>
		</td>
        <tr>
            <td><cf_get_lang_main no ='467.İşlem Tarihi'></td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no ='531.Tarihi Seciniz'></cfsavecontent>
                <cfinput type="text" name="start_date" value="#attributes.start_date#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#" required="yes">
                <cf_wrk_date_image date_field="start_date"> 
            </td>
        </tr>
    </table>
    <cf_popup_box_footer>
        <cfsavecontent variable="message">Belgeleri Birleştir</cfsavecontent>
        <cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' insert_info='#message#' add_function='kontrol()'>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.form_basket.location_id.value.length == 0)
		{
			alert("<cf_get_lang no ='61.Depo Seçiniz'>");	
			return false;
		}
		else
			return true;
	}	
</script>