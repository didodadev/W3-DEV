<cf_get_lang_set module_name="prod">
<cfsetting showdebugoutput="yes">
<cfset attributes.shift_id = 1> <!---Firmaya Göre Değişir--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.deliverdate" default=0>
<cfparam name="attributes.operasyon" default="">
<cfparam name="attributes.durum" default="">
<cfparam name="attributes.master_plan_id" default="">
<cfparam name="attributes.sub_plan_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.is_form_submitted" default="">
<cfparam name="attributes._miktar" default="1">
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
  <cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_master_plans" datasource="#dsn3#">
	SELECT     
    	MASTER_PLAN_ID, 
        MASTER_PLAN_START_DATE, 
        MASTER_PLAN_FINISH_DATE, 
        MASTER_PLAN_NAME, 
        MASTER_PLAN_NUMBER, 
        MASTER_PLAN_DETAIL
	FROM         
    	EZGI_MASTER_PLAN
	WHERE     
    	MASTER_PLAN_PROCESS = 1 AND 
        IS_PROCESS = 1 AND 
        MASTER_PLAN_STATUS = 1 AND 
        MASTER_PLAN_CAT_ID = #attributes.shift_id#
</cfquery>

<cfquery name="get_sub_plans" datasource="#dsn3#">
	SELECT     
    	EMAP.MASTER_ALT_PLAN_ID, 
        EMAP.MASTER_ALT_PLAN_NO, 
        EMAP.PLAN_START_DATE, 
        EMAP.PLAN_FINISH_DATE, 
        EMAP.PLAN_DETAIL
	FROM         
    	EZGI_MASTER_PLAN AS EMP INNER JOIN
      	EZGI_MASTER_ALT_PLAN AS EMAP ON EMP.MASTER_PLAN_ID = EMAP.MASTER_PLAN_ID INNER JOIN
      	EZGI_MASTER_PLAN_SABLON AS EMPS ON EMAP.PROCESS_ID = EMPS.PROCESS_ID
	WHERE    
    	EMP.MASTER_PLAN_PROCESS = 1 AND 
        EMP.IS_PROCESS = 1 AND 
        EMP.MASTER_PLAN_STATUS = 1 AND 
        EMP.MASTER_PLAN_CAT_ID = #attributes.shift_id# AND 
        EMP.MASTER_PLAN_ID = #attributes.master_plan_id# AND 
       	EMPS.SIRA = 1
</cfquery>
<cfquery name="get_sub_plan_stations" datasource="#dsn3#">
	SELECT     
    	MENU_HEAD, 
        PROCESS_ID
	FROM         
    	EZGI_MASTER_PLAN_SABLON AS EMPS
	WHERE     
    	SHIFT_ID = #attributes.shift_id# AND 
        SIRA > 0
	ORDER BY 
    	SIRA
