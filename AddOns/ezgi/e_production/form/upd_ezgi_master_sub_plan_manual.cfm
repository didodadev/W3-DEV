<cfset ezgi_gosterim_tip = 1> <!---0 Olduğunda Üst Emri Aynı Emirden Geliyorsa Bu sayfadakilerde Tek Select Geliyor--->
<cfset module_name="prod">
<cfquery name="get_default" datasource="#dsn3#">
	SELECT       
    	EMAD.POINT_METHOD,
        EMAD.FABRIC_CAT,
        EMAD.CONTROL_METHOD
	FROM            
    	EZGI_MASTER_PLAN_DEFAULTS AS EMAD INNER JOIN
     	EZGI_MASTER_PLAN AS EMAP ON EMAD.SHIFT_ID = EMAP.MASTER_PLAN_CAT_ID
	WHERE        
    	EMAP.MASTER_PLAN_ID = #attributes.master_plan_id#
</cfquery>
<cfparam name="attributes.islem" default="0">
<cfquery name="get_master_plan" datasource="#dsn3#">
	SELECT  	
		EMP.MASTER_PLAN_NAME, 
		EMP.MASTER_PLAN_DETAIL, 
		EMP.MASTER_PLAN_STATUS, 
    	EMP.MASTER_PLAN_CAT_ID, 
		EMP.BRANCH_ID, 
		EMP.GROSSTOTAL,
		EMP.MASTER_PLAN_ID, 
		EMP.MASTER_PLAN_NUMBER,
		EMP.MASTER_PLAN_PROJECT_ID,
		EMAP.MASTER_ALT_PLAN_NO,
		EMAP.MASTER_ALT_PLAN_STAGE, 
		EMAP.IS_STOCK_FIS, 
		EMAP.RECORD_DATE, 
    	EMAP.RECORD_IP, 
		EMAP.UPDATE_DATE, 
		EMAP.UPDATE_EMP,
    	EMAP.PLAN_START_DATE, 
		EMAP.PLAN_FINISH_DATE,
   		LTRIM(EMAP.PLAN_DETAIL) AS PLAN_DETAIL, 
		EMAP.UPDATE_IP,
     	EMAP.PLAN_POINT,
    	ISNULL(EMAP.PLAN_TYPE,0) AS PLAN_TYPE,
   		EMPS.SIRA,
    	EMAP.PROCESS_ID,
        <cfif get_default.POINT_METHOD eq 1>
    	ISNULL((	
                    SELECT     
                		SUM(PO.QUANTITY) AS P_POINT
                    FROM         
                        EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                        PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID
                    WHERE     
                        EMPR.MASTER_ALT_PLAN_ID =  EMAP.MASTER_ALT_PLAN_ID
    	),0) AS TOTAL_POINT,
        <cfelseif get_default.POINT_METHOD eq 2>
        ISNULL(
                	(	
                    SELECT     
                		SUM(PO.QUANTITY * ISNULL(PTIP.PROPERTY2, 0)) AS P_POINT
                    FROM         
                        EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                        PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID LEFT OUTER JOIN
                        PRODUCT_TREE_INFO_PLUS AS PTIP ON PO.STOCK_ID = PTIP.STOCK_ID
                    WHERE     
                        EMPR.MASTER_ALT_PLAN_ID =  EMAP.MASTER_ALT_PLAN_ID
              	),0) AS TOTAL_POINT,
        </cfif>
        <cfif get_default.POINT_METHOD eq 1>
        ISNULL((	
                    SELECT     
                		SUM(PO.QUANTITY) AS P_POINT
                    FROM         
                        EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                        PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID
                    WHERE     
                        EMPR.MASTER_ALT_PLAN_ID =  EMAP.MASTER_ALT_PLAN_ID AND PO.IS_STAGE = 2
    	),0) AS G_POINT
        <cfelseif get_default.POINT_METHOD eq 2>
        ISNULL(
                	(	
                    SELECT     
                		SUM(PO.QUANTITY * ISNULL(PTIP.PROPERTY2, 0)) AS P_POINT
                    FROM         
                        EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                        PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID LEFT OUTER JOIN
                        PRODUCT_TREE_INFO_PLUS AS PTIP ON PO.STOCK_ID = PTIP.STOCK_ID
                    WHERE     
                        EMPR.MASTER_ALT_PLAN_ID =  EMAP.MASTER_ALT_PLAN_ID AND PO.IS_STAGE = 2
              	),0) AS G_POINT
        </cfif>
	FROM       	
    	EZGI_MASTER_ALT_PLAN AS EMAP INNER JOIN
      	EZGI_MASTER_PLAN AS EMP ON EMAP.MASTER_PLAN_ID = EMP.MASTER_PLAN_ID INNER JOIN
      	EZGI_MASTER_PLAN_SABLON AS EMPS ON EMAP.PROCESS_ID = EMPS.PROCESS_ID
	WHERE     	
    	EMAP.MASTER_ALT_PLAN_ID = #attributes.master_alt_plan_id#
</cfquery>
<cfquery name="GET_OPERATION_NULL" datasource="#DSN3#">
	SELECT     
    	EZGI_OPERATION_S.*
	FROM         
    	EZGI_OPERATION_S
	WHERE     
   		MASTER_ALT_PLAN_ID IN
                      			(
                                SELECT     
                                  	MASTER_ALT_PLAN_ID
                           		FROM          
                                   	EZGI_MASTER_ALT_PLAN
                           		WHERE      
                                   	MASTER_ALT_PLAN_ID = #attributes.master_alt_plan_id# OR
                                   	RELATED_MASTER_ALT_PLAN_ID = #attributes.master_alt_plan_id#
                               	) AND 
         	O_STATION_IP IS NULL
</cfquery>
<cfquery name="GET_OPERATION_PROCESS" datasource="#DSN3#">
	SELECT     
    	EZGI_OPERATION_S.*
	FROM         
    	EZGI_OPERATION_S
	WHERE     
    	MASTER_ALT_PLAN_ID IN
                      			(
                                SELECT     
                                  	MASTER_ALT_PLAN_ID
                           		FROM          
                                   	EZGI_MASTER_ALT_PLAN
                           		WHERE      
                                   	MASTER_ALT_PLAN_ID = #attributes.master_alt_plan_id# OR
                                   	RELATED_MASTER_ALT_PLAN_ID = #attributes.master_alt_plan_id#
                               	) AND 
         	O_STATION_IP IS NOT NULL
</cfquery>
<cfquery name="menu_spec" datasource="#dsn3#">
    SELECT   	
    	*
    FROM       	 
    	EZGI_MASTER_PLAN_SABLON
    WHERE      
    	PROCESS_ID = #get_master_plan.PROCESS_ID#
</cfquery>
<cfif get_master_plan.recordcount>
	<cfset PROCESS_STAGE = get_master_plan.MASTER_ALT_PLAN_STAGE>
