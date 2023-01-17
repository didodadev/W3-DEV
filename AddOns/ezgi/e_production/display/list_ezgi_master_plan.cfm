<cf_get_lang_set module_name="sales"><!--- sayfanin en altinda kapanisi var --->
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_ezgi_master_plan">
<cfif isDefined('attributes.date1') and isdate(attributes.date1)>
	<cfset adres = '#adres#&date1=#attributes.date1#'>
</cfif>
<cfif isDefined('attributes.date2') and isdate(attributes.date2)>
	<cfset adres = '#adres#&date2=#attributes.date2#'>
</cfif>
<cfif isDefined('attributes.page_action_type')>
	<cfset adres = '#adres#&page_action_type=#attributes.page_action_type#'>
</cfif>
<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
	<cfset adres = '#adres#&keyword=#attributes.keyword#'>
</cfif>
<cfif isDefined('attributes.paper_number') and len(attributes.paper_number)>
	<cfset adres = '#adres#&paper_number=#attributes.paper_number#'>
</cfif>
<cfif isDefined('attributes.account')>
	<cfset adres = '#adres#&account=#attributes.account#'>
</cfif>
<cfif isDefined('attributes.oby') and len(attributes.oby)>
	<cfset adres = '#adres#&oby=#attributes.oby#'>
</cfif>
<cfif isdefined('attributes.oil_stage') and len(attributes.oil_stage)>
	<cfset adres = '#adres#&oil_stage=#attributes.oil_stage#'>
</cfif>
<cfif isdefined('attributes.account_status') and len(attributes.account_status)>
	<cfset adres = '#adres#&account_status=#attributes.account_status#'>
</cfif>
<cfif isdefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
	<cfset adres = adres&"&is_form_submitted=1">
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih = "attributes.date1">
<cfelse>	
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.date1 = ''>
	<cfelse>
		<cfset attributes.date1 = session.ep.period_start_date>
	</cfif>
</cfif>

<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih = "attributes.date2">
<cfelse>	
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.date2 = ''>
	<cfelse>
		<cfset attributes.date2 = session.ep.period_finish_date>
	</cfif>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.paper_number" default="">
<cfparam name="attributes.search_id" default="">
<cfparam name="attributes.search_name" default="">
<cfparam name="attributes.search_type" default="">
<cfparam name="attributes.emp_type" default="">
<cfparam name="attributes.emp_name" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.oby" default="1">
<cfparam name="attributes.special_definition_id" default="">
<cfparam name="bakiye" default="0">
<cfparam name="attributes.action_bank" default="2">
<cfparam name="attributes.page_action_type" default="">
<cfparam name="attributes.oil_stage" default="">
<cfparam name="attributes.account_status" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="#ListgetAt(session.ep.User_Location,1,'-')#">
<!---<cfparam name="attributes.department_id" default="17">--->
<cfset type = "">
<cfset genel_bakiye = 0>
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_ezgi_master_plan.cfm">
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_actions.recordcount = 0>
	<cfset arama_yapilmali = 1>
</cfif>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
    	BRANCH_ID,
        BRANCH_NAME 
  	FROM 
    	BRANCH 
	WHERE
		COMPANY_ID = #session.ep.COMPANY_ID# AND	
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
	ORDER BY 
    	BRANCH_NAME
</cfquery>
<cfquery name="get_departments" datasource="#dsn#">
	SELECT        
    	DEPARTMENT_ID, 
        DEPARTMENT_HEAD
	FROM            
    	DEPARTMENT
	WHERE        
    	DEPARTMENT_STATUS = 1 AND 
        IS_PRODUCTION = 1 AND 
        BRANCH_ID IN
        			(
                    	SELECT 
    						BRANCH_ID
                        FROM 
                            BRANCH 
                        WHERE
                            COMPANY_ID = #session.ep.COMPANY_ID# AND	
                            BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                    )
