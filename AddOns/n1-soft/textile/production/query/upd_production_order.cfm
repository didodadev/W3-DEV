
<cf_xml_page_edit fuseact="prod.add_prod_order"><!--- Ürtim Emri XML AYARLARI --->
<cfquery name="get_party" datasource="#dsn3#">
	select *from PRODUCTION_ORDERS WHERE PARTY_ID=#attributes.party_id#
</cfquery>
<cfset sayac=0>


<cf_date tarih="attributes.start_date">
<cf_date tarih="attributes.finish_date">
<cfscript>
	attributes.startdate_fn = date_add("n",attributes.start_m,date_add("h",attributes.start_h,attributes.start_date));
	attributes.finishdate_fn = date_add("n",attributes.finish_m,date_add("h",attributes.finish_h,attributes.finish_date));
	attributes.start_date = date_add("n",start_m,date_add("h",start_h - session.ep.time_zone,attributes.start_date));
	attributes.finish_date = date_add("n",finish_m,date_add("h",finish_h - session.ep.time_zone,attributes.finish_date));
</cfscript>
<cfloop query="get_party">
<cfset attributes.p_order_id=get_party.p_order_id>
 <cfquery name="GET_RELATED_PRODUCTION_RESULT" datasource="#dsn3#">
        SELECT POO.PRODUCTION_ORDER_NO FROM PRODUCTION_ORDER_RESULTS_ROW POR_,PRODUCTION_ORDER_RESULTS POO WHERE POO.PR_ORDER_ID=POR_.PR_ORDER_ID AND POR_.P_ORDER_ID IN (#attributes.p_order_id#)
    </cfquery>
	<cfif GET_RELATED_PRODUCTION_RESULT.recordcount and is_result_control eq 1><!--- xmle bağlandı --->
        <script type="text/javascript">
            alert("<cf_get_lang no ='635.Bu Üretim Emrinin İlişkili Olduğu Üretimlerden Sonuç Girilenler Var,Güncelleme Yapılamaz Sonuç Girilenler'>.! \n :<cfoutput>#related_production_no_list#</cfoutput>");
            history.go(-1);
        </script>
        <cfabort>
    </cfif>

<cfif isdefined("attributes.station_id")  and len(attributes.station_id)>
	<cfquery name="GET_STATION" datasource="#dsn3#">
		SELECT 
			STATION_NAME,
			EXIT_DEP_ID,
			EXIT_LOC_ID,
			ENTER_DEP_ID,
			ENTER_LOC_ID,
			PRODUCTION_DEP_ID,
			PRODUCTION_LOC_ID
		FROM 
			WORKSTATIONS 
		WHERE 
			STATION_ID = #attributes.station_id#
	</cfquery>
</cfif>
<cfif isdefined("get_station.exit_dep_id") and len(get_station.exit_dep_id)>
	<cfset _EXIT_DEP_ID = get_station.exit_dep_id>
	<cfset _EXIT_LOC_ID = get_station.exit_loc_id>
<cfelse>
	<cfset _EXIT_DEP_ID = ''>
	<cfset _EXIT_LOC_ID = ''>
</cfif>
<cfif isdefined("get_station.production_dep_id") and len(get_station.production_dep_id)>
	<cfset _PRODUCTION_DEP_ID = get_station.production_dep_id>
	<cfset _PRODUCTION_LOC_ID = get_station.production_loc_id>
<cfelse>
	<cfset _PRODUCTION_DEP_ID = ''>
	<cfset _PRODUCTION_LOC_ID = ''>
</cfif>
<cfset temp_start = attributes.start_date>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cf_wrk_get_history datasource= "#dsn3#" source_table="PRODUCTION_ORDERS" target_table= "PRODUCTION_ORDERS_HISTORY" record_id="#attributes.P_ORDER_ID#"  record_name="P_ORDER_ID">
		<!---<cfinclude template="../query/add_sub_product_fire.cfm">--->
		<cfquery name="add_production_order_" datasource="#dsn3#"> 
			UPDATE [TEXTILE_PRODUCTION_ORDERS_MAIN]
			SET 
				[PARTY_STARTDATE] =#attributes.startdate_fn#
				,[PARTY_FINISHDATE] = #attributes.finishdate_fn#
				,[STAGE] =<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>
				,STATUS = <cfif isdefined('attributes.status')>1<cfelse>0</cfif>
				,[PROJECT_ID] =<cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>
				,DETAIL = '#attributes.detail#'
				,LOT_NO = <cfif isdefined('attributes.lot_no') and len(attributes.lot_no)>'#attributes.lot_no#'<cfelse>NULL</cfif>
				,EXIT_DEP_ID = <cfif len(_EXIT_DEP_ID) and _EXIT_DEP_ID gt 0>'#_EXIT_DEP_ID#'<cfelse>NULL</cfif>
				,EXIT_LOC_ID = <cfif len(_EXIT_LOC_ID) and _EXIT_LOC_ID gt 0>'#_EXIT_LOC_ID#'<cfelse>NULL</cfif>
				,PRODUCTION_DEP_ID = <cfif len(_PRODUCTION_DEP_ID) and _PRODUCTION_DEP_ID gt 0>'#_PRODUCTION_DEP_ID#'<cfelse>NULL</cfif>
				,PRODUCTION_LOC_ID = <cfif len(_PRODUCTION_LOC_ID) and _PRODUCTION_LOC_ID gt 0>'#_PRODUCTION_LOC_ID#'<cfelse>NULL</cfif>
				,STATION_ID = <cfif isdefined("attributes.station_id")  and len(attributes.station_id)>#attributes.station_id#<cfelse>NULL</cfif>
				,UPDATE_EMP = #session.ep.userid#
				,UPDATE_DATE = #now()#
				,UPDATE_IP = '#CGI.REMOTE_ADDR#'
			WHERE 
		     	PARTY_ID = #attributes.party_id#
		</cfquery>

			<cfquery name="add_production_order" datasource="#dsn3#"> 
			UPDATE 
				PRODUCTION_ORDERS
			SET
				STATION_ID = <cfif isdefined("attributes.station_id")  and len(attributes.station_id)>#attributes.station_id#,<cfelse>NULL,</cfif>
				START_DATE = #attributes.startdate_fn#,
				FINISH_DATE = #attributes.finishdate_fn#,
				PROD_ORDER_STAGE = <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>#attributes.process_stage#,<cfelse>NULL,</cfif>
				STATUS = <cfif isdefined('attributes.status')>1,<cfelse>0,</cfif>
				PROJECT_ID = <cfif len(attributes.project_id)>#attributes.project_id#,<cfelse>NULL,</cfif>
				DETAIL = '#attributes.detail#',
				IS_STOCK_RESERVED =  <cfif isdefined("attributes.stock_reserved")>1<cfelse>0</cfif>,
				IS_DEMONTAJ =0,
				REFERENCE_NO = <cfif isdefined('attributes.reference_no') and len(attributes.reference_no)>'#attributes.reference_no#'<cfelse>NULL</cfif>,
				LOT_NO = <cfif isdefined('attributes.lot_no') and len(attributes.lot_no)>'#attributes.lot_no#'<cfelse>NULL</cfif>,
				EXIT_DEP_ID = <cfif len(_EXIT_DEP_ID) and _EXIT_DEP_ID gt 0>'#_EXIT_DEP_ID#'<cfelse>NULL</cfif>,
				EXIT_LOC_ID = <cfif len(_EXIT_LOC_ID) and _EXIT_LOC_ID gt 0>'#_EXIT_LOC_ID#'<cfelse>NULL</cfif>,
				PRODUCTION_DEP_ID = <cfif len(_PRODUCTION_DEP_ID) and _PRODUCTION_DEP_ID gt 0>'#_PRODUCTION_DEP_ID#'<cfelse>NULL</cfif>,
				PRODUCTION_LOC_ID = <cfif len(_PRODUCTION_LOC_ID) and _PRODUCTION_LOC_ID gt 0>'#_PRODUCTION_LOC_ID#'<cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#'
			WHERE
				PARTY_ID = #attributes.party_id#<!--- İlişkili üretim emirleride beraber gönderildiği için ilk eleman yani ana üretim emirinin id'sini alıyoruz. --->
		</cfquery>
		
		
		
			
		
		
	</cftransaction>
</cflock>
</cfloop>

<!----
<cfif isdefined("attributes.p_order_id")>
	<cfscript>//ilişkili üretim emirlerine sonuç girilmemiş ise güncelleme yapılabilir!onun kontrolü
        related_production_list=attributes.p_order_id;
        function WriteRelatedProduction(P_ORDER_ID)
            {
                var i = 1;
                QueryText = '
                        SELECT 
                            P_ORDER_ID
                        FROM 
                            PRODUCTION_ORDERS
                        WHERE 
                            PO_RELATED_ID = #P_ORDER_ID#';
                'GET_RELATED_PRODUCTION#P_ORDER_ID#' = cfquery(SQLString : QueryText, Datasource : dsn3);
                if(Evaluate('GET_RELATED_PRODUCTION#P_ORDER_ID#').recordcount) 
                {
                    for(i=1;i lte Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").recordcount;i=i+1)
                    {
                        related_production_list = ListAppend(related_production_list,Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i],',');
                        WriteRelatedProduction(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]);
                    }
                }
            }
        WriteRelatedProduction(attributes.p_order_id);
    </cfscript>
    <cfset attributes.p_order_id = related_production_list>
    <cfquery name="GET_RELATED_PRODUCTION_RESULT" datasource="#dsn3#">
        SELECT PRODUCTION_ORDER_NO FROM PRODUCTION_ORDER_RESULTS WHERE P_ORDER_ID IN (#attributes.p_order_id#)
    </cfquery>
    <cfset related_production_no_list = ValueList(GET_RELATED_PRODUCTION_RESULT.PRODUCTION_ORDER_NO,',')>
    <cfif GET_RELATED_PRODUCTION_RESULT.recordcount and is_result_control eq 1><!--- xmle bağlandı --->
        <script type="text/javascript">
            alert("<cf_get_lang no ='635.Bu Üretim Emrinin İlişkili Olduğu Üretimlerden Sonuç Girilenler Var,Güncelleme Yapılamaz Sonuç Girilenler'>.! \n :<cfoutput>#related_production_no_list#</cfoutput>");
            history.go(-1);
        </script>
        <cfabort>
    </cfif>
</cfif>
<cf_date tarih="attributes.start_date">
<cf_date tarih="attributes.finish_date">
<cfscript>
	attributes.startdate_fn = date_add("n",attributes.start_m,date_add("h",attributes.start_h,attributes.start_date));
	attributes.finishdate_fn = date_add("n",attributes.finish_m,date_add("h",attributes.finish_h,attributes.finish_date));
	attributes.start_date = date_add("n",start_m,date_add("h",start_h - session.ep.time_zone,attributes.start_date));
	attributes.finish_date = date_add("n",finish_m,date_add("h",finish_h - session.ep.time_zone,attributes.finish_date));
</cfscript>
<cfif isdefined("attributes.station_id")  and len(attributes.station_id)>
	<cfquery name="GET_STATION" datasource="#dsn3#">
		SELECT 
			STATION_NAME,
			EXIT_DEP_ID,
			EXIT_LOC_ID,
			ENTER_DEP_ID,
			ENTER_LOC_ID,
			PRODUCTION_DEP_ID,
			PRODUCTION_LOC_ID
		FROM 
			WORKSTATIONS 
		WHERE 
			STATION_ID = #attributes.station_id#
	</cfquery>
</cfif>
<cfif isdefined("get_station.exit_dep_id") and len(get_station.exit_dep_id)>
	<cfset _EXIT_DEP_ID = get_station.exit_dep_id>
	<cfset _EXIT_LOC_ID = get_station.exit_loc_id>
<cfelse>
	<cfset _EXIT_DEP_ID = ''>
	<cfset _EXIT_LOC_ID = ''>
</cfif>
<cfif isdefined("get_station.production_dep_id") and len(get_station.production_dep_id)>
	<cfset _PRODUCTION_DEP_ID = get_station.production_dep_id>
	<cfset _PRODUCTION_LOC_ID = get_station.production_loc_id>
<cfelse>
	<cfset _PRODUCTION_DEP_ID = ''>
	<cfset _PRODUCTION_LOC_ID = ''>
</cfif>
<cfset temp_start = attributes.start_date>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cf_wrk_get_history datasource= "#dsn3#" source_table="PRODUCTION_ORDERS" target_table= "PRODUCTION_ORDERS_HISTORY" record_id="#attributes.P_ORDER_ID#"  record_name="P_ORDER_ID">
		<cfinclude template="../query/add_sub_product_fire.cfm">
		<cfquery name="add_production_order" datasource="#dsn3#">
			UPDATE 
				PRODUCTION_ORDERS
			SET
				STOCK_ID = #attributes.stock_id#, 
				QUANTITY = #attributes.quantity#,
				STATION_ID = <cfif isdefined("attributes.station_id")  and len(attributes.station_id)>#attributes.station_id#,<cfelse>NULL,</cfif>
				START_DATE = #attributes.startdate_fn#,
				FINISH_DATE = #attributes.finishdate_fn#,
				PROD_ORDER_STAGE = <cfif isdefined("attributes.process_stage")>#attributes.process_stage#,<cfelse>NULL,</cfif>
				STATUS = <cfif isdefined('attributes.status')>1,<cfelse>0,</cfif>
				<cfif isdefined('attributes.p_order_no')>P_ORDER_NO = '#attributes.p_order_no#',</cfif>
				PROJECT_ID = <cfif len(attributes.project_id)>#attributes.project_id#,<cfelse>NULL,</cfif>
				DETAIL = '#attributes.detail#',
				SPEC_MAIN_ID = <cfif len(attributes.SPECT_MAIN_ID)>#attributes.SPECT_MAIN_ID#<cfelse>NULL</cfif>,
				SPECT_VAR_ID = <cfif len(attributes.spect_var_id)>#attributes.spect_var_id#<cfelse>NULL</cfif>,
				SPECT_VAR_NAME = <cfif len(attributes.spect_var_name)>'#attributes.spect_var_name#'<cfelse>NULL</cfif>,
				IS_STOCK_RESERVED =  <cfif isdefined("attributes.stock_reserved")>1<cfelse>0</cfif>,
				IS_DEMONTAJ =  <cfif isdefined("attributes.is_demontaj")>1<cfelse>0</cfif>,
				REFERENCE_NO = <cfif isdefined('attributes.reference_no') and len(attributes.reference_no)>'#attributes.reference_no#'<cfelse>NULL</cfif>,
				LOT_NO = <cfif isdefined('attributes.lot_no') and len(attributes.lot_no)>'#attributes.lot_no#'<cfelse>NULL</cfif>,
				EXIT_DEP_ID = <cfif len(_EXIT_DEP_ID) and _EXIT_DEP_ID gt 0>'#_EXIT_DEP_ID#'<cfelse>NULL</cfif>,
				EXIT_LOC_ID = <cfif len(_EXIT_LOC_ID) and _EXIT_LOC_ID gt 0>'#_EXIT_LOC_ID#'<cfelse>NULL</cfif>,
				PRODUCTION_DEP_ID = <cfif len(_PRODUCTION_DEP_ID) and _PRODUCTION_DEP_ID gt 0>'#_PRODUCTION_DEP_ID#'<cfelse>NULL</cfif>,
				PRODUCTION_LOC_ID = <cfif len(_PRODUCTION_LOC_ID) and _PRODUCTION_LOC_ID gt 0>'#_PRODUCTION_LOC_ID#'<cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				WORK_ID = <cfif isdefined('attributes.work_id') and len(attributes.work_id) and len(attributes.work_head)>#attributes.work_id#<cfelse>NULL</cfif>
				<cfif isdefined('attributes.po_related_id') and len(attributes.po_related_id)>,PO_RELATED_ID = #attributes.po_related_id#</cfif>
			WHERE
				P_ORDER_ID = #ListGetAt(attributes.p_order_id,1,',')#<!--- İlişkili üretim emirleride beraber gönderildiği için ilk eleman yani ana üretim emirinin id'sini alıyoruz. --->
		</cfquery>
	   <cfquery name="add_production_order_related" datasource="#dsn3#">
			UPDATE 
				PRODUCTION_OPERATION
			SET
				AMOUNT =  #attributes.quantity#
			WHERE 
				P_ORDER_ID = #ListGetAt(attributes.p_order_id,1,',')#
		</cfquery>
		<cfif isdefined("is_related_por_amount_upd") and is_related_por_amount_upd eq 1><!--- xmlde ilişkili üretim emir miktarları güncellensin evet ise.. --->
			<cfif listlen(related_production_list,',') gt 1 and attributes.old_quantity neq attributes.quantity><!--- İlişkili üretim emirleri varsa ve miktar değişmiş ise ilişkili üretim emirlerinin miktarlarını da update ediyoruz. --->
				<cfset new_quantity_rate = (attributes.quantity/attributes.old_quantity)>
				<cfquery name="get_related_production_amounts" datasource="#dsn3#">
					SELECT QUANTITY,P_ORDER_ID,PO_RELATED_ID,STOCK_ID FROM PRODUCTION_ORDERS WHERE P_ORDER_ID IN (#related_production_list#)
				</cfquery>
				<cfquery name="get_related_production_amounts_sarf" datasource="#dsn3#">
					SELECT AMOUNT,P_ORDER_ID,POR_STOCK_ID,IS_FREE_AMOUNT,STOCK_ID FROM PRODUCTION_ORDERS_STOCKS WHERE TYPE = 2 AND P_ORDER_ID IN (#related_production_list#)
				</cfquery>
				<cfquery name="get_related_production_amounts_fire" datasource="#dsn3#">
					SELECT AMOUNT,P_ORDER_ID,POR_STOCK_ID,IS_FREE_AMOUNT,STOCK_ID FROM PRODUCTION_ORDERS_STOCKS WHERE TYPE = 3 AND P_ORDER_ID IN (#related_production_list#)
				</cfquery>
				<!--- İlişkili Üretim Emirlerinin Miktarlarını Aldık --->
				<cfset pos_id_list = ''>
				<cfset fire_pos_id_list = ''>
				<cfoutput query="get_related_production_amounts"><cfset 'quantity#P_ORDER_ID#' = QUANTITY ></cfoutput>
				<cfoutput query="get_related_production_amounts_sarf">
					<cfset 'quantity_#P_ORDER_ID#_#POR_STOCK_ID#' = AMOUNT>
					<cfset 'is_free_amount_#P_ORDER_ID#_#POR_STOCK_ID#' = IS_FREE_AMOUNT>
					<cfset pos_id_list = ListAppend(pos_id_list,POR_STOCK_ID)>
				</cfoutput>
				<cfoutput query="get_related_production_amounts_fire">
					<cfset 'fire_quantity_#P_ORDER_ID#_#POR_STOCK_ID#' = AMOUNT>
					<cfset 'fire_is_free_amount_#P_ORDER_ID#_#POR_STOCK_ID#' = IS_FREE_AMOUNT>
					<cfset fire_pos_id_list = ListAppend(fire_pos_id_list,POR_STOCK_ID)>
				</cfoutput>
				<!--- Şimdi Bu İlişkili Üretim Emirlerinin Miktarlarını Güncelliyoruz. --->
				<cfloop from="2" to="#listlen(attributes.p_order_id,',')#" index="p_o"><!--- 2 den başlatıyoruz çünkü üst tarafta zaten ana üretim güncelleniyor. --->
					<cfquery name="get_related_prod_amounts_" datasource="#dsn3#"><!--- ilişkili üemri --->
						SELECT QUANTITY,P_ORDER_ID,PO_RELATED_ID,STOCK_ID FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #ListGetAt(attributes.p_order_id,p_o,',')#
					</cfquery>
					<cfquery name="get_related_prod_amounts_sarf_" datasource="#dsn3#"><!--- üst üretim emrinin sarfları --->
						SELECT 
							AMOUNT,P_ORDER_ID,POR_STOCK_ID,IS_FREE_AMOUNT,STOCK_ID 
						FROM 
							PRODUCTION_ORDERS_STOCKS 
						WHERE 
							TYPE = 2 AND 
							P_ORDER_ID = #get_related_prod_amounts_.po_related_id# AND
							STOCK_ID = #get_related_prod_amounts_.stock_id#
					</cfquery>
					<cfset new_quantity_rate_ = (get_related_prod_amounts_sarf_.amount/get_related_prod_amounts_.quantity)>
					<!--- <cfoutput>#p_o#</cfoutput>
					<cfdump var="#get_related_prod_amounts_#">
					<cfdump var="#get_related_prod_amounts_sarf_#"> --->
				    <cfquery name="add_production_order_related" datasource="#dsn3#">
						UPDATE
							PRODUCTION_ORDERS
						SET
							QUANTITY =  #get_related_prod_amounts_sarf_.amount#
						WHERE 
							P_ORDER_ID = #ListGetAt(attributes.p_order_id,p_o,',')#
					</cfquery>
					<cfquery name="add_production_order_related" datasource="#dsn3#">
						UPDATE 
							PRODUCTION_OPERATION
						SET
							AMOUNT =  #get_related_prod_amounts_sarf_.amount#
						WHERE 
							P_ORDER_ID = #ListGetAt(attributes.p_order_id,p_o,',')#
					</cfquery>
					<cfloop from="1" to="#ListLen(pos_id_list)#" index="pos_id">
						<cfif isdefined("is_free_amount_#ListGetAt(attributes.p_order_id,p_o,',')#_#ListGetAt(pos_id_list,pos_id,',')#") and evaluate('is_free_amount_#ListGetAt(attributes.p_order_id,p_o,',')#_#ListGetAt(pos_id_list,pos_id,',')#') eq 0>
							<cfif isdefined("quantity_#ListGetAt(attributes.p_order_id,p_o,',')#_#ListGetAt(pos_id_list,pos_id,',')#")>
								<cfquery name="upd_related_production_amount_sarf" datasource="#dsn3#">
									UPDATE
										PRODUCTION_ORDERS_STOCKS
									SET
										AMOUNT = #Evaluate('quantity_#ListGetAt(attributes.p_order_id,p_o,',')#_#ListGetAt(pos_id_list,pos_id,',')#')*new_quantity_rate_#
									WHERE 
										P_ORDER_ID = #ListGetAt(attributes.p_order_id,p_o,',')# AND
										POR_STOCK_ID = #ListGetAt(pos_id_list,pos_id,',')#
								</cfquery>
							</cfif>
						</cfif>
					</cfloop>
					<cfloop from="1" to="#ListLen(fire_pos_id_list)#" index="pos_id">
						<cfif isdefined("fire_is_free_amount_#ListGetAt(attributes.p_order_id,p_o,',')#_#ListGetAt(fire_pos_id_list,pos_id,',')#") and evaluate('fire_is_free_amount_#ListGetAt(attributes.p_order_id,p_o,',')#_#ListGetAt(fire_pos_id_list,pos_id,',')#') eq 0>
							<cfif isdefined("fire_quantity_#ListGetAt(attributes.p_order_id,p_o,',')#_#ListGetAt(fire_pos_id_list,pos_id,',')#")>
								<cfquery name="upd_related_production_amount_fire" datasource="#dsn3#">
									UPDATE
										PRODUCTION_ORDERS_STOCKS
									SET
										AMOUNT = #Evaluate('fire_quantity_#ListGetAt(attributes.p_order_id,p_o,',')#_#ListGetAt(fire_pos_id_list,pos_id,',')#')*new_quantity_rate_#
									WHERE 
										P_ORDER_ID = #ListGetAt(attributes.p_order_id,p_o,',')# AND
										POR_STOCK_ID = #ListGetAt(fire_pos_id_list,pos_id,',')#
								</cfquery>
							</cfif>
						</cfif>
					</cfloop>
				</cfloop>
			</cfif>
		</cfif><!--- <cfabort> --->
		<cfquery name="GET_PAPER" datasource="#dsn3#">
			SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #ListGetAt(attributes.p_order_id,1,',')#
		</cfquery>
        <!--- Siparişten geliyorsa ve ürünün spec'i değiştirilmiş ise siparişle bağlantısının kopmamasını sağlıyoruz. --->
        <cfif isdefined('attributes.ORDER_ROW_ID') and len(attributes.ORDER_ROW_ID) and isdefined('attributes.OLD_SPECT_VAR_ID') and len(attributes.SPECT_VAR_ID) and attributes.OLD_SPECT_VAR_ID neq attributes.SPECT_VAR_ID>
            <!--- Bu bloğa girdi ise siparişteki spect_Var_id değişmiştir,o sebeble bizde siparişi güncelliyoruz. --->
            <cfquery name="UPD_ORDERS" datasource="#dsn3#">
            	UPDATE ORDER_ROW SET SPECT_VAR_ID = #attributes.SPECT_VAR_ID# WHERE ORDER_ROW_ID = #attributes.ORDER_ROW_ID#
            </cfquery>
        </cfif>
	</cftransaction>
</cflock>
<cfif xml_is_order_row_deliver_date_update eq 1><!--- XML ayarlarından üretim emrinin bitiş tarihi satış siparişinin teslim tarihini güncellensin seçilmiş ise. --->
	<cfif len(attributes.order_row_id)><!--- sipariş satır id'leri varsa --->
    	<cfquery name="update_order_row_deliver_date" datasource="#dsn3#">
        	UPDATE ORDER_ROW 
            SET DELIVER_DATE = #attributes.finishdate_fn#
            WHERE ORDER_ROW_ID IN (#attributes.order_row_id#)
        </cfquery>
    </cfif>
</cfif>
<cf_workcube_process
	is_upd='1' 
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_page='#request.self#?fuseaction=prod.form_upd_prod_order&upd=#ListGetAt(attributes.p_order_id,1,',')#' 
	action_id='#ListGetAt(attributes.p_order_id,1,',')#'
	action_table='PRODUCTION_ORDERS'
	action_column='P_ORDER_ID'
	old_process_line='#attributes.old_process_line#' 
	warning_description = 'Üretim Emri : #get_paper.p_order_no#'>
<cfif not isdefined('attributes.is_graph')><!--- Çizelge sayfasındaki güncelleme ekranından gelmiyorsa location yapsın --->
	<cflocation url="#request.self#?fuseaction=prod.form_upd_prod_order&upd=#ListGetAt(attributes.p_order_id,1,',')#" addtoken="no">
</cfif>
--->	

<cfloop from="1" to="#attributes.record_num_exit#" index="i">
			<cfset stock_id=evaluate("attributes.stock_id_exit#i#")>
			<cfset product_id=evaluate("attributes.product_id_exit#i#")>
			<cfset spect_main_id=evaluate("attributes.spec_main_id_exit#i#")>
			<cfset unit_id=evaluate("attributes.unit_id_exit#i#")>
			<cfset old_stock_id=evaluate("attributes.old_stock_id#i#")>
			<cfset spect_main_row_exit=evaluate("attributes.spect_main_row_exit#i#")>
			<cfif len(old_stock_id) and len(stock_id) and stock_id neq old_stock_id>
						<cfquery name="upd__" datasource="#dsn3#">
								UPDATE 
										POS
								SET 
									POS.STOCK_ID=#stock_id#,
									POS.PRODUCT_ID=#product_id#,
								POS.SPECT_MAIN_ID=<cfif len(spect_main_id)>#spect_main_id#<cfelse>NULL</cfif>,
									POS.SPECT_MAIN_ROW_ID=<cfif len(spect_main_row_exit)>#spect_main_row_exit#<cfelse>NULL</cfif>,
									POS.PRODUCT_UNIT_ID=#unit_id#
								FROM
								PRODUCTION_ORDERS_STOCKS POS,
								PRODUCTION_ORDERS PO
								WHERE 
									POS.P_ORDER_ID=PO.P_ORDER_ID AND
									PO.PARTY_ID=#attributes.party_id# AND
									POS.STOCK_ID=#old_stock_id# AND
									POS.TYPE=2
						</cfquery>
			</cfif>
</cfloop>
<cflocation url="#request.self#?fuseaction=textile.order&event=upd&party_id=#attributes.party_id#" addtoken="no">