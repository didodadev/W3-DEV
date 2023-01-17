<cfset order_id_list = '7531,7530,7529,7528'>
<cfquery name="order_grup" datasource="#dsn3#">
	SELECT
    DISTINCT
 	O.COMPANY_ID, 
    O.PROJECT_ID,
    (SELECT NICKNAME  FROM #dsn#.COMPANY WHERE COMPANY_ID = O.COMPANY_ID) AS COMPANY,
    (SELECT PROJECT_HEAD FROM #dsn#.PRO_PROJECTS WHERE PROJECT_ID = O.PROJECT_ID) AS PROJE,
    O.ORDER_DATE
    FROM
    ORDERS AS O
    WHERE
    O.ORDER_ID IN (#order_id_list#)
</cfquery>
			<cfset set_id = 0>
            <cfset order_list = ''>
			<cfoutput query="order_grup">
            <cfset set_id = set_id+1>
			<!--- standart fiyatlar --->
            <!---<cfsavecontent variable="rig"><cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'></cfsavecontent>--->
            
            <cfquery name="order_detail" datasource="#dsn3#">
            SELECT
            DISTINCT
            O.ORDER_ID,
            O.ORDER_NUMBER,
            O.COMPANY_ID,    
            O.ORDER_HEAD,
            (SELECT NICKNAME  FROM #dsn#.COMPANY WHERE COMPANY_ID = O.COMPANY_ID) AS COMPANY,
            (SELECT PROJECT_HEAD FROM #dsn#.PRO_PROJECTS WHERE PROJECT_ID = O.PROJECT_ID) AS PROJE,
            (SELECT DEPARTMENT_HEAD FROM #DSN#.DEPARTMENT WHERE DEPARTMENT_ID = O.DELIVER_DEPT_ID) AS DEPARTMENT,
            O.ORDER_DATE,
            O.DELIVERDATE
            FROM
            ORDERS AS O
            WHERE
            O.ORDER_DATE = '#order_grup.ORDER_DATE#' AND O.COMPANY_ID = #order_grup.COMPANY_ID# AND 
            <cfif len(order_grup.proje)>
            O.PROJECT_ID = #order_grup.PROJECT_ID# AND
            <cfelse>
            O.PROJECT_ID IS NULL AND
            </cfif>
            O.ORDER_ID IN (#order_id_list#)
        </cfquery>
        <cfset order_list = valuelist(order_detail.order_id)>
        <cfsavecontent variable="header_">
        <a href="javascript://" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_print_files_all&action_id=&print_type=91&orders=#order_list#','page')"><img src="/images/print.gif" /></a>
        <a href="javascript://" onclick="show_hide('#set_id#')">#order_grup.COMPANY# - #order_grup.PROJE# #dateformat(order_grup.order_date,'dd/mm/yyyy')# 
		</a>
        </cfsavecontent>
        
        <cf_medium_list_search title="#header_#"></cf_medium_list_search>
        <div style="height:auto; overflow:auto;" id="#set_id#">
        <table class="medium_list" align="center"> 
        
                    <thead>     
                          
                        <tr> 
                            
                            <th>No</th>
                            <th>Belge Tarihi</th>
                            <th>Teslim Tarihi</th>
                            <th>Konu</th>	
                            <th>Şirket</th>				              
                            <th>Depo</th>
                          </tr>
                          </thead>
                          
                          
                          <tbody>
                            <cfloop query="order_detail" startrow="1" endrow="#order_detail.recordcount#">
                            <tr>
                                <td>#order_number#</td>
                                <td>#dateformat(order_date,'dd/mm/yyyy')#</td>
                                <td>#dateformat(deliverdate,'dd/mm/yyyy')#</td>
                                <td>#order_head#</td>
                                <td>#company#</td>
                                <td>#department#</td> 
                            </tr>                 
                            </cfloop>
                          </tbody>
          </table>         
            </div>
		</cfoutput>

