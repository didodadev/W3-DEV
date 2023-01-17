<cfif not isdefined("form.avans")>
	<script type="text/javascript">
		alert("Eksik Bilgi !");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="upd_puantaj" datasource="#dsn#">
	UPDATE
		EMPLOYEES_PUANTAJ_ROWS
	SET
		AVANS = #FORM.AVANS#,
		IZIN = #FORM.IZIN#,
		IZIN_PAID = #FORM.IZIN_PAID#,
		<!--- 20050922 puantaj update ekraninda salary input brut ve aylik degerler gosterdigi icin update edilemez, ilk kayit haliyle kalmali.
		SALARY = #FORM.SALARY#, --->
		MONEY = '#FORM.MONEY#',
		DAMGA_VERGISI_MATRAH = #FORM.DAMGA_VERGISI_MATRAH#,
		COCUK_PARASI = 0,
		TOTAL_DAYS = #FORM.DAYS#,
		TOTAL_HOURS = #FORM.TOTAL_HOURS#,
		SSK_MATRAH = #FORM.SSK_MATRAH#,
		DAMGA_VERGISI = #FORM.DAMGA_VERGISI#,
		GELIR_VERGISI_MATRAH = #FORM.GELIR_VERGISI_MATRAH#,
		GELIR_VERGISI = #FORM.GELIR_VERGISI#,
		KUMULATIF_GELIR_MATRAH = #FORM.KUMULATIF_GELIR_MATRAH+FORM.GELIR_VERGISI_MATRAH#,
		SSDF_ISCI_HISSESI = #FORM.ssdf_isci_hissesi#,
		SSDF_ISVEREN_HISSESI = #FORM.ssdf_isveren_hissesi#,
		EXT_TOTAL_HOURS_0 = #FORM.EXT_TOTAL_HOURS_0#,
		EXT_TOTAL_HOURS_1 = #FORM.EXT_TOTAL_HOURS_1#,
		EXT_TOTAL_HOURS_2 = #FORM.EXT_TOTAL_HOURS_2#,
		VERGI_INDIRIMI = <cfif not len(FORM.VERGI_INDIRIMI)>0<cfelse>#FORM.VERGI_INDIRIMI#</cfif>,
		VERGI_INDIRIMI_5084 = #FORM.VERGI_INDIRIMI_5084#,
		OZEL_KESINTI = #FORM.OZEL_KESINTI#,
		TOTAL_PAY_SSK_TAX = #FORM.TOTAL_PAY_SSK_TAX#,
		TOTAL_PAY_SSK = #FORM.TOTAL_PAY_SSK#,
		TOTAL_PAY_TAX = #FORM.TOTAL_PAY_TAX#,
		TOTAL_PAY = #FORM.TOTAL_PAY#,
		SAKATLIK_INDIRIMI = #FORM.SAKATLIK_INDIRIMI#,
		TOTAL_SALARY = #FORM.TOTAL_SALARY#,
		EXT_SALARY = #FORM.EXT_SALARY#,
		GOCMEN_INDIRIMI = #FORM.GOCMEN_INDIRIMI#,
		VERGI_IADESI = #FORM.VERGI_IADESI#,
		VERGI_IADE_DAMGA_VERGISI = #FORM.VERGI_IADE_DAMGA_VERGISI#,
		ISSIZLIK_ISVEREN_HISSESI = #FORM.ISSIZLIK_ISVEREN_HISSESI#,
		SSK_ISVEREN_HISSESI = <cfif len(FORM.SSK_ISVEREN_HISSESI)>#FORM.SSK_ISVEREN_HISSESI#<cfelse>0</cfif>,
		TOPLAM_YUVARLAMA = 0,
		ISSIZLIK_ISCI_HISSESI = #FORM.ISSIZLIK_ISCI_HISSESI#,
		SSK_ISCI_HISSESI = #FORM.SSK_ISCI_HISSESI#,
		NET_UCRET = #NET_UCRET#,
		KIDEM_WORKER = #KIDEM_ISCI#,
		KIDEM_BOSS = #KIDEM_ISVEREN#,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		EMPLOYEE_PUANTAJ_ID = #attributes.EMPLOYEE_PUANTAJ_ID#
