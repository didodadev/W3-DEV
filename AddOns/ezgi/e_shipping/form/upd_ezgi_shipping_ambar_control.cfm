﻿<cfsetting showdebugoutput="yes">
<cfset default_process_type = 113>
<cfquery name="get_default_departments" datasource="#dsn#">
	SELECT        
    	DEFAULT_RF_TO_SV_DEP, 
        DEFAULT_RF_TO_SV_LOC
	FROM            
    	EZGI_PDA_DEPARTMENT_DEFAULTS
	WHERE        
    	EPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfquery name="get_period_id" datasource="#dsn#">
    	SELECT        
        	PERIOD_YEAR
		FROM            
        	SETUP_PERIOD
		WHERE        
        	OUR_COMPANY_ID = #session.ep.company_id# AND 
            PERIOD_YEAR < #session.ep.period_year#
</cfquery>
<cfset last_year = session.ep.period_year -1>
<cfif not get_default_departments.recordcount>
	<cfset type = 0>
<cfelse>
	<cfset type = 1>
    <cfset default_departments = '#get_default_departments.DEFAULT_RF_TO_SV_DEP#'> 
    <cfparam name="attributes.department_in_id" default="#ListGetAt(get_default_departments.DEFAULT_RF_TO_SV_DEP,2)#-#ListGetAt(get_default_departments.DEFAULT_RF_TO_SV_LOC,2)#">
    <cfparam name="attributes.department_out_id" default="#ListGetAt(get_default_departments.DEFAULT_RF_TO_SV_DEP,1)#-#ListGetAt(get_default_departments.DEFAULT_RF_TO_SV_LOC,1)#">
    <cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
        SELECT 
            D.DEPARTMENT_HEAD,
            D.BRANCH_ID,
            SL.DEPARTMENT_ID,
            SL.LOCATION_ID,
            SL.STATUS,
            SL.COMMENT
        FROM 
            STOCKS_LOCATION SL,
            DEPARTMENT D,
            BRANCH B
        WHERE
            D.DEPARTMENT_ID IN (#default_departments#) AND
            SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
            SL.STATUS = 1 AND
            D.BRANCH_ID = B.BRANCH_ID
    </cfquery>
    <cfquery name="get_process_cat" datasource="#DSN3#">
        SELECT TOP (1)    
            SPC.PROCESS_CAT_ID
        FROM         
            SETUP_PROCESS_CAT AS SPC INNER JOIN
            SETUP_PROCESS_CAT_FUSENAME AS SPCF ON SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID INNER JOIN
            SETUP_PROCESS_CAT_ROWS AS SPCR ON SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID
        WHERE     
            SPC.PROCESS_TYPE = #default_process_type# AND 
            SPCF.FUSE_NAME = 'stock.form_add_fis' 
        ORDER BY
            SPC.PROCESS_CAT_ID DESC      
    </cfquery>
  	<cfif not get_process_cat.recordcount>
		<script type="text/javascript">
            alert("<cf_get_lang_main no='3136.İşlem Kategorisi Tanımlayınız!'>!");
            window.close();
        </script>
    </cfif>  
</cfif>
<cfif attributes.is_type eq 1>
    <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
        SELECT     
        	PAKET_SAYISI AS PAKETSAYISI, 
            PAKET_ID AS STOCK_ID, 
            BARCOD, 
            STOCK_CODE, 
            PRODUCT_NAME,
         	ISNULL((
            		SELECT 
                  		SUM(CONTROL_AMOUNT) CONTROL_AMOUNT
                   	FROM
                     	( 
                       	SELECT        
                          	SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                      	FROM            
                       		#dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                         	#dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                     	WHERE        
                         	SF.FIS_TYPE = 113 AND 
                          	SF.REF_NO = '#attributes.ref_no#' AND 
                     		SFR.STOCK_ID = TBL.PAKET_ID
                 		<cfif get_period_id.recordcount>
                       		UNION ALL
                          	SELECT        
                             	SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                           	FROM            
                           		#dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                              	#dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                           	WHERE        
                              	SF.FIS_TYPE = 113 AND 
                              	SF.REF_NO = '#attributes.ref_no#' AND 
                              	SFR.STOCK_ID = TBL.PAKET_ID
                    	</cfif>
                		) AS TBL_5
        	),0) AS CONTROL_AMOUNT,
            SHIP_RESULT_ID,
            DELIVER_PAPER_NO
		FROM         
        	(
            SELECT
            	SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID,
                DELIVER_PAPER_NO
           	FROM
            	(     
                SELECT     
                    round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),3) AS PAKET_SAYISI, 
                    EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    ESR.SHIP_RESULT_ID,
                    ESRR.ORDER_ROW_ID,
                    ESR.DELIVER_PAPER_NO
                FROM          
                    SPECTS AS SP INNER JOIN
                  	EZGI_SHIP_RESULT AS ESR INNER JOIN
                	EZGI_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                 	ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID ON SP.SPECT_VAR_ID = ORR.SPECT_VAR_ID INNER JOIN
                 	STOCKS AS S INNER JOIN
             		EZGI_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID ON SP.SPECT_MAIN_ID = EPS.MODUL_SPECT_ID INNER JOIN
                    STOCKS AS S1 ON ORR.STOCK_ID = S1.STOCK_ID
                WHERE      
                    ESR.SHIP_RESULT_ID = #attributes.ship_id# AND
                    ISNULL(S1.IS_PROTOTYPE,0) = 1
                GROUP BY 
                    EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    ESR.SHIP_RESULT_ID,
                    ESRR.ORDER_ROW_ID,
                    DELIVER_PAPER_NO
             	UNION ALL
                SELECT     
                    round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),3) AS PAKET_SAYISI, 
                    EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    ESR.SHIP_RESULT_ID,
                    ESRR.ORDER_ROW_ID,
                    ESR.DELIVER_PAPER_NO
                FROM          
                    EZGI_SHIP_RESULT AS ESR INNER JOIN
                    EZGI_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                    EZGI_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                    STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID INNER JOIN
                    STOCKS AS S1 ON ORR.STOCK_ID = S1.STOCK_ID
                WHERE      
                    ESR.SHIP_RESULT_ID = #attributes.ship_id# AND
                    ISNULL(S1.IS_PROTOTYPE,0) = 0
                GROUP BY 
                    EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    ESR.SHIP_RESULT_ID,
                    ESRR.ORDER_ROW_ID,
                    DELIVER_PAPER_NO
             	) AS TBL1
          	GROUP BY
            	PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID,
                DELIVER_PAPER_NO
        	) AS TBL
		ORDER BY
			PRODUCT_NAME
  	</cfquery>
