<cfinclude template="../query/get_ssk_offices.cfm">

<cfif not isdefined("attributes.grupa")>
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <cfform name="employee" method="post">
      <tr class="color-border">
        <td>
          <table width="100%" cellpadding="2" cellspacing="1">
            <tr class="color-row">
              <td>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table>
                        <tr>
                          <td class="headbold"><cf_get_lang dictionary_id="52962.Personel Durum Çizelgesi"></td>
                          <td>
                            <select name="SSK_OFFICE" id="SSK_OFFICE">
                              <cfoutput query="GET_SSK_OFFICES">
                                <cfif len(SSK_OFFICE) and len(SSK_NO)>
                                  <option value="#SSK_OFFICE#-#SSK_NO#"<cfif isdefined("attributes.SSK_OFFICE") and (attributes.SSK_OFFICE is "#SSK_OFFICE#-#SSK_NO#")> selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
                                </cfif>
                              </cfoutput>
                            </select>
                            <select name="sal_mon" id="sal_mon">
                              <cfif session.ep.period_year lt dateformat(now(),'YYYY')>
                                <cfloop from="1" to="12" index="i">
                                  <cfoutput>
                                    <option value="#i#"<cfif isdefined("attributes.sal_mon") and (i eq attributes.sal_mon)> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                  </cfoutput>
                                </cfloop>
                                <cfelse>
                                <cfloop from="1" to="#evaluate(dateformat(now(),'MM'))#" index="i">
                                  <cfoutput>
                                    <option value="#i#"<cfif isdefined("attributes.sal_mon") and (i eq attributes.sal_mon)> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                  </cfoutput>
                                </cfloop>
                              </cfif>
                            </select>
                            <input type="text" name="sal_year" id="sal_year" style="width:40px;" value="<cfoutput>#session.ep.period_year#</cfoutput>" readonly>
                          </td>
                          <td>
                            <cf_wrk_search_button>
                          </td>
                        </tr>
                      </table>
                    </td>
                    <!--- print --->
                    <td  style="text-align:right;">
                      <cfif isdefined("attributes.ssk_office")>
                        <a href="javascript://" onClick="document.send.submit();"><img src="/images/print.gif" title="Gönder" border="0"></a> <a href="javascript://" onClick="window.close();"><img src="/images/close.gif" title="Kapat" border="0"></a>
                      </cfif>
                    </td>
                    <!--- print --->
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </cfform>
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
<cfif not isdefined("form.ssk_office")>
  <cfexit method="exittemplate">
