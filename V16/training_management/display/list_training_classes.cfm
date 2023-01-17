<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.date1" default="#DateFormat(Now(),dateformat_style)#">
<cfif isdefined("attributes.date1") and len(attributes.date1)>
	<cf_date tarih='attributes.date1'>
</cfif>
<cfinclude template="../query/get_training_class.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_training_class.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.train_group_id") and len(attributes.train_group_id)>
	<cfset adres_temp = "#request.self#?fuseaction=training_management.popup_list_training_classes&train_group_id=#attributes.train_group_id#">
<cfelseif isdefined("attributes.announce_id") and len(attributes.announce_id)>
	<cfset adres_temp = "#request.self#?fuseaction=training_management.popup_list_training_classes&announce_id=#attributes.announce_id#">
</cfif>
<div class="col col-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Dersler',58063)#">
		<cfform name="list_training" method="post" action="#adres_temp#">
			<div class="ui-form-list flex-list">
				<div class="form-group medium">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="Filtre">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfset attributes.date1=dateformat(attributes.date1,dateformat_style)>
						<cfinput name="date1" type="text" value="#attributes.date1#" required="yes" message="Tarih Girmelisiniz !">
						<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</div>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='46015.Ders'></th>
					<th><cf_get_lang dictionary_id='30935.Eğitimci'></th>
					<th><cf_get_lang dictionary_id='31296.Yer'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_training_class.recordcount>
					<cfparam name="attributes.page" default=1>
					<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
					<cfparam name="attributes.totalrecords" default=#get_training_class.recordcount#>
					<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
					<cfoutput query="get_training_class" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<cfif isdefined("attributes.train_group_id") and len(attributes.train_group_id)>
								<cfset my_adres = "train_group_id=#attributes.train_group_id#">
							<cfelseif isdefined("attributes.announce_id") and len(attributes.announce_id)>
								<cfset my_adres = "announce_id=#attributes.announce_id#">
							</cfif>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=training_management.emptypopup_add_class_to_group&#my_adres#&class_id=#CLASS_ID#" class="tableyazi">#class_name#</a></td>
							<td>
							<cfscript>
								get_trainers = createObject("component","V16.training_management.cfc.get_class_trainers");
								get_trainers.dsn = dsn;
								get_trainer_names = get_trainers.get_class_trainers
								(
									module_name : fusebox.circuit,
									class_id : class_id
								);
							</cfscript>
								<cfloop query="get_trainer_names">
									#get_trainer_names.trainer#<cfif get_trainer_names.recordcount neq currentrow>, <br></cfif>
								</cfloop>
							</td>
							<td>
								<cfif online eq 1>
									#class_place# - <a href="#class_place_address#">#class_place_address#</a>
								<cfelse>
									#class_place#
								</cfif>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
						<tr>
							<td colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
						</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfset url_str = "">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.date1)>
			<cfset url_str = "#url_str#&date1=#attributes.date1#">					  
		</cfif>
		<cfif isdefined("attributes.train_group_id") and len(attributes.train_group_id)>
			<cfset url_str = "#url_str#&train_group_id=#attributes.train_group_id#">
		<cfelseif isdefined("attributes.announce_id") and len(attributes.announce_id)>
			<cfset url_str = "#url_str#&announce_id=#attributes.announce_id#">
		</cfif>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="training_management.popup_list_training_classes#url_str#">
	</cf_box>
</div>