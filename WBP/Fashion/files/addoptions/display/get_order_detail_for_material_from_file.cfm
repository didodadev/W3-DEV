<cfset kontrol_file = 0>
<cfif not isdefined("attributes.from_order_list")>
	<cfset upload_folder_ = "#upload_folder#production#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
			  fileField = "uploaded_file" 
			  destination = "#upload_folder_#"
			  nameConflict = "MakeUnique"  
			  mode="777">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder_##file_name#">
			<script language="JavaScript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>	
		<cfset file_size = cffile.filesize>
		<cfset dosya_yolu = "#upload_folder_##file_name#">
		<cffile action="read" file="#dosya_yolu#" variable="dosya">
		<cfcatch type="Any">
			<cfset kontrol_file = 1>
		</cfcatch>  
	</cftry>
</cfif>
<cfset stock_id_list_info1 = ''>
<cfset stock_id_list_info2 = ''>
<cfif (kontrol_file eq 0) or isdefined("attributes.from_order_list")>
	<cfquery name="del_rows" datasource="#dsn3#">
		DELETE FROM PRODUCTION_MATERIAL_ROWS WHERE RECORD_EMP = #session.ep.userid#
	</cfquery>
	<cfif not isdefined("attributes.from_order_list")>
		<cfscript>
			CRLF = Chr(13) & Chr(10);// satır atlama karakteri
			dosya = Replace(dosya,';;','; ;','all');
			dosya = Replace(dosya,';;','; ;','all');
			dosya = ListToArray(dosya,CRLF);
			line_count = ArrayLen(dosya);
		</cfscript>
	<cfelse>
		<cfif isdefined("row_stock_all_")>
			<cfset row_stock_all = row_stock_all_>
			<cfset row_amount_all = row_amount_all_>
			<cfset row_spect_all = row_spect_all_>
		</cfif>
		<cfset line_count = listlen(row_stock_all)>
	</cfif>
	<cfif line_count gt 2000>
		<script>
			alert("Satır Sayısı 2000'den Fazla Olamaz! Lütfen Dosyanızı Düzenleyiniz.");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfif not isdefined("attributes.from_order_list")>
		<cfset from_ = 2>
	<cfelse>
		<cfset from_ = 1>
	</cfif>
	<cfloop from="#from_#" to="#line_count#" index="k">
		<cfif not isdefined("attributes.from_order_list")>
			<cfscript>
				product_code = ListGetAt(dosya[k],1,";");
				product_amount = ListGetAt(dosya[k],2,";");
				if(listlen(dosya[k],';') gte 3)
					main_spec = ListGetAt(dosya[k],3,";");
				else
					main_spec = '';
			</cfscript>
			<cfset prod_amount = 1>
		<cfelse>
			<cfscript>
				product_code = ListGetAt(row_stock_all,k,",");
				product_amount = ListGetAt(row_amount_all,k,",");
				if(ListGetAt(row_spect_all,k,",") gt 0)
					main_spec = ListGetAt(row_spect_all,k,",");
				else
					main_spec = '';
			</cfscript>
			<cfif product_amount gt 0><cfset prod_amount = 1><cfelse><cfset prod_amount = 0></cfif>
		</cfif>
		<cfif prod_amount gt 0>
			<cfquery name="get_product" datasource="#dsn3#">
				SELECT
					S.PRODUCT_ID,
					S.STOCK_ID, 
					S.STOCK_CODE, 
					S.PRODUCT_NAME, 
					#product_amount# AS AMOUNT,
					SM.SPECT_MAIN_ID
				FROM
					SPECT_MAIN SM,
					STOCKS S
				WHERE
					S.STOCK_ID = SM.STOCK_ID 
					<cfif len(main_spec)>
						AND SM.SPECT_MAIN_ID = #main_spec#
					<cfelse>
						AND SM.SPECT_MAIN_ID = (SELECT TOP 1 SMM.SPECT_MAIN_ID FROM SPECT_MAIN SMM WHERE SMM.SPECT_STATUS=1 AND SMM.STOCK_ID = S.STOCK_ID ORDER BY SMM.RECORD_DATE DESC,SMM.UPDATE_DATE DESC)
					</cfif>
					<cfif len(product_code)>
						AND (S.PRODUCT_CODE_2 = '#product_code#' OR S.STOCK_CODE = '#product_code#')
					<cfelse>
						AND 1 = 2
					</cfif>
					<cfif ListLen(attributes.product_code)>
						<cfset p_cod_count = 0>
						AND	
						(
						<cfloop list="#attributes.product_code#" delimiters="," index="p_code">
							<cfset p_cod_count =p_cod_count+1>
							S.PRODUCT_CODE LIKE '#p_code#.%' <cfif ListLen(attributes.product_code,',') gt p_cod_count>OR</cfif>
						</cfloop>
						)
					</cfif>	
					<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
						AND S.COMPANY_ID = #attributes.company_id#
					</cfif>
					<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
						AND S.PRODUCT_MANAGER = #attributes.pos_code#
					</cfif>
					<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>
						AND S.PRODUCT_ID = #attributes.product_id#
					</cfif>
					<cfif isdefined('attributes.sort_type') and len(attributes.sort_type)>
						AND  S.IS_PRODUCTION = #attributes.sort_type#
					</cfif>
			</cfquery>
		<cfelse>
			<cfset get_product.recordcount = 0>
		</cfif>
		<cfif get_product.recordcount>
			<cfscript>
				deep_level = 0;
				function get_subs(spect_main_id)
				{										
					SQLStr = "
							SELECT
								STOCK_ID,
								AMOUNT,
								SPECT_MAIN_ID,
								ISNULL(RELATED_MAIN_SPECT_ID,0) RELATED_MAIN_SPECT_ID
							FROM 
								SPECT_MAIN_ROW SMR
							WHERE
								SMR.SPECT_MAIN_ID = #spect_main_id#
								AND STOCK_ID IS NOT NULL
						";
					query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
					stock_id_ary='';
					for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
					{
						stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'█');
						stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'§');
						stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'§');
						stock_id_ary=listappend(stock_id_ary,query1.RELATED_MAIN_SPECT_ID[str_i],'§');
					}
					return stock_id_ary;
				}
				function writeTree(spect_main_id,main_amount)
				{
					var i = 1;
					var sub_products = get_subs(spect_main_id);
					
					for (i=1; i lte listlen(sub_products,'█'); i = i+1)
					{
						deep_level = deep_level + 1;
						_next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
						_next_amount_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
						_next_spect_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
						_next_related_spect_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),4,'§');
						if(deep_level neq 0 and isdefined("product_amount#deep_level-1#"))
							new_amount = evaluate("product_amount#deep_level-1#");
						else
							new_amount = 1;

						InsSQLStr = "
							INSERT INTO PRODUCTION_MATERIAL_ROWS
							(
								STOCK_ID,
								AMOUNT,
								SPECT_MAIN_ID,
								RECORD_EMP,
								RECORD_DATE,
								TYPE
							)
							VALUES
							(
								#_next_stock_id_#,
								#_next_amount_#*#get_product.AMOUNT#*#new_amount#,
								#_next_spect_id_#,
								#session.ep.userid#,
								#now()#,
								#get_product.STOCK_ID#
							)
						";
						query1 = cfquery(SQLString : InsSQLStr, Datasource : dsn3, is_select:false);
						if(len(main_spec) and _next_related_spect_id_ gt 0)
							new_select_1 = "SELECT TOP 1 SMM.SPECT_MAIN_ID FROM SPECT_MAIN SMM WHERE SMM.SPECT_STATUS=1 AND SMM.STOCK_ID = #_next_stock_id_# AND SPECT_MAIN_ID = #_next_related_spect_id_#";
						else
							new_select_1 = "SELECT TOP 1 SMM.SPECT_MAIN_ID FROM SPECT_MAIN SMM WHERE SMM.SPECT_STATUS=1 AND SMM.STOCK_ID = #_next_stock_id_# ORDER BY SMM.RECORD_DATE DESC,SMM.UPDATE_DATE DESC";
						query1_ = cfquery(SQLString : new_select_1, Datasource : dsn3);
						new_select_row = "SELECT AMOUNT FROM SPECT_MAIN_ROW SMM WHERE SMM.SPECT_MAIN_ID = #_next_spect_id_# AND SMM.STOCK_ID = #_next_stock_id_#";
						query1_row = cfquery(SQLString : new_select_row, Datasource : dsn3);
						if(query1_row.recordcount) 
							main_amount_ = query1_row.AMOUNT[1];
						else 
							main_amount_ = 1;
							
						if(deep_level eq 1)
							'product_amount#deep_level#' = main_amount_;
						else
							'product_amount#deep_level#' = '#Evaluate('product_amount#deep_level-1#')#*#main_amount_#';
						
						new_tree_row = "SELECT STOCK_ID FROM PRODUCT_TREE WHERE STOCK_ID = #_next_stock_id_#";
						get_tree_row = cfquery(SQLString : new_tree_row, Datasource : dsn3);
						if(get_tree_row.recordcount eq 0)
						{
							new_select_row_info = "SELECT IS_PRODUCTION,STOCK_CODE,PRODUCT_NAME FROM STOCKS SMM WHERE STOCK_ID = #_next_stock_id_#";
							query1_row_info = cfquery(SQLString : new_select_row_info, Datasource : dsn3);
							if(query1_row_info.recordcount and query1_row_info.IS_PRODUCTION eq 1)
							{
								InsSQLStr3 = "
									INSERT INTO PRODUCTION_MATERIAL_ROWS 
									(
										STOCK_ID,
										AMOUNT,
										SPECT_MAIN_ID,
										RECORD_EMP,
										RECORD_DATE,
										STOCK_CODE,
										PRODUCT_NAME,
										TYPE
									)
									VALUES
									(
										NULL,
										#_next_amount_#,
										#_next_spect_id_#,
										#session.ep.userid#,
										#now()#,
										'#query1_row_info.STOCK_CODE#',
										'#query1_row_info.PRODUCT_NAME#',
										1
									)
								";
								query3 = cfquery(SQLString : InsSQLStr3, Datasource : dsn3, is_select:false);
							}
						}							
						if(query1_.recordcount gt 0 and len(query1_.SPECT_MAIN_ID[1]) and query1_.SPECT_MAIN_ID[1] neq _next_spect_id_)
							writeTree(query1_.SPECT_MAIN_ID[1],main_amount_);
						
						 deep_level = deep_level-1;
					 }
				}
				writeTree(get_product.SPECT_MAIN_ID,1);
			</cfscript>
		<cfelse>
			<cfquery name="get_stock_info" datasource="#dsn3#">
				SELECT
					S.STOCK_ID,S.PRODUCT_NAME
				FROM
					STOCKS S
				WHERE
					(S.PRODUCT_CODE_2 = '#product_code#' OR S.STOCK_CODE = '#product_code#')
			</cfquery>
			<cfif get_stock_info.recordcount>
				<cfquery name="add_row" datasource="#dsn3#">
					INSERT INTO PRODUCTION_MATERIAL_ROWS 
						(
							STOCK_ID,
							AMOUNT,
							SPECT_MAIN_ID,
							RECORD_EMP,
							RECORD_DATE,
							STOCK_CODE,
							PRODUCT_NAME,
							TYPE
						)
						VALUES
						(
							NULL,
							#product_amount#,
							<cfif len(main_spec)>#main_spec#<cfelse>NULL</cfif>,
							#session.ep.userid#,
							#now()#,
							'#product_code#',
							'#get_stock_info.PRODUCT_NAME#',
							1
						)
				</cfquery>
			<cfelse>
				<cfquery name="add_row" datasource="#dsn3#">
					INSERT INTO PRODUCTION_MATERIAL_ROWS 
						(
							STOCK_ID,
							AMOUNT,
							SPECT_MAIN_ID,
							RECORD_EMP,
							RECORD_DATE,
							STOCK_CODE,
							TYPE
						)
						VALUES
						(
							NULL,
							#product_amount#,
							<cfif len(main_spec)>#main_spec#<cfelse>NULL</cfif>,
							#session.ep.userid#,
							#now()#,
							'#product_code#',
							2
						)
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>	
</cfif>
<cfquery name="check_table" datasource="#dsn3#">
	IF EXISTS (select * from tempdb.sys.tables where name='####get_metarials_get_order_#session.ep.userid#')
        DROP TABLE ####get_metarials_get_order_#session.ep.userid#
