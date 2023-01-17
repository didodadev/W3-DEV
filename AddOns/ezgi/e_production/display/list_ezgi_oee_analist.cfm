<cfparam name="attributes.controller_emp_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_filtre" default="">
<cfparam name="attributes.controller_emp" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.shift_id" default="">
<cfparam name="attributes.operation_type_id" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.report_format" default="1">
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset total_working_minute = 200>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_defaults" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_DEFAULTS
</cfquery>
<cfset toplam_operator_sayisi = get_defaults.DEFAULT_ACTIVE_OPERATOR_AMOUNT>
<cfquery name="get_station" datasource="#dsn3#">
	SELECT     
    	E.STATION_ID, 
        W.STATION_NAME,
        ISNULL((SELECT OEE_PERFORM_RATE FROM EZGI_STATION_OOE_RATE WHERE STATION_ID = E.STATION_ID AND OEE_STATUS = 1),0) AS OEE_PERFORM_RATE,
        ISNULL((SELECT OEE_AVAILBILITY_RATE FROM EZGI_STATION_OOE_RATE WHERE STATION_ID = E.STATION_ID AND OEE_STATUS = 1),0) AS OEE_AVAILBILITY_RATE,
        ISNULL((SELECT OEE_QUALITY_RATE FROM EZGI_STATION_OOE_RATE WHERE STATION_ID = E.STATION_ID AND OEE_STATUS = 1),0) AS OEE_QUALITY_RATE
	FROM         
    	EZGI_OPERATION_M AS E INNER JOIN
        WORKSTATIONS AS W ON E.STATION_ID = W.STATION_ID
	GROUP BY 
    	E.STATION_ID, 
        W.STATION_NAME
  	ORDER BY
    	W.STATION_NAME
</cfquery>
<cfquery name="get_employee" datasource="#dsn3#">
	SELECT        
    	EMPLOYEE_ID,
        ISNULL((SELECT OEE_PERFORM_RATE FROM EZGI_EMPLOYEE_OOE_RATE WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND OEE_STATUS = 1),0) AS OEE_PERFORM_RATE,
        ISNULL((SELECT OEE_AVAILBILITY_RATE FROM EZGI_EMPLOYEE_OOE_RATE WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND OEE_STATUS = 1),0) AS OEE_AVAILBILITY_RATE,
        ISNULL((SELECT OEE_QUALITY_RATE FROM EZGI_EMPLOYEE_OOE_RATE WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND OEE_STATUS = 1),0) AS OEE_QUALITY_RATE
	FROM            
    	#dsn_alias#.EMPLOYEES E
	WHERE        
    	EMPLOYEE_STATUS = 1
</cfquery>
<cfif attributes.report_type eq 1>
	<cfoutput query="get_station">
        <cfset 'STATION_NAME_#STATION_ID#' = STATION_NAME>
        <cfset 'OEE_PERFORM_RATE_#STATION_ID#' = OEE_PERFORM_RATE>
        <cfset 'OEE_AVAILBILITY_RATE_#STATION_ID#' = OEE_AVAILBILITY_RATE>
        <cfset 'OEE_QUALITY_RATE_#STATION_ID#' = OEE_QUALITY_RATE>
    </cfoutput>
<cfelse>
	<cfoutput query="get_employee">
        <cfset 'OEE_PERFORM_RATE_#EMPLOYEE_ID#' = OEE_PERFORM_RATE>
        <cfset 'OEE_AVAILBILITY_RATE_#EMPLOYEE_ID#' = OEE_AVAILBILITY_RATE>
        <cfset 'OEE_QUALITY_RATE_#EMPLOYEE_ID#' = OEE_QUALITY_RATE>
    </cfoutput>
</cfif>


<cfquery name="get_shift" datasource="#dsn#">
	SELECT SHIFT_ID, SHIFT_NAME FROM SETUP_SHIFTS
