<cfquery name="get_design_package_row" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_PACKAGE WHERE PACKAGE_ROW_ID = #attributes.design_package_row_id#
</cfquery>
<cfquery name="get_design_main_row" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_ROW_ID = #get_design_package_row.DESIGN_MAIN_ROW_ID#
</cfquery>
<cfquery name="get_colors" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS ORDER BY COLOR_NAME
</cfquery>

<cfquery name="get_partner_package" datasource="#dsn3#"> <!---Master Pakete Bağlı mı--->
	SELECT        
    	PACKAGE_ROW_ID
	FROM            
    	EZGI_DESIGN_PACKAGE
	WHERE        
    	PACKAGE_ROW_ID =
                    	(
                        	SELECT        
                            	PACKAGE_PARTNER_ID
                       		FROM            
                            	EZGI_DESIGN_PACKAGE AS EZGI_DESIGN_PACKAGE_1
                        	WHERE        
                            	PACKAGE_ROW_ID = #attributes.design_package_row_id# AND 
                                PACKAGE_IS_MASTER = 0
                      	)
</cfquery>
<cfquery name="get_partner_package_control" datasource="#dsn3#"> <!---Master Paket mi--->
	SELECT       
    	EZGI_DESIGN_PACKAGE.PACKAGE_ROW_ID, 
      	EZGI_DESIGN_PACKAGE.DESIGN_MAIN_ROW_ID, 
     	EZGI_DESIGN_PACKAGE.PACKAGE_AMOUNT, 
        EZGI_DESIGN_PACKAGE.PACKAGE_NUMBER,
      	EZGI_DESIGN_MAIN_ROW.DESIGN_MAIN_NAME, 
     	EZGI_DESIGN_MAIN_ROW.DESIGN_ID
	FROM            
    	EZGI_DESIGN_PACKAGE INNER JOIN
      	EZGI_DESIGN_MAIN_ROW ON EZGI_DESIGN_PACKAGE.DESIGN_MAIN_ROW_ID = EZGI_DESIGN_MAIN_ROW.DESIGN_MAIN_ROW_ID
	WHERE        
    	EZGI_DESIGN_PACKAGE.PACKAGE_PARTNER_ID = #attributes.design_package_row_id#
</cfquery>
<cfif get_partner_package_control.recordcount>
	<cfquery name="get_partner_package_used_control" datasource="#dsn3#"> <!---Master Paket ortak paket olarak kullanılmış mı--->
		SELECT     
        	PACKAGE_ROW_ID
		FROM         
        	EZGI_DESIGN_PACKAGE AS EZGI_DESIGN_PACKAGE
		WHERE     
        	PACKAGE_IS_MASTER = 0 AND 
            PACKAGE_PARTNER_ID = #attributes.design_package_row_id#
	</cfquery>
<cfelse>
	<cfset get_partner_package_used_control.recordcount = 0>
</cfif>
<cfif get_partner_package.recordcount>
	<cfquery name="get_design_package_image" datasource="#dsn3#">
        SELECT TOP (1) * FROM EZGI_DESIGN_PACKAGE_IMAGES WHERE DESIGN_PACKAGE_ROW_ID = #get_partner_package.PACKAGE_ROW_ID# ORDER BY DESIGN_PACKAGE_ROW_ID DESC
    </cfquery>
<cfelse>
	<cfquery name="get_design_package_image" datasource="#dsn3#">
        SELECT TOP (1) * FROM EZGI_DESIGN_PACKAGE_IMAGES WHERE DESIGN_PACKAGE_ROW_ID = #attributes.design_package_row_id# ORDER BY DESIGN_PACKAGE_ROW_ID DESC
    </cfquery>
</cfif>
<br />
<table class="dph">
 	<tr>
    	<td class="dpht"><cfoutput>#getLang('stock',371)# #getLang('main',52)#</cfoutput> - <cfoutput>#get_design_main_row.DESIGN_MAIN_NAME#</cfoutput></td>
     	<td class="dphb"> 
        	<cfif get_partner_package.recordcount> <!---Master Pakete Bağlı ise Master Pakete Git--->
            	<a href="javascript://" onClick="go_related_package();"><img src="/images/file.gif" align="absmiddle" title="<cf_get_lang_main no='2860.İlişkili Master Paket'>"></a>
            <cfelse>
        		<a href="javascript://" onClick="add_material();"><img src="/images/online_basket.gif" align="absmiddle" title="<cf_get_lang_main no='2861.Toplu Malzeme Ekle'>"></a>
            </cfif>
            <a href="javascript://" onClick="add_package_images();"><img src="/images/photo.gif" align="absmiddle" title="<cf_get_lang_main no='102.Resim Ekle'>"></a>
     	</td>
    </tr>
