<cfif not len(attributes.in_out_id)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='45869.Çalışana Öncelikle Giriş İşlemi Yapmalısınız'>!");
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
<!--- <cfset branch_id_ = get_in_out.BRANCH_ID> --->

<cfquery name="get_emp_detail" datasource="#dsn#">
	SELECT 
		ED.*,
		EI.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.PHOTO,
		E.PHOTO_SERVER_ID
	FROM 
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES E
	WHERE 
		ED.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		EI.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = ED.EMPLOYEE_ID
</cfquery>
<cfquery name="get_emp_detail_organizer" datasource="#dsn#">
	SELECT 
		ED.*,
		EI.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.PHOTO,
		E.PHOTO_SERVER_ID	
	FROM 
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES E
	WHERE 
		ED.EMPLOYEE_ID =#session.ep.userid# AND
		EI.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = ED.EMPLOYEE_ID
</cfquery>
 <cfif len(attributes.employee_id)>
	<cfquery name="get_positions" datasource="#dsn#">
		SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
	</cfquery>
</cfif>
 <cfif isdefined('get_emp_detail.NATIONALITY') and len(get_emp_detail.NATIONALITY)>
	<cfquery name="get_country" datasource="#dsn#">
		SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID=#get_emp_detail.NATIONALITY#
	</cfquery>
