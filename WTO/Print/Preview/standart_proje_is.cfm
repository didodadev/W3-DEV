<cf_get_lang_set module_name="project">
	<!--- Proje İs Printi --->
	<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
	<cfquery name="get_work" datasource="#dsn#">
	  SELECT * FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
	</cfquery>
	 <cfset sdate=date_add("h",session.ep.TIME_ZONE,get_work.TARGET_START)>
	 <cfset fdate=date_add("h",session.ep.TIME_ZONE,get_work.TARGET_FINISH)>
	<cfif get_work.PROJECT_EMP_ID neq 0 and len(get_work.PROJECT_EMP_ID)>
	  <cfset person="#get_emp_info(get_work.PROJECT_EMP_ID,0,0)#">
	<cfelseif get_work.OUTSRC_PARTNER_ID neq 0 and len(get_work.OUTSRC_PARTNER_ID)>
	  <cfset person="#get_par_info(get_work.OUTSRC_PARTNER_ID,0,0,0)#">
	<cfelse>
	  <cfset person="">
	</cfif>
	<cfquery name="GET_PROCURRENCY" datasource="#dsn#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.popup_project_work_prints%"> AND
		PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.work_currency_id#">
	</cfquery>
	
	<cfif len(get_work.project_id)>
	  <cfquery name="get_pro_name" datasource="#DSN#">
		SELECT 
		  PROJECT_HEAD,
		  TARGET_START,
		  TARGET_FINISH
		FROM 
		  PRO_PROJECTS 
		WHERE 
		  PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.project_id#">
	  </cfquery>
	</cfif>
	<cfquery name="CHECK" datasource="#DSN#">
		SELECT 
		  ASSET_FILE_NAME2,
		  ASSET_FILE_NAME2_SERVER_ID,
		COMPANY_NAME
		FROM 
		  OUR_COMPANY 
		WHERE 
		  <cfif isdefined("attributes.our_company_id")>
			COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		  <cfelse>
			<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
			  COMP_ID = #session.ep.company_id#
			<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>  
			  COMP_ID = #session.pp.company_id#
			<cfelseif isDefined("session.ww.our_company_id")>
			  COMP_ID = #session.ww.our_company_id#
			<cfelseif isDefined("session.cp.our_company_id")>
			  COMP_ID = #session.cp.our_company_id#
			</cfif> 
		  </cfif> 
	  </cfquery>
	<cfquery name="GET_CATS" datasource="#dsn#">
	  SELECT 
		PRIORITY 
	  FROM 
		SETUP_PRIORITY
	  WHERE
		PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.work_priority_id#">
	</cfquery>
	
	<cfif len(get_work.RELATED_WORK_ID)>
	  <cfquery name="GET_REL_WORK" datasource="#dsn#">
		SELECT
		  *
		FROM
		  PRO_WORK_RELATIONS
		WHERE
		  WORK_ID = #get_work.WORK_ID#
	  </cfquery>
	</cfif>
	<cfif len(get_work.work_cat_id)>
	  <cfquery name="GET_WORK_CAT" datasource="#dsn#">
		SELECT 
		  WORK_CAT 
		FROM 
		  PRO_WORK_CAT
		WHERE
		  WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.WORK_CAT_ID#">
	  </cfquery>
	</cfif>
	<cfif len(get_work.COMPANY_ID) and len(get_work.COMPANY_PARTNER_ID)>
	<cfset attributes.partner_id = get_work.COMPANY_PARTNER_ID>
	  <cfquery name="GET_PARTNER_NAME" datasource="#dsn#">
		SELECT
		  COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		  COMPANY_PARTNER.COMPANY_PARTNER_EMAIL,
		  COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		  COMPANY.COMPANY_ID,
		  COMPANY.NICKNAME,
		  COMPANY.FULLNAME
		FROM
		  COMPANY_PARTNER,
		  COMPANY
		WHERE
		  COMPANY_PARTNER.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PARTNER_ID#"> AND 
		  COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID 
	  </cfquery>
	</cfif>
	<cfif len(GET_WORK.WORKGROUP_ID)>
		<cfquery name="GET_ASSETP_GROUPS" datasource="#DSN#">
			SELECT 
			WORKGROUP_ID,
			WORKGROUP_NAME
			FROM 
				WORK_GROUP
			WHERE
				WORKGROUP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_WORK.WORKGROUP_ID#">
		  </cfquery>
	</cfif>
	  <cfset record_count_row = 0>
