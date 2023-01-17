<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_fee.cfm">
<cfquery name="DETAIL" datasource="#dsn#" maxrows="1">
	SELECT 
		BRANCH_ID,
		START_DATE,
		SOCIALSECURITY_NO,
		FINISH_DATE
	FROM
		EMPLOYEES_IN_OUT
	WHERE 
		IN_OUT_ID = #get_fee.in_out_id#
</cfquery>
<cfset my_branch_id = DETAIL.BRANCH_ID>
<cfquery name="SSK" datasource="#dsn#">
	SELECT 
		BRANCH.*,
		OUR_COMPANY.COMPANY_NAME,
        OUR_COMPANY.TEL_CODE,
        OUR_COMPANY.TEL,
        OUR_COMPANY.FAX,
		OUR_COMPANY.ADDRESS,
        OUR_COMPANY.TAX_OFFICE,
        OUR_COMPANY.TAX_NO,
        OUR_COMPANY.EMAIL,
		OUR_COMPANY.MANAGER
	FROM 
		BRANCH,
		OUR_COMPANY
	WHERE 
		BRANCH.BRANCH_ID = #my_branch_id# 
		AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
</cfquery>
<cfif not detail.recordcount>
	<script type="text/javascript">
		alert("Çalışan Bilgileri Eksik !");
		window.close();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_EMP_DETAIL" datasource="#DSN#">
	SELECT
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.MOBILCODE,
		E.MOBILTEL,
		ED.HOMETEL_CODE,
		ED.HOMETEL,
		ED.HOMEADDRESS,
		ED.HOMEPOSTCODE,
		ED.HOMECITY,
		ED.HOMECOUNTRY,
		ED.HOMECOUNTY,
		ED.SEX,
		ED.LAST_SCHOOL,
		EI.FATHER,
		EI.BIRTH_DATE,
		EI.BIRTH_PLACE,
		EI.TC_IDENTY_NO,
		EI.MARRIED
	FROM
		EMPLOYEES E,
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IDENTY EI
	WHERE
		E.EMPLOYEE_ID = #get_fee.EMPLOYEE_ID#
		AND ED.EMPLOYEE_ID = E.EMPLOYEE_ID
		AND EI.EMPLOYEE_ID = E.EMPLOYEE_ID
</cfquery>
<cfif isdefined('get_fee.witness1_id') and len(get_fee.witness1_id)>
	<cfquery name="get_witness1" datasource="#dsn#">
		SELECT 
			HOMEADDRESS
		FROM
			EMPLOYEES_DETAIL
		WHERE
			EMPLOYEE_ID = #get_fee.witness1_id#
	</cfquery>
</cfif>
<cfif isdefined('get_fee.witness2_id') and len(get_fee.witness2_id)>
	<cfquery name="get_witness2" datasource="#dsn#">
		SELECT 
			HOMEADDRESS
		FROM
			EMPLOYEES_DETAIL
		WHERE
			EMPLOYEE_ID = #get_fee.witness2_id#
	</cfquery>
</cfif>
<br/><br/>

<cfscript>
	erkek_sayisi = 0;
	kadin_sayisi = 0;
	cocuk_sayisi = 0;
	eski_hukumlu_sayisi = 0;
	ozurlu_sayisi = 0;
	stajyer_sayisi = 0;
</cfscript>

