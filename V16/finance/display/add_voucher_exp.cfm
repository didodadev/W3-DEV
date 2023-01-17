<cf_box title="#getLang('','','54505')#">
            	<div class="col col-6 col-xs-12" type="column" index="1" sort="false">
                	
                    <div class="form-group">
                    	<label class="col col-12 bold"><cf_get_lang dictionary_id='58597.Önemli Uyarı'></label>
                    </div>
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id='54955.Toplu Senet Girişi Workcube uygulamasını kullanmaya başlayan şirketlerin sadece başlangıçta'></label>
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id='54956.Senet verilerini kolayca sisteme girmeleri için kullanılır.'> </label>
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id='54952.Workcube e geçmeden önceki döneme ait çekler aşağıda görüldüğü gibi 4 grupta sisteme girilir.'></label>
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id='64296.Yandaki linkleri tıklayarak işlemlere başlayabilirsiniz.'></label>
                    </div>
				</div>
                <div class="col col-6 col-xs-12" type="column" index="2" sort="false">
                	<div class="form-group">
                    	<label class="col col-12 "><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.form_add_voucher_exp&event=add_cash"><cf_get_lang dictionary_id='54506.Kasa Portföy Senet Girişi'></a></label>
                    </div>
                    <div class="form-group">
                    	<label class="col col-12"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.form_add_voucher_exp&event=add_bank"><cf_get_lang dictionary_id='54507.Banka Portföy Senet Girişi'></a></label>
                    </div>
                    <div class="form-group">
                    	<label class="col col-12"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.form_add_voucher_exp&event=add_payment"><cf_get_lang dictionary_id='54508.Ödenecek Senet Girişi'></a></label>
                    </div>
                    <div class="form-group">
                    	<label class="col col-12"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.form_add_voucher_exp&event=add_cash&is_ciro_voucher"><cf_get_lang dictionary_id='54510.Ciro Senet Girişi'></a></label>
                    </div>
                </div>
			
			</cf_box>



