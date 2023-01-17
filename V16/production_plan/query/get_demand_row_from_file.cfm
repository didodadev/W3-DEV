<cfset kontrol_file = 0>
<cfset upload_folder = "#upload_folder#production#dir_seperator#">
<cfif not directoryexists("#upload_folder#")>
	<cfdirectory action="create" directory="#upload_folder#">
</cfif>
<cftry>
	<cffile action = "upload" 
		  fileField = "uploaded_file" 
		  destination = "#upload_folder#"
		  nameConflict = "MakeUnique"  
		  mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
	<!---Script dosyalarını engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfset file_size = cffile.filesize>
	<cfset dosya_yolu = "#upload_folder##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
	<cfcatch type="Any">
		<cfset kontrol_file = 1>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>");
			history.back();
		</script>
	</cfcatch>
</cftry>
<cfif kontrol_file eq 0>
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
	</cfscript>
	<cfloop from="2" to="#line_count#" index="k">
		<cfscript>
			order_id_="";
			order_row_id_="";
			product_code = ListGetAt(dosya[k],1,";");
			product_amount = ListGetAt(dosya[k],2,";");
			product_amount = Replace(product_amount,',','.','all');
			if(listlen(dosya[k],';') gte 3)
			main_spec = ListGetAt(dosya[k],3,";");
			else
			main_spec = '';
			if(listlen(dosya[k],';') gte 4)
			start_date = ListGetAt(dosya[k],4,";");
			else
			start_date = '';
			if(listlen(dosya[k],';') gte 5)
			finish_date = ListGetAt(dosya[k],5,";");
			else
			finish_date = '';
			if(listlen(dosya[k],';') gte 6)
			order_row_id = trim(ListGetAt(dosya[k],6,";"));
			else
			order_row_id = '';
			if(listlen(dosya[k],';') gte 7)
				demand_no = ListGetAt(dosya[k],7,";");
			else
				demand_no ='';
		</cfscript>
		<cfquery name="get_product" datasource="#dsn3#">
			SELECT
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PRODUCT_NAME, 
				#product_amount# AS AMOUNT,
				SM.SPECT_MAIN_ID,
				PU.ADD_UNIT UNIT
			FROM
				SPECT_MAIN SM,
				STOCKS S,
				PRODUCT_UNIT PU
			WHERE
				S.STOCK_ID = SM.STOCK_ID 
				AND PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
				<cfif len(trim(main_spec))>
					AND SM.SPECT_MAIN_ID = #main_spec#
				<cfelse>
					AND SM.SPECT_MAIN_ID = (SELECT TOP 1 SMM.SPECT_MAIN_ID FROM SPECT_MAIN SMM WHERE SMM.SPECT_STATUS=1 AND SMM.STOCK_ID = S.STOCK_ID ORDER BY SMM.RECORD_DATE DESC,SMM.UPDATE_DATE DESC)
				</cfif>
				<cfif len(product_code)>
					AND (S.PRODUCT_CODE_2 = '#product_code#' OR S.STOCK_CODE = '#product_code#')
				<cfelse>
					AND 1 = 2
				</cfif>
		</cfquery>
		<cfif len(order_row_id)>
			<cfquery name="get_order_row" datasource="#dsn3#">
				SELECT ORDER_ID,ORDER_ROW_ID FROM ORDER_ROW WHERE ORDER_ROW_ID = #order_row_id#
			</cfquery>
			<cfif get_order_row.recordcount>
				<cfset order_id_= get_order_row.order_id>
				<cfset order_row_id_= get_order_row.order_row_id>
			</cfif>
		</cfif>
		<cfif get_product.recordcount>
			<cfoutput>
				<script type="text/javascript">
					add_row("#get_product.stock_id#","#get_product.product_name#","#get_product.amount#","#get_product.unit#","#start_date#","#finish_date#","#order_id_#","#order_row_id_#","#get_product.spect_main_id#","#demand_no#");
				</script>
			</cfoutput>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='63389.Girilen stok kodlu ürün bilgisi bulunamamıştır.'>");
				history.back();
			</script>
		</cfif>
	</cfloop>	
</cfif>