<cfelse>
   	<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
        SELECT     
        	PAKET_SAYISI AS PAKETSAYISI, 
            PAKET_ID AS STOCK_ID, 
            BARCOD, 
            STOCK_CODE, 
            PRODUCT_NAME,
            ISNULL((
            		SELECT 
                  		SUM(CONTROL_AMOUNT) CONTROL_AMOUNT
                   	FROM
                     	( 
                       	SELECT        
                          	SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                      	FROM            
                       		#dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                         	#dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                     	WHERE        
                         	SF.FIS_TYPE = 113 AND 
                          	SF.REF_NO = '#attributes.ref_no#' AND 
                     		SFR.STOCK_ID = TBL.PAKET_ID
                 		<cfif get_period_id.recordcount>
                       		UNION ALL
                          	SELECT        
                             	SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                           	FROM            
                           		#dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                              	#dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                           	WHERE        
                              	SF.FIS_TYPE = 113 AND 
                              	SF.REF_NO = '#attributes.ref_no#' AND 
                              	SFR.STOCK_ID = TBL.PAKET_ID
                    	</cfif>
                		) AS TBL_5
          	),0) AS CONTROL_AMOUNT, 
            SHIP_RESULT_ID,
            SHIP_RESULT_ID AS DELIVER_PAPER_NO
		FROM         
        	(
            SELECT     
            	SUM(PAKET_SAYISI) AS PAKET_SAYISI, 
                PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID
       		FROM          
            	(
                SELECT     
                	round(SUM(SIR.AMOUNT * EPS.PAKET_SAYISI),3) AS PAKET_SAYISI, 
                 	EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    SIR.SHIP_ROW_ID, 
                    SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID
         		FROM          
                	STOCKS AS S INNER JOIN
                    EZGI_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID INNER JOIN
                    #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                    #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID
           		WHERE      
                	SI.DISPATCH_SHIP_ID = #attributes.ship_id#
             	GROUP BY 
                	EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    SIR.SHIP_ROW_ID, 
                    SI.DISPATCH_SHIP_ID
           		) AS TBL1
         	GROUP BY 
            	PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID
       		) AS TBL
      	ORDER BY
        	PRODUCT_NAME
    </cfquery>
</cfif> 
   
<cfform name="shipping_ambar" action="" method="post"> 
<cfif type eq 1>
    <cfinput type="hidden" name="ship_id" value="#attributes.ship_id#">
    <cfinput type="hidden" name="fis_type" value="#default_process_type#">
    <cfinput type="hidden" name="process_cat" value="#get_process_cat.PROCESS_CAT_ID#">