</cfquery>
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
	<cfquery name="get_perform" datasource="#dsn3#">
        SELECT        
            OPERATION_CODE, 
            OPERATION_TYPE, 
            OPERATION_TYPE_ID, 
            SUM(REAL_AMOUNT) AS REAL_AMOUNT, 
            SUM(REAL_TIME) AS REAL_TIME, 
            SUM(OPTIMUM_TIME) AS OPTIMUM_TIME, 
            CASE 
                WHEN 
                    SUM(OPTIMUM_TIME) > 0 AND SUM(REAL_TIME) > 0 
                THEN 
                    ROUND(SUM(OPTIMUM_TIME) / SUM(REAL_TIME), 2) 
                ELSE 
                    0
            END AS PERFORMANS_ORAN,
            <cfif isdefined('attributes.report_type') and attributes.report_type eq 2>
                ACTION_EMPLOYEE_ID AS STATION_ID,
            <cfelse>
                STATION_ID,
            </cfif>
            <cfif attributes.report_format eq 1>
            	DAY_TIME,
            </cfif>
            <cfif attributes.report_format eq 2>
            	WEEK_TIME,
            </cfif>
            <cfif attributes.report_format eq 1 or attributes.report_format eq 3>
            	MONTH_TIME,
            </cfif>
            YEAR_TIME
        FROM            
            (
                SELECT        
                    OES.OPERATION_CODE, 
                    OES.OPERATION_TYPE, 
                    OES.OPERATION_TYPE_ID, 
                    OES.STOCK_ID, 
                    <cfif attributes.report_type eq 1>
                    	OES.STATION_ID, 
                    <cfelse>
                    	OES.ACTION_EMPLOYEE_ID,
                    </cfif>
                    ISNULL(SUM(OES.REAL_AMOUNT), 0) AS REAL_AMOUNT, 
                    ISNULL(SUM(OES.REAL_TIME), 0) AS REAL_TIME, 
                    SUM(ISNULL(EZGI_SETUP_TIME,0)+(ISNULL(OES.REAL_AMOUNT,0) * (ISNULL(EOOT.OPTIMUM_TIME,0)+ISNULL(OES.EZGI_H_SURE,0)))) AS OPTIMUM_TIME, 
                    YEAR(OES.ACTION_START_DATE) AS YEAR_TIME, 
                    MONTH(OES.ACTION_START_DATE) AS MONTH_TIME, 
                    DAY(OES.ACTION_START_DATE) AS DAY_TIME, 
                    { fn WEEK(OES.ACTION_START_DATE) } AS WEEK_TIME
                FROM            
                    EZGI_OPERATION_S AS OES LEFT OUTER JOIN
                    EZGI_OPERATION_OPTIMUM_TIME AS EOOT ON OES.OPERATION_TYPE_ID = EOOT.OPERATION_TYPE_ID AND OES.STOCK_ID = EOOT.STOCK_ID
                WHERE        
                    OES.REAL_TIME > 0 AND
                    <cfif attributes.report_type eq 1>
                    	OES.STATION_ID IN (SELECT STATION_ID FROM EZGI_STATION_OOE_RATE WHERE OEE_STATUS = 1)
                    <cfelse>
                    	OES.ACTION_EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EZGI_EMPLOYEE_OOE_RATE WHERE OEE_STATUS = 1)
                    </cfif>
                    <cfif len(attributes.operation_type_id)>
                        AND OES.OPERATION_TYPE_ID = #attributes.operation_type_id#
                    </cfif>
                    <cfif len(attributes.controller_emp)>
                        AND OES.ACTION_EMPLOYEE_ID = #attributes.controller_emp_id#
                    </cfif>
                    <cfif len(attributes.station_id)>
                        AND OES.STATION_ID = #attributes.station_id#
                    </cfif>
                GROUP BY 
                    OES.OPERATION_CODE, 
                    OES.OPERATION_TYPE, 
                    OES.OPERATION_TYPE_ID, 
                    OES.STOCK_ID, 
                    <cfif attributes.report_type eq 1>
                    	OES.STATION_ID, 
                    <cfelse>
                    	OES.ACTION_EMPLOYEE_ID,
                    </cfif>
                    EOOT.OPTIMUM_TIME, 
                    YEAR(OES.ACTION_START_DATE), 
                    MONTH(OES.ACTION_START_DATE), 
                    DAY(OES.ACTION_START_DATE), 
                    { fn WEEK(OES.ACTION_START_DATE) }
            ) AS TBL_1
        WHERE 
            1=1
            <cfif isdefined('attributes.day_time') and len(attributes.day_time)>
                AND DAY_TIME = #attributes.day_time#
            <cfelseif isdefined('attributes.week_time') and len(attributes.week_time)>
                AND WEEK_TIME = #attributes.week_time#
            <cfelseif isdefined('attributes.month_time') and len(attributes.month_time)>
                AND MONTH_TIME = #attributes.month_time#
            <cfelseif isdefined('attributes.year_time') and len(attributes.year_time)>
                AND YEAR_TIME = #attributes.year_time#
            </cfif>
        GROUP BY 
            OPERATION_CODE, 


            OPERATION_TYPE, 
            OPERATION_TYPE_ID, 
            <cfif isdefined('attributes.report_type') and attributes.report_type eq 2>
                ACTION_EMPLOYEE_ID,
            <cfelse>
                STATION_ID,
            </cfif>
            <cfif attributes.report_format eq 1>
            	DAY_TIME,
            </cfif>
            <cfif attributes.report_format eq 2>
            	WEEK_TIME,
            </cfif>
            <cfif attributes.report_format eq 1 or attributes.report_format eq 3>
            	MONTH_TIME,
            </cfif>
            YEAR_TIME
      	ORDER BY
        	YEAR_TIME
            <cfif attributes.report_format eq 1 or attributes.report_format eq 3>
            	,MONTH_TIME
            </cfif>
            <cfif attributes.report_format eq 2>
            	,WEEK_TIME
            </cfif>
        	<cfif attributes.report_format eq 1>
            	,DAY_TIME
            </cfif>
    </cfquery>
    <!---<cfdump var="#get_perform#">--->
    <cfquery name="get_plan_info" datasource="#dsn#">
        SELECT DEPARTMENT_ID, CONTROL_HOUR_1 FROM SETUP_SHIFTS WHERE SHIFT_ID = #attributes.shift_id#
    </cfquery>
    <cfset attributes.department_id = get_plan_info.DEPARTMENT_ID>
	<cfset gunluk_caliasma_saat = get_plan_info.CONTROL_HOUR_1>
