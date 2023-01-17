<!--- sayfa içinde kullaným için

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
<cfset bas = DayofWeek(tarih)-1>
<cfif bas EQ 0>
  	<cfset bas=7>
</cfif>
<cfset son = DaysinMonth(tarih)>
<cfset gun = 1>
<cfset yer = "#cgi.script_name#?fuseaction=#attributes.fuseaction#&mode=#attributes.mode#">
<table cellspacing="0" cellpadding="0" align="center" style="width:98%">
  	<tr class="color-border">
    	<td>
            <table cellspacing="1" cellpadding="2" style="width:100%">
                <tr class="color-row" style="height:25px;">
                    <td colspan="7" align="center">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr class="formbold"> 
                                <cfoutput>
                                    <td align="left" style="width:20px;"> <a href="#yer#&ay=#ay#&yil=#oncekiyil#" title="<cf_get_lang_main no='528.Önceki Yıl'>"><img src="/images/previous20.gif" alt="<cf_get_lang_main no='528.Önceki Yıl'>" width="15" height="20" border="0"/></a></td>
                                    <td align="center" class="agenda-date">#Year(tarih)#</td>
                                    <td  style="text-align:right; width:20px;"><a href="#yer#&ay=#ay#&yil=#sonrakiyil#" title="<cf_get_lang_main no='533.Sonraki Yıl'>"><img src="/images/next20.gif" alt="<cf_get_lang_main no='533.Sonraki Yıl'>" width="15" height="20" border="0"/></a></td>
                                    <td align="left" style="width:20px;"><a href="#yer#&ay=#oncekiay#&yil=<cfif ay eq 1>#oncekiyil#<cfelse>#yil#</cfif>" title="<cf_get_lang_main no='529.Önceki Ay'>"><img src="/images/previous20.gif" alt="<cf_get_lang_main no='529.Önceki Ay'>" width="15" height="20" border="0"/></a></td>
                                    <cfif ( isdefined("session.ep.language") and  (session.ep.language is 'tr') )  or ( isdefined("session.pp.language") and (session.pp.language is 'tr') )>
                                        <td align="center" class="agenda-date">#ListGetAt(aylar,Month(tarih))#</td>
                                    <cfelseif ( isdefined("session.ep.language") and  (session.ep.language is 'eng') )  or ( isdefined("session.pp.language") and (session.pp.language is 'eng') )>
                                        <td align="center" class="agenda-date">#dateformat(tarih, 'mmmm')#</td>
                                    </cfif>
                                    <td style="text-align:right; width:20px;"><a href="#yer#&ay=#sonrakiay#&yil=<cfif ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif>" title="<cf_get_lang_main no='532.Sonraki Ay'>"><img src="/images/next20.gif" alt="<cf_get_lang_main no='532.Sonraki Ay'>" width="15" height="20" border="0"/></a></td>
                                </cfoutput> 
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="color-header" style="height:25px;">
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
                    <td class="tableyazi"><cfoutput><a class="tableyazi" href="#yer#&yil=#yil#&ay=#ay#&gun=#gun#">#gun#</a></cfoutput></td>
                    <cfset gun = gun +1>
                </cfloop>
                </tr>
                <cfloop index=y from=2 to=6>
                    <tr class="color-row">
                        <cfloop index=x from=1 to=7>
                            <cfif gun LTE son>
                                <td class="tableyazi"><cfoutput><a class="tableyazi" href="#yer#&yil=#yil#&ay=#ay#&gun=#gun#">#gun#</a></cfoutput></td>
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
