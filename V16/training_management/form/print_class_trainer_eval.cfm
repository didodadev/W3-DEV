<cfset attributes.class_id = attributes.id>
<cfinclude template="../query/get_class.cfm">
<cfinclude template="../query/get_trainer_eval.cfm">
<cfinclude template="../display/view_class.cfm">
  <table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold">&nbsp;<cf_get_lang no='284.Eğitimci Eğitim Değerlendirmesi'></td>
  </tr>
</table>
        <table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr clasS="color-border">
            <td>
              <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
				<tr class="color-row">
                  <td valign="top">
				  <br/>
                    <table border="0" width="99%">
					    <tr>
                        <td valign="top" class="txtboldblue">1-) <cf_get_lang no='285.Sınıfın Yapısı Programa Uygun mu'>?</td>
                      </tr>
					    <tr>
					      <td valign="top"><cfoutput>#GET_TRAIN_EVAL.PROGRAMA_UYGUN#</cfoutput></td>
				      </tr>
				      <tr>
                        <td valign="top" class="txtboldblue">2-) <cf_get_lang no='286.Programın Süresi yeterli mi'>?</td>
                      </tr>
                      <tr>
                        <td class="formbold" height="25"><cfoutput>#GET_TRAIN_EVAL.SURE_YETERLI#</cfoutput></td>
                      </tr>
                      <tr>
                        <td class="formbold" height="25">3-)
                          <cf_get_lang no='287.Katılımcılarla ilgili Düşünceleriniz Nelerdir'>?</td>
                      </tr>
                      <tr>
                        <td valign="top" class="txtboldblue">A-) <cf_get_lang no='288.Eğitim Öncesi konu ile ilgilibilgi seviyeleri nasıldı'>?</td>
                      </tr>
                      <tr>
                        <td valign="top"><cfoutput>#GET_TRAIN_EVAL.KATILIMCI_BILGI_SEVIYE#</cfoutput></td>
                      </tr>
                      <tr>
                        <td valign="top" class="txtboldblue">B-) <cf_get_lang no='289.Derse ilgi ve katılım nasıldı'>?</td>
                      </tr>
                      <tr>
                        <td valign="top"><cfoutput>#GET_TRAIN_EVAL.DERSE_KATILIM#</cfoutput></td>
                      </tr>
                      <tr>
                        <td valign="top" class="txtboldblue">C-) <cf_get_lang no='290.Eğitim Süresince
                          derse katılımlarıyla olumlu yönde dikkatinizi çeken
                          kişiler ve olumlu nitelikleri belirtiniz'>. </td>
                      </tr>	
                      <tr>
                        <td valign="top"><cfoutput>#GET_TRAIN_EVAL.OLUMLU_NITELIK#</cfoutput></td>
                      </tr>
                      <tr>
                        <td valign="top" class="txtboldblue">D-) <cf_get_lang no='291.Eğitim Süresince
                          konuyu takip etmekte zorlanan ya da derste olumsuz
                          davranışlarıyla dikkaktinizi çeken kişiler ve niteliklerini
                          belirtiniz'>. </td>
                      </tr>	
                      <tr>
                        <td valign="top"><cfoutput>#GET_TRAIN_EVAL.OLUMSUZ_NITELIK#</cfoutput></td>
                      </tr>
                      <tr>
                        <td valign="top" class="txtboldblue">4-) <cf_get_lang no='292.Eğitimci olarak
                          katıldığınız bu program hakkındaki diğer görüş ve düşünceleriniz
                          nedelerdir'>?</td>
                      </tr>
                      <tr>
                        <td valign="top"><cfoutput>#GET_TRAIN_EVAL.GORUS_ONVERI#</cfoutput></td>
                      </tr>				  				  
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
