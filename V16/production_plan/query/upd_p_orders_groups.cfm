<!--- Üretim Emirleri Sayfasında Gruplanan Emirlerin Güncellenmesi İçin Kullanılıyor. M.ER 02082008 --->
<cfsetting showdebugoutput="no">
<cf_date tarih = "attributes.p_start_date">
<cf_date tarih = "attributes.p_finish_date">
<cfscript>
	attributes.p_start_date = date_add("n",p_start_m,date_add("h",p_start_h ,attributes.p_start_date));
	attributes.p_finish_date = date_add("n",p_finish_m,date_add("h",p_finish_h ,attributes.p_finish_date));
</cfscript>
<cfif isdefined('attributes.p_order_id_list') and len(attributes.p_order_id_list)>
	<!---
        <cfloop list="#attributes.p_order_id_list#" index="po_ind">
        Sorguyu birden fazla kez çalıştırmaya gerek olmadığından kapatıldı. WHERE IN aynı işi görüyor.
        upd : 22/05/2019, Uğur Hamurpet
    --->
        <cfquery name="UPD_P_ORDER_GROUPS" datasource="#DSN3#">
            UPDATE
                PRODUCTION_ORDERS
            SET 
                DETAIL = '#attributes.detail#',
                START_DATE =  #attributes.p_start_date#,
                FINISH_DATE = #attributes.p_finish_date#,
                LOT_NO = '#attributes._lot_no_#',
                STATION_ID = #attributes._station_id_#,
                IS_GROUP_LOT = 1,
                IS_STAGE = <cfif isdefined('attributes.is_operator_display') and attributes.is_operator_display eq 1>0<cfelse>4</cfif>
            WHERE
                P_ORDER_ID IN (<cfqueryparam value = "#attributes.p_order_id_list#" CFSQLType = "cf_sql_integer" list="yes">)
        </cfquery>
    <!----</cfloop>--->
	<cfif attributes.is_saved_paper neq 1><!--- Belge numarası güncellenmemiş ise... --->
        <cf_papers paper_type="production_lot">
        <cfscript>
        lot_system_paper_no=paper_code & '-' & paper_number;
        lot_system_paper_no_add=paper_number;
        </cfscript>
        <cfquery name="UPD_GEN_PAP_LOT" datasource="#dsn3#">
            UPDATE 
                GENERAL_PAPERS
            SET
                PRODUCTION_LOT_NUMBER = #lot_system_paper_no_add#
            WHERE
                PRODUCTION_LOT_NUMBER IS NOT NULL
        </cfquery>
    </cfif>
    <cfif isdefined('paper_number')>
		<script type="text/javascript">
            document.getElementById('is_saved_paper').value=1;
            document.getElementById('_lot_no_').value="<cfoutput>#paper_number#</cfoutput>";
            document.getElementById('_lot_no_').style.background='FF9900';
        </script>
    </cfif>
</cfif>
