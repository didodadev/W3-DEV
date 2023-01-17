<!--- Sirketin Borc alacak durumunu ve dovizli bakiyelerini gosterir ,company_id gonderilir --->
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfquery name="GET_REMAINDER" datasource="#DSN2#">
		SELECT * FROM COMPANY_REMAINDER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
	</cfquery>

	<cfquery name="GET_REMAINDER_MONEY" datasource="#DSN2#">
		SELECT
			BORC3,
			ALACAK3,
			BAKIYE3,
			OTHER_MONEY
		FROM
			COMPANY_REMAINDER_MONEY
		WHERE 
			COMPANY_ID=#attributes.action_id#
	</cfquery>
<cfelseif isdefined("attributes.action_id_2") and len(attributes.action_id_2)> 
	<cfquery name="GET_REMAINDER" datasource="#dsn2#">
		SELECT * FROM CONSUMER_REMAINDER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id_2#">
	</cfquery>
	<cfquery name="GET_REMAINDER_MONEY" datasource="#DSN2#">
		SELECT
			BORC3,
			ALACAK3,
			BAKIYE3,
			OTHER_MONEY
		FROM
			CONSUMER_REMAINDER_MONEY
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id_2#">
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
<cf_flat_list>
    <tbody>
        <cfoutput>
            <tr>
                <td><cf_get_lang dictionary_id='57587.Borç'>: </td>
                <td>#tlformat(ABS(borc))#&nbsp;#session.ep.money#</td>
                <td width="20"></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='57588.Alacak'>:</td>
                <td>#tlformat(ABS(alacak))#&nbsp;#session.ep.money# <br /></td>
                <td></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='57589.Bakiye'>:</td>
                <td>#tlformat(abs(bakiye))#&nbsp;#session.ep.money# </td>
                <td><cfif borc gte alacak>(B)<cfelse>(A)</cfif></td>
            </tr>
            <cfif (isdefined("is_finance_summary_money") and is_finance_summary_money eq 1) or not isdefined("is_finance_summary_money")><!--- xml den dövizli özet --->
                <tr>
                    <td colspan="3" class="txtbold"><cf_get_lang dictionary_id='57677.Döviz'> <cf_get_lang dictionary_id='57589.Bakiye'></td>
                </tr>
                <cfloop query="get_remainder_money">	
                    <tr>
                        <td colspan="3">
                            #TLFormat(abs(bakiye3))#&nbsp;#other_money# <cfif borc3 gte alacak3>(B)<cfelse>(A)</cfif>
                        </td>
                    </tr>
                </cfloop> 
            </cfif>
        </cfoutput>
    </tbody>
</cf_flat_list>
