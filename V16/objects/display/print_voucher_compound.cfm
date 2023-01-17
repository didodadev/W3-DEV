<cfscript>
	if(not isdefined("total_pesin"))total_pesin = 0;
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

<cfset en_genel_toplam = en_genel_toplam+total_pesin >
<cfset kalan_pesin = main_total-total_pesin >
<cfset ana_para = main_total-total_pesin >
<cfset en_genel_toplam = 0 >
<cfset toplam_carpan = 0 >
<cfset faiz = faiz/100 >
<cfif len(GET_TYPE_PM.BALANCED_PAYMENT) and GET_TYPE_PM.BALANCED_PAYMENT>
 	 <!--- ve bilesik faiz --->
	  <cfloop from="1" to="#taksit_sayi#" index="n">
		<cfset ay_carpan = ((1 + faiz)^n) >
		<cfset toplam_carpan = toplam_carpan + ay_carpan >
	  </cfloop>
	  <cfset ilk_ay_odemesi = ana_para/toplam_carpan >
	  <cfloop from="1" to="#taksit_sayi#" index="m">
		<cfset aylik_ana_para = ilk_ay_odemesi*((1+faiz)^m) >
		<cfset aylik_faiz = aylik_ana_para*faiz>
		<cfset ay_toplam= aylik_ana_para+aylik_faiz >
	  </cfloop>
 	  <cfset ay_toplam = round(ay_toplam) >
	  <cfloop from="1" to="#taksit_sayi#" index="m">
		<cfset aylik_faiz = ana_para*faiz >
		<cfset aylik_ana_para = round(ay_toplam - aylik_faiz) >
		<cfset ana_para = ana_para - aylik_ana_para >
		<cfset "aylik_faiz#m#" = ana_para*faiz >
		<cfset "aylik_ana_para#m#" = round(ay_toplam - aylik_faiz) >
		<cfset "ana_para#m#" = ana_para - aylik_ana_para >
		<cfset "ay_toplam#m#" = ay_toplam >
		<cfset en_genel_toplam=en_genel_toplam+ay_toplam>
	  </cfloop>
  <cfelse>
  <!--- artan odeme ve bilesik faiz --->
  <cfset aylik_ana_para = ana_para/taksit_sayi >
  <cfloop from="1" to="#taksit_sayi#" index="m">
    <cfset aylik_faiz = (aylik_ana_para*((1+faiz)^m))-aylik_ana_para >
    <cfset ay_toplam = round(aylik_ana_para+aylik_faiz) >
    <cfset "aylik_faiz#m#" = (aylik_ana_para*((1+faiz)^m))-aylik_ana_para >
    <cfset "ay_toplam#m#" = round(aylik_ana_para+aylik_faiz) >
    <cfset en_genel_toplam=en_genel_toplam+ay_toplam>
  </cfloop>
</cfif>
<cfset yuzde_orani =100/taksit_sayi>

<cfloop from="1" to="#taksit_sayi#" index="m">
  <br/>
  <br/>
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
            <td><cf_get_lang dictionary_id='56565.Kr.'></td>
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
                  <td height="30">
				  <cfset tarih2=date_add('m',m,tarih)>
				  <cfoutput>#dateformat(tarih2,dateformat_style)#</cfoutput></td>
                  <td height="30"><cfoutput>#TLFormat(Evaluate("ay_toplam#m#"))# #SESSION.EP.MONEY#</cfoutput></td>
                  <td height="30">.....................</td>
                  <td height="30"></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td><p> İşbu emre muharrer senedim...........mukabilinde <cfoutput><strong>#dateformat(tarih2,dateformat_style)#</strong></cfoutput> tarihinde<br/>
                Bay <cfoutput><strong>#session.ep.company#</strong></cfoutput> veyahut emrühavale...........................<br/>
                Ödeyeceği <cfoutput><strong>
                  <cfset txt_total_value=odenecek>
                  <cf_n2txt number="txt_total_value">#txt_total_value# #SESSION.EP.MONEY#</strong></cfoutput> Bedeli arzolunmuştur. İş bu bono vadesinde ödenmediği<br/>
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
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  <br/>
  <br/>
</cfloop>
