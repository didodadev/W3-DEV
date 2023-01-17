<cfparam name="odenecek" default="0">
<cfquery name="GET_TYPE_PM" datasource="#DSN#" >
	SELECT
		*
	FROM
		SETUP_PAYMETHOD
	WHERE
		PAYMETHOD_ID=#attributes.pay_id#
</cfquery>
<cfset  attributes.ID=attributes.main_id>
<cfset date_v=attributes.date_v>
<cfquery datasource="#evaluate("#attributes.db_name#")#" name="get_values">
	SELECT
		*
	FROM
		#attributes.str_table#
	WHERE
		#attributes.str_field#=#attributes.main_id#
</cfquery>
<cfset main_total="#evaluate("get_values.#main_value#")#">

<cfif not isDefined("attributes.print")>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr class="color-border">
		<td colspan="2">
			<table width="100%" border="0" cellspacing="1" cellpadding="2">
			<tr class="color-row">
			<td style="text-align:right;">
			<a href="javascript://" onClick="<cfoutput>windowopen('#request.self#?fuseaction=objects.popup_print_sales_voucher&print=true#page_code#','page')</cfoutput>"><img src="/images/print.gif" title="<cf_get_lang dictionary_id='58743.Gönder'>" border="0"></a>
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
    window.opener.close();
	window.print();
</script>
</cfif>
<cfscript>
	total_pesin = 0;kalan_pesin= 0;
	if(not len(main_total)) main_total = 0;
	if(len(GET_TYPE_PM.DUE_DATE_RATE)) due_date_rate = GET_TYPE_PM.DUE_DATE_RATE; else due_date_rate = 0;
	en_genel_toplam = 0;
	is_compound = GET_TYPE_PM.COMPOUND_RATE;
	if(len(GET_TYPE_PM.balanced_payment) and GET_TYPE_PM.balanced_payment) esit_odeme=1; else esit_odeme=0;
	if(len(GET_TYPE_PM.FINANCIAL_COMPOUND_RATE) and GET_TYPE_PM.FINANCIAL_COMPOUND_RATE)is_financial_compound = 1; else is_financial_compound = 0;
	tarih = "#evaluate("get_values.#date_v#")#";
	faiz =due_date_rate ;
	if(len(GET_TYPE_PM.DUE_MONTH)) taksit_sayi = GET_TYPE_PM.DUE_MONTH; else taksit_sayi = 0;
</cfscript>
<!--- ******************************* ---->
<cfif LEN(GET_TYPE_PM.IN_ADVANCE) and GET_TYPE_PM.IN_ADVANCE gt 0>
	<cfset total_pesin=GET_TYPE_PM.IN_ADVANCE*main_total/100>
</cfif>
		

<!----
<cfif LEN(GET_TYPE_PM.IN_ADVANCE) and GET_TYPE_PM.IN_ADVANCE gt 0>
		
<cfset total_pesin=GET_TYPE_PM.IN_ADVANCE*main_total/100>
<br/><br/>
<table width="1000" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC">
  <tr>
    <td width="200">
	<table width="100%" height="188" border="0" cellpadding="0" cellspacing="3">
        <tr>
          <td>No </td>
          <td width="3">:</td>
          <td width="100%">....................</td>
        </tr>
        <tr>
          <td>Lira</td>
          <td>:</td>
          <td>....................</td>
        </tr>
        <tr>
          <td>Kr.</td>
          <td>:</td>
          <td>....................</td>
        </tr>
        <tr>
          <td>Borçlu</td>
          <td>:</td>
          <td>....................</td>
        </tr>
        <tr>
          <td>Vade</td>
          <td>:</td>
          <td>....................</td>
        </tr>
        <tr>
          <td>Tarih</td>
          <td>:</td>
          <td>....................</td>
        </tr>
      </table>
    </td>
    <td width="75">&nbsp;</td>
    <td>
	<table>
        <tr>
          <td valign="top"><table width="100%">
              <tr align="center">
                <td width="110">Ödeme Günü</td>
                <td width="110">Türk Lirası</td>
                <td width="110">Kuruş</td>
                <td width="110">No.</td>
              </tr>
              <tr align="center" class="formbold">
                <td height="30"><cfoutput>#dateformat(tarih,dateformat_style)#</cfoutput></td>
                <td height="30"><cfoutput>#TLFormat(total_pesin)# #SESSION.EP.MONEY#</cfoutput></td>
                <td height="30">.....................</td>
                <td height="30"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td><p> 
            İşbu emre muharrer senedim...........mukabilinde <cfoutput><strong>#dateformat(tarih,dateformat_style)#</strong></cfoutput> tarihinde<br/>
            Bay   <cfoutput><strong>#session.ep.company#</strong></cfoutput>  veyahut emrühavale...........................<br/>
            Ödeyeceği <cfoutput><strong><cfset txt_total_value=total_pesin> <cf_n2txt number="txt_total_value">#txt_total_value# #SESSION.EP.MONEY#</strong></cfoutput> Bedeli arzolunmuştur. İş bu bono vadesinde ödenmediği<br/>
            takdirde müteakip bonoların da muacceliyet kesbedeceğini, ihtilaf vukuunda..................<br/>
			mahkemelerin selahiyetini şimdiden kabul eyleri<br/>          
          </p>
          </td>
        </tr>
        <tr>
          <td><table width="100%">
            <tr>
              <td width="15" rowspan="4">Ö<br/>                
                d<br/>
                e<br/>
                y<br/>
                e<br/>
                c<br/>
                e<br/>
                k</td>
              <td>İsim :</td>
              <td>......................................................</td>
            </tr>
            <tr>
              <td>Adresi :</td>
              <td>......................................................</td>
            </tr>
            <tr>
              <td>Kefil :</td>
              <td>......................................................</td>
            </tr>
            <tr>
              <td width="65">V.Da.No :</td>
              <td>......................................................</td>
            </tr>
          </table></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<br/>
