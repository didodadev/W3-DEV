<cfif isdefined("attributes.company_id")>
	<cfquery name="GETOUR" datasource="#dsn#">
		SELECT 
			COMP_ID, 
			COMPANY_NAME,
			TEL_CODE,
			TEL,
			ASSET_FILE_NAME3,
			EMAIL,
			WEB,
			ADDRESS,
			FAX,
			ASSET_FILE_NAME2_SERVER_ID,
			ASSET_FILE_NAME2
		FROM 
			OUR_COMPANY 
		WHERE 
			COMP_ID = #session.ep.company_id#
	</cfquery>
	<cfquery name="CHECK" datasource="#dsn2#">
		SELECT ASSET_FILE_NAME2, ASSET_FILE_NAME2_SERVER_ID FROM #dsn_alias#.OUR_COMPANY WHERE COMP_ID = #session.ep.company_id#
	</cfquery>
	<cfquery name="GET_TEMPLATE_DIMENSION" datasource="#dsn2#">
		SELECT * FROM #dsn_alias#.SETUP_TEMPLATE_DIMENSION 
	</cfquery>
	<cfquery name="GETTYPE" datasource="#dsn2#">
		SELECT 
			START_DATE,
			FINISH_DATE,
			IS_CH,
			IS_CR,
			IS_BA,
			IS_BS,
			BABS_AMOUNT 
		FROM 
			CARI_LETTER
		WHERE 
			CARI_LETTER_ID = #attributes.cari_letter_id#
	</cfquery>
	<cfloop list="#attributes.company_id#" index="i">
		<cfset uuidvalue = CreateUUID()>
		<cfquery name="GETROW" datasource="#dsn2#">
			SELECT
				<cfif isdefined("attributes.moneytype#i#") and len(evaluate("attributes.moneytype#i#")) and '#evaluate("attributes.moneytype#i#")#' neq '#session.ep.money#'>
					AMOUNT_OTHER AS IS_CH_AMOUNT,
					AMOUNT_OTHER AS	IS_CR_AMOUNT,
					AMOUNT_OTHER AS	IS_BA_TOTAL,
					AMOUNT_OTHER AS	IS_BA_AMOUNT,
					AMOUNT_OTHER AS	IS_BS_TOTAL,
					AMOUNT_OTHER AS	IS_BS_AMOUNT,
					OTHER_MONEY AS MONEY_TYPE,
				<cfelse>
					IS_CH_AMOUNT,
					IS_CR_AMOUNT,
					IS_BA_TOTAL,
					IS_BA_AMOUNT,
					IS_BS_TOTAL,
					IS_BS_AMOUNT,
					'#session.ep.money#' AS MONEY_TYPE,
				</cfif>		
				*	
			 FROM CARI_LETTER_ROW WHERE COMPANY_ID = #evaluate("attributes.company_id_#i#")# AND CARI_LETTER_ID = #attributes.cari_letter_id#
		</cfquery>
		<cfset chemail = evaluate("attributes.chemail#i#")>
		<cfset asemail = evaluate("attributes.asemail#i#")>
		<cfquery name="GETCOMPANY" datasource="#dsn#">
			SELECT 
				FULLNAME,
				COMPANY_ADDRESS,
				COMPANY_POSTCODE,
				CITY,
				COUNTY,
				TAXOFFICE,
				TAXNO,
				COMPANY_TEL1 TEL,
				COMPANY_TELCODE TELCODE,
				COMPANY_FAX FAX
			FROM 
				COMPANY 
			WHERE 
				COMPANY_ID = #evaluate("attributes.company_id_#i#")#
		</cfquery>
		<!--- Mutabakat Mektubu --->
		<cfif gettype.is_ch eq 1>
			<cfif len(chemail)>
				<cfquery name="UPDMAIN" datasource="#dsn2#">
					UPDATE 
						CARI_LETTER_ROW
					SET 
						IS_SEND = #session.ep.userid#,
						IS_SEND_DATE = #now()#,
						IS_SEND_IP = '#cgi.remote_addr#'
					WHERE 
						CARI_LETTER_ID = #attributes.cari_letter_id# AND 
						COMPANY_ID = #evaluate("attributes.company_id_#i#")#
				</cfquery>
				<cfsavecontent variable="subject"><cf_get_lang dictionary_id='49865.Mutabakat Mektubu'></cfsavecontent>
				<cfmail  from="#getour.company_name#<#GETOUR.email#>" to="#chemail#" charset="utf-8" subject="#subject#" type="html">
					<style type="text/css">
						.label {font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
						.css1 {font-size:12px;font-family:arial,verdana;color:000000; background-color:white;}
						.css2 {font-size:9px;font-family:arial,verdana;color:999999; background-color:white;}
						.keypadtable{background-color:##DAEAF8;border:1px solid ##6699cc;}
						.color-list	{background-color:##DAEAF8;}
						.color-header {background-color: ##a7caed;}
						tr.color-row td{background-color: ##F4F9FD;}
						tr.color-row{background-color: ##F4F9FD;}
						tr.color-header td{background-color: ##a7caed;}
						.color-border {background-color:##6699cc;}
						.color-row { background-color:##F4F9FD;}
						.headbold {font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
						.divaccept { background-color:##009900; color:##FFFFFF; font-weight:bold; font-size:14px; padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px; text-decoration:none; text-align:center}
						.divcancel { background-color:##990000; color:##FFFFFF; font-weight:bold; font-size:14px; padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px; text-decoration:none; text-align:center}
					</style>
					<table width="700" class="css1">
						<tr>
							<td style="text-align:right"><cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td style="text-align:left"><b><cfoutput>#getcompany.fullname#</cfoutput></b></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td style="text-align:left"><cfoutput>#getcompany.company_address# #getcompany.company_postcode#</cfoutput></td>
						</tr>
						<tr>
							<td style="text-align:left"><cfoutput>
							<cfif len(getcompany.city)>
								<cfquery name="GETCITY" datasource="#dsn2#">
									SELECT CITY_NAME FROM #dsn_alias#.SETUP_CITY WHERE CITY_ID = #getcompany.city#
								</cfquery>#getcity.city_name#
							</cfif> / 
							<cfif len(getcompany.county)>
								<cfquery name="GETCITY" datasource="#dsn2#">
									SELECT COUNTY_NAME FROM #dsn_alias#.SETUP_COUNTY WHERE COUNTY_ID = #getcompany.county#
								</cfquery>#getcity.county_name#
							</cfif>
							</cfoutput></td>
						</tr>
						<tr>
							<td style="text-align:center"><b><cf_get_lang dictionary_id='49865.Mutabakat Mektubu'></b></td>
						</tr>
						<tr>
							<td style="text-align:left">Sn. <cfoutput>#getcompany.fullname#</cfoutput></td>
						</tr>
						<tr>
							<td colspan="2">						
								<br>
								<cfset bakiyevalue = evaluate("attributes.is_ch_amount#i#")>
								<cf_get_lang dictionary_id='64447.??irketimiz nezdindeki hesap bakiyeniz'> <cfoutput>#dateformat(gettype.finish_date,'dd/mm/yyyy')#</cfoutput> 
								<cf_get_lang dictionary_id='33287.tarihi itibari ile'>&nbsp;&nbsp;
								<b><cfoutput>#tlformat(getrow.is_ch_amount)# #getrow.MONEY_TYPE#&nbsp;<cfif getrow.is_ch_amount gt 0><cfif getrow.cari_status eq 1>(<cf_get_lang dictionary_id='57587.Bor??'>)<cfelse>(<cf_get_lang dictionary_id='57588.Alacak'>)</cfif></cfif></cfoutput></b>&nbsp;&nbsp;
								<cfoutput>
								<cfset mynumber = getrow.is_ch_amount>
								&nbsp;&nbsp;<cf_n2txt number="mynumber" para_birimi="#getrow.MONEY_TYPE#"><cfoutput><b>#mynumber#</b></cfoutput>&nbsp;&nbsp;
								</cfoutput>
								<cfif getrow.is_ch_amount gt 0><cfif getrow.cari_status eq 1><b><cf_get_lang dictionary_id='57587.Bor??'></b><cfelse><b><cf_get_lang dictionary_id='57588.Alacak'></b></cfif></cfif> <cf_get_lang dictionary_id='64448.bakiyesi vermektedir.'> <cf_get_lang dictionary_id='64446.Bu tutar?? hakk??nda mutab??k olup olmad??????n??z?? bildirmenizi rica ederiz.'> <br /><br /> 										
								<cf_get_lang dictionary_id='48814.Sayg??lar??m??zla'>,<br /><br /><br />
								<table>
									<tr>
										<td width="200" valign="top"><a href="#fusebox.server_machine_list#/wex.cfm/wutabakat?type=10345&cspid=#evaluate("attributes.company_id_#i#")#&uuid=#getrow.unique_id#&capyval=1395798571&mmxid=#attributes.cari_letter_id#&ocid=#session.ep.company_id#&pid=#session.ep.period_id#&isbxbsam=0" target="_blank" style="text-decoration:none;"><div class="divaccept"><cf_get_lang dictionary_id='58475.Onayla'></div></a><br /></td>
										<td width="200" valign="top"><a href="#fusebox.server_machine_list#/wex.cfm/wutabakat?type=10345&cspid=#evaluate("attributes.company_id_#i#")#&uuid=#getrow.unique_id#&capyval=1395798570&mmxid=#attributes.cari_letter_id#&ocid=#session.ep.company_id#&pid=#session.ep.period_id#&isbxbsam=0" target="_blank" style="text-decoration:none;"><div class="divcancel"><cf_get_lang dictionary_id='58461.Reddet'></div></a><br /><br /></td>
									</tr>
								</table><br><br>
								<b><cfoutput>#getour.company_name#</cfoutput></b><br>	
								<b><cf_get_lang dictionary_id='49272.Tel'>: </b><cfoutput>#getour.tel_code# #getour.tel#</cfoutput><br>
								<b><cf_get_lang dictionary_id='57488.Fax'>: </b><cfoutput>#getour.tel_code# #getour.fax#</cfoutput><br>
								<b><cf_get_lang dictionary_id='55484.E-Mail'>: </b><cfoutput>#GETOUR.EMAIL#</cfoutput><br><br>
								<cf_get_server_file output_file="settings/#getour.asset_file_name2#" output_server="#getour.asset_file_name2_server_id#" output_type="5"> 
								<br /><br /><br />
								<cf_get_lang dictionary_id='57422.Notlar'> : <br />
								1- <cf_get_lang dictionary_id='49048.HATA VE UNUTMA ??ST??SNADIR'><br />
								2- <cf_get_lang dictionary_id='49053.Mutabakat veya itiraz??n??z?? 7 g??n i??erisinde bildirmedi??iniz takdirde T.T.K. nun 92. maddesi gere??ince bakiyede mutab??k say??laca????m??z?? hat??rlat??r??z.'><br />
								3- <cf_get_lang dictionary_id='49373.Bakiyede Mutab??k olmad??????n??z takdirde hesap ekstrenizi'> <cf_get_lang dictionary_id='64445.taraf??m??za g??ndermenizi rica ederiz.'>
							</td>
						</tr>
					</table>
				</cfmail>
			</cfif>
		</cfif>
		<!--- Cari Hat??rlatma --->   
		<cfif gettype.is_cr eq 1>
			<cfif len(chemail)>
				<cfquery name="UPDMAIN" datasource="#dsn2#">
					UPDATE 
						CARI_LETTER_ROW
					SET 
						IS_SEND = #session.ep.userid#,
						IS_SEND_DATE = #now()#,
						IS_SEND_IP = '#cgi.remote_addr#'
					WHERE 
						CARI_LETTER_ID = #attributes.cari_letter_id# AND 
						COMPANY_ID = #evaluate("attributes.company_id_#i#")#
				</cfquery>  
				<cfmail from="#getour.company_name#<#GETOUR.EMAIL#>" to="#chemail#" charset="utf-8" subject="Cari Bakiye Hat??rlatma" type="html">
				<style type="text/css">
					.label {font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
					.css1 {font-size:12px;font-family:arial,verdana;color:000000; background-color:white;}
					.css2 {font-size:9px;font-family:arial,verdana;color:999999; background-color:white;}
					.keypadtable{background-color:##DAEAF8;border:1px solid ##6699cc;}
					.color-list	{background-color:##DAEAF8;}
					.color-header {background-color: ##a7caed;}
					tr.color-row td{background-color: ##F4F9FD;}
					tr.color-row{background-color: ##F4F9FD;}
					tr.color-header td{background-color: ##a7caed;}
					.color-border {background-color:##6699cc;}
					.color-row { background-color:##F4F9FD;}
					.headbold {font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
				</style>
				<table width="700" class="css1">
					<tr>
						<td style="text-align:right"><cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td style="text-align:left"><b><cfoutput>#getcompany.fullname#</cfoutput></b></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td style="text-align:left"><cfoutput>#GETCOMPANY.COMPANY_ADDRESS# #GETCOMPANY.COMPANY_POSTCODE#</cfoutput></td>
					</tr>
					<tr>
						<td style="text-align:left"><cfoutput>
						<cfif len(GETCOMPANY.city)>
							<cfquery name="GETCITY" datasource="#dsn2#">
								SELECT CITY_NAME FROM #dsn_alias#.SETUP_CITY WHERE CITY_ID = #GETCOMPANY.city#
							</cfquery>#GETCITY.CITY_NAME#
						</cfif> / 
						<cfif len(GETCOMPANY.county)>
							<cfquery name="GETCITY" datasource="#dsn2#">
								SELECT COUNTY_NAME FROM #dsn_alias#.SETUP_COUNTY WHERE COUNTY_ID = #GETCOMPANY.county#
							</cfquery>#GETCITY.COUNTY_NAME#
						</cfif>
						</cfoutput></td>
					</tr>
					<tr>
						<td style="text-align:center"><b><cf_get_lang dictionary_id='58061.Cari'><cf_get_lang dictionary_id='57589.Bakiye'> <cf_get_lang dictionary_id='29720.Hat??rlatma'></b></td>
					</tr>
					<tr>
						<td style="text-align:left">Sn. <cfoutput>#GETCOMPANY.fullname#</cfoutput></td>
					</tr>
					<tr>
						<td colspan="2">						
							<br>
							<cf_get_lang dictionary_id='64447.??irketimiz nezdindeki hesap bakiyeniz'> <cfoutput>#dateformat(gettype.finish_Date,'dd/mm/yyyy')#</cfoutput> 
							<cf_get_lang dictionary_id='33287.tarihi itibari ile'>&nbsp;&nbsp;
							<b><cfoutput>#tlformat(getrow.is_cr_amount)# #getrow.MONEY_TYPE#&nbsp;<cfif getrow.is_ch_amount gt 0><cfif getrow.cari_status eq 1>(<cf_get_lang dictionary_id='57587.Bor??'>)<cfelse>(<cf_get_lang dictionary_id='57588.Alacak'>)</cfif></cfif></cfoutput></b>&nbsp;&nbsp;
							<cfoutput>
							<cfset mynumber = getrow.is_cr_amount>
							&nbsp;&nbsp;<cf_n2txt number="mynumber" para_birimi="#getrow.MONEY_TYPE#"><cfoutput><b>#mynumber#</b></cfoutput>&nbsp;&nbsp;
							</cfoutput>
							<cfif getrow.is_ch_amount gt 0><cfif getrow.cari_status eq 1>(<cf_get_lang dictionary_id='57587.Bor??'>)<cfelse>(<cf_get_lang dictionary_id='57588.Alacak'>)</cfif></cfif> <cf_get_lang dictionary_id='64448.bakiyesi vermektedir.'> 
							<cf_get_lang dictionary_id='64449.Vadesi dolmu?? veya bu hafta vadesi dolacak olan faturalar i??in herhangi bir ??deme kayd??na rastlanmam????t??r. ??lgili bakiyenin en k??sa zamanda banka hesap numaralar??m??za tediyesini rica eder, iyi ??al????malar dileriz.'> 
							<br /><br /> 
							<cf_get_lang dictionary_id='48814.Sayg??lar??m??zla'>,<br /><br /><br />
							<b><cfoutput>#getour.COMPANY_NAME#</cfoutput></b><br>	
							<b><cf_get_lang dictionary_id='49272.Tel'>: </b><cfoutput>#getour.TEL_CODE# #getour.TEL#</cfoutput><br>
							<b><cf_get_lang dictionary_id='57488.Fax'>: </b><cfoutput>#getour.TEL_CODE# #getour.FAX#</cfoutput><br>
							<b><cf_get_lang dictionary_id='55484.E-Mail'>: </b><cfoutput>#getour.EMAIL#</cfoutput><br><br>
							<cf_get_server_file output_file="settings/#getour.asset_file_name2#" output_server="#getour.asset_file_name2_server_id#" output_type="5"> 
							<br /><br /><br />
							<cf_get_lang dictionary_id='57422.Notlar'> : <br />
							1- <cf_get_lang dictionary_id='49048.HATA VE UNUTMA ??ST??SNADIR'><br />
							2- <cf_get_lang dictionary_id='49373.Bakiyede Mutab??k olmad??????n??z takdirde hesap ekstrenizi'> <cf_get_lang dictionary_id='64445.taraf??m??za g??ndermenizi rica ederiz.'>
						</td>
					</tr>
				</table>
				</cfmail> 
			</cfif>
		</cfif>
		<!--- BA Hat??rlatma --->
		<cfif gettype.is_ba eq 1>
			<cfif len(asemail)>
				<cfquery name="UPDMAIN" datasource="#dsn2#">
					UPDATE 
						CARI_LETTER_ROW
					SET 
						IS_SEND = #session.ep.userid#,
						IS_SEND_DATE = #now()#,
						IS_SEND_IP = '#cgi.remote_addr#'
					WHERE 
						CARI_LETTER_ID = #attributes.cari_letter_id# AND 
						COMPANY_ID = #evaluate("attributes.company_id_#i#")#
				</cfquery>
				<cfmail from="#getour.company_name#<#GETOUR.EMAIL#>" to="#asemail#" charset="utf-8" subject="BA Mutabakat Mektubu" type="html">
				<style type="text/css">
					.table,td {font-family: Verdana, Arial, Helvetica, sans-serif;}
					.font_text {font-size:11px;}
					.divaccept { background-color:##009900; color:##FFFFFF; font-weight:bold; font-size:14px; padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px; text-decoration:none; text-align:center}
					.divcancel { background-color:##990000; color:##FFFFFF; font-weight:bold; font-size:14px; padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px; text-decoration:none; text-align:center}
				</style>
				<table style="width:200mm;height:280mm;" border="0">
					<tr valign="top">
						<td style="width:5mm;">&nbsp;</td>
						<td>
							<cfif len(check.asset_file_name2)>
								<table border="0" cellpadding="<cfif isdefined("attributes.padding_off")>0<cfelse>10</cfif>" cellspacing="<cfif isdefined("attributes.padding_off")>0<cfelse>10</cfif>" bgcolor="FFFFFF" style="width : <cfoutput>#get_template_dimension.template_width#</cfoutput>">
									<tr> 
										<td style="width:20mm;height:20mm;" align="<cfoutput>#get_template_dimension.template_align#</cfoutput>">
											<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
										</td>
									</tr>
								</table>
							</cfif>
							<cfif isdefined("attributes.show_datetime") and attributes.show_datetime and (attributes.show_datetime eq 1)>
								<table cellpadding="10" cellspacing="10" bgcolor="FFFFFF" style="width : <cfoutput>#get_template_dimension.template_width##get_template_dimension.TEMPLATE_UNIT#</cfoutput>">
									<tr>
										<td align="<cfoutput>#get_template_dimension.template_align#</cfoutput>">
											<b><cfoutput>#dateformat(now(),'dd/mm/yyyy')# - #timeformat(date_add('H',session.ep.time_zone,now()),'HH:MM')#</cfoutput></b>
										</td>
									</tr>
								</table>
							</cfif>
						</td>
					</tr>
					<tr valign="top">
						<td style="width:5mm;">&nbsp;</td>
						<td>
							<table border="0">
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										Say??n Yetkili
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<cf_get_lang dictionary_id='64439.381 S??ra Nolu Vergi Usul Kanunu Genel Tebli??i gere??ince, 213 say??l?? Vergi Usul Kanununun (1) 148, 149 ve M??kerrer 257 nci maddelerinin verdi??i yetkiye dayan??larak,
										362 S??ra Nolu Vergi Usul Kanunu Genel Tebli??i (2) ile bilan??o esas??na g??re defter tutan
										m??kelleflerin belirli bir haddi a??an mal ve hizmet al??mlar??n?? "Mal ve Hizmet Al??mlar??na ??li??kin
										Bildirim Formu (Form Ba)" ile;'><cf_get_lang dictionary_id='64440.mal ve hizmet sat????lar??n?? ise "Mal ve Hizmet Sat????lar??na ??li??kin Bildirim Formu (Form Bs)" ile vergilendirme d??nemini takip eden ay??n birinci g??n??nden itibaren son g??n?? ak??am??na kadar tebli?? etmesi gerekti??i a????klanm????t??r.'>
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<cf_get_lang dictionary_id='64441.2010 ve izleyen y??llar??n ayl??k d??nemlerine ili??kin mal ve/veya hizmet al????lar?? ile mal ve/veya hizmet sat????lar??na uygulanacak had 396 s??ra no.lu Tebli?? ile'> #TLFormat(gettype.babs_amount,0)# <cf_get_lang dictionary_id='64442.TL olarak belirlenmi??tir.'>
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										#dateformat(gettype.start_date,'dd/mm/yyyy')#&nbsp;-&nbsp;#dateformat(gettype.finish_date,'dd/mm/yyyy')#  <cf_get_lang dictionary_id='64443.itibar?? ile firman??z ile aram??zda  d??zenlenen fatura adedi ve tutarlar?? a??a????daki gibidir.'>
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<cf_get_lang dictionary_id='64444.Firma bilgileriniz ile birlikte fatura adet ve  tutarlar??n?? kontrol edip, mutab??k olman??z halinde ka??eleyip imzalayarak, mutab??k  olmad??????n??z takdirde firma bilgileriniz ile hesap ekstrenizi taraf??m??za mail  veya faks yoluyla iletmenizi rica ederiz. Yada a??a????daki linklere t??klayarak mutab??k olup olmad??????n??z?? taraf??m??za iletebilirsiniz.'> <br /><br />
										<table>
											<tr>
												<td width="200" valign="top"><a href="#fusebox.server_machine_list#/wex.cfm/wutabakat?type=20648&cspid=#evaluate("attributes.company_id_#i#")#&uuid=#getrow.unique_id#&capyval=1395798571&mmxid=#attributes.cari_letter_id#&ocid=#session.ep.company_id#&pid=#session.ep.period_id#&isbxbsam=1" target="_blank" style="text-decoration:none;"><div class="divaccept"><cf_get_lang dictionary_id='58475.Onayla'></div></a><br /></td>
												<td width="200" valign="top"><a href="#fusebox.server_machine_list#/wex.cfm/wutabakat?type=20648&cspid=#evaluate("attributes.company_id_#i#")#&uuid=#getrow.unique_id#&capyval=1395798570&mmxid=#attributes.cari_letter_id#&ocid=#session.ep.company_id#&pid=#session.ep.period_id#&isbxbsam=1" target="_blank" style="text-decoration:none;"><div class="divcancel"><cf_get_lang dictionary_id='58461.Reddet'></div></a><br /><br /></td>
											</tr>
										</table><br><br>
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<cf_get_lang dictionary_id='48814.Sayg??lar??m??zla'>
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr>
									<td>
										<table border="0">
											<tr class="font_text">
												<td width="150"><cf_get_lang dictionary_id='63265.Firma ??nvan??'></td>
												<td>: #getcompany.fullname#</td>
											</tr>
											<tr class="font_text">
												<td><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
												<td>: #getcompany.taxoffice#</td>
											</tr>
											<tr class="font_text">
												<td><cf_get_lang dictionary_id='56085.Vergi Numaras??'></td>
												<td>: #getcompany.taxno#</td>
											</tr>
											<tr class="font_text">
												<td><cf_get_lang dictionary_id='63896.Telefon'></td>
												<td>: <cfif Len(getcompany.tel)>(#getcompany.telcode#) #getcompany.tel#<cfelse>&nbsp;</cfif></td>
											</tr>
											<tr class="font_text">
												<td><cf_get_lang dictionary_id='57488.Fax'></td>
												<td>: <cfif Len(getcompany.fax)>#getcompany.fax#<cfelse>&nbsp;</cfif></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr><td class="formbold">#dateformat(gettype.start_date,'dd/mm/yyyy')# - #dateformat(gettype.finish_date,'dd/mm/yyyy')# <cf_get_lang dictionary_id='60649.D??nemi BA-BS Raporu'></td></tr>
								<tr>
									<td>
										<table border="0" width="100%" align="center">
											<tr align="left" class="font_text">
												<td width="25%"><u><cf_get_lang dictionary_id='60230.BA'><cf_get_lang dictionary_id='39684.Belge Adedi'></u></td>
												<td width="25%"><u><cf_get_lang dictionary_id='60230.BA'><cf_get_lang dictionary_id='57673.Tutar'></u></td>
											</tr>
											<tr align="left" class="font_text">
												<td>#getrow.is_ba_total#</td>
												<td>#TLFormat(getrow.is_ba_amount,0)#</td>
											</tr>
											<tr><td height="50">&nbsp;</td></tr>
											<tr class="font_text">
												<td colspan="3">&nbsp;</td>
												<td><cf_get_lang dictionary_id='58957.??mza'></td>
											</tr>
										</table>
									</td>
								</tr>	
							</table>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<!---<cfif len(getour.ASSET_FILE_NAME3)>
								<cfset attributes.mail_logo = "documents/settings/"&getour.ASSET_FILE_NAME3>
							<cfelse>
								<cfset attributes.mail_logo = "documents/templates/info_mail/logobig.gif">
							</cfif>
							<img src="#user_domain##attributes.mail_logo#" align="absmiddle" border="0" /><br /><br /><br /><br />--->
							<b style="font-size:11px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;color :##333333;">
							#getour.company_name#<br /></b>
							<cf_get_lang dictionary_id='49272.Tel'> : #getour.tel_code# #getour.tel#<br />
							<cf_get_lang dictionary_id='57488.Fax'> : #getour.tel_code# #getour.fax#<br />
							<cf_get_lang dictionary_id='55484.E-Mail'> : #getour.email#<br />
							<cf_get_lang dictionary_id='46762.Web'> : #getour.web#<br />
							<cf_get_lang dictionary_id='63895.Adres'> : #getour.address# 
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
				</table>
				</cfmail>
			</cfif>
		</cfif>
		<!--- BS Hat??rlatma --->
		<cfif gettype.is_bs eq 1>
			<cfif len(asemail)>
				<cfquery name="UPDMAIN" datasource="#dsn2#">
					UPDATE 
						CARI_LETTER_ROW
					SET 
						IS_SEND = #session.ep.userid#,
						IS_SEND_DATE = #now()#,
						IS_SEND_IP = '#cgi.remote_addr#'
					WHERE 
						CARI_LETTER_ID = #attributes.cari_letter_id# AND 
						COMPANY_ID = #evaluate("attributes.company_id_#i#")#
				</cfquery> 
				<cfmail from="#getour.company_name#<#GETOUR.EMAIL#>" to="#asemail#" charset="utf-8" subject="BS Mutabakat Mektubu" type="html">
				<style type="text/css">
					.table,td {font-family: Verdana, Arial, Helvetica, sans-serif;}
					.font_text {font-size:11px;}
					.divaccept { background-color:##009900; color:##FFFFFF; font-weight:bold; font-size:14px; padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px; text-decoration:none; text-align:center}
					.divcancel { background-color:##990000; color:##FFFFFF; font-weight:bold; font-size:14px; padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px; text-decoration:none; text-align:center}
				</style>
				<table style="width:200mm;height:280mm;" border="0">
					<tr valign="top">
						<td style="width:5mm;">&nbsp;</td>
						<td>
							<cfif len(check.asset_file_name2)>
								<table border="0" cellpadding="<cfif isdefined("attributes.padding_off")>0<cfelse>10</cfif>" cellspacing="<cfif isdefined("attributes.padding_off")>0<cfelse>10</cfif>" bgcolor="FFFFFF" style="width : <cfoutput>#get_template_dimension.template_width#</cfoutput>">
									<tr> 
										<td style="width:20mm;height:20mm;" align="<cfoutput>#get_template_dimension.template_align#</cfoutput>">
											<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
										</td>
									</tr>
								</table>
							</cfif>
							<cfif isdefined("attributes.show_datetime") and attributes.show_datetime and (attributes.show_datetime eq 1)>
								<table cellpadding="10" cellspacing="10" bgcolor="FFFFFF" style="width : <cfoutput>#get_template_dimension.template_width##get_template_dimension.TEMPLATE_UNIT#</cfoutput>">
									<tr>
										<td align="<cfoutput>#get_template_dimension.template_align#</cfoutput>">
											<b><cfoutput>#dateformat(now(),'dd/mm/yyyy')# - #timeformat(date_add('H',session.ep.time_zone,now()),'HH:MM')#</cfoutput></b>
										</td>
									</tr>
								</table>
							</cfif>
						</td>
					</tr>
					<tr valign="top">
						<td style="width:5mm;">&nbsp;</td>
						<td>
							<table border="0">
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<cf_get_lang dictionary_id='49699.Say??n Yetkili'>
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<cf_get_lang dictionary_id='64439.381 S??ra Nolu Vergi Usul Kanunu Genel Tebli??i gere??ince, 213 say??l?? Vergi Usul Kanununun (1) 148, 149 ve M??kerrer 257 nci maddelerinin verdi??i yetkiye dayan??larak,
										362 S??ra Nolu Vergi Usul Kanunu Genel Tebli??i (2) ile bilan??o esas??na g??re defter tutan
										m??kelleflerin belirli bir haddi a??an mal ve hizmet al??mlar??n?? "Mal ve Hizmet Al??mlar??na ??li??kin
										Bildirim Formu (Form Ba)" ile;'><cf_get_lang dictionary_id='64440.mal ve hizmet sat????lar??n?? ise "Mal ve Hizmet Sat????lar??na ??li??kin Bildirim Formu (Form Bs)" ile vergilendirme d??nemini takip eden ay??n birinci g??n??nden itibaren son g??n?? ak??am??na kadar tebli?? etmesi gerekti??i a????klanm????t??r.'>
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<cf_get_lang dictionary_id='64441.2010 ve izleyen y??llar??n ayl??k d??nemlerine ili??kin mal ve/veya hizmet al????lar?? ile mal ve/veya hizmet sat????lar??na uygulanacak had 396 s??ra no.lu Tebli?? ile'> #TLFormat(gettype.babs_amount,0)# <cf_get_lang dictionary_id='64442.TL olarak belirlenmi??tir.'>
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										#dateformat(gettype.start_date,'dd/mm/yyyy')#&nbsp;-&nbsp;#dateformat(gettype.finish_date,'dd/mm/yyyy')#  <cf_get_lang dictionary_id='64443.itibar?? ile firman??z ile aram??zda  d??zenlenen fatura adedi ve tutarlar?? a??a????daki gibidir.'>
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<cf_get_lang dictionary_id='64444.Firma bilgileriniz ile birlikte fatura adet ve  tutarlar??n?? kontrol edip, mutab??k olman??z halinde ka??eleyip imzalayarak, mutab??k  olmad??????n??z takdirde firma bilgileriniz ile hesap ekstrenizi taraf??m??za mail  veya faks yoluyla iletmenizi rica ederiz. Yada a??a????daki linklere t??klayarak mutab??k olup olmad??????n??z?? taraf??m??za iletebilirsiniz.'> <br /><br />
										<table>
											<tr>
												<td width="200" valign="top"><a href="#fusebox.server_machine_list#/wex.cfm/wutabakat?type=20648&cspid=#evaluate("attributes.company_id_#i#")#&uuid=#getrow.unique_id#&capyval=1395798571&mmxid=#attributes.cari_letter_id#&ocid=#session.ep.company_id#&pid=#session.ep.period_id#&isbxbsam=1" target="_blank" style="text-decoration:none;"><div class="divaccept"><cf_get_lang dictionary_id='58475.Onayla'></div></a><br /></td>
												<td width="200" valign="top"><a href="#fusebox.server_machine_list#/wex.cfm/wutabakat?type=20648&cspid=#evaluate("attributes.company_id_#i#")#&uuid=#getrow.unique_id#&capyval=1395798570&mmxid=#attributes.cari_letter_id#&ocid=#session.ep.company_id#&pid=#session.ep.period_id#&isbxbsam=1" target="_blank" style="text-decoration:none;"><div class="divcancel"><cf_get_lang dictionary_id='58461.Reddet'></div></a><br /><br /></td>
											</tr>
										</table><br><br>
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr class="font_text">
									<td><p align="justify" style="line-height: 18px;">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<cf_get_lang dictionary_id='48814.Sayg??lar??m??zla'>
										</p>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr>
									<td>
										<table border="0">
											<tr class="font_text">
												<td width="150"><cf_get_lang dictionary_id='63265.Firma ??nvan??'></td>
												<td>: #getcompany.fullname#</td>
											</tr>
											<tr class="font_text">
												<td><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
												<td>: #getcompany.taxoffice#</td>
											</tr>
											<tr class="font_text">
												<td><cf_get_lang dictionary_id='56085.Vergi Numaras??'></td>
												<td>: #getcompany.taxno#</td>
											</tr>
											<tr class="font_text">
												<td><cf_get_lang dictionary_id='63896.Telefon'></td>
												<td>: <cfif Len(getcompany.tel)>(#getcompany.telcode#) #getcompany.tel#<cfelse>&nbsp;</cfif></td>
											</tr>
											<tr class="font_text">
												<td><cf_get_lang dictionary_id='57488.Fax'></td>
												<td>: <cfif Len(getcompany.fax)>#getcompany.fax#<cfelse>&nbsp;</cfif></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr style="height:15px;"><td>&nbsp;</td></tr>
								<tr><td class="formbold">#dateformat(gettype.start_date,'dd/mm/yyyy')# - #dateformat(gettype.finish_date,'dd/mm/yyyy')# <cf_get_lang dictionary_id='60649.D??nemi BA-BS Raporu'></td></tr>
								<tr>
									<td>
										<table border="0" width="100%" align="center">
											<tr align="left" class="font_text">
												<td width="25%"><u><cf_get_lang dictionary_id='60230.BA'><cf_get_lang dictionary_id='39684.Belge Adedi'></u></td>
												<td width="25%"><u><cf_get_lang dictionary_id='60230.BA'><cf_get_lang dictionary_id='57673.Tutar'></u></td>
											</tr>
											<tr align="left" class="font_text">
												<td>#getrow.is_bs_total#</td>
												<td>#TLFormat(getrow.is_bs_amount,0)#</td>
											</tr>
											<tr><td height="50">&nbsp;</td></tr>
											<tr class="font_text">
												<td colspan="3">&nbsp;</td>
												<td><cf_get_lang dictionary_id='58957.??mza'></td>
											</tr>
										</table>
									</td>
								</tr>	
							</table>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<!---<cfif len(getour.ASSET_FILE_NAME3)>
								<cfset attributes.mail_logo = "documents/settings/"&getour.ASSET_FILE_NAME3>
							<cfelse>
								<cfset attributes.mail_logo = "documents/templates/info_mail/logobig.gif">
							</cfif>
							<img src="#user_domain##attributes.mail_logo#" align="absmiddle" border="0" /><br /><br /><br /><br />--->
							<b style="font-size:11px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;color :##333333;">
							#getour.company_name#<br /></b>
							<cf_get_lang dictionary_id='49272.Tel'> : #getour.tel_code# #getour.tel#<br />
							<cf_get_lang dictionary_id='57488.Fax'> : #getour.tel_code# #getour.fax#<br />
							<cf_get_lang dictionary_id='55484.E-Mail'> : #getour.email#<br />
							<cf_get_lang dictionary_id='46762.Web'> : #getour.web#<br />
							<cf_get_lang dictionary_id='63895.Adres'> : #getour.address# 
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
				</table>
				</cfmail>
			</cfif>
		</cfif>
	</cfloop>
	<cflocation url="#request.self#?fuseaction=finance.list_cari_letter&event=upd&cari_letter_id=#attributes.cari_letter_id#" addtoken="no">
<cfelse>
	<script language="javascript">
		alert("<cf_get_lang dictionary_id='64403.Herhangi Bir Cari Se??mediniz!'>");
		window.location.href='<cfoutput>#request.self#?fuseaction=finance.list_cari_letter&event=upd&cari_letter_id=#attributes.cari_letter_id#</cfoutput>';
	</script>
</cfif>