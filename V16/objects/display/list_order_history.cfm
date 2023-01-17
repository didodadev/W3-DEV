<cfquery name="GET_ORDER_HISTORY" datasource="#DSN3#">
	SELECT
          OH.ORDER_ID,
          OH.ORDER_HISTORY_ID,
          OH.ORDER_DATE,
          OH.PUBLISHDATE,
          OH.DELIVERDATE,
          OH.RECORD_DATE,
          OH.UPDATE_DATE,
          OH.UPDATE_EMP,
          OH.PARTNER_ID,
          OH.CONSUMER_ID,
          OH.PROJECT_ID,
          OH.WORK_ID,
          OH.ORDER_EMPLOYEE_ID,
          OH.RECORD_EMP,
          OH.RECORD_PAR,
          OH.RECORD_IP,
          OH.ORDER_STAGE,
          OH.SHIP_ADDRESS,
          OH.ORDER_NUMBER,
          PP.PROJECT_HEAD,
          PW.WORK_HEAD,
          PTR.STAGE,
          CP.COMPANY_PARTNER_NAME,
          CP.COMPANY_PARTNER_SURNAME,
          C.CONSUMER_NAME,
          C.CONSUMER_SURNAME,
          E.EMPLOYEE_NAME,
          E.EMPLOYEE_SURNAME
    FROM 
          ORDERS_HISTORY OH 
          LEFT JOIN #DSN_ALIAS#.PRO_PROJECTS PP ON PP.PROJECT_ID = OH.PROJECT_ID 
          LEFT JOIN #DSN_ALIAS#.PRO_WORKS PW ON PW.WORK_ID = OH.WORK_ID
          LEFT JOIN #DSN_ALIAS#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = OH.ORDER_STAGE
          LEFT JOIN #DSN_ALIAS#.COMPANY_PARTNER CP ON CP.PARTNER_ID = OH.PARTNER_ID
          LEFT JOIN #DSN_ALIAS#.CONSUMER C ON C.CONSUMER_ID = OH.CONSUMER_ID
          LEFT JOIN #DSN_ALIAS#.EMPLOYEES E ON E.EMPLOYEE_ID = OH.ORDER_EMPLOYEE_ID
    WHERE 
          ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> 
    ORDER BY 
          ORDER_HISTORY_ID
</cfquery>
<cfquery name="GET_ORDER_ROWS" datasource="#DSN3#">
	SELECT
		P.PRODUCT_NAME,
		S.PROPERTY,
        ORD.ORDER_ID,
        ORD.ORDER_HISTORY_ID,
        ORD.ORDER_ROW_ID,
        ORD.PRODUCT_NAME,
        ORD.PRICE,
        ORD.ORDER_ROW_CURRENCY,
        ORD.DISCOUNT_1,
        ORD.DISCOUNT_2,
        ORD.DISCOUNT_3,
        ORD.DISCOUNT_4,
        ORD.DISCOUNT_5,
        ORD.DISCOUNT_6,
        ORD.DISCOUNT_7,
        ORD.DISCOUNT_8,
        ORD.DISCOUNT_9,
        ORD.DISCOUNT_10,
        ORD.TAX,
        ORD.QUANTITY,
        ORD.UNIT,
        ORD.OTHER_MONEY_VALUE,
        ORD.OTHER_MONEY
	FROM
		ORDER_ROW_HISTORY ORD,
     --   ORDER_ROW ORW,
		PRODUCT P,
		STOCKS S
	WHERE
		ORD.PRODUCT_ID=P.PRODUCT_ID AND
		ORD.STOCK_ID=S.STOCK_ID AND
     --   ORW.ORDER_ROW_ID = ORD.ORDER_ROW_ID AND
        ORD.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
	ORDER BY 
		ORD.STOCK_ID,
		ORD.ORDER_ROW_ID
</cfquery>
<cfquery name="GET_SEND_DETAIL_XML" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="objects.popup_list_order_history"> AND
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_is_discount">
</cfquery>
<style>
.history_head tr:first-child td{
	background-color:#67bbc9;
	color:white;
	font-weight:bold;
	border:none;
	}
.history_head td {
	text-align:center;
	}	