<cfoutput>
	<table style="width:210mm">
	  <tr>
		<td>
		<table width="100%">
			<tr class="row_border">
			<td style="padding:10px 0 0 0!important">
			<table style="width:100%;">
			<tr>
			  <td class="print_title"><cf_get_lang dictionary_id='49888.Proje İş'></td>
			  <td style="text-align:right;">
			  <cfif len(check.asset_file_name2)>
			  <cfset attributes.type = 1>
				<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
			  </cfif>
			  </td>
			</tr>
		</table>
		<tr class="row_border"class="row_border">
		<td>
			<table>				
				<tr >
					<td style="width:100px;"><b><cf_get_lang dictionary_id="58820.Başlık"></b></td>
					<td >#get_work.WORK_HEAD#</td>
				</tr><tr>
					<td style="width:100px;"><b><cf_get_lang dictionary_id='57485.Öncelik'> </b></td>
					<td>#get_cats.priority#</td>
				</tr>
				<tr >
					<td style="width:100px;"><b><cf_get_lang dictionary_id="57416.Proje"></b></td>
					<td >
					<cfif len(get_work.project_id)>
						#get_pro_name.project_head#
					<cfelse>
						<cf_get_lang dictionary_id="58459.Projesiz">
					</cfif>
					</td>
				</tr>
				<tr>
					<td style="width:100px;"><b><cf_get_lang dictionary_id="38268.İş İlişkisi"></b></td>
					<td>
						<cfif len(get_work.RELATED_WORK_ID)>
						#get_rel_work.PRE_ID#<cfif Len(get_rel_work.RELATION_TYPE)>#get_rel_work.RELATION_TYPE#</cfif><cfif Len(get_rel_work.LAG)>#get_rel_work.LAG#</cfif>
						<cfelse>
						</cfif>
					</td>
				</tr>
				<tr>
					<td style="width:100px;"><b><cf_get_lang dictionary_id="35041.İş Kategorisi"> </b></td>
					<td ><cfif len(get_work.work_cat_id)>#GET_WORK_CAT.work_cat#<cfelse>&nbsp;</cfif></td>
				</tr>
				<tr>
					<td style="width:100px;"><b><cf_get_lang dictionary_id="36426.Şirket Yetkilisi"></b></td>
					<td>
						<cfif len(get_work.COMPANY_ID) and len(get_work.COMPANY_PARTNER_ID)>
							<cfif len(get_partner_name.NICKNAME) and len(get_partner_name.COMPANY_PARTNER_NAME) and len(get_partner_name.COMPANY_PARTNER_SURNAME)>
								#get_partner_name.NICKNAME# &nbsp;&nbsp;&nbsp;&nbsp; #get_partner_name.COMPANY_PARTNER_NAME# #get_partner_name.COMPANY_PARTNER_SURNAME#
							<cfelseif len(get_partner_name.COMPANY_PARTNER_NAME) and len(get_partner_name.COMPANY_PARTNER_SURNAME)>
								#get_partner_name.COMPANY_PARTNER_NAME# #get_partner_name.COMPANY_PARTNER_SURNAME#
							</cfif>
						</cfif>
					</td> 
				</tr>
				<tr>
					<td><b><cf_get_lang dictionary_id ="57629.Açıklama"></b></td>
					<td >#get_work.WORK_DETAIL#</td>
				</tr>
			</table>	
		</td>
		</tr>
			<table width="100%">
				<tr bgcolor="##eee" style="background-color:##eee;border-top:1px solid ##c0c0c0;border-bottom:1px solid ##c0c0c0">
					<td style="width:100px"><b><cf_get_lang dictionary_id='57482.Aşama'></b></td>
					<td>#get_procurrency.stage#</td>
				</tr>
			</table>
		<tr>
			<td><b><cf_get_lang dictionary_id='57771.Detay'></b></td>
		  </tr>
		<tr class="row_border">
			<td >
			  <table class="print_border">
				<tr>
				  <th style="width:100px"><b><b><cf_get_lang dictionary_id="38175.Tahmini Bütçe"></b></th>
				  <th style="width:100px"><b><cf_get_lang dictionary_id="57655.Başlama Tarihi"></b></th>
				  <th style="width:100px;"><cf_get_lang dictionary_id="38176.Tahmini Süre"> </th>
				<th style="width:100px;"><cf_get_lang dictionary_id="57700.Bitiş Tarihi">  </th>
				</tr>
				<cfloop query="get_work">
				<tr>
					<td><cfif len(get_work.expected_budget)>#TLFormat(get_work.expected_budget)# &nbsp;&nbsp;&nbsp; #get_work.expected_budget_money# <cfelse></cfif></td>
					<td>#dateformat(sdate,dateformat_style)# #timeformat(sdate,timeformat_style)#</td>
					<td >#get_work.estimated_time# <cf_get_lang dictionary_id="58127.Dakika"></td>
					<td>#dateformat(fdate,dateformat_style)# #timeformat(fdate,timeformat_style)#</td>
					</tr>
			</cfloop>
			</table>
		</td>
		</td>
		</tr>
		<table style="width:100%;">
			<tr>
				<td style="width:100px;"><cf_get_lang dictionary_id="57569.Görevli"><br/><b>#person#</b></td>
				<td  style="width:100px;"><cf_get_lang dictionary_id="58140.İş Grubu"></br> <b><cfif len(get_work.workgroup_id)>#get_assetp_groups.WORKGROUP_NAME#<cfelse>&nbsp;</cfif></b></td>
			</tr>
			</table>
				<br>
				<table>
					<tr class="fixed">
					<td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
					</tr>
				</br>
			</table>
		</table>
	  </td>
	  </tr>
	</table>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->