<cfquery name="GET_MONEYS" datasource="#dsn#">
	SELECT MONEY_ID, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cf_box title="#getlang('','Alışveriş Kuponları','63931')#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_coupon_main" method="post"  action="#request.self#?fuseaction=product.emptypopup_add_coupon">
		<div class="col col-12">
					<cf_basket_form id="form_add_assetp">
							<cf_box_elements>
							<div class="col col-12 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item-is_active">
									<label class="col col-4">
										<cf_get_lang dictionary_id='57493.Aktif'>
									</label>
									<div class="col col-8">
										<input type="checkbox" name="is_active" id="is_active">
									</div>
								</div>
								<div class="form-group" id="item-start_date">
									<label class="col col-4">
										<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'>
									</label>
									<div class="col col-8">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="start_date" required="Yes" message="#message#" validate="#validate_style#" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></spcan>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-finish_date">
									<label class="col col-4">
										<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>
									</label>
									<div class="col col-8">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş tarihi Girmelisiniz'>!</cfsavecontent>
											<cfinput type="text" name="finish_date" required="Yes" message="#message#" validate="#validate_style#" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-coupon_name">
									<label class="col col-4">
										<cf_get_lang dictionary_id='37471.Kupon Adı'> *
									</label>
									<div class="col col-8">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='37471.Kupon Adı'></cfsavecontent>
										<cfinput type="text" name="coupon_name" value="" message="#message#" required="yes" maxlength="50">
									</div>
								</div>
								<div class="form-group" id="item-coupon_no">
									<label class="col col-4">
										<cf_get_lang dictionary_id='37470.Kupon No'>
									</label>
									<div class="col col-8">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.Hatali Veri'>:<cf_get_lang dictionary_id='37470.Kupon No'></cfsavecontent>
										<cfinput type="text" name="coupon_no" maxlength="20" message="#message#" validate="integer">
									</div>
								</div>
								<div class="form-group" id="item-barcod">
									<label class="col col-4">
										<cf_get_lang dictionary_id='57633.Barkod'>
									</label>
									<div class="col col-8">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57735.Dogru Barkod Girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="barcod" maxlength="20" message="#message#" validate="integer">
									</div>
								</div>
								<div class="form-group" id="item-coupon_type">
									<label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='63933.Kupon Tipi'></label> 
									<div class="col col-8 col-xs-8">
										<div class="col col-6 col-xs-6"><cf_get_lang dictionary_id='58560.İndirim'>%<input type="radio" onclick="indirim()"  name="coupon_type" id="coupon_type" value="1" checked></div>
										<div class="col col-6 col-xs-6"><cf_get_lang dictionary_id='57673.Tutar'><input type="radio" onclick="tutar()" name="coupon_type" id="coupon_type" value="2"></div>
									</div>
								</div>
								<div class="form-group" id="item-discount_rate">
									<label class="col col-4" id="discount"><cf_get_lang dictionary_id='63934.İndirim Oranı'>%</label> 
									<label class="col col-4" id="amount"><cf_get_lang dictionary_id='63935.Kupon Tutarı'></label> 
									<div class="col col-8 col-xs-8" id="discount_rate_row">
										<cfinput type="text" name="discount_rate" id="discount_rate" message="#message#">
									</div>
									<div class="col col-8 col-xs-8" id="coupon_amount_row">
										<div class="col col-10 col-xs-10">
										<cfinput type="text" name="coupon_amount" id="coupon_amount" message="#message#">
										</div><div class="col col-2 col-xs-2">
												<select name="currency" id="currency">
												<cfoutput query="get_moneys">
												<option value="#money#" >#money#</option>
												</cfoutput>
												</select>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-coupon_detail">
									<label class="col col-4">
										<cf_get_lang dictionary_id='57629.Açıklama'>
									</label>
									<div class="col col-8">
										<textarea name="coupon_detail" id="coupon_detail" value=""></textarea>
									</div>
								</div>
							</div>
					</cf_box_elements>
							<cf_box_footer><cf_workcube_buttons is_='0' add_function='check()'></cf_box_footer>
					</cf_basket_form>
			</div>
	</cfform>
</cf_box>


<script type="text/javascript">
		indirim();
		function tutar()
		{	
			document.getElementById("discount_rate_row").style.display="none";
			document.getElementById("discount").style.display="none";
			document.getElementById("amount").style.display="block";
			document.getElementById("coupon_amount_row").style.display="block";
			document.getElementById("discount_rate").value="";
		}
		function indirim()
		{	
			document.getElementById("discount_rate_row").style.display="block";
			document.getElementById("discount").style.display="block";
			document.getElementById("amount").style.display="none";
			document.getElementById("coupon_amount_row").style.display="none";
			document.getElementById('currency').getElementsByTagName('option')[0].selected = "selected";
			document.getElementById("coupon_amount").value="";
		}
	function kapa_refresh()
	{	
		y=(200-add_coupon_main.coupon_detail.value.length);
		if(y<0)
		{
			alert("<cf_get_lang dictionary_id='57629.Açıklama'> "+((-1)*y)+"<cf_get_lang dictionary_id='29538.Karakter Uzun'>");
			return false;
		}
		return true;
	}
</script>
