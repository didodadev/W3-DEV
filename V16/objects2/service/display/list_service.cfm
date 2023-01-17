<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfparam name="attributes.is_submit" default="0">
<cfif isdefined("session.service_reply")>
	<cfscript>structdelete(session,"service_reply");</cfscript>
</cfif>
<cfif isdefined("session.service_task")>
	<cfscript>structdelete(session,"service_task");</cfscript>
</cfif>

<cfparam name="attributes.page" default=1>
<cfif isdefined("session.pp")>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfelseif isdefined("session.ww")>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif attributes.is_submit>
	<cfinclude template="../query/get_service.cfm">
<cfelse>
	<cfset get_service.recordcount = 0>
</cfif>

<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.list_service%">
</cfquery>
<cfinclude template="../query/get_service_status.cfm">
<cfinclude template="../query/get_service_appcat.cfm">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.subscription_id" default=''>
<cfparam name="attributes.subscription_no" default=''>
<cfparam name="attributes.process_stage" default=''>
<cfparam name="attributes.status" default="1">

<cfif get_service.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_service.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>

<cfform name="form1" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
    <input type="hidden" name="is_submit" id="is_submit" value="1">
    <table cellpadding="0" cellspacing="0" border="0" align="center" style="width:100%">
        <tr style="height:35px;">
            <td>        	
                <table align="right">				
                    <tr>
                        <td><cf_get_lang_main no='48.Filtre'>:</td>
                        <td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#"></td>
                        <cfif isdefined('attributes.is_service_hier') and (attributes.is_service_hier eq 1 or  attributes.is_service_hier eq 4)>
                            <td>
                                Müşteri
                                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">								  
                                <input type="text" name="company_name" id="company_name" value="<cfif isdefined("attributes.company_name")><cfoutput>#attributes.company_name#</cfoutput></cfif>" style="width:130px;" onfocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_relation_member_objects2','\'1\',\'0\',\'0\',\'\',\'2\',\'1\'','COMPANY_ID','company_id','form1','3','250');" value="" autocomplete="off">
                            </td>
                        </cfif>
                        <td><cf_get_lang_main no='1420.abone'>:</td>
                        <td>
                            <input type="hidden" name="subscription_id" id="subscription_id" value="<cfif len(attributes.subscription_id)><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
                            <input type="text" name="subscription_no" id="subscription_no" value="<cfif len(attributes.subscription_no)><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" readonly style="width:100px;">
                            <cfset str_subscription_link="field_partner=&field_id=form1.subscription_id&field_no=form1.subscription_no">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_list_subscriptions&#str_subscription_link#'</cfoutput>,'list','popup_list_subscriptions');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                        </td>
                        <td>
                            <select name="process_stage" id="process_stage">
                                <option value=""><cf_get_lang_main no='70.Aşama'></option>
                                <cfoutput query="get_process_stage">
                                    <option value="#process_row_id#" <cfif attributes.process_stage eq process_row_id>selected</cfif>>#stage#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="height:35px;">
            <td>
                <table align="right">
                    <tr>
                        <td align="right" style="text-align:right;">
                            <select name="category" id="category">
                                <option value="" selected><cf_get_lang_main no='1739.Tüm Kategoriler'></option>
                                <cfoutput query="get_service_appcat">
                                    <option value="#servicecat_id#" <cfif isDefined('attributes.category') and attributes.category eq get_service_appcat.servicecat_id>selected</cfif>>#servicecat#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td align="right" style="text-align:right;">
                            <select name="sub_status" id="sub_status">
                                <option value="" selected><cf_get_lang no='644.Tüm Durumlar'></option>
                                <cfoutput query="get_service_substatus">
                                    <option value="#service_substatus_id#" <cfif isDefined('attributes.sub_status') and attributes.sub_status eq get_service_substatus.service_substatus_id>selected</cfif>>#service_substatus#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td align="right" style="text-align:right;">
                            <select name="status" id="status">
                                <option value="" selected>Tümü</option>
                                <option value="0" <cfif isDefined('attributes.status') and attributes.status eq 0>selected</cfif>>Pasif</option>
                                <option value="1" <cfif isDefined('attributes.status') and attributes.status eq 1>selected</cfif>>Aktif</option>
                            </select>
                        </td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                          <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td><cf_wrk_search_button></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfform>
