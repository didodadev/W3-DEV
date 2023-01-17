<cfset tarih_bugun = dateformat(now(),"yyyy-mm-dd")>
<table width="99%" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" colspan="2">
      <table cellspacing="0" cellpadding="0" width="100%" border="0" align="center">
        <tr class="color-border">
          <td>
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header">
                <td height="22" align="center" width="15%" class="form-title"><cf_get_lang_main no='192.Pazartesi'></td>
                <td align="center" width="15%" class="form-title"><cf_get_lang_main no='193.Sali'></td>
                <td align="center" width="15%" class="form-title"><cf_get_lang_main no='194.Çarsamba'></td>
                <td align="center" width="15%" class="form-title"><cf_get_lang_main no='195.Persembe'></td>
                <td align="center" width="15%" class="form-title"><cf_get_lang_main no='196.Cuma'></td>
                <td align="center" width="15%" class="form-title"><cf_get_lang_main no='197.Cumartesi'></td>
                <td align="center" class="form-title"><cf_get_lang_main no='198.Pazar'></td>
              </tr>
              <cfset sayac =0>
              <tr class="color-list">
                <cfloop index="x" from="1" to="#Evaluate(bas-1)#">
                  <td height="20">&nbsp;</td>
                </cfloop>
                <cfloop index="x" from="#bas#" to="7">
                  <td height="20" class="txtbold"><cfoutput>#gun#</cfoutput></td>
                  <cfset gun = gun +1>
                  <cfset sayac = sayac +1>
                </cfloop>
              </tr>
              <cfset gun = gun - sayac>
              <tr class="color-row">
                <cfloop index="x" from="1" to="#Evaluate(bas-1)#">
                  <td height="79">&nbsp;</td>
                </cfloop>
                <cfset gun=0>
                <cfloop index="x" from="#bas#" to="7">
				<cfset gun = gun + 1>
                  <cfoutput>
                    <td height="79" valign="top" class="label">
                      <cfset attributes.to_day = date_add("h",-session.ep.time_zone,CreateODBCDatetime('#yil#-#ay#-#gun#'))>
                      <cfset compare_tarih="#yil#-#numberformat(ay,'00')#-#numberformat(gun,'00')#">
                      <cfset attributes.tarih_egitim = '#yil#-#ay#-#gun#'>
					  <cfset attributes.tarih_egitim_for_query =dateformat(attributes.tarih_egitim,dateformat_style) >
                      <cfinclude  template="../query/get_todays_trainings.cfm">
                      <cfloop  query="get_tr">
                        <cfif not len(get_tr.finish_date[currentrow]) and not len(get_tr.start_date[currentrow])>
                          <cfset color_ = "000000">
						  <cfelse>
                          <cfset compare_tarih = dateformat(get_tr.finish_date[currentrow],"yyyy-mm-dd")>
                          <cfset start_tarih = dateformat(get_tr.start_date[currentrow],"yyyy-mm-dd")>
                          <cfif start_tarih eq tarih_bugun or compare_tarih eq tarih_bugun or (start_tarih lt tarih_bugun and compare_tarih gt tarih_bugun)>
                            <cfset color_="FF0000">
							<cfelse>
								<cfset color_="FF00FF">
                          </cfif>
						</cfif>
						<cfif type eq 4>
							<cfset color_="000000">
						</cfif>
						<cfif attributes.tarih_egitim eq compare_tarih or start_tarih eq attributes.tarih_egitim>
                        	<a href="#request.self#?fuseaction=training.view_class&class_id=#get_tr.class_id#">
							<font  color="#color_#">#get_tr.class_name#<cfif get_tr.type eq 2>&nbsp;(Eğitimci)<cfelseif get_tr.type eq 1>&nbsp;(Katılımcı)<cfelseif get_tr.type eq 3>&nbsp;(Bilgi Amaçlı)</cfif></font></a><br/>
						</cfif>
						</cfloop>
						&nbsp;
					 </td>
                  </cfoutput>
                </cfloop>
                <cfset gun = gun + 1>
              </tr>
              <cfloop index=y from=2 to=6>
                <cfset sayac=0>
                <tr class="color-list">
                  <cfloop index=x from=1 to=7>
                    <cfif gun lte son>
                      <td height="20" class="txtbold"><cfoutput>#gun#</cfoutput></td>
                      <cfelse>
                      <td>&nbsp;</td>
                    </cfif>
                    <cfset gun = gun +1>
                    <cfset sayac = sayac +1>
                  </cfloop>
                </tr>
                <cfset gun=gun-sayac>
                <tr valign="top" class="color-row"> <cfoutput>
                    <cfloop index="x" from="1" to="7" >
                      <cfif gun lte son>
                        <td height="80" class="label">
                          <cfset attributes.tarih_egitim= '#yil#-#ay#-#gun#'>
						  <cfset attributes.tarih_egitim_for_query =dateformat(attributes.tarih_egitim,dateformat_style) >						  
                          <cfinclude  template="../query/get_todays_trainings.cfm">
                          <cfloop  query="get_tr">
                            <cfif not len(get_tr.finish_date[currentrow]) and not len(get_tr.start_date[currentrow])>
                              <cfset color_="000000" >
                              <cfelse>
                              <cfset compare_tarih=dateformat(get_tr.finish_date[currentrow],"yyyy-mm-dd")>
                              <cfset start_tarih=dateformat(get_tr.start_date[currentrow],"yyyy-mm-dd")>
                              <cfif start_tarih eq tarih_bugun or compare_tarih eq tarih_bugun or (start_tarih lt tarih_bugun and compare_tarih gt tarih_bugun)>
                              	  <cfset color_="FF0000" >
                              <cfelseif (compare_tarih gt tarih_bugun) and  (start_tarih  gt tarih_bugun)>
	                              <cfset color_ = "000000">
							  <cfelse>
	                              <cfset color_ = "FF00FF"></cfif></cfif>
								<cfif type eq 4>
									<cfset color_="000000">
								</cfif>
							<!--- compare_tarih bitiş tarihi --->
								<cfset haftasonu = dayofweek(attributes.tarih_egitim)>
							<cfif haftasonu neq 1>
                            	<a href="#request.self#?fuseaction=training.view_class&class_id=#get_tr.class_id#">
								<font color="#color_#">#get_tr.class_name#<cfif get_tr.type eq 2>&nbsp;(Eğitimci)<cfelseif get_tr.type eq 1>&nbsp;(Katılımcı)<cfelseif get_tr.type eq 3>&nbsp;(Bilgi Amaçlı)</cfif></font></a><br/>
							</cfif>
                          </cfloop>
                        </td>
                        <cfelse>
                        <td height="80">&nbsp;</td>
                      </cfif>
                      <cfset gun = gun +1>
                    </cfloop>
                  </cfoutput> </tr>
              </cfloop>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<br/>

