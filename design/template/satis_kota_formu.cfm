<cfquery name="get_quotas" datasource="#dsn3#">
	SELECT * FROM SALES_QUOTAS WHERE SALES_QUOTA_ID = #attributes.action_id#
</cfquery>
<cfquery name="get_row" datasource="#dsn3#">
	SELECT * FROM SALES_QUOTAS_ROW WHERE SALES_QUOTA_ID = #attributes.action_id#
</cfquery>
<cfif len(get_quotas.sales_zone_id)>
	<cfquery name="get_zones" datasource="#dsn#">
		SELECT SZ_NAME FROM SALES_ZONES WHERE SZ_ID = #get_quotas.sales_zone_id#
	</cfquery>
</cfif>
<cfif len(get_quotas.ims_code_id)>
	<cfquery name="get_ims_code" datasource="#dsn#">
		SELECT IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #get_quotas.ims_code_id#
	</cfquery>
</cfif>
<br/><br/>
<cfoutput query="get_quotas">
	<table  style="width:250mm;" border="0" cellpadding="1" cellspacing="1" align="center">
		<tr>
			<td height="25" class="headbold"><cf_get_lang_main no='777.Satış Kotaslari'></td>
		</tr>
	</table>
	<table style="width:250mm;" border="0" cellpadding="1" cellspacing="1" align="center">
		<tr>
			<td height="20">&nbsp;</td>
		</tr>
		<tr>
			<td valign="top">
			<table style="width:250mm;" cellpadding="3" cellspacing="0" border="1">	
				<tr height="20">
					<td class="txtbold" style="width:25mm;">Plânlayan</td>
					<td style="width:45mm;"><cfif len(planner_emp_id)>#get_emp_info(planner_emp_id,0,0)#</cfif>&nbsp;</td>
					<td class="txtbold"><cf_get_lang_main no='107.Cari Hesap'></td>
					<td><cfif len(company_id)>#get_par_info(company_id,1,1,0)#</cfif>&nbsp;</td>
					<td class="txtbold"><cf_get_lang_main no='247.Satış Bölgesi'></td>
					<td><cfif len(sales_zone_id)>#get_zones.sz_name#</cfif>&nbsp;</td>
				</tr>
				<tr height="20">
					<td class="txtbold"><cf_get_lang_main no='468.Belge No'></td>
					<td>#paper_no#</td>
					<td class="txtbold"><cf_get_lang_main no='166.Yetkili'></td>
					<td width="20%"><cfif len(partner_id)>#get_par_info(partner_id,0,-1,0)#</cfif>&nbsp;</td>
					<td class="txtbold"><cf_get_lang_main no='722.Mikro Bölge Kodu'></td>
					<td width="20%"><cfif len(ims_code_id)>#get_ims_code.ims_code# #get_ims_code.ims_code_name#</cfif>&nbsp;</td>
				</tr>
				<tr height="20">
					<td class="txtbold">Hazırlanma Tarihi</td>
					<td><cfif len(plan_date)>#dateformat(plan_date,dateformat_style)#</cfif>&nbsp;</td>
					<td class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
					<td colspan="4"><cfif len(detail)>#detail#</cfif>&nbsp;</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
</cfoutput>