</cfif>
<cfif not isDefined("attributes.print_et")>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-row">
          <td  style="text-align:right;">
            <a href="##" onClick="document.send.submit();"><img src="/images/print.gif" title="<cf_get_lang dictionary_id='29740.Yazıcıya Gönder'>" border="0"></a>
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
<form name="send" id="send" method="post">
<input type="hidden" name="print_et" id="print_et" value="1">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
  	<td class="formbold" align="center"><cf_get_lang dictionary_id="59487.ÇALIŞANLARA AİT KİMLİK BİLDİRME BELGESİ"></td>
  </tr>
  <tr>
  	<td align="center">
		<br/><br/>
		<table cellpadding="0" cellspacing="0" border="1">
			<tr>
				<td width="90" align="center"><cf_get_lang dictionary_id="53806.İŞYERİ"></td>
				<td width="90" align="center"><cf_get_lang dictionary_id="59488.KONUT"></td>
				<td width="90" align="center"><cf_get_lang dictionary_id="59489.YURT"></td>
			</tr>
			<tr>
				<td width="90" align="center">X</td>
				<td width="90" align="center">&nbsp;</td>
				<td width="90" align="center">&nbsp;</td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
  	<td align="center">
		<br/>
		<table cellpadding="0" cellspacing="0" border="1" width="100%">
			<tr>
				<td rowspan="2" align="center"><cf_get_lang dictionary_id="59491.Bulunduğu"></td>
				<td align="center"><cf_get_lang dictionary_id="41196.İL-İLÇE"></td>
				<td align="center"><cf_get_lang dictionary_id="55645.KÖY"></td>
				<td align="center"><cf_get_lang dictionary_id="58132.SEMT"></td>
				<td align="center"><cf_get_lang dictionary_id="30629.CADDE"> - <cf_get_lang dictionary_id="30630.SOKAK"></td>
				<td align="center"><cf_get_lang dictionary_id="52521.BİNA"> -<cf_get_lang dictionary_id="57487.NO"> </td>
				<td align="center"><cf_get_lang dictionary_id="57499.TELEFON"></td>
			</tr>
			<tr>
				<td align="center">#get_in_out.BRANCH_CITY# #get_in_out.BRANCH_COUNTY#&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">#get_in_out.BRANCH_ADDRESS#&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">#get_in_out.BRANCH_TEL1#&nbsp;</td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
  	<td class="formbold" align="center"><cf_get_lang dictionary_id="36209.ÇALIŞANIN"></td>
  </tr>
  <tr>
  	<td>
		<table cellpadding="2" cellspacing="0" border="1" width="100%">
		
			<tr>
				<td><cf_get_lang dictionary_id="55757.Adı Soyadı"></td>
				<td>#get_emp_detail.EMPLOYEE_SURNAME# #get_emp_detail.EMPLOYEE_NAME#&nbsp;</td>
				<td colspan="2" align="center"><cf_get_lang dictionary_id="31247.NÜFUSA KAYITLI OLDUĞU YERİN"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="58033.BABA ADI"></td>
				<td>#get_emp_detail.FATHER#&nbsp;</td>
				<td><cf_get_lang dictionary_id="41196.İL-İLÇE"></td>
				<td>#get_emp_detail.CITY# - #get_emp_detail.COUNTY#</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="57790.DOĞUM YERİ"> <cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
				<td>#get_emp_detail.BIRTH_PLACE# #DateFormat(get_emp_detail.BIRTH_DATE,dateformat_style)#&nbsp;</td>
				<td><cf_get_lang dictionary_id="55645.KÖY"></td>
				<td>#get_emp_detail.VILLAGE#&nbsp;</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="30693.MEDENİ HALİ"></td>
				<td><cfif get_emp_detail.MARRIED eq 0><cf_get_lang dictionary_id="30694.Bekar"><cfelse><cf_get_lang dictionary_id="55743.Evli"></cfif>&nbsp;</td>
				<td><cf_get_lang dictionary_id="58723.ADRES"></td>
				<td>#get_emp_detail.HOMEADDRESS#&nbsp;</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="56135.UYRUĞU"></td>
				<td>
					<cfif isdefined('get_emp_detail.NATIONALITY') and len(get_emp_detail.NATIONALITY) and len(get_country.COUNTRY_NAME)>#get_country.COUNTRY_NAME#&nbsp;<cfelse>&nbsp;</cfif>
				</td>
				<td><cf_get_lang dictionary_id="59490.PASAPORT T.VE B."></td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
  	<td align="center">
		<br/>
		<table cellpadding="0" cellspacing="0" border="1" width="100%">
			<tr>
				<td rowspan="2" align="center" width="10%"><cf_get_lang dictionary_id="59492.Önceki İşinin"></td>
				<td align="center" width="150"><cf_get_lang dictionary_id="57897.ADI"></td>
				<td align="center" width="75"><cf_get_lang dictionary_id="58664.YERİ"></td>
				<td align="center"><cf_get_lang dictionary_id="49318.ADRESİ"></td>
				<td align="center" width="90"><cf_get_lang dictionary_id="31530.AYRILIŞ TARİHİ"></td>
			</tr>
			<tr>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
			</tr>
		</table><br />
		<table cellpadding="0" cellspacing="0" border="1" width="100%">
			<tr height="25">
				<td align="left" width="10%"><cf_get_lang dictionary_id="59461.YAPTIĞI İŞ">&nbsp;</td>
				<td align="center" width="30%">#get_positions.POSITION_NAME#&nbsp;</td>
				<td align="left" width="15%"><cf_get_lang dictionary_id="57655.BAŞLAMA TARİHİ">&nbsp;</td>
				<td align="center" width="20%">#DATEFORMAT(get_in_out.START_DATE,dateformat_style)#&nbsp;</td>
				<td align="center" width="15%"><cf_get_lang dictionary_id="59493.İŞ YERİNDE BARINIYOR">&nbsp;</td>
				<td align="center" width="10%">&nbsp;</td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
  	<td class="formbold" align="center">#get_in_out.COMPANY_NAME#&nbsp;<cf_get_lang dictionary_id="59494.ADINA BELGEYİ DÜZENLEYENİN"></td>
  </tr>
  <tr>
  	<td>
		<table cellpadding="2" cellspacing="0" border="1" width="100%">
			<tr>
				<td><cf_get_lang dictionary_id="32370.Adı Soyadı"></td>
				<td> #get_emp_detail_organizer.EMPLOYEE_NAME# #get_emp_detail_organizer.EMPLOYEE_SURNAME#&nbsp;</td>
				<td colspan="3" align="center"><cf_get_lang dictionary_id="30111.DURUMU"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="58033.BABA ADI"> </td>
				<td>#get_emp_detail_organizer.FATHER#&nbsp;</td>
				<td rowspan="3" align="center"><cf_get_lang dictionary_id="53806.İşyeri"></td>
				<td><cf_get_lang dictionary_id="43301.SAHİBİ"></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="57790.DOĞUM YERİ"> <cf_get_lang dictionary_id="58727.Doğum Tarihi"> </td>
				<td>#get_emp_detail_organizer.BIRTH_PLACE# #DateFormat(get_emp_detail_organizer.BIRTH_DATE,dateformat_style)#&nbsp;</td>
				<td><cf_get_lang dictionary_id="59495.KİRACI"></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="56135.UYRUĞU"></td>
				<td><cfif isdefined('get_country.COUNTRY_NAME') and len(get_country.COUNTRY_NAME)>#get_country.COUNTRY_NAME#&nbsp;<cfelse>&nbsp;</cfif></td>
				<td><cf_get_lang dictionary_id="59496.SORUMLU İŞLETİCİ"></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td rowspan="2"><cf_get_lang dictionary_id="49318.ADRESİ"></td>
				<td rowspan="2">#get_in_out.BRANCH_ADDRESS#&nbsp;</td>
				<td rowspan="2"><cf_get_lang dictionary_id="59488.KONUT"></td>
				<td><cf_get_lang dictionary_id="59497.AİLE REİSİ"> </td>
				<td>&nbsp;</td>
			</tr>
			<tr>
			  <td><cf_get_lang dictionary_id="29511.YÖNETİCİ">&nbsp;</td>
			  <td>&nbsp;</td>
		    </tr>
			<tr>
				<td><cf_get_lang dictionary_id="57499.TELEFONU"></td>
				<td>#get_in_out.BRANCH_TEL1#&nbsp;</td>
				<td><cf_get_lang dictionary_id="59489.YURT"></td>
				<td><cf_get_lang dictionary_id="59496.SORUMLU İŞLETİCİ">&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
  	<td height="30"  style="text-align:right;">
		<br/>
		<table cellspacing="1" cellpadding="2" width="100%">
			<tr align="left">
				<td align="left">
					<cf_get_lang dictionary_id="59498.VERDİĞİM BU BELGENİN DOĞRULUĞUNU ONAYLARIM."> <strong><br/>#get_emp_detail_organizer.EMPLOYEE_NAME# #get_emp_detail_organizer.EMPLOYEE_SURNAME#&nbsp;</strong>
				</td>
				<td><strong>#dateformat(now(),dateformat_style)#</strong></td>
			</tr>
		</table>
		<br/><br/>
	</td>
  </tr>
  <tr>
  	<td class="formbold" align="center"><cf_get_lang dictionary_id="59499.BELGEYİ TESLİM ALANIN"></td>
  </tr>
  <tr>
  	<td>
		<table cellpadding="2" cellspacing="0" border="1" width="100%">
			<tr>
				<td width="15%"><cf_get_lang dictionary_id="32370.ADI SOYADI"></td>
				<td>&nbsp;</td>
				<td width="15%"><cf_get_lang dictionary_id="53916.GÖREVİ"></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td width="20%"><cf_get_lang dictionary_id="59500.RÜTBESİ"></td>
				<td>&nbsp;</td>
				<td><cf_get_lang dictionary_id="59501.ALINIŞ TARİHİ"></td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</td>
  </tr>
