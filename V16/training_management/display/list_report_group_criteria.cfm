<cfset basla=1>
<cf_popup_box title="#getLang('training_management',294)#">
<cfform name="form1" action="#request.self#?fuseaction=training_management.popup_list_report_group_choosen&train_group_id=#attributes.TRAIN_GROUP_ID#" method="post">
	<table>
		<tr>
			<td><cf_get_lang_main no='22.Rapor Adı'></td>
			<td colspan="2"><input style="width:200px;" name="proje_adi" id="proje_adi"  type="text"></td>
			<td>
				&nbsp;
			</td>
			<td style="text-align:center" class="txtbold"><cf_get_lang no='376.Gruplama'></td>
		</tr>
		<tr>
			<td><cf_get_lang no='319.Rapor Tarihi'></td>
			<td colspan="3">
				<cfsavecontent variable="message"><cf_get_lang_main no ='1080.Tarihi Kontrol Ediniz'>!</cfsavecontent>
				<cfinput type="text" validate="date" name="tarih" id="tarih" value="" message="#message#" style="width:200px"><cf_wrk_date_image date_field="tarih">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no='295.Kapak'></td>
			<td><input style="width:30px;" name="secenek1" id="secenek1"  type="text"></td>
			<td><input type="text" name="header1" id="header1" style="width:165px;"></td>
			<td>
				&nbsp;
			</td>
			<td style="text-align:center"><input type="checkbox" name="konsolide" id="konsolide" value="1" checked></td>
		</tr>
		<tr>
			<td><cf_get_lang no='296.Program kimliği'></td>
			<td><input  style="width:30px;"  name="secenek2" id="secenek2"  type="text">
			<td><input type="text" name="header2" id="header2" style="width:165px;"></td>
			<td>
				&nbsp;
			</td>
			<td style="text-align:center"><input type="checkbox" name="konsolide" id="konsolide" value="2" checked></td>
		</tr>
		<tr>
			<td><cf_get_lang no='297.Katılım listesi (kişi şube departman ünvan)'></td>
			<td><input style="width:30px;" name="secenek3" id="secenek3" type="text"></td>
			<td>
				<input type="text" name="header3" id="header3" style="width:165px;">
			</td>
			<td>
				<input type="checkbox" name="excused" id="excused" value=""><cf_get_lang no='99.Mazeretliler'>
			</td>
			<td style="text-align:center"><input type="checkbox" name="konsolide" id="konsolide" value="3" checked></td>
		</tr>
		<tr>
			<td><cf_get_lang no='298.Sonuçlar listesi ön test-son test katılım oranı'></td>
			<td><input  style="width:30px;"  name="secenek4" id="secenek4"  type="text"></td>
			<td><input type="text" name="header4" id="header4" style="width:165px;"></td>
			<td>
				&nbsp;
			</td>
			<td style="text-align:center"><input type="checkbox" name="konsolide" id="konsolide" value="4" checked></td>
		</tr>
		<tr>
			<td><cf_get_lang no='299.Ön test-son test (Başarı oranı ayrı ayrı ve grafik ortalama karşılaştırması)'></td>
			<td><input  style="width:30px;"  name="secenek5" id="secenek5"  type="text"></td>
			<td><input type="text" name="header5" id="header5" style="width:165px;"></td>
			<td>
				&nbsp;
			</td>
			<td style="text-align:center"><input type="checkbox" name="konsolide" id="konsolide" value="5" checked></td>
		</tr>
			<cfinclude template="../query/get_group_classes.cfm">
			<cfset attributes.class_ids=valuelist(get_tr_name.CLASS_ID)>
			<cfif NOT LEN(attributes.class_ids)>
				<cfset attributes.class_ids = 0>
			</cfif>
			<cfinclude template="../query/get_training_quizes.cfm">
			<cfset basla=6>
		<cfif GET_QUIZ.recordcount>
			<cfoutput query="GET_QUIZ">
				<tr>
					<td>#QUIZ_HEAD#</td>
					<td>
						<input type="hidden" name="gizli#basla#" id="gizli#basla#" value="#QUIZ_ID#">
						<input  style="width:30px;"  name="secenek#basla#" id="secenek#basla#"  type="text">
					</td>
					<td>
						<cf_get_lang_main no='1303.Liste'><input type="checkbox" name="list#basla#" id="list#basla#" value="1" checked>
						<select name="graph_type#basla#" id="graph_type#basla#" style="width:110px;">
							<option value=""><cf_get_lang_main no='538.Grafik Format'></option>
							<option value="pie"><cf_get_lang_main no='1316.Pasta'></option>
							<option value="line"><cf_get_lang_main no='253.Eğri'></option>
							<option value="bar"><cf_get_lang_main no='251.Bar'></option>
						</select>
					</td>
					<td style="text-align:center"><input type="checkbox" name="konsolide" id="konsolide" value="#basla#" checked></td>
				</tr>
				<cfif basla eq 8>
					<cfset basla=16>
				<cfelse>
					<cfset basla=basla+1>
				</cfif>
			</cfoutput>
			<tr>
				<td>Eğitim Formları Baş. ve Bit Tarihi:</td>
				<td colspan="2">
				<input value="" type="text" name="start_date" id="start_date" style="width:78px;" maxlength="10"><cf_wrk_date_image date_field="start_date">
				<input value="" type="text" name="finish_date" id="finish_date" style="width:78px;" maxlength="10"><cf_wrk_date_image date_field="finish_date"></td>
			</tr>
		</cfif>
		<tr>
			<td><cf_get_lang no='302.Eğitim sonrası değerlendirme'></td>
			<td><input  style="width:30px;"  name="secenek9" id="secenek9"  type="text"></td>
			<td><input type="text" name="header9" id="header9" style="width:165px;"></td>
			<td>
				&nbsp;
			</td>
			<td style="text-align:center"> <input type="checkbox" name="konsolide" id="konsolide" value="9" checked></td>
		</tr>
		<tr>
			<td><cf_get_lang no='305.Düşünceler, Öneriler'></td>
			<td><input style="width:30px;"  name="secenek12" id="secenek12"  type="text"></td>
			<td><input type="text" name="header12" id="header12" style="width:165px;"></td>
			<td>
				&nbsp;
			</td>
			<td style="text-align:center"><input type="checkbox" name="konsolide" id="konsolide" value="12" checked></td>
		</tr>
		<tr>
			<td><cf_get_lang no='224.Katılımcı değerlendirme formu'></td>
			<td><input  style="width:30px;"  name="secenek14" id="secenek14"  type="text"></td>
			<td><input type="text" name="header14" id="header14" style="width:165px;"></td>
			<td>
				&nbsp;
			</td>
			<td style="text-align:center"><input type="checkbox" name="konsolide" id="konsolide" value="14" checked></td>
		</tr>
		<tr>
			<td><cf_get_lang no='307.Maliyet bilgisi gelsin'></td>
			<td><input style="width:30px;"  name="secenek15" id="secenek15"  type="text"></td>
			<td><input type="text" name="header15" id="header15" style="width:165px;"></td>
			<td>
				&nbsp;
			</td>
			<td style="text-align:center"><input type="checkbox" name="konsolide" id="konsolide" value="15" checked></td>
		</tr>
			<cfif basla lte 9 >
				<cfset basla=15>
			<cfelse>
				<cfset basla=basla-1>
			</cfif>
			<input name="max" id="max"  value="<cfoutput>#basla#</cfoutput>" type="hidden">
		<tr>
		<td colspan="4">
			<br />
			<font color="FF0000"><cf_get_lang_main no='55.Not'>: </font>
			<cf_get_lang no='374.Raporda görmek istediğiniz kısımların karşısına görünmesini istediğiniz sayfanın numarasını yazınız'>.
		</td>
		</tr>
	</table>
	<cf_popup_box_footer><cf_workcube_buttons type_format='1' is_upd='0'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
