<cfsetting showdebugoutput="no">
<cfif not len(attributes.in_out_id)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='53622.Giriş Çıkış Kaydı Bulunamadı'> !");
		window.close();
	</script>
<cfelse>
<cfquery name="get_in_out" datasource="#DSN#" maxrows="1">
	SELECT 
		EMPLOYEES_IDENTY.FATHER,
		EMPLOYEES_IDENTY.BIRTH_DATE,
		EMPLOYEES_IDENTY.BIRTH_PLACE,
		(SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = EMPLOYEES_IDENTY.NATIONALITY) AS NATIONALITY,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_DETAIL.SEX,
		EMPLOYEES_DETAIL.HOMEADDRESS,
		EMPLOYEES_DETAIL.HOMEPOSTCODE,
		EMPLOYEES_DETAIL.HOMETEL_CODE,
		EMPLOYEES_DETAIL.HOMETEL,
		EMPLOYEES_DETAIL.MOBILCODE_SPC,
		EMPLOYEES_DETAIL.MOBILTEL_SPC,
		BRANCH.*
	FROM
		EMPLOYEES_IN_OUT,
		BRANCH,
		EMPLOYEES,
		EMPLOYEES_IDENTY,
		EMPLOYEES_DETAIL
	WHERE 
		EMPLOYEES_IN_OUT.IN_OUT_ID = #attributes.in_out_id#
		AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID
</cfquery>
<cfquery name="get_emp_puantajs" datasource="#dsn#" maxrows="4">
  	SELECT
		*
	FROM
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
	WHERE
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		AND EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
		AND EMPLOYEES_PUANTAJ.SSK_OFFICE = '#get_in_out.SSK_OFFICE#'
		AND EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = '#get_in_out.SSK_NO#'
	ORDER BY
		EMPLOYEES_PUANTAJ.SAL_YEAR DESC,
		EMPLOYEES_PUANTAJ.SAL_MON DESC
