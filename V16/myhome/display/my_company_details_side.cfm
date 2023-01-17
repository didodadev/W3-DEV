<!--- Finans yetkisi varsa ve şirket potansiyel değilse finansal özet geliyor --->

<cfif (get_company.ISPOTANTIAL eq 0) and get_module_user(16)>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id="58085.Finansal Özet"></cfsavecontent>
        <cf_box id="finance_summary" closable="0" box_page="#request.self#?fuseaction=objects.emptypopup_dsp_finance_summary_ajaxsummary&cpid=#url.cpid#" unload_body="1" title="#title#">
            <table>
                <tr>
                    <td id="_dsp_finance_summary_" colspan="2"></td>
                </tr> 
            </table>
        </cf_box>
    </div>
</cfif>
<!--- Varlıklar --->
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
		<cf_get_workcube_asset asset_cat_id="-9" module_id='4' action_section='COMPANY_ID' action_id='#attributes.cpid#'>
	</div>
	<!--- SOSYAL MEDYA --->
<cf_workcube_social_media action_type='COMPANY_ID' action_type_id ='#attributes.cpid#'>
<!--- Reservstions  sm kapattı 20120816
<cfif isdefined("reservations") and reservations eq 1>
	<cfif (get_company.ISPOTANTIAL eq 0) and listgetat(session.ep.user_level,11) and structkeyexists(fusebox.circuits,'sales')>
		<cf_box id="reservations" closable="0" box_page="#request.self#?fuseaction=sales.emptypopup_ws_reservation&company_id=#url.cpid#" unload_body="1" title="Rezervasyonlar">
			<table>
				<tr>
					<td id="_reservation_"></td>
				</tr>
			</table>
		</cf_box>
	</cfif>
</cfif>--->
<!--- Sayaclar sm kapattı 20120917
<cfif isdefined("counter") and counter eq 1>
	<cfif (get_company.ISPOTANTIAL eq 0) and listgetat(session.ep.user_level,11) and structkeyexists(fusebox.circuits,'sales')>
		<cf_box id="counters" closable="0" info_href="#request.self#?fuseaction=sales.popup_list_subscription_counter_invoice&cpid=#attributes.cpid#" add_href="#request.self#?fuseaction=sales.popup_add_subscription_counter&cpid=#attributes.cpid#" box_page="#request.self#?fuseaction=sales.emptypopup_list_subscription_counter&cpid=#url.cpid#" unload_body="1" title="Sayaçlar">
			<table>
				<tr>
					<td id="_counter_" colspan="2"></td>
				</tr>
			</table>
		</cf_box>
	</cfif>
</cfif> --->
<!--- MAXROWS
	<div class="col col-12" type="column" sort="false" index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfform action="#request.self#?fuseaction=call.list_callcenter&event=detCompany&cpid=#attributes.cpid#&partner_id=#attributes.partner_id#" method="post">
			<div class="form-group">
                <input name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>" type="hidden">
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <div class="col col-9 col-xs-12">
                	<div class="input-group x-3_5 pull-right">
                		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                	</div>
				</div>
                <div class="col col-3 col-xs-12"><cf_wrk_search_button is_excel="0"></div>
			</div>
        </cfform>
    </div>
--->
