<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.service_type" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.form_submitted" default="1">
<cfparam name="attributes.task_status" default="">

<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date=''>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date=''>
</cfif>
<cfquery name="GET_SHIP_STAGE" datasource="#DSN#">
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
		<cfif isdefined("session.ep.company_id")>
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_warehouse_tasks%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfscript>
		if(isdefined("session.ep.userid"))
			get_warehouse_tasks_action = createObject("component", "v16.stock.cfc.get_warehouse_tasks");
		else
			get_warehouse_tasks_action = createObject("component", "cfc.get_warehouse_tasks");
        get_warehouse_tasks_action.dsn3 = dsn3;
        get_warehouse_tasks_action.dsn_alias = dsn_alias;
        get_warehouse_tasks = get_warehouse_tasks_action.get_warehouse_tasks_fnc(
			 keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			 process_stage_type : '#IIf(IsDefined("attributes.process_stage_type"),"attributes.process_stage_type",DE(""))#',
			 start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			 finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			 employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
			 employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
			 department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
			 department_name : '#IIf(IsDefined("attributes.department_name"),"attributes.department_name",DE(""))#',
			 company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			 company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
			 service_type:'#IIf(IsDefined("attributes.service_type"),"attributes.service_type",DE(""))#',
			 task_status :'#IIf(IsDefined("attributes.task_status"),"attributes.task_status",DE("1"))#'
		);
	</cfscript>
<cfelse>
	<cfset get_warehouse_tasks.recordCount = 0>
</cfif>


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_warehouse_tasks.recordcount#'>
<cf_box>
<cfform name="service_form" method="post" action="#request.self#?fuseaction=stock.list_warehouse_tasks">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cf_box_search> 

            	<div class="form-group">
                	<div class="input-group">
						<cfinput type="text" placeholder="#getlang('','Filtre','57460')#" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:60px;">
                	</div>
                </div>
				<div class="form-group">
					<select name="task_status" id="task_status" style="width:90px;">
						<option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
						<option value="-2" <cfif (attributes.task_status eq -2)> selected</cfif>><cf_get_lang dictionary_id="63848.Müşteri Kaydı"></option>
						<option value="-1" <cfif (attributes.task_status eq -1)> selected</cfif>><cf_get_lang dictionary_id="57704.İşlem Yapılıyor"></option>
						<option value="1" <cfif (attributes.task_status eq 1)> selected</cfif>><cf_get_lang dictionary_id="58699.Onaylandı"></option>
						<cfif not isdefined("session.pp.userid")><option value="0" <cfif (attributes.task_status eq 0)> selected</cfif>><cf_get_lang dictionary_id="59190.İptal Edildi"></option></cfif>
					</select>  
                </div>
				<div class="form-group">
                        <select name="service_type" id="service_type" style="width:90px;">
                            <option value=""><cf_get_lang dictionary_id='61806.İşlem Tipi'></option>
							<option value="1" <cfif (attributes.service_type eq 1)> selected</cfif>><cf_get_lang dictionary_id="63876.Shipment"></option>
							<option value="0" <cfif (attributes.service_type eq 0)> selected</cfif>><cf_get_lang dictionary_id="63877.Receiving"></option>
							<option value="2" <cfif (attributes.service_type eq 2)> selected</cfif>><cf_get_lang dictionary_id="63874.Sayım Sonucu"></option>
							<option value="3" <cfif (attributes.service_type eq 3)> selected</cfif>><cf_get_lang dictionary_id="63875.Sayım"></option>
                        </select>  
                </div>
				<cfif not isdefined("session.pp.userid")>
                <div class="form-group">
                    <div class="input-group">
                        <cf_wrkdepartmentlocation 
                            returnInputValue="department_name,department_id"
                            returnQueryValue="LOCATION_NAME,DEPARTMENT_ID"
                            fieldName="department_name"
                            fieldid="location_id"
                            department_fldId="department_id"
                            department_id="#attributes.department_id#"
                            location_name="#attributes.department_name#"
                            user_level_control="1"
							user_location="0"
                            width="100">
                    </div>
                </div>
				</cfif>
				
				<cfif not isdefined("session.pp.userid")>
                <div class="form-group">
                        <select name="process_stage_type" id="process_stage_type" style="width:90px;">
                            <option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
                            <cfoutput query="get_ship_stage">
                                <option value="#process_row_id#" <cfif (attributes.process_stage_type eq process_row_id)> selected</cfif>>#stage#</option>
                            </cfoutput>
                        </select>  
                </div>
				</cfif>				
                <div class="form-group">
                    <div class="input-group x-3_5">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                        <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                        <cf_wrk_search_button button_type="4" search_function="date_check(service_form.start_date,service_form.finish_date,'#message_date#')">
                </div>      
	</cf_box_search>
	<cf_box_search_detail>
    	<div class="row" type="row">
        	<cfif not isdefined("session.pp.userid")>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            	<div class="form-group" id="item-company">
                	<label class="col col-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                    <div class="col col-12">
                    	<div class="input-group">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                            <input type="text" name="company" id="company" value="<cfoutput>#attributes.company#</cfoutput>" style="width:130px;">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=service_form.company_id&field_comp_name=service_form.company&field_consumer=service_form.consumer_id&field_member_name=service_form.company&select_list=2,3','list','popup_list_all_pars');"></span>
                        </div>
                    </div>
                </div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-employee_id">						
                	<label class="col col-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>			
                    <div class="col col-12">
                        <div class="input-group">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                            <input name="employee_name" type="text" id="employee_name" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=service_form.employee_id&field_name=service_form.employee_name&is_form_submitted=1&select_list=1','list');"></span>
                        </div>
                    </div>
                </div>
			</div>
			</cfif>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-date">
                	<label class="col col-12"><cfoutput><cf_get_lang dictionary_id='57742.Tarih'></cfoutput></label>
                    <div class="col col-12">
                    	<div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                            <cfinput value="#dateformat(attributes.start_date,dateformat_style)#" type="text" name="start_date" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                            <span class="input-group-addon no-bg"></span>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                            <cfinput value="#dateformat(attributes.finish_date,dateformat_style)#" type="text" name="finish_date" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>           
	</cf_box_search_detail>
