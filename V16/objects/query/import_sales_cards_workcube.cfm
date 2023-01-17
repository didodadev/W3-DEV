<!---********* workcube satış export işlemini sisteme yüklemek için kullanılacak ancak işlemler kesin karar verilmediğinden bir süre ertelendiii--->
<!--- <cfsetting showdebugoutput="no"> --->
<!--- sube satis import --->

<cfif (session.ep.admin neq 1) and (timeformat(now(),'HHMM') gte 800) and (timeformat(now(),'HHMM') lte 1800)>
	Satış İşletme İşlemlerini Saat 10:00 ile 20:00 arası yapamazsınız...<br/>
	<cfabort>
<cfelse>
	<cfquery name="CHECK_IMPORTED" datasource="#DSN2#">
		SELECT I_ID FROM FILE_IMPORTS WHERE IMPORTED = 1 AND I_ID = #attributes.i_id#
	</cfquery>
	<cfif check_imported.recordcount>
		<script type="text/javascript">
			alert('Bu Dosya İmport Edilmiş, Tekrar İmport Edilemez !');
			wrk_opener_reload();
			window.close;
		</script>
		<cfabort>
	</cfif>
	
	<!--- Aktarım İşlemi Başladı, Lütfen Bekleyiniz...<br/>
	<cfinclude template="../../objects/functions/sales_import_functions.cfm">
	<cfinclude template="sales_import.cfm">
	<script type="text/javascript">
		wrk_opener_reload();
	</script>
	
	<cfoutput>
		<hr>
			import satır sayısı : #TOTAL_PRODUCTS#<br/>
			sorunlu satır sayısı : #PROBLEMS_COUNT#<br/>
			Toplam Süre : #timeformat(now()-start_time,'mm:ss')#<br/>
		<hr>
	</cfoutput> --->
	
	<cfquery name="GET_IMPORT" datasource="#DSN2#">
		SELECT
			FI.SOURCE_SYSTEM,
			FI.STARTDATE,
			FI.DEPARTMENT_ID,
			FI.DEPARTMENT_LOCATION,
			FI.IMPORT_DETAIL,
			FI.FILE_NAME,
			FI.FILE_SERVER_ID,		
			D.BRANCH_ID
		FROM
			FILE_IMPORTS FI,
			#dsn_alias#.DEPARTMENT D
		WHERE
			FI.I_ID = #attributes.i_id# AND
			FI.DEPARTMENT_ID = D.DEPARTMENT_ID
	</cfquery>	
	<cfscript>
		wrk_xml_read(xml_file:'#upload_folder#store#dir_seperator##get_import.file_name#');
		
		row_id = 2;	


		while (isdefined('INVOICE_INVOICE_ID_#row_id#'))
		{
		
			writeoutput('#evaluate("INVOICE_COMPANY_ID_#row_id#")#<br/>');
			writeoutput('#evaluate("INVOICE_INVOICE_ID_#row_id#")#<br/>');
			
			writeoutput('#evaluate("CARD_PAYMETHOD_ID_#row_id#")#<br/>');
			writeoutput('#evaluate("CARD_PAYMETHOD_RATE_#row_id#")#<br/>');
			writeoutput('#evaluate("CASH_ID_#row_id#")#<br/>');			
			writeoutput('#evaluate("COMMETHOD_ID_#row_id#")#<br/>');
			writeoutput('#evaluate("COMPANY_ID_#row_id#")#<br/>');
			writeoutput('#evaluate("CONSUMER_ID_#row_id#")#<br/>');			
			writeoutput('#evaluate("CUSTOMER_VALUE_ID_#row_id#")#<br/>');
			writeoutput('#evaluate("DELIVER_EMP_#row_id#")#<br/>');
			writeoutput('#evaluate("DEPARTMENT_ID_#row_id#")#<br/>');			
			writeoutput('#evaluate("DEPARTMENT_LOCATION_#row_id#")#<br/>');
			writeoutput('#evaluate("DUE_DATE_#row_id#")#<br/>');
			writeoutput('#evaluate("FREE_PROM_AMOUNT_#row_id#")#<br/>');			
			writeoutput('#evaluate("_#row_id#")#<br/>');
			writeoutput('#evaluate("_#row_id#")#<br/>');
			writeoutput('#evaluate("_#row_id#")#<br/>');			
			writeoutput('#evaluate("_#row_id#")#<br/>');
			writeoutput('#evaluate("_#row_id#")#<br/>');
			writeoutput('#evaluate("_#row_id#")#<br/>');			
			writeoutput('#evaluate("_#row_id#")#<br/>');
			writeoutput('#evaluate("_#row_id#")#<br/>');
			writeoutput('#evaluate("_#row_id#")#<br/>');			
			writeoutput('#evaluate("_#row_id#")#<br/>');
			writeoutput('#evaluate("_#row_id#")#<br/>');
			writeoutput('#evaluate("_#row_id#")#<br/>');			
			writeoutput('#evaluate("_#row_id#")#<br/>');
			writeoutput('#evaluate("_#row_id#")#<br/>');
			writeoutput('#evaluate("_#row_id#")#<br/>');			
			
 
 
FREE_PROM_COST 
FREE_PROM_ID 
FREE_PROM_LIMIT 
FREE_PROM_STOCK_ID 
FREE_STOCK_MONEY 
FREE_STOCK_PRICE 
GENERAL_PROM_AMOUNT
GENERAL_PROM_DISCOUNT 
GENERAL_PROM_ID 
GENERAL_PROM_LIMIT 
GROSSTOTAL
GROSSTOTAL_WITHOUT_ROUND 
IMS_CODE_ID 
INVENTORY_ID 
INVOICE_CAT
INVOICE_DATE
INVOICE_ID
INVOICE_MULTI_ID 
INVOICE_NUMBER
IS_ACCOUNTED
IS_CASH
IS_COST
IS_IPTAL
IS_ORDERED 
IS_PROCESSED
IS_RETURN
IS_WITH_SHIP
KASA_ID 
NETTOTAL
NOTE 
OFFER_ID 
ORDER_ID 
OTHER_MONEY
OTHER_MONEY_VALUE
PARTNER_ID
PAY_METHOD 
PRINT_COUNT 
PROCESS_CAT
PROJECT_ID 
PURCHASE_SALES
RECORD_DATE
RECORD_EMP
REF_NO 
RESOURCE_ID 
ROUND_MONEY 
SALE_EMP 
SALE_PARTNER 
SA_DISCOUNT
SHIP_ADDRESS
SHIP_METHOD 
STOPAJ 
STOPAJ_ORAN 
STOPAJ_RATE_ID 
TAXTOTAL
TEVKIFAT
TEVKIFAT_ORAN 
UPDATE_DATE
UPDATE_EMP
UPD_STATUS
WRK_ID
ZONE_ID 
			
			
			
			
			row_id= row_id+1;
		}
		
	</cfscript>
	<!--- <cf_get_server_file output_file="store#dir_seperator##get_import.file_name#" output_server="#get_import.file_server_id#" output_type="3" read_name="dosya"> --->
</cfif>