</cfquery>
<cfquery name="get_stocks" datasource="#dsn3#">
	SELECT     
    	PO.STOCK_ID, 
        S.PRODUCT_NAME
	FROM         
    	EZGI_MASTER_ALT_PLAN AS EMAP INNER JOIN
      	EZGI_MASTER_PLAN AS EMP ON EMAP.MASTER_PLAN_ID = EMP.MASTER_PLAN_ID INNER JOIN
      	EZGI_MASTER_PLAN_RELATIONS AS EMPR ON EMAP.MASTER_ALT_PLAN_ID = EMPR.MASTER_ALT_PLAN_ID INNER JOIN
     	PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
     	EZGI_MASTER_PLAN_SABLON AS EMPS ON EMPR.PROCESS_ID = EMPS.PROCESS_ID INNER JOIN
      	STOCKS AS S ON PO.STOCK_ID = S.STOCK_ID
	WHERE     
    	EMP.MASTER_PLAN_CAT_ID = #attributes.shift_id# AND 
        EMP.MASTER_PLAN_STATUS = 1 AND 
        EMP.MASTER_PLAN_PROCESS = 1 AND 
        EMAP.MASTER_ALT_PLAN_ID IN (#get_sub_plans.MASTER_ALT_PLAN_ID#) AND
        <cfif len(attributes.sub_plan_id)>
        	EMAP.MASTER_ALT_PLAN_ID = #attributes.sub_plan_id# AND
        </cfif>
        EMPS.SIRA = 1
  	ORDER BY
    	S.PRODUCT_NAME
</cfquery>
<cfif len(attributes.is_form_submitted)>
	<cfif len(attributes.stock_id)>
    	<cfset iid = attributes.STOCK_ID>
        <cfinclude template="/add_options/e_furniture/query/get_ezgi_recete_2.cfm">
        <cfquery name="get_recete_1" dbtype="query">
            SELECT 		STOCK_ID
            FROM 		GET_RECETE
            WHERE		STOCK_CODE LIKE '01.151%' or STOCK_CODE LIKE '01.152%'
            GROUP BY 	STOCK_ID,PRODUCT_ID,PRODUCT_NAME,STOCK_CODE 
            ORDER BY	STOCK_CODE
        </cfquery>
        <cfset recete_stock_id_list = Valuelist(get_recete_1.STOCK_ID)>
    </cfif>
  	<cfquery name="get_operations_" datasource="#dsn3#">
 		SELECT     
        	EMPSG.TYPE, 
            EMPSG.M, 
            EMPSG.W, 
            EMPSG.P, 
            EOS.P_ORDER_ID, 
            EOS.PO_RELATED_ID, 
            EOS.LOT_NO, 
            EOS.P_ORDER_NO, 
            EOS.PRODUCTION_LEVEL, 
           	EOS.IS_STAGE, 
            EOS.START_DATE, 
            EOS.STOCK_CODE, 
            EOS.SPEC_MAIN_ID, 
            EOS.STOCK_ID, 
            EOS.PRODUCT_ID, 
            EOS.PRODUCT_NAME, 
            EOS.SPECT_VAR_NAME, 
        	EOS.QUANTITY, 
            EOS.P_OPERATION_ID, 
            EOS.OPERATION_TYPE_ID, 
            EOS.OPERATION_CODE, 
            EOS.OPERATION_TYPE, 
            EOS.AMOUNT, 
            EOS.STAGE, 
            EOS.STATION_ID, 
         	EOS.REAL_TIME, 
            EOS.WAIT_TIME, 
            EOS.ACTION_EMPLOYEE_ID, 
            EOS.ACTION_START_DATE, 
            EOS.REAL_AMOUNT, 
            EOS.LOSS_AMOUNT, 
            EOS.STATION_NAME, 
       		EOS.O_START_DATE, 
            EOS.MASTER_ALT_PLAN_ID, 
            EMPR.STATION_ID AS MAIN_STATION_ID, 
            EMAP.RELATED_MASTER_ALT_PLAN_ID
		FROM         
        	EZGI_MASTER_PLAN_SABLON_GRP AS EMPSG INNER JOIN
           	EZGI_MASTER_ALT_PLAN AS EMAP ON EMPSG.P = EMAP.PROCESS_ID INNER JOIN
          	EZGI_MASTER_PLAN_RELATIONS AS EMPR ON EMAP.MASTER_ALT_PLAN_ID = EMPR.MASTER_ALT_PLAN_ID INNER JOIN
           	EZGI_OPERATION_S AS EOS ON EMPR.P_ORDER_ID = EOS.P_ORDER_ID
		WHERE 
        	1=1
            <cfif len(attributes.master_plan_id)>  
        		AND EMAP.MASTER_PLAN_ID = #attributes.master_plan_id# 
           	</cfif>
            <cfif len(attributes.sub_plan_id)> 
            	AND (EMAP.RELATED_MASTER_ALT_PLAN_ID = #attributes.sub_plan_id# OR EMAP.MASTER_ALT_PLAN_ID = #attributes.sub_plan_id#)
           	</cfif>
            <cfif len(attributes.stock_id) and len(recete_stock_id_list)>
				AND EOS.STOCK_ID IN (#recete_stock_id_list#)
           	</cfif>
		ORDER BY 
        	EMPSG.TYPE desc
	</cfquery>
    <cfquery name="get_operation" dbtype="query">
    	SELECT     
        	TYPE, 
            M, 
            W, 
            P, 
            P_ORDER_ID, 
            LOT_NO, 
            P_ORDER_NO, 
            IS_STAGE, 
            START_DATE, 
            STOCK_CODE, 
            SPEC_MAIN_ID, 
            STOCK_ID, 
       		PRODUCT_ID, 
            PRODUCT_NAME, 
            SPECT_VAR_NAME, 
            QUANTITY, 
            MASTER_ALT_PLAN_ID, 
            MAIN_STATION_ID
		FROM  
        	get_operations_   
		GROUP BY 
        	TYPE, 
            M, 
            W, 
            P, 
            P_ORDER_ID, 
            PO_RELATED_ID, 
            LOT_NO, 
            P_ORDER_NO, 
            PRODUCTION_LEVEL, 
            IS_STAGE, START_DATE, 
            STOCK_CODE, 
            SPEC_MAIN_ID, 
        	STOCK_ID, 
            PRODUCT_ID, 
            PRODUCT_NAME, 
            SPECT_VAR_NAME, 
            QUANTITY, 
            MASTER_ALT_PLAN_ID, 
            MAIN_STATION_ID, 
            RELATED_MASTER_ALT_PLAN_ID
       	ORDER BY
        	TYPE
    </cfquery>

    <cfquery name="get_master_plan_info" datasource="#dsn3#">
    	SELECT     
        	EMAP.MASTER_ALT_PLAN_NO,
            EMAP.MASTER_ALT_PLAN_ID, 
            EMP.MASTER_PLAN_NUMBER
		FROM         
        	EZGI_MASTER_ALT_PLAN AS EMAP INNER JOIN
   			EZGI_MASTER_PLAN AS EMP ON EMAP.MASTER_PLAN_ID = EMP.MASTER_PLAN_ID
        <cfif len(attributes.master_plan_id)> 
            WHERE     
                EMAP.MASTER_PLAN_ID = #attributes.master_plan_id#
       	</cfif>
    </cfquery>
    
    <cfoutput query="get_master_plan_info">
    	<cfset 'MASTER_ALT_PLAN_NO_#MASTER_ALT_PLAN_ID#' = MASTER_ALT_PLAN_NO>
        <cfset 'MASTER_PLAN_NUMBER_#MASTER_ALT_PLAN_ID#' = MASTER_PLAN_NUMBER>
    </cfoutput>
    <cfquery name="get_station_grp" dbtype="query">
    	SELECT MAIN_STATION_ID FROM get_operation GROUP BY MAIN_STATION_ID
    </cfquery>
    <cfset main_station_id_list = Valuelist(get_station_grp.MAIN_STATION_ID)>
    <cfif len(main_station_id_list)>
        <cfquery name="get_station_name" datasource="#dsn3#">
            SELECT STATION_ID,STATION_NAME FROM WORKSTATIONS WHERE STATION_ID IN (#main_station_id_list#)
        </cfquery>
        <cfoutput query="get_station_name">
        	<cfset 'STATION_NAME_#STATION_ID#' = STATION_NAME>
        </cfoutput>
    </cfif>
	<cfset arama_yapilmali=0>
<cfelse>
	<cfset arama_yapilmali=1>
</cfif>
<cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
    <input name="type" type="hidden" value="3">
    <cf_big_list_search title="<cf_get_lang_main no='3211.İşlemdeki Operasyonlar'>" collapsed="1">
        <cf_big_list_search_area>
            <table>
                <tr>
                	<td></td>
                    <td align="right" width="60"><cf_get_lang_main no='2838.Master Plan'></td>
                    <td width="260">
                    	<select name="master_plan_id" id="master_plan_id" style=" width:200px" onChange="set_master_plan(this.value)";>
                        	<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                            <cfoutput query="get_master_plans">
                            	<option value="#MASTER_PLAN_ID#" <cfif attributes.master_plan_id eq #MASTER_PLAN_ID#>selected</cfif>>#MASTER_PLAN_NUMBER#-#MASTER_PLAN_DETAIL#-#Dateformat(MASTER_PLAN_START_DATE,'DD/MM/YYYY')#-#Dateformat(MASTER_PLAN_FINISH_DATE,'DD/MM/YYYY')#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td align="right" width="45"><cf_get_lang_main no='3212.Alt Plan'></td>
                    <td width="260">
                        <select name="sub_plan_id" id="sub_plan_id" style=" width:200px" onChange="set_master_sub_plan(this.value)">
                        	<option value="" <cfif attributes.sub_plan_id eq ''>selected</cfif>><cf_get_lang_main no ='322.Seçiniz'></option>
                            <cfoutput query="get_sub_plans">
                            	<option value="#MASTER_ALT_PLAN_ID#" <cfif attributes.sub_plan_id eq #MASTER_ALT_PLAN_ID#>selected</cfif>>#MASTER_ALT_PLAN_NO#-#PLAN_DETAIL#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td align="right" width="35"><cf_get_lang_main no='245.Ürün'></td>
                    <td width="160">
                    	<select name="stock_id" id="stock_id" style=" width:150px">
                        	<option value="" <cfif attributes.stock_id eq ''>selected</cfif>><cf_get_lang_main no ='322.Seçiniz'></option>
                            <cfoutput query="get_stocks">
                            	<option value="#STOCK_ID#" <cfif attributes.stock_id eq #STOCK_ID#>selected</cfif>>#PRODUCT_NAME#</option>
                            </cfoutput>
                            
                        </select>
                    </td>
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
                <th width="35"><cf_get_lang_main no='1165.Sıra'></th>
                <th width="70"><cf_get_lang_main no='2838.Master Plan'> <cf_get_lang_main no='75.No'></th>
                <th width="70"><cf_get_lang_main no='3212.Alt Plan'> <cf_get_lang_main no='75.No'></th>
                <th width="70"><cf_get_lang_main no='1677.Emir No'></th>
                <th width="70"><cf_get_lang no='385.Lot_No'></th>
                <th width="70"><cfoutput>#getLang('prod',566)#</cfoutput></th>
                <th><cf_get_lang_main no='245.Ürün'></th>
                <th width="70"><cf_get_lang_main no='235.spec'></th>
                <th width="40"><cf_get_lang_main no='2995.Emir Miktarı'></th>
                <th width="75"><cf_get_lang_main no='1422.İstasyon'></th>
                <th width="40"><cf_get_lang no='142.Katsayı'></th>
                <th width="280"><cf_get_lang no='63.Operasyonlar'></th>
                <th width="20"></th>
            </tr>
        </thead>
        <tbody>
            <cfif len(attributes.is_form_submitted)>
            	<cfset type_ = ''>
            	<cfoutput query="get_operation">
                	<cfif type_ neq TYPE>
                    	<tr> 
                        	<td style="height:5px" colspan="13"></td>
                      	</tr>
                    	<cfset type_ = TYPE>
                  	</cfif>
                    <tr> 
                        <td style="text-align:right; height:10px">#currentrow#</td>
                        <td style="text-align:center;" nowrap="nowrap">#Evaluate('MASTER_PLAN_NUMBER_#MASTER_ALT_PLAN_ID#')#</td>
                        <td style="text-align:center;" nowrap="nowrap">#Evaluate('MASTER_ALT_PLAN_NO_#MASTER_ALT_PLAN_ID#')#</td>
                        <td style="text-align:center;" nowrap="nowrap">#P_ORDER_NO#</td>
                        <td style="text-align:center;" nowrap="nowrap">#lot_no#</td>
                        <td style="text-align:center;" nowrap="nowrap">#DateFormat(Start_Date,'DD/MM/YYYY')#</td>
                        <td>
                            <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.add_product_tree&stock_id=#stock_id#','longpage');" class="tableyazi">
                            	#product_name#
                            </a>
                        </td>
                        <td style="text-align:center;">#SPEC_MAIN_ID#</td>
                        
                        <td style="text-align:right;">#amountformat(quantity)#</td>
                        <td style="text-align:center;">#Evaluate('STATION_NAME_#MAIN_STATION_ID#')#</td>
                        <td style="text-align:center;"></td>
                        <td style="text-align:left;">
                        	<cfquery name="get_operation_1" dbtype="query">
                                SELECT 
                                	P_ORDER_ID,    
                                    P_OPERATION_ID, 
                                    OPERATION_TYPE_ID, 
                                    OPERATION_CODE, 
                                    OPERATION_TYPE, 
                                    AMOUNT, 
                                    STAGE, 
                                    sum(REAL_AMOUNT) REAL_AMOUNT
                                FROM  
                                    get_operations_       
                                WHERE     
                                    P_ORDER_ID = #P_ORDER_ID#
                               	GROUP BY
                                	P_ORDER_ID,    
                                    P_OPERATION_ID, 
                                    OPERATION_TYPE_ID, 
                                    OPERATION_CODE, 
                                    OPERATION_TYPE, 
                                    AMOUNT, 
                                    STAGE
                            </cfquery> 
                            <cfif get_operation_1.recordcount>
                            	<table>
                        			<tr>
                                    	<cfloop query="get_operation_1">
                                    		<td title="#OPERATION_TYPE#"
                                            	<cfif STAGE eq 0 >
                                               		style="background-color:orange;height:10px;font-weight:bold"
                                              	<cfelseif STAGE eq 1>
                                               		style="background-color:green;height:10px;font-weight:bold"
                                              	<cfelseif STAGE eq 3>
                                                  	style="background-color:red;height:10px;font-weight:bold"
                                              	<cfelse>
                                                  	style="background-color:white;height:10px"
                                               	</cfif>
                                                > 
                                                <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.form_upd_prod_order&upd=#P_ORDER_ID#','longpage');" >
													<cfif len(OPERATION_code)>#OPERATION_CODE#</cfif>
                                                    <cfif len(REAL_AMOUNT)>#REAL_AMOUNT#<cfelse>0</cfif>/<cfif len(AMOUNT)>#AMOUNT#<cfelse>0</cfif>
                                                </a>
                                          	</td>
                                        </cfloop>
                                    </tr>
                        		</table>
                        	</cfif>
                        </td>
                        
                        <td><input type="checkbox" name="select_production" value="#P_ORDER_ID#"></td>
                    </tr>
                </cfoutput>
                <tfoot>
                    <tr>
                        <td height="20" style="text-align:right"><cf_get_lang_main no='80.Toplam'></td>
                        <td style="text-align:right"><cfoutput></cfoutput></td>
                        <td colspan="11"></td>
                    </tr>
                </tfoot>
            <cfelse>
                <tr> 
                    <td colspan="13" height="20"><cfif arama_yapilmali eq 0><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_big_list>
</cfform>
<script language="javascript">
	<cfoutput>
		var shift_id_ = #attributes.shift_id#
	</cfoutput>
	function grupla(type)
	{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
		p_order_id_list = '';
		chck_leng = document.getElementsByName('select_production').length;
		for(ci=0;ci<chck_leng;ci++)
		{
			var my_objets = document.all.select_production[ci];
			if(chck_leng == 1)
				var my_objets =document.all.select_production;
			if(type == -1)
			{//hepsini seç denilmişse	
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
			if(type == -5)
			{
				chng_master_alt_plan=document.search_product.master_alt_plan.value;
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_upd_ezgi_p_order_send&torba=1&p_order_list='+p_order_id_list+'&chng_master_alt_plan='+chng_master_alt_plan+'','groups_p',1);
			}
	}
	function set_master_plan(xyz)
	{
		var master_plan_id_ = xyz;
		var master_plan_names = wrk_query("SELECT EMAP.MASTER_ALT_PLAN_ID, EMAP.MASTER_ALT_PLAN_NO, EMAP.PLAN_START_DATE, EMAP.PLAN_FINISH_DATE, EMAP.PLAN_DETAIL FROM EZGI_MASTER_PLAN AS EMP INNER JOIN EZGI_MASTER_ALT_PLAN AS EMAP ON EMP.MASTER_PLAN_ID = EMAP.MASTER_PLAN_ID INNER JOIN EZGI_MASTER_PLAN_SABLON AS EMPS ON EMAP.PROCESS_ID = EMPS.PROCESS_ID WHERE EMP.MASTER_PLAN_PROCESS = 1 AND EMP.IS_PROCESS = 1 AND EMP.MASTER_PLAN_STATUS = 1 AND EMP.MASTER_PLAN_CAT_ID = "+ shift_id_  +" AND EMPS.SIRA = 1 AND EMP.MASTER_PLAN_ID ="+ master_plan_id_ +"ORDER BY EMAP.PLAN_START_DATE","dsn3");
		
		var option_count = document.getElementById('sub_plan_id').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('sub_plan_id').options[x] = null;
		if(master_plan_names.recordcount != 0)
		{	
			document.getElementById('sub_plan_id').options[0] = new Option('Seçiniz','');
			for(var xx=0;xx<master_plan_names.recordcount;xx++)
				document.getElementById('sub_plan_id').options[xx+1]=new Option(master_plan_names.MASTER_ALT_PLAN_NO[xx]+"-"+master_plan_names.PLAN_DETAIL[xx],master_plan_names.MASTER_ALT_PLAN_ID[xx],master_plan_names.MASTER_ALT_PLAN_NO[xx]);
		}
		else
			document.getElementById('sub_plan_id').options[0] = new Option('Seçiniz','');
	}
	function set_master_sub_plan(abc)
	{
		var master_sub_plan_id_ = abc;
		var product_names = 
		wrk_query("SELECT PO.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME FROM EZGI_MASTER_ALT_PLAN AS EMAP INNER JOIN EZGI_MASTER_PLAN AS EMP ON EMAP.MASTER_PLAN_ID = EMP.MASTER_PLAN_ID INNER JOIN EZGI_MASTER_PLAN_RELATIONS AS EMPR ON EMAP.MASTER_ALT_PLAN_ID = EMPR.MASTER_ALT_PLAN_ID INNER JOIN PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN EZGI_MASTER_PLAN_SABLON AS EMPS ON EMPR.PROCESS_ID = EMPS.PROCESS_ID INNER JOIN STOCKS AS S ON PO.STOCK_ID = S.STOCK_ID WHERE EMP.MASTER_PLAN_CAT_ID = "+shift_id_+" AND EMP.MASTER_PLAN_STATUS = 1 AND EMP.MASTER_PLAN_PROCESS = 1 AND EMAP.MASTER_ALT_PLAN_ID = "+master_sub_plan_id_+" AND EMPS.SIRA = 1 ORDER BY S.PRODUCT_NAME","dsn3");
		var option_count = document.getElementById('stock_id').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('stock_id').options[x] = null;
		if(product_names.recordcount != 0)
		{	
			document.getElementById('stock_id').options[0] = new Option('Seçiniz','');
			for(var xx=0;xx<product_names.recordcount;xx++)
				document.getElementById('stock_id').options[xx+1]=new Option(product_names.PRODUCT_NAME[xx],product_names.STOCK_ID[xx],product_names.STOCK_CODE[xx]);
		}
		else
			document.getElementById('stock_id').options[0] = new Option('Seçiniz','');
	}
</script>

