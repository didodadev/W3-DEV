<cf_xml_page_edit fuseact="prod.add_prod_order"><!--- Ürtim Emri XML AYARLARI --->
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
				QUANTITY = #filternum(attributes.quantity,8)#,
                QUANTITY_2=<cfif isdefined("attributes.quantity2")  and len(attributes.quantity2)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#filternum(attributes.quantity2,8)#"><cfelse>NULL</cfif>,
                UNIT_2=<cfif isdefined("attributes.unit_2_text")  and len(attributes.unit_2_text)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.unit_2_text#"><cfelse>NULL</cfif>,
				STATION_ID = <cfif isdefined("attributes.station_id")  and len(attributes.station_id)>#attributes.station_id#,<cfelse>NULL,</cfif>
				START_DATE = #attributes.startdate_fn#,
				FINISH_DATE = #attributes.finishdate_fn#,
				PROD_ORDER_STAGE = <cfif isdefined("attributes.process_stage")>#attributes.process_stage#,<cfelse>NULL,</cfif>
				STATUS = <cfif isdefined('attributes.status')>1,<cfelse>0,</cfif>
				<cfif isdefined('attributes.p_order_no')>P_ORDER_NO = '#attributes.p_order_no#',</cfif>
				PROJECT_ID = <cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#,<cfelse>NULL,</cfif>
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
				AMOUNT =  #filternum(attributes.quantity,8)#
			WHERE 
				P_ORDER_ID = #ListGetAt(attributes.p_order_id,1,',')#
		</cfquery>
		<cfif isdefined("is_related_por_amount_upd") and is_related_por_amount_upd eq 1><!--- xmlde ilişkili üretim emir miktarları güncellensin evet ise.. --->
			<cfif listlen(related_production_list,',') gt 1 and attributes.old_quantity neq attributes.quantity><!--- İlişkili üretim emirleri varsa ve miktar değişmiş ise ilişkili üretim emirlerinin miktarlarını da update ediyoruz. --->
				<cfset new_quantity_rate = (filternum(attributes.quantity,8)/filternum(attributes.old_quantity,8))>
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
                    <cfif get_related_prod_amounts_sarf_.recordcount>
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
                     </cfif>
				</cfloop>
			</cfif>
		</cfif><!--- <cfabort> --->
		<cfquery name="GET_PAPER" datasource="#dsn3#">
			SELECT P_ORDER_NO,P_ORDER_ID FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #ListGetAt(attributes.p_order_id,1,',')#
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
<cfif isdefined("attributes.is_generate_serial_nos") and attributes.is_generate_serial_nos eq 1>
    <cfquery name="ctrl_seri" datasource="#dsn3#">
    	SELECT GUARANTY_ID FROM SERVICE_GUARANTY_NEW WHERE PROCESS_ID = #ListGetAt(attributes.p_order_id,1,',')# AND PROCESS_CAT = 1194
    </cfquery>
    <cfif ctrl_seri.recordcount>
    	<cfquery name="dlt_seri" datasource="#dsn3#">
        	DELETE FROM SERVICE_GUARANTY_NEW WHERE PROCESS_ID = #ListGetAt(attributes.p_order_id,1,',')# AND PROCESS_CAT = 1194
        </cfquery>
    </cfif>
	<cfquery name="get_product_guaranty" datasource="#dsn3#">
		SELECT S.STOCK_CODE,S.IS_SERIAL_NO,S.PRODUCT_ID, G.TAKE_GUARANTY_CAT_ID FROM STOCKS S LEFT JOIN PRODUCT_GUARANTY G ON G.PRODUCT_ID = S.PRODUCT_ID WHERE S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	</cfquery>
    <cfif get_product_guaranty.IS_SERIAL_NO>
		<cfset year_ = mid(session.ep.period_year,3,2)>
        <cfset lot_no_ = listlast(attributes.lot_no,'-')>
        <cfset attributes.amount = filterNum(quantity)>
        <cfset attributes.department_id = _PRODUCTION_DEP_ID>
        <cfset attributes.guarantycat_id = get_product_guaranty.TAKE_GUARANTY_CAT_ID>
        <cfset attributes.location_id = _PRODUCTION_LOC_ID>
        <cfset attributes.method = 0><!--- Standart Oluşturma--->
        <cfset attributes.m_type = 3><!--- Sondan Artmalı --->
        <cfset attributes.process_cat = 1194>
        <cfif isdefined("attributes.p_order_no")>
        	<cfset attributes.process_number = attributes.p_order_no>
        <cfelse>
        	<cfset attributes.process_number = attributes.demand_no>
        </cfif>
        <cfset attributes.product_amount = filterNum(quantity)>
        <cfset attributes.stock_id = attributes.stock_id>
        <cfset attributes.ship_start_no = year_&lot_no_>
        <cfset attributes.ship_start_no_orta = listlast(get_product_guaranty.STOCK_CODE,'.')>
        <cfset attributes.ship_start_no_son = 001>
        <cfset attributes.start_date = dateformat(now(),dateformat_style)>
        <cfset is_generate_serial_nos = 1>
        <cfset uploaded_file = dateformat(now(),dateformat_style)>
        <cfset take_get = 0>
        <cfset attributes.take_get = 0>
        <cfset attributes.rma_no = "">
        <cfset attributes.wrk_row_id = "">
        <cfset attributes.process_id = ListGetAt(attributes.p_order_id,1,',')>
        <cfset attributes.company_id = -1>
        <cfset attributes.partner_id = -1>
        <cfset attributes.consumer_id = -1>
        <cfset attributes.spect_id = attributes.spect_var_id>
        <cfset attributes.main_stock_id = "">
        <cfset attributes.process_date = attributes.start_date>
        <cfset attributes.lot_no = "">
        <cfset attributes.product_id = get_product_guaranty.product_id>
        <cfset attributes.order_type_ = 1> <!--- Ana Emir --->
        <cfinclude template="../../objects/query/add_stock_serial_no.cfm">
    </cfif>
    <!---İlişkili Üretm Emri için  --->
    <cfquery name="get_related_orders" datasource="#dsn3#">
        <cfloop list="#attributes.p_order_id#" index="i">
            SELECT
                PO.P_ORDER_ID,
                PO.P_ORDER_NO,
                PO.STOCK_ID,
                PO.SPECT_VAR_ID,
                PO.QUANTITY,
                S.STOCK_CODE,
                S.PRODUCT_NAME,
                WORKSTATIONS.PRODUCTION_DEP_ID,
                WORKSTATIONS.PRODUCTION_LOC_ID,
                PO.LOT_NO
            FROM
                STOCKS S,
                PRODUCTION_ORDERS PO LEFT JOIN WORKSTATIONS
                ON PO.STATION_ID = WORKSTATIONS.STATION_ID
            WHERE
                S.STOCK_ID = PO.STOCK_ID AND
                PO_RELATED_ID =  #i#
            <cfif listfind(attributes.p_order_id,i) neq 0 and listlast(attributes.p_order_id) neq i>UNION</cfif>
        </cfloop>
    </cfquery>
    <!--- silme eklenecek --->
    <cfif get_related_orders.recordcount>
        <cfquery name="ctrl_seri2" datasource="#dsn3#">
            SELECT GUARANTY_ID FROM SERVICE_GUARANTY_NEW WHERE PROCESS_ID IN  (#valuelist(get_related_orders.p_order_id)#) AND PROCESS_CAT = 1194
        </cfquery>
        <cfif ctrl_seri2.recordcount>
            <cfquery name="dlt_seri" datasource="#dsn3#">
                DELETE FROM SERVICE_GUARANTY_NEW WHERE GUARANTY_ID IN  (#valuelist(ctrl_seri2.GUARANTY_ID)#)
            </cfquery>
        </cfif>
        <cfoutput QUERY="get_related_orders">
            <cfquery name="get_product_guaranty2" datasource="#dsn3#">
                SELECT S.STOCK_CODE,S.IS_SERIAL_NO,S.PRODUCT_ID, G.TAKE_GUARANTY_CAT_ID FROM STOCKS S LEFT JOIN PRODUCT_GUARANTY G ON G.PRODUCT_ID = S.PRODUCT_ID WHERE S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_orders.stock_id#">
            </cfquery>
            <cfif get_product_guaranty2.IS_SERIAL_NO>
                <cfset year_ = mid(session.ep.period_year,3,2)>
                <cfset lot_no_ = listlast(get_related_orders.lot_no,'-')>
                <cfset attributes.amount = filterNum(get_related_orders.quantity)>
                <cfset attributes.department_id = get_related_orders.PRODUCTION_DEP_ID>
                <cfset attributes.guarantycat_id = get_product_guaranty2.TAKE_GUARANTY_CAT_ID>
                <cfset attributes.location_id = get_related_orders.PRODUCTION_LOC_ID>
                <cfset attributes.method = 0><!--- Standart Oluşturma--->
                <cfset attributes.m_type = 3><!--- Sondan Artmalı --->
                <cfset attributes.process_cat = 1194>
                <cfset attributes.process_number = get_related_orders.p_order_no>
                <cfset attributes.product_amount = filterNum(get_related_orders.quantity)>
                <cfset attributes.stock_id = get_related_orders.stock_id>
                <cfset attributes.ship_start_no = year_&lot_no_>
                <cfset attributes.ship_start_no_orta = listlast(get_product_guaranty2.STOCK_CODE,'.')>
                <cfset attributes.ship_start_no_son = 001>
                <cfset attributes.start_date = dateformat(now(),dateformat_style)>
                <cfset is_generate_serial_nos = 1>
                <cfset uploaded_file = dateformat(now(),dateformat_style)>
                <cfset take_get = 0>
                <cfset attributes.take_get = 0>
                <cfset attributes.rma_no = "">
                <cfset attributes.wrk_row_id = "">
                <cfset attributes.process_id = get_related_orders.p_order_id>
                <cfset attributes.company_id = -1>
                <cfset attributes.partner_id = -1>
                <cfset attributes.consumer_id = -1>
                <cfset attributes.spect_id = get_related_orders.spect_var_id>
                <cfset attributes.main_stock_id = "">
                <cfset attributes.lot_no = "">
                <cfset attributes.product_id = get_product_guaranty2.product_id>
                <cfset attributes.order_type_ = 2> <!--- Alt Emir --->
                <cfinclude template="../../objects/query/add_stock_serial_no.cfm">
            </cfif>
    	</cfoutput>
    </cfif>
</cfif>
<cf_workcube_process
	is_upd='1' 
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_page='#request.self#?fuseaction=prod.order&event=upd&upd=#get_paper.p_order_no#' 
	action_id='#get_paper.p_order_id#'
	action_table='PRODUCTION_ORDERS'
	action_column='P_ORDER_ID'
	old_process_line='#attributes.old_process_line#' 
	warning_description = "#getLang('','Üretim Emri',49884)# : #get_paper.p_order_no#">
    <cf_add_log  log_type="0" action_id="#ListGetAt(attributes.p_order_id,1,',')#" action_name="#get_paper.p_order_no#" paper_no="#get_paper.p_order_no#" data_source="#dsn3#" process_stage="#attributes.process_stage#">
<cfset attributes.actionId=ListGetAt(attributes.p_order_id,1,',')>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=prod.order&event=upd&upd=#get_paper.p_order_no#</cfoutput>";
</script>
