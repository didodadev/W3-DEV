<cfflush interval="3000">
<cfsetting showdebugoutput="no">
<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cftry>	
	<cffile action = "upload" 
		fileField = "uploaded_file" 
		destination = "#upload_folder#"
		nameConflict = "MakeUnique"  
		mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
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
	<cfcatch type="any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>
<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	satir_no =0;
	satir_say =0;
	add_record = 0;
	upd_record = 0;
</cfscript>
<cfif attributes.recort_type eq 0>
	<cfset temp_alan='BARCOD'>
	<cfset temp_detail='Barkod'>
<cfelseif attributes.recort_type eq 1>
	<cfset temp_alan='STOCK_CODE_2'>
	<cfset temp_detail='Özel Kod'>
<cfelseif attributes.recort_type eq 2>
	<cfset temp_alan='STOCK_CODE'>
	<cfset temp_detail='Stok Kod'>
</cfif>
<cfquery name="GET_ALL_STOCK" datasource="#DSN3#">
	SELECT 
		BARCOD,
		STOCK_CODE_2,
		STOCK_CODE,
		STOCK_ID,
		PRODUCT_ID		
	FROM 
		STOCKS 
</cfquery>
<cflock name="#createuuid()#" timeout="500">
	<cftransaction>
		<cfloop from="2" to="#line_count#" index="i"> 
			<cfset j= 1>
			<cfset error_flag = 0>
			<cftry>
				<cfscript>
					satir_no=satir_no+1;
					recort_type_value = Listgetat(dosya[i],j,";");//Aktarım tipidir./Stok kodu/ veya Bar kodu/ veya Özel Kodu
					recort_type_value = trim(recort_type_value);//araya zaman içinde sutun eklenebilsin diye değişkenle j artırılmıştır.
					j=j+1;
					strate_type = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					max_stock = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					min_stock = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					bloc_stock_valu = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					rep_stock_value = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					min_order_stock_value = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					min_order_unit_id = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					max_order_stock_value = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					max_order_unit_id = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					strate_order_type = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					prov_time = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					is_liv_order = trim(Listgetat(dosya[i],j,";"));
					j=j+1;	
					if(listlen(dosya[i],';') gte j)
					{
						stoc_action_id = Listgetat(dosya[i],j,";");
						stoc_action_id = left(trim(stoc_action_id),255);
					}
					else
						stoc_action_id ='';
					j=j+1;	
					if(listlen(dosya[i],';') gte j)
					{
						dept_id = Listgetat(dosya[i],j,";");
						dept_id = trim(dept_id);
					}
					else
						dept_id ='';
				</cfscript>
			<cfcatch type="any">
				<cfoutput>#satir_no#</cfoutput>.Satırda Hata Oluştu.<br/>
				<cfset error_flag = 1>
			</cfcatch>
			</cftry>
			<cfif error_flag  neq 1>
				<cfif not len(recort_type_value) or not len(max_stock) or not len(prov_time) or not len(rep_stock_value) or not len(min_stock) or not len(min_order_stock_value) or not len(is_liv_order) or not len(strate_type) or not len(bloc_stock_valu)>
					<cfoutput>
						#satir_no#.satırdaki zorunlu alanlarda eksik değerler var Lütfen dosyanızı kontrol ediniz !.<br/>
					</cfoutput>
					<cfset error_flag = 1>
				</cfif>
				<cfif error_flag neq 1>
					<cfquery name="GET_ROW_STOCK" dbtype="query">
						SELECT 
							STOCK_ID,
							PRODUCT_ID 
						FROM 
							GET_ALL_STOCK 
						WHERE 
							#temp_alan# = '#recort_type_value#'
					</cfquery>
					<cfset p_id_ = get_row_stock.product_id>
					<cfset s_id_ = get_row_stock.stock_id>
					<cfif get_row_stock.recordcount>	
						<!--- satırdaki birim, urun birimleri arasında var mı --->
						<cfquery name="GET_PRODUCT_UNIT" datasource="#DSN3#">
							SELECT 
								DISTINCT 
								PRODUCT_UNIT_ID,
								ADD_UNIT,
								MAIN_UNIT_ID
							FROM 
								PRODUCT_UNIT 
							WHERE 
								PRODUCT_UNIT_STATUS = 1 AND 
								PRODUCT_ID = #get_row_stock.product_id#
								AND IS_MAIN = 1
						</cfquery>
						<cfloop query="get_product_unit">
							<cfif not len(min_order_unit_id)>
								<cfset min_order_product_unit = get_product_unit.PRODUCT_UNIT_ID>
							<cfelseif get_product_unit.add_unit eq min_order_unit_id>
								<cfset min_order_product_unit = get_product_unit.product_unit_id>
							</cfif>
							<cfif not len(max_order_unit_id)>
								<cfset max_order_product_unit = get_product_unit.PRODUCT_UNIT_ID>
							<cfelseif get_product_unit.add_unit eq max_order_unit_id>
								<cfset max_order_product_unit = get_product_unit.product_unit_id>
							</cfif>
						</cfloop>
						<cfif get_product_unit.recordcount gt 0 and isdefined('min_order_product_unit') and isdefined('max_order_product_unit')>	
							<cfquery name="GET_STOCK_STRATEGY_RECORD" datasource="#DSN3#">
								SELECT 
									STOCK_STRATEGY_ID
								FROM 
									STOCK_STRATEGY 
								WHERE 
									PRODUCT_ID = #p_id_# AND 
									STOCK_ID = #s_id_#
									<cfif len(dept_id)>
										AND DEPARTMENT_ID = #dept_id#
									</cfif>
							</cfquery>
							<cfif get_stock_strategy_record.recordcount>
								<cfquery name="DELETE_STK_STRATEGY_RESERVED" datasource="#DSN3#">
									DELETE FROM	ORDER_ROW_RESERVED WHERE STOCK_ID = #s_id_# AND DEPARTMENT_ID IS NULL AND STOCK_STRATEGY_ID IS NOT NULL
								</cfquery>
								<cfquery name="UPD_STOCK_STRATEGY_#satir_no#" datasource="#DSN3#">
									UPDATE
										STOCK_STRATEGY
									SET
										STRATEGY_TYPE = <cfif len(strate_type) and strate_type eq 1>1<cfelseif len(strate_type) and strate_type eq 0>0</cfif>,
										MAXIMUM_STOCK = <cfif len(max_stock)>#max_stock#<cfelse>NULL</cfif>,
										PROVISION_TIME = <cfif len(prov_time)>#prov_time#<cfelse>NULL</cfif>,
										REPEAT_STOCK_VALUE = <cfif len(rep_stock_value)>#rep_stock_value#<cfelse>NULL</cfif>,
										MINIMUM_STOCK = <cfif len(min_stock)>#min_stock#<cfelse>NULL</cfif>,
										MINIMUM_ORDER_STOCK_VALUE = <cfif len(min_order_stock_value)>#min_order_stock_value#<cfelse>NULL</cfif>,
										MINIMUM_ORDER_UNIT_ID = <cfif len(min_order_product_unit)>#min_order_product_unit#<cfelse>NULL</cfif>,
										MAXIMUM_ORDER_STOCK_VALUE = <cfif len(max_order_stock_value)>#max_order_stock_value#<cfelse>NULL</cfif>,
										MAXIMUM_ORDER_UNIT_ID = <cfif len(max_order_product_unit)>#max_order_product_unit#<cfelse>NULL</cfif>,
										IS_LIVE_ORDER = <cfif len(is_liv_order)>#is_liv_order#<cfelse>NULL</cfif>,
										STRATEGY_ORDER_TYPE =  <cfif strate_order_type eq 1>1<cfelseif strate_order_type eq 0>0<cfelse>NULL</cfif>,
										BLOCK_STOCK_VALUE = <cfif len(bloc_stock_valu)>#bloc_stock_valu#<cfelse>NULL</cfif>,
										STOCK_ACTION_ID =  <cfif len(stoc_action_id)>#stoc_action_id#<cfelse>NULL</cfif>
									 WHERE
										PRODUCT_ID = #p_id_# AND 
										STOCK_ID = #s_id_# AND
										STOCK_STRATEGY_ID = #get_stock_strategy_record.stock_strategy_id#
										<cfif len(dept_id)>
											AND DEPARTMENT_ID = #dept_id#
										</cfif>
								</cfquery>
								<cfif len(bloc_stock_valu) and bloc_stock_valu gt 0>
									<cfquery name="ADD_STK_STRATEGY" datasource="#DSN3#">
										INSERT INTO
											ORDER_ROW_RESERVED 
										(
											STOCK_STRATEGY_ID,
											STOCK_ID,
											PRODUCT_ID,
											RESERVE_STOCK_IN,
											RESERVE_STOCK_OUT,
											STOCK_IN,
											STOCK_OUT
										)
										VALUES
										(
											#get_stock_strategy_record.stock_strategy_id#,
											#s_id_#,
											#p_id_#,
											0,
											#bloc_stock_valu#,
											0,
											0
										)
									</cfquery>
								</cfif>
								<cfset upd_record = upd_record + 1>
								<cfoutput>#satir_no#.</cfoutput> satırdaki ürüne ait stok stratejisi güncellendi.<br/>
							<cfelse>
								<cfquery name="ADD_STOCK_STRATEGY" datasource="#DSN3#">
									INSERT INTO
										STOCK_STRATEGY
								  	(
										PRODUCT_ID,
										STOCK_ID,
										STRATEGY_TYPE,
										MAXIMUM_STOCK,
										PROVISION_TIME,
										REPEAT_STOCK_VALUE,
										MINIMUM_STOCK,
										MINIMUM_ORDER_STOCK_VALUE,
										MINIMUM_ORDER_UNIT_ID,
										MAXIMUM_ORDER_STOCK_VALUE,
										MAXIMUM_ORDER_UNIT_ID,
										IS_LIVE_ORDER,
										STRATEGY_ORDER_TYPE,
										BLOCK_STOCK_VALUE,
										STOCK_ACTION_ID,
										DEPARTMENT_ID,
										RECORD_DATE,
										RECORD_EMP,
										RECORD_IP
								   	)
									VALUES
								   	(
										#get_row_stock.product_id#,
										#get_row_stock.stock_id#,
										<cfif len(strate_type) and strate_type eq 1>1<cfelseif len(strate_type) and strate_type eq 0>0</cfif>,
										<cfif len(max_stock)>#max_stock#<cfelse>NULL</cfif>,
										<cfif len(prov_time)>#prov_time#<cfelse>NULL</cfif>,
										<cfif len(rep_stock_value)>#rep_stock_value#<cfelse>NULL</cfif>,
										<cfif len(min_stock)>#min_stock#<cfelse>NULL</cfif>,
										<cfif len(min_order_stock_value)>#min_order_stock_value#<cfelse>NULL</cfif>,
										<cfif len(min_order_product_unit)>#min_order_product_unit#<cfelse>NULL</cfif>,
										<cfif len(max_order_stock_value)>#max_order_stock_value#<cfelse>NULL</cfif>,
										<cfif len(max_order_product_unit)>#max_order_product_unit#<cfelse>NULL</cfif>,
										<cfif len(is_liv_order)>#is_liv_order#<cfelse>NULL</cfif>,
										<cfif strate_order_type eq 1>1<cfelseif strate_order_type eq 0>0<cfelse>NULL</cfif>,
										<cfif len(bloc_stock_valu)>#bloc_stock_valu#<cfelse>NULL</cfif>,
										<cfif len(stoc_action_id)>#stoc_action_id#<cfelse>NULL</cfif>,
										<cfif len(dept_id)>#dept_id#<cfelse>NULL</cfif>,
										#now()#,
										#session.ep.userid#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
									)
								</cfquery>
								<cfif len(bloc_stock_valu) and bloc_stock_valu gt 0>
									<cfquery name="GET_MAX_STRATEGY" datasource="#DSN3#">
										SELECT MAX(STOCK_STRATEGY_ID) MAX_ID FROM STOCK_STRATEGY WHERE STOCK_ID = #get_row_stock.stock_id#
									</cfquery>
									<cfquery name="ADD_STK_STRATEGY" datasource="#DSN3#">
										INSERT INTO
											ORDER_ROW_RESERVED 
										(
											STOCK_STRATEGY_ID,
											STOCK_ID,
											PRODUCT_ID,
											RESERVE_STOCK_IN,
											RESERVE_STOCK_OUT,
											STOCK_IN,
											STOCK_OUT
										)
										VALUES
										(
											#get_max_strategy.max_id#,
											#get_row_stock.stock_id#,
											#get_row_stock.product_id#,
											0,
											#bloc_stock_valu#,
											0,
											0
										)
									</cfquery>
								</cfif>
								<cfset add_record = add_record + 1>
								<cfoutput>#satir_no#.</cfoutput> satırdaki ürüne ait stok stratejisi eklendi.<br/>
							</cfif>
						<cfelse>
							<cfoutput>#satir_no#.satırdaki ürün için belirtilen <cfif not isdefined('min_order_product_unit')>"Minimum Sipariş Birimi-"</cfif> <cfif not isdefined('max_order_product_unit')>"Maksimum Sipariş Birimi-"</cfif> ürün birimleri arasında bulunmamaktadır.<br/></cfoutput>
						</cfif>
					<cfelse>
						<cfoutput>#satir_no#.satırdaki #recort_type_value# değerindeki #temp_detail#</cfoutput> bulunamadı.<br/>					
					</cfif>
				<cfelse>
					<cfoutput>#satir_no# .#recort_type_value# </cfoutput>satırda hata oluştu.<br/>
				</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
	<cfoutput>
	Dosyadaki Ürün Sayısı : #satir_no# <br/>
	Stratejisi Güncellenen Ürün Sayısı : #upd_record#<br/>
	Stratejisi Kaydedilen Ürün Sayısı : #add_record#
	</cfoutput>
</cflock>
<cfabort>
