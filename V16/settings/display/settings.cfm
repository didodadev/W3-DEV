<!--- 
	TYPE_LIST :
				1 Param
				2 Sistem
				3 Import
				4 Dönem
				5 Bakım
				6 Utility
                7 Dev
                8 Report
 --->
<cfswitch expression="#attributes.fuseaction#">
	<cfcase value="settings.params">
    	<cfset attributes.type = 1>
        <cfset attributes.head = getLang('main',281)>
    </cfcase>
	<cfcase value="settings.management">
    	<cfset attributes.type = 2>
        <cfset attributes.head = getLang('settings',2450)>
    </cfcase>
	<cfcase value="settings.system_transfers">
    	<cfset attributes.type = 3>
        <cfset attributes.head = getLang('dev',13)>
    </cfcase>
	<cfcase value="settings.db_admin">
    	<cfset attributes.type = 4>
        <cfset attributes.head = getLang('settings',1571)>
    </cfcase>
	<cfcase value="settings.maintenance">
    	<cfset attributes.type = 5>
        <cfset attributes.head = getLang('settings',2456)>
    </cfcase>
    <cfcase value="report.standart">
    	<cfset attributes.type = 8>
		<cfset attributes.head = 'Report'>
		<cf_xml_page_edit fuseact="report.standart">
    </cfcase>
    <cfdefaultcase>
    	<cfset attributes.type = 6>
        <cfset attributes.head = 'Utility'>
    </cfdefaultcase>

</cfswitch>

<cfquery name="GET_PARAMETERS" datasource="#dsn#">
        SELECT
			S2.ITEM_#uCase(session.ep.language)# AS FAMILY, 
			S3.ITEM_#uCase(session.ep.language)# AS MODULE, 
			S4.ITEM_#uCase(session.ep.language)# AS OBJECT, 
			S1.ITEM_#session.ep.language# AS SOLUTION, 
			W.FULL_FUSEACTION,
			W.*, 
            M.* 
        FROM 
            WRK_OBJECTS AS W 
            LEFT JOIN SETUP_LANGUAGE_TR AS S4 ON S4.DICTIONARY_ID = W.DICTIONARY_ID 
            LEFT JOIN WRK_MODULE AS M ON W.MODULE_NO = M.MODULE_NO 
            LEFT JOIN SETUP_LANGUAGE_TR AS S3 ON S3.DICTIONARY_ID = M.MODULE_DICTIONARY_ID 
            LEFT JOIN WRK_FAMILY AS WF ON WF.WRK_FAMILY_ID = M.FAMILY_ID
            LEFT JOIN SETUP_LANGUAGE_TR AS S2 ON S2.DICTIONARY_ID = WF.FAMILY_DICTIONARY_ID
            LEFT JOIN WRK_SOLUTION AS WS ON WS.WRK_SOLUTION_ID = WF.WRK_SOLUTION_ID
            LEFT JOIN SETUP_LANGUAGE_TR AS S1 ON S1.DICTIONARY_ID = WS.SOLUTION_DICTIONARY_ID 
        WHERE 
            W.TYPE = #attributes.type# AND 
			W.IS_ACTIVE = 1 AND
            W.DICTIONARY_ID IS NOT NULL
			<cfif attributes.type eq 8>
			 	<cfif len(session.ep.report_user_level)>
					AND W.MODULE_NO IN (#session.ep.report_user_level#)
				<cfelse>
					AND 1 = 0	
				</cfif>
			</cfif>
			<cfif attributes.type eq 1 or attributes.type eq 3 or attributes.type eq 5>
				<cfif len(session.ep.power_user_level_id)>
					AND W.MODULE_NO IN (#session.ep.power_user_level_id#)
				<cfelse>
					AND 1 = 0
				</cfif>
			</cfif>
        ORDER BY 
		<cfif attributes.type eq 4>
			W.RANK_NUMBER,
			WS.WRK_SOLUTION_ID,		
			S2.ITEM_TR,
			S3.ITEM_TR,
			S4.ITEM_TR
		<cfelse>
			WS.WRK_SOLUTION_ID,		
			S2.ITEM_TR,
			S3.ITEM_TR,
			S4.ITEM_TR,
			W.RANK_NUMBER
		</cfif>
</cfquery>
<!--- <div class="row margin-top-15 margin-bottom-15">
	<div class="col col-12">
		<h3><cfoutput>#attributes.head#</cfoutput></h3>
	</div>
</div> --->
<cf_catalystHeader>
<div class="params_content">
	<cfoutput query="GET_PARAMETERS" group="SOLUTION">
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12 params_item">
			<ul class="params_list">
				<div class="params_list_title color-#UCase(left(SOLUTION,2))#">#SOLUTION#</div> 
				<cfoutput group="FAMILY">                 
				<span><i class="fa fa-angle-down"></i>#FAMILY#</span>
					<cfif attributes.type eq 8>
						<cfoutput group="MODULE">
							<cfif ((is_module_authority eq 1 and get_module_user(GET_PARAMETERS.module_no)) or is_module_authority eq 0)>
								<ul>
									<li>#MODULE#
										<ul>
											<cfoutput>
												<li><a href="#request.self#?fuseaction=#FULL_FUSEACTION#" target="_blank">- #OBJECT#</a></li>                          
											</cfoutput>
										</ul>
									</li>
								</ul>
							</cfif>
						</cfoutput>	
					<cfelse>
						<cfoutput group="MODULE">
							<li>#MODULE#
								<ul>
									<cfoutput>
										<cfif FULL_FUSEACTION contains 'popup'>
											<li><a href="javascript:" onclick="windowopen('#request.self#?fuseaction=#FULL_FUSEACTION#','list')">- #OBJECT#</a></li>   	 
										<cfelse>
											<li><a href="#request.self#?fuseaction=#FULL_FUSEACTION#" target="_blank">- #OBJECT#</a></li> 
										</cfif>                    
									</cfoutput>
								</ul>
							</li>	
						</cfoutput>
					</cfif>
				
				</cfoutput>    
			</ul>
		</div>
	</cfoutput>
</div>
<script>
	$(function() {
		var $msrContent = $('.params_content');
		$msrContent.masonry({itemSelector: '.params_item',percentPosition: true});
	});
</script> 