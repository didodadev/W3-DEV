<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>
<cfquery name="get_ciro_report_cash" datasource="#dsn_dev#">
    SELECT
        MAX(GA2.FIS_TARIHI) AS SON_FIS,
        PE2.EQUIPMENT_CODE
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2,
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
        <cfif not session.ep.ehesap>
            B2.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
		<cfif attributes.branch_id gt 0>
        B2.BRANCH_ID = #attributes.branch_id# AND
        <cfelse>
        B2.BRANCH_ID < 0 AND
        </cfif>
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        GA2.FIS_TARIHI >= #attributes.startdate# AND 
        GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)# 
    GROUP BY 
        PE2.EQUIPMENT_CODE
</cfquery>
<cf_medium_list>
    <tbody>
        <tr>
            <td style="background-color:#FFC;">
                <font class="formbold">Kasalar : </font><cfoutput query="get_ciro_report_cash">#EQUIPMENT_CODE# : <b>#dateformat(SON_FIS,"dd/mm/yyyy")# (#timeformat(SON_FIS,"HH:MM")#)</b>&nbsp;&nbsp;&nbsp;</cfoutput>
            </td>
        </tr>
    </tbody>
</cf_medium_list>
