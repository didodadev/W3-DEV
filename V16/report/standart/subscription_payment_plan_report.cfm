<cfsetting showdebugoutput="no">
<!--- 
Sistemlerin deme planlarinin detayli bilgisini gsterir, 
faturalandi provizyon olusturulmadi vs. gibi sorgulari vardr Aysenur20060715...
 --->
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.module_id_control" default="11">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.finishdate" default="#now()#">
<cfparam name="attributes.startdate" default="#now()#">
<cfparam name="attributes.is_multi" default="">
<cfparam name="attributes.is_billed" default="">
<cfparam name="attributes.is_prov" default="">
<cfparam name="attributes.is_paid" default="">
<cfparam name="attributes.is_group" default="">
<cfparam name="attributes.is_show_member_team" default="">
<cfparam name="attributes.member_team_roles" default="">
<cfparam name="attributes.use_efatura" default="">
<cfparam name="attributes.is_show_paid" default="">
<cfparam name="attributes.is_show_curr" default="">
<cfparam name="attributes.period_id" default="#session.ep.period_id#-#session.ep.period_year#">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.subscription_type" default="">
<cfif not len (attributes.subscription_no) >
	<cfset attributes.subscription_id = '' >
</cfif> 

<cfset gsa = createObject("component","V16.objects.cfc.subscriptionNauthority")/>
<cfset GET_SUBSCRIPTION_AUTHORITY= gsa.SelectAuthority()/>

<cfset GET_SUBSCRIPTION_TYPE= gsa.SelectSubscription()/>

<cfquery name="get_roles" datasource="#dsn#">
	SELECT PROJECT_ROLES_ID, PROJECT_ROLES FROM SETUP_PROJECT_ROLES ORDER BY PROJECT_ROLES
</cfquery>
<cfquery name="get_period" datasource="#dsn#">
	SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# ORDER BY PERIOD_YEAR
