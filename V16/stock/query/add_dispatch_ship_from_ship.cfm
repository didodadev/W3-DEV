<!--- mal alım irsaliyesinden sevk irsaliyesi oluşturmak için yapıldı. hgul 20121003 --->
<cfset form.process_cat = attributes.process_cat>
<cfscript>
	GET_AMOUNT = QueryNew ("WRK_ROW_ID,STOCK_ID,PRODUCT_ID,DEPARTMENT_IN_ID,LOCATION_IN_ID,AMOUNT,SHELF_ID,NAME_PRODUCT,UNIT_ID,UNIT,EXTRA_COST,COST_PRICE,SPECT_VAR_ID,SPECT_VAR_NAME,DELIVER_STORE_ID,LOCATION,SHIP_NUMBER,DELIVER_EMP_ID,ROW_PROJECT_ID,PRODUCT_NAME2,BASKET_EMPLOYEE_ID,DISCOUNTTOTAL","VarChar,integer,integer,integer,integer,Decimal,integer,VarChar,integer,VarChar,Decimal,Decimal,integer,VarChar,integer,integer,VarChar,integer,integer,VarChar,integer,Decimal");
	row_of_query = 0;
	attributes.WRK_ROW_ID = '';
	attributes.STOCK_ID = '';
	attributes.PRODUCT_ID = '';
	attributes.AMOUNT = '';
	attributes.DEPARTMENT_IN_ID = '';
	attributes.LOCATION_IN_ID = '';
	attributes.SHELF_ID = '';
	attributes.NAME_PRODUCT = '';
	attributes.UNIT_ID = '';
	attributes.UNIT = '';
	attributes.EXTRA_COST = '';
	attributes.COST_PRICE = '';
	attributes.SPECT_VAR_ID = '';
	attributes.SPECT_VAR_NAME = '';
	attributes.DELIVER_STORE_ID = '';
	attributes.LOCATION = '';
	attributes.SHIP_NUMBER = '';
	attributes.DELIVER_EMP_ID = '';
	attributes.ROW_PROJECT_ID = '';
	attributes.PRODUCT_NAME2 = '';
	attributes.BASKET_EMPLOYEE_ID = '';
	attributes.DISCOUNTTOTAL = '';
</cfscript>
<cfif isdefined("attributes.row_list")>
	<cfset row_list_ = attributes.row_list>
<cfelseif isdefined("attributes.occured_row_list")>
	<cfset row_list_ = attributes.occured_row_list>
</cfif>

