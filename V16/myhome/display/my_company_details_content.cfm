<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT
		CP.COUNTRY COUNTRY_ID,
        CONCAT( CP.MOBIL_CODE, '', CP.MOBILTEL ) MOBILS,
		CONCAT(CP.COMPANY_PARTNER_TELCODE, '', CP.COMPANY_PARTNER_TEL) AS TELS,
		*
	FROM 
		COMPANY_PARTNER CP, 
		COMPANY C
	WHERE 
		<cfif isdefined("is_only_active_partners") and is_only_active_partners eq 1>
			CP.COMPANY_PARTNER_STATUS = 1 AND
		</cfif>
		CP.COMPANY_ID = #attributes.cpid# AND 
		CP.COMPANY_ID = C.COMPANY_ID
	ORDER BY
		CP.COMPANY_PARTNER_NAME
</cfquery>
<cfset list_partner=ValueList(get_partner.partner_id,',')>
<cfset list_mobils=ValueList(get_partner.MOBILS,',')>
<cfset list_tels=ValueList(get_partner.TELS,',')>

<!--- Detaylar --->
<div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
    <cf_box id="company_detail" closable="0" collapsable="0" title="#get_par_info(get_company.MANAGER_PARTNER_ID,0,-1,0)#">
        <cfinclude template="my_company_detail.cfm">
    </cf_box>
    <cf_box  id="cdrs" closable="0"  collapsable="0" title="#getlang('','Arama Kayıtları','62637')#" widget_load="cdrs&fuseact=call.list_callcenter&tels=#get_company.company_telcode##get_company.company_tel1#,#get_company.company_tel2#,#get_company.company_tel3#,#get_company.mobil_code##get_company.mobiltel#,#list_tels#,#list_mobils#"></cf_box>
</div>
<!---Kontak Kişiler--->
<div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
    <!---<cfinclude template="my_company_partner_detail.cfm">--->
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='31385.Kontak Kişiler'></cfsavecontent>
    <cf_box
        id="kontak_"
        closable="0"
        add_href="#request.self#?fuseaction=member.list_contact&event=add&comp_cat=#GET_COMPANY.COMPANYCAT_ID#&compid=#attributes.cpid#"
        box_page="#request.self#?fuseaction=myhome.my_company_partner_detail&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#&startrow=#attributes.startrow#"
        unload_body="1"
        title="#title#">
    </cf_box>
</div>

<!---Şubeler--->
<div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
    <!---<cfinclude template="my_company_address_detail.cfm">--->
    <cfsavecontent variable="title"><cf_get_lang dictionary_id="29434.Şubeler"></cfsavecontent>
    <cf_box
        id="addres_detail"
        closable="0"
        box_page="#request.self#?fuseaction=myhome.my_company_address_detail&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#&startrow=#attributes.startrow#"
        unload_body="1"
        title="#title#">
    </cf_box>
</div>

<!--- notlar --->
<div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='57422.Notlar'></cfsavecontent>
    <cf_box
        id="box_notes"
        closable="0"
        add_href="#request.self#?fuseaction=objects.popup_form_add_note&action=company_id&action_id=#attributes.cpid#&is_special=0&action_type=0"
        box_page="#request.self#?fuseaction=myhome.popupajax_my_company_notes&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
        unload_body="1"
        title="#title#">
    </cf_box>
</div>

<!--- Etkilesimler --->
<cfif isdefined('etkilesim') and etkilesim eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58729.Etkileşimler'></cfsavecontent>
        <cf_box
            id="box_help"
            closable="0"
            add_href="#request.self#?fuseaction=call.helpdesk&event=add&partner_id=#get_company.manager_partner_id#&member_type=partner"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_helps&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>
    
<!--- Kampanyalar --->
<cfif isdefined('kampanya') and kampanya eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='31098.Kampanyalar'></cfsavecontent>
        <cf_box
            id="box_campaign"
            closable="0"
            add_href="#request.self#?fuseaction=campaign.list_campaign&event=add&cid=#attributes.cpid#&member_type=company"
            box_page="#request.self#?fuseaction=myhome.popupajax_sending_member_campaings&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#&list_partner=#list_partner#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>
<!--- Yazismalar --->
<cfif isdefined('yazisma') and yazisma eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id ='57459.Yazışmalar'></cfsavecontent>
        <cf_box
            id="box_correspondence"
            closable="0"
            body_style="overflow:visible;"
            add_href="#request.self#?fuseaction=correspondence.list_correspondence&event=add&cpid=#get_company.manager_partner_id#&member_type=company"
            box_page="#request.self#?fuseaction=myhome.popupajax_partner_correspondence&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#&list_partner=#list_partner#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>