</cfform>
</cf_box>
<cfset t_quantity = 0>
<cfset t_pallet = 0>
<cf_box title="#getlang('','Depo İşlemleri','45369')#">
<cf_grid_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='57756.Durum'></th>
			<th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='58763.Depo'></th>
			<th><cf_get_lang dictionary_id='57457.Müşteri'></th>
			<th><cf_get_lang dictionary_id='57416.Müşteri'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='57635.Müşteri'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='37244.Palet'></th>
			<th><cf_get_lang dictionary_id='63850.Konteyner'></th>
			<th><cf_get_lang dictionary_id='63851.B/L No'></th>
			<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
            <!-- sil -->
			<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.list_warehouse_tasks&event=add&task_in_out=0"><i class="fa fa-arrow-circle-o-down" title="<cf_get_lang dictionary_id="63877.Receiving">"></i></a></th>
			<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.list_warehouse_tasks&event=add&task_in_out=1"><i class="fa fa-arrow-circle-o-up" title="<cf_get_lang dictionary_id="63876.Shipment">"></i></a></th>
				<cfif not isdefined("session.pp.userid")>
					<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.list_warehouse_tasks&event=add&task_in_out=3"><i class="fa fa-edit" title="<cf_get_lang dictionary_id="63875.Sayım">"></i></a></th>
				</cfif>
			</th>
			<th width="20" class="header_icn_none"><a><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></th>
			<th width="20" class="header_icn_none"><a><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464. Guncelle'>"></i></a></th>
			<!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_warehouse_tasks.recordcount>	
		<cfoutput query="get_warehouse_tasks" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>#currentrow#</td>
				<td>
					<cfif IS_ACTIVE eq 1><b style="color:green;"><cf_get_lang dictionary_id="58699.Onaylandı"></b><cfelseif IS_ACTIVE eq -1><b style="color:blue;"><cf_get_lang dictionary_id="57704.İşlem Yapılıyor"></b><cfelseif IS_ACTIVE eq -2><b style="color:orange;"><cf_get_lang dictionary_id="63848.Müşteri Kaydı"></b><cfelse><b style="color:red;"><cf_get_lang dictionary_id="59190.İptal Edildi"></b></cfif>
					<cfif IS_ACTIVE neq -2 and len(record_par)>
						- <b style="color:orange;">CR</b>
					</cfif>
				</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>"><cfif WAREHOUSE_IN_OUT eq 1><cf_get_lang dictionary_id="63876.Shipment"><cfelseif WAREHOUSE_IN_OUT eq 2><cf_get_lang dictionary_id="63874.Sayım Sonucu"><cfelseif WAREHOUSE_IN_OUT eq 3><cf_get_lang dictionary_id="63875.Sayım"><cfelse><cf_get_lang dictionary_id="63877.Receiving"></cfif></td>
				<td><a href="#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#task_id#" class="tableyazi">#TASK_NO#</a></td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>">#DEPARTMENT_HEAD#</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>">#fullname#</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>">#project_head#</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif> text-align:right;">#TOTAL_QUANTITY#</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif> text-align:right;">#TOTAL_PALLETS + TOTAL_ADD_PALLETS#</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>">#container#</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>">#bl_number#</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>">#ACTION_MAN#</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>">#dateformat(ACTION_DATE,dateformat_style)#</td>
				<!-- sil --><td class="header_icn_none">
					<cfif len(cargo_type) and len(CARGO_CODE)>
						<img src="/documents/#cargo_type#.png" height="20" align="absmiddle">
						&nbsp;
					</cfif>
				<td></td>
				<td></td>
					<cfif not isdefined("session.pp.userid")>
						<td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#task_id#&print_type=1002','WOC');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
						</cfif>
					<td><a href="#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#task_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464. Guncelle'>"></i></a> 
				</td><!-- sil -->
			</tr>
			<cfset t_quantity = t_quantity + TOTAL_QUANTITY>
			<cfset t_pallet = t_pallet + TOTAL_PALLETS + TOTAL_ADD_PALLETS>
		</cfoutput>
		<cfelse>
			<tr>
				<td colspan="17"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
	</tbody>
	<cfif get_warehouse_tasks.recordcount>
	<cfoutput>
		<tfoot>
			<tr>
				<td colspan="7"><cf_get_lang dictionary_id="57492.Toplam"></td>
				<td style="text-align:right;">#t_quantity#</td>
				<td style="text-align:right;">#t_pallet#</td>
				<td colspan="9"></td>
			</tr>
		</tfoot>
	</cfoutput>
	</cfif>
</cf_grid_list>
<cfset url_str="stock.list_warehouse_tasks">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
</cfif>
<cfif len(attributes.company_id)>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif len(attributes.consumer_id)>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif len(attributes.company)>
	<cfset url_str = "#url_str#&company=#attributes.company#">
</cfif>
<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)>
	<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#" >
</cfif>
<cfif isdefined("attributes.service_type") and len(attributes.service_type)>
	<cfset url_str = "#url_str#&service_type=#attributes.service_type#" >
</cfif>
<cfif len(attributes.department_id)>
	<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
</cfif>
<cfif len(attributes.department_name)>
	<cfset url_str = "#url_str#&department_name=#attributes.department_name#">
</cfif>
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif isdefined("attributes.task_status") and len(attributes.task_status)>
	<cfset url_str = "#url_str#&task_status=#attributes.task_status#">
</cfif>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#url_str#">
<script type="text/javascript">
document.getElementById('keyword').focus();
function pencere_ac()
{
	if((form.city_id.value != "") && (form.city.value != ""))
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form.county_id&field_name=form.county&city_id=' + document.form.city_id.value,'small');
	else
		alert("<cf_get_lang dictionary_id='45491.Lütfen İl Seçiniz'> !");
}
</script>

