<!-- Start Styles. Move the 'style' tags and everything between them to between the 'head' tags -->
<style type="text/css">
.myOtherTable { background-color:#FFFFE0;border-collapse:collapse;color:#000;font-size:18px; }
.myOtherTable th { background-color:#BDB76B;color:white;width:50%; }
.myOtherTable td, .myOtherTable th { padding:5px;border:0; }
.myOtherTable td { border-bottom:1px dotted #BDB76B; }
</style>
<!-- End Styles -->

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.money" default="EUR">

<cfset textile_round=3>

<cfquery name="get_detail" datasource="#dsn3#">
SELECT 
	T.ID,
	T.REQUEST_COMPANY_STOCK,
	T.STOCK_ID,
	T.UNIT,
	T.PRODUCT_CATID,
	T.MONEY_TYPE,
	T.QUANTITY,
	T.REVIZE_QUANTITY,
	T.PRICE,
	T.REVIZE_PRICE,
	T.PRODUCT_NAME,
	T.TYPE
FROM
	(
	SELECT 
		0 AS TYPE,
		TSS.ID,
		TSS.REQUEST_COMPANY_STOCK,
		TSS.STOCK_ID,
		TSS.PRODUCT_ID,
		TSS.UNIT,
		TSS.PRODUCT_CATID,
		ISNULL(TSS.MONEY_TYPE,'TL') MONEY_TYPE,
		ISNULL(TSS.QUANTITY,0) QUANTITY,
		ISNULL(TSS.REVIZE_QUANTITY,ISNULL(TSS.QUANTITY,0)) REVIZE_QUANTITY,
		ISNULL(TSS.PRICE,0) PRICE,
		case when TSS.REVIZE_PRICE = 0 then
		ISNULL(TSS.PRICE,0)
		else
		ISNULL(TSS.REVIZE_PRICE,ISNULL(TSS.PRICE,0))
		end AS REVIZE_PRICE,
		P.PRODUCT_NAME
	FROM #dsn3#.[TEXTILE_SR_SUPLIERS] TSS
		RIGHT JOIN #dsn1#.PRODUCT P
		ON TSS.PRODUCT_ID=P.PRODUCT_ID
	WHERE REQ_ID=#attributes.req_id# AND
		  ISNULL(TSS.IS_STATUS,1)=1
	
	UNION ALL
	SELECT
		1 AS TYPE,
		TSP.ID,
		Null REQUEST_COMPANY_STOCK,
		TSP.STOCK_ID,
		P.PRODUCT_ID,
		'BR' AS UNIT,
		TSP.PRODUCT_CATID,
		ISNULL(TSP.MONEY,'TL') MONEY_TYPE,
		1 AS QUANTITY,
		1 AS REVIZE_QUANTITY,
		ISNULL(TSP.PRICE,0) PRICE,
			ISNULL(TSP.REVIZE_PRICE,ISNULL(TSP.PRICE,0)) REVIZE_PRICE,
		P.PRODUCT_NAME
	FROM #dsn3#.[TEXTILE_SR_PROCESS] TSP
		RIGHT JOIN #dsn1#.PRODUCT P
		ON TSP.PRODUCT_ID=P.PRODUCT_ID
	WHERE 
		REQUEST_ID=#attributes.req_id# 
		--and ISNULL(TSP.IS_STATUS,1)=1
	) T  
</cfquery>

<cfquery name="GET_MONEYS" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>

<cfquery name="get_opportunity" datasource="#dsn3#">
	SELECT *FROM TEXTILE_SAMPLE_REQUEST WHERE REQ_ID=#attributes.req_id#
</cfquery>

<cfquery name="get_money_bskt" datasource="#dsn3#">
	SELECT *FROM TEXTILE_SAMPLE_REQUEST_MONEY WHERE ACTION_ID=#attributes.req_id#
</cfquery>
<cfif get_money_bskt.recordcount eq 0>
	<cfquery name="get_money_bskt" datasource="#dsn3#">
		select 
			MONEY MONEY_TYPE,
			RATE1,
			RATE2,
			0 IS_SELECTED
		from #dsn#.TEXTILE_SETUP_MONEY
		WHERE 
			PERIOD_ID=#session.ep.period_id# AND COMPANY_ID=#session.ep.company_id# AND MONEY_STATUS=1
	</cfquery>
</cfif>
<cfinclude template="../../sales/query/get_req.cfm">
<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
	getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
</cfscript>
<cfset moneylist = structNew()>
<cfloop query="get_money_bskt">
<cfset moneylist[MONEY_TYPE] = RATE2>
</cfloop>

<div class="row">
	<div class="col col-12">
	<cf_box id="sample_request" closable="0" unload_body = "1"  title="Numune Özet" >
		<div class="col col-10 col-xs-10">
				<cfinclude template="../../common/get_opportunity_type.cfm">
				<cfinclude template="../../sales/display/dsp_sample_request.cfm">
		</div>
		<div class="col col-2 col-xs-2">
			<cfinclude template="../../objects/display/asset_image.cfm">
		</div>
	</cf_box>
	</div>
</div>

<div class="row">
	<div  class="col col-12">
		<cfform name="s_Form" method="post" action="" >
		<cf_big_list_search title="Konfigurator">
		<cf_big_list_search_area>
		<div class="row form-inline">
                <div class="form-group" id="form-opp_id">
                    <div class="input-group x-10">
						Rapor Para Birimi 
						<select name="money" id="money" onchange="get_currency();">
							<cfoutput query="GET_MONEYS">
								<option value="#MONEY#" <cfif isdefined('attributes.money') and attributes.money eq MONEY>selected<cfelseif not isdefined('attributes.money') and MONEY eq SESSION.EP.MONEY>selected</cfif>>#MONEY#</option>
							</cfoutput>
						</select>
						<cfif not isdefined('attributes.rate')><cfset attributes.rate = 1></cfif>
						<cfif not isdefined('attributes.money')><cfset attributes.money = SESSION.EP.MONEY></cfif>
						<input type="hidden" name="old_money" id="old_money" value="<cfoutput>#attributes.money#</cfoutput>">
					</div>
                </div>
				<div class="form-group">
					<button name="btncevir" type="submit" class="btn btn-success">Çevir</button>
                    <cf_workcube_file_action pdf='0' mail='0' doc='0' print='0'>
                </div>
				<div class="form-group x-2">
					<a href="javascript://"	onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&iid=#req_id#&print_type=#72#<cfif isdefined('attributes.money')>&iiid=#attributes.money#</cfif></cfoutput>','page')"><i class="icon-print"></i></a>
				</div>
            </div>
		</cf_big_list_search_area>
		</cf_big_list_search>
		</cfform>
	</div>
</div>
<cfform name="upd_form" method="post" action="#request.self#?fuseaction=textile.list_sample_request&event=config">

	<div class="row">
		<div class="col col-12">
				<cf_grid_list>
					<thead>
						<tr>
						<input type="hidden" name="money" value="<cfoutput>#attributes.money#</cfoutput>">
						<input type="hidden" name="req_id" value="<cfoutput>#attributes.req_id#</cfoutput>">
						<input type="hidden" name="record_num" value="<cfoutput>#get_detail.recordcount#</cfoutput>">
							<th class="drag-enable">SN<span class="table-handle"><i class="fa fa-sort"></i></span></th>
							<th>Ürün</th>
							<th>Hammaddeler</th>
							<th>Miktar</th>	
							<th><font color="red">Rev. Miktar</th>
							<th>Birim</th>
							<th>Birim Fiyat</th>
							<th>Para Birimi</th>
							<th><font color="red">Rev. Birim Fiyat</th>
							<th>Para Birimi</th>
							<th>Pln.Tutar TL</th>
							<th>Rev. TL Tutar</th>
							<th>Pln.Döviz Tutar</th>
							<th>Rev.Döviz Tutar</th>
						</tr>
					</thead>
					<tbody>
					<cfset ptt = 0>
					<cfset rtt = 0>
					<cfset pdt = 0>
					<cfset rdt = 0>
					<cfoutput query="get_detail">
						<tr>
							<td>#currentrow#</td>
							<td text-wrap:suppress;>#PRODUCT_NAME#</td>
							<td text-wrap:suppress;>#REQUEST_COMPANY_STOCK#</td>
							<td text-wrap:suppress; style="text-align:right;">#tlformat(QUANTITY,textile_round)#
								<input type="hidden" name="row_id#currentrow#" value="#id#">
								<input type="hidden" name="type#currentrow#" value="#type#">
							</td>
							<td text-wrap:suppress; style="text-align:right;">
								<input type = "text" id="r_q#currentrow#" name ="r_q#currentrow#" onblur="satirhesapla('#currentrow#', '#MONEY_TYPE#')", value = "#tlformat(REVIZE_QUANTITY,textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));" style="width: 100%; max-width: 60px;<cfif REVIZE_PRICE neq PRICE>background-color: red;color:white;</cfif>" class="box" >
							</td>
							<td text-wrap:suppress; style="text-align:center;">#UNIT#</td>
							<td text-wrap:suppress; style="text-align:right;">#tlformat(PRICE,textile_round)#</td>
							<td text-wrap:suppress; style="text-align:center;">#MONEY_TYPE#</td>
							<td text-wrap:suppress; style="text-align:right;">
								<input type = "text" id ="r_p#currentrow#" name ="r_p#currentrow#" onblur="satirhesapla('#currentrow#', '#MONEY_TYPE#')" value = "#tlformat(REVIZE_PRICE,textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));" style="width: 100%; max-width: 60px;<cfif REVIZE_PRICE neq PRICE>background-color: red;color:white;</cfif>" class="box">
							</td>
							<td text-wrap:suppress; style="text-align:center;">#MONEY_TYPE#</td>
							<td text-wrap:suppress; style="text-align:right;">
								<input type ="text" style="text-align:right;width: 80%; max-width: 60px;" id ="p_t#currentrow#" name ="p_t#currentrow#" value = "#tlformat(QUANTITY*PRICE*moneylist[MONEY_TYPE],textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));" readonly> TL
							</td>
							<td text-wrap:suppress; style="text-align:right;">
								<input type ="text" style="text-align:right;width: 100%; max-width: 60px;" id ="r_t#currentrow#" name ="r_t#currentrow#" value = "#tlformat(REVIZE_QUANTITY*REVIZE_PRICE*moneylist[MONEY_TYPE],textile_round)#" class="box" onkeyup="return(FormatCurrency(this,event,#textile_round#));" readonly>  TL
							</td>
							<td text-wrap:suppress; style="text-align:right;">
								<input type ="text" style="text-align:right;width: 100%; max-width: 60px;" id ="pd#currentrow#" name ="pd#currentrow#" value ="#tlformat((QUANTITY*PRICE*moneylist[MONEY_TYPE])/moneylist[attributes.money],textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));" readonly>&nbsp;#attributes.money#
							</td>
							<td text-wrap:suppress; style="text-align:right;">
								<input type ="text" style="text-align:right;width: 100%; max-width: 60px;" id ="rd#currentrow#" name ="rd#currentrow#" value ="#tlformat((REVIZE_QUANTITY*REVIZE_PRICE*moneylist[MONEY_TYPE])/moneylist[attributes.money],textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));" class="box" readonly>&nbsp;#attributes.money#
							</td>			
							<cfset ptt = ptt + (QUANTITY*PRICE*moneylist[MONEY_TYPE])>
							<cfset rtt = rtt + (REVIZE_QUANTITY*REVIZE_PRICE*moneylist[MONEY_TYPE])>
							<cfset rdt = rdt + (REVIZE_QUANTITY*REVIZE_PRICE*moneylist[MONEY_TYPE])/moneylist[attributes.money]>
						</tr>
					</cfoutput>
					<cfoutput>
						<tr style="font-weight: bold !important;">
							<td text-wrap:suppress; colspan="10" style="text-align: right">Toplam :</td>
							<td text-wrap:suppress; style="text-align:right;">
								<input  type="text" name="ptt" id="ptt" value="#tlformat(ptt,textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));" style="text-align:right;width: 80%; max-width: 60px;font-weight: bold !important;" > TL
							</td>
							<td text-wrap:suppress; style="text-align:right;">
								<input class="box" type="text" name="rtt" id="rtt" value="#tlformat(rtt,textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));" style="text-align:right;width: 80%; max-width: 60px;font-weight: bold !important;"> TL
							</td>
							<td text-wrap:suppress; style="text-align:right;">
								<input  type="text" name="pdt" id="pdt" value="#tlformat(pdt,textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));" style="text-align:right;width: 80%; max-width: 60px;font-weight: bold !important;"> #attributes.money#
							</td>
							<td text-wrap:suppress; style="text-align:right;">
								<input class="box" type="text" name="rdt" id="rdt" value="#tlformat(rdt,textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));" style="text-align:right;width: 80%; max-width: 60px;font-weight: bold !important;"> #attributes.money#
							</td>
						</tr>
					</cfoutput>
					</tbody>
				</cf_grid_list>
		</div>	
	</div>


	<div class="row">
		<div class="col col-12">

		<cf_grid_list>
			<thead>
				<tr>
					<th>Kurlar</th>
					<th>Fiyatlama</th>
					<th>Karlılık</th>
				</tr>
			</thead>
			<tbody>
				<tr valign="top">
					<td text-wrap:suppress; width="20%" height="100px">
						<cfinclude template="/WBP/Fashion/files/objects/display/dsp_money.cfm">
					</td>
					<cfoutput><cfset i="">
					<td text-wrap:suppress; width="40%">
						<cf_grid_list>
						<thead>
							<tr>
								<th>*</th>
								<th>Oran</th>
								<th>TL Tutar</th>
								<th>Döviz Tutar</th>
								<th>PB</th>
							</tr>
						</thead>
						<tbody>
							<tr >
							<cfset customer_fire_oran = {}>
							<cfquery name="query_customer_values" datasource="#dsn3#">
								SELECT * FROM TEXTILE_CUSTOMER_VALUES WHERE IS_ACTIVE = 1
							</cfquery>
							<cfloop query="query_customer_values">
								<cfset customer_fire_oran[query_customer_values.CUSTOMER_VALUE] = query_customer_values.GYG_RATE>
							</cfloop>
								<td>Gyg+İmalat Firesi (#GET_OPPORTUNITY.CUSTOMER_VALUE# / %#StructKeyExists(customer_fire_oran, GET_OPPORTUNITY.CUSTOMER_VALUE) ? customer_fire_oran[GET_OPPORTUNITY.CUSTOMER_VALUE] : 0#)</td>
								<td style="text-align:right;">%<input type = "text" style="text-align:right;" id = "gyg_oran" name = "gyg_oran" onblur="hesapla();" onkeyup="return(FormatCurrency(this,event,#textile_round#));" value = "#len(get_opportunity.gyg_fire)?get_opportunity.gyg_fire:(StructKeyExists(customer_fire_oran, GET_OPPORTUNITY.CUSTOMER_VALUE) ? customer_fire_oran[GET_OPPORTUNITY.CUSTOMER_VALUE] : 0)#" size="8px"></td>
								<td style="text-align:right;"><input type = "text" style="text-align:right;" id = "gyg_tutar" name = "gyg_tutar" value = "" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px" readonly></td>
								<td style="text-align:right;"><input type = "text" style="text-align:right;" id = "gyg_tutar_dv" name = "gyg_tutar_dv" value = "" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px" readonly></td>
								<td>#attributes.money#</td>
							</tr>
							<tr>
								<td>Toplam Maliyet</td>
								<td></td>
								<td style="text-align:right;"><input type = "text" style="text-align:right;" id = "t_maliyet" name = "t_maliyet" value = "" size="8px" readonly></td>
								<td style="text-align:right;"><input type = "text" style="text-align:right;" id = "t_maliyet_dv" name = "t_maliyet_dv" value = "" size="8px" readonly></td>
								<td>#attributes.money#</td>
							</tr>
							<tr>
								<cfquery name="query_commission_rate" datasource="#dsn3#">
									SELECT sum(ROW_PREMIUM_PERCENT) AS TOPLAMORAN FROM SALES_QUOTAS_ROW WHERE SUPPLIER_ID = #GET_OPPORTUNITY.COMPANY_ID#
								</cfquery>
								<td>Komisyon Oranı (%#query_commission_rate.TOPLAMORAN#)</td>
								<td style="text-align:right;">%<input type = "text" style="text-align:right;" id = "komisyon" name = "komisyon" onblur="hesapla();" value="#tlformat(len(get_opportunity.commission)?get_opportunity.commission:query_commission_rate.TOPLAMORAN, textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px"></td>
								<td style="text-align:right;"><input type = "text" style="text-align:right;" id = "komisyon_tutar_tl" name = "komisyon_tutar_tl" onkeyup="return(FormatCurrency(this,event,#textile_round#));" value = "" size="8px" readonly></td>
								<td style="text-align:right;"><input type = "text" style="text-align:right;" id = "komisyon_tutar_dv" name = "komisyon_tutar_dv" onkeyup="return(FormatCurrency(this,event,#textile_round#));" value = "" size="8px" readonly></td>
								<td>#attributes.money#</td>
							</tr>
							<tr>
								<td>Başa Baş Noktası</td>
								<!---<td style="text-align:right;"><input type = "text" class="box" id = "bb" name = "bb" value = "" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px"></td>--->
								<td ></td>
								<td style="text-align:right;"><input type = "text" class="box" style="text-align:right;" id = "bb_tl" name = "bb_tl" value = "" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px" readonly></td>
								<td style="text-align:right;"><input type = "text" class="box" style="text-align:right;" id = "bb_dv" name = "bb_dv" value = "" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px" readonly></td>
								<td >#attributes.money#</td>
							</tr>
							<tr>
								<td> <font color="red">Satış Fiyatı</td>
								<td style="text-align:right;">Kar %<input type = "text" id = "kar" name = "kar" value = "" style="text-align:right;" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px" readonly></td>
								<td style="text-align:right;"><input type = "text" class="box" id = "sft_tl" name = "sft_tl" style="text-align:right;" onblur="hesapla();" value = "" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px" readonly></td>
								<td style="text-align:right;"><input type = "text" class="box" id = "sft_dv" name = "sft_dv" style="text-align:right;" onblur="hesapla();" value = "#tlformat(get_opportunity.config_price_other,textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px"></td>
								<td> <font color="red">#attributes.money#</td>
							</tr>
							<!----
							<tr>
								<td>Kar</td>
								<td style="text-align:right;"><input type = "text" class="box" id = "kar" name = "kar" value = "" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px"></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>					
							--->
							</tbody>
						</cf_grid_list>
					</td>
					</cfoutput>
					<td text-wrap:suppress; width="40%">
						<cf_grid_list>
							<thead>
								<tr>
									<th class="header">Kar%</th>
									<th class="header">Kar Tutarı</th>
									<th class="header">Komisyon</th>
									<th class="header">Satış Fiyatı</th>
									<th class="header">PB</th>
								</tr>		
							</thead>
							<tbody>
							<cfoutput>
								<cfloop from="5" to="50" index="i" Step="5">
									<tr>
										<td>#i#</td>
										<td><input type = "text"  id = "kar_tutar#i#" name = "kar_tutar#i#" value = "" style="text-align:right;" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px" readonly></td>
										<td><input type = "text"  id = "komisyon#i#" name = "komisyon#i#" value = "" style="text-align:right;" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px" readonly></td>
										<td><input type = "text"  id = "stf_dv#i#" name = "stf_dv#i#" value = "" style="text-align:right;" onkeyup="return(FormatCurrency(this,event,#textile_round#));" size="8px" readonly></td>
										<td>#attributes.money#</td>
									</tr>
								</cfloop>
							</cfoutput>	
							</tbody>
						</cf_grid_list>
					</td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="4" style="text-align:right;">
									Rapor Durumu :
									<select name="status" id="status">
											<option value="0" <cfif get_opportunity.CONFIG_STATUS neq 1>selected</cfif>>Planlama</option>
											<option value="1" <cfif get_opportunity.CONFIG_STATUS eq 1>selected</cfif>>Tamamlandı</option>
									</select> <cf_workcube_buttons is_upd='0'></td>
				</tr>
			</tfoot>
		</cf_grid_list>
		

		</div>
	</div>
</cfform>

</br>



<cfset kurlar = {}>
<script>
	<cfoutput query="get_money_bskt">
	window.#MONEY_TYPE# = #RATE2#;
	</cfoutput>
</script>



<script>
	var rowcount='<cfoutput>#get_detail.recordcount#</cfoutput>';
	var textile_round='<cfoutput>#textile_round#</cfoutput>';
	toplam_hesapla();
		hesapla();
	function satirhesapla(no, kur)
	{
		revize_miktar=document.getElementById('r_q'+no).value;
		
		revize_fiyat=document.getElementById('r_p'+no).value;
		
		if(revize_miktar.length=='')
		revize_miktar=0;
		if(revize_fiyat.length=='')
		revize_fiyat=0;
		
	
		var revize_tutar_tl=parseFloat(filterNum(revize_miktar,textile_round))*parseFloat(filterNum(revize_fiyat,textile_round))*window[kur];
		
		document.getElementById('r_t'+no).value=commaSplit(revize_tutar_tl,textile_round);
		
		p_satirhesapla(no, kur);
		r_satirhesapla(no, kur);
		toplam_hesapla();
		hesapla();
	
	}
	function toplam_hesapla()
	{
		var toplam_planlanan_tutar_tl=0;
		var toplam_revize_tutar_tl=0;
		
		var toplam_planlanan_tutar_dv=0;
		var toplam_revize_tutar_dv=0;
		for(var i=1;i<=rowcount;i++)
		{
			planlanan_tutar_tl=document.getElementById('p_t'+i).value;	
			revize_tutar_tl=document.getElementById('r_t'+i).value;	
				
			planlanan_tutar_dv=document.getElementById('pd'+i).value;	
			revize_tutar_dv=document.getElementById('rd'+i).value;	
			
			if(planlanan_tutar_tl.length=='')
				planlanan_tutar_tl=0;
			if(revize_tutar_tl.length=='')
				revize_tutar_tl=0;
			if(planlanan_tutar_dv.length=='')
				planlanan_tutar_dv=0;
			if(revize_tutar_dv.length=='')
				revize_tutar_dv=0;
			
			toplam_planlanan_tutar_tl=parseFloat(toplam_planlanan_tutar_tl)+parseFloat(filterNum(planlanan_tutar_tl,textile_round));
			toplam_revize_tutar_tl=parseFloat(toplam_revize_tutar_tl)+parseFloat(filterNum(revize_tutar_tl,textile_round));
			
			toplam_planlanan_tutar_dv=parseFloat(toplam_planlanan_tutar_dv)+parseFloat(filterNum(planlanan_tutar_dv,textile_round));
			toplam_revize_tutar_dv=parseFloat(toplam_revize_tutar_dv)+parseFloat(filterNum(revize_tutar_dv,textile_round));
		}
	
		document.getElementById('ptt').value=commaSplit(toplam_planlanan_tutar_tl,textile_round);
		document.getElementById('rtt').value=commaSplit(toplam_revize_tutar_tl,textile_round);
			
		document.getElementById('pdt').value=commaSplit(toplam_planlanan_tutar_dv,textile_round);
		document.getElementById('rdt').value=commaSplit(toplam_revize_tutar_dv,textile_round);
		
	}

	function get_currency()
	{
	for(i=1;i<=no;i++)
		{
			pd=document.getElementById('p_t'+i).value;
			
			if(pd.length=='')
			pd=0;
			
			var money;
			money=document.getElementById('money').value;
			
			
			pd=parseFloat(pd)/window[money];

			document.getElementById('pd'+no).value=pd;
		}
	}
	
	var rowcount='<cfoutput>#get_detail.recordcount#</cfoutput>';
	function p_satirhesapla(no, kur)
	{
		planlanan_tutar_tl=document.getElementById('p_t'+no).value;
		
		if(planlanan_tutar_tl.length=='')
		planlanan_tutar_tl=0;
		var money;
		money=document.getElementById('money').value;
		planlanan_tutar_doviz=parseFloat(filterNum(planlanan_tutar_tl,textile_round))/window[money];
		document.getElementById('pd'+no).value=commaSplit(planlanan_tutar_doviz,textile_round);
	}
	function r_satirhesapla(no, kur)
	{
		revize_tutar_tl=document.getElementById('r_t'+no).value;
		if(revize_tutar_tl.length=='')
		revize_tutar_tl=0;
		var money;
		money=document.getElementById('money').value;
	
		revize_tutar_doviz=parseFloat(filterNum(revize_tutar_tl,textile_round))/window[money];
		
		document.getElementById('rd'+no).value=commaSplit(revize_tutar_doviz,textile_round);
			
		
	}
	function hesapla()
	{
		var revize_tutar_tl=document.getElementById('rtt').value;
		if(revize_tutar_tl=='')
		revize_tutar_tl=0;
		else
		revize_tutar_tl=filterNum(revize_tutar_tl,textile_round);
		
		var gyg_oran=document.getElementById('gyg_oran').value;
		if(gyg_oran=='')
		gyg_oran=0;
		else
		gyg_oran=filterNum(gyg_oran);
		
		
		gyg_tutar=parseFloat(revize_tutar_tl)*parseFloat(gyg_oran)/100;
		document.getElementById('gyg_tutar').value=commaSplit(gyg_tutar,textile_round);
		
		t_maliyet=parseFloat(revize_tutar_tl)+parseFloat(gyg_tutar);
		document.getElementById('t_maliyet').value=commaSplit(t_maliyet,textile_round);
		var money;
		money=document.getElementById('money').value;
		
		gyg_tutar_dv=parseFloat(gyg_tutar)/window[money];
		document.getElementById('gyg_tutar_dv').value=commaSplit(gyg_tutar_dv,textile_round);
		
		t_maliyet_dv=parseFloat(t_maliyet)/window[money];
		document.getElementById('t_maliyet_dv').value=commaSplit(t_maliyet_dv,textile_round);
		
		komisyon_oran=document.getElementById('komisyon').value;
		if(komisyon_oran=='')
		komisyon_oran=0;
		else
		komisyon_oran=filterNum(komisyon_oran);
		
		bb=parseFloat(t_maliyet)/parseFloat(1-(parseFloat(komisyon_oran)/parseFloat(100)));
		
		bb_dv=parseFloat(bb)/window[money];

		komisyon_tutar_tl=parseFloat(bb)-parseFloat(t_maliyet);
		komisyon_tutar_dv=parseFloat(komisyon_tutar_tl)/window[money];
		document.getElementById('komisyon_tutar_tl').value=commaSplit(komisyon_tutar_tl,textile_round);
		document.getElementById('komisyon_tutar_dv').value=commaSplit(komisyon_tutar_dv,textile_round);
		document.getElementById('bb_tl').value=commaSplit(bb,textile_round);
		document.getElementById('bb_dv').value=commaSplit(bb_dv,textile_round);
		
		sft_tl=document.getElementById('sft_tl').value;
		sft_dv=document.getElementById('sft_dv').value;
		if(sft_tl=='')
		sft_tl=0
		if(sft_dv=='')
		sft_dv=0
		else
		sft_dv=filterNum(sft_dv);
		
		sft_tl=parseFloat(sft_dv)*parseFloat(window[money]);
		
		document.getElementById('sft_tl').value=commaSplit(sft_tl,textile_round);
		
		
		
		var kar=(parseFloat(sft_dv)-parseFloat(t_maliyet_dv)-(parseFloat(sft_dv)*(parseFloat(komisyon_oran)/parseFloat(100))))/parseFloat(t_maliyet_dv);
		
		
		document.getElementById('kar').value=commaSplit(kar*100,textile_round);
		
		
		for(var i=5;i<=50;i+=5)
		{
		  dv_stf=parseFloat(bb_dv)*(parseFloat(1)+(parseFloat(i)/parseFloat(100)));
		
		  document.getElementById('stf_dv'+i).value=commaSplit(dv_stf,textile_round);
		  dv_komisyon=parseFloat(dv_stf)*(parseFloat(komisyon_oran)/parseFloat(100));
		  document.getElementById('komisyon'+i).value=commaSplit(dv_komisyon,textile_round);
		  
		  dv_kar=parseFloat(dv_stf)-parseFloat(dv_komisyon)-parseFloat(t_maliyet_dv);
		  
		  document.getElementById("kar_tutar"+i).value=commaSplit(dv_kar,textile_round);
		}
		
	}
</script>