<cfloop list="#row_list_#" index="ii" delimiters="█">
	<cfscript>
		attributes.WRK_ROW_ID = ListAppend(attributes.WRK_ROW_ID,Listgetat(ii,1,'§'),',');
		attributes.STOCK_ID = ListAppend(attributes.STOCK_ID,Listgetat(ii,2,'§'),',');
		attributes.PRODUCT_ID = ListAppend(attributes.PRODUCT_ID,Listgetat(ii,3,'§'),',');
		attributes.AMOUNT = ListAppend(attributes.AMOUNT,Listgetat(ii,4,'§'),',');
		attributes.DEPARTMENT_IN_ID = ListAppend(attributes.DEPARTMENT_IN_ID,Listgetat(ii,5,'§'),',');
		attributes.LOCATION_IN_ID = ListAppend(attributes.LOCATION_IN_ID,Listgetat(ii,6,'§'),',');
		attributes.SHELF_ID = ListAppend(attributes.SHELF_ID,Listgetat(ii,7,'§'),',');
		attributes.NAME_PRODUCT = ListAppend(attributes.NAME_PRODUCT,Listgetat(ii,8,'§'),',');
		attributes.UNIT_ID = ListAppend(attributes.UNIT_ID,Listgetat(ii,9,'§'),',');
		attributes.UNIT = ListAppend(attributes.UNIT,Listgetat(ii,10,'§'),',');
		attributes.EXTRA_COST = ListAppend(attributes.EXTRA_COST,Listgetat(ii,11,'§'),',');
		attributes.COST_PRICE = ListAppend(attributes.COST_PRICE,Listgetat(ii,12,'§'),',');
		attributes.SPECT_VAR_ID = ListAppend(attributes.SPECT_VAR_ID,Listgetat(ii,13,'§'),',');
		attributes.SPECT_VAR_NAME = ListAppend(attributes.SPECT_VAR_NAME,Listgetat(ii,14,'§'),',');
		attributes.DELIVER_STORE_ID = ListAppend(attributes.DELIVER_STORE_ID,Listgetat(ii,15,'§'),',');
		attributes.LOCATION = ListAppend(attributes.LOCATION,Listgetat(ii,16,'§'),',');
		attributes.SHIP_NUMBER = ListAppend(attributes.SHIP_NUMBER,Listgetat(ii,17,'§'),',');
		attributes.DELIVER_EMP_ID = ListAppend(attributes.DELIVER_EMP_ID,Listgetat(ii,18,'§'),',');
		attributes.ROW_PROJECT_ID = ListAppend(attributes.ROW_PROJECT_ID,Listgetat(ii,19,'§'),',');
		attributes.PRODUCT_NAME2 = ListAppend(attributes.PRODUCT_NAME2,Listgetat(ii,20,'§'),',');
		attributes.BASKET_EMPLOYEE_ID = ListAppend(attributes.BASKET_EMPLOYEE_ID,Listgetat(ii,21,'§'),',');
		attributes.DISCOUNTTOTAL = ListAppend(attributes.DISCOUNTTOTAL,Listgetat(ii,22,'§'),',');
		row_of_query = row_of_query + 1;
		QueryAddRow(GET_AMOUNT,1);
		QuerySetCell(GET_AMOUNT,"WRK_ROW_ID","#Listgetat(ii,1,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"STOCK_ID","#Listgetat(ii,2,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"PRODUCT_ID","#Listgetat(ii,3,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"AMOUNT","#Listgetat(ii,4,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"DEPARTMENT_IN_ID","#Listgetat(ii,5,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"LOCATION_IN_ID","#Listgetat(ii,6,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"SHELF_ID","#Listgetat(ii,7,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"NAME_PRODUCT","#Listgetat(ii,8,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"UNIT_ID","#Listgetat(ii,9,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"UNIT","#Listgetat(ii,10,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"EXTRA_COST","#Listgetat(ii,11,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"COST_PRICE","#Listgetat(ii,12,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"SPECT_VAR_ID","#Listgetat(ii,13,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"SPECT_VAR_NAME","#Listgetat(ii,14,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"DELIVER_STORE_ID","#Listgetat(ii,15,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"LOCATION","#Listgetat(ii,16,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"SHIP_NUMBER","#Listgetat(ii,17,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"DELIVER_EMP_ID","#Listgetat(ii,18,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"ROW_PROJECT_ID","#Listgetat(ii,19,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"PRODUCT_NAME2","#Listgetat(ii,20,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"BASKET_EMPLOYEE_ID","#Listgetat(ii,21,'§')#",row_of_query);
		QuerySetCell(GET_AMOUNT,"DISCOUNTTOTAL","#Listgetat(ii,22,'§')#",row_of_query);
	</cfscript>
</cfloop>
<cfquery name="get_amount_" dbtype="query">
	SELECT * FROM GET_AMOUNT ORDER BY DELIVER_STORE_ID,DEPARTMENT_IN_ID,LOCATION,LOCATION_IN_ID
</cfquery>
<cfset attributes.rows_ = get_amount_.recordcount>
<cfset form.BASKET_NET_TOTAL = 0>
<cfset form.BASKET_RATE1 = 1>
<cfset form.BASKET_RATE2 = 1>
<cfset dept_id_list = listdeleteduplicates(ValueList(get_amount_.DEPARTMENT_IN_ID))>
<cfinclude template="get_process_cat.cfm">
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date' >
<cfif not isDefined("new_dsn2")><cfset new_dsn2 = dsn2></cfif>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfif isdefined("attributes.is_from_report_sevk")><!--- ilk inşaat özel rapor için py--->
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
			<!--- Varsa Oncelikli Belge numaralarindan Alinacak Sekilde Duzenlendi fbs 20130111 --->
			<cfquery name="Get_Paper_No" datasource="#dsn2#">
				SELECT TOP 1 ISNULL(PRINTER_ID,0) PRINTER_ID, SHIP_NO, SHIP_NUMBER FROM #dsn3_alias#.PAPERS_NO WHERE SHIP_NUMBER IS NOT NULL AND (PRINTER_ID IN (SELECT SPU.PRINTER_ID FROM #dsn_alias#.SETUP_PRINTER_USERS SPU WHERE SPU.PRINTER_EMP_ID = #session.ep.userid#) OR EMPLOYEE_ID = #session.ep.userid#) ORDER BY PRINTER_ID DESC
			</cfquery>
			<cfif Get_Paper_No.RecordCount>
				<cfset ship_number_ = "#Get_Paper_No.Ship_No#-#Get_Paper_No.Ship_Number+1#">
				<cfif Get_Paper_No.Printer_Id neq 0><cfset attributes.paper_printer_id = Get_Paper_No.Printer_Id></cfif>
				
				<cfif Len(ship_number_)>
					<cfquery name="UPD_PAPERS" datasource="#new_dsn2#">
						UPDATE
							#dsn3_alias#.PAPERS_NO
						SET
							SHIP_NUMBER = #ListLast(ship_number_,'-')#
						WHERE
						<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
							PRINTER_ID = #attributes.paper_printer_id#
						<cfelse>
							EMPLOYEE_ID = #session.ep.userid#
						</cfif>
					</cfquery>
				</cfif>
			<cfelse>
				<!--- Yoksa Eski Tanim Devam Eder --->
				<cfquery name="get_ship_number" datasource="#dsn2#">
					SELECT MAX(CAST(REPLACE(SHIP_NUMBER,'SVK-IRS-','') AS INT)) SHIP_NUMBER FROM SHIP WHERE SHIP_NUMBER LIKE 'SVK-IRS-%'
				</cfquery>
				<cfif get_ship_number.recordcount and len(get_ship_number.SHIP_NUMBER)>
					<cfset ship_number_ = ListLast(get_ship_number.SHIP_NUMBER,'-') + 1>
					<cfset ship_number_ = 'SVK-IRS'&'-'&'#ship_number_#'>
				<cfelse>
					<cfset ship_number_ = 'SVK-IRS-1'>
				</cfif>
			</cfif>
			<cfquery name="ADD_SALE" datasource="#new_dsn2#" result="MAX_ID">
					INSERT INTO
						#dsn2_alias#.SHIP
					(
						WRK_ID,
						PURCHASE_SALES,
						SHIP_NUMBER,
						SHIP_TYPE,
						PROCESS_CAT,
						SHIP_DATE,
						<cfif isdate(attributes.deliver_date_frm)>DELIVER_DATE,</cfif>
						DISCOUNTTOTAL,
						NETTOTAL,
						GROSSTOTAL,
						TAXTOTAL,
						OTHER_MONEY,
						OTHER_MONEY_VALUE,
						DELIVER_STORE_ID,
						LOCATION,
						DEPARTMENT_IN,
						LOCATION_IN,
						REF_NO,
						RECORD_DATE,
						RECORD_EMP,
						IS_DELIVERED,
						DELIVER_EMP_ID,
						PROJECT_ID_IN
					)
					VALUES
					(
						'#wrk_id#',
						1,
						'#ship_number_#',
						#get_process_type.process_type#,
						#form.process_cat#,
						#attributes.ship_date#,
						<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#,</cfif>
						0,<!--- BASKET_DISCOUNT_TOTAL --->
						0,<!--- basket_net_total --->
						0,<!--- basket_gross_total --->
						0,<!--- basket_tax_total --->
						0,<!--- form.basket_money --->
						#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
						<cfif isdefined("attributes.deliver_store_id1") and len(attributes.deliver_store_id1)>#attributes.deliver_store_id1#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.location1") and len(attributes.location1)>#attributes.location1#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.department_in_id1") and len(attributes.department_in_id1)>#attributes.department_in_id1#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.location_in_id1") and len(attributes.location_in_id1)>#attributes.location_in_id1#<cfelse>NULL</cfif>,
						'#SHIP_NUMBER#',<!--- ref_no --->
						#now()#,
						#session.ep.userid#,
						<cfif isdefined("attributes.is_delivered")>#attributes.is_delivered#<cfelse>1</cfif>,
						<cfif len(DELIVER_EMP_ID)>#DELIVER_EMP_ID#<cfelse>NULL</cfif>,
						<cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>
					)
				</cfquery>
			<cfoutput query="get_amount_">
				<cfset wrk_row_id_ = 'WRK'&'#currentrow#'&round(rand()*65)&dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#session.ep.userid#'&round(rand()*100)&'#currentrow#'>
                <cfquery name="get_ship_row" datasource="#new_dsn2#">
                    SELECT ISNULL(GROSSTOTAL,0) GROSSTOTAL_,ISNULL(NETTOTAL,0)NETTOTAL_,ISNULL(TAXTOTAL,0)TAXTOTAL_,ISNULL(OTHER_MONEY_GROSS_TOTAL,0)OTHER_MONEY_GROSS_TOTAL_,* FROM SHIP_ROW WHERE WRK_ROW_ID = '#WRK_ROW_ID#'
                </cfquery>
                <cfscript>
                    i = 1;
                    attributes.indirim11 = get_ship_row.DISCOUNT;
                    attributes.indirim21 = get_ship_row.DISCOUNT2;
                    attributes.indirim31 = get_ship_row.DISCOUNT3;
                    attributes.indirim41 = get_ship_row.DISCOUNT4;
                    attributes.indirim51 = get_ship_row.DISCOUNT5;
                    attributes.indirim61 = get_ship_row.DISCOUNT6;
                    attributes.indirim71 = get_ship_row.DISCOUNT7;
                    attributes.indirim81 = get_ship_row.DISCOUNT8;
                    attributes.indirim91 = get_ship_row.DISCOUNT9;
                    attributes.indirim101 = get_ship_row.DISCOUNT10;
                </cfscript>
                <cfinclude template="get_dis_amount.cfm">
                <cfquery name="get_prod_name" datasource="#new_dsn2#">
                	SELECT PRODUCT_NAME FROM #DSN1_ALIAS#.PRODUCT WHERE PRODUCT_ID = #PRODUCT_ID#	
                </cfquery>
                <cfquery name="ADD_SHIP_ROW" datasource="#new_dsn2#">
                    INSERT INTO
                        #dsn2_alias#.SHIP_ROW
                    (
                        NAME_PRODUCT,
                        SHIP_ID,
                        STOCK_ID,
                        PRODUCT_ID,
                        AMOUNT,
                        UNIT,
                        UNIT_ID,
                        WRK_ROW_ID,
                        WRK_ROW_RELATION_ID,
                        TAX,
                        PRICE,
                        PURCHASE_SALES,
                        DISCOUNT,
                        DISCOUNT2,
                        DISCOUNT3,
                        DISCOUNT4,
                        DISCOUNT5,
                        DISCOUNT6,
                        DISCOUNT7,
                        DISCOUNT8,
                        DISCOUNT9,
                        DISCOUNT10,
                        DISCOUNTTOTAL,
                        GROSSTOTAL,
                        NETTOTAL,
                        TAXTOTAL,
                        PRICE_OTHER,
                        OTHER_MONEY_GROSS_TOTAL,
                        IS_PROMOTION,
                        SHELF_NUMBER,
                        EXTRA_COST,
                        COST_PRICE,
                        SPECT_VAR_ID,
                        SPECT_VAR_NAME,
                        ROW_PROJECT_ID,
                        BASKET_EMPLOYEE_ID,
                        PRODUCT_NAME2
                    )
                    VALUES
                    (
                        '#left(get_prod_name.PRODUCT_NAME,250)#',
                        #MAX_ID.IDENTITYCOL#,
                        #STOCK_ID#,
                        #PRODUCT_ID#,
                        #AMOUNT#,
                        '#UNIT#',
                        #UNIT_ID#,
                        '#wrk_row_id_#',<!--- wrk_row_id --->
                        '#WRK_ROW_ID#',<!--- wrk_row_relation_id --->
                        #get_ship_row.TAX#,
                        #get_ship_row.PRICE#,
                        1,
                        #attributes.indirim11#,
                        #attributes.indirim21#,
                        #attributes.indirim31#,
                        #attributes.indirim41#,
                        #attributes.indirim51#,
                        #attributes.indirim61#,
                        #attributes.indirim71#,
                        #attributes.indirim81#,
                        #attributes.indirim91#,
                        #attributes.indirim101#,
                        <cfif IsDefined("DISCOUNTTOTAL") and len(DISCOUNTTOTAL)>#DISCOUNTTOTAL#<cfelse>#DISCOUNT_AMOUNT#</cfif>,
                        #get_ship_row.GROSSTOTAL_*AMOUNT/get_ship_row.AMOUNT#,<!--- row_lasttotal --->
                        #get_ship_row.NETTOTAL_*AMOUNT/get_ship_row.AMOUNT#,<!--- row_nettotal --->
                        #get_ship_row.TAXTOTAL_*AMOUNT/get_ship_row.AMOUNT#,<!--- row_taxtotal --->
                        #get_ship_row.PRICE_OTHER#,<!--- price_other --->
                        #get_ship_row.OTHER_MONEY_GROSS_TOTAL_*AMOUNT/get_ship_row.AMOUNT#,<!--- other_money_gross_total --->
                        0,
                        <cfif len(SHELF_ID) and SHELF_ID gt 0>#SHELF_ID#<cfelse>NULL</cfif>,
                        #EXTRA_COST#,
                        #COST_PRICE#,
                        <cfif len(SPECT_VAR_ID) and SPECT_VAR_ID gt 0>#SPECT_VAR_ID#<cfelse>NULL</cfif>,
                        <cfif len(SPECT_VAR_NAME)>'#SPECT_VAR_NAME#'<cfelse>NULL</cfif>,
                        <cfif len(ROW_PROJECT_ID) and ROW_PROJECT_ID gt 0>#ROW_PROJECT_ID#<cfelse>NULL</cfif>,
                        <cfif len(BASKET_EMPLOYEE_ID) and BASKET_EMPLOYEE_ID neq 0>#basket_employee_id#<cfelse>NULL</cfif>,
                        '#product_name2#'
                    )
                </cfquery>
				<cfif get_process_type.is_stock_action eq 1><!--- Stok hareketi yapılsın --->
                    <cfif len(SPECT_VAR_ID)>
                        <cfset form_spect_id = SPECT_VAR_ID>
                        <cfif len(form_spect_id) and len(form_spect_id)>
                            <cfquery name="GET_MAIN_SPECT" datasource="#new_dsn2#">
                                SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
                            </cfquery>
                            <cfif GET_MAIN_SPECT.RECORDCOUNT>
                                <cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
                            </cfif>
                        </cfif>
                    </cfif>
                    <cfquery name="ADD_STOCK_ROW" datasource="#new_dsn2#">
                        INSERT INTO 
                            #dsn2_alias#.STOCKS_ROW
                        (
                            UPD_ID,
                            PRODUCT_ID,
                            STOCK_ID,
                            PROCESS_TYPE,
                            STOCK_OUT,
                            STORE,
                            STORE_LOCATION,
                            PROCESS_DATE
                            <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
                                ,SPECT_VAR_ID
                            </cfif>
                        )
                        VALUES
                        (
                            #MAX_ID.IDENTITYCOL#,
                            #PRODUCT_ID#,
                            #STOCK_ID#,
                            #get_process_type.process_type#,
                            #AMOUNT#,
                            #DELIVER_STORE_ID#,
                            #LOCATION#,
                            #attributes.ship_date#
                            <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
                                ,#form_spect_main_id#
                            </cfif>
                        )
                    </cfquery>
                    <cfquery name="ADD_STOCK_ROW" datasource="#new_dsn2#">
                        INSERT INTO 
                            #dsn2_alias#.STOCKS_ROW
                        (
                            UPD_ID,
                            PRODUCT_ID,
                            STOCK_ID,
                            PROCESS_TYPE,
                            STOCK_IN,
                            STORE,
                            STORE_LOCATION,
                            PROCESS_DATE
                            <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
                                ,SPECT_VAR_ID
                            </cfif>
                        )
                        VALUES
                        (
                            #MAX_ID.IDENTITYCOL#,
                            #PRODUCT_ID#,
                            #STOCK_ID#,
                            #get_process_type.process_type#,
                            #AMOUNT#,
                            #DEPARTMENT_IN_ID#,
                            #LOCATION_IN_ID#,
                            #attributes.ship_date#
                            <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
                                ,#form_spect_main_id#
                            </cfif>
                        )
                    </cfquery>	
				</cfif>
         </cfoutput>			
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = "#MAX_ID.IDENTITYCOL#"
			action_table="SHIP"
			action_column="SHIP_ID"
			is_action_file = 1
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=#MAX_ID.IDENTITYCOL#'
			action_file_name='#get_process_type.action_file_name#'
			action_db_type = '#new_dsn2#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>
<cfelse>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfoutput query="get_amount_">
			<!--- Varsa Oncelikli Belge numaralarindan Alinacak Sekilde Duzenlendi fbs 20130111 --->
			<cfquery name="Get_Paper_No" datasource="#dsn2#">
				SELECT TOP 1 ISNULL(PRINTER_ID,0) PRINTER_ID, SHIP_NO, SHIP_NUMBER FROM #dsn3_alias#.PAPERS_NO WHERE SHIP_NUMBER IS NOT NULL AND (PRINTER_ID IN (SELECT SPU.PRINTER_ID FROM #dsn_alias#.SETUP_PRINTER_USERS SPU WHERE SPU.PRINTER_EMP_ID = #session.ep.userid#) OR EMPLOYEE_ID = #session.ep.userid#) ORDER BY PRINTER_ID DESC
			</cfquery>
			<cfif Get_Paper_No.RecordCount>
				<cfset ship_number_ = "#Get_Paper_No.Ship_No#-#Get_Paper_No.Ship_Number+1#">
				<cfif Get_Paper_No.Printer_Id neq 0><cfset attributes.paper_printer_id = Get_Paper_No.Printer_Id></cfif>
				
				<cfif Len(ship_number_)>
					<cfquery name="UPD_PAPERS" datasource="#new_dsn2#">
						UPDATE
							#dsn3_alias#.PAPERS_NO
						SET
							SHIP_NUMBER = #ListLast(ship_number_,'-')#
						WHERE
						<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
							PRINTER_ID = #attributes.paper_printer_id#
						<cfelse>
							EMPLOYEE_ID = #session.ep.userid#
						</cfif>
					</cfquery>
				</cfif>
			<cfelse>
				<!--- Yoksa Eski Tanim Devam Eder --->
				<cfquery name="get_ship_number" datasource="#dsn2#">
					SELECT MAX(CAST(REPLACE(SHIP_NUMBER,'SVK-IRS-','') AS INT)) SHIP_NUMBER FROM SHIP WHERE SHIP_NUMBER LIKE 'SVK-IRS-%'
				</cfquery>
				<cfif get_ship_number.recordcount and len(get_ship_number.SHIP_NUMBER)>
					<cfset ship_number_ = ListLast(get_ship_number.SHIP_NUMBER,'-') + 1>
					<cfset ship_number_ = 'SVK-IRS'&'-'&'#ship_number_#'>
				<cfelse>
					<cfset ship_number_ = 'SVK-IRS-1'>
				</cfif>
			</cfif>
			<cfset wrk_row_id_ = 'WRK'&'#currentrow#'&round(rand()*65)&dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#session.ep.userid#'&round(rand()*100)&'#currentrow#'>
			<cfif ((DELIVER_STORE_ID[currentrow] neq DELIVER_STORE_ID[currentrow-1]) or ((DELIVER_STORE_ID[currentrow] eq DELIVER_STORE_ID[currentrow-1]) and (LOCATION[currentrow] neq LOCATION[currentrow-1]))) or ((DEPARTMENT_IN_ID[currentrow] neq DEPARTMENT_IN_ID[currentrow-1]) or ((DEPARTMENT_IN_ID[currentrow] eq DEPARTMENT_IN_ID[currentrow-1]) and (LOCATION_IN_ID[currentrow] neq LOCATION_IN_ID[currentrow-1])))>
				<cfquery name="ADD_SALE" datasource="#new_dsn2#" result="MAX_ID">
					INSERT INTO
						#dsn2_alias#.SHIP
					(
						WRK_ID,
						PURCHASE_SALES,
						SHIP_NUMBER,
						SHIP_TYPE,
						PROCESS_CAT,
						SHIP_DATE,
						<cfif isdate(attributes.deliver_date_frm)>DELIVER_DATE,</cfif>
						DISCOUNTTOTAL,
						NETTOTAL,
						GROSSTOTAL,
						TAXTOTAL,
						OTHER_MONEY,
						OTHER_MONEY_VALUE,
						DELIVER_STORE_ID,
						LOCATION,
						DEPARTMENT_IN,
						LOCATION_IN,
						REF_NO,
						RECORD_DATE,
						RECORD_EMP,
						IS_DELIVERED,
						DELIVER_EMP_ID,
						PROJECT_ID_IN
					)
					VALUES
					(
						'#wrk_id#',
						1,
						'#ship_number_#',
						#get_process_type.process_type#,
						#form.process_cat#,
						#attributes.ship_date#,
						<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#,</cfif>
						0,<!--- BASKET_DISCOUNT_TOTAL --->
						0,<!--- basket_net_total --->
						0,<!--- basket_gross_total --->
						0,<!--- basket_tax_total --->
						0,<!--- form.basket_money --->
						#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
						<cfif isdefined("attributes.deliver_store_id1")>#attributes.deliver_store_id1#<cfelse>#DELIVER_STORE_ID#</cfif>,
						<cfif isdefined("attributes.location1")>#attributes.location1#<cfelse>#LOCATION#</cfif>,
						<cfif isdefined("attributes.department_in_id1")>#attributes.department_in_id1#<cfelse>#DEPARTMENT_IN_ID#</cfif>,
						<cfif isdefined("attributes.location_in_id1")>#attributes.location_in_id1#<cfelse>#LOCATION_IN_ID#</cfif>,
						'#SHIP_NUMBER#',<!--- ref_no --->
						#now()#,
						#session.ep.userid#,
						<cfif isdefined("attributes.is_delivered")>#attributes.is_delivered#<cfelse>1</cfif>,
						<cfif len(DELIVER_EMP_ID)>#DELIVER_EMP_ID#<cfelse>NULL</cfif>,
						<cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>
					)
				</cfquery>
			</cfif>
			<cfquery name="get_ship_row" datasource="#new_dsn2#">
				SELECT ISNULL(GROSSTOTAL,0) GROSSTOTAL_,ISNULL(NETTOTAL,0)NETTOTAL_,ISNULL(TAXTOTAL,0)TAXTOTAL_,ISNULL(OTHER_MONEY_GROSS_TOTAL,0)OTHER_MONEY_GROSS_TOTAL_,* FROM SHIP_ROW WHERE WRK_ROW_ID = '#WRK_ROW_ID#'
			</cfquery>
			<cfscript>
				i = 1;
				attributes.indirim11 = get_ship_row.DISCOUNT;
				attributes.indirim21 = get_ship_row.DISCOUNT2;
				attributes.indirim31 = get_ship_row.DISCOUNT3;
				attributes.indirim41 = get_ship_row.DISCOUNT4;
				attributes.indirim51 = get_ship_row.DISCOUNT5;
				attributes.indirim61 = get_ship_row.DISCOUNT6;
				attributes.indirim71 = get_ship_row.DISCOUNT7;
				attributes.indirim81 = get_ship_row.DISCOUNT8;
				attributes.indirim91 = get_ship_row.DISCOUNT9;
				attributes.indirim101 = get_ship_row.DISCOUNT10;
			</cfscript>
			<cfinclude template="get_dis_amount.cfm">
			<cfquery name="ADD_SHIP_ROW" datasource="#new_dsn2#">
				INSERT INTO
					#dsn2_alias#.SHIP_ROW
				(
					NAME_PRODUCT,
					SHIP_ID,
					STOCK_ID,
					PRODUCT_ID,
					AMOUNT,
					UNIT,
					UNIT_ID,
					WRK_ROW_ID,
					WRK_ROW_RELATION_ID,
					TAX,
					PRICE,
					PURCHASE_SALES,
					DISCOUNT,
					DISCOUNT2,
					DISCOUNT3,
					DISCOUNT4,
					DISCOUNT5,
					DISCOUNT6,
					DISCOUNT7,
					DISCOUNT8,
					DISCOUNT9,
					DISCOUNT10,
					DISCOUNTTOTAL,
					GROSSTOTAL,
					NETTOTAL,
					TAXTOTAL,
					PRICE_OTHER,
					OTHER_MONEY_GROSS_TOTAL,
					IS_PROMOTION,
					SHELF_NUMBER,
					EXTRA_COST,
					COST_PRICE,
					SPECT_VAR_ID,
					SPECT_VAR_NAME,
					ROW_PROJECT_ID,
					BASKET_EMPLOYEE_ID,
                    PRODUCT_NAME2
				)
				VALUES
				(
					'#left(NAME_PRODUCT,250)#',
					#MAX_ID.IDENTITYCOL#,
					#STOCK_ID#,
					#PRODUCT_ID#,
					#AMOUNT#,
					'#UNIT#',
					#UNIT_ID#,
					'#wrk_row_id_#',<!--- wrk_row_id --->
					'#WRK_ROW_ID#',<!--- wrk_row_relation_id --->
					#get_ship_row.TAX#,
					#get_ship_row.PRICE#,
					1,
					#attributes.indirim11#,
					#attributes.indirim21#,
					#attributes.indirim31#,
					#attributes.indirim41#,
					#attributes.indirim51#,
					#attributes.indirim61#,
					#attributes.indirim71#,
					#attributes.indirim81#,
					#attributes.indirim91#,
					#attributes.indirim101#,
					<cfif IsDefined("DISCOUNTTOTAL") and len(DISCOUNTTOTAL)>#DISCOUNTTOTAL#<cfelse>#DISCOUNT_AMOUNT#</cfif>,
					#get_ship_row.GROSSTOTAL_*AMOUNT/get_ship_row.AMOUNT#,<!--- row_lasttotal --->
					#get_ship_row.NETTOTAL_*AMOUNT/get_ship_row.AMOUNT#,<!--- row_nettotal --->
					#get_ship_row.TAXTOTAL_*AMOUNT/get_ship_row.AMOUNT#,<!--- row_taxtotal --->
					#get_ship_row.PRICE_OTHER#,<!--- price_other --->
					#get_ship_row.OTHER_MONEY_GROSS_TOTAL_*AMOUNT/get_ship_row.AMOUNT#,<!--- other_money_gross_total --->
					0,
					<cfif len(SHELF_ID) and SHELF_ID gt 0>#SHELF_ID#<cfelse>NULL</cfif>,
					#EXTRA_COST#,
					#COST_PRICE#,
					<cfif len(SPECT_VAR_ID) and SPECT_VAR_ID gt 0>#SPECT_VAR_ID#<cfelse>NULL</cfif>,
					<cfif len(SPECT_VAR_NAME)>'#SPECT_VAR_NAME#'<cfelse>NULL</cfif>,
					<cfif len(ROW_PROJECT_ID) and ROW_PROJECT_ID gt 0>#ROW_PROJECT_ID#<cfelse>NULL</cfif>,
					<cfif len(BASKET_EMPLOYEE_ID) and BASKET_EMPLOYEE_ID neq 0>#basket_employee_id#<cfelse>NULL</cfif>,
                    '#product_name2#'
				)
			</cfquery>
			<cfif get_process_type.is_stock_action eq 1><!--- Stok hareketi yapılsın --->
				<cfif len(SPECT_VAR_ID)>
					<cfset form_spect_id = SPECT_VAR_ID>
					<cfif len(form_spect_id) and len(form_spect_id)>
						<cfquery name="GET_MAIN_SPECT" datasource="#new_dsn2#">
							SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
						</cfquery>
						<cfif GET_MAIN_SPECT.RECORDCOUNT>
							<cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
						</cfif>
					</cfif>
				</cfif>
				<cfquery name="ADD_STOCK_ROW" datasource="#new_dsn2#">
					INSERT INTO 
						#dsn2_alias#.STOCKS_ROW
					(
						UPD_ID,
						PRODUCT_ID,
						STOCK_ID,
						PROCESS_TYPE,
						STOCK_OUT,
						STORE,
						STORE_LOCATION,
						PROCESS_DATE
						<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
							,SPECT_VAR_ID
						</cfif>
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#PRODUCT_ID#,
						#STOCK_ID#,
						#get_process_type.process_type#,
						#AMOUNT#,
						#DELIVER_STORE_ID#,
						#LOCATION#,
						#attributes.ship_date#
						<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
							,#form_spect_main_id#
						</cfif>
					)
				</cfquery>
				<cfquery name="ADD_STOCK_ROW" datasource="#new_dsn2#">
					INSERT INTO 
						#dsn2_alias#.STOCKS_ROW
					(
						UPD_ID,
						PRODUCT_ID,
						STOCK_ID,
						PROCESS_TYPE,
						STOCK_IN,
						STORE,
						STORE_LOCATION,
						PROCESS_DATE
						<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
							,SPECT_VAR_ID
						</cfif>
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#PRODUCT_ID#,
						#STOCK_ID#,
						#get_process_type.process_type#,
						#AMOUNT#,
						#DEPARTMENT_IN_ID#,
						#LOCATION_IN_ID#,
						#attributes.ship_date#
						<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
							,#form_spect_main_id#
						</cfif>
					)
				</cfquery>		
			</cfif>
		</cfoutput>			
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = "#MAX_ID.IDENTITYCOL#"
			action_table="SHIP"
			action_column="SHIP_ID"
			is_action_file = 1
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=#MAX_ID.IDENTITYCOL#'
			action_file_name='#get_process_type.action_file_name#'
			action_db_type = '#new_dsn2#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>
</cfif>

