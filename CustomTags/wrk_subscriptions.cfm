<!--- 
	Sistem(Abone) seçme custom tag i.İstenirse company-consumer gönderilerek gereken diğer alanlar da doldurulabilir.
 --->
<cfparam name="attributes.form_name" default='add_service'>
<cfset f_name = attributes.form_name>
<cfparam name="attributes.subscription_id" default=''>
<cfparam name="attributes.subscription_no" default=''>
<cfparam name="attributes.width_info" default='165'>
<cfparam name="attributes.img_info" default='plus_thin'>
<cfparam name="attributes.fieldId" default="subscription_id">
<cfparam name="attributes.fieldName" default="subscription_no">
<cfparam name="attributes.returnQueryValue" default=""><!--- queryden gönderilecek değerler..COMPANY_ID,FULLNAME,MEMBER_ID,MEMBER_NAME --->
<cfparam name="attributes.returnInputValue" default=""><!--- değer gönderilecek input isimleri..company_id,company_name,member_id,member_name --->
<cfparam name="attributes.is_upd" default="">
<cfparam name="attributes.call_function" default="">
<cfparam name="attributes.call_function_param" default="">
<cfparam name="attributes.isGetCounter" default="">
<cfscript>
	str_subscription_link="&field_id=#f_name#.subscription_id&field_no=#f_name#.subscription_no";
	if(ListFind(attributes.returnInputValue,'member_id',',') and isDefined("#f_name#.member_id"))
		str_subscription_link="#str_subscription_link#&field_member_id=#f_name#.member_id";
	if(ListFind(attributes.returnInputValue,'member_name',',') and isDefined("#f_name#.member_name"))
		str_subscription_link="#str_subscription_link#&field_member_name=#f_name#.member_name";
	if(ListFind(attributes.returnInputValue,'member_type',',') and isDefined("#f_name#.member_type"))
		str_subscription_link="#str_subscription_link#&field_member_type=#f_name#.member_type";
	if(ListFind(attributes.returnInputValue,'company_id',',') and isDefined("#f_name#.company_id"))
		str_subscription_link="#str_subscription_link#&field_company_id=#f_name#.company_id";
	if(ListFind(attributes.returnInputValue,'company_name',',') and isDefined("#f_name#.company_name"))
		str_subscription_link="#str_subscription_link#&field_company_name=#f_name#.company_name";
	if(ListFind(attributes.returnInputValue,'service_address',',') and isDefined("#f_name#.service_address"))
		str_subscription_link="#str_subscription_link#&field_ship_address=#f_name#.service_address";
	if(len(attributes.call_function))
		str_subscription_link="#str_subscription_link#&call_function=#attributes.call_function#";
	if(len(attributes.call_function_param))
		str_subscription_link="#str_subscription_link#&call_function_param=#attributes.call_function_param#";
		if(len(attributes.isGetCounter))
		str_subscription_link="#str_subscription_link#&isGetCounter=#attributes.isGetCounter#";
</cfscript>
<cfif len(attributes.subscription_id) and len(attributes.subscription_id)>
	<cfquery name="CT_GET_SUBS" datasource="#CALLER.DSN3#">
		SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#"> 
	</cfquery>
	<cfset attributes.subscription_no = ct_get_subs.subscription_no>
</cfif>
<cfoutput>
<cfif attributes.is_upd neq 1>
	<div class="input-group">
</cfif>
		<input type="text" style="display:none;" name="#attributes.fieldId#" id="#attributes.fieldId#" value="#attributes.subscription_id#">
		<input type="text" name="#attributes.fieldName#" id="#attributes.fieldName#" placeholder="<cf_get_lang_main no='1705.Sistem No'>" style="width:#attributes.width_info#px" value="<cfif isdefined("attributes.subscription_no") and len(attributes.subscription_no)>#attributes.subscription_no#</cfif>" onkeyup="compenentInputValueEmptying(this);" onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID<cfif len(attributes.returnQueryValue)>,#attributes.returnQueryValue#</cfif>','#attributes.fieldId#<cfif len(attributes.returnInputValue)>,#attributes.returnInputValue#</cfif>','','3','164'<cfif len(attributes.isGetCounter) and attributes.isGetCounter eq 1>,true,'getCounterType()'</cfif>);" autocomplete="off" <cfif attributes.is_upd eq 1>readonly="readonly"</cfif>>
		<cfif attributes.is_upd neq 1>
			<span class="input-group-addon btnPointer icon-ellipsis"  onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_subscription&#str_subscription_link#');">			
			</span>
		</cfif>
<cfif attributes.is_upd neq 1>		
	</div>
</cfif>    
</cfoutput>
<script type="text/javascript">
	function compenentInputValueEmptying(object_)
	{
		var keyword_ = object_.value;
		if(keyword_.length == 0)
			document.getElementById('<cfoutput>#attributes.fieldId#</cfoutput>').value ='';
	}
</script>