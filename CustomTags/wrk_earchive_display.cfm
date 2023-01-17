<!---
    upd:    Uğur Hamurpet, 16/07/2019
    desc:   Bu customtag fatura tab menülerinde ve popupta e-arşiv göndermek için kullanılıyor.
            Popuplarda a ikonu gösteriminde sorun olduğundan dolayı düzenlendi.
            a ikonuna basıldığında ilgili linklerin listelenmesi sağlandı.
---->
<cfif caller.attributes.fuseaction contains 'popup'>
    <style>
        ul#earchive_displayUl{
            overflow-x: hidden !important;
        }
        ul#earchive_displayUl li{
            list-style:none;
            border-bottom:none;
            position: relative;
        }
    </style>
    <script type="text/javascript">
        function gizle_goster_earchive(id)
        {
            $("#" +id).toggle();
        }
    </script>
</cfif>

<cfset dsn = application.systemParam.systemParam().dsn>
<cfset this.dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
<cfset this.dsn3_alias = "#dsn#_#session.ep.company_id#">
<cfif session.ep.our_company_info.is_earchive>
    <cfparam name="attributes.action_id" default="">
    <cfparam name="attributes.action_type" default="">
    <cfparam name="attributes.action_date" default="">
    <cfparam name="attributes.period_id" default="">
	<cfparam name="attributes.is_display" default="0">
    <cfset is_iptal = 0>
    <cfset is_iptal_archive = 0>
    <cfquery name="GET_EARCHIVE_INFO" datasource="#DSN#">
        SELECT
            EARCHIVE_INTEGRATION_TYPE
        FROM
            EARCHIVE_INTEGRATION_INFO
        WHERE
            COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfif isdefined("attributes.period_id") and len(attributes.period_id)>
        <cfquery name="get_period" datasource="#DSN#">
            SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
        </cfquery>
            <cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
    <cfelse>
        <cfset db_adres = "#this.dsn2#">
    </cfif>  
    <cfif len(attributes.action_id) and len(attributes.action_type)>
        <cfquery name="CHK_SEND_INV_" datasource="#db_adres#">
            SELECT STATUS_CODE FROM EARCHIVE_SENDING_DETAIL WHERE ACTION_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#">	    
        </cfquery>
        <cfquery name="CHK_SEND_INV" dbtype="query">
            SELECT * FROM CHK_SEND_INV_ WHERE STATUS_CODE = '1'	    
        </cfquery>
        <cfquery name="CHK_INV_REL" datasource="#db_adres#">
            SELECT STATUS_CODE,STATUS,ISNULL(IS_CANCEL,0) IS_IPTAL,SENDER_TYPE FROM EARCHIVE_RELATION WHERE ACTION_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#">
        </cfquery>
        <cfset is_iptal_archive = CHK_INV_REL.IS_IPTAL>
        <cfif attributes.action_type is 'INVOICE'>
        	<cfquery name="GET_IPTAL" datasource="#db_adres#">
            	SELECT ISNULL(IS_IPTAL,0) IS_IPTAL FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
            </cfquery>
        <cfelseif attributes.action_type is 'EXPENSE_ITEM_PLANS'>
        	<cfquery name="GET_IPTAL" datasource="#db_adres#">

            	SELECT ISNULL(IS_IPTAL,0) IS_IPTAL FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
            </cfquery>
        </cfif>
        <cfset is_iptal = get_iptal.is_iptal>
    <cfelse>
        <cfset chk_send_inv.recordcount = 0>
        <cfset chk_inv_rel.recordcount = 0>
    </cfif>
    <a <cfif not isDefined("caller.attributes.draggable")>id="earchive_display"</cfif>  <cfif caller.attributes.fuseaction contains 'popup' and not isDefined("caller.attributes.draggable")>onclick="gizle_goster_earchive('earchive_displayUl');"</cfif>>
		<cfif chk_inv_rel.recordcount and is_iptal_archive eq 1>
            <img src="images/icons/earchive_red.gif" height="17" align="absmiddle" alt="İptal">
        <cfelseif (chk_inv_rel.recordcount and chk_inv_rel.status eq 1)>
            <img src="images/icons/earchive_green.gif" height="17" align="absmiddle"/>
        <cfelseif (chk_inv_rel.recordcount and chk_inv_rel.status eq 0)>
            <img src="images/icons/earchive_purple.gif" height="17" align="absmiddle"/>
        <cfelseif (chk_inv_rel.recordcount and not len(chk_inv_rel.status))>
        	<img src="images/icons/earchive_yellow.gif" height="17" align="absmiddle"/>
        <cfelseif datediff('d',createodbcdatetime('#year(session.ep.our_company_info.earchive_date)#-#month(session.ep.our_company_info.earchive_date)#-#day(session.ep.our_company_info.earchive_date)#'),attributes.action_date) gte 0>
            <img src="images/icons/earchive_blue.gif" height="17" align="absmiddle"/>
        </cfif>
    </a>
	<cfoutput>
        <ul id="earchive_displayUl" class="dropdown-menu scrollContent scrollContentDropDown" style="display:none;">
            <cfif chk_send_inv.recordcount eq 0 and attributes.is_display eq 0>
                <li><a href="javascript:void(0);" onclick="windowopen('#request.self#?fuseaction=invoice.popup_preview_invoice&action_id=#attributes.action_id#&action_type=#attributes.action_type#&invoice_type=earchieve','wide');"><cf_get_lang dictionary_id="44564.Önizleme"></a></li>
                <li><a href="javascript:void(0);" onclick="windowopen('#request.self#?fuseaction=invoice.popup_import_einvoice&action_id=#attributes.action_id#&action_type=#attributes.action_type#&invoice_type=earchive','small');"><cf_get_lang dictionary_id="60697.E-Fatura İçe Aktar"></a></li>
                <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_create_xml_earchive&action_id=#attributes.action_id#&action_type=#attributes.action_type#','wide');"><cf_get_lang dictionary_id='47763.E-Arşiv Fatura Gönder'></a></li>
                <cfif chk_send_inv_.recordcount and chk_send_inv_.STATUS_CODE eq 1>
                    <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=invoice.popup_send_detail_earchive&action_id=#attributes.action_id#&action_type=#attributes.action_type#');"><cf_get_lang dictionary_id='51954.Gönderim Detayları'></a></li>
                </cfif>
            <cfelse>
                <cfif attributes.is_display eq 0>
                    <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=invoice.popup_send_detail_earchive&action_id=#attributes.action_id#&action_type=#attributes.action_type#');"><cf_get_lang dictionary_id='51954.Gönderim Detayları'></a></li>
                    <!--- gönderim detaylı ile birleştirilidi
                    <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_return_detail_earchive&action_id=#attributes.action_id#&action_type=#attributes.action_type#','wide');">Dönüş Değerleri</a></li>
                    --->
                    <cfif is_iptal eq 1 or is_iptal_archive eq 1>
                        <li><a href="javascript://" onclick="if(confirm('İptal Edilen Bir e-Arşiv Faturanın PDF ini Alıyorsunuz !'))windowopen('#request.self#?fuseaction=objects.popup_dsp_earchive_detail&action_id=#attributes.action_id#&action_type=#attributes.action_type#','small');"><cf_get_lang dictionary_id='51948.E-Arşiv Görsel'></a></li>
                    <cfelse>
                        <li><a href='#request.self#?fuseaction=objects.popup_dsp_earchive_detail&action_id=#attributes.action_id#&action_type=#attributes.action_type#'><cf_get_lang dictionary_id='51948.E-Arşiv Görsel'></a></li>
                    </cfif>
                    <cfif get_earchive_info.earchive_integration_type eq 3 and chk_inv_rel.sender_type eq 3 and listfind('40',chk_inv_rel.status_code)><!--- Medyasoft Tekrar Gonderim --->
                        <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_create_xml_earchive&action_id=#attributes.action_id#&action_type=#attributes.action_type#&resend=1','wide');"><cf_get_lang dictionary_id='51952.Tekrar e-Arşiv Fatura Gönder'></a></li>
                    </cfif>
                <cfelse>
                    <cfif attributes.period_id eq session.ep.period_id>
                        <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=invoice.popup_send_detail_earchive&action_id=#attributes.action_id#&action_type=#attributes.action_type#');"><cf_get_lang dictionary_id='51954.Gönderim Detayları'></a></li>
                    </cfif>
                     <cfif is_iptal eq 1 or is_iptal_archive eq 1>
                        <li><a href="javascript://" onclick="if(confirm('İptal Edilen Bir e-Arşiv Faturanın PDF ini Alıyorsunuz !'))windowopen('#request.self#?fuseaction=objects.popup_dsp_earchive_detail&action_id=#attributes.action_id#&action_type=#attributes.action_type#','small');"><cf_get_lang dictionary_id='51948.E-Arşiv Görsel'></a></li>
                    <cfelse>
                        <li><a href='#request.self#?fuseaction=objects.popup_dsp_earchive_detail&action_id=#attributes.action_id#&action_type=#attributes.action_type#'><cf_get_lang dictionary_id='51948.E-Arşiv Görsel'></a></li>
                    </cfif>
                </cfif>
                <cfif is_iptal eq 1 and is_iptal_archive eq 0 and attributes.is_display eq 0>
                    <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_send_cancel_earchive&action_id=#attributes.action_id#&action_type=#attributes.action_type#','small');"><cf_get_lang dictionary_id='51968.İptal Bilgisi Gönder'></a></li>
                </cfif>
            </cfif>
        </ul>
    </cfoutput>
</cfif>
<script>
    function openDetails(){
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=invoice.popup_send_detail_earchive&action_id=#attributes.action_id#&action_type=#attributes.action_type#</cfoutput>');
    }
</script>