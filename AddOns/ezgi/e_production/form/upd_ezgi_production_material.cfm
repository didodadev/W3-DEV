<cfset module_name="prod">
<cfquery name="get_stock_info" datasource="#dsn3#">
	SELECT        
    	S.PROPERTY, 
        S.PRODUCT_UNIT_ID, 
        S.PRODUCT_CODE, 
        S.PRODUCT_NAME, 
        PU.MAIN_UNIT
	FROM            
    	STOCKS AS S INNER JOIN
      	PRODUCT_UNIT AS PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
	WHERE        
    	S.STOCK_ID = #attributes.sid#
</cfquery>
<br />
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='3385.Malzeme Optimizasyon Güncelle'></td>
        <td class="dphb">
        	<cfoutput>

            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<cfform name="upd_material" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_production_material">
	<cfinput type="hidden" name="iid" value="#attributes.iid#">
    <cfinput type="hidden" name="sid" value="#attributes.sid#">
    <cfinput type="hidden" name="pid" value="#attributes.pid#">
    <table class="dpm" align="center">
        <tr>
            <td valign="top" class="dpml">
                <cf_form_box>	
                    <cfoutput>
                	<table>
                     	<tr height="30px">
                            <td style="font-weight:bold"><cf_get_lang_main no='245.Ürün'> <cf_get_lang_main no='106.Stok Kodu'></td>
                            <td>:&nbsp;
                            	<cfinput name="product_code" readonly="yes" type="text" style="width:150px; text-align:left" value="#get_stock_info.PRODUCT_CODE#" class="box">
                            </td>
                      	</tr>
                        <tr height="30px">
                            <td style="font-weight:bold"><cf_get_lang_main no='809.Ürün Adı'></td>
                            <td style="width:280px">:&nbsp;
                            	<cf_wrk_products form_name = 'upd_material' product_name='product_name' stock_id='stock_id' product_id='product_id' max_rows ='250'>
								<input type="hidden" name="product_id" id="product_id" value="">
								<input type="text" name="product_name" id="product_name" style="width:140px;" value="#get_stock_info.PRODUCT_NAME#" passthrough="readonly=yes" onkeyup="get_product();">
								<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=upd_material.product_id&field_name=upd_material.product_name<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                            	<!---<cfinput name="product_name" readonly="yes" type="text" style="width:250px; text-align:left" value="#get_stock_info.PRODUCT_NAME#" class="box">--->
                            </td>
                      	</tr>
                        
                        <tr height="30px">
                            <td style="font-weight:bold"><cf_get_lang_main no='3288.Plan İhtiyacı'></td>
                            <td>:&nbsp;
                            	<cfinput name="plan_demand" readonly="yes" type="text" style="width:70px; text-align:right" value="#TlFormat(total,3)#" class="box">&nbsp;
                                <cfinput name="unit" readonly="yes" type="text" style="width:30px; text-align:left" value="#get_stock_info.MAIN_UNIT#" class="box">
                            </td>
                      	</tr>
                        <tr height="30px">
                            <td style="font-weight:bold"><cf_get_lang_main no='3386.Optimizasyon'></td>
                            <td>:&nbsp;
                            	<cfinput name="optimizasyon" id="optimizasyon"  type="text" style="width:70px; text-align:right" value="#TlFormat(total,3)#">&nbsp;
                                <cfinput name="opti_unit" readonly="yes" type="text" style="width:30px; text-align:left" value="#get_stock_info.MAIN_UNIT#" class="box">
                            </td>
                      	</tr>
                        <tr height="30px">
                            <td style="font-weight:bold"><cf_get_lang_main no='2003.Dosya Adı'></td>
                            <td>:&nbsp;
                            	<cfinput name="opt_file_name" type="text" style="width:250px; text-align:left" value="">
                            </td>
                      	</tr>
                        <tr height="30px">
                            <td style="font-weight:bold"></td>
                            <td>&nbsp;</td>
                      	</tr>
                    </table>
                    </cfoutput>
                    <cf_form_box_footer>
                       	<cf_workcube_buttons 
                         	is_upd='1' 
                       		is_delete = '0' 
                        	add_function='kontrol()'>
          			</cf_form_box_footer>
            	</cf_form_box>
         	</td>
      	</tr>
    </table>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById("optimizasyon").value <= 0)
		{
			alert("<cf_get_lang_main no='3387.Optimizasyon değeri 0 dan büyük olmalıdır.'> !");
			document.getElementById('optimizasyon').focus();
			return false;
		}
	}
</script>