</cfquery>
<cfoutput>
<table style="width:17cm;" align="center" border="0">
	<tr>
		<td style="text-align:center;height:30px;" class="headbold"><cf_get_lang dictionary_id="53454.SİGORTA HESAP FİŞİ"></td>
	</tr>	
	<tr>
		<td valign="top">
			<table bordercolor="##CCCCCC" style="text-align:center;width:100%" border="1" cellpadding="2" cellspacing="1">
				<tr>
					<td style="text-align:right" colspan="3"><cf_get_lang dictionary_id="45418.Belgenin Düzenlendiği Tarih"></td>
					<td style="text-align:right;width:100px;">#dateformat(now(),dateformat_style)#</td>
				</tr>
				<tr>
					<td style="text-align:center" colspan="4"><B>A-<cf_get_lang dictionary_id="53464.SİGORTALININ"></B></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='58025.TC Kimlik No'></td>
					<td>:#get_in_out.TC_IDENTY_NO#</td>
					<td colspan="2"><cf_get_lang dictionary_id='53931.İkametgah Adresi'></td>
				</tr>
				<tr>
				  <td width="90"><cf_get_lang dictionary_id="53903.Sigorta Sicil No"></td>
				  <td width="230">:#get_in_out.SOCIALSECURITY_NO#</td>
				  <td rowspan="6" colspan="2" valign="top">:#get_in_out.HOMEADDRESS# #get_in_out.HOMEPOSTCODE#</td>
				</tr>
				<tr>
				  <td width="90"><cf_get_lang dictionary_id="57897.Adı"><cf_get_lang dictionary_id="58550.Soyadı"></td>
				  <td width="230">:#get_in_out.EMPLOYEE_NAME# #get_in_out.EMPLOYEE_SURNAME#</td>
				</tr>
				<tr>
				  <td width="90"><cf_get_lang dictionary_id="58033.Baba Adı"></td>
				  <td width="230">:#get_in_out.father#</td>
				</tr>
				<tr>
				  <td width="90"><cf_get_lang dictionary_id="51527.Cinsiyeti"></td>
				  <td width="230">:<cfif get_in_out.sex eq 1><cf_get_lang dictionary_id="58959.Erkek"><cfelseif get_in_out.sex eq 0><cf_get_lang dictionary_id="55621.Bayan"></cfif></td>
				</tr>
				<tr>
				  <td width="90"><cf_get_lang dictionary_id="56135.Uyruğu"></td>
				  <td width="230">:#get_in_out.nationality#</td>
				</tr>
				<tr>
				  <td width="90"><cf_get_lang dictionary_id="57790.Doğum Yeri"> - <cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
				  <td width="230">:#get_in_out.BIRTH_PLACE# - #dateformat(get_in_out.BIRTH_DATE,dateformat_style)#</td>
				</tr>
				<tr>
				  <td width="90"><cf_get_lang dictionary_id="56543.İşe Giriş Tarihi"></td>
				  <td width="230">:#dateformat(get_in_out.START_DATE,dateformat_style)#</td>
				  <td style="width:150px;"><cf_get_lang dictionary_id="55601.Ev Telefonu"></td>
				  <td>:#get_in_out.HOMETEL_CODE# #get_in_out.HOMETEL#</td>
				</tr>
				<tr>
				  <td width="90"><cf_get_lang dictionary_id="59405.İş Yerinden Ayrılış Tarihi"></td>
				  <td width="230">:#dateformat(get_in_out.FINISH_DATE,dateformat_style)#</td>
				  <td><cf_get_lang dictionary_id="58813.Cep Telefonu"></td>
				  <td>:#get_in_out.MOBILCODE_SPC# #get_in_out.MOBILTEL_SPC#</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<table style="width:100%">		
				<tr>
					<td style="text-align:center"><b>B - <cf_get_lang dictionary_id="59406.SİGORTALININ PRİM ÖDEME GÜN SAYISI"></b></td>
				</tr>
				<tr>
					<td>
						<table bordercolor="##CCCCCC" style="width:100%" border="1" cellpadding="2" cellspacing="1">
						  <tr>
							<td style="width:80px;text-align:center"><cf_get_lang dictionary_id="58455.Yıl"> - <cf_get_lang dictionary_id="58724.Ay"></td>
							<td style="width:50px;text-align:center"><cf_get_lang dictionary_id="59689.Prim Gün Sayısı"></td>
							<td style="width:120px;text-align:center"><cf_get_lang dictionary_id="46570.Prime Esas Brüt Kazançlar"></td>
							<td style="width:200px;text-align:center"><cf_get_lang dictionary_id="46408.Açıklamalar"></td>
						  </tr>
						  <cfloop query="get_emp_puantajs">
						  <tr>
						  	<td style="text-align:center">&nbsp;#sal_year# / #sal_mon#</td>
							<td style="text-align:center">&nbsp;<!--- #total_days# --->#ssk_days#</td>
							<td style="text-align:center">&nbsp;#TlFormat(ssk_matrah)#</td>
							<td>&nbsp;</td>
						  </tr>
						  </cfloop>
						  <cfloop from="1" to="8" index="i">
							  <tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							  </tr>
						  </cfloop>
					  </table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top" width="100%">
			<table cellpadding="2" cellspacing="1" width="100%">		
				<tr>
					<td style="text-align:center"><b>C - <cf_get_lang dictionary_id="53856.PRİM ÖDEME GÜN SAYISI"></b></td>
				</tr>
				<tr>
					<td valign="top">
						<table bordercolor="##CCCCCC" border="1" cellpadding="2" cellspacing="1" width="100%">
							  <tr>
									<td style="width:80px;"><cf_get_lang dictionary_id="58928.Ödeme Tipi"></td>
									<td style="width:85px;"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></td>
									<td style="width:85px;"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></td>
									<td><cf_get_lang dictionary_id="54452.Tutarı"></td>
									<td><cf_get_lang dictionary_id="57629.Açıklama"></td>
							  </tr>
							  <tr>
									<td style="width:80px;">&nbsp;</td>
									<td style="width:85px;">&nbsp;</td>
									<td style="width:85px;">&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
							  </tr>
						  </table>
					 </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<table width="100%">
				<tr>
					<td style="text-align:center"><b>D - <cf_get_lang dictionary_id="53908.BEYAN VE TAAHHÜTLER"></b></td>
				</tr>
				<tr>
					<td>
						<table bordercolor="##CCCCCC" border="1" cellpadding="2" cellspacing="1" width="100%">
							<tr>
								<td style="width:50%"><cf_get_lang dictionary_id="53833.İşverenin"> <cf_get_lang dictionary_id="59416.Adı Soyadı / Unvanı"></td>
								<td style="width:50%"><cf_get_lang dictionary_id="53823.İşyeri Sicil No"></td>
							</tr>
							<tr>
								<td>&nbsp;#get_in_out.branch_name#</td>
								<td>	
									<table style="width:400px;">
										<tr align="center">
										  <td>M</td>
										  <td>&nbsp;</td>
										  <td><cf_get_lang dictionary_id="59690.İş Kodu"></td>
										  <td>&nbsp;</td>
										  <td><cf_get_lang dictionary_id="59005.Şube Kod"></td>
										  <td>&nbsp;</td>
										  <td><cf_get_lang dictionary_id="55657.Sıra No"></td>
										  <td>&nbsp;</td>
										  <td><cf_get_lang dictionary_id="53827.İl Kodu"></td>
										  <td>&nbsp;</td>
										  <td><cf_get_lang dictionary_id="58638.İlçe"></td>
										  <td>&nbsp;</td>
										  <td>CD</td>
										  <td>&nbsp;</td>
										  <td><cf_get_lang dictionary_id="43311.İşyeri Aracı"> <cf_get_lang dictionary_id="57487.No"></td>
										</tr>
										<tr>
										  <td style="border : thin solid ##cccccc;">&nbsp;#get_in_out.ssk_m#</td>
										  <td>&nbsp;</td>
										  <td style="border : thin solid ##cccccc;">&nbsp;#get_in_out.SSK_JOB#</td>
										  <td>&nbsp;</td>
										  <td style="border : thin solid ##cccccc;">&nbsp;#get_in_out.SSK_BRANCH#</td>
										  <td>&nbsp;</td>
										  <td style="border : thin solid ##cccccc;">&nbsp;#get_in_out.SSK_NO#</td>
										  <td>&nbsp;</td>
										  <td style="border : thin solid ##cccccc;">&nbsp;#get_in_out.SSK_CITY#</td>
										  <td>&nbsp;</td>
										  <td style="border : thin solid ##cccccc;">&nbsp;#get_in_out.SSK_COUNTRY#</td>
										  <td>&nbsp;</td>
										  <td style="border : thin solid ##cccccc;">&nbsp;#get_in_out.SSK_CD#</td>
										  <td>&nbsp;</td>
										  <td style="border : thin solid ##cccccc;">&nbsp;#get_in_out.ssk_agent#</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"><cf_get_lang dictionary_id="53901.İşyerinin Adresi"></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;#get_in_out.branch_address# #get_in_out.branch_postcode#</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<table width="100%">
				<tr>
					<td>
						<table bordercolor="##CCCCCC" border="1" cellpadding="2" cellspacing="1" width="100%">
						<tr>
							<td rowspan="2"><cf_get_lang dictionary_id="59408.Yukarıdaki bilgilerin defter, kayıt ve belgelere uygun bulunduğunu, yanlış olması sebebiyle sigortalının eşi ve geçindirmekle yükümlü olduğu çocuklarına Kurumca yersiz olarak yapılan her türlü masrafları ödemeyi kabul ederim">.</td>
							<td style="width:80px;"><cf_get_lang dictionary_id="30631.Tarih"></td>
							<td><cf_get_lang dictionary_id="59691.İşyeri veya Vekilinin Adı Soyadı İmzası ve Kaşesi"></td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>		
	</tr>
</table>
</cfoutput>
<script type="text/javascript">
	window.print();
</script>
</cfif>
