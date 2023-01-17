<cfquery name="get_default" datasource="#dsn3#">
	SELECT DEFAULT_COLOR_PROPERTY_ID FROM EZGI_DESIGN_DEFAULTS
</cfquery>
<cfif not get_default.recordcount or not len(get_default.DEFAULT_COLOR_PROPERTY_ID)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='3022.İlk Olarak Default Renk Özellik ID Giriniz'>!");
		window.close()
	</script>
	<cfabort>
</cfif>
<cfquery name="get_max" datasource="#dsn3#">
	SELECT MAX(CAST(PROPERTY_DETAIL_CODE AS INT)) AS MAX_ID FROM EZGI_COLORS
</cfquery>
<cfif len(get_max.max_id) eq 1>
	<cfset  sira = '00#get_max.max_id+1#'>
<cfelseif len(get_max.max_id) eq 2>
	<cfset  sira = '0#get_max.max_id+1#'>
<cfelse>
	<cfset  sira = '001'>
</cfif>
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cfoutput>#getLang('settings',1133)# #getLang('main',2836)#</cfoutput></td>
        <td class="dphb">
        	<cfoutput>

            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
            <cf_form_box>	
            	<cfform name="add_default_color" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_default_color">
                	 <table>
                     	<tr height="25px"  id="design_name_">
                            <td width="100px" valign="top" style="font-weight:bold"><cf_get_lang_main no='81.Aktif'></td>
                            <td width="70px" valign="top">
                                <cfinput type="checkbox" id="status" name="status" value="1" checked="yes">
                            </td>
                            <td width="100px" style="font-weight:bold"><cfoutput>#getLang('report',205)# #getLang('main',245)#</cfoutput> *</td>
                            <td width="280px">
                                <input type="text" name="urun" id="urun_hzm" style="width:240px;" readonly="readonly">
                                <input type="hidden" name="pid" id="pid_hzm">
                                <input type="hidden" name="stock_id" id="stock_id"> 
                                <a style="cursor:pointer" href"javascript://" onClick="pencere_ac();">
                                	<img src="/images/plus_thin.gif" align="absmiddle" border="0">
                                </a>
                            </td>
                      	</tr>
                     	<tr height="25px"  id="design_name_">
                            <td valign="top" style="font-weight:bold"><cfoutput>#getLang('prod',241)# #getLang('objects',256)#</cfoutput> *</td>
                            <td valign="top">
                                <cfinput type="text" name="default_code" id="default_code" value="#sira#" maxlength="20" style="width:50px;" >
                            </td>
                            <td valign="top" style="font-weight:bold"><cfoutput>#getLang('prod',241)# #getLang('main',485)#</cfoutput> *</td>
                            <td valign="top">
                                <cfinput type="text" name="default_name" id="default_name" value="" maxlength="50" style="width:240px;" >
                            </td>
                      	</tr>
                    </table>
                    <cf_form_box_footer>
                        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                    </cf_form_box_footer>
          		</cfform>
          	</cf_form_box>
      	</td>
  	</tr>
</table>
<script type="text/javascript">
	document.getElementById('default_name').focus();
	function kontrol()
	{
		if(document.getElementById("default_name").value == "")
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2914.Renk Adı'> !");
			document.getElementById('default_name').focus();
			return false;
		}
		if(document.getElementById("stock_id").value <=0)
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2915.Master Ürün'> !");
			document.getElementById('stock_id').focus();
			return false;
		}

		if(document.getElementById("default_code").value == "")
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2916.Renk Kodu'> !");
			document.getElementById('default_code').focus();
			return false;
		}
	}
	function pencere_ac()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=1&master=1&product_id=add_default_color.pid&field_id=add_default_color.stock_id&field_name=add_default_color.urun",'list');
	}
</script>