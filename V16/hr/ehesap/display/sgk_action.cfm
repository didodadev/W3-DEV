<cfparam name="attributes.in_out_id" type="numeric" default="0">
<cfparam name="attributes.ese_id" type="numeric" default="0">

<cfif attributes.in_out_id gt 0>
    <cfquery name="getSgkDetail" datasource="#dsn#">
        SELECT
            EI.TC_IDENTY_NO,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            DATEPART(DAY,EIO.START_DATE) AS START_DATE_GUN,
            DATEPART(MONTH,EIO.START_DATE) START_DATE_AY,
            DATEPART(YEAR,EIO.START_DATE) START_DATE_YIL,
            CASE EIO.SSK_STATUTE WHEN 1 THEN 0 WHEN 2 THEN 8 WHEN 4 THEN 7 WHEN 11 THEN 18 ELSE -1 END AS SSK_STATUTE,
            CASE EIO.DEFECTION_LEVEL WHEN 0 THEN 'H' ELSE 'E' END AS DEFECTION_LEVEL,
            'H' AS ESKI_HUKUMLU,
            CASE EIO.DUTY_TYPE WHEN 6 THEN 'E' ELSE 'H' END AS IS_KISMI_ISTIHDAM,
            EIO.KISMI_ISTIHDAM_GUN,
            (CASE EIO.DUTY_TYPE WHEN 0 THEN '01' WHEN 1 THEN '01' WHEN 2 THEN '02' WHEN 6 THEN '02' ELSE '06' END) AS GOREV_KODU,
            B.BRANCH_WORK AS ISKOLU_KODU,
            SBC.BUSINESS_CODE + '  ' AS BUSINESS_CODE,
            SBC.BUSINESS_CODE_NAME,
            1 AS OGRENIM_DURUMU,
            EAEI.EDU_FINISH AS MEZUNIYET_YILI,
            EAEI.EDU_PART_NAME AS MEZUNIYET_BOLUMU,
            ED.HOMECITY,
            'TC' AS ULKE,
            ED.HOMETEL_CODE,
            ED.HOMETEL,
            SC.COUNTY_NAME,
            ED.HOMEPOSTCODE,
            ED.EMAIL_SPC,
            ED.MOBILCODE_SPC,
            ED.MOBILTEL_SPC,
            B.TCKIMLIK_NO,
            B.USER_NAME,
            B.SYSTEM_PASSWORD,
            B.COMPANY_PASSWORD,
            ED.BOULEVARD,
            ED.STREET,
            ED.EXTERNAL_DOOR_NUMBER,
            ED.AVENUE,
            ED.NEIGHBORHOOD,
            ED.INTERNAL_DOOR_NUMBER,
            DATEPART(DAY,EIO.FINISH_DATE) FINISH_DATE_GUN,
            DATEPART(MONTH,EIO.FINISH_DATE) FINISH_DATE_AY,
            DATEPART(YEAR,EIO.FINISH_DATE) FINISH_DATE_YIL,
            (CASE WHEN EIO.FINISH_DATE IS NULL THEN 'IN' ELSE 'OUT' END) AS ACTION_TYPE,
            (CASE WHEN DATEPART(MONTH,EIO.FINISH_DATE) - DATEPART(MONTH,EIO.START_DATE) = 1 THEN DATEPART(DAY,EIO.START_DATE) ELSE 0 END) AS ISE_GIRIS_GUN1,
            (CASE WHEN DATEPART(MONTH,EIO.FINISH_DATE) - DATEPART(MONTH,EIO.START_DATE) = 1 THEN DATEPART(MONTH,EIO.START_DATE) ELSE 0 END) AS ISE_GIRIS_AY1,
            (CASE WHEN DATEPART(MONTH,EIO.FINISH_DATE) - DATEPART(MONTH,EIO.START_DATE) = 0 THEN DATEPART(DAY,EIO.START_DATE) ELSE 0 END) AS ISE_GIRIS_GUN2,
            (CASE WHEN DATEPART(MONTH,EIO.FINISH_DATE) - DATEPART(MONTH,EIO.START_DATE) = 0 THEN DATEPART(MONTH,EIO.START_DATE) ELSE 0 END) AS ISE_GIRIS_AY2,
            (CASE WHEN DATEPART(MONTH,EIO.FINISH_DATE) - DATEPART(MONTH,EIO.START_DATE) = 1 THEN EPR1.TOTAL_DAYS ELSE 0 END) AS GUN_SAYISI_1,
            EPR2.TOTAL_DAYS AS GUN_SAYISI_2,
            (CASE WHEN DATEPART(MONTH,EIO.FINISH_DATE) - DATEPART(MONTH,EIO.START_DATE) = 1 THEN EPR1.SSK_MATRAH ELSE 0 END) AS SSK_MATRAH_1,
            EPR2.SSK_MATRAH AS SSK_MATRAH_2,
            (CASE WHEN DATEPART(MONTH,EIO.FINISH_DATE) - DATEPART(MONTH,EIO.START_DATE) = 1 THEN EPR1.IZIN ELSE 0 END) AS IZIN_1,
            EPR2.IZIN AS IZIN_2,
            EIO.EXPLANATION_ID,
			(CASE WHEN DATEPART(MONTH,EIO.FINISH_DATE) - DATEPART(MONTH,EIO.START_DATE) = 1 THEN
				(
				SELECT
					CASE WHEN (
						SELECT
							COUNT(DISTINCT EBILDIRGE_TYPE_ID)
						FROM
							OFFTIME
								LEFT JOIN SETUP_OFFTIME SO ON SO.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
						WHERE
							EMPLOYEE_ID = E.EMPLOYEE_ID
							AND IS_PAID = 0
							AND (DATEPART(MONTH,FINISHDATE) = 5 OR DATEPART(MONTH,STARTDATE) = 5 OR (DATEPART(MONTH,FINISHDATE) < 5 AND DATEPART(MONTH,STARTDATE) > 5))
						) > 1
					THEN
						12
					ELSE
						(
							SELECT
								DISTINCT EBILDIRGE_TYPE_ID
							FROM
								OFFTIME
									LEFT JOIN SETUP_OFFTIME SO ON SO.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
							WHERE
								EMPLOYEE_ID = E.EMPLOYEE_ID
								AND IS_PAID = 0
								AND (DATEPART(MONTH,FINISHDATE) = 5 OR DATEPART(MONTH,STARTDATE) = 5 OR (DATEPART(MONTH,FINISHDATE) < 5 AND DATEPART(MONTH,STARTDATE) > 5))
						)
					END
				)
				ELSE '' END) AS EKSIK_GUN_1,
			(
				SELECT
					CASE WHEN (
						SELECT
							COUNT(DISTINCT EBILDIRGE_TYPE_ID)
						FROM
							OFFTIME
								LEFT JOIN SETUP_OFFTIME SO ON SO.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
						WHERE
							EMPLOYEE_ID = E.EMPLOYEE_ID
							AND IS_PAID = 0
							AND (DATEPART(MONTH,FINISHDATE) = DATEPART(MONTH,EIO.START_DATE) OR DATEPART(MONTH,STARTDATE) = DATEPART(MONTH,EIO.START_DATE) OR (DATEPART(MONTH,FINISHDATE) < DATEPART(MONTH,EIO.START_DATE) AND DATEPART(MONTH,STARTDATE) > DATEPART(MONTH,EIO.START_DATE)))
						) > 1
					THEN
						12
					ELSE
						(
							SELECT
								DISTINCT EBILDIRGE_TYPE_ID
							FROM
								OFFTIME
									LEFT JOIN SETUP_OFFTIME SO ON SO.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
							WHERE
								EMPLOYEE_ID = E.EMPLOYEE_ID
								AND IS_PAID = 0
								AND (DATEPART(MONTH,FINISHDATE) = DATEPART(MONTH,EIO.FINISH_DATE) OR DATEPART(MONTH,STARTDATE) = DATEPART(MONTH,EIO.FINISH_DATE) OR (DATEPART(MONTH,FINISHDATE) < DATEPART(MONTH,EIO.FINISH_DATE) AND DATEPART(MONTH,STARTDATE) > DATEPART(MONTH,EIO.FINISH_DATE)))
						)
					END
				) AS EKSIK_GUN_2
        FROM
            EMPLOYEES E
                LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_APP_EDU_INFO EAEI ON EAEI.EMPLOYEE_ID = E.EMPLOYEE_ID AND EAEI.EDU_FINISH = (SELECT MAX(EDU_FINISH) FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEE_ID = E.EMPLOYEE_ID)
                LEFT JOIN SETUP_BUSINESS_CODES SBC ON SBC.BUSINESS_CODE_ID = EIO.BUSINESS_CODE_ID
                LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN SETUP_COUNTY SC ON SC.COUNTY_ID = ED.HOMECOUNTY
                LEFT JOIN BRANCH B ON B.BRANCH_ID = EIO.BRANCH_ID
                LEFT JOIN
                (
                    SELECT
                        SSK_MATRAH,
                        SAL_MON,
                        SAL_YEAR,
                        TOTAL_DAYS,
                        IZIN,
                        EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
                    FROM
                        EMPLOYEES_PUANTAJ_ROWS
                            LEFT JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
                ) AS EPR2 ON EPR2.SAL_MON = DATEPART(MONTH,EIO.FINISH_DATE) AND EPR2.SAL_YEAR = DATEPART(YEAR,EIO.FINISH_DATE) AND EPR2.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN
                (
                    SELECT
                        SSK_MATRAH,
                        SAL_MON,
                        SAL_YEAR,
                        TOTAL_DAYS,
                        IZIN,
                        EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
                    FROM
                        EMPLOYEES_PUANTAJ_ROWS
                            LEFT JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
                ) AS EPR1 ON ((EPR1.SAL_MON = DATEPART(MONTH,EIO.FINISH_DATE) - 1 AND EPR1.SAL_YEAR = DATEPART(YEAR,EIO.FINISH_DATE)) OR (EPR1.SAL_MON = DATEPART(MONTH,EIO.FINISH_DATE) + 11 AND EPR1.SAL_YEAR = DATEPART(YEAR,EIO.FINISH_DATE) - 1)) AND EPR1.EMPLOYEE_ID = E.EMPLOYEE_ID
        WHERE
            EIO.IN_OUT_ID = #attributes.in_out_id#
    </cfquery>
    <cfif !len(getSgkDetail.TCKIMLIK_NO) or !len(getSgkDetail.USER_NAME) or !len(getSgkDetail.SYSTEM_PASSWORD) or !len(getSgkDetail.COMPANY_PASSWORD)>
        Lütfen SGK erişim bilgilerini tanımlayınız.
    <cfelse>
        <cfscript>
            j_username=getSgkDetail.TCKIMLIK_NO;
            isyeri_kod=getSgkDetail.USER_NAME;
            j_password=getSgkDetail.SYSTEM_PASSWORD;
            isyeri_sifre=getSgkDetail.COMPANY_PASSWORD;
        
            sgk_no = getSgkDetail.TC_IDENTY_NO;
            ad = getSgkDetail.EMPLOYEE_NAME;
            soyad = getSgkDetail.EMPLOYEE_SURNAME;
            evrak_tarihi = now();
            
            if(len(getSgkDetail.EXPLANATION_ID)) {
                exp_id = listfind(reason_order_list(),getSgkDetail.EXPLANATION_ID);
            } else {
                exp_id = 0;
            }
        </cfscript>
        <table>
            <tr>
                <td>
                    <h2><cf_get_lang dictionary_id="58585.Kod"> :</h2>
                </td>
                <td>
                  <input type="text" name="captcha" id="captcha" style="width:100%" />
                </td>
                <td>
                  <img src="https://uyg.sgk.gov.tr/SigortaliTescil/PG" />
                </td>
                <td>
                  <input type="button" name="giriceri" value="Devam" onclick="login();" style="width:100%" />
                </td>
            </tr>
        </table>
        <div style="display:none">
            <iframe id="loginframe" src="" width="400" height="200">
            </iframe>
            <iframe id="getempframe" width="400" height="200">
            </iframe>
            <iframe id="getbildirgeframe" width="400" height="200">
            </iframe>
        </div>
        <div style="display:none">
            <cfinclude template="last_screen.cfm">
        </div>
      <script type="text/javascript">
            function login() {
                $("#loginframe").attr("src", "https://uyg.sgk.gov.tr/SigortaliTescil/amp/loginldap?j_username=<cfoutput>#j_username#</cfoutput>&isyeri_kod=<cfoutput>#isyeri_kod#</cfoutput>&j_password=<cfoutput>#j_password#</cfoutput>&isyeri_sifre=<cfoutput>#isyeri_sifre#</cfoutput>&isyeri_guvenlik=" + $("#captcha").val());
                setTimeout(function(){
                <cfif getSgkDetail.ACTION_TYPE is 'IN'>
                    ise_giris_bildirgesi_sayfasi();
                <cfelseif getSgkDetail.ACTION_TYPE is 'OUT'>
                    isten_ayrilis_bildirgesi_sayfasi();
                </cfif>
                }, 300);
            }
            function ise_giris_bildirgesi_sayfasi() {
                $("#loginframe").attr("src", "https://uyg.sgk.gov.tr/SigortaliTescil/jsp/anamenu.jsp?tckno=<cfoutput>#sgk_no#</cfoutput>");
                setTimeout(function(){
                  kimlikbulmasayfasi();
                }, 300);
        
            }
            function kimlikbulmasayfasi() {
                $("#getempframe").contents().find('form').submit();
                setTimeout(function(){
                  ise_giris_bildirge();
                }, 300);
            }
            function ise_giris_bildirge() {
                $("#getbildirgeframe").contents().find('form').submit();
                
                $("#lastform #tx_TekIsGirTarGG").val('<cfoutput>#getSgkDetail.START_DATE_GUN#</cfoutput>');
                $("#lastform #tx_TekIsGirTarAA").val('<cfoutput>#getSgkDetail.START_DATE_AY#</cfoutput>');
                $("#lastform #tx_TekIsGirTarYY").val('<cfoutput>#getSgkDetail.START_DATE_YIL#</cfoutput>');
                $("#lastform #sigtur").val('<cfoutput>#getSgkDetail.SSK_STATUTE#</cfoutput>');
                $("#lastform #cmb_Ozurkod").val('<cfoutput>#getSgkDetail.DEFECTION_LEVEL#</cfoutput>');
                $("#lastform #cmb_eskiHukumlu").val('<cfoutput>#getSgkDetail.ESKI_HUKUMLU#</cfoutput>');
                $("#lastform #cmb_ogrenimDurum").val('<cfoutput>#getSgkDetail.OGRENIM_DURUMU#</cfoutput>');
                $("#lastform #mezuniyetYil").val('<cfoutput>#getSgkDetail.MEZUNIYET_YILI#</cfoutput>');
                $("#lastform #tx_MezuniyetBlm").val('<cfoutput>#getSgkDetail.MEZUNIYET_BOLUMU#</cfoutput>');
                $("#lastform #30gundenaz").val('<cfoutput>#getSgkDetail.IS_KISMI_ISTIHDAM#</cfoutput>');
                $("#lastform #gunsayisi").val('<cfoutput>#getSgkDetail.KISMI_ISTIHDAM_GUN#</cfoutput>');
                $("#lastform #csgbiskolukod").val('<cfoutput>#getSgkDetail.ISKOLU_KODU#</cfoutput>');
                $("#lastform #cbMeslek").val('<cfoutput>#getSgkDetail.BUSINESS_CODE#</cfoutput>');
                $("#lastform #cbgorev").val('<cfoutput>#getSgkDetail.GOREV_KODU#</cfoutput>');
                $("#lastform #adresIlId").val('<cfoutput>#getSgkDetail.HOMECITY#</cfoutput>');
                $("#lastform #cmb_Ulke").val('<cfoutput>#getSgkDetail.ULKE#</cfoutput>');
                $("#lastform #tx_Tel1alan").val('<cfoutput>#getSgkDetail.HOMETEL_CODE#</cfoutput>');
                $("#lastform #tx_Tel1").val('<cfoutput>#getSgkDetail.HOMETEL#</cfoutput>');
                $("#lastform #S_ilce").val('<cfoutput>#getSgkDetail.COUNTY_NAME#</cfoutput>');
                $("#lastform #tx_PostaKodu").val('<cfoutput>#getSgkDetail.HOMEPOSTCODE#</cfoutput>');
                $("#lastform #tx_Eposta").val('<cfoutput>#getSgkDetail.EMAIL_SPC#</cfoutput>');
                $("#lastform #tx_Tel2alan").val('<cfoutput>#getSgkDetail.MOBILCODE_SPC#</cfoutput>');
                $("#lastform #tx_Tel2").val('<cfoutput>#getSgkDetail.MOBILTEL_SPC#</cfoutput>');
                $("#lastform #tx_Mah").val('<cfoutput>#getSgkDetail.NEIGHBORHOOD#</cfoutput>');
                $("#lastform #tx_Bulvar").val('<cfoutput>#getSgkDetail.BOULEVARD#</cfoutput>');
                $("#lastform #tx_Cadde").val('<cfoutput>#getSgkDetail.AVENUE#</cfoutput>');
                $("#lastform #tx_Sokak").val('<cfoutput>#getSgkDetail.STREET#</cfoutput>');
                $("#lastform #tx_Kapi").val('<cfoutput>#getSgkDetail.EXTERNAL_DOOR_NUMBER#</cfoutput>');
                $("#lastform #tx_Daire").val('<cfoutput>#getSgkDetail.INTERNAL_DOOR_NUMBER#</cfoutput>');
                setTimeout(function(){
                    do_belgeHazirla();
                }, 300);
                setTimeout(function(){
                    //window.close();
                }, 300);
        
            }
            function isten_ayrilis_bildirgesi_sayfasi() {
                $("#loginframe").attr("src", "https://uyg.sgk.gov.tr/SigortaliTescil/jsp/istenAyrilis.jsp");
                setTimeout(function(){
                  kimlikbulmasayfasi_cikis();
                }, 300);
        
            }
            function kimlikbulmasayfasi_cikis() {
                $("#getempframe").contents().find('form').submit();
                setTimeout(function(){
                  isten_ayrilis_bildirge();
                }, 300);
            }
            function isten_ayrilis_bildirge() {
                $("#lastform #cbMeslek").val('<cfoutput>#getSgkDetail.BUSINESS_CODE#</cfoutput>');
        
                $("#lastform #adresIlId").val('<cfoutput>#getSgkDetail.HOMECITY#</cfoutput>');
                $("#lastform #cmb_Ulke").val('<cfoutput>#getSgkDetail.ULKE#</cfoutput>');
                $("#lastform #tx_Tel1alan").val('<cfoutput>#getSgkDetail.HOMETEL_CODE#</cfoutput>');
                $("#lastform #tx_Tel").val('<cfoutput>#getSgkDetail.HOMETEL#</cfoutput>');
                $("#lastform #adresIlceId").val('<cfoutput>#getSgkDetail.COUNTY_NAME#</cfoutput>');
                $("#lastform #tx_PostaKodu").val('<cfoutput>#getSgkDetail.HOMEPOSTCODE#</cfoutput>');
                $("#lastform #tx_Eposta").val('<cfoutput>#getSgkDetail.EMAIL_SPC#</cfoutput>');
                $("#lastform #tx_Tel2alan").val('<cfoutput>#getSgkDetail.MOBILCODE_SPC#</cfoutput>');
                $("#lastform #tx_Cep").val('<cfoutput>#getSgkDetail.MOBILTEL_SPC#</cfoutput>');
                $("#lastform #tx_Mah").val('<cfoutput>#getSgkDetail.NEIGHBORHOOD#</cfoutput>');
                $("#lastform #tx_Bulvar").val('<cfoutput>#getSgkDetail.BOULEVARD#</cfoutput>');
                $("#lastform #tx_Cadde").val('<cfoutput>#getSgkDetail.AVENUE#</cfoutput>');
                $("#lastform #tx_Sokak").val('<cfoutput>#getSgkDetail.STREET#</cfoutput>');
                $("#lastform #tx_Kapi").val('<cfoutput>#getSgkDetail.EXTERNAL_DOOR_NUMBER#</cfoutput>');
                $("#lastform #tx_Daire").val('<cfoutput>#getSgkDetail.INTERNAL_DOOR_NUMBER#</cfoutput>');
				
                $("#lastform #tx_Cep").val('<cfoutput>#getSgkDetail.MOBILTEL_SPC#</cfoutput>');
                
                $("#lastform #belgetur1").val('<cfoutput>#getSgkDetail.SSK_STATUTE#</cfoutput>');
                $("#lastform #belgetur2").val('<cfoutput>#getSgkDetail.SSK_STATUTE#</cfoutput>');
                $("#lastform #gun1").val('<cfoutput>#getSgkDetail.GUN_SAYISI_1#</cfoutput>');
                $("#lastform #gun2").val('<cfoutput>#getSgkDetail.GUN_SAYISI_2#</cfoutput>');
                $("#lastform #heu1").val('<cfoutput>#getSgkDetail.SSK_MATRAH_1#</cfoutput>');
                $("#lastform #heu2").val('<cfoutput>#getSgkDetail.SSK_MATRAH_2#</cfoutput>');
                $("#lastform #eksikgunsayisi").val('<cfoutput>#getSgkDetail.IZIN_1#</cfoutput>');
                $("#lastform #eksikgunsayisi2").val('<cfoutput>#getSgkDetail.IZIN_2#</cfoutput>');
                
                $("#lastform #isegirisgun1").val('<cfoutput>#getSgkDetail.ISE_GIRIS_GUN1#</cfoutput>');
                $("#lastform #isegirisgun2").val('<cfoutput>#getSgkDetail.ISE_GIRIS_GUN2#</cfoutput>');
                $("#lastform #isegirisay1").val('<cfoutput>#getSgkDetail.ISE_GIRIS_AY1#</cfoutput>');
                $("#lastform #isegirisay2").val('<cfoutput>#getSgkDetail.ISE_GIRIS_AY2#</cfoutput>');
				
                $("#lastform #istencikgun2").val('<cfoutput>#getSgkDetail.FINISH_DATE_GUN#</cfoutput>');
                $("#lastform #tx_TekIsGirTarAA").val('<cfoutput>#getSgkDetail.FINISH_DATE_AY#</cfoutput>');
                
                $("#lastform #eksikgunnedeni").val('<cfoutput>#getSgkDetail.EKSIK_GUN_1#</cfoutput>');
                $("#lastform #eksikgunnedeni2").val('<cfoutput>#getSgkDetail.EKSIK_GUN_2#</cfoutput>');
                
                $("#lastform #txtnedenKodu").val('<cfoutput>#exp_id#</cfoutput>');
                $("#lastform #csgbiskolukod").val('<cfoutput>#getSgkDetail.ISKOLU_KODU#</cfoutput>');
                setTimeout(function(){
                    devam();
                }, 300);
                setTimeout(function(){
                    //window.close();
                }, 300);
            }
            $( document ).ready(function() {
                <cfif getSgkDetail.ACTION_TYPE is 'IN'>
                $('#getempframe').contents().find('body').append('<form name="form1" method="post" action="https://uyg.sgk.gov.tr/SigortaliTescil/amp/sigortaliTescilAction"><input type="hidden" name="jobid" id="jobid" value="kimlikbul"><input type="hidden" name="uyruk" id="uyruk"><input type="text" name="cmb_uyruk" id="cmb_uyruk" value="TC"><input type="text" name="tckno" id="tckno" size="13" maxlength="11" value="<cfoutput>#getSgkDetail.TC_IDENTY_NO#</cfoutput>"><input type="submit" name="button1" id="button1" title="BUL" value=" BUL "></form>');
                <cfelseif getSgkDetail.ACTION_TYPE is 'OUT'>
                $('#getempframe').contents().find('body').append('<form name="form1" method="post" action="https://uyg.sgk.gov.tr/SigortaliTescil/amp/sigortaliTescilAction"><input type="hidden" name="jobid" id="jobid" value="cikistcbul"><input type="hidden" name="uyruk" id="uyruk"><input type="text" name="cmb_uyruk" id="cmb_uyruk" value="TC"><input type="text" name="tckno" id="tckno" size="13" maxlength="11" value="<cfoutput>#getSgkDetail.TC_IDENTY_NO#</cfoutput>"><input type="text" name="tx_TekIsCikTarGG" id="tx_TekIsCikTarGG" maxlength="02" style="width:25" value="<cfoutput>#getSgkDetail.FINISH_DATE_GUN#</cfoutput>"><input type="text" name="tx_TekIsCikTarAA" id="tx_TekIsCikTarAA" maxlength="02" style="width:25" value="<cfoutput>#getSgkDetail.FINISH_DATE_AY#</cfoutput>"><input type="text" name="tx_TekIsCikTarYY" id="tx_TekIsCikTarYY" maxlength="04" style="width:50" value="<cfoutput>#getSgkDetail.FINISH_DATE_YIL#</cfoutput>"><input type="submit" name="button1" id="button1" title="BUL" value=" BUL "></form>'				);
                </cfif>
                $('#getbildirgeframe').contents().find('body').append('<form name="form1" method="post" action="https://uyg.sgk.gov.tr/SigortaliTescil/amp/sigortaliTescilAction"><input type="hidden" name="jobid" id="jobid" value="tekrarTescil"><input type="hidden" name="uyruk" id="uyruk"><input type="text" name="cmb_uyruk" id="cmb_uyruk" value="TC"><input type="text" name="tckno" id="tckno" size="13" maxlength="11" value="<cfoutput>#getSgkDetail.TC_IDENTY_NO#</cfoutput>"><input type="submit" name="button1" id="button1" title="BUL" value=" BUL "></form>');
                if(history.length > 1)
                    window.close();
            });
        </script>
    </cfif>
