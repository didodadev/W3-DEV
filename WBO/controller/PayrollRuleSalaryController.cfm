<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.personal_payment';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/personal_payment.cfm';
		
		WOStruct['#attributes.fuseaction#']['listPayments'] = structNew();
		WOStruct['#attributes.fuseaction#']['listPayments']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['listPayments']['fuseaction'] = 'ehesap.popup_list_insurance_payments';
		WOStruct['#attributes.fuseaction#']['listPayments']['filePath'] = 'V16/hr/ehesap/form/list_insurance_payments.cfm';
		WOStruct['#attributes.fuseaction#']['listPayments']['nextEvent'] = 'ehesap.personal_payment';	

		WOStruct['#attributes.fuseaction#']['addPayments'] = structNew();
		WOStruct['#attributes.fuseaction#']['addPayments']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['addPayments']['fuseaction'] = 'ehesap.popup_form_add_insurance_payments';
		WOStruct['#attributes.fuseaction#']['addPayments']['filePath'] = 'V16/hr/ehesap/form/form_add_insurance_payments.cfm';
		WOStruct['#attributes.fuseaction#']['addPayments']['queryPath'] = 'V16/hr/ehesap/query/add_insurance_payments.cfm';
		WOStruct['#attributes.fuseaction#']['addPayments']['nextEvent'] = 'ehesap.personal_payment';	
				
		WOStruct['#attributes.fuseaction#']['listRatios'] = structNew();
		WOStruct['#attributes.fuseaction#']['listRatios']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['listRatios']['fuseaction'] = 'ehesap.popup_list_insurance_ratios';
		WOStruct['#attributes.fuseaction#']['listRatios']['filePath'] = 'V16/hr/ehesap/display/list_insurance_ratios.cfm';
		WOStruct['#attributes.fuseaction#']['listRatios']['nextEvent'] = 'ehesap.personal_payment';	
		
		WOStruct['#attributes.fuseaction#']['addRatio'] = structNew();
		WOStruct['#attributes.fuseaction#']['addRatio']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['addRatio']['fuseaction'] = 'ehesap.popup_form_add_insurance_ratio';
		WOStruct['#attributes.fuseaction#']['addRatio']['filePath'] = 'V16/hr/ehesap/form/form_add_insurance_ratio.cfm';
		WOStruct['#attributes.fuseaction#']['addRatio']['queryPath'] = 'V16/hr/ehesap/query/add_insurance_ratio.cfm';
		WOStruct['#attributes.fuseaction#']['addRatio']['nextEvent'] = 'ehesap.personal_payment';	
				
		WOStruct['#attributes.fuseaction#']['listTax'] = structNew();
		WOStruct['#attributes.fuseaction#']['listTax']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['listTax']['fuseaction'] = 'ehesap.popup_list_insurance_tax';
		WOStruct['#attributes.fuseaction#']['listTax']['filePath'] = 'V16/hr/ehesap/display/list_insurance_tax.cfm';
		WOStruct['#attributes.fuseaction#']['listTax']['nextEvent'] = 'ehesap.personal_payment';	
				
		WOStruct['#attributes.fuseaction#']['listFactor'] = structNew();
		WOStruct['#attributes.fuseaction#']['listFactor']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['listFactor']['fuseaction'] = 'ehesap.popup_list_factor_definition';
		WOStruct['#attributes.fuseaction#']['listFactor']['filePath'] = 'V16/hr/ehesap/display/list_factor_definition.cfm';
		WOStruct['#attributes.fuseaction#']['listFactor']['nextEvent'] = 'ehesap.personal_payment';	

		WOStruct['#attributes.fuseaction#']['addTax'] = structNew();
		WOStruct['#attributes.fuseaction#']['addTax']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['addTax']['fuseaction'] = 'ehesap.popup_form_add_tax_slice';
		WOStruct['#attributes.fuseaction#']['addTax']['filePath'] = 'V16/hr/ehesap/form/add_tax_slice.cfm';
		WOStruct['#attributes.fuseaction#']['addTax']['queryPath'] = 'V16/hr/ehesap/query/add_tax_slice.cfm';
		WOStruct['#attributes.fuseaction#']['addTax']['nextEvent'] = 'ehesap.personal_payment';	

		WOStruct['#attributes.fuseaction#']['addCourses'] = structNew();
		WOStruct['#attributes.fuseaction#']['addCourses']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['addCourses']['fuseaction'] = 'ehesap.personal_payment';
		WOStruct['#attributes.fuseaction#']['addCourses']['filePath'] = 'V16/hr/ehesap/form/add_additional_course.cfm';
		WOStruct['#attributes.fuseaction#']['addCourses']['nextEvent'] = 'ehesap.personal_payment';	

		WOStruct['#attributes.fuseaction#']['updCourses'] = structNew();
		WOStruct['#attributes.fuseaction#']['updCourses']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['updCourses']['fuseaction'] = 'ehesap.personal_payment';
		WOStruct['#attributes.fuseaction#']['updCourses']['filePath'] = 'V16/hr/ehesap/form/upd_additional_course.cfm';
		WOStruct['#attributes.fuseaction#']['updCourses']['nextEvent'] = 'ehesap.personal_payment';	

		WOStruct['#attributes.fuseaction#']['listCourses'] = structNew();
		WOStruct['#attributes.fuseaction#']['listCourses']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['listCourses']['fuseaction'] = 'ehesap.personal_payment';
		WOStruct['#attributes.fuseaction#']['listCourses']['filePath'] = 'V16/hr/ehesap/display/list_additional_course.cfm';

		WOStruct['#attributes.fuseaction#']['listAcademicRate'] = structNew();
		WOStruct['#attributes.fuseaction#']['listAcademicRate']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['listAcademicRate']['fuseaction'] = 'ehesap.personal_payment';
		WOStruct['#attributes.fuseaction#']['listAcademicRate']['filePath'] = 'V16/hr/ehesap/display/list_academic_rate.cfm';


		WOStruct['#attributes.fuseaction#']['updAcademicRate'] = structNew();
		WOStruct['#attributes.fuseaction#']['updAcademicRate']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['updAcademicRate']['fuseaction'] = 'ehesap.personal_payment';
		WOStruct['#attributes.fuseaction#']['updAcademicRate']['filePath'] = 'V16/hr/ehesap/form/upd_academic_rate.cfm';
		WOStruct['#attributes.fuseaction#']['updAcademicRate']['nextEvent'] = 'ehesap.personal_payment';	

		WOStruct['#attributes.fuseaction#']['addAcademicRate'] = structNew();
		WOStruct['#attributes.fuseaction#']['addAcademicRate']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['addAcademicRate']['fuseaction'] = 'ehesap.personal_payment';
		WOStruct['#attributes.fuseaction#']['addAcademicRate']['filePath'] = 'V16/hr/ehesap/form/add_academic_rate.cfm';
		WOStruct['#attributes.fuseaction#']['addAcademicRate']['nextEvent'] = 'ehesap.personal_payment';

		if(isdefined("attributes.ins_pay_id"))
		{
			WOStruct['#attributes.fuseaction#']['updPayments'] = structNew();
			WOStruct['#attributes.fuseaction#']['updPayments']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updPayments']['fuseaction'] = 'ehesap.popup_form_upd_insurance_payments';
			WOStruct['#attributes.fuseaction#']['updPayments']['filePath'] = 'V16/hr/ehesap/form/form_upd_insurance_payments.cfm';
			WOStruct['#attributes.fuseaction#']['updPayments']['queryPath'] = 'V16/hr/ehesap/query/upd_insurance_payments.cfm';
			WOStruct['#attributes.fuseaction#']['updPayments']['Identity'] = '#attributes.ins_pay_id#';
			WOStruct['#attributes.fuseaction#']['updPayments']['nextEvent'] = 'ehesap.personal_payment';
			
			WOStruct['#attributes.fuseaction#']['delPayments'] = structNew();
			WOStruct['#attributes.fuseaction#']['delPayments']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['delPayments']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_insurance_payments&ins_pay_id=#attributes.ins_pay_id#';
			WOStruct['#attributes.fuseaction#']['delPayments']['filePath'] = 'V16/hr/ehesap/query/del_insurance_payments.cfm';
			WOStruct['#attributes.fuseaction#']['delPayments']['queryPath'] = 'V16/hr/ehesap/query/del_insurance_payments.cfm';
			WOStruct['#attributes.fuseaction#']['delPayments']['nextEvent'] = 'ehesap.personal_payment';
		}
		if(isdefined("attributes.ins_rat_id"))
		{
			WOStruct['#attributes.fuseaction#']['updRatio'] = structNew();
			WOStruct['#attributes.fuseaction#']['updRatio']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updRatio']['fuseaction'] = 'ehesap.popup_form_upd_insurance_ratio';
			WOStruct['#attributes.fuseaction#']['updRatio']['filePath'] = 'V16/hr/ehesap/form/form_upd_insurance_ratio.cfm';
			WOStruct['#attributes.fuseaction#']['updRatio']['queryPath'] = 'V16/hr/ehesap/query/upd_insurance_ratio.cfm';
			WOStruct['#attributes.fuseaction#']['updRatio']['Identity'] = '#attributes.ins_rat_id#';
			WOStruct['#attributes.fuseaction#']['updRatio']['nextEvent'] = 'ehesap.personal_payment';
			
			WOStruct['#attributes.fuseaction#']['delRatio'] = structNew();
			WOStruct['#attributes.fuseaction#']['delRatio']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['delRatio']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_insurance_ratio&INS_RAT_ID=#attributes.INS_RAT_ID#';
			WOStruct['#attributes.fuseaction#']['delRatio']['filePath'] = 'V16/hr/ehesap/query/del_insurance_ratio.cfm';
			WOStruct['#attributes.fuseaction#']['delRatio']['queryPath'] = 'V16/hr/ehesap/query/del_insurance_ratio.cfm';
			WOStruct['#attributes.fuseaction#']['delRatio']['nextEvent'] = 'ehesap.personal_payment';
		}
		if(isdefined("attributes.tax_sl_id"))
		{
			WOStruct['#attributes.fuseaction#']['updTax'] = structNew();
			WOStruct['#attributes.fuseaction#']['updTax']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updTax']['fuseaction'] = 'ehesap.popup_form_upd_tax_slice';
			WOStruct['#attributes.fuseaction#']['updTax']['filePath'] = 'V16/hr/ehesap/form/upd_tax_slice.cfm';
			WOStruct['#attributes.fuseaction#']['updTax']['queryPath'] = 'V16/hr/ehesap/query/upd_tax_slice.cfm';
			WOStruct['#attributes.fuseaction#']['updTax']['Identity'] = '#attributes.tax_sl_id#';
			WOStruct['#attributes.fuseaction#']['updTax']['nextEvent'] = 'ehesap.personal_payment';
			
			WOStruct['#attributes.fuseaction#']['delTax'] = structNew();
			WOStruct['#attributes.fuseaction#']['delTax']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['delTax']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_tax_slice&tax_sl_id=#attributes.tax_sl_id#';
			WOStruct['#attributes.fuseaction#']['delTax']['filePath'] = 'V16/hr/ehesap/query/del_tax_slice.cfm';
			WOStruct['#attributes.fuseaction#']['delTax']['queryPath'] = 'V16/hr/ehesap/query/del_tax_slice.cfm';
			WOStruct['#attributes.fuseaction#']['delTax']['nextEvent'] = 'ehesap.personal_payment';
		}
		if(isdefined("attributes.event") and (attributes.event is 'addPayments' or attributes.event is 'updPayments')){
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addPayments,updPayments';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INSURANCE_PAYMENT';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INS_PAY_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-startdate','item-finishdate','item-minimum','item-maximum','item-min_gross_payment_normal','item-min_gross_payment_16']";
		}
		if(isdefined("attributes.event") and (attributes.event is 'addRatio' or attributes.event is 'updRatio')){
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addRatio,updRatio';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INSURANCE_RATIO';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INS_RAT_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-startdate','item-finishdate','item-mom_insurance_premium_worker','item-PAT_INS_PREMIUM_WORKER','item-PAT_INS_PREMIUM_WORKER_2','item-death_insurance_premium_worker','item-death_insurance_worker','item-SOC_SEC_INSURANCE_WORKER']";
		}
		if(isdefined("attributes.event") and (attributes.event is 'addTax' or attributes.event is 'updTax')){
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addTax,updTax';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_TAX_SLICES';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'TAX_SL_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-name','item-date','item-payment1','item-payment2','item-payment3','item-payment4','item-payment5','item-payment6','item-sakat1','item-sakat2','item-sakat3']";
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(isdefined("attributes.event") and attributes.event is 'addPayments')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['addPayments']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addPayments']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addPayments']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addPayments']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.personal_payment";
			tabMenuStruct['#fuseactController#']['tabMenus']['addPayments']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addPayments']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if (isdefined("attributes.event") and attributes.event is 'updPayments')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayments']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayments']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayments']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayments']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.personal_payment";
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayments']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayments']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayments']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayments']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=ehesap.personal_payment&event=addPayments'";
		}
		else if (isdefined("attributes.event") and attributes.event is 'addRatio')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['addRatio']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addRatio']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addRatio']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addRatio']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.personal_payment";
			tabMenuStruct['#fuseactController#']['tabMenus']['addRatio']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addRatio']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'updRatio')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['updRatio']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updRatio']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updRatio']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updRatio']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.personal_payment";
			tabMenuStruct['#fuseactController#']['tabMenus']['updRatio']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updRatio']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayments']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayments']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=ehesap.personal_payment&event=addRatio'";
		}
		else if (isdefined("attributes.event") and attributes.event is 'addTax')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['addTax']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addTax']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addTax']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addTax']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.personal_payment";
			tabMenuStruct['#fuseactController#']['tabMenus']['addTax']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addTax']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if (isdefined("attributes.event") and attributes.event is 'updTax')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['updTax']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updTax']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updTax']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updTax']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.personal_payment";
			tabMenuStruct['#fuseactController#']['tabMenus']['updTax']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updTax']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['updTax']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updTax']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=ehesap.personal_payment&event=addTax'";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
