<cfinclude template="../query/get_emp_att.cfm">
<cf_popup_box title="#getLang('training_management',224)#">
	<cfform name="add_class_attender_eval" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_class_attender_eval">
	<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
		<cfif get_emp_att.recordcount>
			<cfsavecontent variable="b1"><cf_get_lang no='225.Seminere İlgi'></cfsavecontent>
			<cfsavecontent variable="b2"><cf_get_lang no='226.Tartışmalara Katılım'></cfsavecontent>
			<cfsavecontent variable="b3"><cf_get_lang no='227.Öğrenme Motivasyonu'></cfsavecontent>
			<cfsavecontent variable="b4"><cf_get_lang no='228.Fikir Üretme'></cfsavecontent>
			<cfsavecontent variable="b5"><cf_get_lang no='229.Karşı Fikre Saygı'></cfsavecontent>
			<cfsavecontent variable="b6"><cf_get_lang no='230.Yeniliğe Açıklık'></cfsavecontent>
			<cfsavecontent variable="b7"><cf_get_lang no='231.Değişime İnanç'></cfsavecontent>
			<cfsavecontent variable="b8"><cf_get_lang_main no='678.İletişim Becerisi'></cfsavecontent>
			<table>
				<tr class="txtboldblue">
					<td height="25" valign="bottom"><cf_get_lang_main no='158.Ad Soyad' ></td>
					<cfloop from="1" to="8" index="sayy">
						<td width="25">
							<cfimage action="writeTobrowser" source="#txtToImage(Evaluate("b" & sayy), 11, 22, 145, "bold", "Verdana", "Black", "", 270)#">
						</td>
					</cfloop>
					<td valign="bottom"><cf_get_lang_main no='10.Notlar'></td>
				</tr>
				<input name="max_record_number" id="max_record_number" type="hidden" value="<cfoutput>#get_emp_att.recordcount#</cfoutput>">
				<cfoutput query="get_emp_att">
					<tr>
						<td nowrap>
						<cfif len(emp_id)>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#emp_id#','project');" class="tableyazi">#ad#</a>
							<input type="hidden" name="EMP_ID_#currentrow#" id="EMP_ID_#currentrow#" value="#EMP_ID#">
						<cfelseif len(con_id)>
							<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#con_id#','medium');" class="tableyazi">#ad#</a>
							<input type="hidden" name="CON_ID_#currentrow#" id="CON_ID_#currentrow#" value="#CON_ID#">
						<cfelseif len(par_id)>
							<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#par_id#','medium');" class="tableyazi">#ad#</a>
							<input type="hidden" name="PAR_ID_#currentrow#" id="PAR_ID_#currentrow#" value="#PAR_ID#">
						</cfif>
						</td>
						<td align="center">
							<cfsavecontent variable="message"><cf_get_lang no='526.SEMINERE ILGI İçin aşağıdaki puanları tanımlayınız'></cfsavecontent>
							<cfinput type="text" message="#message#" name="SEMINERE_ILGI_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
						</td>
						<td align="center">
							<cfsavecontent variable="message"><cf_get_lang no='527.TARTISMALARA KATILIM İçin aşağıdaki puanları tanımlayınız'></cfsavecontent>
							<cfinput type="text" message="#message#" name="TARTISMALARA_KATILIM_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
						</td>
						<td align="center">
							<cfsavecontent variable="message"><cf_get_lang no='528.OGRENME MOTIVASYONU İçin aşağıdaki puanları tanımlayınız'></cfsavecontent>
							<cfinput type="text" message="#message#" name="OGRENME_MOTIVASYONU_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
						</td>
						<td align="center">
							<cfsavecontent variable="message"><cf_get_lang no='529.FIKIR URETME İçin aşağıdaki puanları tanımlayınız'></cfsavecontent>
							<cfinput type="text" message="#message#" name="FIKIR_URETME_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
						</td>
						<td align="center">
							<cfsavecontent variable="message"><cf_get_lang no='530.KARSI FIKRE SAYGI İçin aşağıdaki puanları tanımlayınız'></cfsavecontent>
							<cfinput type="text" message="#message#" name="KARSI_FIKRE_SAYGI_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
						</td>
						<td align="center">
							<cfsavecontent variable="message"><cf_get_lang no='531.YENILIGE ACIKLIK İçin aşağıdaki puanları tanımlayınız'></cfsavecontent>
							<cfinput type="text" message="#message#" name="YENILIGE_ACIKLIK_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
						</td>
						<td align="center">
							<cfsavecontent variable="message"><cf_get_lang no='528.OGRENME MOTIVASYONU İçin aşağıdaki puanları tanımlayınız'></cfsavecontent>
							<cfinput type="text" message="#message#" name="DEGISIME_INANC_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
						</td>
						<td align="center">
							<cfsavecontent variable="message"><cf_get_lang no='532.ILETISIM BECERISI İçin aşağıdaki puanları tanımlayınız'></cfsavecontent>
							<cfinput type="text" message="#message#" name="ILETISIM_BECERISI_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
						</td>
						<td rowspan="3">
							<textarea name="NOTE_#currentrow#" id="NOTE_#currentrow#" style="width:350px;height:60px;"></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="9">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="9">&nbsp;</td>
					</tr>
				</cfoutput>
				<tr>
					<td height="20" colspan="10" class="txtbold" style="text-align:right;"> 
						1 = <cf_get_lang no='233.Çok Zayıf'>&nbsp;&nbsp;&nbsp; 
						2 = <cf_get_lang no='234.Zayıf'>&nbsp;&nbsp;&nbsp;
						3 = <cf_get_lang_main no='516.Orta'>&nbsp;&nbsp;&nbsp;
						4 = <cf_get_lang no='236.İyi'>&nbsp;&nbsp;&nbsp;
						5 = <cf_get_lang no='237.Çok İyi'>
					</td>
				</tr>
			</table>
		<cfelse>
			<table border="0">
				<tr class="txtboldblue">
					<td height="25"><cf_get_lang no='525.Kullanıcı Kaydı Yok'> !</td>
				</tr>
			</table>
		</cfif>
		<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='0'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>