</table> 
</form>
</cfoutput>
<cfif isdefined('get_emp_detail.NATIONALITY') and len(get_emp_detail.NATIONALITY)>
	<cfquery name="get_country" datasource="#dsn#">
		SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID=#get_emp_detail.NATIONALITY#
	</cfquery>
</cfif>
 <cfoutput>
<br/>
<hr />
<table cellpadding="2" cellspacing="0" border="1" width="800" align="center">
<tr align="center" valign="top">
	<td colspan="4" class="formbold"><strong><cf_get_lang dictionary_id="59502.ÇALIŞANIN AYRILMASI HALİNDE BELGEYİ DÜZENLEYEN İLE  KOLLUK ÖRGÜTÜ ARASINDA DEĞİŞTİRİLECEK KISIM"></strong></td>
</tr>  <tr width="10">	
    <td width="20%"><cf_get_lang dictionary_id="32370.ADI SOYADI"></td>
    <td width="20%">#get_emp_detail.EMPLOYEE_NAME# #get_emp_detail.EMPLOYEE_SURNAME#&nbsp;</td>
    <td width="40%"><cf_get_lang dictionary_id="59431.İŞYERİ ADRESİ"></td>
    <td>#get_in_out.BRANCH_ADDRESS# #get_in_out.BRANCH_COUNTY# #get_in_out.BRANCH_CITY#&nbsp;</td>
  </tr>
  <tr width="10">
    <td><cf_get_lang dictionary_id="58033.BABA ADI"></td>
    <td>#get_emp_detail.FATHER#&nbsp;</td>
    <td><cf_get_lang dictionary_id="33787.AYRILMA TARİHİ"></td>
    <td>#DATEFORMAT(get_in_out.FINISH_DATE,dateformat_style)#&nbsp;</td>
  </tr>
  <tr width="10">
    <td><cf_get_lang dictionary_id="57790.DOĞUM YERİ"> <cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
    <td>#get_emp_detail.BIRTH_PLACE# #DateFormat(get_emp_detail.BIRTH_DATE,dateformat_style)#&nbsp;</td>
    <td><cf_get_lang dictionary_id="58957.İMZA"></td>
    <td>&nbsp;</td>
  </tr>
  <br/>
  <tr align="center">
	<td class="formbold" colspan="5" align="center"><cf_get_lang dictionary_id="58723.ADRES">,<cf_get_lang dictionary_id="57499.TELEFON">,<cf_get_lang dictionary_id="55127.KİMLİK BİLGİLERİ"> </td>
