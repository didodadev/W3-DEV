    <cfif isDefined("URL.DOC_ID") and len(URL.DOC_ID)>
       <cfquery name="GET_DOC" datasource="#DSN#">
            SELECT 
                *
            FROM 
                EMPLOYEES_RELATIVE_HEALTY 
            WHERE 
                DOC_ID = #URL.DOC_ID#
       </cfquery>
    </cfif>
    
    <!--- queryler --->
    <cfquery name="DETAIL" datasource="#dsn#">
        SELECT 
            BRANCH_ID,
            START_DATE,
            FINISH_DATE,
            SOCIALSECURITY_NO
        FROM
            EMPLOYEES_IN_OUT
        WHERE 
            EMPLOYEES_IN_OUT.IN_OUT_ID = #GET_DOC.in_out_id#
    </cfquery>
    <cfif NOT DETAIL.RECORDCOUNT>
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='54638.Çalışan Kaydı Bulunamadı'>!");
            window.close();
        </script>
        <cfabort>
    </cfif>
    
    <cfif len(GET_DOC.branch_id)>
        <cfset my_branch_id = GET_DOC.BRANCH_ID>
    <cfelse>
        <cfset my_branch_id = DETAIL.BRANCH_ID>
    </cfif>
    
    <cfquery name="SSK" datasource="#dsn#">
        SELECT 
            BRANCH.SSK_NO,
            BRANCH.SSK_M,
            BRANCH.SSK_JOB,
            BRANCH.SSK_BRANCH,   
            BRANCH.BRANCH_FULLNAME,
            BRANCH.SSK_CITY,
            BRANCH.SSK_CD,
            BRANCH.SSK_COUNTRY,
            BRANCH.SSK_BRANCH_OLD,
            BRANCH.SSK_OFFICE,
            BRANCH.BRANCH_ADDRESS,
            BRANCH.BRANCH_POSTCODE,
            BRANCH.BRANCH_COUNTY,
            BRANCH.BRANCH_CITY,
            OUR_COMPANY.COMPANY_NAME,
            OUR_COMPANY.ADDRESS,
            OUR_COMPANY.MANAGER
        FROM 
            BRANCH,
            OUR_COMPANY
        WHERE 
            BRANCH.BRANCH_ID = #my_branch_id# AND 
            OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
    </cfquery>
    
    <cfquery name="get_emp_puantajs" datasource="#dsn#" maxrows="12">
        SELECT
            EMPLOYEES_PUANTAJ.SAL_MON,
            EMPLOYEES_PUANTAJ.SAL_YEAR,
            EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS,
            EMPLOYEES_PUANTAJ.SSK_OFFICE,
            EMPLOYEES_PUANTAJ.SSK_OFFICE_NO
        FROM
            EMPLOYEES_PUANTAJ,
            EMPLOYEES_PUANTAJ_ROWS,
            BRANCH
        WHERE
            EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
            AND EMPLOYEES_PUANTAJ.SSK_OFFICE = BRANCH.SSK_OFFICE
            AND EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = BRANCH.SSK_NO
            AND BRANCH.BRANCH_ID = #my_branch_id#
            AND EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
            AND
            (
                (
                    EMPLOYEES_PUANTAJ.SAL_YEAR = #dateformat(GET_DOC.arrangement_date,'yyyy')#
                    AND EMPLOYEES_PUANTAJ.SAL_MON < #dateformat(GET_DOC.arrangement_date,'MM')#
                )
                OR
                (			
                    EMPLOYEES_PUANTAJ.SAL_YEAR < #dateformat(GET_DOC.arrangement_date,'yyyy')#
                )
            )
        <cfif not session.ep.ehesap>
            AND 
            BRANCH.BRANCH_ID IN (
                                SELECT
                                    BRANCH_ID
                                FROM
                                    EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                    EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
                                )
        </cfif>
        ORDER BY
            EMPLOYEES_PUANTAJ.SAL_YEAR DESC,
            EMPLOYEES_PUANTAJ.SAL_MON DESC
    </cfquery>
    
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
            EI.FATHER,
            EI.BIRTH_DATE,
            EI.BIRTH_PLACE,
            EI.NATIONALITY,
            EI.TC_IDENTY_NO
        FROM
            EMPLOYEES E,
            EMPLOYEES_DETAIL ED,
            EMPLOYEES_IDENTY EI
        WHERE
            E.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
            AND ED.EMPLOYEE_ID = E.EMPLOYEE_ID
            AND EI.EMPLOYEE_ID = E.EMPLOYEE_ID
    </cfquery>
    <cfif len(get_emp_detail.HOMECITY)>
        <cfquery name="get_city_name" datasource="#dsn#">
            SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID=#get_emp_detail.HOMECITY#
        </cfquery>
    </cfif>
    <cfif len(get_emp_detail.HOMECOUNTY)>
        <cfquery name="get_county_name" datasource="#dsn#">
            SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID=#get_emp_detail.HOMECOUNTY#
        </cfquery>
    </cfif>
    <cfif len(GET_EMP_DETAIL.NATIONALITY)>
        <cfquery name="get_country" datasource="#dsn#">
            SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #GET_EMP_DETAIL.NATIONALITY#
        </cfquery>
    </cfif>
