<cf_popup_box title="Grup Fiyatları">
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<table class="medium_list" align="center" style="width:100%;">  
<thead>             
	<tr> 
		<th width="25"><cf_get_lang_main no='75.No'></th>
		<th>Tablo Kodu</th>
		<th>F. Tipi</th>
        <th>Ürün</th>
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
		<th>Depo Stok</th>
		<th>Genel Stok</th>
		<th>Kayıt</th>
		<th></th>
	  </tr>
	  </thead>
	  <tbody>
	  <cfset is_pink_ = 0>
	  <cfquery name="get_price" datasource="#dsn_dev#">
		SELECT 
			(SELECT SUM(PRODUCT_STOCK) AS SONSTOK FROM #dsn2_alias#.GET_STOCK_LAST_LOCATION WHERE PRODUCT_ID = PT.PRODUCT_ID AND DEPARTMENT_ID <> #merkez_depo_id#) AS MAGAZA_STOK,
			(SELECT SUM(PRODUCT_STOCK) AS SONSTOK FROM #dsn2_alias#.GET_STOCK_LAST_LOCATION WHERE PRODUCT_ID = PT.PRODUCT_ID) AS GENEL_STOK,
			ISNULL(PTY.TYPE_CODE,'AKTARIM') TYPE_NAME,
			ISNULL(PT.NEW_PRICE,(PT.NEW_PRICE_KDV/(1+SKDV/100))) NEW_PRICE_2,
			(SELECT ST.TABLE_INFO FROM SEARCH_TABLES ST WHERE ST.TABLE_ID = PT.TABLE_ID) AS TABLE_INFO,
			(SELECT E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE E.EMPLOYEE_ID = PT.RECORD_EMP) RECORDER,
            P.PRODUCT_NAME,
			PT.*                 
		FROM
			#dsn1_alias#.PRODUCT P,
            PRICE_TABLE PT
			LEFT JOIN PRICE_TYPES PTY ON PT.PRICE_TYPE = PTY.TYPE_ID
		WHERE
			PT.IS_ACTIVE_P = 1 AND
            PT.PRODUCT_ID = P.PRODUCT_ID AND
            PT.ACTION_CODE = '#attributes.ACTION_CODE#'
            <cfif isdefined("attributes.TABLE_CODE")>
            	AND PT.TABLE_CODE = '#attributes.TABLE_CODE#'
            </cfif>
            <cfif isdefined("attributes.product_id_list")>
            	AND PT.PRODUCT_ID IN (#attributes.product_id_list#)
            </cfif>
		ORDER BY
			PT.FINISHDATE DESC,
			PT.STARTDATE DESC,
			PT.ROW_ID DESC
	  </cfquery>	
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
		<tr>
			<td>#currentrow#</td>
			<td style="<cfif len(startdate) and len(finishdate) and s_bugun_fark gte 0 and f_bugun_fark lte 0 and is_pink_ eq 0><cfset is_pink_ = 1>color:##F39; font-weight:bold;<cfelse></cfif>">#table_code#</td>
			<td nowrap>#TYPE_NAME#</td>
            <td nowrap>#PRODUCT_NAME#</td>
			<td>#table_info#</td>
			<td style="background-color:##DEB887; ;"><cfif IS_ACTIVE_S eq 0 and IS_ACTIVE_P eq 0>Teklif<cfelseif IS_ACTIVE_S eq 1>1</cfif></td>
			<td style="background-color:##DEB887; ;">#start_#</td>                
			<td style="<cfif len(finishdate) and f_bugun_fark lte 0>background-color:##0F6;;<cfelse>background-color:##DEB887;;</cfif>">#dateformat(finishdate,'dd/mm/yyyy')#</td>                
			<td style="background-color:##DEB887; ;">#TLFormat(NEW_PRICE_2,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>
			<td style="background-color:##DEB887; ;">#TLFormat(NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>
			<td><cfif IS_ACTIVE_S eq 0 and IS_ACTIVE_P eq 0>Teklif<cfelseif IS_ACTIVE_P eq 1>1</cfif></td>
			<td style="background-color:##FFF8DC; ;">#dateformat(p_startdate,'dd/mm/yyyy')#</td>                
			<td style="background-color:##FFF8DC; ;">#dateformat(p_finishdate,'dd/mm/yyyy')#</td>
			<td style="background-color:##FFF8DC; ;"><a href="javascript://" onclick="gonder_price('#TLFormat(brut_alis,session.ep.our_company_info.sales_price_round_num)#','#discount_list#','#manuel_discount#','#row_id#','#start_#','#finish_#','#p_start_#','#p_finish_#','#TLFormat(margin)#','#TLFormat(p_margin)#','#TLFormat(new_price_2,session.ep.our_company_info.sales_price_round_num)#','#TLFormat(NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#','#PRICE_TYPE#','<cfif len(is_active_s)>#is_active_s#<cfelse>0</cfif>','<cfif len(is_active_p)>#is_active_p#<cfelse>0</cfif>');" class="tableyazi">#tlformat(brut_alis)#</a></td>
			<td style="background-color:##FFF8DC; ;">#discount_list#</td>
			<td style="background-color:##FFF8DC; ;">#tlformat(manuel_discount)#</td>
			<td style="background-color:##FFF8DC; color:white;"><a href="javascript://" onclick="gonder_price('#TLFormat(brut_alis,session.ep.our_company_info.sales_price_round_num)#','#discount_list#','#manuel_discount#','#row_id#','#start_#','#finish_#','#p_start_#','#p_finish_#','#TLFormat(margin)#','#TLFormat(p_margin)#','#TLFormat(new_price_2,session.ep.our_company_info.sales_price_round_num)#','#TLFormat(NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#','#PRICE_TYPE#','<cfif len(is_active_s)>#is_active_s#<cfelse>0</cfif>','<cfif len(is_active_p)>#is_active_p#<cfelse>0</cfif>');" class="tableyazi">#TLFormat(new_alis,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</a></td>
			<td  style="background-color:##FFF8DC; ;">#TLFormat(new_alis_kdv,session.ep.our_company_info.sales_price_round_num)# #SESSION.EP.money#</td>
			<td>#tlformat(margin)#</td>
			<td>#tlformat(p_margin)#</td>
			<td>#dueday#</td>
			<td style="background-color:##FA8072; ;">#tlformat(MAGAZA_STOK)#</td>
			<td style="background-color:##808000; ;">#tlformat(GENEL_STOK)#</td>
			<td>
				<cfset record_ = dateadd('h',session.ep.time_zone,record_date)>
				#dateformat(record_,'dd/mm/yyyy')# #timeformat(record_,'HH:MM')#
			</td>
			<td>#RECORDER#</td>
		  </tr>			  
	  </cfoutput> 
	</tbody>
</table>
</cf_popup_box>