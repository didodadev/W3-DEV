<cfif caller.attributes.fuseaction contains 'popup'>
    <style>
        ul#efatura_displayUl{
            overflow-x: hidden !important;
        }
        ul#efatura_displayUl li{
            list-style:none;
            border-bottom:none;
            position: relative;
        }
    </style>
    <script type="text/javascript">
        function gizle_goster_efatura(id)
        {
            if(document.getElementById(id).style.display=='block')
            {
                document.getElementById(id).style.display='none';
            } else {
                document.getElementById(id).style.display='block';
                $(document).bind('click', function(e){
                    var $clicked = $(e.target);
                    if (!($clicked.is('#efatura_display_hover') || $clicked.parents().is('#efatura_display_hover'))) {
                        if(!$clicked.is('#efatura_display img')){
                            document.getElementById('efatura_display_hover').style.display='none';
                            $(document).unbind('click');
                        }
                    }
                });
            }
        }
    </script>
</cfif>
<cfset dsn = application.systemParam.systemParam().dsn>
<cfset this.dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
<cfset this.dsn3_alias = "#dsn#_#session.ep.company_id#">

<cfquery name="get_makbuz_info" datasource="#dsn#">
    SELECT IS_EPRODUCER_RECEIPT, IS_EVOUCHER FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id# 
</cfquery>

<cfif get_makbuz_info.IS_EPRODUCER_RECEIPT eq 1 or get_makbuz_info.IS_EVOUCHER eq 1>
    <cfparam name="attributes.action_id" default="">
    <cfparam name="attributes.action_type" default="">
    <cfparam name="attributes.action_date" default="">
    <cfparam name="attributes.period_id" default="">
    <cfparam name="attributes.is_display" default="0"><!--- 1 gelirse gönderim detayları gösterilmez --->
    
    <cfif isdefined("attributes.period_id") and len(attributes.period_id)>
        <cfquery name="GET_PERIOD" datasource="#DSN#">
            SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
        </cfquery>
		<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
    <cfelse>
        <cfset db_adres = "#this.dsn2#">
    </cfif>  
    <cfif len(attributes.action_id) and len(attributes.action_type)>
        <cfquery name="CHK_SEND_SHIP" datasource="#db_adres#">
            SELECT COUNT(*) COUNT FROM ERECEIPT_SENDING_DETAIL WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#"> AND STATUS_CODE = 1	    
        </cfquery>
        <cfquery name="CHK_SHIP_REL" datasource="#db_adres#">
            SELECT PROFILE_ID,STATUS_CODE,UUID,INTEGRATION_ID,RECEIPT_UUID,RECEIPT_ID FROM ERECEIPT_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#">
        </cfquery>
    <cfelse>
        <cfset CHK_SEND_SHIP.count = 0>
        <cfset CHK_SHIP_REL.recordcount = 0>
    </cfif>

    <a id="efatura_display" <cfif caller.attributes.fuseaction contains 'popup'>onclick="gizle_goster_efatura('efatura_displayUl');"</cfif>>
        <cfif (CHK_SHIP_REL.recordcount and CHK_SHIP_REL.status_code eq 1)>
            <img src="images/icons/efatura_green.gif" height="17" align="absmiddle"/>                 
        <cfelseif CHK_SHIP_REL.recordcount and CHK_SHIP_REL.status_code eq 0>
            <img src="images/icons/efatura_red.gif" height="17" align="absmiddle"/>
        <cfelseif CHK_SEND_SHIP.count gt 0>
            <img src="images/icons/efatura_yellow.gif" height="17" align="absmiddle"/>
        <cfelse>
            <img src="images/icons/efatura_blue.gif" height="17" align="absmiddle"/>
        </cfif>
    </a>
    <cfoutput>
        <ul id="efatura_displayUl" class="dropdown-menu scrollContent scrollContentDropDown" style="display:none;">
            <cfif CHK_SEND_SHIP.count eq 0>
                <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_preview_producer&action_id=#attributes.action_id#&action_type=#attributes.action_type#','wide');"><cf_get_lang dictionary_id="44564.Önizleme"></a></li>
                <cfif attributes.action_type eq 'MM'>
                    <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_create_producer_xml&action_id=#attributes.action_id#&action_type=#attributes.action_type#','wide');">Makbuz Gönder</a></li>
                <cfelse>
                    <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_create_voucher_xml&action_id=#attributes.action_id#&action_type=#attributes.action_type#','wide');">Makbuz Gönder</a></li>
                </cfif>
            <cfelse>
                <cfif attributes.is_display eq 0>                                     
                    <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_send_detail_ereceipt&action_id=#attributes.action_id#&action_type=#attributes.action_type#','wide');"><cf_get_lang dictionary_id='51954.Gönderim Detayları'></a></li>
                    <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_return_detail_ereceipt&action_id=#attributes.action_id#&action_type=#attributes.action_type#','wide');"><cf_get_lang dictionary_id='51946.Dönüş Değerleri'></a></li>
                    <li><a href='#request.self#?fuseaction=objects.popup_ajax_list_ereceipt_detail&uuid=#CHK_SHIP_REL.uuid#&integration_id=#CHK_SHIP_REL.integration_id#&action_type=#attributes.action_type#' ><cf_get_lang dictionary_id='62189.e-Makbuz Görsel'></a></li>
                </cfif>
            </cfif>
        </ul>
    </cfoutput>
</cfif>