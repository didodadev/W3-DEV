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
<cfsavecontent variable="ocak"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="subat"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="mart"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="nisan"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="mayis"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="haziran"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="temmuz"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="agustos"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="eylul"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ekim"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="kasim"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="aralik"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
<cfset aylar="#trim(ocak)#,#trim(subat)#,#trim(mart)#,#trim(nisan)#,#trim(mayis)#,#trim(haziran)#,#trim(temmuz)#,#trim(agustos)#,#trim(eylul)#,#trim(ekim)#,#trim(kasim)#,#trim(aralik)#">
<!--- 
<cfif isLeapYear(yil)>
	<cfset aylar=listSetAt(aylar,2,29)>
</cfif>
 --->
<cfset tarih = createDate(yil,ay,1)>
<cfset bas = DayofWeek(tarih)-1>
<cfif bas EQ 0>
  <cfset bas=7>
</cfif>
<cfset son = DaysinMonth(tarih)>
<cfset gun = 1>
<cfset yer = "#cgi.script_name#?fuseaction=#attributes.fuseaction#&page_type=0&mode=#attributes.mode#">
<cf_grid_list>
    <thead>
        <tr> 
            <cfoutput>
                <th colspan="7">
                    <div class="input-group">
                        <span class="input-group-addon"><a href="#yer#&ay=#ay#&yil=#oncekiyil#"><i class="fa fa-caret-left"></i></a></span>
                        #Year(tarih)#
                        <span class="input-group-addon"><a href="#yer#&ay=#ay#&yil=#sonrakiyil#"><i class="fa fa-caret-right"></i></a></span>
                        <span class="input-group-addon"><a href="#yer#&ay=#oncekiay#&yil=<cfif ay eq 1>#oncekiyil#<cfelse>#yil#</cfif>"><i class="fa fa-caret-left"></i></a></span>
                            <cfif ( isdefined("session.ep.language") and  (session.ep.language is 'tr') )  or ( isdefined("session.pp.language") and  (session.pp.language is '_tr') )>
                                #ListGetAt(aylar,Month(tarih))#
                                <cfelseif ( isdefined("session.ep.language") and  (session.ep.language is 'eng') )  or ( isdefined("session.pp.language") and  (session.pp.language is '_eng') )>
                                #dateformat(tarih, 'mmmm')#
                            </cfif>
                            <span class="input-group-addon"><a href="#yer#&ay=#sonrakiay#&yil=<cfif ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif>"><i class="fa fa-caret-right"></i></a></span>
                    </div> 
                </th>
            </cfoutput> 
        </tr>
        <tr>
        <th class="form-title"><cf_get_lang dictionary_id='57619.Pzt'></th>
        <th class="form-title"><cf_get_lang dictionary_id='57620.Sal'></th>
        <th class="form-title"><cf_get_lang dictionary_id='57621.Çrş'></th>
        <th class="form-title"><cf_get_lang dictionary_id='57622.Prş'></th>
        <th class="form-title"><cf_get_lang dictionary_id='57623.Cu'></th>
        <th class="form-title"><cf_get_lang dictionary_id='57624.Cmt'></th>
        <th class="form-title"><cf_get_lang dictionary_id='57625.Paz'></th>
        </tr>
        </thead>
        <tr>
          <cfloop index=x from=1 to=#Evaluate(bas-1)#>
            <td class="tableyazi">&nbsp;</td>
          </cfloop>
          <cfloop index=x from=#bas# to=7>
            <td class="tableyazi"><cfoutput><A class="tableyazi" href="#yer#&yil=#yil#&ay=#ay#&gun=#gun#">#gun#</a></cfoutput></td>
            <cfset gun = gun +1>
          </cfloop>
        </tr>
        <cfloop index=y from=2 to=6>
          <tr>
            <cfloop index=x from=1 to=7>
              <cfif gun LTE son>
                <td class="tableyazi"><cfoutput><A class="tableyazi" href="#yer#&yil=#yil#&ay=#ay#&gun=#gun#">#gun#</a></cfoutput></td>
                <cfelse>
                <td class="tableyazi">&nbsp;</td>
              </cfif>
              <cfset gun = gun +1>
            </cfloop>
          </tr>
        </cfloop>
      </cf_grid_list>
    
