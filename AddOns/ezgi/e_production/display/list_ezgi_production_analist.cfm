<cfif not isdefined("attributes.is_excel")>
	<cfsetting showdebugoutput="yes">
</cfif>
<cfset total_amount = 0>
<cfset t_total_amount = 0>
<cfset total_loss = 0>
<cfset t_total_loss = 0>
<cfset total_time = 0>
<cfset t_total_time = 0>
<cfparam name="attributes.controller_emp_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_filtre" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.controller_emp" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.operation_type_id" default="">
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.is_virtual" default="">
<cfparam name="attributes.k_stock_id" default="1">
<cfparam name="attributes.k_lot_no" default="1">
<cfparam name="attributes.k_employee_id" default="1">
<cfparam name="attributes.k_station_id" default="1">
<cfparam name="attributes.k_opertaion_id" default="1">
<cfparam name="attributes.k_action_date" default="1">
<cfparam name="attributes.k_all" default="1">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-1,wrk_get_today())>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',1,attributes.start_date)>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_station" datasource="#dsn3#">
	SELECT     
    	E.STATION_ID, 
        W.STATION_NAME
	FROM         
    	EZGI_OPERATION_M AS E INNER JOIN
        WORKSTATIONS AS W ON E.STATION_ID = W.STATION_ID
	GROUP BY 
    	E.STATION_ID, 
        W.STATION_NAME
  	ORDER BY
    	W.STATION_NAME
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT     
    	DP.DEPARTMENT_ID, 
        DP.DEPARTMENT_HEAD
	FROM         
    	DEPARTMENT AS DP INNER JOIN
        #dsn3_alias#.WORKSTATIONS AS D ON DP.DEPARTMENT_ID = D.DEPARTMENT
	WHERE     
    	DP.DEPARTMENT_STATUS = 1 AND 
        DP.IS_PRODUCTION = 1
	GROUP BY 
    	DP.DEPARTMENT_ID, 
        DP.DEPARTMENT_HEAD
</cfquery>
<cfoutput query="get_station">
	<cfset 'STATION_NAME_#STATION_ID#' = STATION_NAME >
</cfoutput>
<cfquery name="get_operation" datasource="#dsn3#">
	SELECT     
    	E.OPERATION_TYPE_ID, 
        O.OPERATION_TYPE
	FROM         
    	EZGI_OPERATION_M AS E INNER JOIN
        OPERATION_TYPES AS O ON E.OPERATION_TYPE_ID = O.OPERATION_TYPE_ID

	GROUP BY 
    	E.OPERATION_TYPE_ID, 
        O.OPERATION_TYPE
   	ORDER BY
    	O.OPERATION_TYPE
</cfquery>
<cfoutput query="get_operation">
	<cfset 'OPERATION_TYPE_#OPERATION_TYPE_ID#' = OPERATION_TYPE >
