<cf_box title="#getLang('','Toplu Çek Giriş İşlemleri',54487)#">
    <cf_box_elements>
        <div class="col col-6 col-xs-12" type="column" index="1" sort="false">
            <div class="form-group">
                <label class="col col-12"><font color="#FF0000"><cf_get_lang dictionary_id='58597.Önemli Uyarı!'></font></label>
            </div>
            <div class="form-group">
                <label class="col col-12">
                    <cf_get_lang dictionary_id='54951.Toplu Çek Girişi Workcube uygulamasını kullanmaya başlayan şirketlerin sadece başlangıçta'>
                    <cf_get_lang dictionary_id='54953.Çek verilerini kolayca sisteme girmeleri için kullanılır'> <br/><br/>
                    <cf_get_lang dictionary_id='54952.Workcube e geçmeden önceki döneme ait çekler aşağıda görüldüğü gibi 4 grupta sisteme girilir'><br/><br/>
                    <cf_get_lang dictionary_id='50234.Yandaki linklere tıklayarak işlemlere başlayabilirsiniz'>
                </label>
            </div>
        </div>
        <div class="col col-6 col-xs-12" type="column" index="2" sort="false">
            <div class="form-group">
                <label class="col col-12 "><a class="font-blue" href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.form_add_cheque_exp&event=add_cash"><cf_get_lang dictionary_id='54491.Kasa Portföy Çek Girişi'></a></label>
            </div>
            <div class="form-group">
                <label class="col col-12"><a class="font-blue" href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.form_add_cheque_exp&event=add_bank"><cf_get_lang dictionary_id='54492.Banka Portföy Çek Girişi'></a></label>
            </div>
            <div class="form-group">
                <label class="col col-12"><a class="font-blue" href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.form_add_cheque_exp&event=add_payment"><cf_get_lang dictionary_id='54494.Ödenecek Çek Girişi'></a></label>
            </div>
            <div class="form-group">
                <label class="col col-12"><a class="font-blue" href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.form_add_cheque_exp&event=add_cash&is_ciro_cheque"><cf_get_lang dictionary_id='54495.Ciro Çek Girişi'></a></label>
            </div>
        </div>
    </cf_box_elements>
</cf_box>
            	