<cfelseif attributes.ese_id gt 0>
	<div id = "logindiv">
        <table>
            <tr>
                <td>
                    <h2><cf_get_lang dictionary_id="58585.Kod"> :</h2>
                </td>
                <td>
                  <input type="text" name="captcha" id="captcha" style="width:100%" />
                </td>
                <td>
                  <img src="https://ebildirge.sgk.gov.tr/WPEB/PG" />
                </td>
                <td>
                  <input type="button" name="giriceri" value="Devam" onclick="login();" style="width:100%" />
                </td>
            </tr>
        </table>
    </div>
    <div style="display:none">
        <iframe id="loginframe" src="" width="400" height="200">
        </iframe>
        <iframe id="getempframe" width="400" height="200">
        </iframe>
        <iframe id="getbildirgeframe" width="400" height="200">
        </iframe>
    </div>
    <div id="lastdiv" style="display:none">
        <form enctype="multipart/form-data" action="https://ebildirge.sgk.gov.tr/WPEB/amp/dosyatransfer" method="post" name="form1" id="form1">
        <input type="FILE" name="dosya" enctype="multipart/form-data">
        <input type="button" name="btnSubmit" width="100%" value="Dosyayı Gönder" onclick="form1.submit();">
        </form>
        <cf_get_lang dictionary_id="59402.İndirilen dosyayı yükleyerek devam edebilirsiniz.">
    </div>
    <cfquery name="getSgkDetail" datasource="#dsn#">
        SELECT
            *
        FROM
            EMPLOYEES_SSK_EXPORTS ESE
            	LEFT JOIN BRANCH B ON B.BRANCH_ID = ESE.SSK_BRANCH_ID
        WHERE
            ESE.ESE_ID = #attributes.ese_id#
    </cfquery>
    <cfif isDefined('attributes.downloadMode')>
	    <cfheader name="Content-Disposition" value="attachment; filename='#file_web_path#hr/ebildirge/#getSgkDetail.file_name#' " />
    </cfif>
    <cfscript>
		j_username=getSgkDetail.TCKIMLIK_NO;
		isyeri_kod=getSgkDetail.USER_NAME;
		j_password=getSgkDetail.SYSTEM_PASSWORD;
		isyeri_sifre=getSgkDetail.COMPANY_PASSWORD;
	</cfscript>
  <script type="text/javascript">
		function login() {
			$("#loginframe").attr("src", "https://ebildirge.sgk.gov.tr/WPEB/amp/loginldap?j_username=<cfoutput>#j_username#</cfoutput>&isyeri_kod=<cfoutput>#isyeri_kod#</cfoutput>&j_password=<cfoutput>#j_password#</cfoutput>&isyeri_sifre=<cfoutput>#isyeri_sifre#</cfoutput>&isyeri_guvenlik=" + $("#captcha").val());
			setTimeout(function(){
			  xml_import_sayfasi();
			}, 300);
		}
		function xml_import_sayfasi() {
			$("#loginframe").attr("src", "https://ebildirge.sgk.gov.tr/WPEB/amp/dosyatransferPage");
			setTimeout(function(){
			  getXmlFile();
			}, 300);
		}
		function getXmlFile() {
			$('#logindiv').hide();
			$('#lastdiv').show();
		}
	</script>
</cfif>
<script type="text/javascript">
		$(document).keypress(function(e){
			if (e.which == 13){
				login();
			}
		});
</script>
