
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box closable="1" title="#getLang('','Satılabilir Stok Prensipleri',58747)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_stock_action" action="#request.self#?fuseaction=product.emptypopup_add_saleable_stock_action" method="post">
			<cf_box_elements vertical="1">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-stock_action_name">
					 	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37778.Prensip Adı'> *</label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='37778.Prensip Adı'></cfsavecontent>
							<cfinput type="text" name="stock_action_name" value="" maxlength="150" required="yes" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-stock_action_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37779.Prensip Türü'></label>
						<div class="col col-8 col-xs-12"> 
							<select name="stock_action_type" id="stock_action_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"><cf_get_lang dictionary_id='37167.Bekleyen Sipariş Alınamaz'></option>
								<option value="2"><cf_get_lang dictionary_id='37169.Bekleyen Siparişe Alınır Silinemez'></option>
								<option value="3"><cf_get_lang dictionary_id='37174.Bekleyen Siparişe Alınır Silinebilir'></option>
								<option value="4"><cf_get_lang dictionary_id='37178.Alternatif Ürün Gönderilebilir'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-stock_action_message">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57543.Mesaj'></label>
						<div class="col col-8 col-xs-12"> 
							<cfinput type="text" name="stock_action_message" value="" maxlength="250">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>	
				<cf_workcube_buttons type_format='1' is_upd='0'>
			</cf_box_footer>			
		</cfform>
	</cf_box>
</div>
