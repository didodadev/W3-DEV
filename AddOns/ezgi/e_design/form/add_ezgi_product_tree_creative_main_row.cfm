<cfquery name="get_colors" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS ORDER BY COLOR_NAME
</cfquery>
<cfquery name="get_design_main_row_setup" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_MAIN_ROW_SETUP ORDER BY MAIN_ROW_SETUP_NAME
</cfquery>
<cfquery name="get_design" datasource="#dsn3#">
	SELECT  * FROM EZGI_DESIGN WHERE DESIGN_ID = #attributes.design_id#
</cfquery>
<cfquery name="get_design_main_row" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_ID = #attributes.design_id#
</cfquery>
<cfquery name="get_design_defaults" datasource="#dsn3#">
	SELECT ISNULL(EZGI_DESIGN_IFLOW,0) AS EZGI_DESIGN_IFLOW FROM EZGI_DESIGN_DEFAULTS
</cfquery>
<cfquery name="get_money" datasource="#dsn#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# ORDER BY MONEY_SYMBOL
</cfquery>

<br />
<cf_form_box title="#getLang('main',2857)#">
	<cfform name="add_design_main_row" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_product_tree_creative_main_row">
    	<cfinput type="hidden" name="design_id" value="#attributes.design_id#">
    	<br />
		<table>
        	<cfif Len(get_design.IS_PROTOTIP) and get_design.IS_PROTOTIP eq 1>
            	<tr>
                    <td width="120"><cfoutput>#getLang('objects',1614)#</cfoutput></td>
                    <td width="250">
                        <select name="spect_type" id="spect_type" style="width:130px; height:20px">
                        	<option value="0"><cfoutput>#getLang('product',216)#</cfoutput></option>
                            <option value="1"><cfoutput>#getLang('settings',1074)#</cfoutput></option>
                        </select>
                    </td>
                </tr>
            </cfif>
            <tr>
                <td width="120"><cfoutput>#getLang('prod',429)#</cfoutput> <cf_get_lang_main no ='485.Adı'>*</td>
                <td width="250">
                	<cfinput type="text" name="design_name_main_row" id="design_name_main_row" value="#get_design.DESIGN_NAME#" maxlength="100" style="width:230px;" >
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('prod',429)#</cfoutput> *</td>
                <td valign="top">
                	<select name="setup_type" id="setup_type" style="width:130px; height:20px" onChange="hesapla();">
                    	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_design_main_row_setup">
                        	<option value="#MAIN_ROW_SETUP_ID#" >#MAIN_ROW_SETUP_NAME#</option>
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
                        	<option value="#COLOR_ID#" <cfif  get_design.color_id eq COLOR_ID>style="font-weight:bold" selected </cfif>>#COLOR_NAME#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('main',274)#</cfoutput> - 1 (cm.) </td>
                <td valign="top">
                	<cfinput type="text" name="olcu1" id="olcu1" value="" maxlength="3" validate="integer" style="width:70px;" onChange="hesapla();">
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('main',274)#</cfoutput> - 2 (cm.) </td>
                <td valign="top">
                	<cfinput type="text" name="olcu2" id="olcu2" value="" maxlength="3" validate="integer" style="width:70px;" onChange="hesapla();">
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('main',2856)#</cfoutput> <cf_get_lang_main no='223.Miktar'> </td>
                <td valign="top">
                	<cfinput type="text" name="main_row_amount" value="" maxlength="3" validate="integer" style="width:70px;">
                </td>
            </tr>
            <cfif get_design_defaults.EZGI_DESIGN_IFLOW eq 1>
            	<tr>
                    <td valign="top"><cfoutput>#getLang('prod',161)#</cfoutput> (<cfoutput>#getLang('stock',206)#</cfoutput>)</td>
                    <td valign="top">
                        <cfinput type="text" name="sales_price" value="#TlFormat(0,2)#" maxlength="10" style="width:70px; text-align:right; height:20px">
                        <select name="money" id="money" style="width:40px; height:20px">
                        	<cfoutput query="get_money">
                        		<option value="#money#">#money#</option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
            </cfif>
        </table>
    	<table>
        	<tr>
            	<td style="text-align:right; vertical-align:middle; height:25px">
		    		<cfinput type="submit" value="#getLang('main',49)#" name="buton">
            	</td>
          	</tr>
      	</table>
	</cfform>
</cf_form_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_design_main_row.setup_type.value == 0)
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> !");
			document.getElementById('setup_type').focus();
			return false;
		}
		if(document.add_design_main_row.color_type.value == '')
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> !");
			document.getElementById('color_type').focus();
			return false;
		}
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
</script>