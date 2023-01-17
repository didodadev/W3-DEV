<!---  Egitmen Degerlendirme  --->
<cfinclude template="../query/get_class.cfm">
<cfinclude template="../query/get_trainer_eval.cfm">
<cfif GET_TRAIN_EVAL.recordcount>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.popup_upd_class_trainer_eval&class_id=<cfoutput>#attributes.class_id#</cfoutput>";
	</script>	
	<cfabort>
</cfif>
<cfform name="add_ev" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_class_trainer_eval">
<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#class_id#</cfoutput>">
	<cf_popup_box title="#getLang('training_management',272)#: #get_class.class_name#">
        <div class="row">
        	<div class="col col-12 col-xs-12 col-md-12 col-sm-12">
				<div class="form-group" id="item-PROGRAMA_UYGUN">
					<label class="formbold col col-6 col-xs-12 col-md-3 col-sm-6">1-)<cf_get_lang no='285.Sınıfın Yapısı Programa Uygun mu'>?</label>
					<div class="col col-6 col-xs-12 col-md-9 col-sm-5">
						<textarea name="PROGRAMA_UYGUN" id="PROGRAMA_UYGUN" style="width:340px;height:40px;"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-KATILIMCIYA_UYGUN">
					<label class="formbold col col-6 col-xs-12 col-md-3 col-sm-6">2-)<cf_get_lang no ='491.Programın İçeriği katılımcıların düzeyine (bilgi birikimi,deneyim) uygunmuydu'>?</label>
					<div class="col col-6 col-xs-12 col-md-9 col-sm-5">
						<textarea name="KATILIMCIYA_UYGUN" id="KATILIMCIYA_UYGUN" style="width:340px;height:40px;"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-SURE_YETERLI">
					<label class="formbold col col-6 col-xs-12 col-md-3 col-sm-6">3-)<cf_get_lang no='286.Programın Süresi yeterli mi'></label>
					<div class="col col-6 col-xs-12 col-md-9 col-sm-5">
						<textarea name="SURE_YETERLI" id="SURE_YETERLI"  style="width:340px;height:40px;"></textarea>
					</div>
				</div>
				<br>
				<label class="formbold col col-12 col-xs-12 col-md-12 col-sm-12">4-)<cf_get_lang no='287.Katılımcılarla İlgili Düşünceleriniz Nelerdir'>?</label>
				<br><br>
				<div class="form-group" id="item-KATILIMCI_BILGI_SEVIYE">
					<label class="col col-6 col-xs-12 col-md-3 col-sm-6">&emsp;a-)<cf_get_lang no='288.Eğitim Öncesi konu ile ilgilibilgi seviyeleri nasıldı'>?</label>
					<div class="col col-6 col-xs-12 col-md-9 col-sm-5">
						<textarea name="KATILIMCI_BILGI_SEVIYE" id="KATILIMCI_BILGI_SEVIYE" style="width:340px;height:40px;"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-KATILIMCI_DUZEYLERI">
					<label class="col col-6 col-xs-12 col-md-3 col-sm-6">&emsp;b-)<cf_get_lang no ='492.Katılımcılar, bilgi birikimi ve deneyim düzeyi açısından birbirine yakın mıydı'> ?</label>
					<div class="col col-6 col-xs-12 col-md-9 col-sm-5">
						<textarea name="KATILIMCI_DUZEYLERI" id="KATILIMCI_DUZEYLERI" style="width:340px;height:40px;"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-DERSE_KATILIM">
					<label class="col col-6 col-xs-12 col-md-3 col-sm-6">&emsp;c-)<cf_get_lang no='289.Derse ilgi ve katılım nasıldı'>?</label>
					<div class="col col-6 col-xs-12 col-md-9 col-sm-5">
						<textarea name="DERSE_KATILIM" id="DERSE_KATILIM"  style="width:340px;height:40px;"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-DERS_SONU_BEKLENTI">
					<label class="col col-6 col-xs-12 col-md-3 col-sm-6">&emsp;d-)<cf_get_lang no ='493. Katılımcılar eğitim sonunda, eğitim başında hedeflenen bilgi ve becerileri kazanarak istenilen düzeye ulaştılar mı'></label>
					<div class="col col-6 col-xs-12 col-md-9 col-sm-5">
						<textarea name="DERS_SONU_BEKLENTI" id="DERS_SONU_BEKLENTI"  style="width:340px;height:40px;"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-OLUMLU_NITELIK">
					<label class="col col-6 col-xs-12 col-md-3 col-sm-6">&emsp;e-)<cf_get_lang no='290.Eğitim Süresince derse katılımlarıyla olumlu yönde dikkatinizi çeken kişiler ve olumlu nitelikleri belirtiniz'>.</label>
					<div class="col col-6 col-xs-12 col-md-9 col-sm-5">
						<textarea name="OLUMLU_NITELIK" id="OLUMLU_NITELIK" style="width:340px;height:40px;"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-OLUMSUZ_NITELIK">
					<label class="col col-6 col-xs-12 col-md-3 col-sm-6">&emsp;f-)<cf_get_lang no='291.Eğitim Süresince konuyu takip etmekte zorlanan ya da derste olumsuz davranışlarıyla dikkaktinizi çeken kişiler ve niteliklerini belirtiniz'>.</label>
					<div class="col col-6 col-xs-12 col-md-9 col-sm-5">
						<textarea name="OLUMSUZ_NITELIK" id="OLUMSUZ_NITELIK"  style="width:340px;height:40px;"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-GORUS_ONVERI">
					<label class="formbold col col-6 col-xs-12 col-md-3 col-sm-6">4-)<cf_get_lang no='292.Eğitimci olarak katıldığınız bu program hakkındaki diğer görüş ve düşünceleriniz nedelerdir'>?</label>
					<div class="col col-6 col-xs-12 col-md-9 col-sm-5">
						<textarea name="GORUS_ONVERI" id="GORUS_ONVERI" style="width:340px;height:40px;"></textarea>
					</div>
				</div>
			</div>
		</div>	
		<cf_popup_box_footer><cf_workcube_buttons is_upd='0' ></cf_popup_box_footer>
	</cf_popup_box>
</cfform>

