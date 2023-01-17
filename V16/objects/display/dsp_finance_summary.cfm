<!--- Sirketin Borc alacak durumunu ve dovizli bakiyelerini gosterir ,company_id gonderilir --->
<cf_xml_page_edit fuseact="member.detail_company">
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border">
	<tr class="color-header">
	  <td align="center" class="form-title" height="22" style="cursor:pointer;" onClick="gizle_goster(ozet);"><cf_get_lang dictionary_id ='58085.Finansal Özet'></td>
	</tr>
	<cfif isdefined("url.cpid") and len(url.cpid)>
		<cfquery name="GET_REMAINDER" datasource="#dsn2#">
			SELECT * FROM COMPANY_REMAINDER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cpid#">
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
				COMPANY_ID=#URL.CPID#
		</cfquery>
	<cfelseif isdefined("url.cid") and len(url.cid)> 
		<cfquery name="GET_REMAINDER" datasource="#dsn2#">
			SELECT * FROM CONSUMER_REMAINDER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#">
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
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#">
		</cfquery>
	</cfif>
	<cfif get_remainder.recordcount>
	  <cfset borc = get_remainder.borc>
	  <cfset alacak = get_remainder.alacak>
	  <cfset bakiye = get_remainder.bakiye>
	<cfelse>
	  <cfset borc = 0>
	  <cfset alacak = 0>
	  <cfset bakiye = 0>
	</cfif>
	<tr id="ozet">
		<td class="color-row" align="center">
		<table width="100%" class="color-header" cellpadding="2" cellspacing="1">
		<cfoutput>
			<tr class="color-row">
				<td align="center" width="40"><cf_get_lang dictionary_id='57587.Borç'>: </td ><td style="text-align:right">#TLFormat(ABS(borc))#&nbsp;#session.ep.money#</td><td width="15"></td>
			</tr>
			<tr class="color-row">
				<td align="center"><cf_get_lang dictionary_id='57588.Alacak'>: </td ><td style="text-align:right">#TLFormat(ABS(alacak))#&nbsp;#session.ep.money# <br/></td><td></td>
			</tr>
			<tr class="color-row">
				<td align="center"><cf_get_lang dictionary_id='57589.Bakiye'>: </td><td style="text-align:right">#TLFormat(abs(bakiye))#&nbsp;#session.ep.money# </td><td><cfif borc gte alacak>(B)<cfelse>(A)</cfif></td>
			</tr>
		</cfoutput>
		</table>
		<cfif (isdefined("is_finance_summary_money") and is_finance_summary_money eq 1) or not isdefined("is_finance_summary_money")><!--- xml den dövizli özet --->
			<table>
				<tr>
					<td align="center" class="txtbold"><cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57589.Bakiye'></td>
				</tr>
			<cfoutput query="get_remainder_money">
                <tr>
                    <td class="color-row" align="center">
                        #TLFormat(abs(bakiye3))#&nbsp;#other_money# <cfif borc3 gte alacak3>(B)<cfelse>(A)</cfif>
                    </td>
                </tr>
            </cfoutput>          
			</table>
		</cfif>
		</td>
	</tr> 
</table>
<cfset borc = 0>
<cfset alacak = 0>
<cfset bakiye = 0>
