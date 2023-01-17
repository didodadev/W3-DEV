<cfsetting showdebugoutput="no">
<cfif attributes.process_type eq 0 or attributes.process_type eq 3><!--- Talepler Üretime Çeviriliyorsa(0) yada Malzeme İhtiyaç Listesine Yönlendiriliyorsa...(3) --->
	<cfif ListLen(attributes.p_order_id_list,',')>
        <cfif attributes.process_type eq 0><!--- Sadece Üretime Çevirme yapılıyorsa Güncelleme Yapılsın! --->
			 <cfquery name="upd_demand_to_production" datasource="#dsn3#">
                UPDATE 
					PRODUCTION_ORDERS
                SET
                    IS_STOCK_RESERVED=1,
                    IS_STAGE = 4
                WHERE 
                    P_ORDER_ID IN (#attributes.p_order_id_list#)
            </cfquery>
            <cfquery name="UPD_PRODUCTION_ORDERS_ROW" datasource="#DSN3#"><!--- Talepler Üretime Çevirildiği İçin Artık Ara tablomuzdaki talebe çevirilen siparişleri üretime çevirildi diye değiştirmemiz gerekir! --->
				UPDATE
                	PRODUCTION_ORDERS_ROW
				SET 
                	TYPE=1<!--- 0 İSE TALEP 1 İSE ÜRETİM. --->
                WHERE 
                    PRODUCTION_ORDER_ID IN (#attributes.p_order_id_list#)
            </cfquery>
        </cfif>
        <cfquery name="get_demand_min_max_date" datasource="#dsn3#">
            SELECT 
	            dateadd(dd,-1,MIN(START_DATE)) as START_DATE,
    	        dateadd(dd,1,MAX(FINISH_DATE)) as FINISH_DATE 
            FROM 
        	    PRODUCTION_ORDERS
            WHERE 
            	P_ORDER_ID IN (#attributes.p_order_id_list#)   
        </cfquery>
			<cfquery name="get_p_order_no_list" datasource="#dsn3#">
				SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID IN (#attributes.p_order_id_list#)  
			</cfquery>
			<cfset p_order_no_list = ValueList(get_p_order_no_list.P_ORDER_NO,',')>
        <script type="text/javascript">
			<cfoutput>
			<cfif attributes.process_type eq 0><!--- Sadece Üretime Çevirildiğinde Bu Mesajı Versin! --->
				opener.document.go_p_order_list.keyword.value = '#p_order_no_list#';
				opener.window.go_p_order_list.action = "#request.self#?fuseaction=prod.order";
				opener.alert('Toplam #ListLen(attributes.p_order_id_list,',')# Adet Talep Üretime Çevirildi!')
			<cfelse>
				opener.document.go_p_order_list.row_demand_all.value = '';
				opener.document.go_p_order_list.production_order_no.value = '#p_order_no_list#';
				opener.window.go_p_order_list.action = "#request.self#?fuseaction=prod.list_materials_total&is_submitted=1";
			</cfif>
			opener.window.go_p_order_list.submit();
			window.close();
			</cfoutput>
        </script>
    </cfif>
<cfelseif attributes.process_type eq 1 or attributes.process_type eq 5>
	<cfif isdefined("attributes.process_stage_") and len(attributes.process_stage_)>
		<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
			SELECT
				STAGE
			FROM
				PROCESS_TYPE_ROWS
			WHERE
				PROCESS_ROW_ID = #attributes.process_stage_#
		</cfquery>			
	</cfif>
	<cfif ListLen(attributes.p_order_id_list,',')>
		<cfloop list="#attributes.p_order_id_list#" delimiters="," index="p_order_id"> 	
        	<cfscript>//ilişkili üretim emirlerine sonuç girilmemiş ise güncelleme yapılabilir!onun kontrolü
				related_production_list=p_order_id;
				function WriteRelatedProduction(p_order_id)
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
				WriteRelatedProduction(p_order_id);
			</cfscript>
			<cfif isdefined("attributes.production_start_date_#p_order_id#") and isdate(Evaluate("attributes.production_start_date_#p_order_id#"))>
                <cf_date tarih = "attributes.production_start_date_#p_order_id#">
                <cfset production_start_date = date_add("n",Evaluate("attributes.production_start_m_#p_order_id#"),date_add("h",Evaluate("attributes.production_start_h_#p_order_id#") ,Evaluate("attributes.production_start_date_#p_order_id#")))><!--- - session.ep.time_zone --->
            <cfelse>
                <cfset production_start_date =''>
            </cfif>
			<cfif isdefined("attributes.production_finish_date_#p_order_id#") and isdate(Evaluate("attributes.production_finish_date_#p_order_id#"))>
                <cf_date tarih = "attributes.production_finish_date_#p_order_id#">
                <cfset production_finish_date = date_add("n",Evaluate("attributes.production_finish_m_#p_order_id#"),date_add("h",Evaluate("attributes.production_finish_h_#p_order_id#") ,Evaluate("attributes.production_finish_date_#p_order_id#")))><!--- - session.ep.time_zone --->
            <cfelse>
                <cfset production_finish_date =''>
            </cfif>
            <cfset quantity = filternum(Evaluate("attributes.quantity_#p_order_id#"),3)>
            <cfif isdefined("attributes.is_upd_related_demands") and attributes.is_upd_related_demands eq 1><!--- Eğer xml de seçilmişse ilişkili talepleri güncelliyor --->
				<cfset old_quantity =Evaluate("attributes.old_quantity_#p_order_id#")>
				<cfset new_quantity_rate = (quantity/old_quantity)>
				<cfquery name="get_related_production_amounts" datasource="#dsn3#">
					SELECT QUANTITY,P_ORDER_ID,P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID IN (#related_production_list#)
				</cfquery>
				<cfoutput query="get_related_production_amounts"><cfset 'quantity#P_ORDER_ID#' = QUANTITY ></cfoutput>
				<cfloop from="2" to="#listlen(related_production_list,',')#" index="p_o"><!--- 2 den başlatıyoruz çünkü üst tarafta zaten ana üretim güncelleniyor. --->
				   <cfquery name="add_production_order_related" datasource="#dsn3#">
						UPDATE 
							PRODUCTION_ORDERS
						SET
							QUANTITY =  #Evaluate('quantity#ListGetAt(related_production_list,p_o,',')#')*new_quantity_rate#,
							UPDATE_EMP = #SESSION.EP.USERID#,
							UPDATE_DATE = #NOW()#,
							UPDATE_IP = '#CGI.REMOTE_ADDR#'
						WHERE 
							P_ORDER_ID = #ListGetAt(related_production_list,p_o,',')#
					</cfquery>
				</cfloop>
            <cfelse>
                <cfquery name="get_related_production_amounts" datasource="#dsn3#">
                    SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID IN (#related_production_list#)
                </cfquery>				
			</cfif>
			<cfif isdefined("attributes.station_id_#p_order_id#")>
				<cfset station_id = Evaluate("attributes.station_id_#p_order_id#")>
			</cfif>
            <cfquery name="update_production_demands" datasource="#dsn3#">
            	UPDATE 
                	PRODUCTION_ORDERS
				SET
					UPDATE_EMP = #SESSION.EP.USERID#,
					UPDATE_DATE = #NOW()#,
					UPDATE_IP = '#CGI.REMOTE_ADDR#'
					<cfif isdate(production_start_date) and len(production_start_date)>,START_DATE = #production_start_date#</cfif>
                    <cfif isdate(production_finish_date) and len(production_finish_date)>, FINISH_DATE = #production_finish_date#</cfif>
					<cfif isdefined("attributes.process_stage_") and len(attributes.process_stage_)>
						,PROD_ORDER_STAGE = #attributes.process_stage_#
					</cfif><!--- asama geliyorsa asamayi guncelle gelmiyorsa asama ile ilgili hicbir islem yapma yo09122009--->
                    <cfif isdefined("attributes.station_id_#p_order_id#")>
						,STATION_ID = <cfif len(station_id)>#station_id#<cfelse>NULL</cfif>
						,QUANTITY =  <cfif len(quantity)>#quantity#<cfelse>NULL</cfif>
					</cfif>
				WHERE
                	P_ORDER_ID = #p_order_id#
			</cfquery>
             <cf_workcube_process
                is_upd='1' 
                process_stage='#attributes.process_stage_#' 
                record_member='#session.ep.userid#' 
                record_date='#now()#' 
                action_page='#request.self#?fuseaction=prod.form_upd_prod_order&upd=#p_order_id#' 
                action_id='#p_order_id#'
                action_table='PRODUCTION_ORDERS'
                action_column='P_ORDER_ID'
                old_process_line='#p_order_id#' 
                warning_description = "#getLang('','Üretim Emri',49884)# : #get_related_production_amounts.p_order_no#">
			<cfif isdefined("attributes.process_stage_") and len(attributes.process_stage_)>
				<cfoutput>
					<script type="text/javascript">
						if(document.getElementById("td_process_#p_order_id#") != undefined)
							document.getElementById("td_process_#p_order_id#").innerHTML = '#GET_PROCESS_TYPE.STAGE#';
					</script>
				</cfoutput>
			</cfif>
        </cfloop>
        <script type="text/javascript">
			<cfoutput>
				<cfif attributes.process_type eq 1>
					alert('Toplam #ListLen(attributes.p_order_id_list,',')# Adet Talep Güncellendi!');
				<cfelse>
					alert('Toplam #ListLen(attributes.p_order_id_list,',')# Adet Emir Güncellendi!');
				</cfif>
				opener.window.search_list.submit();
				window.close();
			</cfoutput>
        </script>
    </cfif>
<cfelseif attributes.process_type eq 6>
	<cfif ListLen(attributes.p_order_id_list,',')>
		<cfloop list="#attributes.p_order_id_list#" delimiters="," index="p_order_id"> 	
			<cfquery name="delete_production_demands" datasource="#dsn3#">
				DELETE FROM
					PRODUCTION_ORDERS
				WHERE
					P_ORDER_ID = #p_order_id#
			</cfquery>
        </cfloop>
	</cfif>
	<script type="text/javascript">
		<cfoutput>
			<cfif attributes.process_type eq 6>
				alert('Toplam #ListLen(attributes.p_order_id_list,',')# Adet Talep Silindi!');
				opener.window.search_list.submit();
				window.close();
			</cfif>
		</cfoutput>
     </script>
<cfelseif attributes.process_type eq 7>
	<cfloop from="1" to="#listlen(attributes.row_demand)#" index="i">
		<cfif attributes.result eq 1>
			<cfquery name="upd_operation_result" datasource="#dsn3#">
				UPDATE
					PRODUCTION_OPERATION_RESULT
				SET
					STATION_ID = #listgetat(attributes.station_id_list,i,';')#,
					ACTION_EMPLOYEE_ID = #listgetat(attributes.employee_id_list,i,';')#,
					REAL_AMOUNT = #listgetat(attributes.amount_list,i,';')#,
					UPDATE_EMP = #SESSION.EP.USERID#,
					UPDATE_DATE = #NOW()#,
					UPDATE_IP = '#CGI.REMOTE_ADDR#'
				WHERE
					OPERATION_RESULT_ID = #listgetat(attributes.operation_result_id_list,i,';')#
			</cfquery>
		<cfelse>
        <cfquery name="GET_O" datasource="#DSN3#">
                SELECT 
                	P_OPERATION_ID
                FROM
                    PRODUCTION_OPERATION
                WHERE 
                    P_ORDER_ID = #listgetat(attributes.p_order_id_list,i)#
                    AND OPERATION_TYPE_ID = #listgetat(attributes.operation_id_list,i,';')#
            </cfquery>
			<cfquery name="add_operation_result" datasource="#dsn3#">
				INSERT INTO
					PRODUCTION_OPERATION_RESULT
				(
					P_ORDER_ID,
					OPERATION_ID,
					STATION_ID,
					REAL_AMOUNT,
					LOSS_AMOUNT,
					REAL_TIME,
					WAIT_TIME,
					ACTION_EMPLOYEE_ID,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					#listgetat(attributes.p_order_id_list,i)#,
					<cfif GET_O.recordcount>#GET_O.P_OPERATION_ID#<cfelse>#listgetat(attributes.operation_id_list,i,';')#</cfif>,
					#listgetat(attributes.station_id_list,i,';')#,
					#listgetat(attributes.amount_list,i,';')#,
					0,
					0,
					0,
					#listgetat(attributes.employee_id_list,i,';')#,
					#session.ep.userid#,
					#NOW()#,
					'#CGI.REMOTE_ADDR#'
				)
			</cfquery>
		</cfif>
	
	</cfloop>
	<script type="text/javascript">
		<cfoutput>
			<cfif attributes.result eq 1>
				alert('Toplam #ListLen(attributes.p_order_id_list,',')# Adet Operasyon Sonucu Güncellendi!');
			<cfelse>
				alert('Toplam #ListLen(attributes.p_order_id_list,',')# Adet Operasyon Sonucu Eklendi!');
			</cfif>
			window.close();
		</cfoutput>
		location.href=document.referrer;
	</script>
</cfif>
