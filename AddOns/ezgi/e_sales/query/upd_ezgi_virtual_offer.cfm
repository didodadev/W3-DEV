<cf_date tarih="attributes.virtual_offer_date">
<cf_date tarih="attributes.deliverdate">
<cf_date tarih="attributes.finishdate">
<cfif len(attributes.BASKET_DUE_VALUE_DATE_)>
	<cf_date tarih="attributes.BASKET_DUE_VALUE_DATE_">
</cfif>
<cfif len(attributes.sales_member)>
    <cfquery name="get_company_id" datasource="#dsn#">
        SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = #attributes.sales_member_id#
    </cfquery>
</cfif>
<cflock name="#CREATEUUID()#" timeout="90">
    <cftransaction>
        <cfif attributes.record_num gt 0>
        	<cfquery name="upd_virtual_offer_history" datasource="#dsn3#" result="max_id">
            	INSERT INTO 
                	EZGI_VIRTUAL_OFFER_HISTORY
                 	(
                    	VIRTUAL_OFFER_ID, VIRTUAL_OFFER_DETAIL, VIRTUAL_OFFER_HEAD, VIRTUAL_OFFER_NUMBER, VIRTUAL_OFFER_DATE, VIRTUAL_OFFER_STAGE, VIRTUAL_OFFER_STATUS, PURCHASE_SALES, 
                         COMPANY_ID, PARTNER_ID, EMPLOYEE_ID, CONSUMER_ID, VIRTUAL_OFFER_EMPLOYEE_ID, PRIORITY_ID, MEMBER_TYPE, SHIP_METHOD, RESERVED, PROJECT_ID, DELIVERDATE, FINISHDATE, 
                         DISCOUNTTOTAL, SUB_DISCOUNTTOTAL, GROSSTOTAL, TAX, NETTOTAL, OTV_TOTAL, TAXTOTAL, OTHER_MONEY, OTHER_MONEY_VALUE, PAYMETHOD, DELIVER_DEPT_ID, LOCATION_ID, SHIP_ADDRESS, 
                         CITY_ID, COUNTY_ID, DUE_DATE, DUE_VALUE, REF_NO, SHIP_ADDRESS_ID, BRANCH_ID, PARTNER_COMPANY_ID, RECORD_DATE, RECORD_EMP, RECORD_IP, RECORD_PAR, RECORD_CON, 
                         UPDATE_DATE, UPDATE_EMP, UPDATE_IP, UPDATE_PAR, UPDATE_CON, IS_FOREIGN, COUNTRY_ID, REVISION_NO, REVISION_ID, SALES_COMPANY_ID
                 	)
				SELECT         
                		VIRTUAL_OFFER_ID, VIRTUAL_OFFER_DETAIL, VIRTUAL_OFFER_HEAD, VIRTUAL_OFFER_NUMBER, VIRTUAL_OFFER_DATE, VIRTUAL_OFFER_STAGE, VIRTUAL_OFFER_STATUS, PURCHASE_SALES, 
                         COMPANY_ID, PARTNER_ID, EMPLOYEE_ID, CONSUMER_ID, VIRTUAL_OFFER_EMPLOYEE_ID, PRIORITY_ID, MEMBER_TYPE, SHIP_METHOD, RESERVED, PROJECT_ID, DELIVERDATE, FINISHDATE, 
                         DISCOUNTTOTAL, SUB_DISCOUNTTOTAL, GROSSTOTAL, TAX, NETTOTAL, OTV_TOTAL, TAXTOTAL, OTHER_MONEY, OTHER_MONEY_VALUE, PAYMETHOD, DELIVER_DEPT_ID, LOCATION_ID, SHIP_ADDRESS, 
                         CITY_ID, COUNTY_ID, DUE_DATE, DUE_VALUE, REF_NO, SHIP_ADDRESS_ID, BRANCH_ID, PARTNER_COMPANY_ID, RECORD_DATE, RECORD_EMP, RECORD_IP, RECORD_PAR, RECORD_CON, 
                         UPDATE_DATE, UPDATE_EMP, UPDATE_IP, UPDATE_PAR, UPDATE_CON, IS_FOREIGN, COUNTRY_ID, REVISION_NO, REVISION_ID, SALES_COMPANY_ID
				FROM          
                	EZGI_VIRTUAL_OFFER
              	WHERE 
                	VIRTUAL_OFFER_ID = #attributes.VIRTUAL_OFFER_id#
            </cfquery>
            <cfquery name="upd_virtual_offer_row_history" datasource="#dsn3#">
            	INSERT INTO 
                	EZGI_VIRTUAL_OFFER_ROW_HISTORY
                 	(
                    	HISTORY_VIRTUAL_OFFER_ID, VIRTUAL_OFFER_ID, VIRTUAL_OFFER_ROW_ID, PRODUCT_TYPE, PRODUCT_ID, STOCK_ID, STOCK_CODE, BOY, EN, DERINLIK, YON, PRODUCT_CODE_2, PRODUCT_NAME, 
                         DUEDATE, QUANTITY, PRICE, PRICE_OTHER, UNIT, UNIT_ID, TAX, NETTOTAL, PAY_METHOD, VIRTUAL_OFFER_ROW_CURRENCY, DELIVER_DATE, DELIVER_DEPT, DELIVER_LOCATION, DISCOUNT_1, 
                         DISCOUNT_2, DISCOUNT_3, DISCOUNT_4, DISCOUNT_5, DISCOUNT_6, DISCOUNT_7, DISCOUNT_8, DISCOUNT_9, DISCOUNT_10, DISCOUNT_COST, OTHER_MONEY, OTHER_MONEY_VALUE, LOT_NO, 
                         PRODUCT_NAME2, ROW_DISCOUNTTOTAL, EXTRA_PRICE_TOTAL, OTV_ORAN, OTVTOTAL, LIST_PRICE, KARMA_PRODUCT_ID, WRK_ROW_ID, WRK_ROW_RELATION_ID, DELIVER_AMOUNT, IS_STANDART, 
                         COST, EZGI_ID, PURCHASE_PRICE, PURCHASE_PRICE_MONEY, COST_PRICE, COST_PRICE_MONEY,P_PURCHASE_PRICE, P_PURCHASE_PRICE_MONEY, P_DISCOUNT_1, P_DISCOUNT_2, P_DISCOUNT_3, 
                         P_DISCOUNT_4, P_DISCOUNT_5
                 	)
				SELECT        
                		#MAX_ID.IDENTITYCOL#, VIRTUAL_OFFER_ID, VIRTUAL_OFFER_ROW_ID, PRODUCT_TYPE, PRODUCT_ID, STOCK_ID, STOCK_CODE, BOY, EN, DERINLIK, YON, PRODUCT_CODE_2, PRODUCT_NAME, DUEDATE, QUANTITY, 
                         PRICE, PRICE_OTHER, UNIT, UNIT_ID, TAX, NETTOTAL, PAY_METHOD, VIRTUAL_OFFER_ROW_CURRENCY, DELIVER_DATE, DELIVER_DEPT, DELIVER_LOCATION, DISCOUNT_1, DISCOUNT_2, DISCOUNT_3, 
                         DISCOUNT_4, DISCOUNT_5, DISCOUNT_6, DISCOUNT_7, DISCOUNT_8, DISCOUNT_9, DISCOUNT_10, DISCOUNT_COST, OTHER_MONEY, OTHER_MONEY_VALUE, LOT_NO, PRODUCT_NAME2, 
                         ROW_DISCOUNTTOTAL, EXTRA_PRICE_TOTAL, OTV_ORAN, OTVTOTAL, LIST_PRICE, KARMA_PRODUCT_ID, WRK_ROW_ID, WRK_ROW_RELATION_ID, DELIVER_AMOUNT, IS_STANDART, COST, EZGI_ID, 
                         PURCHASE_PRICE, PURCHASE_PRICE_MONEY, COST_PRICE, COST_PRICE_MONEY,P_PURCHASE_PRICE, P_PURCHASE_PRICE_MONEY, P_DISCOUNT_1, P_DISCOUNT_2, P_DISCOUNT_3, P_DISCOUNT_4, 
                         P_DISCOUNT_5
				FROM            
               		EZGI_VIRTUAL_OFFER_ROW
              	WHERE 
                	VIRTUAL_OFFER_ID = #attributes.VIRTUAL_OFFER_id#
            </cfquery>
            <cfquery name="add_money_history" datasource="#dsn3#">
            	INSERT INTO 
                	EZGI_VIRTUAL_OFFER_MONEY_HISTORY
                  	(
                    	HISTORY_ACTION_ID, MONEY_TYPE, ACTION_ID, ACTION_MONEY_ID, RATE2, RATE1, IS_SELECTED
                   	)
				SELECT        
                	#MAX_ID.IDENTITYCOL#, MONEY_TYPE, ACTION_ID, ACTION_MONEY_ID, RATE2, RATE1, IS_SELECTED
				FROM            
                	EZGI_VIRTUAL_OFFER_MONEY
               	WHERE 
                	 ACTION_ID = #attributes.VIRTUAL_OFFER_id#
            </cfquery>
            <cfquery name="upd_virtual_offer" datasource="#dsn3#">
            	UPDATE
                    EZGI_VIRTUAL_OFFER
              	SET
                    VIRTUAL_OFFER_DETAIL= <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>, 
                    VIRTUAL_OFFER_DATE= <cfif len(attributes.VIRTUAL_OFFER_date)>#attributes.VIRTUAL_OFFER_date#<cfelse>NULL</cfif>, 
                    VIRTUAL_OFFER_STAGE= <cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
                    VIRTUAL_OFFER_STATUS= <cfif isdefined('attributes.VIRTUAL_OFFER_status') and len(attributes.VIRTUAL_OFFER_status)>1<cfelse>0</cfif>,
                    VIRTUAL_OFFER_HEAD= <cfif len(attributes.VIRTUAL_OFFER_head)>'#attributes.VIRTUAL_OFFER_head#'<cfelse>NULL</cfif>, 
                    PURCHASE_SALES= 0, 
                    <cfif len(attributes.company_id)>
                    	COMPANY_ID= #attributes.company_id#,
                    	PARTNER_ID= #attributes.partner_id#,
                        CONSUMER_ID= NULL,
                 	<cfelseif len(attributes.consumer_id)>
                       	COMPANY_ID= NULL,
                    	PARTNER_ID= NULL,
                       	CONSUMER_ID= #attributes.consumer_id#,
                   	</cfif>
                    PRIORITY_ID= #attributes.priority_id#, 
                    MEMBER_TYPE= '#attributes.member_type#', 
                    PROJECT_ID= <cfif len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>, 
                    DELIVERDATE= <cfif len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>, 
 		    		FINISHDATE = <cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,	
                    DUE_DATE= <cfif len(attributes.BASKET_DUE_VALUE_DATE_)>#attributes.BASKET_DUE_VALUE_DATE_#<cfelse>NULL</cfif>,
                    DUE_VALUE= <cfif len(attributes.basket_due_value)>#attributes.basket_due_value#<cfelse>NULL</cfif>,
                    REF_NO= <cfif len(attributes.Ref_No)>'#attributes.Ref_No#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.sub_total_brut') and len(attributes.sub_total_brut)>
                    	GROSSTOTAL = #FilterNum(attributes.sub_total_brut,2)#,
                   	</cfif>
                  	<cfif isdefined('attributes.sub_total_end') and len(attributes.sub_total_end)>
                    	NETTOTAL = #FilterNum(attributes.sub_total_end,2)#,
                   	</cfif>
                 	<cfif isdefined('attributes.sub_total_discount') and len(attributes.sub_total_discount)>
                    	DISCOUNTTOTAL = #FilterNum(attributes.sub_total_discount,2)#,
                  	</cfif>
                 	<cfif isdefined('attributes.sub_total_tax') and len(attributes.sub_total_tax)>
                    	TAXTOTAL = #FilterNum(attributes.sub_total_tax,2)#,
                  	</cfif>
                    <cfif isdefined('attributes.sub_total_discount_ext') and len(attributes.sub_total_discount_ext)>
                    	SUB_DISCOUNTTOTAL = #FilterNum(attributes.sub_total_discount_ext,2)#,
                  	</cfif>
                    BRANCH_ID = <cfif len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
                  	PARTNER_COMPANY_ID = <cfif len(attributes.sales_member)>#attributes.sales_member_id#<cfelse>NULL</cfif>,
                    SALES_COMPANY_ID = <cfif len(attributes.sales_member)>#get_company_id.COMPANY_ID#<cfelse>NULL</cfif>,
                    PAYMETHOD = <cfif len(attributes.paymethod) and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
                    SHIP_METHOD = <cfif len(attributes.ship_method_name)>#attributes.ship_method_id#<cfelse>NULL</cfif>,
                    UPDATE_DATE= #now()#, 
                    UPDATE_EMP= #session.ep.userid#,
                    UPDATE_IP = '#cgi.remote_addr#'
				WHERE 
                	VIRTUAL_OFFER_ID = #attributes.VIRTUAL_OFFER_id#
       		</cfquery>
            <cfquery name="del_VIRTUAL_OFFER_row" datasource="#dsn3#">
            	DELETE FROM EZGI_VIRTUAL_OFFER_ROW WHERE VIRTUAL_OFFER_ID = #attributes.VIRTUAL_OFFER_id#
            </cfquery>
            <cfloop from="1" to="#attributes.record_num#" index="i">
            	<cfif isdefined('attributes.row_kontrol#i#') and Evaluate('attributes.row_kontrol#i#') gt 0>
                    <cfquery name="add_VIRTUAL_OFFER_row" datasource="#dsn3#">
                    	INSERT INTO 
                    		EZGI_VIRTUAL_OFFER_ROW
                         	(
                            	VIRTUAL_OFFER_ID, 
                                IS_STANDART, 
                                PRODUCT_ID,
                                STOCK_ID,
                                PRODUCT_NAME, 
                                STOCK_CODE,
                                QUANTITY, 
                                UNIT, 
                                VIRTUAL_OFFER_ROW_CURRENCY, 
                                PRODUCT_NAME2,
                                EZGI_ID,
                                PRICE,
                                OTHER_MONEY,
                                DISCOUNT_1,
                                DISCOUNT_2,
                                DISCOUNT_3,
                                DISCOUNT_COST,
                                COST,
                                BOY,
                                EN,
                                DERINLIK,
								YON,
                                PRODUCT_CODE_2,
                                TAX,
                                WRK_ROW_RELATION_ID,
                            	PURCHASE_PRICE, 
                                PURCHASE_PRICE_MONEY, 
                                COST_PRICE, 
                                COST_PRICE_MONEY,
                                P_PURCHASE_PRICE, 
                                P_PURCHASE_PRICE_MONEY, 
                                P_DISCOUNT_1, 
                                P_DISCOUNT_2, 
                                P_DISCOUNT_3, 
                                P_DISCOUNT_4, 
                                P_DISCOUNT_5
                         	)
						VALUES        
                        	(
                            	#attributes.VIRTUAL_OFFER_id#,
                            	1,
                            	<cfif len(Evaluate('attributes.product_id#i#'))>#Evaluate('attributes.product_id#i#')#<cfelse>NULL</cfif>,
                                <cfif len(Evaluate('attributes.stock_id#i#'))>#Evaluate('attributes.stock_id#i#')#<cfelse>NULL</cfif>,
                                <cfif len(Evaluate('attributes.product_name#i#'))>'#Evaluate('attributes.product_name#i#')#'<cfelse>NULL</cfif>,
                                <cfif len(Evaluate('attributes.product_code#i#'))>'#Evaluate('attributes.product_code#i#')#'<cfelse>NULL</cfif>,
                                #FilterNum(Evaluate('attributes.quantity#i#'),2)#,
                                '#Evaluate('attributes.main_unit#i#')#',
                                #Evaluate('attributes.currency#i#')#,
                                '#Evaluate('attributes.detail#i#')#',
                                <cfif isdefined('attributes.ezgi_id#i#')>
                                	#Evaluate('attributes.ezgi_id#i#')#,
                              	<cfelse>
                                	NULL,
                                </cfif>
                                #FilterNum(Evaluate('attributes.sales_price#i#'),2)#,
                                '#Evaluate('attributes.money#i#')#',
                            	#FilterNum(Evaluate('attributes.discount1_#i#'),2)#,
                                #FilterNum(Evaluate('attributes.discount2_#i#'),2)#,
                                #FilterNum(Evaluate('attributes.discount3_#i#'),2)#,
                                #FilterNum(Evaluate('attributes.discount_tut#i#'),2)#,
                                #FilterNum(Evaluate('attributes.cost#i#'),2)#,
                                #Evaluate('attributes.boy#i#')#,
                                #Evaluate('attributes.en#i#')#,
                                #Evaluate('attributes.derinlik#i#')#,
								<cfif isdefined('attributes.yon#i#') and len(Evaluate('attributes.yon#i#'))>#Evaluate('attributes.yon#i#')#<cfelse>NULL</cfif>,
                                '#Evaluate('attributes.special_code#i#')#',
                                #Evaluate('attributes.tax#i#')#,
                                <cfif isdefined('attributes.WRK_ROW_RELATION_ID_#i#') and len(Evaluate('attributes.WRK_ROW_RELATION_ID_#i#'))>'#Evaluate('attributes.WRK_ROW_RELATION_ID_#i#')#'<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.purchase_price#i#')>#FilterNum(Evaluate('attributes.purchase_price#i#'),2)#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.purchase_price_money#i#')>'#Evaluate('attributes.purchase_price_money#i#')#'<cfelse>'#session.ep.money#'</cfif>,
                                <cfif isdefined('attributes.cost_price#i#')>#FilterNum(Evaluate('attributes.cost_price#i#'),2)#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.cost_price_money#i#')>'#Evaluate('attributes.cost_price_money#i#')#'<cfelse>'#session.ep.money#'</cfif>,
                                <cfif isdefined('attributes.p_purchase_price#i#') and len(Evaluate('attributes.p_purchase_price#i#'))>#FilterNum(Evaluate('attributes.p_purchase_price#i#'),2)#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.p_purchase_price_money#i#') and len(Evaluate('attributes.p_purchase_price_money#i#'))>'#Evaluate('attributes.p_purchase_price_money#i#')#'<cfelse>'#session.ep.money#'</cfif>,
                                <cfif isdefined('attributes.p_discount_1_#i#') and len(Evaluate('attributes.p_discount_1_#i#'))>#FilterNum(Evaluate('attributes.p_discount_1_#i#'),2)#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.p_discount_2_#i#') and len(Evaluate('attributes.p_discount_2_#i#'))>#FilterNum(Evaluate('attributes.p_discount_2_#i#'),2)#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.p_discount_3_#i#') and len(Evaluate('attributes.p_discount_3_#i#'))>#FilterNum(Evaluate('attributes.p_discount_3_#i#'),2)#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.p_discount_4_#i#') and len(Evaluate('attributes.p_discount_4_#i#'))>#FilterNum(Evaluate('attributes.p_discount_4_#i#'),2)#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.p_discount_5_#i#') and len(Evaluate('attributes.p_discount_5_#i#'))>#FilterNum(Evaluate('attributes.p_discount_5_#i#'),2)#<cfelse>0</cfif>
                            )
                    </cfquery>
                    <cfquery name="upd_ezgi_id" datasource="#dsn3#">
                    	UPDATE EZGI_VIRTUAL_OFFER_ROW SET EZGI_ID = VIRTUAL_OFFER_ROW_ID WHERE VIRTUAL_OFFER_ID = #attributes.VIRTUAL_OFFER_id# AND EZGI_ID IS NULL
                    </cfquery>
                    <cfif isdefined('attributes.money_recordcount')>
                        <cfquery name="del_VIRTUAL_OFFER_row" datasource="#dsn3#">
                            DELETE FROM EZGI_VIRTUAL_OFFER_MONEY WHERE ACTION_ID = #attributes.VIRTUAL_OFFER_id#
                        </cfquery>
                        <cfloop from="1" to="#attributes.money_recordcount#" index="i">
                            <cfif isdefined('attributes.MONEY_TYPE_#i#')>
                                <cfquery name="add_money" datasource="#dsn3#">
                                    INSERT INTO 
                                        EZGI_VIRTUAL_OFFER_MONEY
                                        (
                                            MONEY_TYPE, 
                                            ACTION_ID, 
                                            RATE2, 
                                            RATE1, 
                                            IS_SELECTED
                                        )
                                    VALUES        
                                        (
                                            '#Evaluate("attributes.MONEY_TYPE_#i#")#',
                                            #attributes.VIRTUAL_OFFER_id#,
                                            #Filternum(Evaluate('attributes.MONEY_#i#'))#,
                                            1,
                                            <cfif attributes.basket eq Evaluate('attributes.MONEY_TYPE_#i#')>1<cfelse>0</cfif>
                                        )
                                </cfquery>	
                            </cfif>
                        </cfloop>
                  	</cfif>
            	</cfif>
            </cfloop>
       	<cfelse>
        	Kaydedilecek Satır Bulunamadı.
        	<cfabort>
        </cfif>
    </cftransaction>
</cflock>
<cf_workcube_process is_upd='1' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='EZGI_VIRTUAL_OFFER'
		action_column='VIRTUAL_OFFER_ID'
		action_id='#attributes.virtual_offer_id#'
		action_page='#request.self#?fuseaction=prod.upd_ezgi_virtual_offer&virtual_offer_id=#attributes.virtual_offer_id#' 
		warning_description='Sanal Teklif'>
<cflocation url="#request.self#?fuseaction=prod.upd_ezgi_virtual_offer&virtual_offer_id=#attributes.virtual_offer_id#" addtoken="No">