</cfif>
<cfinclude template="../query/get_personel_durum_count.cfm">
<table width="610" height="860" border="1" cellspacing="0" bordercolor="#999999">
  <tr>
    <td><table width="600" height="850" border="0" bordercolor="#999999">
        <tr>
          <td height="150" valign="top" class="headbold"><table width="100%" border="1" cellspacing="0">
              <tr align="center">
                <td colspan="2" class="headbold"> <cf_get_lang dictionary_id="52962.PERSONEL DURUM ÇİZELGESİ"><br/>
					<font size="2" class="label">(<cf_get_lang dictionary_id="59696.İşverenlerin İş ve İşçi Bulma Kurumuna Her Ay Göndermeleri Gereken Çizelge">)</font></td>
              </tr>
              <tr>
                <td width="311">
				<table width="100%" border="0">
                    <tr>
                      <td width="100"><cf_get_lang dictionary_id="53550.İşverenin"> <cf_get_lang dictionary_id ="57571.Ünvanı"></td>
                      <td>:</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td width="100"><cf_get_lang dictionary_id="53901.İşyerinin Adresi"></td>
                      <td>:</td>
                      <td>&nbsp;</td>
                    </tr>
                  </table>
                </td>
                <td width="150"  style="text-align:right;">
				<table>
					<tr>
						<td><cf_get_lang dictionary_id="53843.Ait Olduğu"> <cf_get_lang dictionary_id="58724.Ay">/<cf_get_lang dictionary_id="58455.Yıl"></td>
					</tr>
					<tr>
						<td><cfoutput>#ListGetAt(ay_list(),attributes.sal_mon)# &nbsp; &nbsp; #attributes.sal_year#</cfoutput></td>
					</tr>
				</table>
				
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td height="400" align="center" valign="top" bordercolor="#999999" class="headbold"><p>A-<cf_get_lang dictionary_id="45049.İŞÇİ"> <cf_get_lang dictionary_id="57756.DURUM"></p>
            <table width="100%" border="1" cellspacing="0">
              <tr>
                <td colspan="2">&nbsp;</td>
                <td width="100"><div align="center"><cf_get_lang dictionary_id="59697.Önceki Aydan Devreden"></div>
                </td>
                <td width="153"><cf_get_lang dictionary_id="53857.Ay İçinde"> <cf_get_lang dictionary_id="33656.Giren"></td>
                <td width="114"><cf_get_lang dictionary_id="53857.Ay İçinde"> <cf_get_lang dictionary_id="30368.Çalışan"></td>
                <td width="129"><cf_get_lang dictionary_id="53857.Ay İçinde"> <cf_get_lang dictionary_id="33657.Çıkan"></td>
              </tr>
              <tr>
                <td width="110" rowspan="3"><cf_get_lang dictionary_id="36863.SÜREKLİ"> <cf_get_lang dictionary_id ="45049.İŞÇİ"></td>
                <td width="213"><cf_get_lang dictionary_id="58959.Erkek"></td>
                <td width="100" align="center"><cfoutput>#ALL_MEN - STARTED_MEN#</cfoutput></td>
                <td width="153" align="center"><cfoutput>#STARTED_MEN#</cfoutput></td>
                <td width="114" align="center"><cfoutput>#ALL_MEN#</cfoutput></td>
                <td width="129" align="center"><cfoutput>#FIRED_MEN#</cfoutput></td>
              </tr>
              <tr>
                <td width="213"><cf_get_lang dictionary_id="58958.Kadın"></td>
                <td width="100" align="center"><cfoutput>#ALL_WOMEN - STARTED_WOMEN#</cfoutput></td>
                <td width="153" align="center"><cfoutput>#STARTED_WOMEN#</cfoutput></td>
                <td width="114" align="center"><cfoutput>#ALL_WOMEN#</cfoutput></td>
                <td width="129" align="center"><cfoutput>#FIRED_WOMEN#</cfoutput></td>
              </tr>
              <tr>
                <td width="213"><cf_get_lang dictionary_id="57492.Toplam"></td>
                <td width="100" align="center"><cfoutput>#ALL_MEN + ALL_WOMEN - STARTED_MEN - STARTED_WOMEN#</cfoutput></td>
                <td width="153" align="center"><cfoutput>#STARTED_MEN+STARTED_WOMEN#</cfoutput></td>
                <td width="114" align="center"><cfoutput>#ALL_MEN+ALL_WOMEN#</cfoutput></td>
                <td width="129" align="center"><cfoutput>#FIRED_MEN+FIRED_WOMEN#</cfoutput></td>
              </tr>
            </table>
            <br/>
            <br/>
            <br/>
            <br/>
            <table width="100%" border="1" cellspacing="0">
              <tr>
                <td colspan="2">&nbsp;</td>
                <td width="59"><div align="center"><cf_get_lang dictionary_id="59697.Önceki Aydan Devreden"></div>
                </td>
                <td width="270"><cf_get_lang dictionary_id="53857.Ay İçinde"> <cf_get_lang dictionary_id="33656.Giren"></td>
                <td width="174"><cf_get_lang dictionary_id="53857.Ay İçinde"> <cf_get_lang dictionary_id="30368.Çalışan"></td>
                <td width="189"><cf_get_lang dictionary_id="53857.Ay İçinde"> <cf_get_lang dictionary_id="33657.Çıkan"></td>
              </tr>
              <tr>
                <td width="81" rowspan="3"><cf_get_lang dictionary_id="54124.SAKAT"></td>
                <td width="46"><cf_get_lang dictionary_id="58959.Erkek"></td>
                <td width="59" align="center">&nbsp;</td>
                <td width="270" align="center">&nbsp;</td>
                <td width="174" align="center">&nbsp;</td>
                <td width="189" align="center">&nbsp;</td>
              </tr>
              <tr>
                <td width="46"><cf_get_lang dictionary_id="58958.Kadın"></td>
                <td width="59" align="center">&nbsp;</td>
                <td width="270" align="center">&nbsp;</td>
                <td width="174" align="center">&nbsp;</td>
                <td width="189" align="center">&nbsp;</td>
              </tr>
              <tr>
                <td width="46"><cf_get_lang dictionary_id="57492.Toplam"></td>
                <td width="59" align="center">&nbsp;</td>
                <td width="270" align="center">&nbsp;</td>
                <td width="174" align="center">&nbsp;</td>
                <td width="189" align="center">&nbsp;</td>
              </tr>
            </table>
            <br/>
            <table width="100%" border="1" cellspacing="0">
              <tr>
                <td rowspan="3"><cf_get_lang dictionary_id="55615.ESKİ HÜKÜMLÜ"></td>
                <td width="40"><cf_get_lang dictionary_id="58959.Erkek"></td>
                <td width="100" align="center">&nbsp;</td>
                <td width="100" align="center">&nbsp;</td>
                <td width="100" align="center">&nbsp;</td>
                <td width="100" align="center">&nbsp;</td>
              </tr>
              <tr>
                <td width="40"><cf_get_lang dictionary_id="58958.Kadın"></td>
                <td width="100" align="center">&nbsp;</td>
                <td width="100" align="center">&nbsp;</td>
                <td width="100" align="center">&nbsp;</td>
                <td width="100" align="center">&nbsp;</td>
              </tr>
              <tr>
                <td width="40"><cf_get_lang dictionary_id="57492.Toplam"></td>
                <td width="100" align="center">&nbsp;</td>
                <td width="100" align="center">&nbsp;</td>
                <td width="100" align="center">&nbsp;</td>
                <td width="100" align="center">&nbsp;</td>
              </tr>
            </table>
            <br/>
            <table width="100%" border="1" cellspacing="0">
              <tr>
                <td width="79" rowspan="3"><cf_get_lang dictionary_id="53657.TERÖR MAĞDURU"></td>
                <td width="46"><cf_get_lang dictionary_id="58959.Erkek"></td>
                <td width="29" align="center">&nbsp;</td>
                <td width="306" align="center">&nbsp;</td>
                <td width="172" align="center">&nbsp;</td>
                <td width="187" align="center">&nbsp;</td>
              </tr>
              <tr>
                <td width="46"><cf_get_lang dictionary_id="58958.Kadın"></td>
                <td width="29" align="center">&nbsp;</td>
                <td width="306" align="center">&nbsp;</td>
                <td width="172" align="center">&nbsp;</td>
                <td width="187" align="center">&nbsp;</td>
              </tr>
              <tr>
                <td width="46"><cf_get_lang dictionary_id="57492.Toplam"></td>
                <td width="29" align="center">&nbsp;</td>
                <td width="306" align="center">&nbsp;</td>
                <td width="172" align="center">&nbsp;</td>
                <td width="187" align="center">&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td valign="top"><div align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id="36245.İşyerinin"> <cfoutput><strong>#ListGetAt(ay_list(),attributes.sal_mon)#</strong></cfoutput> ayına ait personel hareketi gösterir çizelge doldurularak gönderilmiştir.
            <cf_get_lang dictionary_id="52374.Bilginize">.</div>
          </td>
        </tr>
        <tr>
          <td align="center" valign="top" class="headbold"><div align="left"><cf_get_lang dictionary_id="48814.Saygılarımızla"></div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<p></p>

