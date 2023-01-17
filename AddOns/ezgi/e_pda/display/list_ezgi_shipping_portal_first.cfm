 <cfsetting showdebugoutput="yes">
<cfquery name="get_default_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID, LOCATION_ID FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = #session.ep.POSITION_CODE# AND OUR_COMPANY_ID = #session.ep.COMPANY_ID#
</cfquery>
<cfif get_default_department.recordcount>
	<cfparam name="attributes.sales_departments" default="#get_default_department.DEPARTMENT_ID#-#get_default_department.LOCATION_ID#">
<cfelse>
	<cfparam name="attributes.sales_departments" default="">
    <script type="text/javascript">
     	alert("<cf_get_lang_main no='3129.Kullanıcı İçin Default Depo Tanımlayınız'>!");
     	history.go(-1);
  	</script>
 	<cfabort>
</cfif>

<cfquery name="get_stocks" datasource="#dsn2#"><!---Mal Kabul Deposuna gelen irsaliye ürünleri Listeleniyor--->
	SELECT
    	*
  	FROM
    	(
        SELECT  
            1 AS TYPE,
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
            END AS UNVAN,  
            ISNULL((
                SELECT        
                    SUM(SFR.AMOUNT) AS TESLIM
                FROM            
                    STOCK_FIS AS SF INNER JOIN
                    STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                WHERE        
                    SF.REF_NO = E.DELIVER_PAPER_NO
            ),0) AS TESLIM,  
            S.SHIP_ID, 
            S.SHIP_NUMBER, 
            S.SHIP_TYPE, 
            S.SHIP_DATE, 
            S.RECORD_DATE,
            SR.AMOUNT, 
            SR.UNIT, 
            SR.STOCK_ID, 
            SR.NAME_PRODUCT, 
            SR.ROW_ORDER_ID, 
            ORR1.QUANTITY, 
            ORR1.ORDER_ROW_ID,
            O.ORDER_NUMBER, 
            O.COMPANY_ID, 
            O.EMPLOYEE_ID, 
            O.CONSUMER_ID, 
            S.COMPANY_ID AS SHIP_COMPANY_ID,
            E.DELIVER_PAPER_NO, 
            (SELECT PRODUCT_CODE_2 FROM #dsn3_alias#.STOCKS WHERE STOCK_ID = SR.STOCK_ID) AS PRODUCT_CODE_2,
            ISNULL((SELECT REAL_STOCK FROM GET_STOCK_LAST_LOCATION WHERE DEPARTMENT_ID = 6 AND LOCATION_ID = 0 AND STOCK_ID = SR.STOCK_ID),0) AS REAL_STOCK
        FROM    
            #dsn3_alias#.EZGI_SHIP_RESULT AS E INNER JOIN
            #dsn3_alias#.EZGI_SHIP_RESULT_ROW AS ESR ON E.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID INNER JOIN
            SHIP AS S INNER JOIN
            SHIP_ROW AS SR ON S.SHIP_ID = SR.SHIP_ID INNER JOIN
            #dsn3_alias#.ORDER_ROW AS ORR ON SR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID INNER JOIN
            #dsn3_alias#.ORDER_ROW AS ORR1 ON ORR.WRK_ROW_RELATION_ID = ORR1.WRK_ROW_ID INNER JOIN
            #dsn3_alias#.ORDERS AS O ON ORR1.ORDER_ID = O.ORDER_ID ON ESR.ORDER_ROW_ID = ORR1.ORDER_ROW_ID
        WHERE        
            S.PURCHASE_SALES = 0 AND 
            <!---S.SHIP_DATE <= #DateAdd('d',1,now())# AND --->
            S.LOCATION_IN = 0 AND 
            S.DEPARTMENT_IN = 6
		) AS TBL	
  	WHERE
    	REAL_STOCK > 0
  	ORDER BY
     	RECORD_DATE   	
        <!---S.LOCATION = #get_default_department.LOCATION_ID# AND 
        S.DELIVER_STORE_ID = #get_default_department.DEPARTMENT_ID#--->
</cfquery>
<cfform name="form_portal" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
  		<tr class="color-border">
        	<td>
            	<table cellspacing="1" cellpadding="2" width="100%" border="0">
                    <tr class="color-header" style="height:35px">
                        <td class="form-title" style="width:30px;text-align:center"><cf_get_lang_main no='1165.Sira'></td>
                        <td class="form-title" style="width:80px;text-align:center"><cf_get_lang_main no='799.Sipariş No'></td>
                        <td class="form-title" style="width:80px;text-align:center"><cf_get_lang_main no='726.İrsaliye No'></td>
                        <td class="form-title" style="width:60px;text-align:center"><cf_get_lang_main no='330.Tarih'></td>
                        <td class="form-title" style="width:160px;text-align:center"><cf_get_lang_main no='1736.Tedarikçi'></td>
                        <td class="form-title" style="width:160px;text-align:center"><cf_get_lang_main no='45.Müşteri'></td>
                        <td class="form-title" style="width:115px;text-align:center"><cf_get_lang_main no='106.Stok Kodu'></td>
                        <td class="form-title" style="text-align:center"><cf_get_lang_main no='809.Ürün Adı'></td>
                        <td class="form-title" style="width:90px;text-align:center"><cf_get_lang_main no='199.Sipariş'></td>
                        <td class="form-title" style="width:90px;text-align:center"><cf_get_lang_main no='361.İrsaliye'></td>
                        <td class="form-title" style="width:90px;text-align:center"><cf_get_lang_main no='1349.Sevk'></td>
                        <td class="form-title" style="width:90px;text-align:center"><cf_get_lang_main no='1351.Depo'></td>
                        <td class="form-title" style="width:60px;text-align:center"><cf_get_lang_main no='224.Birim'></td>
                	</tr>
        			<cfif get_stocks.recordcount>
                        <cfoutput query="get_stocks">
                            <cfif isdefined('IRSALIYE_#ORDER_ROW_ID#')>
                            	<cfset 'IRSALIYE_#ORDER_ROW_ID#' = Evaluate('IRSALIYE_#ORDER_ROW_ID#') + AMOUNT>
                            <cfelse>
                            	<cfset 'IRSALIYE_#ORDER_ROW_ID#' = AMOUNT>
                            </cfif>
                            <cfif Evaluate('IRSALIYE_#ORDER_ROW_ID#') gt TESLIM>
                       		<tr style="height:30px" class="color-row">
                           		<td style="text-align:right">#currentrow#</td>
                                <td style="text-align:center">#ORDER_NUMBER#<br />#DELIVER_PAPER_NO#</td>
                              	<td style="text-align:left">#SHIP_NUMBER#</td>
                            	<td style="text-align:center">#DateFormat(SHIP_DATE,'DD/MM/YYYY')#</td>
                            	<td style="text-align:LEFT">#get_par_info(SHIP_COMPANY_ID,1,1,0)#</td>
                             	<td style="text-align:left">#UNVAN#</td>
                                <td style="text-align:left">#PRODUCT_CODE_2#</td>
                             	<td style="text-align:left">#NAME_PRODUCT#</td>
                             	<td style="text-align:right">#TlFormat(QUANTITY,2)#</td>
                                <td style="text-align:right">#TlFormat(AMOUNT,2)#</td>
                                <td style="text-align:right">#TlFormat(TESLIM,2)#</td>
                                <td style="text-align:right">#TlFormat(REAL_STOCK,2)#</td>
                             	<td style="text-align:left">#UNIT#</td>
                          	</tr>
                            </cfif>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="11"><cf_get_lang_main no='72.Kayit Yok'>!</td>
                        </tr>
                    </cfif>
       	      	</table>
          	</td>
      	</tr>
        <tr>
         	<td style="display:none">
            	<cfif get_stocks.recordcount>
               		<audio autoplay="autoplay" controls="none">
                     	<source src="dingdong.mp3" type="audio/mpeg">
                  	</audio>
              	</cfif>
         	</td>
    	</tr>
	</table>
</cfform>
<script language="javascript">
	pn_kontrol();
	function pn_kontrol()
	{
		geciktir1 = setTimeout("window.location.href='<cfoutput>#request.self#?fuseaction=sales.list_ezgi_shipping_portal_first</cfoutput>'", 100000);
	}
</script>