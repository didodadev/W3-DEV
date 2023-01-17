<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.project_id" default="">

<cfquery name="get_types" datasource="#dsn_dev#">
	SELECT * FROM SEARCH_TABLE_PROCESS_TYPES ORDER BY TYPE_NAME
</cfquery>

<cfquery name="get_rows" datasource="#dsn_dev#">
	SELECT
    	(SELECT P.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS P WHERE P.PROJECT_ID = PR.PROJECT_ID) AS PROJECT_NAME,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        C.FULLNAME,
        C.NICKNAME,
        PR.*,
        STPT.TYPE_NAME,
        D.DEPARTMENT_HEAD
    FROM
    	#dsn_alias#.EMPLOYEES E,
        #dsn_alias#.DEPARTMENT D,
        #dsn_alias#.COMPANY C,
        SEARCH_TABLE_PROCESS_TYPES STPT,
        PROCESS_ROWS PR
    WHERE
    	<cfif len(attributes.project_id)>
        	PR.PROJECT_ID = #attributes.project_id# AND
        </cfif>
    	PR.DEPARTMENT_ID = D.DEPARTMENT_ID AND
        PR.COMPANY_ID = C.COMPANY_ID AND
        PR.ROW_ID IN (#attributes.row_list#) AND
        PR.RECORD_EMP = E.EMPLOYEE_ID AND
        STPT.TYPE_ID = PR.PROCESS_TYPE
   ORDER BY
   		PR.PROCESS_STARTDATE,
        D.DEPARTMENT_HEAD
</cfquery>
<cf_medium_list>
    <thead>
        <tr>
        	<td colspan="12">
            	<table>
                	<tr>
                        <td class="formbold" width="75">Firma</td>
                        <td><cfoutput>#get_rows.FULLNAME# <cfif len(get_rows.PROJECT_NAME)> - #get_rows.PROJECT_NAME#</cfif></cfoutput></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <th>Sıra</th>
            <!--- <th>Kayıt</th> --->
            <th>Mağaza</th>
            <th>Uygulama Tipi</th>
            <th>Açıklama</th>
            <!--- <th>Adet</th> --->
            <th>Dönem</th>
            <th>Uyg. Başlangıç</th>
            <th>Uyg. Bitiş</th>
            <!--- <th>Yapılış</th> --->
            <!--- <th>Bitiş</th> --->
            <th>Ödeme T.</th>
            <!--- <th>Ödendiği T.</th> --->
            <th>Fiyat</th>
            <th>KDV</th>
            <th>Ödeme</th>
            <th>Bakiye</th>
        </tr>
    </thead>
    <tbody>
        <cfset total_cost = 0>
        <cfset total_paid = 0>
		<cfoutput query="get_rows">
        <tr>
            <td>#currentrow#</td>
            <!--- <td>#dateformat(dateadd("h",session.ep.time_zone,record_date),'dd/mm/yyyy')#</td> --->
            <td>#DEPARTMENT_HEAD#</td>
            <td>#TYPE_NAME#</td>
            <td>#PROCESS_DETAIL#</td>
            <!--- <td>#QUANTITY#</td> --->
            <td>#period#</td>
            <td>#dateformat(PROCESS_STARTDATE,'dd/mm/yyyy')#</td>
            <td>#dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy')#</td>
            <!--- <td>#dateformat(ACTION_STARTDATE,'dd/mm/yyyy')#</td> --->
            <!--- <td>#dateformat(ACTION_FINISHDATE,'dd/mm/yyyy')#</td> --->
            <td>#dateformat(PAYMENT_DATE,'dd/mm/yyyy')#</td>
            <!--- <td>#dateformat(PAID_DATE,'dd/mm/yyyy')#</td> --->
            <td>#tlformat(COST)#</td>
            <td>#tax#</td>
            <td>
            <cfset paid_ = 0>
            #tlformat(paid_)#
            </td>
            <td><cfif len(COST) and isnumeric(COST)>#tlformat(COST - paid_)#</cfif></td>
            <cfif len(COST) and isnumeric(COST)>
				<cfset total_cost = total_cost + COST>
                <cfset total_paid = total_paid + paid_>
            </cfif>
        </tr>
        </cfoutput>
        <cfoutput>
        <tr>
        	<td colspan="8" style="text-align:right;" class="formbold">Toplam</td>
            <td>#tlformat(total_cost)#</td>
            <td>&nbsp;</td>
            <td>#tlformat(total_paid)#</td>
            <td>#tlformat(total_cost - total_paid)#</td>
        </tr>
        </cfoutput>
        </tbody>
        <tfoot>
        	<tr>
            	<td colspan="12" height="75" valign="top">
                	<br />
                    <cfoutput>#attributes.note#</cfoutput>
                    <br /><br />
                    <table>
                    	<tr>
                        	<td width="75" class="formbold">Alıcı</td>
                            <td width="200"><cfoutput>#session.ep.name# #session.ep.surname#</cfoutput></td>
                            <td width="75" class="formbold">Satıcı</td>
                            <td width="200"></td>
                        </tr>
                        <tr>
                        	<td style="height:50px;" class="formbold">İmza</td>
                            <td>&nbsp;</td>
                            <td style="height:50px;" class="formbold">İmza</td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </tfoot>
</cf_medium_list>