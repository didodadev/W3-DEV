<cfinclude template="../query/get_det_promotion.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='32803.Promosyon No'></cfsavecontent>
	<cfoutput>
		<cf_box title="#message#: #get_det_promotion.prom_no#" popup_box="1" resize="0">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #get_det_promotion.prom_head#</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(get_det_promotion.brand_id)>#get_brand_name.brand_name#</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(get_det_promotion.company_id)>#get_company.nickname#</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfif len(get_det_promotion.stock_id)>#get_main_product.product_name#</cfif></label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(get_det_promotion.stock_id)>
							#get_main_product.product_cat#
							</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(get_det_promotion.camp_id)>#get_camp_name.camp_head#</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58775.Alışveriş Miktarı'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif get_det_promotion.limit_type is 1 or get_det_promotion.limit_type is 3>
								 #get_det_promotion.limit_value#
								<cf_get_lang dictionary_id='58082.Adet'>
							<cfelseif get_det_promotion.LIMIT_TYPE is 2>
								 #TLFormat(get_det_promotion.LIMIT_VALUE)#
								<cf_get_lang dictionary_id='57673.Tutar'>
							</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif get_det_promotion.price_catid is '-2'>
								<cf_get_lang dictionary_id='58721.Standart Satış'>
							<cfelseif get_det_promotion.price_catid is '-1'>
								<cf_get_lang dictionary_id='58722.Standart Alış'>
							<cfelse>
								<cfif len(get_det_promotion.price_catid)>
									<cfquery name="PRICE_CATS" datasource="#dsn3#">
										SELECT
											PRICE_CAT
										FROM
											PRICE_CAT
										WHERE
											PRICE_CATID = #get_det_promotion.price_catid#
										ORDER BY
											PRICE_CAT
									</cfquery>
									#price_cats.PRICE_CAT#
									</cfif>
							</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlangıç Tar'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #dateformat(get_det_promotion.startdate,dateformat_style)#</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tar'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #dateformat(get_det_promotion.finishdate,dateformat_style)#</label>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33250.Satış Limiti'>
						/
						<cf_get_lang dictionary_id='57951.Hedef'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #get_det_promotion.total_amount#</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33252.Anında İndirim'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(get_det_promotion.discount)> %#get_det_promotion.discount#</cfif>
						</label>
					</div>
						<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32453.Bedava Ürün'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(get_det_promotion.free_stock_id)>#get_free_product.product_name#</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32454.Armağan'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #get_det_promotion.gift_head#</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32491.Şans Kuponu'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(get_det_promotion.coupon_id)>#get_coupon.coupon_name#</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58984.Puan'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #get_det_promotion.prom_point#</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32495.Dönem Primi'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(get_det_promotion.prim_percent)> %#get_det_promotion.prim_percent#</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32501.Toplam Maliyet'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #TLFormat(get_det_promotion.total_promotion_cost)##session.ep.money#</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_det_promotion.prom_detail#</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif len(get_det_promotion.record_emp) and get_emp.recordcount>#get_emp.employee_name#&nbsp;#get_emp.employee_surname#</cfif>
						</label>
					</div>
					<div class="form-group">
						<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #dateformat(get_det_promotion.record_date,dateformat_style)#-#timeformat(get_det_promotion.record_date,'HH:MM:SS')# 
						</label>
					</div>
				</div>
			</cf_box_elements>
		</cf_box>
	</cfoutput> 
</div>

