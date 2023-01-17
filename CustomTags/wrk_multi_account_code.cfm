<!---Çoklu muhasebe kodu seçme 20110927 SM--->
<cfparam name="attributes.form_name" default='form'>
<cfparam name="attributes.is_multi" default='0'>
<cfparam name="attributes.is_name" default='0'>
<cfparam name="attributes.acc_code1_1" default=''>
<cfparam name="attributes.acc_code2_1" default=''>
<cfparam name="attributes.acc_code1_2" default="">
<cfparam name="attributes.acc_code2_2" default="">
<cfparam name="attributes.acc_code1_3" default="">
<cfparam name="attributes.acc_code2_3" default="">
<cfparam name="attributes.acc_code1_4" default="">
<cfparam name="attributes.acc_code2_4" default="">
<cfparam name="attributes.acc_code1_5" default="">
<cfparam name="attributes.acc_code2_5" default="">
<cfparam name="attributes.width_info" default='90'>
<cfparam name="attributes.placeholder" default="">
<cfparam name="attributes.placeholder2" default="">
<cfparam name="attributes.id" default="multi_acc_code_#listlast(caller.attributes.fuseaction,'.')#">
<cfset fuseact = '#caller.attributes.fuseaction#'>
<cfset attributes.collapsed = 1>
<cfif isdefined("caller.xml_unload_body_#attributes.id#")>   
	<cfset attributes.collapsed = evaluate("caller.xml_unload_body_#attributes.id#")>
<cfelseif isdefined("caller.caller.xml_unload_body_#attributes.id#")> 
	<cfset attributes.collapsed = evaluate("caller.caller.xml_unload_body_#attributes.id#")>
</cfif>
<cfoutput>
	<cfsavecontent  variable="message"><cfif isdefined("attributes.placeholder") and len(attributes.placeholder)>#attributes.placeholder#</cfif></cfsavecontent>
	<cfsavecontent  variable="message2"><cfif isdefined("attributes.placeholder2") and len(attributes.placeholder2)>#attributes.placeholder2#</cfif></cfsavecontent>
	<div class="form-group medium">
		<div class="input-group">
			<cfif isDefined("attributes.is_name") and attributes.is_name eq 1>
				<cfinput type="text" name="acc_code1_1" id="acc_code1_1" value="#attributes.acc_code1_1#" onFocus="AutoComplete_Create('acc_code1_1','ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_name','\'1\',0','ACCOUNT_NAME','','form','3','250');" autocomplete="off" placeHolder="#message#">
			<cfelse>
				<cfinput type="text" name="acc_code1_1" id="acc_code1_1" value="#attributes.acc_code1_1#" onFocus="AutoComplete_Create('acc_code1_1','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','ACCOUNT_CODE','','form','3','250');" autocomplete="off" placeHolder="#message#">
			</cfif>
			<span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:open_acc_code('#attributes.form_name#.acc_code1_1','form.acc_code1_1','form.acc_code1_1');"></span>	
		</div>
	</div>
	<div class="form-group medium">
		<div class="input-group">
			<cfif isDefined("attributes.is_name") and attributes.is_name eq 1>
				<cfinput type="text" name="acc_code2_1" id="acc_code2_1" value="#attributes.acc_code2_1#" onFocus="AutoComplete_Create('acc_code2_1','ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_name','\'1\',0','ACCOUNT_NAME','','form','3','250');" autocomplete="off" placeHolder="#message2#">
			<cfelse>
				<cfinput type="text" name="acc_code2_1" id="acc_code2_1" value="#attributes.acc_code2_1#" onFocus="AutoComplete_Create('acc_code2_1','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','ACCOUNT_CODE,','','form','3','250');" autocomplete="off" placeHolder="#message2#">
			</cfif>
			<span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:open_acc_code('#attributes.form_name#.acc_code2_1','form.acc_code2_1','form.acc_code2_1');"></span>
			
			<cfif attributes.is_multi eq 1>
				<span class="input-group-addon icon-ellipsis btnPointer font-red" onclick="#attributes.id#_multi_acc(#attributes.id#);"></span>
			</cfif>
			
		</div>
		<cfif attributes.is_multi eq 1>
			<div id="action_#attributes.id#" class="portBox portBottom border border-grey actCodeOther" style="display:none; width:1px;"></div>		
			<div class="portBox portBottom border border-grey actCodeOther scrollContent scroll-x15" id="box_#attributes.id#" style="display:none; position: absolute; left: 0px; top: 50px; z-index : 2;width: 400px !important;">
				<div class="portHead font-red-pink ui-sortable-handle" ><span><cf_get_lang_main no ='1399.Muhasebe Kodu'></span></div>
				<div class="portBody scrollContent scroll-x2" id="#attributes.id#"></div>
			</div>
		</cfif>
	</div>	
