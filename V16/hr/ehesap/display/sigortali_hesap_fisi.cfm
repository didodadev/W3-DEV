<cfinclude template="../query/get_emp_identy.cfm">
<cfinclude template="../query/get_hr.cfm">
<cfinclude template="../query/get_position.cfm">
<cfinclude template="../query/get_hr_detail.cfm">

<cfif not GET_POSITION.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='59403.Çalışanı Öncelikle Bir Pozisyona Atamalısınız'>");
		window.close();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_BRANCH_INFO" datasource="#dsn#">
	SELECT 
		BRANCH.*
	FROM 
		BRANCH,
		DEPARTMENT
	WHERE
		DEPARTMENT.DEPARTMENT_ID = #GET_POSITION.DEPARTMENT_ID#
		AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
</cfquery>
<cfquery name="GET_COMPANY_INFO" datasource="#dsn#">
	SELECT 
		COMPANY_NAME,
		NICK_NAME
	FROM 
		OUR_COMPANY
	WHERE
		COMP_ID = #GET_BRANCH_INFO.COMPANY_ID#
</cfquery>

<cfquery name="get_in_out" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		EMPLOYEES_IN_OUT 
	WHERE 
		EMPLOYEE_ID = #GET_POSITION.EMPLOYEE_ID# 
	ORDER BY 
		IN_OUT_ID DESC
</cfquery>
	<cfquery name="emp_last_work" datasource="#dsn#">
	SELECT
		EXP3_START,
		EXP3_FINISH,
		EXP3,
		EXP3_POSITION
	FROM
		EMPLOYEES_DETAIL
	WHERE
		EMPLOYEE_ID = #GET_POSITION.EMPLOYEE_ID#	
	</cfquery>

<cfif not isDefined("attributes.EMEKLI")>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-row">
          <td  style="text-align:right;">
            <a href="##" onClick="document.all.send.submit();"><img src="/images/print.gif" title="<cf_get_lang dictionary_id='29740.Yazıcıya Gönder'>" border="0"></a>
			<a href="javascript://" onClick="window.close();"><img src="/images/close.gif" title="<cf_get_lang dictionary_id='57553.Kapat'>" border="0"></a>
		   </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<cfelse>
	<script type="text/javascript">
	function waitfor(){
	window.close();
	}	
	setTimeout("waitfor()",3000);
	window.print();
	</script>
