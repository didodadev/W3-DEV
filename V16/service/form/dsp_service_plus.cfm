<cfquery name="get_service_detail" datasource="#dsn3#">
	SELECT * FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cfinclude template="../query/get_service_plus.cfm">
<cfset adres_ = "#request.self#?fuseaction=objects.popup_add_pursuits_documents_plus&action_id=#attributes.id#&header=upd_service.service_head&contact_person=#get_service_detail.applicator_name#">
<cfif len(get_service_detail.service_consumer_id)>
	<cfset adres_ = adres_ & "&consumer_id=#get_service_detail.service_consumer_id#">
<cfelseif len(get_service_detail.service_partner_id)>
	<cfset adres_ = adres_ & "&partner_id=#get_service_detail.service_partner_id#">
</cfif>
<cfset adres_ = adres_ & "&pursuit_type=is_service_application">
<cfoutput query="get_service_plus">
    <div class="ui-info-text padding-left-10">
        <p><b>#subject#</b></p>
        <p>#plus_content#</p>
    </div>
    <div class="ui-info-bottom flex-end" style="align-items:center">
        <div class="col col-10 col-xs-12 padding-0">  
            <p>
                <b><cf_get_lang dictionary_id='57483.Kayıt'></b>: #dateformat(plus_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#
            </p>
        </div>
        <cfif not listfindnocase(denied_pages,'call.popup_upd_service_plus')>
          <div class="col col-2 col-xs-12">  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_pursuits_documents_plus&action_plus_id=#service_plus_id#&pursuit_type=is_service_application','medium');" class="pull-right ui-wrk-btn ui-wrk-btn-success"><cf_get_lang dictionary_id='57464.Güncelle'></a></div>
        </cfif>
    </div>
</cfoutput>
