<cfset module_name="prod">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_submitted" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = wrk_get_today()>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',1,attributes.start_date)>
</cfif>
<cfset t_d_time = 0>
<cfset t_c_time = 0>
<cfquery name="get_hr" datasource="#dsn#">
	SELECT 
		E.*,
		EI.TC_IDENTY_NO,
		ED.SEX,
		ED.EMAIL_SPC,
		ED.MOBILCODE_SPC,
		ED.MOBILTEL_SPC
	FROM 
		EMPLOYEES E,
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IDENTY EI
	WHERE 
		E.EMPLOYEE_ID = #attributes.employee_id# 
		AND E.EMPLOYEE_ID = ED.EMPLOYEE_ID
		AND EI.EMPLOYEE_ID = ED.EMPLOYEE_ID
</cfquery>
<cfquery name="get_daily_works" datasource="#dsn3#">
	SELECT     
    	POR.OPERATION_RESULT_ID, 
        ISNULL(POR.REAL_AMOUNT,0) REAL_AMOUNT, 
        ISNULL(POR.REAL_TIME,0) REAL_TIME, 
        POR.ACTION_START_DATE, 
        S.PRODUCT_NAME, 
        W.STATION_NAME, 
        W.STATION_ID,
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
    	POR.ACTION_EMPLOYEE_ID = #attributes.employee_id# 
        <cfif len(attributes.start_date)>
       		AND POR.ACTION_START_DATE >= #attributes.start_date#
     	</cfif>
   		<cfif len(attributes.finish_date)>
         	AND POR.ACTION_START_DATE <= #attributes.finish_date#
      	</cfif>
</cfquery>
<cfquery name="get_daily_works_now" dbtype="query">
	SELECT
    	STATION_ID
  	FROM
    	get_daily_works
   	WHERE
    	REAL_AMOUNT = 0
</cfquery>
<cfquery name="get_daily_duration" datasource="#dsn3#">
	SELECT     
    	ISNULL(PRP.PROD_DURATION,0) PROD_DURATION, 
        PRPT.PROD_PAUSE_TYPE, 
        OT.OPERATION_TYPE, 
        S.PRODUCT_NAME, 
        W.STATION_NAME, 
        PRO.P_ORDER_NO, 
        PRO.LOT_NO, 
      	PRP.ACTION_DATE
	FROM         
    	PRODUCTION_OPERATION AS PO INNER JOIN
       	OPERATION_TYPES AS OT ON PO.OPERATION_TYPE_ID = OT.OPERATION_TYPE_ID INNER JOIN
       	SETUP_PROD_PAUSE AS PRP INNER JOIN
      	SETUP_PROD_PAUSE_TYPE AS PRPT ON PRP.PROD_PAUSE_TYPE_ID = PRPT.PROD_PAUSE_TYPE_ID ON PO.P_OPERATION_ID = PRP.OPERATION_ID INNER JOIN
       	PRODUCTION_ORDERS AS PRO ON PRP.P_ORDER_ID = PRO.P_ORDER_ID INNER JOIN
      	STOCKS AS S ON PRO.STOCK_ID = S.STOCK_ID INNER JOIN
      	WORKSTATIONS AS W ON PRP.STATION_ID = W.STATION_ID
  	WHERE     
    	PRP.EMPLOYEE_ID = #attributes.employee_id#
        <cfif len(attributes.start_date)>
       		AND PRP.ACTION_DATE >= #attributes.start_date#
     	</cfif>
   		<cfif len(attributes.finish_date)>
         	AND PRP.ACTION_DATE <= #attributes.finish_date#
      	</cfif>
</cfquery>
<cfif get_daily_works_now.recordcount>
    <cfquery name="get_takim" datasource="#dsn3#">
        SELECT     
            STATION_ID, 
            EMPLOYEE_ID, 
            START_DATE
        FROM         
            EZGI_STATION_EMPLOYEE
        WHERE     
            FINISH_DATE IS NULL AND 
            STATION_ID = #get_daily_works_now.station_id#
    </cfquery>
<cfelse>
	<cfset get_takim.recordcount = 0>