<!---  Eğitimler --->
<cfif isdefined('eğitim') and eğitim eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='29912.Eğitimler'></cfsavecontent>
        <cf_box
            id="box_learnings"
            closable="0"
            box_page="#request.self#?fuseaction=myhome.popupajax_member_learnings&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>


<!---  Etkinlikler --->
<cfif isdefined('etkinlik') and etkinlik eq 1>
	<div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
            <cfsavecontent variable="title"><cf_get_lang dictionary_id='49713.Etkinlikler'></cfsavecontent>
            <cf_box
                id="box_organizations"
                closable="0"
                box_page="#request.self#?fuseaction=myhome.popupajax_member_organizations&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
                unload_body="1"
                title="#title#">
            </cf_box>
    </div>
</cfif>

<!--- toplantı-ziyaretler --->
<cfif isdefined('visit') and visit eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='31374.Toplantılar/Ziyaretler'></cfsavecontent>
        <cfset infoLink = "">
        <cfset addLink = "">
        <cfsavecontent variable="infoLink">
            <!--- yetkili yoksa toplanti ziyaret ekleme ikonu cikmasin ---> 
            <cfif Len(get_company.manager_partner_id)>
                <cfif get_module_user(6)>
                    <cfoutput>#request.self#?fuseaction=agenda.view_daily&event=add&partner_id=#get_company.manager_partner_id#&member_type=partner</cfoutput>
                </cfif>
            </cfif>
        </cfsavecontent>
        <cfsavecontent variable="addLink">
                <cfif get_module_user(12)>
                    <cfoutput>#request.self#?fuseaction=sales.list_visit&event=add&partner_id=#get_company.manager_partner_id#&member_type=partner</cfoutput>
                </cfif>
            </cfsavecontent>
        <cf_box
            id="box_visits"
            closable="0"
            add_href_2="#infoLink#"
            add_href="#addLink#"
            add_href_2_title="#getLang('','Ajanda Olay Ekle',63210)#"
            info_title="#getLang('','Ziyaret Ekle',51645)#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_events&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#&list_partner=#list_partner#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>
<!--- fırsatlar --->
<cfif isdefined('firsat') and firsat eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58694.Fırsatlar'></cfsavecontent>
    
        <cfsavecontent variable="infoLink">
            <cfif get_module_user(11)>
                <cfoutput>#request.self#?fuseaction=sales.list_opportunity&event=add&cpid=#attributes.cpid#&member_id=#get_company.manager_partner_id#&member_type=partner</cfoutput>
            </cfif>
        </cfsavecontent>
        <cf_box
            id="box_opportunities"
            closable="0"
            add_href="#infoLink#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_opportunities&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>

<!--- teklifler --->
<cfif isdefined('teklif') and teklif eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='31104.Teklifler'></cfsavecontent>
    
        <cfset infoLink = "">
        <cfset addLink = "">
        <cfif get_company.company_status eq 1>
            <cfsavecontent variable="infoLink">
                <cfif get_module_user(11)>
                    <cfoutput>#request.self#?fuseaction=sales.list_offer&event=add&member_type=partner&company_id=#attributes.cpid#&partner_id=#get_company.manager_partner_id#</cfoutput>
                </cfif>
            </cfsavecontent>
    
            <cfsavecontent variable="addLink">
                <cfif get_module_user(12)>
                    <cfoutput>#request.self#?fuseaction=purchase.list_offer&event=add&member_id=#get_company.manager_partner_id#</cfoutput>
                </cfif>
            </cfsavecontent>
        </cfif>
        <cf_box
            id="box_offers"
            closable="0"
            add_href_2="#infoLink#"
            add_href="#addLink#"
            add_href_2_title="#getLang('','Satış Teklifleri',30007)#"
            info_title="#getLang('','Satın Alma Teklifleri',64553)#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_offers&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>
