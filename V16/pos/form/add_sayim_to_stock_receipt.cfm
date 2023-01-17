<cf_date tarih = 'attributes.fis_date'>
<cfquery name="get_location" datasource="#dsn#">
	SELECT
		COMMENT
	FROM
		STOCKS_LOCATION
	WHERE
		LOCATION_ID = #attributes.location_in# AND
		DEPARTMENT_ID = #attributes.department_in#
</cfquery>
<cf_papers paper_type="STOCK_FIS">
<cfif isdefined("paper_full") and isdefined("paper_number")>
	<cfset system_paper_no = paper_full>
	<cfset system_paper_no_add = paper_number>
<cfelse>
	<cfset system_paper_no = "">
	<cfset system_paper_no_add = "">
</cfif>

<cfform name="add_stock" method="post" action="#request.self#?fuseaction=pos.emptypopup_add_sayim_to_stock_receipt">
<input type="hidden" name="file_id" id="file_id" value="<cfoutput>#attributes.file_id#</cfoutput>">
  <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" height="100%">
    <tr>
      <td class="color-border">
        <table width="100%" align="center" cellpadding="2" cellspacing="1" border="0" height="100%">
         <tr class="color-list" height="35">
		 <td class="headbold"><cf_get_lang dictionary_id ='36081.Stok Fişine Çevir'></td>
		 </tr>
		  <tr class="color-row">
            <td valign="top">
              <table>
                <tr>
                  <td width="75"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</td>
                  <td><cf_workcube_process_cat></td>
                </tr>
                <tr>
                  <td><cf_get_lang dictionary_id='57946.Fiş No'> *</td>
                  <td><input type="text" name="fis_no_" id="fis_no_" value="<cfoutput>#system_paper_no#</cfoutput>" readonly style="width:150px;"></td>
                </tr>
				<tr>
				  <td><cf_get_lang dictionary_id='57742.Tarih '>*</td>
				  <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='36118.Fiş Tarihi Girmelisiniz'> !</cfsavecontent>
					<cfinput type="text" name="fis_date" value="01/01/#session.ep.period_year#" validate="#validate_style#" required="yes" message="#message#" style="width:130px;">
                    <cf_wrk_date_image date_field="fis_date"></td>
				</tr>
                <tr>
                  <td><cf_get_lang dictionary_id='58763.Depo'></td>
                  <td><input type="hidden" name="location_in" id="location_in" value="<cfoutput>#attributes.location_in#</cfoutput>">							
					<input type="hidden" name="department_in" id="department_in" value="<cfoutput>#attributes.department_in#</cfoutput>">
                    <input type="text" name="txt_departman_in" id="txt_departman_in" value="<cfoutput>#get_location.comment#</cfoutput>" readonly style="width:150px;"></td>
                </tr>
                <tr>
				  <td></td>
                  <td height="35"><cf_workcube_buttons is_upd='0' add_function='process_cat_control()'></td>
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
	function process_cat_control()
	{
		deger = add_stock.process_cat.options[add_stock.process_cat.selectedIndex].value;
		if( deger.length == 0 ){
			alert("<cf_get_lang dictionary_id ='58770.İşlem Tipi Seçiniz'>!");
			return false;
		}
		return true;
	}
</script>
