<!--- stock_identity_type 1 ise barkod 2 ise stok kodu 3 ise ozel kod ile sayım dosyası olusturulmustur --->
<cf_get_lang_set module_name="pos"><!--- sayfanin en altinda kapanisi var --->
	<cfset upload_folder = "#upload_folder#store#dir_seperator#">
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
				alert("<cf_get_lang dictionary_id='47804.php,jsp,asp,cfm,cfml Formatlarında Dosya Girmeyiniz'>!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset file_size = cffile.filesize>
		<cfset dosya_yolu = "#upload_folder##file_name#" >
		<cffile action="read" file="#dosya_yolu#" variable="dosya">
		<cffile action="delete" file="#dosya_yolu#">
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='57455.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
	<cfscript>
		//dosya formatı için colum_3,colum_4... tarzı değişkenlerde degerleri tutar formda atlanarak seçebilirler diye döngü ile yazıldı 
		if(isdefined('attributes.add_file_format_1'))
		{
			clm_count=3;//dosyadan kesin 2 alan geliyor diğerleri parametrik olduğundan 3 verdim deger olarak
			for(i=1;i lte 8;i=i+1)
			{
				if(len(evaluate('attributes.add_file_format_#i#')))
				{
					'colum_#clm_count#'=evaluate('attributes.add_file_format_#i#');
					temp_col=evaluate('colum_#clm_count#');
					'#temp_col#_count_colums' = clm_count;//dosyada hangi kolon oldugunu tutar
					clm_count=clm_count+1;
					continue;
				}
			}
		}
		CRLF = Chr(13)&Chr(10); // satır atlama karakteri
		document_seperator = chr(attributes.seperator_type);
		dosya = Replace(dosya,'#document_seperator#'&'#document_seperator#','#document_seperator# #document_seperator#','all');
		dosya = Replace(dosya,'#document_seperator#'&'#document_seperator#','#document_seperator# #document_seperator#','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
	
		barcod_list = "";
		//formdan gelen ek degerler icin liste
		if(isdefined('colum_3')) '#colum_3#_list' = '';
		if(isdefined('colum_4')) '#colum_4#_list' = '';
		if(isdefined('colum_5')) '#colum_5#_list' = '';
		if(isdefined('colum_6')) '#colum_6#_list' = '';
		if(isdefined('colum_7')) '#colum_7#_list' = '';
		if(isdefined('colum_8')) '#colum_8#_list' = '';
		if(isdefined('colum_9')) '#colum_9#_list' = '';
		if(isdefined('colum_10')) '#colum_10#_list' = '';
	
		for(i=1; i lte line_count;i=i+1)
		{
			temp_barcod = trim(listfirst(dosya[i],'#document_seperator#'));
			if(len(temp_barcod) and not listfind(barcod_list,temp_barcod,'#document_seperator#'))
				barcod_list = Listappend(barcod_list,temp_barcod,'#document_seperator#');
			if(isdefined('colum_3') and colum_3 neq 'DELIVER_DATE' and listlen(dosya[i],'#document_seperator#') gt 2)
			{
				'temp_#colum_3#' = trim(listgetat(dosya[i],3,'#document_seperator#'));
				if(len(evaluate('temp_#colum_3#')))
					'#colum_3#_list' = Listappend(evaluate('#colum_3#_list'),evaluate('temp_#colum_3#'),'#document_seperator#');
			}
			if(isdefined('colum_4') and colum_4 neq 'DELIVER_DATE' and listlen(dosya[i],'#document_seperator#') gt 3)
			{
				'temp_#colum_4#' = trim(listgetat(dosya[i],4,'#document_seperator#'));
				if(len(evaluate('temp_#colum_4#')))
					'#colum_4#_list' = Listappend(evaluate('#colum_4#_list'),evaluate('temp_#colum_4#'),'#document_seperator#');
			}
			if(isdefined('colum_5') and colum_5 neq 'DELIVER_DATE' and listlen(dosya[i],'#document_seperator#') gt 4)
			{
				'temp_#colum_5#' = trim(listgetat(dosya[i],5,'#document_seperator#'));
				if(len(evaluate('temp_#colum_5#')))
					'#colum_5#_list' = Listappend(evaluate('#colum_5#_list'),evaluate('temp_#colum_5#'),'#document_seperator#');
			}
			if(isdefined('colum_6') and colum_6 neq 'DELIVER_DATE' and listlen(dosya[i],'#document_seperator#') gt 5)
			{
				'temp_#colum_6#' = trim(listgetat(dosya[i],6,'#document_seperator#'));
				if(len(evaluate('temp_#colum_6#')))
					'#colum_6#_list' = Listappend(evaluate('#colum_6#_list'),evaluate('temp_#colum_6#'),'#document_seperator#');
			}
			if(isdefined('colum_7') and colum_7 neq 'DELIVER_DATE' and listlen(dosya[i],'#document_seperator#') gt 6)
			{
				'temp_#colum_7#' = trim(listgetat(dosya[i],7,'#document_seperator#'));
				if(len(evaluate('temp_#colum_7#')))
					'#colum_7#_list' = Listappend(evaluate('#colum_7#_list'),evaluate('temp_#colum_7#'),'#document_seperator#');
			}
			if(isdefined('colum_8') and colum_8 neq 'DELIVER_DATE' and listlen(dosya[i],'#document_seperator#') gt 7)
			{
				'temp_#colum_8#' = trim(listgetat(dosya[i],8,'#document_seperator#'));
				if(len(evaluate('temp_#colum_8#')))
					'#colum_8#_list' = Listappend(evaluate('#colum_8#_list'),evaluate('temp_#colum_8#'),'#document_seperator#');
			}
			if(isdefined('colum_9') and colum_9 neq 'DELIVER_DATE' and listlen(dosya[i],'#document_seperator#') gt 8)
			{
				'temp_#colum_9#' = trim(listgetat(dosya[i],9,'#document_seperator#'));
				if(len(evaluate('temp_#colum_9#')))
					'#colum_9#_list' = Listappend(evaluate('#colum_9#_list'),evaluate('temp_#colum_9#'),'#document_seperator#');
			}
			if(isdefined('colum_10') and colum_10 neq 'DELIVER_DATE' and listlen(dosya[i],'#document_seperator#') gt 9)
			{
				'temp_#colum_10#' = trim(listgetat(dosya[i],10,'#document_seperator#'));
				if(len(evaluate('temp_#colum_10#')))
					'#colum_10#_list' = Listappend(evaluate('#colum_10#_list'),evaluate('temp_#colum_10#'),'#document_seperator#');
			}
		}
	</cfscript>
	<cfif not listlen(barcod_list)>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='36128.Belgenizde'> <cfif attributes.stock_identity_type eq 1><cf_get_lang dictionary_id ='36129.Barkod Listesi'><cfelseif attributes.stock_identity_type eq 3><cf_get_lang dictionary_id ='36130.Özel Kod Listesi'><cfelse><cf_get_lang dictionary_id ='36131.Stok Kodu Listesi'></cfif> <cf_get_lang dictionary_id ='36132.Bulunamadı'> .<cf_get_lang dictionary_id ='36133.Lütfen Belgenizi Kontrol Ediniz'>  !");
			window.history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_product_main_all" datasource="#dsn3#">
		SELECT
			<cfif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 1>
				GSB.BARCODE,
			</cfif>
			S.STOCK_ID,
			S.PRODUCT_ID,
			S.STOCK_CODE,
			S.PROPERTY,					
			P.PRODUCT_NAME,
			P.MANUFACT_CODE,
			S.STOCK_CODE_2,
			PS.PRICE,
			PS.MONEY,
			PU.MAIN_UNIT,
			PS.PURCHASESALES,
			PS.PRICESTANDART_STATUS,
			PU.IS_MAIN,
			S.IS_PRODUCTION,
			S.IS_PROTOTYPE,
			(SELECT TOP 1 SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID AND SM.SPECT_STATUS = 1 ORDER BY SM.RECORD_DATE DESC) SPECT_MAIN_ID,
			(SELECT TOP 1 SM.SPECT_MAIN_NAME FROM #dsn3_alias#.SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID AND SM.SPECT_STATUS = 1 ORDER BY SM.RECORD_DATE DESC) SPECT_MAIN_NAME
		FROM
			PRODUCT P,
			STOCKS AS S,
			<cfif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 1>
				GET_STOCK_BARCODES AS GSB,
			</cfif>
			PRICE_STANDART AS PS,
			PRODUCT_UNIT AS PU
		WHERE
		<cfif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 1>
			(
			<cfset count=0>
			<cfloop list="#barcod_list#" delimiters="#document_seperator#" index="barcode_ind">
				<cfset count=count+1>
				GSB.BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#barcode_ind#">
				<cfif listlen(barcod_list,document_seperator) gt count>OR</cfif>
			</cfloop>
			)
			<!---ın li degil cunku ifadeler icinde , olabilir GSB.BARCODE IN (#ListQualify(barcod_list,"'")#) ---> AND 
			S.STOCK_ID = GSB.STOCK_ID AND
		<cfelseif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 3>
			(
			<cfset count=0>
			<cfloop list="#barcod_list#" delimiters="#document_seperator#" index="barcode_ind">
				<cfset count=count+1>
				S.STOCK_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#barcode_ind#">
				<cfif listlen(barcod_list,document_seperator) gt count>OR</cfif>
			</cfloop>
			) 
			<!---S.STOCK_CODE_2 IN (#ListQualify(barcod_list,"'")#)---> AND
		<cfelse>
			(
			<cfset count=0>
			<cfloop list="#barcod_list#" delimiters="#document_seperator#" index="barcode_ind">
				<cfset count=count+1>
				S.STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#barcode_ind#">
				<cfif listlen(barcod_list,document_seperator) gt count>OR</cfif>
			</cfloop>
			)
			<!---S.STOCK_CODE IN (#ListQualify(barcod_list,"'")#) ---> AND
		</cfif>
			PS.PURCHASESALES = 0 AND
			PS.PRICESTANDART_STATUS = 1 AND
			PU.IS_MAIN = 1 AND
			P.PRODUCT_ID = S.PRODUCT_ID AND
			PS.PRODUCT_ID = P.PRODUCT_ID AND
			PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			PU.PRODUCT_ID = P.PRODUCT_ID
	</cfquery>
	<cfif not get_product_main_all.recordcount>
		<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='36128.Belgenizde'> <cfif attributes.stock_identity_type eq 1><cf_get_lang dictionary_id ='36129.Barkod Listesi'><cfelseif attributes.stock_identity_type eq 3><cf_get_lang dictionary_id ='36130.Özel Kod Listesi'><cfelse><cf_get_lang dictionary_id ='36131.Stok Kodu Listesi'></cfif> <cf_get_lang dictionary_id ='36134.İle İlgili Ürün Bulunamadı'>.<cf_get_lang dictionary_id ='36133.Lütfen Belgenizi Kontrol Ediniz'>!");
			window.history.back();
		</script>
		<cfabort>
	</cfif>
	<cfif isdefined('SPECT_MAIN_ID_LIST') and listlen(SPECT_MAIN_ID_LIST,'#document_seperator#')><!--- degisken barcode_list olusurken formdan gelen degere gore olusuyor --->
		<!--- kolon olarak main_spec_id varsa main_specler toplu çekiliyor --->
		<cfset SPECT_MAIN_ID_LIST = Replace(SPECT_MAIN_ID_LIST,'#document_seperator#',',','all')>
		<cfquery name="GET_PRODUCT_SPEC_MAIN_ALL" datasource="#dsn3#">
			SELECT
				SPECT_MAIN_ID,
				SPECT_MAIN_NAME
			FROM
				SPECT_MAIN
			WHERE
				SPECT_MAIN_ID IN (#SPECT_MAIN_ID_LIST#)
		</cfquery>
	</cfif>
	<cfif isdefined('SHELF_CODE_LIST') and listlen(SHELF_CODE_LIST,',')><!--- LİSTE BARCODE LİSTESİ İLE BİLRİKDE İSMİ DİNAMİK OLUŞUYOR --->
		<cfquery name="GET_PRODUCT_PLACE_ALL" datasource="#dsn3#">
			SELECT
				PRODUCT_PLACE_ID,
				SHELF_CODE
			FROM
				PRODUCT_PLACE
			WHERE
				(
				<cfset count=0>
				<cfloop list="#SHELF_CODE_LIST#" delimiters="#document_seperator#" index="shlf_ind">
					<cfset count=count+1>
					SHELF_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shlf_ind#">
					<cfif listlen(SHELF_CODE_LIST,document_seperator) gt count>OR</cfif>
				</cfloop>
				)
				AND LOCATION_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_in#">
				AND STORE_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_in#">
		</cfquery>
	</cfif>
	<cfset not_find_product_list=''>
	<cfset many_find_product_list=''>
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
		<tr>
			<td width="100%" height="35" class="headbold"></td>
			<!-- sil -->
			<td width="100" align="right" style="text-align:right;">&nbsp;</td>
			<cf_workcube_file_action pdf='0' mail='0' doc='1' print='1'>
			<!-- sil -->
		</tr>
	</table>
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='36119.PHL Dökümanı İçeriği'></cfsavecontent>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#head#">
			<form action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_write_document</cfoutput>" method="post" name="add_ship_file">
				<input type="hidden" name="file_path_and_name" id="file_path_and_name" value="<cfoutput>#dosya_yolu#</cfoutput>">
				<input type="hidden" name="stock_identity_type" id="stock_identity_type" value="<cfoutput>#attributes.stock_identity_type#</cfoutput>">
				<input type="hidden" name="file_name" id="file_name" value="<cfoutput>#file_name#</cfoutput>">
				<input type="hidden" name="location_in" id="location_in" value="<cfoutput>#attributes.location_in#</cfoutput>">
				<input type="hidden" name="department_in" id="department_in" value="<cfoutput>#attributes.department_in#</cfoutput>">
				<input type="hidden" name="line_count" id="line_count" value="<cfoutput>#line_count#</cfoutput>">
				<input type="hidden" name="description" id="description" value="<cfoutput>#attributes.description#</cfoutput>">
				<input type="hidden" name="seperator_type" id="seperator_type" value="<cfoutput>#attributes.seperator_type#</cfoutput>">
				<!--- ek kolonların --->
				<input type="hidden" name="add_file_format_1" id="add_file_format_1" value="<cfoutput>#attributes.add_file_format_1#</cfoutput>">
				<input type="hidden" name="add_file_format_2" id="add_file_format_2" value="<cfoutput>#attributes.add_file_format_2#</cfoutput>">
				<input type="hidden" name="add_file_format_3" id="add_file_format_3" value="<cfoutput>#attributes.add_file_format_3#</cfoutput>">
				<input type="hidden" name="add_file_format_4" id="add_file_format_4" value="<cfoutput>#attributes.add_file_format_4#</cfoutput>">
				<input type="hidden" name="add_file_format_5" id="add_file_format_5" value="<cfoutput>#attributes.add_file_format_5#</cfoutput>">
				<input type="hidden" name="add_file_format_6" id="add_file_format_6" value="<cfoutput>#attributes.add_file_format_6#</cfoutput>">
				<input type="hidden" name="add_file_format_7" id="add_file_format_7" value="<cfoutput>#attributes.add_file_format_7#</cfoutput>">
				<!---// ek kolonların  --->
				<cf_grid_list>
					<thead>
						<tr>
							<th><cf_get_lang dictionary_id ='58508.Satır'></th>
							<cfif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 1>
								<th><cf_get_lang dictionary_id='57633.Barkod'></th>
							<cfelseif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 3>
								<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
							</cfif>
							<th ><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<th ><cf_get_lang dictionary_id='57657.Ürün'></th>
							<th ><cf_get_lang dictionary_id='57634.Üretici Kodu'></th>
							<th ><cf_get_lang dictionary_id='57647.Spec'></th>
							<th ><cf_get_lang dictionary_id='36091.Finansal Yaş'></th>
							<th ><cf_get_lang dictionary_id='36090.Fiziksel Yaş'></th>
							<th ><cf_get_lang dictionary_id='36088.Raf'></th>
							<th ><cf_get_lang dictionary_id='36089.Son Kullanma Tarihi'></th>
							<th ><cf_get_lang dictionary_id='36046.lot no'></th>
							<th ><cf_get_lang dictionary_id='36121.Birim Maliyet'></th>
							<th ><cf_get_lang dictionary_id='36098.Ek Maliyet'></th>
							<th ><cf_get_lang dictionary_id='57635.Miktar'></th>
							<cfif session.ep.isBranchAuthorization eq 0><th align="right"  style="text-align:right;"><cf_get_lang dictionary_id ='36122.Toplam Alış Fiyatı'></th></cfif>
						</tr>
					</thead>
					<tbody>
						<cftry>
							<cfset net_total = 0>
							<cfloop from="1" to="#line_count#" index="k">
								<cfset temp_barcod = trim(ListGetAt(dosya[k],1,"#document_seperator#"))>
								<cfquery name="get_product_main" dbtype="query">
									SELECT
										<cfif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 1>
											BARCODE,
										</cfif>
										STOCK_ID,
										PRODUCT_ID,
										STOCK_CODE,
										PROPERTY,					
										PRODUCT_NAME,
										STOCK_CODE_2,
										MANUFACT_CODE,
										PRICE,
										MONEY,
										MAIN_UNIT,
										IS_PRODUCTION,
										IS_PROTOTYPE,
										SPECT_MAIN_ID,
										SPECT_MAIN_NAME
									FROM
										get_product_main_all
									WHERE
										<cfif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 1>
											BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp_barcod#">
										<cfelseif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 3>
											STOCK_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp_barcod#">
										<cfelse>
											STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp_barcod#">
										</cfif>
								</cfquery>
								<cfif get_product_main.recordcount eq 1>
									<cfoutput query="get_product_main">
										<cfif MAIN_UNIT is "Kg">
											<cfset satir_toplam = trim(Replace( ListGetAt( dosya[k],2,"#document_seperator#" ),',','.','all' ) * price) / 1000>
										<cfelse>
											<cfset satir_toplam = trim(Replace( ListGetAt( dosya[k],2,"#document_seperator#"),',','.','all' )) * price>
										</cfif>
										<input type="hidden" name="barcode_#k#" id="barcode_#k#" value="#ListGetAt(dosya[k],1,'#document_seperator#')#">
										<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
											<td align="center">#k#</td>
											<cfif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 1>
												<td>#barcode#</td>
											<cfelseif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 3>
												<td>#stock_code_2#</td>
											</cfif>
											<td>#stock_code#</td>
											<td>#product_name# #property#</td>
											<td>#manufact_code#</td>
											<td nowrap>
												<cfif isdefined('SPECT_MAIN_ID_count_colums') and listlen(dosya[k],"#document_seperator#") gt SPECT_MAIN_ID_count_colums-1 and len(trim(ListGetAt(dosya[k],SPECT_MAIN_ID_count_colums,"#document_seperator#")))>
													<cfset satir_spec = trim(ListGetAt(dosya[k],SPECT_MAIN_ID_count_colums,"#document_seperator#"))>
													<cfquery name="get_product_spec_main" dbtype="query">
														SELECT
														SPECT_MAIN_ID,
														SPECT_MAIN_NAME
													FROM
														GET_PRODUCT_SPEC_MAIN_ALL
													WHERE
														SPECT_MAIN_ID = <cfif len(satir_spec)><cfqueryparam cfsqltype="cf_sql_integer" value="#satir_spec#"><cfelse>0</cfif>
													</cfquery>
													<input type="hidden" name="spect_main_id_#k#" id="spect_main_id_#k#" value="#get_product_spec_main.SPECT_MAIN_ID#">
													<input type="text" name="spect_main_name_#k#" id="spect_main_name_#k#" value="(#get_product_spec_main.SPECT_MAIN_ID#) #get_product_spec_main.SPECT_MAIN_NAME#" style="width:150px;">
												<cfelseif get_product_main.is_production eq 1 and get_product_main.is_prototype eq 0 and len(get_product_main.spect_main_id)>
													<input type="hidden" name="spect_main_id_#k#" id="spect_main_id_#k#" value="#get_product_main.spect_main_id#">
													<input type="text" name="spect_main_name_#k#" id="spect_main_name_#k#" value="#get_product_main.spect_main_name#" style="width:150px;">							
												<cfelse>
													<input type="hidden" name="spect_main_id_#k#" id="spect_main_id_#k#" value="">
													<input type="text" name="spect_main_name_#k#" id="spect_main_name_#k#" value="" style="width:150px;">							
												</cfif>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_spect_main&stock_id=#STOCK_ID#&field_main_id=add_ship_file.spect_main_id_#k#&field_name=add_ship_file.spect_main_name_#k#','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
											</td>
											<td>
												<cfif isdefined('FINANCE_DATE_count_colums') and listlen(dosya[k],"#document_seperator#") gt FINANCE_DATE_count_colums-1>
													<cfset satir_finance_date = trim(ListGetAt(dosya[k],FINANCE_DATE_count_colums,"#document_seperator#"))>
													<input type="text" name="finance_date_#k#" id="finance_date_#k#" value="#satir_finance_date#" style="width:75px;">
												<cfelse>
													<input type="text" name="finance_date_#k#" id="finance_date_#k#" value="" style="width:75px;">
												</cfif>
											</td>
											<td>
												<cfif isdefined('PHYSICAL_AGE_count_colums') and listlen(dosya[k],"#document_seperator#") gt PHYSICAL_AGE_count_colums-1>
													<cfset satir_physical_age = trim(ListGetAt(dosya[k],PHYSICAL_AGE_count_colums,"#document_seperator#"))>
													<input type="text" name="physical_age_#k#" id="physical_age_#k#" value="#satir_physical_age#" style="width:50px;" align="right">
												<cfelse>
													<input type="text" name="physical_age_#k#" id="physical_age_#k#" value="" style="width:50px;" align="right">
												</cfif>
											</td>
											<td>
												<cfif isdefined('shelf_code_count_colums') and listlen(dosya[k],"#document_seperator#") gt shelf_code_count_colums-1>
													<cfset satir_shelf = trim(ListGetAt(dosya[k],shelf_code_count_colums,"#document_seperator#"))>
													<cfif len(satir_shelf)>
														<cfquery name="GET_PRODUCT_PLACE" dbtype="query">
															SELECT
																PRODUCT_PLACE_ID,
																SHELF_CODE
															FROM
																GET_PRODUCT_PLACE_ALL
															WHERE
																SHELF_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#satir_shelf#">
														</cfquery>
														<cfset satir_shelf_id = GET_PRODUCT_PLACE.PRODUCT_PLACE_ID>
														<cfset satir_shelf = GET_PRODUCT_PLACE.SHELF_CODE>
													<cfelse>
														<cfset satir_shelf_id = ''>
														<cfset satir_shelf = ''>
													</cfif>
												<cfelse>
													<cfset satir_shelf = ''>
													<cfset satir_shelf_id = ''>
												</cfif>
												<input type="hidden" name="shelf_id_#k#" id="shelf_id_#k#" value="#satir_shelf_id#">
												<input type="text" name="shelf_number_#k#" id="shelf_number_#k#" style="width:75;" value="#satir_shelf#">
											</td>
											<td>
												<cfif isdefined('deliver_date_count_colums') and listlen(dosya[k],"#document_seperator#") gt deliver_date_count_colums-1>
													<cfset satir_deliver = trim(ListGetAt(dosya[k],deliver_date_count_colums,"#document_seperator#"))>
												<cfelse>
													<cfset satir_deliver = ''>
												</cfif>
												<input type="text" name="deliver_date_#k#" id="deliver_date_#k#" maxlength="10" style="width:75;" value="#satir_deliver#">
											</td>
											<td>
												<cfif isdefined('LOT_NO_count_colums') and listlen(dosya[k],"#document_seperator#") gt LOT_NO_count_colums-1>
													<cfset satir_lot_no = trim(ListGetAt(dosya[k],LOT_NO_count_colums,"#document_seperator#"))>
												<cfelse>
													<cfset satir_lot_no = ''>
												</cfif>
												<input type="text" name="lot_no_#k#" id="lot_no_#k#" maxlength="10" style="width:75;" value="#satir_lot_no#">
											</td>
											<td>
												<cfif isdefined('cost_price_count_colums') and listlen(dosya[k],"#document_seperator#") gt cost_price_count_colums-1>
													<cfset satir_cost_price = trim(ListGetAt(dosya[k],cost_price_count_colums,'#document_seperator#'))>
												<cfelse>
													<cfset satir_cost_price = ''>
												</cfif>
												<input type="text" name="cost_price_#k#" id="cost_price_#k#" style="width:50;" value="#satir_cost_price#" align="right">
											</td>
											<td>
												<cfif isdefined('extra_cost_count_colums') and listlen(dosya[k],"#document_seperator#") gt extra_cost_count_colums-1>
													<cfset satir_extra_cost = trim(ListGetAt(dosya[k],extra_cost_count_colums,'#document_seperator#'))>
												<cfelse>
													<cfset satir_extra_cost = ''>
												</cfif>
												<input type="text" name="extra_cost_#k#" id="extra_cost_#k#" style="width:50;" value="#satir_extra_cost#" align="right">
											</td>
											<td><input type="text" name="miktar_#k#" id="miktar_#k#" maxlength="10" style="width:50;" value="#trim(Replace( ListGetAt( dosya[k],2,'#document_seperator#'),',','.','all' ))+0#"></td>
											<cfif session.ep.isBranchAuthorization eq 0><td align="right" style="text-align:right;">#TLFormat(satir_toplam)# #money#</td></cfif>
										</tr>
										<cfif session.ep.isBranchAuthorization eq 0>
											<cfif money neq session.ep.money>
												<cfquery name="get_money_rate" datasource="#dsn#" maxrows="1">
													SELECT
														RATE2
													FROM
														SETUP_MONEY
													WHERE
														COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
														PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
														MONEY_STATUS = 1 AND
														MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
													ORDER BY
													MONEY_ID DESC
												</cfquery>
												<cfif get_money_rate.recordcount>
													<cfset satir_toplam=satir_toplam*get_money_rate.rate2>
												</cfif>
												<!--- kod yazilacak --->
											</cfif>
											<cfset net_total = net_total + satir_toplam>
										</cfif>
									</cfoutput>
								<cfelse>
									<cfif not get_product_main.recordcount>
										<cfset not_find_product_list=trim(ListGetAt(dosya[k],1,"#document_seperator#"))>
									<cfelse>
										<cfset many_find_product_list=trim(ListGetAt(dosya[k],1,"#document_seperator#"))>
									</cfif>
								</cfif>
							</cfloop>
							<cfif session.ep.isBranchAuthorization eq 0>
								<cfoutput>
									<tr class="color-list" height="22">
										<td colspan="<cfif isdefined('attributes.stock_identity_type') and listfind('1,3',attributes.stock_identity_type,',')>14<cfelse>13</cfif>" align="right"  class="formbold"  style="text-align:right;"><cf_get_lang dictionary_id ='36080.Toplam Maliyet'></td>
										<td align="right" class="txtbold" style="text-align:right;">#TLFormat(net_total)# #session.ep.money#</td>
									</tr>
								</cfoutput>
							</cfif>
							<cfcatch>!!!<cf_get_lang dictionary_id ='36135.DOSYA OKUMADA HATA VAR'>!!!</cfcatch>
						</cftry>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="13">
							<cf_record_info query_name="get_product_main">
							</td>
							<td style="text-align:right">
								<cf_workcube_buttons is_upd='0' type_format="1">
							</td>
						</tr>
					</tfoot>
				</cf_grid_list>
			</form>
		</cf_box>
	</div>
	<cfif listlen(not_find_product_list,'#document_seperator#') or listlen(many_find_product_list,'#document_seperator#')>
		<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
			<tr class="color-border">
				<td>
					<table width="100%" cellpadding="2" cellspacing="1">
						<tr class="color-header" height="22">
							   <td  colspan="2"><cf_get_lang dictionary_id ='36136.Hatalı Kayıtlar'></td>
						</tr>
						<tr class="color-row" height="22">
							<td width="120"><cf_get_lang dictionary_id ='36137.Bulunamayan Kayıtlar'></td>
							<td><cfoutput><cfloop list="#not_find_product_list#" index="ind" delimiters="#document_seperator#">#ind# #document_seperator#</cfloop></cfoutput></td>
						</tr>
						<tr class="color-row" height="22">
							<td width="120"><cf_get_lang dictionary_id ='36138.Benzer Kayıtlar'></td>
							<td><cfoutput><cfloop list="#many_find_product_list#" index="ind" delimiters="#document_seperator#">#ind# #document_seperator#</cfloop></cfoutput></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</cfif>
	<script language="JavaScript" type="text/javascript">
		function kaydet_control(){
			document.add_ship_file.submit();
		}
	</script>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	