</cfif>
<cfquery name="get_prod_order" datasource="#dsn3#">
	<cfif menu_spec.IS_CONTROL eq 1>
		SELECT     	
        	PO.P_ORDER_ID, 
        	S.PRODUCT_CODE, 
       		S.PRODUCT_NAME, 
      		S.STOCK_ID, 
          	S.PRODUCT_ID, 
        	PO.STATION_ID, 
        	PO.START_DATE, 
        	PO.FINISH_DATE,
          	ISNULL(PO.PRINT_COUNT,0) PRINT_COUNT, 
         	PO.QUANTITY, 
         	PO.STATUS, 
         	PO.P_ORDER_NO, 
         	PO.PO_RELATED_ID, 
       		PO.ORDER_ROW_ID, 
         	PO.SPECT_VAR_NAME,
         	PO.SPECT_VAR_ID, 
         	PO.PROD_ORDER_STAGE, 
        	PO.IS_STOCK_RESERVED, 
         	PO.SPEC_MAIN_ID, 
         	PO.PRODUCTION_LEVEL, 
         	ISNULL(PO.IS_GROUP_LOT,0) IS_GROUP_LOT, 
     		PO.IS_STAGE, 
        	PO.DETAIL,
 			W.STATION_NAME, 
        	W.BRANCH,
         	PTR.STAGE,
         	ISNULL(PTIP.PROPERTY2, 0) AS PRODUCT_POINT,
         	ISNULL(PTIP.PROPERTY2, 0)*PO.QUANTITY as P_ORDER_POINT,
         	(
                SELECT     
                	S1.PRODUCT_NAME
				FROM         
                	PRODUCTION_ORDERS AS PO1 INNER JOIN
                  	STOCKS AS S1 ON PO1.STOCK_ID = S1.STOCK_ID
				WHERE     
                	PO1.P_ORDER_ID = PO.PO_RELATED_ID
         	) AS UST_EMIR,
        	ISNULL((
                SELECT  
                	TOP (1)   
                	P_ORDER_ID
               	FROM          
                	PRODUCTION_ORDERS
               	 WHERE      
                 	PO_RELATED_ID = PO.P_ORDER_ID
          	),0) AS ALT_EMIR,
         	CASE 
             	WHEN 
                	LEFT(PO.LOT_NO,1) = '-' 
                THEN 
                	SUBSTRING(PO.LOT_NO,2,LEN(PO.LOT_NO)-1)
              	ELSE PO.LOT_NO
        	END as LOT_NO,
        	ISNULL(O.ORDER_ID,0) AS ORDER_ID, 
          	O.ORDER_NUMBER, 
         	O.ORDER_DATE, 
          	O.ORDER_STATUS, 
         	O.DELIVERDATE,
         	O.IS_INSTALMENT,
         	ORRR.DELIVER_DATE,
         	CASE
            	WHEN O.COMPANY_ID IS NOT NULL THEN
                   (
                    SELECT     
                      	NICKNAME
					FROM         
                    	#dsn_alias#.COMPANY
					WHERE     
                   		COMPANY_ID = O.COMPANY_ID
                  	)
              	WHEN O.CONSUMER_ID IS NOT NULL THEN      
                   	(	
                  	SELECT     
                     	CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
					FROM         
                      	#dsn_alias#.CONSUMER
					WHERE     
                		CONSUMER_ID = O.CONSUMER_ID
               		)
              	WHEN O.EMPLOYEE_ID IS NOT NULL THEN
                  	(
                   	SELECT     
                    	EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS ISIM
					FROM         
                  		#dsn_alias#.EMPLOYEES
					WHERE     
                     	EMPLOYEE_ID = O.EMPLOYEE_ID
                 	)
            	ELSE      
                    	'Stok Üretim'
         	END AS UNVAN
		FROM  
       		ORDERS AS O INNER JOIN
         	PRODUCTION_ORDERS_ROW AS POR ON O.ORDER_ID = POR.ORDER_ID INNER JOIN
         	ORDER_ROW AS ORRR ON POR.ORDER_ROW_ID = ORRR.ORDER_ROW_ID RIGHT OUTER JOIN
          	STOCKS AS S INNER JOIN
        	PRODUCTION_ORDERS AS PO ON S.STOCK_ID = PO.STOCK_ID INNER JOIN
         	WORKSTATIONS AS W ON PO.STATION_ID = W.STATION_ID INNER JOIN
         	#dsn_alias#.PROCESS_TYPE_ROWS AS PTR ON PO.PROD_ORDER_STAGE = PTR.PROCESS_ROW_ID INNER JOIN
         	EZGI_MASTER_PLAN_RELATIONS AS EMPR ON PO.P_ORDER_ID = EMPR.P_ORDER_ID ON POR.PRODUCTION_ORDER_ID = PO.P_ORDER_ID LEFT OUTER JOIN
        	PRODUCT_TREE_INFO_PLUS AS PTIP ON S.STOCK_ID = PTIP.STOCK_ID
		WHERE     	
    		EMPR.MASTER_ALT_PLAN_ID = #attributes.master_alt_plan_id# AND 
        	PO.STATION_ID = #menu_spec.WORKSTATION_ID#
		ORDER BY 
        	O.ORDER_NUMBER,	
    		O.DELIVERDATE
 	<cfelse>
    	SELECT     	
       		PO.P_ORDER_ID, 
    		S.PRODUCT_CODE, 
         	S.PRODUCT_NAME, 
         	S.STOCK_ID, 
         	S.PRODUCT_ID, 
         	PO.STATION_ID, 
        	PO.START_DATE, 
         	PO.FINISH_DATE,
        	ISNULL(PO.PRINT_COUNT,0) PRINT_COUNT, 
         	PO.QUANTITY, 
          	PO.STATUS, 
         	PO.P_ORDER_NO, 
         	PO.PO_RELATED_ID, 
        	PO.ORDER_ROW_ID, 
        	PO.SPECT_VAR_NAME,
         	PO.SPECT_VAR_ID, 
         	PO.PROD_ORDER_STAGE, 
         	PO.IS_STOCK_RESERVED, 
          	PO.SPEC_MAIN_ID, 
         	PO.PRODUCTION_LEVEL, 
        	ISNULL(PO.IS_GROUP_LOT,0) IS_GROUP_LOT, 
        	PO.IS_STAGE, 
         	PO.DETAIL,
 			W.STATION_NAME, 
         	W.BRANCH,
        	PTR.STAGE,
          	ISNULL(PTIP.PROPERTY2, 0) AS PRODUCT_POINT,
          	ISNULL(PTIP.PROPERTY2, 0)*PO.QUANTITY as P_ORDER_POINT,
           	(
                SELECT     
                	S1.PRODUCT_NAME
				FROM         
                	PRODUCTION_ORDERS AS PO1 INNER JOIN
                  	STOCKS AS S1 ON PO1.STOCK_ID = S1.STOCK_ID
				WHERE     
                	PO1.P_ORDER_ID = PO.PO_RELATED_ID
          	) AS UST_EMIR,
         	ISNULL((
                SELECT   
                	TOP (1)    
                	P_ORDER_ID
               	FROM          
                	PRODUCTION_ORDERS
               	 WHERE      
                 	PO_RELATED_ID = PO.P_ORDER_ID
         	),0) AS ALT_EMIR,
          	CASE 
              	WHEN 
                	LEFT(PO.LOT_NO,1) = '-' 
               	THEN 
                	SUBSTRING(PO.LOT_NO,2,LEN(PO.LOT_NO)-1)
              	ELSE 
                	PO.LOT_NO
        	END AS LOT_NO,
         	0 AS ORDER_ID, 
       		'' AS ORDER_NUMBER, 
          	'' AS ORDER_DATE, 
         	1 AS ORDER_STATUS, 
         	'' AS DELIVERDATE,
       		'' AS DELIVER_DATE,
          	1 AS IS_INSTALMENT,
          	'' AS UNVAN
		FROM 
        	STOCKS AS S INNER JOIN
        	PRODUCTION_ORDERS AS PO ON S.STOCK_ID = PO.STOCK_ID INNER JOIN
        	WORKSTATIONS AS W ON PO.STATION_ID = W.STATION_ID INNER JOIN
          	#dsn_alias#.PROCESS_TYPE_ROWS AS PTR ON PO.PROD_ORDER_STAGE = PTR.PROCESS_ROW_ID INNER JOIN
          	EZGI_MASTER_PLAN_RELATIONS AS EMPR ON PO.P_ORDER_ID = EMPR.P_ORDER_ID LEFT OUTER JOIN
          	PRODUCT_TREE_INFO_PLUS AS PTIP ON S.STOCK_ID = PTIP.STOCK_ID
		WHERE     	
    		EMPR.MASTER_ALT_PLAN_ID = #attributes.master_alt_plan_id# AND 
        	PO.STATION_ID = #menu_spec.WORKSTATION_ID#
		ORDER BY 	
    		PO.START_DATE
    </cfif>    	           
