<cfif isdefined("session.pp.userid")>
	<cfquery name="get_comp_hier" datasource="#dsn#">
		SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	</cfquery>
	<cfset list_comp_hier = ''>
	<cfoutput query="get_comp_hier">
		<cfif len(company_id) and not listfind(list_comp_hier,company_id)>
			<cfset list_comp_hier = Listappend(list_comp_hier,company_id)>
		</cfif>
	</cfoutput>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.s_status" default="1">
<cfparam name="attributes.subscription_type" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfif len(list_comp_hier)>
	<cfquery name="get_subscription" datasource="#dsn3#">
		SELECT
			SC.SUBSCRIPTION_ID,
			SC.SUBSCRIPTION_NO,
			SC.SUBSCRIPTION_HEAD,
			SC.PARTNER_ID,
			SC.COMPANY_ID,
			SC.CONSUMER_ID,
			SC.SALES_EMP_ID,
			SC.SALES_COMPANY_ID,
			SC.SUBSCRIPTION_STAGE,
			SC.MONTAGE_DATE,
			SC.START_DATE,
			SC.FINISH_DATE,
			SC.RECORD_EMP,
			SC.SUBSCRIPTION_ADD_OPTION_ID,
			SC.SALES_ADD_OPTION_ID,
			SST.SUBSCRIPTION_TYPE
		FROM
			SUBSCRIPTION_CONTRACT SC,
			SETUP_SUBSCRIPTION_TYPE AS SST
		WHERE
			(
			COMPANY_ID IN (#list_comp_hier#) OR
			INVOICE_COMPANY_ID IN (#list_comp_hier#)
			) AND
			<cfif attributes.s_status eq 1>
				SC.IS_ACTIVE = 1 AND
			<cfelseif attributes.s_status eq 0>
				SC.IS_ACTIVE = 0 AND
			</cfif>
			SUBSCRIPTION_ID IS NOT NULL AND 
			SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID
			<cfif isdefined('attributes.process_stage_type') and len(attributes.process_stage_type)> 
				AND SC.SUBSCRIPTION_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type#">
			</cfif>
			<cfif isdefined('attributes.subscription_type') and len(attributes.subscription_type)> 
				AND SC.SUBSCRIPTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_type#">
			</cfif>
			<cfif len(attributes.keyword)>
			AND (
					SC.SUBSCRIPTION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					SC.SUBSCRIPTION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_subscription.recordcount = 0>
</cfif>
<cfquery name="GET_SUBSCRIPTION_TYPE" datasource="#DSN3#">
	SELECT SUBSCRIPTION_TYPE_ID, SUBSCRIPTION_TYPE FROM SETUP_SUBSCRIPTION_TYPE ORDER BY SUBSCRIPTION_TYPE
</cfquery>
<cfquery name="GET_SERVICE_STAGE" datasource="#DSN#">
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
		<cfif isdefined("session.pp")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_subscription_contract%">
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_subscription.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table cellspacing="0" cellpadding="0" width="100%" border="0" align="center">
  <tr class="formbold" height="27">
    <td align="right" style="text-align:right;">
      <!---Arama --->
      <table>
        <cfform name="list_subscription" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
          <tr>
            <td><cf_get_lang_main no='48.Filtre'>:</td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
			<td><select name="subscription_type" id="subscription_type" style="width:100px;">
					<option value="">Kategori</option>
					<cfoutput query="get_subscription_type">
						<option value="#subscription_type_id#" <cfif attributes.subscription_type eq subscription_type_id>selected</cfif>>#subscription_type#</option>
					</cfoutput>
				</select>
			</td>
			<td><select name="process_stage_type" id="process_stage_type" style="width:125px;">
					<option value="">Aşama</option>
					<cfoutput query="get_service_stage">
						<option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
					</cfoutput>
				</select>
			</td>
			<td>
				<select name="s_status" id="s_status">
					<option value=""><cf_get_lang_main no='296.Tümü'></option>
					<option value="1" <cfif attributes.s_status eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
					<option value="0" <cfif attributes.s_status eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
				</select>
			</td>
            <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td><cf_wrk_search_button></td>
            </tr>
        </cfform>
      </table>
      <!---Arama --->
    </td>
  </tr>
</table>
<table cellspacing="1" cellpadding="2" width="100%" border="0">
	<tr class="color-header" height="20">
		<td class="form-title" width="60"><cf_get_lang_main no='1705.Sistem No'></td>
		<td class="form-title"><cf_get_lang_main no='821.Tanim'></td>
		<td class="form-title">Müsteri</td>
		<td class="form-title"><cf_get_lang_main no='74.Kategori'></td>
		<td class="form-title"><cf_get_lang_main no='70.Asama'></td>
		<td width="40"></td>
	</tr>
	<cfif get_subscription.recordcount and len(list_comp_hier)>
	<cfset process_list=''>
	<cfset company_list=''>
		<cfoutput query="get_subscription" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(get_subscription.subscription_stage) and not listfind(process_list,get_subscription.subscription_stage)>
				<cfset process_list = listappend(process_list,get_subscription.subscription_stage)>
			</cfif>
			<cfif len(get_subscription.company_id) and not listfind(company_list,get_subscription.company_id)>
				<cfset company_list = listappend(company_list,get_subscription.company_id)>
			</cfif>
		</cfoutput>
		<cfif len(process_list)>
			<cfset process_list=listsort(process_list,"numeric","ASC",",")>
			<cfquery name="get_process_type" datasource="#dsn#">
				SELECT 
					STAGE,
					PROCESS_ROW_ID
				FROM
					PROCESS_TYPE_ROWS
				WHERE
					PROCESS_ROW_ID IN (#process_list#)
			</cfquery>
			<cfset main_process_list = listsort(listdeleteduplicates(valuelist(get_process_type.process_row_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(company_list)>
			<cfset company_list=listsort(company_list,"numeric","ASC",",")>
			<cfquery name="get_company_" datasource="#dsn#">
				SELECT 
					FULLNAME,
					COMPANY_ID
				FROM
					COMPANY
				WHERE
					COMPANY_ID IN (#company_list#)
				ORDER BY COMPANY_ID
			</cfquery>
			<cfset main_company_list = listsort(listdeleteduplicates(valuelist(get_company_.company_id,',')),'numeric','ASC',',')>
		</cfif> 
		<cfoutput query="get_subscription" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td width="60"><a href="javascript://" onclick="sent_subscription(#get_subscription.subscription_id#)" class="tableyazi">#subscription_no#</a></td>
				<td>#left(subscription_head,50)#</td>
				<td><cfif len(company_id)>#get_company_.fullname[listfind(main_company_list,get_subscription.company_id,',')]#</cfif></td>
				<td>#subscription_type#</td>
				<td><cfif len(subscription_stage)>#get_process_type.STAGE[listfind(main_process_list,get_subscription.subscription_stage,',')]#</cfif></td> 
				<td align="center">
				<a href="#request.self#?fuseaction=objects2.add_service&subscription_id=#subscription_id#&subscription_no=#subscription_no#"><img src="/images/transfer.gif" title="Servis Basvurusu Ekle" border="0" align="absmiddle"></a>
				<a href="javascript://" onclick="sent_subscription(#get_subscription.subscription_id#);" class="tableyazi"><img src="/images/update_list.gif" title="Display" border="0"></a>
				</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row">
			<td colspan="7"><cf_get_lang_main no='72.Kayit Bulunamadi'> !</td>
		</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table cellpadding="0" cellspacing="0" border="0" align="center" width="98%" height="30">
    <tr>
      <td> <cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="#attributes.fuseaction#&keyword=#attributes.keyword#&s_status=#attributes.s_status#&is_submited=1"> </td>
     <td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayit'>:#get_subscription.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
</cfif>
<form name="pop_gonder" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.dsp_subscription" method="post">
	<input type="hidden" name="subscription_id" id="subscription_id" value="">
</form>
<script type="text/javascript">
	function sent_subscription(degisken)
	{
		document.pop_gonder.subscription_id.value = degisken;
		pop_gonder.submit();
	}
</script>
