<cf_get_lang_set module_name = "salesplan"> 
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.plan_year" default="">
    <cfparam name="attributes.process_stage_type" default="">
    <cfparam name="attributes.sale_scope" default="">
    <cfparam name="attributes.is_form_submitted" default="">
    <cfparam name="attributes.sales_county" default="">
	<cfif isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
		<cfset form_varmi = 1>
	<cfelse>
		<cfset form_varmi = 0>
	</cfif>
	<cfif isDefined("attributes.is_form_submitted")>
        <cfquery name="get_sales_quota" datasource="#dsn#">
            SELECT
                SQG.*,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                PTR.STAGE,
                SZ.SZ_NAME,
                SZ.SZ_ID
            FROM
                SALES_QUOTES_GROUP SQG
                LEFT JOIN EMPLOYEES E ON  SQG.PLANNER_EMP_ID = E.EMPLOYEE_ID
                LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = SQG.PROCESS_STAGE
                LEFT JOIN SALES_ZONES SZ ON SZ.SZ_ID = SQG.SALES_ZONE_ID
            WHERE 
                SQG.IS_PLAN = 1
                <cfif len(attributes.keyword)>
                    AND SQG.PAPER_NO LIKE '%#attributes.keyword#%'
                </cfif>	
                <cfif len(attributes.process_stage_type)>
                    AND SQG.PROCESS_STAGE = #attributes.process_stage_type#
                </cfif>
                <cfif len(attributes.plan_year)>
                    AND SQG.QUOTE_YEAR = #attributes.plan_year#
                </cfif>
                <cfif len(attributes.sale_scope)>
                    AND SQG.QUOTE_TYPE= #attributes.sale_scope#
                </cfif>
                <cfif isdefined('attributes.sales_county') and len(attributes.sales_county)>
                    AND SQG.SALES_ZONE_ID = #attributes.sales_county#
                </cfif>
            ORDER BY
                SQG.PLAN_DATE
        </cfquery>
    <cfelse>
    	<cfset get_sales_quota.recordcount = 0>
    </cfif>
    <cfquery name="get_sz" datasource="#dsn#">
		SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
	</cfquery>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default="#get_sales_quota.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfquery name="get_stage" datasource="#dsn#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%salesplan.list_sales_plan_quotas%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
