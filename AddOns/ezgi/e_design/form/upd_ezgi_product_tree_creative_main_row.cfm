<cfquery name="get_colors" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS ORDER BY COLOR_NAME
</cfquery>
<cfquery name="get_design_main_row_setup" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_MAIN_ROW_SETUP ORDER BY MAIN_ROW_SETUP_NAME
</cfquery>

<cfquery name="get_design_main_row" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
</cfquery>
<cfquery name="get_design_main_image" datasource="#dsn3#">
	SELECT TOP (1) * FROM EZGI_DESIGN_MAIN_IMAGES WHERE DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id# ORDER BY DESIGN_MAIN_ROW_ID DESC
</cfquery>
<cfquery name="get_design" datasource="#dsn3#">
	SELECT  * FROM EZGI_DESIGN WHERE DESIGN_ID = #get_design_main_row.design_id#
</cfquery>
<cfquery name="get_design_defaults" datasource="#dsn3#">
	SELECT ISNULL(EZGI_DESIGN_IFLOW,0) AS EZGI_DESIGN_IFLOW FROM EZGI_DESIGN_DEFAULTS
</cfquery>
<cfquery name="get_money" datasource="#dsn#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# ORDER BY MONEY_SYMBOL
</cfquery>
<table class="dph">
 	<tr>
    	<td class="dpht"><cfoutput>#getLang('main',2855)#</cfoutput></td>
     	<td class="dphb"> 
        	<a href="javascript://" onClick="add_material();"><img src="/images/basket1.gif" align="absmiddle" title="Kanban"></a>
        	<a href="javascript://" onClick="add_main_images();"><img src="/images/photo.gif" align="absmiddle" title="<cf_get_lang_main no='102.Resim Ekle'>"></a>
     	</td>
    </tr>
</table>
<cf_form_box title="">
	<cfform name="upd_design_main_row" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_product_tree_creative_main_row" enctype="multipart/form-data">
    	<cfinput type="hidden" name="design_main_row_id" value="#attributes.design_main_row_id#">
        <cf_area width="350px">
		<table>
            <tr>
				<td>&nbsp;</td>
				<td><input type="checkbox" name="is_active" id="is_active" value="1" checked><cf_get_lang_main no='81.Aktif'></td>
            </tr>
            <br>
            <cfif len(get_design.IS_PROTOTIP) and get_design.IS_PROTOTIP>
            	<tr>
                    <td width="100"><cfoutput>#getLang('objects',1614)#</cfoutput></td>
                    <td width="230">
                        <select name="spect_type" id="spect_type" style="width:130px; height:20px">
                        	<option value="0" <cfif get_design_main_row.MAIN_PROTOTIP_TYPE eq 0>selected</cfif>><cfoutput>#getLang('product',216)#</cfoutput></option>
                            <option value="1" <cfif get_design_main_row.MAIN_PROTOTIP_TYPE eq 1>selected</cfif>><cfoutput>#getLang('settings',1074)#</cfoutput></option>
                        </select>
                    </td>
                </tr>
            </cfif>
            <tr>
                <td width="100"><cfoutput>#getLang('prod',429)#</cfoutput> <cf_get_lang_main no ='485.Adı'>*</td>
                <td width="230">
                	<cfinput type="text" name="design_name_main_row" id="design_name_main_row" value="#get_design_main_row.DESIGN_MAIN_NAME#" maxlength="100" style="width:180px;" >
                    <cf_language_info 
                    	table_name="EZGI_DESIGN_MAIN_ROW" 
                      	column_name="DESIGN_MAIN_NAME" 
                      	column_id_value="#attributes.design_main_row_id#" 
                     	maxlength="500" 
                     	datasource="#dsn3#" 
                      	column_id="DESIGN_MAIN_ROW_ID" 
                      	control_type="0">
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('prod',429)#</cfoutput> *</td>
                <td valign="top">
                	<select name="setup_type" id="setup_type" style="width:130px; height:20px" onChange="hesapla();">
                    	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_design_main_row_setup">
                        	<option value="#MAIN_ROW_SETUP_ID#" <cfif get_design_main_row.MAIN_ROW_SETUP_ID eq MAIN_ROW_SETUP_ID>selected</cfif>>#MAIN_ROW_SETUP_NAME#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang_main no ='1968.Renk Düzenle'> *</td>
                <td valign="top">
                	<select name="color_type" id="color_type" style="width:130px; height:20px" onChange="hesapla();">
                    	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_colors">
                        	<option value="#COLOR_ID#" <cfif get_design_main_row.DESIGN_MAIN_COLOR_ID eq COLOR_ID>selected</cfif> <cfif  get_design.color_id eq COLOR_ID>style="font-weight:bold" </cfif>>#COLOR_NAME#</option>
                        </cfoutput>
                    </select>

                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('main',274)#</cfoutput> - 1 (cm.) </td>
                <td valign="top">
                	<cfinput type="text" name="olcu1" id="olcu1" value="#get_design_main_row.olcu1#" maxlength="3" validate="integer" style="width:70px;" onChange="hesapla();">
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('main',274)#</cfoutput> - 2 (cm.) </td>
                <td valign="top">
                	<cfinput type="text" name="olcu2" id="olcu2" value="#get_design_main_row.olcu2#" maxlength="3" validate="integer" style="width:70px;" onChange="hesapla();">
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('main',2856)#</cfoutput> <cf_get_lang_main no='223.Miktar'> </td>
                <td valign="top">
                	<cfinput type="text" name="main_row_amount" value="#get_design_main_row.KARMA_KOLI_MIKTAR#" maxlength="3" validate="integer" style="width:70px;">
                </td>
            </tr>
            <cfif get_design_defaults.EZGI_DESIGN_IFLOW eq 1>
            	<tr>
                    <td valign="top"><cfoutput>#getLang('prod',161)#</cfoutput></td>
                    <td valign="top">
                        <cfinput type="text" name="sales_price" value="#TlFormat(get_design_main_row.SALES_PRICE,2)#" maxlength="10" style="width:70px; text-align:right">
                        <select name="money" id="money" style="width:40px; height:20px">
                        	<cfoutput query="get_money">
                        		<option value="#money#" <cfif get_design_main_row.money eq money>selected</cfif>>#money#</option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
            </cfif>
        </table>
        </cf_area>
        <cf_area width="200px">
        	<table>
            	<tr>
                	<cfoutput>
                	<td style="width:140px; height:190px; vertical-align:middle; text-align:center">
                    	<cfif len(get_design_main_image.PATH)>
                    		<img src="/documents/product/#get_design_main_image.PATH#" style="height:160px; width:130px; vertical-align:middle">
                        </cfif>
                  	</td>
                    </cfoutput>
                </tr>
         	</table>
        </cf_area>
		<table>
        	<tr>
            	<td style="text-align:right; vertical-align:middle; height:25px">
                	<cfinput type="button" value="#getLang('main',50)#" name="cnc_buton" onClick="window.close();">&nbsp;
		    		<cfinput type="button" value="#getLang('main',52)#" name="upd_buton" onClick="kontrol();">&nbsp;
                    <cfinput type="button" value="#getLang('main',51)#" name="del_buton" onClick="sil();">
            	</td>
          	</tr>
      	</table>
	</cfform>
