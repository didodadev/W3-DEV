<cfparam name="is_stock_control_with_spec" default="1">
<cfset popup_spec_type=is_stock_control_with_spec>
<!--- Toplu Sonuç Girme Ekranı --->
<cfsetting showdebugoutput="no">
<!--- İlk Önce Toplam Ürün İhtiyaçlarını stok_id ve spec_main id bazında almak için 
gruplayarak query'imizi çekiyoruz, 0 stock kontrelleri bu miktarlar üzerinden yapılacak...  --->
<cfif attributes.type eq 2 or attributes.type eq 3><!--- Stok fişi oluştur denildi ise yada stok kontrolü yapılıyorsa! --->
    <cfquery name="get_production_order_results_groups" datasource="#dsn3#">
        <cfif attributes.type eq 2><!--- Stok fişi oluştur deniliyorsa zaten üretim emri kaydedilmiştir... --->
			SELECT 
				SUM(PORR.AMOUNT) AS TOTAL_AMOUNT,
				PORR.STOCK_ID,
				<cfif popup_spec_type neq 1>0 SPEC_MAIN_ID<cfelse>ISNULL(PORR.SPEC_MAIN_ID,0) AS SPEC_MAIN_ID</cfif><!--- Üretim Emrinin XML ayarlarından Stok Kontrolü Speclere göre yapılsın denildiyse Speclere göre yoksa ürünün genel stoğuna göre çekiyoruz query'i --->
			FROM 
				PRODUCTION_ORDER_RESULTS POR,
				PRODUCTION_ORDER_RESULTS_ROW PORR
			WHERE 
				POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
				POR.P_ORDER_ID IN (#attributes.p_order_id_list#) AND
				PORR.TYPE = 2 <!--- SADECE SARFLAR STOK KONTROLÜNE GİRECEK. --->
				<cfif isdefined("pr_order_id_new")> AND POR.PR_ORDER_ID = #pr_order_id_new#</cfif>
			GROUP BY
				AMOUNT,
				PORR.STOCK_ID,
				PORR.SPEC_MAIN_ID
		<cfelseif attributes.type eq 3><!--- Stok kontrolü yapılıyorsa var olan üreim emirlerinden çekilcek... --->
			   SELECT * FROM 
			   (
				<cfloop list="#attributes.p_order_id_list#" index="pind">
					SELECT
						0 AS SPEC_MAIN_ID,
						RELATED_ID AS STOCK_ID,
						SUM(AMOUNT)*(SELECT QUANTITY FROM PRODUCTION_ORDERS WHERE P_ORDER_ID =#pind#) AS TOTAL_AMOUNT
					FROM 
						PRODUCT_TREE 
					WHERE 
						STOCK_ID IN(SELECT DISTINCT STOCK_ID FROM PRODUCTION_ORDERS WHERE P_ORDER_ID =#pind# )
					GROUP BY 
						RELATED_ID
					UNION 
					SELECT
						<cfif popup_spec_type neq 1>0 AS SPEC_MAIN_ID<cfelse>ISNULL(RELATED_MAIN_SPECT_ID,0) AS SPEC_MAIN_ID</cfif>,
						STOCK_ID, 
						SUM(AMOUNT)*(SELECT QUANTITY FROM PRODUCTION_ORDERS WHERE P_ORDER_ID =#pind#) AS TOTAL_AMOUNT
					FROM 
						SPECT_MAIN_ROW SMR
					WHERE 
						SMR.SPECT_MAIN_ID IN(SELECT DISTINCT SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE P_ORDER_ID =#pind# )
						AND SMR.STOCK_ID IS NOT NULL
					GROUP BY 
						STOCK_ID,RELATED_MAIN_SPECT_ID 
					<cfif ListLast(attributes.p_order_id_list,',') neq pind>
						UNION
					</cfif>
				</cfloop>
           ) TABLE_PRODUCTION 
		</cfif>
    </cfquery>
    <cfset stock_id_list = 0 >
    <cfset spec_main_id_list = 0>
    <cfquery name="get_production_order_results_groups_specsiz" dbtype="query">
        SELECT * FROM get_production_order_results_groups WHERE SPEC_MAIN_ID = 0 AND STOCK_ID IS NOT NULL
    </cfquery>
    <cfif get_production_order_results_groups_specsiz.recordcount>
        <cfset stock_id_list = ValueList(get_production_order_results_groups_specsiz.STOCK_ID,',')>
        <cfloop query="get_production_order_results_groups_specsiz">
            <cfset 'gerekli_miktar_stock#STOCK_ID#' =TOTAL_AMOUNT>
        </cfloop>
    </cfif>
    <cfquery name="get_production_order_results_groups_specli" dbtype="query">
        SELECT * FROM get_production_order_results_groups WHERE SPEC_MAIN_ID > 0
    </cfquery>
    <cfif get_production_order_results_groups_specli.recordcount>
        <cfset spec_main_id_list = ValueList(get_production_order_results_groups_specli.SPEC_MAIN_ID)>
        <cfloop query="get_production_order_results_groups_specli">
            <cfset 'gerekli_miktar_spec#SPEC_MAIN_ID#' =TOTAL_AMOUNT>
        </cfloop>
    </cfif>
    <cfscript>
        user_info = '';
        dep_id = attributes.exit_department_id;
        loc_id = attributes.exit_location_id;
        is_update = 0;
        stock_type = 0;
    </cfscript>
	<cfif len(dep_id) and len(loc_id)>
		<cfquery name="GET_ZERO_STOCK_CONTROL" datasource="#dsn2#">
			 SELECT 
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,
				S.PRODUCT_NAME AS PRODUCT_NAME,
				0 SPECT_MAIN_ID,
				S.STOCK_ID
				
			FROM 
				#dsn3_alias#.STOCKS S, 
				STOCKS_ROW SR
			WHERE 
				SR.STOCK_ID = S.STOCK_ID AND 
				SR.STOCK_ID IN (#stock_id_list#) AND 
				S.IS_ZERO_STOCK = 0 AND
				SR.STORE_LOCATION = #loc_id# AND
				SR.STORE = #dep_id#
			GROUP BY 
				S.STOCK_ID,
				S.PRODUCT_NAME
			UNION ALL  
			SELECT 
				SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, 
				SM.SPECT_MAIN_NAME AS PRODUCT_NAME,
				SM.SPECT_MAIN_ID,
				0 STOCK_ID
			FROM 
				STOCKS_ROW AS SR, 
				#dsn3_alias#.SPECT_MAIN AS SM,
				#dsn3_alias#.STOCKS S
			WHERE
				S.STOCK_ID = SM.STOCK_ID AND
				S.STOCK_ID = SR.STOCK_ID AND
				S.IS_ZERO_STOCK = 0 AND
				SR.PROCESS_TYPE IS NOT NULL AND
				SM.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND 
				SR.SPECT_VAR_ID IN (#spec_main_id_list#) AND 
				UPD_ID NOT IN (0)  AND 
				SR.STORE_LOCATION = #loc_id# AND
				SR.STORE = #dep_id#
			GROUP BY 
				SM.SPECT_MAIN_NAME,SM.SPECT_MAIN_ID
		</cfquery>
	<cfelse>
		<cfset GET_ZERO_STOCK_CONTROL.recordcount = 0>
	</cfif>
	<cfif GET_ZERO_STOCK_CONTROL.recordcount>
        <cfscript>
            for(zi=1;zi lte GET_ZERO_STOCK_CONTROL.recordcount;zi=zi+1){
            _spect_main_id_ = GET_ZERO_STOCK_CONTROL.SPECT_MAIN_ID[zi];
            _stock_id_ = GET_ZERO_STOCK_CONTROL.STOCK_ID[zi];
            _mevcut_stok_ = GET_ZERO_STOCK_CONTROL.PRODUCT_TOTAL_STOCK[zi];
            _product_name_ = GET_ZERO_STOCK_CONTROL.PRODUCT_NAME[zi];
                if(_stock_id_ gt 0){
                    if(isdefined("gerekli_miktar_stock#_stock_id_#") and Evaluate("gerekli_miktar_stock#_stock_id_#") gt _mevcut_stok_)
                        user_info ='#user_info#<tr height="25" class="color-list"><td>#_product_name_#</td><td align="center">-</td><td align="right">#Evaluate("gerekli_miktar_stock#_stock_id_#")#</td><td align="right">#_mevcut_stok_#</td><td align="right">#Evaluate("gerekli_miktar_stock#_stock_id_#")-_mevcut_stok_#</td></tr>';
                }
                else if(_spect_main_id_ gt 0){
                    if(isdefined("gerekli_miktar_spec#_spect_main_id_#") and Evaluate("gerekli_miktar_spec#_spect_main_id_#") gt _mevcut_stok_)
                        user_info ='#user_info#<tr height="25" class="color-list"><td>#_product_name_#</td><td align="center">#_spect_main_id_#</td><td align="right">#Evaluate("gerekli_miktar_spec#_spect_main_id_#")#</td><td align="right">#_mevcut_stok_#</td><td align="right">#Evaluate("gerekli_miktar_spec#_spect_main_id_#")-_mevcut_stok_#</td></tr>';
                }
            }
        </cfscript>
    <cfelse>
        <cfset user_info = '<tr class="color-list"><td colspan="5" class="txtbold">Eksik Stok Bulunamadı!</td></tr>'>    
    </cfif>
</cfif>
<cfif (isdefined('user_info') and len(user_info) and not user_info contains 'Eksik Stok Bulunamadı!') or isdefined('attributes.stock_control')><!--- Eğer bu bloğa girerse Stokta Sıkıntı Var Demektir yada kullanıcı stok kontrolü yapmak istemiştir!--->
	<cf_grid_list>		
		<thead>
			<tr class="color-row">
				<td class="txtbold" colspan="5"><font color="FF0000"><cf_get_lang no="77.Üretimi Sonuçlandırmak İçin Aşağıdaki Ürünlerde Yeterli Stok Miktarı Bulunmamaktadır">!</font></td>
			</tr>
		<tr>
			<th width="150"><cf_get_lang_main no="809.Ürün Adı"></th>
			<th width="40"><cf_get_lang_main no="235.Spec"> M</th>
			<th width="80" style="text-align:right;"><cf_get_lang no="78.Gerekli Miktar"></th>
			<th width="120" style="text-align:right;"><cf_get_lang no="79.Stok Miktarı"></th>
			<th width="80" style="text-align:right;"><cf_get_lang no="80.Eksik Miktar"></th>
		</tr>
	</thead>
		<cfoutput>#user_info#</cfoutput>
	</cf_grid_list>
	<cfabort>
<cfelse>
	<cfif isdefined("attributes.is_prod") and len(attributes.is_prod)>
		<cfquery name="GET_PR_ORDER_ID_ALL" datasource="#DSN3#">
			SELECT P_ORDER_ID,PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE P_ORDER_ID IN (#attributes.p_order_id_list#) ORDER BY RECORD_DATE DESC  <!--- record_date desc yaptım, seri no kaydederken karışıyor die. --->
		</cfquery>
		<cfif GET_PR_ORDER_ID_ALL.recordcount>
			<cfset attributes.pr_order_id = #GET_PR_ORDER_ID_ALL.PR_ORDER_ID#>
			<cfinclude template="add_duration_operation.cfm">
		</cfif>
	</cfif>
	<cfquery name="GET_PR_ORDER_ID_ALL" datasource="#DSN3#">
		SELECT P_ORDER_ID,PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE P_ORDER_ID IN (#attributes.p_order_id_list#)<cfif isdefined("pr_order_id_new")> AND PR_ORDER_ID = #pr_order_id_new#</cfif> ORDER BY RECORD_DATE DESC
	</cfquery>
	<cfif GET_PR_ORDER_ID_ALL.recordcount>
		<cfset attributes.is_multi = 1 >                      
		<!--- BURADA LOOP DÖNDÜĞĞÜ İÇİN DİĞER SAYFADA BÜTÜN ÜRETİM SONUÇLARI GELİYOR. BU NEDENLE ÜRETİM KAYDI YAPILDIĞINDA BİR ÖNCEKİ ÜRETİM SONUCUNA GÖTÜRÜYOR BİZİ.. BURASI NASIL ÇALIŞACAK??? --->
		<cfset is_demontaj = 0>
		<cfloop query="GET_PR_ORDER_ID_ALL">
			<cfset attributes.pr_order_id = PR_ORDER_ID>
			<cfset attributes.p_order_id = P_ORDER_ID>
			<!--- PR_ORDER_ID KADAR DOSYAMIZI INCLUDE EDİYORUZ BU SAYEDE DOSYAYI ÇOĞALTMAYADA GEREK KALMIYCAK! --->
			<cfinclude template="../../production_plan/query/add_production_result_to_stock.cfm">
		</cfloop>
		<script type="text/javascript">
			<cfif isdefined("attributes.no") and isdefined("attributes.record_num")>
				no = "<cfoutput>#attributes.no#</cfoutput>";
				record_num_ = "<cfoutput>#attributes.record_num#</cfoutput>";
				if (eval("document.getElementById('p_finish')") != undefined)
				{
					document.getElementById('p_finish').style.display = "none";
				}
				if (eval("document.getElementById('frm_row'+no+'')") != undefined)
				{
					document.getElementById('frm_row'+no+'').style.display = "none";
				}
				if (eval("document.getElementById('frm_row_1'+no+'')") != undefined)
				{
					document.getElementById('frm_row_1'+no+'').style.display = "none";
				}
				if (eval("document.getElementById('frm_row_2'+no+'')") != undefined)
				{
					document.getElementById('frm_row_2'+no+'').style.display = "none";
				}
				if (eval("document.getElementById('frm_row_3'+no+'')") != undefined)
				{
					document.getElementById('frm_row_3'+no+'').style.display = "none";
				}
				if (eval("document.getElementById('frm_row_4'+no+'')") != undefined)
				{
					document.getElementById('frm_row_4'+no+'').style.display = "none";
				}
				<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
					for(i=1;i<=record_num_; ++i)
					{
						if (eval("document.getElementById('frm_row_5'+no+'_'+i)") != undefined)
						{
							document.getElementById('frm_row_5'+no+'_'+i).style.display = "none";
						}
					}
				</cfif>
			</cfif>
			alert("<cf_get_lang no='76.Üretim Emirleri Sonuçlandırıldı'>!");
			window.location.reload();
		</script>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no='17.Üretim Sonuçlarınız Silinmiştir. Stok Fişi Oluşturamazsınız.'>");
		</script>
	</cfif>
</cfif>
