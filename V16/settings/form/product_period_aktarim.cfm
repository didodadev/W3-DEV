<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
		COMP_ID, 
		COMPANY_NAME
	FROM 
		OUR_COMPANY 
</cfquery>
<cfif not isdefined("attributes.hedef_period")>
	<cfsavecontent variable = "title">
		<cf_get_lang no='1553.Ürün Dönemi Aktarımı'>
	</cfsavecontent>
	<cf_box title="#title#">
		<div class="col col-12 col-xs-12">
				<form action="" method="post" name="form_">	
					<input type="hidden" name="form_submitted" id="form_submitted" value="1">
					<cf_box_elements>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-comp_name">
								<label class="col col-4 col-xs-12"><cf_get_lang  dictionary_id="43260.Hedef Dönem"></label>
								<div class="col col-8 col-xs-12">  
									<select name="item_company_id" id="item_company_id"  onchange="show_periods_departments(1)"> 
										<cfoutput query="get_companies">
											<option value="#comp_id#" <cfif isdefined("attributes.item_company_id") and attributes.item_company_id eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-period_div">
								<label class="col col-4 col-xs-12"><cf_get_lang   dictionary_id="39035.Dönem Seçiniz">
								</label>
								<div class="col col-8 col-xs-12"> 
									<select name="hedef_period_1" id="hedef_period_1" style="width:220px;">
										<cfif isdefined("attributes.item_company_id") and len(attributes.item_company_id)>
											<cfquery name="get_periods" datasource="#dsn#">
												SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #attributes.item_company_id# ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
											</cfquery>
											<cfoutput query="get_periods">				
												<option value="#period_id#" <cfif isdefined("attributes.hedef_period_1") and attributes.hedef_period_1 eq period_id>selected</cfif>>#period#</option>						
											</cfoutput>
										</cfif>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="false">
							<div class="form-group"><div class="col col-8 col-xs-12"> 
								<label class="col col-12 bold"><td class="headbold" valign="top"><cf_get_lang dictionary_id="57433.Yardım"></label>
								<cftry>
									<cfinclude template="#file_web_path#templates/period_help/productPeriodTransfer_#session.ep.language#.html">
									<cfcatch>
										<script type="text/javascript">
											alert("<cf_get_lang dictionary_id  ="29760.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz">");
										</script>
									</cfcatch>
								</cftry>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<div class="col col-12 text-right ">
							<cfsavecontent variable="title"><cf_get_lang no ='2013.Dönem Aktar'></cfsavecontent>
							<cf_workcube_buttons extraButton="1"  extraButtonText="#title#"  extraFunction=" basamak_1()" update_status="0">
						</div>               
					</cf_box_footer>  
				</form>
		</div>
		<div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
			<cf_box>
				<div class="ui-cfmodal-close">×</div>
				<ul class="required_list"></ul>
				<div class="ui-form-list-btn">
					<div>
						<a href="javascript:void(0);"  onClick="cancel();" class="ui-btn ui-btn-delete"><cf_get_lang dictionary_id="58461.Reddet"></a>
					</div>
					<div>
						<input type="button" value="<cf_get_lang dictionary_id="44010.Aktarımı Başlat">" onClick="basamak_2();">		
					</div>
				</div>
			</cf_box>
		</div> 					     
	</cf_box>
</cfif>	
<cfif isdefined("attributes.hedef_period_1")>
	<cfquery name="get_hedef_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_period_1#">
	</cfquery>
	<cfquery name="get_kaynak_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.our_company_id#"> AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.period_year-1#"> 
	</cfquery>		
	<cfif not get_kaynak_period.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2030.Kaynak Period Bulunamadı! Önceki Dönemi Olmayan Bir Döneme Aktarım Yapılamaz'>");
			history.back();
		</script>
		<cfabort>
	</cfif>									
	<cflock name="#CREATEUUID()#" timeout="70">
		<cftransaction>
			<!--- once hedef perioddaki kayitlar mükerrer olmasin diye silinir --->
			<cfquery name="del_" datasource="#dsn#_#get_hedef_period.our_company_id#">
				DELETE FROM PRODUCT_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_period_1#">  AND PRODUCT_ID IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_kaynak_period.period_id#">)
			</cfquery>
			
			<!--- eski donemdeki bilgiler aktarilir --->
			<cfquery name="GET_COLUMN" datasource="#dsn#_#get_hedef_period.our_company_id#">
				SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '#dsn#_#get_hedef_period.our_company_id#' AND TABLE_NAME = 'PRODUCT_PERIOD' AND COLUMN_NAME NOT IN ('PERIOD_ID','PRODUCT_ACCOUNT_ID')
			</cfquery>

			<cfquery name="ADD_PRODUCT_PERIOD" datasource="#dsn#_#get_hedef_period.our_company_id#">
				INSERT INTO 
					PRODUCT_PERIOD 
				(
					PERIOD_ID,
				<cfoutput query="get_column">
					#get_column.column_name#<cfif get_column.currentrow neq get_column.recordcount>,</cfif>
				</cfoutput>			
				)
				SELECT 
					#attributes.hedef_period_1#,
				<cfoutput query="get_column">
					#get_column.column_name#<cfif get_column.currentrow neq get_column.recordcount>,</cfif>
				</cfoutput>					
				FROM 
					PRODUCT_PERIOD
				WHERE 
					PERIOD_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#get_kaynak_period.period_id#">
			</cfquery>
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2020.İşlem Başarıyla Tamamlanmıştır'>");
	</script>
</cfif>
<script type="text/javascript">
	function cancel() {
			$('.ui-cfmodal__alert').fadeOut();
			return false;
	}
	function basamak_1()
		{
			if($('#hedef_period_1').val() == ""){
				alert("<cf_get_lang dictionary_id ="44014.Hedef Period Seçmelisiniz">!");
				return false;
			}
			if($('#form_submitted').val())	{
				$('.ui-cfmodal__alert .required_list li').remove();
				$('.ui-cfmodal__alert .required_list').append('<li>Ürün Dönem Aktarım İşlemi Gerçekleştir</li>');	
				$('.ui-cfmodal__alert').fadeIn();
				return false;
			} 
			return true;
		}
		
	function basamak_2()
		{
		if(confirm("<cf_get_lang no ='2025.Dönem Aktarım İşlemi Yapacaksınız!!!Bu İşlem Geri Alınamaz!!!Emin misiniz'>"))
			document.form_.submit();
		else 
			return false;
		}
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.item_company_id") and len(attributes.item_company_id))>
			var company_id = document.getElementById('item_company_id').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
		</cfif>
	}
		)
	function show_periods_departments(number)
	{
		if(number == 1){
				var company_id = document.getElementById('item_company_id').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
			
		}
	}
</script>