</cf_form_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.upd_design_main_row.setup_type.value == 0)
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='2944.Modül'> <cf_get_lang_main no='3019.Tipi'> !");
			document.getElementById('setup_type').focus();
			return false;
		}
		else if(document.upd_design_main_row.color_type.value == '')
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='3002.Renk'>!");
			document.getElementById('color_type').focus();
			return false;
		}
		else
		document.getElementById("upd_design_main_row").submit();
	}
	function sil()
	{
		sor = confirm("<cf_get_lang_main no='3020.Modülü Silmek İstediğinizden Emin Misiniz'>?");
		if(sor==true)
		window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_del_ezgi_product_tree_creative_main_row&design_main_row_id=#attributes.design_main_row_id#</cfoutput>";
		else
		return false;
		
	}
	function hesapla()
	{
		var main_row_name = <cfoutput>'#get_design.design_name#'</cfoutput>;
			
		if(document.getElementById('setup_type').value > 0)
		{
			<cfloop query="get_design_main_row_setup">
				main_row_setup_id = <cfoutput>#get_design_main_row_setup.main_row_setup_id#</cfoutput>;
				main_row_setup_name = <cfoutput>'#get_design_main_row_setup.main_row_setup_name#'</cfoutput>;
				if(document.getElementById('setup_type').value == main_row_setup_id)

				{
					main_row_name = main_row_name +' '+ main_row_setup_name
				}
			</cfloop>
		}
		if(document.getElementById('color_type').value > 0)
		{
			<cfloop query="get_colors">
				color_id = <cfoutput>#get_colors.color_id#</cfoutput>;
				color_name = <cfoutput>'#get_colors.color_name#'</cfoutput>;
				if(document.getElementById('color_type').value == color_id)
				{
					main_row_name = main_row_name +' ('+ color_name +') '
				}
			</cfloop>
		}
		if(document.getElementById('olcu1').value > 0)
		{
			main_row_name = main_row_name + ' - ' + document.getElementById('olcu1').value;
		}
		if(document.getElementById('olcu2').value > 0)
		{
			main_row_name = main_row_name + ' X ' + document.getElementById('olcu2').value;
		}
		document.getElementById('design_name_main_row').value = main_row_name;
	}
	function add_main_images()
	{
		<cfif get_design_main_image.recordcount>
			windowopen('<cfoutput>#request.self#?fuseaction=prod.form_upd_ezgi_popup_image&id=#attributes.design_main_row_id#&type=product&detail=#get_design_main_row.DESIGN_MAIN_NAME#&table=EZGI_DESIGN_MAIN_IMAGES</cfoutput>','small');
		<cfelse>
			windowopen('<cfoutput>#request.self#?fuseaction=prod.form_add_ezgi_popup_image&id=#attributes.design_main_row_id#&type=product&detail=#get_design_main_row.DESIGN_MAIN_NAME#&table=EZGI_DESIGN_MAIN_IMAGES</cfoutput>','small');
		</cfif>
	}
	function add_material()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_ezgi_design_all_material&design_main_row_id=#attributes.design_main_row_id#&detail=#get_design_main_row.DESIGN_MAIN_NAME#</cfoutput>','small');
	}
</script>
<!---delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_ezgi_product_tree_creative_main_row&design_main_row_id=#attributes.design_main_row_id#'--->