</cfquery>


<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		
		<cfquery name="clear_EMPLOYEES_PUANTAJ_ROWS_EXT" datasource="#dsn#">
			DELETE FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = #attributes.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		
		<cfif isdefined("vergi_istisna_len")>
			<cfloop from="1" to="#vergi_istisna_len#" index="i">
				<cfquery name="add_EMPLOYEES_PUANTAJ_ROWS_EXT" datasource="#dsn#">
					INSERT INTO EMPLOYEES_PUANTAJ_ROWS_EXT					
						(PUANTAJ_ID,
						EMPLOYEE_PUANTAJ_ID,
						COMMENT_PAY,
						PAY_METHOD,
						AMOUNT,
						SSK,
						TAX,
						EXT_TYPE,
						CALC_DAYS,
						AMOUNT_2
						)
					VALUES
						(#attributes.puantaj_id#,
						#attributes.EMPLOYEE_PUANTAJ_ID#,
						'#listgetat(attributes.vergi_istisna_1,i)#',
						#listgetat(attributes.vergi_istisna_h,i)#,
						#listgetat(attributes.vergi_istisna_all,i)#,
						#listgetat(attributes.vergi_istisna_4,i)#,
						#listgetat(attributes.vergi_istisna_5,i)#,
						#listgetat(attributes.vergi_istisna_6,i)#,
						#listgetat(attributes.vergi_istisna_g,i)#,
						0
						)
				</cfquery>
			</cfloop>
		</cfif>
		
		<cfif isdefined("kesinti_all_len")>
			<cfloop from="1" to="#kesinti_all_len#" index="i">
				<cfquery name="add_EMPLOYEES_PUANTAJ_ROWS_EXT" datasource="#dsn#">
					INSERT INTO EMPLOYEES_PUANTAJ_ROWS_EXT					
						(PUANTAJ_ID,
						EMPLOYEE_PUANTAJ_ID,
						COMMENT_PAY,
						PAY_METHOD,
						AMOUNT,
						SSK,
						TAX,
						EXT_TYPE,
						CALC_DAYS,
						AMOUNT_2
						)
					VALUES
						(#attributes.puantaj_id#,
						#attributes.EMPLOYEE_PUANTAJ_ID#,
						'#listgetat(attributes.kesinti_all_1,i)#',
						#listgetat(attributes.kesinti_all_h,i)#,
						#listgetat(attributes.kesinti_all,i)#,
						#listgetat(attributes.kesinti_all_4,i)#,
						#listgetat(attributes.kesinti_all_5,i)#,
						#listgetat(attributes.kesinti_all_6,i)#,
						#listgetat(attributes.kesinti_all_g,i)#,
						#listgetat(attributes.kesinti_all_8,i)#
						)
				</cfquery>
			</cfloop>
		</cfif>
		
		<cfif isdefined("total_pay_ssk_tax_len")>
			<cfloop from="1" to="#total_pay_ssk_tax_len#" index="i">
				<cfquery name="add_EMPLOYEES_PUANTAJ_ROWS_EXT" datasource="#dsn#">
					INSERT INTO EMPLOYEES_PUANTAJ_ROWS_EXT					
						(PUANTAJ_ID,
						EMPLOYEE_PUANTAJ_ID,
						COMMENT_PAY,
						PAY_METHOD,
						AMOUNT,
						SSK,
						TAX,
						EXT_TYPE,
						CALC_DAYS,
						AMOUNT_2
						)
					VALUES
						(#attributes.puantaj_id#,
						#attributes.EMPLOYEE_PUANTAJ_ID#,
						'#listgetat(attributes.odenek_ssk_tax_1,i)#',
						#listgetat(attributes.odenek_ssk_tax_h,i)#,
						#listgetat(attributes.odenek_ssk_tax,i)#,
						#listgetat(attributes.odenek_ssk_tax_4,i)#,
						#listgetat(attributes.odenek_ssk_tax_5,i)#,
						#listgetat(attributes.odenek_ssk_tax_6,i)#,
						#listgetat(attributes.odenek_ssk_tax_g,i)#,
						#listgetat(attributes.odenek_ssk_tax_8,i)#
						)
				</cfquery>
			</cfloop>
		</cfif>
		
		<cfif isdefined("total_pay_ssk_len")>
			<cfloop from="1" to="#total_pay_ssk_len#" index="i">
				<cfquery name="add_EMPLOYEES_PUANTAJ_ROWS_EXT" datasource="#dsn#">
					INSERT INTO EMPLOYEES_PUANTAJ_ROWS_EXT					
						(PUANTAJ_ID,
						EMPLOYEE_PUANTAJ_ID,
						COMMENT_PAY,
						PAY_METHOD,
						AMOUNT,
						SSK,
						TAX,
						EXT_TYPE,
						CALC_DAYS,
						AMOUNT_2
						)
					VALUES
						(#attributes.puantaj_id#,
						#attributes.EMPLOYEE_PUANTAJ_ID#,
						'#listgetat(attributes.odenek_ssk_1,i)#',
						#listgetat(attributes.odenek_ssk_h,i)#,
						#listgetat(attributes.odenek_ssk,i)#,
						#listgetat(attributes.odenek_ssk_4,i)#,
						#listgetat(attributes.odenek_ssk_5,i)#,
						#listgetat(attributes.odenek_ssk_6,i)#,
						#listgetat(attributes.odenek_ssk_g,i)#,
						#listgetat(attributes.odenek_ssk_8,i)#
						)
				</cfquery>
			</cfloop>
		</cfif>
		
		<cfif isdefined("total_pay_tax_len")>
			<cfloop from="1" to="#total_pay_tax_len#" index="i">
				<cfquery name="add_EMPLOYEES_PUANTAJ_ROWS_EXT" datasource="#dsn#">
					INSERT INTO EMPLOYEES_PUANTAJ_ROWS_EXT					
						(PUANTAJ_ID,
						EMPLOYEE_PUANTAJ_ID,
						COMMENT_PAY,
						PAY_METHOD,
						AMOUNT,
						SSK,
						TAX,
						EXT_TYPE,
						CALC_DAYS,
						AMOUNT_2
						)
					VALUES
						(#attributes.puantaj_id#,
						#attributes.EMPLOYEE_PUANTAJ_ID#,
						'#listgetat(attributes.odenek_tax_1,i)#',
						#listgetat(attributes.odenek_tax_h,i)#,
						#listgetat(attributes.odenek_tax,i)#,
						#listgetat(attributes.odenek_tax_4,i)#,
						#listgetat(attributes.odenek_tax_5,i)#,
						#listgetat(attributes.odenek_tax_6,i)#,
						#listgetat(attributes.odenek_tax_g,i)#,
						#listgetat(attributes.odenek_tax_8,i)#
						)
				</cfquery>
			</cfloop>
		</cfif>
		
		<cfif isdefined("total_pay_none_len")>
			<cfloop from="1" to="#total_pay_none_len#" index="i">
				<cfquery name="add_EMPLOYEES_PUANTAJ_ROWS_EXT" datasource="#dsn#">
					INSERT INTO EMPLOYEES_PUANTAJ_ROWS_EXT					
						(PUANTAJ_ID,
						EMPLOYEE_PUANTAJ_ID,
						COMMENT_PAY,
						PAY_METHOD,
						AMOUNT,
						SSK,
						TAX,
						EXT_TYPE,
						CALC_DAYS,
						AMOUNT_2
						)
					VALUES
						(#attributes.puantaj_id#,
						#attributes.EMPLOYEE_PUANTAJ_ID#,
						'#listgetat(attributes.odenek_none_1,i)#',
						#listgetat(attributes.odenek_none_h,i)#,
						#listgetat(attributes.odenek_none,i)#,
						#listgetat(attributes.odenek_none_4,i)#,
						#listgetat(attributes.odenek_none_5,i)#,
						#listgetat(attributes.odenek_none_6,i)#,
						#listgetat(attributes.odenek_none_g,i)#,
						#listgetat(attributes.odenek_none_8,i)#
						)
				</cfquery>
			</cfloop>
		</cfif>

	</cftransaction>
</cflock>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