</table>
<cf_form_box title="">
	<cfform name="upd_design_package_row" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_product_tree_creative_package_row">
    	<cfinput type="hidden" name="design_package_row_id" value="#attributes.design_package_row_id#">
    	<br />
		<table width="98%" cellpadding="2" cellspacing="2">
        	<cfif get_partner_package.recordcount><!---Master Pakete Bağlı mı--->
                <cfinput type="hidden" name="design_package_partner_id" value="#get_partner_package.PACKAGE_ROW_ID#">
            <cfelse> <!---Bağlı Ortak Paket Değilse Master Paket Olmalı mı--->
            	<tr>
                    <td><cfoutput>#getLang('report',205)# #getLang('main',2862)# </cfoutput> </td>
                    <td>
                		<input type="checkbox" name="package_is_master" id="package_is_master" value="1" <cfif get_design_package_row.PACKAGE_IS_MASTER eq 1>checked</cfif> />
                 	</td>
              	</tr>
         	</cfif>
         	<tr>
                <td><cfoutput>#getLang('stock',371)# #getLang('main',75)# </cfoutput> </td>
                <td>
                	<cfinput type="text" name="paket_number" id="paket_number" value="#get_design_package_row.PACKAGE_NUMBER#"  validate="integer" maxlength="2" style="width:70px; text-align:right">&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfif get_partner_package.recordcount gt 0>
                    	<span style=" font-weight:bold; color:orange">
                     		&nbsp;<cfoutput>#getLang('main',2862)#</cfoutput>
                       	</span>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td width="120"><cfoutput>#getLang('stock',371)# #getLang('main',485)# </cfoutput> *</td>
                <td width="280">
                	<cfinput type="text" name="design_name_package_row" id="design_name_package_row" value="#get_design_package_row.PACKAGE_NAME#" maxlength="80" style="width:230px;" >
                    <cf_language_info 
                    	table_name="EZGI_DESIGN_PACKAGE" 
                      	column_name="PACKAGE_NAME" 
                      	column_id_value="#attributes.design_package_row_id#" 
                     	maxlength="500" 
                     	datasource="#dsn3#" 
                      	column_id="PACKAGE_ROW_ID" 
                      	control_type="0">
                </td>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang_main no ='1968.Renk Düzenle'> *</td>
                <td valign="top">
                	<select name="color_type" id="color_type" style="width:130px; height:20px">
                    	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_colors">
                        	<option value="#COLOR_ID#" <cfif get_design_package_row.PACKAGE_COLOR_ID eq COLOR_ID>selected</cfif> <cfif  get_design_main_row.DESIGN_MAIN_COLOR_ID eq COLOR_ID>style="font-weight:bold" </cfif>>#COLOR_NAME#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('settings',861)#</cfoutput> (cm.) </td>
                <td valign="top">
                	<cfinput type="text" name="paket_boy" id="paket_boy" value="#Tlformat(get_design_package_row.PACKAGE_BOYU,1)#" maxlength="8" style="width:70px; text-align:right">
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('report',749)#</cfoutput> (cm.) </td>
                <td valign="top">
                	<cfinput type="text" name="paket_en" id="paket_en" value="#Tlformat(get_design_package_row.PACKAGE_ENI,1)#" maxlength="8" style="width:70px; text-align:right">
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('report',790)#</cfoutput> (cm.) </td>
                <td valign="top">
                	<cfinput type="text" name="paket_kalinlik" id="paket_kalinlik" value="#Tlformat(get_design_package_row.PACKAGE_KALINLIK,1)#" maxlength="7" style="width:70px; text-align:right">
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('main',1987)#</cfoutput> (kg.) </td>
                <td valign="top" nowrap="nowrap">
                	<cfinput type="text" name="paket_weight" id="paket_weight" value="#Tlformat(get_design_package_row.PACKAGE_WEIGHT,1)#" maxlength="7" style="width:70px; text-align:right">
                </td>
            </tr>
            <tr>
                <td valign="top"><cfoutput>#getLang('stock',371)# #getLang('main',670)#</cfoutput> </td>
                <td valign="top">
                	<cfinput type="text" name="paket_amount" id="paket_amount" value="#get_design_package_row.PACKAGE_AMOUNT#" validate="integer" maxlength="2" style="width:70px; text-align:right">
                </td>
            </tr>
           

        </table>
	<br>
        <table>
        	<tr>
            	<td style="text-align:right; vertical-align:middle; height:25px">
                	<cfinput type="button" value="#getLang('main',50)#" name="cnc_buton" onClick="window.close();">&nbsp;
		    		<cfinput type="button" value="#getLang('main',52)#" name="upd_buton" onClick="kontrol();">&nbsp;
                    <cfif get_partner_package_used_control.recordcount gt 0>
                    
                    <cfelse>
                    	<cfinput type="button" value="#getLang('main',51)#" name="del_buton" onClick="sil();">
                    </cfif>
            	</td>
          	</tr>
      	</table>
	</cfform>
