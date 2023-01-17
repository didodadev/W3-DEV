<cfsetting showdebugoutput="yes">
<cfinclude template="../query/get_ezgi_product_tree_creative_station_time.cfm">
<cfif get_default.DEFAULT_IS_STATION_OR_IS_OPERATION eq 1>
	<cfset time_head = '#getLang('prod',358)#'>
<cfelse>
	<cfset time_head = '#getLang('prod',63)#'>
</cfif>
<cf_seperator title="#time_head#" id="operation_" is_closed="0">
<div id="operation_">
	<cf_form_list id="operation_">
        <thead>
            <tr style="height:30px">
                <th style="text-align:right;width:25px"><cf_get_lang_main no='1165.Sıra'></th>
                <th style="text-align:left;width:100%">&nbsp;<cfif get_default.DEFAULT_IS_STATION_OR_IS_OPERATION eq 1><cf_get_lang_main no='1422.İstasyon'><cfelse><cf_get_lang_main no='1622.Operasyon'></cfif></th>
                <th style="text-align:center;width:40px"><cf_get_lang no='101.Adam Sayısı'></th>
                <th style="text-align:center;width:70px"><cf_get_lang_main no='1716.Süre'></th>  
            </tr>
        </thead>
        <tbody>
        <cfif station_time_cal_group.recordcount>
        	<cfset total_time = 0>
			<cfoutput query="station_time_cal_group">
            	<cfset total_time = total_time+TOTAL_EMPLOYEE_TIME>
                <tr>
                    <td style="text-align:right">#currentrow#&nbsp;</td>
                    <td nowrap <cfif Len(STATION_NAME) gt 30>title="#STATION_NAME#"</cfif>>
                    	<cfif get_default.DEFAULT_IS_STATION_OR_IS_OPERATION eq 1>
                        	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.upd_ezgi_workstation&station_id=#station_id#','wide');">
                        <cfelse>
                        	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_upd_ezgi_iflow_operation_rate&operation_type_id=#station_id#&e_design=1','small');">
                        </cfif>
                            &nbsp;#Left(STATION_NAME,30)#<cfif len(STATION_NAME) gte 30>...</cfif>
                        </a>
                    </td>
                    <td style="text-align:center;">#AmountFormat(EMPLOYEE_NUMBER,0)#</td>
                    <td style="text-align:right;"><cfif len(Int(TOTAL_STATION_TIME/3600)) eq 1>0</cfif>#Int(TOTAL_STATION_TIME/3600)#:<cfif len(Int((TOTAL_STATION_TIME/60) Mod 60)) eq 1>0</cfif>#Int((TOTAL_STATION_TIME/60) Mod 60)#:<cfif len(Int(TOTAL_STATION_TIME Mod 60)) eq 1>0</cfif>#Int(TOTAL_STATION_TIME Mod 60)#&nbsp;</td>
                </tr>
            </cfoutput>
            <tr>
            	<td colspan="3" style="font-weight:bolder"><cf_get_lang_main no='80.Total'> <cf_get_lang no='101.Adam Sayısı'> <cf_get_lang_main no='1716.Süre'></td>
              	<td style="text-align:right;font-weight:bolder"><cfoutput><cfif len(Int(TOTAL_TIME/3600)) eq 1>0</cfif>#Int(TOTAL_TIME/3600)#:<cfif len(Int((TOTAL_TIME/60) Mod 60)) eq 1>0</cfif>#Int((TOTAL_TIME/60) Mod 60)#:<cfif len(Int(TOTAL_TIME Mod 60)) eq 1>0</cfif>#Int(TOTAL_TIME Mod 60)#&nbsp;</cfoutput></td>
        	</tr>
        <cfelse>
        	<tr><td colspan="4"><cf_get_lang_main no='72.Kayıt Yok'></td></tr>
        </cfif>
       </tbody>
    </cf_form_list>
</div>
