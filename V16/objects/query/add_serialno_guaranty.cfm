<cfquery name="get_guaranty_time_" datasource="#dsn#">
	SELECT (SELECT GUARANTYCAT_TIME FROM SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = #attributes.guarantycat_id#
</cfquery>
<cfquery name="get_sale_guaranty_time_" datasource="#dsn#">
	SELECT (SELECT GUARANTYCAT_TIME FROM SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = #attributes.sale_guarantycat_id#
</cfquery>
<cfif len(get_guaranty_time_.GUARANTYCAT_TIME)>
 <cfset guarantycat_time = get_guaranty_time_.GUARANTYCAT_TIME>
<cfelse>
	<cfset guarantycat_time = '0'>
</cfif>
<cfif len(get_sale_guaranty_time_.GUARANTYCAT_TIME)>
	<cfset guarantycat_time_sale = get_sale_guaranty_time_.GUARANTYCAT_TIME>
   <cfelse>
	   <cfset guarantycat_time_sale = '0'>
   </cfif>
<cfif len(attributes.start_date)>
	<cf_date tarih= "attributes.start_date">
	<cfset finish_date = date_add('m',guarantycat_time,attributes.start_date)>
</cfif>
<cfif len(attributes.sale_start_date)>
	<cf_date tarih= "attributes.sale_start_date">
	<cfset sale_finish_date = date_add('m',guarantycat_time_sale,attributes.sale_start_date)>
</cfif>

<cfset list_numbers = "">
<cfset yer = 0>
<cfset yer2 = 0>
<cfset f1 = 0>
<cfset f2 = 0>
<cfset attributes.ship_start_no = replace(attributes.ship_start_no,'*','-','all')>
<cfset uzunluk = len(attributes.ship_start_no)>
<cfset str = attributes.ship_start_no>
<cfset counter = attributes.amount>
<cfif attributes.method eq 0>
	<cfset sayi = "">
	<!--- sayısal kısım bulunur --->
	<cfloop from="1" to="#uzunluk#" index="j">
		<cfset temp = mid(str,uzunluk-j+1,1)>
		<cfif isnumeric(temp)>
			<cfif f1>
				<cfset sayi =  "#temp##sayi#">
			<cfelse>
				<cfset f1 = 1>
				<cfset sayi =  "#temp##sayi#">
			</cfif>
		<cfelse>
			<cfif len(sayi)>
				<cfset yer =j>
				<cfbreak>
			<cfelse>
				<cfset yer2 =j>
			</cfif>
		</cfif>
	</cfloop>
	<cfif yer>
		<cfset start = left(str,len(str)-yer+1)>
	<cfelse>
		<cfset start = "">
	</cfif>
	<cfif len(sayi) and len(start)>
		<cfset len_str = len(str)>
		<cfset len_sayi = len(sayi)>
		<cfset len_start = len(start)>
		<cfset minus = len_str - len_sayi-len_start>
			<cfif minus gt 0>
			<cfset end = right(str, abs(minus))>
			<cfelse>
			<cfset end = "">
			</cfif>	
	<cfelse>
		<cfset end = "">
	</cfif>
	<!--- // sayısal kısım bulunur --->
	<!--- sayısal kısım başındaki sıfırlar saklanır --->
	<cfset zero_count = 0>
	<cfset str_zero="">
	<cfset ilk = "">
	<cfif not len(sayi)>
		<cfset sayi = "0">
		<cfif len(yer2)>
			<cfset ilk = left(str,yer2)>
		</cfif>
	</cfif>
	<cfset zero_count = 1>
	<cfset counter_ = len(sayi)>
	<cfloop from="1" to="#len(sayi)#" index="k">
		<cfif mid(sayi,counter_,1) eq 0>
			<cfset zero_count = zero_count + 1>
		</cfif>
		<cfset counter_ = counter_ -1>
	</cfloop>
	<cfset zero_count = zero_count-1>
	<cfif (zero_count eq 1) and left(sayi, 1)>
		<cfset zero_count = 0>
	</cfif>
	<cfif zero_count neq 0>
		<cfloop from="1" to="#zero_count#" index="m">
			<cfset str_zero = str_zero & "0">
		</cfloop>
	</cfif>
	<!--- //sayısal kısım başındaki sıfırlar saklanır --->
	
	<cfloop from="0" to="#counter-1#" index="i">
		<!---<cfset temp_sayi = '#str_zero##sayi#'>--->
		<cfset temp_sayi = "#sayi#">
		<cfif len(ilk)>
			<cfset temp_sayi = "#ilk##temp_sayi#">
		</cfif>
		<cfif len(start)>
			<cfset temp_sayi = "#start##temp_sayi#">
		</cfif>
		<cfif len(end)>
			<cfset temp_sayi = "#temp_sayi##end#">
		</cfif>
		<cfif isdefined("attributes.ship_start_text") and len(attributes.ship_start_text)>
			<cfset temp_sayi = "#temp_sayi##attributes.ship_start_text#">
		</cfif>
		<cfif listlen(list_numbers) and not listfind(list_numbers, temp_sayi, ',')>
			<cfset list_numbers = listappend(list_numbers, temp_sayi, ',')>
		<cfelseif not listlen(list_numbers)>
			<cfset list_numbers = listappend(list_numbers, temp_sayi, ',')>
		</cfif>		
		<cfset sayi = add_one(sayi)>
	</cfloop>
<cfelse>
	<!--- <cfset attributes.ship_start_no = ListChangeDelims(replacelist(attributes.ship_start_nos,"#chr(13)##chr(10)#",";"),",",";")>--->
	<cfset counter = 0>
	<!---<cfloop list="#ship_start_no#" index="eleman">
		<cfset counter = counter + 1>
		<cfset attributes.ship_start_no = ListSetAt(attributes.ship_start_no, counter, trim(eleman), ",")>
	</cfloop>--->
	<cfset list_numbers = listappend(list_numbers, attributes.ship_start_no, ',')>
</cfif>
<cfset list_numbers = ListDeleteDuplicates(list_numbers)>
<cfif len(list_numbers)>
	<!--- <cfset list_numbers = ListQualify(list_numbers,"'",",","ALL")> --->
	<cfset list_numbers = "'"&ListChangeDelims(list_numbers,"','",",")&"'">
	<cfquery name="seri_cont" datasource="#dsn3#">
		SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO IN (#PreserveSingleQuotes(list_numbers)#)
	</cfquery>
	<cfif seri_cont.recordcount>
		<cfoutput query="seri_cont">
			<!---<cfset main_list_numbers = ListDeleteAt(list_numbers,SERIAL_NO,',')>--->
			<cfset main_list_numbers = listdeleteat(list_numbers,listlen(SERIAL_NO,","),",")>
		</cfoutput>
	<cfelse>
		<cfset main_list_numbers = list_numbers>
	</cfif>
</cfif>
<cfif isDefined("main_list_numbers") and listlen(main_list_numbers)>
	<cfloop list="#main_list_numbers#" index="k">
		<cfset my_seri_number = "#mid(k,2,len(k)-2)#">
		<cfquery name="add_guaranty" datasource="#dsn3#" result="MAX_ID">
			INSERT INTO
				SERVICE_GUARANTY_NEW
			(
				STOCK_ID,
				SERIAL_NO,
				LOT_NO,
				IN_OUT,
				IS_PURCHASE,
				IS_SALE,
				IS_RETURN,
				IS_RMA,
				IS_SERVICE,
				IS_TRASH,
				PROCESS_CAT,
				PERIOD_ID,
				DEPARTMENT_ID,
				LOCATION_ID,
				PURCHASE_GUARANTY_CATID,
				PURCHASE_START_DATE,
				PURCHASE_FINISH_DATE,
				SALE_GUARANTY_CATID,
				SALE_START_DATE,
				SALE_FINISH_DATE,
				UPDATE_TIME,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				PROCESS_ID
			)
			VALUES
			(
				#STOCK_ID#,
				'#my_seri_number#',
				<cfif isdefined("attributes.lot_no") and len(attributes.lot_no)>'#attributes.lot_no#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.in_out") and len(attributes.in_out)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_purchase_sales") and len(attributes.is_purchase_sales) and (attributes.is_purchase_sales eq 0)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_purchase_sales") and len(attributes.is_purchase_sales) and (attributes.is_purchase_sales eq 1)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_return") and len(attributes.is_return)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_rma") and len(attributes.is_rma)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_service") and len(attributes.is_service)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_trash") and len(attributes.is_trash)>1<cfelse>0</cfif>,
				114,
				#session.ep.period_id#,
				#attributes.department_id#,
				#attributes.location_id#,
				#attributes.guarantycat_id#,
				<cfif isdefined("attributes.start_date") and len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				<cfif isdefined("finish_date") and len(finish_date)>#finish_date#<cfelse>NULL</cfif>,
				#attributes.sale_guarantycat_id#,
				<cfif isdefined("attributes.sale_start_date") and len(attributes.sale_start_date)>#attributes.sale_start_date#<cfelse>NULL</cfif>,
				<cfif isdefined("sale_finish_date") and len(sale_finish_date)>#sale_finish_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.update_time") and len(attributes.update_time)>#attributes.update_time#<cfelse>NULL</cfif>,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				#NOW()#,
				0
			)
		</cfquery>
		<!--- BK kaldirdi 6 aya kaldirilmali. 20130529
		<cfquery name="add_guaranty_hist" datasource="#dsn3#">
			INSERT INTO
				SERVICE_GUARANTY_NEW_HISTORY
			(
				GUARANTY_ID,
				STOCK_ID,
				SERIAL_NO,
				LOT_NO,
				IN_OUT,
				IS_PURCHASE,
				IS_SALE,
				IS_RETURN,
				IS_RMA,
				IS_SERVICE,
				IS_TRASH,
				PROCESS_CAT,
				DEPARTMENT_ID,
				LOCATION_ID,
				PURCHASE_GUARANTY_CATID,
				PURCHASE_START_DATE,
				PURCHASE_FINISH_DATE,
				SALE_GUARANTY_CATID,
				SALE_START_DATE,
				SALE_FINISH_DATE,
				UPDATE_TIME,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			)
			VALUES(
				#MAX_ID.IDENTITYCOL#,
				#STOCK_ID#,
				'#my_seri_number#',
				<cfif isdefined("attributes.lot_no") and len(attributes.lot_no)>'#attributes.lot_no#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.in_out") and len(attributes.in_out)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_purchase_sales") and len(attributes.is_purchase_sales) and (attributes.is_purchase_sales eq 0)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_purchase_sales") and len(attributes.is_purchase_sales) and (attributes.is_purchase_sales eq 1)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_return") and len(attributes.is_return)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_rma") and len(attributes.is_rma)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_service") and len(attributes.is_service)>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_trash") and len(attributes.is_trash)>1<cfelse>0</cfif>,
				114,
				#attributes.department_id#,
				#attributes.location_id#,
				#attributes.guarantycat_id#,
				<cfif isdefined("attributes.start_date") and len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				<cfif isdefined("finish_date") and len(finish_date)>#finish_date#<cfelse>NULL</cfif>,
				#attributes.sale_guarantycat_id#,
				<cfif isdefined("attributes.sale_start_date") and len(attributes.sale_start_date)>#attributes.sale_start_date#<cfelse>NULL</cfif>,
				<cfif isdefined("sale_finish_date") and len(sale_finish_date)>#sale_finish_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.update_time") and len(attributes.update_time)>#attributes.update_time#<cfelse>NULL</cfif>,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				#NOW()#
			)
		</cfquery> --->
	</cfloop>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='62806.Seri Numarası kayıtlı!'>");
		return false;
	</script>
	<cfabort>
</cfif>
<script>
	location.href= '<cfoutput>#request.self#?fuseaction=service.list_guaranty&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
