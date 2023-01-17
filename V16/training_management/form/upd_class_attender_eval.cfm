<cfquery name="GET_CLASS_ATTENDER_EVAL" datasource="#dsn#">
	SELECT 
		TCA.*,
		E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS AD
	FROM 
		TRAINING_CLASS_ATTENDER TCA,
		EMPLOYEES E,
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY C
	WHERE 
		EP.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND 
		BRANCH.BRANCH_ID IN (
                                SELECT
                                    BRANCH_ID
                                FROM
                                    EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                    POSITION_CODE = #SESSION.EP.POSITION_CODE#	
                            ) AND 
		C.COMP_ID=BRANCH.COMPANY_ID AND 
		EP.EMPLOYEE_ID = TCA.EMP_ID AND
		TCA.EMP_ID = E.EMPLOYEE_ID AND
		TCA.CLASS_ID = #attributes.class_id#
	UNION
	SELECT	
		TCA.*,
		CON.CONSUMER_NAME+' '+CON.CONSUMER_SURNAME AS AD
	FROM 
		TRAINING_CLASS_ATTENDER TCA,
		CONSUMER CON
	WHERE 
		TCA.CON_ID = CON.CONSUMER_ID AND 
		TCA.CLASS_ID = #attributes.class_id#
	UNION
	SELECT	
		TCA.*,
		COMP.COMPANY_PARTNER_NAME+' '+ COMP.COMPANY_PARTNER_SURNAME AS AD
	FROM 
		TRAINING_CLASS_ATTENDER TCA,
		COMPANY_PARTNER COMP
	WHERE 
		TCA.PAR_ID = COMP.PARTNER_ID AND 
		TCA.CLASS_ID = #attributes.class_id#
	ORDER BY
		AD ASC
</cfquery>
<cfquery name="get_attender_eval" datasource="#dsn#" maxrows="1">
	SELECT * FROM TRAINING_CLASS_ATTENDER_EVAL WHERE CLASS_ID = #attributes.class_id#
</cfquery>
<cfsavecontent variable="img">
	<a href="<cfoutput>#request.self#?fuseaction=training_management.popup_form_add_class_attender_eval&class_id=#class_id#</cfoutput>"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