</cfquery>
<cfset control_list=Valuelist(get_prod_order.P_ORDER_ID)>
<cfquery name="GET_W" datasource="#dsn3#">
	SELECT     	
    	EMAP.MASTER_ALT_PLAN_NO, 
    	EMAP.MASTER_ALT_PLAN_ID, 
      	EMAP.PLAN_FINISH_DATE, 
     	EMAP.PLAN_START_DATE,
      	EMAP.PLAN_TYPE,
        EMAP.PLAN_DETAIL,
      	EMP.MASTER_PLAN_NUMBER,
      	ISNULL(EMAP.PLAN_POINT,0) AS W_POINT,
    	EPN.WORKSTATION_ID,
    	EPN.SHIFT_ID,
      	EPN.SIRA,
      	ISNULL(
       		(	
          	SELECT     
            	SUM(PO.QUANTITY * ISNULL(PTIP.PROPERTY2, 0)) AS P_POINT
         	FROM         
           		EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
            	PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID LEFT OUTER JOIN
              	PRODUCT_TREE_INFO_PLUS AS PTIP ON PO.STOCK_ID = PTIP.STOCK_ID
        	WHERE     
          		EMPR.MASTER_ALT_PLAN_ID =  EMAP.MASTER_ALT_PLAN_ID
         	)
    	,0) AS TOTAL_POINT
	FROM      	
    	EZGI_MASTER_PLAN_SABLON AS EPN INNER JOIN
     	EZGI_MASTER_ALT_PLAN AS EMAP ON EPN.PROCESS_ID = EMAP.PROCESS_ID INNER JOIN
      	EZGI_MASTER_PLAN AS EMP ON EMAP.MASTER_PLAN_ID = EMP.MASTER_PLAN_ID
	WHERE     	
    	EPN.WORKSTATION_ID = (
        						SELECT    	
                                	WORKSTATION_ID
                              	FROM       	 
                                	EZGI_MASTER_PLAN_SABLON
                             	WHERE      	
                                	PROCESS_ID = #get_master_plan.PROCESS_ID#
                             	) AND 
      	EMAP.MASTER_ALT_PLAN_ID <> #attributes.master_alt_plan_id# AND 
        EMP.MASTER_PLAN_STATUS = 1 AND 
        EMP.MASTER_PLAN_PROCESS = 1 AND
        EMP.MASTER_PLAN_CAT_ID = 
        						(
                                SELECT     
                                	MASTER_PLAN_CAT_ID
								FROM         
                                	EZGI_MASTER_PLAN
								WHERE     
                                	MASTER_PLAN_ID = #attributes.master_plan_id#
        						)
  	ORDER BY	
    	EMAP.PLAN_START_DATE
</cfquery>
<!---<cfdump expand="yes" var="#GET_PROD_ORDER#">
<cfabort>--->
<cfquery name="order_group_control" dbtype="query">
	SELECT SPEC_MAIN_ID FROM GET_PROD_ORDER WHERE IS_STAGE <> 1 AND IS_STAGE <> 2 GROUP BY SPEC_MAIN_ID HAVING (COUNT(*) > 1)
</cfquery>
<cfquery name="order_related_control" dbtype="query">
	SELECT SPEC_MAIN_ID FROM GET_PROD_ORDER WHERE PO_RELATED_ID IS NOT NULL
</cfquery>
<cfquery name="p_order_is_group_control" dbtype="query">
	SELECT P_ORDER_ID FROM GET_PROD_ORDER WHERE IS_GROUP_LOT = 0 AND IS_STAGE <> 1 AND IS_STAGE <> 2
