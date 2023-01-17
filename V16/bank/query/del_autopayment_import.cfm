<!--- otomatik ödeme işlemini geri alma sayfasıdır --->
<!--- dbs icin silme islemi yapildi 20121206 --->
<cfset CRLF = Chr(13)&Chr(10)><!--- satır atlama karakteri --->
<cfquery name="GET_IMPORT" datasource="#DSN2#">
	SELECT SOURCE_SYSTEM,FILE_NAME,FILE_CONTENT,IS_DBS FROM FILE_IMPORTS WHERE PROCESS_TYPE = -12 AND I_ID = #attributes.export_import_id# AND IMPORTED = 1
</cfquery>
<cfquery name="get_old_period" datasource="#dsn#">
	SELECT PERIOD_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR=#session.ep.period_year - 1#
</cfquery>
<cfif get_old_period.recordcount>
	<cfset old_dsn2 = '#dsn#_#get_old_period.period_year#_#session.ep.company_id#'>
	<cfset old_period_id = get_old_period.period_id>
</cfif>
<cfif get_import.recordcount>
	<cfif not len(get_import.file_content)>
		<script language="JavaScript">
			alert("<cf_get_lang no ='389.Şifrenizi Kontrol Ediniz'>!");
				opener.location.reload();
				window.close();
		</script>
		<cfabort>
	</cfif>
	<cfif is_encrypt_file eq 1>
		<cfset file_content_result = Decrypt(get_import.file_content,attributes.key_type,"CFMX_COMPAT","Hex")>
	<cfelse>
		<cfset file_content_result = get_import.file_content>
	</cfif>
	<cfset dosya = ListToArray(file_content_result,CRLF)>
	<cfif is_encrypt_file eq 1>
		<cfif not(left(file_content_result,1) eq "H" or left(file_content_result,2) eq "10")><!--- encrypt in doğru açılması kontrolu --->
			<script language="JavaScript">
				alert("<cf_get_lang no ='389.Şifrenizi Kontrol Ediniz'>!");
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>opener.location.reload();window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<cfscript>
		ArrayDeleteAt(dosya,1);//header satırını silmek için
		line_count = ArrayLen(dosya);
	</cfscript>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfif GET_IMPORT.IS_DBS eq 1>
				<cfloop from="1" to="#line_count#" index="i">
					<cftry>
						<cflock name="#CreateUUID()#" timeout="20">
							<cftransaction>
								<cfscript>
									satir = dosya[i];
									prov_row_id = val(oku(satir,113,20));	//prov satır idsi
								</cfscript>
								<cfquery name="UPD_INVOICE_PAYMENT_PLAN" datasource="#DSN2#"><!--- odeme islemi geri alinir, gerekli alanlara NULL set edilir --->
									UPDATE
										#dsn3_alias#.INVOICE_PAYMENT_PLAN
									SET
										IS_PAID = 0,
										RESULT_CODE = NULL,
										RESULT_DETAIL = NULL,
										BANK_ACTION_ID = NULL,
										BANK_PERIOD_ID = NULL,
                                        PAYMENT_DATE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										INVOICE_PAYMENT_PLAN_ID = #prov_row_id#
								</cfquery>
							</cftransaction>
						</cflock>
						<cfcatch>
							<cfoutput>
								#i#. <cf_get_lang no="119.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir"><br/>
							</cfoutput>
							<cfabort>
						</cfcatch>
					</cftry>
				</cfloop>
			<cfelse>
				<cfif get_import.source_system eq 30><!--- HSBC --->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırını almamak için --->
						<cfscript>
							satir = dosya[i];
							prov_row_id = oku(satir,24,12);//prov satır idsi
							invoice_id = oku(satir,12,12);//invoice idsi
						</cfscript>
						<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
							SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
						</cfquery>
						<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#DSN2#">
							UPDATE
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
							SET
								IS_PAID = 0,
								CARI_ACTION_ID = NULL,
								CARI_PERIOD_ID = NULL,
								CARI_ACT_TYPE = NULL,
								CARI_ACT_ID = NULL,
								CARI_ACT_TABLE = NULL,
								UPDATE_DATE = #now()#,
								UPDATE_IP = '#cgi.remote_addr#',
								UPDATE_EMP = #session.ep.userid#
							WHERE
								SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
								AND 
								(
									(
										CARI_ACT_ID IS NOT NULL
										AND CARI_ACT_TYPE = 24
										AND CARI_ACT_ID IN
										(
											SELECT ACTION_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#
										)
									)
								)
						</cfquery>
						<cfquery name="get_period_year" datasource="#dsn2#">
							SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
						</cfquery>
						<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
						<cfquery name="upd_inv" datasource="#dsn2#">
							UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = NULL,BANK_PERIOD_ID = NULL WHERE INVOICE_ID = #invoice_id#
						</cfquery>
					</cfloop>
				<cfelseif get_import.source_system eq 31><!--- Finansbank --->
					<cfloop from="1" to="#line_count-1#" index="i">
						<cfscript>
							satir = dosya[i];
							prov_row_id = oku(satir,64,12);//prov satır idsi
							invoice_id = oku(satir,14,12);//invoice idsi
						</cfscript>
						<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
							SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
						</cfquery>
						<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#DSN2#">
							UPDATE
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
							SET
								IS_PAID = 0,
								CARI_ACTION_ID = NULL,
								CARI_PERIOD_ID = NULL,
								CARI_ACT_TYPE = NULL,
								CARI_ACT_ID = NULL,
								CARI_ACT_TABLE = NULL,
								UPDATE_DATE = #now()#,
								UPDATE_IP = '#cgi.remote_addr#',
								UPDATE_EMP = #session.ep.userid#
							WHERE
								SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
								AND 
								(
									(
										CARI_ACT_ID IS NOT NULL
										AND CARI_ACT_TYPE = 24
										AND CARI_ACT_ID IN
										(
											SELECT ACTION_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#
										)
									)
								)
						</cfquery>
						<cfquery name="get_period_year" datasource="#dsn2#">
							SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
						</cfquery>
						<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
						<cfquery name="upd_inv" datasource="#dsn2#">
							UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = NULL,BANK_PERIOD_ID = NULL WHERE INVOICE_ID = #invoice_id#
						</cfquery>
					</cfloop>
				<cfelseif get_import.source_system eq 32><!--- İşBankası --->
					<cfloop from="1" to="#line_count-2#" index="i"><!--- trailer satırını almamak için --->
						<cfscript>
							satir = dosya[i];
							invoice_id = oku(satir,18,16);//invoice idsi
							prov_row_id = oku(satir,134,105);//prov satır idsi
							prov_code = oku(satir,89,2);//Onay kodu
						</cfscript>
						<cfif prov_code eq 71 and left(satir,2) eq 51><!--- 51otomatik ödeme alonan kayıtlar  ve  71 tahsilat yapıldı onay kodu --->
							<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
								SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
							</cfquery>
							<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#DSN2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_PAID = 0,
									CARI_ACTION_ID = NULL,
									CARI_PERIOD_ID = NULL,
									CARI_ACT_TYPE = NULL,
									CARI_ACT_ID = NULL,
									CARI_ACT_TABLE = NULL,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
									AND 
									(
										(
											CARI_ACT_ID IS NOT NULL
											AND CARI_ACT_TYPE = 24
											AND CARI_ACT_ID IN
											(
												SELECT ACTION_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#
											)
										)
									)
							</cfquery>
							<cfquery name="get_period_year" datasource="#dsn2#">
								SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
							</cfquery>
							<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
							<cfquery name="upd_inv" datasource="#dsn2#">
								UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = NULL,BANK_PERIOD_ID = NULL WHERE INVOICE_ID = #invoice_id#
							</cfquery>
						</cfif>
					</cfloop>
				<cfelseif ListFind('33,36,37,39,44,46',get_import.source_system)><!--- Garanti-YKB-Akbank-Ziraat ortak versiyon, Sekerbank--->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırını almamak için --->
						<cfscript>
							satir = dosya[i];
							invoice_id = oku(satir,57,13);//invoice idsi
							prov_row_id = oku(satir,119,60);//prov satır idsi
							prov_code = oku(satir,179,2);//Onay kodu
						</cfscript>
						<cfif prov_code eq 91><!--- tahsilat yapıldı onay kodu --->
							<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
								SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
							</cfquery>
							<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#DSN2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_PAID = 0,
									CARI_ACTION_ID = NULL,
									CARI_PERIOD_ID = NULL,
									CARI_ACT_TYPE = NULL,
									CARI_ACT_ID = NULL,
									CARI_ACT_TABLE = NULL,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
									AND 
									(
										(
											CARI_ACT_ID IS NOT NULL
											AND CARI_ACT_TYPE = 24
											AND CARI_ACT_ID IN
											(
												SELECT ACTION_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#
											)
										)
									)
							</cfquery>
							<cfquery name="get_period_year" datasource="#dsn2#">
								SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
							</cfquery>
							<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
							<cfquery name="upd_inv" datasource="#dsn2#">
								UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = NULL,BANK_PERIOD_ID = NULL WHERE INVOICE_ID = #invoice_id#
							</cfquery>
						</cfif>
					</cfloop>
				<cfelseif get_import.source_system eq 34><!--- Oyakbank--->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırını almamak için --->
						<cfscript>
							satir = dosya[i];
							invoice_id = oku(satir,57,13);//invoice idsi
							prov_row_id = oku(satir,119,60);//prov satır idsi
							prov_code = oku(satir,179,2);//Onay kodu
						</cfscript>
						<cfif prov_code eq 91><!--- tahsilat yapıldı onay kodu --->
							<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
								SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
							</cfquery>
							<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#DSN2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_PAID = 0,
									CARI_ACTION_ID = NULL,
									CARI_PERIOD_ID = NULL,
									CARI_ACT_TYPE = NULL,
									CARI_ACT_ID = NULL,
									CARI_ACT_TABLE = NULL,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
									AND 
									(
										(
											CARI_ACT_ID IS NOT NULL
											AND CARI_ACT_TYPE = 24
											AND CARI_ACT_ID IN
											(
												SELECT ACTION_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#
											)
										)
									)
							</cfquery>
							<cfquery name="get_period_year" datasource="#dsn2#">
								SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
							</cfquery>
							<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
							<cfquery name="upd_inv" datasource="#dsn2#">
								UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = NULL,BANK_PERIOD_ID = NULL WHERE INVOICE_ID = #invoice_id#
							</cfquery>
						</cfif>
					</cfloop>
				<cfelseif get_import.source_system eq 35><!--- TEB--->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırını almamak için --->
						<cfscript>
							satir = dosya[i];
							invoice_id = oku(satir,57,13);//invoice idsi
							prov_row_id = oku(satir,119,60);//prov satır idsi
							prov_code = oku(satir,179,2);//Onay kodu
						</cfscript>
						<cfif prov_code eq 91><!--- tahsilat yapıldı onay kodu --->
							<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
								SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
							</cfquery>
							<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#DSN2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_PAID = 0,
									CARI_ACTION_ID = NULL,
									CARI_PERIOD_ID = NULL,
									CARI_ACT_TYPE = NULL,
									CARI_ACT_ID = NULL,
									CARI_ACT_TABLE = NULL,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
									AND 
									(
										(
											CARI_ACT_ID IS NOT NULL
											AND CARI_ACT_TYPE = 24
											AND CARI_ACT_ID IN
											(
												SELECT ACTION_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#
											)
										)
									)
							</cfquery>
							<cfquery name="get_period_year" datasource="#dsn2#">
								SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
							</cfquery>
							<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
							<cfquery name="upd_inv" datasource="#dsn2#">
								UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = NULL,BANK_PERIOD_ID = NULL WHERE INVOICE_ID = #invoice_id#
							</cfquery>
						</cfif>
					</cfloop>
				<cfelseif get_import.source_system eq 41 or get_import.source_system eq 45><!--- Denizbank ve odeabank--->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırlarını almamak için --->
						<cfscript>
							satir = dosya[i];
							invoice_id = oku(satir,17,15);//invoice nosu
							nettotal_1 = oku(satir,48,19);//Tutar
							nettotal_2 = oku(satir,67,2);//Kurus
							prov_code = oku(satir,72,1);//Onay kodu
							prov_row_id = oku(satir,113,20);//prov satır idsi
							nettotal = "#nettotal_1#.#nettotal_2#";
						</cfscript>
						<cfif prov_code eq 'T'>
							<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
								SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
							</cfquery>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#DSN2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_PAID = 0,
									CARI_ACTION_ID = NULL,
									CARI_PERIOD_ID = NULL,
									CARI_ACT_TYPE = NULL,
									CARI_ACT_ID = NULL,
									CARI_ACT_TABLE = NULL,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
									AND 
									(
										(
											CARI_ACT_ID IS NOT NULL
											AND CARI_ACT_TYPE = 24
											AND CARI_ACT_ID IN
											(
												SELECT ACTION_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#
											)
										)
									)
							</cfquery>
							<cfquery name="get_period_year" datasource="#dsn2#">
								SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
							</cfquery>
							<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
							<cfquery name="upd_inv" datasource="#dsn2#">
								UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = NULL,BANK_PERIOD_ID = NULL WHERE INVOICE_ID = #invoice_id#
							</cfquery>
						</cfif>
					</cfloop>
				<cfelseif get_import.source_system eq 43><!--- Vakıf--->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırlarını almamak için --->
						<cfscript>
							satir = dosya[i];
							satir_id = oku(satir,1,2);//satir id
							invoice_id = oku(satir,180,30);//invoice nosu
							nettotal_1 = oku(satir,42,13);//Tutar
							nettotal_2 = oku(satir,55,2);//Kurus
							prov_code = oku(satir,89,2);//Onay kodu
							nettotal = "#nettotal_1#.#nettotal_2#";
						</cfscript>
						<cfif prov_code eq '71' and satir_id eq '51'>
							<cfquery name="get_inv_id" datasource="#dsn2#">
								SELECT YEAR(INVOICE_DATE) YEAR_INFO FROM INVOICE WHERE INVOICE_ID = #invoice_id#
								<cfif get_old_period.recordcount>
									UNION ALL SELECT YEAR(INVOICE_DATE) YEAR_INFO FROM #old_dsn2#.INVOICE WHERE INVOICE_ID = #invoice_id#
								</cfif>
							</cfquery>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#DSN2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_PAID = 0,
									CARI_ACTION_ID = NULL,
									CARI_PERIOD_ID = NULL,
									CARI_ACT_TYPE = NULL,
									CARI_ACT_ID = NULL,
									CARI_ACT_TABLE = NULL,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# 
									AND 
									(
										(
											CARI_ACT_ID IS NOT NULL
											AND CARI_ACT_TYPE = 24
											AND CARI_ACT_ID IN
											(
												SELECT ACTION_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#
											)
										)
									)
									<!---AND YEAR(PAYMENT_DATE) = #get_inv_id.year_info#--->
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			<cfquery name="DEL_BANK_ACTION_MONEY" datasource="#DSN2#">
				DELETE FROM 
					BANK_ACTION_MONEY 
				WHERE 
					ACTION_ID IN (SELECT ACTION_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#)
			</cfquery>
			<cfquery name="DEL_CARI_ROWS" datasource="#DSN2#">
				DELETE FROM 
					CARI_ROWS 
				WHERE 
					ACTION_TYPE_ID IN (24,25) AND<!--- gelen ve giden havale --->
					ACTION_ID IN (SELECT ACTION_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#)
			</cfquery>
			<cfquery name="GET_CARD_ID" datasource="#DSN2#">
				 SELECT
					CARD_ID
				 FROM
					ACCOUNT_CARD
				 WHERE
					ACTION_TYPE IN (24,25) AND<!--- gelen ve giden havale --->
					ACTION_ID IN (SELECT ACTION_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#)
			</cfquery>
			<cfif GET_CARD_ID.RECORDCOUNT>
				<cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#DSN2#">
					DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID IN (#ValueList(GET_CARD_ID.CARD_ID)#)
				</cfquery>
				<cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#DSN2#">
					DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID IN (#ValueList(GET_CARD_ID.CARD_ID)#)
				</cfquery>
				<cfquery name="DEL_ACCOUNT_CARD" datasource="#DSN2#">
					DELETE FROM ACCOUNT_CARD WHERE CARD_ID IN (#ValueList(GET_CARD_ID.CARD_ID)#)
				</cfquery>
			</cfif>
			<cfquery name="DEL_CREDIT_CARD_PAY" datasource="#DSN2#">
				DELETE FROM BANK_ACTIONS WHERE FILE_IMPORT_ID = #attributes.export_import_id#
			</cfquery>
			<cfquery name="DEL_CREDIT_CARD_PAY" datasource="#DSN2#">
				UPDATE FILE_IMPORTS SET IMPORTED = 0 WHERE I_ID = #attributes.export_import_id#
			</cfquery>
		</cftransaction>
	</cflock>
	<script language="JavaScript">
	<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>opener.location.reload();window.close();</cfif>
	</script>
<cfelse>
	<script language="JavaScript">
		<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>opener.location.reload();window.close();</cfif>
	</script>
	<cfabort>
</cfif>	