</cfif>
<table class="drm" cellpadding="1" cellspacing="1" border="0" >
	<tr>
		<td colspan="3">
            <table class="dph">
                <tr>
                    <td class="dpht" name="parti"><cf_get_lang_main no='3221.Çalışan İş Raporu'> : <cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></td>
                    <td class="dphb" name="butons">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.employee_id#&print_type=39</cfoutput>','page');"><img src="/images/print.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no='62.Yazdır'>" title="<cf_get_lang_main no='62.Yazdır'>"></a>
                    </td>
                </tr>
            </table>
            <table class="dpm" cellpadding="1" cellspacing="1" border="0">
                <tr>
                    <td valign="top" class="dpml" name="Detail Page Left">
                    	<cfform name="search_list" action="#request.self#?fuseaction=prod.popup_display_ezgi_personel_report_moduler" method="post">
                        	<cfinput type="hidden" name="employee_id" value="#attributes.employee_id#">
                        	<input type="hidden" name="is_submitted" id="is_submitted" value="1">
                            <cf_form_box width="100%">            
                                <cf_object_main_table>
                                    <cf_object_table column_width_list="100">
                                        <cfsavecontent variable="header_"><cf_get_lang_main no='330.Tarih'></cfsavecontent>
                                        <cf_object_tr id="form_ul_start_date" title="#header_#">
                                            <cf_object_td>
                                                <cfif session.ep.our_company_info.unconditional_list>
                                                    <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
                                                <cfelse>
                                                    <cfsavecontent variable="message"><cf_get_lang no='277.Bitis Tarihi Kontrol Ediniz'></cfsavecontent>
                                                    <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                                                </cfif>
                                                <cf_wrk_date_image date_field="start_date">                 
                                            </cf_object_td>
                                        </cf_object_tr>
                                    </cf_object_table>
                                
                                
                                    <cf_object_table column_width_list="150">
                                        <cfsavecontent variable="header_"><cf_get_lang_main no='330.Tarih'></cfsavecontent>
                                        <cf_object_tr id="form_ul_finish_date" title="#header_#">
                                            <cf_object_td>
                                                <cfif session.ep.our_company_info.unconditional_list>
                                                    <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
                                                <cfelse>
                                                    <cfsavecontent variable="message"><cf_get_lang no='277.Bitis Tarihi Kontrol Ediniz'></cfsavecontent>
                                                    <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                                                </cfif>
                                                <cf_wrk_date_image date_field="finish_date"> 
                                                <cf_workcube_buttons is_upd='0' type_format="1" >                
                                            </cf_object_td>
                                        </cf_object_tr>
                                    </cf_object_table> 
                                </cf_object_main_table>
                        	</cf_form_box>
                    	</cfform>
					</td>
				</tr>
     		</table>
  		</td>
	</tr>
    <tr>
    	<td style="width:90%; vertical-align:top">
                    <cf_seperator title="#getLang('prod',476)#" id="uretim" is_closed="1">
                    <div id="uretim" style="display;width:100%">
                        <cf_form_list id="table1">
                            <thead>
                                <tr height="15px">
                                    <th style="width:25px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='1165.Sıra'></th>
                                    <th style="width:190px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='1422.İstasyon'></th>
                                    <th style="width:60px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='1677.Emir No'></th>
                                    <th style="width:60px;text-align:center;" nowrap="nowrap"><cfoutput>#getLang('prod',215)#</cfoutput></th>
                                    <th style="width:100%;text-align:center;"><cf_get_lang_main no='245.Ürün'></th>
                                    <th style="width:110px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='1622.Operasyon'></th>
                                    <th style="width:50px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='223.Miktar'></th>
                                    <th style="width:50px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='90.Bitiş'></th>
                                    <th style="width:50px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='3222.İş Puanı'></th>
                                    <th style="width:70px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='3113.Çalışma'><br />(<cf_get_lang_main no='1415.Dk'>:<cf_get_lang_main no='3223.Sn'>)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfif get_daily_works.recordcount>
                                    <cfoutput query="get_daily_works">
                                        <tr height="15">
                                            <td style="text-align:right;" nowrap="nowrap">#currentrow#&nbsp;</td>
                                            <td style="text-align:left;" nowrap="nowrap">&nbsp;#STATION_NAME#</td>
                                            <td style="text-align:center;" nowrap="nowrap">#P_ORDER_NO#</td>
                                            <td style="text-align:center;" nowrap="nowrap">#LOT_NO#</td>
                                            <td style="text-align:left;">&nbsp;#PRODUCT_NAME#</td>
                                            <td style="text-align:left;" nowrap="nowrap">&nbsp;#OPERATION_TYPE#</td>
                                            <td style="text-align:right;" nowrap="nowrap">#REAL_AMOUNT#</td>
                                            <td style="text-align:center;" nowrap="nowrap">#TimeFormat(DateAdd('H',session.ep.time_zone,ACTION_START_DATE), 'HH:MM')#</td>
                                            <td style="text-align:center;" nowrap="nowrap"></td>
                                            <td style="text-align:right;" nowrap="nowrap">#numberformat(REAL_TIME/60,0)#:#numberformat(REAL_TIME % 60, "00")#&nbsp;</td>
                                        </tr>
                                        <cfset t_c_time = t_c_time + REAL_TIME>
                                    </cfoutput>
                                    <tr height="15">
                                        <td colspan="9" style=" text-align:right;"><strong><cf_get_lang_main no='3224.Toplam Çalışma Zamanı'>&nbsp;</strong></td>
                                        <td style=" text-align:right;"><strong><cfoutput>#numberformat(t_c_time/60,0)#:#numberformat(t_c_time % 60, "00")#</cfoutput>&nbsp;</strong></td>
                                    </tr>
                                <cfelse>
                                    <tr height="15">
                                        <td colspan="10" style=" text-align:left;">&nbsp;<cf_get_lang_main no='3225.Kayıtlı İş Bulunamadı'></td>
                                    </tr>
                                </cfif>
                            </tbody>
                        </cf_form_list>        
                    </div> 
            
                    <br />
                    <cf_seperator title="#getLang('prod',672)#" id="duraklama" is_closed="1">
                    <div id="duraklama" style="display;width:100%">
                        <cf_form_list id="table2">
                            <thead>
                                <tr height="15px">
                                    <th style="width:25px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='1165.Sıra'></th>
                                    <th style="width:190px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='1422.İstasyon'></th>
                                    <th style="width:60px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='1677.Emir No'></th>
                                    <th style="width:60px;text-align:center;" nowrap="nowrap"><cfoutput>#getLang('prod',215)#</cfoutput></th>
                                    <th style="width:100%;text-align:center;"><cf_get_lang_main no='245.Ürün'></th>
                                    <th style="width:110px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='1622.Operasyon'></th>
                                    <th style="width:100px;text-align:center;" nowrap="nowrap"><cfoutput>#getLang('production',96)#</cfoutput></th>
                                    <th style="width:50px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='1055.Başlama'></th>
                                    <th style="width:70px;text-align:center;" nowrap="nowrap"><cf_get_lang_main no='3103.Duraklama'><br />(<cf_get_lang_main no='1415.Dk'>:<cf_get_lang_main no='3223.Sn'>)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfif get_daily_duration.recordcount>
                                    <cfoutput query="get_daily_duration">
                                        <tr height="15">
                                            <td style="text-align:right;" nowrap="nowrap">#currentrow#&nbsp;</td>
                                            <td style="text-align:left;" nowrap="nowrap">&nbsp;#STATION_NAME#</td>
                                            <td style="text-align:center;" nowrap="nowrap">#P_ORDER_NO#</td>
                                            <td style="text-align:center;" nowrap="nowrap">#LOT_NO#</td>
                                            <td style="text-align:left;">&nbsp;#PRODUCT_NAME#</td>
                                            <td style="text-align:left;" nowrap="nowrap">&nbsp;#OPERATION_TYPE#</td>
                                            <td style="text-align:left;" nowrap="nowrap">#PROD_PAUSE_TYPE#</td>
                                            <td style="text-align:center;" nowrap="nowrap">#TimeFormat(DateAdd('H',session.ep.time_zone,ACTION_DATE), 'HH:MM')#</td>
                                            <td style="text-align:right;" nowrap="nowrap">#numberformat(PROD_DURATION/60,0)#:#numberformat(PROD_DURATION % 60, "00")#&nbsp;</td>
                                        </tr>
                                        <cfset t_d_time = t_d_time + PROD_DURATION>
                                    </cfoutput>
                                    <tr height="15">
                                        <td colspan="8" style="text-align:right;"><strong><cf_get_lang_main no='3226.Toplam Duraklama Zamanı'>&nbsp;</strong></td>
                                        <td style=" text-align:right;"><strong><cfoutput>#numberformat(t_d_time/60,0)#:#numberformat(t_d_time % 60, "00")#</cfoutput>&nbsp;</strong></td>
                                    </tr>
                                <cfelse>
                                    <tbody  ><tbody  ><tr height="15">
                                        <td colspan="9" style=" text-align:left;">&nbsp;<cf_get_lang_main no='3227.Kayıtlı Duraklama Bulunamadı'></td>
                                    </tr>
                          		</cfif>
                            </tbody>
                     	 </cf_form_list>
              		</div> 
		</td>
        <td style="width:2%;vertical-align:top"></td>
        <td style="width:19%;vertical-align:top">
        	<cf_seperator title="#getLang('hr',25)#" id="foto" is_closed="1">
       		<div id="foto" style="display;width:100%">
				<cf_box id="emp_photo" closable="0" collapsable="0">
                    <table align="center" width="100%">
                        <tr>
                            <td style="text-align:center;">
                                <cfif len(get_hr.photo)>
                                    <cf_get_server_file output_file="hr/#get_hr.photo#" output_server="#get_hr.photo_server_id#" output_type="0" image_width="150" image_height="160">
                                <cfelse>
                                    <cfif get_hr.sex eq 1>
                                        <img src="/images/male.jpg" title="<cf_get_lang_main no='1134.Yok'>">
                                    <cfelse>
                                        <img src="/images/female.jpg" title="<cf_get_lang_main no='1134.Yok'>">
                                    </cfif>
                                </cfif>
                            </td>
                        </tr>
                    </table>
                </cf_box>
     		</div> 
        	<cf_seperator title="#getLang('main',3216)#" id="takim" is_closed="1">
       		<div id="takim" style="display;width:100%">
            	<cf_form_list id="table3">
                	<thead>
                    	<tr>
                        	<th style="width:25px;text-align:center;"><cf_get_lang_main no='1165.Sıra'></th>
                           	<th style="width:190px;text-align:center;"><cfoutput>#getLang('myhome',1612)#</cfoutput></th>
                        </tr>
                    </thead>
                    <tbody>
                    	<cfif get_takim.recordcount>
							<cfoutput query="get_takim">
                                <tr>
                                    <td style="text-align:right">#currentrow#</td>
                                    <td style="text-align:left">#get_emp_info(EMPLOYEE_ID,0,0)#</td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                        	<tr>
                        		<td style="text-align:left" colspan="2"><cf_get_lang_main no='72.Kayıt Yok'></td>
                        	</tr>
                        </cfif>
                    </tbody>
                </cf_form_list>        
     		</div> 
            <cf_seperator title="#getLang('main',3228)#" id="grafik_1" is_closed="1">
       		<div id="grafik_1" style="display;width:100%">
            	<cf_form_list id="table3">
            	 	<tbody>
                    	<tr>
                    		<td style="text-align:right; white-space:215px; height:215px">
                            	 <table cellspacing="1" cellpadding="1" border="0" width="10%" height="100%" align="right">
                                 	<tr>
                                      <td> 
                                         <cfchart format="png" chartWidth="215" chartHeight="215" pieSliceStyle="sliced">
                                            <cfchartseries type="pie" itemcolumn="deneme1"> 
                                                <cfchartdata item="Çalışma" value="#t_c_time#">
                                                <cfchartdata item="Duraklama" value="#t_d_time#">
                                            </cfchartseries>
                                        </cfchart> 
                                      </td>
                                    </tr>
                                  </table>
                            </td>
                       	</tr>
                 	</tbody>
             	</cf_form_list>        
     		</div> 
        </td>
   	</tr>
</table>            	
<script type="text/javascript">
	function sw_start(type)
	{
		if(type==3)
		{
			window.close();
		}
	}
</script>  
