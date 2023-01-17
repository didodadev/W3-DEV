<cf_get_lang_set module_name="finance">
    <cf_xml_page_edit fuseact="finance.add_payment_actions">
    <cfset module_name = 'finance'>
    <cfset module_name2 = 'cost'>
    <cfset module_name3 = 'objects'>
    <cfset module = 23>
    <cfparam name="attributes.action_type" default="">
    <cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
        SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
    </cfquery>
    <cfquery name="GET_ROWS" datasource="#DSN2#">
        SELECT * FROM CARI_CLOSED_ROW WHERE CLOSED_ID = #attributes.closed_id#
    </cfquery>
    <cfquery name="GET_INVOICE_CLOSE" datasource="#DSN2#">
        SELECT
            <cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
                DEBT_AMOUNT_VALUE,
                CLAIM_AMOUNT_VALUE,
                DIFFERENCE_AMOUNT_VALUE,
            <cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
                PAYMENT_DEBT_AMOUNT_VALUE DEBT_AMOUNT_VALUE,
                PAYMENT_CLAIM_AMOUNT_VALUE CLAIM_AMOUNT_VALUE,
                PAYMENT_DIFF_AMOUNT_VALUE DIFFERENCE_AMOUNT_VALUE,
            <cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
                P_ORDER_DEBT_AMOUNT_VALUE DEBT_AMOUNT_VALUE,
                P_ORDER_CLAIM_AMOUNT_VALUE CLAIM_AMOUNT_VALUE,
                P_ORDER_DIFF_AMOUNT_VALUE DIFFERENCE_AMOUNT_VALUE,
            </cfif>
            PROJECT_ID,
            COMPANY_ID,
            CONSUMER_ID,
            EMPLOYEE_ID,
            CLOSED_ID,
            PAPER_DUE_DATE,
            OTHER_MONEY,
            PAYMETHOD_ID,
            PAPER_ACTION_DATE,
            PROCESS_STAGE,
            ACTION_DETAIL,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_DATE,
            UPDATE_EMP,
            ACC_TYPE_ID
        FROM
            CARI_CLOSED
        WHERE
            CLOSED_ID = #attributes.closed_id#
        <cfif (listfind(attributes.fuseaction,'correspondence','.') and not isDefined("attributes.mail_control")) or (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info))>
            AND RECORD_EMP = #session.ep.userid#<!--- yazışmalardan girilen kayıtlarda, başkalarının kayıtları görülmesn diye.. --->
        </cfif>
    </cfquery>
<cfif not (GET_INVOICE_CLOSE.recordcount) or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
        <!--- attributes.active_company Kaldirilmasin surec linklerinden geldiginde sorun olusuyor FBS 20100504 --->
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'><cf_get_lang_main no='586.Veya'><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
    <cfelse>
        <cfquery name="get_closed_" datasource="#dsn2#">
            SELECT
                ACTION_ID,
                CLOSED_ID,
                P_ORDER_VALUE,
                CLOSED_AMOUNT,
                RELATED_CLOSED_ROW_ID
            FROM 
                CARI_CLOSED_ROW
            WHERE
                CLOSED_ID = #attributes.closed_id#
        </cfquery>
        <cfif attributes.act_type eq 2>
            <cfquery name="get_order_actions" dbtype="query">
                SELECT CLOSED_ID FROM get_closed_ WHERE P_ORDER_VALUE IS NOT NULL
            </cfquery>	
        <cfelseif attributes.act_type eq 3>	
            <cfquery name="get_order_actions" dbtype="query">
                SELECT CLOSED_ID FROM get_closed_ WHERE RELATED_CLOSED_ROW_ID IS NOT NULL
            </cfquery>	
            <cfquery name="get_order_actions_2" dbtype="query">
                SELECT RELATED_CLOSED_ROW_ID FROM get_closed_ WHERE RELATED_CLOSED_ROW_ID IS NOT NULL
            </cfquery>
            <cfset related_row_ids = valuelist(get_order_actions_2.RELATED_CLOSED_ROW_ID)>
        <cfelse>
            <cfset get_order_actions.recordcount = 0>
        </cfif>
        <cfinclude template="../query/get_payment_actions_detail.cfm">
    <cfform name="add_payment_actions2" id="add_payment_actions2" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_payment_actions">
        <input type="hidden" name="closed_id" id="closed_id" value="<cfoutput>#attributes.closed_id#</cfoutput>">
        <cfif isdefined("attributes.extra_type_info")>
            <input type="hidden" name="extra_type_info" id="extra_type_info" value="<cfoutput>#attributes.extra_type_info#</cfoutput>">
        <cfelse>
            <input type="hidden" name="extra_type_info" id="extra_type_info" value="">
        </cfif>
        <input type="hidden" name="act_type" id="act_type" value="<cfoutput>#attributes.act_type#</cfoutput>">
        <input type="hidden" name="all_records" id="all_records" value="<cfoutput>#get_cari_closed_row_1.recordcount+get_cari_closed_row_2.recordcount#</cfoutput>">
        <input type="hidden" name="order_row_id_info" id="order_row_id_info" value="">
        <input type="hidden" name="company_id" id="company_id" value="1">
        <cfif get_closed_.action_id eq 0><input type="hidden" name="correspondence_info" id="correspondence_info" value=""></cfif>
        <cfif isdefined("attributes.mail_control")><input type="hidden" name="mail_control" id="mail_control" value="1"></cfif><!--- Silmeyin urlden gelen verinin kaybolmamasi icin konuldu FBS 20090526 --->           
        <cfscript>
            pageHead="#getlang('main',2403)# : #attributes.closed_id#";
            if(len(GET_INVOICE_CLOSE.company_id))
                title = "#get_par_info(GET_INVOICE_CLOSE.company_id,1,1,0)#";
            else if(len(GET_INVOICE_CLOSE.consumer_id))
                title = "#get_cons_info(GET_INVOICE_CLOSE.consumer_id,0,0)#";
            else if(len(GET_INVOICE_CLOSE.employee_id) and isdefined('attributes.acc_type_id'))
                title = "#get_emp_info(GET_INVOICE_CLOSE.employee_id,0,0,0,attributes.acc_type_id)#";
            else if (len(GET_INVOICE_CLOSE.employee_id))
                title = "#get_emp_info(GET_INVOICE_CLOSE.employee_id,0,0,0)#";
            else
                title = "#getlang('main',2403)# : #attributes.closed_id#";
        </cfscript> 
        <cf_catalystHeader>
            <div class="row">
                <div class="col col-3">
                       <!--- Belgeler --->
                    <cf_get_workcube_asset asset_cat_id="-17" module_id='25' action_section='CLOSED_ID' action_id='#attributes.closed_id#' company_id="#session.ep.company_id#">        
                    <!--- Notlar --->
                    <cf_get_workcube_note company_id="#session.ep.company_id#" asset_cat_id="-17" module_id='25' action_section='CLOSED_ID' action_id='#attributes.closed_id#'>
                </div>
            </div>       
    </cfform>
</cfif>
 