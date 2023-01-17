<div style="display:none;z-index:999;" id="phl_div"></div>
<cfif listgetat(attributes.fuseaction,2,'.') eq 'list_purchasedemand'>
	<cfset is_demand = 1>
<cfelse>
	<cfset is_demand = 0>
</cfif>
<cfif listlast(fuseaction,'.') eq "list_internaldemand">
	<cf_xml_page_edit fuseact ="correspondence.add_internaldemand">
<cfelseif listlast(fuseaction,'.') eq "list_purchasedemand">
	<cf_xml_page_edit fuseact ="correspondence.add_purchasedemand">
</cfif>
<cf_get_lang_set module_name="correspondence"><!--- sayfanin en altinda kapanisi var --->
<cfscript>
session_basket_kur_ekle(process_type:0);
xml_all_depo_entry = iif(isdefined("xml_location_auth_entry"),xml_location_auth_entry,DE('-1'));
xml_all_depo_outer = iif(isdefined("xml_location_auth_outer"),xml_location_auth_outer,DE('-1'));
</cfscript>
<cfinclude template="../query/get_priority.cfm">
<cfif isdefined('attributes.is_from_report')><!--- heg gıda rapor için eklendi 1114 py --->
	<cfset attributes.department_id = form.department_out>
	<cfset attributes.location_id = form.location_out>
	<cfset attributes.department_in_id = form.department_in>
	<cfset attributes.location_in_id = form.location_in>
	<cfset attributes.txt_department_name = get_location_info(attributes.department_id,attributes.location_id)>
	<cfset attributes.department_in_txt = get_location_info(attributes.department_in_id,attributes.location_in_id)>
	<cfset attributes.ref_no = form.convert_p_order_no>
</cfif>
<cfif isdefined('attributes.internal_row_info')>
	<!--- Planlama Bazinda --->
	<cfif isDefined("attributes.pro_material_id_list")>
		<cfscript>
			pro_material_id_list ="";
			pro_material_row_id_list = "";
			pro_material_amount_list = "";
			pro_material_work_list = "";
			for(ind_i=1; ind_i lte listlen(attributes.internal_row_info); ind_i=ind_i+1)
			{
				temp_row_info_ = listgetat(attributes.internal_row_info,ind_i);
				if(isdefined('add_stock_amount_#replace(temp_row_info_,";","_")#') and len(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#')) )
				{
					pro_material_amount_list = listappend(pro_material_amount_list,filterNum(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#'),4));
					pro_material_work_list = listappend(pro_material_work_list,evaluate('work_id#replace(temp_row_info_,";","_")#'));
					pro_material_row_id_list = listappend(pro_material_row_id_list,listlast(temp_row_info_,';'));
					if(not listfind(pro_material_id_list,listfirst(temp_row_info_,';')))
						pro_material_id_list = listappend(pro_material_id_list,listfirst(temp_row_info_,';'));
				}
			}
		</cfscript>
   <cfelse>
    <cfif isdefined("attributes.internaldemand_id")>
    	<cfquery name="getIntRow" datasource="#dsn3#">
        	SELECT 
                IR.I_ROW_ID,
                IR.QUANTITY - SUM(ISNULL(IRR2.AMOUNT,0)) QUANTITY 
            FROM 
               INTERNALDEMAND_ROW IR
                LEFT JOIN INTERNALDEMAND_RELATION_ROW IRR2 ON IRR2.INTERNALDEMAND_ID=IR.I_ID AND IR.I_ROW_ID=IRR2.INTERNALDEMAND_ROW_ID
            WHERE
                IR.I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.internaldemand_id#"> AND
                IR.I_ROW_ID NOT IN 
                	(
                    	SELECT 
                        	INTERNALDEMAND_ROW_ID
                        FROM
                        	INTERNALDEMAND_RELATION_ROW IRR
                        WHERE
                        	IRR.INTERNALDEMAND_ID=IR.I_ID AND
                            IR.I_ROW_ID=IRR.INTERNALDEMAND_ROW_ID AND
                            TO_INTERNALDEMAND_ID IS NOT NULL 
                       GROUP BY 
					   		INTERNALDEMAND_ROW_ID
                       HAVING
                            IR.QUANTITY - SUM(ISNULL(IRR.AMOUNT,0))<=0
                    )
                     GROUP BY 
						I_ROW_ID,
						QUANTITY
        </cfquery>
        <cfscript>
			if (getIntRow.recordcount)
			{
				internald_row_amount_list =valuelist(getIntRow.QUANTITY,',');
				internald_row_id_list =valuelist(getIntRow.I_ROW_ID);
				internaldemand_id_list =attributes.internaldemand_id;
			}
			else
			{
				internald_row_amount_list ="";
				internald_row_id_list ="";
				internaldemand_id_list ="";
			}
		</cfscript>
	<cfelse>
		<cfscript>
			internald_row_amount_list ="";
			internald_row_id_list ="";
			internaldemand_id_list ="";
			for(ind_i=1; ind_i lte listlen(attributes.internal_row_info); ind_i=ind_i+1)
			{
				temp_row_info_ = listgetat(attributes.internal_row_info,ind_i);
				if(isdefined('add_stock_amount_#replace(temp_row_info_,";","_")#') and len(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#')) )
				{
					internald_row_amount_list = listappend(internald_row_amount_list,filterNum(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#'),4));
					internald_row_id_list = listappend(internald_row_id_list,listlast(temp_row_info_,';'));
					if(not listfind(internaldemand_id_list,listfirst(temp_row_info_,';')))
						internaldemand_id_list = listappend(internaldemand_id_list,listfirst(temp_row_info_,';'));
				}
			}
		</cfscript>
    </cfif>
	<cfif isdefined('internaldemand_id_list') and len(internaldemand_id_list)>
        <cfquery name="GET_INTERNALDEMAND_NUMBER" datasource="#DSN3#">
            SELECT 
                DISTINCT 
                INTERNAL_NUMBER
            FROM 
                INTERNALDEMAND
            WHERE 
                INTERNAL_ID IN (#internaldemand_id_list#)
        </cfquery>
        <cfset internal_number_list = valuelist(GET_INTERNALDEMAND_NUMBER.INTERNAL_NUMBER,',')>
        <cfquery name="get_internaldemand_info" datasource="#dsn3#">
            SELECT PROJECT_ID,PROJECT_ID_OUT,WORK_ID,LOCATION_OUT,DEPARTMENT_OUT,LOCATION_IN,DEPARTMENT_IN,TARGET_DATE,FROM_POSITION_CODE FROM INTERNALDEMAND WHERE INTERNAL_ID IN (#internaldemand_id_list#)
        </cfquery>
        <cfscript>
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,',')),',') eq 1)
                attributes.project_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,','));
            else
                attributes.project_id = "";
    
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id_out,',')),',') eq 1)
                attributes.project_id_out = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id_out,','));
            else
                attributes.project_id_out = "";	
    
			if( compare(ValueList(get_internaldemand_info.work_id), ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id))) eq -1)
				attributes.work_id = "";
            else if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,',')),',') eq 1)
                attributes.work_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,','));
            else
                attributes.work_id = "";
                
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.location_out,',')),',') eq 1)
                attributes.location_out = ListDeleteDuplicates(ValueList(get_internaldemand_info.location_out,','));
            else
                attributes.location_out = "";
                
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.department_out,',')),',') eq 1)
                attributes.department_out = ListDeleteDuplicates(ValueList(get_internaldemand_info.department_out,','));
            else
                attributes.department_out = "";
                
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.location_in,',')),',') eq 1)
                attributes.location_in = ListDeleteDuplicates(ValueList(get_internaldemand_info.location_in,','));
            else
                attributes.location_in = "";
                
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.department_in,',')),',') eq 1)
                attributes.department_in = ListDeleteDuplicates(ValueList(get_internaldemand_info.department_in,','));
            else
                attributes.department_in = "";	
			
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.target_date,',')),',') eq 1)
                attributes.target_date = ListDeleteDuplicates(ValueList(get_internaldemand_info.target_date,','));
            else
                attributes.target_date = "";	
			 if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.from_position_code,',')),',') eq 1)
                attributes.from_position_code = ListDeleteDuplicates(ValueList(get_internaldemand_info.from_position_code,','));
            else
                attributes.from_position_code = "";
        </cfscript>
        <cfif len(attributes.location_out) and len(attributes.department_out)>
            <cfset attributes.txt_departman_out = get_location_info(attributes.department_out,attributes.location_out)>
        </cfif>
        <cfif len(attributes.location_in) and len(attributes.department_in)>
            <cfset attributes.txt_department_in = get_location_info(attributes.department_in,attributes.location_in)>
        </cfif>
    </cfif>
    </cfif>