<div style="page-break-after:always!important">
    <table align="center" style="width:190mm;" cellpadding="0" cellspacing="0">
    <tr>
    <td>
    <table width="99%">
      <tr>
        <td align="center" class="printbold">
            <span class="formbold"><img src="/images/ssk.gif"><br/>
            <cf_get_lang dictionary_id="30489.SOSYAL GÜVENLİK KURUMU"> <cf_get_lang dictionary_id="53100.SAĞLIK BELGESİ"></span><br/>
            (<cf_get_lang dictionary_id="59467.Sigortalının Eşi ve Geçindirmekle Yükümlü Olduğu Çocuklar İle Ana ve Babasına Ait">)
        </td>
        </tr>
    </table>
    <table width="99%">
      <tr>
        <td></td>
        <td class="txtbold" width="175"><cf_get_lang dictionary_id="45418.Belgenin Düzenlendiği Tarih">:</td>
        <td width="100"><cfoutput>#dateformat(GET_DOC.arrangement_date,dateformat_style)#</cfoutput></td>
      </tr>
      <tr>
          <td></td>
        <td class="txtbold"><cf_get_lang dictionary_id="59468.Belgenin Son Geçerlilik Tarihi">:</td>
        <td>
        <cfif len(DETAIL.FINISH_DATE)>
            <cfset finishdate_ = date_add("m", 6, DETAIL.FINISH_DATE)>
        <cfelseif len(GET_DOC.arrangement_date)>
            <cfset finishdate_ = date_add("m", 6, GET_DOC.arrangement_date)>
        <cfelse>
            <cfset finishdate_ = date_add("m", 6,now())>
        </cfif>
        <cfoutput>#dateformat(finishdate_,dateformat_style)#</cfoutput>
        </td>
      </tr>
    </table>
    
    <!--- çalışan bilgileri --->
    <CFOUTPUT>
    <table width="99%" border="1" cellspacing="0" cellpadding="0">
      <tr align="center">
        <td colspan="4" class="formbold">A-<cf_get_lang dictionary_id="53464.SİGORTALININ"></td>
      </tr>
      <tr>
        <td width="15" class="txtbold">1</td>
        <td width="175" class="txtbold"><cf_get_lang dictionary_id="58025.TC Kimlik No"></td>
        <td width="220">#get_emp_detail.TC_IDENTY_NO#</td>
        <td class="txtbold"><cf_get_lang dictionary_id="53931.İkametgah Adresi"></td>
      </tr>
      <tr>
        <td class="txtbold">2</td>
        <td class="txtbold"><cf_get_lang dictionary_id="53903.Sigorta Sicil No"></td>
        <td>#DETAIL.SOCIALSECURITY_NO#</td>
        <td rowspan="3" valign="top">#get_emp_detail.HOMEADDRESS#<cfif len(#get_emp_detail.HOMECOUNTY#)>&nbsp;#get_county_name.COUNTY_NAME#</cfif> <cfif len(get_emp_detail.HOMECITY)>&nbsp;#get_city_name.CITY_NAME#</cfif>&nbsp;</td>
      </tr>
      <tr>
        <td class="txtbold">3</td>
        <td class="txtbold"><cf_get_lang dictionary_id="32370.Adı ve Soyadı"></td>
        <td>#get_emp_detail.employee_name# #get_emp_detail.employee_surname#</td>
        </tr>
      <tr>
        <td class="txtbold">4</td>
        <td class="txtbold"><cf_get_lang dictionary_id="58033.Baba Adı"></td>
        <td>#get_emp_detail.father#</td>
        </tr>
      <tr>
        <td class="txtbold">5</td>
        <td class="txtbold"><cf_get_lang dictionary_id="32872.Cinsiyeti"></td>
        <td>
            <cfif get_emp_detail.SEX eq 1><cf_get_lang dictionary_id="58959.Erkek"><cfelse><cf_get_lang dictionary_id="58958.Kadın"></cfif>	</td>
        <td class="txtbold"><cf_get_lang dictionary_id="57472.Posta Kodu">: #get_emp_detail.HOMEPOSTCODE#</td>
      </tr>
      <tr>
        <td class="txtbold">6</td>
        <td class="txtbold"><cf_get_lang dictionary_id="53934.Uyruğu"> (<cf_get_lang dictionary_id="53936.Yabancı İse Ülke Adı">)</td>
        <td><cfif len(GET_EMP_DETAIL.NATIONALITY)>#get_country.COUNTRY_NAME#</cfif></td>
        <td class="txtbold">
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="50%" class="txtbold"><cf_get_lang dictionary_id="31261.Ev Tel">: #get_emp_detail.HOMETEL_CODE# #get_emp_detail.HOMETEL#</td>
                    <td width="50%" class="txtbold"><cf_get_lang dictionary_id="30697.Cep Tel">: #get_emp_detail.MOBILCODE# #get_emp_detail.MOBILTEL#</td>
                </tr>
            </table>
    </td>
      </tr>
      <tr>
        <td class="txtbold">7</td>
        <td class="txtbold"><cf_get_lang dictionary_id="57790.Doğum Yeri"> / <cf_get_lang dictionary_id="58727.Doğum Tarihi"> </td>
        <td colspan="2">#dateformat(get_emp_detail.BIRTH_DATE,dateformat_style)# / #get_emp_detail.BIRTH_PLACE#</td>
      </tr>
      <tr>
        <td class="txtbold">8</td>
        <td class="txtbold"><cf_get_lang dictionary_id="53348.İşe Giriş Tarihi"></td>
        <td>#dateformat(detail.START_DATE,dateformat_style)#&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
    </table>
    </CFOUTPUT>
    <!--- çalışan bilgileri --->
    <br/>
    <!--- yakın bilgileri --->
    <cfoutput>
    <table width="99%" border="1" cellspacing="0" cellpadding="0">
              <tr align="center">
                <td colspan="4" class="formbold">B-<cf_get_lang dictionary_id="59428.HASTANIN"></td>
              </tr>
              <tr>
                <td width="15" class="txtbold">9</td>
                <td width="175" class="txtbold"><cf_get_lang dictionary_id="59429.Sigortalıya Yakınlığı"></td>
                <td width="220">#GET_DOC.ILL_RELATIVE#</td>
                <td class="txtbold"><cf_get_lang dictionary_id="49318.Adresi"></td>
              </tr>
              <tr>
                <td class="txtbold">10</td>
                <td class="txtbold"><cf_get_lang dictionary_id="58025.TC Kimlik No"></td>
                <td>#GET_DOC.TC_IDENTY_NO#</td>
                <td rowspan="2" valign="top">
                    #get_emp_detail.HOMEADDRESS# <cfif len(#get_emp_detail.HOMECOUNTY#)>&nbsp;#get_county_name.COUNTY_NAME#</cfif> <cfif len(get_emp_detail.HOMECITY)>&nbsp;#get_city_name.CITY_NAME#</cfif>&nbsp;
                </td>
              </tr>
              <tr>
                <td class="txtbold">11</td>
                <td class="txtbold"><cf_get_lang dictionary_id="32370.Adı Soyadı"></td>
                <td>#GET_DOC.ill_name# #GET_DOC.ill_surname#&nbsp;</td>
              </tr>
              <tr>
                <td class="txtbold">12</td>
                <td class="txtbold"><cf_get_lang dictionary_id="32872.Cinsiyeti"></td>
                <td><cfif get_doc.ill_SEX eq 1><cf_get_lang dictionary_id="58959.Erkek"><cfelse><cf_get_lang dictionary_id="58958.Kadın"></cfif></td>
                <td class="txtbold"><cf_get_lang dictionary_id="57472.Posta Kodu"> : #get_emp_detail.HOMEPOSTCODE#</td>
              </tr>
              <tr>
                <td class="txtbold">13</td>
                <td class="txtbold"><cf_get_lang dictionary_id="56135.Uyruğu"> (<cf_get_lang dictionary_id="53936.Yabancı İse Ülke Adı">)</td>
                <td><cfif len(GET_EMP_DETAIL.NATIONALITY)>#get_country.COUNTRY_NAME#</cfif>&nbsp;</td>
                <td class="txtbold">
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="50%" class="txtbold"><cf_get_lang dictionary_id="31261.Ev Tel">:#get_emp_detail.HOMETEL_CODE# #get_emp_detail.HOMETEL#</td>
                            <td width="50%" class="txtbold"><cf_get_lang dictionary_id="30697.Cep Tel">: </td>
                        </tr>
                    </table>
                </td>			
                <!--- BK eski hali 120 gune siline 20080502
                <td class="txtbold">
                    Ev Tel: #get_emp_detail.HOMETEL_CODE# #get_emp_detail.HOMETEL#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    Cep Tel:
                </td> --->
              </tr>
              <tr>
                <td class="txtbold">14</td>
                <td class="txtbold"><cf_get_lang dictionary_id="57790.Doğum Yeri"> / <cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
                <td colspan="2">#GET_DOC.ILL_BIRTHPLACE# - #dateformat(GET_DOC.ILL_BIRTHDATE,dateformat_style)# &nbsp;</td>
              </tr>
            </table>
    </cfoutput>		
    <!--- yakın bilgileri --->
    <br/>
    <!--- sigorta prim durumları --->
        <table width="99%" border="1" cellspacing="0" cellpadding="0">
              <tr>
                <td width="15" class="txtbold">15</td>
                <td class="txtbold"><cf_get_lang dictionary_id="59430.Prim Ödeme Halinin Sona Erip Ermediğini 'Sona Erdi' veya 'Sona Ermedi' Şeklinde ve El Yazınız İle Yandaki Haneye Yazınız."></td>
                <td width="200" class="txtbold">
                <cf_get_lang dictionary_id="45527.Sona Erdi İse Erdiği Tarih">;<br/>
                <cfif len(DETAIL.finish_date)>
                    <cfoutput>#dateformat(DETAIL.finish_date,dateformat_style)#</cfoutput>
                </cfif>
                </td>
              </tr>
        </table>
        <br/>
        <table width="99%" border="1" cellspacing="0" cellpadding="0">
              <tr align="center">
                <td colspan="4" class="formbold">C-<cf_get_lang dictionary_id="59406.SİGORTALININ PRİM ÖDEME GÜN SAYISI"></td>
                </tr>
              <tr class="txtbold">
                <td width="15" align="center"><cf_get_lang dictionary_id="58577.Sıra"></td>
                <td width="200" align="center"><cf_get_lang dictionary_id="58455.Yıl"></td>
                <td width="200" align="center"><cf_get_lang dictionary_id="58724.Ay"></td>
                <td align="center"><cf_get_lang dictionary_id="53856.Prim Ödeme Gün Sayısı"></td>
              </tr>
          <cfset i=0>
          <cfoutput query="get_emp_puantajs">
            <cfset i=i+1>
              <tr>
                <td align="center">#i#</td>
                <td align="center">#SAL_YEAR#</td>
                <td align="center">#Listgetat(ay_list(),sal_mon)#</td>
                <td align="center">#total_days#</td>
              </tr>
          </cfoutput>
          <cfloop from="#i+1#" to="12" index="i">
              <tr>
                <td align="center"><cfoutput>#i#</cfoutput></td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
              </tr>
          </cfloop>
            </table>
    <!--- sigorta prim durumları --->
    <br/>
    <!--- işveren bilgileri --->
    <cfoutput>
                <table width="99%" border="1" cellspacing="0" cellpadding="0">
                     <tr>
                 <td align="center" class="FORMBOLD" colspan="2"><cf_get_lang dictionary_id="53908.BEYAN VE TAAHHÜTLER"></td>
             </tr>
                  <tr>
                    <td class="txtbold" valign="top"><cf_get_lang dictionary_id="53833.İşverenin"> <cf_get_lang dictionary_id="59416.Adı Soyadı / Ünvan"><br/><br/>
                    #ssk.company_name#
                    </td>
                    <td width="500" align="center">	
                    <br/>
                            <table width="98%" border="1" cellspacing="0" cellpadding="0">
                            <tr align="center">
                              <td colspan="26"><cf_get_lang dictionary_id="53823.İŞYERİ SİCİL NO"></td>
                              </tr>
                            <tr class="printbold">
                              <td rowspan="2">M</td>
                              <td colspan="4" align="center"><cf_get_lang dictionary_id="46374.İŞ KOLU KODU"></td>
                              <td colspan="4" align="center" rowspan="2"><cf_get_lang dictionary_id="53825.ÜNİTE KODU"></td>
                              <td colspan="7" rowspan="2" align="center"><cf_get_lang dictionary_id="53826.İŞYERİ SIRA NUMARASI"></td>
                              <td colspan="3" rowspan="2" align="center"><cf_get_lang dictionary_id="53827.İL KODU"></td>
                              <td colspan="2" rowspan="2" align="center"><cf_get_lang dictionary_id="53828.İLÇE KODU"></td>
                              <td colspan="2" rowspan="2" align="center"><cf_get_lang dictionary_id="53829.KONTROL NUMARASI"></td>
                              <td colspan="3" rowspan="2" align="center"><cf_get_lang dictionary_id="53830.ARACI KODU"></td>
                              </tr>
                            <tr>
                              <td colspan="2"><cf_get_lang dictionary_id="58674.YENİ"></td>
                              <td colspan="2"><cf_get_lang dictionary_id="52154.ESKİ"></td>
                              </tr>
                            <tr>
                              <td>&nbsp;#ssk.ssk_m#</td>
                              <td>&nbsp;#mid(ssk.SSK_JOB,1,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_JOB,2,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_JOB,3,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_JOB,4,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_BRANCH,1,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_BRANCH,2,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_BRANCH_OLD,1,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_BRANCH_OLD,2,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_NO,1,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_NO,2,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_NO,3,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_NO,4,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_NO,5,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_NO,6,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_NO,7,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_CITY,1,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_CITY,2,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_CITY,3,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_COUNTRY,1,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_COUNTRY,2,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_CD,1,1)#</td>
                              <td>&nbsp;#mid(ssk.SSK_CD,2,1)#</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                          <br/>
                  </td>            
                </tr>
                 <tr>	
                      <td width="200" height="60" valign="top"><strong><cf_get_lang dictionary_id="59431.İşyeri Adresi"></strong><br/>#ssk.BRANCH_ADDRESS#</td>
                      <td>
                      <table width="99%" height="99%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>
                          <table border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="30" class="txtbold"><cf_get_lang dictionary_id="58132.Semt"></td>
                              <td width="100">&nbsp;</td>
                              <td width="30" class="txtbold"><cf_get_lang dictionary_id="58638.İlçe"></td>
                              <td width="100">&nbsp;#ssk.BRANCH_COUNTY#</td>
                              <td width="30" class="txtbold"><cf_get_lang dictionary_id="57971.Şehir"></td>
                              <td width="100">&nbsp;#ssk.BRANCH_CITY#</td>
                              <td width="65" class="txtbold"><cf_get_lang dictionary_id="57472.Posta Kodu"></td>
                              <td>&nbsp;#ssk.BRANCH_POSTCODE#</td>
                            </tr>
                          </table>					  
                          </td>
                         </tr>
                      </table>
                      </td>
                    </tr>	
            </table>
            <br/>
            <table width="99%" border="1" cellspacing="0" cellpadding="0" height="75">
                         <tr>
                      <td valign="top"><cf_get_lang dictionary_id="59432.Yukarıda ki bilgilerin yanlış olması sebebiyle sigortalının eşi ve geçindirmekle yükümlü olduğu çocukları ile ana ve babasına  Kurumca yersiz olarak yapılan her türlü masrafları ödemeyi kabul ederim"><br/>
                        <cf_get_lang dictionary_id="57742.Tarih">:</td>
                      <td align="center" valign="bottom"><cf_get_lang dictionary_id="59409.İşverenin veya Vekilinin Adı-Soyadı İmzası, Mühür veya Kaşesi"></td>
                    </tr>			
                  </table>
    </cfoutput>
    <!--- işveren bilgileri --->
    </td>
    </tr>
    </table>
</div>
