<!--- sayfa içinde kullanım icin

attributes.ay
attributes.gun
attributes.yil
attributes.mode
attributes.fuseaction

Ergün KOÇAK
--->
<cfif isDefined("url.ay")>
  <cfset ay = url.ay>
  <cfelseif isDefined("attributes.ay")>
  <cfset ay = attributes.ay>
  <cfelse>
  <cfset ay = DateFormat(now(),"mm")>
</cfif>
<cfif isDefined("url.yil")>
  <cfset yil = url.yil>
  <cfelseif isDefined("attributes.yil")>
  <cfset yil = attributes.yil>
  <cfelse>
  <cfset yil = DateFormat(now(),"yyyy")>
</cfif>
<cfif not isdefined("attributes.mode")>
  <cfset attributes.mode = "">
</cfif>
<cfset oncekiyil = yil-1>
<cfset sonrakiyil = yil+1>
<cfset oncekiay = ay-1>
<cfset sonrakiay = ay+1>
<cfif ay EQ 1>
  <cfset oncekiay=12>
</cfif>
<cfif ay EQ 12>
  <cfset sonrakiay=1>
</cfif>
<cfsavecontent variable="ocak"><cf_get_lang_main no='180.ocak'></cfsavecontent>
<cfsavecontent variable="subat"><cf_get_lang_main no='181.şubat'></cfsavecontent>
<cfsavecontent variable="mart"><cf_get_lang_main no='182.mart'></cfsavecontent>
<cfsavecontent variable="nisan"><cf_get_lang_main no='183.nisan'></cfsavecontent>
<cfsavecontent variable="mayis"><cf_get_lang_main no='184.mayıs'></cfsavecontent>
<cfsavecontent variable="haziran"><cf_get_lang_main no='185.haziran'></cfsavecontent>
<cfsavecontent variable="temmuz"><cf_get_lang_main no='186.temmuz'></cfsavecontent>
<cfsavecontent variable="agustos"><cf_get_lang_main no='187.agustos'></cfsavecontent>
<cfsavecontent variable="eylul"><cf_get_lang_main no='188.eylül'></cfsavecontent>
<cfsavecontent variable="ekim"><cf_get_lang_main no='189.ekim'></cfsavecontent>
<cfsavecontent variable="kasim"><cf_get_lang_main no='190.ksaım'></cfsavecontent>
<cfsavecontent variable="aralik"><cf_get_lang_main no='191.aralık'></cfsavecontent>
<cfset aylar="#trim(ocak)#,#trim(subat)#,#trim(mart)#,#trim(nisan)#,#trim(mayis)#,#trim(haziran)#,#trim(temmuz)#,#trim(agustos)#,#trim(eylul)#,#trim(ekim)#,#trim(kasim)#,#trim(aralik)#">
<cfset tarih = createDate(yil,ay,1)>
<cfset bas = DayofWeek(tarih)-1> <!---gun değerini rakam olarak dondurur--->
<cfif bas EQ 0>
  <cfset bas=7>
</cfif>
<cfset son = DaysinMonth(tarih)><!--- aydaki gun sayısını verir--->
<cfset gun = 1>
<cfset yer = "#cgi.script_name#?fuseaction=#attributes.fuseaction#&mode=#attributes.mode#">

