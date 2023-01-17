<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	netbook.dsn2 = dsn2;
	netbook.dsn3 = dsn3;
	get_integration_definitions = netbook.getIntegrationDefinitions();
</cfscript>
<cfquery name="get_last_netbook" datasource="#dsn2#">
	SELECT MAX(FINISH_DATE) LAST_NETBOOK_FINISH FROM NETBOOKS WHERE STATUS NOT IN (0,-1)
</cfquery>
<cfif get_last_netbook.recordcount and len(get_last_netbook.last_netbook_finish)>
	<cfset attributes.start_date = "#dateformat(dateAdd('d',1,get_last_netbook.last_netbook_finish),dateformat_style)#">
    <cfset attributes.finish_date = "#dateformat(dateAdd('d',1,get_last_netbook.last_netbook_finish),dateformat_style)#">
</cfif>
<cfquery name="get_acc_card_type" datasource="#dsn3#">
    SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
</cfquery>
<cfif get_integration_definitions.recordcount eq 0>
	<script language="javascript">
		alert("<cf_get_lang dictionary_id='57200.E-defter ile ilgili tanımlarınızı entegrasyon tanımlarından yapınız'>!");
		window.close();
	</script>
    <cfabort>
</cfif>
<cfparam name="attributes.start_date" default="01/01/#session.ep.period_year#">
<cfparam name="attributes.finish_date" default="01/01/#session.ep.period_year#">
<cfsavecontent variable="message"> <cf_get_lang dictionary_id="30802.E-Defter"> </cfsavecontent>
<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="create_netbook" method="post" action="#request.self#?fuseaction=account.emptypopup_create_netbook" >
    <cf_box_elements>
		<div class="col col-8 col-md-8 col-sm-8 col-xs-12"type="column" index="1" sort="true">
			<div class="form-group" id="item-start_date">
				<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>  
				<div class="col col-8 col-xs-12">
					<div class="col col-6 col-xs-12">
						<div class="input-group">
							<cfif get_last_netbook.recordcount gt 0 and len(get_last_netbook.LAST_NETBOOK_FINISH)>
								<cfinput type="text" name="start_date" id="start_date" value="#attributes.start_date#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#" readonly="yes">
							<cfelse>
								<cfinput type="text" name="start_date" id="start_date" value="#attributes.start_date#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>                
							</cfif>
						</div>
					</div>
					<div class="col col-6 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
							<cfinput type="text" name="finish_date" id="finish_date" value="#attributes.finish_date#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-coming_out">
				<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>  
				<div class="col col-8 col-xs-12">
					<select multiple="multiple" name="acc_card_type" id="acc_card_type">
						<cfoutput query="get_acc_card_type" group="process_type">
							<cfoutput>
							<option value="#process_type#-#process_cat_id#">#process_cat#</option>
							</cfoutput>
						</cfoutput>
                	</select>
				</div>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cfsavecontent variable="message"> <cf_get_lang dictionary_id="34234.E-Defter Oluştur"> </cfsavecontent>
    	<cf_workcube_buttons insert_info='#message#' type_format="1" is_upd='0' add_function='kontrol()'>
    </cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if ((document.getElementById('finish_date').value.length == 0 || document.getElementById('start_date').value.length == 0))
		{
			alert("<cf_get_lang dictionary_id='57213.Lütfen E-Defter Oluşturulacak Dönemi Seçiniz'>");
			return false;
		}
		else
		{
			d1 = document.getElementById('start_date').value;
			start_date = d1.substring(6,10)+d1.substring(3,5)+d1.substring(0,2);
			d2 = document.getElementById('finish_date').value;
			finish_date = d2.substring(6,10)+d2.substring(3,5)+d2.substring(0,2);

			var today = new Date();
			var dd = today.getDate();
			var mm = today.getMonth()+1;
			var yyyy = today.getFullYear();
			if(dd<10){dd='0'+dd}
			if(mm<10){mm='0'+mm}
			today_ = yyyy+''+mm+''+dd;

			if(start_date>finish_date)
			{
				alert("<cf_get_lang dictionary_id='57217.Başlangıç tarihi bitiş tarihinden sonra olamaz'>");
				return false;
			}
			if(finish_date>=today_)
			{
				alert("<cf_get_lang dictionary_id='57218.Bitiş tarihi bugün veya bugünden sonra olamaz'>!");
				return false;
			}
			if((d2.substring(3,5)-d1.substring(3,5)) >= 1)
			{
				alert("<cf_get_lang dictionary_id='57224.E-Defter verileri bir aylık periyodu geçemez'>");
				return false;
			}
		}
	}
</script>