</cfsavecontent>
<cf_popup_box title="#getLang('training_management',224)#" right_images="#img#">
<cfform name="upd_class_attender_eval" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_attender_eval">
<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
<table>
	<cfif get_class_attender_eval.recordcount>
	<!---	<cfoutput>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_attender_eval&action=print&id=#url.class_id#&module=training_management','page');return false;"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a> 
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_attender_eval&action=mail&id=#url.class_id#&module=training_management&caption=Eğitim Katılımcı Değerlendirmesi','page')"><img src="/images/mail.gif" title="<cf_get_lang_main no='63.Mail Gönder'>" border="0"></a> 
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_attender_eval&action=pdf&id=#url.class_id#&module=training_management','page')"><img src="/images/pdf.gif" title="<cf_get_lang_main no='66.PDF e dönüştür'>" border="0"></a>
		</cfoutput>--->
	<thead>
	<tr>
		<th class="txtbold" height="25"><cf_get_lang_main no='158.Ad Soyad'></th>
		<th class="txtbold" width="25" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='225.Seminere İlgi'></th>
		<th class="txtbold" width="25" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='226.Tartışmalara Katılım'></th>
		<th class="txtbold"width="25" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='227.Öğrenme Motivasyonu'></th>
		<th class="txtbold" width="25" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='228.Fikir Üretme'></th>
		<th class="txtbold" width="25" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='229.Karşı Fikre Saygı'></th>
		<th class="txtbold" width="25" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='230.Yeniliğe Açıklık'></th>
		<th class="txtbold" width="25" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang no='231.Değişime İnanç'></th>
		<th class="txtbold" width="25" style="writing-mode : tb-rl;direction : rtl;"><cf_get_lang_main no='678.İletişim Becerisi'></th>
		<th class="txtbold" width="25" style="writing-mode : tb-rl;"><cf_get_lang no='383.Ortalama'></th> 
		<th class="txtbold" valign="bottom"><cf_get_lang_main no='10.Notlar'></th>
	</tr>
	</thead>
	<tr>
		<input name="max_record_number" id="max_record_number" type="hidden" value="<cfoutput>#GET_CLASS_ATTENDER_EVAL.recordcount#</cfoutput>">
		<cfoutput query="GET_CLASS_ATTENDER_EVAL">
		<cfquery name="get_class_eval" datasource="#dsn#">
			SELECT 
				* 
			FROM
				TRAINING_CLASS_ATTENDER_EVAL TCAE
			WHERE
				TCAE.CLASS_ID IS NOT NULL AND
				TCAE.CLASS_ID = #CLASS_ID# AND
				<cfif len(EMP_ID)>
					TCAE.EMP_ID = #EMP_ID#
				<cfelseif len(PAR_ID)>
					TCAE.PAR_ID = #PAR_ID#
				<cfelseif len(CON_ID)>
					TCAE.CON_ID = #CON_ID#
				</cfif>
		</cfquery>
		<cfset satir_ort = 0>
		<cfset counter = 0>
		<cfif get_class_eval.recordcount>
			<cfif len(get_class_eval.SEMINERE_ILGI)>
				<cfset satir_ort = satir_ort + get_class_eval.SEMINERE_ILGI>
				<cfset counter = counter + 1>
			</cfif> 
			<cfif len(get_class_eval.TARTISMALARA_KATILIM)>
				<cfset satir_ort = satir_ort + get_class_eval.TARTISMALARA_KATILIM>
				<cfset counter = counter + 1>
			</cfif>
			<cfif len(get_class_eval.OGRENME_MOTIVASYONU)>
				<cfset satir_ort = satir_ort + get_class_eval.OGRENME_MOTIVASYONU>
				<cfset counter = counter + 1>
			</cfif>
			<cfif len(get_class_eval.FIKIR_URETME)>
				<cfset satir_ort = satir_ort + get_class_eval.FIKIR_URETME>
				<cfset counter = counter + 1>
			</cfif>
			<cfif len(get_class_eval.YENILIGE_ACIKLIK)>
				<cfset satir_ort = satir_ort + get_class_eval.YENILIGE_ACIKLIK>
				<cfset counter = counter + 1>
			</cfif>
			<cfif len(get_class_eval.KARSI_FIKRE_SAYGI)>
				<cfset satir_ort = satir_ort + get_class_eval.KARSI_FIKRE_SAYGI>
				<cfset counter = counter + 1>
			</cfif>
			<cfif len(get_class_eval.DEGISIME_INANC)>
				<cfset satir_ort = satir_ort + get_class_eval.DEGISIME_INANC>
				<cfset counter = counter + 1>
			</cfif>
			<cfif len(get_class_eval.ILETISIM_BECERISI)>
				<cfset satir_ort = satir_ort + get_class_eval.ILETISIM_BECERISI>
				<cfset counter = counter + 1>
			</cfif>
		</cfif>
		<tr>
			<td nowrap>
			<cfif get_class_eval.recordcount>
				<cfif len(emp_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id#','medium');" class="tableyazi">#ad#</a>
					<input type="hidden" name="EMP_ID_#currentrow#" id="EMP_ID_#currentrow#" value="#EMP_ID#">
				<cfelseif len(con_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#con_id#','medium');" class="tableyazi">#ad#</a>
					<input type="hidden" name="CON_ID_#currentrow#" id="CON_ID_#currentrow#" value="#CON_ID#">
				<cfelseif len(par_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#par_id#','medium');" class="tableyazi">#ad#</a>
					<input type="hidden" name="PAR_ID_#currentrow#" id="PAR_ID_#currentrow#" value="#PAR_ID#">
				</cfif>
			<cfelse>
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
			</cfif>
			</td>
			<td align="center">
				<cfsavecontent variable="message">SEMINERE ILGI İçin aşağıdaki puanları tanımlayınız</cfsavecontent>
				<cfif get_class_eval.recordcount>
					<cfinput type="text" name="SEMINERE_ILGI_#currentrow#" value="#get_class_eval.SEMINERE_ILGI#" style="width:20px;" validate="integer" maxlength="1" message="Seminere İlgi 1 İle 5 Arasında Olmalıdır !" range="1,5">
				<cfelse>
					<cfinput type="text" message="#message#" name="SEMINERE_ILGI_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
				</cfif>
			</td>
			<td align="center">
				<cfsavecontent variable="message">TARTISMALARA KATILIM İçin aşağıdaki puanları tanımlayınız</cfsavecontent>
				<cfif get_class_eval.recordcount>
					<cfinput type="text" name="TARTISMALARA_KATILIM_#currentrow#" value="#get_class_eval.TARTISMALARA_KATILIM#" style="width:20px" validate="integer" message="Tartışmalara Katılım 1 İle 5 Arasında Olmalıdır !" maxlength="1" range="1,5">
				<cfelse>
					<cfinput type="text" message="#message#" name="TARTISMALARA_KATILIM_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
				</cfif>
			</td>
			<td align="center">
				<cfsavecontent variable="message">OGRENME MOTIVASYONU İçin aşağıdaki puanları tanımlayınız</cfsavecontent>
				<cfif get_class_eval.recordcount>
					<cfinput type="text" name="OGRENME_MOTIVASYONU_#currentrow#" value="#get_class_eval.OGRENME_MOTIVASYONU#" style="width:20px" message="Öğrenme Motivasyonu 1 İle 5 Arasında Olmalıdır !" validate="integer" maxlength="1" range="1,5">
				<cfelse>
					<cfinput type="text" message="#message#" name="OGRENME_MOTIVASYONU_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
				</cfif>
			</td>
			<td align="center">
				<cfsavecontent variable="message">FIKIR URETME İçin aşağıdaki puanları tanımlayınız</cfsavecontent>
				<cfif get_class_eval.recordcount>
					<cfinput type="text" name="FIKIR_URETME_#currentrow#" value="#get_class_eval.FIKIR_URETME#" style="width:20px" validate="integer" message="Fikir Üretme 1 İle 5 Arasında Olmalıdır !" maxlength="1" range="1,5">
				<cfelse>
					<cfinput type="text" message="#message#" name="FIKIR_URETME_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
				</cfif>
			</td>
			<td align="center">
				<cfsavecontent variable="message">KARSI FIKRE SAYGI İçin aşağıdaki puanları tanımlayınız</cfsavecontent>
				<cfif get_class_eval.recordcount>
					<cfinput type="text" name="KARSI_FIKRE_SAYGI_#currentrow#" value="#get_class_eval.KARSI_FIKRE_SAYGI#" style="width:20px" validate="integer" message="Karşı fikire Saygı 1 İle 5 Arasında Olmalıdır !" maxlength="1" range="1,5">
				<cfelse>
					<cfinput type="text" message="#message#" name="KARSI_FIKRE_SAYGI_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
				</cfif>
			</td>
			<td align="center">
				<cfsavecontent variable="message">YENILIGE ACIKLIK İçin aşağıdaki puanları tanımlayınız</cfsavecontent>
				<cfif get_class_eval.recordcount>
					<cfinput type="text" name="YENILIGE_ACIKLIK_#currentrow#" value="#get_class_eval.YENILIGE_ACIKLIK#" style="width:20px" message="Yeniliğe Açıklık 1 İle 5 Arasında Olmalıdır !" validate="integer" maxlength="1" range="1,5">
				<cfelse>
					<cfinput type="text" message="#message#" name="YENILIGE_ACIKLIK_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
				</cfif>
			</td>
			<td align="center">
				<cfsavecontent variable="message">DEGISIME_INANC İçin aşağıdaki puanları tanımlayınız</cfsavecontent>
				<cfif get_class_eval.recordcount>
					<cfinput type="text" name="DEGISIME_INANC_#currentrow#" value="#get_class_eval.DEGISIME_INANC#" style="width:20px"  message="Değişime İnanç 1 İle 5 Arasında Olmalıdır !" validate="integer" maxlength="1" range="1,5">
				<cfelse>
					<cfinput type="text" message="#message#" name="DEGISIME_INANC_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
				</cfif>
			</td>
			<td align="center">
				<cfsavecontent variable="message">ILETISIM BECERISI İçin aşağıdaki puanları tanımlayınız</cfsavecontent>
				<cfif get_class_eval.recordcount>
					<cfinput type="text" name="ILETISIM_BECERISI_#currentrow#" value="#get_class_eval.ILETISIM_BECERISI#" style="width:20px" message="İletişim Becerisi 1 İle 5 Arasında Olmalıdır !" validate="integer" maxlength="1" range="1,5">
				<cfelse>
					<cfinput type="text" message="#message#" name="ILETISIM_BECERISI_#currentrow#" value="" style="width:20px;" validate="integer" range="1,5">
				</cfif>
			</td>
			<cfif counter neq 0>
				<cfset satir_ort = satir_ort / counter >
			<cfelse>
				<cfset satir_ort = satir_ort / 1 >
			</cfif>
			<td class="txtbold"><cfif satir_ort gt 0>#TLFormat(satir_ort)#</cfif></td>
			<td rowspan="3">
				<cfif get_class_eval.recordcount>
					<textarea name="NOTE_#currentrow#" id="NOTE_#currentrow#" style="width:350px;height:60px;">#get_class_eval.NOTE#</textarea>
				<cfelse>
					<textarea name="NOTE_#currentrow#" id="NOTE_#currentrow#" style="width:350px;height:60px;"></textarea>
				</cfif>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</cfoutput>
	<tr>
		<td class="txtbold"><cf_get_lang no='383.Ortalama'></td>
		<td class="txtbold" align="center">
		<cfoutput>
			<cfset toplam_seminere_ilgi=0>
			<cfset sayi=0>
			<cfset deger_seminere_ilgi = 0>
			<cfloop query="get_class_attender_eval">
				<cfquery name="get_class_eval_s" datasource="#dsn#">
					SELECT 
						* 
					FROM
						TRAINING_CLASS_ATTENDER_EVAL TCAE
					WHERE
						TCAE.CLASS_ID IS NOT NULL AND
						TCAE.CLASS_ID = #get_class_attender_eval.CLASS_ID# AND
						<cfif len(get_class_attender_eval.EMP_ID)>
							TCAE.EMP_ID = #get_class_attender_eval.EMP_ID#
						<cfelseif len(get_class_attender_eval.PAR_ID)>
							TCAE.PAR_ID = #get_class_attender_eval.PAR_ID#
						<cfelseif len(get_class_attender_eval.CON_ID)>
							TCAE.CON_ID = #get_class_attender_eval.CON_ID#
						</cfif>
				</cfquery>
				<cfif len(get_class_eval_s.seminere_ilgi)>
					<cfset toplam_seminere_ilgi=toplam_seminere_ilgi+get_class_eval_s.seminere_ilgi>
					<cfset sayi=sayi+1>
				</cfif>
			</cfloop>
			<cfif toplam_seminere_ilgi neq 0>
				<cfset deger_seminere_ilgi = toplam_seminere_ilgi/sayi>
				#TLFormat(deger_seminere_ilgi)#
			</cfif>
		</td>
		<td class="txtbold" align="center">
			<cfset toplam_tartismalara_katilim=0>
			<cfset sayi=0>
			<cfloop query="get_class_attender_eval">
				<cfquery name="get_class_eval_t" datasource="#dsn#">
					SELECT 
						* 
					FROM
						TRAINING_CLASS_ATTENDER_EVAL TCAE
					WHERE
						TCAE.CLASS_ID IS NOT NULL AND
						TCAE.CLASS_ID = #get_class_attender_eval.CLASS_ID# AND
						<cfif len(get_class_attender_eval.EMP_ID)>
							TCAE.EMP_ID = #get_class_attender_eval.EMP_ID#
						<cfelseif len(get_class_attender_eval.PAR_ID)>
							TCAE.PAR_ID = #get_class_attender_eval.PAR_ID#
						<cfelseif len(get_class_attender_eval.CON_ID)>
							TCAE.CON_ID = #get_class_attender_eval.CON_ID#
						</cfif>
					</cfquery>
				<cfif len(get_class_eval_t.tartismalara_katilim)>
				<cfset toplam_tartismalara_katilim=toplam_tartismalara_katilim+#get_class_eval_t.tartismalara_katilim#>
				<cfset sayi=sayi+1>
				</cfif>
			</cfloop>
			<cfif sayi neq 0>
				<cfset deger_tartismalara_katilim=#toplam_tartismalara_katilim#/#sayi#>
				#TLFormat(deger_tartismalara_katilim)#
			</cfif>
		</td>
		<td class="txtbold" align="center">
			<cfset toplam_OGRENME_MOTIVASYONU=0>
			<cfset sayi=0>
			<cfloop query="get_class_attender_eval">
				<cfquery name="get_class_eval_o" datasource="#dsn#">
						SELECT 
							* 
						FROM
							TRAINING_CLASS_ATTENDER_EVAL TCAE
						WHERE
							TCAE.CLASS_ID IS NOT NULL AND
							TCAE.CLASS_ID = #get_class_attender_eval.CLASS_ID# AND
							<cfif len(get_class_attender_eval.EMP_ID)>
								TCAE.EMP_ID = #get_class_attender_eval.EMP_ID#
							<cfelseif len(get_class_attender_eval.PAR_ID)>
								TCAE.PAR_ID = #get_class_attender_eval.PAR_ID#
							<cfelseif len(get_class_attender_eval.CON_ID)>
								TCAE.CON_ID = #get_class_attender_eval.CON_ID#
							</cfif>
					</cfquery>
				<cfif len(get_class_eval_o.OGRENME_MOTIVASYONU)>
				<cfset toplam_OGRENME_MOTIVASYONU=toplam_OGRENME_MOTIVASYONU+#get_class_eval_o.OGRENME_MOTIVASYONU#>
				<cfset sayi=sayi+1>
				</cfif>
			</cfloop>
			<cfif sayi neq 0>
				<cfset deger_OGRENME_MOTIVASYONU=#toplam_OGRENME_MOTIVASYONU#/#sayi#>
				#TLFormat(deger_OGRENME_MOTIVASYONU)#
			</cfif>
		</td>
		<td class="txtbold" align="center">
			<cfset toplam_FIKIR_URETME=0>
			<cfset sayi=0>
			<cfloop query="get_class_attender_eval">
				<cfquery name="get_class_eval_f" datasource="#dsn#">
					SELECT 
						* 
					FROM
						TRAINING_CLASS_ATTENDER_EVAL TCAE
					WHERE
						TCAE.CLASS_ID IS NOT NULL AND
						TCAE.CLASS_ID = #get_class_attender_eval.CLASS_ID# AND
						<cfif len(get_class_attender_eval.EMP_ID)>
							TCAE.EMP_ID = #get_class_attender_eval.EMP_ID#
						<cfelseif len(get_class_attender_eval.PAR_ID)>
							TCAE.PAR_ID = #get_class_attender_eval.PAR_ID#
						<cfelseif len(get_class_attender_eval.CON_ID)>
							TCAE.CON_ID = #get_class_attender_eval.CON_ID#
						</cfif>
				</cfquery>
				<cfif len(get_class_eval_f.FIKIR_URETME)>
				<cfset toplam_FIKIR_URETME=toplam_FIKIR_URETME+#get_class_eval_f.FIKIR_URETME#>
				<cfset sayi=sayi+1>
				</cfif>
			</cfloop>
			<cfif sayi neq 0>				
				<cfset deger_FIKIR_URETME=#toplam_FIKIR_URETME#/#sayi#>
				#TLFormat(deger_FIKIR_URETME)#
			</cfif>	
		</td>
		<td class="txtbold" align="center">
			<cfset toplam_KARSI_FIKRE_SAYGI=0>
			<cfset sayi=0>
			<cfloop query="get_class_attender_eval">
				<cfquery name="get_class_eval_k" datasource="#dsn#">
					SELECT 
						* 
					FROM
						TRAINING_CLASS_ATTENDER_EVAL TCAE
					WHERE
						TCAE.CLASS_ID IS NOT NULL AND
						TCAE.CLASS_ID = #get_class_attender_eval.CLASS_ID# AND
						<cfif len(get_class_attender_eval.EMP_ID)>
							TCAE.EMP_ID = #get_class_attender_eval.EMP_ID#
						<cfelseif len(get_class_attender_eval.PAR_ID)>
							TCAE.PAR_ID = #get_class_attender_eval.PAR_ID#
						<cfelseif len(get_class_attender_eval.CON_ID)>
							TCAE.CON_ID = #get_class_attender_eval.CON_ID#
						</cfif>
				</cfquery>
				<cfif len(get_class_eval_k.KARSI_FIKRE_SAYGI)>
				<cfset toplam_KARSI_FIKRE_SAYGI=toplam_KARSI_FIKRE_SAYGI+#get_class_eval_k.KARSI_FIKRE_SAYGI#>
				<cfset sayi=sayi+1>
				</cfif>
			</cfloop>
			<cfif sayi neq 0>	
				<cfset deger_KARSI_FIKRE_SAYGI=#toplam_KARSI_FIKRE_SAYGI#/#sayi#>
				#TLFormat(deger_KARSI_FIKRE_SAYGI)#
			</cfif>
		</td>
		<td class="txtbold" align="center">
			<cfoutput>
				<cfset toplam_YENILIGE_ACIKLIK=0>
				<cfset sayi=0>
				<cfloop query="get_class_attender_eval">
					<cfquery name="get_class_eval_y" datasource="#dsn#">
						SELECT 
							* 
						FROM
							TRAINING_CLASS_ATTENDER_EVAL TCAE
						WHERE
							TCAE.CLASS_ID IS NOT NULL AND
							TCAE.CLASS_ID = #get_class_attender_eval.CLASS_ID# AND
							<cfif len(get_class_attender_eval.EMP_ID)>
								TCAE.EMP_ID = #get_class_attender_eval.EMP_ID#
							<cfelseif len(get_class_attender_eval.PAR_ID)>
								TCAE.PAR_ID = #get_class_attender_eval.PAR_ID#
							<cfelseif len(get_class_attender_eval.CON_ID)>
								TCAE.CON_ID = #get_class_attender_eval.CON_ID#
							</cfif>
					</cfquery>
					<cfif len(get_class_eval_y.YENILIGE_ACIKLIK)>
					<cfset toplam_YENILIGE_ACIKLIK=toplam_YENILIGE_ACIKLIK+#get_class_eval_y.YENILIGE_ACIKLIK#>
					<cfset sayi=sayi+1>
					</cfif>
				</cfloop>
				<cfif sayi neq 0>	
				<cfset deger_YENILIGE_ACIKLIK=#toplam_YENILIGE_ACIKLIK#/#sayi#>
				#TLFormat(deger_YENILIGE_ACIKLIK)#
				</cfif>
			</cfoutput>
		</td>
		<td class="txtbold" align="center">
			<cfset toplam_DEGISIME_INANC=0>
			<cfset sayi=0>
			<cfloop query="get_class_attender_eval">
				<cfquery name="get_class_eval_d" datasource="#dsn#">
					SELECT 
						* 
					FROM
						TRAINING_CLASS_ATTENDER_EVAL TCAE
					WHERE
						TCAE.CLASS_ID IS NOT NULL AND
						TCAE.CLASS_ID = #get_class_attender_eval.CLASS_ID# AND
						<cfif len(get_class_attender_eval.EMP_ID)>
							TCAE.EMP_ID = #get_class_attender_eval.EMP_ID#
						<cfelseif len(get_class_attender_eval.PAR_ID)>
							TCAE.PAR_ID = #get_class_attender_eval.PAR_ID#
						<cfelseif len(get_class_attender_eval.CON_ID)>
							TCAE.CON_ID = #get_class_attender_eval.CON_ID#
						</cfif>
				</cfquery>
				<cfif len(get_class_eval_d.DEGISIME_INANC)>
				<cfset toplam_DEGISIME_INANC=toplam_DEGISIME_INANC+#get_class_eval_d.DEGISIME_INANC#>
				<cfset sayi=sayi+1>
				</cfif>
			</cfloop>
			<cfif sayi neq 0>
				<cfset deger_DEGISIME_INANC=#toplam_DEGISIME_INANC#/#sayi#>
				#TLFormat(deger_DEGISIME_INANC)#
			</cfif>	
		</td>
		<td class="txtbold" align="center">
			<cfset toplam_ILETISIM_BECERISI=0>
			<cfset sayi=0>
			<cfloop query="get_class_attender_eval">
				<cfquery name="get_class_eval_i" datasource="#dsn#">
					SELECT 
						* 
					FROM
						TRAINING_CLASS_ATTENDER_EVAL TCAE
					WHERE
						TCAE.CLASS_ID IS NOT NULL AND
						TCAE.CLASS_ID = #get_class_attender_eval.CLASS_ID# AND
						<cfif len(get_class_attender_eval.EMP_ID)>
							TCAE.EMP_ID = #get_class_attender_eval.EMP_ID#
						<cfelseif len(get_class_attender_eval.PAR_ID)>
							TCAE.PAR_ID = #get_class_attender_eval.PAR_ID#
						<cfelseif len(get_class_attender_eval.CON_ID)>
							TCAE.CON_ID = #get_class_attender_eval.CON_ID#
						</cfif>
				</cfquery>
				<cfif len(get_class_eval_i.ILETISIM_BECERISI)>
				<cfset toplam_ILETISIM_BECERISI=toplam_ILETISIM_BECERISI+#get_class_eval_i.ILETISIM_BECERISI#>
				<cfset sayi=sayi+1>
				</cfif>
			</cfloop>
			<cfif sayi neq 0>
				<cfset deger_ILETISIM_BECERISI=#toplam_ILETISIM_BECERISI#/#sayi#>
				#TLFormat(deger_ILETISIM_BECERISI)#
			</cfif>	
		</td>
	</cfoutput>
	</tr>
	<tr>
		<td class="txtbold" height="20" colspan="10" style="text-align:right;">
			1 = <cf_get_lang no='233.Çok Zayıf'>&nbsp;&nbsp;&nbsp;
			2 = <cf_get_lang no='234.Zayıf'>&nbsp;&nbsp;&nbsp;
			3 = <cf_get_lang_main no='516.Orta'>&nbsp;&nbsp;&nbsp;
			4 = <cf_get_lang no='236.İyi'>&nbsp;&nbsp;&nbsp;
			5 = <cf_get_lang no='237.Çok İyi'>
		</td>
	</tr>			
	</cfif>
</table>
<cf_popup_box_footer>
	<cf_record_info query_name="get_attender_eval">
	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=training_management.emptypopup_del_class_attender_eval&class_id=#attributes.class_id#'>
</cf_popup_box_footer>			
</cfform>
</cf_popup_box>
