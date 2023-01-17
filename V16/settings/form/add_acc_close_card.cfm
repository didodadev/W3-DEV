<cfquery name="get_period" datasource="#dsn#">
	SELECT PERIOD_ID, PERIOD FROM SETUP_PERIOD
</cfquery>
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfif not isdefined("attributes.hedef_period")>
	<cf_box title="#getLang('','Muhasebe Dönem Kapanış Fişi','44546')#">
		<cfform name="close_ch" method="post" action="#request.self#?fuseaction=settings.emptypopup_acc_close_card" enctype="multipart/form-data">
			<cf_box_elements>
				<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
					<div class="form-group" id="item-hedef_period_1">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52273.Muhasebe Dönemi'></label>            
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<select name="hedef_period_1" id="hedef_period_1"  onchange="show_periods_departments()">
									<option value=""><cf_get_lang dictionary_id='54096.Şirket Seçiniz'></option>
									<cfoutput query="get_companies">
										<option value="#comp_id#">#company_name#</option>
									</cfoutput>
								</select>
							</div>
							<div class="col col-4 col-md-6 col-sm-6 col-xs-12" id="period_div">
								<select name="acc_period" id="acc_period" >
								</select>
							</div>
						</div>    
					</div> 
			
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>            
						<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
							<cfquery name="get_acc_card_type" datasource="#dsn3#">
								SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14) ORDER BY PROCESS_TYPE
							</cfquery>
							<cf_multiselect_check
								name="acc_card_type"
								option_name="process_cat"
								option_value="process_cat_id"
								query_name="get_acc_card_type"
								width="200">
						</div>           
					</div>
			
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="47401.İşlem Dövizi Bazında"></label>
						<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
							<input type="checkbox" name="is_other_money" id="is_other_money" value="1">
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="39350.Şube Bazında"></label>
						<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
							<input type="checkbox" name="is_branch" id="is_branch" value="1">
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="47553.Departman Bazında"></label>
						<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
							<input type="checkbox" name="is_department" id="is_department" value="1">
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="29819.Proje Bazında"></label>
						<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
							<input type="checkbox" name="is_project" id="is_project" value="1">
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" >
					<div class="form-group">
						<label><b><cf_get_lang dictionary_id='57433.Yardım'></b></label>                
					</div>
					<div class="form-group">
						<cftry>
							<cf_get_lang dictionary_id='44547.Bu işlem seçtiğiniz muhasebe dönemi için otomatik kapanış fişi oluşturulmasını sağlar'>
							<!---Yardım Dosya yolu eklenecek--->
							<!---<cfinclude template="#file_web_path#templates/period_help/filename_#session.ep.language#.html">--->
							<cfcatch>
								<script type="text/javascript">
									alert("<cf_get_lang dictionary_id='29760.Help file not found! Please contact system admin.'>");
								</script>
							</cfcatch>
						</cftry>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function="kontrol()">
			</cf_box_footer>
		</cfform>
	</cf_box>
</cfif>
<script type="text/javascript">
	function kontrol()
	{
		if(document.close_ch.acc_period.value == '')
		{
			alert("<cf_get_lang dictionary_id='43274.Dönem Seçmelisiniz'>!");
			return false;
		}
		if (confirm("<cf_get_lang dictionary_id='44927.Seçtiğiniz Dönem İçin Otomatik Kapanış Fişi Oluşturulacaktır. Onaylıyor musunuz'>?")) 
			return true; 
		else 
			return false;
	}
	/* $(document).ready(function(){
		var company_id = document.getElementById('item_company_id').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
		AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
	}); */
	function show_periods_departments()
	{
		if(document.getElementById('hedef_period_1').value != '')
		{
			var company_id = document.getElementById('hedef_period_1').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'acc_period',1,'Dönemler');
		}else document.getElementById('acc_period').innerHTML = "<option value=''><cf_get_lang dictionary_id='39035.Dönem Seçiniz'></option>";
	}
</script>