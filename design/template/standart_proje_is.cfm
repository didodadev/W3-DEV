<cf_get_lang_set module_name="project">
<!--- Proje İs Printi --->
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
		SELECT GROUP_ID, GROUP_NAME FROM SETUP_ASSETP_GROUP WHERE GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_WORK.WORKGROUP_ID#">
	</cfquery>
</cfif>
<cfoutput>
<table>
	<tr><td style="height:10mm;">&nbsp;</td></tr>
</table>
<table width="650" border="0" align="center" style="border:1 solid ##000000;">
	<tr style="height:10mm;">
		<td width="100" class="formbold"><cf_get_lang_main no="70.Aşama"> :</td>
		<td width="180">#get_procurrency.stage#</td>
		<td width="50" class="formbold"><cf_get_lang_main no="73.Öncelik"> :</strong></td>
		<td>#get_cats.priority#</td>
	</tr>
	<tr style="height:10mm;">
		<td width="100" class="formbold"><cf_get_lang_main no="4.Proje"> :</td>
		<td width="180">
			<cfif len(get_work.project_id)>
				#get_pro_name.project_head#
			<cfelse>
				<cf_get_lang_main no="1047.Projesiz">
			</cfif>
		</td>
		<td width="80" class="formbold"><cf_get_lang no="148.İş İlişkisi"> : </td>
		<td>
			<cfif len(get_work.RELATED_WORK_ID)>
				;#get_rel_work.PRE_ID#<cfif Len(get_rel_work.RELATION_TYPE)>#get_rel_work.RELATION_TYPE#</cfif><cfif Len(get_rel_work.LAG)>#get_rel_work.LAG#</cfif>;
			<cfelse>
				&nbsp;
			</cfif>
		</td>
	</tr>
	<tr style="height:10mm;">
		<td width="100" valign="bottom" class="formbold"><cf_get_lang no="303.Şirket Yetkili"> :</td>
		<td colspan="3" valign="bottom">
			<cfif len(get_work.COMPANY_ID) and len(get_work.COMPANY_PARTNER_ID)>
				#get_partner_name.NICKNAME# &nbsp;&nbsp;&nbsp;&nbsp; #get_partner_name.COMPANY_PARTNER_NAME# #get_partner_name.COMPANY_PARTNER_SURNAME#
			<cfelse>
				&nbsp;
			</cfif>
		</td>
	</tr>
	<tr style="height:10mm;">
		<td width="100" class="formbold" valign="bottom"><cf_get_lang no="1408.Başlık"></td>
		<td colspan="3">#get_work.WORK_HEAD#</td>
	</tr>
	<tr style="height:10mm;">
		<td colspan="4" width="450"  class="formbold"><cf_get_lang_main no="217.Açıklama"> :</td>
	</tr> 
	<tr style="height:10mm;">
		<td colspan="4" width="450">#get_work.WORK_DETAIL#</td>
	</tr>
	<tr style="height:10mm;">
		<td width="100" class="formbold" valign="bottom"><cf_get_lang no="55.Tahmini Bütçe"> :</td>
		<td width="180" valign="bottom">#TLFormat(get_work.expected_budget)# &nbsp;&nbsp;&nbsp; #get_work.expected_budget_money#</td>
		<td width="120" align="left" class="formbold"><cf_get_lang_main no="243.Başlama Tarihi"> :</td>
		<td align="left">#dateformat(sdate,dateformat_style)# #timeformat(sdate,timeformat_style)#</td>
	</tr>
	<tr style="height:10mm;">
		<td width="100" class="formbold"><cf_get_lang no="56.Tahmini Süre"> :</td>
		<td width="180">#get_work.estimated_time# <cf_get_lang_main no="715.Dakika"></td>
		<td width="100" align="left" class="formbold"><cf_get_lang_main no="288.Bitiş Tarihi"> :</td>
		<td align="left">#dateformat(fdate,dateformat_style)# #timeformat(fdate,timeformat_style)#</td>
	</tr>
	<tr style="height:10mm;">
		<td width="100" class="formbold"><cf_get_lang no="57.İş Kategorisi"> :</td>
		<td width="180"><cfif len(get_work.work_cat_id)>#GET_WORK_CAT.work_cat#<cfelse>&nbsp;</cfif></td>
		<td width="100" align="left" class="formbold"><cf_get_lang_main no="157.Görevli"> :</td>
		<td align="left">#person#</td>
	</tr>
	<tr style="height:10mm;">
		<td width="100"></td>
		<td width="180"></td>
		<td width="100" align="left" class="formbold"><cf_get_lang_main no="728.İş Grubu"> :</td>
		<td align="left"><cfif len(get_work.workgroup_id)>#get_assetp_groups.group_name#<cfelse>&nbsp;</cfif></td>
	</tr>
</table>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
