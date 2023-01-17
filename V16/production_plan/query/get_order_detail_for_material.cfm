<cfif ListLen(attributes.production_order_no,',')>
	<cfset p_o_no_count_ = listlen(attributes.production_order_no)>
	<cfset list_ = 750>
	<cfset p_o_no_list_count_ = ceiling(p_o_no_count_ / list_)>
	<cfset p_o_no_array_ = listtoarray(attributes.production_order_no)>
	
	<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
		<cfset 'p_no_list_#ccc#' = ''>
	</cfloop>
	<cfloop from="1" to="#p_o_no_count_#" index="xxx">
		<cfset sira_ = ceiling(xxx / list_)>
		<cfset 'p_no_list_#sira_#' = listappend(evaluate("p_no_list_#sira_#"),"'#p_o_no_array_[xxx]#'")>
	</cfloop>
    <cfquery name="ins_order_no_attributes" datasource="#dsn#">
		IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####attrordernotmp_#session.ep.userid#')
		DROP TABLE ####attrordernotmp_#session.ep.userid#
		
		CREATE TABLE ####attrordernotmp_#session.ep.userid#
		(
			order_no nvarchar(150)  COLLATE Turkish_CI_AS
		)
	</cfquery>
	<cfset baslangic= 1 >
	<cfset bitis = 2000>
	<cfloop from="1" to="#ceiling(listlen(attributes.production_order_no)/2000)#" index="ccc">
		<cfquery name="ins_order_no1" datasource="#dsn#">
			<cfloop from="#baslangic#" to="#bitis#" index="xxx">
				<cfif xxx lte listlen(attributes.production_order_no) >
					INSERT INTO ####attrordernotmp_#session.ep.userid# (ORDER_NO)
					values ('#listgetat(attributes.production_order_no,xxx)#')
				</cfif>
			</CFLOOP>
		</cfquery>
		<cfset baslangic = baslangic + 2000>
		<cfset bitis = bitis + 2000> 
	</cfloop> 
    
</cfif>

<cfquery name="check_table" datasource="#dsn3#">
    IF EXISTS (select * from tempdb.sys.tables where name='####get_metarials_get_order_#session.ep.userid#')
        DROP TABLE ####get_metarials_get_order_#session.ep.userid#
</cfquery>
<!---<cfquery name="check_table" datasource="#dsn3#">
    IF OBJECT_ID('tempdb.####get_metarials_get_order_#session.ep.userid#') IS NOT NULL
    BEGIN
      DROP TABLE ####get_metarials_get_order_#session.ep.userid#;
    END
</cfquery> --->