</cfif>

<cfif isdefined("attributes.form_varmi")>
	<cfif not isdefined("get_perform.QUERY_COUNT")>
    	<cfparam name="attributes.totalrecords" default="#get_perform.recordcount#">
    <cfelse>
    	<cfparam name="attributes.totalrecords" default="0">
    </cfif>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cf_big_list_search title="#getLang('main',3602)#">
	<cfform name="quality_control" id="quality_control" method="post" action="#request.self#?fuseaction=prod.list_ezgi_oee_analist">
	<input name="form_varmi" id="form_varmi" value="1" type="hidden">
    	<cf_big_list_search_area>
            <table>
                <tr>
                	
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="is_filtre" id="is_filtre" style="width:90px;" value="#attributes.is_filtre#"></td>
                    <td><cf_get_lang_main no='160.Departman'></td>
                    <td>
                    	<select name="shift_id" id="shift_id" style="width:110px; height:20px">
                            <cfoutput query="get_shift">
                                <option value="#shift_id#" <cfif attributes.shift_id eq shift_id>selected</cfif>>#SHIFT_NAME#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td nowrap="nowrap"><cf_get_lang_main no='164.Çalışan'></td>
                    <td nowrap="nowrap">
                        <input type="hidden" name="controller_emp_id" id="controller_emp_id" value="<cfif len(attributes.controller_emp_id)><cfoutput>#attributes.controller_emp_id#</cfoutput></cfif>">			
                        <input type="text" name="controller_emp" id="controller_emp" value="<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)><cfoutput>#attributes.controller_emp#</cfoutput></cfif>" onfocus="AutoComplete_Create('controller_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','controller_emp_id','','3','130');" autocomplete="off" style="width:100px;">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_emps&field_id=quality_control.controller_emp_id&field_name=quality_control.controller_emp&select_list=1</cfoutput>','list');"><img src="/images/plus_thin.gif" align="top" border="0"></a>
                    </td>
                    <td><cf_get_lang_main no='1422.İstasyon'></td>
                    <td>
                    	<select name="station_id" id="station_id" style="width:100px; height:20px">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            <cfoutput query="get_station">
                                <option value="#station_id#" <cfif attributes.station_id eq station_id>selected</cfif>>#station_name#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td nowrap="nowrap"><cf_get_lang_main no='1622.Operasyon'></td>
                    <td>
                        <select name="operation_type_id" id="operation_type_id" style="width:100px; height:20px">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            <cfoutput query="get_operation">
                                <option value="#operation_type_id#" <cfif attributes.operation_type_id eq operation_type_id>selected</cfif>>#OPERATION_TYPE#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td nowrap="nowrap"><cf_get_lang_main no='1548.Rapor Tipi'></td>
                    <td>
                    	<select name="report_type" id="report_type" style="width:70px; height:20px">
                            <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang_main no='1422.İstasyon'></option>
                            <option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang_main no='164.Çalışan'></option>
                      	</select>
                    </td>
                    <td nowrap="nowrap"><cf_get_lang_main no='2693.Rapor Formatı'></td>
                    <td>
                    	<select name="report_format" id="report_format" style="width:70px; height:20px">
                            <option value="1" <cfif attributes.report_format eq 1>selected</cfif>><cf_get_lang_main no='1045.Günlük'></option>
                            <option value="2" <cfif attributes.report_format eq 2>selected</cfif>><cf_get_lang_main no='1046.Haftalık'></option>
                            <option value="3" <cfif attributes.report_format eq 3>selected</cfif>><cf_get_lang_main no='1520.Aylık'></option>
                            <option value="4" <cfif attributes.report_format eq 4>selected</cfif>><cf_get_lang_main no='1603.Yıllık'></option>
                      	</select>
                    </td>
                    <td>
                    	<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#" style="width:25px;">
                       	<cf_wrk_search_button><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                    </td>
                </tr>
            </table>
        </cf_big_list_search_area>
	</cfform>