</cfquery>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%master_plan%">
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_actions.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="bank_list" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_ezgi_master_plan" method="post">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
 	<cf_big_list_search title="#getLang('main',3197)#"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
                    <td><cf_get_lang_main no='468.Belge No'></td>
					<td><cfinput type="text" name="paper_number" id="paper_number" style="width:85px;" value="#attributes.paper_number#"></td>
                    <!---<td>
						<select name="prod_order_stage" style="width:125px; height:20px">
							<option value=""><cf_get_lang_main no='1447.Süreç'></option>
							<cfoutput query="get_process_type">
								<option value="#process_row_id#"<cfif isdefined('attributes.oil_stage') and attributes.oil_stage eq process_row_id>selected</cfif>>#stage#</option>
							</cfoutput>
						</select>
					</td>--->
					<td>
                      <select name="department_id" style="width:150px; height:20px">
						<cfoutput query="get_departments">
							<option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department_id') and attributes.department_id eq DEPARTMENT_ID>selected</cfif>>#DEPARTMENT_HEAD#</option>
						</cfoutput>
					  </select>
                 	</td>
                    <td><cf_get_lang_main no='1512.Sıralama'></td>
                    <td align="center">
                        <select name="oby" style="width:120px; height:20px">
                            <option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
                            <option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
                        </select>
                  	</td>
                    <td><cf_get_lang_main no='482.Statü'></td>
                    <td align="center">
                        <select name="account_status" style="width:80px; height:20px">
                            <option value=""><cf_get_lang_main no='296.Tümü'></option>
                            <option value="1"<cfif isDefined("attributes.account_status") and (attributes.account_status eq 1)> selected</cfif>><cf_get_lang_main no='3198.İşleyen'></option>
                            <option value="0"<cfif isDefined("attributes.account_status") and (attributes.account_status eq 0)> selected</cfif>><cf_get_lang_main no='3105.Biten'></option>
                        </select>
                    </td>
                    <td><cf_wrk_search_button></td>
              	</tr>
          	</table>
		</cf_big_list_search_area>
     	<cf_big_list_search_detail_area>   
        	<table>
            	<tr>

                	<td style="text-align:right;">
						<cf_get_lang_main no='487.Kaydeden'>
						<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
						<input name="record_emp_name" type="text" id="record_emp_name" style="width:120px;" onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','bank_list','3','125');" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput> </cfif>" autocomplete="off">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=bank_list.record_emp_name&field_emp_id=bank_list.record_emp_id<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,9','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</td>
					
                    <td>
					  <select name="branch_id" style="width:100px; height:20px">
						<option value=""><cf_get_lang_main no='41.Şube'></option>
						<cfoutput query="get_branchs">
							<option value="#branch_id#"<cfif isdefined('attributes.branch_id') and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
						</cfoutput>
					  </select>
                  	</td>
                    <td>
						<cf_get_lang_main no='215.Kayıt Tarihi'>
						<cfsavecontent variable="record_date"><cf_get_lang_main no ='1091.Lütfen Tarih giriniz'></cfsavecontent>
						<cfinput type="text" name="record_date" value="#dateformat(attributes.record_date,'dd/mm/yyyy')#" style="width:65px" validate="eurodate" message="#record_date#">
						<cf_wrk_date_image date_field="record_date">
						<cfinput type="text" name="record_date2" value="#dateformat(attributes.record_date2,'dd/mm/yyyy')#" style="width:65px" validate="eurodate" message="#record_date#">
						<cf_wrk_date_image date_field="record_date2">
                   	</td>
                    <td>
						<cf_get_lang_main no='467.İşlem Tarihi'>
						<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
							<cfinput name="date1" type="text" value="#dateformat(attributes.date1,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10">
						<cfelse>
							<cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
							<cfinput value="#dateformat(attributes.date1,'dd/mm/yyyy')#" message="#message#" type="text" name="date1" required="yes" style="width:65px;" validate="eurodate" maxlength="10">
						</cfif>
						<cf_wrk_date_image date_field="date1">
						<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
							<cfinput value="#dateformat(attributes.date2,'dd/mm/yyyy')#" type="text" name="date2" style="width:65px;" validate="eurodate" maxlength="10">
						<cfelse>
							<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
							<cfinput value="#dateformat(attributes.date2,'dd/mm/yyyy')#" message="#message#" type="text" name="date2" required="yes" style="width:65px;" validate="eurodate" maxlength="10">
						</cfif>
						<cf_wrk_date_image date_field="date2">
                	</td>	
                </tr>
        	</table>
         </cf_big_list_search_detail_area>
	</cf_big_list_search>
