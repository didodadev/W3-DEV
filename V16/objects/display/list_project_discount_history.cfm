<cfquery name="get_pro" datasource="#dsn3#">
	SELECT  
		PDH.PRO_DISCOUNT_ID,
		PDH.IS_CHECK_RISK,
		PDH.IS_CHECK_PRJ_LIMIT,
		PDH.IS_CHECK_PRJ_PRODUCT,
		PDH.IS_CHECK_PRJ_MEMBER,
		PDH.IS_CHECK_PRJ_PRICE_CAT,
		PDH.COMPANY_ID,
		PDH.CONSUMER_ID,
		PDH.PRICE_CATID, 
		PDH.RECORD_DATE, 
		PDH.RECORD_EMP,
		PDH.START_DATE,
		PDH.FINISH_DATE,
		PDH.DISCOUNT_1, 
		PDH.DISCOUNT_2,
		PDH.DISCOUNT_3, 
		PDH.DISCOUNT_4, 
		PDH.DISCOUNT_5,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		PC.PRICE_CAT,
		PDH.PAYMETHOD_ID,
		CASE WHEN PDH.PAYMETHOD_ID IS NOT NULL THEN SP.PAYMETHOD ELSE CASE WHEN PDH.CARD_PAYMETHOD_ID IS NOT NULL THEN CPT.CARD_NO END END AS PAYMETHOD_NAME
	FROM
		PROJECT_DISCOUNTS_HISTORY AS PDH 
		LEFT JOIN #DSN_ALIAS#.PRO_PROJECTS AS PP ON PDH.PROJECT_ID = PP.PROJECT_ID
		LEFT JOIN #DSN_ALIAS#.EMPLOYEES E ON E.EMPLOYEE_ID = PDH.RECORD_EMP
		LEFT JOIN PRICE_CAT PC ON PC.PRICE_CATID = PDH.PRICE_CATID
		LEFT JOIN #DSN_ALIAS#.SETUP_PAYMETHOD AS SP ON SP.PAYMETHOD_ID = PDH.PAYMETHOD_ID
		LEFT JOIN CREDITCARD_PAYMENT_TYPE AS CPT ON CPT.PAYMENT_TYPE_ID = PDH.CARD_PAYMETHOD_ID
	WHERE
		<cfif isDefined("attributes.discount_history_id")>
			PRO_DISCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_history_id#"> AND
		</cfif>
		PDH.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	ORDER BY
		PDH.RECORD_DATE DESC     
