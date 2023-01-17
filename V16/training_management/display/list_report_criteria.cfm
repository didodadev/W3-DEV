<cf_catalystHeader>
<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
	<cf_box title="#getLang('','Rapor Seçenekleri',46501)#">
		<cfform name="form1" action="#request.self#?fuseaction=training_management.popup_list_report_choosen&class_id=#attributes.class_id#" method="post">
			<cf_box_elements>
				<div class="col col-8 col-xs-8 col-md-8 col-sm-12">
					<div class="form-group" id="item-tarih">
						<label class="col col-3 col-xs-12 col-md-3 col-sm-3"><cf_get_lang no='319.Rapor Tarih'></label>
						<div class="col col-9 col-xs-12 col-md-9 col-sm-2">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent> 
								<cfinput name="tarih" id="tarih" value="" validate="#validate_style#" message="#message#" type="text" style="width:65px;" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="tarih"></span>
							</div>
						</div>
					</div>	
					<div class="form-group" id="item-proje_adi">
						<label class="col col-3 col-xs-12 col-md-3 col-sm-3"><cf_get_lang_main no='22.Rapor Adı'></label>
						<div class="col col-9 col-xs-12 col-md-9 col-sm-8">
							<input style="width:200px;" name="proje_adi" id="proje_adi" type="text">
						</div>
					</div>
					<div class="form-group" id="item-secenek1">
						<label class="col col-3 col-xs-12 col-md-3 col-sm-3"><cf_get_lang no='295.Kapak'></label>
						<div class="col col-2 col-xs-2 col-md-2 col-sm-1">
							<input name="secenek1" id="secenek1" type="text" style="width:30px;" onkeyup="isNumber(this)">
						</div>
						<div class="col col-7 col-xs-10 col-md-7 col-sm-7">
							<input type="text" name="header1" id="header1" style="width:165px;">
						</div>
					</div>
					<div class="form-group" id="item-secenek2">
						<label class="col col-3 col-xs-12 col-md-3 col-sm-3"><cf_get_lang no='296.Program kimliği'></label>
						<div class="col col-2 col-xs-2 col-md-2 col-sm-1">
							<input name="secenek2" id="secenek2" type="text" style="width:30px;" onkeyup="isNumber(this)">
						</div>
						<div class="col col-7 col-xs-10 col-md-7 col-sm-7">
							<input type="text" name="header2" id="header2" style="width:165px;">
						</div>
					</div>
					<div class="form-group" id="item-secenek3">
						<label class="col col-3 col-xs-12 col-md-3 col-sm-3"><cf_get_lang no='297.Katılım listesi (kişi şube departman ünvan)'></label>
						<div class="col col-1 col-xs-2 col-md-2 col-sm-1">
							<input name="secenek3" id="secenek3" type="text" style="width:30px;" onkeyup="isNumber(this)">
						</div>
						<div class="col col-6 col-xs-10 col-md-6 col-sm-6">
							<input type="text" name="header3" id="header3" style="width:165px;">
						</div>
						<div class="col col-2 col-xs-12 col-md-1 col-sm-2">
							<input type="checkbox" name="excused" id="excused" value=""><cf_get_lang no='99.Mazeretliler'>
						</div>	
					</div>
					<div class="form-group" id="item-secenek4">
						<label class="col col-3 col-xs-12 col-md-3 col-sm-3"><cf_get_lang no='298.Sonuçlar listesi ön test-son test katılım oranı'></label>
						<div class="col col-2 col-xs-2 col-md-2 col-sm-1">
							<input name="secenek4" id="secenek4" type="text" style="width:30px;" onkeyup="isNumber(this)">
						</div>
						<div class="col col-7 col-xs-10 col-md-7 col-sm-7">
							<input type="text" name="header4" id="header4" style="width:165px;">
						</div>
					</div>
					<div class="form-group" id="item-secenek5">
						<label class="col col-3 col-xs-12 col-md-3 col-sm-3"><cf_get_lang no='299.Ön test-son test (Başarı oranı ayrı ayrı ve grafik ortalama karşılaştırması)'></label>
						<div class="col col-2 col-xs-2 col-md-2 col-sm-1">
							<input name="secenek5" id="secenek5" type="text" style="width:30px;" onkeyup="isNumber(this)">
						</div>
						<div class="col col-7 col-xs-10 col-md-7 col-sm-7">
							<input type="text" name="header5" id="header5" style="width:165px;">
						</div>
					</div>
					<cfinclude template="../query/get_training_quizes.cfm">
					<cfset basla=6>
					<cfif GET_QUIZ.recordcount>							
						<cfoutput query="GET_QUIZ">
							<tr> 					
								<td>#QUIZ_HEAD#</td>
								<td>
									<input name="secenek#basla#" id="secenek#basla#" type="text" style="width:30px;" onkeyup="isNumber(this)"><input type="hidden" name="gizli#basla#" id="gizli#basla#" value="#QUIZ_ID#">
								</td>
								<td>
								<cf_get_lang_main no='1303.Liste'><input type="checkbox" name="list#basla#" id="list#basla#" value="1">
									<select name="graph_type#basla#" id="graph_type#basla#" style="width:110px;">
										<option value=""><cf_get_lang_main no='538.Grafik Format'></option>
										<option value="pie"><cf_get_lang_main no='1316.Pasta'></option>
										<option value="line"><cf_get_lang_main no='253.Eğri'></option>
										<option value="bar"><cf_get_lang_main no='251.Bar'></option>
									</select>
								</td>
							</tr>
							<cfif basla eq 8>
								<cfset basla=16>
							<cfelse>
								<cfset basla=basla+1>
							</cfif>
						</cfoutput>						
					</cfif>
					<div class="form-group" id="item-secenek9">
						<label class="col col-3 col-xs-12 col-md-3 col-sm-3"><cf_get_lang no='302.Eğitim sonrası değerlendirme'></label>
						<div class="col col-2 col-xs-2 col-md-2 col-sm-1">
							<input   name="secenek9" id="secenek9" type="text" style="width:30px;" onkeyup="isNumber(this)">
						</div>
						<div class="col col-7 col-xs-10 col-md-7 col-sm-7">
							<input type="text" name="header9" id="header9" style="width:165px;">
						</div>
					</div>				  
					<div class="form-group" id="item-secenek12">
						<label class="col col-3 col-xs-12 col-md-3 col-sm-3"><cf_get_lang no='305.Düşünceler, Öneriler'></label>
						<div class="col col-2 col-xs-2 col-md-2 col-sm-1">
							<input name="secenek12" id="secenek12" type="text" style="width:30px;" onkeyup="isNumber(this)">
						</div>
						<div class="col col-7 col-xs-10 col-md-7 col-sm-7">
							<input type="text" name="header12" id="header12" style="width:165px;">
						</div>
					</div>					  
					<div class="form-group" id="item-secenek14">
						<label class="col col-3 col-xs-12 col-md-3 col-sm-3"><cf_get_lang no='224.Katılımcı değerlendirme formu'></label>
						<div class="col col-2 col-xs-2 col-md-2 col-sm-1">
							<input name="secenek14" id="secenek14" type="text" style="width:30px;" onkeyup="isNumber(this)">
						</div>
						<div class="col col-7 col-xs-10 col-md-7 col-sm-7">
							<input type="text" name="header14" id="header14" style="width:165px;">
						</div>
					</div>
					<div class="form-group" id="item-secenek15">
						<label class="col col-3 col-xs-12 col-md-3 col-sm-3"><cf_get_lang no='307.Maliyet bilgisi gelsin'></label>
						<div class="col col-2 col-xs-2 col-md-2 col-sm-1">
							<input name="secenek15" id="secenek15" type="text" style="width:30px;" onkeyup="isNumber(this)">
						</div>
						<div class="col col-7 col-xs-10 col-md-7 col-sm-7">
							<input type="text" name="header15" id="header15" style="width:165px;">
						</div>
					</div>
					<cfif basla lte 9><cfset basla=15><cfelse><cfset basla=basla-1></cfif>
					<input name="max" id="max" value="<cfoutput>#basla#</cfoutput>" type="hidden">
					<label class="col col-12 col-xs-12 col-md-12 col-sm-12">
						<font color="FF0000"><cf_get_lang_main no='55.Not'>: </font>
						<cf_get_lang no='374.Raporda görmek istediğiniz kısımların karşısına görünmesini istediğiniz sayfanın numarasını yazınız'>.
					</label>
				</div>
			</cf_box_elements>	
			<cf_box_footer><cf_workcube_buttons type_format='1' is_upd='0'></cf_box_footer>		
		</cfform>
	</cf_box>
</div>
<div class="col col-3 col-sm-6 col-xs-12">
	<cfinclude template="../form/upd_class_sag.cfm">
</div>