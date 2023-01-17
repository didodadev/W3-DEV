<!---
    File: get_budget_row_from_file.cfm
    Folder: V16\budget\query\
	Controller:
    Author:
    Date:
    Description:
        Bütçe planlama fişi excel ile aktarım sayfası
    History:
		2019-12-24 18:06:02 Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
		Proje ID alanı eklendi
    To Do:

--->

<cfscript>
	kontrol_file	= 0;
	upload_folder	= '#upload_folder#finance#dir_seperator#';
	if (Not directoryExists(upload_folder)) {
		directoryCreate(upload_folder);
	}
</cfscript>

<cftry>
	<cffile action = "upload" 
		  fileField = "uploaded_file" 
		  destination = "#upload_folder#"
		  nameConflict = "MakeUnique"  
		  mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
	<!---Script dosyalarını engelle  02092010 ND --->
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
		<script type="text/javascript">
			alert('Dosya yüklenemedi\n\n<cfoutput>#cfcatch.detail#</cfoutput>');
		</script>
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
		<cfscript>
			order_id_="";
			order_row_id_="";
			expense_date = trim(ListGetAt(dosya[k],1,";"));
			detail = ListGetAt(dosya[k],2,";");
			expense_center_id = trim(ListGetAt(dosya[k],3,";"));
			expense_item_id = trim(ListGetAt(dosya[k],4,";"));
			account_code = trim(ListGetAt(dosya[k],5,";"));
			activity_type = trim(ListGetAt(dosya[k],6,";"));
			workgroup_id = trim(ListGetAt(dosya[k],7,";"));
			assetp_id = trim(ListGetAt(dosya[k],8,";"));
			comp_code = trim(ListGetAt(dosya[k],9,";"));
			cons_code = trim(ListGetAt(dosya[k],10,";"));
			income_total = trim(ListGetAt(dosya[k],11,";"));
			if(listlen(dosya[k],';') gte 12)
				expense_total = trim(ListGetAt(dosya[k],12,";"));
			else
				expense_total = '';
			if(listlen(dosya[k],';') Gte 13)
				project_id	= trim(ListGetAt(dosya[k],13,";"));
			else
				project_id	= '';
		</cfscript>
		<cfoutput>
			<cfif len(expense_item_id)>
				<cfquery name="get_exp_item" datasource="#dsn2#">
					SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #expense_item_id#
				</cfquery>
				<cfset expense_item_name = get_exp_item.EXPENSE_ITEM_NAME>
			<cfelse>
				<cfset expense_item_name = ''>
			</cfif>
			<cfif len(assetp_id)>
				<cfquery name="get_assetp_name" datasource="#dsn#">
					SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #assetp_id#
				</cfquery>
				<cfset assetp_name = get_assetp_name.ASSETP>
			<cfelse>
				<cfset assetp_name = ''>
			</cfif>
			<cfif not len(account_code)>
				<cfset account_code = get_exp_item.ACCOUNT_CODE>
			</cfif>
			<cfif len(comp_code)>
				<cfquery name="get_name_" datasource="#dsn#">
					SELECT FULLNAME NAME,'Partner' MEMBER_TYPE,COMPANY_ID,'' CONSUMER_ID FROM COMPANY WHERE MEMBER_CODE = '#comp_code#' OR OZEL_KOD = '#comp_code#'
				</cfquery>
			<cfelseif len(trim(cons_code))>
				<cfquery name="get_name_" datasource="#dsn#">
					SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME NAME,'Consumer' MEMBER_TYPE,CONSUMER_ID,'' COMPANY_ID FROM CONSUMER WHERE MEMBER_CODE = '#cons_code#' OR OZEL_KOD = '#cons_code#'
				</cfquery>
			</cfif>

			<cfscript>
				if (isDefined('get_name_')) {
					member_type	= get_name_.member_type;
					company_id	= get_name_.company_id;
					consumer_id = get_name_.consumer_id;
					authorized	= get_name_.name;
				}
				else{
					member_type	= '';
					company_id	= '';
					consumer_id = '';
					authorized	= '';
				}
				if (Not Len(income_total)) {income_total = 0;}
				if (Not Len(expense_total)) {expense_total = 0;}
				diff_total		= filterNum(income_total) - filterNum(expense_total);
				project_name	= '';
			</cfscript>
			<cfif len(project_id)and project_id Neq 0>
				<cfquery name="get_project" datasource="#dsn#">
					SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#" />
				</cfquery>
				<cfset project_name	= get_project.PROJECT_HEAD />
			</cfif>
			<script type="text/javascript">
				add_row("#expense_date#","#detail#","#expense_center_id#","#expense_item_id#","#expense_item_name#","","","#account_code#","#account_code#","#activity_type#","#workgroup_id#","#member_type#","#company_id#","#consumer_id#","","#authorized#","#project_id#","#project_name#","#income_total#","#expense_total#","#diff_total#","","","","#assetp_id#","#assetp_name#");
			</script>
		</cfoutput>
	</cfloop>	
</cfif>