<cfquery name="get_all_personel" datasource="#dsn#">
	SELECT
		EMPLOYEES_IN_OUT.EMPLOYEE_ID,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.VALID,
		EMPLOYEES_IN_OUT.SSK_STATUTE,
		EMPLOYEES_DETAIL.SEX,
		EMPLOYEES_DETAIL.TERROR_WRONGED,
		EMPLOYEES_DETAIL.SENTENCED,
		EMPLOYEES_DETAIL.DEFECTED,
		EMPLOYEES_IN_OUT.DEFECTION_LEVEL,
		EMPLOYEES_IN_OUT.SURELI_IS_AKDI,
		EMPLOYEES_IN_OUT.SALARY_TYPE
	FROM
		EMPLOYEES,
		EMPLOYEES_IN_OUT,
		EMPLOYEES_DETAIL,
		BRANCH	
	WHERE
		EMPLOYEES_IN_OUT.USE_SSK = 1
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES_DETAIL.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND
		(
			(EMPLOYEES_IN_OUT.FINISH_DATE >= #createodbcdatetime(GET_FEE.FEE_DATE)# AND	EMPLOYEES_IN_OUT.VALID = 1)
			OR 
			EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
		)
		AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
		AND BRANCH.BRANCH_ID = #DETAIL.BRANCH_ID#
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>

<cfquery name="GET_ALL_WOMEN" dbtype="query">
	SELECT EMPLOYEE_ID FROM get_all_personel WHERE SEX = 0 OR SEX IS NULL
</cfquery>

<cfquery name="GET_ALL_MEN" dbtype="query">
	SELECT EMPLOYEE_ID FROM get_all_personel WHERE SEX = 1
</cfquery>

<cfquery name="GET_ALL_SAKAT" dbtype="QUERY">
	SELECT EMPLOYEE_ID FROM get_all_personel WHERE DEFECTION_LEVEL > 0
</cfquery>

<cfquery name="GET_ALL_HUKUMLU" dbtype="QUERY">
	SELECT EMPLOYEE_ID FROM get_all_personel WHERE SENTENCED = 1
</cfquery>

<cfquery name="GET_ALL_STAJYER" dbtype="QUERY">
	SELECT EMPLOYEE_ID FROM get_all_personel WHERE SSK_STATUTE = 75
</cfquery>

<cfif len(get_fee.ACCIDENT_TYPE_ID)>
	<cfquery name="get_accident_name" datasource="#dsn#">
		SELECT 
			ACCIDENT_TYPE
		FROM
			EMPLOYEE_WORK_ACCIDENT_TYPE
		WHERE
			ACCIDENT_TYPE_ID = #get_fee.ACCIDENT_TYPE_ID#
	</cfquery>
</cfif>

<cfscript>
	erkek_sayisi = GET_ALL_MEN.recordcount;
	kadin_sayisi = GET_ALL_WOMEN.recordcount;
	cocuk_sayisi = 0;
	eski_hukumlu_sayisi = GET_ALL_HUKUMLU.recordcount;
	ozurlu_sayisi = GET_ALL_SAKAT.recordcount;
	stajyer_sayisi = GET_ALL_STAJYER.recordcount;
</cfscript>

<cfoutput>
<table align="center" cellpadding="3" cellspacing="0" width="700" border="1" bordercolor="000000">
	<tr>
		<td><img height="55" src="/images/ssk.gif"></td>
        <td style="width:125mm;" align="center"><cf_get_lang dictionary_id="45685.T.C SOSYAL GÜVENLİK KURUMU"><br /><cf_get_lang dictionary_id="45608.Sosyal Sigortalar Genel Müdürlüğü"></td>
        <td><cf_get_lang dictionary_id="45418.Belgenin Düzenlendiği Tarih"> :#dateformat(get_fee.FEE_DATE,dateformat_style)#<br />
            <cf_get_lang dictionary_id="45584.Belgenin Düzenlendiği Sayı"> :
        </td>
	</tr>	
    <tr>
    	<td colspan="3" class="formbold" align="center"><cf_get_lang dictionary_id="45592.İŞ KAZASI VE MESLEK HASTALIĞI BİLDİRİM FORMU"></td>
    </tr>
    <!--- <tr height="30">
    	<!--- 1 --->
        <td style="writing-mode: tb-rl;width:1%; filter:flipv() fliph();" align="center" class="txtbold">İşyerinin</td>
        <td colspan="2">
            <table border="0" cellpadding="0" cellspacing="0" width="708">
                <tr style="height:5mm;">
                    <td>Bağlı Bulunduğu İl:</td>
                    <td>İşyeri Sicil No:&nbsp; #SSK.work_zone_m##SSK.work_zone_job##SSK.work_zone_file##SSK.work_zone_city#</td>
            	</tr>
                <tr><td colspan="3"><hr /></td></tr>
    			<tr>
                    <td colspan="2">
                        <table cellpadding="0" cellspacing="0" border="0" width="708">
                            <tr>
                                <td>Vergi Dairesi ve Numarası:&nbsp;#ssk.TAX_OFFICE# &nbsp; #ssk.TAX_NO#</td>
                                <td>Tel:&nbsp; (#ssk.TEL_CODE#) &nbsp;#ssk.TEL#</td>
                                <td>Fax:&nbsp; (#ssk.TEL_CODE#) &nbsp;#ssk.FAX#</td>
                            </tr>
                            <tr><td colspan="3"><hr /></td></tr>
                            <tr style="height:5mm;">
                                <td colspan="3">İşyerinin Unvanı ve Adresi:&nbsp; #ssk.BRANCH_FULLNAME# &nbsp; #ssk.BRANCH_ADDRESS#  #ssk.BRANCH_POSTCODE# #ssk.BRANCH_COUNTY# #ssk.BRANCH_CITY#</td>
                            </tr>
                            <tr><td colspan="3"><hr /></td></tr>
                            <tr>
                                <td colspan="3">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td colspan="3" style="width:20mm;">İşçi Sayısı:</td>
                                            <td>
                                                <table border="0" cellpadding="0" cellspacing="0" width="570">
                                                    <tr>
                                                        <td>Erkek</td>
                                                        <td><input type="text" name="erkek_sayisi" style="width:25px;" value="#erkek_sayisi#" disabled></td>
                                                        <td>Kadın</td>     	
                                                        <td><input type="text" name="kadin_sayisi" style="width:25px;" value="#kadin_sayisi#" disabled></td>
                                                        <td>Çocuk</td>
                                                        <td><input type="text" name="cocuk_sayisi" style="width:25px;" value="#cocuk_sayisi#" disabled></td>
                                                        <td>Stajyer-çırak</td>
                                                        <td><input type="text" name="stajyer_sayisi" style="width:25px;" value="#stajyer_sayisi#" disabled></td>
                                                        <td>Terör Mağduru</td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Özürlü</td>
                                                        <td><input type="text" name="ozurlu_sayisi" style="width:25px;" value="#ozurlu_sayisi#" disabled></td>
                                                        <td>Eski Hükümlü</td>
                                                        <td><input type="text" name="eski_hukumlu_sayisi" style="width:25px;" value="#eski_hukumlu_sayisi#" disabled></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>   
                        </table>
    				</td>
    			</tr>
    		</table>
    	</td>
    </tr> --->
    <tr height="30">
		<!--- 2 --->
        <td style="writing-mode: tb-rl;width:5%; filter:flipv() fliph();" align="center" class="txtbold"><cf_get_lang dictionary_id="45586.Kazazede veya Kazazedelerin">/<cf_get_lang dictionary_id="45583.Meslek Hastalığı Tanısı veya Şüphesi ile Hastaneye Sevk edilenin"></td>
        <td colspan="3">
            <table border="0" cellspacing="0" cellpadding="0" style="width:100%">
            	<tr>
                	<td style="width:15mm;"><cf_get_lang dictionary_id="32370.Adı Soyadı">:</td>
                    <td style="width:45mm;">#get_fee.employee_name# #get_fee.employee_surname#</td>
                    <td style="width:55mm;"><cf_get_lang dictionary_id="32872.Cinsiyeti">:
	                    <input type="checkbox" name="sex" id="sex" value="1" <cfif GET_EMP_DETAIL.SEX eq 1> checked</cfif> disabled><cf_get_lang dictionary_id="58959.Erkek">
                        <input type="checkbox" name="sex1" id="sex1" value="0" <cfif GET_EMP_DETAIL.SEX eq 0> checked</cfif> disabled><cf_get_lang dictionary_id="58958.Kadın">
                    </td>
                    <td style="width:40mm;"><cf_get_lang dictionary_id="58727.Doğum Tarihi">:&nbsp; #dateformat(GET_EMP_DETAIL.BIRTH_DATE,dateformat_style)#</td>
                </tr>
                <tr><td colspan="6"><hr /></td></tr>
                <tr>
                	<td colspan="6">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td><cf_get_lang dictionary_id="58025.TC Kimlik No">:&nbsp; #GET_EMP_DETAIL.TC_IDENTY_NO#</td>
                                <td><cf_get_lang dictionary_id="45579.SSK Sicil No">:&nbsp; #DETAIL.SOCIALSECURITY_NO#</td>
                            </tr>
                            <tr><td colspan="6"><hr /></td></tr>
                            <tr style="height:2mm;">
                                <td style="width:85mm;"><cf_get_lang dictionary_id="38923.İşe Giriş Tarihi">:&nbsp; #dateformat(detail.start_date,dateformat_style)#</td>
                                <td style="width:75mm;"><cf_get_lang dictionary_id="30693.Medeni Hali">:&nbsp;
                                    <input type="checkbox" name="married1" id="married1" value="0" <cfif GET_EMP_DETAIL.married EQ 0>checked</cfif>><cf_get_lang dictionary_id="31205.Bekar">
                                    <input type="checkbox" name="married2" id="married2" value="1" <cfif GET_EMP_DETAIL.married EQ 1>checked</cfif>><cf_get_lang dictionary_id="55743.Evli">
                                    <input type="checkbox" name="married3" id="married3"><cf_get_lang dictionary_id="51555.Dul">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr><td colspan="6"><hr /></td></tr>
                <tr>
                	<td colspan="6">
                    	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                        	<tr style="height:8mm;">
                                <td><cf_get_lang dictionary_id="30929.Öğrenim Durumu">:</td>
                                <td>
                                    <table border="0" width="100%">
                                        <tr>
                                            <td>&nbsp;<cf_get_lang dictionary_id="45575.Okur Yazar"></td>
                                            <td><input type="checkbox"<cfif GET_EMP_DETAIL.LAST_SCHOOL eq 1>checked</cfif> name="last_school" id="last_school" disabled></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="41896.Okur Yazar Değil"></td>
                                            <td><input type="checkbox"<cfif GET_EMP_DETAIL.LAST_SCHOOL eq 1>checked</cfif> name="last_school" id="last_school" disabled></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="34843.İlköğretim"></td>
                                            <td><input type="checkbox"<cfif GET_EMP_DETAIL.LAST_SCHOOL eq 1>checked</cfif> name="last_school" id="last_school" disabled></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="45578.Orta Öğretim"></td>
                                            <td><input type="checkbox"<cfif GET_EMP_DETAIL.LAST_SCHOOL eq 2>checked</cfif> name="last_school" id="last_school" disabled></td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;<cf_get_lang dictionary_id="34847.Yüksek Lisans"></td>
                                            <td><input type="checkbox"<cfif GET_EMP_DETAIL.LAST_SCHOOL eq 7>checked</cfif> name="last_school" id="last_school" disabled></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="29755.Üniversite"></td>
                                            <td><input type="checkbox"<cfif GET_EMP_DETAIL.LAST_SCHOOL eq 3>checked</cfif> name="last_school" id="last_school" disabled></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="34847.Y.Lisans"></td>
                                            <td><input type="checkbox"<cfif GET_EMP_DETAIL.LAST_SCHOOL eq 5>checked</cfif> name="last_school"  id="last_school" disabled></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="31293.Doktora"></td>
                                            <td><input type="checkbox"<cfif GET_EMP_DETAIL.LAST_SCHOOL eq 2>checked</cfif> name="last_school" id="last_school" disabled></td>
                                        </tr>
                                    </table>
                                </td>
                        	</tr>
                        </table>
                    </td>
                </tr>
                <tr><td colspan="6"><hr /></td></tr>
                <tr>
                	<td colspan="6">
                    	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                        	<tr>
                            	<td><cf_get_lang dictionary_id="45582.İstihdam Durumu">:
                                    <table border="0">
                                        <tr>
                                        	<td><cf_get_lang dictionary_id="41536.Kamu">:</td>
                                            <td><input type="checkbox" /></td>
                                            <td><cf_get_lang dictionary_id="57979.Özel"></td>
                                            <td><input type="checkbox" /></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                	<table border="0" width="100%">
                                    	<tr>
                                        	<td>&nbsp;<cf_get_lang dictionary_id="45769.Daimi"></td>
                                            <td><input type="checkbox" /></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="45576.Mevsimlik"></td>
                                            <td><input type="checkbox" /></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="45541.Geçici"></td>
                                            <td><input type="checkbox" /></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="40525.Eski Hükümlü"></td>
                                            <td><input type="checkbox" /></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="53656.Hükümlü"></td>
                                            <td><input type="checkbox" /></td>
                                        </tr>
                                        <tr>
                                        	<td>&nbsp;<cf_get_lang dictionary_id="31232.Özürlü"></td>
                                            <td><input type="checkbox" /></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="45538.Ödünç çalışan"></td>
                                            <td><input type="checkbox" /></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="53657.Terör Mağduru"></td>
                                            <td><input type="checkbox" /></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="41911.Stajyer">-<cf_get_lang dictionary_id="54077.Çırak"></td>
                                            <td><input type="checkbox" /></td>
                                            <td>&nbsp;<cf_get_lang dictionary_id="58156.Diğer"></td>
                                            <td><input type="checkbox" /></td>
                                        </tr>
                                    </table>
                                    <table border="0">
                                    	<tr>
                                        	<td>&nbsp;<cf_get_lang dictionary_id="45580.Alt İşverene ait çalışan"></td>
                                            <td><input type="checkbox" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr><td colspan="6"><hr /></td></tr>
                <tr>
                	<td colspan="6">
                        <table border="0" width="100%">
                        	<tr>
                                <td style="width:32mm;"><cf_get_lang dictionary_id="30128.Çalışma Şekli">:</td>
                                <td><cf_get_lang dictionary_id="38669.Tam Zamanlı">&nbsp; <input type="checkbox" /></td>
                                <td><cf_get_lang dictionary_id="45533.Kısmi Zamanlı">&nbsp; <input type="checkbox" /></td>
                                <td><cf_get_lang dictionary_id="58156.Diğer">&nbsp; <input type="checkbox" /></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr><td colspan="6"><hr /></td></tr>
                <tr>
                	<td colspan="6">
                        <table border="0" width="700">
                            <tr>
                                <td style="width:34mm;"><cf_get_lang dictionary_id="45529.Prim Ödeme hali">:</td>
                                <td><cf_get_lang dictionary_id="45530.sona erdi"></td>
                                <td style="width:10mm;"><input type="checkbox" /></td>
                                <td><cf_get_lang dictionary_id="45528.sona ermedi"></td>
                                <td style="width:10mm;"><input type="checkbox" /></td>
                                <td><cf_get_lang dictionary_id="45527.Sona erdi ise; erdiği tarih">: ...... / ...... / ......</td>
                            </tr>
                        </table>
                	</td>
                </tr>
                <tr><td colspan="6"><hr /></td></tr>
                <tr>
                	<td colspan="6">
                    	<table border="0" width="700">
                        	<tr>
                            	<td style="width:95mm;"><cf_get_lang dictionary_id="45524.Son bir yıl içindeki toplam ücretli izin gün sayısı">:</td>
                    			<td><cf_get_lang dictionary_id="45501.Son işyerine giriş tarihi">:&nbsp; &nbsp;  ...... / ...... / ......</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr><td colspan="6"><hr /></td></tr>
                <tr>
                	<td colspan="6">
                    	<table border="0">
                        	<tr>
                            	<td width="350"><cf_get_lang dictionary_id="45497.Esas İşi (Mesleği)">:&nbsp; #get_fee.emp_work#</td>
                                <td width="350"><cf_get_lang dictionary_id="45494.Uyruğu(Yabancı ise ülke adı)">:</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr><td colspan="6"><hr /></td></tr>
                <tr>
                	<td colspan="6">
                    	<table border="0" width="700">
                        	<tr>
                            	<td style="width:33mm;"><cf_get_lang dictionary_id="45489.İşçinin 1.derece yakınının"></td>
                                <td style="width:15mm;"><cf_get_lang dictionary_id="32370.Adı Soyadı">:</td>
                                <td style="width:45mm;">&nbsp;#get_fee.RELATIVE_NAME_SURNAME#</td>
                                <td style="width:15mm;"><cf_get_lang dictionary_id="45704.Açık Adresi">:</td>
                                <td style="width:45mm;">&nbsp; #get_fee.RELATIVE_ADDRESS#</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
	</tr>
    <tr height="30">
	    <!--- 3 --->
      	<td style="writing-mode: tb-rl;width:18mm; filter:flipv() fliph();" align="center" class="txtbold"><cf_get_lang dictionary_id="45703.İş Kazası Halinde Doldurulacaktır">.</td>
    	<!--- <td>
        	<table border="0" cellspacing="0" cellpadding="0" style="height:145mm;">
        		<tr>
                    <td>
                    	<table border="1" cellspacing="0" cellpadding="0" style="height:145mm;">
                        	<tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">3</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">4</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">5</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">6</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">7</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">8</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">9</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">10</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">11</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">12</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">13</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">14</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">15</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">16</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">17</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">18</td></tr>
                            <tr><td style="writing-mode: tb-rl;width:5mm; filter:flipv() fliph();">19</td></tr>
                        </table>
                    </td> 
                </tr>
        	</table>
       	</td>--->
        <td colspan="3">
        	<table border="0" cellpadding="0" cellspacing="0" width="708">
            	<tr style="height:5mm;">
                    <td width="33%"><cf_get_lang dictionary_id="45702.İş Kazasının Tarihi">:&nbsp; #dateformat(get_fee.event_date,dateformat_style)#</td>
                    <td width="43%"><cf_get_lang dictionary_id="45488.Kaza Gününde İşbaşı saati">:&nbsp; <cfif len(get_fee.workstart)>#get_fee.workstart#</cfif></td>
                    <td width="43%"><cf_get_lang dictionary_id="45486.İş Kazasının Saati">:&nbsp; <cfif len(get_fee.event_hour)> #get_fee.event_hour#:#get_fee.event_min#</cfif></td>
                </tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr>
                	<td><cf_get_lang dictionary_id="45696.Kaza Anında Yaptığı İş">:</td>
                </tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr>
                	<td><cf_get_lang dictionary_id="45674.Kazanın sebebi">:</td>
                    <td><cf_get_lang dictionary_id="45675.Kaza sonucu iş göremezliği">:&nbsp; 
                    	<cf_get_lang dictionary_id="58564.Var"><input type="checkbox" />
                        <cf_get_lang dictionary_id="58546.Yok"><input type="checkbox" />
                        <cf_get_lang dictionary_id="40507.Ölüm"><input type="checkbox" />
                    </td>
                </tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45665.Yaranın Türü">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45673.Yaranın Vucüttaki Yeri">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45645.İşyerinin büyüklüğü">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45672.Çalışılan Ortam">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45643.Çalışılan Çevre">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45631.Kaza Anında Kazazedenin Yürütmekte Olduğu Genel Faaliyet">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45624.Kazadan Az Önceki Zamanda Kazazedenin Yürüttüğü Özel Faaliyet">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45621.Olayı Normal Seyrinden Saptıran Kazaya Sebebiyet Veren Olay(Sapma)">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45610.Yaralanmaya Sebep olan Hareket(Olay)">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45620.Özel Faaliyet Sırasında Kullandığı Materyal(Araç)">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45619.Sapmaya Sebep Veren Materyal(Araç)">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr><td colspan="9"><cf_get_lang dictionary_id="45615.Yaralanmaya Sebep Olan Hareket Sırasında Kullanılan Materyal(Araç)">:</td></tr>
                <tr><td colspan="9"><hr /></td></tr>
                <tr>
                    <td style="width:75mm;"><cf_get_lang dictionary_id="45613.Kazayı Gören">:
                        <input type="checkbox" name="_see1" id="_see1" value="1" <cfif len(get_fee.witness1) or len(get_fee.witness2)>checked</cfif>>&nbsp;Var
						<input type="checkbox" name="_see2" id="_see2" value="1" <cfif not len(get_fee.witness1) and not len(get_fee.witness2)>checked</cfif>>&nbsp;Yok
                    </td>
                    <td style="width:30mm;"><cf_get_lang dictionary_id="45606.Şahitlerin Adresi">:&nbsp; 
						<cfif isdefined('get_fee.witness1_id') and len(get_fee.witness1_id)>1- #get_witness1.HOMEADDRESS#</cfif>
						<cfif isdefined('get_fee.witness2_id') and len(get_fee.witness2_id)>2- #get_witness2.HOMEADDRESS#</cfif>
                    </td>
               </tr>
               <tr><td colspan="9"><hr /></td></tr>
               <tr>
               		<td colspan="9"><cf_get_lang dictionary_id="45609.Şahitlerin Adı Soyadı">:&nbsp; <cfif len(get_fee.witness1)>1-#get_fee.witness1#</cfif>&nbsp; &nbsp; <cfif len(get_fee.witness2)>2-#get_fee.witness2#</cfif></td>
               </tr>
               <tr>
                   <td><cf_get_lang dictionary_id="45758.Şahitlerin imzası">:</td>
               </tr>
               <tr><td colspan="9"><hr /></td></tr>
               <tr>
                   <td colspan="9"><cf_get_lang dictionary_id="45760.Kazanın Oluş Şeklini ve Sebebini Açıklayınız">: #get_fee.event#</td>
               </tr>
             </table>
        </td>
    </tr>
    <tr height="30">
    <!--- 4 --->
        <td style="writing-mode: tb-rl;width:5%; filter:flipv() fliph();" align="center" class="txtbold"><cf_get_lang dictionary_id="45607.Mesleki Hastalığı Halinde Doldurulacaktır">.</td>
        <td valign="top">
            <table border="0" cellpadding="0" cellspacing="0" width="450">
            	<tr>
                    <td style="height:5mm;"><cf_get_lang dictionary_id="45730.Meslek Hastalığı Tanısı veya Şüphesi Tarihi">:&nbsp; #get_fee.PROFESSION_ILL_DIAGNOSIS#</td>
                </tr>
                <tr><td><hr /></td></tr>
                <tr>
                	<td style="height:5mm;"><cf_get_lang dictionary_id="45708.Meslek Hastalığı Tanısı veya Şüphesi ile Sevk edilenin Çalıştığı Bölüm / İş">:&nbsp; #get_fee.PROFESSION_ILL_WORK#</td>
                </tr>
                <tr><td><hr /></td></tr>
                <tr>
                	<td style="height:5mm;"><cf_get_lang dictionary_id="45729.Meslek Hastalığı Tanısı veya Şüphesinin Türü">:&nbsp; #get_fee.PROFESSION_ILL_DOUBT#</td>
                </tr>
                <tr><td><hr /></td></tr>
                <tr>
                    <td valign="top">
                    	<table border="0" cellpadding="0" cellspacing="0">
                        	<tr>
           	                	<td style="height:5mm; width:30mm;"><cf_get_lang dictionary_id="45905.Meslek Hastalığının Saptanma Şekli">:</td>
	       	                    <td style="width:30mm;"><cf_get_lang dictionary_id="45904.Periyodik Muayene ile"></td>
                                <td style="width:10mm;"><input type="checkbox" name="accident_result_dead" id="accident_result_dead" <cfif get_fee.JOB_ILLNESS_TO_FIX eq 0>checked</cfif> disabled></td>
                                <td style="width:30mm;"><cf_get_lang dictionary_id="58156.Diğer"></td>
                                <td style="width:10mm;"><input type="checkbox" name="light_wounded" id="light_wounded" <cfif get_fee.JOB_ILLNESS_TO_FIX eq 3>checked</cfif> disabled></td>
                            </tr>
                            <tr>
                            	<td>&nbsp;</td>
                                <td><cf_get_lang dictionary_id="53447.Üst Kurum Sevki ile"></td>
                                <td><input type="checkbox" name="accident_result_wounded" id="accident_result_wounded"  <cfif get_fee.JOB_ILLNESS_TO_FIX eq 1>checked</cfif> disabled></td>
                                <td><cf_get_lang dictionary_id="53448.Meslek Hast.Hast."></td>
                                <td><input type="checkbox" name="organ_to_lose" id="organ_to_lose"  <cfif get_fee.JOB_ILLNESS_TO_FIX eq 2>checked</cfif> disabled></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td  valign="top" style="text-align:right;">
            <table border="0" cellpadding="0" cellspacing="0" width="250">
                <tr>
                    <td style="height:5mm;" class="formbold">21-<cf_get_lang dictionary_id="48068.Düzenleme Tarihi">:&nbsp; #dateformat(get_fee.FEE_DATE,dateformat_style)#</td>
                </tr>
                <tr>
                    <td style="height:20mm;" align="center" valign="top"><cf_get_lang dictionary_id="45901.İşveren veya Vekilinin"><br/> <cf_get_lang dictionary_id="45897.Adı Soyadı ve İmzası"></td>
                </tr>
                <tr><td style="height:5mm;" class="formbold"><cf_get_lang dictionary_id="57428.E-posta">:&nbsp; #SSK.EMAIL#</td></tr>
            </table>
        </td>
    </tr>
    
</table>
<table border="0" align="center" width="820">
    <tr>
        <td colspan="5">
        <table border="0" cellspacing="0">
            <tr>
                <td style="font-size:11px;">
                    <cf_get_lang dictionary_id="57467.Not">: <cf_get_lang dictionary_id="a) İşverenler, işyerinde meydana gelen iş kazasını kanunun 4 üncü maddesi birinci fıkrası (a) bendi ile 5 inci madde kapsamındaki sigortalıları o yer kolluk kuvvetlerine">
                    <br /> <cf_get_lang dictionary_id="45892.derhal Kuruma da en geç kazadan sonraki üç iş günü  içinde, (b) bendi kapsamında sigortalının kendisi tarafından 1 ayı geçmemek şartıyla  rahatsızlığının bildirim yapmaya">
                    <br /> <cf_get_lang dictionary_id="45890.engel olmadığı günden sonra ki üç işgünü içinde ayrıca işveren sigortalının meslek hastalığına tutulduğunu öğrendiği veya bu durum kendisine bildirildiği günden başlayarak">
                    <br /> <cf_get_lang dictionary_id="45889.üç iş günü içinde (b) bendi kapsamındaki sigortalı isebu durumu öğrendiği günden başlayarak üç iş günü içinde Kuruma bildirmesi zorunludur."> <br />
                    &nbsp; &nbsp; &nbsp; &nbsp;
                    <cf_get_lang dictionary_id="45887.b) İşverenler işyerinde meydana gelen iş kazasını ve tespit edilecek meslek hastalığını en geç üç iş günü içinde yazı ile ilgili Bölge Müdürlüğüne bildirmek zorundadır."><br />
                    <cf_get_lang dictionary_id="45886.(4857 sayılı İş Kanunu md. 77) Bu bildirimi zamanında yapmayan işverenlere aynı kanunun 105 inci Maddesi uyarınca idari para cezası uygulanır."><br />
                     &nbsp; &nbsp; &nbsp; &nbsp;
                    <cf_get_lang dictionary_id="45884.c) 1, 2 ve 21 inci bölümler hem kaza hemde meslek hastalığı bildirimi durumunda, 3 ile 19 uncu bölümler sadece kaza bildiriminde, 20 nci bölüm ise sadece meslek hastalığı bildiriminde doldurulacaktır."><br />
                     &nbsp; &nbsp; &nbsp; &nbsp;
                    <cf_get_lang dictionary_id="45883.d) 5,6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, kazanın saati ve esas işi (mesleği) bölümleri seçildiğinde konu ile ilgili tablolar ekrana gelecektir.">
                    <cf_get_lang dictionary_id="45881.Ekrana gelen bu"><br /> <cf_get_lang dictionary_id="45879.tablolardan seçim işlemi yapılacaktır."> <cf_get_lang dictionary_id="45876.Bu alanlara konu ile ilgili tanımlayıcı kelime yazıldığında da arama motoru devreye girecektir.">
                    <cf_get_lang dictionary_id="45875.Arama motoru ilgili bölümlerdeki"><br /> <cf_get_lang dictionary_id="45873.tanımlayıcı başlıkları ekrana getirecektir."> <cf_get_lang dictionary_id="45870.ekrana gelen bu başlıklardan en uygun tanımlama seçilmelidir."><br />
                </td>
            </tr>
        </table>
        </td>
    </tr>
</table>
</cfoutput>
