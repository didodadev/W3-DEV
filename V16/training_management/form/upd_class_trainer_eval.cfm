<cfinclude template="../query/get_class.cfm">
<cfinclude template="../query/get_trainer_eval.cfm">
<cfsavecontent variable="right">
	<cfoutput>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_trainer_eval&action=print&id=#url.class_id#&module=training_management','page');return false;"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a> 
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_trainer_eval&action=mail&id=#url.class_id#&module=training_management&caption=Eğitim Katılımcı Değerlendirmesi','page')"><img src="/images/mail.gif" title="<cf_get_lang_main no='63.Mail Gönder'>" border="0"></a> 
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_trainer_eval&action=pdf&id=#url.class_id#&module=training_management','page')"><img src="/images/pdf.gif" title="<cf_get_lang_main no='66.PDF e Dönüştür'>" border="0"></a>
	</cfoutput>
</cfsavecontent>
<cf_popup_box title="#getLang('training_management',284)# : #get_class.class_name#" right_images="#right#">
	<cfform name="add_ev" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_trainer_eval">
	<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#class_id#</cfoutput>">
	<table>
		<tr>
			<td valign="top" class="formbold">1-) <cf_get_lang no='285.Sınıfın Yapısı Programa Uygun mu'>?</td>
			<td><textarea name="PROGRAMA_UYGUN" id="PROGRAMA_UYGUN" style="width:340px;height=40;"><cfoutput>#GET_TRAIN_EVAL.PROGRAMA_UYGUN#</cfoutput></textarea></td>
		</tr>
		<tr>
			<td valign="top" class="formbold">2-) Programın İçeriği katılımcıların düzeyine (bilgi birikimi,deneyim) uygunmuydu?</td>
			<td><textarea name="KATILIMCIYA_UYGUN" id="KATILIMCIYA_UYGUN" style="width:340px;height:40px;"><cfoutput>#GET_TRAIN_EVAL.KATILIMCIYA_UYGUN#</cfoutput></textarea></td>
		</tr>
		<tr>
			<td valign="top" class="formbold">3-) <cf_get_lang no='286.Programın Süresi yeterli mi'>?</td>
			<td><textarea name="SURE_YETERLI" id="SURE_YETERLI" style="width:340px;height=40;"><cfoutput>#GET_TRAIN_EVAL.SURE_YETERLI#</cfoutput></textarea></td>
		</tr>
		<tr>
			<td colspan="2" class="formbold" height="25">4-) <cf_get_lang no='287.Katılımcılarla ilgili Düşünceleriniz Nelerdir'>?</td>
		</tr>
		<tr>
			<td valign="top">a-) <cf_get_lang no='288.Eğitim Öncesi konu ile ilgilibilgi seviyeleri nasıldı'>?</td>
			<td>
				<textarea name="KATILIMCI_BILGI_SEVIYE" id="KATILIMCI_BILGI_SEVIYE" style="width:340px;height=40;"><cfoutput>#GET_TRAIN_EVAL.KATILIMCI_BILGI_SEVIYE#</cfoutput></textarea>
			</td>
		</tr>
		<tr>
			<td valign="top">b-) Katılımcılar, bilgi birikimi ve deneyim düzeyi açısından birbirine yakın mıydı?</td>
			<td><textarea name="KATILIMCI_DUZEYLERI" id="KATILIMCI_DUZEYLERI" style="width:340px;height:40px;"><cfoutput>#GET_TRAIN_EVAL.KATILIMCI_DUZEYLERI#</cfoutput></textarea></td>
		</tr>
		<tr>
			<td valign="top">c-) <cf_get_lang no='289.Derse ilgi ve katılım nasıldı'>?</td>
			<td>
				<textarea name="DERSE_KATILIM" id="DERSE_KATILIM" style="width:340px;height=40;"><cfoutput>#GET_TRAIN_EVAL.DERSE_KATILIM#</cfoutput></textarea>
			</td>
		</tr>
		<tr>
			<td valign="top">d-) Katılımcılar eğitim sonunda, eğitim başında hedeflenen bilgi ve becerileri kazanarak istenilen düzeye ulaştılar mı?</td>
			<td><textarea name="DERS_SONU_BEKLENTI" id="DERS_SONU_BEKLENTI"  style="width:340px;height:40px;"><cfoutput>#GET_TRAIN_EVAL.DERS_SONU_BEKLENTI#</cfoutput></textarea></td>
		</tr>
		<tr>
			<td valign="top">e-) <cf_get_lang no='290.Eğitim Süresince
			derse katılımlarıyla olumlu yönde dikkatinizi çeken
			kişiler ve olumlu nitelikleri belirtiniz'>. </td>
			<td><textarea name="OLUMLU_NITELIK" id="OLUMLU_NITELIK" style="width:340px;height=40;"><cfoutput>#GET_TRAIN_EVAL.OLUMLU_NITELIK#</cfoutput></textarea></td>
		</tr>	
		<tr>
			<td valign="top">f-) <cf_get_lang no='291.Eğitim Süresince
			konuyu takip etmekte zorlanan ya da derste olumsuz
			davranışlarıyla dikkaktinizi çeken kişiler ve niteliklerini
			belirtiniz'>. </td>
			<td><textarea name="OLUMSUZ_NITELIK" id="OLUMSUZ_NITELIK" style="width:340px;height=40;"><cfoutput>#GET_TRAIN_EVAL.OLUMSUZ_NITELIK#</cfoutput></textarea></td>
		</tr>	
		<tr>
			<td valign="top" class="formbold">4-) <cf_get_lang no='292.Eğitimci olarak
			katıldığınız bu program hakkındaki diğer görüş ve düşünceleriniz
			nedelerdir'>?</td>
			<td><textarea name="GORUS_ONVERI" id="GORUS_ONVERI" style="width:340px;height=40;"><cfoutput>#GET_TRAIN_EVAL.GORUS_ONVERI#</cfoutput></textarea></td>
		</tr>	
	</table>
	<cf_popup_box_footer>
		<cf_workcube_buttons type_format="1" is_upd='1' delete_page_url='#request.self#?fuseaction=training_management.emptypopup_upd_class_trainer_eval&is_del=1&class_id=#attributes.class_id#'>
	</cf_popup_box_footer>			  				  
	</cfform>
</cf_popup_box>

