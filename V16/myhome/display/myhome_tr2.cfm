<cfquery name="get_buy_sell" datasource="#DSN#">
	SELECT 
		MY_BUYERS, 
		MY_SELLERS, 
		REPORT, 
		MY_VALIDS 
	FROM 
		MY_SETTINGS 
	WHERE 
		EMPLOYEE_ID = #SESSION.EP.USERID#
</cfquery>
<cfoutput>
  <cfswitch expression="#session.ep.design_id#">
    <!--- Tasarm ablonu id si 2--->
    <cfcase value="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="27" background="/images/tas2/altarka.jpg">
        <tr>
            <td>
                <table  border="0" cellpadding="0" cellspacing="0">
                    <tr>
                    <cfif not listfindnocase(denied_pages,'myhome.myhome')>
                        <td>&nbsp;<a href="#request.self#?fuseaction=myhome.myhome" class="altbarheader"><cf_get_lang dictionary_id='57413.gundem'></a>&nbsp;</td>
                    </cfif>
                    <cfif  not listfindnocase(denied_pages,'myhome.list_warnings')>
                        <td><a href="#request.self#?fuseaction=myhome.list_warnings" class="altbar"><cf_get_lang dictionary_id='30761.onaylarım'>-<cf_get_lang dictionary_id='30766.Uyarilarim'></a></td>
                    </cfif>	
                    <cfif ((get_buy_sell.my_buyers eq 1) or (get_buy_sell.my_sellers eq 1)) and not listfindnocase(denied_pages,'myhome.my_companies')>
                        <td><a href="#request.self#?fuseaction=myhome.my_companies" class="altbar"><cf_get_lang dictionary_id='31355.Üyelerim'></a></td>
                    </cfif>
                    <cfif (get_buy_sell.report eq 1) and not listfindnocase(denied_pages,'myhome.my_reports')>
                        <td><a href="#request.self#?fuseaction=myhome.my_reports" class="altbar"><cf_get_lang dictionary_id='30764.raporlarım'></a></td>
                    </cfif>
                    <cfif  not listfindnocase(denied_pages,'myhome.time_cost')>
                        <td><a href="#request.self#?fuseaction=myhome.upd_myweek" class="altbar"><cf_get_lang dictionary_id='57563.ben'></a></td>
                    </cfif>
                    <cfif  not listfindnocase(denied_pages,'myhome.mysettings')>
                        <td><a href="#request.self#?fuseaction=myhome.list_mydesign" class="altbar"><cf_get_lang dictionary_id='57430.ayarlarım'></a></td>
                    </cfif>
                    </tr>
                </table>
            </td>
        <td  style="text-align:right;"><cfinclude template="../../objects/display/favourites.cfm"></td>
        </tr>
    </table>
    </cfcase>
	<cfcase value="3,4,5,6">
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="27">
            <tr class="color-list">
                <td>
					<cfif not listfindnocase(denied_pages,'myhome.myhome')>
                        &nbsp;<a href="#request.self#?fuseaction=myhome.myhome" class="titlebold"><cf_get_lang dictionary_id='57413.gundem'></a>&nbsp;
                    </cfif>	
                    <cfif  not listfindnocase(denied_pages,'myhome.list_warnings')>
                        <a href="#request.self#?fuseaction=myhome.list_warnings" class="txtsubmenu"><cf_get_lang dictionary_id='30761.onaylarım'>-<cf_get_lang dictionary_id='30766.Uyarilarim'></a> :
                    </cfif>			  
                    <cfif ((get_buy_sell.my_buyers eq 1) or (get_buy_sell.my_sellers eq 1)) and not listfindnocase(denied_pages,'myhome.my_companies')>
                        <a href="#request.self#?fuseaction=myhome.my_companies" class="txtsubmenu"><cf_get_lang dictionary_id='31355.Üyelerim'></a> :
                    </cfif>
                    <cfif get_buy_sell.report eq 1 and not listfindnocase(denied_pages,'myhome.my_reports')>
                        <a href="#request.self#?fuseaction=myhome.my_reports" class="txtsubmenu"><cf_get_lang dictionary_id='30764.raporlarım'></a> :
                    </cfif>
                    <cfif  not listfindnocase(denied_pages,'myhome.time_cost')>
                        <a href="#request.self#?fuseaction=myhome.upd_myweek" class="txtsubmenu"><cf_get_lang dictionary_id='57563.ben'></a> :
                    </cfif>
                    <cfif  not listfindnocase(denied_pages,'myhome.mysettings')>
                        <a href="#request.self#?fuseaction=myhome.list_mydesign" class="txtsubmenu"><cf_get_lang dictionary_id='57430.ayarlarım'></a>
                    </cfif>
                  </td>
              <td  style="text-align:right;"><cfinclude template="../../objects/display/favourites.cfm"></td>
            </tr>
        </table>
