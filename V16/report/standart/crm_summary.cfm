<cfif not isdefined("attributes.startdate")><cfset attributes.startdate = ''><cfelse><cfset attributes.startdate = dateformat(attributes.startdate,dateformat_style)></cfif>
<cfif not isdefined("attributes.finishdate")><cfset attributes.finishdate = ''><cfelse><cfset attributes.finishdate = dateformat(attributes.finishdate,dateformat_style)></cfif>
<script src="JS/Chart.min.js"></script>
<div class="row">
	<cfform name="list_crm_dashboard" action="">
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='59036.CRM Dashboards'></cfsavecontent>
			<cf_box title="#head#">
				<cf_box_search>
					<div class="form-group" id="item-status">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
							<input type="text" name="startdate" id="startdate" value="<cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput>" message="<cfoutput>#message#</cfoutput>" validate="<cfoutput>#validate_style#</cfoutput>" placeholder="<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>">
							<span class="input-group-addon"> <cf_wrk_date_image date_field="startdate"> </span>
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
							<input type="text" name="finishdate" id="finishdate" value="<cfoutput>#dateformat(attributes.finishdate,dateformat_style)#</cfoutput>"  validate="<cfoutput>#validate_style#</cfoutput>" maxlength="10" message="<cfoutput>#message#</cfoutput>" placeholder="<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>">
							<span class="input-group-addon"> <cf_wrk_date_image date_field="finishdate"> </span>
						</div>
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type='4' is_excel='0'>
					</div>
				</cf_box_search>
			</cf_box>	
		</div>	
	</cfform>
	<div id="crm">
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="message"><cf_get_lang dictionary_id='29954.Genel'> <cf_get_lang dictionary_id='38752.Tablo'>
			</cfsavecontent>
			<cf_box title="#message#" >
				<div id="general_summary" style="margin-top:29px;">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_general_summary&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','general_summary');
					</script>
				</div>
			</cf_box>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="message"><cf_get_lang dictionary_id='57457.Müşteri'> <cf_get_lang dictionary_id='29954.Genel'> <cf_get_lang dictionary_id='32796.Görünüm'>
			</cfsavecontent>
			<cf_box title="#message#" >	
				<div id="member_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_member_summary&member_type=1&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','member_summary');
					</script>
				</div>
			</cf_box>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="message"><cf_get_lang dictionary_id='49270.Etkileşim'></cfsavecontent>
			<cf_box title="#message#">
				<div id="help_summary" style="margin-top:29px;">
				<script type="text/javascript">
					AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_help_summary&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','help_summary');
				</script>
				</div>
			</cf_box>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="message"><cf_get_lang dictionary_id='57612.Fırsat'></cfsavecontent>
			<cf_box title="#message#" >
				<div id="opp_summary" >
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_opp_summary&opp_type=1&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','opp_summary');
					</script>
				</div>
			</cf_box>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="message"><cf_get_lang dictionary_id='57545.Teklif'></cfsavecontent>
			<cf_box title="#message#" >
				<div id="offer_summary" >
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_offer_summary&offer_type=1&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','offer_summary');
					</script>
				</div>
			</cf_box>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="message"><cf_get_lang dictionary_id='30039.Servis Başvuruları'></cfsavecontent>
			<cf_box title="#message#">
				<div id="service_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_service_summary&service_type=1&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','service_summary');
					</script>
				</div>
			</cf_box>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="message"><cf_get_lang dictionary_id='57415.Ajanda'> / <cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
			<cf_box title="#message#">
				<div id="event_summary" style="margin-top:29px;">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_event_summary&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','event_summary');
					</script>
				</div>
			</cf_box>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="message"><cf_get_lang dictionary_id='33222.Sektörler'> <cf_get_lang dictionary_id='58673.Müşteriler'></cfsavecontent>
			<cf_box title="#message#" >
				<div id="sector_member_summary" style="margin-top:29px;">
				<script type="text/javascript">
					AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_sector_member_summary&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','sector_member_summary');
				</script>
				</div>
			</cf_box>
		</div>
	</div>
</div>
		
			
	
