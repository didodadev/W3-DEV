<cfset attributes.style=1>
<cfif is_dsp_photo_right eq 1>
<!--- Fotoğraf --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id="30243.Fotoğraf"></cfsavecontent>
<cf_box 
	id="photo" 
    collapsed="#iif(attributes.style,1,0)#" 
    closable="0"  
    title="#message#" 
	box_page="#request.self#?fuseaction=#fusebox.circuit#.upd_consumer_photo_ajax&cid=#attributes.cid#"> 
</cf_box>
</cfif>
<!--- Finansal Ozet--->
<cfif get_module_user(16) and (get_consumer.consumer_status is 1) and not(get_consumer.ispotantial is 1)>
	<cfif isdefined("attributes.cid")>
        <cf_get_workcube_finance_summary action_id_2="#attributes.cid#" style="1">
   <cfelseif isdefined("attributes.cpid")>
        <cf_get_workcube_finance_summary action_id="#attributes.cpid#" style="1">
   </cfif>
</cfif>
<!--- Bireysel Üye Ekibi FB 20070530--->
<cfif is_dsp_member_team_right eq 1>
	<cfif isdefined("attributes.cid")>
        <cf_get_workcube_company_member_team action_id_2="#attributes.cid#" style="1">
    <cfelseif isdefined("attributes.cpid")>
        <cf_get_workcube_company_member_team action_id="#attributes.cpid#" style="1">
    </cfif>
</cfif>

<!--- Sube Iliskisi --->
<cfif is_dsp_related_branch_right eq 1>
	<cfif isdefined("attributes.cid")>
        <cf_get_workcube_member_branch action_id_2="#attributes.cid#" style="1">
   <cfelseif isdefined("attributes.cpid")>
        <cf_get_workcube_member_branch action_id="#attributes.cpid#" style="1">
   </cfif>
</cfif>

<!--- Notlar --->
<cf_get_workcube_note action_section='CONSUMER_ID' action_id='#attributes.cid#'>

<!--- Belgeler --->
<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-9" module_id='4' action_section='CONSUMER_ID' action_id='#attributes.cid#'>

<cfif get_module_power_user(12) or get_module_power_user(19) or get_module_power_user(22) or get_module_power_user(23) or get_module_power_user(25) >
	<!--- Banka Hesaplari --->
	<cfset kontrol_cc_bank = 0>
	<cfif (isdefined("is_credit_bank_kontrol") and is_credit_bank_kontrol eq 1) or not isdefined("is_credit_bank_kontrol")>
		<cfif get_module_user(16)>
			<cfset kontrol_cc_bank = 1>
		</cfif>
	<cfelseif isdefined("is_credit_bank_kontrol") and is_credit_bank_kontrol eq 0>
		<cfset kontrol_cc_bank = 1>
	</cfif>
	<cfif kontrol_cc_bank eq 1>
		<cf_get_workcube_bank_account action_type='CONSUMER' action_id="#attributes.cid#">
	</cfif>

	<!--- Kredi Kartları --->
	<cfif kontrol_cc_bank eq 1>
		<cf_get_workcube_list_credit_cards action_id_2 ='#attributes.cid#' style='0' design='0'>
	</cfif>
</cfif>

<!--- Analiz --->
<cf_get_member_analysis action_type='MEMBER' consumer_id='#attributes.cid#'>
<cfset attributes.style=1>
<cfset attributes.style1=1>
<!--- Yetkili olduğu b2bc leri getirir. --->
<cf_get_workcube_domain action_type='CONSUMER' action_id='#attributes.cid#'>
	
<cf_box id="get_related" collapsed="#iif(attributes.style1,1,0)#" closable="0"  title="#getLang('main',1617)#"
	box_page="#request.self#?fuseaction=#fusebox.circuit#.popupajax_related_associations&cid=#attributes.cid#">
</cf_box>
<!--- SOSYAL MEDYA --->
<cf_workcube_social_media action_type='CONSUMER_ID' action_type_id ='#attributes.cid#'>
<!--- Kart No Bilgileri --->
<cfif is_dsp_card_no_info eq 1>
	 <cfif isdefined('attributes.cid')>
    	<cf_get_workcube_list_customer_cards action_type="CONSUMER_ID" action_id="#attributes.cid#">
	<cfelseif isdefined('attributes.pid')>
    	<cf_get_workcube_list_customer_cards action_type="PARTNER_ID" action_id="#attributes.pid#">
	</cfif>
</cfif>
