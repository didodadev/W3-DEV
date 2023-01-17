<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="check_our_period.cfm"> 
<cfquery name="GET_NUMBER" datasource="#DSN2#">
	SELECT 
		FIS_NUMBER,
		FIS_ID
	FROM 
		STOCK_FIS
	WHERE 
		FIS_ID = #attributes.UPD_ID#
</cfquery>
<cfif not get_number.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='538.Böyle Bir Fiş Kaydı Bulunamadı'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.welcome</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfinclude template="get_process_cat.cfm">
<cfset attributes.FIS_TYPE = get_process_type.PROCESS_TYPE>
<cfinclude template="upd_fis_0.cfm">
<cfif attributes.del_fis eq 1>
	<cfinclude template="upd_fis_1.cfm">
	<cfabort>
<cfelse>
	<!--- guncelleme islemi yapiliyor --->
	<cflock name="#CreateUUID()#" timeout="500">
		<cftransaction>
			<cfinclude template="upd_fis_2.cfm">
			<cfinclude template="upd_fis_3.cfm">
			<!--- fisler turlere gore insert ediliyor --->
			<cfinclude template="upd_fis_4.cfm">
			<cfif listfind("111,112,113",attributes.FIS_TYPE)><!--- sarf,fire,ambar fisleri icin muhasebeleştirme islemi--->
				<cfinclude template="upd_fis_6.cfm">
			<cfelseif attributes.fis_type eq 115>
            	<cfinclude template="upd_fis_7.cfm">
            </cfif>
			<cfscript>
				basket_kur_ekle(action_id:attributes.UPD_ID,table_type_id:6,process_type:1);
				if(isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)) //stok fişi ic talepten olusturulmussa
				{
					add_internaldemand_row_relation(
						to_related_action_id:attributes.UPD_ID,
						to_related_action_type:2,
						action_status:1,
						process_db:dsn2
						);
				}
			</cfscript>
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = "#attributes.UPD_ID#"
				action_table="STOCK_FIS"
				action_column="FIS_ID"
				is_action_file = 1
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_fis&event=upd&upd_id=#attributes.UPD_ID#'
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
                <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.UPD_ID#" action_name="#attributes.FIS_NO# Güncellendi" paper_no="#attributes.FIS_NO#"  period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
		</cftransaction>
	</cflock>		
</cfif>
<!---Ek Bilgiler--->
<cfset attributes.info_id =  attributes.UPD_ID>
<cfset attributes.is_upd = 1>
<cfset attributes.info_type_id=-22>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cfif session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1 and listfind('115,113,110',attributes.FIS_TYPE,',')><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
	<cfscript>cost_action(action_type:3,action_id:attributes.UPD_ID,query_type:2);</cfscript>
<cfelseif listfind("115,113,110",form.old_process_type) and not listfind("115,113,110",attributes.FIS_TYPE)>
	<cfscript>
		cost_action(action_type:3,action_id:attributes.UPD_ID,query_type:3);
	</cfscript>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_fis&event=upd&upd_id=#attributes.UPD_ID#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