<!--- siparisler --->    
<cfif isdefined('siparis') and siparis eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='31106.Siparişler'></cfsavecontent>
    
        <cfif get_company.company_status eq 1>
            <cfset infoLink = "">
            <cfset addLink = "">
            <cfset new_link_ = "">
            <cfquery name="get_company_credit" datasource="#dsn#">
                SELECT SHIP_METHOD_ID FROM COMPANY_CREDIT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
            </cfquery>
            <!--- risk bilgileri mevcut ise siparis eklediginde secili gelmesi icin eklendi --->
            <cfif get_company_credit.recordcount>
                <cfif Len(get_company_credit.ship_method_id)>
                    <cfset new_link_ = "#new_link_#&ship_method_id=#get_company_credit.ship_method_id#">
                </cfif>
            </cfif>
            <cfsavecontent variable="infoLink">
                <cfif get_module_user(11)>
                    <cfoutput>#request.self#?fuseaction=sales.list_order&event=add&company_id=#attributes.cpid#&partner_id=#get_company.manager_partner_id#&member_id=#get_company.manager_partner_id#&member_type=partner#new_link_#</cfoutput>
                </cfif>
            </cfsavecontent>
    
            <cfsavecontent variable="addLink">
                <cfif get_module_user(12)>
                    <cfoutput>#request.self#?fuseaction=purchase.list_order&event=add&company_id=#attributes.cpid#&partner_id=#get_company.manager_partner_id#&member_id=#get_company.manager_partner_id#&member_type=partner#new_link_#</cfoutput>
                </cfif>
            </cfsavecontent>
        </cfif>
        <cf_box
            id="cons_orders"
            closable="0"
            add_href_2="#addLink#"
            add_href="#infoLink#"
            add_href_2_title="#getLang('','satın Alma Siparişleri',64554)#"
            info_title="#getLang('','Satış Siparişleri',64555)#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_orders&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>
<!--- taksitli satışlar --->
<cfif isdefined('taksit') and taksit eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58208.Taksitli Satışlar'></cfsavecontent>
    
        <cfsavecontent variable="infoLink">
            <cfif get_module_user(11)>
                <cfoutput>#request.self#?fuseaction=sales.list_order_instalment&event=add&company_id=#attributes.cpid#&partner_id=#get_company.manager_partner_id#&member_id=#get_company.manager_partner_id#&member_type=partner</cfoutput>
            </cfif>
        </cfsavecontent>
    
        <cf_box
            id="box_instalment_orders"
            closable="0"
            add_href="#infoLink#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_is_instalment_orders&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>
<!---Faturalar  --->
<cfif isdefined('is_invoice') and is_invoice eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58917.Faturalar'></cfsavecontent>
    
        <cfset infoLink = "">
        <cfset addLink = "">
        <cfif get_company.company_status eq 1>
            <cfsavecontent variable="infoLink">
                <cfif get_module_user(20)>
                    <cfoutput>#request.self#?fuseaction=invoice.form_add_bill&company_id=#attributes.cpid#&partner_id=#get_company.manager_partner_id#</cfoutput>
                </cfif>
            </cfsavecontent>
    
            <cfsavecontent variable="addLink">
                <cfif get_module_user(20)>
                    <cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase&company_id=#attributes.cpid#&partner_id=#get_company.manager_partner_id#</cfoutput>
                </cfif>
            </cfsavecontent>
        </cfif>
        <cf_box
            id="box_bill"
            closable="0"
            add_href_2="#infoLink#"
            add_href_2_title="#getLang('','satış faturası ekle',57016)#"
            add_href="#addLink#"
            info_title="#getLang('','alış faturası ekle',57015)#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_invoice&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>
<!--- servis basvuruları --->
<cfif isdefined('service') and service eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='30039.Servis Başvuruları'></cfsavecontent>
        <cfsavecontent variable="infoLink">
            <cfif get_module_user(14)>
                <cfoutput>#request.self#?fuseaction=service.list_service&event=add&company_id=#attributes.cpid#&member_id=#get_company.manager_partner_id#&member_type=partner</cfoutput>
            </cfif>
        </cfsavecontent>
        <cf_box
            id="box_services"
            closable="0"
            add_href="#infoLink#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_service&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>

<!--- call center basvuruları --->
<cfif isdefined('call_center') and call_center eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id ='58468.Call Center Başvuruları'></cfsavecontent>
    
        <cfsavecontent variable="infoLink">
            <cfif get_module_user(27)>
                <cfoutput>#request.self#?fuseaction=call.list_service&event=add&company_id=#attributes.cpid#&partner_id=#get_company.manager_partner_id#&member_id=#get_company.manager_partner_id#&member_type=partner</cfoutput>
            </cfif>
        </cfsavecontent>
        <cf_box
            id="box_call_services"
            closable="0"
            add_href="#infoLink#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_call_service&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>