</cfoutput>
<script type="text/javascript">
<cfoutput>
	show_multi_acc_code_list('#attributes.id#','#fuseact#');
	<cfif attributes.collapsed eq 0>
			url_str = '&form_name=#attributes.form_name#&acc_code1_2=#attributes.acc_code1_2#&acc_code2_2=#attributes.acc_code2_2#&acc_code1_3=#attributes.acc_code1_3#&acc_code2_3=#attributes.acc_code2_3#&acc_code1_4=#attributes.acc_code1_4#&acc_code2_4=#attributes.acc_code2_4#&acc_code1_5=#attributes.acc_code1_5#&acc_code2_5=#attributes.acc_code2_5#'
			#attributes.id#.style.display='';
			AjaxPageLoad('#request.self#?fuseaction=account.emptypopup_list_multi_acc_codes'+url_str,'#attributes.id#');	
	<cfelseif attributes.collapsed eq 1>
		box_#attributes.id#.style.display='none';
	</cfif>
	function #attributes.id#_multi_acc(id)
	{		
		<cfif isDefined('fuseact') and len(fuseact) and fuseact eq 'account.list_scale'>
			acc_code1 = document.getElementById('acc_code1_1').value;
			acc_code2 = document.getElementById('acc_code2_1').value;
			if(acc_code1 == '' || acc_code2 == ''){
				alert("#caller.getLang('main',1399,'muh kod')#1 #caller.getLang('main',586,'veya')# #caller.getLang('main',1399,'muh kod')#2 #caller.getLang('settings',1313,'alanını boş bırakmamalısınız')#!");
			}else{
				if(box_#attributes.id#.style.display=='')
				{			
					box_#attributes.id#.style.display='none';
					show_multi_acc_code_list('#attributes.id#','#fuseact#');	
				} else {
					box_#attributes.id#.style.display='';
					url_str = '&form_name=#attributes.form_name#&acc_code1_2=#attributes.acc_code1_2#&acc_code2_2=#attributes.acc_code2_2#&acc_code1_3=#attributes.acc_code1_3#&acc_code2_3=#attributes.acc_code2_3#&acc_code1_4=#attributes.acc_code1_4#&acc_code2_4=#attributes.acc_code2_4#&acc_code1_5=#attributes.acc_code1_5#&acc_code2_5=#attributes.acc_code2_5#'
					AjaxPageLoad('#request.self#?fuseaction=account.emptypopup_list_multi_acc_codes'+url_str,'#attributes.id#');
					show_multi_acc_code_list('#attributes.id#','#fuseact#');	
				}
			}
		<cfelse>
			if(box_#attributes.id#.style.display=='')
			{			
				box_#attributes.id#.style.display='none';
				show_multi_acc_code_list('#attributes.id#','#fuseact#');	
			} else {
				box_#attributes.id#.style.display='';
				url_str = '&form_name=#attributes.form_name#&acc_code1_2=#attributes.acc_code1_2#&acc_code2_2=#attributes.acc_code2_2#&acc_code1_3=#attributes.acc_code1_3#&acc_code2_3=#attributes.acc_code2_3#&acc_code1_4=#attributes.acc_code1_4#&acc_code2_4=#attributes.acc_code2_4#&acc_code1_5=#attributes.acc_code1_5#&acc_code2_5=#attributes.acc_code2_5#'
				AjaxPageLoad('#request.self#?fuseaction=account.emptypopup_list_multi_acc_codes'+url_str,'#attributes.id#');
				show_multi_acc_code_list('#attributes.id#','#fuseact#');	
			}
		</cfif>
			
		
	}
	function open_acc_code(str_alan_1,str_alan_2,str_alan)
	{
		var txt_keyword = eval(str_alan_1 + ".value" );
		windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_1+'&keyword='+txt_keyword,'list');
	}
	</cfoutput>
</script>