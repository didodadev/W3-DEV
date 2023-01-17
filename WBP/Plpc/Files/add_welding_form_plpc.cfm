<cfif isdefined("specer_return_value_list") and ListGetAt(specer_return_value_list,2) gt 0>
    <cfset welding_json = '{"BUTT_SHEET_THICKNESS":"#filternum(butt_sheet_thickness)#","BUTT_OVERLAP":"#filternum(butt_overlap)#",
    "BUTT_SEAM_LENGTH":"#filternum(butt_seam_length)#","BUTT_ROOT_GAP":"#filternum(butt_root_gap)#","BUTT_CAP":"#filternum(butt_cap)#",
    "BUTT_PENETRATION":"#filternum(butt_penetration)#","BUTT_STEEL_DENSITY":"#filternum(butt_steel_density)#","SINGLE_BUTT_SHEET_THICKNESS":"#filternum(single_butt_sheet_thickness)#",
    "SINGLE_BUTT_SEAM_LENGTH":"#filternum(single_butt_seam_length)#","SINGLE_BUTT_ROOT_GAP":"#filternum(single_butt_root_gap)#",
    "SINGLE_BUTT_CAP":"#filternum(single_butt_cap)#","SINGLE_BUTT_PENETRATION":"#filternum(single_butt_penetration)#","SINGLE_BUTT_OVERLAP":"#filternum(single_butt_overlap)#",
    "SINGLE_BUTT_DEPTH_OF_ROOT_FACE":"#single_butt_depth_of_root_face#","SINGLE_BUTT_ALPHA1":"#filternum(single_butt_alpha1)#","SINGLE_BUTT_ALPHA2":"#filternum(single_butt_alpha2)#",
    "SINGLE_BUTT_STEEL_DENSITY":"#filternum(single_butt_steel_density)#","DOUBLE_BUTT_SHEET_THICKNESS":"#filternum(double_butt_sheet_thickness)#",
    "DOUBLE_BUTT_SEAM_LENGTH":"#filternum(double_butt_seam_length)#","WELDING_ID":"#welding_id#","DOUBLE_BUTT_ROOT_GAP":"#filternum(double_butt_root_gap)#",
    "DOUBLE_BUTT_CAP":"#filternum(double_butt_cap)#","DOUBLE_BUTT_CAP_2":"#filternum(double_butt_cap2)#","DOUBLE_BUTT_SEAM_GROOVE":"#filternum(double_butt_seam_groove)#",
    "DOUBLE_BUTT_OVERLAP":"#filternum(double_butt_overlap)#","DOUBLE_BUTT_DEPTH_OF_ROOT_FACE":"#double_butt_depth_of_root_face#","DOUBLE_BUTT_ALPHA_1":"#filternum(double_butt_alpha1)#",
    "DOUBLE_BUTT_ALPHA_2":"#filternum(double_butt_alpha2)#","DOUBLE_BUTT_ALPHA_3":"#filternum(double_butt_alpha3)#","DOUBLE_BUTT_ALPHA_4":"#filternum(double_butt_alpha4)#",
    "DOUBLE_BUTT_STEEL_DENSITY":"#filternum(double_butt_steel_density)#","FILLET_BUTT_SHEET_THICKNESS":"#filternum(fillet_butt_sheet_thickness)#",
    "FILLET_BUTT_SEAM_LENGTH":"#filternum(fillet_butt_seam_length)#","FILLET_BUTT_CAP":"#filternum(fillet_butt_cap)#","FILLET_BUTT_STEEL_DENSITY":"#filternum(fillet_butt_steel_density)#"}'>
    <cfquery name="UPD_VAR_SPECT" datasource="#DSN3#">
        UPDATE
            #new_dsn3#.SPECTS
        SET
            WELDING_JSON=<cfif isdefined('welding_json') and len(welding_json)><cfqueryparam value = "#welding_json#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
            DIAMETER=<cfif isdefined('diameter') and len(diameter)><cfqueryparam value = "#filternum(diameter)#" CFSQLType = "cf_sql_float"><cfelse>0</cfif>,
            CAP_UNIT=<cfif isdefined('cap_unit') and len(cap_unit)><cfqueryparam value = "#filternum(cap_unit)#" CFSQLType = "cf_sql_float"><cfelse>0</cfif>,
            WIDTH=<cfif isdefined('width') and len(width)><cfqueryparam value = "#filternum(width)#" CFSQLType = "cf_sql_float"><cfelse>0</cfif>,
            HEIGHT=<cfif isdefined('height') and len(height)><cfqueryparam value = "#filternum(height)#" CFSQLType = "cf_sql_float"><cfelse>0</cfif>,
            WIDTH_UNIT=<cfif isdefined('width_unit') and len(width_unit)><cfqueryparam value = "#filternum(width_unit)#" CFSQLType = "cf_sql_float"><cfelse>0</cfif>,
            SIZE=<cfif isdefined('size') and len(size)><cfqueryparam value = "#filternum(size)#" CFSQLType = "cf_sql_float"><cfelse>0</cfif>,
            SIZE_UNIT=<cfif isdefined('size_unit') and len(size_unit)><cfqueryparam value = "#filternum(size_unit)#" CFSQLType = "cf_sql_float"><cfelse>0</cfif>,
            THICKNESS=<cfif isdefined('thickness') and len(thickness)><cfqueryparam value = "#filternum(thickness)#" CFSQLType = "cf_sql_float"><cfelse>0</cfif>,
            INNER_DIAMETER=<cfif isdefined('inner_diameter') and len(inner_diameter)><cfqueryparam value = "#filternum(inner_diameter)#" CFSQLType = "cf_sql_float"><cfelse>0</cfif>,
            OUTER_DIAMETER=<cfif isdefined('outer_diameter') and len(outer_diameter)><cfqueryparam value = "#filternum(outer_diameter)#" CFSQLType = "cf_sql_float"><cfelse>0</cfif>,
            OUTER_UNIT=<cfif isdefined('outer_unit') and len(outer_unit)><cfqueryparam value = "#filternum(outer_unit)#" CFSQLType = "cf_sql_float"><cfelse>0</cfif>,
            PRODUCT_CAT=<cfif isdefined('cat') and len(cat)><cfqueryparam value = "#cat#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            QUALITY_ID=<cfif isdefined('quality') and len(quality)><cfqueryparam value = "#quality#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
        WHERE
            SPECT_VAR_ID=#ListGetAt(specer_return_value_list,2)#
    </cfquery>	
    <cfif isdefined("attributes.plpc_configurator_id")>
        <cfquery name="control_plpc" datasource="#DSN#" >
            SELECT * FROM SPEC_PLP
            WHERE 
                SPECT_ID=#ListGetAt(specer_return_value_list,2)#
        </cfquery>	
            <cfif control_plpc.recordCount lte 0>
            <cfquery name="add_spec_plp" datasource="#DSN#">
                INSERT INTO
                SPEC_PLP 
                (   
                    SPECT_ID,
                    CATEGORY_ID,
                    WIDTH,
                    HEIGHT,
                    ORDER_QUANTITY,
                    COLOUR_C,
                    COLOUR_M,
                    COLOUR_Y,
                    COLOUR_K,
                    GILDING_ID,
                    IS_LACQUER,
                    IS_VARNISH,
                    IS_CELLOPHANE,
                    IS_DESIGNED,
                    TIME_COST_DESIGN,
                    IS_PRINT_DESIGNED,
                    TIME_COST_PRINT,
                    DETAIL,
                    CONFIGURATOR_NO,
                    ORDER_NO,
                    DESIGN_NAME,
                    COMPANY_ID,
                    CONSUMER_ID
                ) 
                VALUES (
                #ListGetAt(specer_return_value_list,2)#,
                <cfif isdefined('attributes.plpc_category') and len(attributes.plpc_category)><cfqueryparam value = "#attributes.plpc_category#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.width_basic') and len(attributes.width_basic)><cfqueryparam value = "#attributes.width_basic#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.height_basic') and len(attributes.height_basic)><cfqueryparam value = "#attributes.height_basic#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.order_quantity') and len(attributes.order_quantity)><cfqueryparam value = "#attributes.order_quantity#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.colour_c') and len(attributes.colour_c)><cfqueryparam value = "#attributes.colour_c#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.colour_m') and len(attributes.colour_m)><cfqueryparam value = "#attributes.colour_m#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.colour_y') and len(attributes.colour_y)><cfqueryparam value = "#attributes.colour_y#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.colour_k') and len(attributes.colour_k)><cfqueryparam value = "#attributes.colour_k#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.gilding_id') and len(attributes.gilding_id)><cfqueryparam value = "#attributes.gilding_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.printing_lacquer') and len(attributes.printing_lacquer)><cfqueryparam value = "#attributes.printing_lacquer#" CFSQLType = "cf_sql_bit"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.varnish') and len(attributes.varnish)><cfqueryparam value = "#attributes.varnish#" CFSQLType = "cf_sql_bit"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.cellophane') and len(attributes.cellophane)><cfqueryparam value = "#attributes.cellophane#" CFSQLType = "cf_sql_bit"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.made_in_design') and len(attributes.made_in_design)><cfqueryparam value = "#attributes.made_in_design#" CFSQLType = "cf_sql_bit"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.time_cost_desing') and len(attributes.time_cost_desing)><cfqueryparam value = "#attributes.time_cost_desing#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.design_print') and len(attributes.design_print)><cfqueryparam value = "#attributes.design_print#" CFSQLType = "cf_sql_bit"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.time_cost_print') and len(attributes.time_cost_print)><cfqueryparam value = "#attributes.time_cost_print#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.other_note') and len(attributes.other_note)><cfqueryparam value = "#attributes.other_note#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.configurator_no') and len(attributes.configurator_no)><cfqueryparam value = "#attributes.configurator_no#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.related_order_no') and len(attributes.related_order_no)><cfqueryparam value = "#attributes.related_order_no#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.design_name') and len(attributes.design_name)><cfqueryparam value = "#attributes.design_name#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.plp_company_id') and len(attributes.plp_company_id)><cfqueryparam value = "#attributes.plp_company_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.plp_consumer_id') and len(attributes.plp_consumer_id)><cfqueryparam value = "#attributes.plp_consumer_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                )
            </cfquery>	
            <cfelse>
            <cfquery name="UPD_SPECT_PLP" datasource="#DSN#">
                UPDATE
                    SPEC_PLP
                SET
                    CATEGORY_ID=<cfif isdefined('attributes.plpc_category') and len(attributes.plpc_category)><cfqueryparam value = "#attributes.plpc_category#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    WIDTH=<cfif isdefined('attributes.width_basic') and len(attributes.width_basic)><cfqueryparam value = "#attributes.width_basic#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    HEIGHT=<cfif isdefined('attributes.height_basic') and len(attributes.height_basic)><cfqueryparam value = "#attributes.height_basic#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    ORDER_QUANTITY=<cfif isdefined('attributes.order_quantity') and len(attributes.order_quantity)><cfqueryparam value = "#attributes.order_quantity#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    COLOUR_C=<cfif isdefined('attributes.colour_c') and len(attributes.colour_c)><cfqueryparam value = "#attributes.colour_c#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                    COLOUR_M=<cfif isdefined('attributes.colour_m') and len(attributes.colour_m)><cfqueryparam value = "#attributes.colour_m#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                    COLOUR_Y=<cfif isdefined('attributes.colour_y') and len(attributes.colour_y)><cfqueryparam value = "#attributes.colour_y#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                    COLOUR_K=<cfif isdefined('attributes.colour_k') and len(attributes.colour_k)><cfqueryparam value = "#attributes.colour_k#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                    GILDING_ID=<cfif isdefined('attributes.gilding_id') and len(attributes.gilding_id)><cfqueryparam value = "#attributes.gilding_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    IS_LACQUER=<cfif isdefined('attributes.printing_lacquer') and len(attributes.printing_lacquer)><cfqueryparam value = "#attributes.printing_lacquer#" CFSQLType = "cf_sql_bit"><cfelse>NULL</cfif>,
                    IS_VARNISH=<cfif isdefined('attributes.varnish') and len(attributes.varnish)><cfqueryparam value = "#attributes.varnish#" CFSQLType = "cf_sql_bit"><cfelse>NULL</cfif>,
                    IS_CELLOPHANE=<cfif isdefined('attributes.cellophane') and len(attributes.cellophane)><cfqueryparam value = "#attributes.cellophane#" CFSQLType = "cf_sql_bit"><cfelse>NULL</cfif>,
                    IS_DESIGNED=<cfif isdefined('attributes.made_in_design') and len(attributes.made_in_design)><cfqueryparam value = "#attributes.made_in_design#" CFSQLType = "cf_sql_bit"><cfelse>NULL</cfif>,
                    TIME_COST_DESIGN=<cfif isdefined('attributes.time_cost_desing') and len(attributes.time_cost_desing)><cfqueryparam value = "#attributes.time_cost_desing#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    IS_PRINT_DESIGNED=<cfif isdefined('attributes.design_print') and len(attributes.design_print)><cfqueryparam value = "#attributes.design_print#" CFSQLType = "cf_sql_bit"><cfelse>NULL</cfif>,
                    TIME_COST_PRINT=<cfif isdefined('attributes.time_cost_print') and len(attributes.time_cost_print)><cfqueryparam value = "#attributes.time_cost_print#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    DETAIL=<cfif isdefined('attributes.other_note') and len(attributes.other_note)><cfqueryparam value = "#attributes.other_note#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                    CONFIGURATOR_NO=<cfif isdefined('attributes.configurator_no') and len(attributes.configurator_no)><cfqueryparam value = "#attributes.configurator_no#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                    ORDER_NO=<cfif isdefined('attributes.related_order_no') and len(attributes.related_order_no)><cfqueryparam value = "#attributes.related_order_no#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                    DESIGN_NAME=<cfif isdefined('attributes.design_name') and len(attributes.design_name)><cfqueryparam value = "#attributes.design_name#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                    COMPANY_ID=<cfif isdefined('attributes.plp_company_id') and len(attributes.plp_company_id)><cfqueryparam value = "#attributes.plp_company_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    CONSUMER_ID=<cfif isdefined('attributes.plp_consumer_id') and len(attributes.plp_consumer_id)><cfqueryparam value = "#attributes.plp_consumer_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                WHERE
                    SPECT_ID=#ListGetAt(specer_return_value_list,2)#
            </cfquery>	
            </cfif>	
    </cfif>
    <cfif isdefined("attributes.tree_record_num") and len(attributes.tree_record_num)>
    <cfquery name="GET_SPECTS_ROWS" datasource="#DSN3#">
       SELECT 
            SPECT_ROW_ID 
       FROM 
            SPECTS_ROW
        WHERE 
       SPECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(specer_return_value_list,2)#">
       ORDER BY SPECT_ID
    </cfquery>	
    <cfset lastindex=1>
    <cfoutput query="GET_SPECTS_ROWS">
        <cfset control=lastindex>
        <cfloop index="i" from="#lastindex#" to="#attributes.tree_record_num#" >	
            <cfif isdefined("attributes.tree_row_kontrol#i#") and evaluate("attributes.tree_row_kontrol#i#") eq 1 and lastindex eq control>
            <cfquery name="UPD_SPECTS_ROWS" datasource="#DSN3#">
                UPDATE
                    SPECTS_ROW
                SET
                    TREE_TYPE=<cfif isdefined('attributes.tree_types#i#') and len(evaluate("attributes.tree_types#i#"))><cfqueryparam value = "#filternum(evaluate("attributes.tree_types#i#"))#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    PRODUCT_WIDTH=<cfif isdefined('attributes.product_width#i#') and len(evaluate("attributes.product_width#i#"))><cfqueryparam value = "#filternum(evaluate("attributes.product_width#i#"))#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
                    PRODUCT_SIZE=<cfif isdefined('attributes.product_size#i#') and len(evaluate("attributes.product_size#i#"))><cfqueryparam value = "#filternum(evaluate("attributes.product_size#i#"))#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
                    PRODUCT_HEIGHT=<cfif isdefined('attributes.product_height#i#') and len(evaluate("attributes.product_height#i#"))><cfqueryparam value = "#filternum(evaluate("attributes.product_height#i#"))#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
                    PRODUCT_THICKNESS=<cfif isdefined('attributes.product_thickness#i#') and len(evaluate("attributes.product_thickness#i#"))><cfqueryparam value = "#filternum(evaluate("attributes.product_thickness#i#"))#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
                    FIRE_AMOUNT=<cfif isdefined('attributes.fire_amount#i#') and len(evaluate("attributes.fire_amount#i#"))><cfqueryparam value = "#filternum(evaluate("attributes.fire_amount#i#"))#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>
                WHERE
                    SPECT_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SPECTS_ROWS.SPECT_ROW_ID#">
            </cfquery>
            <cfset lastindex=i+1>	
        </cfif>
        </cfloop>
    </cfoutput>
    </cfif>
</cfif>