</cfif>
<cfoutput>
  <table width="655" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td align="center"><cf_get_lang dictionary_id="53821.SOSYAL SİGORTALAR KURUMU"><br/>
      <cf_get_lang dictionary_id="59404.SİGORTALI HESAP FİŞİ"></td>
    </tr>
    <tr>
      <td><table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr align="center">
          <td colspan="5">A-<cf_get_lang dictionary_id="31517.SİGORTALININ"></td>
          </tr>
        <tr>
          <td width="20">1</td>
          <td width="180"><cf_get_lang dictionary_id="55649.TC. Kimlik No"></td>
          <td width="200">&nbsp;</td>
          <td width="95" rowspan="4" valign="top"><cf_get_lang dictionary_id="38974.İkametgah Adresi"></td>
          <td rowspan="4">&nbsp;</td>
        </tr>
        <tr>
          <td>2</td>
          <td><cf_get_lang dictionary_id="53903.Sigorta Sicil No"></td>
          <td>&nbsp;</td>
          </tr>
        <tr>
          <td>3</td>
          <td><cf_get_lang dictionary_id="32370.Adı Soyadı"></td>
          <td>&nbsp;</td>
          </tr>
        <tr>
          <td>4</td>
          <td><cf_get_lang dictionary_id="58033.Baba Adı"></td>
          <td>&nbsp;</td>
          </tr>
        <tr>
          <td>5</td>
          <td><cf_get_lang dictionary_id="32872.Cinsiyeti"></td>
          <td>&nbsp;</td>
          <td><cf_get_lang dictionary_id="57472.Posta Kodu"></td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>6</td>
          <td><cf_get_lang dictionary_id="45494.Uyruğu(Yabancı ise ülke adı)"></td>
          <td>&nbsp;</td>
          <td><cf_get_lang dictionary_id="31261.Ev Tel"></td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>7</td>
          <td><cf_get_lang dictionary_id="57790.Doğum Yeri"> / <cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
          <td>&nbsp;</td>
          <td><cf_get_lang dictionary_id="30697.Cep Tel"></td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>8</td>
          <td><cf_get_lang dictionary_id="38923.İşe Giriş Tarihi"></td>
          <td colspan="3">&nbsp;</td>
          </tr>
        <tr>
          <td>9</td>
          <td><cf_get_lang dictionary_id="59405.İşyerinden Ayrılış Tarihi"></td>
          <td colspan="3">&nbsp;</td>
          </tr>
      </table></td>
    </tr>
    <tr>
      <td height="3"></td>
    </tr>
    <tr>
      <td><table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr align="center">
          <td colspan="5">B-<cf_get_lang dictionary_id="59406.SİGORTALININ PRİM ÖDEME GÜN SAYISI"></td>
          </tr>
        <tr align="center">
          <td width="65"><cf_get_lang dictionary_id="58455.Yıl"></td>
          <td width="65"><cf_get_lang dictionary_id="58724.Ay"></td>
          <td width="80"><cf_get_lang dictionary_id="53856.Prim Ödeme Gün Sayısı"></td>
          <td><cf_get_lang dictionary_id="46570.Prime Esas Kazanç Tutarı"></td>
          <td width="200"><cf_get_lang dictionary_id="46408.Açıklamalar"></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2"><cf_get_lang dictionary_id="57492.Toplam"></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td height="3">&nbsp;</td>
    </tr>
    <tr>
      <td><table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr align="center">
          <td colspan="5">C-<cf_get_lang dictionary_id="59407.AYRILIŞINDA SİGORTALIYA VERİLEN (İhbar, İstihkak, Ücret, İzin)"></td>
          </tr>
        <tr>
          <td width="60"><cf_get_lang dictionary_id="30057.Ödeme Şekli"></td>
          <td width="75"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></td>
          <td width="75"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></td>
          <td><cf_get_lang dictionary_id="57673.Tutar"></td>
          <td width="200"><cf_get_lang dictionary_id="46408.Açıklamalar"></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td height="3"></td>
    </tr>
    <tr>
      <td><table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center">D-<cf_get_lang dictionary_id="53908.BEYAN VE TAAHHÜTLER"></td>
        </tr>
        <tr>
          <td><table width="100%" border="1" cellspacing="0" cellpadding="0">
            <tr>
              <td>İyerinin Adı Soyadı / Ünvanı</td>
              <td rowspan="2" align="center"><table width="98%" border="1" cellspacing="0" cellpadding="0">
                <tr align="center">
                  <td colspan="26"><cf_get_lang dictionary_id="44617.İŞYERİ SİCİL NO"></td>
                  </tr>
                <tr>
                  <td width="3%" rowspan="2" align="center">M</td>
                  <td colspan="4" rowspan="2" align="center"><cf_get_lang dictionary_id="46374.İş Kolu Kodu"></td>
                  <td colspan="4" align="center"><cf_get_lang dictionary_id="39974.Ünite Kodu"></td>
                  <td colspan="7" rowspan="2" align="center"><cf_get_lang dictionary_id="53826.İşyeri Sıra Numarası"></td>
                  <td colspan="3" rowspan="2" align="center"><cf_get_lang dictionary_id="39976.İl Kodu"></td>
                  <td colspan="2" rowspan="2" align="center"><cf_get_lang dictionary_id="53828.İlçe Kodu"></td>
                  <td colspan="2" rowspan="2" align="center"><cf_get_lang dictionary_id="40010.Kontrol Numarası"></td>
                  <td colspan="3" rowspan="2" align="center"><cf_get_lang dictionary_id="39979.Aracı Kodu"></td>
                  </tr>
                <tr>
                  <td colspan="2" align="center"><cf_get_lang dictionary_id="58674.Yeni"></td>
                  <td colspan="2" align="center"><cf_get_lang dictionary_id="53832.Eski"></td>
                  </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td width="3%">&nbsp;</td>
                  <td width="3%">&nbsp;</td>
                  <td width="3%">&nbsp;</td>
                  <td width="2%">&nbsp;</td>
                  <td width="3%">&nbsp;</td>
                  <td width="3%">&nbsp;</td>
                  <td width="3%">&nbsp;</td>
                  <td width="3%">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table></td>
            </tr>
            <tr>
              <td height="40">&nbsp;</td>
              </tr>
          </table>
            <br/>
            <table width="100%" border="1" cellspacing="0" cellpadding="0">
              <tr>
                <td width="80" rowspan="2" valign="top"><cf_get_lang dictionary_id="53901.İşyerinin Adresi"></td>
                <td>&nbsp;</td>
                </tr>
              <tr>
                <td><cf_get_lang dictionary_id="58132.Semt">...........................<cf_get_lang dictionary_id="58638.İlçe">:........................<cf_get_lang dictionary_id="57971.Şehir">:....................<cf_get_lang dictionary_id="57472.Posta Kodu">:...........................</td>
              </tr>
            </table>
            <br/>
            <table width="100%" border="1" cellspacing="0" cellpadding="0">
              <tr>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id="59408.Yukarıdaki bilgilerin defter, kayıt ve belgelere uygun bulunduğunu, yanlış olması sebebiyle sigortalının eşi ve geçindirmekle yükümlü olduğu çocuklarına kurumca yersiz olarak yapılan her turlu masrafları ödemeyi kabul ederim."><br/>
                  <br/>
                  <br/>
                  <br/></td>
                <td width="150" valign="bottom"><cf_get_lang dictionary_id="57742.Tarih">:</td>
                <td width="250" align="center" valign="bottom"><cf_get_lang dictionary_id="59409.İşverenin veya vekilinin Adı,Soyadı,İmzası, Mühür veya Kaşesi"></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
    </tr>
  </table>
</cfoutput>
