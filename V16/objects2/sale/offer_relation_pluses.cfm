<cfquery name="GET_OFFER" datasource="#DSN3#">
	SELECT 
		CONSUMER_ID,
		PARTNER_ID,
		EMPLOYEE_ID,
		COMPANY_ID,
		OFFER_TO_PARTNER,
		OFFER_HEAD,
		PROJECT_ID 
	FROM 
		OFFER 
	WHERE 
		OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>

<cfif len(get_offer.consumer_id)>
  	<cfset contact_type = "c">
  	<cfset contact_id = get_offer.consumer_id>
<cfelseif len(get_offer.partner_id)>
  	<cfset contact_type = "p">
  	<cfset contact_id = get_offer.partner_id>
<cfelseif len(get_offer.company_id)>
  	<cfset contact_type = "comp">
  	<cfset contact_id = get_offer.company_id>
<cfelseif len(get_offer.employee_id)>
  	<cfset contact_type = "e">
  	<cfset contact_id = get_offer.employee_id>
<cfelseif len(listsort(get_offer.offer_to_partner,"numeric"))>
  	<cfset contact_type = "p">
  	<cfset contact_id = listfirst(listsort(get_offer.offer_to_partner,"numeric"))>
</cfif>
<form name="upd_offer_product">
	<input type="hidden" name="offer_head" id="offer_head" value="<cfoutput>#get_offer.offer_head#</cfoutput>">
</form>
<cfinclude template="../../objects/query/get_account_simple.cfm">
<cfquery name="GET_OFFER_PLUSES" datasource="#DSN3#">
	SELECT
		*
	FROM
		OFFER_PLUS
	WHERE
		OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>

<table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
 	<cfif get_offer_pluses.recordcount>
		<cfoutput query="get_offer_pluses">
            <tr style="height:22px;">
                <td>
                	<li>
                		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_dsp_offer_plus&offer_plus_id=#offer_plus_id#','medium');" class="tableyazi">
                        <cfif len(subject)>#subject#<cfelse><cf_get_lang_main no='68.Baslik'></cfif>
                    	</a>
                    </li>
                </td>
                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_form_add_offer_plus&offer_plus_id=#offer_plus_id#&offer_id=#offer_id#&header=upd_offer_product.offer_head&contact_mail=#get_account_simple.email#&contact_person=#get_account_simple.name# #get_account_simple.surname#','medium');"><img src="/images/reply.gif" border="0" title="Cevap Ver"></a></td>
            </tr>
		</cfoutput>
  	<cfelse>
		<tr style="height:20px;"> 
			<td><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
		</tr>
	</cfif>
</table>