<cfset colspan_ = 7>
<cfif attributes.list_service_product eq 1>
	<cfset colspan_ = colspan_ + 1>
</cfif>
<cfif attributes.list_service_category eq 1>
	<cfset colspan_ = colspan_ + 1>
</cfif>
<cfif attributes.list_service_app eq 1>
	<cfset colspan_ = colspan_ + 1>
</cfif>
<cfif attributes.list_service_task eq 1>
	<cfset colspan_ = colspan_ + 1>
</cfif>
<cfif attributes.list_service_cargo eq 1>
	<cfset colspan_ = colspan_ + 1>
</cfif>

<table cellspacing="1" cellpadding="2" border="0" align="center" style="width:100%">
	<tr class="color-header" style="height:22px;">
	  	<td class="form-title" style="width:12px;"><cf_get_lang_main no='1262.Yeni'></td>
	  	<td class="form-title" style="width:50px;"><cf_get_lang_main no='75.No'></td>
	  	<td class="form-title" style="width:100px;"><cf_get_lang_main no='330.Tarih'></td>
	  	<td class="form-title" style="width:90px;"><cf_get_lang_main no='70.Aşama'></td>
	  	<td class="form-title" style="width:90px;">Durum</td>
	  	<td class="form-title"><cf_get_lang_main no='68.Konu'></td>
	  	<cfif attributes.list_service_product eq 1>
		  	<td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
		</cfif>
	  	<cfif attributes.list_service_category eq 1>
		  	<td class="form-title" style="width:100px;"><cf_get_lang_main no='74.Kategori'></td>
	  	</cfif>
	  	<cfif attributes.list_service_app eq 1>
		  	<td class="form-title"><cf_get_lang no='40.Başvuru Sahibi'></td>
	  	</cfif>
	  	<td class="form-title"><cf_get_lang_main no='225.Seri No'></td>
	  	<cfif attributes.list_service_task eq 1>
		  	<td class="form-title"><cf_get_lang_main no='157.Görevli'></td>
	  	</cfif>
	  	<cfif attributes.list_service_cargo eq 1>
		  	<td class="form-title"><cf_get_lang no='645.Kargo'></td>
	  	</cfif>
	</tr>
   	<cfif get_service.recordcount>
		<cfset service_id_list=''>
		<cfset ship_service_id_list =''>
		<cfoutput query="get_service">
			<cfset service_id_list = Listappend(service_id_list,service_id)>
		</cfoutput>
		<cfif len(service_id_list)>
			<cfquery name="GET_SHIP" datasource="#DSN2#">
				SELECT SR.SERVICE_ID FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID = SR.SHIP_ID AND SR.SERVICE_ID IN (#service_id_list#) AND S.SHIP_TYPE = 141 ORDER BY SR.SERVICE_ID
			</cfquery>
			<cfset ship_service_id_list = listsort(listdeleteduplicates(valuelist(get_ship.service_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_service">
	  		<tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
				<td align="center"><cfif isread eq 0><font color="##ff0000"> *</font></cfif></td>
				<td>#service_no#</td>
				<td>
					<cfif isdefined("session.pp.time_zone")>
						#dateformat(date_add('h',session.pp.time_zone,get_service.apply_date),'dd/mm/yyyy')# 
						#timeformat(date_add('h',session.pp.time_zone,get_service.apply_date),'HH:MM')#
					<cfelse>
						#dateformat(date_add('h',session.ww.time_zone,get_service.apply_date),'dd/mm/yyyy')# 
						#timeformat(date_add('h',session.ww.time_zone,get_service.apply_date),'HH:MM')#
					</cfif>
				</td>
				<td>#stage#</td>
				<cfif len(service_substatus_id)>
					<cfquery name="GET_SERVICE_SUBSTATUE" dbtype="query">
						SELECT SERVICE_SUBSTATUS FROM GET_SERVICE_SUBSTATUS WHERE SERVICE_SUBSTATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_substatus_id#">
					</cfquery>
					<td>#get_service_substatue.service_substatus#</td>
				<cfelse>
					<td></td>
				</cfif>
				<td><a href="#request.self#?fuseaction=objects2.upd_service&service_id=#get_service.service_id#" class="tableyazi">#service_head#</a></td>
				<cfif attributes.list_service_product eq 1>
					<td>#product_name#</td>
				</cfif>
				<cfif attributes.list_service_category eq 1>
					<td>#servicecat#</td>
				</cfif>
				<cfif attributes.list_service_app eq 1>
					<td>
					  <cfif get_service.service_partner_id neq 0>#get_par_info(service_partner_id,0,0,0)#</cfif>
					  <cfif get_service.service_consumer_id neq 0>#get_cons_info(service_consumer_id,0,0)#</cfif>
					  <cfif get_service.service_employee_id neq 0>#get_emp_info(service_employee_id,0,0)#</cfif>
					</td>
				</cfif>
				<td>#pro_serial_no#</td>
				<cfif attributes.list_service_task eq 1>
					<td>
					  	<cfset service_id=get_service.service_id>
					  	<cfinclude template="../query/get_service_task.cfm">
					  	<cfif get_service_task.recordcount>
							<cfloop query="get_service_task">
							  <cfif (get_service_task.outsrc_partner_id neq 0) and len(get_service_task.outsrc_partner_id)>
								#get_par_info(OUTSRC_PARTNER_ID,0,0,1)#
							  </cfif>
							  <cfif (get_service_task.project_emp_id neq 0) and len(get_service_task.project_emp_id)>
								#get_emp_info(PROJECT_EMP_ID,0,0)#
							  </cfif>
							<br/>
							</cfloop>
					  	</cfif>
					</td>
				</cfif>
				<cfif attributes.list_service_cargo eq 1>
					<cfif listfind(ship_service_id_list,service_id,',')>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_cargo_information&cargo_type=2&service_no=#service_no#','horizantal','popup_cargo_information');"><img src="/images/ship.gif" title="Kargo Bilgileri" border="0"></a></td>
					<cfelse>
						<td></td>
					</cfif>
				</cfif>
	  		</tr>
		</cfoutput>	
	<cfelse>
		<tr class="color-row" style="height:20px;">
	  		<td colspan="<cfoutput>#colspan_#</cfoutput>"><cfif attributes.is_submit><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
		</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  	<table cellpadding="0" cellspacing="0" align="center" style="width:100%; height:35px;">
		<tr>
		  	<td>
				<cfset adres="#attributes.fuseaction#">
					<cfset adres = adres&"&keyword="&attributes.keyword>
				<cfif isDefined('attributes.category') and len(attributes.category)>
					<cfset adres = adres&"&category="&attributes.category>
				</cfif>
				<cfif isDefined('attributes.status') and len(attributes.status)>
					<cfset adres = adres&"&status="&attributes.status>
				</cfif>
				<cfif isDefined('attributes.sub_status') and len(attributes.sub_status)>
					<cfset adres = adres&"&sub_status="&attributes.sub_status>
				</cfif>
				<cfif isDefined('attributes.subscription_id') and len(attributes.subscription_id)>
					<cfset adres = adres&"&subscription_id="&attributes.subscription_id>
				</cfif>
				<cfif isDefined('attributes.subscription_no') and len(attributes.subscription_no)>
					<cfset adres = adres&"&subscription_no="&attributes.subscription_no>
				</cfif>
				<cfif isDefined('attributes.company_id') and len(attributes.company_id)>
					<cfset adres = adres&"&company_id="&attributes.company_id>
				</cfif>
				<cfif isDefined('attributes.process_stage') and len(attributes.process_stage)>
					<cfset adres = adres&"&process_stage="&attributes.process_stage>
				</cfif>
				<cfif isDefined('attributes.is_submit') and len(attributes.is_submit)>
					<cfset adres = adres&"&is_submit="&attributes.is_submit>
				</cfif>
				<cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#adres#">
		  	<td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
  	</table>
</cfif>
