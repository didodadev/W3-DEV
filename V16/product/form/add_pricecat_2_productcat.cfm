<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_branch.cfm">
<cfset order_by="HIERARCHY">
<cfinclude template="../query/get_product_cats.cfm">
<!--- Aktif kategorilerin gelmesi için --->
<cfset attributes.is_active_consumer_cat = 1 >
<cfinclude template="../query/get_consumer_cat.cfm">

<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" align="center">
 	<tr valign="top">
		<cfinclude template="../../objects/display/tree_back.cfm">
		<td <cfoutput>#td_back#</cfoutput>><cfinclude template="../display/product_definition_left_menu.cfm"></td>
	    <td>
    	<cfform name="form_add_pricecat" method="post" action="#request.self#?fuseaction=product.emptypopup_add_pricecat_2_productcat">
        <input type="hidden" name="visible" id="visible" value="1">
        <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
   			<tr>
            	<td class="headbold"><cf_get_lang dictionary_id='37029.Fiyat Listesi Ekle'></td>
          	</tr>
        </table>
		<table border="0" width="98%" align="center" cellpadding="2" cellspacing="1" class="color-border">
			<tr class="color-row">
				<td valign="top" width="225">
				<table width="100%" border="0" align="right">
					<tr>
						<td class="txtboldblue"><cf_get_lang dictionary_id='37140.Yayın Alanı'></td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></td>
					</tr>
					<tr>
						<td>
							<cfoutput query="get_companycat">
								<input type="checkbox" name="company_cat" id="company_cat" value="#companycat_id#">#companycat#<br/>
							</cfoutput>
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
								<input type="checkbox" name="consumer_cat" id="consumer_cat" value="#conscat_id#">#conscat#<br/>
							</cfoutput>
						</td>
					</tr>
                    <tr>
                    	<td class="txtbold"><input type="checkbox" name="all_consumer_cat" id="all_consumer_cat" value="1" onclick="wrk_select_all('all_consumer_cat','consumer_cat')"><cf_get_lang dictionary_id='37814.Hepsini Seç'></td>
                    </tr>
					<tr>
						<td class="txtbold" height="25"><cf_get_lang dictionary_id='29434.Şubeler'></td>
					</tr>
					<tr>
						<td>
							<cfoutput query="get_branch">
								<input type="Checkbox" value="#branch_id#" name="branch" id="branch">#zone_name# / #branch_name#<br/>
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
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='37405.liste girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="price_cat" value="" required="Yes" message="#message#" style="width:185px;">
						</td>
					</tr>
					<tr>
						<td class="txtboldblue">&nbsp;</td>
						<td class="txtboldblue"><cf_get_lang dictionary_id='37145.Fiyatlandırma Yöntemi'></td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='37045.Marj'></td>
						<td>
							<select name="target_margin" id="target_margin" style="width:180px;">
								<option selected value="son"><cf_get_lang dictionary_id='37147.Son Alış Fiyatına % ekle'></option>
								<option value="ortalama"><cf_get_lang dictionary_id='37148.Ortalama Alış Fiyatına % ekle'></option>
								<option value="standart"><cf_get_lang dictionary_id='37149.Standart Alış Fiyatına % Ekle'></option>
								<option value=""><cf_get_lang dictionary_id='37312.Standart Satış Fiyatından % İndirim'></option>
							</select>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="startdate" value="#dateformat(now(),dateformat_style)#" required="Yes" message="#message#" validate="#validate_style#" style="width:70px;" maxlength="10">
							<cf_wrk_date_image date_field="startdate">
						</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='57710.Yuvarlama'></td>
						<td>
							<select name="ROUNDING" id="ROUNDING">
							<cfloop from="0" to="3" index="round_no">
								<cfoutput><option value="#round_no#">#round_no#</option>
							</cfoutput>
							</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='37365.KDV Dahil'></td>
						<td><input type="checkbox" name="IS_KDV" id="IS_KDV" value=""></td>
					</tr>
				</table>
				<table>
					<tr height="20" class="color-list">
						<td colspan="5" class="txtboldblue"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></td>
					</tr>
					<tr class="txtbold">
						<td width="20"></td>
						<td width="125"><cf_get_lang dictionary_id='37159.Kategori Kodu'></td>
						<td><cf_get_lang dictionary_id='37163.Kategori Adı'></td>
						<td width="50" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37313.Standart Marj'></td>
						<td width="60" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37314.Liste Marjı'></td>
					</tr>
				<cfif get_product_cats.RecordCount>
				<cfset product_sub_cat_ids = '' >
				<cfoutput query="get_product_cats">
					<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>
							<cfif is_sub_product_cat is 0>
								<cfset product_sub_cat_ids = listappend(product_sub_cat_ids,product_catid,',') >
								<input type="checkbox" name="product_cat_ids" id="product_cat_ids" value="#product_catid#">
							</cfif>
						</td>
						<td>#hierarchy#</td>
						<td>#product_cat#</td>
						<td align="right" style="text-align:right;">#profit_margin#</td>
						<td align="right" style="text-align:right;">
							<cfif is_sub_product_cat is 0>
								<cfif len(profit_margin)>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='37406.liste marjı girmelisiniz'>!</cfsavecontent>
									<cfinput type="text" name="list_margin_#product_catid#" value="#profit_margin#" class="moneybox" range="0,100" validate="float" message="#message#" style="width:50px;">
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='37406.Liste Marjı Sayısal Olmalıdır'>!</cfsavecontent>
									<cfinput type="text" name="list_margin_#product_catid#" value="0" class="moneybox" range="0,100" validate="float" message="#message#" style="width:50px;">
								</cfif>
							</cfif>
						</td>
					</tr>
				</cfoutput>
				<cfelse>
					<tr height="20" class="color-row">
						<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
					<tr height="35">
						<td colspan="2" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
					</tr>	
				</table>
				</td>
			</tr>
		</table>
      	</cfform>
    	</td>
 	</tr>
</table>
<script type="text/javascript">
function kontrol()
{
	flag = 0;
	for (i=0; i < <cfoutput>#listlen(product_sub_cat_ids,',')#</cfoutput>;i++)
		if (document.form_add_pricecat.product_cat_ids[i].checked)
			flag = 1;
	if (flag == 0)
	{
		alert('<cf_get_lang dictionary_id="37872.En az bir ürün kategorisi seçmelisiniz"> !');
		return false;
	}
	return true;
}
</script>
