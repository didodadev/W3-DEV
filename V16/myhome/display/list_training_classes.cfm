<script type="text/javascript">
function add_user(id,name)
{
	<cfif isdefined("attributes.field_name")>
		<cfif listlen(attributes.field_name,'.') eq 2>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
		</cfif>
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<cfif listlen(attributes.field_id,'.') eq 2>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
		</cfif>
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfset url_str = "">
<cfif isdefined("attributes.class_name")>
	<cfset url_str = "#url_str#&class_name=#attributes.class_name#">
</cfif>
<cfif isdefined("attributes.class_id")>
	<cfset url_str = "#url_str#&class_id=#class_id#">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset url_str = "#url_str#&is_form_submitted=#is_form_submitted#">
</cfif>
<cfif isdefined("attributes.train_group_id") and len(attributes.train_group_id)>
	<cfset url_str = "#url_str#&train_group_id=#attributes.train_group_id#">
<cfelseif isdefined("attributes.announce_id") and len(attributes.announce_id)>
	<cfset url_str = "#url_str#&announce_id=#attributes.announce_id#">
</cfif>
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.date1") and len(attributes.date1)>
	<cfset url_str = "#url_str#&date1=#attributes.date1#">					  
</cfif>
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">					  
</cfif>
<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">					  
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.date1" default="#DateFormat(Now(),dateformat_style)#">
<cfif isdefined("attributes.date1") and len(attributes.date1)>
	<cf_date tarih='attributes.date1'>
</cfif>
<cfinclude template="../query/get_training_class.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_training_class.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Eğitimler',29912)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="list_training" method="post" action="#request.self#?fuseaction=myhome.popup_list_training_classes#url_str#">
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<cf_box_search>
				<cfif isdefined("attributes.field_name")>
					<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
				</cfif>
				<cfif isdefined("attributes.field_id")>
					<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
				</cfif>
				<div class="form-group">
					<cfinput type="text" name="keyword" maxlength="50" placeholder="#getLang('','Filtre','57460')#" value="#attributes.keyword#">
				</div>
				<div class="form-group medium">
					<div class="input-group">
						<cfset attributes.date1=dateformat(attributes.date1,dateformat_style)>
						<cfinput name="date1" type="text" placeholder="#getLang('','Başlangıç Tarihi','58053')#" value="#attributes.date1#" required="yes" message="#getLang('','Lutfen Tarih Giriniz','58503')#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_training',#attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57419.Eğitim'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_training_class.recordcount and form_varmi eq 1>
					<cfparam name="attributes.page" default=1>
					<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
					<cfparam name="attributes.totalrecords" default=#get_training_class.recordcount#>
					<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
					<cfoutput query="get_training_class" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td><a href="javascript://" class="tableyazi"  onClick="add_user('#CLASS_ID#','#class_name#')">#class_name#</a></td>
							<td>#dateformat(start_date,dateformat_style)# - #dateformat(finish_date,dateformat_style)# </td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
			<div class="ui-info-bottom">
				<p><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif></p>
			</div>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.date1)>
				<cfset url_str = "#url_str#&date1=#attributes.date1#">					  
			</cfif>
			<cfset url_str = "">
			<cfif isdefined("attributes.class_name")>
				<cfset url_str = "#url_str#&class_name=#attributes.class_name#">
			</cfif>
			<cfif isdefined("attributes.class_id")>
				<cfset url_str = "#url_str#&class_id=#class_id#">
			</cfif>
			<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="myhome.popup_list_training_classes#url_str#"></td>
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