<cfif attributes.list_type eq 1 or (isdefined("attributes.list_type") and not len(attributes.list_type))><!--- uretim emirlerinden (spec) --->
	<cfquery name="del_row" datasource="#dsn#">
    	DELETE FROM TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_SPECT_MAIN_ID' AND RECORD_EMP = #session.ep.userid#
    </cfquery>
	<cfquery name="get_metarials" datasource="#dsn3#">
		SELECT
			SUM(AMOUNT) AMOUNT,
			PRODUCT_ID,
			STOCK_ID,
           SPECT_MAIN_NAME,
			STOCK_CODE,
			PRODUCT_NAME,
			UNIT,
			ISNULL(SPECT_MAIN_ID,1) SPECT_MAIN_ID
            <cfif isdefined('is_line_number') and is_line_number eq 1>
                ,LINE_NUMBER
            </cfif>
		INTO ####get_metarials_get_order_#session.ep.userid#
        FROM
		(
			SELECT
				S.PRODUCT_ID, 
				S.STOCK_ID, 
                 ISNULL((SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID),'') SPECT_MAIN_NAME,
				S.STOCK_CODE, 
				S.PRODUCT_NAME+ ' - ' + ISNULL(S.PROPERTY,'') PRODUCT_NAME,
				PU.ADD_UNIT UNIT,
                POS.LINE_NUMBER,
                <cfif isdefined('is_materials_frm_remain_amount') and is_materials_frm_remain_amount eq 1>
                	(POS.AMOUNT - ISNULL((SELECT SUM(PORR.AMOUNT) FROM PRODUCTION_ORDER_RESULTS POR,PRODUCTION_ORDER_RESULTS_ROW PORR WHERE POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND POR.IS_STOCK_FIS = 1 AND POS.STOCK_ID = PORR.STOCK_ID AND PO.P_ORDER_ID = POR.P_ORDER_ID AND PORR.TYPE = 2),0)) AS AMOUNT,
				<cfelse>
                	POS.AMOUNT,
                </cfif>
				POS.SPECT_MAIN_ID
			FROM
				PRODUCTION_ORDERS PO,
				PRODUCTION_ORDERS_STOCKS POS,
				STOCKS S,
				PRODUCT_UNIT PU
			WHERE
				S.STOCK_ID = POS.STOCK_ID AND 
				S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND 
				PO.P_ORDER_ID = POS.P_ORDER_ID AND
				POS.TYPE IN (2,3) AND    <!---firelerinde hesap edilmesi için düzenlendi--->
				PO.SPEC_MAIN_ID IS NOT NULL AND
				PO.START_DATE >= #attributes.start_date# AND 
				PO.START_DATE < #DATEADD("d",1,attributes.finish_date)#
			<cfif ListLen(attributes.demand_no,',') gte 1>
				AND
				(
				<cfset d_sayac = 0>
				<cfloop list="#attributes.demand_no#" delimiters="," index="p_de_no">
				<cfset d_sayac = d_sayac+1>
				PO.DEMAND_NO = '#p_de_no#' <cfif ListLen(attributes.demand_no,',') gt d_sayac>OR </cfif>
				</cfloop>
				)
			</cfif>
			<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
				AND PO.P_ORDER_ID IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
			</cfif>
			<cfif ListLen(attributes.production_order_no,',')>
				AND
				(
					<cfset c_ = 0>
					<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
						<cfset c_ = c_ + 1>
						PO.P_ORDER_NO IN (#evaluate("p_no_list_#ccc#")#) <cfif c_ neq p_o_no_list_count_>OR</cfif>
					</cfloop>
				)
			</cfif>
			<cfif ListLen(attributes.product_code)>
				<cfset p_cod_count = 0>
				AND	
				(
				<cfloop list="#attributes.product_code#" delimiters="," index="p_code">
					<cfset p_cod_count =p_cod_count+1>
					S.PRODUCT_CODE LIKE '#p_code#.%' <cfif ListLen(attributes.product_code,',') gt p_cod_count>OR</cfif>
				</cfloop>
				)
			</cfif>	
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
				AND S.COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
				AND S.PRODUCT_MANAGER = #attributes.pos_code#
			</cfif>
			<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>
				AND S.PRODUCT_ID = #attributes.product_id#
			</cfif>
			<cfif isdefined('attributes.sort_type') and len(attributes.sort_type)>
				AND  S.IS_PRODUCTION = #attributes.sort_type#
			</cfif>
            <cfif isdefined('attributes.station_id') and len(attributes.station_id)>
				AND PO.STATION_ID = #attributes.station_id#
			</cfif>
		)T1
		GROUP BY
			PRODUCT_ID, 
			STOCK_ID,
            SPECT_MAIN_NAME,
			STOCK_CODE,
			PRODUCT_NAME,
			UNIT,
			SPECT_MAIN_ID
            <cfif isdefined('is_line_number') and is_line_number eq 1>
                ,LINE_NUMBER
            </cfif>
		ORDER BY
            <cfif isdefined('is_line_number') and is_line_number eq 1>
                LINE_NUMBER
            <cfelse>
                STOCK_CODE,
                PRODUCT_NAME
            </cfif>
	</cfquery>
    
<cfelseif isdefined("attributes.list_type") and attributes.list_type eq 4> <!--- uretim emirlerinden (alternatifli) --->
	<cfquery name="del_row" datasource="#dsn#">
    	DELETE FROM TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_SPECT_MAIN_ID' AND RECORD_EMP = #session.ep.userid#
    </cfquery>
	<cfquery name="get_metarials" datasource="#dsn3#">
		SELECT
			SUM(AMOUNT) AMOUNT,
			PRODUCT_ID,
			STOCK_ID,
            SPECT_MAIN_NAME,
			STOCK_CODE,
			PRODUCT_NAME,
			UNIT,
			ISNULL(SPECT_MAIN_ID,1) SPECT_MAIN_ID
            <cfif isdefined('is_line_number') and is_line_number eq 1>
                ,LINE_NUMBER
            </cfif>
			INTO ####get_metarials_get_order_#session.ep.userid#
        FROM
		(
			SELECT
				S.PRODUCT_ID, 
				S.STOCK_ID, 
                ISNULL((SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID),'') SPECT_MAIN_NAME,
				S.STOCK_CODE, 
				S.PRODUCT_NAME+ ' - ' + ISNULL(S.PROPERTY,'') PRODUCT_NAME,
				PU.ADD_UNIT UNIT,
                POS.LINE_NUMBER,
				<cfif isdefined('is_materials_frm_remain_amount') and is_materials_frm_remain_amount eq 1>
                	(POS.AMOUNT - ISNULL((SELECT SUM(PORR.AMOUNT) FROM PRODUCTION_ORDER_RESULTS POR,PRODUCTION_ORDER_RESULTS_ROW PORR WHERE POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND POR.IS_STOCK_FIS = 1 AND POS.STOCK_ID = PORR.STOCK_ID AND PO.P_ORDER_ID = POR.P_ORDER_ID AND PORR.TYPE = 2),0)) AS AMOUNT,
				<cfelse>
                	POS.AMOUNT,
                </cfif>
				POS.SPECT_MAIN_ID
			FROM
				PRODUCTION_ORDERS PO,
				PRODUCTION_ORDERS_STOCKS POS,
				STOCKS S,
				PRODUCT_UNIT PU
			WHERE
				S.STOCK_ID = POS.STOCK_ID AND 
				S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND 
				PO.P_ORDER_ID = POS.P_ORDER_ID AND
				POS.TYPE = 2 AND
				PO.SPEC_MAIN_ID IS NOT NULL AND
				PO.START_DATE >= #attributes.start_date# AND 
				PO.START_DATE < #DATEADD("d",1,attributes.finish_date)#
			<cfif ListLen(attributes.demand_no,',') gte 1>
				AND
				(
				<cfset d_sayac = 0>
				<cfloop list="#attributes.demand_no#" delimiters="," index="p_de_no">
				<cfset d_sayac = d_sayac+1>
				PO.DEMAND_NO = '#p_de_no#' <cfif ListLen(attributes.demand_no,',') gt d_sayac>OR </cfif>
				</cfloop>
				)
			</cfif>
			<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
				AND PO.P_ORDER_ID IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
			</cfif>
			<cfif ListLen(attributes.production_order_no,',')>
				AND
				(
					<cfset c_ = 0>
					<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
						<cfset c_ = c_ + 1>
						PO.P_ORDER_NO IN (#evaluate("p_no_list_#ccc#")#) <cfif c_ neq p_o_no_list_count_>OR</cfif>
					</cfloop>
				)
			</cfif>
			<cfif ListLen(attributes.product_code)>
				<cfset p_cod_count = 0>
				AND	
				(
				<cfloop list="#attributes.product_code#" delimiters="," index="p_code">
					<cfset p_cod_count =p_cod_count+1>
					S.PRODUCT_CODE LIKE '#p_code#.%' <cfif ListLen(attributes.product_code,',') gt p_cod_count>OR</cfif>
				</cfloop>
				)
			</cfif>	
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
				AND S.COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
				AND S.PRODUCT_MANAGER = #attributes.pos_code#
			</cfif>
			<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>
				AND S.PRODUCT_ID = #attributes.product_id#
			</cfif>
			<cfif isdefined('attributes.sort_type') and len(attributes.sort_type)>
				AND  S.IS_PRODUCTION = #attributes.sort_type#
			</cfif>
            <cfif isdefined('attributes.station_id') and len(attributes.station_id)>
				AND PO.STATION_ID = #attributes.station_id#
			</cfif>
		)T1
		GROUP BY
			PRODUCT_ID,
			STOCK_ID,
            SPECT_MAIN_NAME,
			STOCK_CODE,
			PRODUCT_NAME,
			UNIT,
			SPECT_MAIN_ID
            <cfif isdefined('is_line_number') and is_line_number eq 1>
                ,LINE_NUMBER
            </cfif>
		ORDER BY
			<cfif isdefined('is_line_number') and is_line_number eq 1>
                LINE_NUMBER
            <cfelse>
                STOCK_CODE,
                PRODUCT_NAME
            </cfif>
	</cfquery>
 
<cfelse><!--- uretim emirlerinden (urun agaci) --->
	<cfquery name="get_metarials" datasource="#dsn3#">
		SELECT
			S.PRODUCT_ID,
			S.STOCK_ID, 
            ISNULL((SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID),'') SPECT_MAIN_NAME,
			S.STOCK_CODE, 
			S.PRODUCT_NAME+ ' - ' + ISNULL(S.PROPERTY,'') PRODUCT_NAME,
			PU.ADD_UNIT UNIT,
			SUM((PO.QUANTITY*SMR.AMOUNT)) AS AMOUNT,
            ISNULL(SMR.SPECT_MAIN_ID,1) SPECT_MAIN_ID,
			(SELECT PRICE FROM TEXTILE_SR_SUPLIERS WHERE  STOCK_ID = S.STOCK_ID AND PRODUCT_ID = S.PRODUCT_ID <cfif isdefined("attributes.req_id") and len(attributes.req_id)> and REQ_ID = #attributes.req_id#</cfif> ) AS LIST_PRICE
            <cfif isdefined('is_line_number') and is_line_number eq 1>
                ,SMR.LINE_NUMBER
            </cfif>
		INTO ####get_metarials_get_order_#session.ep.userid#
        FROM
			PRODUCTION_ORDERS PO,
			PRODUCT_TREE SMR,
			STOCKS S,
			PRODUCT_UNIT PU
		WHERE
			S.STOCK_ID = SMR.RELATED_ID AND 
			S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND 
			(PO.STOCK_ID = SMR.STOCK_ID OR PO.STOCK_ID = SMR.MAIN_STOCK_ID) AND
			SMR.RELATED_ID IS NOT NULL AND
			PO.SPEC_MAIN_ID IS NOT NULL AND
			PO.START_DATE >= #attributes.start_date# AND 
			PO.START_DATE < #DATEADD("d",1,attributes.finish_date)# AND
			SMR.IS_CONFIGURE = 0 AND
			SMR.QUESTION_ID IS NULL
		<cfif ListLen(attributes.demand_no,',') gte 1>
			AND
			(
			<cfset d_sayac = 0>
			<cfloop list="#attributes.demand_no#" delimiters="," index="p_de_no">
			<cfset d_sayac = d_sayac+1>
			PO.DEMAND_NO = '#p_de_no#' <cfif ListLen(attributes.demand_no,',') gt d_sayac>OR </cfif>
			</cfloop>
			)
		</cfif>
		<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
			AND PO.P_ORDER_ID IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
		</cfif>
		<cfif ListLen(attributes.production_order_no,',')>
			AND
			(
				<cfset c_ = 0>
				<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
					<cfset c_ = c_ + 1>
					PO.P_ORDER_NO IN (#evaluate("p_no_list_#ccc#")#) <cfif c_ neq p_o_no_list_count_>OR</cfif>
				</cfloop>
			)
		</cfif>
		<cfif ListLen(attributes.product_code)>
			<cfset p_cod_count = 0>
			AND	
			(
			<cfloop list="#attributes.product_code#" delimiters="," index="p_code">
				<cfset p_cod_count =p_cod_count+1>
				S.PRODUCT_CODE LIKE '#p_code#.%' <cfif ListLen(attributes.product_code,',') gt p_cod_count>OR</cfif>
			</cfloop>
			)
		</cfif>	
		<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
			AND S.COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
			AND S.PRODUCT_MANAGER = #attributes.pos_code#
		</cfif>
		<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>
			AND S.PRODUCT_ID = #attributes.product_id#
		</cfif>
		<cfif isdefined('attributes.sort_type') and len(attributes.sort_type)>
			AND  S.IS_PRODUCTION = #attributes.sort_type#
		</cfif>
        <cfif isdefined('attributes.station_id') and len(attributes.station_id)>
				AND PO.STATION_ID = #attributes.station_id#
			</cfif>
		GROUP BY
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.STOCK_CODE, 
			S.PRODUCT_NAME,
			PU.ADD_UNIT,
			ISNULL(S.PROPERTY,''),
			SMR.SPECT_MAIN_ID
            <cfif isdefined('is_line_number') and is_line_number eq 1>
                ,SMR.LINE_NUMBER
            </cfif>
		ORDER BY
            <cfif isdefined('is_line_number') and is_line_number eq 1>
                SMR.LINE_NUMBER
            <cfelse>
                S.STOCK_CODE,
                S.PRODUCT_NAME
            </cfif>
	</cfquery>	
</cfif>
<cfquery name="get_metarials" datasource="#dsn3#">
	SELECT * FROM ####get_metarials_get_order_#session.ep.userid# <cfif isdefined('is_line_number') and is_line_number eq 1>ORDER BY LINE_NUMBER</cfif>
</cfquery>

