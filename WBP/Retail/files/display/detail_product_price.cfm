<cfif fusebox.fuseaction is 'popup_detail_product_price'>
    <link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.base.css" />
    <link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.energyblue.css" />
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.edit.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
    
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.selection.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsresize.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsreorder.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.filter.js"></script>

    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxnumberinput_new.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxinput.js"></script>

    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdropdownlist.js"></script>
    
    
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.grouping.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.aggregates.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/scripts/demos.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/demos/jqxgrid/localization.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
</cfif>

<cfparam name="attributes.row_id" default="">
<cf_get_lang_set module_name="product">
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfquery name="get_stocks" datasource="#dsn3#" result="a1">
    SELECT STOCK_ID,PROPERTY FROM STOCKS WHERE PRODUCT_ID = #attributes.pid#
</cfquery>
<cfset attributes.stock_id = valuelist(get_stocks.stock_id)>
<cfset attributes.stock_name_list = valuelist(get_stocks.property)>

<cfquery name="get_stock_info" datasource="#dsn2#" result="a2">
    EXEC get_stock_last_location_function '#attributes.stock_id#'
</cfquery>

<cfquery name="get_last_stock" dbtype="query">
    SELECT SUM(PRODUCT_STOCK) AS SONSTOK FROM get_stock_info WHERE DEPARTMENT_ID NOT IN (#iade_depo_id#)
</cfquery>

<cfquery name="get_depo_stock" dbtype="query">
    SELECT SUM(PRODUCT_STOCK) AS SONSTOK FROM get_stock_info WHERE DEPARTMENT_ID = #merkez_depo_id#
</cfquery>

<cfquery name="get_product" datasource="#dsn3#" result="a3">
	SELECT
    	ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.ROW_ID NOT IN (SELECT PTD.ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD) AND
                    (
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) AND
                    PT1.PRODUCT_ID = P.PRODUCT_ID
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PS.PRICE_KDV) AS PRICE_KDV,
       ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.ROW_ID NOT IN (SELECT PTD.ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD) AND
                    (
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#) AND
                    PT1.PRODUCT_ID = P.PRODUCT_ID
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PS.PRICE) AS PRICE,
        ISNULL(( 
        SELECT TOP 1 
                PT.TYPE_NAME
            FROM
                #DSN_DEV#.PRICE_TABLE PT1,
                #DSN_DEV#.PRICE_TYPES PT
            WHERE
                PT1.ROW_ID NOT IN (SELECT PTD.ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD) AND
                PT1.PRICE_TYPE = PT.TYPE_ID AND
                (
                PT1.IS_ACTIVE_S = 1 AND
                PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#) AND
                PT1.PRODUCT_ID = P.PRODUCT_ID
            ORDER BY
                PT1.STARTDATE DESC
            ),'SS') AS PRICE_TYPE,
        PU.MAIN_UNIT,
        PS.PRICE_KDV AS SATIS_FIYAT_KDV,
        PS.PRICE AS SATIS_FIYAT,
        PS2.PRICE_KDV AS ALIS_FIYAT_KDV,
        PS2.PRICE AS ALIS_FIYAT,
        P.PRODUCT_NAME,
        P.TAX,
        P.TAX_PURCHASE
    FROM
    	PRODUCT P,
        PRICE_STANDART PS,
        PRICE_STANDART PS2,
        PRODUCT_UNIT PU
    WHERE
    	PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
        P.PRODUCT_ID = #attributes.pid# AND
        PS.PRODUCT_ID = P.PRODUCT_ID AND
		PS.PURCHASESALES = 1 AND
		PS.PRICESTANDART_STATUS = 1 AND
        PS2.PRODUCT_ID = P.PRODUCT_ID AND
		PS2.PURCHASESALES = 0 AND
		PS2.PRICESTANDART_STATUS = 1
</cfquery>

<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.order_list" default="0">

<!--- net maliyet hesabı --->


<!--- net maliyet hesabı --->
<cfset alis_kdv = GET_PRODUCT.TAX_PURCHASE>
<cfset satis_kdv = GET_PRODUCT.TAX>

<table class="dph">
  <tr>
    <td class="dpht">
        <table>
            <tr>
				<cfoutput>
                <td class="headbold"><a href="#request.self#?fuseaction=product.form_upd_product&pid=#attributes.pid#">#get_product.product_name#</a>&nbsp;&nbsp;</td>
                <td class="formbold" bgcolor="##FFCC66">Genel Stok</td>
                <td bgcolor="##33FFFF">#get_last_stock.SONSTOK#</td>
                <td class="formbold" bgcolor="##FFCC66">Depo Stok</td>
                <td bgcolor="##33FFFF">#get_depo_stock.SONSTOK#</td>
                </cfoutput>
            </tr>
        </table>
    </td>
  </tr>
</table>
<table class="dpm">
	<tr>
		<td class="dpml">
			<!--- Ürün Bilgileri --->
            <table class="medium_list" align="center">
            <thead>
              <tr> 
				<th><cf_get_lang_main no='224.Birim'></th>
			    <th style="text-align:right;"><cf_get_lang_main no='1310.Standart Alış'></th>
				<th style="text-align:right;"><cf_get_lang no='415.KDV li Alış'></th>
			    <th style="text-align:right;"><cf_get_lang_main no='1309.Standart Satış'></th>
				<th style="text-align:right;"><cf_get_lang_main no='1309.Standart Satış'> <cf_get_lang_main no='1304.KDVli'></th>
                <th style="text-align:right;">Fiyat Tipi</th>
                <th style="text-align:right;">Geçerli Fiyat</th>
                <th style="text-align:right;">Geçerli Fiyat <cf_get_lang_main no='1304.KDVli'></th>
			    <th width="70" style="text-align:right;"><cf_get_lang no='34.Kar Marjı'>%</th>
              </tr>
            </thead>
            <cfoutput>
                <tbody>
					<tr>
						<td>#get_product.MAIN_UNIT#</td>
						<td style="text-align:right;" nowrap="nowrap">#TLFormat(get_product.ALIS_FIYAT,2)#</td>
						<td style="text-align:right;">#TLFormat(get_product.ALIS_FIYAT_KDV,2)#</td>
						<td style="text-align:right;">#TLFormat(get_product.SATIS_FIYAT,2)#</td>
						<td style="text-align:right;">#TLFormat(get_product.SATIS_FIYAT_KDV,2)#</td>
						<td style="text-align:right;background-color:##48D1CC;">
                        	<cfif get_product.PRICE_TYPE is 'SS'>
                            	<cfif get_product.PRICE eq wrk_round(get_product.SATIS_FIYAT)>
                                	Standart Satış
                                <cfelse>
                                	Aktarım
                                </cfif>
                            <cfelse>
                                #get_product.PRICE_TYPE#
                          </cfif>
                        </td>
                        <td style="text-align:right;background-color:##48D1CC;">#tlformat(get_product.PRICE)#</td>
                        <td style="text-align:right;background-color:##48D1CC;">#tlformat(get_product.PRICE_KDV)#</td>                         
                        <td style="text-align:right;">&nbsp;</td>				
					</tr>
                </tbody>
            </cfoutput>
            </table>
            
            <!--- standart fiyatlar --->
          <cfquery name="get_price" datasource="#dsn_dev#" result="get_price_result">
            EXEC get_product_standart_prices #attributes.pid#
          </cfquery>
          
            <cfsavecontent variable="rig"><cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'></cfsavecontent>
            <cfsavecontent variable="header_"><a href="javascript://" onclick="show_hide('standart_fiyat_table')">Standart Fiyatlar</a></cfsavecontent>
            <cf_medium_list_search title="#header_#"></cf_medium_list_search>
            <div style="height:250px; overflow:auto;display:none;" id="standart_fiyat_table">
            <table class="medium_list" align="center"> 
            <thead>             
                <tr> 
                    <th width="25"><cf_get_lang_main no='75.No'></th>
                    <th>Tablo Kodu</th>
                    <th>Açıklama</th>
                    <th>Onay</th>
                    <th>St. Baş.</th>			              
                    <th>St. Fiyat</th>				
                    <th>St. KDVli</th>	
                    <th>Al. Baş.</th>
                    <th>Brüt Al.</th>
                    <th>% İnd.</th>
                    <th>Al. Fiyat</th>				
                    <th>Al. KDVli</th>
                    <th>M. İnd.</th>
                    <th>St. Kar</th>
                    <th>Al. Kar</th>
                    <th>Kayıt</th>
                  </tr>
                  </thead>
                  <tbody>
                  
                  <cfoutput query="get_price">
                  	<cfset discount_list = "">
                    <cfloop from="1" to="10" index="ccc">
                        <cfif len(evaluate("std_sales_discount#ccc#")) and evaluate("std_sales_discount#ccc#") neq 0>
                            <cfset discount_list = listappend(discount_list,tlformat(evaluate("std_sales_discount#ccc#")),'+')>
                        </cfif>
                    </cfloop>
                    <tr>
                        <td>#currentrow#</td>
                        <td>#table_code#</td>
                        <td>#table_info#</td>
                        <td><cfif is_active_s eq 1>Onaylı<cfelse>Teklif</cfif></td>
                        <td style="background-color:##66FFFF; ;">#dateformat(STANDART_S_STARTDATE,'dd/mm/yyyy')#</td>   
                        <td style="background-color:##66FFFF; ;">#TLFormat(READ_FIRST_SATIS_PRICE,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>
                        <td style="background-color:##66FFFF; ;">#TLFormat(READ_FIRST_SATIS_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>                        
                        <td style="background-color:##CCFFFF; ;">#dateformat(STD_P_STARTDATE,'dd/mm/yyyy')#</td>
                        <td style="background-color:##CCFFFF; ;">#TLFormat(standart_alis,session.ep.our_company_info.sales_price_round_num)#</td>
                        <td style="background-color:##CCFFFF; ;">#discount_list#</td>
                        <td style="background-color:##CCFFFF; ;">#TLFormat(standart_alis_liste,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>                
                        <td style="background-color:##CCFFFF; ;">#TLFormat(standart_alis_kdvli,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>
                        <td>#tlformat(std_p_discount_manuel)#</td>
                        <td style="background-color:##66FFFF; ;">#s_profit#</td>
                        <td>#p_profit#</td>
                        <td style="background-color:##66FFFF; ;">#dateformat(record_date,'dd/mm/yyyy')#</td> 
					</tr>			  
                  </cfoutput> 
                </tbody>
            </table>
            </div>
            <!--- standart fiyatlar --->
            <br />
            
            <!--- sube bazli --->
            <cfquery name="get_price_depts" datasource="#dsn_dev#" result="get_p_result2">
            	EXEC get_product_of_prices_depts #attributes.pid#   
            </cfquery>
            <cfsavecontent variable="header_"><a href="javascript://" onclick="show_hide('sube_bazli_fiyat_table')">Şube Bazlı Fiyatlar</a></cfsavecontent>
            <cf_medium_list_search title="#header_#"></cf_medium_list_search>
            <div style="display:none;" id="sube_bazli_fiyat_table">
            	<cfif not get_price_depts.recordcount>
                	&nbsp;&nbsp;&nbsp;&nbsp;Şube Bazlı Fiyatlandırma Yok!
                <cfelse>
                	&nbsp;&nbsp;&nbsp;&nbsp;
					<cfset dept_id_list = listdeleteduplicates(valuelist(get_price_depts.department_id))>
                    <cfset dept_name_list = listdeleteduplicates(valuelist(get_price_depts.department_head))>
                            <table class="medium_list" align="center" style="width:100%;">  
                            <thead>             
                                <tr> 
                                    <th width="25"><cf_get_lang_main no='75.No'></th>
                                    <th>Tablo Kodu</th>
                                    <th>Hareket Kodu</th>
                                    <th>F. Tipi</th>
                                    <th>Açıklama</th>
                                    <th>St. O.</th>
                                    <th>St. Baş.</th>				
                                    <th>St. Bitiş</th>
                                    <th>St. Fiyat</th>
                                    <th>St. KDVli</th>				              
                                    <th>Al. O.</th>
                                    <th>Al. Baş.</th>				
                                    <th>Al. Bitiş</th>
                                    <th>Br. Alış</th>
                                    <th>% İnd.</th>
                                    <th>Tut. İnd.</th>
                                    <th>Al. Fiyat</th>
                                    <th>Al. KDVli</th>
                                    <th>St. Kar</th>
                                    <th>Al. Kar</th>
                                    <th>Vade</th>
                                    <th>P</th>
                                    <th>Kayıt T.</th>
                                    <th>Kayıt</th>
                                    <th></th>
                                  </tr>
                                  </thead>
                                  <tbody>
                              <cfloop from="1" to="#listlen(dept_id_list)#" index="ddd">
							<cfset d_id_ = listgetat(dept_id_list,ddd)>
                            <cfset d_head_ = listgetat(dept_name_list,ddd)>
                                <cfquery name="get_price" dbtype="query">
                                    SELECT
                                        *
                                    FROM
                                        get_price_depts
                                    WHERE
                                        DEPARTMENT_ID = #d_id_#
                                </cfquery>                            
                                  <cfset is_pink_ = 0>
                                  <tr>
                                  	<td colspan="25"><cfoutput><span style="font-weight:bold; font-size:10px;">#d_head_#</span></cfoutput></td>
                                  </tr>
								  <cfoutput query="get_price">
                                  	<cfquery name="get_price_d_list" dbtype="query">
                                    	SELECT
                                        	*
                                        FROM
                                        	get_price_depts
                                        WHERE
                                        	ROW_ID = #get_price.ROW_ID#
                                    </cfquery>
                                    <cfset p_dept_list = valuelist(get_price_d_list.department_id)>
                                  
                                  
                                    <cfset discount_list = "">
                                    <cfloop from="1" to="10" index="ccc">
                                        <cfif len(evaluate("discount#ccc#")) and evaluate("discount#ccc#") neq 0>
                                            <cfset discount_list = listappend(discount_list,tlformat(evaluate("discount#ccc#")),'+')>
                                        </cfif>
                                    </cfloop>
                                    
                                    <cfif len(startdate)><cfset s_bugun_fark = datediff('d',startdate,bugun_)></cfif>
                                    <cfif len(finishdate)><cfset f_bugun_fark = datediff('d',dateadd("d",-1,finishdate),bugun_)></cfif>
                                    
                                    <cfset start_ = dateformat(startdate,'dd/mm/yyyy')>
                                    <cfset finish_ = dateformat(finishdate,'dd/mm/yyyy')>
                                    <cfset p_start_ = dateformat(p_startdate,'dd/mm/yyyy')>
                                    <cfset p_finish_ = dateformat(p_finishdate,'dd/mm/yyyy')>
                                    <tr id="s_price_row_#row_id#">
                                        <td>#currentrow#</td>
                                        <td style="<cfif len(startdate) and len(finishdate) and s_bugun_fark gte 0 and f_bugun_fark lte 0 and is_pink_ eq 0><cfset is_pink_ = 1>color:##F39; font-weight:bold;<cfelse></cfif>">#table_code#</td>
                                        <td nowrap>#action_code#</td>
                                        <td nowrap>#TYPE_NAME#</td>
                                        <td>#table_info#</td>
                                        <td style="background-color:##DEB887; ;"><cfif IS_ACTIVE_S eq 0 and IS_ACTIVE_P eq 0>Teklif<cfelseif IS_ACTIVE_S eq 1>1</cfif></td>
                                        <td style="background-color:##DEB887; ;">#start_#</td>                
                                        <td style="<cfif len(finishdate) and f_bugun_fark lte 0>background-color:##0F6;;<cfelse>background-color:##DEB887;;</cfif>">#dateformat(finishdate,'dd/mm/yyyy')#</td>                
                                        <td style="background-color:##DEB887; ;">#TLFormat(NEW_PRICE_2,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>
                                        <td style="background-color:##DEB887; ;">#TLFormat(NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>
                                        <td><cfif IS_ACTIVE_S eq 0 and IS_ACTIVE_P eq 0>Teklif<cfelseif IS_ACTIVE_P eq 1>1</cfif></td>
                                        <td style="background-color:##FFF8DC; ;">#dateformat(p_startdate,'dd/mm/yyyy')#</td>                
                                        <td style="background-color:##FFF8DC; ;">#dateformat(p_finishdate,'dd/mm/yyyy')#</td>
                                        <td style="background-color:##FFF8DC; ;">#tlformat(brut_alis)#</td>
                                        <td style="background-color:##FFF8DC; ;">#discount_list#</td>
                                        <td style="background-color:##FFF8DC; ;">#tlformat(manuel_discount)#</td>
                                        <td style="background-color:##FFF8DC;">
                                        <cfif len(attributes.row_id)>
                                            <cfset start_ = dateformat(startdate,'dd/mm/yyyy')>
                                            <cfset finish_ = dateformat(finishdate,'dd/mm/yyyy')>
                                            <cfset p_start_ = dateformat(p_startdate,'dd/mm/yyyy')>
                                            <cfset p_finish_ = dateformat(p_finishdate,'dd/mm/yyyy')>
                                            <a href="javascript://" onclick="gonder_price_new('#attributes.row_id#','#TLFormat(brut_alis,session.ep.our_company_info.sales_price_round_num)#','#discount_list#','#manuel_discount#','#row_id#','#start_#','#finish_#','#p_start_#','#p_finish_#','#TLFormat(margin)#','#TLFormat(p_margin)#','#TLFormat(new_price_2,session.ep.our_company_info.sales_price_round_num)#','#TLFormat(NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#','#PRICE_TYPE#','<cfif len(is_active_s)>#is_active_s#<cfelse>0</cfif>','<cfif len(is_active_p)>#is_active_p#<cfelse>0</cfif>','#TLFormat(new_alis,2)#','#TLFormat(new_alis_kdv,2)#','#p_product_type#','#p_dept_list#');" class="tableyazi">#TLFormat(new_alis,2)# #SESSION.EP.money#</a>
                                        <cfelse>
                                            <a href="javascript://" onclick="gonder_price('#TLFormat(brut_alis,session.ep.our_company_info.sales_price_round_num)#','#discount_list#','#manuel_discount#','#row_id#','#start_#','#finish_#','#p_start_#','#p_finish_#','#TLFormat(margin)#','#TLFormat(p_margin)#','#TLFormat(new_price_2,session.ep.our_company_info.sales_price_round_num)#','#TLFormat(NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#','#PRICE_TYPE#','<cfif len(is_active_s)>#is_active_s#<cfelse>0</cfif>','<cfif len(is_active_p)>#is_active_p#<cfelse>0</cfif>');" class="tableyazi">#TLFormat(new_alis,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</a>
                                        </cfif>
                                        </td>
                                        <td  style="background-color:##FFF8DC; ;">#TLFormat(new_alis_kdv,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>
                                        <td>#tlformat(margin)#</td>
                                        <td>#tlformat(p_margin)#</td>
                                        <td>#dueday#</td>
                                        <td><cfif p_product_type eq 1>1<cfelse>55</cfif></td>
                                        <td>
                                            <cfset record_ = dateadd('h',session.ep.time_zone,record_date)>
                                            #dateformat(record_,'dd/mm/yyyy')# #timeformat(record_,'HH:MM')#
                                        </td>
                                        <td>#RECORDER#</td>
                                        <td>
                                            <a href="javascript://" onclick="if(confirm('Fiyat Satırını Silmek İstediğinize Emin misiniz?')) {windowopen('#request.self#?fuseaction=retail.emptypopup_del_price&row_id=#row_id#','medium')} else {return false};"><img src="/images/delete_list.gif"></a>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_upd_price&row_id=#row_id#','list');"><img src="/images/update_list.gif"></a>
                                        </td>
                                      </tr>			  
                                  </cfoutput> 
                                  </cfloop>
                                </tbody>
                            </table>
                </cfif>
            </div>
            <!--- sube bazli --->
            

			<!--- Satış Fiyatları --->
            <cfquery name="get_price" datasource="#dsn_dev#" result="get_p_result">
            	EXEC get_product_of_prices #attributes.pid# 
            </cfquery>
            
            <cfsavecontent variable="rig"><cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'></cfsavecontent>
            <div style="height:250px; overflow:auto;">
            <cf_medium_list_search title="Fiyatlar" right_images="#rig#"><!---Satış Fiyatları---></cf_medium_list_search>
            <table class="medium_list" align="center" style="width:100%;">  
            <thead>             
                <tr> 
                    <th width="25"><cf_get_lang_main no='75.No'></th>
                    <th>Tablo Kodu</th>
                    <th>Hareket Kodu</th>
                    <th>F. Tipi</th>
                    <th>Açıklama</th>
                    <th>St. O.</th>
                    <th>St. Baş.</th>				
                    <th>St. Bitiş</th>
                    <th>St. Fiyat</th>
                    <th>St. KDVli</th>				              
                    <th>Al. O.</th>
                    <th>Al. Baş.</th>				
                    <th>Al. Bitiş</th>
                    <th>Br. Alış</th>
                    <th>% İnd.</th>
                    <th>Tut. İnd.</th>
                    <th>Al. Fiyat</th>
                    <th>Al. KDVli</th>
                    <th>St. Kar</th>
                    <th>Al. Kar</th>
                    <th>Vade</th>
                    <th>P</th>
                    <th>Kayıt T.</th>
                    <th>Kayıt</th>
                    <th></th>
                  </tr>
                  </thead>
                  <tbody>
                  <cfset is_pink_ = 0>
                  <cfoutput query="get_price">
                  	<cfset discount_list = "">
                    <cfloop from="1" to="10" index="ccc">
                        <cfif len(evaluate("discount#ccc#")) and evaluate("discount#ccc#") neq 0>
                            <cfset discount_list = listappend(discount_list,tlformat(evaluate("discount#ccc#")),'+')>
                        </cfif>
                    </cfloop>
                    
					<cfif len(startdate)><cfset s_bugun_fark = datediff('d',startdate,bugun_)></cfif>
        			<cfif len(finishdate)><cfset f_bugun_fark = datediff('d',dateadd("d",-1,finishdate),bugun_)></cfif>
                    
                    <cfset start_ = dateformat(startdate,'dd/mm/yyyy')>
                    <cfset finish_ = dateformat(finishdate,'dd/mm/yyyy')>
                    <cfset p_start_ = dateformat(p_startdate,'dd/mm/yyyy')>
                    <cfset p_finish_ = dateformat(p_finishdate,'dd/mm/yyyy')>
                    <tr id="s_price_row_#row_id#">
                        <td>#currentrow#</td>
                        <td style="<cfif len(startdate) and len(finishdate) and s_bugun_fark gte 0 and f_bugun_fark lte 0 and is_pink_ eq 0><cfset is_pink_ = 1>color:##F39; font-weight:bold;<cfelse></cfif>">#table_code#</td>
                        <td nowrap>#action_code#</td>
                        <td nowrap>#TYPE_NAME#</td>
                        <td>#table_info#</td>
                        <td style="background-color:##DEB887; ;"><cfif IS_ACTIVE_S eq 0 and IS_ACTIVE_P eq 0>Teklif<cfelseif IS_ACTIVE_S eq 1>1</cfif></td>
                        <td style="background-color:##DEB887; ;">#start_#</td>                
                        <td style="<cfif len(finishdate) and f_bugun_fark lte 0>background-color:##0F6;;<cfelse>background-color:##DEB887;;</cfif>">#dateformat(finishdate,'dd/mm/yyyy')#</td>                
                        <td style="background-color:##DEB887; ;">#TLFormat(NEW_PRICE_2,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>
                        <td style="background-color:##DEB887; ;">#TLFormat(NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>
                        <td><cfif IS_ACTIVE_S eq 0 and IS_ACTIVE_P eq 0>Teklif<cfelseif IS_ACTIVE_P eq 1>1</cfif></td>
                        <td style="background-color:##FFF8DC; ;">#dateformat(p_startdate,'dd/mm/yyyy')#</td>                
                        <td style="background-color:##FFF8DC; ;">#dateformat(p_finishdate,'dd/mm/yyyy')#</td>
                        <td style="background-color:##FFF8DC; ;">#tlformat(brut_alis)#</td>
                        <td style="background-color:##FFF8DC; ;">#discount_list#</td>
                        <td style="background-color:##FFF8DC; ;">#tlformat(manuel_discount)#</td>
                        <td style="background-color:##FFF8DC;">
                        <cfif len(attributes.row_id)>
                            <cfset start_ = dateformat(startdate,'dd/mm/yyyy')>
							<cfset finish_ = dateformat(finishdate,'dd/mm/yyyy')>
                            <cfset p_start_ = dateformat(p_startdate,'dd/mm/yyyy')>
                            <cfset p_finish_ = dateformat(p_finishdate,'dd/mm/yyyy')>
                            <a href="javascript://" onclick="gonder_price_new('#attributes.row_id#','#TLFormat(brut_alis,session.ep.our_company_info.sales_price_round_num)#','#discount_list#','#manuel_discount#','#row_id#','#start_#','#finish_#','#p_start_#','#p_finish_#','#TLFormat(margin)#','#TLFormat(p_margin)#','#TLFormat(new_price_2,session.ep.our_company_info.sales_price_round_num)#','#TLFormat(NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#','#PRICE_TYPE#','<cfif len(is_active_s)>#is_active_s#<cfelse>0</cfif>','<cfif len(is_active_p)>#is_active_p#<cfelse>0</cfif>','#TLFormat(new_alis,2)#','#TLFormat(new_alis_kdv,2)#','#p_product_type#','');" class="tableyazi">#TLFormat(new_alis,2)# #SESSION.EP.money#</a>
                        <cfelse>
                        	<a href="javascript://" onclick="gonder_price('#TLFormat(brut_alis,session.ep.our_company_info.sales_price_round_num)#','#discount_list#','#manuel_discount#','#row_id#','#start_#','#finish_#','#p_start_#','#p_finish_#','#TLFormat(margin)#','#TLFormat(p_margin)#','#TLFormat(new_price_2,session.ep.our_company_info.sales_price_round_num)#','#TLFormat(NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#','#PRICE_TYPE#','<cfif len(is_active_s)>#is_active_s#<cfelse>0</cfif>','<cfif len(is_active_p)>#is_active_p#<cfelse>0</cfif>');" class="tableyazi">#TLFormat(new_alis,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</a>
                        </cfif>
                        </td>
                        <td  style="background-color:##FFF8DC; ;">#TLFormat(new_alis_kdv,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>
                        <td>#tlformat(margin)#</td>
                        <td>#tlformat(p_margin)#</td>
                        <td>#dueday#</td>
                        <td><cfif p_product_type eq 1>1<cfelse>55</cfif></td>
                        <td>
                        	<cfset record_ = dateadd('h',session.ep.time_zone,record_date)>
                            #dateformat(record_,'dd/mm/yyyy')# #timeformat(record_,'HH:MM')#
                        </td>
                        <td>#RECORDER#<cfif len(RECORDER_PAR)><b>b2b</b>:#RECORDER_PAR#</cfif></td>
						<td>
                        	<a href="javascript://" onclick="if(confirm('Fiyat Satırını Silmek İstediğinize Emin misiniz?')) {windowopen('#request.self#?fuseaction=retail.emptypopup_del_price&row_id=#row_id#','medium')} else {return false};"><img src="/images/delete_list.gif"></a>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_upd_price&row_id=#row_id#','list');"><img src="/images/update_list.gif"></a>
                        </td>
                      </tr>			  
                  </cfoutput> 
                </tbody>
            </table>
            </div>
	  </td>
	</tr>
</table>

<div id="product_detail_inner_div"></div>
<input type="hidden" name="order_list" id="order_list" value="-0">
<script>
$(document).ready(function ()
{
	adress_ = 'index.cfm?fuseaction=retail.emptypopup_detail_product_price_inner';
	adress_ += '&pid=<cfoutput>#attributes.pid#</cfoutput>';
	AjaxPageLoad(adress_,'product_detail_inner_div','1');
});
</script>