</cfif>
<cfif isdefined("attributes.event") and ListFindNoCase('add,upd',attributes.event)>
    <cfquery name="get_sales_zone" datasource="#dsn#">	
        SELECT * FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
    </cfquery>
    <cfquery name="get_company_cat" datasource="#dsn#">	
        SELECT * FROM COMPANY_CAT ORDER BY COMPANYCAT
    </cfquery>
	<cfif attributes.event is 'add'> 
        <cfquery name="get_money" datasource="#dsn2#">
            SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY ORDER BY MONEY_ID
        </cfquery>          
        <cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
        <cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
        <cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
        <cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
        <cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
        <cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
        <cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
        <cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
        <cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
        <cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
        <cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
        <cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
        <cfset ay_list = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
        <cfquery name="get_standart_process_money" datasource="#dsn#">
            SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
        </cfquery>
	</cfif>
    <cfif attributes.event is 'upd'>   	
        <cfquery name="get_plan" datasource="#dsn#">
            SELECT * FROM SALES_QUOTES_GROUP WHERE SALES_QUOTE_ID = #attributes.plan_id#
        </cfquery>
		<cfquery name="get_plan_money" datasource="#dsn#">
        	SELECT
            	<cfif session.ep.period_year gte 2009>
                	CASE WHEN MONEY_TYPE ='YTL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE MONEY_TYPE END AS MONEY_TYPE,
            	<cfelse>
                	CASE WHEN MONEY_TYPE ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE MONEY_TYPE END AS MONEY_TYPE,
            	</cfif>
            	ACTION_ID,RATE2,RATE1,IS_SELECTED
        	FROM
            	SALES_QUOTES_GROUP_MONEY
        	WHERE
            	ACTION_ID = #attributes.plan_id#
        </cfquery>
        <cfif not get_plan_money.recordcount>
        	<cfquery name="get_plan_money" datasource="#dsn2#">
            	SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY
        	</cfquery>
            <cfquery name="get_plan_rows" datasource="#dsn#">
                SELECT * FROM SALES_QUOTES_GROUP_ROWS WHERE SALES_QUOTE_ID = #attributes.plan_id# ORDER BY SALES_QUOTE_ROW_ID
            </cfquery>
        </cfif>
        <cfquery name="get_plan_rows" datasource="#dsn#">
            SELECT * FROM SALES_QUOTES_GROUP_ROWS WHERE SALES_QUOTE_ID = #attributes.plan_id# ORDER BY SALES_QUOTE_ROW_ID
        </cfquery>
        <cfset ds_alias = '#dsn_alias#'>
		<cfif get_plan.quote_type eq 1>
            <cfset column_name = 'SUB_ZONE_ID'>
            <cfset column_name2 = 'SZ_ID'>
            <cfset column_name3 = 'SZ_NAME'>
            <cfset table_name = 'SALES_ZONES'>
        <cfelseif get_plan.quote_type eq 2>
            <cfset column_name = 'SUB_BRANCH_ID'>
            <cfset column_name2 = 'BRANCH_ID'>
            <cfset column_name3 = 'BRANCH_NAME'>
            <cfset table_name = 'BRANCH'>
        <cfelseif get_plan.quote_type eq 3>
            <cfset column_name = 'TEAM_ID'>
            <cfset column_name2 = 'TEAM_ID'>
            <cfset column_name3 = 'TEAM_NAME'>
            <cfset table_name = 'SALES_ZONES_TEAM'>
        <cfelseif get_plan.quote_type eq 4>
            <cfset column_name = 'IMS_ID'>
            <cfset column_name2 = 'IMS_CODE_ID'>
            <cfset column_name3 = 'IMS_CODE_NAME'>
            <cfset table_name = 'SETUP_IMS_CODE'>
        <cfelseif get_plan.quote_type eq 5>
            <cfset column_name = 'EMPLOYEE_ID'>
            <cfset column_name2 = 'EMPLOYEE_ID'>
            <cfset column_name3 = 'EMPLOYEE_NAME'>
            <cfset column_name4 = 'EMPLOYEE_SURNAME'>
            <cfset table_name = 'EMPLOYEES'>
        <cfelseif get_plan.quote_type eq 6>
            <cfset column_name = 'CUSTOMER_COMP_ID'>
            <cfset column_name2 = 'COMPANY_ID'>
            <cfset column_name3 = 'FULLNAME'>
            <cfset table_name = 'COMPANY'>
        <cfelseif get_plan.quote_type eq 7>
            <cfset column_name = 'PRODUCTCAT_ID'>
            <cfset column_name2 = 'PRODUCT_CATID'>
            <cfset column_name3 = 'PRODUCT_CAT'>
            <cfset table_name = 'PRODUCT_CAT'>
            <cfset ds_alias = '#dsn3_alias#'>
        <cfelseif get_plan.quote_type eq 8>
            <cfset column_name = 'BRAND_ID'>
            <cfset column_name2 = 'BRAND_ID'>
            <cfset column_name3 = 'BRAND_NAME'>
            <cfset table_name = 'PRODUCT_BRANDS'>
            <cfset ds_alias = '#dsn3_alias#'>
        <cfelseif get_plan.quote_type eq 9>
            <cfset column_name = 'COMPANYCAT_ID'>
            <cfset column_name2 = 'COMPANYCAT_ID'>
            <cfset column_name3 = 'COMPANYCAT'>
            <cfset table_name = 'COMPANY_CAT'>
        </cfif>
        <cfquery name="get_plan_rows2" datasource="#dsn#">
            SELECT DISTINCT SQR.#column_name#,NT.#column_name3# AS SCOPE_NAME<cfif isdefined("column_name4")>,NT.#column_name4# AS SCOPE_NAME2<cfelse>,''  AS SCOPE_NAME2</cfif>,NT.#column_name2# AS SCOPE_ID FROM SALES_QUOTES_GROUP_ROWS SQR,#ds_alias#.#table_name# NT WHERE  NT.#column_name2# =SQR.#column_name# AND SALES_QUOTE_ID = #attributes.plan_id# ORDER BY NT.#column_name3#	
        </cfquery>
        <cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
        <cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
        <cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
        <cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
        <cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
        <cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
        <cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
        <cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
        <cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
        <cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
        <cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
        <cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
        <cfset ay_list = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
        <cfquery name="get_standart_process_money" datasource="#dsn#">
            SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
        </cfquery>        
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
    		document.list_quota.keyword.focus();
		});	
	</cfif>
	<cfif isdefined("attributes.event") and listFindNoCase("add,upd",attributes.event)>
		function sil(sy)
			{
				var my_element=eval("document.sales_plan.row_kontrol"+sy);
				my_element.value=0;
				var my_element=eval("frm_row"+sy);
				my_element.style.display="none";
				toplam_hesapla();
			}
		function pencere_ac_company(no)
		{
			no = row_count + 1;
			add_row(6,'','');
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=7</cfoutput>&field_comp_name=sales_plan.plan_scope'+ no +'&field_comp_id=sales_plan.plan_scope_id'+ no,'list','popup_list_pars');
		}
		function change_scope()
		{
			if(document.sales_plan.sale_scope.value != '')
			{
				row_count = 0;
				document.sales_plan.record_num.value = 0;
				var oTable=document.getElementById("table1");
				console.log(oTable.rows);
				while(oTable.rows.length>0)
					oTable.deleteRow(oTable.rows.length-1);
			}
			$('#total_amount').val(commaSplit(0));
			document.sales_plan.other_total_amount.value = commaSplit(0);
			document.sales_plan.satir_total_stytem.value = commaSplit(0);
			document.sales_plan.satir_total_stytem2.value = commaSplit(0);
			for(i=1;i<=<cfoutput>#listlen(ay_list)#</cfoutput>;i++)
				{
					eval('document.sales_plan.total_stytem'+i).value = commaSplit(0);
					eval('document.sales_plan.total_stytem2'+i).value = commaSplit(0);
					eval('document.sales_plan.set_net_kar_'+i).value = commaSplit(0);
					eval('document.sales_plan.set_net_prim_'+i).value = commaSplit(0);
				}
			if(document.sales_plan.sale_scope.value == 1)//Satış Bölgesi Bazında
			{
				$('#sz_1').addClass("wrk-hide");			
				$('#sz_2').addClass("wrk-hide");
				$('#sz_3').addClass("wrk-hide");
				$('#sz_4').addClass("wrk-hide");
				$('#sz_5').addClass("wrk-hide");
				document.sales_plan.zone_id.value = '';
				var zone_control = wrk_safe_query('slsp_zone_control','dsn');
				if(zone_control.recordcount > 0)
					document.getElementById('total_').style.display = '';
				else
					document.getElementById('total_').style.display = 'none';
				for(var j=0;j<zone_control.recordcount;j++)
				{
					<cfif isdefined("attributes.event") and attributes.event is 'add'>
						add_row(zone_control.SZ_ID[j],zone_control.SZ_NAME[j],document.sales_plan.sale_scope.value);
					<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
						add_row(zone_control.SZ_ID[j],zone_control.SZ_NAME[j]);
					</cfif>
				}
			}
			else if(document.sales_plan.sale_scope.value == 2)//Şube Bazında
			{
				$('#sz_1').addClass("wrk-hide");			
				$('#sz_2').addClass("wrk-hide");
				$('#sz_3').addClass("wrk-hide");
				$('#sz_4').addClass("wrk-hide");
				$('#sz_5').addClass("wrk-hide");
				document.sales_plan.zone_id.value = '';
				var branch_control = wrk_safe_query('slsp_branch_control','dsn');
				if(branch_control.recordcount > 0)
					document.getElementById('total_').style.display = '';
				else
					document.getElementById('total_').style.display = 'none';
				for(var j=0;j<branch_control.recordcount;j++)
				{
				<cfif isdefined("attributes.event") and attributes.event is 'add'>
					add_row(branch_control.BRANCH_ID[j],branch_control.BRANCH_NAME[j],document.sales_plan.sale_scope.value);
				<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
					add_row(branch_control.BRANCH_ID[j],branch_control.BRANCH_NAME[j]);
				</cfif>
				}
			}
			else if(document.sales_plan.sale_scope.value == 3)//Satış Takımı Bazında
			{
				$('#sz_1').removeClass("wrk-hide");			
				$('#sz_2').removeClass("wrk-hide");
				$('#sz_3').addClass("wrk-hide");
				$('#sz_4').addClass("wrk-hide");
				$('#sz_5').addClass("wrk-hide");
				if(document.sales_plan.zone_id.value != '')
				{
					var team_control = wrk_safe_query('slsp_team_control','dsn',0,document.sales_plan.zone_id.value);
					if(team_control.recordcount > 0)
						document.getElementById('total_').style.display = '';
					else
						document.getElementById('total_').style.display = 'none';
					
					for(var j=0;j<team_control.recordcount;j++)
					{
						<cfif isdefined("attributes.event") and attributes.event is 'add'>
							add_row(team_control.TEAM_ID[j],team_control.TEAM_NAME[j],document.sales_plan.sale_scope.value);
						<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
							add_row(team_control.TEAM_ID[j],team_control.TEAM_NAME[j],'');
						</cfif>
					}
				}
				else
				{
					alert("<cf_get_lang no ='169.Satış Takımları İçin Önce Satış Bölgesi Seçmelisiniz'> !");
					document.getElementById('total_').style.display = 'none';
				}
			}
			else if(document.sales_plan.sale_scope.value == 4)//Mikro Bölge Bazında
			{
				$('#sz_1').removeClass("wrk-hide");			
				$('#sz_2').removeClass("wrk-hide");
				$('#sz_3').addClass("wrk-hide");
				$('#sz_4').addClass("wrk-hide");
				$('#sz_5').addClass("wrk-hide");	
				if(document.sales_plan.zone_id.value != '')
				{
					var ims_control = wrk_safe_query('slsp_ims_control','dsn',0,document.sales_plan.zone_id.value);
					if(ims_control.recordcount > 0)
						document.getElementById('total_').style.display = '';
					else
						document.getElementById('total_').style.display = 'none';
					for(var j=0;j<ims_control.recordcount;j++)
					{
						<cfif isdefined("attributes.event") and attributes.event is 'add'>
							add_row(ims_control.IMS_CODE_ID[j],ims_control.IMS_CODE_NAME[j],document.sales_plan.sale_scope.value);
						<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
							add_row(ims_control.IMS_CODE_ID[j],ims_control.IMS_CODE_NAME[j],''); 	
						</cfif>
					}
				}
				else
				{
					alert("<cf_get_lang no ='170.Mikro Bölge İçin Önce Satış Bölgesi Seçmelisiniz'> !");
					document.getElementById('total_').style.display = 'none';
				}
			}
			else if(document.sales_plan.sale_scope.value == 5)//Çalışan Bazında
			{
				$('#sz_1').removeClass("wrk-hide");			
				$('#sz_2').removeClass("wrk-hide");
				$('#sz_3').addClass("wrk-hide");
				$('#sz_4').addClass("wrk-hide");
				$('#sz_5').addClass("wrk-hide");
				if(document.sales_plan.zone_id.value != '')
				{
					
						var employee_control = wrk_safe_query('slsp_employee_control','dsn',0,document.sales_plan.zone_id.value);
				
					if(employee_control.recordcount > 0)
						document.getElementById('total_').style.display = '';
					else
						document.getElementById('total_').style.display = 'none';
					for(var j=0;j<employee_control.recordcount;j++)
					{
						<cfif isdefined("attributes.event") and attributes.event is 'add'>
							add_row(employee_control.EMPLOYEE_ID[j],employee_control.EMPLOYEE_NAME[j] +  ' ' + employee_control.EMPLOYEE_SURNAME[j],document.sales_plan.sale_scope.value);
						<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
							add_row(employee_control.EMPLOYEE_ID[j],employee_control.EMPLOYEE_NAME[j],employee_control.EMPLOYEE_SURNAME[j]);
						</cfif>
					}
				}
				else
				{
					alert("<cf_get_lang no ='171.Çalışanlar İçin Önce Satış Bölgesi Seçmelisiniz'>!");
					document.getElementById('total_').style.display = 'none';
				}
			}
			else if(document.sales_plan.sale_scope.value == 6)//Müşteri Bazında
			{
				$('#sz_1').removeClass("wrk-hide");			
				$('#sz_2').removeClass("wrk-hide");
				$('#sz_3').removeClass("wrk-hide");
				$('#sz_4').removeClass("wrk-hide");
				$('#sz_5').removeClass("wrk-hide");
				if(document.sales_plan.zone_id.value != '' || document.sales_plan.companycat_id.value != '')
				{
					if(document.sales_plan.zone_id.value != '' && document.sales_plan.companycat_id.value != '')//üye kategorisi ve satış bölgesi seçilmiş ise
					{
						var listParam = document.sales_plan.zone_id.value + "*" + document.sales_plan.companycat_id.value;
						var new_sql_company = 'slsp_company_control';
					}
					else if(document.sales_plan.zone_id.value != '' && document.sales_plan.companycat_id.value == '')//sadece satış bölgesi seçilmiş ise
					{
						var listParam = document.sales_plan.zone_id.value;
						var new_sql_company = 'slsp_company_control_2';
					}
					else if(document.sales_plan.zone_id.value == '' && document.sales_plan.companycat_id.value != '')//sadece üye kategorisi seçilmiş ise
					{
						var listParam = document.sales_plan.companycat_id.value;
						var new_sql_company = 'slsp_company_control_3';
					}
					var company_control = wrk_safe_query(new_sql_company,'dsn',0,listParam);
					if(company_control.recordcount > 0)
						document.getElementById('total_').style.display = '';
					else
						document.getElementById('total_').style.display = 'none';
					for(var j=0;j<company_control.recordcount;j++)
					{
						<cfif isdefined("attributes.event") and attributes.event is 'add'>
							add_row(company_control.COMPANY_ID[j],company_control.FULLNAME[j],document.sales_plan.sale_scope.value);
						<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
							add_row(company_control.COMPANY_ID[j],company_control.FULLNAME[j],'');
						</cfif>
					}
				}
				else
				{
					alert("<cf_get_lang no ='172.Müşteriler İçin Önce Satış Bölgesi veya Üye Kategorisi Seçmelisiniz'> !");
					document.getElementById('total_').style.display = 'none';
				}
			}
			else if(document.sales_plan.sale_scope.value == 7)//Ürün kategorisi Bazında
			{
				$('#sz_1').addClass("wrk-hide");			
				$('#sz_2').addClass("wrk-hide");
				$('#sz_3').addClass("wrk-hide");
				$('#sz_4').addClass("wrk-hide");
				$('#sz_5').addClass("wrk-hide");
				document.sales_plan.zone_id.value = '';
				<cfif isdefined("attributes.event") and attributes.event is 'add'>
					var product_cat_control = wrk_safe_query("slsp_product_cat_control_2",'dsn3',0,"<cfoutput>#dsn1_alias#</cfoutput>");
				<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
					var product_cat_control = wrk_safe_query('slsp_product_cat_control','dsn3',0,'<cfoutput>#dsn1_alias#</cfoutput>');
				</cfif>
				if(product_cat_control.recordcount > 0)
					document.getElementById('total_').style.display = '';
				else
					document.getElementById('total_').style.display = 'none';
				for(var j=0;j<product_cat_control.recordcount;j++)
				{
					<cfif isdefined("attributes.event") and attributes.event is 'add'>
						add_row(product_cat_control.PRODUCT_CATID[j],product_cat_control.PRODUCT_CAT[j],document.sales_plan.sale_scope.value);
					<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
						add_row(product_cat_control.PRODUCT_CATID[j],product_cat_control.PRODUCT_CAT[j]);
					</cfif>
				}
			}
			else if(document.sales_plan.sale_scope.value == 8)//Marka Bazında
			{
				$('#sz_1').addClass("wrk-hide");			
				$('#sz_2').addClass("wrk-hide");
				$('#sz_3').addClass("wrk-hide");
				$('#sz_4').addClass("wrk-hide");
				$('#sz_5').addClass("wrk-hide");
				document.sales_plan.zone_id.value = '';
					var brand_control = wrk_safe_query('slsp_brand_control_2','dsn3',0,'<cfoutput>#dsn1_alias#</cfoutput>');
				if(brand_control.recordcount > 0)
					document.getElementById('total_').style.display = '';
				else
					document.getElementById('total_').style.display = 'none';
				for(var j=0;j<brand_control.recordcount;j++)
				{
					<cfif isdefined("attributes.event") and attributes.event is 'add'> 
						add_row(brand_control.BRAND_ID[j],brand_control.BRAND_NAME[j],document.sales_plan.sale_scope.value);
					<cfelseif isdefined("attributes.event") and attributes.event is 'upd'> 
						add_row(brand_control.BRAND_ID[j],brand_control.BRAND_NAME[j]);
					</cfif>
				}
			}
			else if(document.sales_plan.sale_scope.value == 9)//Üye Kategorisi Bazında
			{
				$('#sz_1').addClass("wrk-hide");			
				$('#sz_2').addClass("wrk-hide");
				$('#sz_3').addClass("wrk-hide");
				$('#sz_4').addClass("wrk-hide");
				$('#sz_5').addClass("wrk-hide");
				document.sales_plan.zone_id.value = '';
				var comp_cat_control = wrk_safe_query('slsp_comp_cat_control','dsn');
				if(comp_cat_control.recordcount > 0)
					document.getElementById('total_').style.display = '';
				else
					document.getElementById('total_').style.display = 'none';
				for(var j=0;j<comp_cat_control.recordcount;j++)
				{
					<cfif isdefined("attributes.event") and attributes.event is 'add'>
						add_row(comp_cat_control.COMPANYCAT_ID[j],comp_cat_control.COMPANYCAT[j],document.sales_plan.sale_scope.value);
					<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>	
						add_row(comp_cat_control.COMPANYCAT_ID[j],comp_cat_control.COMPANYCAT[j]);	
					</cfif>
				}
			}
			<cfif isdefined("attributes.event") and attributes.event is 'upd'>
				toplam_hesapla();
			</cfif>
		}
		function son_deger_degis(row_no,month)
		{
			son_deger = eval("document.sales_plan.net_total" + month + "_" + row_no + ".value");
			son_deger = filterNum(son_deger);
			son_deger_other = eval("document.sales_plan.net_total_other" + month + "_" + row_no + ".value");
			son_deger_other = filterNum(son_deger_other);
		}
		function toplam_al(row_no,month)
		{
			gelen_satir_toplam = eval("document.sales_plan.satir_net_total_" + row_no).value;
			gelen_satir_toplam = filterNum(gelen_satir_toplam);
			gelen_input = eval("document.sales_plan.net_total" + month + "_" + row_no + ".value");
			gelen_input = filterNum(gelen_input);
			gelen_kolon_toplam = eval("document.sales_plan.total_stytem" + month).value;
			gelen_kolon_toplam = filterNum(gelen_kolon_toplam);
			son_toplam = document.sales_plan.satir_total_stytem.value;
			son_toplam = filterNum(son_toplam);
			
			son_toplam = (parseFloat(son_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
			gelen_kolon_toplam = (parseFloat(gelen_kolon_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
			gelen_satir_toplam = (parseFloat(gelen_satir_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
			gelen_input = commaSplit(gelen_input,2);
			gelen_satir_toplam = commaSplit(gelen_satir_toplam,2);
			gelen_kolon_toplam = commaSplit(gelen_kolon_toplam,2);
			son_toplam = commaSplit(son_toplam,2);
			
			eval("document.sales_plan.satir_net_total_" + row_no).value = gelen_satir_toplam;
			eval("document.sales_plan.total_stytem" + month).value = gelen_kolon_toplam;
			eval("document.sales_plan.net_total" + month + "_" + row_no).value = gelen_input;
			document.sales_plan.satir_total_stytem.value = son_toplam;
			document.sales_plan.total_amount.value = son_toplam;
			
			if('<cfoutput>#session.ep.money2#</cfoutput>' != '')
			{
				for(i=1;i<=document.sales_plan.kur_say.value;i++)
				{
					if(eval('document.sales_plan.hidden_rd_money_'+i).value == '<cfoutput>#session.ep.money2#</cfoutput>')
					{
						form_txt_rate2_ = filterNum(eval("document.sales_plan.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					}
				}
				eval('document.sales_plan.net_total_other'+month+'_'+row_no).value = commaSplit(filterNum(eval("document.sales_plan.net_total" + month + "_" + row_no).value)/form_txt_rate2_);
	
				gelen_satir_toplam_other = eval("document.sales_plan.satir_net_total_other_" + row_no).value;
				gelen_satir_toplam_other = filterNum(gelen_satir_toplam_other);
				gelen_input_other = eval("document.sales_plan.net_total_other" + month + "_" + row_no + ".value");
				gelen_input_other = filterNum(gelen_input_other);
				gelen_kolon_toplam_other = eval("document.sales_plan.total_stytem2" + month).value;
				gelen_kolon_toplam_other = filterNum(gelen_kolon_toplam_other);
				son_toplam_other = document.sales_plan.satir_total_stytem2.value;
				son_toplam_other = filterNum(son_toplam_other);
				
				son_toplam_other = (parseFloat(son_toplam_other) + parseFloat(gelen_input_other)) - parseFloat(son_deger_other);
				gelen_kolon_toplam_other = (parseFloat(gelen_kolon_toplam_other) + parseFloat(gelen_input_other)) - parseFloat(son_deger_other);
				gelen_satir_toplam_other = (parseFloat(gelen_satir_toplam_other) + parseFloat(gelen_input_other)) - parseFloat(son_deger_other);
				
				gelen_input_other = commaSplit(gelen_input_other,2);
				gelen_satir_toplam_other = commaSplit(gelen_satir_toplam_other,2);
				gelen_kolon_toplam_other = commaSplit(gelen_kolon_toplam_other,2);
				son_toplam_other = commaSplit(son_toplam_other,2);
				
				eval("document.sales_plan.satir_net_total_other_" + row_no).value = gelen_satir_toplam_other;
				eval("document.sales_plan.total_stytem2" + month).value = gelen_kolon_toplam_other;
				eval("document.sales_plan.net_total_other" + month + "_" + row_no).value = gelen_input_other;
				document.sales_plan.satir_total_stytem2.value = son_toplam_other;
				document.sales_plan.other_total_amount.value = son_toplam_other;
			}
		}
		function toplam_al2(row_no,month)
		{		
			gelen_satir_toplam_other = eval("sales_plan.satir_net_total_other_" + row_no).value;
			gelen_satir_toplam_other = filterNum(gelen_satir_toplam_other);
			gelen_input_other = eval("sales_plan.net_total_other" + month + "_" + row_no + ".value");
			gelen_input_other = filterNum(gelen_input_other);
			gelen_kolon_toplam_other = eval("sales_plan.total_stytem2" + month).value;
			gelen_kolon_toplam_other = filterNum(gelen_kolon_toplam_other);
			son_toplam_other = sales_plan.satir_total_stytem2.value;
			son_toplam_other = filterNum(son_toplam_other);
			
			son_toplam_other = (parseFloat(son_toplam_other) + parseFloat(gelen_input_other)) - parseFloat(son_deger_other);
			gelen_kolon_toplam_other = (parseFloat(gelen_kolon_toplam_other) + parseFloat(gelen_input_other)) - parseFloat(son_deger_other);
			gelen_satir_toplam_other = (parseFloat(gelen_satir_toplam_other) + parseFloat(gelen_input_other)) - parseFloat(son_deger_other);
			
			gelen_input_other = commaSplit(gelen_input_other,2);
			gelen_satir_toplam_other = commaSplit(gelen_satir_toplam_other,2);
			gelen_kolon_toplam_other = commaSplit(gelen_kolon_toplam_other,2);
			son_toplam_other = commaSplit(son_toplam_other,2);
			
			eval("document.sales_plan.satir_net_total_other_" + row_no).value = gelen_satir_toplam_other;
			eval("document.sales_plan.total_stytem2" + month).value = gelen_kolon_toplam_other;
			eval("document.sales_plan.net_total_other" + month + "_" + row_no).value = gelen_input_other;
			document.sales_plan.satir_total_stytem2.value = son_toplam_other;
			document.sales_plan.other_total_amount.value = son_toplam_other;
			
			for(i=1;i<=document.sales_plan.kur_say.value;i++)
			{
				if(eval('document.sales_plan.hidden_rd_money_'+i).value == '<cfoutput>#session.ep.money2#</cfoutput>')
				{
					form_txt_rate2_ = filterNum(eval("document.sales_plan.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
			eval('document.sales_plan.net_total'+month+'_'+row_no).value = commaSplit(filterNum(eval('document.sales_plan.net_total_other'+month+'_'+row_no).value)*form_txt_rate2_);
	
			gelen_satir_toplam = eval("document.sales_plan.satir_net_total_" + row_no).value;
			gelen_satir_toplam = filterNum(gelen_satir_toplam);
			gelen_input = eval("document.sales_plan.net_total" + month + "_" + row_no + ".value");
			gelen_input = filterNum(gelen_input);
			gelen_kolon_toplam = eval("document.sales_plan.total_stytem" + month).value;
			gelen_kolon_toplam = filterNum(gelen_kolon_toplam);
			son_toplam = document.sales_plan.satir_total_stytem.value;
			son_toplam = filterNum(son_toplam);
			
			son_toplam = (parseFloat(son_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
			gelen_kolon_toplam = (parseFloat(gelen_kolon_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
			gelen_satir_toplam = (parseFloat(gelen_satir_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
			
			gelen_input = commaSplit(gelen_input,2);
			gelen_satir_toplam = commaSplit(gelen_satir_toplam,2);
			gelen_kolon_toplam = commaSplit(gelen_kolon_toplam,2);
			son_toplam = commaSplit(son_toplam,2);
			
			eval("document.sales_plan.satir_net_total_" + row_no).value = gelen_satir_toplam;
			eval("document.sales_plan.total_stytem" + month).value = gelen_kolon_toplam;
			eval("document.sales_plan.net_total" + month + "_" + row_no).value = gelen_input;
			document.sales_plan.satir_total_stytem.value = son_toplam;
			document.sales_plan.total_amount.value = son_toplam;
		}
		function toplam_hesapla(type)
		{
			if(document.sales_plan.kur_say.value == 1)
				for(s=1;s<=$('#kur_say').val();s++)
				{
					if(document.sales_plan.rd_money.checked == true)
					{
						deger_diger_para = document.add_invent.rd_money.value;
						form_txt_rate2_ = filterNum(eval("document.sales_plan.txt_rate2_"+s).value);
					}
					if(eval('document.sales_plan.hidden_rd_money_'+s).value == '<cfoutput>#session.ep.money2#</cfoutput>')
						form_txt_rate2_2 = filterNum(eval("document.sales_plan.txt_rate2_"+s).value);
				}
			else 
				for(s=1;s<=$('#kur_say').val();s++)
				{
					if(document.sales_plan.rd_money[s-1].checked == true)
					{
						deger_diger_para = document.sales_plan.rd_money[s-1].value;
						form_txt_rate2_ = filterNum(eval("document.sales_plan.txt_rate2_"+s).value);
					}
					if(eval('document.sales_plan.hidden_rd_money_'+s).value == '<cfoutput>#session.ep.money2#</cfoutput>')
						form_txt_rate2_2 = filterNum(eval("document.sales_plan.txt_rate2_"+s).value);
				}
			var total_amount = 0;
			var other_total_amount = 0;
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				{
					var total_amount_ = 0;
					var total_amount_2 = 0;
					for(i=1;i<=<cfoutput>#listlen(ay_list)#</cfoutput>;i++)
						if(eval("document.sales_plan.row_kontrol"+j).value==1)
						{
							eval('document.sales_plan.total_stytem'+i).value = 0; 
							eval('document.sales_plan.total_stytem2'+i).value = 0;
							total_amount_ += parseFloat(filterNum(eval('document.sales_plan.net_total'+i+'_'+j).value));
							total_amount_2 += parseFloat(filterNum(eval('document.sales_plan.net_total_other'+i+'_'+j).value));
						}
					eval('document.sales_plan.satir_net_total_'+j).value = commaSplit(total_amount_);
					eval('document.sales_plan.satir_net_total_other_'+j).value = commaSplit(total_amount_2);
				}
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				for(i=1;i<=<cfoutput>#listlen(ay_list)#</cfoutput>;i++)
					if(eval("document.sales_plan.row_kontrol"+j).value==1)
					{
						total_amount += parseFloat(filterNum(eval('document.sales_plan.net_total'+i+'_'+j).value));
						satir_toplam = filterNum(eval('document.sales_plan.net_total'+i+'_'+j).value);
						if('<cfoutput>#session.ep.money2#</cfoutput>' != '')
						{
							if(type!= undefined)
								eval('document.sales_plan.net_total_other'+i+'_'+j).value = commaSplit(satir_toplam/form_txt_rate2_2);
							other_total_amount += parseFloat(filterNum(eval('document.sales_plan.net_total_other'+i+'_'+j).value));
							satir_toplam_2 = filterNum(eval('document.sales_plan.net_total_other'+i+'_'+j).value);
						}
						eval('document.sales_plan.total_stytem'+i).value = commaSplit(filterNum(eval('document.sales_plan.total_stytem'+i).value) + satir_toplam); 
						eval('document.sales_plan.total_stytem2'+i).value = commaSplit(filterNum(eval('document.sales_plan.total_stytem2'+i).value) + satir_toplam_2); 
					}
			$('#total_amount').val(commaSplit(total_amount));
			$('#other_total_amount').val(commaSplit(total_amount/form_txt_rate2_));
			document.sales_plan.satir_total_stytem.value = commaSplit(total_amount);
			if('<cfoutput>#session.ep.money2#</cfoutput>' != '')
				document.sales_plan.satir_total_stytem2.value = commaSplit(other_total_amount);
			document.sales_plan.tl_value1.value = list_getat(deger_diger_para,1,',');
		}
		function unformat_fields()
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				for(i=1;i<=12;i++)
					if(eval("document.sales_plan.row_kontrol"+j).value==1)	
					{
						eval('document.sales_plan.net_total'+i+'_'+j).value = filterNum(eval('document.sales_plan.net_total'+i+'_'+j).value);
						eval('document.sales_plan.net_total_other'+i+'_'+j).value = filterNum(eval('document.sales_plan.net_total_other'+i+'_'+j).value);
						eval('document.sales_plan.net_kar'+i+'_'+j).value = filterNum(eval('document.sales_plan.net_kar'+i+'_'+j).value);
						eval('document.sales_plan.net_prim'+i+'_'+j).value = filterNum(eval('document.sales_plan.net_prim'+i+'_'+j).value);
						eval('document.sales_plan.quantity'+i+'_'+j).value = filterNum(eval('document.sales_plan.quantity'+i+'_'+j).value);
					}
			for(st=1;st<=document.sales_plan.kur_say.value;st++)
			{
				eval('document.sales_plan.txt_rate2_' + st).value = filterNum(eval('document.sales_plan.txt_rate2_' + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				eval('document.sales_plan.txt_rate1_' + st).value = filterNum(eval('document.sales_plan.txt_rate1_' + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
		function apply_kar(no)
		{
			for(j=1;j<=document.getElementById('record_num').value;j++)
			{
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
					eval('document.sales_plan.net_kar'+no+'_'+j).value = commaSplit(filterNum(eval('document.sales_plan.set_net_kar_'+no).value));
			}
		}
		function apply_prim(no)
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
					eval('document.sales_plan.net_prim'+no+'_'+j).value = commaSplit(filterNum(eval('document.sales_plan.set_net_prim_'+no).value));
		}
	</cfif>		
	<cfif (isdefined("attributes.event") and attributes.event is 'add')>
	row_count=0;
	ay_list = "<cfoutput>#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#</cfoutput>";	
	function add_row(scope_id,scope_name,scope_name2,revenue_money_1,revenue_money2_1,amount_1,profit_1,bonus_1,revenue_money_2,revenue_money2_2,amount_2,profit_2,bonus_2,revenue_money_3,revenue_money2_3,amount_3,profit_3,bonus_3,revenue_money_4,revenue_money2_4,amount_4,profit_4,bonus_4,revenue_money_5,revenue_money2_5,amount_5,profit_5,bonus_5,revenue_money_6,revenue_money2_6,amount_6,profit_6,bonus_6,revenue_money_7,revenue_money2_7,amount_7,profit_7,bonus_7,revenue_money_8,revenue_money2_8,amount_8,profit_8,bonus_8,revenue_money_9,revenue_money2_9,amount_9,profit_9,bonus_9,revenue_money_10,revenue_money2_10,amount_10,profit_10,bonus_10,revenue_money_11,revenue_money2_11,amount_11,profit_11,bonus_11,revenue_money_12,revenue_money2_12,amount_12,profit_12,bonus_12)
	{
		document.sales_plan.sale_scope.selectedIndex = scope_name2;
		if(scope_name2 == undefined) scope_name2 = '';
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		newRow.onmouseover=function(){this.className='color-light'};
		newRow.onmouseout=function(){this.className='color-row'};
		$('#record_num').val(row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol'+ row_count +'" id="row_kontrol'+ row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="text" value="'+scope_name+' '+scope_name2+'" name="plan_scope' + row_count +'" id="plan_scope' + row_count +'" class="boxtext" style="width:120px;" readonly><input type="hidden" value="'+scope_id+'" name="plan_scope_id' + row_count +'" class="boxtext">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '&nbsp;';
		for(i=1;i<=<cfoutput>#listlen(ay_list)#</cfoutput>;i++)
		{
			if(eval('revenue_money_'+i) == undefined)
				new_revenue_money = commaSplit(0);
			else
				new_revenue_money = commaSplit(filterNum(eval('revenue_money_'+i)));
			if(eval('revenue_money2_'+i) == undefined)
				new_revenue_money2 = commaSplit(0);
			else
				new_revenue_money2 = commaSplit(filterNum(eval('revenue_money2_'+i)));
			if(eval('amount_'+i) == undefined)
				new_amount = commaSplit(0);
			else
				new_amount = commaSplit(filterNum(eval('amount_'+i)));
			if(eval('profit_'+i) == undefined)
				new_profit = commaSplit(0);
			else
				new_profit = commaSplit(filterNum(eval('profit_'+i)));
			if(eval('bonus_'+i) == undefined)
				new_bonus = commaSplit(0);
			else
				new_bonus = commaSplit(filterNum(eval('bonus_'+i)));
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value="'+new_revenue_money+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" name="net_total'+ i +'_'+ row_count +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);toplam_al('+row_count+','+i+');" onFocus="son_deger_degis('+row_count+','+i+');">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value="'+new_revenue_money2+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" name="net_total_other'+ i +'_'+ row_count +'" style="width:100px;" class="box" onkeyup="return(FormatCurrency(this,event));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);toplam_al2('+row_count+','+i+');" onFocus="son_deger_degis('+row_count+','+i+');">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value="'+new_amount+'" name="quantity'+ i +'_'+ row_count +'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" style="width:100px;" class="box" onkeyup="isNumber(this);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value="'+new_profit+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" name="net_kar'+ i +'_'+ row_count +'" style="width:100px;" class="box" onkeyup="return(FormatCurrency(this,event));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value="'+new_bonus+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" name="net_prim'+ i +'_'+ row_count +'" style="width:100px;" class="box" onkeyup="return(FormatCurrency(this,event));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '&nbsp;';
		}
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="text" value="'+commaSplit(0)+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" name="satir_net_total_'+ row_count +'" id="satir_net_total_'+row_count+'" style="width:100px;" class="box" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="text" value="'+commaSplit(0)+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" name="satir_net_total_other_'+ row_count +'" style="width:100px;" class="box" readonly>';
	}	
	function hesapla(row_no,month)
	{
		var satir_toplam = filterNum(eval('document.sales_plan.net_total'+month+'_'+row_no).value);
		if('<cfoutput>#session.ep.money2#</cfoutput>' != '')
		{
			for(i=1;i<=document.sales_plan.kur_say.value;i++)
			{
				if(eval('document.sales_plan.hidden_rd_money_'+i).value == '<cfoutput>#session.ep.money2#</cfoutput>')
				{
					form_txt_rate2_ = filterNum(eval("document.sales_plan.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
			eval('document.sales_plan.net_total_other'+month+'_'+row_no).value = commaSplit(satir_toplam/form_txt_rate2_);
		}
		var total_amount_ = 0;
		var total_amount_2 = 0;
		for(i=1;i<=<cfoutput>#listlen(ay_list)#</cfoutput>;i++)
			if(eval("document.sales_plan.row_kontrol"+row_no).value==1)
			{
				total_amount_ += filterNum(eval('document.sales_plan.net_total'+i+'_'+row_no).value);
				total_amount_2 += filterNum(eval('document.sales_plan.net_total_other'+i+'_'+row_no).value);
			}
		eval('document.sales_plan.satir_net_total_'+row_no).value = commaSplit(total_amount_);
		eval('document.sales_plan.satir_net_total_other_'+row_no).value = commaSplit(total_amount_2);
		toplam_hesapla();
	}	
	
	function kontrol()
	{	
		if($('#paper_no').val() == "")
			{
				alert("<cf_get_lang no='148.Lütfen Belge No Giriniz'>!");
				return false;	
			}
		var record_exist=0;
		say=0;
		for(r=1;r<=document.sales_plan.record_num.value;r++)
		{
			if(eval("document.sales_plan.row_kontrol"+r).value==1)
			{
				record_exist=1;
			}
		}
		if (document.sales_plan.sale_scope.value == '') 
		{
			alert("<cf_get_lang no ='173.Lütfen Kapsam Seçiniz'> !");
			return false;
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang no='147.Lütfen Satır Giriniz'>!");
			return false;
		}
		if(document.sales_plan.sale_scope.value == 1)//Satış Bölgesi Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value;
					var zone_control = wrk_safe_query("slsp_zone_control_2",'dsn',0,listParam);
					if(zone_control.recordcount)
					{
						alert ("<cf_get_lang no ='174.Seçilen Satış Bölgesi İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 2)//Şube Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='175.Seçilen Şube İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 3)//Satış Takımı Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_2",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='176.Seçilen Satış Takımı İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 4)//Mikro Bölge Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;	
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_3",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='177.Seçilen Mikro Bölge İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 5)//Çalışan Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_4",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='178.Seçilen Çalışan İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 6)//Müşteri Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_5",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='179.Seçilen Müşteri İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 7)//Ürün kategorisi Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_6",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='180.Seçilen Ürün kategorisi İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 8)//Marka Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_7",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='181.Seçilen Marka İçin İlgili Dönemde Kota Tanımı Yapılmış  Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 9)//Üye Kategorisi Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_8",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='182.Seçilen Üye Kategorisi İçin İlgili Dönemde Kota Tanımı Yapılmış ! Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		unformat_fields();
		return process_cat_control();
		return true;
	}	
	function open_file()
	{
		document.getElementById("sales_plan_quota_file").style.display='';
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.popup_add_sales_plan_quota_file<cfif isdefined("attributes.plan_id")>&plan_id=#attributes.plan_id#</cfif></cfoutput>','sales_plan_quota_file',1);
		return false;
	}
	</cfif>
	<cfif isdefined("attributes.event") and attributes.event is 'upd'>
	$(document).ready(function()
		{
			toplam_hesapla(1);
			row_count=<cfoutput>#get_plan_rows2.recordcount#</cfoutput>;	
		});		
	function add_row(scope_id,scope_name,scope_name2)
	{
		if(scope_name2 == undefined)
			scope_name2 = '';
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.sales_plan.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol'+ row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="text" value="'+scope_name+' '+scope_name2+'" name="plan_scope' + row_count +'" class="boxtext" style="width:120px;" readonly><input type="hidden" value="'+scope_id+'" name="plan_scope_id' + row_count +'" class="boxtext">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '&nbsp;';
		for(i=1;i<=<cfoutput>#listlen(ay_list)#</cfoutput>;i++)
		{
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value="'+commaSplit(0)+'" name="net_total'+ i +'_'+ row_count +'" style="width:100px;" class="box" onkeyup="return(FormatCurrency(this,event));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);toplam_al('+row_count+','+i+');" onFocus="son_deger_degis('+row_count+','+i+');">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value="'+commaSplit(0)+'" name="net_total_other'+ i +'_'+ row_count +'" style="width:100px;" class="box" onkeyup="return(FormatCurrency(this,event));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);toplam_al2('+row_count+','+i+');" onFocus="son_deger_degis('+row_count+','+i+');">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value="'+commaSplit(0)+'" name="quantity'+ i +'_'+ row_count +'" style="width:100px;" class="box" onkeyup="isNumber(this);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value="'+commaSplit(0)+'" name="net_kar'+ i +'_'+ row_count +'" style="width:100px;" class="box" onkeyup="return(FormatCurrency(this,event));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value="'+commaSplit(0)+'" name="net_prim'+ i +'_'+ row_count +'" style="width:100px;" class="box" onkeyup="return(FormatCurrency(this,event));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '&nbsp;';
		}
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="text" value="'+commaSplit(0)+'" name="satir_net_total_'+ row_count +'" style="width:100px;" class="box" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="text" value="'+commaSplit(0)+'" name="satir_net_total_other_'+ row_count +'" style="width:100px;" class="box" readonly>';
	}		
	function kontrol()
	{	
		var record_exist=0;
		var say = 0;
		for(r=1;r<=document.sales_plan.record_num.value;r++)
		{
			if(eval("document.sales_plan.row_kontrol"+r).value==1)
			{
				record_exist=1;
			}
		}
		if (document.sales_plan.sale_scope.value == '') 
		{
			alert("<cf_get_lang no ='173.Lütfen Kapsam Seçiniz'> !");
			return false;
		}
		if (record_exist == 0) 

		{
			alert("<cf_get_lang no='147.Lütfen Satır Giriniz'>!");
			return false;
		}
		if(document.sales_plan.sale_scope.value == 1)//Satış Bölgesi Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value + "*" + document.sales_plan.plan_id.value;
					var zone_control = wrk_safe_query("slsp_zone_control_3",'dsn',0,listParam);
					if(zone_control.recordcount)
					{
						alert ("<cf_get_lang no ='174.Seçilen Satış Bölgesi İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 2)//Şube Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value + "*" + document.sales_plan.plan_id.value;
					var control = wrk_safe_query("slsp_control_9",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='175.Seçilen Şube İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 3)//Satış Takımı Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var new_sql = 'SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = '+document.sales_plan.plan_year.value+' AND SQR.TEAM_ID = '+eval("document.sales_plan.plan_scope_id"+j).value+' AND SQ.SALES_QUOTE_ID <> '+document.sales_plan.plan_id.value+' AND SQ.IS_PLAN = 1';
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value + "*" + document.sales_plan.plan_id.value;
					var control = wrk_safe_query("slsp_control_10",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='176.Seçilen Satış Takımı İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 4)//Mikro Bölge Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value + "*" + document.sales_plan.plan_id.value;
					var control = wrk_safe_query("slsp_control_11",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='177.Seçilen Mikro Bölge İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 5)//Çalışan Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value + "*" + document.sales_plan.plan_id.value;
					var control = wrk_safe_query("slsp_control_12",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='178.Seçilen Çalışan İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 6)//Müşteri Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value + "*" + document.sales_plan.plan_id.value;
					var control = wrk_safe_query("slsp_control_13",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='179.Seçilen Müşteri İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 7)//Ürün kategorisi Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var new_sql = 'SELECT * FROM SALES_QUOTES_GROUP SQ,SALES_QUOTES_GROUP_ROWS SQR WHERE SQ.SALES_QUOTE_ID=SQR.SALES_QUOTE_ID AND SQ.QUOTE_YEAR = '+document.sales_plan.plan_year.value+' AND SQR.PRODUCTCAT_ID = '+eval("document.sales_plan.plan_scope_id"+j).value+' AND SQ.SALES_QUOTE_ID <> '+document.sales_plan.plan_id.value+' AND SQ.IS_PLAN = 1';
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value + "*" + document.sales_plan.plan_id.value;
					var control = wrk_safe_query("slsp_control_14",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='180.Seçilen Ürün kategorisi İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 8)//Marka Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value + "*" + document.sales_plan.plan_id.value;
					var control = wrk_safe_query("slsp_control_15",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='181.Seçilen Marka İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.sales_plan.sale_scope.value == 9)//Üye Kategorisi Bazında
		{
			for(j=1;j<=document.sales_plan.record_num.value;j++)
				if(eval("document.sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.sales_plan.plan_year.value + "*" + eval("document.sales_plan.plan_scope_id"+j).value + "*" + document.sales_plan.plan_id.value;
					var control = wrk_safe_query("slsp_control_16",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang no ='182.Seçilen Üye Kategorisi İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		unformat_fields();


		return process_cat_control();
		return true;
	}
	</cfif>
</script>



<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'salesplan.list_sales_plan_quotas';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'salesplan/display/list_sales_plan_quotas.cfm';
	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'salesplan.list_sales_plan_quotas';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'salesplan/form/add_sales_plan_quota.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'salesplan/query/add_sales_plan_quota.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'salesplan.list_sales_plan_quotas&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('sales_plan','sales_plan_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'salesplan.list_sales_plan_quotas';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'salesplan/form/upd_sales_plan_quota.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'salesplan/query/upd_sales_plan_quota.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'salesplan.list_sales_plan_quotas&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'plan_id=##attributes.plan_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.plan_id##';
	
	if(attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=salesplan.emptypopup_del_sales_plan_quota&plan_id=#attributes.plan_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'salesplan/query/del_sales_plan_quota.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'salesplan/query/del_sales_plan_quota.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'salesplan.list_sales_plan_quotas';		
	}	
	
		
	if(attributes.event is 'add')
	{			
		plan_id = -1;
		if(isdefined("attributes.plan_id"))
		 	plan_id = attributes.plan_id;
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[2576]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=objects.popup_add_sales_plan_quota_file&plan_id=#plan_id#',this,'sales_plan_quota_file')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	// Upd //	
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=salesplan.list_sales_plan_quotas&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'salesplanListPlanQuotos';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SALES_QUOTES_GROUP';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-paper_no','item-plan_date','item-process_stage','item-plan_year']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