<!--- Satış Kotası Satırları--->
<cfset miktar_toplam=0>
<cfset tutar_toplam=0>
<cfset prim_toplam=0>
<cfset mal_toplam=0>
<cfset kar_toplam=0>
<cfif get_row.recordcount>
	<table style="width:250mm;" border="0"  cellpadding="1" cellspacing="1"  align="center">
		<tr>
			<td height="20">&nbsp;</td>
		</tr>
		<tr>
			<td valign="top">
                <table style="width:250mm;" cellpadding="3" cellspacing="0" border="1">									
                    <tr class="txtbold">
                        <td style="width:100mm;"><cf_get_lang_main no='1736.Tedarikçi'></td>
                        <td style="width:50mm;"><cf_get_lang_main no='1435.Marka'></td>
                        <td style="width:70mm;"><cf_get_lang_main no='74.Kategori'></td>
                        <td style="width:130mm;"><cf_get_lang_main no='245.Ürün'></td>
                        <td style="text-align:right;"><cf_get_lang_main no='223.Miktar'></td>
                        <td style="text-align:right;width:35mm;"><cf_get_lang_main no='261.Tutar'></td>
                        <td style="text-align:right;width:22mm;">Prim%</td>
                        <td style="text-align:right;width:40mm;">Prim <cf_get_lang_main no="261.Tutar"></td>
                        <td style="text-align:right;width:60mm;">Mal Fazlası</td>
                        <td style="text-align:right;width:20mm;">Kar %</td>
                        <td style="text-align:right;width:40mm;">Kar <cf_get_lang_main no="261.Tutar"></td>
                        <td style="width:20mm;"><cf_get_lang_main no='217.Açıklama'>/<cf_get_lang_main no='55.Not'></td>
                    </tr>
                    <cfif get_row.recordcount>
                        <cfset company_list=''>
                        <cfset brand_list=''>
                        <cfset cat_list=''>
                        <cfset product_list=''>
                        <cfoutput query="get_row">
                            <cfif len(supplier_id) and not listfind(company_list,supplier_id)>
                                <cfset company_list=listappend(company_list,supplier_id)>
                            </cfif>
                            <cfif len(brand_id) and not listfind(brand_list,brand_id)>
                                <cfset brand_list=listappend(brand_list,brand_id)>
                            </cfif>
                            <cfif len(category_id) and not listfind(cat_list,category_id)>
                                <cfset cat_list=listappend(cat_list,category_id)>
                            </cfif>
                            <cfif len(product_id) and not listfind(product_list,product_id)>
                                <cfset product_list=listappend(product_list,product_id)>
                            </cfif>
                        </cfoutput>
                        <cfif len(company_list)>
                            <cfset company_list = listsort(company_list,"numeric","ASC",",")>
                            <cfquery name="GET_COM" datasource="#DSN#">
                                SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN(#company_list#) ORDER BY COMPANY_ID
                            </cfquery>
                        </cfif>
                        <cfif len(brand_list)>
                            <cfset brand_list = listsort(brand_list,"numeric","ASC",",")>
                            <cfquery name="GET_BRAND" datasource="#DSN1#">
                                SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN(#brand_list#) ORDER BY BRAND_ID
                            </cfquery>
                        </cfif>
                        <cfif len(cat_list)>
                            <cfset cat_list = listsort(cat_list,"numeric","ASC",",")>
                            <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
                                SELECT PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID IN(#cat_list#) ORDER BY PRODUCT_CATID
                            </cfquery>
                        </cfif>
                        <cfif len(product_list)>
                            <cfset product_list = listsort(product_list,"numeric","ASC",",")>
                            <cfquery name="GET_PRODUCT" datasource="#DSN1#">
                                SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN(#product_list#) ORDER BY PRODUCT_ID
                            </cfquery>
                        </cfif>
                    </cfif>
                    <cfoutput query="get_row">
                        <tr>
                            <td><cfif len(supplier_id)>#get_com.FULLNAME[listfind(company_list,supplier_id,',')]#</cfif>&nbsp;</td>
                            <td><cfif len(brand_id)>#get_brand.BRAND_NAME[listfind(brand_list,brand_id,',')]#</cfif>&nbsp;</td>
                            <td><cfif len(category_id)>#get_product_cat.PRODUCT_CAT[listfind(cat_list,category_id,',')]#</cfif>&nbsp;</td>
                            <td><cfif len(product_id)>#get_product.PRODUCT_NAME[listfind(product_list,product_id,',')]#</cfif>&nbsp;</td>
                            <td style="text-align:right;">#quantity#</td>
                            <td style="text-align:right;">#TLFormat(ROW_TOTAL)#&nbsp;#session.ep.money#</td>
                            <td style="text-align:right;">#TLFormat(ROW_PREMIUM_PERCENT)#&nbsp;</td>
                            <td style="text-align:right;">#TLFormat(ROW_PREMIUM_TOTAL)#&nbsp;#session.ep.money#</td>
                            <td style="text-align:right;">#ROW_EXTRA_STOCK#</td>
                            <td style="text-align:right;">#TLFormat(ROW_PROFIT_PERCENT)#&nbsp;</td>
                            <td style="text-align:right;">#TLFormat(ROW_PROFIT_TOTAL)#&nbsp;#session.ep.money#</td>
                            <td>#row_detail#&nbsp;</td>
                            <cfset miktar_toplam=miktar_toplam+quantity>
                            <cfset tutar_toplam=tutar_toplam+row_total>
                            <cfset prim_toplam=prim_toplam+row_premium_total>
                            <cfset mal_toplam=mal_toplam+row_extra_stock>
                            <cfset kar_toplam=kar_toplam+row_profit_total>
                        </tr>	
                    </cfoutput>
                    <tr class="txtbold" height="25">
                        <td colspan="4" style="text-align:right;"><cf_get_lang_main no="80.Toplam"></td>
                        <cfoutput>
                            <td style="text-align:right;" width="150">#miktar_toplam#</td>
                            <td style="text-align:right;" width="150">#TLFormat(tutar_toplam)#&nbsp;#session.ep.money#</td>
                            <td>&nbsp;</td>
                            <td style="text-align:right;" width="150">#TLFormat(prim_toplam)#&nbsp;#session.ep.money#</td>
                            <td style="text-align:right;" width="150">#mal_toplam#</td>
                            <td>&nbsp;</td>
                            <td style="text-align:right;" width="150">#TLFormat(kar_toplam)#&nbsp;#session.ep.money#</td>
                        </cfoutput>  
                    </tr>
                </table>
            </td>
		</tr>
	</table>
</cfif>
