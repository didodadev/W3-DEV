<cfquery name="GET_LIST_INTERNALDEMAND" datasource="#dsn3#">
	SELECT
		<cfif isdefined('attributes.list_type') and attributes.list_type eq 1>
			I_ROW.STOCK_ID,
			I_ROW.PRODUCT_ID,
			S.STOCK_CODE,
			S.COMPANY_ID,
			S.PRODUCT_CODE,
			S.PRODUCT_MANAGER,
			ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = I_ROW.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
			I_ROW.I_ROW_ID AS ACTION_ROW_ID,
			I_ROW.UNIT,
			I_ROW.PRODUCT_NAME,
			I_ROW.QUANTITY,
			ISNULL(I_ROW.DELIVER_DATE,I.TARGET_DATE) DELIVER_DATE,
			I_ROW.SPECT_VAR_NAME,
			ISNULL(I_ROW.DELIVER_DEPT,I.DEPARTMENT_IN) ROW_DEPT,
			ISNULL(I_ROW.DELIVER_LOCATION,I.LOCATION_IN) ROW_LOC,
			I_ROW.BASKET_EXTRA_INFO_ID,
			I_ROW.SELECT_INFO_EXTRA,
			I_ROW.DETAIL_INFO_EXTRA,
            <cfif isdefined("x_to_position") and  x_to_position eq 1>
            	E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME NAME,
            </cfif>
		<cfelse>
			I.DEPARTMENT_IN ROW_DEPT,
			I.LOCATION_IN ROW_LOC,
            I.DEPARTMENT_OUT,
            I.LOCATION_OUT,
		</cfif>
		I.INTERNAL_ID AS ACTION_ID,
        (SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = I.PROJECT_ID_OUT) PROJECT_HEAD_OUT,
        (
        	SELECT 
            	D.DEPARTMENT_HEAD  + '-' +  SL.COMMENT
        	FROM 
            	#dsn_alias#.STOCKS_LOCATION SL,
                #dsn_alias#.DEPARTMENT D
            WHERE  
            	D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
                SL.LOCATION_ID = I.LOCATION_OUT AND
                SL.DEPARTMENT_ID = I.DEPARTMENT_OUT
        ) SL_COMMENT,
		<cfif session.ep.our_company_info.workcube_sector is 'tersane'>
			(SELECT DPL_NO FROM DRAWING_PART WHERE DPL_ID = I.DPL_ID) DPL_NO,
		</cfif>
		I.*,
		PW.WORK_HEAD,
		PW.WORK_NO
		<cfif isdefined('attributes.list_type') and attributes.list_type eq 1>
			,(SELECT TOP 1 PCE.PRODUCT_ID FROM PRICE_CAT_EXCEPTIONS PCE,RELATED_CONTRACT RC WHERE RC.CONTRACT_ID = PCE.CONTRACT_ID AND RC.STATUS = 1 AND PCE.PRODUCT_ID = I_ROW.PRODUCT_ID) PRODUCT_ID_EXCEPTIONS
		</cfif>
	FROM 
		<cfif isdefined('attributes.list_type') and attributes.list_type eq 1>
        	STOCKS S,
            INTERNALDEMAND_ROW I_ROW
            <cfif isdefined("x_to_position") and  x_to_position eq 1>
				LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID=I_ROW.BASKET_EMPLOYEE_ID,
            <cfelse>
            	,
            </cfif>
		</cfif>
		INTERNALDEMAND I
		LEFT JOIN #dsn_alias#.PRO_WORKS PW ON I.WORK_ID = PW.WORK_ID
	WHERE	
		I.INTERNAL_ID > 0
		<cfif isdefined('attributes.list_type') and attributes.list_type eq 1>
			<cfif isdefined("x_basket_row_add_definition") and x_basket_row_add_definition eq 1 and len(attributes.add_explain)>
				AND I_ROW.BASKET_EXTRA_INFO_ID=#attributes.add_explain#
			</cfif>
			AND I.INTERNAL_ID = I_ROW.I_ID
			AND I_ROW.STOCK_ID = S.STOCK_ID
			<cfif isdefined('attributes.company_id') and len (attributes.company_id) and isdefined('attributes.company') and len (attributes.company)>
                AND S.COMPANY_ID = #attributes.company_id#
            </cfif>
            <cfif isdefined('attributes.product_id') and len(attributes.product_id) and isdefined('attributes.product_name') and len(attributes.product_name)>
                AND I_ROW.PRODUCT_ID=#attributes.product_id#
            </cfif>
            <cfif isdefined('attributes.position_code') and len(attributes.position_code) and isdefined('attributes.position_name') and len(attributes.position_name)>
                AND S.PRODUCT_MANAGER = #attributes.position_code#
            </cfif>
            <cfif isdefined ('attributes.prod_cat') and len(attributes.prod_cat)>
                AND S.PRODUCT_CODE LIKE '#attributes.prod_cat#.%'
            </cfif>	
		</cfif>
        <cfif isdefined("is_demand")>AND DEMAND_TYPE=#is_demand#</cfif>
		<cfif isdefined("attributes.from_employee_id") and len(attributes.from_employee_id) and isdefined('attributes.from_employee_name') and len(attributes.from_employee_name)>
			AND I.FROM_POSITION_CODE = #attributes.from_employee_id#
		</cfif>
		<cfif isdefined('attributes.list_type') and attributes.list_type eq 1 and len(attributes.from_employee_id) and len(attributes.from_employee_name) and x_basket_row_employee eq 1>
			AND I_ROW.BASKET_EMPLOYEE_ID = #attributes.from_employee_name#
		</cfif>
		<cfif isdefined("attributes.to_position_code") and len(attributes.to_position_code) and isdefined('attributes.to_position_name') and len(attributes.to_position_name)>
			AND I.TO_POSITION_CODE = #attributes.to_position_code#
		</cfif>
		<cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head) and isdefined('attributes.project_id_out') and len(attributes.project_id_out) and isdefined('attributes.project_head_out') and len(attributes.project_head_out)>
			AND (I.PROJECT_ID = #attributes.project_id# OR I.PROJECT_ID_OUT = #attributes.project_id_out#)
        <cfelseif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
   			AND I.PROJECT_ID = #attributes.project_id#
		<cfelseif isdefined('attributes.project_id_out') and len(attributes.project_id_out) and isdefined('attributes.project_head_out') and len(attributes.project_head_out)>
            AND I.PROJECT_ID_OUT = #attributes.project_id_out#
		</cfif>
		<cfif len(attributes.startdate)>
			AND I.RECORD_DATE >= #attributes.startdate#
		</cfif>
		<cfif len(attributes.finishdate)>
			AND I.RECORD_DATE < #dateadd('d',1,attributes.finishdate)#
		</cfif>
		<cfif isdefined('attributes.list_type') and attributes.list_type eq 1 and isdefined('attributes.deliverdate') and len(attributes.deliverdate)>
			AND DATEADD(DAY,-1*ISNULL((SELECT TOP 1 SS.PROVISION_TIME FROM STOCK_STRATEGY SS WHERE SS.PRODUCT_ID =I_ROW.PRODUCT_ID AND SS.STOCK_ID = I_ROW.STOCK_ID AND SS.DEPARTMENT_ID IS NULL),0),I.TARGET_DATE) <= #attributes.deliverdate#
		</cfif>
		<cfif len(attributes.priority) or len(attributes.priority)>
			AND I.PRIORITY =#attributes.priority#
		</cfif>
		<cfif is_demand eq 0>
			<cfif len(attributes.location_id) and len(department_id) and len(attributes.txt_departman)>
				AND I.LOCATION_OUT = #attributes.location_id#
				AND I.DEPARTMENT_OUT =  #attributes.department_id#
			</cfif>
		</cfif>
		<cfif len(attributes.location_in_id) and len(department_in_id) and len(attributes.department_in_txt)>
			<cfif isdefined('attributes.list_type') and attributes.list_type eq 1>
				AND ISNULL(I_ROW.DELIVER_DEPT,I.DEPARTMENT_IN) = #attributes.department_in_id#
				AND ISNULL(I_ROW.DELIVER_LOCATION,I.LOCATION_IN) =  #attributes.location_in_id#
			<cfelse>			
				AND I.LOCATION_IN = #attributes.location_in_id#
				AND I.DEPARTMENT_IN =  #attributes.department_in_id#
			</cfif>
		</cfif>
		<cfif len(attributes.internaldemand_stage)>
			AND I.INTERNALDEMAND_STAGE = #attributes.internaldemand_stage#
		<cfelseif ListLen(ListDeleteDuplicates(ValueList(get_process_type.process_row_id,',')))>
			<!--- Burada süreclerde varolanlar gelsin sadece  --->
			AND I.INTERNALDEMAND_STAGE IN (#ListDeleteDuplicates(Valuelist(get_process_type.process_row_id,','))#)
		</cfif>
		<cfif len(attributes.internaldemand_status)>
			AND I.INTERNALDEMAND_STATUS = #attributes.internaldemand_status#
		</cfif>
		<cfif len(attributes.is_active)>
            AND I.IS_ACTIVE = #attributes.is_active#
        </cfif>
		<cfif isdefined('attributes.work_id') and len(attributes.work_id) and isdefined('attributes.work_head') and len(attributes.work_head)>
			AND I.WORK_ID = #attributes.work_id#	
		</cfif>
		<cfif isdefined('attributes.dpl_id') and len(attributes.dpl_id) and isdefined('attributes.dpl_no') and len(attributes.dpl_no)>
			AND I.DPL_ID = #attributes.dpl_id#	
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND
			(
				I.DEPARTMENT_IN IN (SELECT DEPARTMENT_ID FROM #DSN_ALIAS#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
			OR
				I.DEPARTMENT_OUT IN (SELECT DEPARTMENT_ID FROM #DSN_ALIAS#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
			)	
		<cfelseif fusebox.circuit is 'correspondence' and xml_userid eq 1>
			AND
			(
				I.RECORD_EMP = #session.ep.userid# OR
				I.UPDATE_EMP = #session.ep.userid# OR
				I.TO_POSITION_CODE = #session.ep.position_code# OR
				I.FROM_POSITION_CODE = #session.ep.userid#
			)		
		</cfif> 
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND (
				I.SUBJECT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
				I.INTERNAL_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				<cfif session.ep.our_company_info.workcube_sector is 'tersane'>
					OR DPL_ID IN (SELECT DPL_ID FROM DRAWING_PART WHERE DPL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
				</cfif>
				)
		</cfif>
		<cfif len(attributes.internaldemand_action) and attributes.internaldemand_action eq 1><!--- Siparişe Dönüşenler --->
			AND (I.INTERNAL_ID IN (SELECT INTERNALDEMAND_ID FROM INTERNALDEMAND_RELATION_ROW WHERE INTERNALDEMAND_ID = I.INTERNAL_ID <cfif attributes.list_type eq 1>AND STOCK_ID = I_ROW.STOCK_ID</cfif> AND TO_ORDER_ID IS NOT NULL)
            	<!---Teklif üzerinden siparişe dönüşenler --->
            	OR I.INTERNAL_ID IN(SELECT INTERNALDEMAND_ID FROM INTERNALDEMAND_RELATION_ROW  WHERE INTERNALDEMAND_ID = I.INTERNAL_ID <cfif attributes.list_type eq 1>AND STOCK_ID = I_ROW.STOCK_ID</cfif> AND TO_OFFER_ID IS NOT NULL AND TO_OFFER_ID IN(SELECT DISTINCT FROM_ACTION_ID FROM RELATION_ROW WHERE FROM_TABLE='OFFER' AND TO_TABLE='ORDERS' AND FROM_TABLE IS NOT NULL AND TO_TABLE IS NOT NULL))
                )
		<cfelseif len(attributes.internaldemand_action) and attributes.internaldemand_action eq 2><!--- Teklife Dönüşenler --->
			<cfif isdefined('attributes.list_type') and attributes.list_type eq 1>
				AND I_ROW.WRK_ROW_ID IN (SELECT WRK_ROW_RELATION_ID FROM OFFER_ROW)
			<cfelse>
				AND (
				I.INTERNAL_ID IN (SELECT INTERNALDEMAND_ID FROM OFFER WHERE INTERNALDEMAND_ID = I.INTERNAL_ID AND INTERNALDEMAND_ID IS NOT NULL)
				OR I.INTERNAL_ID IN (SELECT IRR.INTERNALDEMAND_ID FROM INTERNALDEMAND_RELATION_ROW IRR WHERE IRR.TO_OFFER_ID IS NOT NULL )				
				)
			</cfif>
		<cfelseif len(attributes.internaldemand_action) and attributes.internaldemand_action eq 4><!--- sarf fişine Dönüşenler --->
			<cfif isdefined('attributes.list_type') and attributes.list_type eq 1>
				AND I_ROW.WRK_ROW_ID IN (SELECT WRK_ROW_RELATION_ID FROM #dsn2_alias#.STOCK_FIS_ROW)
			<cfelse>
				AND I.INTERNAL_ID IN (SELECT IRR.INTERNALDEMAND_ID FROM INTERNALDEMAND_RELATION_ROW IRR WHERE IRR.TO_STOCK_FIS_ID IS NOT NULL )				
			</cfif>
		<cfelseif len(attributes.internaldemand_action) and attributes.internaldemand_action eq 3><!--- İşlenmeyenler --->
			<!--- Burada hic islem gormemislerin yani sira yeni bir istek uzerine, taleplerde kalan miktar oldugu surece islenenler de gelecek (sadece satir bazinda) --->
			<cfif isdefined('attributes.list_type') and attributes.list_type eq 1><!--- Satır Bazında --->
				AND I_ROW.BASKET_EXTRA_INFO_ID != 1
				AND	(
						<!--- Islenmis olup, kalan miktari olanlar --->
						I_ROW.I_ROW_ID IN  (SELECT INTERNALDEMAND_ROW_ID FROM INTERNALDEMAND_RELATION_ROW IRR WHERE IRR.INTERNALDEMAND_ID = I_ROW.I_ID  AND I_ROW.STOCK_ID = IRR.STOCK_ID GROUP BY INTERNALDEMAND_ROW_ID HAVING (I_ROW.QUANTITY - SUM(IRR.AMOUNT)) > 0) OR
						<!--- Islenmemis olanlar --->
						I_ROW.I_ROW_ID NOT IN  (SELECT INTERNALDEMAND_ROW_ID FROM INTERNALDEMAND_RELATION_ROW IRR WHERE IRR.INTERNALDEMAND_ID = I_ROW.I_ID  AND I_ROW.STOCK_ID = IRR.STOCK_ID)
					)
			<cfelse><!--- Belge Bazında --->
				AND (
					I.INTERNAL_ID NOT IN (SELECT IRR.INTERNALDEMAND_ID FROM INTERNALDEMAND_RELATION_ROW IRR WHERE IRR.TO_ORDER_ID IS NOT NULL )
				  OR
					<!---İstek Üzerine SİPARİŞLERDE kalan miktarlar olduğu sürece belge bazında İşlenmemiş olarak gösterilmesine--->
					I.INTERNAL_ID IN (
					SELECT
						INTERNALDEMAND_ROW.I_ID
					FROM
						INTERNALDEMAND_ROW
						LEFT JOIN INTERNALDEMAND_RELATION_ROW
					ON
						INTERNALDEMAND_ROW.I_ID = INTERNALDEMAND_RELATION_ROW.INTERNALDEMAND_ID AND 
						INTERNALDEMAND_ROW.STOCK_ID = INTERNALDEMAND_RELATION_ROW.STOCK_ID AND
						INTERNALDEMAND_RELATION_ROW.TO_ORDER_ID IS NOT NULL
					GROUP BY
						INTERNALDEMAND_ROW.I_ID
					HAVING
						((SELECT SUM(I_ROW.QUANTITY) FROM INTERNALDEMAND_ROW I_ROW WHERE I_ROW.I_ID = INTERNALDEMAND_ROW.I_ID)-SUM(INTERNALDEMAND_RELATION_ROW.AMOUNT))>0)
				)
				AND
				(
					I.INTERNAL_ID NOT IN (SELECT IRR.INTERNALDEMAND_ID FROM INTERNALDEMAND_RELATION_ROW IRR WHERE IRR.TO_OFFER_ID IS NOT NULL)
				  OR
					<!---İstek Üzerine TEKLİFLERDE kalan miktarlar olduğu sürece belge bazında İşlenmemiş olarak gösterilmesine--->
					I.INTERNAL_ID IN(
					SELECT 
						INTERNALDEMAND_ROW.I_ID 
					FROM 
						INTERNALDEMAND_ROW  
						LEFT JOIN INTERNALDEMAND_RELATION_ROW  
					ON 
						INTERNALDEMAND_ROW.I_ID=INTERNALDEMAND_RELATION_ROW.INTERNALDEMAND_ID AND 
						INTERNALDEMAND_ROW.STOCK_ID = INTERNALDEMAND_RELATION_ROW.STOCK_ID AND
						INTERNALDEMAND_RELATION_ROW.TO_OFFER_ID IS NOT NULL
					GROUP BY 
						INTERNALDEMAND_ROW.I_ID
					HAVING 
						((SELECT SUM(I_ROW.QUANTITY) FROM INTERNALDEMAND_ROW I_ROW WHERE I_ROW.I_ID = INTERNALDEMAND_ROW.I_ID)-SUM(INTERNALDEMAND_RELATION_ROW.AMOUNT))>0)
				)
				AND
				(
					I.INTERNAL_ID NOT IN (SELECT IRR.INTERNALDEMAND_ID FROM INTERNALDEMAND_RELATION_ROW IRR WHERE IRR.TO_STOCK_FIS_ID IS NOT NULL)
				  OR
					<!---İstek Üzerine SARF FİŞİNDE kalan miktarlar olduğu sürece belge bazında İşlenmemiş olarak gösterilmesine--->
					I.INTERNAL_ID IN(
					SELECT 
						INTERNALDEMAND_ROW.I_ID 
					FROM 
						INTERNALDEMAND_ROW
						LEFT JOIN INTERNALDEMAND_RELATION_ROW ON 
							INTERNALDEMAND_ROW.I_ID=INTERNALDEMAND_RELATION_ROW.INTERNALDEMAND_ID AND 
							INTERNALDEMAND_ROW.STOCK_ID = INTERNALDEMAND_RELATION_ROW.STOCK_ID AND
							INTERNALDEMAND_RELATION_ROW.TO_STOCK_FIS_ID IS NOT NULL
					GROUP BY 
						INTERNALDEMAND_ROW.I_ID
					HAVING 
						((SELECT SUM(I_ROW.QUANTITY) FROM INTERNALDEMAND_ROW I_ROW WHERE I_ROW.I_ID = INTERNALDEMAND_ROW.I_ID)-SUM(INTERNALDEMAND_RELATION_ROW.AMOUNT))>0)
				)
			</cfif>
		</cfif>	
	ORDER BY
		<cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 1>
			I.TARGET_DATE DESC
		<cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 2>
			I.TARGET_DATE
		<cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 3 and attributes.list_type neq 0>
			I_ROW.PRODUCT_NAME DESC
		<cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 4 and attributes.list_type neq 0>
			I_ROW.PRODUCT_NAME
	   <cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 5>
			CAST(PARSENAME(REPLACE(INTERNAL_NUMBER,'-','.'),1)AS INT) DESC
			<!--- CAST(RIGHT(INTERNAL_NUMBER,(LEN(INTERNAL_NUMBER)-CHARINDEX('-',INTERNAL_NUMBER))) AS INT) DESC --->
	   <cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 6>
			CAST(PARSENAME(REPLACE(INTERNAL_NUMBER,'-','.'),1)AS INT)
        <cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 7>
        	I.RECORD_DATE DESC
        <cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 8>
        	I.RECORD_DATE
        <cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 9 and isdefined('attributes.list_type') and attributes.list_type eq 1>
        	S.PRODUCT_CODE
        <cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 10 and isdefined('attributes.list_type') and attributes.list_type eq 1>
        	S.PRODUCT_CODE DESC
        <cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 11>
        	I.PROJECT_ID
        <cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 12>
        	I.PROJECT_ID DESC
        <cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 13>
        	I.PROJECT_ID_OUT
        <cfelseif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 14>
        	I.PROJECT_ID_OUT DESC
		<cfelse>
			I.TARGET_DATE DESC
		</cfif>
        <cfif not  listfind("11,12,13,14",attributes.order_by_date_) >
			<cfif isdefined("attributes.group_project") and len(attributes.group_project) and attributes.group_project eq 1>
                ,I.PROJECT_ID 
            <cfelseif isdefined("attributes.group_project") and len(attributes.group_project) and attributes.group_project eq 2>
                ,I.PROJECT_ID_OUT
            </cfif>
        </cfif>
		<cfif isdefined('attributes.list_type') and attributes.list_type eq 1>
			,I.INTERNAL_ID
			,I_ROW.I_ROW_ID
		</cfif>
</cfquery>
