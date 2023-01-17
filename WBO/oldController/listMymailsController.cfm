<cfset url_str = "">
<cfparam name="attributes.employee_id" default='#session.ep.userid#'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)> 
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif> 

<cfinclude template="../correspondence/query/get_emp_mails.cfm">
<cfparam name="attributes.page" default=1>						
<cfparam name="attributes.totalrecords" default="#EMP_MAIL_LIST.recordcount#">

<cfquery name="get_signature" datasource="#DSN#">
	SELECT * FROM CUBE_MAIL_SIGNATURE WHERE EMPLOYEE_ID = #attributes.employee_id#
</cfquery>

<cfinclude template="../correspondence/query/get_folders.cfm">
<cfquery name="get_rules" datasource="#DSN#">
	SELECT * FROM CUBE_MAIL_RULES WHERE EMPLOYEE_ID = #attributes.employee_id#
</cfquery>

<cfquery name="get_main_rules" datasource="#DSN#">
	SELECT * FROM CUBE_MAIL_MAIN_RULES
</cfquery>

<script type="text/javascript">
	var elementPosition = function (e, w) {
		
			var left = $(e).offset().left;
			var top = $(e).offset().top;
			var windowWidth =$(window).width();
			var divWidth = 0;
			
			if ( left > windowWidth /2 )  divWidth = w;
		
			return [{'left':left,'top': top,'divWidth':divWidth}];
		
		} // elementPosition

	function open_add_mail_(employeeId,e){
		
		var div = $('#add_mail_addres_')
		var w = 400 ;
		var size =  elementPosition (e,w);
		
		div.css({ 'top' : size[0].top , 'left': size[0].left - size[0].divWidth})
		
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_add_new_mail&employee_id='+employeeId,'add_mail_addres_','1');
	}
	
	function open_update_mailbox(mailbox_id,employeeId,e) { 
		var div = $('#add_mail_addres_')
		var w = 400 ;
		var size =  elementPosition (e,w);
		
		div.css({ 'top' : size[0].top , 'left': size[0].left - size[0].divWidth})
		AjaxPageLoad( '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_mail_settings&mailbox_id='+mailbox_id+'&employee_id='+employeeId,'add_mail_addres_','1');
	}
	
	function open_add_mail_rule_(employeeId, e) {
		
		var div = $('#add_mail_rule_')
		var w = 300 ;
		var size =  elementPosition (e,w);
		
		div.css({ 'top' : size[0].top , 'left': size[0].left - size[0].divWidth})
		
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_add_mail_rule&employee_id='+employeeId,'add_mail_rule_','1');
	}
	
	function open_update_rule(ruleID, employeeId, e) {
		
		var div = $('#add_mail_rule_')
		var w = 300 ;
		var size =  elementPosition (e,w);
		
		div.css({ 'top' : size[0].top , 'left': size[0].left - size[0].divWidth})
		
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_rule_settings&rule_id=' + ruleID + '&employee_id=' + employeeId, 'add_mail_rule_', '1');
	}
	
	function open_add_mail_signature_(employeeId,e) {
		
		var div = $('#add_mail_signature_')
		var w = 550;
		var size =  elementPosition (e, w);
		
		div.css({ 'top' : size[0].top , 'left': size[0].left - size[0].divWidth})
		
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_add_mail_signature&employee_id='+employeeId,'add_mail_signature_','1');
	}
	
	function open_update_signature(signatureID,employeeId,e) { 
		
		var div = $('#add_mail_signature_')
		var w = 550;
		var size =  elementPosition (e, w);
		
		div.css({ 'top' : size[0].top , 'left': size[0].left - size[0].divWidth})
	
		AjaxPageLoad( '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_signature_settings&signature_id='+signatureID+'&employee_id='+employeeId,'add_mail_signature_','1');
	}
	
	function open_add_main_mail_rule(employeeId, e){
		
		var div = $('#add_main_mail_rule_')
		var w = 305;
		var size =  elementPosition (e, w);
		
		div.css({ 'top' : size[0].top , 'left': size[0].left - size[0].divWidth})
		
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_add_main_mail_rule','add_main_mail_rule_','1');
	}
	
	function open_update_main_rule(ruleID,employeeId, e) { 
	
		var div = $('#add_main_mail_rule_')
		var w = 305;
		var size =  elementPosition (e, w);
		
		div.css({ 'top' : size[0].top , 'left': size[0].left - size[0].divWidth})
	
		AjaxPageLoad( '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_main_rule_settings&rule_id='+ruleID,'add_main_mail_rule_','1');
	}
</script>             

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
			
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'correspondence.list_mymails';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'correspondence/display/list_mymails.cfm';

		
</cfscript>