</cfform>
<table class="big_list">
	<cf_big_list id="piece_">
	<thead>
		<tr>
			<th style="width:30px;text-align:center; height:20px" class="header_icn_txt"><cf_get_lang_main no='1165.Sira'></th>
          	<th style="width:65px;text-align:center"><cf_get_lang_main no='468.Belge No'></th>
		  	<th style="width:70px;text-align:center"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
          	<th style="width:70px;text-align:center"><cfoutput>#getLang('report',753)#</cfoutput></th>
          	<th style="width:70px;text-align:center"><cf_get_lang_main no='1457.Planlanan'></th>
          	<th style="width:70px;text-align:center"><cfoutput>#getLang('myhome',734)#</cfoutput></th>
          	<th style="width:95px;text-align:center"><cfoutput>#getLang('prod',291)#</cfoutput></th>
          	<th style="width:95px;text-align:center"><cfoutput>#getLang('prod',293)#</cfoutput></th>
          	<th style="width:170px;text-align:center"><cf_get_lang_main no='3199.Master Plan Adı'></th>
		  	<th style="text-align:center"><cf_get_lang_main no='217.Açıklama'></th>
		  	<th style="width:50px;text-align:center"><cf_get_lang_main no='1447.Süreç'></th>
		  	<th style="width:15px;text-align:center">&nbsp;</th>
            <!-- sil --><th class="header_icn_none"> <a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.</cfoutput>form_add_ezgi_master_plan"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='3200.İşlem Tipi Ekle'>"> </a></th><!-- sil -->
		</tr>
   	</thead>
	<tbody>
		<cfif get_actions.recordcount>
			<cfset g_bakiye = 0>
            <cfset t_bakiye = 0>
            <cfset h_bakiye = 0>
			<cfoutput query="get_actions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfquery  name="GET_PROCESS"  dbtype="query">
					SELECT
							STAGE,
							PROCESS_ROW_ID 
					FROM 
							GET_PROCESS_TYPE
					WHERE
							PROCESS_ROW_ID=#MASTER_PLAN_STAGE#
				</cfquery>
				<tr>
					<td style="text-align:right">#get_actions.currentrow#&nbsp;</td>
					<td style="text-align:center">
                    	<a href="#request.self#?fuseaction=prod.form_upd_ezgi_master_plan&upd_id=#MASTER_PLAN_ID#" class="tableyazi">
                    		#get_actions.MASTER_PLAN_NUMBER#
                   		</a>
                    </td>
					<td style="text-align:center">#dateformat(get_actions.record_date,'dd/mm/yyyy')#</td>
                    <td style="text-align:right">#Tlformat(H_POINT,2)#&nbsp;</td>
                    <td style="text-align:right">#Tlformat(T_POINT,2)#&nbsp;</td>
                    <td style="text-align:right">#Tlformat(G_POINT,2)#&nbsp;</td>
   					<td style="text-align:center">#dateformat(get_actions.MASTER_PLAN_START_DATE,'dd/mm/yyyy')#</td>
                    <td style="text-align:center">#dateformat(get_actions.MASTER_PLAN_FINISH_DATE,'dd/mm/yyyy')#</td>
					<td>#MASTER_PLAN_NAME#</td>
					<td>#MASTER_PLAN_DETAIL#</td>
					<td style="text-align:center">#GET_PROCESS.STAGE#</td>

					<td style="text-align:right;">
						<cfif MASTER_PLAN_PROCESS eq 1>
							 <img src="/images/yesil_top.png" title="<cf_get_lang_main no='3201.Başladı'>">
						<cfelse>
							 <img src="/images/siyah.png" title="<cf_get_lang_main no='3108.Bitti'>">
						</cfif>       
					</td>
					
					<td align="center"><a href="#request.self#?fuseaction=prod.form_upd_ezgi_master_plan&upd_id=#MASTER_PLAN_ID#"> <img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Düzenle'>" border="0"></a>
					</td>
					<cfset g_bakiye = g_bakiye+G_POINT>
					<cfset t_bakiye = t_bakiye+T_POINT>
                    <cfset h_bakiye = h_bakiye+H_POINT>
				</tr>
			</cfoutput>
			<cfoutput>
				<tr class="color-row" height="20">
					<td colspan="3" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
					<td class="txtbold" style="text-align:right;">#TLFormat(h_bakiye,2)#&nbsp;</td>
					<td class="txtbold" style="text-align:right;">#TLFormat(t_bakiye,2)#&nbsp;</td>
                    <td class="txtbold" style="text-align:right;">#TLFormat(g_bakiye,2)#&nbsp;</td>
					<td colspan="7">&nbsp;</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr height="20" class="color-row">
				<td colspan="14"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'><cfelse><cf_get_lang_main no='72.Kayıt Yok'></cfif>!</td>
			</tr>
		</cfif>
   	</tbody>
    </cf_big_list>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfif isDefined('attributes.search_id') and len(attributes.search_id)>
		<cfset adres = '#adres#&search_id=#attributes.search_id#'>
	</cfif>
	<cfif isDefined('attributes.emp_id') and len(attributes.emp_id)>
		<cfset adres = '#adres#&emp_id=#attributes.emp_id#'>
	</cfif>
	<cfif isDefined('attributes.emp_name') and len(attributes.emp_name)>
		<cfset adres = '#adres#&emp_name=#attributes.emp_name#'>
	</cfif>
	<cfif isDefined('attributes.branch_id') and len(attributes.branch_id)>
		<cfset adres = '#adres#&branch_id=#attributes.branch_id#'>
	</cfif>
	<cfif isDefined('attributes.record_emp_name') and len(attributes.record_emp_name)>
		<cfset adres = '#adres#&record_emp_id=#attributes.record_emp_id#'>
		<cfset adres = '#adres#&record_emp_name=#attributes.record_emp_name#'>
	</cfif>
	<cfif isDefined('attributes.search_name') and len(attributes.search_name)>
		<cfset adres = '#adres#&search_name=#attributes.search_name#'>
	</cfif>
	<cfif isDefined('attributes.account_status') and len(attributes.account_status)>
		<cfset adres = '#adres#&account_status=#attributes.account_status#'>
	</cfif>
	<cfif isDefined ("attributes.record_date")>
		<cfset adres = "#adres#&record_date=#dateformat(attributes.record_date,'dd/mm/yyyy')#">
	</cfif>
	<cfif isDefined ("attributes.record_date2")>
		<cfset adres = "#adres#&record_date2=#dateformat(attributes.record_date2,'dd/mm/yyyy')#">
	</cfif>
	<cfif isDefined('attributes.special_definition_id') and len(attributes.special_definition_id)>
		<cfset adres = '#adres#&special_definition_id=#attributes.special_definition_id#'>
	</cfif>
	<cfif isDefined('attributes.action_bank')>
		<cfset adres = '#adres#&action_bank=#attributes.action_bank#'>
	</cfif>
	<cfif isDefined('attributes.search_type') and len(attributes.search_type)>
		<cfif attributes.search_type is 'employee'>
			<cfset attributes.emp_name = get_emp_info(emp_id,0,0)>
		</cfif>
		<cfif attributes.search_type is 'partner'>
			<cfset attributes.search_name = get_par_info(search_id,1,1,0)>
		<cfelseif attributes.search_type is 'consumer'>
			<cfset attributes.search_name = get_cons_info(search_id,0,0)> 
		</cfif>
		<cfset adres = '#adres#&search_type=#attributes.search_type#'>
	</cfif>
	<!-- sil -->
	  <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
		<tr>
		  <td colspan="5">
			<cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#"
				adres="#adres#">
			</td>
		  <td colspan="5" align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_actions.recordcount# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	  </table>
	<!-- sil -->
</cfif>
<script language="javascript">
function hesap_sec()
{
	if(document.bank_list.search_id.value!='')
	{
		document.bank_list.search_id.value='';
		document.bank_list.emp_name.value='';
		document.bank_list.emp_type.value='';
	}
	if(document.bank_list.emp_id.value!='')
	{
		document.bank_list.emp_id.value='';
		document.bank_list.emp_name.value='';
		document.bank_list.emp_type.value='';
	}
	if(document.bank_list.search_type.value!='')
	{
		document.bank_list.search_type.value='';
		document.bank_list.emp_name.value='';
		document.bank_list.emp_type.value='';
	}
}
	document.bank_list.keyword.select();
</script>
<br>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->