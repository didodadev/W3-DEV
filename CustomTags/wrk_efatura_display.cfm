<!---
    upd:    Uğur Hamurpet, 15/07/2019
    desc:   Bu customtag fatura tab menülerinde ve popupta e-fatura göndermek için kullanılıyor.
            Popuplarda e ikonu gösteriminde sorun olduğundan dolayı düzenlendi.
            e ikonuna basıldığında ilgili linklerin listelenmesi sağlandı.
---->
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
<cfif session.ep.our_company_info.is_efatura>
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
    <cfquery name="GET_OUR_COMPANY" datasource="#dsn#">
        SELECT
            EINVOICE_COMPANY_CODE,
            EINVOICE_TYPE
        FROM
            OUR_COMPANY_INFO
        WHERE
            COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>   
    <cfif len(attributes.action_id) and len(attributes.action_type)>
        <cfquery name="CHK_SEND_INV" datasource="#db_adres#">
            SELECT COUNT(*) COUNT FROM EINVOICE_SENDING_DETAIL WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#"> AND STATUS_CODE = 1	    
        </cfquery>
        <cfquery name="CHK_INV_REL" datasource="#db_adres#">
            SELECT STATUS,PROFILE_ID,STATUS_CODE,SENDER_TYPE,UUID,INTEGRATION_ID FROM EINVOICE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#">
        </cfquery>
    <cfelse>
        <cfset chk_send_inv.count = 0>
        <cfset chk_inv_rel.recordcount = 0>
    </cfif>
    <a <cfif not isDefined("caller.attributes.draggable")> id="efatura_display" </cfif><cfif caller.attributes.fuseaction contains 'popup' and not isDefined("caller.attributes.draggable")>onclick="gizle_goster_efatura('efatura_displayUl');"</cfif>>
        <cfif (chk_inv_rel.recordcount and chk_inv_rel.status eq 1)>
            <cfif get_our_company.einvoice_type eq 5 and listfind('50,60,80,110',chk_inv_rel.status_code)>
                <img src="images/icons/efatura_purple.gif" height="17" title="Tekrar Gönderilecek" align="absmiddle"/>
            <cfelse>
                <img src="images/icons/efatura_green.gif" height="17" align="absmiddle"/>
            </cfif>
        <cfelseif get_our_company.einvoice_type eq 7 and chk_inv_rel.sender_type eq 7 and  chk_inv_rel.recordcount and chk_inv_rel.status eq 0 and listfind('40',chk_inv_rel.status_code)>
            <img src="images/icons/efatura_purple.gif" height="17" align="absmiddle"/>                     
        <cfelseif chk_inv_rel.recordcount and chk_inv_rel.status eq 0>
            <img src="images/icons/efatura_red.gif" height="17" align="absmiddle"/>
        <cfelseif chk_send_inv.count gt 0>
            <img src="images/icons/efatura_yellow.gif" height="17" align="absmiddle"/>
        <cfelse>
            <img src="images/icons/efatura_blue.gif" height="17" align="absmiddle"/>
        </cfif>
    </a>
    <cfoutput>
        <ul id="efatura_displayUl" class="dropdown-menu scrollContent scrollContentDropDown" style="display:none;">
            <cfif chk_send_inv.count eq 0>
                <li><a href="javascript:void(0);" onclick="windowopen('#request.self#?fuseaction=invoice.popup_preview_invoice&action_id=#attributes.action_id#&action_type=#attributes.action_type#&invoice_type=einvoice','wide');"><cf_get_lang dictionary_id="44564.Önizleme"></a></li>
                <li><a href="javascript:void(0);" onclick="windowopen('#request.self#?fuseaction=invoice.popup_import_einvoice&action_id=#attributes.action_id#&action_type=#attributes.action_type#&invoice_type=einvoice','small');"><cf_get_lang dictionary_id="60697.E-Fatura İçe Aktar"></a></li>
                <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_create_xml&action_id=#attributes.action_id#&action_type=#attributes.action_type#','wide');"><cfif GET_OUR_COMPANY.EINVOICE_TYPE eq 1>XML <cf_get_lang dictionary_id="57461.Kaydet"><cfelse><cf_get_lang dictionary_id="52008.Fatura Gönder"></cfif></a></li>
            <cfelse>
                <cfif attributes.is_display eq 0>
                    <cfif get_our_company.einvoice_type eq 5 and listfind('50,60,80,110',chk_inv_rel.status_code)><!--- ING Tekrar Gonderim --->
                        <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_create_xml&action_id=#attributes.action_id#&action_type=#attributes.action_type#&resend=1','wide');"><cf_get_lang dictionary_id="64309.Tekrar Fatura Gönder"></a></li>
                    </cfif>  
                    <cfif get_our_company.einvoice_type eq 7 and chk_inv_rel.sender_type eq 7 and listfind('40',chk_inv_rel.status_code)><!--- Medyasoft Tekrar Gonderim --->
                        <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_create_xml&action_id=#attributes.action_id#&action_type=#attributes.action_type#&resend=1','wide');"><cf_get_lang dictionary_id="64309.Tekrar Fatura Gönder"></a></li>
                    </cfif>                                         
                    <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=invoice.popup_send_detail&action_id=#attributes.action_id#&action_type=#attributes.action_type#');"><cf_get_lang dictionary_id="51954.Gönderim Detayları"></a></li>
                    <!--- Gönderim detayları tarafı ile birleştirildiğinden kapatıyorum. 
                    <cfif not listfind('1,4',chk_inv_rel.sender_type) >
                        <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_return_detail&action_id=#attributes.action_id#&action_type=#attributes.action_type#','wide');">Dönüş Değerleri</a></li>
                    </cfif>
                    --->
                    <cfif listfind('8,5,3,6,7',get_our_company.einvoice_type)><li><a href='#request.self#?fuseaction=objects.popup_ajax_list_dsp_einvoice_detail&uuid=#chk_inv_rel.uuid#&sender_type=#chk_inv_rel.sender_type#&integration_id=#chk_inv_rel.integration_id#' ><cf_get_lang dictionary_id="52042.E-Fatura Görsel"> (PDF)</a></li></cfif>
                <cfelse>
                    <cfif attributes.period_id eq session.ep.period_id>
                        <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_send_detail&action_id=#attributes.action_id#&action_type=#attributes.action_type#','wide');"><cf_get_lang dictionary_id="51954.Gönderim Detayları"></a></li>
                    </cfif>
                    <cfif listfind('8,5,3,6,7',get_our_company.einvoice_type)><li><a href='#request.self#?fuseaction=objects.popup_ajax_list_dsp_einvoice_detail&uuid=#chk_inv_rel.uuid#&sender_type=#chk_inv_rel.sender_type#&integration_id=#chk_inv_rel.integration_id#' ><cf_get_lang dictionary_id="52042.E-Fatura Görsel"></a></li></cfif>
                </cfif>
            </cfif>
        </ul>
    </cfoutput>
</cfif>

<script>
    function openDetails(){
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=invoice.popup_send_detail&action_id=#attributes.action_id#&action_type=#attributes.action_type#</cfoutput>');
    }
</script>