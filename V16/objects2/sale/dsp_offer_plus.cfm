<cfquery name="GET_OFFER_PLUS" datasource="#DSN3#">
	SELECT
		SUBJECT
	FROM
		OFFER_PLUS
	WHERE
		OFFER_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_plus_id#">
</cfquery>

<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%; height:100%;">
  	<tr class="color-list" style="height:35px;">
		<td>
	 		<table style="width:100%;">
	 			<tr>
                    <td class="headbold"><cfif isdefined("get_offer_plus.subject")><cfoutput>#get_offer_plus.subject#</cfoutput></cfif></td>
                    <td align="right" style="text-align:right;"><cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_form_add_offer_plus&offer_plus_id=#offer_plus_id#','medium');" class="tableyazi"><img src="/images/reply.gif" border="0" title="<cf_get_lang_main no='1242.Cevap'>"></a></cfoutput></td>
				</tr>
	 		</table>
		</td>
  	</tr>
  	<tr class="color-row">
		<td style="vertical-align:top;"><cfoutput>#get_offer_plus.plus_content#</cfoutput></td>
  	</tr>
</table>
