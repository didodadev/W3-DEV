<cf_get_lang_set module_name="prod">
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.durum" default="1">
<cfparam name="attributes.is_form_submitted" default="">
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
  <cfset attributes.maxrows = session.ep.maxrows>
</cfif>
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
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif len(attributes.is_form_submitted)>
	<cfif len(attributes.durum) and attributes.durum eq 1>
    	<cfquery name="get_employees" datasource="#dsn#">
        	SELECT     
            	E.EMPLOYEE_NO, 
            	EP.POSITION_ID, 
                EP.EMPLOYEE_ID, 
                EP.EMPLOYEE_NAME, 
                EP.EMPLOYEE_SURNAME, 
                ESE.START_DATE, 
                ESE.FINISH_DATE, 
            	W.STATION_NAME, 
                W.STATION_ID, 
                TBL.PROD_PAUSE_TYPE_ID, 
                DATEADD(hh,#session.ep.time_zone#,TBL.ACTION_DATE) ACTION_DATE,
                SP.PROD_PAUSE_TYPE
			FROM         
            	(
                	SELECT     
                    	STATION_ID, 
                        PROD_PAUSE_TYPE_ID,
                        ACTION_DATE
                	FROM          
                    	#dsn3_alias#.SETUP_PROD_PAUSE
                  	WHERE      
                    	PROD_DURATION IS NULL
               	) AS TBL INNER JOIN
         		#dsn3_alias#.SETUP_PROD_PAUSE_TYPE AS SP ON TBL.PROD_PAUSE_TYPE_ID = SP.PROD_PAUSE_TYPE_ID RIGHT OUTER JOIN
            	#dsn3_alias#.EZGI_STATION_EMPLOYEE AS ESE ON TBL.STATION_ID = ESE.STATION_ID LEFT OUTER JOIN
              	#dsn3_alias#.WORKSTATIONS AS W ON ESE.STATION_ID = W.STATION_ID RIGHT OUTER JOIN
               	EMPLOYEE_POSITIONS AS EP INNER JOIN
              	EMPLOYEES AS E ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID ON ESE.EMPLOYEE_ID = E.EMPLOYEE_ID
			WHERE     
            	<cfif len(attributes.department_id)>
                    EP.DEPARTMENT_ID = #attributes.department_id# AND
                </cfif> 
                EP.POSITION_STATUS = 1 AND 
                E.EMPLOYEE_STATUS = 1 AND 
                ESE.FINISH_DATE IS NULL AND 
                W.STATION_ID IS NOT NULL
			ORDER BY 
            	W.STATION_NAME, 
                EP.EMPLOYEE_NAME, 
                EP.EMPLOYEE_SURNAME
        </cfquery>
    <cfelse>
        <cfquery name="get_employees1" datasource="#dsn#">
            SELECT DISTINCT
                E.EMPLOYEE_NO,   
                EP.POSITION_ID, 
                EP.EMPLOYEE_ID, 
                EP.EMPLOYEE_NAME, 
                EP.EMPLOYEE_SURNAME, 
                ESE.START_DATE, 
                ESE.FINISH_DATE, 
                W.STATION_NAME, 
                EOS.P_ORDER_ID, 
                EOS.LOT_NO, 
                EOS.P_ORDER_NO, 
                EOS.IS_STAGE, 
                EOS.STOCK_ID, 
                EOS.PRODUCT_NAME, 
                EOS.QUANTITY, 
                EOS.OPERATION_TYPE_ID, 
                EOS.OPERATION_CODE, 
                EOS.OPERATION_TYPE, 
                EOS.AMOUNT, 
                EOS.STAGE, 
                EOS.ACTION_START_DATE, 
                EOS.REAL_AMOUNT, 
                EOS.LOSS_AMOUNT, 
                EOS.O_START_DATE,
                EOS.O_FINISH_DATE, 
                EOS.STATION_ID, 
                EOS.O_TOTAL_PROCESS_TIME, 
                EOS.STATION_NAME AS O_STATION_NAME
            FROM         
                #dsn3_alias#.EZGI_OPERATION_M AS EOS RIGHT OUTER JOIN
                #dsn3_alias#.EZGI_STATION_EMPLOYEE AS ESE ON EOS.ACTION_EMPLOYEE_ID = ESE.EMPLOYEE_ID LEFT OUTER JOIN
                #dsn3_alias#.WORKSTATIONS AS W ON ESE.STATION_ID = W.STATION_ID RIGHT OUTER JOIN
                EMPLOYEE_POSITIONS AS EP INNER JOIN
                EMPLOYEES AS E ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID ON ESE.EMPLOYEE_ID = E.EMPLOYEE_ID
            WHERE 
                <cfif len(attributes.department_id)>
                    W.DEPARTMENT = #attributes.department_id# AND
                </cfif>                       
                EP.POSITION_STATUS = 1 AND 
                ISNULL(EOS.STAGE,1) <> 3 AND
                E.EMPLOYEE_STATUS = 1 AND
                ESE.FINISH_DATE IS NULL <!---AND
                (
                EOS.MASTER_ALT_PLAN_ID IN
                                        (
                                        SELECT     
                                            EMAP.MASTER_ALT_PLAN_ID
                                        FROM         
                                            #dsn3_alias#.EZGI_MASTER_ALT_PLAN AS EMAP INNER JOIN
                                            #dsn3_alias#.EZGI_MASTER_PLAN AS EMP ON EMAP.MASTER_PLAN_ID = EMP.MASTER_PLAN_ID
                                        WHERE     
                                            EMP.MASTER_PLAN_CAT_ID = #attributes.shift_id#
                                        )
                
                OR 
                EOS.MASTER_ALT_PLAN_ID IS NULL
                )--->
         	UNION ALL
            SELECT DISTINCT
                E.EMPLOYEE_NO,   
                EP.POSITION_ID, 
                EP.EMPLOYEE_ID, 
                EP.EMPLOYEE_NAME, 
                EP.EMPLOYEE_SURNAME, 
                ESE.START_DATE, 
                ESE.FINISH_DATE, 
                W.STATION_NAME, 
                EOS.P_ORDER_ID, 
                EOS.LOT_NO, 
                EOS.P_ORDER_NO, 
                EOS.IS_STAGE, 
                EOS.STOCK_ID, 
                EOS.PRODUCT_NAME, 
                EOS.QUANTITY, 
                EOS.OPERATION_TYPE_ID, 
                EOS.OPERATION_CODE, 
                EOS.OPERATION_TYPE, 
                EOS.AMOUNT, 
                EOS.STAGE, 
                EOS.ACTION_START_DATE, 
                EOS.REAL_AMOUNT, 
                EOS.LOSS_AMOUNT, 
                EOS.O_START_DATE,
                EOS.O_FINISH_DATE, 
                EOS.STATION_ID, 
                EOS.O_TOTAL_PROCESS_TIME, 
                EOS.STATION_NAME AS O_STATION_NAME
            FROM         
                #dsn3_alias#.EZGI_OPERATION_S AS EOS RIGHT OUTER JOIN
                #dsn3_alias#.EZGI_STATION_EMPLOYEE AS ESE ON EOS.ACTION_EMPLOYEE_ID = ESE.EMPLOYEE_ID LEFT OUTER JOIN
                #dsn3_alias#.WORKSTATIONS AS W ON ESE.STATION_ID = W.STATION_ID RIGHT OUTER JOIN
                EMPLOYEE_POSITIONS AS EP INNER JOIN
                EMPLOYEES AS E ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID ON ESE.EMPLOYEE_ID = E.EMPLOYEE_ID
            WHERE 
                <cfif len(attributes.department_id)>
                    W.DEPARTMENT = #attributes.department_id# AND
                </cfif>                       
                EP.POSITION_STATUS = 1 AND 
                ISNULL(EOS.STAGE,1) <> 3 AND
                E.EMPLOYEE_STATUS = 1 AND
                ESE.FINISH_DATE IS NULL <!---AND
                (
                EOS.MASTER_ALT_PLAN_ID IN
                                        (
                                        SELECT     
                                            EMAP.MASTER_ALT_PLAN_ID
                                        FROM         
                                            #dsn3_alias#.EZGI_MASTER_ALT_PLAN AS EMAP INNER JOIN
                                            #dsn3_alias#.EZGI_MASTER_PLAN AS EMP ON EMAP.MASTER_PLAN_ID = EMP.MASTER_PLAN_ID
                                        WHERE     
                                            EMP.MASTER_PLAN_CAT_ID = #attributes.shift_id#
                                        )
                
                OR 
                EOS.MASTER_ALT_PLAN_ID IS NULL
                )--->
            ORDER BY 
                W.STATION_NAME,
                EP.EMPLOYEE_NAME, 
                EP.EMPLOYEE_SURNAME,
                EOS.ACTION_START_DATE
        </cfquery>
        <cfif get_employees1.recordcount>
            <cfquery name="get_employees" dbtype="query">
                SELECT DISTINCT
                    EMPLOYEE_NO,   
                    POSITION_ID, 
                    EMPLOYEE_ID, 
                    EMPLOYEE_NAME,
                    STATION_ID, 
                    EMPLOYEE_SURNAME
                    <cfif len(attributes.durum) and attributes.durum neq 0>
                        , 
                        START_DATE, 
                        FINISH_DATE, 
                        STATION_NAME
                        <cfif len(attributes.durum) and attributes.durum eq 2>        
                            , 
                            P_ORDER_ID, 
                            LOT_NO, 
                            PRODUCT_NAME, 
                            OPERATION_TYPE, 
                            O_STATION_NAME, 
                            ACTION_START_DATE,
                            AMOUNT
                        </cfif>      
                    </cfif>
                FROM  
                    get_employees1
                WHERE
                    1=1
                    <cfif len(attributes.durum) and (attributes.durum eq 1 or attributes.durum eq 2)>
                         AND START_DATE IS NOT NULL AND FINISH_DATE IS NULL
                    </cfif>
                    <cfif len(attributes.durum) and attributes.durum eq 2>
                        AND (REAL_AMOUNT = 0) AND (LOSS_AMOUNT = 0)
                    </cfif>
                <cfif len(attributes.durum) and attributes.durum eq 0>
                    GROUP BY
                        EMPLOYEE_NO,   
                        POSITION_ID, 
                        EMPLOYEE_ID, 
                        EMPLOYEE_NAME,
                        STATION_ID, 
                        EMPLOYEE_SURNAME
                </cfif>         
            </cfquery>
        <cfelse>
        	<cfset get_employees.recordcount = 0>
        </cfif>
        <cfset arama_yapilmali=0>
   	</cfif>
<cfelse>
	<cfset arama_yapilmali=1>
    <cfset get_employees.recordcount = 1>
</cfif>
<cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
	<cfinput name="master_plan_id" type="hidden" value="#attributes.master_plan_id#">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
    <input name="type" type="hidden" value="4">
    <cf_big_list_search title="#getLang('main',3215)#" collapsed="1">
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
                    <td align="right" width="35"><cf_get_lang_main no='245.Ürün'></td>
                    <td width="160">
                    	<select name="durum" style=" width:150px">
                            <option value="1" <cfif attributes.durum eq '1'>selected</cfif>><cf_get_lang_main no='3216.İstasyona Giriş Yapanlar'></option>
                          	<option value="2" <cfif attributes.durum eq '2'>selected</cfif>><cf_get_lang_main no='3217.İstasyonda İş Yapanlar'></option>  
                        </select>
                    </td>
                    <td></td>
                    <td width="20">
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					
					<td><cf_wrk_search_button> <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>

    <cf_big_list id="list_product_big_list">
        <thead>
            <tr>
                <th style="text-align:center; width:25px"><cf_get_lang_main no='1165.Sıra'></th>
                <th style="text-align:center;"><cfoutput>#getLang('ehesap',823)#</cfoutput></th>
                <th style="text-align:center; width:100px"><cf_get_lang_main no='1422.İstasyon'></th>
                <th style="text-align:center; width:100px"><cf_get_lang_main no='3218.Giriş Zamanı'></th>
                <th style="text-align:center; width:80px"><cfoutput>#getLang('report',740)#</cfoutput></th>
                <th style="text-align:center;"><cfif len(attributes.durum) and attributes.durum eq 1><cf_get_lang_main no='3103.Duraklama'><cfelse><cf_get_lang_main no='1670.Üretilen Ürün'></cfif></th>
                <th style="text-align:center; width:80px"><cf_get_lang_main no='1622.Operasyon'></th>
                <th style="text-align:center; width:50px"><cf_get_lang_main no='223.Miktar'></th>
                <th style="text-align:center; width:80px"><cf_get_lang_main no='3219.Başlama Zamanı'></th>
                <th style="text-align:center; width:80px"><cfoutput>#getLang('report',740)#</cfoutput></th>
            </tr>
        </thead>
        <tbody>
            <cfif len(attributes.is_form_submitted) and get_employees.recordcount gt 0>
            	<cfoutput query="get_employees">
                	<cfif isdefined('START_DATE')>
                    	<cfset start_date_ = DateAdd('h',#session.ep.time_zone#,START_DATE)>
                        <cfset start_time_ = DateDiff('n',START_DATE,now())>
                        <cfset totaltime = "#start_time_\60#:#numberformat(start_time_ % 60, "00")#:00">
                    </cfif>
                    <cfif isdefined('ACTION_START_DATE')>
                    	<cfset action_start_date_ = DateAdd('h',#session.ep.time_zone#,ACTION_START_DATE)><!---DateAdd('h',#session.ep.time_zone#,ACTION_START_DATE)--->
                        <cfset action_start_time_ = DateDiff('n',ACTION_START_DATE,now())>
                        <cfset action_totaltime = "#action_start_time_\60#:#numberformat(action_start_time_ % 60, "00")#:00">
                    </cfif>
                    <cfif attributes.durum gt 0>
                        <cfquery name="get_employee_durum" datasource="#dsn3#">
                            SELECT  
                                P_OPERATION_ID
                            FROM        
                                EZGI_OPERATION_M
                            WHERE     
                                ACTION_EMPLOYEE_ID = #employee_id# AND 
                                <cfif len(STATION_ID)>
                                STATION_ID = #STATION_ID# AND
                                </cfif>
                                STAGE = 1 AND
                                LOSS_AMOUNT=0 AND
                                REAL_AMOUNT=0 
                        </cfquery>
                    </cfif>
                	<tr>
                    	<td style="text-align:left;" nowrap="nowrap">
                        	<strong>#currentrow#</strong>
                            <cfif attributes.durum gt 0>
								<cfif get_employee_durum.recordcount>
                                    <img src="images/delete_list.gif" border="0" onclick="delete_control(#employee_id#,#STATION_ID#,#get_employee_durum.P_OPERATION_ID#)"/>
                                <cfelse>
                                	<cfif attributes.durum eq 1>
                                    	<img src="images/delete_list.gif" border="0" onclick="exit_control(#employee_id#)"/>
                                    </cfif>
                                </cfif>
                            </cfif>
                        </td>
                        <td style="text-align:left;" nowrap="nowrap">
                        	<strong>
                        		<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_display_ezgi_personel_report_moduler&employee_id=#employee_id#','longpage');" class="tableyazi" >
                        			#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
                            	</a>
                        	</strong>
                      	</td>
                        <td style="text-align:left;" nowrap="nowrap"><strong><cfif isdefined('STATION_NAME')>#STATION_NAME#</cfif></strong></td>
                        <td style="text-align:center;" nowrap="nowrap"><strong><cfif isdefined('start_date_')>#DateFormat(start_date_,'DD/MM/YYYY')# #TimeFormat(start_date_,'HH:MM')#</cfif></strong></td>
                        <td style="text-align:right;" nowrap="nowrap"><cfif isdefined('start_date_')><strong>#totaltime#</strong></cfif></td>
                        <td style="text-align:left;" nowrap="nowrap">
                        	<cfif len(attributes.durum) and attributes.durum eq 1>
                          		<font color="RED">
                                	#PROD_PAUSE_TYPE#
                                </font>
                            <cfelse>
								<cfif isdefined('PRODUCT_NAME')>
                                    #PRODUCT_NAME#
                                </cfif>
                          	</cfif>
                       	</td>
                        <td style="text-align:left;" nowrap="nowrap">
							<cfif isdefined('OPERATION_TYPE')>
                        		<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.form_upd_prod_order&upd=#p_order_id#','longpage');" class="tableyazi" >
                        			#OPERATION_TYPE#
                              	</a>
                            </cfif>
                       	</td>
                        <td style="text-align:right;" nowrap="nowrap"><cfif isdefined('AMOUNT')>#AmountFormat(AMOUNT)#</cfif></td>
                        <td style="text-align:CENTER;" nowrap="nowrap">
                        	<cfif len(attributes.durum) and attributes.durum eq 1>
                          		<font color="RED">
                                	#TimeFormat(action_date,'HH:MM')#
                                </font>
                            <cfelse>

								<cfif isdefined('action_start_time_')>#DateFormat(action_start_date_,'DD/MM/YYYY')# #TimeFormat(action_start_date_,'HH:MM')#</cfif>
                          	</cfif>
                       	</td>
                        
						<td style="text-align:right;" nowrap="nowrap"><cfif isdefined('action_totaltime')><strong>#action_totaltime#</strong></cfif></td>
                  	</tr>
              	</cfoutput>      
                <tfoot>
                    <tr>
                        <td height="20" colspan="10" style="text-align:right"></td>
                    </tr>
                </tfoot>
            </cfif>
        </tbody>
    </cf_big_list>
</cfform>
<script language="javascript">
	document.search_product.lot_number.select();
	function delete_control(employee_id,station_id,operation_id)
	{
	sor = confirm('<cf_get_lang_main no='3220.Üretim İçin Sonuç Girmeden Çıkmak İstediğinizden Emin misiniz?'>');
	if(sor==true)
	window.open('<cfoutput>#request.self#?fuseaction=production.upd_ezgi_station_employee_exit&production=1</cfoutput>&station_id='+station_id+'&employee_id='+employee_id+'&p_operation_id='+operation_id,'','')
	}
	function exit_control(employee_id)
	{
	window.open('<cfoutput>#request.self#?fuseaction=production.upd_ezgi_station_employee_exit&production=1</cfoutput>&employee_id='+employee_id,'','')
	}
</script>