</cfcase>
<cfcase value="1">
<table width="100%" border="0" cellspacing="0" cellpadding="0" background="/images/top22back.gif" height="27">
    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
					<cfif  not listfindnocase(denied_pages,'myhome.myhome')>
                        <td align="center"><a href="#request.self#?fuseaction=myhome.myhome" class="topheader"><cf_get_lang dictionary_id='57413.gundem'></a></td>
                    </cfif>
                    <cfif  not listfindnocase(denied_pages,'myhome.list_warnings')>
                        <td><img src="/images/button/sol.gif"></td>
                        <td background="/images/button/back.gif"><a href="#request.self#?fuseaction=myhome.list_warnings" class="top2"><cf_get_lang dictionary_id='30761.onaylarım'>-<cf_get_lang dictionary_id='30766.Uyarilarim'></a></td>
                        <td><img src="/images/button/sag.gif"></td>
                    </cfif>			  
                    <cfif ((get_buy_sell.my_buyers eq 1) or (get_buy_sell.my_sellers eq 1)) and not listfindnocase(denied_pages,'myhome.my_companies')>
                        <td><img src="/images/button/sol.gif"></td>
                        <td background="/images/button/back.gif"><a href="#request.self#?fuseaction=myhome.my_companies" class="top2"><cf_get_lang dictionary_id='31355.Üyelerim'></a></td>
                        <td><img src="/images/button/sag.gif"></td>
                    </cfif>
                    <cfif get_buy_sell.report eq 1 and not listfindnocase(denied_pages,'myhome.my_reports')>
                        <td><img src="/images/button/sol.gif"></td>
                        <td background="/images/button/back.gif"><a href="#request.self#?fuseaction=myhome.my_reports" class="top2"><cf_get_lang dictionary_id='30764.raporlarım'></a></td>
                        <td><img src="/images/button/sag.gif"></td>
                    </cfif>
                    <cfif  not listfindnocase(denied_pages,'myhome.time_cost')>
                        <td><img src="/images/button/sol.gif"></td>
                        <td background="/images/button/back.gif"><a href="#request.self#?fuseaction=myhome.upd_myweek" class="top2"><cf_get_lang dictionary_id='57563.ben'></a></td>
                        <td><img src="/images/button/sag.gif"></td>
                    </cfif>
                    <cfif  not listfindnocase(denied_pages,'myhome.mysettings')>
                        <td><img src="/images/button/sol.gif"></td>
                        <td background="/images/button/back.gif"><a href="#request.self#?fuseaction=myhome.list_mydesign" class="top2"><cf_get_lang dictionary_id='57430.ayarlarım'></a></td>
                        <td><img src="/images/button/sag.gif"></td>
                    </cfif>
                </tr>
            </table>
        </td>
    <td  valign="middle" style="text-align:right;"><cfinclude template="../../objects/display/favourites.cfm"></td>
    </tr>
	</table>
	</cfcase>
</cfswitch>
</cfoutput>
