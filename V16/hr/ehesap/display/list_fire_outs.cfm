<cfif not isdefined("attributes.in_out_ids")>
	<script>
		alert("<cf_get_lang dictionary_id='45506.Giriş Çıkış Kaydı Seçmelisiniz'>!");
		window.history.go(-2);
	</script>
	<cfabort>
</cfif>

<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
	<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
</cfif>

<cfset getComponent = createObject('component','V16.hr.ehesap.cfc.list_fire_in_out')>
<cfset GET_IN_OUTS = getComponent.GET_EMPLOYEE_OUT(in_out_ids :attributes.in_out_ids)>  


<!---- Nakil Olanlar Esma R. Uysal---->
<cfquery name="GET_IN_OUTS_TRANSFER" dbtype="query">
	SELECT * FROM GET_IN_OUTS WHERE EXPLANATION_ID = 18
</cfquery>

<cfquery name="GET_IN_OUTS_NOT_TRANSFER" dbtype="query">
	SELECT * FROM GET_IN_OUTS WHERE EXPLANATION_ID <> 18
</cfquery>
<cfif GET_IN_OUTS_NOT_TRANSFER.recordcount gt 0>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="45476.SGK Çıkış İşlemleri"></cfsavecontent>
	<cf_box title="#message#">
		<CFOUTPUT QUERY="GET_IN_OUTS_NOT_TRANSFER" GROUP="BRANCH_NAME">
			<cfsavecontent variable="xml_icerik_#BRANCH_ID#">
				<?xml version="1.0" encoding="iso-8859-9"?>
				<SGK4AISTENCIKIS>
					<ISYERI ISYERIADRES="#left(BRANCH_ADDRESS,50)#" ISYERIUNVAN="#left(BRANCH_FULLNAME,50)#" ISYERIARACINO="#iif(len(left(SSK_AGENT,3)) eq 3,"#left(SSK_AGENT,3)#","000")#" ISYERISICIL="#SSK_ISYERI#"/>
					<SIGORTALILAR>
						<CFOUTPUT>
							<cfset bu_ay_basi = createdate(YEAR(FINISH_DATE),MONTH(FINISH_DATE), 1)>
							<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>

							<cfquery name="get_izins" datasource="#dsn#">
								SELECT
									OFFTIME.EMPLOYEE_ID,
									SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
									SETUP_OFFTIME.SIRKET_GUN,
									OFFTIME.STARTDATE
								FROM
									OFFTIME, SETUP_OFFTIME
								WHERE
									SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
									AND SETUP_OFFTIME.IS_PAID = 0 
									AND OFFTIME.IS_PUANTAJ_OFF = 0
									AND OFFTIME.VALID = 1
									AND OFFTIME.STARTDATE <= #bu_ay_sonu#
									AND OFFTIME.FINISHDATE >= #bu_ay_basi#
									AND OFFTIME.EMPLOYEE_ID = #EMPLOYEE_ID#
								ORDER BY
									OFFTIME.EMPLOYEE_ID
							</cfquery>
							
							<cfif len(G_SAL_YEAR)>
								<cfset G_ay_basi = createdate(G_SAL_YEAR,G_SAL_MON, 1)>
								<cfset G_ay_sonu = date_add('s',-1,date_add('m',1,G_ay_basi))>
								<cfquery name="get_izins_old" datasource="#dsn#">
									SELECT
										OFFTIME.EMPLOYEE_ID,
										SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
										SETUP_OFFTIME.SIRKET_GUN,
										OFFTIME.STARTDATE
									FROM
										OFFTIME, SETUP_OFFTIME
									WHERE
										SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
										AND SETUP_OFFTIME.IS_PAID = 0 
										AND OFFTIME.IS_PUANTAJ_OFF = 0
										AND OFFTIME.VALID = 1
										AND OFFTIME.STARTDATE <= #G_ay_sonu#
										AND OFFTIME.FINISHDATE >= #G_ay_basi#
										AND OFFTIME.EMPLOYEE_ID = #EMPLOYEE_ID#
									ORDER BY
										OFFTIME.EMPLOYEE_ID
								</cfquery>
							</cfif>

							<cfif BUDONEM_TOTAL_KAZANC gte BUDONEM_MATRAH>
								<cfif len(BUDONEM_TOTAL_IKRAMIYE)>
									<cfset pikramiye = budonem_total_ikramiye>
								<cfelse>
									<cfset pikramiye = 0>
								</cfif>
								
							<cfelse>
								<cfset pikramiye = wrk_round(BUDONEM_MATRAH - BUDONEM_TOTAL_KAZANC)>
							</cfif>
							
							<cfif GDONEM_TOTAL_KAZANC gte GDONEM_MATRAH>
								<cfif len(GDONEM_TOTAL_IKRAMIYE)>
									<cfset Gpikramiye = GDONEM_TOTAL_IKRAMIYE>
								<cfelse>
									<cfset Gpikramiye = 0>
								</cfif>
							<cfelse>
								<cfset Gpikramiye = wrk_round(GDONEM_MATRAH - GDONEM_TOTAL_KAZANC)>
							</cfif>
							
							<cfscript>
								eksik_neden_id = 13;
								if (BUDONEM_IZIN gt 0)
								{
								get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins");
								eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
								if (not len(eksik_neden_id) AND DUTY_TYPE EQ 6) eksik_neden_id = 6;
								if (not len(eksik_neden_id)) eksik_neden_id = 13;
								if (get_emp_izins_2.recordcount gte 2)
									for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
										if (get_emp_izins_2.EBILDIRGE_TYPE_ID[geii-1] neq get_emp_izins_2.EBILDIRGE_TYPE_ID[geii])
											eksik_neden_id = 12; // birden fazla
								}
								
								g_eksik_neden_id = 13;
								if (GDONEM_IZIN gt 0)
								{
								get_emp_izins_3 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins_old");
								g_eksik_neden_id = get_emp_izins_3.EBILDIRGE_TYPE_ID;
								if (not len(g_eksik_neden_id) AND DUTY_TYPE EQ 6) g_eksik_neden_id = 6;
								if (not len(g_eksik_neden_id)) g_eksik_neden_id = 13;
								if (get_emp_izins_3.recordcount gte 2)
									for (geii=2; geii lte get_emp_izins_3.recordcount; geii=geii+1)
										if (get_emp_izins_3.EBILDIRGE_TYPE_ID[geii-1] neq get_emp_izins_3.EBILDIRGE_TYPE_ID[geii])
											g_eksik_neden_id = 12; // birden fazla
								}
								if(len(BUDONEM_TOTAL_IKRAMIYE) and budonem_matrah gte budonem_total_ikramiye)
									bu_donem_hakedilen = budonem_matrah-budonem_total_ikramiye;
								else if(len(BUDONEM_TOTAL_IKRAMIYE) and budonem_matrah lte budonem_total_ikramiye)
								{
									bu_donem_hakedilen = budonem_matrah;
								}
								else
									bu_donem_hakedilen = budonem_matrah;
									
								if(len(gdonem_total_ikramiye))
									gecmis_donem_hakedilen = gdonem_matrah-gdonem_total_ikramiye;
								else if(len(gdonem_matrah))
									gecmis_donem_hakedilen = gdonem_matrah;
								else
									gecmis_donem_hakedilen = 0;
							</cfscript>
							<cfset kod_ = numberformat(ListGetAt(law_list(),explanation_id,","),'00')>
							<SIGORTALI 
								UCRETYUZDEUSULU="H" 
								CSGBISKOLU="#BRANCH_WORK#" 
								ISTENAYRILISNEDENI="#kod_#"
								MESLEKKODU="#BUSINESS_CODE#" 
								ISTENCIKISTARIHI="#dateformat(FINISH_DATE,'yyyy-mm-dd')#" SOYAD="#EMPLOYEE_SURNAME#" AD="#EMPLOYEE_NAME#" TCKNO="#TC_IDENTY_NO#">
								<ONCEKIDONEM 
									<cfif GDONEM_IZIN gt 0>
										EKSIKGUNSAYISI="#GDONEM_IZIN#" 
										EKSIKGUNNEDENI="#g_eksik_neden_id#"
									</cfif>
									PRIMIKRAMIYE="#Gpikramiye#" 
									<cfif len(gecmis_donem_hakedilen)>
									HAKEDILENUCRET="#gecmis_donem_hakedilen#" 
									<cfelse>
									HAKEDILENUCRET="0" 
									</cfif>
									BELGETURU="#SSK_STATUTE#"/>
								<BULUNDUGUMUZDONEM 							
									PRIMIKRAMIYE="#pikramiye#" 
									<cfif BUDONEM_IZIN gt 0>
										EKSIKGUNSAYISI="#BUDONEM_IZIN#" 
										EKSIKGUNNEDENI="#eksik_neden_id#"
									</cfif>
									HAKEDILENUCRET="#bu_donem_hakedilen#" 
									BELGETURU="#SSK_STATUTE#"/>
							</SIGORTALI>
						</CFOUTPUT>
					</SIGORTALILAR>
				</SGK4AISTENCIKIS>
			</cfsavecontent>
			<!--branch name göre farklı xml dosyası olusturuyoruz-->
			<cffile 
				action="write" 
				file="#upload_folder#reserve_files\#drc_name_#\user_id_#session.ep.userid#_sube_id_#BRANCH_ID#_sgk_cikis.xml" 
				nameconflict="overwrite"
				charset ="iso-8859-9"
				output="#trim(evaluate('xml_icerik_#BRANCH_ID#'))#"
			>	
			#BRANCH_NAME# <cf_get_lang dictionary_id="45479.için ürettiğiniz xml file"> : <a href="/documents/reserve_files/#drc_name_#/user_id_#session.ep.userid#_sube_id_#BRANCH_ID#_sgk_cikis.xml" class="tableyazi">user_id_#session.ep.userid#_sube_id_#BRANCH_ID#_sgk_cikis.xml</a> (<cf_get_lang dictionary_id="45509.Farklı Kaydet Diyebilirsiniz">!) <br><br>
		</CFOUTPUT>
	</cf_box>
