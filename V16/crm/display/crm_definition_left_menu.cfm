<cfif get_module_power_user(52)>
<cfoutput>
    <ul id="tree">
        <li><strong><cf_get_lang_main no='117.tanimlar'></strong>
            <ul>
				<cfif not listfindnocase(denied_pages,'crm.form_add_stock_amount')>                		
                        <li><a href="#request.self#?fuseaction=crm.form_add_stock_amount"><cf_get_lang no='149.Stok ve Raf Durumu'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.form_add_duty_period')>
                        <li><a href="#request.self#?fuseaction=crm.form_add_duty_period"><cf_get_lang no='123.Müşteri Nöbet Durumu'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.form_add_customer_position')>
                        <li><a href="#request.self#?fuseaction=crm.form_add_customer_position"><cf_get_lang no='95. Müşteri Genel Konumu'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.list_society')>
                        <li><a href="#request.self#?fuseaction=crm.list_society"><cf_get_lang no='97.Çalışılan Kurumlar'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.list_membership_stages')>
                        <li><a href="#request.self#?fuseaction=crm.list_membership_stages"><cf_get_lang no='73.Üye Durum'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.form_add_purchase_authority')>
                        <li><a href="#request.self#?fuseaction=crm.form_add_purchase_authority"><cf_get_lang no='33.Mal Alımındaki Etkinlik Durumu'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.form_add_graduate_level')>
                        <li><a href="#request.self#?fuseaction=crm.form_add_graduate_level"><cf_get_lang no='36.Eğitim Durumu'></a></li>
                </cfif> 
                <li><a href="#request.self#?fuseaction=settings.add_customer_type"><cf_get_lang_main no='45.Müşteri'> <cf_get_lang_main no='1227.Tipleri'></a></li>
                <li><a href="#request.self#?fuseaction=settings.add_main_location_cat"><cf_get_lang no='1051.Ana Konum'></a></li>
                <li><a href="#request.self#?fuseaction=settings.add_endorsement_cat"><cf_get_lang_main no='2213.Ciro'> <cf_get_lang no='40.Kategorileri'></a></li>
                <li><a href="#request.self#?fuseaction=settings.add_profitability_cat"><cf_get_lang no='808.Karlılık'> <cf_get_lang no='40.Kategorileri'></a></li>
                <li><a href="#request.self#?fuseaction=settings.add_risk_cat"><cf_get_lang_main no='277.Risk'> <cf_get_lang no='40.Kategorileri'></a></li>
                <li><a href="#request.self#?fuseaction=settings.add_special_state_cat"><cf_get_lang no='1055.Ozel Durum'></a></li>
                <li><a href="#request.self#?fuseaction=settings.add_duty_unit_cat"><cf_get_lang no='42.Hizmet Birim'> <cf_get_lang no='40.Kategorileri'></a></li>
                <li><a href="#request.self#?fuseaction=settings.add_duty_type"><cf_get_lang no='41.Hizmet'> <cf_get_lang_main no='1227.Tipleri'></a></li>
                <li><a href="#request.self#?fuseaction=settings.add_target_period"><cf_get_lang no='43.Hedef Dönemleri'></a></li>               
            </ul>
         </li>
    </ul>
</cfoutput>
<cfelse>
<script>
	alert("<cf_get_lang dictionary_id='56057.Süper kullanıcı yetkiniz Bulunmamaktadır'>.");
	history.back(-1);
</script>
</cfif>