</cfif>
<table class="dph">
	<tr> 
		<td class="dpht"><cf_get_lang_main no='3573.Ambar Fişi Hazırlama Kontrol Listesi'></td>
        <td style="text-align:right">
        
        </td>
	</tr>
    <cfif type eq 1>
    <tr>
    	<td colspan="2">
        	<cf_get_lang_main no='1631.Çıkış Depo'> &nbsp;
            <select name="department_out_id" id="department_out_id" style="width:120px">
         	 	<cfoutput query="get_all_location" group="department_id">
            		<option disabled="disabled" value="#department_id#">#department_head#</option>
					<cfoutput>
                    <option value="#department_id#-#location_id#-#branch_id#-#comment#" <cfif department_id is #ListFirst(attributes.department_out_id,'-')# and location_id is #ListGetAt(attributes.department_out_id,2,'-')#>selected="selected"</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#</option>
                    </cfoutput> 
				</cfoutput>
        	</select>
            &nbsp;
            <cfoutput>#getLang('prod',193)#</cfoutput> &nbsp;
            <select name="department_in_id" id="department_in_id" style="width:120px">
         	 	<cfoutput query="get_all_location" group="department_id">
            		<option disabled="disabled" value="#department_id#">#department_head#</option>
					<cfoutput>
                    <option value="#department_id#-#location_id#-#branch_id#-#comment#" <cfif department_id is #ListFirst(attributes.department_in_id,'-')# and location_id is #ListGetAt(attributes.department_in_id,2,'-')#>selected="selected"</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#</option>
                    </cfoutput> 
				</cfoutput>
        	</select>
        </td>
    </tr>
    </cfif>
</table>   

<table id="kontrol_listesi" width="100%">
	<tr>
		<td>
        	<cf_medium_list>
                <thead>
                    <tr height="20px">
                        <th width="45px"><cf_get_lang_main no='221.Barkod'></th>
                        <th width="70px"><cf_get_lang_main no='1173.Kod'></th>
                        <th><cf_get_lang_main no='245.Ürün'></th>
                        <th width="50px"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="50px"><cf_get_lang_main no='1349.Sevk'></th>
                        <th width="50px"><cf_get_lang_main no='1032.Kalan'></th>
                        <th width="50px"><cfoutput>#getLang('stock',181)#</cfoutput></th>
                        <th width="20px" align="center"><cfoutput>#getLang('crm',1066)#</cfoutput></th>
                    </tr>
    			</thead>
                <tbody>
					<cfoutput query="GET_SHIP_PACKAGE_LIST">
                    	<cfinput type="hidden" name="stock_id_#currentrow#" value="#stock_id#">
                        <tr height="20">
                       		<td>#BARCOD#</td>
                          	<td>#STOCK_CODE#</td>
                         	<td>#product_name#</td>
                          	<td style="text-align:right"><strong>#Tlformat(PAKETSAYISI,3)#</strong></td>
                         	<td style="text-align:right"><strong>#Tlformat(control_amount,3)#</strong></td>
                            <cfset kalan_amount= PAKETSAYISI - control_amount>
                            <input type="hidden" name="kalan_amount" id="kalan_amount_#currentrow#" value="#Tlformat(kalan_amount,3)#"/>
                            <td style="text-align:right"><strong>#Tlformat(kalan_amount,3)#</strong></td>
                            <td style="text-align:right">
                            	<cfif type eq 1>
                             		<input name="control_amount" id="control_amount_#currentrow#" value="#Tlformat(0,3)#" style="text-align:right; width:50px" readonly="readonly" class="box"/>
                                <cfelse>
                                	<strong>#Tlformat(0,3)#</strong>
                                </cfif>
                          	</td>
                         	<td style="text-align:center">
                            	<cfif control_amount eq 0>
                                	<cfif type eq 1>
                                        <a href="javascript://" class="tableyazi" onclick="gonder(#currentrow#);">
                                            <img src="images\closethin.gif" title="<cf_get_lang_main no='3574.Ambar Fişi Yapılmadı'>">
                                        </a>
                                    <cfelse>
                                    	<img src="images\closethin.gif" title="<cf_get_lang_main no='3574.Ambar Fişi Yapılmadı'>">
                                    </cfif>
                             	<cfelseif paketsayisi eq control_amount>
                                	<img src="images\c_ok.gif" title="<cf_get_lang_main no='3575.Hepsi Ambar Fişi Yapıldı'>">
                              	<cfelseif paketsayisi gt control_amount>
                                	<cfif type eq 1>
                                        <a href="javascript://" class="tableyazi" onclick="gonder(#currentrow#);">
                                            <img src="images\warning.gif" title="<cf_get_lang_main no='3576.Eksik Ambar Fişi Yapıldı'>">
                                        </a>
                                    <cfelse>
                                    	<img src="images\warning.gif" title="<cf_get_lang_main no='3576.Eksik Ambar Fişi Yapıldı'>">
                                    </cfif>
                              	</cfif>
                          	</td>
                        </tr>
                    </cfoutput>
            	</tbody>
                <tfoot>
                    <tr class="color-list">
                        <td colspan="8" style="text-align:right">
                        	<cfif type eq 1>
                            	<input type="button" value="<cf_get_lang_main no='141.Kapat'>" onClick="kontrol(0);">&nbsp;
                        		<input type="button" value="<cfoutput>#getLang('prod',585)#</cfoutput>" name="ambar_fisi" id="ambar_fisi" onClick="kontrol(1);" style="width:140px;">
                            <cfelse>
                            	<input type="button" value="<cf_get_lang_main no='141.Kapat'>" onClick="kontrol(0);">
                            </cfif>
                        </td>
                    </tr>
             	</tfoot>
         	</cf_medium_list>
      	</td>
  	</tr>