<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-row" height="25">
          <td colspan="7" align="center">
            <table border="0" cellpadding="0" cellspacing="0">
              <tr class="formbold"> <cfoutput>
                  <!-- sil --><td width="20" align="left"> <a href="#yer#&ay=#ay#&yil=#oncekiyil# <cfif isdefined("adres") and len(adres)>&#adres#</cfif> "><img src="/images/previous20.gif" width="15" height="20" alt="Yıl" border="0"></a></td><!-- sil -->
                  <td colspan="3" align="center">#Year(tarih)#</td>
                  <!-- sil --><td width="20" style="text-align:right;"><a href="#yer#&ay=#ay#&yil=#sonrakiyil#<cfif isdefined("adres") and len(adres)>&#adres#</cfif>"><img src="/images/next20.gif" width="15" height="20" alt="Adres" border="0"></a></td><!-- sil -->
                  <!-- sil --><td width="20" align="left"><a href="#yer#&ay=#oncekiay#&yil=<cfif ay eq 1>#oncekiyil#<cfelse>#yil#</cfif><cfif isdefined("adres") and len(adres)>&#adres#</cfif>"><img src="/images/previous20.gif" width="15" alt="Yıl" height="20" border="0"></a></td><!-- sil -->
                  <td colspan="4" align="center">#ListGetAt(aylar,Month(tarih))#</td>
                  <!-- sil --><td width="20" style="text-align:right;"><a href="#yer#&ay=#sonrakiay#&yil=<cfif ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif><cfif isdefined("adres") and len(adres)>&#adres#</cfif>"><img src="/images/next20.gif" alt="Ay" width="15" height="20" border="0"></a></td><!-- sil -->
                </cfoutput> </tr>
            </table>
          </td>
        </tr>
          <tr class="color-header" height="25">
            <td class="form-title"><cf_get_lang_main no='207.pzt'></th>
            <td class="form-title"><cf_get_lang_main no='208.sal'></th>
            <td class="form-title"><cf_get_lang_main no='209.crs'></th>
            <td class="form-title"><cf_get_lang_main no='210.per'></th>
            <td class="form-title"><cf_get_lang_main no='211.cum'></th>
            <td class="form-title"><cf_get_lang_main no='212.cmt'></th>
            <td class="form-title"><cf_get_lang_main no='213.paz'></th>
          </tr>
        <tr class="color-row">
          <cfloop index=x from=1 to=#Evaluate(bas-1)#>
            <td class="tableyazi">&nbsp;</td>
          </cfloop>
          <cfloop index=x from=#bas# to=7>
		  		<cfif isdefined('attributes.view_agenda') and len(attributes.view_agenda)>
					<td class="tableyazi"><cfoutput><a class="tableyazi" href="#yer#&yil=#yil#&ay=#ay#&gun=#gun#&view_agenda=#view_agenda#<cfif isdefined("adres") and len(adres)>&#adres#</cfif>"><cfif dateformat(now(),'d') eq gun and dateformat(now(),'mm') eq ay and dateformat(now(),'yyyy') eq yil><font class="color-light">#gun#</font><cfelse>#gun#</cfif></a></cfoutput></td>
				<cfelse>
					<td class="tableyazi"><cfoutput><a class="tableyazi" href="#yer#&yil=#yil#&ay=#ay#&gun=#gun#<cfif isdefined("adres") and len(adres)>&#adres#</cfif>"><cfif dateformat(now(),'d') eq gun and dateformat(now(),'mm') eq ay><font class="color-light">#gun#</font><cfelse>#gun#</cfif></a></cfoutput></td>
				</cfif>
            <cfset gun = gun +1>
          </cfloop>
        </tr>
        <cfloop index=y from=2 to=6>
          <tr class="color-row">
            <cfloop index=x from=1 to=7>
              <cfif gun LTE son>
			  		<cfif isdefined('attributes.view_agenda') and len(attributes.view_agenda)>
						<td class="tableyazi"><cfoutput><A class="tableyazi" href="#yer#&yil=#yil#&ay=#ay#&gun=#gun#&view_agenda=#view_agenda#<cfif isdefined("adres") and len(adres)>&#adres#</cfif>"><cfif dateformat(now(),'d') eq gun and dateformat(now(),'mm') eq ay and dateformat(now(),'yyyy') eq yil><font class="color-light">#gun#</font><cfelse>#gun#</cfif></a></cfoutput></td>
					<cfelse>
						<td class="tableyazi"><cfoutput><A class="tableyazi" href="#yer#&yil=#yil#&ay=#ay#&gun=#gun#<cfif isdefined("adres") and len(adres)>&#adres#</cfif>"><cfif dateformat(now(),'d') eq gun and dateformat(now(),'mm') eq ay and dateformat(now(),'yyyy') eq yil><font class="color-light">#gun#</font><cfelse>#gun#</cfif></a></cfoutput></td>
					</cfif>
			<cfelse>
                <td class="tableyazi">&nbsp;</td>
              </cfif>
              <cfset gun = gun +1>
            </cfloop>
          </tr>
        </cfloop>
      </table>
    </td>
  </tr>
</table>
