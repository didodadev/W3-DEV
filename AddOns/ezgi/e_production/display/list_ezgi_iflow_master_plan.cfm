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
<cfparam name="attributes.action_bank" default="2">
<cfparam name="attributes.page_action_type" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.master_plan_status" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.paper_number" default="">
<cfparam name="attributes.shift_id" default="">
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_ezgi_iflow_master_plan">
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
<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
	<cfset adres = '#adres#&process_stage=#attributes.process_stage#'>
</cfif>
<cfif isdefined('attributes.master_plan_status') and len(attributes.master_plan_status)>
	<cfset adres = '#adres#&master_plan_status=#attributes.master_plan_status#'>
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

<cfset type = "">
<cfset genel_bakiye = 0>
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_ezgi_iflow_master_plan.cfm">
    <cfif get_master_plan.recordcount>
    	<cfset master_plan_list = ValueList(get_master_plan.MASTER_PLAN_ID)>
        <cfquery name="get_master_ids" datasource="#dsn3#">
            SELECT        
                EM.MASTER_PLAN_ID, PO.P_ORDER_ID
            FROM            
            	EZGI_IFLOW_MASTER_PLAN AS EM INNER JOIN
              	EZGI_IFLOW_PRODUCTION_ORDERS AS EI ON EM.MASTER_PLAN_ID = EI.MASTER_PLAN_ID INNER JOIN
            	PRODUCTION_ORDERS AS PO ON EI.LOT_NO = PO.LOT_NO
            WHERE        
                EM.MASTER_PLAN_ID IN (#master_plan_list#)
		</cfquery>
        <cfoutput query="get_master_ids">
        	<cfif isdefined('MASTER_PLAN_#MASTER_PLAN_ID#')>
            	<cfset 'MASTER_PLAN_#MASTER_PLAN_ID#' = ListAppend(Evaluate('MASTER_PLAN_#MASTER_PLAN_ID#'),P_ORDER_ID)>
            <cfelse>
            	<cfset 'MASTER_PLAN_#MASTER_PLAN_ID#' = P_ORDER_ID>
            </cfif>
        </cfoutput>
  	</cfif>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_master_plan.recordcount = 0>
	<cfset arama_yapilmali = 1>
</cfif>
<cfquery name="get_shift" datasource="#dsn#">
	SELECT        
    	SHIFT_ID, 
        SHIFT_NAME, 
        BRANCH_ID
	FROM            
    	SETUP_SHIFTS
	WHERE        
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
<cfparam name="attributes.totalrecords" default='#get_master_plan.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
   	<cf_big_list_search title="#getLang('main',3254)#" collapsed="1">
		<cf_big_list_search_area>
            <table>
                <tr height="20px">
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="keyword" id="keyword" style="width:150px;" value="#attributes.keyword#" maxlength="500"></td>
                    <td>
                    	<select name="oby" style="width:120px; height:20px">
                            <option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
                            <option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
                        </select>
                    </td>
					<td>
						<select name="shift_id" style="width:150px; height:20px">
						<cfoutput query="get_shift">
							<option value="#SHIFT_ID#"<cfif isdefined('attributes.shift_id') and attributes.shift_id eq SHIFT_ID>selected</cfif>>#SHIFT_NAME#</option>
						</cfoutput>
					  </select>
					</td>
                    <td>
                        <select name="master_plan_status" style="width:80px; height:20px">
                            <option value=""><cf_get_lang_main no='296.Tümü'></option>
                            <option value="1"<cfif isDefined("attributes.master_plan_status") and (attributes.master_plan_status eq 1)> selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                            <option value="0"<cfif isDefined("attributes.master_plan_status") and (attributes.master_plan_status eq 0)> selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                        </select>
                    </td>
                    <td nowrap="nowrap">
                   		<cf_get_lang_main no='641.Başlangıç Tarihi'>
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
					<td>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_list_ezgi_iflow_production_order','longpage');"><img src="/images/cizelge_emp.gif" title="<cf_get_lang_main no='3267.Üretim Emirleri Toplu Liste'>"></a>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_ezgi_production_analist','longpage');"><img src="/images/target_team.gif" title="<cf_get_lang_main no='3431.Üretim Sonuç Analizi'>"></a>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_display_ezgi_prod_menu_moduler&type=1&master_plan_id=1','longpage');"><img src="/images/table.gif" title="<cfoutput>#getLang('prod',220)# (#getLang('worknet',216)#)</cfoutput>"></a>
                    </td>
					<td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button search_function='input_control()'></td>
				</tr>
			</table>
        </cf_big_list_search_area>
   		<cf_big_list_search_detail_area>
			<table>
				<tr valign="middle">
                	<td style="text-align:right;">
						<cf_get_lang_main no='487.Kaydeden'>
						<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
						<input name="record_emp_name" type="text" id="record_emp_name" style="width:120px;" onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','search','3','125');" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput> </cfif>" autocomplete="off">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search.record_emp_name&field_emp_id=search.record_emp_id<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,9','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</td>
					<td>
						<select name="prod_order_stage" style="width:125px; height:20px">
							<option value=""><cf_get_lang_main no='1447.Süreç'></option>
							<cfoutput query="get_process_type">
								<option value="#process_row_id#"<cfif isdefined('attributes.process_stage') and attributes.process_stage eq process_row_id>selected</cfif>>#stage#</option>
							</cfoutput>
						</select>
					</td>
					<td style="text-align:right;">
                      
						<cf_get_lang_main no='215.Kayıt Tarihi'>
						<cfsavecontent variable="record_date"><cf_get_lang_main no ='1091.Lütfen Tarih giriniz'></cfsavecontent>
						<cfinput type="text" name="record_date" value="#dateformat(attributes.record_date,'dd/mm/yyyy')#" style="width:65px" validate="eurodate" message="#record_date#">
						<cf_wrk_date_image date_field="record_date">
						<cfinput type="text" name="record_date2" value="#dateformat(attributes.record_date2,'dd/mm/yyyy')#" style="width:65px" validate="eurodate" message="#record_date#">
						<cf_wrk_date_image date_field="record_date2">
                 	</td>
                </tr>
			</table>
		</cf_big_list_search_detail_area>
	</cf_big_list_search>
	
	<cf_big_list id="list_product_big_list">
        <thead>
            <tr valign="middle">
            	<th style="width:25px; text-align:center"><cf_get_lang_main no='75.No'></th>
              	<th style="width:75px; text-align:center"><cf_get_lang_main no='468.Belge No'></th>
              	<th style="width:70px; text-align:center"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
              	<th style="width:70px; text-align:center"><cfoutput>#getLang('report',753)#</cfoutput></th>
              	<th style="width:70px; text-align:center"><cf_get_lang_main no='1457.Planlanan'></th>
              	<th style="width:70px; text-align:center"><cfoutput>#getLang('report',1004)#</cfoutput></th>
              	<th style="width:95px; text-align:center"><cfoutput>#getLang('prod',291)#</cfoutput></th>
              	<th style="width:95px; text-align:center"><cfoutput>#getLang('prod',293)#</cfoutput></th>
              	<th style="width:125px; text-align:center"><cfoutput><cf_get_lang_main no='711.Planlama'> <cf_get_lang_main no='1239.Türü'></cfoutput></th>
              	<th style="text-align:center"><cf_get_lang_main no='217.Açıklama'></th>
              	<th style="width:50px; text-align:center"><cf_get_lang_main no='1447.Süreç'></th>
              	<th style="width:25px; text-align:center" class="header_icn_none">&nbsp;</th>
                <th style="width:20px; text-align:center; vertical-align:middle" class="header_icn_none" >
                	<input type="checkbox" alt="<cf_get_lang_main no='3009.Hepsini Seç'>" onClick="secim(-1);">
                </th>
              	<th style="width:25px; text-align:center"  class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.</cfoutput>add_ezgi_iflow_master_plan"><img src="/images/plus_list.gif" style="text-align:center" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a></th>
                <!-- sil -->
            </tr>
        </thead>
        <tbody>
            <cfif get_master_plan.recordcount>
				<cfset g_bakiye = 0>
				<cfset t_bakiye = 0>
                <cfset h_bakiye = 0>
                <cfoutput query="get_master_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
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
                        <td style="text-align:right">#currentrow#&nbsp;</td>
                        <td style="text-align:center">
                            <a href="#request.self#?fuseaction=prod.upd_ezgi_iflow_master_plan&master_plan_id=#MASTER_PLAN_ID#"  class="tableyazi">
                                #MASTER_PLAN_NUMBER#
                            </a>
                        </td>
                        <td style="text-align:center">#dateformat(record_date,'dd/mm/yyyy')#</td>
                        <td style="text-align:right">#Tlformat(H_POINT,2)#&nbsp;</td>
                        <td style="text-align:right">#Tlformat(T_POINT,2)#&nbsp;</td>
                        <td style="text-align:right">#Tlformat(G_POINT,2)#&nbsp;</td>
                        <td style="text-align:center">#dateformat(MASTER_PLAN_START_DATE,'dd/mm/yyyy')#</td>
                        <td style="text-align:center">#dateformat(MASTER_PLAN_FINISH_DATE,'dd/mm/yyyy')#</td>
                        <td>#MASTER_PLAN_NAME#</td>
                        <td>#MASTER_PLAN_DETAIL#</td>
                        <td style="text-align:center">#GET_PROCESS.STAGE#</td>
                        <!-- sil -->
                        <td style="text-align:center;">
                        	<cfif BITEN_EMIR_SAYISI eq 0>
                            	<img src="/images/yellow_glob.gif" title="<cf_get_lang_main no='3279.Başlamadı'>">
                           	<cfelseif BITEN_EMIR_SAYISI lt TOPLAM_EMIR_SAYISI>
                            	<img src="/images/green_glob.gif" title="<cf_get_lang_main no='3201.Başladı'>">
                            <cfelseif BITEN_EMIR_SAYISI gt TOPLAM_EMIR_SAYISI>
                            	<img src="/images/grey_glob.gif" title="<cf_get_lang_main no='3101.Arıza'>">
                            <cfelse>
                            	<img src="/images/red_glob.gif" title="<cf_get_lang_main no='3108.Bitti'>">
                            </cfif>
                        </td>
                        <td style="text-align:center;">
                        	<cfif isdefined('MASTER_PLAN_#MASTER_PLAN_ID#')>
                        		<input type="checkbox" name="select_sub_plan" value="#Evaluate('MASTER_PLAN_#MASTER_PLAN_ID#')#">
                            </cfif>
                        </td>
                        <td style="text-align:center"><a href="#request.self#?fuseaction=prod.upd_ezgi_iflow_master_plan&master_plan_id=#MASTER_PLAN_ID#"> <img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Düzenle'>" border="0"></a>
                        </td>
                        <cfset g_bakiye = g_bakiye+G_POINT>
                        <cfset t_bakiye = t_bakiye+T_POINT>
                        <cfset h_bakiye = h_bakiye+H_POINT>
                        <!-- sil -->
                    </tr>
                </cfoutput>
                <cfoutput>
                <tfoot>
                    <tr  height="20">
                        <td colspan="3" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
                        <td class="txtbold" style="text-align:right;">#TLFormat(h_bakiye,2)#&nbsp;</td>
                        <td class="txtbold" style="text-align:right;">#TLFormat(t_bakiye,2)#&nbsp;</td>
                        <td class="txtbold" style="text-align:right;">#TLFormat(g_bakiye,2)#&nbsp;</td>
                        <td colspan="8" style="text-align:right">
                        	<button type="button" name="material_button" id="material_button" onclick="secim(-2);" style="width:100px; height:30px; text-align:center;font-size:10px; font-weight:bold">
                          		<img src="/images/forklift.gif" alt="<cf_get_lang_main no='3247.Malzeme'>" border="0">&nbsp;<cf_get_lang_main no='3247.Malzeme'>
                       		</button>
                        </td>
                    </tr>
                </tfoot>
			</cfoutput>
            <cfelse>
                <tr> 
                    <td colspan="14" height="20"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
	</cf_big_list>
</cfform>  
<cf_paging 
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#&is_form_submitted=1">
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function input_control()
	{
		return true;	
	}
	function secim(type)
	{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
		p_order_id_list = '';
		chck_leng = document.getElementsByName('select_sub_plan').length;
		for(ci=0;ci<chck_leng;ci++)
		{
			var my_objets = document.all.select_sub_plan[ci];
			if(chck_leng == 1)
				var my_objets =document.all.select_sub_plan;
			if(type == -1){//hepsini seç denilmişse	
				if(my_objets.checked == true)
					my_objets.checked = false;
				else
					my_objets.checked = true;
			}
			else
			{
				if(my_objets.checked == true)
					p_order_id_list +=my_objets.value+',';
			}
		}
		p_order_id_list = p_order_id_list.substr(0,p_order_id_list.length-1);//sondaki virgülden kurtarıyoruz.
		if(list_len(p_order_id_list,','))
		{
			if(type == -2)
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_dsp_ezgi_iflow_product_metarial_need&p_order_id_list='+p_order_id_list,'longpage');
			else
				return false;
		}
	}
</script>