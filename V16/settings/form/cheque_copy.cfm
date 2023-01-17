<!--- KASA AKTARMLARI DÜZENLENİNCE KASA IDLERNDEN İŞLEM YAPILACAK, SENETTE BUNA GÖRE DÜZENLENECK --->
<cfquery name="get_periods" datasource="#dsn#">
	SELECT 
		SP.PERIOD_YEAR,
        SP.OUR_COMPANY_ID,
        SP.PERIOD_ID,
        SP.PERIOD,
		OC.COMPANY_NAME 
	FROM 
		SETUP_PERIOD SP,
		OUR_COMPANY OC
	WHERE
		SP.OUR_COMPANY_ID = OC.COMP_ID
	ORDER BY 
		SP.OUR_COMPANY_ID
</cfquery>
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfsavecontent variable = "title">
	<cf_get_lang dictionary_id='43572.Çek Dönem Aktarım'>
</cfsavecontent>
<div class="col col-12 col-xs-12">
	<cf_box title="#title#" >
		<cfform name="add_cheque_entry" action="#request.self#?fuseaction=settings.emptypopup_cheque_copy" method="post" >
			<cf_box_elements>	
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">

					<div class="form-group" id="item-kaynak_period_1">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43575.Hangi Şirketten'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<select name="kaynak_period_1" id="kaynak_period_1"  onchange="show_periods_departments(1)">
								<cfoutput query="get_companies">
									<option value="#comp_id#" <cfif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-hedef_period_1">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43576.Hangi Şirkete'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<select name="hedef_period_1" id="hedef_period_1" onchange="show_periods_departments(2)">
								<cfoutput query="get_companies">
								<option value="#comp_id#" <cfif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-is_cheque_voucher_based_action">
						<label class="col col-4 col-md-6 col-xs-12"></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<input type="checkbox" name="is_cheque_voucher_based_action" id="is_cheque_voucher_based_action" value="1"><cf_get_lang no ='2056.Satır Bazında Çek\Senetleri Carileştir'>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="form-group" id="item-from_cmp">
							<div class="col col-12 col-md-12 col-xs-12">
								<select name="from_cmp" id="from_cmp">
								</select>
							</div>
						</div>
						<div class="form-group" id="item-to_cmp">
							<div class="col col-12 col-md-12 col-xs-12">
								<select name="to_cmp" id="to_cmp" >
								</select>
							</div>
						</div>
					</div>
			    </div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div><b><cf_get_lang dictionary_id='57433.Yardım'></b></div>
						<cfset getImportExpFormat("chequeTransfersPeriod") />
						<div class="form-group" id="item">
							<label class="col col-12 col-md-12 col-xs-12">
							<b><cf_get_lang dictionary_id='58597.Önemli Uyarı'>!</b>
						</div>
						<div class="form-group" id="item">
							<label class="col col-12 col-md-12 col-xs-12">
							<b><cf_get_lang dictionary_id='43574.Çek dönem Aktarımı, Sadece Dönem Başı İşlemi Olarak Kullanılmalıdır'> !</b>
						</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>	
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

	
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('from_cmp').value == document.getElementById('to_cmp').value)
		{
			alert("Aynı Dönem İçerisinde Aktarım Yapılamaz !");
			return false;		
		}
		return true;
	}
	$(document).ready(function(){
			var company_id = document.getElementById('kaynak_period_1').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'from_cmp',1,'Dönemler');
		}
	)
	function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('kaynak_period_1').value != '')
			{
				var company_id = document.getElementById('kaynak_period_1').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'from_cmp',1,'Dönemler');
			}
		}
		else if(number == 2)
		{
			if(document.getElementById('hedef_period_1').value != '')
			{
				var company_id = document.getElementById('hedef_period_1').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'to_cmp',1,'Dönemler');
			}
		}
	}
	$(document).ready(function(){
			var company_id = document.getElementById('hedef_period_1').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'to_cmp',1,'Dönemler');
		}
	)
</script>
