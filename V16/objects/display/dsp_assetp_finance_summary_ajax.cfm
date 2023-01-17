<!--- Fiziki varligin Borc alacak durumunu ve dovizli bakiyelerini gosterir ,assetp_id gonderilir FA--->
<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
	<cfquery name="get_remainder" datasource="#dsn2#">
		SELECT
			SUM(BORC-ALACAK) BAKIYE,
			SUM(BORC) BORC,
			SUM(ALACAK) ALACAK,
			ASSETP_ID
		FROM
		(
			SELECT
				ACTION_VALUE BORC,
				0 ALACAK,
				ASSETP_ID
			FROM
				CARI_ROWS
			WHERE
				(TO_CMP_ID IS NOT NULL OR TO_CONSUMER_ID IS NOT NULL OR TO_EMPLOYEE_ID IS NOT NULL)
				AND ASSETP_ID = #attributes.assetp_id#
			UNION ALL
			SELECT
				0 BORC,
				ACTION_VALUE ALACAK,
				ASSETP_ID
			FROM
				CARI_ROWS
			WHERE
				(FROM_CMP_ID IS NOT NULL OR FROM_CONSUMER_ID IS NOT NULL OR FROM_EMPLOYEE_ID IS NOT NULL)
				AND ASSETP_ID = #attributes.assetp_id#
		)T1
		GROUP BY
		ASSETP_ID
	</cfquery>
	<cfquery name="get_remainder_money" datasource="#dsn2#">
		SELECT
			SUM(BORC-ALACAK) BAKIYE,
			SUM(BORC) BORC,
			SUM(ALACAK) ALACAK,
			ASSETP_ID,
			OTHER_MONEY
		FROM
		(
			SELECT
				OTHER_CASH_ACT_VALUE BORC,
				0 ALACAK,
				ASSETP_ID,
				OTHER_MONEY
			FROM
				CARI_ROWS
			WHERE
				(TO_CMP_ID IS NOT NULL OR TO_CONSUMER_ID IS NOT NULL OR TO_EMPLOYEE_ID IS NOT NULL)
				AND ASSETP_ID = #attributes.assetp_id#
			UNION ALL
				SELECT
				0 BORC,
				OTHER_CASH_ACT_VALUE ALACAK,
				ASSETP_ID,
				OTHER_MONEY
			FROM
				CARI_ROWS
			WHERE
				(FROM_CMP_ID IS NOT NULL OR FROM_CONSUMER_ID IS NOT NULL OR FROM_EMPLOYEE_ID IS NOT NULL)
				AND ASSETP_ID = #attributes.assetp_id#
			)T1
		GROUP BY
			ASSETP_ID,
			OTHER_MONEY
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

<table>
    <cfoutput>
    <tr>
        <td class="color-row" align="center"> <cf_get_lang dictionary_id='57587.Borç'>: #TLFormat(ABS(borc))#&nbsp;#session.ep.money#</td>
    </tr>
    <tr>
        <td class="color-row" align="center"><cf_get_lang dictionary_id='57588.Alacak'>: #TLFormat(ABS(alacak))#&nbsp;#session.ep.money# <br/></td>
    </tr>
    <tr>
        <td class="color-row" align="center"><cf_get_lang dictionary_id='57589.Bakiye'>: #TLFormat(abs(bakiye))#&nbsp;#session.ep.money# <cfif borc gte alacak>(B)<cfelse>(A)</cfif></td>
    </tr>
    </cfoutput>
</table>
<cfif get_remainder_money.recordcount>
  <table>
    <tr>
        <td align="center" class="txtbold"><cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57589.Bakiye'></td>
    </tr>
    <cfoutput query="get_remainder_money">
        <tr>
            <td class="color-row" align="center">
                 #TLFormat(abs(get_remainder_money.bakiye))#&nbsp;#get_remainder_money.other_money# <cfif get_remainder_money.borc gte get_remainder_money.alacak>(B)<cfelse>(A)</cfif>
            </td>
        </tr>
    </cfoutput>          
    </table>
</cfif>
<cfset borc = 0>
<cfset alacak = 0>
<cfset bakiye = 0>
