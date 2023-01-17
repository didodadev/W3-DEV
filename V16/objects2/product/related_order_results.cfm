<cfsetting showdebugoutput="no">
<cfset attributes.date_control = 1>

<cfquery name="GET_ORDER_RESULT" datasource="#DSN3#">
	SELECT
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
		PRODUCTION_ORDER_RESULTS.START_DATE,
		PRODUCTION_ORDER_RESULTS.FINISH_DATE,
		PRODUCTION_ORDER_RESULTS.RESULT_NO,
		PRODUCTION_ORDER_RESULTS.POSITION_ID,
		PRODUCTION_ORDER_RESULTS.STATION_ID,
		PRODUCTION_ORDERS.QUANTITY,
		ISNULL((SELECT
			SUM(POR_.AMOUNT) ORDER_AMOUNT
		FROM
			PRODUCTION_ORDER_RESULTS_ROW POR_,
			PRODUCTION_ORDER_RESULTS POO
		WHERE
			POR_.PR_ORDER_ID = POO.PR_ORDER_ID
			AND POO.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID
			AND POR_.TYPE = 1
			AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
		),0) RESULT_AMOUNT
	FROM
		PRODUCTION_ORDER_RESULTS,
		PRODUCTION_ORDERS
	WHERE
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID AND
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">
	ORDER BY
		PRODUCTION_ORDER_RESULTS.FINISH_DATE DESC
</cfquery>

<table style="width:100%;">
    <thead>
	    <tr>
            <td class="headbold" colspan="6">Üretim Sonuçları</td>
        </tr>
        <tr class="color-header" style="height:22px;">
            <th class="form-title">Sonuç No</th>
            <th class="form-title" nowrap><cf_get_lang_main no='330.Tarih'></th>
            <th class="form-title">İşlemi Yapan</th>
            <th class="form-title"><cf_get_lang_main no='1422.İstasyon'></th>
            <th class="form-title">Çıktılar</th>
            <th class="form-title">
                <cfif get_order_result.recordcount and (get_order_result.result_amount lt get_order_result.quantity)>
                    <a style="cursor:pointer;" onclick="add_p_order_result('<cfoutput>#attributes.upd#</cfoutput>')"><img src="/images/plus_list.gif" align="absmiddle" border="0"/></a>
                <cfelseif not get_order_result.recordcount>
                    <a style="cursor:pointer;" onclick="add_p_order_result('<cfoutput>#attributes.upd#</cfoutput>')"><img src="/images/plus_list.gif" align="absmiddle" border="0"/></a>
                </cfif>
            </th>
        </tr>
    </thead>
    <tbody>
        <script type="text/javascript">
            function add_p_order_result(p_order_id){
                if(<cfoutput>'#attributes.date_control#'</cfoutput> == 1)
                    window.location.href ='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_add_prod_order_result&p_order_id='+p_order_id+'';
                else
                    alert('Sonuç Girmek İçin Başlangıç ve Bitiş Tarihlerini Giriniz!');	
            }
        </script>
        <cfoutput query="get_order_result">
            <tr class="color-row" style="height:20px;">
                <td><a href="#request.self#?fuseaction=objects2.form_upd_prod_order_result&p_order_id=#attributes.upd#&pr_order_id=#pr_order_id#" class="tableyazi">#result_no#</a></td>
                <td>#dateformat(start_date,'dd/mm/yyyy')# #timeformat(start_date,'HH:mm')# - #dateformat(finish_date,'dd/mm/yyyy')# #timeformat(finish_date,'HH:mm')#</td>
                <td>#get_emp_info(position_id,0,1)#</td>
                <td>
                    <cfif len(station_id)>
                        <cfquery name="GET_STATION" datasource="#DSN3#">
                            SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#station_id#">
                        </cfquery>
                        #get_station.station_name#
                    </cfif>
                </td>
                <td>
                <cfquery name="GET_ROW_ENTER" datasource="#DSN3#">
                    SELECT NAME_PRODUCT, AMOUNT, UNIT_NAME FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_result.pr_order_id#"> AND TYPE = 1
                </cfquery>
                <table>
                    <cfloop query="get_row_enter">
                        <tr>
                            <td style="width:250px;"><b><cf_get_lang_main no='40.Stok'> : </b>#get_row_enter.name_product#&nbsp;&nbsp;</td>
                            <td><b><cf_get_lang_main no='223.Miktar'> : </b> #TlFormat(get_row_enter.amount,3)#&nbsp;#get_row_enter.unit_name#</td>
                        </tr>
                    </cfloop>
                </table>
                </td>
                <td><a href="#request.self#?fuseaction=objects2.form_upd_prod_order_result&p_order_id=#attributes.upd#&pr_order_id=#pr_order_id#"><img src="/images/update_list.gif" align="absmiddle" border="0"/></a></td>
            </tr>
        </cfoutput>
    </tbody>
</table>
