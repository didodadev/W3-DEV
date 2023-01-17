<cfset attributes.empapp_id = attributes.id>
<cfset empapp_id = attributes.id>
<cfset names="yes">
<cfset xfa.upd= "hr.emptypopup_upd_app">
<cfset xfa.del= "hr.emptypopup_del_app">
<cfset xfa.start= "hr.start_employee">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_mobil_cats.cfm">
<cfinclude template="../query/get_app.cfm">
<cfquery name="get_emp_reference" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_REFERENCE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
</cfquery>
<cfquery name="get_emp_language" datasource="#dsn#">
	SELECT 
		EMPAPP_ID,
		LANG_ID,
		LANG_SPEAK,
		LANG_WRITE,
		LANG_MEAN,
		LANG_WHERE 
	FROM 
		EMPLOYEES_APP_LANGUAGE
	WHERE
		EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
</cfquery>
<table align="center" width="750">
	<tr>
		<td valign="top" width="610">
		<!--- başvuru bilgileri --->
		<table width="100%" border="1" cellspacing="0" cellpadding="0" height="100%">
			<tr>
				<td valign="top">
					<table>
						<tr>
							<td colspan="4" class="txtboldblue"><cf_get_lang dictionary_id="49315.Başvuru Bilgileri"></td>
						</tr>
						<tr>
							<td width="150" class="txtbold"><cf_get_lang dictionary_id="57756.Durum"></td>
							<td width="150"><cfif get_app.app_status eq 1><cf_get_lang dictionary_id="57493.Aktif"><cfelse><cf_get_lang dictionary_id="57494.Pasif"></cfif></td>
							<td width="70" class="txtbold"><cf_get_lang dictionary_id="32508.E-mail"></td>
							<td><cfoutput>#get_app.email#</cfoutput></td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="29514.Başvuru Yapan"></td>
							<td><cfoutput>#get_app.name# #get_app.surname#</cfoutput></td>
							<td class="txtbold"><cf_get_lang dictionary_id="57499.Telefon"></td>
							<td><cfoutput> #get_app.worktelcode# - #get_app.worktel# - #get_app.extension# </cfoutput></td>
						</tr>
					<tr>
						<td class="txtbold"></td>
						<td></td>
						<td class="txtbold"><cf_get_lang dictionary_id="58482.Mobil Tel"></td>
						<td> 
							<cfoutput query="mobil_cats">
								<cfif get_app.mobilcode eq mobilcat>
									#mobilcat#
								</cfif>
							</cfoutput> 
							<cfoutput>#get_app.mobil#</cfoutput>
						</td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id="31954.İstenen Ücret"></td>
						<td><cfoutput>#TLFormat(get_app.salary_wanted)#</cfoutput>
							<cfoutput query="get_moneys">
								<cfif get_app.salary_wanted_money eq money>
									#money#
								</cfif>
							</cfoutput>
						</td>
						<td class="txtbold"><cf_get_lang dictionary_id="57752.Vergi No"></td>
						<td><cfoutput>#get_app.tax_number#</cfoutput></td>
					</tr>
				</table>
				<cfoutput>
					<table>
						<tr>
							<td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id="58143.İletişim"></td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="31261.Ev Tel"></td>
							<td> #get_app.hometelcode# #get_app.hometel#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="58723.Adres"></td>
							<td>#get_app.homeaddress# #get_app.homecounty# #get_app.homecity# #get_app.homecountry# - #get_app.homepostcode#</td>
						</tr>
					</table>
				</cfoutput>
				</td>
			</tr>
		</table>
		<!--- başvuru bilgileri --->
		</td>
		<td width="140" height="160">
			<!--- resim --->
			<table width="100%" border="1" cellspacing="0" cellpadding="0" height="100%">
				<tr>
					<td align="center" style="width:150px;">
						<cfif LEN(get_app.photo)>
							<cf_get_server_file output_file="hr/#get_app.photo#" output_server="#get_app.photo_server_id#" output_type="0" image_link="1"  image_width="120">
						<cfelse>
							<cf_get_lang dictionary_id="55110.Foto">
						</cfif>
					</td>
				</tr>
			</table>
			<!--- resim --->
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table width="100%" border="1" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2" valign="top">
					<!--- kişisel --->
					<cfoutput>
					<table>
						<tr>
							<td colspan="6" class="txtboldblue"><cf_get_lang dictionary_id="51711.Kişisel Bilgiler"></td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="35918.Ek Kart Tipi- No"></td>
							<td width="100"> #get_app.identycard_cat# - #get_app.identycard_no#</td>
							<td class="txtbold"><cf_get_lang dictionary_id="31232.Özürlü"> </td>
							<td width="100">
								<cfif get_app.defected eq 1><cf_get_lang dictionary_id="57495.Evet"></cfif>
								<cfif get_app.defected eq 0><cf_get_lang dictionary_id="57496.Hayır"> </cfif>
							</td>
							<td class="txtbold"><cf_get_lang dictionary_id="31675.Göçmen"></td>
							<td>
								<cfif get_app.immigrant EQ 1><cf_get_lang dictionary_id="57495.Evet"> </cfif>
								<cfif get_app.immigrant EQ 0><cf_get_lang dictionary_id="57496.Hayır"> </cfif>
							</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="33779.SGK No"></td>
							<td>#get_app.socialsecurity_no# </td>
						</tr>     
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="57764.Cinsiyet"></td>
							<td><cfif get_app.sex eq 1><cf_get_lang dictionary_id="58959.Erkek"></cfif><cfif get_app.sex eq 0><cf_get_lang dictionary_id="58958.Kadın"></cfif></td>
							<td class="txtbold"><cf_get_lang dictionary_id="31670.Hüküm Giydi mi">?</td>
							<td><cfif get_app.sentenced EQ 1> <cf_get_lang dictionary_id="57495.Evet"></cfif><cfif get_app.sentenced EQ 0><cf_get_lang dictionary_id="57496.Hayır">  </cfif></td>
							<td class="txtbold"><cf_get_lang dictionary_id="35917.Çocuk"></td>
							<td>#get_app.child#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="31663.Eşinin Çiş. Şirket"></td>
							<td colspan="3">#get_app.partner_company# (#get_app.partner_position#)</td>
							<td class="txtbold"><cf_get_lang dictionary_id="40503.Askerlik"></td>
							<td>
								<cfif get_app.military_status EQ 0><cf_get_lang dictionary_id="31210.Yapmadı"> </cfif>
								<cfif get_app.military_status EQ 1><cf_get_lang dictionary_id="44595.Yaptı"> </cfif>
								<cfif get_app.military_status EQ 2><cf_get_lang dictionary_id="31212.Muaf"> </cfif>
								<cfif get_app.military_status EQ 3><cf_get_lang dictionary_id="31213.Yabancı"> </cfif>
								<cfif get_app.military_status EQ 4><cf_get_lang dictionary_id="31214.Tecilli"> </cfif>
							</td>
						</tr>
						<tr>
							<td colspan="6"><span class="txtbold"><cf_get_lang dictionary_id="31677.Bir suç zannıyla tutuklandınız mı veya mahkumiyetiniz oldu mu?"></span>
							&nbsp;<cfif get_app.defected_probability EQ 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif>              
							</td>
						</tr>
						<tr>
							<td colspan="6"><span class="txtbold"><cf_get_lang dictionary_id="31679.Devam eden bir hastalık veya bedeni sorununuz var mı">?</span>            
								<cfif get_app.illness_probability EQ 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif>
							</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="31371.Varsa nedir"></td>
							<td colspan="5">#get_app.illness_detail#</td>
						</tr>
					</table>
					<!--- kişisel --->
					<table>
						<tr>
							<td colspan="3" class="txtboldblue"><cf_get_lang dictionary_id="35916.Referanslar"></td>
						</tr>
						<cfloop query="get_emp_reference">
							<tr>
								<td colspan="3"><li></li>#REFERENCE_NAME# (#REFERENCE_COMPANY# - #REFERENCE_POSITION#) / #REFERENCE_TELCODE# #REFERENCE_TEL# (#REFERENCE_EMAIL#)</li></td>
							</tr>
						</cfloop>
					</table>
					<br/>
					<cfquery name="get_app_edu_info" datasource="#dsn#">
						SELECT * FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #attributes.empapp_id# ORDER BY EDU_START ASC
					</cfquery>
					<table>
						<tr>
							<td colspan="8" class="txtboldblue"><cf_get_lang dictionary_id="30644.Eğitim Bilgileri"></td>
						</tr>
						<cfloop query="get_app_edu_info">
							<tr>
								<td class="txtbold"><cfif get_app_edu_info.edu_type eq 1><cf_get_lang dictionary_id="30478.İlkOkul"><cfelseif get_app_edu_info.edu_type eq 2><cf_get_lang dictionary_id="30479.Ortaokul"><cfelseif get_app_edu_info.edu_type eq 3><cf_get_lang dictionary_id="30480.Lise"><cfelseif get_app_edu_info.edu_type eq 4><cf_get_lang dictionary_id="29755.Üniversite"><cfelseif get_app_edu_info.edu_type eq 5><cf_get_lang dictionary_id="30483.Yüksek Lisans"></cfif></td>
								<td>#get_app_edu_info.edu_name#
									<cfif get_app_edu_info.edu_type eq 1>#get_app_edu_info.edu_finish#<cfelseif get_app_edu_info.edu_type eq 2>#get_app_edu_info.edu_finish#<cfelseif get_app_edu_info.edu_type eq 3>#get_app_edu_info.edu_finish#<cfelseif get_app_edu_info.edu_type eq 4>#get_app_edu_info.edu_start# - #get_app_edu_info.edu_finish#<cfelseif get_app_edu_info.edu_type eq 5>/ #get_app_edu_info.edu_part_name# #get_app_edu_info.edu_finish# </cfif>
								</td>
							</tr>
						</cfloop>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="31303.Diller"></td>
							<td>
								<cfquery name="get_emp_language" datasource="#dsn#">
									SELECT 
										LANGUAGE_SET
									FROM 
										EMPLOYEES_APP_LANGUAGE,
										SETUP_LANGUAGES
									WHERE
										EMPLOYEES_APP_LANGUAGE.EMPAPP_ID = #EMPAPP_ID#
										AND LANG_ID = LANGUAGE_ID 
								</cfquery>
								<cfloop query="get_emp_language">
									#get_emp_language.LANGUAGE_SET#,
								</cfloop>
							</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="55683.Kurs-Sertifika"></td>
							<td colspan="5">#get_app.KURS1# , #get_app.KURS2# , #get_app.KURS3#</td>
						</tr>		 
					</table>
					<br/>
					</cfoutput>		
					</td>
				</tr>
				<tr>
					<td width="440">
						<cfoutput>
						<cfquery name="get_app_work_info" datasource="#dsn#">
							SELECT * FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #attributes.empapp_id# ORDER BY EXP_START DESC
						</cfquery>
						<cfif get_app_work_info.recordcount>
							<table>
								<tr>
									<td colspan="4" class="txtboldblue"><cf_get_lang dictionary_id="35080.Deneyim Bilgileri"></td>
								</tr>
								<cfloop query="get_app_work_info">
									<tr>
										<td colspan="4" valign="top" class="txtbold">
											#get_app_work_info.exp#-#get_app_work_info.exp_position#-#dateformat(get_app_work_info.exp_finish,'mm/yyyy')#
										</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id="31530.Ayrılma nedeni"></td>
										<td colspan="3">#get_app_work_info.exp_reason#</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id="55330.Ek açıklamalar"></td>
										<td colspan="3">#get_app_work_info.exp_extra#</td>
									</tr>
									<tr>
										<td valign="top">&nbsp;</td>
										<td colspan="3">&nbsp;</td>
									</tr>
								</cfloop>
							</table>
						</cfif>
					</cfoutput>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<table>
							<tr>
								<td width="200" class="txtbold"><cf_get_lang dictionary_id="31703.Çalışmak İstediğiniz Şehir"></td>
								<td><cfoutput>#get_app.PREFERED_CITY#</cfoutput></td>
							</tr>
							<tr>
								<td class="txtbold"><cf_get_lang dictionary_id="31705.Seyahat Edebilir misiniz">?</td>
								<td><cfif get_app.IS_TRIP IS 1> <cf_get_lang dictionary_id="57495.Evet"></cfif>
								<cfif get_app.IS_TRIP IS 0 OR get_app.IS_TRIP IS ""> <cf_get_lang dictionary_id="57496.Hayır"></cfif></td>
							</tr>
							<tr>
								<td class="txtbold"><cf_get_lang dictionary_id="35073.İşe Başlayabileceğiniz Tarih"></td>
								<td><cfoutput>#dateformat(get_app.STARTDATE_IF_ACCEPTED,dateformat_style)#</cfoutput></td>
							</tr>		
						</table>
						<table width="700">
							<tr>
								<td class="txtboldblue"><cf_get_lang dictionary_id="31707.Eklemek İstedikleriniz"></td>
								<td class="txtboldblue">&nbsp;</td>
							</tr>
							<tr>
								<td><cfoutput>#GET_APP.APPLICANT_NOTES#</cfoutput></td>
								<td>&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>  
		</td>
	</tr>
</table>