<!--- sistemler --->
<cfif isdefined('system') and system eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58832.Abone'></cfsavecontent>
    
        <cfsavecontent variable="infoLink">
            <cfif get_module_user(11)>
                <cfoutput>#request.self#?fuseaction=sales.list_subscription_contract&event=add&company_id=#attributes.cpid#&partner_id=#GET_PARTNER.partner_id#&member_type=partner</cfoutput>
            </cfif>
        </cfsavecontent>
        <cf_box
            id="box_systems"
            closable="0"
            add_href="#infoLink#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_systems&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
   <!--- <div class="row" type="row">
        <div class="col col-12 uniqueRow" type="column" sort="false" index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
            <cfsavecontent variable="title"><cf_get_lang_main no='1420.Abone'><cf_get_lang_main no ='170.Ekle'></cfsavecontent>
            <cf_box
                id="box_add_systems"
                closable="0"
                box_page="#request.self#?fuseaction=member.popupajax_add_company_subscription&cpid=#attributes.cpid#&get_company.manager_partner_id=#get_company.manager_partner_id#"
                unload_body="1"
                title="#title#">
            </cf_box>
        </div>
	</div>--->
</cfif>
<!--- Icra Takip --->
<cfif isdefined('takip') and takip eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='31751.İcra Takip'></cfsavecontent>
        <cfsavecontent variable="infoLink">
            <cfif get_module_user(33)>
                <cfoutput>#request.self#?fuseaction=ch.list_law_request&event=add&company_id=#attributes.cpid#&member_type=partner</cfoutput>
            </cfif>
        </cfsavecontent>
        <cf_box
            id="box_law_requests"
            closable="0"
            add_href="#infoLink#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_law_request&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>
<!--- garantiler --->
<cfif isdefined('guaranty') and guaranty eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='32372.Garantili Ürünler'></cfsavecontent>
    
        <cfsavecontent variable="infoLink">
            <cfif get_module_user(33)>
                <cfoutput>#request.self#?fuseaction=service.list_guaranty&event=add&take=1</cfoutput>
            </cfif>
        </cfsavecontent>
        <cf_box
            id="box_waranties"
            closable="0"
            add_href="#infoLink#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_guaranties&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>

<!--- fiziki varlıklar --->
<!--- tekne kaydı yapıyor kaldırıyorum PY 0912--->
<!---<cfif isdefined('physical_assets') and physical_assets eq 1>
    <cfsavecontent variable="title"><cf_get_lang_main no='2207.Fiziki Varlıklar'></cfsavecontent>
    <cfsavecontent variable="infoLink">
        <cfif ListGetAt(session.ep.user_level, 33) and StructKeyExists(fusebox.circuits,'assetcare')>
            <cfoutput>#request.self#?fuseaction=assetcare.form_add_assetp</cfoutput>
        </cfif>
    </cfsavecontent>
    <cf_box
        id="box_physical_assets"
        closable="0"
        add_href="#infoLink#"
        box_page="#request.self#?fuseaction=member.popupajax_my_company_assets&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
        unload_body="1"
        title="#title#">
    </cf_box>
</cfif>--->
<!--- projeler --->


<cfif isdefined('project') and project eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58015.Projeler'></cfsavecontent>
    
        <cfsavecontent variable="infoLink">
            <cfif get_module_user(1)>
                <cfoutput>#request.self#?fuseaction=project.projects&event=add&company_id=#attributes.cpid#&partner_id=#get_company.manager_partner_id#&member_id=#get_company.manager_partner_id#&member_type=partner</cfoutput>
            </cfif>
        </cfsavecontent>
        <cf_box
            id="box_projects"
            closable="0"
            add_href="#infoLink#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_project_list&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>


<!--- isler --->
<cfif isdefined('works') and works eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
        <cfsavecontent variable="infoLink">
            <cfif get_module_user(1)>
                <cfoutput>#request.self#?fuseaction=project.works&event=add&company_id=#attributes.cpid#&partner_id=#get_company.manager_partner_id#&work_fuse=#attributes.fuseaction#</cfoutput>
            </cfif>
        </cfsavecontent>
        <cf_box
            id="box_works"
            closable="0"
            add_href="#infoLink#"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_works&cpid=#attributes.cpid#&maxrows=#attributes.maxrows#"
            unload_body="1"
            title="#title#">
        </cf_box>
    </div>
</cfif>
