<cfinclude template="../../rules/display/rule_menu.cfm">

<div class="blog">
<div id="hr_content">

<div class="col col-12 col-xs-12">
	<div class="blog_title"><cfoutput>#getLang('dev',214)#</cfoutput></div>
</div>	

<cfif not listfindnocase(denied_pages,'myhome.list_purchasedemand')>
<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
	<div class="hr_box">
		<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_purchasedemand" target="blank_">
			<div class="circleBox color-D">
				<i class="fa fa-shopping-cart"></i>
			</div>
			<div class="circleIconTitle">
				<cf_get_lang dictionary_id='33263.Satınalma Talepleri'>
			</div>
		</a>
	</div>
</div>
</cfif>

<cfif not listfindnocase(denied_pages,'myhome.list_purchasedemand')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_internaldemand" target="blank_">
				<div class="circleBox color-M">
					<i class="fa fa-list-alt"></i>
				</div>
				<div class="circleIconTitle">
					<cf_get_lang dictionary_id='30782.İç Talepler'>
				</div>
			</a>
		</div>
	</div>
</cfif>

<cfif not listfindnocase(denied_pages,'correspondence.list_payment_actions_demand')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.list_payment_actions_demand&act_type=2&correspondence_info=1" target="blank_">
				<div class="circleBox color-E">
					<i class="fa fa-suitcase"></i>
				</div>
				<div class="circleIconTitle">
					<cf_get_lang dictionary_id='31427.Ödeme Talepleri'>
				</div>
			</a>
		</div>
	</div>
</cfif>

<cfif not listfindnocase(denied_pages,'correspondence.list_correspondence')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.list_correspondence" target="blank_">
				<div class="circleBox color-P">
					<i class="fa fa-pencil"></i>
				</div>
				<div class="circleIconTitle">
					<cf_get_lang dictionary_id='57459.Yazışmalar'>
				</div>
			</a>
		</div>
	</div>
</cfif>

<cfif not listfindnocase(denied_pages,'myhome.my_offtimes_approve')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_offtimes_approve" target="blank_">
				<div class="circleBox color-F">
					<i class="fa fa-braille"></i>
					<!---<span class="notification-count">2</span>--->
				</div>
				<div class="circleIconTitle">
					<cfoutput><cf_get_lang dictionary_id='58575.İzin'><cf_get_lang dictionary_id='30870.Onaylar'></cfoutput>
				</div>
			</a>
		</div>
	</div>
</cfif>

<cfif not listfindnocase(denied_pages,'myhome.extra_times_approve')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.extra_times_approve" target="blank_">
				<div class="circleBox color-G">
					<i class="fa fa-clock-o"></i>
				</div>
				<div class="circleIconTitle">
					<cfoutput><cf_get_lang dictionary_id='38224.Fazla Mesai'><cf_get_lang dictionary_id='30870.Onaylar'></cfoutput>
				</div>
			</a>
		</div>
	</div>
</cfif>

<!--- <cfif not listfindnocase(denied_pages,'myhome.my_offtimes_approve')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_offtimes_approve&event=cancelList" target="blank_">
				<div class="circleBox color-LM">
					<i class="fa fa-times-circle"></i>
					<!---<span class="notification-count">2</span>--->
				</div>
				<div class="circleIconTitle">
					<cf_get_lang dictionary_id = "51691.Yıllık İzin İptal Talepleri">
				</div>
			</a> 
		</div>
	</div>
</cfif> --->

<cfif not listfindnocase(denied_pages,'myhome.my_assign_targets')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_assign_targets" target="blank_">
				<div class="circleBox color-DE">
					<i class="fa fa-line-chart"></i>
				</div>
				<div class="circleIconTitle">
					<cf_get_lang dictionary_id='31147.Verdiğim Hedefler'>
				</div>
			</a>
		</div>
	</div>
</cfif>

<cfif not listfindnocase(denied_pages,'myhome.list_detail_survey_approve')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_detail_survey_approve" target="blank_">
				<div class="circleBox color-RE">
					<i class="fa fa-comment"></i>
				</div>
				<div class="circleIconTitle">
					<cf_get_lang dictionary_id='29744.Değerlendirme Formları'>
				</div>
			</a>
		</div>
	</div>
</cfif>

<cfif not listfindnocase(denied_pages,'myhome.list_personel_requirement_form')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_personel_requirement_form" target="blank_">
				<div class="circleBox color-PO">
					<i class="fa fa-user"></i>
				</div>
				<div class="circleIconTitle">
					<cfoutput>#getLang('hr',1029)#</cfoutput>
				</div>
			</a>
		</div>
	</div>
</cfif>

<cfif not listfindnocase(denied_pages,'myhome.payment_request_approve')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.payment_request_approve" target="blank_">
				<div class="circleBox color-A">
					<i class="fa fa-money"></i>
				</div>
				<div class="circleIconTitle">
					<cfoutput><cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='30870.Onaylar'></cfoutput>
				</div>
			</a>
		</div>
	</div>
</cfif>

<cfif not listfindnocase(denied_pages,'myhome.flexible_worktime_approve')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.flexible_worktime_approve" target="blank_">
				<div class="circleBox color-HR">
					<i class="fa fa-hourglass"></i>
				</div>
				<div class="circleIconTitle">
					<cf_get_lang dictionary_id='41800.Esnek çalışma'> <cf_get_lang dictionary_id='30870.Onaylar'>
				</div>
			</a>
		</div>
	</div>
</cfif>

<cfif not listfindnocase(denied_pages,'myhome.travel_demand_approve')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.travel_demand_approve" target="blank_">
				<div class="circleBox color-LM">
					<i class="fa fa-plane"></i>
				</div>
				<div class="circleIconTitle">
					<cf_get_lang dictionary_id='49729.Seyahat Talepleri'>
				</div>
			</a>
		</div>
	</div>
</cfif>

<cfif not listfindnocase(denied_pages,'myhome.budget_transfer_demand')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.budget_transfer_demand" target="blank_">
				<div class="circleBox color-Y">
					<i class="fa fa-random"></i>
				</div>
				<div class="circleIconTitle">
					<cf_get_lang dictionary_id="61325.Bütçe Aktarım Talebi">
				</div>
			</a>
		</div>
	</div>
</cfif>

<cfif not listfindnocase(denied_pages,'myhome.list_perform')>
	<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
		<div class="hr_box">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_perform" target="blank_">
				<div class="circleBox color-G">
					<i class="fa fa-list"></i>
				</div>
				<div class="circleIconTitle">
					<cf_get_lang dictionary_id='54360.Performance Assesment'>
				</div>
			</a>
		</div>
	</div>
</cfif>

</div>
</div>