</table>
</cfform>
<form name="aktar_form" method="post">
    <input type="hidden" name="list_price" id="list_price" value="0">
    <input type="hidden" name="price_cat" id="price_cat" value="">
    <input type="hidden" name="CATALOG_ID" id="CATALOG_ID" value="">
    <input type="hidden" name="NUMBER_OF_INSTALLMENT" id="NUMBER_OF_INSTALLMENT" value="">
    <input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
	<input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
	<input type="hidden" name="convert_price" id="convert_price" value="">
	<input type="hidden" name="convert_price_other" id="convert_price_other" value="">
	<input type="hidden" name="convert_money" id="convert_money" value="">
    <input type="hidden" name="location_out" id="location_out" value="" />
    <input type="hidden" name="department_out" id="department_out" value="" />
    <input type="hidden" name="txt_departman_out" id="txt_departman_out" value="" />
    <input type="hidden" name="location_in" id="location_in" value="" />
    <input type="hidden" name="department_in" id="department_in" value="" />
    <input type="hidden" name="txt_department_in" id="txt_department_in" value="" />
    <input type="hidden" name="ref_no" id="ref_no" value="<cfoutput>#attributes.ref_no#</cfoutput>" />
</form>
<script language="javascript">
	function gonder(rowi)
	{
		<cfoutput query="GET_SHIP_PACKAGE_LIST">
			rowa = #currentrow#;
			if(rowi == rowa)
			{
				document.getElementById("control_amount_"+rowi).value = document.getElementById("kalan_amount_"+rowi).value;
			}
		</cfoutput>
	}
	function kontrol(type)
	{
		if(type==0)
		window.close();
		if(type==1)
		{
			department_out_id = document.getElementById('department_out_id').value;
			department_in_id = document.getElementById('department_in_id').value;
			var convert_list ="";
			var convert_list_amount ="";
			var convert_list_price ="";
			var convert_list_price_other="";
			var convert_list_money ="";	
			<cfoutput query="GET_SHIP_PACKAGE_LIST">
				if(filterNum(document.getElementById('control_amount_#currentrow#').value) > 0)
				{
					money = '#session.ep.money#';
					stock_id = #stock_id#;
					convert_list += stock_id+',';
					convert_list_amount += filterNum(document.getElementById('control_amount_#currentrow#').value)+',';
					convert_list_price_other += '0,';
					convert_list_price += '0,';
					convert_list_money += money+',';
				}
			</cfoutput>
			document.getElementById('convert_stocks_id').value=convert_list;
			document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
			document.getElementById('convert_price').value=convert_list_price;
			document.getElementById('convert_price_other').value=convert_list_price_other;
			document.getElementById('convert_money').value=convert_list_money;
			document.getElementById('department_out').value = list_getat(department_out_id,1,'-');
			document.getElementById('location_out').value = list_getat(department_out_id,2,'-');
			document.getElementById('txt_departman_out').value = list_getat(department_out_id,4,'-');
			document.getElementById('department_in').value = list_getat(department_in_id,1,'-');
			document.getElementById('location_in').value = list_getat(department_in_id,2,'-');
			document.getElementById('txt_department_in').value = list_getat(department_in_id,4,'-');
			if(convert_list)//Ürün Seçili ise
			{
				 windowopen('','longpage','cc_paym');
				 if(type==1)
				 {
					 aktar_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.form_add_fis&type=convert";
					 document.getElementById('ambar_fisi').disabled=true;
				 }
				 aktar_form.target='cc_paym';
				 aktar_form.submit();
			 }
			 else
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='245.Ürün'>.");
		}
	}
</script>