</tr>

</table>
<table cellpadding="2" cellspacing="1" border="1" width="800" align="center">
  <tr>
    <td colspan="3" width="20%"><cf_get_lang dictionary_id="32370.ADI SOYADI">&nbsp;</td>
    <td colspan="2" width="20%">#get_emp_detail.EMPLOYEE_NAME# #get_emp_detail.EMPLOYEE_SURNAME#&nbsp; </td>
    <td colspan="5" align="center" wi><cf_get_lang dictionary_id="31247.NÜFUSA KAYITLI OLDUĞU"></td>
  </tr>
  <tr>
    <td colspan="3"><cf_get_lang dictionary_id="58033.BABA ADI"></td>
    <td colspan="2">#get_emp_detail.FATHER#&nbsp;</td>
    <td colspan="2" width="20%"><cf_get_lang dictionary_id="41196.İL-İLÇE"></td>
    <td colspan="3">#get_emp_detail.CITY#&nbsp; / #get_emp_detail.COUNTY#&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3"><cf_get_lang dictionary_id="58440.ANA ADI"></td>
    <td colspan="2">#get_emp_detail.MOTHER#&nbsp;</td>
    <td colspan="2"><cf_get_lang dictionary_id="55655.CİLT NO">/<cf_get_lang dictionary_id="55656.AİLE SIRA">/<cf_get_lang dictionary_id="31253.SIRA NO"></td>
    <td>#get_emp_detail.BINDING#&nbsp;</td>
    <td>#get_emp_detail.FAMILY#&nbsp;</td>
    <td>#get_emp_detail.CUE#&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3"><cf_get_lang dictionary_id="57790.DOĞUM YERİ"> <cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
    <td colspan="2">#get_emp_detail.BIRTH_PLACE# #DateFormat(get_emp_detail.BIRTH_DATE,dateformat_style)#&nbsp;</td>
    <td colspan="2"><cf_get_lang dictionary_id="55645.KÖY"></td>
    <td colspan="3">#get_emp_detail.VILLAGE#&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3"><cf_get_lang dictionary_id="30693.MEDENİ HALİ"></td>
    <td colspan="2"><cfif get_emp_detail.MARRIED eq 0><cf_get_lang dictionary_id="59493.İŞ YERİNDE BARINIYOR">Bekar<cfelse><cf_get_lang dictionary_id="59493.İŞ YERİNDE BARINIYOR">Evli</cfif>&nbsp;</td>
    <td colspan="2"><cf_get_lang dictionary_id="49318.ADRESİ"></td>
    <td colspan="3">#get_emp_detail.HOMEADDRESS#&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3"><cf_get_lang dictionary_id="56135.UYRUĞU"></td>
<cfif isdefined('get_emp_detail.NATIONALITY') and len(get_emp_detail.NATIONALITY) and len(get_country.COUNTRY_NAME)>
	<td colspan="2">#get_country.COUNTRY_NAME#</td>
<cfelse>
	<td colspan="2">&nbsp;</td>
</cfif>
    <td colspan="2" width="15%"><cf_get_lang dictionary_id="57499.TELEFON"> -1</td>
    <td colspan="6">#get_emp_detail.HOMETEL_CODE# #get_emp_detail.HOMETEL#&nbsp;</td>
  </tr>
  <tr height="35">
    <td colspan="3"><cf_get_lang dictionary_id="58025.TC KİMLİK"></td>
    <td colspan="2">#get_emp_detail.TC_IDENTY_NO#&nbsp;</td>
    <td colspan="2"><cf_get_lang dictionary_id="57499.TELEFON"> -2</td>
    <td colspan="3">&nbsp;</td>
  </tr>
</table>
</form>
</cfoutput>
