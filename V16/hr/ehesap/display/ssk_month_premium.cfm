<cf_get_lang_set module_name="ehesap"><!--- sayfanin en altinda kapanisi var --->
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
	<cfparam name="attributes.ssk_statute" default="1">
	<cfparam name="attributes.puantaj_type" default="-1">
	<cfparam name="attributes.kanun" default="0000">
	<cfparam name="attributes.sal_year" default="#year(now())#">
	<cfif not isDefined("attributes.printme")>
		<cfinclude template="../query/get_ssk_offices.cfm">
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="53814.Aylık SGK Bordrosu"></cfsavecontent>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box title="#getlang('','SGK Aylık Bildirgesi','32105')#">
				<cfform name="employee" method="post">
					<cf_box_search title="#message#">
						<div class="form-group"> 
							<cf_get_lang dictionary_id="57789.Özel Kod">			                  
							<input type="text" name="hierarchy" id="hierarchy" maxlength="50" value="<cfif isdefined("attributes.hierarchy")><cfoutput>#attributes.hierarchy#</cfoutput></cfif>" style="width:65px;">
						</div>
						<div class="form-group"> 
							<select name="SSK_OFFICE" id="SSK_OFFICE">
								<cfoutput query="GET_SSK_OFFICES">
								<cfif len(ssk_office) and len(ssk_no)>
								<option value="#ssk_office#-#ssk_no#-#branch_id#"<cfif isdefined("attributes.ssk_office") and (attributes.ssk_office is "#ssk_office#-#ssk_no#-#branch_id#")> selected</cfif>>#branch_name#-#ssk_office#-#ssk_no#</option>
								</cfif>
								</cfoutput>
							</select>
						</div>
						<div class="form-group"> 
							<select name="sal_mon" id="sal_mon">
								<cfloop from="1" to="12" index="i">
									<cfoutput>
									<option value="#i#"<cfif isdefined("attributes.sal_mon") and (i eq attributes.sal_mon)> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
									</cfoutput>
								</cfloop>
							</select>
						</div>
						<div class="form-group"> 
							<select name="sal_year" id="sal_year">
									<option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
									<cfloop from="-3" to="3" index="i">
											<cfoutput><option value="#year(now()) + i#"<cfif attributes.sal_year eq (year(now()) + i)> selected</cfif>>#year(now()) + i#</option></cfoutput>
									</cfloop>
							</select>
						</div>
						<div class="form-group">
							<cf_wrk_search_button button_type="4">
							
						</div>
						<cfif isdefined("attributes.ssk_office")>
							<div class="form-group">
								<a class="ui-btn ui-btn-gray" href="#" onClick="javascript:document.send.submit();"><i class="fa fa-print fa-2x" title="<cf_get_lang dictionary_id='58743.Gönder'>"></i></a>
							</div>
						</cfif>
					</cf_box_search>
					<cf_box_search_detail>
						<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group">
								<select name="ssk_statute" id="ssk_statute" style="width:200px;">
									<option value="1" <cfif attributes.ssk_statute eq 1>selected</cfif>><cf_get_lang dictionary_id ='53043.Normal'></option>
									<option value="2" <cfif attributes.ssk_statute eq 2>selected</cfif>><cf_get_lang dictionary_id ='58541.Emekli'></option>
									<option value="3" <cfif attributes.ssk_statute eq 3>selected</cfif>><cf_get_lang dictionary_id ='54076.Stajyer Öğrenci'></option>
									<option value="4" <cfif attributes.ssk_statute eq 4>selected</cfif>><cf_get_lang dictionary_id ='54077.Çırak'></option>
									<option value="75" <cfif attributes.ssk_statute eq 75>selected</cfif>><cf_get_lang dictionary_id ='54078.Mesleki Stajyer'></option>
									<option value="5" <cfif attributes.ssk_statute eq 5>selected</cfif>><cf_get_lang dictionary_id ='54079.Anlaşmaya Tabi Olmayan Yabancı'></option>
									<option value="6" <cfif attributes.ssk_statute eq 6>selected</cfif>><cf_get_lang dictionary_id ='54080.Anlaşmalı Ülke Yabancı Uyruk'></option>
									<option value="7" <cfif attributes.ssk_statute eq 7>selected</cfif>><cf_get_lang dictionary_id ='54081.Deniz,Basım,Azot,Şeker'></option>
									<option value="8" <cfif attributes.ssk_statute eq 8>selected</cfif>><cf_get_lang dictionary_id ='54082.Yeraltı Sürekli'></option>
									<option value="9" <cfif attributes.ssk_statute eq 9>selected</cfif>><cf_get_lang dictionary_id ='54083.Yeraltı Gruplu'></option>
									<option value="10" <cfif attributes.ssk_statute eq 10>selected</cfif>><cf_get_lang dictionary_id ='54084.Yerüstü Gruplu'></option>
									<option value="11" <cfif attributes.ssk_statute eq 11>selected</cfif>><cf_get_lang dictionary_id ='54127.YÖK Kısmi İstihdam Öğrenci'></option>
									<option value="12" <cfif attributes.ssk_statute eq 12>selected</cfif>><cf_get_lang dictionary_id ='58542.Aylık Sigorta Prim İşsizlik Hariç'></option>
									<option value="13" <cfif attributes.ssk_statute eq 13>selected</cfif>><cf_get_lang dictionary_id ='54129.LIBYA'></option>
									<option value="14" <cfif attributes.ssk_statute eq 14>selected</cfif>><cf_get_lang dictionary_id ='54130.2098 Sayılı Kanun İşsizlik Hariç'></option>
									<option value="15" <cfif attributes.ssk_statute eq 15>selected</cfif>><cf_get_lang dictionary_id ='54131.2098 Görevli Malül. Aylığı Alanlar'></option>
									<option value="16" <cfif attributes.ssk_statute eq 16>selected</cfif>><cf_get_lang dictionary_id ='54085.Görev Malüllük Aylığı Alanlar'></option>
									<option value="17" <cfif attributes.ssk_statute eq 17>selected</cfif>><cf_get_lang dictionary_id ='54086.İş Kazası Mes Hast Analık ve Hast  Sig  Tabi'></option>
									<option value="50" <cfif attributes.ssk_statute eq 50>selected</cfif>><cf_get_lang dictionary_id ='53955.Emekli Sandığı'></option>
									<option value="60" <cfif attributes.ssk_statute eq 60>selected</cfif>><cf_get_lang dictionary_id ='54087.Banka ve Diğerleri'></option>
									<option value="70" <cfif attributes.ssk_statute eq 70>selected</cfif>><cf_get_lang dictionary_id ='54084.Yerüstü Gruplu'> <cf_get_lang dictionary_id='53956.Bağ-kur'></option>
									<option value="71" <cfif attributes.ssk_statute eq 71>selected</cfif>><cf_get_lang dictionary_id ='54088.Yabancı Uyruk Özel Anlaşma'></option>
									<option value="72" <cfif attributes.ssk_statute eq 72>selected</cfif>><cf_get_lang dictionary_id ='54089.Nöbetçi Doktor'></option>
									<option value="73" <cfif attributes.ssk_statute eq 73>selected</cfif>><cf_get_lang dictionary_id ='54090.Ders Saati Ücretliler'></option>
									<option value="74" <cfif attributes.ssk_statute eq 74>selected</cfif>><cf_get_lang dictionary_id ='54091.Sabit Ücretliler'></option>
									<option value="21" <cfif attributes.ssk_statute eq 21>selected</cfif>><cf_get_lang dictionary_id ='54295.Sözleşmesiz Ülkelere Götürülerek Çalıştırılanlar'></option>
									<option value="32" <cfif attributes.ssk_statute eq 32>selected</cfif>><cf_get_lang dictionary_id ='59474.Tüm sigorta kollarına tabi çalışıp 90 gün fiili hizmet süresi zammına tabi çalışanlar'></option>
									<option value="23" <cfif attributes.ssk_statute eq 23>selected</cfif>><cf_get_lang dictionary_id ='54084.Harp/Vazife Malülü-Kısa Vd. Sig.Koll. Tabi olanlar'></option>
									<option value="33" <cfif attributes.ssk_statute eq 23>selected</cfif>><cf_get_lang dictionary_id='63737.5434 Sayılı Kanuna Tabi Çalışan'></option>
								</select>
							</div>
						</div>
						<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group">
								<select name="kanun" id="kanun">
									<option value="0000" <cfif attributes.kanun is '0000'>selected</cfif>>0000</option>
									<option value="5510" <cfif attributes.kanun is '5510'>selected</cfif>>5510</option>
									<option value="25510" <cfif attributes.kanun is '25510'>selected</cfif>>25510</option>
									<option value="5921" <cfif attributes.kanun is '5921'>selected</cfif>>5921</option>
									<option value="6111" <cfif attributes.kanun is '6111'>selected</cfif>>6111</option>
									<option value="5084" <cfif attributes.kanun is '5084'>selected</cfif>>5084</option>
									<option value="16322" <cfif attributes.kanun is '16322'>selected</cfif>>16322</option>
									<option value="26322" <cfif attributes.kanun is '26322'>selected</cfif>>26322</option>
									<option value="46486" <cfif attributes.kanun is '46486'>selected</cfif>>46486</option>
									<option value="56486" <cfif attributes.kanun is '56486'>selected</cfif>>56486</option>
									<option value="66486" <cfif attributes.kanun is '66486'>selected</cfif>>66486</option>
									<option value="06486" <cfif attributes.kanun is '06486'>selected</cfif>>06486</option>
									<option value="6645" <cfif attributes.kanun is '6645'>selected</cfif>>6645</option>
									<option value="0687" <cfif attributes.kanun is '0687'>selected</cfif>>0687</option>
									<option value="17103" <cfif attributes.kanun is '17103'>selected</cfif>>17103</option>
									<option value="27103" <cfif attributes.kanun is '27103'>selected</cfif>>27103</option>
									<option value="37103" <cfif attributes.kanun is '37103'>selected</cfif>>37103</option>
									<option value="04857" <cfif attributes.kanun is '04857'>selected</cfif>>04857</option>
									<option value="14857" <cfif attributes.kanun is '14857'>selected</cfif>>14857</option>
									<option value="14447" <cfif attributes.kanun is '14447'>selected</cfif>>14447</option>
									<option value="84447" <cfif attributes.kanun is '84447'>selected</cfif>>84447</option>
									<option value="64447" <cfif attributes.kanun is '64447'>selected</cfif>>64447</option>
									<option value="44447" <cfif attributes.kanun is '44447'>selected</cfif>>44447</option>
									<option value="24447" <cfif attributes.kanun is '24447'>selected</cfif>>24447</option>
									<option value="85615" <cfif attributes.kanun is '85615'>selected</cfif>>85615</option>
									<option value="05615" <cfif attributes.kanun is '05615'>selected</cfif>>05615</option>
									<option value="05746" <cfif attributes.kanun is '05746'>selected</cfif>>05746</option>
									<option value="04691" <cfif attributes.kanun is '04691'>selected</cfif>>04691</option>
									<option value="7252" <cfif attributes.kanun is '7252'>selected</cfif>>7252</option>
									<option value="17256" <cfif attributes.kanun is '17256'>selected</cfif>>17256</option>
									<option value="27256" <cfif attributes.kanun is '27256'>selected</cfif>>27256</option>
									<option value="3294" <cfif attributes.kanun is '3294'>selected</cfif>>3294</option>
								</select>
							</div>
						</div>
					</cf_box_search_detail>
				</cfform>
			</cf_box>
		</div>
	</cfif>
	
	<cfif not isdefined("attributes.ssk_office")>
		<cfexit method="exittemplate">
	</cfif>
	
	<cfinclude template="../query/get_aylik.cfm">
	<cfinclude template="../query/get_ssk_monthly_premium.cfm">
	<cfif NOT GET_INSURANCE_RATIO.RECORDCOUNT>
		<script type="text/javascript">
			alert("#dateformat(last_month_1,dateformat_style)# - #dateformat(last_month_30,dateformat_style)# <cf_get_lang dictionary_id ='53819.aralığında geçerli SSK Çarpanları Tanımlı Değil'> !");
			history.back();
		</script>
		<cfexit method="exittemplate">
	</cfif>
	
	<cfset page_ = 1>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<form name="send" method="post" action=""> 
				<cfif isdefined("attributes.sal_mon")><input type="hidden" value="<cfoutput>#attributes.sal_mon#</cfoutput>" name="sal_mon" id="sal_mon"></cfif>
				<cfif isdefined("attributes.ssk_statute")><input type="hidden" value="<cfoutput>#attributes.ssk_statute#</cfoutput>" name="ssk_statute" id="ssk_statute"></cfif>
				<cfif isdefined("attributes.ssk_office")><input type="hidden" value="<cfoutput>#attributes.ssk_office#</cfoutput>" name="ssk_office" id="ssk_office"></cfif>
				<cfif isdefined("attributes.salary_year")><input type="hidden" value="<cfoutput>#attributes.salary_year#</cfoutput>" name="salary_year" id="salary_year"></cfif>
				<cfif isdefined("attributes.sal_year")><input type="hidden" value="<cfoutput>#attributes.sal_year#</cfoutput>" name="sal_year" id="sal_year"></cfif>
				<cfif isdefined("attributes.hierarchy")><input type="hidden" value="<cfoutput>#attributes.hierarchy#</cfoutput>" name="hierarchy" id="hierarchy"></cfif>
				<cfif isdefined("attributes.kanun")><input type="hidden" value="<cfoutput>#attributes.kanun#</cfoutput>" name="kanun" id="kanun"></cfif>
				<input type="hidden" value="1" name="printme" id="printme">
				<cfif get_puantaj_rows.recordcount lte 7>
					<cfset to_count = 1>
				<cfelse>
					<cfset to_count = ceiling((get_puantaj_rows.recordcount-7)/25)+1>
				</cfif>
				<cfset gun_1_last_page = 0>
				<cfset gun_2_last_page = 0>
				<cfset pek_1_last_page = 0>
				<cfset pek_2_last_page = 0>
				<cfset odenek1_last_page = 0>
				<cfset odenek2_last_page = 0>
				<cfset uigun_1_last_page = 0>
				<cfset uigun_2_last_page = 0>
				<cfset izin_ucret_1_last_page = 0>
				<cfset izin_ucret_2_last_page = 0>
				<cfset ssk_1_last_page = 0>
				<cfset ssk_2_last_page = 0>
				<cfloop from="1" to="#to_count#" index="j">
					<table style="height:350mm;" border="0" cellspacing="0" cellpadding="0"><!--- width:197mm; --->
						<tr>
							<td valign="top">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td>
							<table width="98%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td valign="top">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td style="width:55mm;" align="center">
												<SPAN class="printbold"><cf_get_lang dictionary_id="45795.T.C."><br/><cf_get_lang dictionary_id="30489.Sosyal Güvenlik Kurumu"><br/><cf_get_lang dictionary_id="59476.Aylık Prim ve Hizmet Belgesi"><br/>(<cf_get_lang dictionary_id="59477.4/a sigortalıları için">)</SPAN>
												<strong></strong>
												</td>
												<td align="center">	
													<table cellspacing="0" cellpadding="0" border="1" style="border : thin solid cccccc;" class="print">
														<tr align="center">
															<td colspan="26" class="formbold"><cf_get_lang dictionary_id ='53823.İŞYERİ SİCİL NO'></td>
														</tr>
														<tr align="center" class="printbold">
															<td rowspan="2" style="width:5mm;">M</td>
															<td colspan="4" rowspan="2" style="width:20mm;"><cf_get_lang dictionary_id ='53824.İş Kolu Kodu'></td>
															<td colspan="4" align="center" style="width:20mm;"><cf_get_lang dictionary_id ='53825.Ünite Kodu'></td>
															<td colspan="7" rowspan="2" style="width:35mm;"><cf_get_lang dictionary_id ='53826.İşyeri Sıra Numarası'></td>
															<td colspan="3" rowspan="2" style="width:15mm;"><cf_get_lang dictionary_id ='53827.İl Kodu'></td>
															<td colspan="2" rowspan="2" style="width:10mm;"><cf_get_lang dictionary_id ='53828.İlçe Kodu'></td>
															<td colspan="2" rowspan="2" style="width:10mm;"><cf_get_lang dictionary_id ='53829.Kontrol Numarası'></td>
															<td colspan="3" rowspan="2" style="width:15mm;"><cf_get_lang dictionary_id ='59478.Alt işv.'></td>
														</tr>
														<tr class="txtbold">
															<td colspan="2" align="center"><cf_get_lang dictionary_id ='58674.Yeni'></td>
															<td colspan="2" align="center"><cf_get_lang dictionary_id ='53832.Eski'></td>
														</tr>
														<cfoutput>
															<tr align="center">
																<td width="25">&nbsp;#get_branch_info.ssk_m#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_JOB,1,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_JOB,2,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_JOB,3,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_JOB,4,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_BRANCH,1,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_BRANCH,2,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_BRANCH_OLD,1,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_BRANCH_OLD,2,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_NO,1,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_NO,2,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_NO,3,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_NO,4,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_NO,5,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_NO,6,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_NO,7,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_CITY,1,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_CITY,2,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_CITY,3,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_COUNTRY,1,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_COUNTRY,2,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_CD,1,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_CD,2,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_AGENT,1,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_AGENT,2,1)#</td>
																<td width="25">&nbsp;#mid(get_branch_info.SSK_AGENT,3,1)#</td>
															</tr>
														</cfoutput>
													</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td><br/>
										<table cellspacing="0" cellpadding="0" border="1" style="border : thin solid cccccc;" width="100%" class="print">
											<tr>
												<td>&nbsp;</td>
												<td align="center"><cf_get_lang dictionary_id="53833.İŞVERENİN"></td>
												<td align="center"><cf_get_lang dictionary_id="59479.ALT İŞVERENİN">
													<input type="checkbox" name="checkbox32" id="checkbox32" value="checkbox"><cf_get_lang dictionary_id ='53835.SİGORTALIYA DEVİR ALANININ'>
													<input type="checkbox" name="checkbox33" id="checkbox33" value="checkbox"></td>
											</tr>
											<tr>
												<td style="height:8mm" class="txtbold"><cf_get_lang dictionary_id ='57570.Adı ve Soyadı'>/<cf_get_lang dictionary_id ='57571.Ünvanı'></td>
												<td>&nbsp;<cfoutput><strong>#get_branch_info.BRANCH_FULLNAME#</strong></cfoutput></td>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td style="height:14mm" class="txtbold"><cf_get_lang dictionary_id='58723.Adres'></td>
												<td>
													<cfoutput>
														<table width="98%" height="100%" border="0" cellpadding="0" cellspacing="0">
															<tr>
																<td colspan="4" Style="height:8mm">&nbsp;#get_branch_info.BRANCH_ADDRESS#</td>
															</tr>
															<tr>
																<td Style="width:8mm" class="txtbold"><cf_get_lang dictionary_id='58132.Semt'></td>
																<td Style="width:30mm">&nbsp;</td>
																<td Style="width:10mm" class="txtbold"><cf_get_lang dictionary_id='58638.İlçe'></td>
																<td>&nbsp;#get_branch_info.BRANCH_COUNTY#</td>
															</tr>
															<tr>
																<td class="txtbold"><cf_get_lang dictionary_id='57971.Şehir'></td>
																<td>&nbsp;#get_branch_info.BRANCH_CITY#</td>
																<td class="txtbold"><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
																<td>&nbsp;#get_branch_info.BRANCH_POSTCODE#</td>
															</tr>
														</table>
													</cfoutput>
												</td>
												<td>
													<table width="98%" height="100%" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td colspan="4" Style="height:8mm">&nbsp;</td>
														</tr>
														<tr>
															<td Style="width:8mm" class="txtbold"><cf_get_lang dictionary_id='58132.Semt'></td>
															<td Style="width:30mm">&nbsp;</td>
															<td Style="width:10mm" class="txtbold"><cf_get_lang dictionary_id='58638.İlçe'></td>
															<td>&nbsp;</td>
														</tr>
														<tr>
															<td class="txtbold"><cf_get_lang dictionary_id='57971.Şehir'></td>
															<td>&nbsp;</td>
															<td class="txtbold"><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
															<td>&nbsp;</td>
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td style="height:4mm" class="txtbold"><cf_get_lang dictionary_id ='57499.Telefon'> / <cf_get_lang dictionary_id ='57428.E-Mail'> </td>
												<td>&nbsp;<cfoutput>(#get_branch_info.BRANCH_TELCODE#) #get_branch_info.BRANCH_TEL1#</cfoutput></td>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td style="height:4mm" class="txtbold"><cf_get_lang dictionary_id ='58025.TC Kimlik No'>-<cf_get_lang dictionary_id ='53839.Vergi Sicil'>/<cf_get_lang dictionary_id='58627.Kimlik No'></td>
												<td>&nbsp;
													<cfoutput>
														<cfif len(get_branch_info.BRANCH_TAX_NO)>#get_branch_info.BRANCH_TAX_OFFICE# - #get_branch_info.BRANCH_TAX_NO#<cfelseif len(get_company_info.TAX_NO)>#get_company_info.TAX_OFFICE# - #get_company_info.TAX_NO#</cfif>
													</cfoutput>
												</td>
												<td>&nbsp;</td>
											</tr>
										</table>
									</td>
									</tr>
								</table>
							</td>
							<td style="width:45mm;" valign="top" height="100%">
								<table cellspacing="0" cellpadding="0" border="1" style="border : thin solid cccccc;" width="100%" height="100%" class="print">
									<tr class="formbold">
										<td style="text-align:right;" colspan="3"><cf_get_lang dictionary_id="32589.EK">:9</td>
									</tr>
									<tr align="center" class="formbold">
										<td colspan="3"><cf_get_lang dictionary_id ='53842.BELGENİN'></td>
									</tr>
									<tr>
										<td rowspan="2"><cf_get_lang dictionary_id ='53843.Ait Olduğu'></td>
										<td><cf_get_lang dictionary_id='58455.Yıl'></td>
										<td><cfoutput>#attributes.sal_year#</cfoutput></td>
									</tr>
									<tr>
										<td>Ay</td>
										<td><cfoutput>#attributes.sal_mon#</cfoutput></td>
									</tr>
									<tr>
										<td><cf_get_lang dictionary_id ='53846.Mahiyeti'></td>
										<td colspan="2" nowrap><cf_get_lang dictionary_id ='53847.Asıl'><input type="checkbox" name="checkbox" id="checkbox" value="checkbox">
											<cf_get_lang dictionary_id ='32589.Ek'><input type="checkbox" name="checkbox2" id="checkbox2" value="checkbox">
											<cf_get_lang dictionary_id ='58506.İptal'><input type="checkbox" name="checkbox3" id="checkbox3" value="checkbox"></td>
										</tr>
									<tr>
										<td colspan="2"><cf_get_lang dictionary_id='58578.Belge Türü'></td>
										<td>&nbsp;
											<cfif attributes.ssk_statute eq 1>01
											<cfelseif attributes.ssk_statute eq 2>02
											<cfelseif attributes.ssk_statute eq 3>07
											<cfelseif attributes.ssk_statute eq 4>07
											<cfelseif attributes.ssk_statute eq 75>07
											<cfelseif attributes.ssk_statute eq 5>10
											<cfelseif attributes.ssk_statute eq 6>15
											<cfelseif attributes.ssk_statute eq 7>01
											<cfelseif attributes.ssk_statute eq 8>01
											<cfelseif attributes.ssk_statute eq 9>01
											<cfelseif attributes.ssk_statute eq 10>01
											<cfelseif attributes.ssk_statute eq 11>01
											<cfelseif attributes.ssk_statute eq 12>13
											<cfelseif attributes.ssk_statute eq 13>01
											<cfelseif attributes.ssk_statute eq 14>01
											<cfelseif attributes.ssk_statute eq 15>01
											<cfelseif attributes.ssk_statute eq 16>01
											<cfelseif attributes.ssk_statute eq 17>01
											<cfelseif attributes.ssk_statute eq 50>01
											<cfelseif attributes.ssk_statute eq 60>01
											<cfelseif attributes.ssk_statute eq 70>01
											<cfelseif attributes.ssk_statute eq 71>15
											<cfelseif attributes.ssk_statute eq 72>01
											<cfelseif attributes.ssk_statute eq 73>01
											<cfelseif attributes.ssk_statute eq 74>01</cfif>
										</td>
									</tr>
									<tr>
										<td colspan="2"><cf_get_lang dictionary_id ='53851.Düzenlenmesine Esas Kanun No'></td>
										<td>&nbsp;<cfoutput>#attributes.kanun#</cfoutput></td>
									</tr>
									<tr>
										<td colspan="2"><cf_get_lang dictionary_id ='53852.Toplam Sayfa Sayısı'></td>
										<td>&nbsp;<cfoutput>#ceiling((get_puantaj_rows.recordcount-7)/25)+1#</cfoutput></td>
									</tr>
									<tr>
										<td colspan="2"><cf_get_lang dictionary_id ='53685.Sayfa No'></td>
										<td>&nbsp;<cfoutput>#page_#</cfoutput></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<cfif page_ eq 1>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr align="center">
								<td colspan="3" class="formbold">1 - <cf_get_lang dictionary_id ='53853.TÜM SAYILARA AİT TOPLAM BİLGİLER'></td>
							</tr>
							<tr>
								<td Style="width:70mm">
									<table cellspacing="0" cellpadding="0" border="1" style="border : thin solid cccccc;" class="print">
										<tr align="center" class="formbold">
											<td colspan="3"><cf_get_lang dictionary_id ='53854.TOPLAM SİGORTALI BİLGİLERİ'></td>
											</tr>
										<tr>
											<td colspan="2"><cf_get_lang dictionary_id ='53855.Sigortalı Sayısı'></td>
											<td>&nbsp;<cfoutput><cfif (get_puantaj_rows.recordcount)>#get_puantaj_rows.recordcount#<cfelse>0</cfif></cfoutput></td>
										</tr>
										<tr>
											<td colspan="2"><cf_get_lang dictionary_id ='53856.Prim Ödeme Gün Sayısı'></td>
											<td>&nbsp;<cfoutput><cfif len(C5)>#C5#<cfelse>0</cfif></cfoutput></td>
										</tr>
										<tr>
											<td rowspan="2" Style="width:24mm;"><cf_get_lang dictionary_id ='53857.Ay İçinde'></td>
											<td><cf_get_lang dictionary_id ='53858.İşe Girenler'></td>
											<td Style="width:32mm">&nbsp;<cfoutput><cfif (C2.RECORDCOUNT)>#C2.RECORDCOUNT#<cfelse>0</cfif></cfoutput></td>
										</tr>
										<tr>
											<td><cf_get_lang dictionary_id ='53859.İşten Ayrılanlar'></td>
											<td>&nbsp;<cfoutput><cfif (C4.RECORDCOUNT)>#C4.RECORDCOUNT#<cfelse>0</cfif></cfoutput></td>
										</tr>
										<tr>
											<td rowspan="3"><cf_get_lang dictionary_id ='53862.Ücretli İzin Kullananların'></td>
											<td><cf_get_lang dictionary_id="39852.Sayısı"></td>
											<td>&nbsp;<cfoutput><cfif (F3.RECORDCOUNT)>#F3.RECORDCOUNT#<cfelse>0</cfif></cfoutput></td>
										</tr>
										<tr>
											<td><cf_get_lang dictionary_id ='53863.Gün Sayısı'></td>
											<td>&nbsp;<cfoutput><cfif len(F5)>#F5#<cfelse>0</cfif></cfoutput></td>
										</tr>
										<tr>
											<td><cf_get_lang dictionary_id ='53864.İzin Ücreti'></td>
											<td>&nbsp;<cfoutput><cfif len(F6)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(F6)#"><cfelse>0</cfif></cfoutput></td>
										</tr>
									</table>
								</td>
								<td width="20" nowrap>&nbsp;</td>
								<td valign="top" height="100%">
									<table cellspacing="0" cellpadding="0" border="1" style="border : thin solid cccccc;" width="100%" height="100%" class="print">
										<tr align="center" class="formbold">
											<td colspan="4"><cf_get_lang dictionary_id ='53865.TOPLAM TAHAKKUK BİLGİLERİ'></td>
											</tr>
										<tr class="txtbold">
											<td><cf_get_lang dictionary_id ='53866.SİGORTA KOLLARI'></td>
											<td style="text-align:right;"><cf_get_lang dictionary_id ='53867.PRİME ESAS KAZANÇ TOPLAMI'></td>
											<td align="center"><cf_get_lang dictionary_id ='53868.PRİM ORANI'></td>
											<td style="text-align:right;"><cf_get_lang dictionary_id ='53869.PRİM TUTARI'></td>
										</tr>
										<cfset son_toplam = 0>
										<!--- <cfif session.ep.period_year gt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon gt 9)>
											<cfset tehlike_carpan = (GET_BRANCH_INFO.DANGER_DEGREE_NO/2)+0.5>
										<cfelse>
											<cfset tehlike_carpan = (GET_BRANCH_INFO.DANGER_DEGREE_NO/2)+1>
										</cfif>
										<cfif GET_BRANCH_INFO.DANGER_DEGREE eq 0><cfset tehlike_carpan = tehlike_carpan + 0.2></cfif>
										<cfif GET_BRANCH_INFO.DANGER_DEGREE eq 2><cfset tehlike_carpan = tehlike_carpan - 0.2></cfif> 20160418 97495 id'li is MA--->
													
										<cfset tehlike_carpan = GET_BRANCH_INFO.DANGER_DEGREE_NO>
										<tr>
											<td style="width:60mm;"><cfif (session.ep.period_year gt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon gt 9))><cf_get_lang dictionary_id="59480.Kısa Vadeli Sigorta Kolları Primi"><cfelse><cf_get_lang dictionary_id="34805.İş Kazaları ve Meslek Hastalıkları Sigortası"></cfif></td>
											<td style="width:60mm; text-align:right;"><cfoutput><cfif C6-F6><cfif (session.ep.period_year gt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon gt 9))><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(C6)#"><cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(C6-F6)#"></cfif><cfelse>-</cfif></cfoutput></td>
											<td align="center" style="width:30mm"><cfoutput>#tehlike_carpan#</cfoutput></td>
											<td style="text-align:right;"><cfoutput><cfif C6-F6><cfif (session.ep.period_year gt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon gt 9))><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat((C6)*(tehlike_carpan/100))#"><cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat((C6-F6)*(tehlike_carpan/100))#"></cfif><cfelse>-</cfif></cfoutput></td>
										</tr>
										<cfif C6-F6>
											<cfif (session.ep.period_year gt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon gt 9))>
												<cfset son_toplam = son_toplam + ((C6)*(tehlike_carpan/100))>
											<cfelse>
												<cfset son_toplam = son_toplam + ((C6-F6)*(tehlike_carpan/100))>
											</cfif>
										</cfif>
									<cfif attributes.ssk_statute neq 2>
										<cfif (session.ep.period_year lt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon lt 9))>
											<tr>
												<td><cf_get_lang dictionary_id ='53871.Analık Sigortası'></td>
												<td  style="text-align:right;"><cfif C6><cfoutput><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(C6)#"></cfoutput><cfelse>-</cfif></td>
												<td align="center"><cfoutput>#get_insurance_ratio.MOM_INSURANCE_PREMIUM_WORKER+get_insurance_ratio.MOM_INSURANCE_PREMIUM_BOSS#</cfoutput></td>
												<td  style="text-align:right;"><cfif C6><cfoutput><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(C6*((get_insurance_ratio.MOM_INSURANCE_PREMIUM_WORKER+get_insurance_ratio.MOM_INSURANCE_PREMIUM_BOSS)/100))#"></cfoutput><cfelse>-</cfif></td>
											</tr>
										<cfif C6><cfset son_toplam = son_toplam + (C6*((get_insurance_ratio.MOM_INSURANCE_PREMIUM_WORKER+get_insurance_ratio.MOM_INSURANCE_PREMIUM_BOSS)/100))></cfif>
										</cfif>
									<cfelse>
										<cfif (session.ep.period_year lt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon lt 9))>
											<tr>
												<td><cf_get_lang dictionary_id ='53871.Analık Sigortası'></td>
												<td  style="text-align:right;">&nbsp;</td>
												<td align="center">&nbsp;</td>
												<td  style="text-align:right;">&nbsp;</td>
											</tr>
										</cfif>
									</cfif>
												
									<cfif attributes.ssk_statute neq 2>
										<tr>
											<td><cf_get_lang dictionary_id ='53873.Malüllük Yaşlılık ve Ölüm Sigortası'></td>
											<td  style="text-align:right;"><cfoutput><cfif C6><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(C6)#"><cfelse>-</cfif></cfoutput></td>
											<td align="center">
												<cfoutput>#get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER+get_insurance_ratio.DEATH_INSURANCE_PREMIUM_BOSS#</cfoutput>
											</td>
											<td  style="text-align:right;">
											<cfoutput>
												<cfif C6>
												<cfset a = C6*((get_insurance_ratio.DEATH_INSURANCE_PREMIUM_WORKER+get_insurance_ratio.DEATH_INSURANCE_PREMIUM_BOSS)/100)>
																			<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(a)#">
											<cfelse>
												-
												<cfset a = 0>
											</cfif>
										</cfoutput></td>
										</tr>
										<cfset son_toplam = son_toplam + a>
												<cfelse>
										<tr>
											<td><cf_get_lang dictionary_id ='53873.Malüllük Yaşlılık ve Ölüm Sigortası'></td>
											<td  style="text-align:right;">&nbsp;</td>
											<td align="center">&nbsp;</td>
											<td  style="text-align:right;">&nbsp;</td>
										</tr>
									</cfif>
									
									<cfif attributes.ssk_statute neq 2>
										<tr>
										<td><cfif (session.ep.period_year gt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon gt 9))><cf_get_lang dictionary_id="59481.Genel Sağlık Sigortası Primi"><cfelse><cf_get_lang dictionary_id="34801.Hastalık Sigortası"></cfif></td>
											<td  style="text-align:right;"><cfoutput><cfif C6><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(C6)#"><cfelse>0</cfif></cfoutput></td>
											<td align="center"><cfoutput>#get_insurance_ratio.PAT_INS_PREMIUM_WORKER+get_insurance_ratio.PAT_INS_PREMIUM_BOSS#</cfoutput></td>
											<td  style="text-align:right;"><cfoutput><cfif C6><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(C6*((get_insurance_ratio.PAT_INS_PREMIUM_WORKER+get_insurance_ratio.PAT_INS_PREMIUM_BOSS)/100))#"><cfelse>0</cfif></cfoutput></td>
										</tr>
										<cfif C6><cfset son_toplam = son_toplam + (C6*((get_insurance_ratio.PAT_INS_PREMIUM_WORKER+get_insurance_ratio.PAT_INS_PREMIUM_BOSS)/100))></cfif>
									<cfelse>
										<tr>
											<td><cfif (session.ep.period_year gt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon gt 9))><cf_get_lang dictionary_id="59481.Genel Sağlık Sigortası Primi"><cfelse><cf_get_lang dictionary_id="34801.Hastalık Sigortası"></cfif></td>
											<td  style="text-align:right;">&nbsp;</td>
											<td align="center">&nbsp;</td>
											<td  style="text-align:right;">&nbsp;</td>
										</tr>
									</cfif>
									<cfif attributes.ssk_statute eq 2>
										<tr><td><cf_get_lang dictionary_id ='53198.Sosyal Güvenlik Destek Primi'></td>
											<td  style="text-align:right;"><cfoutput><cfif C6><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(C6)#"><cfelse>-</cfif></cfoutput></td>
											<td align="center"><cfoutput>#get_insurance_ratio.SOC_SEC_INSURANCE_BOSS+get_insurance_ratio.SOC_SEC_INSURANCE_WORKER#</cfoutput></td>
											<td  style="text-align:right;"><cfoutput><cfif C6><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(C6*((get_insurance_ratio.SOC_SEC_INSURANCE_BOSS+get_insurance_ratio.SOC_SEC_INSURANCE_WORKER)/100))#"><cfelse>0</cfif></cfoutput></td>
										</tr>
										<cfif C6><cfset son_toplam = son_toplam + (C6*((get_insurance_ratio.SOC_SEC_INSURANCE_BOSS+get_insurance_ratio.SOC_SEC_INSURANCE_WORKER)/100))></cfif>
									</cfif>
									
									<cfif attributes.ssk_statute neq 2>
										<tr>
											<td><cf_get_lang dictionary_id ='53874.İşsizlik Sigorta Primi'></td>
											<td  style="text-align:right;"><cfoutput><cfif C6><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(C6)#"><cfelse>-</cfif></cfoutput></td>
											<td align="center"><cfoutput>#get_insurance_ratio.DEATH_INSURANCE_WORKER+get_insurance_ratio.DEATH_INSURANCE_BOSS#</cfoutput></td>
											<td  style="text-align:right;"><cfoutput><cfif C6><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(toplam_issizlik)#"><cfelse>-</cfif></cfoutput></td>
										</tr>
									<cfif C6><cfset son_toplam = son_toplam + toplam_issizlik></cfif>
									<cfelse>
										<tr>
											<td><cf_get_lang dictionary_id ='53874.İşsizlik Sigorta Primi'></td>
											<td  style="text-align:right;">&nbsp;</td>
											<td align="center">&nbsp;</td>
											<td  style="text-align:right;">&nbsp;</td>
										</tr>
									</cfif>
									<tr>
										<td><cf_get_lang dictionary_id ='57680.GENEL TOPLAM'></td>
										<td  style="text-align:right;">&nbsp;</td>
										<td align="center">&nbsp;</td>
										<td  style="text-align:right;">&nbsp;<cfoutput><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(son_toplam)#"></cfoutput></td>
									</tr>
									</table>
								</td>
								</tr>
							</table>
						</cfif>
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td align="center" class="formbold">II - <cf_get_lang dictionary_id ='53876.AY İÇERİSİNDE ÇALIŞTIRILAN SİGORTALILAR'> </td>
							</tr>
						</table>
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>		
							<table cellspacing="0" cellpadding="0" border="1" style="border : thin solid cccccc;" class="print" width="100%">
										<tr class="printbold">
											<td rowspan="2" align="center" style="width:6mm;height:8mm"><cf_get_lang dictionary_id ='53109.Sıra No'></td>
											<!--- <td rowspan="2" align="center" style="width:15mm;"><cf_get_lang no ='931.Değişiklik'></td> --->
											<td rowspan="2" align="center" style="width:27mm;"><cf_get_lang dictionary_id ='46334.Sosyal Güvenlik Sicil Numarası'></td>
											<td rowspan="2" align="center" style="width:28mm;"><cf_get_lang dictionary_id ='58025.TC Kimlik No'></td>
											<td rowspan="2" align="center" style="width:25mm;"><cf_get_lang dictionary_id ='57631.Adı'></td>
											<td rowspan="2" align="center" style="width:25mm;"><cf_get_lang dictionary_id ='58726.Soyadı'></td>
											<td rowspan="2" align="center" style="width:20mm;"><cf_get_lang dictionary_id ='53879.İlk Soyadı'></td>
											<td rowspan="2" align="center" style="width:06mm;"><cf_get_lang dictionary_id ="59482.Prim Ödeme Günü"></td>
									<cfif (session.ep.period_year gt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon gt 9))>
										<td colspan="2" align="center" style="width:24mm;"><cf_get_lang dictionary_id ='53880.Prime Esas Kazanç'></td>
									<cfelse>
										<td rowspan="2" align="center" style="width:24mm;"><cf_get_lang dictionary_id ='53880.Prime Esas Kazanç'></td>
									</cfif>
											<!---<td colspan="2" align="center" style="width:24mm;">DDD<cf_get_lang no ='740.Ücretli İzin'></td>--->
											<td colspan="2" align="center" style="width:34mm;"><cf_get_lang dictionary_id ='53857.Ay İçinde'></td>
											<td colspan="2" align="center"><cf_get_lang dictionary_id ='53881.Eksik Gün Nedeni'></td>
											<td rowspan="2" align="center"><cf_get_lang dictionary_id ='53882.İşten Çıkış Nedeni'></td>
										</tr>
										<tr class="printbold">
							<cfif (session.ep.period_year gt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon gt 9))>
									<td align="center"><cf_get_lang dictionary_id="53127.Ücret"></td>
									<td align="center"><cf_get_lang dictionary_id="55776.Prim">/ <cf_get_lang dictionary_id="55795.İkramiye"></td>
							</cfif>
											<!---<td align="center"><cf_get_lang no ='917.Gün Sayısı'></td>
											<td align="center"><cf_get_lang no ='918.İzin Ücreti'></td>--->
											<td align="center"><cf_get_lang dictionary_id ='53883.İşe Giriş Tarihi Gün- Ay'></td>
											<td align="center"><cf_get_lang dictionary_id ='53884.İşten Çıkış Tarihi Gün- Ay'></td>
					
							<td align="center"><cf_get_lang dictionary_id="39852.Sayısı"></td>
											<td align="center"><cf_get_lang dictionary_id ="34777.Nedeni"></td>
					
										</tr>
								<cfif page_ eq 1>
									<cfset maxrows_ = 7>
									<cfset startrow_ = 1>
								<cfelseif page_ eq 2>
									<cfset maxrows_ = 25>
									<cfset startrow_ = startrow_ + 7>
								<cfelse>
									<cfset maxrows_ = 25>
									<cfset startrow_ = startrow_ + 25>
								</cfif>
								<cfset ssk_employee_count=0>
								<cfset gun_1_last_page = 0>
								<cfset pek_1_last_page = 0>
								<cfset odenek1_last_page = 0>
								<cfset uigun_1_last_page = 0>
								<cfset izin_ucret_1_last_page = 0>
								<cfset ssk_1_last_page = 0>
					
								<cfoutput query="get_puantaj_rows" startrow="#startrow_#" maxrows="#maxrows_#">
										<tr>
											<td>#currentrow#</td>
											<!--- <td>&nbsp;</td> --->
											<td>&nbsp;#ssk_no#</td>
											<td>&nbsp;#TC_IDENTY_NO#</td>
											<td>&nbsp;#employee_name#</td>
											<td>&nbsp;#employee_surname#</td>
											<td>&nbsp;#last_surname#</td>
											<td style="text-align:right;">&nbsp;#gun_sayisi#</td>
								<cfscript>
								ssk_employee_count=ssk_employee_count+1;
								if (izin_paid gt 0)
									{
									get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0 AND IS_PAID = 0");
									if(get_emp_izins_2.recordcount)
									{
										izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
										if(izin_paid_yaz < 0) // Kisinin 1 gün izni varsa ve izin tanimlarindan 2 günü sirket oder seciliyse burasi - ye dusuyordu. get_emp_izins_2.recordcount kayit getiriyorsa negatife dusemez. EY20140805
											izin_paid_yaz = 0;
									}
									else 
										izin_paid_yaz = izin_paid ;
									//izin ucreti hesabinda SSK_MATRAH yerine total_salary_ vardı: AK20040817
									//total_salary_ = TOTAL_SALARY - (EXT_SALARY + total_pay_ssk_tax + total_pay_tax + total_pay_ssk + total_pay);
									if(total_days gt 0)
										izin_paid_amount = (SSK_MATRAH * (izin_paid_yaz / total_days));//TolgaS20080428 SSK_MATRAH medical parkın belirtiği hata ve diğer icmal ve üst tutarla tutmadığından diğerleri ile aynı hale getirildi
									else
										izin_paid_amount = 0;
									UCRETLIIZINGUN = izin_paid_yaz;
									UIPEK = izin_paid_amount;
									}
								else
									{
									izin_paid = 0;
									izin_paid_yaz = 0;
									izin_paid_amount = 0;
									}
					
								if (izin gt 0)
									{
									get_emp_izins = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND IS_PAID = 0");
									eksik_neden_id = get_emp_izins.EBILDIRGE_TYPE_ID;
									
					
					
									if (get_emp_izins.recordcount gte 2)
										for (geii=2; geii lte get_emp_izins.recordcount; geii=geii+1)
											if (get_emp_izins.EBILDIRGE_TYPE_ID[geii-1] neq get_emp_izins.EBILDIRGE_TYPE_ID[geii])
												eksik_neden_id = 12;
					
									EKSIKGUNNEDENI = eksik_neden_id;
									}
								else
									{
									EKSIKGUNNEDENI = '';
									}
								GIRISGUN = "";
								CIKISGUN = "";
								ISTENCIKISNEDENI = "";
								if ( len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0) )
									GIRISGUN = dateformat(start_date,"dd/mm");
								if ( (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0)) )
									{
									fire_reason = ListGetAt(law_list(),explanation_id,",");
									CIKISGUN = dateformat(finish_date,"dd/mm");
									ISTENCIKISNEDENI = fire_reason;
									}
								last_record = currentrow;
								prim_vb_ = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + TOTAL_PAY_TAX + SSK_DEVIR_LAST + SSK_DEVIR;
								ucret_ = TOTAL_SALARY + SSK_DEVIR_LAST + SSK_DEVIR - (prim_vb_ + TOTAL_PAY);
								if(ucret_ gt ssk_matrah)
									ucret_ = ssk_matrah;
								</cfscript>
											<td  style="text-align:right;">&nbsp;<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(ucret_)#"></td>
								<td style="text-align:right;">&nbsp;#prim_vb_#</td>
									<!--- <cfif (session.ep.period_year gt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon gt 9))>
																<td  style="text-align:right;">&nbsp;#izin_paid_yaz#</td>
									</cfif>
											<td  style="text-align:right;">&nbsp;<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(izin_paid_amount)#"></td>--->
											<td>&nbsp;#GIRISGUN#</td>
											<td>&nbsp;#CIKISGUN#</td>
					
							<td>&nbsp;
					
														<cfset is_istihdam = 0>
														<cfif SSK_ISVEREN_HISSESI_5921_DAY gt 0 and kanun_no eq 0>
															#SSK_ISVEREN_HISSESI_5921_DAY + IZIN#
															<cfset is_istihdam = 1>
														<cfelseif SSK_ISVEREN_HISSESI_5921_DAY gt 0 and kanun_no eq 5921>
															#(TOTAL_DAYS + IZIN) - SSK_ISVEREN_HISSESI_5921_DAY#
															<cfset is_istihdam = 1>
														<cfelse>
															<cfif daysinmonth(BU_AY_BASI) eq 31 and izin eq 30> <!--- 31 çeken aylarda ücretsiz izin toplamı 30 ise aydaki gün sayısı kadar yazacak çünkü e bildirgede 31 olarak bildiriliyor SG 20150313--->
																31
															<cfelse>
																#izin#
															</cfif>
															<cfset is_istihdam = 1>
														</cfif>
					
					
							</td>
					
											<td>&nbsp;<cfif is_istihdam eq 1 and duty_type eq 6>6<cfelse>#EKSIKGUNNEDENI#</cfif></td>
											<td>&nbsp;#ISTENCIKISNEDENI#</td>
										</tr>
								<cfset gun_1_last_page = gun_1_last_page+GUN_SAYISI>
								<cfset pek_1_last_page = pek_1_last_page+ucret_+prim_vb_>  <!--- CH <cfset pek_1_last_page = pek_1_last_page+SSK_MATRAH> --->
								<cfset odenek1_last_page = odenek1_last_page + prim_vb_>
								<cfset uigun_1_last_page = uigun_1_last_page+izin_paid_yaz>
								<cfset izin_ucret_1_last_page = izin_ucret_1_last_page+izin_paid_amount>
								<cfset ssk_1_last_page = ssk_1_last_page+1>
							</cfoutput>
							<cfif ssk_employee_count neq maxrows_>
								<cfloop from="1" to="#maxrows_-ssk_employee_count#" index="i">
										<tr>
											<td><cfoutput>#last_record+i#</cfoutput></td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
								<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
									<cfif (session.ep.period_year gt 2008 or (session.ep.period_year eq 2008 and attributes.sal_mon gt 9))>
										<td>&nbsp;</td>
									</cfif>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
								<td>&nbsp;</td>
											<!---<td>&nbsp;</td>
											<td>&nbsp;</td> ---> 
									</tr>
								</cfloop>
							</cfif>
							<cfset page_ = page_+1>
									</table>
							<table border="0" cellspacing="0" cellpadding="0" class="print">
								<cfoutput>
								<tr>
									<td style="width:45mm;" colspan="2">&nbsp;</td>
									<td style="width:45mm;">&nbsp;<cf_get_lang dictionary_id ='53855.Sigortalı sayısı'></td>
									<td style="width:45mm;">&nbsp;<cf_get_lang dictionary_id ="59482.PRİM ÖDEME GÜNÜ"></td>
									<td style="width:45mm;">&nbsp;<cf_get_lang dictionary_id ="59483.PRİM ESAS KAZANÇ"></td>
								</tr>
								<tr>
								<td style="width:45mm;">&nbsp;</td>
								<td style="width:50mm;" class="printbold"><cf_get_lang dictionary_id ='53885.BU SAYFANIN TOPLAMLARI'></td>
								<!---<td rowspan="3" class="printbold" style="width:33mm;" align="center"><cf_get_lang no ='909.Sigortalı sayısı'></td>--->
								<td style="width:8mm;">&nbsp;#ssk_1_last_page#</td>
								<td style="width:7mm;">#gun_1_last_page#&nbsp</td>
								<td style="width:8mm;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(pek_1_last_page)#"></td>
								<!---<td style="width:29mm; text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(odenek1_last_page)#"></td>
								<td style="width:15mm;text-align:right;">#uigun_1_last_page#</td>
								<td style="width:16mm;text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(izin_ucret_1_last_page)#"></td>
								<td>&nbsp</td>
								<td>&nbsp</td>
								<td>&nbsp</td>--->
								</tr>
								<cfif page_ neq 2>
								<tr>
								<td style="width:16mm;">&nbsp;&nbsp;</TD>
								<td style="width:52mm;" class="printbold"><cf_get_lang dictionary_id ='53886.ÖNCEKİ SAYFADAN DEVİRLER'></td>
								<td style="width:8mm;">&nbsp;#ssk_2_last_page#</td>
								<td style="width:7mm;">&nbsp;#gun_2_last_page#</td>
								<td style="width:8mm;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(pek_2_last_page)#"></td>
								<!---<td style="width:29mm; text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(odenek2_last_page)#"></td>
								<td style="width:15mm;text-align:right;">#uigun_2_last_page#</td>
								<td style="width:16mm;text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(izin_ucret_2_last_page)#"></td>
								<td>&nbsp</td>
								<td>&nbsp</td>
								<td>&nbsp</td>--->
								</tr>
								<tr>
								<td style="width:16mm;">&nbsp;&nbsp;</TD>
								<td style="width:50mm;" class="printbold"><cf_get_lang dictionary_id ='53887.BU SAYFA DAHİL TOPLAMLAR'></td>
								<td style="width:8mm;">&nbsp;#ssk_2_last_page+ssk_1_last_page#</td>
								<td style="width:7mm;">&nbsp;#gun_2_last_page+gun_1_last_page#</td>
								<td style="width:8mm;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(pek_2_last_page+pek_1_last_page)#"></td>
								<!---<td style="width:29mm; text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(odenek2_last_page+odenek1_last_page)#"></td>
								<td style="width:15mm;text-align:right;">#uigun_2_last_page+uigun_1_last_page#</td>
								<td style="width:16mm;text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(izin_ucret_2_last_page+izin_ucret_1_last_page)#"></td>
								<td>&nbsp</td>
								<td>&nbsp</td>
								<td>&nbsp</td>--->
								</tr>
								</cfif>
								</cfoutput>
								</table>
							<cfset ssk_2_last_page = ssk_2_last_page+ssk_1_last_page>
							<cfset gun_2_last_page = gun_2_last_page+gun_1_last_page>
							<cfset pek_2_last_page = pek_2_last_page+pek_1_last_page>
							<cfset odenek2_last_page = odenek2_last_page+odenek1_last_page>
							<cfset uigun_2_last_page = uigun_2_last_page+uigun_1_last_page>
							<cfset izin_ucret_2_last_page = izin_ucret_2_last_page+izin_ucret_1_last_page>
									<table border="0" align="center" cellpadding="2" cellspacing="1" width="100%">
										<tr>
								<td style="width:210mm" valign="top">			
									<table cellspacing="0" cellpadding="0" border="1" style="border : thin solid cccccc;" width="100%" class="print">
										<tr>
											<td colspan="4"><cfoutput>#ceiling((get_puantaj_rows.recordcount-7)/25)+1#</cfoutput> <cf_get_lang dictionary_id ='53888.sayfadan ibaret bu belgede yazılı bilgilerin işyeri defter ve kayıtlarına uygun olduğunu beyan ve kabul ederiz'></td>
										</tr>
										<tr>
											<td style="width:34mm;height:15mm;"><cf_get_lang dictionary_id="59479.ALT İŞVERENİN"> - <cf_get_lang dictionary_id="46543.İşverenin Sigortalıyı Devir Alanının Adı-Soyadı Mühür veya Kaşesi"></td>
											<td style="width:63mm;">&nbsp;</td>
											<td style="width:40mm;"><cf_get_lang dictionary_id="59484.Serbest Muhasebeci Mali Müşavir"><br/><cf_get_lang dictionary_id="53769.Adı-Soyadı">:<br/><cf_get_lang dictionary_id="59485.Oda Kayıt No">:<br/><cf_get_lang dictionary_id="46466.Kaşe İmza">:<br/></td>
											<td style="width:59mm;">&nbsp;</td>
										</tr>
									</table>
								</td>
										<td style="width:56mm;" valign="top">			 
									<table cellspacing="0" cellpadding="0" border="1" style="border : thin solid cccccc;" width="100%" class="print">
										<tr><td><cf_get_lang dictionary_id ='53894.ÜNİTEYE VERİLDİĞİ TARİH'></td></tr>
										<tr><td style="height:15mm;">&nbsp;</td></tr>
									</table>
								</td>
								<td style="width:23mm;" valign="top">
									<table cellspacing="0" cellpadding="0" border="1" style="border : thin solid cccccc;" class="print">
										<tr><td align="center"><cf_get_lang dictionary_id ='53895.RESEN DÜZENLENMİŞTİR'></td></tr>
										<tr>
											<td style="height:12mm;" align="center">
											<span class="print"><br/>(<cf_get_lang dictionary_id="59486.kurum tarafından doldurulacaktır">)</span>
											</td>
										</tr>
									</table>
								</td>
								</tr>
										</table></td>
								</tr>
							</table></td>
						</tr>
					</table>
				</cfloop>
			</form>
		</cf_box>
	</div>
	<cfif isdefined("attributes.printme")>
	<script type="text/javascript">
		function waitfor(){
		window.close();
		}	
		setTimeout("waitfor()",3000);
		window.print();
	</script>
	</cfif>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	