<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box id="box_counter" scroll="1" collapsable="1" resize="1">
        <cfform name="add_counter_type" id="add_counter_type" method="post" action="">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-counter_type">
						<label class="col col-4"><cf_get_lang dictionary_id='41282.Sayaç Tipi'> *</label>
						<div class="col col-8">
							<input type="text" name="counter_type" id="counter_type" required>
						</div>
					</div>
                    <div class="form-group" id="item-reading_type">
						<label class="col col-4"><cf_get_lang dictionary_id='40984.Okuma Tipi'> *</label>
						<div class="col col-8">
							<select name="reading_type" id="reading_type" required>
								<option value="1"><cf_get_lang dictionary_id='39250.Sistem Bazında'></option>
								<option value="2"><cf_get_lang dictionary_id='62220.Kullanıcı Bazında'></option>
								<option value="3"><cf_get_lang dictionary_id='62221.İşlem Bazında'></option>
							</select>
						</div>
					</div>
                    <div class="form-group" id="item-reading_period">
						<label class="col col-4"><cf_get_lang dictionary_id='62224.Okuma Periyodu'> *</label>
						<div class="col col-8">
							<select name="reading_period" id="reading_period" required>
								<option value="1"><cf_get_lang dictionary_id='57490.Gün'></option>
								<option value="2"><cf_get_lang dictionary_id='58734.Hafta'></option>
								<option value="3"><cf_get_lang dictionary_id='58724.Ay'></option>
								<option value="4">3 <cf_get_lang dictionary_id='58724.Ay'></option>
								<option value="5"><cf_get_lang dictionary_id='58455.Yıl'></option>
							</select> 
						</div>
					</div>
                    <div class="form-group" id="item-start_value">
						<label class="col col-4"><cf_get_lang dictionary_id='41283.Başlama Değeri'> *</label>
						<div class="col col-8">
							<input type="text" name="start_value" id="start_value" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox" required>
						</div>
					</div>
                    <div class="form-group" id="item-tariff">
						<label class="col col-4"><cf_get_lang dictionary_id='62222.Tarife/Ek Ürün'></label>
						<div class="col col-4">
							<div class="input-group">
								<input type="hidden" name="tariff_id" id="tariff_id">
								<input type="text" name="tariff_name" id="tariff_name" readonly required>
								<span class="input-group-addon btn_Pointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=sales.popup_list_tariff&fieldId=add_counter_type.tariff_id&fieldName=add_counter_type.tariff_name');"></span>
							</div>
						</div>
						<div class="col col-4">
							<a target="_blank" href="<cfoutput>#request.self#</cfoutput>?fuseaction=sales.tariff&event=add" class="ui-btn ui-btn-update"><cf_get_lang dictionary_id='62223.TASARLA'></a>
						</div>
					</div>
                    <div class="form-group" id="item-invoice_period">
						<label class="col col-4"><cf_get_lang dictionary_id='41285.Fatura Periyodu'> *</label>
						<div class="col col-8">
							<select name="invoice_period" id="invoice_period" required>
								<option value="1"><cf_get_lang dictionary_id='58724.Ay'></option>
								<option value="2">3 <cf_get_lang dictionary_id='58724.Ay'></option>
								<option value="3"><cf_get_lang dictionary_id='58455.Yıl'></option>
							</select>
						</div>
					</div>
                    <div class="form-group" id="item-free_period">
						<label class="col col-4"><cf_get_lang dictionary_id='40994.Ücretsiz Dönem'></label>
						<div class="col col-8">
							<input type="text" name="free_period" id="free_period" placeholder="<cf_get_lang dictionary_id='57490.Gün'>" required>
						</div>
					</div>
					<div class="form-group" id="item-wex_code">
						<label class="col col-4"><cf_get_lang dictionary_id='62244.Wex Code'> *</label>
						<div class="col col-8">
							<div class="input-group">
							<input type="hidden" name="wex_code" id="wex_code">
								<input type="text" name="wex_name" id="wex_name" readonly required>
								<span class="input-group-addon btn_Pointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_wex&fieldId=add_counter_type.wex_code&fieldName=add_counter_type.wex_name');"></span>
							</div>
						</div>
					</div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0' is_delete='0' add_function='kontrol()' data_action = '/V16/settings/cfc/counter_type:add_counter_type' next_page = '#request.self#?fuseaction=#attributes.fuseaction#&event=upd&ct_id='>
			</cf_box_footer>
        </cfform>
    </cf_box>
</div>

<script type="text/javascript">
    function kontrol(){
		
		if(document.add_counter.invoice_period.value==0)
		{
			alert("<cf_get_lang dictionary_id ='41290.Fatura Periyodu Kontrol Ediniz'>!");
			return false;
		}
		
        unformat_fields();
    }
    function unformat_fields(){
        document.add_counter_type.start_value.value = filterNum(document.add_counter_type.start_value.value);
    }
</script>