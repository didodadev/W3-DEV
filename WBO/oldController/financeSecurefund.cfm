<cf_get_lang_set module_name="finance">
	<cfparam name="attributes.securefund_status" default="1">
    <cfparam name="attributes.return_status" default="">
    <cfparam name="attributes.start_date_1" default="">
    <cfparam name="attributes.start_date_2" default="">
    <cfparam name="attributes.finish_date_1" default="">
    <cfparam name="attributes.finish_date_2" default="">
    <cfparam name="attributes.comp_id" default="">
    <cfparam name="attributes.record_date" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.securefund_cat" default="">
    <cfparam name="attributes.comp_branch_id" default="">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
	<cf_xml_page_edit fuseact="finance.list_securefund">
    
    <cfif isdefined('attributes.is_submitted')>
        <cfif isdefined("attributes.start_date_1") and len(attributes.start_date_1)><cf_date tarih="attributes.start_date_1"></cfif>
        <cfif isdefined("attributes.start_date_2") and len(attributes.start_date_2)><cf_date tarih="attributes.start_date_2"></cfif>
        <cfif isdefined("attributes.finish_date_1") and len(attributes.finish_date_1)><cf_date tarih="attributes.finish_date_1"></cfif>
        <cfif isdefined("attributes.finish_date_2") and len(attributes.finish_date_2)><cf_date tarih="attributes.finish_date_2"></cfif>
        <cfif isdefined("attributes.record_date") and len(attributes.record_date)><cf_date tarih="attributes.record_date"></cfif>
        <cfquery name="GET_COMPANY_SECUREFUND" datasource="#DSN#">
            SELECT 
                CS.*,
                ISNULL(CS.EXPENSE_TOTAL,0) EXPENSE_TOTAL_,
                OC.COMPANY_NAME,
                SS.SECUREFUND_CAT,
                CON.CONSUMER_ID,CONSUMER_NAME,
                CON.CONSUMER_SURNAME,
                C.COMPANY_ID,
                C.NICKNAME,
                C.FULLNAME,
                BB.BANK_BRANCH_ID,
                BB.BANK_BRANCH_NAME,
                BB.BANK_NAME,
                PP.PROJECT_ID,
                PP.PROJECT_HEAD
            FROM 
                COMPANY_SECUREFUND CS
                LEFT JOIN OUR_COMPANY OC ON CS.OUR_COMPANY_ID = OC.COMP_ID
                LEFT JOIN SETUP_SECUREFUND SS ON SS.SECUREFUND_CAT_ID = CS.SECUREFUND_CAT_ID
                LEFT JOIN CONSUMER CON ON CON.CONSUMER_ID = CS.CONSUMER_ID
                LEFT JOIN COMPANY C ON C.COMPANY_ID = CS.COMPANY_ID
                LEFT JOIN #dsn3_alias#.BANK_BRANCH BB ON BB.BANK_BRANCH_ID = CS.BANK_BRANCH_ID
                LEFT JOIN PRO_PROJECTS PP ON PP.PROJECT_ID = CS.PROJECT_ID
            WHERE 
                ISNULL(CS.IS_CRM,0) = 0 AND<!--- Crm modulunde kullanilanlarla ayirmak amaciyla eklendi --->
                CS.OUR_COMPANY_ID = #session.ep.company_id#
                <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                    AND (
                            SS.SECUREFUND_CAT LIKE '%#attributes.keyword#%' OR
                            CS.REALESTATE_DETAIL LIKE '%#attributes.keyword#%'
                        )
                </cfif>
                <cfif isdefined("attributes.give_take") and len(attributes.give_take)>
                    AND CS.GIVE_TAKE = #attributes.give_take#
                </cfif>
                <cfif isdate(attributes.record_date) and len(attributes.record_date)>
                    AND CS.RECORD_DATE >= #attributes.record_date# 
                </cfif>
                <cfif isdate(attributes.start_date_1) and len(attributes.start_date_1)>
                    AND CS.START_DATE >= #attributes.start_date_1#
                </cfif>
                <cfif isdate(attributes.start_date_2) and len(attributes.start_date_2)>
                    AND CS.START_DATE < #date_add('d',1,attributes.start_date_2)#
                </cfif>
                <cfif isdate(attributes.finish_date_1) and len(attributes.finish_date_1)>
                    AND CS.FINISH_DATE >= #attributes.finish_date_1#
                </cfif>
                <cfif isdate(attributes.finish_date_2) and len(attributes.finish_date_2)>
                    AND CS.FINISH_DATE < #date_add('d',1,attributes.finish_date_2)#
                </cfif>
                <cfif isDefined("attributes.member_type") and attributes.member_type eq 'partner' and len(attributes.company_id) and isDefined("attributes.member") and len(attributes.member)>
                    AND CS.COMPANY_ID = #attributes.company_id#
                </cfif>
                <cfif isDefined("attributes.member_type") and attributes.member_type eq 'consumer' and len(attributes.member_id) and len(attributes.member)>
                    AND CS.CONSUMER_ID = #attributes.member_id#
                </cfif>
                <cfif isdefined('attributes.comp_id') and len(attributes.comp_id) >
                    AND	COMP_ID = #attributes.comp_id#
                </cfif>	
                <cfif isdefined('attributes.bank_id') and len(attributes.bank_id)>
                    AND	CS.BANK_ID = #attributes.bank_id#
                </cfif>
                <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
                    AND	CS.BANK_BRANCH_ID = #attributes.branch_id# 
                </cfif>
                <cfif fusebox.circuit neq "store" and isdefined('attributes.comp_branch_id') and len(attributes.comp_branch_id)>
                    AND	CS.OURCOMP_BRANCH = #attributes.comp_branch_id#
                <cfelseif fusebox.circuit eq "store">
                    AND CS.OURCOMP_BRANCH = #listlast(session.ep.user_location,'-')# 
                </cfif>
                <cfif isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_head)>
                    AND	CS.PROJECT_ID = #attributes.project_id# 
                </cfif>
                <cfif isdefined('attributes.securefund_cat') and len(attributes.securefund_cat) >
                    AND	CS.SECUREFUND_CAT_ID = #attributes.securefund_cat# 
                </cfif>
                <cfif isdefined('return_status') and return_status eq 1>
                    AND CS.GIVE_TAKE=1 AND RETURN_PROCESS_CAT IS NOT NULL
                <cfelseif isdefined('return_status') and return_status eq 0>
                    AND CS.GIVE_TAKE=0 AND RETURN_PROCESS_CAT IS NOT NULL
                </cfif>															
                <cfif isDefined('attributes.securefund_status') and len(attributes.securefund_status)>AND SECUREFUND_STATUS = #attributes.securefund_status#</cfif>
            ORDER BY 
                CS.RECORD_DATE DESC
        </cfquery>
    <cfelse>
        <cfset get_company_securefund.recordcount = 0>
    </cfif>
    <cfquery name="GET_BANK_BRANCHES" datasource="#DSN3#">
        SELECT 
            BANK_BRANCH_ID,
            BANK_BRANCH_NAME,
            BANK_NAME
        FROM 
            BANK_BRANCH 
        WHERE 
            BANK_ID IS NOT NULL
        ORDER BY
            BANK_NAME
    </cfquery>
    <cfquery name="GET_COMPANY_" datasource="#DSN#">
        SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
    </cfquery>
    <cfquery name="GET_CAT" datasource="#DSN#">
        SELECT SECUREFUND_CAT_ID,SECUREFUND_CAT FROM SETUP_SECUREFUND ORDER BY SECUREFUND_CAT
    </cfquery>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_company_securefund.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
    <script type="text/javascript">
    	$( document ).ready(function() {
		    document.getElementById('keyword').focus();
			<cfif not len(attributes.comp_id)>
				showDepartment(<cfoutput>#session.ep.company_id#</cfoutput>);
			<cfelse>
				showDepartment(<cfoutput>#attributes.comp_id#</cfoutput>);
			</cfif>
		});
		function showDepartment(no)	
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=finance.popup_ajax_list_departments&our_company_id="+no+"<cfif len(attributes.comp_branch_id)>&submitted_branch=<cfoutput>#attributes.comp_branch_id#</cfoutput></cfif>";
	
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Şubeler');
		}
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_securefund';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'finance/display/list_securefund.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'member.popup_form_add_securefund';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'member/form/add_securefund.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'member/query/add_securefund.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_securefund';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'member.popup_form_upd_securefund';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'member/form/upd_securefund.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'member/query/upd_securefund.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_securefund';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'securefund_id=##attributes.securefund_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.securefund_id##';
</cfscript>