</cfif>
<cf_catalystHeader>
<cfinclude template="add_internaldemand_noeditor.cfm">
<script type="text/javascript">
	function kontrol()
		{
			<cfif isdefined("xml_show_process_cat") and len(xml_show_process_cat) and xml_show_process_cat eq 1 and is_demand eq 1>
				if(!chk_process_cat('form_basket')) return false;
			</cfif>
			if(document.form_basket.process_stage.value == "")
			{
				alert("<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
				return false;
			}
			if(document.form_basket.to_position_code.value == "" || document.form_basket.position_code.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57924.Kime '>!");
				return false;
			}
		<!---	<cfif is_target_date eq 1>
				if(document.form_basket.target_date.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57645.Teslim Tarihi'>!");
					return false;
				}
			</cfif>--->
			<!---
			<cfif is_department_in eq 1 and x_project_department_in eq 1>
				if(document.form_basket.department_in_id.value == "" || document.form_basket.department_in_txt.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='33658.Giriş Depo'>!");
					return false;
				}
			</cfif>
			--->
			<cfif isdefined('x_apply_deliverdate_to_rows') and x_apply_deliverdate_to_rows eq 1>
				apply_deliver_date('target_date');
			</cfif> 
			<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
				project_field_name = 'project_head';
				project_field_id = 'project_id';
				apply_deliver_date('',project_field_name,project_field_id);
			</cfif>
			return (process_cat_control() && saveForm());
		}
	function open_phl()
		{
			document.getElementById("phl_div").style.display ='';	
			$("#phl_div").css('margin-left',$("#tabMenu").position().left - 700);
			$("#phl_div").css('margin-top',$("#tabMenu").position().top + 50);
			$("#phl_div").css('position','absolute');		
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.add_order_from_file&from_where=3&is_demand=#is_demand#3&frm_str_=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>','phl_div',1);
			return false;
		}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
