<cfdump var="#attributes#"><cfabort>
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="get_gen_paper" datasource="#dsn3#">
			SELECT 
        	    * 
            FROM 
    	        GENERAL_PAPERS 
            WHERE 
	            ZONE_TYPE = 0 AND PAPER_TYPE = 0
		</cfquery>
		<cfset paper_code = evaluate('get_gen_paper.OFFER_NO')>
		<cfset paper_number = evaluate('get_gen_paper.OFFER_NUMBER') +1>
		<cfset paper_full = '#paper_code#-#paper_number#'>
		<cfquery name="SET_MAX_PAPER" datasource="#dsn3#">
			UPDATE
				GENERAL_PAPERS
			SET
				OFFER_NUMBER = OFFER_NUMBER+1
			WHERE
				PAPER_TYPE = 0 AND
				ZONE_TYPE = 0
		</cfquery>
	</cftransaction>
</cflock>
<cf_date tarih="attributes.virtual_offer_date">
<cf_date tarih="attributes.deliverdate">
<cf_date tarih="attributes.finishdate">
<cfif len(attributes.BASKET_DUE_VALUE_DATE_)>
	<cf_date tarih="attributes.BASKET_DUE_VALUE_DATE_">
</cfif>
<cflock name="#CREATEUUID()#" timeout="90">
    <cftransaction>
        <cfif attributes.record_num gt 0>
            <cfquery name="add_virtual_offer" datasource="#dsn3#">
                INSERT INTO 
                    EZGI_VIRTUAL_OFFER
                    (
                        VIRTUAL_OFFER_DETAIL, 
                        VIRTUAL_OFFER_NUMBER, 
                        VIRTUAL_OFFER_DATE, 
                        VIRTUAL_OFFER_STAGE, 
                        VIRTUAL_OFFER_STATUS,
                        VIRTUAL_OFFER_HEAD, 
                        PURCHASE_SALES,
                        <cfif len(attributes.company_id)> 
                            COMPANY_ID, 
                            PARTNER_ID, 
                        <cfelseif len(attributes.consumer_id)>
                        	CONSUMER_ID,
                        </cfif>
                        PRIORITY_ID, 
                        MEMBER_TYPE, 
                        PROJECT_ID, 
                        DELIVERDATE, 
			FINISHDATE,
                        DUE_DATE, 
                        DUE_VALUE,
                        REF_NO, 
                        GROSSTOTAL,
                        NETTOTAL,
                        DISCOUNTTOTAL,
                        SUB_DISCOUNTTOTAL,
                        BRANCH_ID,
                        PARTNER_COMPANY_ID,
                        RECORD_DATE, 
                        RECORD_EMP, 
                        RECORD_IP
                    )
                VALUES        
                    (
                        <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
                        '#paper_full#',
                        <cfif len(attributes.virtual_offer_date)>#attributes.virtual_offer_date#<cfelse>NULL</cfif>,
                        <cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
                        1,
                        <cfif len(attributes.virtual_offer_head)>'#attributes.virtual_offer_head#'<cfelse>NULL</cfif>,
                        0,
                        <cfif len(attributes.company_id)>
                            #attributes.company_id#,
                            #attributes.partner_id#,
                        <cfelseif len(attributes.consumer_id)>
                        	#attributes.consumer_id#,
                        </cfif>
                        #attributes.priority_id#,
                        '#attributes.member_type#',
                        <cfif len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
                        <cfif len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>,
			<cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
                        <cfif len(attributes.BASKET_DUE_VALUE_DATE_)>#attributes.BASKET_DUE_VALUE_DATE_#<cfelse>NULL</cfif>,
                        <cfif len(attributes.basket_due_value)>#attributes.basket_due_value#<cfelse>NULL</cfif>,
                        <cfif len(attributes.Ref_No)>'#attributes.Ref_No#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.sub_total_brut)>#FilterNum(attributes.sub_total_brut,2)#<cfelse>0</cfif>,
                        <cfif len(attributes.sub_total_end)>#FilterNum(attributes.sub_total_end,2)#<cfelse>0</cfif>,
                        <cfif len(attributes.sub_total_discount)>#FilterNum(attributes.sub_total_discount,2)#<cfelse>0</cfif>,
                        <cfif len(attributes.sub_total_discount_ext)>#FilterNum(attributes.sub_total_discount_ext,2)#<cfelse>0</cfif>,
                        <cfif len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
                        <cfif len(attributes.sales_company_id)>#attributes.sales_company_id#<cfelse>NULL</cfif>,
                        #now()#,
                        #session.ep.userid#,
                        '#cgi.remote_addr#'
                 	)
            </cfquery>
            <cfquery name="get_max_id" datasource="#dsn3#">
            	SELECT MAX(VIRTUAL_OFFER_ID) AS MAX_ID FROM EZGI_VIRTUAL_OFFER
            </cfquery>
            <cfloop from="1" to="#attributes.record_num#" index="i">
                <cfif isdefined('row_kontrol#i#') and Evaluate('row_kontrol#i#') gt 0>
                    <cfquery name="add_virtual_offer_row" datasource="#dsn3#">
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
                                PRICE,
                                OTHER_MONEY,
                                DISCOUNT_1,
                                BOY,
                                EN,
                                DERINLIK,
                                PRODUCT_CODE_2,
                                TAX
                         	)
						VALUES        
                        	(
                            	#get_max_id.MAX_ID#,
                            	1,
                            	<cfif len(Evaluate('attributes.product_id#i#'))>#Evaluate('attributes.product_id#i#')#<cfelse>NULL</cfif>,
                                <cfif len(Evaluate('attributes.stock_id#i#'))>#Evaluate('attributes.stock_id#i#')#<cfelse>NULL</cfif>,
                                <cfif len(Evaluate('attributes.product_name#i#'))>'#Evaluate('attributes.product_name#i#')#'<cfelse>NULL</cfif>,
                                <cfif len(Evaluate('attributes.product_code#i#'))>'#Evaluate('attributes.product_code#i#')#'<cfelse>NULL</cfif>,
                                #FilterNum(Evaluate('attributes.quantity#i#'),2)#,
                                '#Evaluate('attributes.main_unit#i#')#',
                                1,
                                '#Evaluate('attributes.detail#i#')#',
                                #FilterNum(Evaluate('attributes.sales_price#i#'),2)#,
                                '#Evaluate('attributes.money#i#')#',
                            	#FilterNum(Evaluate('attributes.discount#i#'),2)#,
                                #Evaluate('attributes.boy#i#')#,
                                #Evaluate('attributes.en#i#')#,
                                #Evaluate('attributes.derinlik#i#')#,
                                '#Evaluate('attributes.special_code#i#')#',
                                #Evaluate('attributes.tax#i#')#
                            )
                    </cfquery>
                    <cfquery name="upd_ezgi_id" datasource="#dsn3#">
                        UPDATE EZGI_VIRTUAL_OFFER_ROW SET EZGI_ID = VIRTUAL_OFFER_ROW_ID WHERE VIRTUAL_OFFER_ID = #get_max_id.MAX_ID#
                    </cfquery>
                </cfif>
            </cfloop>
            <cfloop from="1" to="#attributes.money_recordcount#" index="i">
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
                         	#get_max_id.MAX_ID#,
                        	#Filternum(Evaluate('attributes.MONEY_#i#'))#,
                        	1,
                        	<cfif attributes.basket eq Evaluate('attributes.MONEY_TYPE_#i#')>1<cfelse>0</cfif>
                 		)
              	</cfquery>	
           	</cfloop>
        <cfelse>
        	Kaydedilecek Satır Bulunamadı.
        	<cfabort>
        </cfif>
    </cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=prod.upd_ezgi_virtual_offer&virtual_offer_id=#get_max_id.MAX_ID#" addtoken="No">