</cfif>
 ******************************* --->
<cfif len(GET_TYPE_PM.DUE_MONTH) and GET_TYPE_PM.IN_ADVANCE neq 100 >
		<cfif is_financial_compound>
			<cfinclude template="print_voucher_compound.cfm">
		<cfelse>
			<cfloop from="1" to="#GET_TYPE_PM.DUE_MONTH#" index="m">
				<cfoutput>
						<cfset en_genel_toplam=en_genel_toplam+total_pesin>
						<cfset kalan_pesin=main_total-total_pesin> 						
						<cfif len(tarih)><cfset tarih=date_add('m',1,tarih)></cfif>
						<cfif is_compound eq 1 >
							<cfset odenecek = kalan_pesin/GET_TYPE_PM.DUE_MONTH + ((due_date_rate*kalan_pesin*m/GET_TYPE_PM.DUE_MONTH)/100) >	
							<!--- odenecek=#kalan_pesin#/#GET_TYPE_PM.DUE_MONTH#+((#due_date_rate#*#kalan_pesin#*m/#GET_TYPE_PM.DUE_MONTH#)/100) --->
						<cfelse>
							<cfset odenecek = kalan_pesin/GET_TYPE_PM.DUE_MONTH + ((due_date_rate*kalan_pesin/GET_TYPE_PM.DUE_MONTH)/100) >
							<!--- odenecek=#kalan_pesin#/#GET_TYPE_PM.DUE_MONTH#+((#due_date_rate#*#kalan_pesin#/#GET_TYPE_PM.DUE_MONTH#)/100)	 --->
						</cfif>
						</cfoutput>
						<br/><br/>
							<table width="1000" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC">
							  <tr>
								<td width="200">
								<table width="100%" height="188" border="0" cellpadding="0" cellspacing="3">
									<tr>
									  <td><cf_get_lang dictionary_id='57487.No'></td>
									  <td width="3">:</td>
									  <td width="100%">....................</td>
									</tr>
									<tr>
									  <td><cf_get_lang dictionary_id='56560.Lira'></td>
									  <td>:</td>
									  <td>....................</td>
									</tr>
									<tr>
									  <td><cf_get_lang dictionary_id='56565.Kr'></td>
									  <td>:</td>
									  <td>....................</td>
									</tr>
									<tr>
									  <td><cf_get_lang dictionary_id='58180.Borçlu'></td>
									  <td>:</td>
									  <td>....................</td>
									</tr>
									<tr>
									  <td><cf_get_lang dictionary_id='57640.Vade'></td>
									  <td>:</td>
									  <td>....................</td>
									</tr>
									<tr>
									  <td><cf_get_lang dictionary_id='57742.Tarih'></td>
									  <td>:</td>
									  <td>....................</td>
									</tr>
								  </table>
								</td>
								<td width="75">&nbsp;</td>
								<td>
								<table>
									<tr>
									  <td valign="top"><table width="100%">
										  <tr align="center">
											<td width="110"><cf_get_lang dictionary_id='54821.Ödeme Günü'></td>
											<td width="110"><cf_get_lang dictionary_id='56581.Türk Lirası'></td>
											<td width="110"><cf_get_lang dictionary_id='56591.Kuruş'></td>
											<td width="110"><cf_get_lang dictionary_id='57487.No'>.</td>
										  </tr>
										  <tr align="center" class="formbold">
											<td height="30"><cfoutput>#dateformat(tarih,dateformat_style)#</cfoutput></td>
											<td height="30"><cfoutput>#TLFormat(odenecek)# #SESSION.EP.MONEY#</cfoutput></td>
											<td height="30">.....................</td>
											<td height="30"></td>
										  </tr>
										</table>
									  </td>
									</tr>
									<tr>
									  <td><p> 
										İşbu emre muharrer senedim...........mukabilinde <cfoutput><strong>#dateformat(tarih,dateformat_style)#</strong></cfoutput> tarihinde<br/>
										Bay   <cfoutput><strong>#session.ep.company#</strong></cfoutput>  veyahut emrühavale...........................<br/>
										Ödeyeceği <cfoutput><strong><cfset txt_total_value=odenecek> <cf_n2txt number="txt_total_value">#txt_total_value# #SESSION.EP.MONEY#</strong></cfoutput> Bedeli arzolunmuştur. İş bu bono vadesinde ödenmediği<br/>
										takdirde müteakip bonoların da muacceliyet kesbedeceğini, ihtilaf vukuunda..................<br/>
										mahkemelerin selahiyetini şimdiden kabul eyleri<br/>          
									  </p>
									  </td>
									</tr>
									<tr>
									  <td><table width="100%">
										<tr>
										  <td width="15" rowspan="4">Ö<br/>                
											d<br/>
											e<br/>
											y<br/>
											e<br/>
											c<br/>
											e<br/>
											k</td>
										  <td><cf_get_lang dictionary_id='44592.İsim'> :</td>
										  <td>......................................................</td>
										</tr>
										<tr>
										  <td><cf_get_lang dictionary_id='49318.Adresi'> :</td>
										  <td>......................................................</td>
										</tr>
										<tr>
										  <td><cf_get_lang dictionary_id='58626.Kefil'> :</td>
										  <td>......................................................</td>
										</tr>
										<tr>
										  <td width="65">V.Da.No :</td>
										  <td>......................................................</td>
										</tr>
									  </table></td>
									</tr>
								  </table>
								</td>
							  </tr>
							</table>
							<br/><br/>
			</cfloop>
		</cfif>
	</cfif>
