<!--- Şirketin Borç alacak durumunu ve dövizli bakiyelerini gösterir ,company_id gönderilir --->
<cfsetting showdebugoutput="no">
<cfif isdefined("url.cpid") and len(url.cpid)>
	<cfquery name="GET_REMAINDER" datasource="#dsn2#">
		SELECT BORC,ALACAK,BAKIYE FROM COMPANY_REMAINDER WHERE COMPANY_ID=#URL.CPID#
	</cfquery>
	<cfquery name="GET_REMAINDER_MONEY" datasource="#dsn2#">
		SELECT
			BORC3,
			ALACAK3,
			BAKIYE3,
			OTHER_MONEY
		FROM
			COMPANY_REMAINDER_MONEY
		WHERE 
			COMPANY_ID = #URL.CPID#
	</cfquery>
<cfelseif isdefined("url.cid") and len(url.cid)> 
	<cfquery name="GET_REMAINDER" datasource="#dsn2#">
		SELECT BORC,ALACAK,BAKIYE FROM CONSUMER_REMAINDER WHERE CONSUMER_ID=#URL.CID#
	</cfquery>
	<cfquery name="GET_REMAINDER_MONEY" datasource="#dsn2#">
		SELECT
			BORC3,
			ALACAK3,
			BAKIYE3,
			OTHER_MONEY
		FROM
			CONSUMER_REMAINDER_MONEY
		WHERE 
			CONSUMER_ID=#URL.CID#
	</cfquery>
</cfif>
<cfif (get_remainder.recordcount)>
  <cfset borc = get_remainder.borc>
  <cfset alacak = get_remainder.alacak>
  <cfset bakiye = get_remainder.bakiye>
<cfelse>
  <cfset borc = 0>
  <cfset alacak = 0>
  <cfset bakiye = 0>
</cfif>
<table class="ajax_list">
	<cfoutput>
    <tbody>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='57587.Borç'></td><td>: #TLFormat(ABS(borc))#&nbsp;#session.ep.money#</td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='57588.Alacak'></td><td>: #TLFormat(ABS(alacak))#&nbsp;#session.ep.money#</td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='57589.Bakiye'></td><td>: #TLFormat(abs(bakiye))#&nbsp;#session.ep.money# <cfif borc gte alacak>(B)<cfelse>(A)</cfif></td>
        </tr>
    </tbody>
    </cfoutput>
    <cfif get_remainder_money.recordcount and not ListContains(http.host,"pronet",".")><!--- add_options include function ı yapılana kadar geçici pronete dövizli bakiyeler gelmesin diye yapıldı..Aysenur20070719 --->
        <tfoot>
            <tr height="20">
                <td colspan="2">
                    <b><cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57589.Bakiye'></b>
                    <cfoutput query="get_remainder_money">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #TLFormat(abs(bakiye3))#&nbsp;#other_money# <cfif borc3 gte alacak3>(B)<cfelse>(A)</cfif>
                    </cfoutput> 
                </td>
            </tr>
        </tfoot>   
	</cfif>
</table>
<cfset borc = 0>
<cfset alacak = 0>
<cfset bakiye = 0>