</cf_big_list_search>    
<cf_big_list>
	<!-- sil -->
    <thead>
      	<tr>
            <th rowspan="2" style="width:20px; text-align:center"><cf_get_lang_main no='1165.Sıra'></th>
            <th rowspan="2" style="width:85px; text-align:center"><cf_get_lang_main no='1060.Dönem'></th>
            <cfif attributes.report_type eq 2> 
            	<th rowspan="2" style="text-align:center"><cf_get_lang_main no='164.Çalışan'></th>
            <cfelse>
            	<th rowspan="2" style="text-align:center"><cf_get_lang_main no='1422.İstasyon'></th>
            </cfif>
         	<th rowspan="2" style="width:80px; text-align:center"><cf_get_lang_main no='1622.Operasyon'></th>
            <th rowspan="2" style="width:50px; text-align:center"><cf_get_lang_main no='2941.Üretim Miktarı'></th>
            <th rowspan="2" style="width:60px; text-align:center"><cf_get_lang_main no='539.Hedef'><br><cf_get_lang_main no='1716.Süre'> (<cf_get_lang_main no='3223.Sn'>)</th>
            <th rowspan="2" style="width:60px; text-align:center"><cf_get_lang_main no='272.Sonuç'><br><cf_get_lang_main no='1716.Süre'>(<cf_get_lang_main no='3223.Sn'>)</th>
            <th rowspan="2" style="width:60px; text-align:center"><cf_get_lang_main no='1060.Dönem'><br><cf_get_lang_main no='1716.Süre'> (<cf_get_lang_main no='3223.Sn'>)</th>
            <th colspan="2" style="width:100px; text-align:center"><cf_get_lang_main no='591.Performans'></th>
            <th colspan="2" style="width:100px; text-align:center"><cfoutput>#getLang('ehesap',869)#</cfoutput></th>
            <th colspan="2" style="width:100px; text-align:center"><cfoutput>#getLang('main',2652)#</cfoutput></th>
            <th colspan="2" style="width:100px; text-align:center"><cfoutput>#getLang('main',3487)#</cfoutput></th>
       	</tr>
       	<tr>
       		<th style="width:50px; text-align:center"><cf_get_lang_main no='539.Hedef'></th>
            <th style="width:50px; text-align:center"><cf_get_lang_main no='272.Sonuç'></th>
            <th style="width:50px; text-align:center"><cf_get_lang_main no='539.Hedef'></th>
            <th style="width:50px; text-align:center"><cf_get_lang_main no='272.Sonuç'></th>
            <th style="width:50px; text-align:center"><cf_get_lang_main no='539.Hedef'></th>
            <th style="width:50px; text-align:center"><cf_get_lang_main no='272.Sonuç'></th>
            <th style="width:50px; text-align:center"><cf_get_lang_main no='539.Hedef'></th>
            <th style="width:50px; text-align:center"><cf_get_lang_main no='272.Sonuç'></th>
       	</tr>
    </thead>
    <tbody>
        <cfif isdefined("attributes.form_varmi") and get_perform.recordcount>
            <cfoutput query="get_perform" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            	<cfif attributes.report_format eq 1>
                	<cfset toplam_gun = 1> <!---Hesaplanacak Dönem Aralığı--->
					<cfset gun = createDate("#YEAR_TIME#", "#MONTH_TIME#", "#DAY_TIME#")> <!---Başlama Günü--->
                    <cfset test_gun = gun> <!---Döngü Başlama Günü--->
				<cfelseif attributes.report_format eq 2>
                  	<cfset toplam_gun = 7> <!---Hesaplanacak Dönem Aralığı--->
					<cfset gun = createDate("#YEAR_TIME#", "01", "01")> <!---Yıl Başı Günü--->
                    <cfset gun = DateAdd("ww",week_time,gun)>
                    <cfset test_gun = gun> <!---Döngü Başlama Günü--->          
              	<cfelseif attributes.report_format eq 3>
                	
					<cfset gun = createDate("#YEAR_TIME#", "#MONTH_TIME#", "01")> <!---Başlama Günü--->
                    <cfset test_gun = gun> <!---Döngü Başlama Günü--->
                    <cfset toplam_gun = DaysInMonth(gun)> <!---Hesaplanacak Dönem Aralığı--->
                <cfelseif attributes.report_format eq 4>
					<cfset gun = createDate("#YEAR_TIME#", "01", "01")> <!---Başlama Günü--->
                    <cfset test_gun = gun> <!---Döngü Başlama Günü--->
                    <cfset toplam_gun = daysInYear(now())> <!---Bu Yıl Kaç Gün (365/366)--->
                </cfif>
                <cfinclude template="../../e_design/query/hsp_ezgi_total_working_day_1.cfm"> <!---'İlgili Gün Aralığını Hesapla--->
                <tr class="color-row">
                    <td style="text-align:right">#currentrow#</td>
                    <td style="text-align:CENTER; height:25px">
						<cfif attributes.report_format eq 1>
                            #DAY_TIME#
                            <cfif MONTH_TIME eq 1>
                            	<cf_get_lang_main no='180.Ocak'>
                            <cfelseif MONTH_TIME eq 2>
                            	<cf_get_lang_main no='181.Şubat'>
                            <cfelseif MONTH_TIME eq 3>
                            	<cf_get_lang_main no='182.Mart'>
                            <cfelseif MONTH_TIME eq 4>
                            	<cf_get_lang_main no='183.Nisan'>
                            <cfelseif MONTH_TIME eq 5>
                            	<cf_get_lang_main no='184.Mayıs'>
                            <cfelseif MONTH_TIME eq 6>
                            	<cf_get_lang_main no='185.Haziran'>
                            <cfelseif MONTH_TIME eq 7>
                            	<cf_get_lang_main no='186.Temmuz'>
                            <cfelseif MONTH_TIME eq 8>
                            	<cf_get_lang_main no='187.Ağustos'>
                            <cfelseif MONTH_TIME eq 9>
                            	<cf_get_lang_main no='188.Eylül'>
                            <cfelseif MONTH_TIME eq 10>
                            	<cf_get_lang_main no='189.Ekim'>
                            <cfelseif MONTH_TIME eq 11>
                            	<cf_get_lang_main no='190.Kasım'>
                            <cfelseif MONTH_TIME eq 12>
                            	<cf_get_lang_main no='191.Aralık'>
                            </cfif>
                            #YEAR_TIME#
                        <cfelseif attributes.report_format eq 2>
                            #WEEK_TIME#-#YEAR_TIME#
                        <cfelseif attributes.report_format eq 3>
                            <cfif MONTH_TIME eq 1>
                            	<cf_get_lang_main no='180.Ocak'>
                            <cfelseif MONTH_TIME eq 2>
                            	<cf_get_lang_main no='181.Şubat'>
                            <cfelseif MONTH_TIME eq 3>
                            	<cf_get_lang_main no='182.Mart'>
                            <cfelseif MONTH_TIME eq 4>
                            	<cf_get_lang_main no='183.Nisan'>
                            <cfelseif MONTH_TIME eq 5>
                            	<cf_get_lang_main no='184.Mayıs'>
                            <cfelseif MONTH_TIME eq 6>
                            	<cf_get_lang_main no='185.Haziran'>
                            <cfelseif MONTH_TIME eq 7>
                            	<cf_get_lang_main no='186.Temmuz'>
                            <cfelseif MONTH_TIME eq 8>
                            	<cf_get_lang_main no='187.Ağustos'>
                            <cfelseif MONTH_TIME eq 9>
                            	<cf_get_lang_main no='188.Eylül'>
                            <cfelseif MONTH_TIME eq 10>
                            	<cf_get_lang_main no='189.Ekim'>
                            <cfelseif MONTH_TIME eq 11>
                            	<cf_get_lang_main no='190.Kasım'>
                            <cfelseif MONTH_TIME eq 12>
                            	<cf_get_lang_main no='191.Aralık'>
                            </cfif>
                            -#YEAR_TIME#
                      	<cfelseif attributes.report_format eq 4>
                            #YEAR_TIME#
                        </cfif>
                    </td>
                    <td>
						<cfif attributes.report_type eq 2> 
                            #get_emp_info(STATION_ID,0,0)# 
                        <cfelse>
                        	<cfif isdefined('STATION_NAME_#STATION_ID#')>
                            	#Evaluate('STATION_NAME_#STATION_ID#')#
                            </cfif>
                        </cfif>
                  	</td>
                    <td>#OPERATION_TYPE#</td>
                    <td style="text-align:CENTER">#TlFormat(REAL_AMOUNT,0)#</td>
                    <td style="text-align:CENTER">#TlFormat(OPTIMUM_TIME,0)#</td>
                    <td style="text-align:CENTER">#TlFormat(REAL_TIME,0)#</td>
                    <td style="text-align:CENTER">#TlFormat(total_working_minute*60,0)#</td>
                    <td style="text-align:CENTER">
						<cfif isdefined('OEE_PERFORM_RATE_#STATION_ID#')>
                        	#TlFormat(Evaluate('OEE_PERFORM_RATE_#STATION_ID#'),1)#
                            <cfset perform_rate = Evaluate('OEE_PERFORM_RATE_#STATION_ID#')>
                        <cfelse>
                        	#TlFormat(0,1)#
                            <cfset perform_rate = 0>
                        </cfif>
                    </td>
                    <td style="text-align:CENTER;<cfif PERFORMANS_ORAN*100 gte perform_rate>background-color:LightCyan<cfelse>background-color:Seashell</cfif>"><b>#TlFormat(PERFORMANS_ORAN*100,1)#</b></td>
                    <td style="text-align:CENTER">
						<cfif isdefined('OEE_AVAILBILITY_RATE_#STATION_ID#')>
                        	#TlFormat(Evaluate('OEE_AVAILBILITY_RATE_#STATION_ID#'),1)#
                            <cfset availbility_rate = Evaluate('OEE_AVAILBILITY_RATE_#STATION_ID#')>
                        <cfelse>
                        	#TlFormat(0,1)#
                            <cfset availbility_rate = 0>
                        </cfif>
                        <cfif total_working_minute*60 gt 0 and REAL_TIME gt 0>
                         	<cfset real_availbility =  REAL_TIME/(total_working_minute*60)>
                   		<cfelse>
                         	<cfset real_availbility = 0>
                    	</cfif>
                    </td>
                    <td style="text-align:CENTER;<cfif real_availbility*100 gte availbility_rate>background-color:LightCyan<cfelse>background-color:Seashell</cfif>"><b>#TlFormat(real_availbility*100,1)#</b></td>
                    <td style="text-align:CENTER">
                    	<cfif isdefined('OEE_QUALITY_RATE_#STATION_ID#')>
                        	#TlFormat(Evaluate('OEE_QUALITY_RATE_#STATION_ID#'),1)#
                            <cfset quality_rate = Evaluate('OEE_QUALITY_RATE_#STATION_ID#')>
                        <cfelse>
                        	#TlFormat(0,1)#
                            <cfset quality_rate = 0>
                        </cfif>
                    </td>
                    <td style="text-align:CENTER;background-color:LightCyan"><b>#TlFormat(100,0)#</b></td>
                    <td style="text-align:CENTER">#perform_rate*availbility_rate*quality_rate/10000#</td>
                    <td style="text-align:CENTER;<cfif PERFORMANS_ORAN*real_availbility*100 gte perform_rate*availbility_rate*quality_rate/10000>background-color:LightCyan<cfelse>background-color:Seashell</cfif>">#TlFormat(PERFORMANS_ORAN*real_availbility*100,1)#</td>
                </tr>
                <cfset son_row = currentrow>
            </cfoutput>
      	    <tfoot>
                <tr>
                    <td colspan="16"><!---<cf_get_lang_main no='80.Toplam'>---> </td>
                </tr>
            </tfoot>  
            	<table style="width:100%">
                	<tr>
                    	<td style="width:100%; height:620px; text-align:center; vertical-align:middle">
                        	<cfif len(attributes.station_id)>
                            	<cfchart
                                    format="png"
                                    scalefrom="0"
                                    scaleto="120"
                                    chartHeight="600" 
                                    chartWidth="1300" 
                                    showLegend="yes" 
                                    >
                                    <cfchartseries
                                        type="line"
                                        serieslabel="#getLang('main',591)#"
                                        seriescolor="red">
                                        <cfloop query="get_perform">
                                                <cfif attributes.report_format eq 1>
                                                    <cfset line_time = '#DAY_TIME#/#MONTH_TIME#/#YEAR_TIME#'>
                                                <cfelseif attributes.report_format eq 2>
                                                    <cfset line_time = '#WEEK_TIME#-#YEAR_TIME#'>
                                                <cfelseif attributes.report_format eq 3>
                                                    <cfset line_time = '#MONTH_TIME#-#YEAR_TIME#'>
                                                <cfelseif attributes.report_format eq 4>
                                                    <cfset line_time = '#YEAR_TIME#'>
                                                </cfif>
                                                <cfchartdata item="#line_time#" value="#PERFORMANS_ORAN*100#">
                                        </cfloop>
                                    </cfchartseries>
                                    <cfchartseries
                                        type="line"
                                        serieslabel="#getLang('ehesap',869)#"
                                        seriescolor="orange">
                                        <cfloop query="get_perform">
                                                <cfif attributes.report_format eq 1>
                                                    <cfset line_time = '#DAY_TIME#/#MONTH_TIME#/#YEAR_TIME#'>
                                                <cfelseif attributes.report_format eq 2>
                                                    <cfset line_time = '#WEEK_TIME#-#YEAR_TIME#'>
                                                <cfelseif attributes.report_format eq 3>
                                                    <cfset line_time = '#MONTH_TIME#-#YEAR_TIME#'>
                                                <cfelseif attributes.report_format eq 4>
                                                    <cfset line_time = '#YEAR_TIME#'>
                                                </cfif>
                                                <cfif total_working_minute*60 gt 0 and REAL_TIME gt 0>
                                                    <cfset real_availbility =  REAL_TIME/(total_working_minute*60)*100>
                                                    <cfchartdata item="#line_time#" value="#real_availbility#">
                                                <cfelse>
                                                    <cfchartdata item="#line_time#" value="0">
                                                </cfif>
                                        </cfloop>
                                    </cfchartseries>
                                </cfchart>
                        	</cfif>
                        </td>
                    </tr>
                </table>
            <!-- sil -->
        <cfelse>
            <tr><td class="color-row" colspan="20"><cfif not isdefined("attributes.form_varmi")><cf_get_lang_main no='289.Filtre ediniz'> !<cfelse><cf_get_lang_main no='72.Kaıt Yok'> !</cfif></td></tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfif isdefined("attributes.form_varmi")>
	<cfset url_str = "prod.list_ezgi_oee_analist">
    <cfif attributes.totalrecords gt attributes.maxrows>
     <table width="99%" align="center" cellpadding="0" cellspacing="0">
        <cfif len(attributes.is_filtre)>
            <cfset url_str = "#url_str#&is_filtre=#attributes.is_filtre#">
        </cfif>
        <cfif len(attributes.station_id)>
            <cfset url_str = "#url_str#&station_id=#attributes.station_id#">
        </cfif>
        <cfif len(attributes.shift_id)>
            <cfset url_str = "#url_str#&shift_id=#attributes.shift_id#">
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
		document.getElementById('quality_control').action="<cfoutput>#request.self#?fuseaction=prod.list_ezgi_oee_analist</cfoutput>"
		return true;
	}
</script>