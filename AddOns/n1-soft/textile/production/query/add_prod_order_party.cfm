<!---<cfdump var="#attributes#">
<cfabort>--->

<!---<cfquery name="get_size_detail" datasource="#dsn3#">
	SELECT DISTINCT
				ISNULL((SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID =ORR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
				
				ORR.ORDER_ROW_ID,
				
		
				BPR.PLAN_AMOUNT QUANTITY,
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
				BEDEN.PROPERTY_DETAIL AS BEDEN_
			FROM 
				ORDERS O,
				ORDER_ROW ORR,
				<!---KRD_OPERASYON_SECIM K,--->
				BRS_ORDER_PLAN_ROW BPR,
				BRS_ORDER_PLAN BP,
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
				PRP.PROPERTY_SIZE = 0 AND 
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
			WHERE
				( (O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1) ) AND  
				PU.PRODUCT_ID = S.PRODUCT_ID AND
				ORR.STOCK_ID = S.STOCK_ID AND
				ORR.PRODUCT_ID = S.PRODUCT_ID AND
				<!---ORR.STOCK_ID=K.STOCK_ID AND
				ORR.WRK_ROW_ID=K.ROW_ID AND
				ORR.ORDER_ID=K.ORDER_ID AND
				ISNULL(K.AMOUNT,0)>0 AND--->
				BP.ORDER_ID=O.ORDER_ID AND
				BP.PLAN_ID=BPR.PLAN_ID AND
				BPR.SUB_WRK_ROW_ID=ORR.WRK_ROW_ID AND
				BPR.SUB_ORDER_ROW_ID=ORR.ORDER_ROW_ID AND
				ISNULL(BPR.PLAN_AMOUNT,0)>0 AND
				S.IS_PRODUCTION = 1 AND
				ORR.ORDER_ID = O.ORDER_ID AND
				O.ORDER_STATUS = 1
				
					AND ORR.ORDER_ROW_ID NOT IN (
									SELECT POR.ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW POR,PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND POR.ORDER_ROW_ID IS NOT NULL AND PO.IS_STAGE<>-1 AND POR.OP_ID=#attributes.operasyon_id_# and (POR.PLAN_ID=#attributes.plan_id_# OR POR.PLAN_ID IS NULL)
								)
					<!---AND	ORR.ORDER_ROW_CURRENCY = -5--->
					AND BP.ASAMA_ID=-5
					and BP.OPERASYON_ID=#attributes.operasyon_id_#
					and BP.PLAN_ID=#attributes.plan_id_#
					and O.ORDER_ID=#attributes.order_id_#
					and ORR.PRODUCT_ID=#attributes.pid_#
					<cfif len(attributes.renk_id_)>
					AND RENK.PROPERTY_DETAIL_ID=#attributes.renk_id_#
					</cfif>
	
</cfquery>--->
<cfquery name="get_size_detail" datasource="#dsn3#">
	SELECT DISTINCT
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
				<!---KRD_OPERASYON_SECIM K,
				BRS_ORDER_PLAN_ROW BPR,
				BRS_ORDER_PLAN BP,--->
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
				
			<!---	BP.ORDER_ID=O.ORDER_ID AND
				BP.PLAN_ID=BPR.PLAN_ID AND
				BPR.SUB_WRK_ROW_ID=ORR.WRK_ROW_ID AND
				BPR.SUB_ORDER_ROW_ID=ORR.ORDER_ROW_ID AND
				ISNULL(BPR.PLAN_AMOUNT,0)>0 AND--->
				S.IS_PRODUCTION = 1 AND
				ORR.ORDER_ID = O.ORDER_ID AND
				O.ORDER_STATUS = 1
				
					<!---AND ORR.ORDER_ROW_ID NOT IN (
									SELECT POR.ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW POR,PRODUCTION_ORDERS PO WHERE PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND POR.ORDER_ROW_ID IS NOT NULL AND PO.IS_STAGE<>-1 AND POR.OP_ID=#attributes.operasyon_id# and (POR.PLAN_ID=#attributes.plan_id# or POR.PLAN_ID IS NULL)
								)--->
					AND	ORR.ORDER_ROW_CURRENCY = -5
					<!---AND BP.ASAMA_ID=-5
					and BP.OPERASYON_ID=#attributes.operasyon_id#
					and BP.PLAN_ID=#attributes.plan_id#--->
					and O.ORDER_ID=#attributes.order_id_#
					and ORR.PRODUCT_ID=#attributes.pid_#
					<!---<cfif len(attributes.renk_id)>
					AND RENK.PROPERTY_DETAIL_ID=#attributes.renk_id#
					</cfif>--->
	
</cfquery>



				<form name="add_production_demand" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=textile.emptypopup_add_production_order_all_sub_tex">
					<tr>
					<cfset is_time_calculation=0>
					<cfset is_cue_theory=0>
					<cfset is_add_multi_demand=0>
						<td colspan="10" style="text-align:right;">
							<input name="is_time_calculation"  id="is_time_calculation" type="hidden" value="<cfoutput>#is_time_calculation#</cfoutput>">
							<input name="is_cue_theory"  id="is_cue_theory" type="hidden" value="<cfoutput>#is_cue_theory#</cfoutput>">
							<input name="is_add_multi_demand"  id="is_add_multi_demand" type="hidden" value="<cfoutput>#is_add_multi_demand#</cfoutput>">
							<input name="process_stage" id="process_stage" type="hidden" value="<cfoutput>#attributes.p_stage#</cfoutput>">
							<input name="station_id_list"  id="station_id_list" type="hidden" value="">
							<input name="works_prog_id_list"  id="works_prog_id_list" type="hidden" value="">
							<input name="production_amount_list"  id="production_amount_list" type="hidden" value="">
							<input name="order_row_id"  id="order_row_id" type="hidden" value="">
							<input name="order_id"  id="order_id" type="hidden" value="">
							<input name="pid"  id="pid" type="hidden" value="<cfoutput>#attributes.pid_#</cfoutput>">
							<input name="colorid"  id="colorid" type="hidden" value="<cfoutput>#attributes.renk_id_#</cfoutput>">
							<input name="opidlist"  id="opidlist" type="hidden" value="">
							<input name="plan_id"  id="plan_id" type="hidden" value="<cfoutput>#attributes.plan_id_#</cfoutput>">
							<input name="lotno_list"  id="lotno_list" type="hidden" value="">
							
							<input name="party_start_date"  id="party_start_date" type="hidden" value="">
							<input name="party_start_h"  id="party_start_h" type="hidden" value="">
							<input name="party_start_m"  id="party_start_m" type="hidden" value="">
							
							<input name="party_finish_date"  id="party_finish_date" type="hidden" value="">
							<input name="party_finish_h"  id="party_finish_h" type="hidden" value="">
							<input name="party_finish_m"  id="party_finish_m" type="hidden" value="">
							
							<input name="production_start_date_list"  id="production_start_date_list" type="hidden" value="">
							<input name="production_start_h_list"  id="production_start_h_list" type="hidden" value="">
							<input name="production_start_m_list"  id="production_start_m_list" type="hidden" value="">
							
							
							<input name="production_finish_date_list"  id="production_finish_date_list" type="hidden" value="">
							<input name="production_finish_h_list"  id="production_finish_h_list" type="hidden" value="">
							<input name="production_finish_m_list"  id="production_finish_m_list" type="hidden" value="">

							<input name="is_party" id="is_party" type="hidden" value="1">
							<input name="party_number" id="party_number" type="hidden" value="">
							
							<input type="hidden" name="is_demand" id="is_demand" value="">
						</td>
					</tr> 
				</form>
	
	
	<table>
		<tr>
            <td>
				Üretime Gönderiliyor! lütfen bekleyiniz...
			</td>
		</tr>
	</table>
<script>
	function send_prod()
	{
		var order_row_id_list="";
			 var order_id_list="";
			 var station_id_list = "";
			 var production_start_date_list = "";
			 var production_start_h_list = "";
			 var production_start_m_list = "";
			 
			  var production_finish_date_list = "";
			 var production_finish_h_list = "";
			 var production_finish_m_list = "";
			 
			 var works_prog_id_list = "";
			 var spect_main_id_list ="";
			 var production_amount_list = "";
			 var unit_name = "";
			 var lotnolist="";
			 var opidlist="";
			 
							document.getElementById('party_start_date').value = '<cfoutput>#attributes.start_date_#</cfoutput>';
							document.getElementById('party_start_m').value ='<cfoutput>#attributes.start_m#</cfoutput>';
							document.getElementById('party_start_h').value = '<cfoutput>#attributes.start_h#</cfoutput>';
							
							document.getElementById('party_finish_date').value = '<cfoutput>#attributes.finish_date_#</cfoutput>';
							document.getElementById('party_finish_m').value = '<cfoutput>#attributes.finish_m#</cfoutput>';
							document.getElementById('party_finish_h').value ='<cfoutput>#attributes.finish_h#</cfoutput>';
			 var lot_no="ULN-<cfoutput>#attributes.order_id_#-#attributes.pid_#-#attributes.renk_id_#-#attributes.operasyon_id_#-#attributes.plan_id_#</cfoutput>";
			<cfoutput query="get_size_detail">
							opidlist+='#attributes.operasyon_id_#'+',';
						 	lotnolist+=lot_no+',';
							order_id_list+='#attributes.order_id_#'+',';//1.ci alan order id'yi tutuyor
							order_row_id_list+='#order_row_id#'+',';//2.ci alan order_row id'yi tutuyor
							 unit_name+='#unit#';
							 spect_main_id_list+='#SPECT_MAIN_ID#'+',';
	
								station_id_list+='#attributes.p_station#'+'@';
							
								
								production_start_date_list+='#attributes.start_date_#'+',';
								production_start_h_list +='#attributes.start_h#'+',';
								production_start_m_list +='#attributes.start_m#'+',';
								
								production_finish_date_list+='#attributes.finish_date_#'+',';
								production_finish_h_list +='#attributes.finish_h#'+',';
								production_finish_m_list +='#attributes.finish_m#'+',';
										
								works_prog_id_list+=''+',';
								
							production_amount_list+='#quantity#'+',';
								
								
			</cfoutput>
			//sipariş seçilmiş ise
			
				opidlist = opidlist.substr(0,opidlist.length-1);
				
				lotno_list = lotnolist.substr(0,lotnolist.length-1);
				order_id_list = order_id_list.substr(0,order_id_list.length-1);//sondaki virgülden kurtarıyoruz.
				order_row_id_list = order_row_id_list.substr(0,order_row_id_list.length-1);
				station_id_list = station_id_list.substr(0,station_id_list.length-1);
				production_start_date_list = production_start_date_list.substr(0,production_start_date_list.length-1);
				production_start_h_list = production_start_h_list.substr(0,production_start_h_list.length-1);
				production_start_m_list = production_start_m_list.substr(0,production_start_m_list.length-1);
				
				production_finish_date_list = production_finish_date_list.substr(0,production_finish_date_list.length-1);
				production_finish_h_list = production_finish_h_list.substr(0,production_finish_h_list.length-1);
				production_finish_m_list = production_finish_m_list.substr(0,production_finish_m_list.length-1);
				
				works_prog_id_list = works_prog_id_list.substr(0,works_prog_id_list.length-1);
				production_amount_list= production_amount_list.substr(0,production_amount_list.length-1);
				spect_main_id_list = spect_main_id_list.substr(0,spect_main_id_list.length-1);
				unit_name = unit_name.substr(0,unit_name.length-1);
				

					_type=0;
							document.getElementById('opidlist').value=opidlist;
							document.getElementById('lotno_list').value = lotno_list;
							document.getElementById('is_demand').value = _type;
							document.getElementById('station_id_list').value = station_id_list;
							document.getElementById('works_prog_id_list').value = works_prog_id_list;
							document.getElementById('production_amount_list').value = production_amount_list;
							document.getElementById('order_row_id').value = order_row_id_list;
							document.getElementById('order_id').value = order_id_list;
							document.getElementById('production_start_m_list').value = production_start_m_list;
							document.getElementById('production_start_h_list').value = production_start_h_list;
							document.getElementById('production_start_date_list').value = production_start_date_list;
	
							document.getElementById('production_finish_m_list').value = production_finish_m_list;
							document.getElementById('production_finish_h_list').value = production_finish_h_list;
							document.getElementById('production_finish_date_list').value = production_finish_date_list;
							

							
							document.getElementById('production_start_h_list').value = production_start_h_list;
							document.getElementById('production_start_date_list').value = production_start_date_list;
							
							
						
							document.add_production_demand.submit();
		
	}
	send_prod();
</script>


