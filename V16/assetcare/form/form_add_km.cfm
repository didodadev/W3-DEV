<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfparam name="employee_id" default="">
<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
    <cfquery name="get_vehicles" datasource="#DSN#">
        SELECT 
            ASSET_P.DEPARTMENT_ID,
            ASSET_P.ASSETP_ID,
            ASSET_P.ASSETP,
			X.FINISH_DATE,
			X.KM_FINISH,
			D.DEPARTMENT_HEAD,
			B.BRANCH_NAME,
			ASSET_P.DEPARTMENT_ID,
			D.BRANCH_ID,
			ASSET_P.EMPLOYEE_ID
        FROM 
            ASSET_P
			LEFT JOIN DEPARTMENT AS D ON ASSET_P.DEPARTMENT_ID = D.DEPARTMENT_ID
			LEFT JOIN BRANCH AS B ON D.BRANCH_ID = B.BRANCH_ID
			OUTER APPLY
			(
				SELECT TOP 1 KM_FINISH,FINISH_DATE FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = ASSET_P.ASSETP_ID ORDER BY KM_FINISH DESC
			) AS X
        WHERE	
            ASSET_P.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
    </cfquery>
    <cfif len(get_vehicles.department_id)>
        <cfquery name="GET_BRANCHS_DEPS" datasource="#DSN#">
            SELECT
                DEPARTMENT.DEPARTMENT_HEAD,
                BRANCH.BRANCH_NAME
            FROM
                BRANCH,
                DEPARTMENT
            WHERE
                DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_vehicles.department_id#"> AND
                BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
        </cfquery>
    </cfif>
   	<cfset pageHead ="#getLang('assetcare',100)# : #getLang('main',1656)# :#get_vehicles.assetp#">
<cfelse>
	<cfset pageHead ="#getLang('assetcare',100)#">
</cfif>

