<cfsavecontent variable="img_">
	<cfoutput>
 	<cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and isdefined('session.ep')><a href="#request.self#?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1&#url_str#"><img src="/images/cuberelation.gif" align="absmiddle" border="0" title="<cf_get_lang no ='1530.Konfigüratör'>"></a></cfif>
    </cfoutput>
</cfsavecontent>
<cfquery name="get_asset" datasource="#dsn3#">
	SELECT  FILE_TYPE_ID, FILE_NAME FROM EZGI_VIRTUAL_OFFER_ROW_IMPORT_FILE WHERE EZGI_ID = #attributes.ezgi_id#
</cfquery>
<cfoutput query="get_asset">
	<cfset 'FILE_NAME_#FILE_TYPE_ID#' = FILE_NAME>
</cfoutput>
<cf_popup_box title="#getLang('objects',1529)# - #get_product.PRODUCT_NAME#" right_images="#img_#">
    <cfform name="addSpecAll" id="addSpecAll" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_virtual_offer_row_spect">
        <cfinput name="ezgi_id" value="#attributes.ezgi_id#" type="hidden">
        <cfinput type="hidden" name="is_price_change" id="is_price_change" value="1">
        <cfinput type="hidden" name="uploaded_file" id="uploaded_file" value="UTF-8">
        <cf_area width="400">
            <cfoutput>
                <table style="height:130px">
                	<tr>
                        <td colspan="2" style="text-align:right; height:10px"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='1118.Aktarım Türü'></td>
                        <td>
                            <select name="import_file_type" id="import_file_type" style="width:200px; height:20px">
								<cfif not isdefined('attributes.ezgi_kilit')>
                                    <option value="1">Satış Fiyatı Aktarım</option>
                                    <option value="2">Çalışma Dosyası Aktarım</option>
                                    <option value="3">İmalat Dosyası Aktarım</option>
                                </cfif>
                                <option value="4">Teknik Detay Dosyası Aktarım</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='56.Belge'>*</td>
                        <td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;height:20px"></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align:right">
                        	<!---<cfif GET_PROCESS_TYPE.recordcount>--->
                         		<input type="button" value="  Aktar  " style="width:60px" onClick="aktar();">
                           	<!---<cfelse>
                            	<font color="red"><cf_get_lang_main no='561.Yetkisiz'></font>
                            </cfif>--->
                        </td>
                    </tr>
                </table>
            </cfoutput>
        </cf_area>
        <cf_area>
        	<br />
             <table cellpadding="2" cellpadding="2" border="0">
               	<tr>
                	<td style="width:350px; text-align:right">Fiyat Aktarım Dosyası</td>
                  	<td style="text-align:left; height:20px; width:300px">
                    	<cfif isdefined('FILE_NAME_1')>
							<cfoutput>
                                <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=temp\#FILE_NAME_1#" class="tableyazi" >
                                	<img src="/images/doc_export.gif" border="0" title="#FILE_NAME_1#" />
                                </a>
                            </cfoutput>
                        </cfif>
                    </td>
           		</tr>
                <tr>
                	<td style="width:350px; text-align:right">Çalışma Dosyası</td>
                  	<td style="text-align:left; height:20px;">
                    	<cfif isdefined('FILE_NAME_2')>
							<cfoutput>
                                <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=temp\#FILE_NAME_2#" class="tableyazi" >
                                	<img src="/images/doc_export.gif" border="0" title="#FILE_NAME_2#" />
                                </a>
                            </cfoutput>

                        </cfif>
                    </td>
           		</tr>
                <tr>
                	<td style="width:350px; text-align:right">İmalat Dosyası</td>
                  	<td style="text-align:left; height:20px; width:300px">
                    	<cfif isdefined('FILE_NAME_3')>
							<cfoutput>
                                <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=temp\#FILE_NAME_3#" class="tableyazi" >
                                	<img src="/images/doc_export.gif" border="0" title="#FILE_NAME_3#" />
                                </a>
                            </cfoutput>
                        </cfif>
                    </td>
           		</tr>
                <tr>
                	<td style="width:350px; text-align:right">Teknik Detay Dosyası</td>
                  	<td style="text-align:left; height:20px; width:300px">
                    	<cfif isdefined('FILE_NAME_4')>
							<cfoutput>
                                <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=temp\#FILE_NAME_4#" class="tableyazi" >
                                	<img src="/images/doc_export.gif" border="0" title="#FILE_NAME_4#" />
                                </a>
                            </cfoutput>
                        </cfif>
                    </td>
           		</tr>
            </table>
        </cf_area>
        <cf_area new_line="1">
            <br />
            <table style="width:100%;">
            	<tr>
                 	<td>
                     	<cf_medium_list>
                                <thead>
                                    <tr>
                                        <th><cf_get_lang_main no='75.No'></th>
                                        <th><cf_get_lang_main no='106.Stok Kodu'></th>
                                        <th><cf_get_lang_main no='809.Ürün Adı'></th>
                                        <th><cf_get_lang_main no='223.Miktar'></th>
                                        <th><cf_get_lang_main no='224.Birim'></th>
                                        <cfif Listfind(session.ep.POWER_USER_LEVEL_ID,56)>
                                            <th><cf_get_lang_main no='672.Fiyat'></th>
                                            <th><cf_get_lang_main no='265.Döviz'></th>
                                            <th><cf_get_lang_main no='261.Tutar'></th>
                                            <th><cf_get_lang_main no='265.Döviz'></th>
                                        </cfif>
                                    </tr>
                                </thead>
                                <tbody>
                                	<cfif get_row.recordcount>
                                    	<cfoutput query="get_row">
                                        	<tr>
                                            	<td style="text-align:right">#currentrow#</td>
                                            	<td style="text-align:center">#PRODUCT_CODE#</td>
                                                <td style="text-align:left">#PRODUCT_NAME#</td>
                                                <td style="text-align:right">#TlFormat(AMOUNT,2)#</td>
                                                <td style="text-align:left">#MAIN_UNIT#</td>
                                                <cfif Listfind(session.ep.POWER_USER_LEVEL_ID,56)>
                                                    <td style="text-align:right">#TlFormat(SALES_PRICE,2)#</td>
                                                    <td style="text-align:left">#SALES_PRICE_money#</td>
                                                    <td style="text-align:right">
                                                        <cfif isdefined('RATE2_#SALES_PRICE_money#')>
                                                            #TlFormat(SALES_PRICE*AMOUNT*Evaluate('RATE2_#SALES_PRICE_money#'),2)#
                                                            
                                                        <cfelse>
                                                            #TlFormat(0,2)#
                                                        </cfif>
                                                    </td>
                                                    <td style="text-align:left">#session.ep.money#</td>
                                                </cfif>
                                                <cfset toplam = toplam+(SALES_PRICE*AMOUNT*Evaluate('RATE2_#SALES_PRICE_money#'))>
                                                <cfset purchase_total = purchase_total+(PURCHASE_PRICE*AMOUNT*Evaluate('RATE2_#PURCHASE_PRICE_money#'))>
                                                <cfset cost_total = cost_total+(COST_PRICE*AMOUNT*Evaluate('RATE2_#COST_PRICE_money#'))>

                                            </tr>
                                        </cfoutput>
                                        <tr>
                                        	<cfoutput>
                                        	<td colspan="<cfif Listfind(session.ep.POWER_USER_LEVEL_ID,56)>7<cfelse>3</cfif>"><b>Toplam</b></td>
                                            <td style="text-align:right"><b>#TlFormat(toplam,2)#</b></td>
                                            <td style="text-align:left">#session.ep.money#</td>
                                            </cfoutput>
                                        </tr>
                                    </cfif>
                         	</tbody>
                           	<tfoot>
                          		<tr>
                                	<td colspan="<cfif Listfind(session.ep.POWER_USER_LEVEL_ID,56)>7<cfelse>3</cfif>" style="text-align:right; color:red; font-weight:bold; vertical-align:middle">
                                    	<cfif not isdefined('attributes.revision')>
                                    	<input type="checkbox" name="is_price_change" id="is_price_change" value="1" checked><cf_get_lang_main no ='133.Teklif'> <cf_get_lang no ='1532.Fiyatı Güncelle'>
                                        </cfif>
                                    </td>
                                 	<td colspan="2">
                                 		<cfif get_product.is_prototip eq 1>
                                     		<cfif get_row.recordcount>
                                        		<cf_workcube_buttons is_upd='1' is_delete='0' add_function="control()">
                                        	</cfif>
                                      	<cfelse>
                                       		<font color="FF0000"><cf_get_lang no="870.Ürün Özelleştirilebilir Olmadığı İçin Spec Kaydedemezsiniz"> !</font>
                                     	</cfif>
                                 	</td>
                             	</tr>
                          	</tfoot>
                      	</cf_medium_list>
                  	</td>
               	</tr>
            </table>
        </cf_area>  
    </cfform>
</cf_popup_box>
<script type="text/javascript">
	function aktar()
	{
		if(document.getElementById('uploaded_file').value == '')
		{
			alert('Lütfen Dosya Seçiniz!');	
			return false;
		}
		else
		{
			var sor = confirm('Dosyayı Aktarıyorsunuz !');
			if(sor==true)
			{
				document.getElementById("addSpecAll").action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_upd_ezgi_virtual_offer_row_spect_aktar";
				document.getElementById("addSpecAll").enctype = "multipart/form-data";
				document.getElementById("addSpecAll").submit();
				
			}
			else
				return false;
		}
	}
	function control()
	{
		document.getElementById("addSpecAll").action = "<cfoutput>#request.self#?fuseaction=prod.emptypopup_upd_ezgi_virtual_offer_row_spect_aktar&upd=1&toplam=#toplam#&money=#session.ep.money#&purchase_total=#purchase_total#&cost_total=#cost_total#</cfoutput>";
		document.getElementById("addSpecAll").submit();
		return true;
	}
</script>