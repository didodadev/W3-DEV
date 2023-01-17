<cfset t_d_time = 0>
<cfset t_c_time = 0>
<cfquery name="get_daily_works" datasource="#dsn3#">
	SELECT     
    	POR.OPERATION_RESULT_ID, 
        POR.REAL_AMOUNT, 
        POR.REAL_TIME, 
        POR.ACTION_START_DATE, 
        S.PRODUCT_NAME, 
        W.STATION_NAME, 
        OT.OPERATION_TYPE,
        PO.LOT_NO, 
        PO.P_ORDER_NO
	FROM         
    	PRODUCTION_OPERATION_RESULT AS POR INNER JOIN
        PRODUCTION_ORDERS AS PO ON POR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
        STOCKS AS S ON PO.STOCK_ID = S.STOCK_ID INNER JOIN
        WORKSTATIONS AS W ON POR.STATION_ID = W.STATION_ID INNER JOIN
        PRODUCTION_OPERATION AS PRO ON POR.OPERATION_ID = PRO.P_OPERATION_ID INNER JOIN
        OPERATION_TYPES AS OT ON PRO.OPERATION_TYPE_ID = OT.OPERATION_TYPE_ID
	WHERE     
    	POR.ACTION_EMPLOYEE_ID = #employee_id# AND 
        POR.REAL_AMOUNT <> 0 AND 
        POR.REAL_TIME IS NOT NULL AND 
        POR.ACTION_START_DATE > '#Dateformat(now(),'MM/DD/YYYY')#' AND 
        POR.ACTION_START_DATE < '#Dateformat(Dateadd('D',1,now()),'MM/DD/YYYY')#'
</cfquery>
<cfquery name="get_daily_duration" datasource="#dsn3#">
	SELECT     
    	PRP.PROD_DURATION, 
        PRPT.PROD_PAUSE_TYPE, 
        OT.OPERATION_TYPE, 
        S.PRODUCT_NAME, 
        W.STATION_NAME, 
        PRO.P_ORDER_NO, 
        PRO.LOT_NO, 
      	PRP.ACTION_DATE
	FROM         
    	PRODUCTION_ORDERS AS PRO INNER JOIN
       	STOCKS AS S ON PRO.STOCK_ID = S.STOCK_ID RIGHT OUTER JOIN
       	SETUP_PROD_PAUSE AS PRP INNER JOIN
      	SETUP_PROD_PAUSE_TYPE AS PRPT ON PRP.PROD_PAUSE_TYPE_ID = PRPT.PROD_PAUSE_TYPE_ID ON 
      	PRO.P_ORDER_ID = PRP.P_ORDER_ID LEFT OUTER JOIN
     	PRODUCTION_OPERATION AS PO INNER JOIN
       	OPERATION_TYPES AS OT ON PO.OPERATION_TYPE_ID = OT.OPERATION_TYPE_ID ON PRP.OPERATION_ID = PO.P_OPERATION_ID LEFT OUTER JOIN
     	WORKSTATIONS AS W ON PRP.STATION_ID = W.STATION_ID
  	WHERE     
    	PRP.EMPLOYEE_ID = #employee_id# AND 
        PRP.ACTION_DATE > '#Dateformat(now(),'MM/DD/YYYY')#' AND 
        PRP.ACTION_DATE < '#Dateformat(Dateadd('D',1,now()),'MM/DD/YYYY')#'
</cfquery>

