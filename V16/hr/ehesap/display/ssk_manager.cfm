<cfinclude template="../query/get_ssk_offices.cfm">
<cfif not isDefined("attributes.print")>
<cf_box title="#getlang('','SGK Yetkili Bildirgesi','47214')#"> 
	<cfform name="get_managers" action="" method="post">
	<cf_box_search>
    <div class="form-group">
      <select name="SSK_OFFICE" id="SSK_OFFICE">
        <cfoutput query="GET_SSK_OFFICES">
          <cfif len(SSK_OFFICE) and len(SSK_NO)>
          <option value="#SSK_OFFICE#-#SSK_NO#" <cfif isdefined("attributes.SSK_OFFICE") and (attributes.SSK_OFFICE is "#SSK_OFFICE#-#SSK_NO#")>selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
          </cfif>
        </cfoutput>
        </select>
    </div>
    <div class="form-group">
      <cf_wrk_search_button button_type="4">
    </div>
	</cf_box_search>	
	</cfform>
</cf_box>
<cfelse>
  <script type="text/javascript">
	function waitfor(){
	  window.close();
	}

	setTimeout("waitfor()",3000);
    window.opener.close();
	window.print();
</script>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="52984.SGK Yetkili Bildirgesi"></cfsavecontent>
<cfif isdefined("attributes.SSK_OFFICE")>
  <cf_box title="#message#" uidrop="1">
  <cfinclude template="../query/get_branch.cfm">
  <cfset attributes.position_code = get_branch.ADMIN1_POSITION_CODE>
  <cfinclude template="../query/get_hr_homeadress.cfm">
 
    <cf_grid_list border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC">
      <cfoutput>
      <tr height="35">
        <td height="35" colspan="3">
          <table width="100%" border="0" class="txtbold">
            <tr>
              <td><cf_get_lang dictionary_id="53821.SOSYAL SİGORTALAR KURUMU"></td>
            </tr>
            <tr>
              <td align="center"><cf_get_lang dictionary_id="59469.İŞYERİ YETKİLİ BİLDİRGESİ"></td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td width="5%" rowspan="16" align="center" class="txtbold">O<br/>
          R<br/>
          T<br/>
          A<br/>
          K<br/>
          <br/>
          B<br/>
          İ<br/>
          L<br/>
          G<br/>
          İ<br/>
          L<br/>
          E<br/>
          R<br/>
          İ</td>
        <td width="45%"><cf_get_lang dictionary_id="30314.Şirketteki Ünvanı"></td>
        <td width=50>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="57570.Ad Soyad"></td>
        <td>#get_hr_homeadress.EMPLOYEE_NAME# #get_hr_homeadress.EMPLOYEE_SURNAME#</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="53931.İkametgah Adresi"> / <cf_get_lang dictionary_id="57472.Posta Kodu"></td>
        <td>#get_hr_homeadress.HOMEADDRESS# #get_hr_homeadress.HOMECOUNTY# <cfif len(get_hr_homeadress.homecity)><cfquery name="get_city" datasource="#dsn#">SELECT * FROM SETUP_CITY WHERE CITY_ID = #get_hr_homeadress.homecity#</cfquery>#get_city.CITY_NAME#-</cfif> #get_hr_homeadress.HOMEPOSTCODE#</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="44172.Vergi Dairesi İsmi"> / <cf_get_lang dictionary_id="44867.Numarası"></td>
        <td>
		<cfif len(get_branch.BRANCH_TAX_NO)>
			#get_branch.branch_tax_office# / #get_branch.BRANCH_TAX_NO#&nbsp;
		<cfelseif len(get_branch.TAX_NO)>
			#get_branch.tax_office# / #get_branch.TAX_NO#&nbsp;
		</cfif>
		</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="56232.Göreve Başlama Tarihi"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="59470.Hisse Oranı"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="59471.Ticaret Sicil Gaz. Tarih/No/Sayfa"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
        <td>#get_hr_homeadress.BIRTH_DATE#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="57790.Doğum Yeri"></td>
        <td>#get_hr_homeadress.BIRTH_PLACE#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="53926.Nufüsa Kayıtlı Olduğu Yer"></td>
        <td>#get_hr_homeadress.CITY#</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="58033.Baba Adı"></td>
        <td>#get_hr_homeadress.FATHER#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="44259.Nufüs Cüzdanı Seri No"> / <cf_get_lang dictionary_id="31253.Sıra No"></td>
        <td>#get_hr_homeadress.SERIES#-#get_hr_homeadress.NUMBER#</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="34548.İş Tel"> / <cf_get_lang dictionary_id="57488.Fax"></td>
        <td>#get_hr_homeadress.DIRECT_TELCODE#-#get_hr_homeadress.DIRECT_TEL#</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="31261.Ev Tel."></td>
        <td>#get_hr_homeadress.HOMETEL_CODE# - #get_hr_homeadress.HOMETEL#</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="59472.Araç Plaka No"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="58156.Diğer"> <cf_get_lang dictionary_id="53823.İşyeri Sicil No"><br/>
          (<cf_get_lang dictionary_id="59473.bağlı olduğunuz birden çok işyeri varsa işyeri sicil numaranızı yazınız.">)</td>
        <td valign="baseline">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="3" align="center" class="txtbold">&nbsp;</td>
      </tr>
  </cfoutput>
  <cfset attributes.position_code = get_branch.ADMIN2_POSITION_CODE>
  <cfinclude template="../query/get_hr_homeadress.cfm">
  <cfoutput>
      <tr>
        <td width="5%" rowspan="16" align="center" class="txtbold"> Y<br/>
          Ö<br/>
          N<br/>
          E<br/>
          T<br/>
          İ<br/>
          C<br/>
          İ<br/>
          <br/>
          B<br/>
          İ<br/>
          L<br/>
          G<br/>
          İ<br/>
          L<br/>
          E<br/>
          R<br/>
          İ</td>
        <td width="45%"><cf_get_lang dictionary_id="30314.Şirket Ünvanı"></td>
        <td width=50>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="57570.Ad Soyad"></td>
        <td>#get_hr_homeadress.employee_name# #get_hr_homeadress.employee_surname#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="53931.İkametgah Adresi"> / <cf_get_lang dictionary_id="57472.Posta Kodu"></td>
        <td>#get_hr_homeadress.HOMEADDRESS# #get_hr_homeadress.HOMECOUNTY#  <cfif len(get_hr_homeadress.homecity)><cfquery name="get_city" datasource="#dsn#">SELECT * FROM SETUP_CITY WHERE CITY_ID = #get_hr_homeadress.homecity#</cfquery>#get_city.CITY_NAME#-</cfif>#get_hr_homeadress.HOMEPOSTCODE#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="44172.Vergi Dairesi Adı"> / <cf_get_lang dictionary_id="44867.Numarası"></td>
        <td>
			<cfif len(get_branch.BRANCH_TAX_NO)>
				#get_branch.branch_tax_office# / #get_branch.BRANCH_TAX_NO#&nbsp;
			<cfelseif len(get_branch.TAX_NO)>
				#get_branch.tax_office# / #get_branch.TAX_NO#&nbsp;
			</cfif>
		</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="56232.Göreve Başlama Tarihi"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="59470.Hisse Oranı"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="59471.Ticaret Sicil Gaz. Tarih/No/Sayfa"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
        <td>#get_hr_homeadress.BIRTH_DATE#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="57790.Doğum Yeri"></td>
        <td>#get_hr_homeadress.BIRTH_PLACE#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="53926.Nufüsa Kayıtlı Olduğu Yer"></td>
        <td>#get_hr_homeadress.CITY#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="58033.Baba Adı"></td>
        <td>#get_hr_homeadress.FATHER#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="44259.Nufüs Cüzdanı Seri No"> / <cf_get_lang dictionary_id="31253.Sıra No"></td>
        <td>#get_hr_homeadress.SERIES#-#get_hr_homeadress.NUMBER#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="34548.İş Tel"> / <cf_get_lang dictionary_id="57488.Fax"></td>
        <td>#get_hr_homeadress.DIRECT_TELCODE#-#get_hr_homeadress.DIRECT_TEL#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="31261.Ev Tel."></td>
        <td>#get_hr_homeadress.HOMETEL_CODE# - #get_hr_homeadress.HOMETEL#&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="59472.Araç Plaka No"></td>
        <td>&nbsp;</td>
      </tr>
  </cfoutput>
      <tr>
        <td><cf_get_lang dictionary_id="58156.Diğer"> <cf_get_lang dictionary_id="53823.İşyeri Sicil No"><br/>
          (<cf_get_lang dictionary_id="59473.bağlı olduğunuz birden çok işyeri varsa işyeri sicil numaranızı yazınız.">)</td>
        <td valign="baseline">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="3" align="center" class="txtbold">&nbsp;</td>
      </tr>
      <tr>
        <td width="5%" rowspan="16" align="center" class="txtbold"> M<br/>
          U<br/>
          H<br/>
          A<br/>
          S<br/>
          E<br/>
          B<br/>
          E<br/>
          C<br/>
          İ<br/>
          <br/>
          B<br/>
          İ<br/>
          L<br/>
          G<br/>
          İ<br/>
          L<br/>
          E<br/>
          R<br/>
          İ</td>
        <td width="45%"><cf_get_lang dictionary_id="30314.Şirket Ünvanı"></td>
        <td width=50>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="57570.Ad Soyad"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="53931.İkametgah Adresi"> / <cf_get_lang dictionary_id="57472.Posta Kodu"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="44172.Vergi Dairesi Adı"> / <cf_get_lang dictionary_id="44867.Numarası"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="56232.Göreve Başlama Tarihi"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="59470.Hisse Oranı"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="59471.Ticaret Sicil Gaz. Tarih/No/Sayfa"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="57790.Doğum Yeri"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="53926.Nufüsa Kayıtlı Olduğu Yer"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="58033.Baba Adı"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="44259.Nufüs Cüzdanı Seri No"> / <cf_get_lang dictionary_id="31253.Sıra No"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="34548.İş Tel"> / <cf_get_lang dictionary_id="57488.Fax"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="31261.Ev Tel."></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="59472.Araç Plaka No"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="58156.Diğer"> <cf_get_lang dictionary_id="53823.İşyeri Sicil No"><br/>
          (<cf_get_lang dictionary_id="59473.bağlı olduğunuz birden çok işyeri varsa işyeri sicil numaranızı yazınız.">)</td>
        <td valign="baseline">&nbsp;</td>
      </tr>
    </cf_grid_list>
  </cf_box>
</cfif>

