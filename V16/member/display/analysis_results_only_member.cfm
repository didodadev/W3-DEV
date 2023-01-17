<cfinclude template="../query/get_analysis.cfm">
<cfparam name="attributes.modal_id" default="">
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT IS_MULTI_ANALYSIS_RESULT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="get_member_analysis_term" datasource="#dsn#">
	SELECT TERM_ID, TERM FROM SETUP_MEMBER_ANALYSIS_TERM
</cfquery>
<cfif IsDefined("attributes.action_type_id")>
	<cfset action_type_id = attributes.action_type_id>
<cfelse>
	<cfset action_type_id = "">
</cfif>
<cfif IsDefined("attributes.action_type") and attributes.action_type eq 'OPPORTUNITY'>
	<cfset action_type = "OPPORTUNITY">
<cfelseif IsDefined("attributes.action_type") and attributes.action_type eq 'PROJECT'>
	<cfset action_type = "PROJECT">
<cfelse>
	<cfset action_type = "MEMBER">        
</cfif>
<cfif IsDefined("attributes.company_id") and len(attributes.company_id)>
    <cfquery name="Get_Company" datasource="#dsn#">
        SELECT NICKNAME,FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
    </cfquery>
    <cfset company_id = attributes.company_id>
    <cfif attributes.action_type eq 'PROJECT'>
    	<cfset fullname = Get_Company.Nickname>
    <cfelse>
	    <cfset fullname = Get_Company.Fullname>
    </cfif>
<cfelse>
	<cfset company_id = "">
	<cfset fullname = "">   
</cfif>
<cfif IsDefined("attributes.partner_id")>
	<cfset member_id = attributes.partner_id>
    <cfset member_type = attributes.member_type>
	<cfset member_name = '#get_par_info(attributes.partner_id,0,-1,0)#'>
<cfelseif IsDefined("attributes.consumer_id")>
	<cfset member_id = attributes.consumer_id>
    <cfset member_type = attributes.member_type>
	<cfset member_name = '#get_cons_info(attributes.consumer_id,0,0,0)#'>
<cfelse>
	<cfset member_id = "">
    <cfset member_type = "">
	<cfset member_name = "">    
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="57560.Analiz"></cfsavecontent>
<cfset pageHead = "#message# : #get_analysis.analysis_head#">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="analysis_modal">
	<cf_box title="#pageHead#" closable="0"  collapsable="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="analysis_result" id="analysis_result" method="post" action="">
			<cf_box_elements vertical="1">
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-member">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29780.Katılımcı'> *</label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#company_id#</cfoutput>">					
								<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#member_id#</cfoutput>">
								<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#member_type#</cfoutput>">					
								<input type="text" name="member_name" id="member_name" value="<cfoutput>#member_name#<cfif len(member_name)>-</cfif>#fullname#</cfoutput>" readonly="yes" message="#message#" style="width:120px;">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=7,8&field_id=analysis_result.member_id&field_name=analysis_result.member_name&field_type=analysis_result.member_type&field_comp_id=analysis_result.company_id&analysis_id=#attributes.analysis_id#</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-attendance_date">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="59871.Katılım Tarihi"></label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="59871.Katılım Tarihi"></cfsavecontent>
								<cfinput type="text" name="attendance_date" id="attendance_date" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat('#now()#',dateformat_style)#">							
								<span class="input-group-addon"><cf_wrk_date_image date_field="attendance_date"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_wrk_search_button value="#getLang('','Oluştur','58966')#" button_type="5"  search_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
	<div ></div>
</div>
<script type="text/javascript">
function kontrol()
{
	if(document.analysis_result.member_name.value=="")
	{
		alert("<cf_get_lang dictionary_id='57785.Üye Secmelisiniz'> !");
		return false;
	}

	if(document.analysis_result.member_type.value=='partner')
	{
		url_type = '<cfoutput>action_type=#action_type#&action_type_id=#action_type_id#&analysis_id=#attributes.analysis_id#&member_type=partner&company_id=</cfoutput>'+document.analysis_result.company_id.value+'&partner_id='+document.analysis_result.member_id.value;
		//var GET_COMPANYCAT=wrk_safe_query('mr_get_companycat','dsn',0,document.analysis_result.company_id.value);
		var GET_COMPANYCAT = wrk_query("SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = "+document.getElementById('company_id').value,"dsn");
		if(list_find('<cfoutput>#get_analysis.analysis_partners#</cfoutput>',GET_COMPANYCAT.COMPANYCAT_ID) ==0)
		{
			alert("<cf_get_lang dictionary_id ='30235.İlgili Müşterinin Kategorisi Bu Analiz İçin Uygun Değildir'>")
			return false;	
		}
		<cfif get_our_company_info.is_multi_analysis_result eq 0>
			var listParam = "<cfoutput>#attributes.analysis_id#</cfoutput>" + "*" + document.analysis_result.member_id.value; 
			var GET_RESULTS=wrk_safe_query("mr_GET_RESULTS","dsn",0,listParam);
			if(GET_RESULTS.recordcount > 0)
			{
				alert("<cf_get_lang dictionary_id ='30240.İlgili Üye Bu Analize Sonuç Girmiştir'>");
				return false;
			}
		</cfif>
	}
	else
	{
		url_type = '<cfoutput>action_type=#action_type#&action_type_id#action_type_id#=&analysis_id=#attributes.analysis_id#&member_type=consumer&consumer_id=</cfoutput>'+document.analysis_result.member_id.value;

		var GET_CONSUMERCAT=wrk_safe_query('mr_get_consumercat','dsn',0,document.analysis_result.member_id.value);
		if(list_find('<cfoutput>#get_analysis.analysis_consumers#</cfoutput>',GET_CONSUMERCAT.CONSUMER_CAT_ID) == 0)
		{
			alert("<cf_get_lang dictionary_id ='30235.İlgili Müşterinin Kategorisi Bu Analiz İçin Uygun Değildir'>")
			return false;	
		}
	}
	<cfif get_our_company_info.is_multi_analysis_result eq 0>
		var listParam = "<cfoutput>#attributes.analysis_id#</cfoutput>" + "*" + document.analysis_result.member_id.value;
		var GET_RESULTS=wrk_safe_query("mr_GET_RESULTS_2",'dsn',0,listParam);
		if(GET_RESULTS.recordcount > 0)
		{
			alert("<cf_get_lang dictionary_id ='30240.İlgili Üye Bu Analize Sonuç Girmiştir'>");
			return false;
		}
	</cfif>
	var url= '<cfoutput>#request.self#</cfoutput>?fuseaction=member.popup_add_member_analysis_result&draggable=<cfoutput>#iif(isdefined("attributes.draggable"),1,0)#</cfoutput>&'+url_type;
	$('#analysis_result').attr('action', url);
	loadPopupBox('analysis_result','<cfoutput>#attributes.modal_id#</cfoutput>');
	return false;
}
</script>