</cfif>

<cfif GET_IN_OUTS_TRANSFER.recordcount gt 0>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="45476.SGK Çıkış İşlemleri">(Nakil)</cfsavecontent>
	<cf_box title="#message#">
		<CFOUTPUT QUERY="GET_IN_OUTS_TRANSFER" GROUP="BRANCH_NAME">
			<CFOUTPUT GROUP="TRANSFER_SSK_SICIL">
				<cfsavecontent variable="xml_icerik_#currentrow#">
					<?xml version="1.0" encoding="iso-8859-9"?>
					<SGK4AISTENCIKIS>
						<ISYERI ISYERISICIL="#SSK_ISYERI#" ISYERIARACINO="#iif(len(left(SSK_AGENT,3)) eq 3,"#left(SSK_AGENT,3)#","000")#" ISYERIUNVAN="#left(BRANCH_FULLNAME,50)#" NAKILGIDECEGIISYERISICIL="#TRANSFER_SSK_SICIL#" ISYERIADRES="#left(BRANCH_ADDRESS,50)#"/>
						<SIGORTALILAR>
							<CFOUTPUT>
								<cfset bu_ay_basi = createdate(YEAR(FINISH_DATE),MONTH(FINISH_DATE), 1)>
								<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>
								<cfquery name="get_izins" datasource="#dsn#">
									SELECT
										OFFTIME.EMPLOYEE_ID,
										SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
										SETUP_OFFTIME.SIRKET_GUN,
										OFFTIME.STARTDATE
									FROM
										OFFTIME, SETUP_OFFTIME
									WHERE
										SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
										AND SETUP_OFFTIME.IS_PAID = 0 
										AND OFFTIME.IS_PUANTAJ_OFF = 0
										AND OFFTIME.VALID = 1
										AND OFFTIME.STARTDATE <= #bu_ay_sonu#
										AND OFFTIME.FINISHDATE >= #bu_ay_basi#
										AND OFFTIME.EMPLOYEE_ID = #EMPLOYEE_ID#
									ORDER BY
										OFFTIME.EMPLOYEE_ID
								</cfquery>
								
								<cfif len(G_SAL_YEAR)>
									<cfset G_ay_basi = createdate(G_SAL_YEAR,G_SAL_MON, 1)>
									<cfset G_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>
									<cfquery name="get_izins_old" datasource="#dsn#">
										SELECT
											OFFTIME.EMPLOYEE_ID,
											SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
											SETUP_OFFTIME.SIRKET_GUN,
											OFFTIME.STARTDATE
										FROM
											OFFTIME, SETUP_OFFTIME
										WHERE
											SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
											AND SETUP_OFFTIME.IS_PAID = 0 
											AND OFFTIME.IS_PUANTAJ_OFF = 0
											AND OFFTIME.VALID = 1
											AND OFFTIME.STARTDATE <= #G_ay_sonu#
											AND OFFTIME.FINISHDATE >= #G_ay_basi#
											AND OFFTIME.EMPLOYEE_ID = #EMPLOYEE_ID#
										ORDER BY
											OFFTIME.EMPLOYEE_ID
									</cfquery>
								</cfif>

								<cfif BUDONEM_TOTAL_KAZANC gte BUDONEM_MATRAH>
									<cfif len(BUDONEM_TOTAL_IKRAMIYE)>
										<cfset pikramiye = budonem_total_ikramiye>
									<cfelse>
										<cfset pikramiye = 0>
									</cfif>
									
								<cfelse>
									<cfset pikramiye = wrk_round(BUDONEM_MATRAH - BUDONEM_TOTAL_KAZANC)>
								</cfif>
								
								<cfif GDONEM_TOTAL_KAZANC gte GDONEM_MATRAH>
									<cfif len(GDONEM_TOTAL_IKRAMIYE)>
										<cfset Gpikramiye = GDONEM_TOTAL_IKRAMIYE>
									<cfelse>
										<cfset Gpikramiye = 0>
									</cfif>
								<cfelse>
									<cfset Gpikramiye = wrk_round(GDONEM_MATRAH - GDONEM_TOTAL_KAZANC)>
								</cfif>
								
								<cfscript>
									eksik_neden_id = 13;
									if (BUDONEM_IZIN gt 0)
									{
									get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins");
									eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
									if (not len(eksik_neden_id) AND DUTY_TYPE EQ 6) eksik_neden_id = 6;
									if (not len(eksik_neden_id)) eksik_neden_id = 13;
									if (get_emp_izins_2.recordcount gte 2)
										for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
											if (get_emp_izins_2.EBILDIRGE_TYPE_ID[geii-1] neq get_emp_izins_2.EBILDIRGE_TYPE_ID[geii])
												eksik_neden_id = 12; // birden fazla
									}
									
									g_eksik_neden_id = 13;
									if (GDONEM_IZIN gt 0)
									{
									get_emp_izins_3 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins_old");
									g_eksik_neden_id = get_emp_izins_3.EBILDIRGE_TYPE_ID;
									if (not len(g_eksik_neden_id) AND DUTY_TYPE EQ 6) g_eksik_neden_id = 6;
									if (not len(g_eksik_neden_id)) g_eksik_neden_id = 13;
									if (get_emp_izins_3.recordcount gte 2)
										for (geii=2; geii lte get_emp_izins_3.recordcount; geii=geii+1)
											if (get_emp_izins_3.EBILDIRGE_TYPE_ID[geii-1] neq get_emp_izins_3.EBILDIRGE_TYPE_ID[geii])
												g_eksik_neden_id = 12; // birden fazla
									}
									if(len(BUDONEM_TOTAL_IKRAMIYE))
										bu_donem_hakedilen = budonem_matrah-budonem_total_ikramiye;
									else
										bu_donem_hakedilen = budonem_matrah;
										
									if(len(gdonem_total_ikramiye))
										gecmis_donem_hakedilen = gdonem_matrah-gdonem_total_ikramiye;
									else if(len(gdonem_matrah))
										gecmis_donem_hakedilen = gdonem_matrah;
									else
										gecmis_donem_hakedilen = 0;
								</cfscript>
								<cfset kod_ = numberformat(ListGetAt(law_list(),explanation_id,","),'00')>
								<SIGORTALI 
									UCRETYUZDEUSULU="H" 
									CSGBISKOLU="#BRANCH_WORK#" 
									ISTENAYRILISNEDENI="#kod_#"
									MESLEKKODU="#BUSINESS_CODE#" 
									ISTENCIKISTARIHI="#dateformat(FINISH_DATE,'yyyy-mm-dd')#" SOYAD="#EMPLOYEE_SURNAME#" AD="#EMPLOYEE_NAME#" TCKNO="#TC_IDENTY_NO#">
									<ONCEKIDONEM 
										<cfif GDONEM_IZIN gt 0>
											EKSIKGUNSAYISI="#GDONEM_IZIN#" 
											EKSIKGUNNEDENI="#g_eksik_neden_id#"
										</cfif>
										PRIMIKRAMIYE="#Gpikramiye#" 
										<cfif len(gecmis_donem_hakedilen)>
										HAKEDILENUCRET="#gecmis_donem_hakedilen#" 
										<cfelse>
										HAKEDILENUCRET="0" 
										</cfif>
										BELGETURU="#SSK_STATUTE#"/>
									<BULUNDUGUMUZDONEM 							
										PRIMIKRAMIYE="#pikramiye#" 
										<cfif BUDONEM_IZIN gt 0>
											EKSIKGUNSAYISI="#BUDONEM_IZIN#" 
											EKSIKGUNNEDENI="#eksik_neden_id#"
										</cfif>
										HAKEDILENUCRET="#bu_donem_hakedilen#" 
										BELGETURU="#SSK_STATUTE#"/>
								</SIGORTALI>
							</CFOUTPUT>
						</SIGORTALILAR>
					</SGK4AISTENCIKIS>
				</cfsavecontent>
				<!--branch name göre farklı xml dosyası olusturuyoruz-->
				<cffile 
					action="write" 
					file="#upload_folder#reserve_files\#drc_name_#\user_id_#session.ep.userid#_sube_id_#BRANCH_ID#_#BRANCH_NAME#_#currentrow#_sgk_cikis.xml" 
					nameconflict="overwrite"
					charset ="iso-8859-9"
					output="#trim(evaluate('xml_icerik_#currentrow#'))#"
				>	
				#BRANCH_NAME# <cf_get_lang dictionary_id="45479.için ürettiğiniz xml file"> : <a href="/documents/reserve_files/#drc_name_#/user_id_#session.ep.userid#_sube_id_#BRANCH_ID#_#BRANCH_NAME#_#currentrow#_sgk_cikis.xml" class="tableyazi">user_id_#session.ep.userid#_sube_id_#currentrow#_sgk_cikis.xml</a> (<cf_get_lang dictionary_id="45509.Farklı Kaydet Diyebilirsiniz">!) <br><br>
			</CFOUTPUT>
		</CFOUTPUT>
	</cf_box>
	<cf_box title="Nakil Giriş İşlemleri">
		<CFOUTPUT QUERY="GET_IN_OUTS_TRANSFER" GROUP="SSK_ISYERI">
			<cfset actionid_list = ''>
			<cfoutput>
				<cfset actionid_list = ListAppend(actionid_list,GET_IN_OUTS_TRANSFER.IN_OUT_ID,',')>
			</cfoutput>
			<cfinclude template = "list_fire_ins.cfm">
		</CFOUTPUT>
	</cf_box>
</cfif>