</style>
<cfsavecontent variable="title_"><cf_get_lang dictionary_id='57473.Tarihçe'>: <cfoutput>#GET_ORDER_HISTORY.order_number#</cfoutput></cfsavecontent>
    <cf_box title="#title_#" popup_box="1">
        <cf_flat_list>
            <thead></thead>
            <cfif get_order_history.recordcount>
                <cfset temp_ = 0>
                <cfoutput query="GET_ORDER_HISTORY">
                    <cfquery name = "GET_ROW_HISTORY" dbtype="query">
                            SELECT 
                                ORDER_ROW_ID,
                                PRODUCT_NAME,
                                PROPERTY,
                                PRICE,
                                ORDER_ROW_CURRENCY,
                                DISCOUNT_1,
                                DISCOUNT_2,
                                DISCOUNT_3,
                                DISCOUNT_4,
                                DISCOUNT_5,
                                DISCOUNT_6,
                                DISCOUNT_7,
                                DISCOUNT_8,
                                DISCOUNT_9,
                                DISCOUNT_10,
                                TAX,
                                QUANTITY,
                                UNIT,
                                OTHER_MONEY_VALUE,
                                OTHER_MONEY
                            FROM 
                                GET_ORDER_ROWS
                            WHERE 
                                ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_id#"> AND 
                                ORDER_HISTORY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#order_history_id#">
                    </cfquery>
                    <cfset temp_ = temp_ +1>
                    <cfsavecontent variable="header_txt"><cfif len(update_date)>#dateformat(update_date,dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,update_date),timeformat_style)#) <cfelse>#dateformat(record_date,dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,record_date),timeformat_style)#)</cfif> - <cfif len(update_emp)>#get_emp_info(update_emp,0,0)#<cfelse>#get_emp_info(record_emp,0,0)#</cfif></cfsavecontent>
                    <cf_seperator id="history_#temp_#" header="#header_txt#" is_closed="1">
                    <div id="history_#temp_#">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12">
                                    <cfif len(partner_id)>
                                        #company_partner_name# #company_partner_surname#
                                    <cfelseif len(consumer_id)>
                                        #consumer_name# #consumer_surname#
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang dictionary_id ='33827.Sipariş Aşama'></label>
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12"><cfif len(order_stage)>#STAGE#</cfif></div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12"><cfif len(project_id)>#project_head#</cfif></div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12">#dateformat(deliverdate,dateformat_style)#</div>
                            </div>
                            <div class="form-group"> 
                                <label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></label>
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12"><cfif len(record_date)>#dateformat(record_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</cfif></div>
                            </div>
                            <div class="form-group"> 
                                <label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang dictionary_id='32555.İş/Görev'></label> 
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12"><cfif len(work_id)>#work_head#</cfif></div>
                            </div>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></label> 	 
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12">#dateformat(order_date,dateformat_style)#</div> 
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang dictionary_id='57483.Kayıt'> <cf_get_lang dictionary_id="32421.IP"></label>
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12">#record_ip#</div>
                            </div>
                            <div class="form-group">  
                                <label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>	
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12"><cfif len(order_employee_id)>#employee_name# #employee_surname#</cfif></div>
                            </div>
                            <div class="form-group">
                                <!---<label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang no='1158.Yayım T.'></label>
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12">#dateformat(publishdate,dateformat_style)#</div>	--->
                                <label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang dictionary_id='57483.Kayıt'></label>
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12"><cfif attributes.portal_type eq "employee" >#get_emp_info(record_emp,0,0)#<cfelse>#get_par_info(record_par,0,-1,0)#</cfif></div>
                            </div>
                            <div class="form-group">  
                                <label class="col col-4 col-md-4 col-xs-4 col-sm-12"><cf_get_lang dictionary_id='58449.teslim yeri'></label>
                                <div class="col col-6 col-md-6 col-xs-6 col-sm-12">#ship_address#</div>
                            </div>
                        </div>
                    </div>
                    <cf_grid_list class="history_head">
                        <cfif GET_ROW_HISTORY.recordcount>
                            <thead>
                                <tr height="20"> 
                                    <th><cf_get_lang dictionary_id='57487.no'></th>
                                    <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                                    <th><cf_get_lang dictionary_id='58084.Fiyat'></th>
                                    <th><cf_get_lang dictionary_id='33828.Satış Aşaması'></th>
                                    <cfset colspan_info = 2>
                                    <cfloop list="#ListDeleteDuplicates(GET_SEND_DETAIL_XML.PROPERTY_VALUE)#" index="xlr">
                                        <cfswitch expression="#xlr#">
                                            <cfcase value="1">
                                                <cfset colspan_info = colspan_info + 1>
                                                <th  width="120"><cf_get_lang dictionary_id='57641.İndirim'> 1</th>
                                            </cfcase>
                                            <cfcase value="2">
                                                <cfset colspan_info = colspan_info + 1>
                                                <th  width="120" ><cf_get_lang dictionary_id='57641.İndirim'> 2</th>
                                            </cfcase>
                                            <cfcase value="3">
                                                <cfset colspan_info = colspan_info + 1>
                                                <th width="120" ><cf_get_lang dictionary_id='57641.İndirim'> 3</th>
                                            </cfcase>
                                            <cfcase value="4">
                                                <cfset colspan_info = colspan_info + 1>
                                                <th width="120" ><cf_get_lang dictionary_id='57641.İndirim'> 4</th>
                                            </cfcase>
                                            <cfcase value="5">
                                                <cfset colspan_info = colspan_info + 1>
                                                <th width="120" ><cf_get_lang dictionary_id='57641.İndirim'> 5</th>
                                            </cfcase>
                                            <cfcase value="6">
                                                <cfset colspan_info = colspan_info + 1>
                                                <th width="120" ><cf_get_lang dictionary_id='57641.İndirim'> 6</th>
                                            </cfcase>
                                            <cfcase value="7">
                                                <cfset colspan_info = colspan_info + 1>
                                                <th  width="120" ><cf_get_lang dictionary_id='57641.İndirim'> 7</th>
                                            </cfcase>
                                            <cfcase value="8">
                                                <cfset colspan_info = colspan_info + 1>
                                                <th  width="120" ><cf_get_lang dictionary_id='57641.İndirim'> 8</th>
                                            </cfcase>
                                            <cfcase value="9">
                                                <cfset colspan_info = colspan_info + 1>
                                                <th width="120"><cf_get_lang dictionary_id='57641.İndirim'> 9</th>
                                            </cfcase>
                                            <cfcase value="10">
                                                <cfset colspan_info = colspan_info + 1>
                                                <th width="120"><cf_get_lang dictionary_id='57641.İndirim'> 10</th>
                                            </cfcase>
                                    </cfswitch>
                                    </cfloop>      				  
                                    <th  width="40"><cf_get_lang dictionary_id='57639.KDV'></th>
                                    <th  width="120" ><cf_get_lang dictionary_id='57635.Miktar'></th>
                                    <th  width="159"><cf_get_lang dictionary_id='57673.Tutar'></th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfloop QUERY="GET_ROW_HISTORY">
                                    <tr>
                                        <td style="padding:1mm;">#ORDER_ROW_ID#</td>
                                        <td>#PRODUCT_NAME#&nbsp;#PROPERTY#</td>
                                        <td class="text-right">#TLFormat(PRICE)# #SESSION.EP.MONEY#</td>
                                        <td>
                                            <cfif Len(ORDER_ROW_CURRENCY)>
                                                <cfswitch expression = "#ORDER_ROW_CURRENCY#">
                                                    <cfcase value="-10"><cf_get_lang dictionary_id="29746.Kapatıldı">(<cf_get_lang dictionary_id="58500.Manuel">)</cfcase>
                                                    <cfcase value="-9"><cf_get_lang dictionary_id="58506.İptal"></cfcase>
                                                    <cfcase value="-8"><cf_get_lang dictionary_id="29749.Fazla Teslimat"></cfcase>
                                                    <cfcase value="-7"><cf_get_lang dictionary_id="29748.Eksik Teslimat"></cfcase>
                                                    <cfcase value="-6"><cf_get_lang dictionary_id="58761.Sevk"></cfcase>
                                                    <cfcase value="-5"><cf_get_lang dictionary_id="57456.Üretim"></cfcase>
                                                    <cfcase value="-4"><cf_get_lang dictionary_id="29747.Kısmi Üretim"></cfcase>
                                                    <cfcase value="-3"><cf_get_lang dictionary_id="29746.Kapatıldı"></cfcase>
                                                    <cfcase value="-2"><cf_get_lang dictionary_id="29745.Tedarik"></cfcase>
                                                    <cfcase value="-1"><cf_get_lang dictionary_id="58717.Açık"></cfcase>
                                                </cfswitch>
                                            </cfif>
                                        </td>
                                        <cfloop list="#ListDeleteDuplicates(GET_SEND_DETAIL_XML.PROPERTY_VALUE)#" index="xlr">
                                            <cfswitch expression="#xlr#">
                                                <cfcase value="1">
                                                    <td>#TLFormat(DISCOUNT_1)# %</td>
                                                </cfcase>
                                                <cfcase value="2">
                                                    <td >#TLFormat(DISCOUNT_2)# %</td>
                                                </cfcase>
                                                <cfcase value="3">
                                                    <td >#TLFormat(DISCOUNT_3)# %</td>
                                                </cfcase>
                                                <cfcase value="4">
                                                    <td >#TLFormat(DISCOUNT_4)# %</td>
                                                </cfcase>
                                                <cfcase value="5">
                                                    <td >#TLFormat(DISCOUNT_5)# %</td>
                                                </cfcase>
                                                <cfcase value="6">
                                                    <td >#TLFormat(DISCOUNT_6)# %</td>
                                                </cfcase>
                                                <cfcase value="7">
                                                    <td >#TLFormat(DISCOUNT_7)# %</td>
                                                </cfcase>
                                                <cfcase value="8">
                                                    <td >#TLFormat(DISCOUNT_8)# %</td>
                                                </cfcase>
                                                <cfcase value="9">
                                                    <td >#TLFormat(DISCOUNT_9)# %</td>
                                                </cfcase>
                                                <cfcase value="10">
                                                    <td >#TLFormat(DISCOUNT_10)# %</td>
                                                </cfcase>
                                            </cfswitch>
                                        </cfloop>						  
                                        <td>#TAX#</td>
                                        <td>#QUANTITY# #UNIT#</td>
                                        <td class="text-right">#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
                                    </tr>
                                </cfloop>
                            </tbody>
                        </cfif>
                    </cf_grid_list>		
                </cfoutput>
                <cfelse>
                <tbody>
                    <tr>
                        <td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td> 
                    </tr>
                </tbody>
            </cfif>
        </cf_flat_list>
    </cf_box>
