<cfsetting showdebugoutput="no">
<cfparam name="attributes.station_id" default="">
<cfparam name="_stock_id_list_specsiz_" default="-1">
<cfparam name="_spec_main_id_list_" default="0">
<style>
	.div-box{width: 60px;
		height:60px;
		border: 1px solid #c0c0c0;
		margin: 5px;
	}
	
</style>
<cfquery name="GET_W" datasource="#dsn3#">
	SELECT * FROM WORKSTATIONS ORDER BY STATION_NAME
</cfquery>
<cfquery name="get_all_production" datasource="#dsn3#">
    SELECT
        SUM(PO.QUANTITY) AS QUANTITY,
        PO.STOCK_ID,
        ISNULL(PO.SPEC_MAIN_ID,0) AS SPEC_MAIN_ID,
        S.STOCK_CODE,
        S.PRODUCT_NAME,
        PO.IS_STAGE
    FROM 
        PRODUCTION_ORDERS PO,
        STOCKS S
    WHERE
    	S.STOCK_ID = PO.STOCK_ID 
       	AND 
		(
			(
			PO.P_ORDER_ID IN (#attributes.p_order_id_list#)
			<cfif isdefined('attributes.p_order_no') and len(attributes.p_order_no) >
				AND IS_GROUP_LOT = 1
				AND LOT_NO = '#attributes.lot_no#'
			</cfif>
			)
		)
    GROUP BY PO.STOCK_ID,PO.SPEC_MAIN_ID,S.STOCK_CODE,S.PRODUCT_NAME,PO.IS_STAGE
</cfquery>
<cfset all_stock_id_list = ValueList(get_all_production.STOCK_ID,',')>
<!--- Malzeme ihtiyaçlarını belirlemek için,gelen spec'li yada specsiz ürünler için 2 tane stock_list oluşturucaz.
ve aşağıda uniounlu bir query ile product_tree ve spect_main_row tablolarından bileşenleri çekicez.
 --->
<cfquery name="get_all_production_1" dbtype="query"><!--- ÖNCELİKLE SPEC'İ OLMAYAN ÜRÜNLERİ QUERYOFQUERY İLE ÇEKİYORUZ. --->
	SELECT * FROM get_all_production WHERE SPEC_MAIN_ID IS NULL
</cfquery>
<cfif get_all_production_1.recordcount>
	<cfset _stock_id_list_specsiz_ = ValueList(get_all_production_1.STOCK_ID,',')>
</cfif>
<cfquery name="get_all_production_2" dbtype="query"><!--- DAHA SONRA MAIN_SPEC'I OLANLARI ÇEKİYORUZ. --->
	SELECT * FROM get_all_production WHERE SPEC_MAIN_ID IS NOT NULL
</cfquery>
<cfif get_all_production_2.recordcount>
	<cfset _spec_main_id_list_ = listdeleteduplicates(ValueList(get_all_production_2.SPEC_MAIN_ID,','))>
</cfif>
<cfloop query="get_all_production"><cfscript>'amounts_p_#STOCK_ID#_#SPEC_MAIN_ID#' = QUANTITY;</cfscript></cfloop>
    <cfif get_all_production.recordcount>
		<cfquery name="get_tree_p" datasource="#dsn3#">                
			 SELECT
				0 SPECT_MAIN_ID,
				AMOUNT AS  AMOUNT_,
				PT.RELATED_ID,
				S.PRODUCT_NAME AS REL_PRODUCT_NAME,
				PT.STOCK_ID,
				S.STOCK_CODE AS  REL_STOCK_CODE
			FROM 
				PRODUCT_TREE PT, 
				STOCKS S 
			WHERE 
				S.STOCK_ID = PT.RELATED_ID AND 
				PT.STOCK_ID IN(#_stock_id_list_specsiz_#) 
		UNION ALL
			SELECT
				SMR.SPECT_MAIN_ID,
				SMR.AMOUNT AS AMOUNT_,
				SMR.STOCK_ID AS RELATED_ID,
				S.PRODUCT_NAME AS REL_PRODUCT_NAME,
				SM.STOCK_ID,
				S.STOCK_CODE AS REL_STOCK_CODE
			FROM
				SPECT_MAIN_ROW SMR,
				SPECT_MAIN SM,
				STOCKS S 
			WHERE
				SMR.STOCK_ID IS NOT NULL AND
				SMR.STOCK_ID = S.STOCK_ID AND
				SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID AND
				SM.SPECT_MAIN_ID IN (#_spec_main_id_list_#)
		</cfquery>
		<cfset _stock_id_list_ = ''>
		<cfset _my_count = 1>
		<cfset product_order_all_values=ArrayNew(2)>
		<cfloop query="get_tree_p"><!--- değerleri grupluyoruz. --->
			<cfscript>
			   if(not isdefined('products_values_#RELATED_ID#'))
			   {
					'products_values_#RELATED_ID#' = '#REL_PRODUCT_NAME#█#Evaluate('amounts_p_#STOCK_ID#_#SPECT_MAIN_ID#')*AMOUNT_#';//alt+987
					_stock_id_list_ = ListAppend(_stock_id_list_,RELATED_ID,',');
					_stock_id_list_ = ListAppend(_stock_id_list_,replace(REL_STOCK_CODE,',',';','all'),'-');
					_stock_id_list_ = ListAppend(_stock_id_list_,replace(REL_PRODUCT_NAME,',',';','all'),'-');
					all_stock_id_list = ListAppend(all_stock_id_list,RELATED_ID,',');
					//product_order_all_values[_my_count][1] = RELATED_ID;
					//_my_count = _my_count+1;
				}	
				else
				{
					'products_values_#RELATED_ID#' = '#REL_PRODUCT_NAME#█#ListGetAt(Evaluate("products_values_#RELATED_ID#"),2,'█')+(Evaluate('amounts_p_#STOCK_ID#_#SPECT_MAIN_ID#')*AMOUNT_)#';
				}	
			</cfscript>
		</cfloop>
		<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN1#">
			SELECT 
				P_I.PATH_SERVER_ID, 
				P_I.PATH,
				S.STOCK_ID
			FROM
				PRODUCT_IMAGES P_I,
				STOCKS S
			WHERE
				P_I.PRODUCT_ID = S.PRODUCT_ID AND
				S.STOCK_ID IN (#all_stock_id_list#)
		</cfquery>
		<cfloop query="GET_PRODUCT_IMAGES">
			<cfset 'picture#STOCK_ID#' = '#PATH#,#PATH_SERVER_ID#'>
		</cfloop>
	<cf_box_elements>	
		<div class="col col-6">
			<cfsavecontent  variable="variable_1"><cf_get_lang dictionary_id="38110.Girdiler/Sarflar"></cfsavecontent>
			<cf_seperator title="#variable_1#" id="girdi">       
			<cf_grid_list id="girdi">
				<thead>
					<tr>
						<th width="60px"></th>
						<th width="140px"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
						<th ><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
						<th  width="75px">
							<cf_get_lang dictionary_id='138.Üretim Miktarı'>
						</th>
						<th width="30px">
							<div class="checkbox checbox-switch">
								<label>
									<input type="checkbox" name="" checked="checked">
									<span></span>
								</label>
							</div>
						</th>
					</tr>
				</thead>
				<cfloop list="#_stock_id_list_#" index="_sid_" delimiters=",">
					<tbody>
						<cfoutput>
							<tr>
								<cfif isdefined('picture#ListGetAt(_sid_,1,'-')#')>
									<td  width="60px">
										<div class="div-box" >
										<cf_get_server_file  output_file="product/#ListGetAt(Evaluate('picture#ListGetAt(_sid_,1,'-')#'),1,',')#" output_server="#ListGetAt(Evaluate('picture#ListGetAt(_sid_,1,'-')#'),2,',')#" output_type="0" border="1"image_link="1" image_width="60" image_height="60"></div>
									</td>
								<cfelse>
									<td >
										<div style="font-size: 30px;padding:10px 15px;" class="div-box">
											#mid(ListGetAt(Evaluate('products_values_#ListGetAt(_sid_,1,'-')#'),1,'█'),1,1)#
										</div>
									</td>
								</cfif>
								<td>
									#ListGetAt(_sid_,2,'-')#
								</td>
								<td>
									#ListGetAt(Evaluate('products_values_#ListGetAt(_sid_,1,'-')#'),1,'█')# 
								</td>
								<td style="text-align:right;" width="75px">
									<div class="form-group">
									
										<input type="text" name="quantity" id="quantity" class="moneybox" value="#TlFormat(ListGetAt(Evaluate('products_values_#ListGetAt(_sid_,1,'-')#'),2,'█'))#">
									</div>
								</td>
								<td>
									<div class="checkbox checbox-switch">
										<label>
											<input type="checkbox" name="" checked="checked">
											<span></span>
										</label>
									</div>
								</td>										
							</tr>
						</cfoutput>
					</tbody>
				</cfloop>
			</cf_grid_list>
		</div>
		<div class="col col-6">
			<cfsavecontent  variable="variable_2"><cf_get_lang dictionary_id="38111.Çıktılar/Üretim Sonuçları"></cfsavecontent>
			<cf_seperator title="#variable_2#" id="cikti"> 
				<cf_grid_list id="cikti">
					<thead>
						<tr>
							<th width="60px"></th>
							<th width="110px"><cf_get_lang dictionary_id='57756.Durum'></th>
							<th width="95px"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<th ><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
							<th width="45px"><cf_get_lang dictionary_id='57647.Spekt'></th>
							<th style="75px;">
								<cf_get_lang dictionary_id='138.Üretim Miktarı'>
							</th>
							<th width="30px">
								<div class="checkbox checbox-switch">
									<label>
										<input type="checkbox" name="" checked="checked">
										<span></span>
									</label>
								</div>
							</th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="get_all_production">
							<tr>									
								<td  width="60px">
								<cfif isdefined('picture#STOCK_ID#')>
									<cf_get_server_file output_file="product/#ListGetAt(Evaluate('picture#STOCK_ID#'),1,',')#" output_server="#ListGetAt(Evaluate('picture#STOCK_ID#'),2,',')#" output_type="0" image_link="1" image_width="60" image_height="60">
									<cfelse>
										<div  class="div-box" style="font-size: 30px;padding:10px 15px;">#mid(PRODUCT_NAME,1,1)#</div>
									</cfif>
								</td>
								<td>
									<cfif get_all_production.IS_STAGE eq 2>
										<cf_get_lang dictionary_id='305.Bitti'>
									<cfelseif get_all_production.IS_STAGE eq 3>
										<cf_get_lang dictionary_id='65434.Durdu'>
									<cfelseif get_all_production.IS_STAGE neq 0>
										<cf_get_lang dictionary_id='476.Başlamadı'>
									<cfelseif get_all_production.IS_STAGE neq 1>
										<cf_get_lang dictionary_id ='36891.Operatöre Gönderildi'>
									</cfif>
								</td>
								<td>
									#STOCK_CODE#
								</td>
								<td>
									#PRODUCT_NAME#
								</td>
								<td>
									#SPEC_MAIN_ID#
								</td>
								<td  style="text-align:right;"   width="75px">
									<div class="form-group">
										<input type="text" name="quantity" id="quantity" class="moneybox"  value="#TlFormat(QUANTITY)#">
									</div>
									</td>
								<td>
									<div class="checkbox checbox-switch">
										<label>
											<input type="checkbox" name="" checked="checked">
											<span></span>
										</label>
									</div>
								</td>									
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>
		</div>	
	</cf_box_elements>	
		
			<cf_box_footer>
				<cfif get_all_production.IS_STAGE eq 2>
					<div><cf_get_lang dictionary_id="38113.Üretimler Sonuçlandırılmış">!</div>
				</cfif>
				<cfif get_all_production.IS_STAGE eq 3>
					<div><font color="FF0000"><cf_get_lang dictionary_id="38112.Üretimler Durmuş">!</font></div>
				</cfif>
				<div id="p_starts"<cfif get_all_production.IS_STAGE neq 0>style="display:none;"</cfif>><a href="javascript://" id="b_p_starts" class="ui-wrk-btn ui-wrk-btn-success" onClick="production_start(1);"><cf_get_lang dictionary_id='38059.Üretime Başla'><i class="fa fa-play"></i></a></div>
				<!--- Üretim Başlamış Ancak Sonuçlandırılmamış ise --->
				<div id="p_finish" <cfif get_all_production.IS_STAGE neq 1>style="display:none;"</cfif>><a  href="javascript://" class="ui-wrk-btn ui-wrk-btn-red" onclick="production_start(2);" ><cf_get_lang dictionary_id='38115.Üretimi Sonuçlandır'> <i class="fa fa-flag"></i></a></div>
				
				<div>
					<a href="<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.p_order_id_list#|#attributes.lot_no#</cfoutput>&print_type=280" class="ui-ripple-btn"><cf_get_lang dictionary_id='38114.Barkod Bas'> <i class="fa fa-print"></i></a>
				</div>
				<!--- İşlem Kategorisi ve Süreç style="display:none" --->
				<div style="display:none;">
					<cf_workcube_process_cat slct_width="140"><cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'>
				</div>
				<div>
					<a href="javascript://"  name="stock_control" id="stock_control" class="ui-btn ui-btn-update" onclick="production_start(3);"><cf_get_lang dictionary_id='38116.Stok Kontrol'> <i class="fa fa-puzzle-piece"></i> </a>
				</div>
				<div>
					<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra"  onclick="window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=production.welcome'"><cf_get_lang dictionary_id='57432.Geri'> <i class="fa fa-arrow-circle-left"></i></a>
				</div>
			</cf_box_footer>
		
		<div id="_production_start_"></div><div id="_production_start_2"></div>
	</cfif>
<cfquery name="GET_STATION_INFO" datasource="#dsn3#">
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
		STATION_ID = #attributes.STATION_ID#
</cfquery>
<script type="text/javascript">
	function production_start(type)
	{//1 ise sadece üretim sonucu kaydedecek! 2 ise stok fişlerni oluşturacak! eğer 3 ise stok kontrolü yapacak!
		var j_url_str = "" ;
		var process_cat = document.getElementById('process_cat').length//işlem kategorisi
		if(process_cat < 2)
		{
			alert("<cf_get_lang dictionary_id='38074.Bu İşlemi Yapabilmek İçin İşlem Kategorisine Yetkili Olmalısınız'>!");
			return false;
		}
		process_cat = document.getElementById('process_cat').options[1].value;
		var process_stage= document.getElementById('process_stage').value;//Süreç
		if(process_stage == "")
		{
			alert("<cf_get_lang dictionary_id='60521.Bu İşlemi Yapabilmek İçin Sürece Yetkili Olmasılısınız'>!");
			return false;
		}
		<cfoutput>
			var exit_department_id = '#GET_STATION_INFO.EXIT_DEP_ID#';//Sarf Depo
			var exit_location_id =	'#GET_STATION_INFO.EXIT_LOC_ID#';//Sarf Depo location
			var production_department_id = '#GET_STATION_INFO.PRODUCTION_DEP_ID#';//üretim  depo
			var production_location_id = '#GET_STATION_INFO.PRODUCTION_LOC_ID#';//üretim location
			var enter_department_id = '#GET_STATION_INFO.ENTER_DEP_ID#';//sevkiyat dep
			var enter_location_id ='#GET_STATION_INFO.ENTER_LOC_ID#';//sevkiyat loca
			var station_id = '#attributes.station_id#';
		</cfoutput>
		j_url_str +='&station_id='+station_id+'&process_cat='+process_cat+'&process_stage='+process_stage+'&exit_department_id='+exit_department_id+'&exit_location_id='+exit_location_id+'&production_department_id='+production_department_id+'&production_location_id='+production_location_id+'&enter_department_id='+enter_department_id+'&enter_location_id='+enter_location_id+'';
		if(type == 1)
		{//üretim sonucu kaydet denilmiş ise
			document.getElementById('b_p_starts').disabled=true;//butona 2 kere tıklanmasın diye pasif yapıyoruz.!
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=production.emptypopup_ajax_add_prod_order_result_group&type='+type+''+j_url_str+'&p_order_id_list=#attributes.p_order_id_list#</cfoutput>','_production_start_',1,'Üretimler Başlatılıyor!');	
		}
		else if(type == 2 || type == 3)
		{//stok fişlerini oluştur denilmiş ise yada stok kontolü yapılmak isteniyorsa!
			if((exit_department_id == "") || (production_department_id == ""))
			{
				alert("<cf_get_lang dictionary_id='60522.Giriş ve Çıkış Depolarının Seçilmiş Olması Gerekiyor'>!");
				return false;
			}
			if(type == 3)//stok kontrolü yapılmak isteniyorsa j_url_str ifademizin içine stock_control değişkeninide ekleyerek gönderiyoruz bu sayede ürünün stok bilgileri oluşmuş olucak!
				j_url_str='&stock_control=1'+j_url_str;
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=production.emptypopup_ajax_add_production_result_to_stock_groups&type='+type+''+j_url_str+'&p_order_id_list=#attributes.p_order_id_list#</cfoutput>','_production_start_',1,'Üretimler Başlatılıyor!');	
		}
	}
</script>
