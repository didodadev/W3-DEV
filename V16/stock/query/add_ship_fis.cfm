<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfif not isdefined("new_comp_id")><cfset new_comp_id = session.ep.company_id></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_dsn3_group_alias")><cfset new_dsn3_group_alias = dsn3_alias></cfif>
<cfif not isdefined("new_dsn2_group_alias")><cfset new_dsn2_group_alias = dsn2_alias></cfif>
<cfif not isdefined("new_period_id")><cfset new_period_id = session.ep.period_id></cfif>
<cfinclude template="check_our_period.cfm"> 
<cfinclude template="get_process_cat.cfm">
<cfset attributes.fis_type = get_process_type.PROCESS_TYPE> 
<!--- kontroller  & tanimlamalar --->
<cfinclude template="add_ship_fis_1.cfm">
<!---  // kontroller & tanimlamalar --->
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfinclude template="add_ship_fis_2.cfm">
		<cfif isdefined("attributes.rows_")>
			<cfinclude template="add_ship_fis_3.cfm">
			<cfinclude template="add_ship_fis_4.cfm">
			<cfif listfind("111,112,113",attributes.fis_type)><!--- sarf,fire,ambar fisleri icin muhasebeleştirme işlemi  --->
				<cfinclude template="add_ship_fis_6.cfm">
			<cfelseif attributes.fis_type eq 115>
            	<cfinclude template="add_ship_fis_7.cfm">
            </cfif>
		<cfelse>
			<cfquery name="ADD_STOCK_FIS_ROW" datasource="#dsn2#">
				INSERT INTO STOCK_FIS_ROW (FIS_NUMBER,FIS_ID) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#FIS_NO#">,#GET_ID.MAX_ID#)
			</cfquery>
		</cfif>
		<cfscript>
			basket_kur_ekle(action_id:GET_ID.MAX_ID,table_type_id:6,process_type:0);
			if(isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)) //ic talepten fis olusturma
			{
				add_internaldemand_row_relation(
					to_related_action_id:GET_ID.MAX_ID,
					to_related_action_type:2,
					action_status:0,
					process_db:dsn2
					);
			}
		</cfscript>
		<!---Ek Bilgiler--->
        <cfset attributes.info_id = GET_ID.MAX_ID>
        <cfset attributes.is_upd = 0>
        <cfset attributes.info_type_id=-22>
        <cfinclude template="../../objects/query/add_info_plus2.cfm">
        <!---Ek Bilgiler--->
		<!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = "#GET_ID.MAX_ID#"
				action_table="STOCK_FIS"
				action_column="FIS_ID"
				is_action_file = 1
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_fis&event=upd&upd_id=#GET_ID.MAX_ID#'
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
                <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#GET_ID.MAX_ID#" action_name="#attributes.fis_no_# Eklendi" paper_no="#attributes.fis_no_#"  period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
	UPDATE 
		GENERAL_PAPERS
	SET
		STOCK_FIS_NUMBER = #system_paper_no_add#
	WHERE
		STOCK_FIS_NUMBER IS NOT NULL
</cfquery>
<cfif  isDefined("attributes.fire_fisi_kaydet") and isDefined("fire_fisi_gerekiyor") and len(session_list)>
	<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
		UPDATE 
			GENERAL_PAPERS
		SET
			STOCK_FIS_NUMBER = #system_paper_no_add_fire#
		WHERE
			STOCK_FIS_NUMBER IS NOT NULL
	</cfquery>
</cfif>
<cfif not isdefined('attributes.webService')>
	<cfif not isdefined("attributes.is_mobile")>
		<cfif session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
			<cfscript>
				cost_action(action_type:3,action_id:GET_ID.MAX_ID,query_type:1);
			</cfscript>
		</cfif>
		<script type="text/javascript">
            window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_fis&event=upd&upd_id=#GET_ID.MAX_ID#</cfoutput>";
        </script>
	</cfif>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

