<cfset kontrol_file = 0>
<cfset upload_folder = "#upload_folder#finance#dir_seperator#">
<cftry>
	<cffile action = "upload" 
		  fileField = "uploaded_file" 
		  destination = "#upload_folder#"
		  nameConflict = "MakeUnique"  
		  mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfset file_size = cffile.filesize>
	<cfset dosya_yolu = "#upload_folder##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
	<cfcatch type="Any">
		<cfset kontrol_file = 1>
	</cfcatch>
</cftry>
<cfif kontrol_file eq 0>
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
	</cfscript>
	<cfloop from="2" to="#line_count#" index="k">
		<cfset j= 1>
		<cfscript>
			expense_date = Listgetat(dosya[k],j,";"); //tarih
			expense_date = trim(expense_date);
			j=j+1;
			
			row_detail = Listgetat(dosya[k],j,";"); //AÇıklama
			row_detail = trim(row_detail);
			j=j+1;	
			
			expense_center_id = Listgetat(dosya[k],j,";"); //Masraf Merkezi
			expense_center_id = trim(expense_center_id);
			j=j+1;	
			
			expense_item_id = Listgetat(dosya[k],j,";"); //Gider Kalemi
			expense_item_id = trim(expense_item_id);
			j=j+1;
			
			account_code = Listgetat(dosya[k],j,";"); //Muhasebe Kodu
			account_code = trim(account_code);
			j=j+1;
			
			asset_id = Listgetat(dosya[k],j,";"); //Fiziki VArlık
			asset_id = trim(asset_id);
			j=j+1;
			
			project_id = Listgetat(dosya[k],j,";"); //Proje
			project_id = trim(project_id);
			j=j+1;
			
			product_id = Listgetat(dosya[k],j,";"); //Ürün id
			product_id = trim(product_id);
			j=j+1;
			
			stock_id = Listgetat(dosya[k],j,";"); //Stok id
			stock_id = trim(stock_id);
			j=j+1;
			
			stock_unit = Listgetat(dosya[k],j,";"); //Birim
			stock_unit = trim(stock_unit);
			j=j+1;
			
			quantity = Listgetat(dosya[k],j,";"); //Miktar
			quantity = trim(quantity);
			j=j+1;
			
			total = Listgetat(dosya[k],j,";"); //Tutar
			total = trim(replace(total,',','.'));
			j=j+1;
			
			tax_rate = Listgetat(dosya[k],j,";"); //KDV %
			tax_rate = trim(tax_rate);
			j=j+1;
			
			otv_rate = Listgetat(dosya[k],j,";"); //OTV %
			otv_rate = trim(otv_rate);
			j=j+1;
									
			money_id = Listgetat(dosya[k],j,";"); //Para Birimi
			money_id = trim(money_id);
			j=j+1;
						
			activity_id = Listgetat(dosya[k],j,";"); //Aktivite Tipi
			activity_id = trim(activity_id);
			j=j+1;

			workgroup_id = Listgetat(dosya[k],j,";"); //İş Grubu
			workgroup_id = trim(workgroup_id);
			j=j+1;

			row_work_id = Listgetat(dosya[k],j,";"); //İş
			row_work_id = trim(row_work_id);
			j=j+1;
			
			exp_opp_id = Listgetat(dosya[k],j,";"); //Fırsat
			exp_opp_id = trim(exp_opp_id);
			j=j+1;

			subscription_id = Listgetat(dosya[k],j,";"); //Sistem
			subscription_id = trim(subscription_id);
			j=j+1;
			
			comp_code = Listgetat(dosya[k],j,";"); //Harcama Yapan Kurumsal Üye Kodu
			comp_code = trim(comp_code);
			j=j+1;
			
			cons_code = Listgetat(dosya[k],j,";"); //Harcama Yapan Bireysel Üye Kodu
			cons_code = trim(cons_code);
			j=j+1;			

			if(listlen(dosya[k],';') gte j)    //Harcama Yapan Çalışan Üye Kodu
			{
				employee_no = Listgetat(dosya[k],j,";");
			}else
				employee_no ='';
			
		</cfscript>
		<cfoutput>
			<cfif len(expense_item_id)>
				<cfquery name="get_exp_item" datasource="#dsn2#">
					SELECT EXPENSE_ITEM_NAME,EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #expense_item_id#
				</cfquery>
				<cfset expense_item_name = get_exp_item.EXPENSE_ITEM_NAME>
			<cfelse>
				<cfset expense_item_name = ''>
			</cfif>
			<cfif len(expense_center_id)>
				<cfquery name="get_exp_center" datasource="#dsn2#">
					SELECT EXPENSE_ID,EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #expense_center_id#
				</cfquery>
				<cfset expense_center_name = get_exp_center.EXPENSE>
			<cfelse>
				<cfset expense_center_name = ''>
			</cfif>
			<cfif len(activity_id)>
				<cfquery name="get_activity_type" datasource="#dsn#">
					SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_ID = #activity_id#
				</cfquery>
				<cfset activity_type = get_activity_type.activity_name>
			<cfelse>
				<cfset activity_type = ''>
			</cfif>
			<cfif len(project_id)>
				<cfquery name="get_project" datasource="#dsn#">
					SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #project_id#
				</cfquery>
				<cfset project = get_project.project_head>
			<cfelse>
				<cfset project = ''>
			</cfif>
			<cfif len(product_id)>
				<cfquery name="get_product" datasource="#dsn3#">
					SELECT STOCK_ID,PRODUCT_ID,PRODUCT_NAME FROM STOCKS WHERE PRODUCT_ID = #product_id#
				</cfquery>
				<cfset product_name = get_product.product_name>
			<cfelse>
				<cfset product_name = ''>
			</cfif>
			<cfif len(money_id)>
				<cfquery name="get_money" datasource="#dsn2#">
					SELECT MONEY AS MONEY_TYPE,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY_ID = #money_id#
				</cfquery>
				<cfset exp_money_type = '#get_money.MONEY_TYPE#,#get_money.RATE1#,#get_money.rate2#'>
			<cfelse>
				<cfset exp_money_type = ''>
			</cfif>
			<cfif len(workgroup_id)>
				<cfquery name="get_workgroups" datasource="#dsn#">
					SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 AND WORKGROUP_ID = #workgroup_id# ORDER BY WORKGROUP_NAME
				</cfquery>
				<cfset workgroup_name = get_workgroups.workgroup_name>
			<cfelse>
				<cfset workgroup_name = ''>
			</cfif>
			<cfif len(row_work_id)>
				<cfquery name="get_work" datasource="#dsn#">
					SELECT WORK_ID,WORK_HEAD FROM PRO_WORKS WHERE WORK_ID = #row_work_id#
				</cfquery>
				<cfset row_work_head = get_work.work_head>
			<cfelse>
				<cfset row_work_head = ''>
			</cfif>
			<cfif len(exp_opp_id)>
				<cfquery name="get_opportunities" datasource="#DSN3#">
					SELECT OPP_ID,OPP_HEAD FROM OPPORTUNITIES WHERE OPP_ID = #exp_opp_id#
				</cfquery>
				<cfset exp_opp_head = get_opportunities.OPP_HEAD>
			<cfelse>
				<cfset exp_opp_head = ''>
			</cfif>
			<cfif len(subscription_id)>
				<cfquery name="get_subscription" datasource="#dsn3#">
					SELECT SUBSCRIPTION_ID, SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #subscription_id#
				</cfquery>
				<cfset subscription_head = get_subscription.subscription_head>
			<cfelse>
				<cfset subscription_head = ''>
			</cfif>
			<cfif len(asset_id)>
				<cfquery name="get_asset" datasource="#dsn#">
					SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID = #asset_id#
				</cfquery>
				<cfset asset_name = get_asset.ASSETP>
			<cfelse>
				<cfset asset_name = ''>
			</cfif>
			<cfset kontrol_comp = 0>
			<cfif len(comp_code)>
				<cfset kontrol_comp = 1>
				<cfquery name="get_name" datasource="#dsn#">
					SELECT FULLNAME NAME,'Partner' MEMBER_TYPE,COMPANY_ID ID,'' CONSUMER_ID,'' EMPLOYEE_ID FROM COMPANY WHERE MEMBER_CODE = '#comp_code#'
				</cfquery>
			<cfelseif len(trim(cons_code))>
				<cfset kontrol_comp = 1>
				<cfquery name="get_name" datasource="#dsn#">
					SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME NAME,'Consumer' MEMBER_TYPE,CONSUMER_ID ID,'' COMPANY_ID,'' EMPLOYEE_ID FROM CONSUMER WHERE MEMBER_CODE = '#cons_code#'
				</cfquery>
			<cfelseif len(trim(employee_no))>
				<cfset kontrol_comp = 1>
				<cfquery name="get_name" datasource="#dsn#">
					SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME NAME,'Employee' MEMBER_TYPE, EMPLOYEE_ID ID,'' CONSUMER_ID,'' COMPANY_ID FROM EMPLOYEES WHERE EMPLOYEE_NO = '#employee_no#'
				</cfquery>
			</cfif>			
			<cfif kontrol_comp eq 1>
				<cfset member_type = get_name.member_type>
				<cfset company_id = get_name.id>
				<cfset authorized = get_name.name>
			<cfelse>
				<cfset member_type = ''>
				<cfset company_id = ''>
				<cfset authorized = ''>
			</cfif>
			<script type="text/javascript">
				row_number = parseFloat(window.top.document.getElementById("record_num").value)+1;
				window.top.add_row("#row_detail#","#expense_center_name#","#expense_center_id#","#expense_item_name#","#expense_item_id#","#project_id#","#project#","#product_id#","","","#stock_id#","#product_name#","#stock_unit#","","#member_type#","","#company_id#","","#authorized#","#total#","","","#tax_rate#","#exp_money_type#","#activity_id#","#workgroup_id#","#subscription_id#","#subscription_head#","#asset_id#","#asset_name#","#account_code#","#expense_date#","#row_work_id#","#row_work_head#","#exp_opp_id#","#exp_opp_head#","#otv_rate#","#quantity#");
				window.top.hesapla('',false,row_number);
			</script>
		</cfoutput>
	</cfloop>
</cfif>
