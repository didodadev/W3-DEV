<!-- sil --><cf_xml_page_edit fuseact="ehesap.popup_ssk_eva"><!-- sil -->
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
<cfparam name="attributes.salary_year" default="#year(now())#">
<cfinclude template="../query/get_ssk_offices.cfm">
<cfif not isDefined("attributes.print")>
<cf_box title="#getlang('','SGK Eksik Gün Bildirim(Ek10)','47213')#">
<cfform name="get_managers" action="" method="post">
	<cf_box_search>
		<div class="form-group">
		<input type="text" placeholder='<cf_get_lang dictionary_id="57789.Özel Kod">' name="hierarchy" id="hierarchy" maxlength="50" value="<cfif isdefined("attributes.hierarchy")><cfoutput>#attributes.hierarchy#</cfoutput></cfif>" style="width:100px;">						
		</div>
		<div class="form-group">
		<select name="SSK_OFFICE" id="SSK_OFFICE" style="width:200px;">
			<cfoutput query="GET_SSK_OFFICES">
				<cfif len(ssk_office) and len(ssk_no)>
					<option value="#ssk_office#-#ssk_no#-#branch_id#" <cfif isdefined("attributes.ssk_office") and (attributes.ssk_office eq "#ssk_office#-#ssk_no#-#branch_id#")>selected</cfif>>#branch_name#-#ssk_office#-#ssk_no#</option>
				</cfif>
			</cfoutput>
		</select>
		</div>
		<div class="form-group">
		<select name="sal_mon" id="sal_mon" style="width:65px;">
			<cfif session.ep.period_year lt dateformat(now(),'YYYY')>
				<cfloop from="1" to="12" index="i">
					<cfoutput>
						<option value="#i#"<cfif isdefined("attributes.sal_mon") and (i eq attributes.sal_mon)> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
					</cfoutput>
				</cfloop>
			<cfelse>
				<cfloop from="1" to="12" index="i">
					<cfoutput>
						<option value="#i#"<cfif isdefined("attributes.sal_mon") and (i eq attributes.sal_mon)> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
					</cfoutput>
				</cfloop>
			</cfif>
		</select>
		</div>
		<div class="form-group">
                    <select name="salary_year" id="salary_year">
                    	<option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
                    	<cfloop from="-3" to="3" index="i">
                    		<cfoutput><option value="#year(now()) + i#"<cfif attributes.salary_year eq (year(now()) + i)> selected</cfif>>#year(now()) + i#</option></cfoutput>
                    	</cfloop>
                    </select>
		</div>
        <div class="form-group"><cf_wrk_search_button button_type="4"></div>
		</tr>
        </table>	
    </cf_box_search>
</cfform>
</cf_box>
</cfif>
<!-- sil -->
<cfif isdefined("attributes.ssk_office")>
	<cfscript>
	BU_AY_BASI = CreateDate(attributes.salary_year, attributes.sal_mon,1);
	BU_AY_SONU = date_add("d",DaysInMonth(BU_AY_BASI),BU_AY_BASI);
	</cfscript>
	<cfquery name="get_izins" datasource="#dsn#">
		SELECT 
			OFFTIME.EMPLOYEE_ID, SETUP_OFFTIME.EBILDIRGE_TYPE_ID, SETUP_OFFTIME.IS_PAID, SETUP_OFFTIME.SIRKET_GUN,
			OFFTIME.STARTDATE,OFFTIME.FINISHDATE
		FROM 
			OFFTIME, SETUP_OFFTIME
		WHERE
			SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND 
			OFFTIME.VALID = 1 AND 
			OFFTIME.STARTDATE < #BU_AY_SONU# AND 
			OFFTIME.FINISHDATE >= #BU_AY_BASI# AND
			OFFTIME.IS_PUANTAJ_OFF = 0
		ORDER BY 
			OFFTIME.EMPLOYEE_ID, OFFTIME.STARTDATE
	</cfquery>