</cfquery>
<cfquery name="get_product" datasource="#dsn3#">
	SELECT S.PRODUCT_ID
	FROM TEXTILE_SAMPLE_REQUEST TSR
	INNER JOIN STOCKS S ON TSR.STOCK_ID = S.STOCK_ID
	WHERE TSR.REQ_ID = #attributes.req_id#
</cfquery>
<cfquery name="get_metarials" datasource="#dsn3#">
	SELECT PRODUCT_ID,
			STOCK_ID, 
			STOCK_CODE,
			PRODUCT_NAME,
			UNIT,
			LIST_PRICE
			,MONEY_TYPE
			,BEDEN
			,BOY
			,SPECT_MAIN_ID
			,SPECT_MAIN_NAME 
			,SUM(AMOUNT) AS AMOUNT
			INTO ####get_metarials_get_order_#session.ep.userid# FROM (
		SELECT

			S.PRODUCT_ID,
			S.STOCK_ID, 
			'' SPECT_MAIN_NAME,
			S.STOCK_CODE, 
			S.PRODUCT_NAME + '-' + ISNULL(S.PROPERTY, '') AS PRODUCT_NAME,
			PU.ADD_UNIT UNIT,
			'' SPECT_MAIN_ID,
			SUM(PMR.AMOUNT) AS AMOUNT,
			ISNULL(ISNULL(SRS.REVIZE_PRICE, SRS.PRICE), 0) AS LIST_PRICE 
			,ISNULL(SRS.MONEY_TYPE, 0) AS MONEY_TYPE
			,BT.BOY_ AS BOY
			,ISNULL(BBT.BEDEN_, BT.BEDEN_) AS BEDEN
		
		FROM
			STOCKS S
			LEFT OUTER JOIN (
				SELECT STOCK_ID, AMOUNT, STOCK_CODE, TYPE, PRODUCT_NAME, SPECT_MAIN_ID, RECORD_EMP FROM PRODUCTION_MATERIAL_ROWS GROUP BY STOCK_ID, AMOUNT, STOCK_CODE, TYPE, PRODUCT_NAME, SPECT_MAIN_ID, RECORD_EMP
				) PMR ON S.STOCK_ID = PMR.STOCK_ID
			LEFT OUTER JOIN PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
			LEFT OUTER JOIN TEXTILE_SR_SUPLIERS SRS ON SRS.PRODUCT_ID = S.PRODUCT_ID AND SRS.STOCK_ID = S.STOCK_ID AND SRS.REQ_ID = #attributes.req_id#
			LEFT OUTER JOIN TEXTILE_SAMPLE_REQUEST TSR ON SRS.REQ_ID =  TSR.REQ_ID
			LEFT OUTER JOIN #dsn#.PRO_PROJECTS PPJ on TSR.PROJECT_ID = PPJ.PROJECT_ID
			
			LEFT OUTER JOIN
				(
					SELECT
							BEDEN.PROPERTY_DETAIL AS BEDEN_,
							STOCKS.PRODUCT_ID,
							STOCKS.STOCK_ID,
							BEDEN.RELATED_ID,
							1 AS BBTYPE
						FROM 
							#dsn1#.STOCKS
							OUTER APPLY
							(
								SELECT 
									PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
									PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
									PPD.PRPT_ID,
									PPD.PROPERTY_DETAIL_CODE,
									PTR.RELATED_ID
								FROM
									#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
									#dsn1#.PRODUCT_PROPERTY PRP,
									STOCKS_PROPERTY SP,
									PRODUCT_TREE PTR
								WHERE
									PRP.PROPERTY_ID = PPD.PRPT_ID AND
									SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
									PRP.PROPERTY_SIZE = 1 AND 
									SP.STOCK_ID = STOCKS.STOCK_ID AND
									PTR.STOCK_ID = STOCKS.STOCK_ID
							) AS BEDEN
						WHERE 
							STOCKS.STOCK_STATUS = 1
							AND BEDEN.PROPERTY_DETAIL IS NOT NULL
						GROUP BY BEDEN.PROPERTY_DETAIL, STOCKS.PRODUCT_ID, STOCKS.STOCK_ID, BEDEN.RELATED_ID
				) AS BBT ON #get_product.PRODUCT_ID# = BBT.PRODUCT_ID AND SRS.VARIANT = BBT.BBTYPE AND BBT.RELATED_ID = S.STOCK_ID AND BBT.STOCK_ID = PMR.TYPE
			LEFT OUTER JOIN
				(
					SELECT
							BOY.PROPERTY_DETAIL AS BOY_,
							BEDEN.PROPERTY_DETAIL AS BEDEN_,
							STOCKS.PRODUCT_ID,
							STOCKS.STOCK_ID,
							BOY.RELATED_ID,
							2 AS BBTYPE
						FROM 
							#dsn1#.STOCKS
							OUTER APPLY
							(
								SELECT 
									PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
									PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
									PPD.PRPT_ID,
									PPD.PROPERTY_DETAIL_CODE,
									PTR.RELATED_ID
								FROM
									#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
									#dsn1#.PRODUCT_PROPERTY PRP,
									STOCKS_PROPERTY SP,
									PRODUCT_TREE PTR
								WHERE
									PRP.PROPERTY_ID = PPD.PRPT_ID AND
									SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
									PRP.PROPERTY_LEN = 1 AND 
									SP.STOCK_ID = STOCKS.STOCK_ID AND
									PTR.STOCK_ID = STOCKS.STOCK_ID
							) AS BOY
							OUTER APPLY
							(
								SELECT 
									PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
									PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
									PPD.PRPT_ID,
									PPD.PROPERTY_DETAIL_CODE,
									PTR.RELATED_ID
								FROM
									#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
									#dsn1#.PRODUCT_PROPERTY PRP,
									STOCKS_PROPERTY SP,
									PRODUCT_TREE PTR
								WHERE
									PRP.PROPERTY_ID = PPD.PRPT_ID AND
									SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
									PRP.PROPERTY_SIZE = 1 AND 
									SP.STOCK_ID = STOCKS.STOCK_ID AND
									PTR.STOCK_ID = STOCKS.STOCK_ID
							) AS BEDEN
						WHERE 
							STOCKS.STOCK_STATUS = 1
							AND BOY.PROPERTY_DETAIL IS NOT NULL
							AND BEDEN.PROPERTY_DETAIL IS NOT NULL
							AND BOY.RELATED_ID = BEDEN.RELATED_ID
						GROUP BY BEDEN.PROPERTY_DETAIL, STOCKS.PRODUCT_ID, STOCKS.STOCK_ID, BOY.PROPERTY_DETAIL, BOY.RELATED_ID, BEDEN.RELATED_ID
				) AS BT ON #get_product.PRODUCT_ID# = BT.PRODUCT_ID AND SRS.VARIANT = BT.BBTYPE AND BT.RELATED_ID = S.STOCK_ID AND BT.STOCK_ID = PMR.TYPE
			
			WHERE
			PMR.RECORD_EMP = #session.ep.userid#
			AND PMR.STOCK_ID IS NOT NULL
			<cfif ListLen(attributes.product_code)>
				<cfset p_cod_count = 0>
				AND	
				(
				<cfloop list="#attributes.product_code#" delimiters="," index="p_code">
					<cfset p_cod_count =p_cod_count+1>
					S.PRODUCT_CODE LIKE '#p_code#.%' <cfif ListLen(attributes.product_code,',') gt p_cod_count>OR</cfif>
				</cfloop>
				)
			</cfif>	
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
				AND S.COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
				AND S.PRODUCT_MANAGER = #attributes.pos_code#
			</cfif>
			<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>
				AND S.PRODUCT_ID = #attributes.product_id#
			</cfif>
			<cfif isdefined('attributes.sort_type') and len(attributes.sort_type)>
				AND  S.IS_PRODUCTION = #attributes.sort_type#
			</cfif>
			
		GROUP BY
			S.PRODUCT_ID,
			S.STOCK_ID, 
			S.STOCK_CODE,
			S.PROPERTY, 
			S.PRODUCT_NAME,
			PU.ADD_UNIT
			,ISNULL(ISNULL(SRS.REVIZE_PRICE, SRS.PRICE), 0)
			,SRS.MONEY_TYPE
			,BT.BEDEN_
			,BT.BOY_
			,BBT.BEDEN_
			,SPECT_MAIN_ID
	) T
	GROUP BY PRODUCT_ID,
			STOCK_ID, 
			STOCK_CODE,
			PRODUCT_NAME,
			UNIT,
			LIST_PRICE
			,MONEY_TYPE
			,BEDEN
			,BOY
			,SPECT_MAIN_ID
			,SPECT_MAIN_NAME
	ORDER BY PRODUCT_ID
</cfquery>
<cfquery name="get_metarials" datasource="#dsn3#">
SELECT * FROM ####get_metarials_get_order_#session.ep.userid# ORDER BY PRODUCT_ID
</cfquery>
<cfquery name="get_metarials_new" datasource="#dsn3#">
	SELECT
		PMR.*
	FROM
		PRODUCTION_MATERIAL_ROWS PMR
	WHERE
		PMR.RECORD_EMP = #session.ep.userid#
		AND PMR.STOCK_ID IS NULL
	ORDER BY
		PMR.STOCK_CODE
</cfquery>
<cfoutput query="get_metarials_new">
	<cfif type eq 1>
		<cfset stock_id_list_info1 = listappend(stock_id_list_info1,'#stock_code#;#amount#;#spect_main_id#;#product_name#')><!--- ürün var ağacı yok ise --->
	<cfelse>
		<cfset stock_id_list_info2 = listappend(stock_id_list_info2,'#stock_code#;#amount#;#spect_main_id#;#product_name#')><!--- ürün yok ise --->
	</cfif>
</cfoutput>