<cf_catalystHeader>
<cfform name="add_km" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_km" onsubmit="return(unformat_fields());">
<div class="row">
	<div class="col col-12 uniqueRow">
        <div class="row formContent">
            <div class="row" type="row">
                <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-assetp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'> *</label>
                        <div class="col col-6 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="assetp_id" id="assetp_id" value="<cfif isdefined("get_vehicles.assetp_id") and len(get_vehicles.assetp_id)><cfoutput>#get_vehicles.assetp_id#</cfoutput></cfif>">
                                <input  type="text" name="assetp_name" id="assetp_name" readonly value="<cfif isdefined("get_vehicles.assetp") and len(get_vehicles.assetp)><cfoutput>#get_vehicles.assetp#</cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_km.assetp_id&field_name=add_km.assetp_name&field_emp_id=add_km.employee_id&field_emp_name=add_km.employee_name&field_dep_name=add_km.department&field_dep_id=add_km.department_id&field_branch_id=add_km.branch_id&field_branch_name=add_km.branch_name&field_pre_date=add_km.start_date&field_pre_km=add_km.pre_km&is_from_km_kontrol=1&is_active=1','list','popup_list_ship_vehicles');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'> *</label>
                        <div class="col col-6 col-xs-12">
                            <div class="input-group">
								<cfoutput>
									<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("get_vehicles.EMPLOYEE_ID") and len(get_vehicles.EMPLOYEE_ID)>#get_vehicles.EMPLOYEE_ID#</cfif>">
									<input type="text" name="employee_name" id="employee_name" readonly value="<cfif isdefined("get_vehicles.EMPLOYEE_ID") and len(get_vehicles.EMPLOYEE_ID)>#get_emp_info(get_vehicles.EMPLOYEE_ID,0,0)#</cfif>" >
									<span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_km.employee_id&field_name=add_km.employee_name&field_pre_km=add_km.pre_km&field_pre_date=add_km.start_date&select_list=1&branch_related','list','popup_list_positions')"></span>
								</cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'> *</label>
                        <div class="col col-6 col-xs-12">
                            <div class="input-group">
								<cfoutput>
									<input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("get_vehicles.DEPARTMENT_ID") and len(get_vehicles.DEPARTMENT_ID)>#get_vehicles.DEPARTMENT_ID#</cfif>">
									<input type="text" name="department" id="department" value="<cfif isdefined("get_vehicles.DEPARTMENT_HEAD") and len(get_vehicles.DEPARTMENT_HEAD) and isdefined("get_vehicles.BRANCH_NAME") and len(get_vehicles.BRANCH_NAME)>#get_vehicles.BRANCH_NAME# - #get_vehicles.DEPARTMENT_HEAD#</cfif>" > 
									<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("get_vehicles.BRANCH_ID") and len(get_vehicles.BRANCH_ID)>#get_vehicles.BRANCH_ID#</cfif>">
									<input type="hidden" name="branch_name" id="branch_name" value="<cfif isdefined("get_vehicles.BRANCH_NAME") and len(get_vehicles.BRANCH_NAME)>#get_vehicles.BRANCH_NAME#</cfif>">
									<span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_departments&field_id=add_km.department_id&field_name=add_km.department&branch_id=add_km.branch_id','list','popup_list_departments');"></span>
								</cfoutput>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='356.Önceki KM Tarihi'></label>
                        <div class="col col-6 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="is_detail" id="is_detail" value="0">
                                <cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='330.Tarih'></cfsavecontent>
                                <cfif isdefined("get_vehicles.assetp_id") and len(get_vehicles.assetp_id) and len(get_vehicles.FINISH_DATE)>
                                    <cfinput type="text" name="start_date" id="start_date" maxlength="10" validate="#validate_style#" message="#alert#" value="#dateFormat(get_vehicles.FINISH_DATE,'dd/mm/yyyy')#"> 
                                <cfelse>
                                    <cfinput type="text" name="start_date" id="start_date" maxlength="10" validate="#validate_style#" message="#alert#" value=""> 
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-pre_km">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='357.Önceki KM'> </label>
                        <div class="col col-6 col-xs-12">
                            <input name="pre_km" id="pre_km" type="text" value="<cfif isdefined("get_vehicles.assetp_id") and len(get_vehicles.assetp_id) and len(get_vehicles.KM_FINISH)><cfoutput>#tlformat(get_vehicles.KM_FINISH,0)#</cfoutput></cfif>" readonly>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'> </label>
                        <div class="col col-6 col-xs-12">
                            <input type="text" name="detail" id="detail" maxlength="200">
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-finish_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='359.Son KM Tarihi'> *</label>
                        <div class="col col-6 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='330.Tarih'></cfsavecontent>
                                <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" validate="#validate_style#" required="yes" message="#alert#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-last_km">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='219.Son KM '> *</label>
                        <div class="col col-6 col-xs-12">
                            <input type="text" name="last_km" id="last_km" onKeyup="return(FormatCurrency(this,event,0));">
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='358.Mesai Dışı'> </label>
                        <div class="col col-6 col-xs-12">
                            <input name="is_offtime" id="is_offtime" type="checkbox" value="1">
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0'  is_cancel='0' is_reset='0' add_function='kontrol()'>
                </div>
            </div>
        </div>
    </div>
</div>
</cfform>
<script type="text/javascript">	
function unformat_fields()
{
	$('#pre_km').val(filterNum($('#pre_km').val()));
	$('#last_km').val(filterNum($('#last_km').val()));
}
	
function kontrol()
{
	if($('#assetp_name').val() == "") 
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'>!");
		return false;
	}
	
	if($('#employee_id').val() == "" || $('#employee_id').val() == 0)
	{
		alert("<cf_get_lang no='622.Lütfen Aracın Sorumlu Bilgisini Kontrol Ediniz'>!");
		return false;
	}
	
	if($('#department').val() == "") 
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1735.Şube Adı'>!");
		return false;
	}
	
	if($('#finish_date').val() == "") 
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='359.Son KM Tarihi'>!");
		return false;
	}
	
	if($('#last_km').val() == "") 
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='219.Son KM '>!");
		return false;
	}
	
	if(!date_check(document.add_km.start_date,document.add_km.finish_date,"Tarih Aralığını Kontrol Ediniz!"))
	{	
		return false;
	}
			
	a =  parseInt(filterNum($('#pre_km').val()));
	b =  parseInt(filterNum($('#last_km').val()));

	if(a >= b || trim(document.add_km.last_km.value) == "")
	{
		alert("<cf_get_lang no='624.Km Aralığını Kontrol Ediniz'>!");
		return false;
	}
	{
		if (!CheckEurodate($('#finish_date').val(),"<cf_get_lang_main no='288.Bitiş Tarihi'>"))
		{
		return false;
		}
	}
	return true;
}
</script>