<table width="100%">
	<tr>
    	<td>
            <cf_box title="#getLang('main',3112)#">
                <cf_ajax_list>
                    <thead>
                        <tr height="20px">
                            <th style="width:45;text-align:center;"><cf_get_lang_main no='1165.Sıra'></th>
                         	<th style="width:100;text-align:left;"><cf_get_lang_main no='1422.İstasyon'></th>
                       		<th style="width:80;text-align:center;"><cf_get_lang_main no='1677.Emir No'></th>
                          	<th style="width:80;text-align:center;">Lot No</th>
                          	<th style="text-align:left;"><cf_get_lang_main no='245.Ürün'></th>
                          	<th style="text-align:left;"><cf_get_lang_main no='1622.Operasyon'></th>
                          	<th style="width:40;text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                          	<th style="width:90;text-align:center;"><cf_get_lang_main no='90.Bitiş'></th>
                          	<th style="width:80;text-align:right;"><cf_get_lang_main no='3113.Çalışma'></th>
                        </tr>
                    </thead>
                    <tbody>
                    	<cfif get_daily_works.recordcount>
							<cfoutput query="get_daily_works">
                   				<tr>
                                	<td style="background-color:FFFFCC;text-align:center;">#currentrow#&nbsp;</td>
                                  	<td style="background-color:FFFFCC;text-align:left;">&nbsp;#STATION_NAME#</td>
                                 	<td style="background-color:FFFFCC;text-align:center;">#P_ORDER_NO#</td>
                                 	<td style="background-color:FFFFCC;text-align:center;">#LOT_NO#</td>
                                 	<td style="background-color:FFFFCC;text-align:left;">&nbsp;#PRODUCT_NAME#</td>
                                  	<td style="background-color:FFFFCC;text-align:left;">&nbsp;#OPERATION_TYPE#</td>
                                  	<td style="background-color:FFFFCC;text-align:right;">#REAL_AMOUNT#</td>
                                	<td style="background-color:FFFFCC;text-align:center;">#TimeFormat(DateAdd('H',session.ep.time_zone,ACTION_START_DATE), 'HH:MM')#</td>
                                 	<td style="background-color:FFFFCC;text-align:right;">#REAL_TIME# Sn.&nbsp;</td>
                    			</tr>
                             	<cfset t_c_time = t_c_time + REAL_TIME>
                          	</cfoutput>
                      	</cfif>
                    </tbody>
                </cf_ajax_list>
            </cf_box>
            <br />
            <cf_box title="#getLang('report',2000)#">
                <cf_ajax_list>
                    <thead>
                        <tr height="20px">
                            <th style="width:45;text-align:center;"><cf_get_lang_main no='1165.Sıra'></th>
                         	<th style="width:100;text-align:left;"><cf_get_lang_main no='1422.İstasyon'></th>
                         	<th style="width:80;text-align:center;"><cf_get_lang_main no='1677.Emir No'></th>
                         	<th style="width:80;text-align:center;">Lot No</th>
                         	<th style="text-align:left;"><cf_get_lang_main no='245.Ürün'></th>
                          	<th style="text-align:left;"><cf_get_lang_main no='1622.Operasyon'></th>
                          	<th style="width:150;text-align:left;"><cfoutput>#getLang('production',96)#</cfoutput></th>
                         	<th style="width:90;text-align:center;"><cf_get_lang_main no='1055.Başlama'></th>
                         	<th style="width:80;text-align:right;"><cf_get_lang_main no='3103.Duraklama'></th>
                        </tr>
                    </thead>
                    <tbody>
                    	<cfif get_daily_duration.recordcount>
							<cfoutput query="get_daily_duration">
                   				<tr height="15">
                               		<td style="background-color:FFFFCC;text-align:center;">#currentrow#&nbsp;</td>
                                  	<td style="background-color:FFFFCC;text-align:left;">&nbsp;#STATION_NAME#</td>
                                  	<td style="background-color:FFFFCC;text-align:center;">#P_ORDER_NO#</td>
                                  	<td style="background-color:FFFFCC;text-align:center;">#LOT_NO#</td>
                                 	<td style="background-color:FFFFCC;text-align:left;">&nbsp;#PRODUCT_NAME#</td>
                                  	<td style="background-color:FFFFCC;text-align:left;">&nbsp;#OPERATION_TYPE#</td>
                                 	<td style="background-color:FFFFCC;text-align:left;">#PROD_PAUSE_TYPE#</td>
                                  	<td style="background-color:FFFFCC;text-align:center;">#TimeFormat(DateAdd('H',session.ep.time_zone,ACTION_DATE), 'HH:MM')#</td>
                                 	<td style="background-color:FFFFCC;text-align:right;">#PROD_DURATION# Sn&nbsp;.</td>
                    			</tr>
                             	<cfset t_d_time = t_d_time + PROD_DURATION>
                          	</cfoutput>
                      	</cfif>
                    </tbody>
                </cf_ajax_list>
            </cf_box>
        </td>
    </tr>
</table>
<br>
<table border="0" width="100%">
	<tr height="20">
    	<td class="box_yazi_td2" style="width:100%;text-align:right">
        	<input type="button" value="<cfoutput>#getLang('main',141)#</cfoutput>" name="kapat" onClick="window.close();" style=" width:100px; height:50px">
       	</td>
  	</tr>
</table>
<script type="text/javascript">
	function sw_start(type)
	{
		
		<cfoutput>
			var p_order_id = <cfif isdefined('attributes.upd_id')>#attributes.upd_id#<cfelse>''</cfif>;
			var station_id = <cfif isdefined('attributes.station_id_')>#attributes.station_id_#<cfelse>''</cfif>; 
			var operation_id = <cfif isdefined('attributes.operation_id_')>#attributes.operation_id_#<cfelse>''</cfif>;
			var employee_id = <cfif isdefined('attributes.employee_id_')>#attributes.employee_id_#<cfelse>''</cfif>;
			var result_id = <cfif isdefined('attributes.result_id')>#attributes.result_id#<cfelse>''</cfif>;
		</cfoutput>
		var prod_pause_ = document.all.prod_pause.value;
		if(type==3)
		{
			window.close();
		}
		if(type==1)
		{
			if(prod_pause_=='')
			{
		 		alert('<cf_get_lang_main no='3114.Lütfen Önce Seçim Yapınız'> !!');
			}
			else
			{
				window.location ='<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_add_ezgi_prod_pause&p_order_id='+p_order_id+'&station_id='+station_id+'&operation_id='+operation_id+'&employee_id='+employee_id+'&prod_pause='+prod_pause_+'&result_id='+result_id;
			}
		}
	}
</script>  