<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_consumer_cat.cfm">
<cfinclude template="../query/get_branch.cfm">
<cfinclude template="../query/get_price_cat.cfm">
<cfset order_by="HIERARCHY">
<cfinclude template="../query/get_product_cats.cfm">
<cfinclude template="../query/get_price_cat_rows.cfm">
<cfset row_list = valuelist(get_price_cat_rows.product_catid)>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT,COMPANYCAT_ID FROM COMPANY_CAT
</cfquery>
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
	<tr valign="top">
		<cfinclude template="../../objects/display/tree_back.cfm">
		<td <cfoutput>#td_back#</cfoutput>><cfinclude template="../display/product_definition_left_menu.cfm"></td>
	    <td>
    	<cfform name="form_add_pricecat" action="#request.self#?fuseaction=product.emptypopup_create_list_2_productcat&pcat_id=#attributes.pcat_id#" method="post">
        <input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>"> 
		<input type="hidden" name="go_val" id="go_val">
        <input type="hidden" name="visible" id="visible" value="1">
        <table width="97%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
        	<tr>
            	<td class="headbold"><cf_get_lang dictionary_id='37192.Fiyat Listesi Düzenle'></td>
          	</tr>
        </table>
 		<table border="0" width="98%" align="center" cellpadding="2" cellspacing="1" class="color-border">
        	<tr class="color-row">
             	<td valign="top" width="225">
                <table width="100%" border="0" align="right">
                	<tr>
                     	<td  class="txtboldblue"><cf_get_lang dictionary_id='37140.Yayın Alanı'></td>
                   	</tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></td>
                    </tr>
                    <tr>
                		<td>
                          	<cfoutput query="get_company_cat">
                            	<input type="Checkbox" name="company_cat" id="company_cat" value="#companycat_id#" <cfif listfind(get_price_cat.company_cat,companycat_id)> checked</cfif>>#companycat#<br/>
							</cfoutput>
						</td>
                  	</tr>
                    <tr>
                    	<td class="txtbold"><input type="checkbox" name="all_company_cat" id="all_company_cat" value="1" onclick="wrk_select_all('all_company_cat','company_cat')"><cf_get_lang dictionary_id='37814.Hepsini Seç'></td>
                    </tr>
                    <tr>
                     	<td class="txtbold"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></td>
                  	</tr>
                    <tr>
                        <td>
							<cfoutput query="get_consumer_cat">
                            	<input type="Checkbox" name="consumer_cat" id="consumer_cat" value="#conscat_id#" <cfif listfind(get_price_cat.consumer_cat,conscat_id)> checked</cfif>>#conscat#<br/>
                          	</cfoutput>
						</td>
                   	</tr>
                    <tr>
                    	<td class="txtbold"><input type="checkbox" name="all_consumer_cat" id="all_consumer_cat" value="1" onclick="wrk_select_all('all_consumer_cat','consumer_cat')"><cf_get_lang dictionary_id='37814.Hepsini Seç'></td>
                    </tr>
                    <tr>
                     	<td class="txtbold"><cf_get_lang dictionary_id='29434.Şubeler'></td>
                   	</tr>
                    <tr>
                     	<td>
							<cfoutput query="get_branch">
                           		<input type="Checkbox" value="#branch_id#" name="branch" id="branch" <cfif listfind(get_price_cat.branch,branch_id)> checked</cfif>>#zone_name# / #branch_name#<br/>
                          	</cfoutput>
						</td>
                	</tr>
                    <tr>
                    	<td class="txtbold"><input type="checkbox" name="all_branch" id="all_branch" value="1" onclick="wrk_select_all('all_branch','branch')"><cf_get_lang dictionary_id='37814.Hepsini Seç'></td>
                    </tr>
                </table>
                </td>
                <td valign="top">
                <table>
                	<tr>
                     	<td width="100"><cf_get_lang dictionary_id='37144.Liste Adı'></td>
                        <td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='37405.Liste girmelisiniz'></cfsavecontent>
							<cfinput required="Yes" message="#message#" type="text" name="price_cat" style="width:185px;" value="#get_price_cat.price_cat#">
						</td>
                  	</tr>
                    <tr>
                    	<td class="formbold">&nbsp;</td>
                        <td class="txtboldblue"><cf_get_lang dictionary_id='37145.Fiyatlandırma Yöntemi'></td>
                  	</tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='37045.Marj'></td>
                        <td>
                         	<select name="target_margin" id="target_margin" style="width:185px;">
	                            <option value="son"<cfif trim(get_price_cat.target_margin) is "son"> selected</cfif>><cf_get_lang dictionary_id='37147.Son Alış Fiyatına % Ekle'></option>
    	                        <option value="ortalama"<cfif trim(get_price_cat.target_margin) is "ortalama"> selected</cfif>><cf_get_lang dictionary_id='37148.Ortalama Alış Fiyatına % Ekle'></option>
        	                    <option value="standart"<cfif trim(get_price_cat.target_margin) is "standart"> selected</cfif>><cf_get_lang dictionary_id='37149.Standart Alış Fiyatına % Ekle'></option>
            	                <option value=""<cfif trim(get_price_cat.target_margin) is ""> selected</cfif>><cf_get_lang dictionary_id='37312.Standart Satış Fiyatından % İndirim'></option>
                	    	</select>
                        </td>
                   	</tr>
                    <tr>
                      	<td><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></td>
                        <td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="startdate" style="width:70px;" value="#dateformat(get_price_cat.startdate,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#">
							<cf_wrk_date_image date_field="startdate">
							<select name="start_clock" id="start_clock" style="width:50px;">
							<option value="0" selected><cf_get_lang dictionary_id='57491.Saat'></option>
							<cfloop from="1" to="23" index="i">
								<cfoutput><option value="#i#" <cfif len(get_price_cat.startdate) and  i eq hour(get_price_cat.startdate)> selected</cfif>>#i#</option></cfoutput>
							</cfloop>
							</select>
							<select name="start_min" id="start_min" style="width:40px;">
							<cfloop from="0" to="55" index="i" step="5">
								<cfoutput><option value="#i#" <cfif len(get_price_cat.startdate) and i eq minute(get_price_cat.startdate) >selected</cfif>>#i#</option></cfoutput>
							</cfloop>
							</select>
						</td>
                   	</tr>
                    <tr>
						<td><cf_get_lang dictionary_id='57710.Yuvarlama'></td>
						<td>
						  	<select name="ROUNDING" id="ROUNDING">
							<cfloop from="0" to="3" index="round_no">
							<cfoutput>
								<option value="#round_no#" <cfif get_price_cat.rounding is round_no> selected</cfif>>#round_no#</option>
							</cfoutput>
							</cfloop>
						 	</select>
						</td>
                	</tr>
                    <tr>
						<td><cf_get_lang dictionary_id='37365.KDV Dahil'></td>
						<td><input type="checkbox" name="IS_KDV" id="IS_KDV" value="" <cfif len(get_price_cat.IS_KDV) and get_price_cat.IS_KDV>checked</cfif>></td>
                    </tr>
                    <tr height="35">
                        <td colspan="2" align="right" style="text-align:right;">
                        <table width="100%">
                        	<tr class="color-list">
                            	<td colspan="5" class="txtboldblue" height="20" ><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></td>
                            </tr>
                            <tr class="txtbold">
                              	<td width="20"></td>
                              	<td width="125"><cf_get_lang dictionary_id='37159.Kategori Kodu'></td>
                             	<td><cf_get_lang no='152.Kategori Adı'></td>
                              	<td width="50" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37313.Standart Marj'></td>
                              	<td width="60" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37314.Liste Marjı'></td>
                            </tr>
						<cfset kontrol_degeri_js_icin = 0>
                        <cfif get_product_cats.RecordCount>
                          <cfoutput query="get_product_cats">
                            <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                           		<td><cfif is_sub_product_cat is 0><input type="checkbox" name="product_cat_ids" id="product_cat_ids" value="#product_catid#"<cfif listcontainsnocase(row_list,product_catid)> checked</cfif>></cfif></td>
								<td>#hierarchy#</td>
                                <td>#product_cat#</td>
                                <td align="right" style="text-align:right;">#profit_margin#</td>
                                <td>
								  	<cfif is_sub_product_cat is 0>
										<cfset kontrol_degeri_js_icin = kontrol_degeri_js_icin + 1>
										<cfif listcontainsnocase(row_list,product_catid)>
											<cfset margin = get_price_cat_rows.margin[listfindnocase(row_list,product_catid)]>
										<cfelseif len(profit_margin)>
										  	<cfset margin = profit_margin>
										<cfelse>
										  	<cfset margin = 0>
										</cfif>
										<cfsavecontent variable="message"><cf_get_lang no='395.liste marjı girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="list_margin_#product_catid#" class="moneybox" value="#margin#" validate="float" message="#message#" style="width:50px;">
									</cfif>
                               	</td>
                          	</tr>
                     	  </cfoutput>
                      	<cfelse>
                        	<tr height="20" class="color-row">
                            	<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                            </tr>
                       	</cfif>
                     	</table>
                        </td>
                 	</tr>
                    <tr>
                     	<td colspan="2" align="right" style="text-align:right;">
						 	<cfsavecontent variable="message"><cf_get_lang dictionary_id='37012.Liste Oluştur'></cfsavecontent>
						  	<cf_workcube_buttons is_upd='0' is_cancel='0'	insert_info='#message#'	add_function='kontrol()' insert_alert=''>
                          	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=product.del_pricecat&pcat_id=#attributes.pcat_id#' add_function='kontrol()' insert_alert=''>
						</td>
                  	</tr>
                    <tr>
                    	<td colspan="2">
						<cfif len(listsort(get_price_cat.branch,'Numeric'))>
							<cfquery name="GET_BRANCH" datasource="#DSN#">
								SELECT 
									BRANCH_NAME 
								FROM 
									BRANCH 
								WHERE 
									BRANCH_ID IN (#listsort(get_price_cat.branch,'Numeric')#)
							</cfquery>
						<cfelse>
							<cfset get_nranch.recordcount = 0>
						</cfif>
						<cfif len(listsort(get_price_cat.consumer_cat,'Numeric'))>
							<cfquery name="GET_CONSUMER" datasource="#DSN#">
								SELECT 
									CONSCAT 
								FROM 
									CONSUMER_CAT 
								WHERE 
									CONSCAT_ID IN (#listsort(get_price_cat.consumer_cat,'Numeric')#)
							</cfquery>
						<cfelse>
							<cfset get_consumer.recordcount = 0>
						</cfif>
						<cfif len(listsort(get_price_cat.company_cat,'Numeric'))>
							<cfquery name="GET_COMPANY" datasource="#DSN#">
								SELECT 
									COMPANYCAT 
								FROM 
									COMPANY_CAT 
								WHERE 
									COMPANYCAT_ID IN (#listsort(get_price_cat.company_cat,'Numeric')#)
							</cfquery>
						<cfelse>
							<cfset get_company.recordcount = 0>
						</cfif>
						 
                        <br/><br/>
                        <table border="0" class="txtbold">
                        	<tr>
                            	<td class="formbold"><cf_get_lang dictionary_id='37193.Bu Fiyat Kategorisinin Kullanıcıları'>:</td>
                           	</tr>
                            <tr>
                            	<td>
									<cf_get_lang dictionary_id='29434.Şubeler'> :
                               		<cfif get_branch.recordcount>
                                  		<cfoutput query="get_branch">#branch_name#&nbsp;</cfoutput>
                                  	<cfelse>
                                 		-
                                	</cfif>
                              	</td>
                         	</tr>
                            <tr>
                            	<td>
									<cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'> :
									<cfif get_consumer.recordcount>
                                  		<cfoutput query="get_consumer">#conscat#&nbsp;</cfoutput>
                                  	<cfelse>
                                  		-
                                	</cfif>
                              	</td>
                            </tr>
                            <tr>
                            	<td>
									<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'> :
                               		<cfif get_company.recordcount>
                                  		<cfoutput query="get_company">#companycat#&nbsp;</cfoutput>
                                	<cfelse>
                                 		-
                                	</cfif>
                              </td>
                            </tr>
                      	</table>
                        </td>
                  	</tr>
               	</table>
                </td>
           	</tr>
      	</table>
      	</cfform>
    	</td>
	</tr>
</table>
<br/>
<script type="text/javascript">	
function kontrol()
{
	if (confirm("<cf_get_lang dictionary_id ='37871.Değişiklikleri kaydetmek istediğinizden emin misiniz'>?"))
	{	
		if (confirm("<cf_get_lang dictionary_id ='37795.Bütün Fiyatlar Yeniden Oluşacak Eminmisiniz! Onaylarsanız fiyat oluşturularak güncellenecek Reddederseniz fiyat oluşturmadan güncellenecek'> !"))
			document.form_add_pricecat.go_val.value = "1";
		else
			document.form_add_pricecat.go_val.value = "0";
		flag = 0;
		for (i=0; i < <cfoutput>#kontrol_degeri_js_icin#</cfoutput>;i++)
			if (document.form_add_pricecat.product_cat_ids[i].checked)
				flag = 1;
		if (flag == 0)
		{
			alert("<cf_get_lang dictionary_id ='37872.En az bir ürün kategorisi seçmelisiniz '>!");
			return false;
		}
	}
	else
		return false;
}
</script>