</cfoutput>
<cfif isdefined("attributes.form_varmi")>
	<cfquery name="quality_row" datasource="#dsn3#">
			SELECT
            	<cfif attributes.k_stock_id eq 1>     
                	STOCK_ID, 
                    PRODUCT_NAME,
              	</cfif> 
               	<cfif attributes.k_lot_no eq 1> 
                	P_ORDER_ID,     
                    LOT_NO, 
              	</cfif>
                <cfif attributes.k_employee_id eq 1>      
                    ACTION_EMPLOYEE_ID, 
               	</cfif>
                <cfif attributes.k_station_id eq 1>     
                    STATION_ID, 
               	</cfif>
                <cfif attributes.k_opertaion_id eq 1>     
                    OPERATION_TYPE_ID,
                    OPERATION_CODE,
               	</cfif>
                <cfif attributes.k_action_date eq 1>     
                    CONVERT(nvarchar(50), ACTION_START_DATE, 103) AS ACTION_START_DATE,
               	</cfif>   
                ISNULL(IS_VIRTUAL,0) AS IS_VIRTUAL,
                SUM(REAL_AMOUNT) AS REAL_AMOUNT,
                SUM(LOSS_AMOUNT) AS LOSS_AMOUNT,  
               	SUM(REAL_TIME) AS REAL_TIME
			FROM         
               	EZGI_OPERATION_M
			WHERE  
            	(REAL_AMOUNT >0 OR LOSS_AMOUNT >0)
                <cfif len(attributes.is_filtre)>
                    AND PRODUCT_NAME LIKE '%#attributes.is_filtre#%'
                </cfif> 
            	<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
					AND ACTION_EMPLOYEE_ID = #attributes.controller_emp_id#
				</cfif> 
                <cfif len(attributes.start_date)>
                    AND ACTION_START_DATE >= #attributes.start_date#
                </cfif>
                <cfif len(attributes.finish_date)>
                    AND ACTION_START_DATE < #dateadd('d',1,attributes.finish_date)#
                </cfif>
                <cfif len(attributes.lot_no)>
                    AND LOT_NO LIKE '%#attributes.lot_no#%'
                </cfif> 
                <cfif len(attributes.product_id) and len(attributes.product_name)>
                    AND STOCK_ID IN (SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = #attributes.product_id#)
                </cfif>
                <cfif len(attributes.operation_type_id)>
                    AND OPERATION_TYPE_ID = #attributes.operation_type_id#
                </cfif>
                <cfif len(attributes.station_id)>
                    AND STATION_ID=#attributes.station_id#			
                </cfif>
                <cfif len(attributes.department_id)>
                	AND STATION_ID IN
                    				(
                                    SELECT     
                                    	STATION_ID
									FROM  
                                    	WORKSTATIONS AS D
									WHERE     
                                    	DEPARTMENT = #attributes.department_id#
                                    )
                </cfif>
                <cfif len(attributes.is_virtual)>
                    AND ISNULL(IS_VIRTUAL,0) = #attributes.is_virtual#			
                </cfif>
			GROUP BY 
               	<cfif attributes.k_stock_id eq 1>     
               		STOCK_ID, 
                    PRODUCT_NAME,
              	</cfif> 
               	<cfif attributes.k_lot_no eq 1>   
                	P_ORDER_ID,   
                    LOT_NO, 
              	</cfif>
                <cfif attributes.k_employee_id eq 1>      
                    ACTION_EMPLOYEE_ID, 
               	</cfif>
                <cfif attributes.k_station_id eq 1>     
                    STATION_ID, 
               	</cfif>
                <cfif attributes.k_opertaion_id eq 1>     
                    OPERATION_TYPE_ID,
                    OPERATION_CODE,
               	</cfif> 
                <cfif attributes.k_action_date eq 1>     
                    CONVERT(nvarchar(50), ACTION_START_DATE, 103),
               	</cfif> 
                IS_VIRTUAL
        	ORDER BY 
            	<cfif attributes.k_lot_no eq 1> 
            		LOT_NO, 
                </cfif>
                <cfif attributes.k_opertaion_id eq 1>     
                	OPERATION_CODE,
               	</cfif>
                <cfif attributes.k_employee_id eq 1>      
                    ACTION_EMPLOYEE_ID, 
               	</cfif>
                <cfif attributes.k_station_id eq 1>     
                    STATION_ID, 
               	</cfif>
                <cfif attributes.k_action_date eq 1>     
                    ACTION_START_DATE,
               	</cfif> 
             	REAL_AMOUNT desc 
	</cfquery>
    <cfoutput query="quality_row">
		<cfset t_total_amount = t_total_amount+ REAL_AMOUNT>
        <cfset t_total_loss = t_total_loss+ LOSS_AMOUNT>
        <cfset t_total_time = t_total_time+ REAL_TIME>
    </cfoutput>
</cfif>

<cfif isdefined("attributes.form_varmi")>
	<cfif not isdefined("quality_row.QUERY_COUNT")>
    	<cfparam name="attributes.totalrecords" default="#quality_row.recordcount#">
    <cfelse>
    	<cfparam name="attributes.totalrecords" default="0">
    </cfif>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cf_big_list_search title="#getLang('report',873)#">
	<cfform name="quality_control" id="quality_control" method="post" action="#request.self#?fuseaction=prod.popup_ezgi_production_analist">
	<input name="form_varmi" id="form_varmi" value="1" type="hidden">
    	<cf_big_list_search_area>
            <table>
                <tr>
                	<td><cf_get_lang_main no='160.Departman'></td>
                    <td>
                    	<select name="department_id" id="department_id" style="width:110px;">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            <cfoutput query="get_department">
                                <option value="#department_id#" <cfif attributes.department_id eq department_id>selected</cfif>>#department_head#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="is_filtre" id="is_filtre" style="width:90px;" value="#attributes.is_filtre#"></td>
                    <td nowrap="nowrap">Lot No</td>
                    <td><cfinput type="text" name="lot_no" id="lot_no" style="width:90px;" value="#attributes.lot_no#"></td>
                    <td nowrap="nowrap"><cf_get_lang_main no='467.İşlem Tarihi'></td>
                    <td nowrap="nowrap">
                    	<cfinput type="text" name="start_date" id="start_date"  value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10"><cf_wrk_date_image date_field="start_date">
                        <cfinput type="text" name="finish_date" id="finish_date"  value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10"><cf_wrk_date_image date_field="finish_date">
                    </td>
                    <td>
                    	<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#" style="width:25px;">
                       	<cf_wrk_search_button><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                    </td>
                </tr>
            </table>
        </cf_big_list_search_area>
        <cf_big_list_search_detail_area>
            <table>
                <tr>
                    <td><cf_get_lang_main no='245.Ürün'></td>
                    <td>
                        <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                        <input type="text" name="product_name" id="product_name" style="width:100px;" value="<cfoutput>#attributes.product_name#</cfoutput>">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=quality_control.product_id&field_name=quality_control.product_name','list');"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
                   </td>
                    <td nowrap="nowrap"><cf_get_lang_main no='164.Çalışan'></td>
                    <td nowrap="nowrap">
                        <input type="hidden" name="controller_emp_id" id="controller_emp_id" value="<cfif len(attributes.controller_emp_id)><cfoutput>#attributes.controller_emp_id#</cfoutput></cfif>">			
                        <input type="text" name="controller_emp" id="controller_emp" value="<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)><cfoutput>#attributes.controller_emp#</cfoutput></cfif>" onfocus="AutoComplete_Create('controller_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','controller_emp_id','','3','130');" autocomplete="off" style="width:100px;">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_emps&field_id=quality_control.controller_emp_id&field_name=quality_control.controller_emp&select_list=1</cfoutput>','list');"><img src="/images/plus_thin.gif" align="top" border="0"></a>
                    </td>
                    <td><cf_get_lang_main no='3295.Üretim Şekli'></td>
                    <td>
                    	<select name="is_virtual" id="is_virtual" style="width:110px; height:20px">
                            <option value="" <cfif attributes.is_virtual eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
                            <option value="0" <cfif attributes.is_virtual eq '0'>selected</cfif>><cf_get_lang_main no='3293.Gerçek'></option>
                            <option value="1" <cfif attributes.is_virtual eq '1'>selected</cfif>><cf_get_lang_main no='1515.Sanal'></option>
                        </select>
                    </td>
                    <td><cf_get_lang_main no='1422.İstasyon'></td>
                    <td>
                    	<select name="station_id" id="station_id" style="width:110px; height:20px">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            <cfoutput query="get_station">
                                <option value="#station_id#" <cfif attributes.station_id eq station_id>selected</cfif>>#station_name#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td nowrap="nowrap"><cf_get_lang_main no='1622.Operasyon'></td>
                    <td>
                        <select name="operation_type_id" id="operation_type_id" style="width:150px; height:20px">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            <cfoutput query="get_operation">
                                <option value="#operation_type_id#" <cfif attributes.operation_type_id eq operation_type_id>selected</cfif>>#OPERATION_TYPE#</option>
                            </cfoutput>
                        </select>
                    </td>
				</tr>
                <tr>
                	<td colspan="10">
                    	<tr>
                        	<table style="width:100%">
                                <td></td>
                                <td>
                                    <strong><cf_get_lang_main no='669.Hepsi'></strong> 
                                    <select name="k_all" onchange="hepsi();" style="width:70px; height:20px">
                                        <option value="1" <cfif attributes.k_all eq '1'>selected</cfif>><cf_get_lang_main no='1184.Göster'></option>
                                        <option value="0" <cfif attributes.k_all eq '0'>selected</cfif>><cf_get_lang_main no='1216.Gizle'></option>
                                    </select>
                                </td>
                                <td>
                                    <cf_get_lang_main no='245.Ürün'> 
                                    <select name="k_stock_id" style="width:70px; height:20px">
                                        <option value="1" <cfif attributes.k_stock_id eq '1'>selected</cfif>><cf_get_lang_main no='1184.Göster'></option>
                                        <option value="0" <cfif attributes.k_stock_id eq '0'>selected</cfif>><cf_get_lang_main no='1216.Gizle'></option>
                                    </select>
                                </td>
                                <td>
                                    <cfoutput>#getLang('objects',526)#</cfoutput>
                                    <select name="k_lot_no" style="width:70px; height:20px">
                                        <option value="1" <cfif attributes.k_lot_no eq '1'>selected</cfif>><cf_get_lang_main no='1184.Göster'></option>
                                        <option value="0" <cfif attributes.k_lot_no eq '0'>selected</cfif>><cf_get_lang_main no='1216.Gizle'></option>
                                    </select>
                                </td>
                                <td>
                                    <cf_get_lang_main no='164.Çalışan'>
                                    <select name="k_employee_id" style="width:70px; height:20px">
                                        <option value="1" <cfif attributes.k_employee_id eq '1'>selected</cfif>><cf_get_lang_main no='1184.Göster'></option>
                                        <option value="0" <cfif attributes.k_employee_id eq '0'>selected</cfif>><cf_get_lang_main no='1216.Gizle'></option>
                                    </select>
                                </td>
                                <td>
                                    <cf_get_lang_main no='1422.İstasyon'>  
                                    <select name="k_station_id" style="width:70px; height:20px">
                                        <option value="1" <cfif attributes.k_station_id eq '1'>selected</cfif>><cf_get_lang_main no='1184.Göster'></option>
                                        <option value="0" <cfif attributes.k_station_id eq '0'>selected</cfif>><cf_get_lang_main no='1216.Gizle'></option>
                                    </select>
                                </td>
                                <td>
                                    <cf_get_lang_main no='1622.Operasyon'> 
                                    <select name="k_opertaion_id" style="width:70px; height:20px">
                                        <option value="1" <cfif attributes.k_opertaion_id eq '1'>selected</cfif>><cf_get_lang_main no='1184.Göster'></option>
                                        <option value="0" <cfif attributes.k_opertaion_id eq '0'>selected</cfif>><cf_get_lang_main no='1216.Gizle'></option>
                                    </select>
                                </td>
                                <td>
                                    <cf_get_lang_main no='3296.Üretim Tarihi'>  
                                    <select name="k_action_date" style="width:70px; height:20px">
                                        <option value="1" <cfif attributes.k_action_date eq '1'>selected</cfif>><cf_get_lang_main no='1184.Göster'></option>
                                        <option value="0" <cfif attributes.k_action_date eq '0'>selected</cfif>><cf_get_lang_main no='1216.Gizle'></option>
                                    </select>
                                </td>
                           	</table>
                       	</tr>
                   	</td>
                </tr>
         	</table> 
        </cf_big_list_search_detail_area>
	</cfform>
</cf_big_list_search>    
<cf_big_list>
	<!-- sil -->
    <thead>
        <tr>
        	<cfset row_ = 1>
            <th style="width:25px; text-align:center"><cf_get_lang_main no='1165.Sıra'></th>
            <cfif attributes.k_stock_id eq 1> 
            	<th style="width:350px; text-align:center"><cf_get_lang_main no='245.Ürün'></th>
            	<cfset row_ = row_ +1>
            </cfif>
           	<cfif attributes.k_lot_no eq 1>
            	<th style="width:80px; text-align:center">Lot No</th>
                <cfset row_ = row_ +1>
            </cfif>
            <cfif attributes.k_employee_id eq 1> 
            	<th style="width:150px; text-align:center"><cf_get_lang_main no='164.Çalışan'></th>
                <cfset row_ = row_ +1>
            </cfif>
            <cfif attributes.k_station_id eq 1>
            	<th style="width:150px; text-align:center"><cf_get_lang_main no='1422.İstasyon'></th>
                <cfset row_ = row_ +1>
            </cfif>
            <cfif attributes.k_opertaion_id eq 1>
            	<th style="width:110px; text-align:center"><cf_get_lang_main no='1622.Operasyon'></th>
                <cfset row_ = row_ +1>
            </cfif>
            <cfif attributes.k_action_date eq 1>
            	<th style="width:80px; text-align:center"><cf_get_lang_main no='3296.Üretim Tarihi'></th>
                <cfset row_ = row_ +1>
            </cfif>
            <th style="width:50px; text-align:center"><cf_get_lang_main no='1515.Sanal'></th>
            <th style="width:50px; text-align:center"><cf_get_lang_main no='44.Üretim'></th>
            <th style="width:50px; text-align:center"><cf_get_lang_main no='1674.Fire'></th>
            <th style="width:50px; text-align:center"><cf_get_lang_main no='1716.Süre'></th>
            <td></td>
       </tr>
    </thead>
    <tbody>
        <cfif isdefined("attributes.form_varmi") and quality_row.recordcount>
            <cfoutput query="quality_row" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr class="color-row">
                    <td style="text-align:right">#currentrow#</td>
                    <cfif attributes.k_stock_id eq 1>     
                        <td style="text-align:left">#product_name#</td>
                    </cfif>
                   	<cfif attributes.k_lot_no eq 1>      
                        <td style="text-align:center">
                        	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.form_upd_prod_order&upd=#P_ORDER_ID#','longpage');" class="tableyazi">
                        		#LOT_NO#
                            </a>
                       	</td> 
                    </cfif>
                    <cfif attributes.k_employee_id eq 1>      
                        <td style="text-align:center">#get_emp_info(ACTION_EMPLOYEE_ID,0,0)#</td> 
                    </cfif>
                    <cfif attributes.k_station_id eq 1>     
                        <td style="text-align:center">#Evaluate('STATION_NAME_#STATION_ID#')#</td>
                    </cfif>
                    <cfif attributes.k_opertaion_id eq 1>     
                        <td style="text-align:center">#Evaluate('OPERATION_TYPE_#OPERATION_TYPE_ID#')#</td>
                    </cfif>
                    <cfif attributes.k_action_date eq 1>   
                    	<td style="text-align:center">#dateformat(ACTION_START_DATE,'dd/mm/yyyy')#</td>  
                    </cfif> 
                    <td style="text-align:right"><cfif IS_VIRTUAL eq 1>Sanal<cfelse>Gerçek</cfif></td>
                    <cfset totaltime = "#REAL_TIME\60#:#numberformat(REAL_TIME % 60, "00")#">
                    <td style="text-align:right">#Tlformat(REAL_AMOUNT)#</td>
                    <td style="text-align:right">#Tlformat(LOSS_AMOUNT)#</td>
                    <td style="text-align:right">#totaltime#</td> 
                    <td></td>
                    <cfset total_amount = total_amount+ REAL_AMOUNT>
					<cfset total_loss = total_loss+ LOSS_AMOUNT>
                    <cfset total_time = total_time+ REAL_TIME>  
                </tr>
                <cfset son_row = currentrow>
            </cfoutput>
      	    <tfoot>
                <tr>
                    <td colspan="<cfoutput>#row_#</cfoutput>"><cf_get_lang_main no='80.Toplam'> : </td>
                    <td></td>
                    <td style="text-align:right" class="txtbold">
                  		<cfoutput>
                        	<cfif attributes.totalrecords gt son_row>
                        		#TLFormat(total_amount)#
							<cfelse>
                            	#TLFormat(t_total_amount)#
                            </cfif>		
						</cfoutput>
                    </td>
                    <td style="text-align:right" class="txtbold">
                  		<cfoutput>
                        	<cfif attributes.totalrecords gt son_row>
                        		#TLFormat(total_loss)#
							<cfelse>
                            	#TLFormat(t_total_loss)#
                            </cfif>		
						</cfoutput>
                    </td>
                    <!---<td style="text-align:right" class="txtbold">
                  		<cfoutput>
                        	<cfif attributes.totalrecords gt son_row>
                            	<cfset a_totaltime = "#total_time\60#:#numberformat(total_time % 60, "00")#">
                        		#TLFormat(a_totaltime)#
							<cfelse>
                            	<cfset t_totaltime = "#t_total_time\60#:#numberformat(t_total_time % 60, "00")#">
                            	#TLFormat(t_totaltime)#
                            </cfif>		
						</cfoutput>
                    </td>--->
                    <td></td>
                    <td></td>
                </tr>
            </tfoot>  
            <!-- sil -->
        <cfelse>
            <tr><td class="color-row" colspan="20"><cfif not isdefined("attributes.form_varmi")><cf_get_lang_main no='289.Filtre ediniz'> !<cfelse><cf_get_lang_main no='72.Kaıt Yok'> !</cfif></td></tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfif isdefined("attributes.form_varmi")>
	<cfset url_str = "prod.popup_ezgi_production_analist">
    <cfif attributes.totalrecords gt attributes.maxrows>
     <table width="99%" align="center" cellpadding="0" cellspacing="0">
        <cfif len(attributes.product_id) and len(attributes.product_name)>
            <cfset url_str = "#url_str#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
        </cfif>
        <cfif len(attributes.is_filtre)>
            <cfset url_str = "#url_str#&is_filtre=#attributes.is_filtre#">
        </cfif>
        <cfif len(attributes.start_date)>
            <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
        </cfif>
        <cfif len(attributes.finish_date)>
            <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
        </cfif>
        <cfif len(attributes.lot_no)>
            <cfset url_str = "#url_str#&lot_no=#attributes.lot_no#">
        </cfif>
        <cfif len(attributes.station_id)>
            <cfset url_str = "#url_str#&station_id=#attributes.station_id#">
        </cfif>
        <cfif len(attributes.department_id)>
            <cfset url_str = "#url_str#&department_id=#attributes.department_id#">
        </cfif>
        <cfif len(attributes.operation_type_id)>
            <cfset url_str = "#url_str#&operation_type_id=#attributes.operation_type_id#">
        </cfif>
        <cfif len(attributes.controller_emp)>
            <cfset url_str = "#url_str#&controller_emp=#attributes.controller_emp#">
        </cfif>
        <cfif len(attributes.controller_emp_id)>
            <cfset url_str = "#url_str#&controller_emp_id=#attributes.controller_emp_id#">
        </cfif>
        <cfif len(attributes.k_stock_id)>
            <cfset url_str = "#url_str#&k_stock_id=#attributes.k_stock_id#">
        </cfif>
        <cfif len(attributes.k_lot_no)>
            <cfset url_str = "#url_str#&k_lot_no=#attributes.k_lot_no#">
        </cfif>
        <cfif len(attributes.k_employee_id)>
            <cfset url_str = "#url_str#&k_employee_id=#attributes.k_employee_id#">
        </cfif>
        <cfif len(attributes.k_station_id)>
            <cfset url_str = "#url_str#&k_station_id=#attributes.k_station_id#">
        </cfif>
        <cfif len(attributes.k_opertaion_id)>
            <cfset url_str = "#url_str#&k_opertaion_id=#attributes.k_opertaion_id#">
        </cfif>
        <cfif len(attributes.k_action_date)>
            <cfset url_str = "#url_str#&k_action_date=#attributes.k_action_date#">
        </cfif>
        <cfif len(attributes.k_all)>
            <cfset url_str = "#url_str#&k_all=#attributes.k_all#">
        </cfif>
		<tr>
            <td><cf_pages 
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_str#&form_varmi=1">
            </td>
            <td align="right" style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
        </tr>
		</table>
     </cfif>
</cfif>
<script type="text/javascript">
	function kontrol()
	{
		document.getElementById('quality_control').action="<cfoutput>#request.self#?fuseaction=prod.popup_ezgi_production_analist</cfoutput>"
		return true;
	}
	function hepsi()
	{
		var hepsi=document.quality_control.k_all.value;
		document.quality_control.k_stock_id.value=hepsi;
		document.quality_control.k_lot_no.value=hepsi;
		document.quality_control.k_employee_id.value=hepsi;
		document.quality_control.k_station_id.value=hepsi;
		document.quality_control.k_opertaion_id.value=hepsi;
		document.quality_control.k_action_date.value=hepsi;
	}
</script>