</cfquery>
<cfparam name="attributes.master_alt_plan_start_date" default="#get_master_plan.PLAN_START_DATE#">
<cfparam name="attributes.master_alt_plan_finish_date" default="#get_master_plan.PLAN_FINISH_DATE#">
<cfparam name="attributes.master_alt_plan_start_h" default="">
<cfparam name="attributes.master_alt_plan_finish_h" default="">
<cfparam name="attributes.master_alt_plan_start_m" default="">
<cfparam name="attributes.master_alt_plan_finish_m" default="">
<cfparam name="attributes.form_basket_submitted" default="">
<cfparam name="attributes.islem_id" default="">
<cfset islem_id = #get_master_plan.PROCESS_ID#>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr>
		<td height="35">
			<table border="0" width="99%" align="center">
				<tr>
					<td class="headbold" height="35"><cfoutput>#session.ep.COMPANY_NICK# #menu_spec.MENU_HEAD#</cfoutput></td>
					<td width="120" align="right">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ezgi_master_alt_plan_plus&master_alt_plan_id=#master_alt_plan_id#</cfoutput>','list');"><img src="/images/add_not.gif" title="<cf_get_lang_main no='3388.Takipler'>" border="0"></a>&nbsp;
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_ezgi_material_system&master_alt_plan_id=#master_alt_plan_id#</cfoutput>','longpage');"><img src="/images/target_micro.gif" title="<cf_get_lang_main no='3283.Alt Plan Malzeme Kontrol Sistemi'>" border="0"></a>&nbsp;
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ezgi_internaldemand_relation&subject=#get_master_plan.MASTER_ALT_PLAN_NO#</cfoutput>','list');"><img src="/images/stockstrategy.gif" title="<cf_get_lang_main no='3389.Alt Plan Malzeme İç Talep Karşılama Raporu'>" border="0"></a>&nbsp;
					<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_ezgi_master_plan&upd_id=#master_plan_id#"><img src="/images/outsource.gif" title="<cf_get_lang_main no='3390.Master Plana Geri Dön'>" border="0"></cfoutput></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" height="95%" class="color-border">
				<tr>
					<cfform name="form_master_alt_plan" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_master_sub_plan">
					<input type="hidden" name="form_master_alt_plan_submitted" value="1" />
                  	<input type="hidden" name="master_plan_id" value="<cfoutput>#master_plan_id#</cfoutput>">
					<input type="hidden" name="master_alt_plan_id" value="<cfoutput>#master_alt_plan_id#</cfoutput>">
                    <input type="hidden" name="islem_id" value="<cfoutput>#get_master_plan.PROCESS_ID#</cfoutput>" />
                    
					<td valign="top" height="50" class="color-row">
						<table>
							<tr>
								<td width="85" nowrap><cf_get_lang_main no='70.Aşama'></td>
								<td width="165"><cf_workcube_process is_upd='0' select_value='#process_stage#' process_cat_width='125' is_detail='1'> </td>
								<td width="80"><cf_get_lang_main no='243.Başlama Tarihi'>*</td>
								<td width="175" nowrap="nowrap"><cfoutput>
									<cfsavecontent variable="message"><cf_get_lang_main no ='1333.Baslama Tarihi Girmelisiniz'> !</cfsavecontent>
                                    <input required="Yes"  message="#message#" type="text" name="master_alt_plan_start_date" id="master_alt_plan_start_date"  validate="eurodate" style="width:65px;" value="#dateformat(attributes.master_alt_plan_start_date,'DD/MM/YYYY')#" > 
                                   <cf_wrk_date_image date_field="master_alt_plan_start_date">
                                    <select name="master_alt_plan_start_h" id="master_alt_plan_start_h">
                                    <cfloop from="0" to="23" index="i">
                                        <option value="#i#" <cfif isdefined('attributes.master_alt_plan_start_date') and timeformat(attributes.master_alt_plan_start_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
                                <select name="master_alt_plan_start_m" id="master_alt_plan_start_m">
                                    <cfloop from="0" to="59" index="i">
                                        <option value="#i#" <cfif isdefined('attributes.master_alt_plan_start_date') and timeformat(attributes.master_alt_plan_start_date,'MM') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
                                </cfoutput>
								</td>
								<td width="60"><cf_get_lang_main no='1174.İşlemi Yapan'></td>
								<td width="160"><input type="hidden" name="expense_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
									<input type="text" name="expense_employee" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" readonly="yes" style="width:140px;">
								</td>
								<td><cf_get_lang_main no='217.Açıklama'></td>
                                <td rowspan="4" nowrap valign="top">
                                	<textarea name="detail" id="detail" style="width:200px;height:50px;"><cfoutput>#get_master_plan.PLAN_DETAIL#</cfoutput></textarea>
                                </td>
							</tr>
							<tr>
								<td>Master Plan No </td>
								<td><input type="text" name="master_plan_number" readonly="readonly" value="<cfoutput>#get_master_plan.master_plan_NUMBER#</cfoutput>"  maxlength="75" style="width:140px;"></td>
								<td><cf_get_lang_main no='288.Bitis Tarihi'>*</td>
								<td><cfoutput>
									<input type="hidden" name="_popup" value="2">
									<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
									<input required="Yes"  message="#message#" type="text" name="master_alt_plan_finish_date" id="master_alt_plan_finish_date"  validate="eurodate" style="width:65px;" value="#dateformat(attributes.master_alt_plan_finish_date,'DD/MM/YYYY')#" > 
                                   <cf_wrk_date_image date_field="master_alt_plan_finish_date">




                                    <select name="master_alt_plan_finish_h" id="master_alt_plan_finish_h">
                                    <cfloop from="0" to="23" index="i">
                                        <option value="#i#" <cfif isdefined('attributes.master_alt_plan_finish_date') and timeformat(attributes.master_alt_plan_finish_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
                                <select name="master_alt_plan_finish_m" id="master_alt_plan_finish_m">
                                    <cfloop from="0" to="59" index="i">
                                        <option value="#i#" <cfif isdefined('attributes.master_alt_plan_finish_date') and timeformat(attributes.master_alt_plan_finish_date,'MM') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
									</cfoutput>
								</td>
								<td><cf_get_lang_main no='4.Proje'></td>
                                <td>
								<input type="hidden" name="project_id" value="#get_master_plan.MASTER_PLAN_PROJECT_ID#" />
								<input type="text" name="project_name" value="<cfif len(get_master_plan.MASTER_PLAN_PROJECT_ID)><cfoutput>#get_project_name(get_master_plan.MASTER_PLAN_PROJECT_ID)#</cfoutput></cfif>" readonly style="width:140px;"></td>
							</tr>
							<tr>
								<td><cf_get_lang_main no='3212.Alt Plan'> No</td>
								<td><cfoutput><input name="paper_serious" type="text" value="#get_master_plan.MASTER_ALT_PLAN_NO#" style="width:75px;" /></cfoutput></td>
								<td><cf_get_lang_main no='3212.Alt Plan'> <cf_get_lang_main no='3019.Tipi'></td>
								<td>
                                	<select name="plan_type" style="width:100px">
                                    	<option value="0" <cfif get_master_plan.plan_type eq 0>selected</cfif>>Normal Plan</option>
                                        <option value="1" <cfif get_master_plan.plan_type eq 1>selected</cfif>><cf_get_lang_main no='3391.Torba Plan'></option> 
                                    </select>
                                </td>
                                <td><cf_get_lang_main no='3392.Hedef İş'></td>
								<td><cfoutput><input name="work_point" type="text" value="#get_master_plan.PLAN_POINT#" style="width:65px;" /></cfoutput></td>
                                <td colspan="3"><strong><cf_get_lang_main no='1457.Planlanan'> : </strong><cfoutput>#Tlformat(get_master_plan.TOTAL_POINT,2)#&nbsp;&nbsp;&nbsp;&nbsp;<strong>#getLang('report',1004)# : </strong>#Tlformat(get_master_plan.G_POINT,2)#</cfoutput></td>
                                <td colspan="2"></td>
							</tr>
							<tr>
								<td colspan="2"></td>
                                <cfif menu_spec.IS_GROUP and p_order_is_group_control.recordcount>
                                	<td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;<font color="#FF0000"><strong> <cf_get_lang_main no='3393.Dikkat Gruplama Yapmalısınız'> !!!</strong></font></td>
                             	<cfelse>
                                	<cfif menu_spec.IS_COLLECT and order_group_control.recordcount>
                                   		<td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;<font color="#FF0000"><strong> <cf_get_lang_main no='3394.Emirleri Birleştiriniz.	'></strong></font></td>
                             		<cfelse>
                                		<td colspan="3">&nbsp;</td>
                                  	</cfif>      
                                </cfif>
								<td colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;<cfif attributes.islem_id gt 0><cf_workcube_buttons is_upd='1' add_function =''is_delete='0'><cfelse><cf_workcube_buttons add_function ='' is_delete='0'></cfif></td>
							</tr>
						</table>
					</td>
                    <td style="text-align:center;" valign="middle" width="100px" class="color-row">
                    	<cfif GET_OPERATION_PROCESS.recordcount and GET_OPERATION_NULL.recordcount>
                        	<cfif menu_spec.SIRA eq 1>
                                <a href="<cfoutput>#request.self#?fuseaction=prod.emptypopup_display_ezgi_hesap&master_plan_id=#master_plan_id#&master_alt_plan_id=#master_alt_plan_id#&islem_id=#islem_id#&islem=2</cfoutput>">
                                    <img src="/images/production/eksik_plan.png" title="<cf_get_lang_main no='3395.Operasyon Planı Yarım'>" border="0">
                                </a> 
                            <cfelse>
                            	<img src="/images/production/eksik_plan.png" title="<cf_get_lang_main no='3395.Operasyon Planı Yarım'>" border="0">
                            </cfif>    
                      	<cfelseif GET_OPERATION_PROCESS.recordcount>
							<cfif menu_spec.SIRA eq 1>
                                <a href="<cfoutput>#request.self#?fuseaction=prod.emptypopup_display_ezgi_hesap&master_plan_id=#master_plan_id#&master_alt_plan_id=#master_alt_plan_id#&islem_id=#islem_id#&islem=2</cfoutput>">
                                    <img src="/images/production/tam_plan.jpg" title="<cf_get_lang_main no='3396.Operasyon Planı Tamam'>" border="0">
                                </a>
                            <cfelse>
                                <img src="/images/production/tam_plan.jpg" title="<cf_get_lang_main no='3396.Operasyon Planı Tamam'>" border="0">
                            </cfif>
                       	<cfelseif GET_OPERATION_NULL.recordcount>
                        	<cfif menu_spec.SIRA eq 1>
                                <a href="<cfoutput>#request.self#?fuseaction=prod.emptypopup_display_ezgi_hesap&master_plan_id=#master_plan_id#&master_alt_plan_id=#master_alt_plan_id#&islem_id=#islem_id#&islem=1</cfoutput>">
                                    <img src="/images/production/plan_yok.png" title="<cf_get_lang_main no='3397.Operasyon Planı Yapılmamış'>" border="0">     
                                </a>
                      		<cfelse>
                            	<img src="/images/production/plan_yok.png" title="<cf_get_lang_main no='3397.Operasyon Planı Yapılmamış'>" border="0">
                            </cfif>
                    	</cfif>
                    </td>
				</tr>
				<tr>
					<td colspan="2" class="color-row" valign="top">
						<table cellspacing="1" cellpadding="2" width="100%" border="0" class="color-border">
							<tr class="color-header" height="25">
							<input type="hidden" name="islem" value="1" />
								<td class="txtboldblue" width="20" align="center"></td>
                                <td class="form-title" width="60"><cf_get_lang_main no='1677.Emir No'></td>
                                <td class="form-title" width="70"><cf_get_lang_main no='799.Sipariş No'></td>
                                <td class="form-title" width="60"><cf_get_lang_main no='1704.Sipariş Tarihi'></td>
                                <td class="form-title" width="60"><cf_get_lang_main no='3093.Termin Tarihi'></td>
                               	<td class="form-title" width="60">Lot No</td>
                                <cfif menu_spec.IS_CONTROL eq 1 and menu_spec.SIRA eq 1>
                                	<td class="form-title" ><cfoutput>#getLang('main',649)# #getLang('main',159)#</cfoutput></td>
                              	<cfelse>
                                	<td class="form-title" ><cf_get_lang_main no='3398.İlişkili Üst Emir'></td>
                                </cfif>      
                                <td class="form-title" ><cf_get_lang_main no='245.Ürün'></td>
                                <td class="form-title" width="90" >Spec</td>
                               	<td class="form-title" width="60"><cf_get_lang_main no='1447.Süreç'></td>
                                <td class="form-title" width="80" align="center"><cfoutput>#getLang('prod',291)#<br />#getLang('prod',293)#</cfoutput></td>
                               	<td class="form-title" width="50" align="center"><cf_get_lang_main no='223.Miktar'></td>
                                <td class="form-title" width="50" align="center"><cf_get_lang_main no='1572.Puan'></td>
                                <cfif menu_spec.IS_CONTROL eq 1>
                                	<td class="form-title" width="20" align="center">OPT</td>
                                    <td class="form-title" width="20" align="center">MLZ</td>
                                </cfif>
                               	<td width="20">
                               	<cfoutput>
                                  	<cfif menu_spec.P_ORDER_FROM_ORDER eq 1>
                                    		<a href="#request.self#?fuseaction=prod.ezgi_tracking&master_plan_id=#master_plan_id#&master_alt_plan_id=#master_alt_plan_id#&islem_id=#islem_id#">
                                    		<img src="/images/add_1.gif" alt="<cf_get_lang_main no='3399.Siparişten Emir Oluştur'>" border="0">                                	
                                        	</a>
                                    </cfif>
                                    <cfif menu_spec.SSH_P_ORDER eq 1>
                                    		<a href="#request.self#?fuseaction=prod.popup_upd_ssh_manual&master_plan_id=#master_plan_id#&master_alt_plan_id=#master_alt_plan_id#&islem_id=#islem_id#">
                                    		<img src="/images/care_plus.gif" alt="SSH <cf_get_lang_main no='3400.Emir Oluştur'>" border="0">                                	
                                        	</a>
                                    </cfif>
                               	</cfoutput>
                                </td>
                               	<td width="1%" align="center">
                                <cfoutput>
                                	<cfif menu_spec.TOPLU_P_ORDERS eq 1>
                                		<a href="#request.self#?fuseaction=prod.add_ezgi_prod_order&master_alt_plan_id=#master_alt_plan_id#&is_collacted=1&islem_id=#islem_id#">
                                    	<img src="/images/copy_list_white.gif" alt="<cf_get_lang no='221.Toplu Üretim Emri Ekle'>" border="0">
                                   		</a>
                                    </cfif>
                                    <cfif menu_spec.STOCK_TO_P_ORDER eq 1>

                                        	<a href="#request.self#?fuseaction=prod.add_ezgi_prod_order&master_alt_plan_id=#master_alt_plan_id#&islem_id=#islem_id#">
                                            <img src="/images/plus_square.gif" alt="<cf_get_lang no='3401.Üretim Emri Ekle'>" border="0">
                                        	</a>
                                    </cfif>
                                    <cfif menu_spec.P_ORDER_UPDATE eq 1>
                                    		<a href="#request.self#?fuseaction=prod.popup_upd_paket_manual&master_plan_id=#master_plan_id#&master_alt_plan_id=#master_alt_plan_id#">
                                    		<img src="/images/workdevwork.gif" alt="<cf_get_lang_main no='3402.İlişkili Emri Düzenle'>" border="0">                                	
                                        	</a>
                                    </cfif>
                                    <cfif menu_spec.FROM_UP_P_ORDER eq 1>
                                    		<a href="#request.self#?fuseaction=prod.popup_upd_parca_manual&master_plan_id=#master_plan_id#&master_alt_plan_id=#master_alt_plan_id#&islem_id=#islem_id#">
                                    		<img src="/images/action_plus.gif" alt="<cf_get_lang_main no='3403.Alt Emir Ekle'>" border="0">                                	
                                        	</a>
                                    </cfif>
                                    <cfif menu_spec.P_ORDER_FREE eq 1>
                                    		<a href="#request.self#?fuseaction=prod.popup_ezgi_upd_parca_1_manual&master_plan_id=#master_plan_id#&master_alt_plan_id=#master_alt_plan_id#&islem_id=#islem_id#">
                                    		<img src="/images/star_full_19x20.png" alt="<cf_get_lang_main no='3404.Stoğa Emir Ekle'>" border="0">                                	
                                        	</a>
                                    </cfif>

                            	</cfoutput>
                               	</td>
                               	<td width="1%" align="center">
                                	<cfoutput><a href="javascript://" onClick="grupla(-2);"><img src="/images/print2_white.gif" alt="#getLang('main',62)#" border="0"></a></cfoutput>
                              	<input type="checkbox" alt="<cf_get_lang no ='546.Hepsini Seç'>" onClick="grupla(-1);">
                             	</td>
							</tr>
                            
                            <form name="convert_demand_to_production" method="post" action="">
                            <cfif get_prod_order.recordcount>
                            	<cfoutput query="get_prod_order">
                                     <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                                    	<td>#currentrow#</td>
                                        <td align="center"><a href="#request.self#?fuseaction=prod.order&event=upd&upd=#P_ORDER_ID#" class="tableyazi" target="_blank">#P_ORDER_NO#</a></td>
                                        <cfif is_instalment eq 1>
											<cfset page_type = 'list_order_instalment&event=upd'>
                                        <cfelse>
                                            <cfset page_type = 'list_order&event=upd'>
                                        </cfif>
                                        <td align="center"><a href="#request.self#?fuseaction=sales.#page_type#&order_id=#ORDER_ID#" class="tableyazi" target="_blank">#ORDER_NUMBER#</a></td>
                                        <td style="text-align:center">#DateFormat(ORDER_DATE,'DD/MM/YYYY')#</td>
                                        <td style="text-align:center">#DateFormat(DELIVER_DATE,'DD/MM/YYYY')#</td>
                                        <td style="text-align:center">#LOT_NO#</td>
                                        <cfif menu_spec.IS_CONTROL eq 1>
                                        	<td align="center">#unvan#</td>
                                        <cfelse>
                                        	<td align="center">#UST_EMIR#</td>
                                        </cfif>
                                		<td><a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#stock_id#" class="tableyazi" target="_blank">#product_name#</a></td>
                                        <td align="left">
											<cfif len(SPECT_VAR_ID)>
												<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect&id=#SPECT_VAR_ID#&stock_id=#stock_id#','list');" class="tableyazi">#spec_main_id#-#spect_var_id#</a>	
											</cfif>
                                       	</td>
                                        <td align="center">#STAGE#</td>
                                        <td align="center" nowrap>#DateFormat(start_date,'DD/MM/YYYY')#<br />#DateFormat(finish_date,'DD/MM/YYYY')#</td>
                                        <td style="text-align:right">#TlFormat(QUANTITY,2)#</td>
                                        <td style="text-align:right">#TlFormat(P_ORDER_POINT,2)#</td>
                                        <cfif menu_spec.IS_CONTROL eq 1>
                                        	<cfquery name="get_kontrol_0" datasource="#dsn3#"> <!---Optimizasyona ve Var-yok a giren emirler soruluyor--->
                                                SELECT DISTINCT 
                                                    POS.STOCK_ID, 
                                                    POS.AMOUNT,
                                                    EMC.STATUS
                                                FROM         
                                                    EZGI_METARIAL_CONTROL AS EMC INNER JOIN
                                                    PRODUCTION_ORDERS_STOCKS AS POS ON EMC.POR_STOCK_ID = POS.POR_STOCK_ID
                                                WHERE     
                                                	<cfif get_default.CONTROL_METHOD eq 1 or ORDER_ID eq 0>
                                                        EMC.LOT_NO = '#lot_no#'
                                                    <cfelseif get_default.CONTROL_METHOD eq 2 and ORDER_ID gt 0>
                                                        EMC.ORDER_ID = #order_id# AND
                                                        POS.POR_STOCK_ID IN 
                                                        					(
                                                                                SELECT        
                                                                                    POSS.POR_STOCK_ID
                                                                                FROM           
                                                                                    PRODUCTION_ORDERS_ROW AS PORR INNER JOIN
                                                                                    PRODUCTION_ORDERS_STOCKS AS POSS ON PORR.PRODUCTION_ORDER_ID = POSS.P_ORDER_ID
                                                                                WHERE        
                                                                                    PORR.ORDER_ID = #order_id#  AND 
                                                                                    PORR.TYPE = 1
                                                                            
                                                                            )
                                                    </cfif>
                                                     
                                            </cfquery>
                                            <cfquery name="get_kontrol_1" dbtype="query"> <!---Var Denilenler Bulunuyor--->
                                                SELECT
                                                    STOCK_ID, 
                                                    AMOUNT
                                                FROM         
                                                    get_kontrol_0
                                                WHERE     
                                                    STATUS = 1
                                            </cfquery>

                                            <cfquery name="get_kontrol_2" dbtype="query"> <!---Yok Denilenler Bulunuyor--->
                                                SELECT
                                                    STOCK_ID, 
                                                    AMOUNT
                                                FROM         
                                                    get_kontrol_0
                                                WHERE     
                                                    STATUS = 2
                                            </cfquery>
                                            <cfquery name="get_ezgi_metarial_control" dbtype="query"> <!---Yok Denilenler Guruplanıyor--->
                                                SELECT
                                                    STOCK_ID, 
                                                    SUM(AMOUNT) AS AMOUNT
                                                FROM         
                                                    get_kontrol_2
                                                GROUP BY 
                                                    STOCK_ID
                                            </cfquery>
                                           <cfquery name="get_ezgi_metarial_control_0" dbtype="query"> <!---Optimizasyondan Geçen heşey guruplanıyor--->
                                                SELECT
                                                    STOCK_ID, 
                                                    SUM(AMOUNT) AS AMOUNT
                                                FROM         
                                                    get_kontrol_0
                                                GROUP BY 
                                                    STOCK_ID
                                            </cfquery>
                                            <cfloop query="get_ezgi_metarial_control_0">
                                                <cfset 'CONTROL_#get_prod_order.lot_no#_#get_ezgi_metarial_control_0.STOCK_ID#'= get_ezgi_metarial_control_0.AMOUNT>
                                            </cfloop>
                                           	<cfquery name="get_ic_talep" datasource="#dsn3#">
                                            	SELECT     
                                             		I.INTERNAL_NUMBER, 
                                                 	EMR.ACTION_ID, 
                                                  	IR.STOCK_ID
                                              	FROM         
                                                   	EZGI_METARIAL_RELATIONS AS EMR INNER JOIN
                                                   	INTERNALDEMAND AS I ON EMR.ACTION_ID = I.INTERNAL_ID INNER JOIN
                                                   	INTERNALDEMAND_ROW AS IR ON I.INTERNAL_ID = IR.I_ID
                                              	WHERE     
                                               		EMR.TYPE = 1 AND 
                                                    <cfif get_default.CONTROL_METHOD eq 1 or ORDER_ID eq 0>
                                                        EMR.LOT_NO = '#lot_no#' AND 
                                                    <cfelseif get_default.CONTROL_METHOD eq 2 and ORDER_ID gt 0>
                                                        EMR.LOT_NO = '#ORDER_NUMBER#' AND 
                                                    </cfif>
                                                    IR.STOCK_ID IN 
                                                    				(
                                                                	SELECT     
                                                                   		STOCK_ID
																	FROM         
                                                                     	STOCKS
																	WHERE     
                                                                     	STOCK_CODE LIKE N'#get_default.FABRIC_CAT#%'
                                                                  	)
                                          	</cfquery>
                                            
                                            <cfquery name="get_period" datasource="#dsn3#">
                                                SELECT     

                                                    PERIOD_ID
                                                FROM         
                                                    EZGI_METARIAL_RELATIONS
                                                WHERE     
                                                    TYPE = 2 AND 
                                                    <cfif get_default.CONTROL_METHOD eq 1 or get_prod_order.ORDER_ID eq 0>
                                                        LOT_NO = '#lot_no#' 
                                                    <cfelseif get_default.CONTROL_METHOD eq 2 and get_prod_order.ORDER_ID gt 0>
                                                        ORDER_ID = #get_prod_order.ORDER_ID#
                                                    </cfif>
                                            </cfquery>
                                            <cfset teslim = 0>
                                            <cfset teslim_1 = 0>
                                            <cfif get_period.recordcount>
                                                <cfset period_list = ValueList(get_period.PERIOD_ID)>
                                                <cfquery name="get_period_ship_dsns" datasource="#dsn3#">
                                                    SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#period_list#)
                                                </cfquery>
                                            </cfif>
                                            <cfif isdefined('period_list') and listlen(period_list) and period_list neq 0>
                                                <cfquery name="get_control_ambar_fis" datasource="#DSN3#">
                                                    SELECT 
                                                        STOCK_ID,
                                                        SUM(AMOUNT) AMOUNT
                                                    FROM
                                                        (
                                                        <cfloop query="get_period_ship_dsns">
                                                            SELECT     
                                                                SFR.STOCK_ID, 
                                                                SFR.AMOUNT
                                                            FROM         
                                                                EZGI_METARIAL_RELATIONS INNER JOIN
                                                                #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.STOCK_FIS_ROW AS SFR ON EZGI_METARIAL_RELATIONS.ACTION_ID = SFR.FIS_ID
                                                            WHERE     
                                                                EZGI_METARIAL_RELATIONS.TYPE = 2 AND 
                                                                EZGI_METARIAL_RELATIONS.PERIOD_ID = #get_period_ship_dsns.period_id# AND 
                                                                <cfif get_default.CONTROL_METHOD eq 1 or get_prod_order.ORDER_ID eq 0>
                                                                    EZGI_METARIAL_RELATIONS.LOT_NO = '#get_prod_order.lot_no#' AND
                                                                <cfelseif get_default.CONTROL_METHOD eq 2 and get_prod_order.ORDER_ID gt 0>
                                                                    EZGI_METARIAL_RELATIONS.ORDER_ID = #get_prod_order.ORDER_ID# AND
                                                                </cfif> 
                                                                SFR.STOCK_ID IN (
                                                                				SELECT     
                                                                                	STOCK_ID
																				FROM         
                                                                                	STOCKS
																				WHERE     
                                                                                	STOCK_CODE LIKE N'#get_default.FABRIC_CAT#%'
                                                                              	)
                                                            <cfif currentrow neq get_period_ship_dsns.recordcount> UNION ALL </cfif> 
                                                        </cfloop>
                                                        ) TBL
                                                    GROUP BY
                                                        STOCK_ID 			
                                                </cfquery>
                                                <cfif get_control_ambar_fis.recordcount>
													<cfif get_control_ambar_fis.recordcount neq get_ezgi_metarial_control_0.recordcount>
                                                        <cfset teslim = 2>		
                                                    <cfelse>
                                                        <cfset teslim = 1>
                                                    </cfif>
                                            	<cfelse>
                                            		<cfset teslim = 0>
                                            	</cfif>
                                            </cfif>
                                        	<td align="center">
                                            	<cfif get_kontrol_0.recordcount eq 0>
                                                    <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_control&lot_no=#LOT_NO#&master_plan_id=#attributes.master_plan_id#','wide');"> <img src="/images/production/offlineuser.gif" tittle="<cf_get_lang_main no='3319.Optimizasyon Onay Verilmedi'>" border="0">
                                              		</a>
                                               	<cfelse>
                                                	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_control&lot_no=#LOT_NO#&master_plan_id=#attributes.master_plan_id#','wide');"> 
                                                	 <img src="/images/production/onlineuser_1.gif" tittle="<cf_get_lang_main no='3320.Optimizasyon Onay Verildi'>">
                                                     </a>
                                              	</cfif> 
                                            </td>
                                            <td align="center">
                                            	<cfif get_kontrol_0.recordcount>
                                                	
														<cfif get_kontrol_1.recordcount neq get_kontrol_0.recordcount>	
                                                            <cfif get_ic_talep.recordcount eq 0>
                                                                <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_control&lot_no=#LOT_NO#&master_plan_id=#attributes.master_plan_id#','wide');"> <img src="/images/production/offlineuser.gif" tittle="<cf_get_lang_main no='3321.İç Talep Verilmedi'>">
                                                                </a>
                                                            <cfelse>
                                                                <cfif get_ic_talep.recordcount neq get_ezgi_metarial_control.recordcount>
                                                                    <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_control&lot_no=#LOT_NO#&master_plan_id=#attributes.master_plan_id#','wide');"> <img src="/images/production/onlineuser.gif" tittle="<cf_get_lang_main no='3322.İç Talep Eksik Verildi'>">
                                                                    </a>
                                                                <cfelse>
                                                                	<cfif teslim eq 0>
                                                                    	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#&master_plan_id=#attributes.master_plan_id#','page');"> <img src="/images/production/onlineuser_2.gif" tittle="<cf_get_lang_main no='3323.İç Talep Tam Verildi'>">
                                                                    	</a>
                                                                  	<cfelseif teslim eq 1>
                                                                    	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#&master_plan_id=#attributes.master_plan_id#','page');">
                                                                        <img src="/images/production/onlineuser_1.gif" tittle="<cf_get_lang_main no='3324.Tam Ambar Fişi'>">
                                                                        </a>
                                                                    <cfelseif teslim eq 2>
                                                                    	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#&master_plan_id=#attributes.master_plan_id#','page');">
                                                                        <img src="/images/production/onlineuser_3.gif" tittle="<cf_get_lang_main no='3325.Eksik Ambar Fişi'>">
                                                                        </a>
                                                                    </cfif>      
                                                                </cfif>
                                                            </cfif>
                                                        <cfelse>
                                                        	<cfif teslim eq 0>
                                                            <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#&master_plan_id=#attributes.master_plan_id#','page');"> <img src="/images/production/onlineuser_2.gif" tittle="<cf_get_lang_main no='3326.Kumaşlar Mevcut'>">
                                                            </a>
                                                            <cfelseif teslim eq 1>
                                                            	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#&master_plan_id=#attributes.master_plan_id#','page');">
                                                            	<img src="/images/production/onlineuser_1.gif" tittle="<cf_get_lang_main no='3324.Tam Ambar Fişi'>">
                                                                </a>
                                                            <cfelseif teslim eq 2>
                                                            	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#&master_plan_id=#attributes.master_plan_id#','page');">
                                                            	<img src="/images/production/onlineuser_3.gif" tittle="<cf_get_lang_main no='3325.Eksik Ambar Fişi'>">
                                                                </a>
                                                            </cfif>
                                                        </cfif>
                                              	</cfif>              
                                            </td>
                                        </cfif>
                                        <td style="text-align:center" <cfif menu_spec.IS_COLLECT><cfif ALT_EMIR gt 0>bgcolor="orange"</cfif></cfif>>
											<cfif IS_STAGE eq 4>
												<cfif IS_GROUP_LOT eq 1>
                                                     <img src="/images/g_blue_glob.gif" title="<cf_get_lang no ='579.Gruplandı Fakat Operatöre Gönderilmedi'>">
                                                <cfelse>
                                                     <img src="/images/blue_glob.gif" title="<cf_get_lang no ='270.Başlamadı'>">
                                                </cfif>       
                                            <cfelseif IS_STAGE eq 0>
                                                <img src="/images/yellow_glob.gif" title="<cf_get_lang no ='578.Operatöre Gönderildi'>">
                                            <cfelseif IS_STAGE eq 1>
                                                <img src="/images/green_glob.gif" title="<cf_get_lang no ='577.Başladı'>">
                                            <cfelseif IS_STAGE eq 2>
                                                <img src="/images/red_glob.gif" title="<cf_get_lang no ='271.Bitti'>">
                                            <cfelseif IS_STAGE eq 3>
                                                <img src="/images/grey_glob.gif" title="<cf_get_lang no ='270.Başlamadı'>">
                                            </cfif>
                                      	</td>
                                        <td style="text-align:center"><a href="#request.self#?fuseaction=prod.order&event=upd&upd=#P_ORDER_ID#" class="tableyazi" target="_blank"> <img src="/images/update_list.gif" alt="<cf_get_lang no='123.Üretim Emri Düzenle'>" border="0"></a></td>
                                        <td style="text-align:center" <cfif PRINT_COUNT gt 0>bgcolor="orange"</cfif>>
                                        <cfif IS_STAGE neq 1 and IS_STAGE neq 2>
                                            <input type="checkbox" name="select_production" value="#P_ORDER_ID#">
                                        <cfelse>
                                        	&nbsp;
                                        </cfif>
                                        </td>
                                    </tr>
                                </cfoutput>
                            <cfelse>
                            	<cfif menu_spec.IS_CONTROL eq 1>
                                	<cfset colspan_e = 18>
                                <cfelse>
                                	<cfset colspan_e = 17>
                                </cfif>

                            	<tr>
                            		<td class="color-row" colspan="<cfoutput>#colspan_e#</cfoutput>"> <cf_get_lang_main no='3405.Üretim Emri Giriniz'></td>
                            	</tr>
                            </cfif>
                            <tr>
                            	<td colspan="8" align="left" class="color-row">
                                    <cfset b = 1>
                                    <select name="master_alt_plan" id="master_alt_plan" style="width:490px;font-weight:bold">
                                        <option value=""><cf_get_lang_main no='3212.Alt Plan'> <cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_w">
                                            <option value="#MASTER_ALT_PLAN_ID#"> (#MASTER_PLAN_NUMBER#) - #MASTER_ALT_PLAN_NO# - <cfif PLAN_TYPE eq 0>#Dateformat (PLAN_START_DATE, 'DD/MM/YYYY')# - #Dateformat (PLAN_FINISH_DATE, 'DD/MM/YYYY')# - #W_POINT# / #Tlformat(TOTAL_POINT,2)# - #PLAN_DETAIL#<cfelse><strong>Torba Plan</strong></font></cfif>
                                			</option>
                                        </cfoutput>
                                    </select>
                                    <cfif menu_spec.is_movie eq 1>
                                    	<input type="button" value="<cf_get_lang_main no='3406.Alt Plana Gönder'>" style="font-size:9px" onClick="grupla(-5);" />
                                    </cfif>
                                    <input type="button" value="<cf_get_lang_main no='3407.Alt Plana Git'>" style="font-size:9px"  onClick="git(-6);" />
                                </td>
                                <cfif menu_spec.IS_CONTROL eq 1>
                                	<cfset colspan_e = 10>
                                <cfelse>
                                	<cfset colspan_e = 9>
                                </cfif>
                            	<td class="color-row" colspan="<cfoutput>#colspan_e#</cfoutput>" style="text-align:right">
                                	<cfif menu_spec.IS_DELETE>
                                    	<input type="button" value="<cfoutput>#getLang('main',51)#</cfoutput>" onClick="grupla(-10);" />
                                    </cfif>
                                	<cfif menu_spec.IS_GROUP and p_order_is_group_control.recordcount>
                                        <input type="button" value="<cfoutput>#getLang('prod',502)#</cfoutput>" onClick="grupla(-4);" />
                                    <cfelse>
                                        <cfif menu_spec.IS_COLLECT and (order_related_control.recordcount or order_group_control.recordcount)>

                                          	<input type="button" value="<cfoutput>#getLang('main',3408)#</cfoutput>" style="font-size:9px"  onClick="grupla(-7);" /> 
                                        </cfif>
                                        <input type="button" value="<cf_get_lang_main no='1422.İstasyon'> M.İ" style="font-size:9px"  onClick="grupla(-3);" />
                                        <cfif get_w.SIRA eq 1>
                                        	<input type="button" value="<cf_get_lang_main no='3411.İlişkili Alt Emirler'> M.İ" style="font-size:9px"  onClick="grupla(-8);" />
                                        	<input type="button" value="<cf_get_lang_main no='3411.İlişkili Alt Planlar'> M.İ" style="font-size:9px"  onClick="metarial(-1);" alt="<cf_get_lang_main no='3330.Tüm İlişkili Alt Planlar'>" />

                                        </cfif>      
                                    </cfif>
                            	</td>
							</tr>
						</table>
					</td>
				</tr>
                </cfform>
			</table>
		</td>
	</tr>
    <tr>
    	<td><div id="groups_p"></div></td>
    </tr>
</table>
<script language="javascript">
	function grupla(type)
	{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
		p_order_id_list = '';
		chck_leng = document.getElementsByName('select_production').length;
		for(ci=0;ci<chck_leng;ci++)
		{
			var my_objets = document.all.select_production[ci];
			if(chck_leng == 1)
				var my_objets =document.all.select_production;
			if(type == -1){//hepsini seç denilmişse	
				if(my_objets.checked == true)
					my_objets.checked = false;
				else
					my_objets.checked = true;
			}
			else
			{
				if(my_objets.checked == true)
					p_order_id_list +=my_objets.value+',';
			}
		}
		p_order_id_list = p_order_id_list.substr(0,p_order_id_list.length-1);//sondaki virgülden kurtarıyoruz.
		if(list_len(p_order_id_list,','))
			if(type == -2)
				{
					var master_alt_plan_id=document.form_master_alt_plan.master_alt_plan_id.value;
					var master_plan_id=document.form_master_alt_plan.master_plan_id.value;
					var islem_id=document.form_master_alt_plan.islem_id.value;
					windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=281</cfoutput>&iid='+p_order_id_list+'&master_alt_plan_id='+master_alt_plan_id,'page');
				}
	
			else if(type == -3)
				{
					var master_alt_plan_id=document.form_master_alt_plan.master_alt_plan_id.value;
					var master_plan_id=document.form_master_alt_plan.master_plan_id.value;
					var islem_id=document.form_master_alt_plan.islem_id.value;
					windowopen('<cfoutput>#request.self#?fuseaction=prod.emptypopup_get_ezgi_sub_plan_metarial&type=1</cfoutput>&p_order_id_list='+p_order_id_list+'&islem_id='+islem_id+'&master_plan_id='+master_plan_id+'&master_alt_plan_id='+master_alt_plan_id,'longpage');
				}
				else if(type == -8)
				{
					var master_alt_plan_id=document.form_master_alt_plan.master_alt_plan_id.value;
					var master_plan_id=document.form_master_alt_plan.master_plan_id.value;
					var islem_id=document.form_master_alt_plan.islem_id.value;
					windowopen('<cfoutput>#request.self#?fuseaction=prod.emptypopup_get_ezgi_sub_plan_metarial&type=2</cfoutput>&p_order_id_list='+p_order_id_list+'&islem_id='+islem_id+'&master_plan_id='+master_plan_id+'&master_alt_plan_id='+master_alt_plan_id,'longpage');
				}
			else if(type == -4)
				{
					var master_alt_plan_id=document.form_master_alt_plan.master_alt_plan_id.value;
					var master_plan_id=document.form_master_alt_plan.master_plan_id.value;
					var islem_id=document.form_master_alt_plan.islem_id.value;
					window.location ='<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_upd_ezgi_p_order_operator&p_order_id_list='+p_order_id_list+'&islem_id='+islem_id+'&master_plan_id='+master_plan_id+'&master_alt_plan_id='+master_alt_plan_id;
				}
			else if(type == -5)
				{
					var master_alt_plan_id=document.form_master_alt_plan.master_alt_plan_id.value;
					var master_plan_id=document.form_master_alt_plan.master_plan_id.value;
					var islem_id=document.form_master_alt_plan.islem_id.value;
					chng_master_alt_plan=document.form_master_alt_plan.master_alt_plan.value;
					AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_upd_ezgi_p_order_send&p_order_list='+p_order_id_list+'&chng_master_alt_plan='+chng_master_alt_plan+'&master_alt_plan_id='+master_alt_plan_id+'','groups_p',1);
		
				}
			else if(type == -7)
				{
					var answer = confirm("<cf_get_lang_main no='3410.Seçtiğiniz Emirler Türüne Göre Birleştirilecek.'> <cf_get_lang_main no='1176.Emin misiniz ?'>")
					if (answer)
					{
					var master_alt_plan_id=document.form_master_alt_plan.master_alt_plan_id.value;
					var master_plan_id=document.form_master_alt_plan.master_plan_id.value;
					var islem_id=document.form_master_alt_plan.islem_id.value;
					window.location ='<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_upd_ezgi_p_order_group&p_order_id_list='+p_order_id_list+'&islem_id='+islem_id+'&master_plan_id='+master_plan_id+'&master_alt_plan_id='+master_alt_plan_id;
					}
				}
			else if(type == -10)
			{
				var answer1 = confirm("<cf_get_lang_main no='3409.Seçtiğiniz Emirler Silinecek.'> <cf_get_lang_main no='1176.Emin misiniz ?'>")
				if (answer1)
				{
					var master_alt_plan_id=document.form_master_alt_plan.master_alt_plan_id.value;
					var master_plan_id=document.form_master_alt_plan.master_plan_id.value;
					var islem_id=document.form_master_alt_plan.islem_id.value;
					window.location ='<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_del_ezgi_p_order_group&p_order_id_list='+p_order_id_list+'&islem_id='+islem_id+'&master_plan_id='+master_plan_id+'&master_alt_plan_id='+master_alt_plan_id;
				}
			}
	}
	function git(type)
	{
		if(type == -6)
		{
		chng_master_alt_plan=document.form_master_alt_plan.master_alt_plan.value;
		window.location ='<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_upd_ezgi_p_order_go&chng_master_alt_plan='+chng_master_alt_plan;
		}
	}
	function metarial(type)
	{
		if(type == -1)
		{
			var master_alt_plan_id=document.form_master_alt_plan.master_alt_plan_id.value;
			var master_plan_id=document.form_master_alt_plan.master_plan_id.value;
			var islem_id=document.form_master_alt_plan.islem_id.value;
			windowopen('<cfoutput>#request.self#?fuseaction=prod.emptypopup_get_ezgi_sub_plan_metarial&type=4</cfoutput>&islem_id='+islem_id+'&master_plan_id='+master_plan_id+'&master_alt_plan_id='+master_alt_plan_id,'longpage');
			
		}
	}
</script>