<cfset is_show_work_prog=0>

<cfsetting showDebugOutput = "no" >
<cfquery name="GET_W" datasource="#dsn#">
	SELECT 
    	STATION_ID,
        STATION_NAME,
        ISNULL(EXIT_DEP_ID,0) AS EXIT_DEP_ID,
        ISNULL(EXIT_LOC_ID,0) AS EXIT_LOC_ID,
        ISNULL(PRODUCTION_DEP_ID,0) AS PRODUCTION_DEP_ID,
        ISNULL(PRODUCTION_LOC_ID,0) AS PRODUCTION_LOC_ID
	FROM 
    	#dsn3_alias#.WORKSTATIONS 
	<!---WHERE 
    	DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# ) --->
	ORDER BY 
    	STATION_NAME ASC
</cfquery>

<cfquery name="get_size_detail" datasource="#dsn3#">
	SELECT 
				ISNULL((SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID =ORR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
				
				ORR.ORDER_ROW_ID,
				
				ORR.QUANTITY,
			
				ORR.UNIT,
				ORR.ORDER_ROW_CURRENCY,
				ORR.SPECT_VAR_ID,
				S.PROPERTY, 
				CASE WHEN S.STOCK_CODE = '' THEN '_' ELSE ISNULL(S.STOCK_CODE,'_') END AS STOCK_CODE,
				ORR.UNIT2,
				ORR.AMOUNT2,
				ORR.DELIVER_DATE AS ROW_DELIVER_DATE,
				S.STOCK_ID,
				S.PRODUCT_NAME,				
				S.STOCK_CODE_2,			
				O.ORDER_ID,
				O.ORDER_NUMBER,
				O.ORDER_HEAD,
				O.OTHER_MONEY,
				O.TAX,
				O.GROSSTOTAL, 
				O.ORDER_DATE, 
				O.DELIVERDATE, 
				O.RECORD_EMP,
				O.COMPANY_ID,
				S.PRODUCT_ID,
				O.CONSUMER_ID,
				O.PROJECT_ID,
				ORR.WRK_ROW_ID,
				ORR.RESERVE_TYPE,
				CAST(O.ORDER_DETAIL AS NVARCHAR(250)) ORDER_DETAIL,
					RENK.PROPERTY_DETAIL AS RENK_,
				BEDEN.PROPERTY_DETAIL AS BEDEN_,
				BOY.PROPERTY_DETAIL AS BOY_
			FROM 
				ORDERS O,
				ORDER_ROW ORR,
				PRODUCT_UNIT PU,
				STOCKS S
				OUTER APPLY
		(
			SELECT 
				PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
				PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,PPD.PRPT_ID
			FROM
				#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
				#dsn1#.PRODUCT_PROPERTY PRP,
				STOCKS_PROPERTY SP
			WHERE
				PRP.PROPERTY_ID = PPD.PRPT_ID AND
				SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
				PRP.PROPERTY_COLOR = 1 AND 
				SP.STOCK_ID = S.STOCK_ID 
		) AS RENK
		OUTER APPLY
		(
			SELECT 
				PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
				PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,PPD.PRPT_ID
			FROM
				#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
				#dsn1#.PRODUCT_PROPERTY PRP,
				STOCKS_PROPERTY SP
			WHERE
				PRP.PROPERTY_ID = PPD.PRPT_ID AND
				SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
				PRP.PROPERTY_SIZE = 1 AND 
				SP.STOCK_ID = S.STOCK_ID 
		) AS BEDEN
		OUTER APPLY
		(
			SELECT 
				PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
				PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,PPD.PRPT_ID
			FROM
				#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
				#dsn1#.PRODUCT_PROPERTY PRP,
				STOCKS_PROPERTY SP
			WHERE
				PRP.PROPERTY_ID = PPD.PRPT_ID AND
				SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
				PRP.PROPERTY_LEN = 1 AND 
				SP.STOCK_ID = S.STOCK_ID 
		) AS Boy
			WHERE
				( (O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1) ) AND  
				PU.PRODUCT_ID = S.PRODUCT_ID AND
				ORR.STOCK_ID = S.STOCK_ID AND
				ORR.PRODUCT_ID = S.PRODUCT_ID AND
				S.IS_PRODUCTION = 1 AND
				ORR.ORDER_ID = O.ORDER_ID AND
				O.ORDER_STATUS = 1
				AND	ORR.ORDER_ROW_CURRENCY = -5
					and O.ORDER_ID=#attributes.order_id#
					and ORR.PRODUCT_ID=#attributes.pid#
</cfquery>


<cf_ajax_list>
			<thead>
					<tr>
						<th style="width:350px;">Stok / Asorti</th>
						<th style="width:50px;">Stok Kodu</th>
						<th style="width:50px;">Özel Kodu</th>
						<th style="width:10px;text-align:right;">Miktar</th>
						<th></th>
					</tr>
					
					<cfset company_name_list =''>
					<cfset consumer_name_list =''>
					<cfset spect_name_list =''>
					<cfset order_row_id_list=''>
					<cfset stock_id_list=''>
					<cfoutput query="get_size_detail">
							<cfif len(ORDER_ROW_ID)>
								<cfset order_row_id_list = ListAppend(order_row_id_list,ORDER_ROW_ID)>
							</cfif>
							<cfif len(COMPANY_ID) and not listfind(company_name_list,COMPANY_ID)>
								<cfset company_name_list = ListAppend(company_name_list,COMPANY_ID)>
							</cfif>
							<cfif len(CONSUMER_ID) and not listfind(consumer_name_list,CONSUMER_ID)>
								<cfset consumer_name_list = ListAppend(consumer_name_list,CONSUMER_ID)>
							</cfif>
							<cfif len(SPECT_VAR_ID) and not listfind(spect_name_list,SPECT_VAR_ID)>
								<cfset spect_name_list = ListAppend(spect_name_list,SPECT_VAR_ID)>
							</cfif>
							<cfif len(STOCK_ID) and not listfind(stock_id_list,STOCK_ID)>
								<cfset stock_id_list = listappend(stock_id_list,STOCK_ID)>
							</cfif>
					</cfoutput>
					<cfif len(company_name_list)>
							<cfset company_name_list=listsort(company_name_list,"numeric","ASC",",")>
							<cfquery name="get_company_name" datasource="#DSN#">
								SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_name_list#) ORDER BY COMPANY_ID
							</cfquery>
							<cfset company_name_list = listsort(listdeleteduplicates(valuelist(get_company_name.COMPANY_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(consumer_name_list)>
						<cfset consumer_name_list=listsort(consumer_name_list,"numeric","ASC",",")>
						<cfquery name="get_consumer_name" datasource="#DSN#">
							SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME AS CONSUMER_NAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_name_list#) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset consumer_name_list = listsort(listdeleteduplicates(valuelist(get_consumer_name.CONSUMER_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(order_row_id_list) and 1 eq 2>
							<cfset order_row_id_list=listsort(order_row_id_list,"numeric","ASC",",")>
							<cfquery name="GET_PRODUCTION_INFO" datasource="#DSN3#">
								SELECT 
									ISNULL(SUM(PO.QUANTITY),0) AS QUANTITY,
									POR.ORDER_ROW_ID,
									ISNULL(POR.TYPE,1) AS TYPE 
								FROM 
									PRODUCTION_ORDERS PO,
									PRODUCTION_ORDERS_ROW POR,
									ORDER_ROW OR_
								WHERE
									OR_.ORDER_ROW_ID =POR.ORDER_ROW_ID AND
									OR_.STOCK_ID = PO.STOCK_ID AND
									PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID
									AND POR.ORDER_ROW_ID IN (#order_row_id_list#)
									AND POR.OP_ID=#attributes.operasyon_id#
									AND (POR.PLAN_ID=#attributes.plan_id# or POR.PLAN_ID IS NULL)
								GROUP BY 
									POR.ORDER_ROW_ID,
									POR.TYPE
									
							</cfquery>
							<cfscript>
								for(gpi_ind=1;gpi_ind lte GET_PRODUCTION_INFO.recordcount;gpi_ind=gpi_ind+1){//ayrı ayrı göstereceğimiz için grupladık
									if(GET_PRODUCTION_INFO.TYPE[gpi_ind] eq 1)
										'verilen_uretim_emri_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' = GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
									else
										'verilen_talep_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' = GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
									if(not isdefined('toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#'))
										'toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' =GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
									else
										'toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#' = Evaluate('toplam_#GET_PRODUCTION_INFO.ORDER_ROW_ID[gpi_ind]#')+GET_PRODUCTION_INFO.QUANTITY[gpi_ind];
								}
							</cfscript>
				</cfif>
				<cfif len(spect_name_list)>
						<cfset spect_name_list=listsort(spect_name_list,"numeric","ASC",",")>
						<cfquery name="GET_SPECT_NAME" datasource="#DSN3#">
							SELECT SPECT_VAR_NAME,SPECT_VAR_ID,SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID IN (#spect_name_list#) ORDER BY SPECT_VAR_ID
						</cfquery>
						<cfset spect_name_list = listsort(listdeleteduplicates(valuelist(GET_SPECT_NAME.SPECT_VAR_ID,',')),'numeric','ASC',',')>
				</cfif>
					<cfif len(get_size_detail.deliverdate)>
						<cfset _now_ = date_add('h',session.ep.TIME_ZONE,get_size_detail.deliverdate)>
					<cfelse>
						<cfset _now_ = date_add('h',session.ep.TIME_ZONE,now())>
					</cfif>						
					<cfset _now_ = date_add('d',-2,_now_)>
					<cfquery name="get_station_times" datasource="#dsn#">
						SELECT * FROM SETUP_SHIFTS WHERE IS_PRODUCTION = 1 AND FINISHDATE > #_now_#
					</cfquery>
					<cfset works_prog = get_station_times.SHIFT_NAME>
					<cfset works_prog_id = get_station_times.SHIFT_ID>
					
					<cfoutput query="get_size_detail">
						<cfif isdefined("SPECT_VAR_ID") and len(SPECT_VAR_ID)>
							<cfset _spect_main_id = GET_SPECT_NAME.SPECT_MAIN_ID[listfind(spect_name_list,get_size_detail.SPECT_VAR_ID,',')]>
							<cfset _spect_name = GET_SPECT_NAME.SPECT_VAR_NAME[listfind(spect_name_list,get_size_detail.SPECT_VAR_ID,',')]> 
						<cfelse>
							<cfset _spect_main_id =  '' >
							<cfset _spect_name = ''>
						</cfif>
						<cfset _spect_main_id =  '' >
							<cfset _spect_name = ''>
							<cfset kalan_uretim_emri = QUANTITY>
						<tr>
							<td>#product_name# #PROPERTY#</td>
							<td>#STOCK_CODE#</td>
							<td>#STOCK_CODE_2#</td>
							<td style="text-align:right;">
								<cfset kalan_uretim_emri=wrk_round(kalan_uretim_emri+(kalan_uretim_emri*attributes.marj/100),0)>
								<input type="text" class="boxtext" readonly name="production_amount_#currentrow#" id="production_amount_#currentrow#" style="width:65px;" value="<cfif kalan_uretim_emri lt 0>#tlformat(0)#<cfelse>#tlformat(kalan_uretim_emri)#</cfif>" class="moneybox" onKeyup="return(FormatCurrency(this,event,3));">
							</td>
							<td></td>
						</tr>
					</cfoutput>
			</thead>
	
			<tfoot>
			
			
			</tfoot>
	</cf_ajax_list>
<script>
	

	function tarihdegis<cfoutput>#attributes.row_number#</cfoutput>(tarih,rownumber,type,sf)
	{	

		x=document.getElementsByName('is_active'+rownumber).length;

				for(var i=1;i<=x;i++)
				{
					if(sf==0)
					{
						if(type==0)
							eval('document.all.production_start_date_'+rownumber+'_'+i).value=tarih;
						else if(type==1)
							eval('document.all.production_start_h_'+rownumber+'_'+i).value=tarih;
						else
							eval('document.all.production_start_m_'+rownumber+'_'+i).value=tarih;
					}
					else
					{
						if(type==0)
							eval('document.all.production_finish_date_'+rownumber+'_'+i).value=tarih;
						else if(type==1)
							eval('document.all.production_finish_h_'+rownumber+'_'+i).value=tarih;
						else
							eval('document.all.production_finish_m_'+rownumber+'_'+i).value=tarih;
					}
				}
		
	}
	function tumunusec<cfoutput>#attributes.row_number#</cfoutput>(object,rownumber)
	{
		x=document.getElementsByName('is_active'+rownumber).length;

		if(x>1)
		{
			for(var i=0;i<x;i++)
			{
				if(object.checked)
				{
					if(document.all.is_active<cfoutput>#attributes.row_number#</cfoutput>[i]!=undefined)
					document.all.is_active<cfoutput>#attributes.row_number#</cfoutput>[i].checked=true;
				}
				else
				{
					if(document.all.is_active<cfoutput>#attributes.row_number#</cfoutput>[i]!=undefined)
					document.all.is_active<cfoutput>#attributes.row_number#</cfoutput>[i].checked=false;
				}
			}
		}
		else
		{
			if(object.checked)
				{
					if(document.all.is_active<cfoutput>#attributes.row_number#</cfoutput>!=undefined)
					document.all.is_active<cfoutput>#attributes.row_number#</cfoutput>.checked=true;
				}
				else
				{
					if(document.all.is_active<cfoutput>#attributes.row_number#</cfoutput>!=undefined)
					document.all.is_active<cfoutput>#attributes.row_number#</cfoutput>.checked=false;
				}
		}
	}
	

</script>
