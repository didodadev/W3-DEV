<cf_xml_page_edit fuseact="myhome.list_my_expense_requests">
	<cfparam name="attributes.listing_type" default="1">
<cfquery name="GET_EXPENSE" datasource="#dsn2#"><!---<cfoutput ><pre>--->
	SELECT <cfif not (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>DISTINCT</cfif>
		EIPR.RECORD_EMP,
		EIPR.PAPER_NO,
		EIPR.RECORD_DATE,
		EIPR.EMP_ID,
		EIPR.EXPENSE_DATE,
	<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
		EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXP_ITEM_ROWS_ID,
		EXPENSE_ITEM_PLAN_REQUESTS_ROWS.AMOUNT,
		EXPENSE_ITEM_PLAN_REQUESTS_ROWS.DETAIL,
		EXPENSE_ITEM_PLAN_REQUESTS_ROWS.TOTAL_AMOUNT,
		EXPENSE_ITEM_PLAN_REQUESTS_ROWS.AMOUNT_KDV,
		E_C.EXPENSE,
		E_I.EXPENSE_ITEM_NAME,
	<cfelse>
		ISNULL(EIPR.TOTAL_AMOUNT, 0) AS TOTAL_AMOUNT,
		EIPR.NET_KDV_AMOUNT,
		EIPR.NET_TOTAL_AMOUNT,
	</cfif> 
		EIPR.INVOICE_NO,
		EIPR.PAPER_TYPE,
		EIPR.EXPENSE_ID,
		EIPR.EXPENSE_STAGE,
		EIPR.SALES_COMPANY_ID,
		EIPR.SALES_CONSUMER_ID,
		CONSUMER.CONSUMER_NAME,
		CONSUMER.CONSUMER_SURNAME,
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME,
		EMP.EMPLOYEE_NAME,
		EMP.EMPLOYEE_SURNAME,
		C.FULLNAME,
		PTR.STAGE
	FROM
		EXPENSE_ITEM_PLAN_REQUESTS EIPR
		LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = EIPR.SALES_CONSUMER_ID
		LEFT JOIN #dsn_alias#.SETUP_DOCUMENT_TYPE ON SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID = EIPR.PAPER_TYPE
		LEFT JOIN #dsn_alias#.EMPLOYEES EMP on EMP.EMPLOYEE_ID =EIPR.EMP_ID
		LEFT JOIN #dsn_alias#.COMPANY C on C.COMPANY_ID=EIPR.SALES_COMPANY_ID
		LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR on PTR.PROCESS_ROW_ID=EIPR.EXPENSE_STAGE
		LEFT JOIN EXPENSE_ITEM_PLAN_REQUESTS_ROWS on EIPR.EXPENSE_ID = EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ID
	<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
		LEFT JOIN EXPENSE_ITEMS E_I on E_I.EXPENSE_ITEM_ID=EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID
		LEFT JOIN EXPENSE_CENTER E_C on E_C.EXPENSE_ID=EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID
	</cfif>
	WHERE
		((
			<cfif isDefined("xml_show_chief_requests") and xml_show_chief_requests eq 1>
				EIPR.RECORD_EMP IN
				(	SELECT
						EP.EMPLOYEE_ID
					FROM
						#dsn_alias#.EMPLOYEE_POSITIONS EP
					WHERE
						EP.UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> <!---'#session.ep.position_code#'---> OR
						EP.UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> <!---'#session.ep.position_code#'--->
				) OR
			</cfif>
			EIPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><!---'#session.ep.userid#'--->
		) OR EXPENSE_ITEM_PLAN_REQUESTS_ROWS.COMPANY_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
		<cfif xml_expense_center_is_popup eq 1>
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_center_id') and len(attributes.expense_center_id) and len(attributes.expense_center_name))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"></cfif>
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_item_id') and len(attributes.expense_item_id) and len(attributes.expense_item_name))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"></cfif>
			<cfelse>
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_center_id') and len(attributes.expense_center_id))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"></cfif>
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_item_id') and len(attributes.expense_item_id))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"></cfif>
		</cfif>   
		AND EIPR.EXPENSE_TYPE IS NULL

	
</cfquery><!---</pre></cfoutput><cfabort>--->
<cfparam name="attributes.totalrecords" default="#get_expense.recordCount#">


<cfsavecontent variable="message"><cf_get_lang dictionary_id='31149.Harcama Talepleri'></cfsavecontent>
<cf_box title="#message#" add_href="#request.self#?fuseaction=myhome.list_my_expense_requests&event=add" closable="0">

<!--- <cf_big_list>  --->
	<cf_flat_list>
		<div class="extra_list">
			<thead>
				<tr>
					<th width="25"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th width="7%"><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th width="8%"><cf_get_lang dictionary_id='58578.Belge Türü'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th width="10%"><cf_get_lang dictionary_id='31168.Harcama Tarihi'></th>
					<th width="15%"><cf_get_lang dictionary_id='33257.Harcama yapan'></th>
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
					<th width="10%"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
					<th width="10%"><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
					</cfif>
					<th width="10%" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></th>
					<th width="10%" style="text-align:right;"><cf_get_lang dictionary_id='31169.Toplam KDV'></th>
					<th width="10%" style="text-align:right;"><cf_get_lang dictionary_id='34019.KDV li Toplam'></th>
					<th width="10%"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th width="10%"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th width="10%"><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th>&nbsp;</th>
		<!--- 			<th class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_expense_requests&event=add"><img src="/images/plus_list.gif" title="<cf_get_lang_main no ='1081.Kayıt Ekle'>"></a></th>		
		 --->		</tr>
			</thead>
			<tbody>
				<cfset toplam1 = 0>
        <cfset toplam2 = 0>
		<cfset toplam3 = 0>
		
	<cfif 1 eq 1>
	<cfif get_expense.recordcount>	
	<cfset expense_stage_list = ''>
		<cfoutput query="get_expense">
			<cfif len(expense_stage) and not listfind(expense_stage_list,expense_stage)>
				<cfset expense_stage_list=listappend(expense_stage_list,expense_stage)>
			</cfif>
		</cfoutput>
		<cfif len(expense_stage_list)>
			<cfquery name="get_stage" datasource="#dsn#">
				SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#expense_stage_list#)
			</cfquery>
			<cfset expense_stage_list = listsort(listdeleteduplicates(valuelist(get_stage.process_row_id,',')),'numeric','ASC',',')>
		</cfif>
			<cfoutput query="get_expense">
				<tr>
					<td>#currentrow#</td>
                    <cfif fusebox.circuit eq 'myhome'>
						<cfset expense_id_ = contentEncryptingandDecodingAES(isEncode:1,content:expense_id,accountKey:'wrk')>
                    <cfelse>
                        <cfset expense_id_ = expense_id>
                    </cfif>
					<td><a href="#request.self#?fuseaction=myhome.list_my_expense_requests&event=upd&request_id=#expense_id_#" class="tableyazi">&nbsp;#paper_no#</a></td>
					<td><cfif len(paper_type)>
							<cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
								SELECT DOCUMENT_TYPE_NAME FROM SETUP_DOCUMENT_TYPE WHERE DOCUMENT_TYPE_ID = #paper_type#
							</cfquery>
							#get_document_type.document_type_name#
						</cfif>
					</td>
					<td>
						<cfif len(sales_company_id)>
							#get_par_info(sales_company_id,1,-1,0)#
						<cfelseif len(sales_consumer_id)>
							#get_cons_info(sales_consumer_id,0,0)#
						</cfif>
					</td>
					<td>#dateformat(expense_date,dateformat_style)#</td>
					<td>#get_emp_info(emp_id,0,1)#</td>
					 <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
           				<td>#expense#</td>
                        <td>#expense_item_name#</td>
           				 </cfif>
                        <td style="text-align:right;">#tlformat(total_amount)# #session.ep.money#</td>
                        <td style="text-align:right;"><cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)>#tlformat(net_total_amount)# #session.ep.money#<cfelse>#tlformat(amount_kdv)# #session.ep.money#</cfif></td>
                        <td style="text-align:right;"><cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)>#tlformat(net_kdv_amount)# #session.ep.money#<cfelse>#tlformat(total_amount)# #session.ep.money#</cfif></td>
					<td>#get_emp_info(record_emp,0,1)#</td>
					<td>#dateformat(record_date,dateformat_style)#</td>
					<td><cfif len(expense_stage)>#get_stage.stage[listfind(expense_stage_list,expense_stage,',')]#</cfif></td>
					<!-- sil --><td style="text-align:left"><a href="#request.self#?fuseaction=myhome.list_my_expense_requests&event=upd&request_id=#expense_id_#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>" alt="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td><!-- sil -->
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)>
						<cfscript>
							toplam1 = toplam1 + total_amount;	
							if(len(net_kdv_amount))		
							toplam2 = toplam2 + net_kdv_amount;  
							toplam3 = toplam3 + net_total_amount; 	
						</cfscript>
					<cfelse>
						<cfscript>
							toplam1 = toplam1 + amount;					
							toplam2 = toplam2 + total_amount; 
							toplam3 = toplam3 + amount_kdv; 	
						</cfscript>
                   </cfif>
                </tr>
			</cfoutput>
           
				<cfoutput>
                    <tr>
						<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
							<td colspan="7" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<cfelse>
							<td colspan="5" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
						</cfif>
						<td class="txtbold" style="text-align:right;">#TLFormat(toplam1)#&nbsp;#session.ep.money#</td>
						<td class="txtbold" style="text-align:right;">#TLFormat(toplam3)#&nbsp;#session.ep.money#</td>
						<td class="txtbold" style="text-align:right;">#TLFormat(toplam2)#&nbsp;#session.ep.money#</td>
						<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
							<td colspan="3" class="txtbold" ></td>
							<!-- sil --><td>&nbsp;</td><!-- sil -->
						<cfelse>
							 <td colspan="4" class="txtbold" ></td>
						</cfif>
						
                    </tr>
                </cfoutput>    
			
		<cfelse>
			<tr>
				<td colspan="14"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
		<cfelse>
			 <tr>
                <td colspan="14" height="20"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
             </tr>
		</cfif>
			</tbody>
		</div>
	</cf_flat_list>
</cf_box>
		
<cfsetting showdebugoutput="no">