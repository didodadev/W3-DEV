<cfparam name="attributes.keyword" default="">
<cfset class_id = attributes.class_id>
<cfquery name="training_groups" datasource="#dsn#">
	SELECT 
    	TCG.TRAIN_GROUP_ID,
        TCG.GROUP_HEAD,
        TCG.START_DATE,
        TCG.FINISH_DATE,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME
  	FROM 
    	TRAINING_CLASS_GROUPS TCG LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = TCG.GROUP_EMP
	<cfif isDefined("attributes.KEYWORD") and len(attributes.keyword)>
        WHERE GROUP_HEAD LIKE '%#attributes.keyword#%'
    </cfif> ORDER BY GROUP_HEAD
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#training_groups.recordcount#'>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('','Sınıflar',58049)#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="list_training_groups" method="post" action="#request.self#?fuseaction=training_management.popup_list_training_groups">
	<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>" />
		<div class="ui-form-list flex-list">
			<div class="form-group medium" id="item-keyword">
				<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button search_function="kontrol()">
			</div>
		</div>
	</cfform>
	<cf_flat_list>
		<thead>
			<tr>
				<th style="width:25px"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='32326.Sınıf'></th>
				<th><cf_get_lang dictionary_id='57501.Başlangıç'>-<cf_get_lang dictionary_id='57502.Bitiş'></th>
				<th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
			</tr>
		</thead>
		<tbody>
			<cfif training_groups.recordcount>
				<cfoutput query="training_groups" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td align="left">
							<input type="hidden" name="train_group_id" id="train_group_id" value="#TRAIN_GROUP_ID#">#currentrow#
						</td>
						<td height="2" nowrap="nowrap">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.list_class&event=addClassToTrainGroup&train_group_id=#TRAIN_GROUP_ID#&class_id=#attributes.class_id#')" class="tableyazi" style="width:200px;">#GROUP_HEAD#</a>
						</td>
						<td>#dateformat(start_date,dateformat_style)# - #dateformat(finish_date,dateformat_style)#</td>
						<td>#employee_name# #employee_surname#</td>
					</tr>
				  </cfoutput>
			<cfelse>
				<tr>
					<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
	<cf_box_footer>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.class_id)>
				<cfset url_str = "#url_str#&class_id=#attributes.class_id#">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cf_paging
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="training_management.popup_list_training_groups#url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box_footer>
</cf_box>
<script>
	function kontrol(){
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('list_training_groups' , '<cfoutput>#attributes.modal_id#</cfoutput>')
		</cfif>
	}
</script>