</cf_form_box>
<cfif get_partner_package_control.recordcount>
    <cf_seperator title="İlişkili Ortak Paketler" id="relared_package_" is_closed="1">
    <div id="relared_package_" style="display:none; width:540px">
        <cf_form_list id="relared_package_">
            <thead>
                <tr style="height:30px">
                    <th style="text-align:right;width:25px">S.No</th>
                    <th style="text-align:left;width:425px">Bağlı Olduğu Modül</th>
                    <th style="text-align:right;width:50px">Paket No</th>
                    <th style="text-align:center;width:40px">Miktar</th>
                </tr>
            </thead>
            <tbody>
				<cfif get_partner_package_control.recordcount>
                    <cfoutput query="get_partner_package_control">
                        <tr>
                            <td style="text-align:right">#currentrow#&nbsp;</td>
                            <td nowrap>&nbsp;
                            	<a href="javascript://" onClick="go_related_package_sub(#PACKAGE_ROW_ID#);" class="tableyazi">
                            		#DESIGN_MAIN_NAME#
                                </a>
                         	</td>
                            <td style="text-align:center;">#PACKAGE_NUMBER#</td>
                            <td style="text-align:center;">#PACKAGE_AMOUNT#</td>
                        </tr>
                    </cfoutput>
                </cfif>
           </tbody>
        </cf_form_list>
    </div>
    	
</cfif>
<cf_area width="500px">
    <table>
        <tr>
            <cfoutput>
                <td style="width:500px; height:500px; vertical-align:middle; text-align:center">
                    <cfif len(get_design_package_image.PATH)>
                        <img src="/documents/product/#get_design_package_image.PATH#" style="height:500px; width:500px; vertical-align:middle">
                    </cfif>
                </td>
            </cfoutput>
        </tr>
    </table>
</cf_area>
<script type="text/javascript">
	function add_material()
	{
		window.location ="<cfoutput>#request.self#?fuseaction=prod.popup_add_ezgi_design_all_material&design_package_row_id=#attributes.design_package_row_id#</cfoutput>";
	}
	function go_related_package()
	{
		window.location ="<cfoutput>#request.self#?fuseaction=prod.popup_upd_ezgi_product_tree_creative_package_row&design_package_row_id=#get_partner_package.PACKAGE_ROW_ID#</cfoutput>";
	}
	function go_related_package_sub(package_row_id)
	{
		window.location ="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_upd_ezgi_product_tree_creative_package_row&design_package_row_id="+package_row_id;
	}
	function kontrol()
	{
		if(document.upd_design_package_row.design_name_package_row == 0)
		{


			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='2903.Paket'> <cf_get_lang_main no='485.Adı'>!");
			document.getElementById('design_name_package_row').focus();
			return false;
		}
		else if(document.upd_design_package_row.color_type.value == '')
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='3002.Renk'>!");
			document.getElementById('color_type').focus();
			return false;
		}
		else
		document.getElementById("upd_design_package_row").submit();
	}
	function sil()
	{
		sor = confirm("<cf_get_lang_main no='3003.Paketi Silmek İstediğinizden Emin misiniz'>?");
		if(sor==true)
		window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_del_ezgi_product_tree_creative_package_row&design_package_row_id=#attributes.design_package_row_id#</cfoutput>";
		else
		return false;
		
	}
	function add_package_images()
	{
		<cfif get_partner_package.recordcount>
			<cfif get_design_package_image.recordcount>
				windowopen('<cfoutput>#request.self#?fuseaction=prod.form_upd_ezgi_popup_image&id=#get_partner_package.PACKAGE_ROW_ID#&type=package&detail=#get_design_package_row.PACKAGE_NAME#&table=EZGI_DESIGN_PACKAGE_IMAGES</cfoutput>','small');
			<cfelse>
				windowopen('<cfoutput>#request.self#?fuseaction=prod.form_add_ezgi_popup_image&id=#get_partner_package.PACKAGE_ROW_ID#&type=package&detail=#get_design_package_row.PACKAGE_NAME#&table=EZGI_DESIGN_PACKAGE_IMAGES</cfoutput>','small');
			</cfif>
		<cfelse>
			<cfif get_design_package_image.recordcount>
				windowopen('<cfoutput>#request.self#?fuseaction=prod.form_upd_ezgi_popup_image&id=#attributes.design_package_row_id#&type=package&detail=#get_design_package_row.PACKAGE_NAME#&table=EZGI_DESIGN_PACKAGE_IMAGES</cfoutput>','small');
			<cfelse>
				windowopen('<cfoutput>#request.self#?fuseaction=prod.form_add_ezgi_popup_image&id=#attributes.design_package_row_id#&type=package&detail=#get_design_package_row.PACKAGE_NAME#&table=EZGI_DESIGN_PACKAGE_IMAGES</cfoutput>','small');
			</cfif>
		</cfif>
	}
</script>