<cfif not len(attributes.in_out_id)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='45869.Çalışana Öncelikle Giriş İşlemi Yapmalısınız'>");
		window.close();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="get_in_out" datasource="#dsn#">
	SELECT 
		BRANCH.*,
		EMPLOYEES_IN_OUT.*,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM 
		BRANCH,
		OUR_COMPANY,
		EMPLOYEES_IN_OUT 
	WHERE
		EMPLOYEES_IN_OUT.IN_OUT_ID = #attributes.IN_OUT_ID#
		AND BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID
		AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
</cfquery>
<cfquery name="emp_last_work" datasource="#dsn#">
	SELECT 
		ED.*,
		EI.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.PHOTO,
		E.PHOTO_SERVER_ID,
		E.MOBILCODE,
		E.MOBILTEL
	FROM 
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES E
	WHERE 
		ED.EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
		AND EI.EMPLOYEE_ID = ED.EMPLOYEE_ID
		AND E.EMPLOYEE_ID = ED.EMPLOYEE_ID
</cfquery>
<cfquery name="get_emp_edu" datasource="#dsn#" maxrows="1">
	SELECT * FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# ORDER BY EDU_FINISH DESC
</cfquery>
<cfquery name="get_emp_work" datasource="#dsn#" maxrows="1">
SELECT * FROM EMPLOYEES_APP_WORK_INFO WHERE EMPLOYEE_ID=#attributes.EMPLOYEE_ID# ORDER BY EXP_START DESC
</cfquery>
<cfif len(emp_last_work.last_school)>
	<cfquery name="get_education_level" datasource="#dsn#">
	  SELECT * FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID = #emp_last_work.last_school#
	</cfquery>
</cfif>
<cfif isDefined("attributes.EMEKLI")>
	<script type="text/javascript">
	function waitfor(){
	window.close();
	}	
	setTimeout("waitfor()",3000);
	window.print();
	</script>
</cfif>
<style>
	* table td {
		padding:1mm;
		}
	.header_
	{
		text-align:center;
		font-weight:bold;
	}

	.tbl_tcNo td
	{
		border-collapse:collapse;
		border:1px black solid;
	}
	.tbl_border
	{
		border-collapse:collapse;
		border:1px black solid;
	}
	.tbl_border td
	{
		border:1px black solid;
	}
</style>
<cfoutput>
<!-- sil -->
<cf_box title="#getlang('','SİGORTALI İŞE GİRİŞ BİLDİRGESİ','45972')#" uidrop="1">
<form name="send" id="send" method="post" action=""><!--- <cfoutput>#request.self#?fuseaction=ehesap.popup_ssk_start_work</cfoutput> --->
<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">

<div class="ui-scroll ListContent">
<table  cellpadding="0" cellspacing="0" width="720">
    <tr>
		<td align="center" class="header_">
            <cf_get_lang dictionary_id="45795.T.C."><br />
            <cf_get_lang dictionary_id="30489.SOSYAL GÜVENLİK KURUMU"><br/> 
  	  		<cf_get_lang dictionary_id="45972.SİGORTALI İŞE GİRİŞ BİLDİRGESİ"><br/>
            <span style="font-size:-6;">(<cf_get_lang dictionary_id="45963.4/1-a-b kapsamındaki sigortalılar için">)</span>
		</td>
	</tr>