<cfinclude template="../query/get_branch.cfm">
  <cfinclude template="../../query/get_emp_codes.cfm">
  <cfquery name="get_offtimes" datasource="#dsn#">
  	SELECT 
		'0' AS KANUN_NO,
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_PUANTAJ_ROWS.IZIN,
		EMPLOYEES_PUANTAJ_ROWS.IZIN_PAID,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_SALARY,
		EMPLOYEES_PUANTAJ_ROWS.EXT_SALARY,
		EMPLOYEES_PUANTAJ_ROWS.YILLIK_IZIN_AMOUNT,
		EMPLOYEES_PUANTAJ_ROWS.IHBAR_AMOUNT,
		EMPLOYEES_PUANTAJ_ROWS.KIDEM_AMOUNT,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY,
		EMPLOYEES_PUANTAJ_ROWS.SSK_NO,
		EMPLOYEES_PUANTAJ_ROWS.SALARY,
		(EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS - EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY) AS GUN_SAYISI,
		EMPLOYEES_PUANTAJ_ROWS.SSK_MATRAH,
		EMPLOYEES_PUANTAJ_ROWS.SALARY_TYPE,
		EMPLOYEES_PUANTAJ_ROWS.IS_KISMI_ISTIHDAM,
        EMPLOYEES_IN_OUT.DUTY_TYPE
	FROM
		EMPLOYEES,
		EMPLOYEES_IDENTY,
		EMPLOYEES_IN_OUT,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
	WHERE
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS <= 30 AND
		(
		(EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY = 0 AND (EMPLOYEES_PUANTAJ_ROWS.IZIN > 0 OR EMPLOYEES_PUANTAJ_ROWS.SALARY_TYPE = 0))
		OR
		(EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY > 0 AND (EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS + EMPLOYEES_PUANTAJ_ROWS.IZIN) > EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY)
		)
		AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
		EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID AND
		EMPLOYEES_IN_OUT.USE_SSK = 1 AND
		EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.salary_year# AND
		EMPLOYEES_PUANTAJ.SAL_MON = #attributes.SAL_MON# AND
		EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = #listgetat(attributes.SSK_OFFICE,3,'-')#
	<cfif fusebox.dynamic_hierarchy>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND 
				('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
					
			<cfelseif database_type is "DB2">
				AND 
				('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
					
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%'
			<cfelseif database_type is "DB2">
				AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE '%.#code_i#.%'
			</cfif>
		</cfloop>
	</cfif>
UNION ALL
	SELECT 
		'5921' AS KANUN_NO,
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_PUANTAJ_ROWS.IZIN,
		EMPLOYEES_PUANTAJ_ROWS.IZIN_PAID,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_SALARY,
		EMPLOYEES_PUANTAJ_ROWS.EXT_SALARY,
		EMPLOYEES_PUANTAJ_ROWS.YILLIK_IZIN_AMOUNT,
		EMPLOYEES_PUANTAJ_ROWS.IHBAR_AMOUNT,
		EMPLOYEES_PUANTAJ_ROWS.KIDEM_AMOUNT,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY,
		EMPLOYEES_PUANTAJ_ROWS.SSK_NO,
		EMPLOYEES_PUANTAJ_ROWS.SALARY,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY AS GUN_SAYISI,
		EMPLOYEES_PUANTAJ_ROWS.SSK_MATRAH,
		EMPLOYEES_PUANTAJ_ROWS.SALARY_TYPE,
		EMPLOYEES_PUANTAJ_ROWS.IS_KISMI_ISTIHDAM,
        EMPLOYEES_IN_OUT.DUTY_TYPE
	FROM
		EMPLOYEES,
		EMPLOYEES_IDENTY,
		EMPLOYEES_IN_OUT,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
	WHERE
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY > 0 AND		
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY < (EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS + EMPLOYEES_PUANTAJ_ROWS.IZIN) AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
		EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID AND
		EMPLOYEES_IN_OUT.USE_SSK = 1 AND
		EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.salary_year# AND
		EMPLOYEES_PUANTAJ.SAL_MON = #attributes.SAL_MON# AND
		EMPLOYEES_PUANTAJ.SSK_OFFICE + '-' + EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = '#attributes.SSK_OFFICE#'
	<cfif fusebox.dynamic_hierarchy>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND 
				('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
					
			<cfelseif database_type is "DB2">
				AND 
				('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
					
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%'
			<cfelseif database_type is "DB2">
				AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE '%.#code_i#.%'
			</cfif>
		</cfloop>
	</cfif>	
	ORDER BY
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
  </cfquery>
<cfset total_pages = ceiling(get_offtimes.RECORDCOUNT / 20)>
<cfset curr_page = 0>
<cfif not get_offtimes.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54639.Bu Ay İzin Kaydı Bulunamadı'> !");
		history.back();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53897.SGK Bilgi Formu"></cfsavecontent>
<cf_box  title="#message#" uidrop="1">
<div class="printThis">
	<cfloop from="1" to="#get_offtimes.recordcount#" index="START_20" step="20">
		<table style="width:210mm;height:285mm;  page-break-inside:avoid; page-break-after:auto;" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">
					<cfset curr_page = curr_page+1>
					<cfset counter1 = 0>
					<table width="100%" align="center">
						<tr>
							<td colspan="2" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id ='53841.EK'>-10</td>
						</tr>
						<tr>
							<td align="center" class="formbold" valign="top">
								<cf_get_lang dictionary_id="45795.T.C."> <br/>
								<cf_get_lang dictionary_id="30489.SOSYAL GÜVENLİK KURUMU"><br/>
								<cf_get_lang dictionary_id='53898.SİGORTALILARIN EKSİK GÜN BİLDİRİM FORMU'>
							</td>
							<td width="175" valign="top">
							<cfoutput>
								<table width="99%" >
									<tr>
										<td colspan="2" align="center" class="formbold"><cf_get_lang dictionary_id ='53842.BELGENİN'></td>
									</tr>
									<tr>
										<td class="txtbold" width="90"><cf_get_lang dictionary_id ='53899.Ait Olduğu Yıl'> </td>
										<td>:&nbsp;#attributes.salary_year#</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='58724.Ay'></td>
										<td>:&nbsp;#attributes.sal_mon#</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id ='53685.Sayfa No'> </td>
										<td>:&nbsp;#curr_page#</td>
									</tr>
								</table>
							</cfoutput>
							</td>
						</tr>
					</table>
					<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td height="30" width="250" align="center">
								<font class="txtbold"><cf_get_lang dictionary_id="59420.İŞVEREN NUMARASI"></font><br/>
								<font class="print">(<cf_get_lang dictionary_id="59421.Gerçek Kişi için T.C. Kimlik No / Tüzel Kişiler İçin Vergi Kimlik No">)</font><br/>
								<cfset tax_no_ = trim(get_branch.tax_no)>
								<cfif len(tax_no_)>
									<cfset tax_no_ = repeatString(" ",11-len(tax_no_)) & "#tax_no_#">
								</cfif>
								<table width="99%" border="1" cellspacing="0" cellpadding="0" align="center">
								<cfoutput>
									<tr height="25" align="center">
										<td width="20">#mid(tax_no_,1,1)#</td>
										<td width="20">#mid(tax_no_,2,1)#</td>
										<td width="20">#mid(tax_no_,3,1)#</td>
										<td width="20">#mid(tax_no_,4,1)#</td>
										<td width="20">#mid(tax_no_,5,1)#</td>
										<td width="20">#mid(tax_no_,6,1)#</td>
										<td width="20">#mid(tax_no_,7,1)#</td>
										<td width="20">#mid(tax_no_,8,1)#</td>
										<td width="20">#mid(tax_no_,9,1)#</td>
										<td width="20">#mid(tax_no_,10,1)#</td>
										<td width="20">#mid(tax_no_,11,1)#</td>
									</tr>
								</cfoutput>
								</table>
								<font class="txtbold"><cf_get_lang dictionary_id="59422.İşverenin, Alt İşverenin veya geçici iş ilişkisi kurulan işverenin Adı Soyadı / Ünvanı"></font>
							</td>
							<td rowspan="2" valign="top">
							<br/>
							<cfoutput>
								<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center">
									<tr align="center">
										<td colspan="26"><cf_get_lang dictionary_id ='53823.İŞYERİ SİCİL NO'></td>
									</tr>
									<tr class="printbold">
										<td rowspan="2">M</td>
										<td colspan="4" rowspan="2" align="center"><cf_get_lang dictionary_id ='53824.İŞ KOLU KODU'></td>
										<td colspan="4" align="center"><cf_get_lang dictionary_id ='53825.ÜNİTE KODU'></td>
										<td colspan="7" rowspan="2" align="center"><cf_get_lang dictionary_id ='53826.İŞYERİ SIRA NUMARASI'></td>
										<td colspan="3" rowspan="2" align="center"><cf_get_lang dictionary_id ='53827.İL KODU'></td>
										<td colspan="2" rowspan="2" align="center"><cf_get_lang dictionary_id ='53828.İLÇE KODU'></td>
										<td colspan="2" rowspan="2" align="center"><cf_get_lang dictionary_id ='53829.KONTROL NUMARASI'></td>
										<td colspan="3" rowspan="2" align="center"><cf_get_lang dictionary_id ="59423.Alt İşveren Kodu"></td>
									</tr>
									<tr>
										<td colspan="2"><cf_get_lang dictionary_id ='58674.YENİ'></td>
										<td colspan="2"><cf_get_lang dictionary_id ='53832.ESKİ'></td>
									</tr>
									<tr>
										<td>&nbsp;#get_branch.ssk_m#</td>
										<td>&nbsp;#mid(get_branch.ssk_job,1,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_job,2,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_job,3,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_job,4,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_branch,1,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_branch,2,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_branch_old,1,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_branch_old,2,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_no,1,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_no,2,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_no,3,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_no,4,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_no,5,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_no,6,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_no,7,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_city,1,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_city,2,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_city,3,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_country,1,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_country,2,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_cd,1,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_cd,2,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_agent,1,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_agent,2,1)#</td>
										<td>&nbsp;#mid(get_branch.ssk_agent,3,1)#</td>
									</tr>
								</table>
							</cfoutput>
							<br/>
							</td>
						</tr>
						<tr>
							<td>&nbsp;<cfoutput>#get_branch.branch_fullname#</cfoutput></td>
						</tr>
					</table>
					<br/>
					<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td width="75" class="txtbold" align="center"><cf_get_lang dictionary_id ='53901.İşyerinin Adresi'></td>
							<td><cfoutput>#get_branch.branch_address# #get_branch.branch_postcode# #get_branch.branch_county# <span class="txtbold">#get_branch.branch_city# - #get_branch.branch_country#</span></cfoutput></td>
						</tr>
					</table>
					<br/>
					<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td rowspan="2" align="center" class="printbold"><cf_get_lang dictionary_id ='53109.Sıra No'></td>
							<td colspan="5" align="center" class="formbold"><cf_get_lang dictionary_id ='53464.SİGORTALININ'></td>
							<td rowspan="2" align="center" class="printbold"><cf_get_lang dictionary_id ='53902.Değerlendirme Sonucu'></td>
						</tr>
						<tr class="printbold" align="center">
							<td><cf_get_lang dictionary_id="58025.TC Kimlik No"></td>
							<td><cf_get_lang dictionary_id ='57570.Adı-Soyadı'></td>
							<td><cf_get_lang dictionary_id ='53904.Prime Esas Günlük Kazancı'></td>
							<td width="75"><cf_get_lang dictionary_id ='53905.Eksik Bildirilen Gün Sayısı'></td>
							<td width="75"><cf_get_lang dictionary_id ='53906.Eksik Bildirim  Nedeni'></td>
						</tr>
						<cfset kazanc = 0>
						<cfoutput query="get_offtimes" startrow="#START_20#" maxrows="20">
							<cfset counter1 = counter1+1>
							<cfif GUN_SAYISI>
								<cfset kazanc = kazanc + (SSK_MATRAH / TOTAL_DAYS)>
							</cfif>
							<tr>
								<td align="center">#((curr_page-1)*20)+COUNTER1#</td>
								<td>#tc_identy_no#&nbsp;</td>
								<td>#employee_name# #employee_surname#&nbsp;</td>
								<td><!---#TOTAL_SALARY# -- ---> 
									<cfif GUN_SAYISI>
										<cfif is_ssk_matrah_or_aylik_brut eq 0>
											<cfset tutar = (TOTAL_SALARY - EXT_SALARY) / TOTAL_DAYS>
											<!--- <cfif SALARY_TYPE eq 0>
												<cfset tutar = tutar * 7.5>
												<cfelseif SALARY_TYPE eq 1>
													<cfset tutar = tutar>
												<cfelse>
													<cfset tutar = tutar / 30>
												</cfif> --->
										<cfelse>
											<cfset tutar = SSK_MATRAH / TOTAL_DAYS>
										</cfif>
										<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(tutar)#">
									<cfelse>
										0
									</cfif>
								</td>
								<td>
									<cfset is_istihdam = 0>
									<cfif SSK_ISVEREN_HISSESI_5921_DAY gt 0 and kanun_no eq 0>
										#SSK_ISVEREN_HISSESI_5921_DAY + IZIN#
										<cfset is_istihdam = 1>
									<cfelseif SSK_ISVEREN_HISSESI_5921_DAY gt 0 and kanun_no eq 5921>
										#(TOTAL_DAYS + IZIN) - SSK_ISVEREN_HISSESI_5921_DAY#
										<cfset is_istihdam = 1>
									<cfelse>
										<cfif daysinmonth(BU_AY_BASI) eq 31 and izin eq 30 and TOTAL_DAYS eq 0> <!--- 31 çeken aylarda ücretsiz izin toplamı 30 ise aydaki gün sayısı kadar yazacak çünkü e bildirgede 31 olarak bildiriliyor SG 20150313--->
											31
										<cfelse>
											#izin#
										</cfif>
										<cfset is_istihdam = 1>
									</cfif>&nbsp;
								</td>
								<cfscript>
									if(SSK_ISVEREN_HISSESI_5921_DAY GT 0 and KANUN_NO eq 5921)
									{
										if(izin_paid gt 0 and izin gt 0)
											EKSIKGUNNEDENI = 12;
										else if(izin gt 0)
										{
											get_emp_izins = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND IS_PAID = 0");
											eksik_neden_id = get_emp_izins.EBILDIRGE_TYPE_ID;
											if (get_emp_izins.recordcount gte 2)
												for (geii=2; geii lte get_emp_izins.recordcount; geii=geii+1)
													if (get_emp_izins.EBILDIRGE_TYPE_ID[geii-1] neq get_emp_izins.EBILDIRGE_TYPE_ID[geii])
														eksik_neden_id = 12;
											EKSIKGUNNEDENI = eksik_neden_id;
										}
										else if(izin_paid gt 0)
										{
											get_emp_izins = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND IS_PAID = 1");
											eksik_neden_id = get_emp_izins.ebildirge_type_id;
											if (get_emp_izins.recordcount gte 2)
												for (geii=2; geii lte get_emp_izins.recordcount; geii=geii+1)
													if (get_emp_izins.ebildirge_type_id[geii-1] neq get_emp_izins.ebildirge_type_id[geii])
														eksik_neden_id = 12;
											EKSIKGUNNEDENI = eksik_neden_id;
										}
										else
										{
											EKSIKGUNNEDENI = 12;
										}
									}
									else
									{
										if(SSK_ISVEREN_HISSESI_5921_DAY GT 0 and KANUN_NO eq 0 and izin gt 0)
											EKSIKGUNNEDENI = 12;
										else if(SSK_ISVEREN_HISSESI_5921_DAY GT 0 and KANUN_NO eq 0 and izin eq 0)
											EKSIKGUNNEDENI = 13;
										else if(SALARY_TYPE eq 0 and IS_KISMI_ISTIHDAM eq 1)
											EKSIKGUNNEDENI = 6;
										else if (izin gt 0)
										{
											get_emp_izins = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND IS_PAID = 0");
											eksik_neden_id = get_emp_izins.EBILDIRGE_TYPE_ID;
											if (get_emp_izins.recordcount gte 2)
												for (geii=2; geii lte get_emp_izins.recordcount; geii=geii+1)
													if (get_emp_izins.ebildirge_type_id[geii-1] neq get_emp_izins.ebildirge_type_id[geii])
														eksik_neden_id = 12;
											EKSIKGUNNEDENI = eksik_neden_id;
										}
										else
										{
											EKSIKGUNNEDENI = 0;
										}
									}
								</cfscript>
								<td><cfif is_istihdam eq 1 and duty_type eq 6>6<cfelse>#EKSIKGUNNEDENI#</cfif></td>
								<td>&nbsp;</td>
							</tr>
						</cfoutput>
						<cfloop from="#counter1+1#" to="20" index="j">
							<cfset counter1 = counter1+1>
							<tr>
								<td align="center"><cfoutput>#((curr_page-1)*20)+J#</cfoutput></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
						</cfloop>
						<cfif counter1 eq 20>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td class="FORMBOLD" align="center"><cf_get_lang dictionary_id ='53907.SAYFA TOPLAMI'></td>
								<td><cfoutput><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(kazanc)#"></cfoutput></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
						</cfif>
					</table>
					<br/>
					<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td colspan="4" align="center" class="formbold"><cf_get_lang dictionary_id ='53908.BEYAN VE TAAHHÜTLER'></td>
						</tr>
						<tr>
							<td colspan="4" class="print"><span class="txtbold"><cfoutput>#total_pages#</cfoutput></span><cf_get_lang dictionary_id ='53888.sayfadan ibaret bu belgede yazılı bilgilerin işyeri defter ve kayıtlarına uygun olduğunu beyan ve kabul ederiz'> . <span class="txtbold"><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput></span></td>
						</tr>
						<tr class="print">
							<td width="100" height="75" align="center" class="printbold">
								<cf_get_lang dictionary_id="59424.İŞVERENİN, ALT İŞVERENİN VEYA GEÇİCİ İŞ İLİŞKİSİ KURULAN İŞVERENİN"><br/> <cf_get_lang dictionary_id="59416.ADI SOYADI / UNVANI"> <br/><cf_get_lang dictionary_id="34739.MÜHÜR ve KAŞESİ">
							</td>
							<td width="250">&nbsp;</td>
							<td width="100" align="center" class="printbold"><cf_get_lang dictionary_id="46511.SERBEST MUHASEBECİ MALİ MÜŞAVİR ADI SOYADI MÜHÜR veya KAŞESİ"></td>
							<td width="250">&nbsp;</td>
						</tr>
					</table>
					<br/>
					<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td colspan="4" align="center" class="formbold"><cf_get_lang dictionary_id ='53909.BELGENİN ÜNİTE KAYIT İŞLEMLERİ'></td>
						</tr>
						<tr>
							<td colspan="4">
								<span class="txtbold"><cfoutput>#total_pages#</cfoutput></span> <cf_get_lang dictionary_id="59425.sayfadan ibaret, iki nüsha düzenlenmiş olan bu formun birinci nüshası, ................. Müdürlüğünce ....... adet eki ile ../../.... tarihinde elden teslim alınmıştır / posta ile gönderilmiştir. İkinci nüshası, Ünitece giriş tarih ve sayısı verildikten sonra alındı belgesi yerine geçmek üzere işverene / alt işverene iade edilmiştir.">
							</td>
						</tr>
						<tr>
							<td width="100" height="75" align="center" class="FORMBOLD"><cf_get_lang dictionary_id ='53911.BELGENİN ALINDIĞI'></td>
							<td width="250" valign="top">
								<table class="formbold">
									<tr>
										<td><cf_get_lang dictionary_id ='57742.Tarih'></td>
										<td>:&nbsp;</td>
									</tr>
									<tr>
										<td><cf_get_lang dictionary_id="32879.Sayı">&nbsp;</td>
										<td>:&nbsp;</td>
									</tr>
								</table>
							</td>
							<td width="100" align="center" class="FORMBOLD"><cf_get_lang dictionary_id ='53914.TESLİM ALANIN'></td>
							<td width="250">
								<table class="formbold">
									<tr>
										<td><cf_get_lang dictionary_id ='57570.Adı Soyadı'></td>
										<td>:&nbsp;</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td><cf_get_lang dictionary_id ='53916.Görevi'>&nbsp;</td>
										<td>:&nbsp;</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td><cf_get_lang dictionary_id ='58957.İmza'>&nbsp;</td>
										<td>:&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<!--- <br/>
					<table width="100%" align="center" cellpadding="0" cellspacing="0">
					<tr>
					<td class="printbold"><cf_get_lang no ='971.NOT Bu Forma İlişkin olduğu ay içinde (30) günden az çalışan süreleri kanıtlayan belgelerin aslı veya tasdikli fotokopileri eklenecektir'></td>
					</tr>
					</table> --->
				</td>
			</tr>
		</table>
	</cfloop>
</cf_box>
</cfif>