</cfquery>
<cfprocessingdirective suppresswhitespace="yes">
<cfif isdefined("attributes.form_varmi")>
	<cfif isdate(attributes.startdate)>
		<cf_date tarih = "attributes.startdate">
	</cfif>
	<cfif isdate(attributes.finishdate)>
		<cf_date tarih = "attributes.finishdate">
	</cfif>
    
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=50000>	
	</cfif>
	<cfquery name="GET_SUBS_PAY_PLAN" datasource="#dsn3#">
		WITH CTE1 AS (
			SELECT
				SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.PAYMENT_DATE ,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.DETAIL ,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.QUANTITY ,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.ROW_TOTAL, 
				SUBSCRIPTION_PAYMENT_PLAN_ROW.DISCOUNT,
                SUBSCRIPTION_PAYMENT_PLAN_ROW.DISCOUNT_AMOUNT,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.ROW_NET_TOTAL ,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.MONEY_TYPE,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.IS_COLLECTED_INVOICE,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.IS_BILLED ,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.IS_COLLECTED_PROVISION,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.IS_PAID,  
				SUBSCRIPTION_PAYMENT_PLAN_ROW.IS_GROUP_INVOICE,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.CARD_PAYMETHOD_ID , 
				SUBSCRIPTION_PAYMENT_PLAN_ROW.UNIT,
                SUBSCRIPTION_PAYMENT_PLAN_ROW.RATE,
				SUBSCRIPTION_CONTRACT.COMPANY_ID,
				SUBSCRIPTION_CONTRACT.CONSUMER_ID,
				CAST(SUBSCRIPTION_PAYMENT_PLAN_ROW.SUBSCRIPTION_PAYMENT_ROW_ID AS NVARCHAR)+'_'+CAST(ISNULL(SUBSCRIPTION_CONTRACT.INVOICE_COMPANY_ID,SUBSCRIPTION_CONTRACT.INVOICE_CONSUMER_ID) AS NVARCHAR) MEMBER_ID,
				<cfif isDefined("attributes.is_show_member_team") and attributes.is_show_member_team eq 1>
					MEMBER_TEAM_CONSUMER.EMP_NAME CONS_EMP_NAME,
					MEMBER_TEAM_COMPANY.EMP_NAME COMP_EMP_NAME,
				</cfif>
				(SELECT ISNULL(TAX,0) FROM PRODUCT WHERE PRODUCT_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.PRODUCT_ID) TAX,
				SUBSCRIPTION_CONTRACT.SUBSCRIPTION_NO,
				SUBSCRIPTION_PAYMENT_PLAN_ROW.PAYMETHOD_ID,
				SETUP_PAYMETHOD.PAYMETHOD,
				CREDITCARD_PAYMENT_TYPE.CARD_NO,
				COMPANY.FULLNAME,
				CONSUMER.CONSUMER_NAME,
				CONSUMER.CONSUMER_SURNAME,
				CASE 
				WHEN INVOICE_COMPANY_ID IS NOT NULL THEN  COMPANY1.FULLNAME
				WHEN INVOICE_CONSUMER_ID IS NOT NULL THEN CONSUMER1.CONSUMER_NAME + '' + CONSUMER1.CONSUMER_SURNAME 
				END AS INVOICE_COMPANY,
				PROCESS_TYPE_ROWS.STAGE,
				SUBSCRIPTION_CONTRACT.FINISH_DATE,
				INVOICE_CONSUMER_ID,INVOICE_COMPANY_ID,
				AMOUNT,
				MONTAGE_DATE,
				CASE 
				WHEN SUBSCRIPTION_CONTRACT.REF_COMPANY_ID IS NOT NULL THEN  COMPANY2.FULLNAME
				WHEN SUBSCRIPTION_CONTRACT.REF_CONSUMER_ID IS NOT NULL THEN CONSUMER2.CONSUMER_NAME + '' + CONSUMER1.CONSUMER_SURNAME 
				END AS REF_COMPANY,
				REF_COMPANY_ID,
				REF_CONSUMER_ID
			FROM
				SUBSCRIPTION_PAYMENT_PLAN_ROW
				LEFT JOIN #DSN_ALIAS#.SETUP_PAYMETHOD ON SETUP_PAYMETHOD.PAYMETHOD_ID =  SUBSCRIPTION_PAYMENT_PLAN_ROW.PAYMETHOD_ID       
				LEFT JOIN CREDITCARD_PAYMENT_TYPE ON CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.CARD_PAYMETHOD_ID 	
				,SUBSCRIPTION_CONTRACT
				LEFT JOIN #DSN_ALIAS#.COMPANY ON COMPANY.COMPANY_ID = SUBSCRIPTION_CONTRACT.COMPANY_ID       
				LEFT JOIN #DSN_ALIAS#.COMPANY COMPANY1 ON COMPANY1.COMPANY_ID = SUBSCRIPTION_CONTRACT.INVOICE_COMPANY_ID
				LEFT JOIN #DSN_ALIAS#.COMPANY COMPANY2 ON COMPANY2.COMPANY_ID = SUBSCRIPTION_CONTRACT.REF_COMPANY_ID
				LEFT JOIN #DSN_ALIAS#.CONSUMER CONSUMER1 ON CONSUMER1.CONSUMER_ID =   SUBSCRIPTION_CONTRACT.INVOICE_CONSUMER_ID       
				LEFT JOIN #DSN_ALIAS#.CONSUMER CONSUMER2 ON CONSUMER1.CONSUMER_ID =   SUBSCRIPTION_CONTRACT.REF_CONSUMER_ID           
				LEFT JOIN #DSN_ALIAS#.CONSUMER ON CONSUMER.CONSUMER_ID = SUBSCRIPTION_CONTRACT.CONSUMER_ID
				LEFT JOIN #DSN_ALIAS#.PROCESS_TYPE_ROWS ON PROCESS_TYPE_ROWS.PROCESS_ROW_ID = SUBSCRIPTION_CONTRACT.SUBSCRIPTION_STAGE
				<cfif isDefined("attributes.is_show_member_team") and attributes.is_show_member_team eq 1>
					LEFT JOIN
						(	SELECT
								WEP.COMPANY_ID,
								EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME EMP_NAME
							FROM
								#DSN_ALIAS#.WORKGROUP_EMP_PAR WEP,
								#DSN_ALIAS#.EMPLOYEE_POSITIONS EP
							WHERE
								WEP.POSITION_CODE = EP.POSITION_CODE AND
								WEP.WORKGROUP_ID IS NULL AND
								<cfif Len(attributes.member_team_roles)>
									WEP.ROLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_team_roles#"> AND
								</cfif>
								WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
							
							UNION ALL
							
							SELECT
								WEP.COMPANY_ID,
								CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME EMP_NAME
							FROM
								#DSN_ALIAS#.WORKGROUP_EMP_PAR WEP,
								#DSN_ALIAS#.COMPANY_PARTNER CP
							WHERE
								WEP.PARTNER_ID = CP.PARTNER_ID AND
								WEP.WORKGROUP_ID IS NULL AND
								<cfif Len(attributes.member_team_roles)>
									WEP.ROLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_team_roles#"> AND
								</cfif>
								WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						) MEMBER_TEAM_COMPANY ON MEMBER_TEAM_COMPANY.COMPANY_ID = SUBSCRIPTION_CONTRACT.INVOICE_COMPANY_ID
					LEFT JOIN
						(	SELECT
								WEP.CONSUMER_ID,
								EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME EMP_NAME
							FROM
								#DSN_ALIAS#.WORKGROUP_EMP_PAR WEP,
								#DSN_ALIAS#.EMPLOYEE_POSITIONS EP
							WHERE
								WEP.POSITION_CODE = EP.POSITION_CODE AND
								WEP.WORKGROUP_ID IS NULL AND
								<cfif Len(attributes.member_team_roles)>
									WEP.ROLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_team_roles#"> AND
								</cfif>
								WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						) MEMBER_TEAM_CONSUMER ON MEMBER_TEAM_CONSUMER.CONSUMER_ID = SUBSCRIPTION_CONTRACT.INVOICE_CONSUMER_ID
				</cfif>
				<cfif isdefined("attributes.is_show_paid") and attributes.is_show_paid eq 1>
					,#dsn#_#listlast(attributes.period_id,'-')#_#session.ep.company_id#.INVOICE I
				</cfif>
			WHERE
				SUBSCRIPTION_PAYMENT_PLAN_ROW.SUBSCRIPTION_ID = SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID AND
				SUBSCRIPTION_PAYMENT_PLAN_ROW.PAYMENT_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#	
					<cfif isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
					AND 
					(
						SUBSCRIPTION_CONTRACT.SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.subscription_no#"> OR
						SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT_PARTITION WHERE PARTITION_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.subscription_no#">)
					)
				</cfif>
				<cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
					AND COMPANY1.USE_EFATURA = 1 
				<cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
					AND COMPANY1.USE_EFATURA = 0 
				</cfif>	
				<cfif isdefined("attributes.status") and len(attributes.status) and ( attributes.status eq 1 or attributes.status eq 0)>
					AND SUBSCRIPTION_CONTRACT.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status#">
				</cfif>
				<cfif isdefined('attributes.is_multi') and len(attributes.is_multi)>
					AND IS_COLLECTED_INVOICE IN (#attributes.is_multi#)
				</cfif>
				<cfif isdefined('attributes.is_billed') and len(attributes.is_billed)>
					AND IS_BILLED IN (#attributes.is_billed#)
				</cfif>
				<cfif isdefined('attributes.is_prov') and len(attributes.is_prov)>
					AND IS_COLLECTED_PROVISION IN (#attributes.is_prov#)
				</cfif>
				<cfif isdefined('attributes.is_paid') and len(attributes.is_paid)>
					AND IS_PAID IN (#attributes.is_paid#)
				</cfif>
				<cfif isdefined('attributes.is_group') and len(attributes.is_group)>
					AND IS_GROUP_INVOICE IN (#attributes.is_group#)
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND SUBSCRIPTION_PAYMENT_PLAN_ROW.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif isdefined("attributes.member_type") AND len(attributes.member_type) and attributes.member_type is 'Partner' and isdefined("attributes.member_name") and len(attributes.member_name)>
					AND INVOICE_COMPANY_ID = #attributes.company_id#
				<cfelseif isdefined("attributes.member_type") AND len(attributes.member_type) and attributes.member_type is 'Consumer' and isdefined("attributes.member_name") and len(attributes.member_name)>
					AND INVOICE_CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif isdefined("attributes.member_type1") AND len(attributes.member_type1) and attributes.member_type1 is 'Partner' and isdefined("attributes.member_name1") and len(attributes.member_name1)>
					AND SUBSCRIPTION_CONTRACT.COMPANY_ID = #attributes.company_id1#
				<cfelseif isdefined("attributes.member_type1") AND len(attributes.member_type1) and attributes.member_type1 is 'Consumer' and isdefined("attributes.member_name1") and len(attributes.member_name1)>
					AND SUBSCRIPTION_CONTRACT.CONSUMER_ID = #attributes.consumer_id1#
				</cfif>
				<cfif isdefined("attributes.is_active") and attributes.is_active eq 1>
					AND SUBSCRIPTION_PAYMENT_PLAN_ROW.IS_ACTIVE =  1
				</cfif>
				<cfif isdefined("attributes.is_active") and attributes.is_active eq 2>
					AND SUBSCRIPTION_PAYMENT_PLAN_ROW.IS_ACTIVE =  0
				</cfif>
				<cfif isdefined("attributes.payment_type_id") and len(attributes.payment_type_id) and isdefined("attributes.payment_type") and len(attributes.payment_type)>
					AND SUBSCRIPTION_PAYMENT_PLAN_ROW.PAYMETHOD_ID = #attributes.payment_type_id#
				<cfelseif isdefined("attributes.payment_type_creditcard_id") and len(attributes.payment_type_creditcard_id) and isdefined("attributes.payment_type") and len(attributes.payment_type) >
					AND SUBSCRIPTION_PAYMENT_PLAN_ROW.CARD_PAYMETHOD_ID = #attributes.payment_type_creditcard_id#
				</cfif>
				<cfif isdefined("attributes.is_show_paid") and attributes.is_show_paid eq 1>
					AND SUBSCRIPTION_PAYMENT_PLAN_ROW.INVOICE_ID = I.INVOICE_ID 
					AND SUBSCRIPTION_PAYMENT_PLAN_ROW.PERIOD_ID = #listfirst(attributes.period_id,'-')#
					AND (I.BANK_ACTION_ID IS NOT NULL OR I.CREDITCARD_PAYMENT_ID IS NOT NULL)
					AND SUBSCRIPTION_PAYMENT_PLAN_ROW.IS_PAID = 0
				</cfif>
				<cfif isdefined("attributes.is_show_curr") and attributes.is_show_curr eq 1>
					AND SUBSCRIPTION_PAYMENT_PLAN_ROW.RATE IS NOT NULL
				</cfif>
				<cfif isdefined("attributes.subscription_type") and len(attributes.subscription_type)>
					AND SUBSCRIPTION_CONTRACT.SUBSCRIPTION_TYPE_ID IN (#attributes.subscription_type#) 
				</cfif>
				<cfif isdefined("attributes.ref_member_type") AND len(attributes.ref_member_type) and attributes.ref_member_type is 'Partner' and isdefined("attributes.ref_member_name") and len(attributes.ref_member_name) and isdefined("attributes.ref_company_id") and len(attributes.ref_company_id)>
					AND REF_COMPANY_ID = #attributes.ref_company_id#
				<cfelseif isdefined("attributes.ref_member_type") AND len(attributes.ref_member_type) and attributes.ref_member_type is 'Consumer' and isdefined("attributes.ref_member_name") and len(attributes.ref_member_name) and isdefined("attributes.ref_consumer_id") and len(attributes.ref_consumer_id)>
					AND REF_CONSUMER_ID = #attributes.ref_consumer_id#
				</cfif>
				<cfif get_subscription_authority.IS_SUBSCRIPTION_AUTHORITY eq 1>
					AND EXISTS 
						(
							SELECT
							SPC.SUBSCRIPTION_TYPE_ID
							FROM        
							#dsn#.EMPLOYEE_POSITIONS AS EP,
							SUBSCRIPTION_GROUP_PERM SPC
							WHERE
							EP.POSITION_CODE = #session.ep.position_code# AND
							(
								SPC.POSITION_CODE = EP.POSITION_CODE OR
								SPC.POSITION_CAT = EP.POSITION_CAT_ID
							)
								AND SUBSCRIPTION_CONTRACT.SUBSCRIPTION_TYPE_ID = spc.SUBSCRIPTION_TYPE_ID
						)
				</cfif>
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	ORDER BY PAYMENT_DATE ASC ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
	<cfset arama_yapilmali=0>
<cfelse>
	<cfset GET_SUBS_PAY_PLAN.recordcount=0>
    <cfset GET_SUBS_PAY_PLAN.query_count=0>
	<cfset arama_yapilmali=1>
</cfif>
<cfif isdate(attributes.startdate)>
	<cfset attributes.startdate = dateformat(attributes.startdate, dateformat_style)>
</cfif>
<cfif isdate(attributes.finishdate)>
	<cfset attributes.finishdate = dateformat(attributes.finishdate, dateformat_style)>
</cfif>
<cfparam name="attributes.totalrecords" default="#GET_SUBS_PAY_PLAN.query_count#">
<cfform name="form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
<cf_report_list_search title="#getLang('report',1355)#">
<cf_report_list_search_area>
	<div class="row">
        <div class="col col-12 col-xs-12">
            <div class="row formContent">
				<div class="row" type="row">              
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<div class="col col-12 col-xs-12">
							<div class="form-group">
								<div class="col col-12 col-xs-12">
									<select name="is_multi" id="is_multi" multiple style="height:40px;">
										<option value="1" <cfif listfind(attributes.is_multi,"1",',')>selected</cfif>><cf_get_lang no='401.Toplu Fat Dahil'></option>
										<option value="0" <cfif listfind(attributes.is_multi,"0",',')>selected</cfif>><cf_get_lang no='402.Toplu Fat Dahil Degil'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<div class="col col-12 col-xs-12">
									<select name="is_prov" id="is_prov" multiple style="height:40px;">
										<option value="1" <cfif listfind(attributes.is_prov,"1",',')>selected</cfif>><cf_get_lang no='407.Provizyon Olusturuldu'></option>
										<option value="0" <cfif listfind(attributes.is_prov,"0",',')>selected</cfif>><cf_get_lang no='413.Provizyon Olusturulmadi'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<div class="col col-12 col-xs-12">
									<select name="is_group" id="is_paid" multiple style="height:40px;">
										<option value="1" <cfif listfind(attributes.is_group,"1",',')>selected</cfif>><cf_get_lang no='2075.Grup Fat Dahil'></option>
										<option value="0" <cfif listfind(attributes.is_group,"0",',')>selected</cfif>><cf_get_lang_main no='2651.Grup Fat Dahil Deg'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<div class="col col-12 col-xs-12">
									<select name="is_paid" id="is_paid" multiple style="height:40px;">
										<option value="1" <cfif listfind(attributes.is_paid,"1",',')>selected</cfif>><cf_get_lang no='415.dendi'></option>
										<option value="0" <cfif listfind(attributes.is_paid,"0",',')>selected</cfif>><cf_get_lang no='418.denmedi'></option>
									</select>
								</div>
							</div>
						</div>					
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<div class="col col-12 col-xs-12">
							<div class="form-group">
								<div class="col col-12 col-xs-12">
									<select name="is_billed" id="is_billed" multiple style="height:40px;">
										<option value="1" <cfif listfind(attributes.is_billed,"1",',')>selected</cfif>><cf_get_lang no='404.Faturalandi'></option>
										<option value="0" <cfif listfind(attributes.is_billed,"0",',')>selected</cfif>><cf_get_lang no='405.Faturalanmadi'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='245.Ürün'></label>
								<div class="col col-9 col-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_id) and len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
										<input type="text" name="product_name" id="product_name" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" style="width:120px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','form','3','250');">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=form.product_id&field_name=form.product_name&keyword='+encodeURIComponent(document.form.product_name.value),'list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='45.Müşteri'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="company_id1" id="company_id1" value="<cfif isdefined("attributes.company_id1")><cfoutput>#attributes.company_id1#</cfoutput></cfif>">
										<input type="hidden" name="consumer_id1" id="consumer_id1" value="<cfif isdefined("attributes.consumer_id1")><cfoutput>#attributes.consumer_id1#</cfoutput></cfif>">
										<input type="hidden" name="partner_id1" id="partner_id1" value="<cfif isdefined("attributes.partner_id1")><cfoutput>#attributes.partner_id1#</cfoutput></cfif>">
										<input type="hidden" name="member_type1" id="member_type1" value="<cfif isdefined("attributes.member_type1")><cfoutput>#attributes.member_type1#</cfoutput></cfif>">
										<input name="member_name1"  type="text" id="member_name1" onfocus="AutoComplete_Create('member_name1','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,MEMBER_TYPE','partner_id1,consumer_id1,member_type','form','3','250');" value="<cfif isdefined("attributes.member_name1") and len(attributes.member_name1)><cfoutput>#attributes.member_name1#</cfoutput></cfif>" autocomplete="off">
										<cfset str_linke_ait1="field_comp_id=form.company_id1&field_partner=form.partner_id1&field_consumer=form.consumer_id1&field_comp_name=form.member_name1&field_type=form.member_type1">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&<cfoutput>#str_linke_ait1#</cfoutput>&select_list=2,3','list','popup_list_all_pars');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang no="439.Fatura Şirketi"></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
										<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id")><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
										<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
										<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
										<input name="member_name" type="text" id="member_name" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,PARTNER_ID,CONSUMER_ID,MEMBER_TYPE','company_id,partner_id,consumer_id,member_type','form','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
										<cfset str_linke_ait="field_partner=form.partner_id&field_consumer=form.consumer_id&field_comp_id=form.company_id&field_comp_name=form.member_name&field_name=form.member_name&field_type=form.member_type">
										<span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&<cfoutput>#str_linke_ait#</cfoutput>&select_list=2,3','list','popup_list_all_pars');"></span>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<div class="col col-12 col-xs-12">
							<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='1104.Ödeme Yöntemi'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="payment_type_id"  id="payment_type_id" value="<cfif isdefined("attributes.payment_type_id") and len(attributes.payment_type_id)><cfoutput>#attributes.payment_type_id#</cfoutput></cfif>">
										<input type="hidden" name="payment_type_creditcard_id" id="payment_type_creditcard_id" value="<cfif isdefined("attributes.payment_type_creditcard_id") and len(attributes.payment_type_creditcard_id)><cfoutput>#attributes.payment_type_creditcard_id#</cfoutput></cfif>">
										<input type="text" name="payment_type"  id="payment_type"   value="<cfif isdefined("attributes.payment_type") and len(attributes.payment_type)><cfoutput>#attributes.payment_type#</cfoutput></cfif>" onfocus = "AutoComplete_Create('payment_type','PAYMETHOD','PAYMETHOD','get_paymethod_autocomplete','\'1,2\'','PAYMETHOD_ID,PAYMENT_TYPE_ID','payment_type_id,payment_type_creditcard_id')">
										<cfoutput>
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&payMethodTip=1,2&field_id=form.payment_type_id&field_name=form.payment_type&field_card_payment_name=form.payment_type&field_card_payment_id=form.payment_type_creditcard_id','list','popup_paymethods');"></span>				
										</cfoutput>
									</div>
								</div>
							</div>
							<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='1705.Abone no'></label>
								<div class="col col-12 col-xs-12">
								<cf_wrk_subscriptions subscription_id='#attributes.subscription_id#' subscription_no='#attributes.subscription_no#' width_info='120' form_name='form' img_info='plus_thin'>
								</div>
							</div>
							<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='344.Durum'></label>
								<div class="col col-12 col-xs-12">
									<select name="is_active" id="is_active">
										<option value="0" <cfif isdefined("attributes.is_active") and attributes.is_active eq 0>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
										<option value="1"<cfif isdefined("attributes.is_active") and attributes.is_active eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
										<option value="2" <cfif isdefined("attributes.is_active") and attributes.is_active eq 2>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang no='1403.Abone Durum'></label>
								<div class="col col-12 col-xs-12">
									<select name="status" id="status">
										<option value="1" <cfif isdefined("attributes.status") and attributes.status eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
										<option value="0" <cfif isdefined("attributes.status") and attributes.status eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
										<option value="2" <cfif isdefined("attributes.status") and attributes.status eq 2 >selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='34779.Referans Müşteri'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="ref_company_id" id="ref_company_id" value="<cfif isdefined("attributes.ref_company_id")><cfoutput>#attributes.ref_company_id#</cfoutput></cfif>">
										<input type="hidden" name="ref_consumer_id" id="ref_consumer_id" value="<cfif isdefined("attributes.ref_consumer_id")><cfoutput>#attributes.ref_consumer_id#</cfoutput></cfif>">
										<input type="hidden" name="ref_partner_id" id="ref_partner_id" value="<cfif isdefined("attributes.ref_partner_id")><cfoutput>#attributes.ref_partner_id#</cfoutput></cfif>">
										<input type="hidden" name="ref_member_type" id="ref_member_type" value="<cfif isdefined("attributes.ref_member_type")><cfoutput>#attributes.ref_member_type#</cfoutput></cfif>">
										<input name="ref_member_name"  type="text" id="ref_member_name" onfocus="AutoComplete_Create('ref_member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,MEMBER_TYPE','ref_company_id,ref_consumer_id,ref_member_type','form','3','250');" value="<cfif isdefined("attributes.ref_member_name") and len(attributes.ref_member_name)><cfoutput>#attributes.ref_member_name#</cfoutput></cfif>" autocomplete="off">
										<cfset str_linke_ait1="field_comp_id=form.ref_company_id&field_partner=form.ref_partner_id&field_consumer=form.ref_consumer_id&field_comp_name=form.ref_member_name&field_type=form.ref_member_type">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&<cfoutput>#str_linke_ait1#</cfoutput>&select_list=2,3','list','popup_list_all_pars');"></span>
									</div>
								</div>
							</div>
						</div>					
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<div class="col col-12 col-xs-12">
							<div class="form-group">
								<label class="col col-12 col-xs-12 "><cf_get_lang no='1364.Abone Kategorisi'></label>
								<div class="col col-12 col-xs-12">
									<select name="subscription_type" id="subscription_type" multiple>
									<cfoutput query="get_subscription_type">
										<option value="#subscription_type_id#" <cfif listfind(attributes.subscription_type,subscription_type_id,',')>selected</cfif>>#subscription_type#</option>
									</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group">
								<cfif session.ep.our_company_info.is_efatura>
										<label class="col col-12 col-xs-12"><cf_get_lang_main no="2075.E-Fatura"></label>
									<div class="col col-12 col-xs-12">
										<select name="use_efatura" id="use_efatura">
											<option value="">E-Fatura</option>
											<option value="1" <cfif attributes.use_efatura eq 1>selected="selected"</cfif>><cf_get_lang_main no='1695.Kullanıyor'></option>
											<option value="0" <cfif attributes.use_efatura eq 0>selected="selected"</cfif>><cf_get_lang_main no='1696.Kullanmıyor'></option>
										</select>
									</div>
									<cfelse>
									<td colspan="2"></td>
								</cfif>
							</div>
							<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='1278.Tarih Aralığı'>*</label>
								<div class="col col-6">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent>
										<cfinput type="text" name="startdate" style="width:65px;" value="#attributes.startdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
										<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
									</div>
								</div>
								<div class="col col-6">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
										<cfinput type="text" name="finishdate" style="width:65px;" value="#attributes.finishdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
										<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="col col-12 col-xs-12" id="roles_info" colspan="2" <cfif isDefined("attributes.is_show_member_team") and attributes.is_show_member_team eq 1>style="display:'';"<cfelse>style="display:none;"</cfif>>
									<select name="member_team_roles" id="member_team_roles">
										<option value="">Rol</option>
										<cfoutput query="get_roles">
											<option value="#project_roles_id#" <cfif Len(attributes.member_team_roles) and attributes.member_team_roles eq project_roles_id>selected</cfif>>#project_roles#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group">
								<div class="col col-12 col-xs-12" id="period_info" colspan="2" <cfif isDefined("attributes.is_show_paid") and attributes.is_show_paid eq 1>style="display:'';"<cfelse>style="display:none;"</cfif>>
										<select name="period_id" id="period_id">
										<cfoutput query="get_period">
											<option value="#period_id#-#period_year#" <cfif Len(attributes.period_id) and attributes.period_id eq "#period_id#-#period_year#">selected</cfif>>#period#</option>
										</cfoutput>
										</select>
								</div>
							</div>
							
							<div class="form-group">
								<div class="col col-12 col-xs-12">
									<label><cf_get_lang no='2072.Kur Bilgisi Olanlar'><input type="checkbox" name="is_show_curr" id="is_show_curr" value="1" <cfif isDefined("attributes.is_show_curr") and attributes.is_show_curr eq 1>checked</cfif>>
									</label>
									<label><cf_get_lang no='2071.Üye Ekibi Gelsin'><input type="checkbox" name="is_show_member_team" id="is_show_member_team" value="1" onclick="gizle_goster(roles_info);" <cfif isDefined("attributes.is_show_member_team") and attributes.is_show_member_team eq 1>checked</cfif>>
									</label>
									<label><cf_get_lang dictionary_id='872.Tahsilat İlişkisi Kopanlar'><input type="checkbox" name="is_show_paid" id="is_show_paid" value="1" onclick="gizle_goster(period_info);" <cfif isDefined("attributes.is_show_paid") and attributes.is_show_paid eq 1>checked</cfif>>
									</label>
								</div>
							</div>
						</div>
					</div>		
				</div>
			</div>
			<div class="row ReportContentBorder">
				<div class="ReportContentFooter">
					<label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>	
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
						<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1 >
								<cfinput type="text" name="maxrows" value="#session.ep.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
						<cfelse>
							<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1 >
								<cfinput type="text" name="maxrows" value="#session.ep.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;" onKeyUp="isNumber(this)">
							</cfif>
					</cfif>
					<cfsavecontent variable="message"><cf_get_lang_main no ='499.alistir'></cfsavecontent>
					<input type="hidden" value="1" name="form_varmi" id="form_varmi">
					<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'  insert_info='#message#'>
				</div>
			</div>
		</div>
	</div>
</cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename="subscriptiob_payment_plan_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-16">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.form_varmi")>
<cf_report_list>
    <cfset col_ = 26>
		<thead>
            <tr> 
                <th><cf_get_lang_main no='75.No'></th>
                <th><cf_get_lang_main no='1420.abone'><cf_get_lang_main no='75.No'></th>
                <th><cf_get_lang_main no='246.üye'></th>
                <th><cf_get_lang dictionary_id='41103.Fatura Şirketi'></th>
				<cfif isDefined("attributes.is_show_member_team") and attributes.is_show_member_team eq 1>
					<th><cf_get_lang dictionary_id='30564.Üye Ekibi'></th>
                    <cfset col_++>
				</cfif>
				<th><cf_get_lang dictionary_id='34779.Referans Müşteri'></th>
                <th><cf_get_lang_main no='1439.Odeme Tarihi'></th>
				<th><cf_get_lang_main no='336.İptal Tarihi'></th>
                <th><cf_get_lang dictionary_id='60559.Kurulum Tarihi'></th>
                <th><cf_get_lang_main no='217.Aiklama'></th>
                <th><cf_get_lang_main no='70.Aşama'></th>
                <th><cf_get_lang_main no='1104.Odeme Yontemi'></th>
                <th><cf_get_lang_main no='224.Birim'></th>
                <th><cf_get_lang_main no='223.Miktar'></th>
                <th><cf_get_lang_main no='261.Tutar'></th>
                <th><cf_get_lang_main no='227.Kdv'></th>
                <th><cf_get_lang_main no='758.Satır Toplam'></th>
                <th><cf_get_lang_main no='229.İskonto'> %</th>
                <th><cf_get_lang_main no='976.İskonto Tutar'></th>
                <th><cf_get_lang no='432.Net Satir Toplam'></th>
                <th><cf_get_lang_main no='767.Kdvli Toplam'></th>
                <th><cf_get_lang_main no="77.Para Birimi"></th>
                <th><cf_get_lang_main no="236.Kur"></th>
 				<th><cf_get_lang dictionary_id='937.GF'></th>
                <th><cf_get_lang dictionary_id='938.TF'></th>
                <th><cf_get_lang no='404.Faturalandi'></th>
                <th><cf_get_lang dictionary_id='939.TP'></th>
                <th><cf_get_lang no='415.dendi'></th>
            </tr>
        </thead>
		<cfif GET_SUBS_PAY_PLAN.recordcount>				
            <tbody>
			<cfoutput query="GET_SUBS_PAY_PLAN" group="MEMBER_ID">
				<tr>
					<td>#rownum#</td>
					<td>
						<cfif type_ eq 1>
							#SUBSCRIPTION_NO#
						<cfelse>
							<a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#SUBSCRIPTION_ID#"  target="_blank">#SUBSCRIPTION_NO#</a>
						</cfif>
					</td>	
					<td>
						<cfif len(COMPANY_ID)>
							<cfif type_ eq 1>
								#FULLNAME#
							<cfelse>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','medium');" >#FULLNAME#</a>							
							</cfif>
						<cfelseif len(CONSUMER_ID)>		
							<cfif type_ eq 1>
								#CONSUMER_NAME# #CONSUMER_SURNAME#							
							<cfelse>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#','medium');" >#CONSUMER_NAME# #CONSUMER_SURNAME#</a>							
							</cfif>		
						</cfif>
					</td>
                    <td>
                    	<cfif len(INVOICE_COMPANY_ID)>
							<cfif type_ eq 1>
								#INVOICE_COMPANY#
							<cfelse>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#INVOICE_COMPANY_ID#','medium');" >#INVOICE_COMPANY#</a>							
							</cfif>
						<cfelseif len(INVOICE_CONSUMER_ID)>		
							<cfif type_ eq 1>
								#INVOICE_COMPANY#							
							<cfelse>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#INVOICE_CONSUMER_ID#','medium');" >#INVOICE_COMPANY#</a>							
							</cfif>		
						</cfif>
                    </td>
					<cfif isDefined("attributes.is_show_member_team") and attributes.is_show_member_team eq 1>
						<td>
						<cfoutput><!--- OUTPUT GROUP KULLANILIYOR --->
							<cfif Len(company_id)>
								#comp_emp_name#
							<cfelseif Len(consumer_id)>
								#cons_emp_name#
							</cfif>
							<br />
						</cfoutput>
						</td>
					</cfif>
					<td>
                    	<cfif len(REF_COMPANY_ID)>
							<cfif type_ eq 1>
								#REF_COMPANY#
							<cfelse>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#REF_COMPANY_ID#','medium');" >#REF_COMPANY#</a>							
							</cfif>
						<cfelseif len(REF_CONSUMER_ID)>		
							<cfif type_ eq 1>
								#REF_COMPANY#							
							<cfelse>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#REF_CONSUMER_ID#','medium');" >#REF_COMPANY#</a>							
							</cfif>		
						</cfif>
                    </td>
					<td format="date">#dateformat(PAYMENT_DATE,dateformat_style)#</td>
                    <td format="date">#dateformat(FINISH_DATE,dateformat_style)#</td> 
                    <td format="date">#dateformat(MONTAGE_DATE,dateformat_style)#</td>
					<td>#DETAIL#</td>
                    <td >#STAGE#</td>
					<td>
						<cfif len(PAYMETHOD_ID)>
							#PAYMETHOD# 
						<cfelseif len(CARD_PAYMETHOD_ID)>				
							#CARD_NO#
						</cfif>
					</td>
                    <td>#UNIT#</td>
					<td style="text-align:right;" format="numeric">#TlFormat(QUANTITY)#</td>
                    <td style="text-align:right;" format="numeric">#TlFormat(Amount)#</td>
                    <td style="text-align:right;" format="numeric">#TlFormat(TAX)#</td>
                    <td style="text-align:right;" format="numeric">#TlFormat(ROW_TOTAL)#</td>
                    <td style="text-align:right;" format="numeric">#TlFormat(DISCOUNT)#</td>
                    <td style="text-align:right;" format="numeric">#TlFormat(DISCOUNT_AMOUNT)#</td>
                    <td style="text-align:right;" format="numeric">#TlFormat(ROW_NET_TOTAL)#</td>
                    <td style="text-align:right;" format="numeric">#TlFormat((TAX*ROW_NET_TOTAL/100)+ROW_NET_TOTAL)#</td>
					<td>#money_type#</td>
                    <td style="text-align:right;" format="numeric">#TlFormat(rate,4)#</td>
					<td style="text-align:center;"><cfif IS_GROUP_INVOICE eq 1>*</cfif></td>
					<td style="text-align:center;"><cfif IS_COLLECTED_INVOICE eq 1>*</cfif></td>
					<td style="text-align:center;"><cfif IS_BILLED eq 1>*</cfif></td>
					<td style="text-align:center;"><cfif IS_COLLECTED_PROVISION eq 1>*</cfif></td>
					<td style="text-align:center;"><cfif IS_PAID eq 1>*</cfif></td>
				</tr>
			</cfoutput>
            </tbody>
        <cfelse>
            <tr>
            	<td colspan="30"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>

</cf_report_list>
<cfset adres = "">
<cfif GET_SUBS_PAY_PLAN.recordcount and (attributes.maxrows lt attributes.totalrecords)>
	<cfset adres = "#attributes.fuseaction#&form_varmi=1">	
	<cfif isDefined("attributes.startdate") and len(attributes.startdate)>
		<cfset adres = "#adres#&startdate=#attributes.startdate#">
	</cfif>
	<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)>
		<cfset adres = "#adres#&finishdate=#attributes.finishdate#">
	</cfif>
	<cfif isDefined("attributes.subscription_type") and len(attributes.subscription_type)>
		<cfset adres = "#adres#&subscription_type=#attributes.subscription_type#">
	</cfif>
	<cfif isDefined("attributes.is_multi") and len(attributes.is_multi)>
		<cfset adres = "#adres#&is_multi=#attributes.is_multi#">
	</cfif>
	<cfif isDefined("attributes.is_billed") and len(attributes.is_billed)>
		<cfset adres = "#adres#&is_billed=#attributes.is_billed#">
	</cfif>
	<cfif isDefined("attributes.is_paid") and len(attributes.is_paid)>
		<cfset adres = "#adres#&is_paid=#attributes.is_paid#">
	</cfif>
	<cfif isDefined("attributes.is_prov") and len(attributes.is_prov)>
		<cfset adres = "#adres#&is_prov=#attributes.is_prov#">
	</cfif>
    <cfif isDefined("attributes.is_group") and len(attributes.is_group)>
		<cfset adres = "#adres#&is_group=#attributes.is_group#">
	</cfif>
	<cfif isdefined("attributes.product_id") and len(attributes.product_id) and isdefined("attributes.product_name") and len(attributes.product_name)>
		<cfset adres = "#adres#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
	</cfif>
    <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) >
		<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#">
	</cfif>
    <cfif isdefined("attributes.partner_id") and len(attributes.partner_id) >
		<cfset adres = "#adres#&partner_id=#attributes.partner_id#">
	</cfif>
     <cfif isdefined("attributes.company_id") and len(attributes.company_id) >
		<cfset adres = "#adres#&company_id=#attributes.company_id#">
	</cfif>
    <cfif isdefined("attributes.member_type") and len(attributes.member_type) >
		<cfset adres = "#adres#&member_type=#attributes.member_type#">
	</cfif>
     <cfif isdefined("attributes.member_name") and len(attributes.member_name) >
		<cfset adres = "#adres#&member_name=#attributes.member_name#">
	</cfif>
    <cfif isdefined("attributes.consumer_id1") and len(attributes.consumer_id1) >
		<cfset adres = "#adres#&consumer_id1=#attributes.consumer_id1#">
	</cfif>
    <cfif isdefined("attributes.partner_id1") and len(attributes.partner_id1) >
		<cfset adres = "#adres#&partner_id1=#attributes.partner_id1#">
	</cfif>
    <cfif isdefined("attributes.member_type1") and len(attributes.member_type1) >
		<cfset adres = "#adres#&member_type1=#attributes.member_type1#">
	</cfif>
    <cfif isdefined("attributes.member_name1") and len(attributes.member_name1) >

		<cfset adres = "#adres#&member_name1=#attributes.member_name1#">
	</cfif>

	<cfif isdefined("attributes.ref_consumer_id") and len(attributes.ref_consumer_id) >
		<cfset adres = "#adres#&ref_consumer_id=#attributes.ref_consumer_id#">
	</cfif>
    <cfif isdefined("attributes.ref_partner_id") and len(attributes.ref_partner_id) >
		<cfset adres = "#adres#&ref_partner_id=#attributes.ref_partner_id#">
	</cfif>
     <cfif isdefined("attributes.ref_company_id") and len(attributes.ref_company_id) >
		<cfset adres = "#adres#&ref_company_id=#attributes.ref_company_id#">
	</cfif>
    <cfif isdefined("attributes.ref_member_type") and len(attributes.ref_member_type) >
		<cfset adres = "#adres#&ref_member_type=#attributes.ref_member_type#">
	</cfif>
     <cfif isdefined("attributes.ref_member_name") and len(attributes.ref_member_name) >
		<cfset adres = "#adres#&ref_member_name=#attributes.ref_member_name#">
	</cfif>

    <cfif isdefined("attributes.is_active") and len(attributes.is_active) >
		<cfset adres = "#adres#&is_active=#attributes.is_active#">
	</cfif>
    <cfif isdefined("attributes.payment_type_id") and len(attributes.payment_type_id) >
		<cfset adres = "#adres#&payment_type_id=#attributes.payment_type_id#">
	</cfif>
    <cfif isdefined("attributes.payment_type_creditcard_id") and len(attributes.payment_type_creditcard_id) >
		<cfset adres = "#adres#&payment_type_creditcard_id=#attributes.payment_type_creditcard_id#">
	</cfif>
    <cfif isdefined("attributes.payment_type") and len(attributes.payment_type) >
		<cfset adres = "#adres#&payment_type=#attributes.payment_type#">
	</cfif>
    <cfif isdefined("attributes.subscription_no") and len(attributes.subscription_no) >
		<cfset adres = "#adres#&subscription_no=#attributes.subscription_no#">
	</cfif>
     <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) >
		<cfset adres = "#adres#&subscription_id=#attributes.subscription_id#">
	</cfif>
    <cfif isdefined("attributes.status") and len(attributes.status) >
		<cfset adres = "#adres#&status=#attributes.status#">
	</cfif>
    <cfif isdefined("attributes.is_show_member_team") and attributes.is_show_member_team eq 1>
		<cfset adres = "#adres#&is_show_member_team=#attributes.is_show_member_team#">
	</cfif>
	<cfif Len(attributes.member_team_roles)>
		<cfset adres = "#adres#&member_team_roles=#attributes.member_team_roles#">
	</cfif>
	<cfif isdefined("attributes.is_show_paid") and attributes.is_show_paid eq 1>
		<cfset adres = "#adres#&is_show_paid=#attributes.is_show_paid#">
	</cfif>
	<cfif isdefined("attributes.is_show_curr") and attributes.is_show_curr eq 1>
		<cfset adres = "#adres#&is_show_curr=#attributes.is_show_curr#">
	</cfif>
	<cfif Len(attributes.period_id)>
		<cfset adres = "#adres#&period_id=#attributes.period_id#">
	</cfif>
	<cfif isdefined("attributes.use_efatura") and len(attributes.use_efatura)>
		<cfset adres = "#adres#&use_efatura=#attributes.use_efatura#">
	</cfif> 
	<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#"></td>
</cfif>
</cfif>
</cfprocessingdirective>
<script>
	function control() {
		if ((document.form.startdate.value != '') && (document.form.finishdate.value != '') &&
	    !date_check(form.startdate,form.finishdate,"<cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if(document.form.is_excel.checked==false)
			{
				document.form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.subscription_payment_plan_report"
				return true;
			}
		else 
			document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_subscription_payment_plan_report</cfoutput>"
		
	}
</script>