<tr>
	<td>
        <table  cellpadding="0" cellspacing="0" width="720" class="tbl_tcNo">
            <tr ><!--- SOSYAL GUVENLIK SICIL NUMARASI (T.C.Kimlik Numarası) --->
                <td nowrap="nowrap">
                    <table width="100%">
                        <tr>
                            <td style="border:none;">
                                <table style="width:80mm;" cellpadding="0" cellspacing="0" align="left" class="tbl_border"><!---SOSYAL GÜVENLİK SİGORTA SİCİL NUMARASI --->
                                    <tr align="center">
                                        <td colspan="11" class="txtbold"><cf_get_lang dictionary_id="45956.SOSYAL GÜVENLİK SİGORTA SİCİL NUMARASI"><br/>(<cf_get_lang dictionary_id="58025.T.C. Kimlik Numarası">)</td>
                                    </tr>
                                    <tr>
                                        <cfif len(emp_last_work.TC_IDENTY_NO)>
                                        <cfloop from="1" to="#len(emp_last_work.TC_IDENTY_NO)#" index="i">
                                        <td width="20" align="center">#mid(emp_last_work.TC_IDENTY_NO,i,1)#</td>
                                        </cfloop>
                                        <cfelse>
                                        <td width="20" align="center" colspan="11">&nbsp;</td>
                                        </cfif>
                                    </tr>
                                </table>
                            </td>
                            <td  style="text-align:right; border:none;">
                                <table cellpadding="0" cellspacing="0" style="border-collapse:collapse;" >
                                    <tr >
                                        <td width="180" align="center" class="formbold"> A-<cf_get_lang dictionary_id="45953.BELGENİN MAHİYETİ"> </td>
                                        <td>
                                            <table width="100%" cellpadding="0" cellspacing="0" style="border-collapse:collapse;">
                                                <tr class="noBorder">
                                                    <td style="border:none;"><cf_get_lang dictionary_id="58548.İlk"> </td>
                                                    <td style="border:none;" width="20"><input type="radio" name="first_time" id="first_time" value="1"<cfif isDefined("attributes.first_time") and attributes.first_time eq 1> checked<cfelse>checked</cfif>></td>
                                                </tr>
                                                <tr>
                                                    <td style="border:none;"><cf_get_lang dictionary_id="54482.Tekrar"></td>
                                                    <td style="border:none;"><input type="radio" name="first_time" id="first_time" value="2"<cfif isDefined("attributes.first_time") and attributes.first_time eq 2> checked</cfif>></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <table  cellpadding="0" cellspacing="0" width="100%" class="tbl_border"  >
                        <tr align="center">
                            <td colspan="7" class="header_">B-<cf_get_lang dictionary_id="45952.SİGORTALININ KİMLİK BİLGİLERİ"></td>
                        </tr>
                        <tr>
                            <td width="2">1</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="57897.Adı"></td>
                            <td width="23%">#emp_last_work.EMPLOYEE_NAME#&nbsp;</td>
                            <td width="2">11</td>
                            <td style="width:20mm;"><cf_get_lang dictionary_id="45940.Yabancı Uyruklu İse Ülke Adı"></td>
                            <td >
                            <cfif isdefined('emp_last_work.NATIONALITY') and len(emp_last_work.NATIONALITY) and (emp_last_work.NATIONALITY neq 1)>
                            <cfquery name="get_nationality_name" datasource="#dsn#">
                            SELECT * FROM SETUP_COUNTRY WHERE COUNTRY_ID = #emp_last_work.NATIONALITY#
                            </cfquery>
                            #get_nationality_name.COUNTRY_NAME#
                            </cfif>&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td width="2">2</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="58550.Soyadı"></td>
                            <td>#emp_last_work.EMPLOYEE_SURNAME#&nbsp;</td>
                            <td width="2" rowspan="3">12</td>
                            <td rowspan="3" colspan="3" style="width:20mm;">
                                <table>
                                    <tr>
                                        <td  style="width:20mm;"><cf_get_lang dictionary_id="30929.Öğrenim Durumu"></td>
                                        <td>
                                            <cfif len(emp_last_work.last_school)>
                                                <cfif get_education_level.DECLARATION_ID eq 0><cf_get_lang dictionary_id='41869.Bilinmeyen'></cfif>
                                                <cfif get_education_level.DECLARATION_ID eq 1><cf_get_lang dictionary_id='41896.Okur yazar değil'></cfif>
                                                <cfif get_education_level.DECLARATION_ID eq 2><cf_get_lang dictionary_id='55678.İlkokul'></cfif>
                                                <cfif get_education_level.DECLARATION_ID eq 3><cf_get_lang dictionary_id='41886.Ortaokul yada İ.Ö.O'></cfif>
                                                <cfif get_education_level.DECLARATION_ID eq 4><cf_get_lang dictionary_id='833.Lise veya Dengi Okul'></cfif>
                                                <cfif get_education_level.DECLARATION_ID eq 5><cf_get_lang dictionary_id='41871.Yüksek okul veya fakülte'></cfif>
                                                <cfif get_education_level.DECLARATION_ID eq 6><cf_get_lang dictionary_id='30483.Yüksek lisans'></cfif>
                                                <cfif get_education_level.DECLARATION_ID eq 7><cf_get_lang dictionary_id='44296.Doktora'></cfif>
                                            </cfif>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td  style="width:20mm;"><cf_get_lang dictionary_id="55845.Mezuniyet Yılı"></td>
                                        <td><cfif isDefined("get_emp_edu.EDU_FINISH") and len(get_emp_edu.EDU_FINISH)>#year(get_emp_edu.EDU_FINISH)#</cfif></td>
                                    </tr>
                                    
                                    <tr>
                                        <td  style="width:20mm;"><cf_get_lang dictionary_id="834.Mezuniyet Bölümü"></td>
                                        <td>#get_emp_edu.EDU_PART_NAME#</td>
                                    </tr>
                                    
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td width="2">3</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="45931.İlk Soyadı"></td>
                            <td>#emp_last_work.LAST_SURNAME#&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="2">4</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="58033.Baba Adı"></td><!-- style="height:5mm;width:65mm"-->
                            <td>#emp_last_work.father#&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="2">5</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="58440.Ana Adı"></td>
                            <td>#emp_last_work.mother#&nbsp;</td>
                            <td width="2" rowspan="3">13</td>
                            <td rowspan="3" style="width:20mm"><cf_get_lang dictionary_id="35141.Askerlik Durumu"></td>
                            <td rowspan="3" colspan="3" style="width:20mm;">
                                <table>
                                    <tr>
                                        <td style="border:none;" colspan="2" align="center"><font size="-6"><cf_get_lang dictionary_id="45938.Başlangıç-Bitiş Tarihi"></font></td>
                                    </tr>
                                    <tr>
                                        <td style="border:none;" colspan="2" align="center"><font size="-6"> . . / . . / . . .</font></td>
                                    </tr>
                                    <tr>
                                        <td style="border:none;"><font size="-6"><cf_get_lang dictionary_id="56148.Er"></font><input type="radio"></td>
                                        <td style="text-align:right; border:hidden;"><font size="-6"><cf_get_lang dictionary_id="46190.Yedek Sb"></font><input type="radio"></td>
                                    </tr>
                                    <tr>
                                        <td style="border:none;"><font size="-6"><cf_get_lang dictionary_id="31212.Muaf"></font><input type="radio"></td>
                                        <td style="text-align:right; border:none;"><font size="-6"><cf_get_lang dictionary_id="31214.Tecilli"></font><input type="radio"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td width="2">6</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="57790.Doğum Yeri"></td>
                            <td>#emp_last_work.birth_place#&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="2">7</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
                            <td><cfif len(emp_last_work.birth_date)>#dateformat(emp_last_work.birth_date,dateformat_style)#<cfelse>&nbsp;</cfif>&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="2">8</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="51527.Cinsiyeti"></td>
                            <td>
                                <cf_get_lang dictionary_id="58959.Erkek"><input type="radio"<cfif emp_last_work.sex eq 1>checked</cfif>>&nbsp;
                                <cf_get_lang dictionary_id="58958.Kadın"><input type="radio"<cfif emp_last_work.sex eq 0>checked</cfif>>
                            </td>
                            <td width="2" rowspan="9">14</td>
                            <td rowspan="6" colspan="3">
                                <table>
                                    <tr>
                                        <td style="border:none;" colspan="2"><font size="-6"><cf_get_lang dictionary_id="38974.İkametgah Adresi">:</font></td><td style="border:none;">#emp_last_work.homeaddress# #emp_last_work.HOMEPOSTCODE# &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td style="border:none;">
                                            <font size="-6"><cf_get_lang dictionary_id="58638.İlçe">:&nbsp;<cfif len(emp_last_work.HOMECOUNTY)>
                                            <cfquery name="get_county" datasource="#dsn#">
                                            SELECT * FROM SETUP_COUNTY WHERE COUNTY_ID = #emp_last_work.HOMECOUNTY#
                                            </cfquery>
                                            #get_county.COUNTY_NAME# 
                                            </cfif>
                                            </font><br/>
                                        </td>
                                        <td style="border:none;"><font size="-6"><cf_get_lang dictionary_id="58638.İl">:<cfif len(emp_last_work.HOMECITY)>
                                            <cfquery name="get_city" datasource="#dsn#">
                                            SELECT * FROM SETUP_CITY WHERE CITY_ID = #emp_last_work.HOMECITY#
                                            </cfquery>
                                            #get_city.CITY_NAME#
                                            </cfif>
                                            </font>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td width="2">9</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="30693.Medeni Hali"></td>
                            <td>
                                <cf_get_lang dictionary_id="30501.Evli"><input type="radio"<cfif emp_last_work.married eq 1>checked</cfif>>&nbsp;
                                <cf_get_lang dictionary_id="31205.Bekar"><input type="radio"<cfif emp_last_work.married eq 0>checked</cfif>>&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="3" style="height:5mm;width:20mm"><cf_get_lang dictionary_id="53926.NÜFUSA KAYITLI OLDUĞU YER"></td>
                        </tr>
                        <tr>
                            <td width="2" rowspan="6">10</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="58608.İl"></td>
                            <td>#emp_last_work.CITY#&nbsp;</td>
                        </tr>
                        <tr>
                            <td style="width:20mm"><cf_get_lang dictionary_id="58638.İlçe"></td>
                            <td>#emp_last_work.COUNTY#&nbsp;</td>
                        </tr>
                        <tr>
                            <td style="width:20mm"><cf_get_lang dictionary_id="53928.Mahalle / Köy"></td>
                            <td>#emp_last_work.WARD#/#emp_last_work.VILLAGE#&nbsp;</td>
                        </tr>
                        <tr>
                            <td style="width:20mm"><cf_get_lang dictionary_id="31249.Cilt No"></td>
                            <td>#emp_last_work.BINDING#&nbsp;</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="53916.Görevi"></td>
                            <td style="max-width:20mm; white-space:normal; text-wrap:normal; word-wrap:break-word;">
                                <cfif len(get_in_out.business_code_id)>
                                <cfquery name="get_business_codes" datasource="#DSN#">
                                SELECT BUSINESS_CODE_NAME,BUSINESS_CODE FROM SETUP_BUSINESS_CODES WHERE BUSINESS_CODE_ID = #get_in_out.business_code_id#
                                </cfquery>
                                #get_business_codes.BUSINESS_CODE_NAME#(#get_business_codes.BUSINESS_CODE#)
                                <cfelse>&nbsp;
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:20mm"><cf_get_lang dictionary_id="31251.Aile Sıra No"></td>
                            <td>#emp_last_work.FAMILY#&nbsp;</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="31261.Ev Tel"></td>
                            <td colspan="2">#emp_last_work.hometel_code#&nbsp;#emp_last_work.hometel#</td>
                        </tr>
                        <tr>
                            <td style="width:20mm"><cf_get_lang dictionary_id="31253.Sıra No"></td>
                            <td>#emp_last_work.cue#&nbsp;</td>
                            <td style="width:20mm"><cf_get_lang dictionary_id="30697.Cep Tel"></td>
                            <td colspan="2">#emp_last_work.MOBILCODE_SPC#&nbsp;#emp_last_work.MOBILTEL_SPC#</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        
        <table>
        <tr></tr>
        </table>
        
        <table width="720" cellpadding="0" cellspacing="0" class="tbl_border" >
            <tr align="center">
                <td colspan="6" class="header_">C-<cf_get_lang dictionary_id="53950.SİGORTALININ SOSYAL GÜVENLİK BİLGİLERİ"></td>
            </tr>
            <tr>
                <td width="2">15</td>
                <td style="height:3mm;width:1.5mm"><cf_get_lang dictionary_id="46187.Sigortalılık Türü/Kodu"></td>
                <td>
                    4(a)<cf_get_lang dictionary_id="46185.Hizmet Akdine Tabi Çalışan">  <input type="text" name="sosyal_prim" id="sosyal_prim" style="width:10mm;" <cfif isDefined("attributes.sosyal_prim") and attributes.sosyal_prim eq 1>checked</cfif>><br/>
                    4(b)<cf_get_lang dictionary_id="46177.Muhtar İle Hizmet Akdine Bağlı Olmaksızın Kendi Adına ve Hesabına Bağımsız Çalışan">  <input type="text" name="sosyal_prim" id="sosyal_prim" style="width:10mm;" <cfif isDefined("attributes.sosyal_prim") and attributes.sosyal_prim eq 2>checked</cfif>>
                </td>
                <td width="2">16</td>
                <td><cf_get_lang dictionary_id="46176.Sigortalı İş Kanununun 30 ncu Maddesine Göre Çalışıyorsa"></td>
                <td>
                    <input type="checkbox" <cfif emp_last_work.SENTENCED EQ 1>CHECKED</cfif>> 
                    <cf_get_lang dictionary_id="52154.Eski"> &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id="53656.Hükümlü"> </br>
                    <input type="checkbox" <cfif emp_last_work.DEFECTED EQ 1>CHECKED</cfif>>
                    <cf_get_lang dictionary_id="31232.Özürlü"> </br>
                    <input type="checkbox" <cfif emp_last_work.terror_wronged EQ 1>CHECKED</cfif>>
                    <cf_get_lang dictionary_id="40524.Terör Mağduru"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </td>
            </tr>
            <tr>
                <td width="2">17</td>
                <td colspan="8" class="txtbold">        
                    <table width="100%" cellpadding="0" cellspacing="0" align="center" class="tbl_border">
                        <tr>
                            <td rowspan="2"><cf_get_lang dictionary_id="46170.01.01.2008 Tarihinden Önce Çalışmış İse"></td>
                            <td><font size="-6"><cf_get_lang dictionary_id="57712.Kurum"></font> </td>
                            <td><font size="-6"><cf_get_lang dictionary_id="58714.SGK"></font> </td>
                            <td><font size="-6"><cf_get_lang dictionary_id="56424.Bağkur"></font> </td>
                            <td><font size="-6"><cf_get_lang dictionary_id="56422.Emekli sandığı"></font> </td>
                            <td><font size="-6">506-G 20.mad.san.</font> </td>
                        </tr>
                        <tr>
                            <td><font size="-6"><cf_get_lang dictionary_id="32328.Sicil No"></font> </td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="height:6mm;">
                <td width="2">18</td>
                <td colspan="2"><cf_get_lang dictionary_id="46305.Yaşlılık Aylığı Alıyorsa Devam Etmek İstediği Sigorta Kolu"></td>
                <td colspan="2"><cf_get_lang dictionary_id="41947.Sosyal Güvenlik Destek Primi"> <input type="radio" name="sosyal_prim" id="sosyal_prim" value="1" <cfif isDefined("attributes.sosyal_prim") and attributes.sosyal_prim eq 1>checked</cfif>></td>
                <td colspan="2"><cf_get_lang dictionary_id="41957.Tüm Sigorta Kolları"> <input type="radio" name="sosyal_prim" id="sosyal_prim" value="2" <cfif isDefined("attributes.sosyal_prim") and attributes.sosyal_prim eq 2>checked</cfif>></td>
            </tr>
            <tr>
                <td width="2">19</td>
                <td  colspan="9" class="txtbold">        
                    <table width="100%" cellpadding="0" cellspacing="0" align="center" class="tbl_border" >
                        <tr>
                            <td rowspan="2">4 - <cf_get_lang dictionary_id="46398.1/b Kapsamında Sigortalının"></td>
                            <td><font size="-6"><cf_get_lang dictionary_id="30495.Meslek"></font> </td>
                            <td><font size="-6"><cf_get_lang dictionary_id="46397.Meslek İli"></font></td>
                            <td><font size="-6"><cf_get_lang dictionary_id="46395.Meslek İlçesi"></font></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="height:6mm;">
                <td width="2">20</td>
                <td nowrap><cf_get_lang dictionary_id="46388.Sigortalının İşe Başladığı Tarih"></td>
                <td colspan="7">&nbsp;#dateformat(get_in_out.start_date,dateformat_style)#</td>
            </tr>
        </table>
        
        <table>
        <tr></tr>
        </table>
        
        <table width="720" class="tbl_border" cellspacing="0" cellpadding="0">
            <tr>
                <td colspan="4" class="header_">D.<cf_get_lang dictionary_id="53908.BEYAN VE TAAHHÜTLER"></td>         
            </tr>
            <tr>
                <td width="2">21</td>
                <td style="width:50mm;" nowrap>
                <font size="-6"><cf_get_lang dictionary_id="46387.Yukarıda yazılı hususların gerçeğe uygun olduğunu ve olabilecek değişiklikleri derhal kuruma ve işverene bildireceğimi beyan ederim."></font></br>
                    <span class="txtbold"><cf_get_lang dictionary_id="57742.Tarih">: #dateformat(now(),dateformat_style)#</span>
                </td>
                <td align="center" valign="top" colspan="2">
                <font size="-6"><cf_get_lang dictionary_id="31517.Sigortalının"> <cf_get_lang dictionary_id="53962.Adı-Soyadı ve İmzası">:#emp_last_work.employee_name# #emp_last_work.employee_surname#<br/></font><br/>
                </td>
            </tr>
            <tr>
                <td width="2">22</td>
                <td style="border:none;">
                    <table width="20%" class="tbl_border" cellspacing="0" cellpadding="0">
                        <tr align="center">
                            <td colspan="26" class="txtbold"><cf_get_lang dictionary_id="44617.İŞYERİ SİCİL NUMARASI"></td>
                        </tr>
                        <tr>
                            <td rowspan="2"><font size="-6">M</font></td>
                            <td colspan="4" rowspan="2" align="center"><font size="-6"><cf_get_lang dictionary_id="46374.İŞ KOLU KODU"></font></td>
                            <td colspan="4" align="center"><font size="-6"><cf_get_lang dictionary_id="39974.ÜNİTE KODU"></font></td>
                            <td colspan="7" rowspan="2" align="center"><font size="-6"><cf_get_lang dictionary_id="53826.İŞYERİ SIRA NUMARASI"></font></td>
                            <td colspan="3" rowspan="2" align="center"><font size="-6"><cf_get_lang dictionary_id="39976.İL KODU"></font></td>
                            <td colspan="2" rowspan="2" align="center"><font size="-6"><cf_get_lang dictionary_id="39977.İLÇE KODU"></font></td>
                            <td colspan="2" rowspan="2" align="center"><font size="-6"><cf_get_lang dictionary_id="40010.KONTROL NUMARASI"></font></td>
                            <td colspan="3" rowspan="2" align="center"><font size="-6"><cf_get_lang dictionary_id="39979.ARACI KODU"></font></td>
                        </tr>
                        <tr> 
                            <td colspan="2"><cf_get_lang dictionary_id="58674.YENİ"></td>
                            <td colspan="2"><cf_get_lang dictionary_id="53832.ESKİ"></td>
                        </tr>
                        <tr>
                            <td>&nbsp;#get_in_out.ssk_m#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_JOB,1,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_JOB,2,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_JOB,3,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_JOB,4,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_BRANCH,1,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_BRANCH,2,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_BRANCH_OLD,1,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_BRANCH_OLD,2,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_NO,1,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_NO,2,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_NO,3,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_NO,4,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_NO,5,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_NO,6,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_NO,7,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_CITY,1,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_CITY,2,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_CITY,3,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_COUNTRY,1,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_COUNTRY,2,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_CD,1,1)#</td>
                            <td>&nbsp;#mid(get_in_out.SSK_CD,2,1)#</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
                <td width="2">23</td>
                <td >
                    <table class="tbl_border">
                        <tr>
                            <td colspan="9" class="txtbold" align="center"><font size="-6"><cf_get_lang dictionary_id="46373.İLGİLİ KURUM/KURULUŞ/VERGİ DAİRESİ/ODA/TİCARET-ESNAF SİCİL NUMARASI"></font></td>
                        </tr>
                        <tr>
                            <cfif len(get_in_out.SOCIALSECURITY_NO)>
                            <cfset kalan = 15 - len(get_in_out.SOCIALSECURITY_NO)>
                            <cfloop from="1" to="#len(get_in_out.SOCIALSECURITY_NO)#" index="i">
                                <td width="20" align="center">#mid(get_in_out.SOCIALSECURITY_NO,i,1)#</td>
                            </cfloop>
                            <cfelse>
                                <td width="20" align="center" colspan="15">&nbsp;</td>
                            </cfif>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td width="2">24</td>
                <td colspan="3">
                    <table>
                        <tr>
                            <td style="border:none;" align="left"><font size="-6">
                            <br/><cf_get_lang dictionary_id="46391.İşverenin/İşyerinin/İlgili Kuruluşun Adı-Soyadı/Ünv."></font><br/>
                            #get_in_out.COMPANY_NAME#<br/>
                            </td>
                            <td style="border:none;text-align:right;" width="50%"> 
                            <font size="-6"><cf_get_lang dictionary_id="46365.İşverenin/İşyerinin/İlgili Kuruluşun Adresi"></font><br/><br/>
                            #get_in_out.BRANCH_ADDRESS# #get_in_out.BRANCH_POSTCODE# #get_in_out.BRANCH_COUNTY#<br/>
                            #get_in_out.BRANCH_CITY# - #get_in_out.BRANCH_COUNTRY#
                            </td>
                        </tr>
                        <tr>
                            <td style="border:none;" colspan="2" height="25">
                                <font size="-6"><cf_get_lang dictionary_id="46362.Yukarıda yazılı hususların sigortalının nüfus cüzdanındaki beyan ettiği resmi belgelerdeki kayıtlara uygun bulunduğunu ve doğru olduğunu beyan ederim."></font>
                            </td>
                        </tr>
                        <tr>
                            <td style="border:none;" height="15" colspan="2"></td>
                        </tr>
                        <tr>
                            <td style="border:none;" align="center" colspan="2" height="25">
                                <font size="-6"><cf_get_lang dictionary_id="46357.Onaylayan Yetkilinin"><br/>
                                <cf_get_lang dictionary_id="46355.Adı Soyadı,İmzası Mühür veya Kaşesi"></font>
                            </td>
                        </tr>
                        <tr>
                            <td style="border:none;" align="center" colspan="2" height="25"></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </td>
</tr>
</table>
</div>
</form>
</cf_box>
</cfoutput>
