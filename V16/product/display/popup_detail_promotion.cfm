<cfinclude template="../query/get_det_promotion.cfm">
<cfoutput>
  <cfsavecontent  variable="message"><cf_get_lang dictionary_id='60425.Promosyon Bilgileri'>: <cfoutput>#get_main_product.product_name#</cfoutput>
  </cfsavecontent>
<cf_box title="#message#" popup_box="1">
  <cf_box_elements>
    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
      <div class="form-group">
			<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32803.Promosyon No'></label>
			<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #get_det_promotion.prom_no#</label>
		</div>
		<div class="form-group">
			<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'></label>
			<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #get_det_promotion.prom_head#</label>
		</div>
		<div class="form-group">
			<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
			<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #get_main_product.product_name#</label>
		</div>
		<div class="form-group">
			<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
			<label class="col col-8 col-md-8 col-sm-8 col-xs-12">  #get_main_product.product_cat#</label>
		</div>
		<div class="form-group">
			<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37304.İlişkili Kampanya'></label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
				<cfif len(get_det_promotion.camp_id)>
				#get_camp_name.camp_head#
				</cfif>
			</label>
		</div>
		<div class="form-group">
			<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58775.Alışveriş Miktarı'></label>
			<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
				 <cfif get_det_promotion.LIMIT_type is 1 or get_det_promotion.LIMIT_type is 3>
					#get_det_promotion.LIMIT_VALUE# <cf_get_lang dictionary_id='58082.Adet'>
					<cfelseif get_det_promotion.LIMIT_type is 2>
					#TLFormat(get_det_promotion.LIMIT_VALUE)# <cf_get_lang dictionary_id='57673.Tutar'>
				</cfif>
			</label>
        </div>
		<div class="form-group">
			<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
			<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
				<cfif get_det_promotion.price_catid is '-2'><cf_get_lang dictionary_id='58721.Standart Satış'>
				<cfelseif get_det_promotion.price_catid is '-1'><cf_get_lang dictionary_id='58722.Standart Alış'>
				<cfelse>
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
				</label>
			</div>
			<div class="form-group">
				<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57641.İndirim'> %</label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #get_det_promotion.discount# </label>
			</div>
			<div class="form-group">
				<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlangıç Tar'>.</label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12">  #dateformat(get_det_promotion.startdate,dateformat_style)# </label>
			</div>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
			<div class="form-group">
				<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32453.Bedava Ürün Ver'></label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12">
				<cfif len(get_det_promotion.free_stock_id)>
				#get_free_product.product_name#
				</cfif>
			</label>
			</div>
			<div class="form-group">
				<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tar'></label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12">  #dateformat(get_det_promotion.finishdate,dateformat_style)#</label>
			</div>
			<div class="form-group">
				<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32811.Armağan Ver'></label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12">  #get_det_promotion.gift_head#</label>
			</div>
			<div class="form-group">
				<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> #get_emp.employee_name#&nbsp;#get_emp.employee_surname#</label>
			</div>
			<div class="form-group">
				<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50891.Puan Ver'></label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12">  #get_det_promotion.prom_point#</label>
			</div>
			<div class="form-group">
				<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12">  #dateformat(get_det_promotion.record_date,dateformat_style)#-#timeformat(get_det_promotion.record_date,'hh:mm:ss')# </label>
				</div>
			<div class="form-group">
				<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32491.Şans Kuponu Ver'></label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12">  #get_det_promotion.coupon_id#</label>
			</div>
			<div class="form-group">
				<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'></label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
					<cfif len(get_det_promotion.valid_emp) and len(get_det_promotion.valid)>
						#get_position.employee_name#&nbsp;#get_position.employee_surname#
						<cfif get_det_promotion.valid eq 1>
							-<cf_get_lang dictionary_id='57616.Onaylı'>
							<cfelse>
							<cf_get_lang dictionary_id='57617.Reddedilmiş'>
						</cfif>
						<cfelse>
						<cf_get_lang dictionary_id='60426.Onay İşlemi Görmemiş'>
					</cfif>
				</label>
			</div>
			<div class="form-group">
				<label class="bold col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37496.Dönem Primi Ver'></label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12">  #get_det_promotion.prim_percent#</label>
			</div>
		</div>
            </cf_box>
</cfoutput> 