</cfquery>
<cfsavecontent variable="icerik">
	<cfif not isDefined("attributes.discount_history_id")>
		<cfif get_pro.recordcount>
			<cfif not isDefined("attributes.discount_history_id")>
				<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>" />
			</cfif>
			<cfoutput query="get_pro">
				<cfsavecontent variable="txt">
					#DateFormat(record_date,dateformat_style)# <cfif len(record_date)>(#TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</cfif> - #employee_name# #employee_surname#
				</cfsavecontent>
				<table class="seperator" id="seperator">
					<tr>
						<td class="seperator_left" nowrap="nowrap">
							<a href="javascript://" onclick="gizle_goster_image('list_spert_action#pro_discount_id#_1','list_spert_action#pro_discount_id#_2','list_spert_action#pro_discount_id#_','');connectAjax('list_spert_action#pro_discount_id#_','#pro_discount_id#');" class="txtboldblue">
								<img src="/images/open_close_1.gif" border="0" id="list_spert_action#pro_discount_id#_2" style="display:'';" />
								<img src="/images/open_close_2.gif" id="list_spert_action#pro_discount_id#_1" border="0" style="display:none;"/>
								#txt#
							</a>
						</td>
						<td class="seperator_right"></td>
					</tr>
				</table>
				<div align="left" id="list_spert_action#pro_discount_id#_" style="display:none;"></div>
			</cfoutput>
		</cfif>
	<cfelse>
		<cfquery name="get_pro_row" datasource="#dsn3#">
			SELECT 
				P.PRODUCT_ID,
				P.PRODUCT_NAME,
				PB.BRAND_ID,
				PB.BRAND_NAME,
				PC.PRODUCT_CATID,
				PC.PRODUCT_CAT
			FROM 
				PROJECT_DISCOUNT_CONDITIONS_HISTORY PDCH
				LEFT JOIN PRODUCT P ON P.PRODUCT_ID = PDCH.PRODUCT_ID
				LEFT JOIN PRODUCT_BRANDS PB ON PB.BRAND_ID = PDCH.BRAND_ID
				LEFT JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = PDCH.PRODUCT_CATID
			WHERE
				PDCH.PRO_DISCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pro.PRO_DISCOUNT_ID#">
			ORDER BY
				PDCH.DISC_CONDITION_ID
		</cfquery>
		<cfoutput query="get_pro">
			<table width="100%">
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='57519.Cari Hesap'> :</td>
					<td><cfif len(company_id)>#get_par_info(company_id,1,0,1)#<cfelseif len(consumer_id)>#get_par_info(consumer_id,1,0,1)#</cfif></td>
					<td class="txtbold"><cf_get_lang dictionary_id='57655.Baslangic Tarihi'> :</td>
					<td><cfif len(start_date)>#dateformat(start_date,dateformat_style)#</cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='58964.Fiyat Listesi'> :</td>
					<td><cfif price_catid eq -1>
							<cf_get_lang dictionary_id='58722.Standart Alış'>
						<cfelseif price_catid eq -2>
							<cf_get_lang dictionary_id='58721.Standart Satış'>
						<cfelse>
							#price_cat#
						</cfif>
					</td>
					<td class="txtbold"><cf_get_lang dictionary_id='57655.Baslangic Tarihi'> :</td>
								<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'> :</td>
					<td>#paymethod_name#</td>
					<td class="txtbold"><cf_get_lang dictionary_id='57641.İndirim'>1 %</td>
					<td><cfif len(discount_1)>#TLFormat(discount_1)#</cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='38466.Risk Kontrolü'> :</td>
					<td><cfif IS_CHECK_RISK eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
					<td class="txtbold"><cf_get_lang dictionary_id='57641.İndirim'>2 %</td>
					<td><cfif len(discount_2)>#TLFormat(discount_2)#</cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='38467.Bağlantı Bakiye Kontrolü'> :</td>
					<td><cfif IS_CHECK_PRJ_LIMIT eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
					<td class="txtbold"><cf_get_lang dictionary_id='57641.İndirim'>3 %</td>
					<td><cfif len(discount_3)>#TLFormat(discount_3)#</cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='38468.Ürün Kontrolü'> :</td>
					<td><cfif IS_CHECK_PRJ_PRODUCT eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
					<td class="txtbold"><cf_get_lang dictionary_id='57641.İndirim'>4 %</td>
					<td><cfif len(discount_4)>#TLFormat(discount_4)#</cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='38469.Bağlantı Üye Kontrolü'> :</td>
					<td><cfif IS_CHECK_PRJ_MEMBER eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
					<td class="txtbold"><cf_get_lang dictionary_id='57641.İndirim'>5 %</td>
					<td><cfif len(discount_5)>#TLFormat(discount_5)#</cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='38470.Fiyat Listesi Kontrolü'> :</td>
					<td><cfif IS_CHECK_PRJ_PRICE_CAT eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
					<td colspan="2"></td>
				</tr>
				<tr valign="top">
					<td colspan="4">
						<table width="100%">
							<tr>
								<td valign="top" width="33%">
									<cfquery name="get_row_product" dbtype="query">
										SELECT PRODUCT_NAME FROM get_pro_row WHERE PRODUCT_ID IS NOT NULL
									</cfquery>
									<cf_seperator width="100%" id="product_name_id#PRO_DISCOUNT_ID#" header="Ürün" is_closed="0">
									<table id="product_name_id#PRO_DISCOUNT_ID#">
										<cfif get_row_product.recordcount>
											<cfloop query="get_row_product">
												<tr>
													<td class="txtbold">#get_row_product.product_name#</td>
												</tr>
											</cfloop>
										</cfif>
									</table>
								</td>
								<td valign="top" width="33%">
									<cfquery name="get_row_product_cat" dbtype="query">
										SELECT PRODUCT_CAT FROM get_pro_row WHERE PRODUCT_CATID IS NOT NULL
									</cfquery>
									<cf_seperator width="100%" id="product_cat_id#PRO_DISCOUNT_ID#" header="Kategori" is_closed="0">
									<table id="product_cat_id#PRO_DISCOUNT_ID#" style="display:none;">
										<cfif get_row_product_cat.recordcount>
											<cfloop query="get_row_product_cat">
												<tr>
													<td class="txtbold">#get_row_product_cat.product_cat#</td>
												</tr>
											</cfloop>
										</cfif>
									</table>
								</td>
								<td valign="top" width="33%">
									<cfquery name="get_row_brand_name" dbtype="query">
										SELECT BRAND_NAME FROM get_pro_row WHERE BRAND_ID IS NOT NULL
									</cfquery>
									<cf_seperator width="100%" id="brand_id_spr#PRO_DISCOUNT_ID#" header="Marka" is_closed="0">
									<table id="brand_id_spr#PRO_DISCOUNT_ID#" style="display:none;">
										<cfif get_row_brand_name.recordcount>
											<cfloop query="get_row_brand_name">
												<tr>
													<td class="txtbold">#get_row_brand_name.brand_name#</td>
												</tr>
											</cfloop>
										</cfif>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</cfoutput>
	</cfif>
</cfsavecontent>
<cfif isDefined("attributes.no_box_page")>
	<cfoutput>#icerik#</cfoutput>
<cfelse>	
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57473.Tarihçe'></cfsavecontent>
	<cf_popup_box title="#message#"><cfoutput>#icerik#</cfoutput></cf_popup_box>
</cfif>
<script type="text/javascript">
	function connectAjax(div_id,discount_history_id)
	{
		<cfoutput>
			AjaxPageLoad('#request.self#?fuseaction=objects.popup_view_history_act&act_type=3&boxwidth=590&boxheight=500&id=#attributes.id#&no_box_page=1&discount_history_id='+discount_history_id,div_id,1);
		</cfoutput>
	}
</script>
