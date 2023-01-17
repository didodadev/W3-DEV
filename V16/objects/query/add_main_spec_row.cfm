<!--- GetSpecer fonksiyonu içerisinden çağırılıyor,hem kod okunurluğunu kolaylaştırmak hemde bu bloğun sayfanın 2 ayrı yerinde çağırıldığı için
SpecMain Satırlarını Ekleme yeri olan bu sayfa include'lu hale getirildi. M.ER 27 01 2008 --->
<cfscript>
	if(isdefined("session.pda") and isDefined("session.pda.userid"))
		session_base.company_id = session.pda.our_company_id;
	else if(isdefined("session.ep") and isDefined("session.ep.company_id"))
		session_base.company_id = session.ep.company_id;
</cfscript>
<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and isdefined("session_base") and isdefined("session_base.company_id") and listfind(fusebox.spect_company_list,session_base.company_id)>
	<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
<cfelse>
	<cfset new_dsn3 = dsn3>
</cfif>
<cfloop from="1" to="#arguments.spec_row_count#" index="jj">
	<cfscript>
		if(len(arguments.fire_amount_list) and listgetat(arguments.fire_amount_list,jj,',') neq 0)
			fire_amount_ = listgetat(arguments.fire_amount_list,jj,',');
		else
			fire_amount_ = '';
		if(len(arguments.fire_rate_list) and listgetat(arguments.fire_rate_list,jj,',') neq 0)
			fire_rate_ = listgetat(arguments.fire_rate_list,jj,',');
		else
			fire_rate_ = '';
		if(len(arguments.is_free_amount_list) and listgetat(arguments.is_free_amount_list,jj,',') neq 0)
			is_free_amount_ = listgetat(arguments.is_free_amount_list,jj,',');
		else
			is_free_amount_ = '';
		if(len(arguments.is_phantom_list) and listgetat(arguments.is_phantom_list,jj,',') neq 0)
			is_phantom_ = listgetat(arguments.is_phantom_list,jj,',');
		else
			is_phantom_ = '';
        arg_product_id = listgetat(arguments.product_id_list,jj,',');
        arg_stock_id = listgetat(arguments.stock_id_list,jj,',');
        arg_product_name = listgetat(arguments.product_name_list,jj,ayirac);
        arg_amount = listgetat(arguments.amount_list,jj,',');
        arg_is_sevk = listgetat(arguments.is_sevk_list,jj,',');
        arg_is_property = listgetat(arguments.is_property_list,jj,',');
        arg_is_configure = listgetat(arguments.is_configure_list,jj,',');
        arg_property_id = listgetat(arguments.property_id_list,jj,',');
        arg_variation_id = listgetat(arguments.variation_id_list,jj,',');
		if(len(arguments.detail_list) and listgetat(arguments.detail_list,jj,',') neq 0)
			detail = listgetat(arguments.detail_list,jj,',');
		else
			detail = '';
		if(len(related_tree_id_list))
			arg_related_tree_id = listgetat(arguments.related_tree_id_list,jj,',');
		if(len(operation_type_id_list))
			arg_operation_type_id = listgetat(arguments.operation_type_id_list,jj,',');
		
        arg_total_min = listgetat(arguments.total_min_list,jj,',');
        arg_total_max = listgetat(arguments.total_max_list,jj,',');
        arg_tolerance = listgetat(arguments.tolerance_list,jj,',');
        if (len(arguments.product_space_list)) arg_product_space = listgetat(arguments.product_space_list,jj,',');
        if (len(arguments.product_display_list))arg_product_display = listgetat(arguments.product_display_list,jj,',');
        if (len(arguments.product_rate_list))arg_product_rate = listgetat(arguments.product_rate_list,jj,',');
        if (len(arguments.list_price_list))arg_product_price = listgetat(arguments.list_price_list,jj,',');
        if (len(arguments.calculate_type_list))arg_calculate_type = listgetat(arguments.calculate_type_list,jj,',');
        if (len(arguments.related_spect_id_list))arg_related_spect_id = listgetat(arguments.related_spect_id_list,jj,',');
        if (len(arguments.related_spect_name_list))arg_related_spect_name = listgetat(arguments.related_spect_name_list,jj,',');
        if (isdefined('arguments.line_number_list') and len(arguments.line_number_list) and listlen(arguments.line_number_list) gte jj)
            arg_line_number =  listgetat(arguments.line_number_list,jj,',');
		if (len(arguments.configurator_variation_id_list) and listlen(arguments.configurator_variation_id_list) gte jj) arg_conf_var_id = listgetat(arguments.configurator_variation_id_list,jj,',');
		if (len(arguments.dimension_list)) arg_dimention = listgetat(arguments.dimension_list,jj,',');
		if (isdefined('arguments.question_id_list') and len(arguments.question_id_list)) arg_question_id = listgetat(arguments.question_id_list,jj,',');
		if (isdefined('arguments.station_id_list') and len(arguments.station_id_list)) arg_station_id = listgetat(arguments.station_id_list,jj,',');
        if (isdefined('arguments.is_quality_tpye_list') and len(arguments.is_quality_tpye_list)) arg_is_quality_tpye = listgetat(arguments.is_quality_tpye_list,jj,',');
        if (isdefined('arguments.quality_tpye_id_list') and len(arguments.quality_tpye_id_list)) arg_quality_tpye_id = listgetat(arguments.quality_tpye_id_list,jj,',');
        if (isdefined('arguments.quality_standart_value_list') and len(arguments.quality_standart_value_list)) arg_standart_value = listgetat(arguments.quality_standart_value_list,jj,',');
        if (isdefined('arguments.quality_quality_measure_list') and len(arguments.quality_quality_measure_list)) arg_quality_measure = listgetat(arguments.quality_quality_measure_list,jj,',');
        if (isdefined('arguments.quality_tolerance_list') and len(arguments.quality_tolerance_list)) arg_quality_tolerance = listgetat(arguments.quality_tolerance_list,jj,',');
    </cfscript>	
    <cfquery name="ADD_ROW" datasource="#arguments.dsn_type#">
        INSERT
        INTO
            #new_dsn3#.SPECT_MAIN_ROW
            (
                SPECT_MAIN_ID,
                PRODUCT_ID,
                STOCK_ID,
                AMOUNT,
                PRODUCT_NAME,
                IS_PROPERTY,
                IS_CONFIGURE,
                IS_SEVK,
                PROPERTY_ID,
                VARIATION_ID,
                TOTAL_MIN,
                TOTAL_MAX,
                TOLERANCE,
                PRODUCT_SPACE,
                PRODUCT_DISPLAY,
                PRODUCT_RATE,
                PRODUCT_LIST_PRICE,
                CALCULATE_TYPE,
                RELATED_MAIN_SPECT_ID,
                RELATED_MAIN_SPECT_NAME,
                LINE_NUMBER,
                CONFIGURATOR_VARIATION_ID,
                DIMENSION,
                RELATED_TREE_ID,
                OPERATION_TYPE_ID,
                QUESTION_ID,
				DETAIL,
				FIRE_AMOUNT,
				FIRE_RATE,
				IS_FREE_AMOUNT,
				IS_PHANTOM,
                IS_QUALITY_TYPE,
                QUALITY_TYPE_ID,
                QUALITY_STANDART_VALUE,
                QUALITY_MEASURE,
                QUALITY_TOLERANCE
            )
            VALUES
            (
                #main_spec_id#,
                <cfif arg_product_id gt 0>#arg_product_id#<cfelse>NULL</cfif>,
                <cfif arg_stock_id gt 0>#arg_stock_id#<cfelse>NULL</cfif>,
                #arg_amount#,
                <cfif len(arg_product_name)>'#arg_product_name#'<cfelse>NULL</cfif>,
                #arg_is_property#,
                #arg_is_configure#,
                #arg_is_sevk#,
                <cfif arg_property_id gt 0>#arg_property_id#<cfelse>NULL</cfif>,
                <cfif arg_variation_id gt 0>#arg_variation_id#<cfelse>NULL</cfif>,
                <cfif arg_total_min neq '-'>#arg_total_min#<cfelse>NULL</cfif>,
                <cfif arg_total_max neq '-'>#arg_total_max#<cfelse>NULL</cfif>,
                <cfif arg_tolerance neq '-'>#arg_tolerance#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_product_space') and  arg_product_space gt 0>#arg_product_space#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_product_display') and arg_product_display gt 0>#arg_product_display#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_product_rate') and arg_product_rate gt 0>#arg_product_rate#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_product_price') and arg_product_price gt 0>#arg_product_price#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_calculate_type') and len(arg_calculate_type)>#arg_calculate_type#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_related_spect_id') and arg_related_spect_id gt 0>#arg_related_spect_id#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_related_spect_name') and len(arg_related_spect_name)>#arg_related_spect_name#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_line_number') and len(arg_line_number)>#arg_line_number#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_conf_var_id') and len(arg_conf_var_id) and arg_conf_var_id gt 0 >#arg_conf_var_id#<cfelse>NULL</cfif>,
				<cfif isdefined('arg_dimention') and len(arg_dimention)>#arg_dimention#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_related_tree_id')and len(arg_related_tree_id) and arg_related_tree_id gt 0>#arg_related_tree_id#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_operation_type_id')and len(arg_operation_type_id) and arg_operation_type_id gt 0>#arg_operation_type_id#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_question_id')and len(arg_question_id) and arg_question_id gt 0>#arg_question_id#<cfelse>NULL</cfif>,
                <cfif isdefined('detail')and len(detail) and detail is not '0'>'#detail#'<cfelse>NULL</cfif>,
                <cfif isdefined('fire_amount_')and len(fire_amount_)>#fire_amount_#<cfelse>NULL</cfif>,
                <cfif isdefined('fire_rate_')and len(fire_rate_)>#fire_rate_#<cfelse>NULL</cfif>,
                <cfif isdefined('is_free_amount_')and len(is_free_amount_)>#is_free_amount_#<cfelse>NULL</cfif>,
                <cfif isdefined('is_phantom_')and len(is_phantom_)>#is_phantom_#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_is_quality_tpye') and len(arg_is_quality_tpye)>#arg_is_quality_tpye#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_quality_tpye_id') and len(arg_quality_tpye_id) and arg_quality_tpye_id gt 0>#arg_quality_tpye_id#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_standart_value') and len(arg_standart_value) and arg_standart_value neq '-'>#arg_standart_value#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_quality_measure') and len(arg_quality_measure) and arg_quality_measure neq '-'>#arg_quality_measure#<cfelse>NULL</cfif>,
                <cfif isdefined('arg_quality_tolerance') and len(arg_quality_tolerance) and arg_quality_tolerance neq '-'>#arg_quality_tolerance#<cfelse>NULL</cfif>
            )
    </cfquery>
</cfloop>
