<!---    File: queryJSONConverter.cfm
   Author: Canan Ebret <cananebret@workcube.com>
   Date: 23.10.2019
   Controller: -
   Description: Modülleri baz alarak, her modüle ait dashboardları listeler.​ --->
<!--- 
	TYPE_LIST :	13 Dashboard	
 --->    
<cfset attributes.type = 13>
<cfset attributes.head =  getLang('crm',190)>
<cfset dashboardList= createObject("component","V16.settings.cfc.get_modul")>
<cfset GET_PARAMETERS=dashboardList.GET_PARAMETERS(type : attributes.type)>
<cf_catalystHeader>
<div class="row msr-content">
	<cfoutput query="GET_PARAMETERS" group="SOLUTION">
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12 msr-item margin-bottom-15">
			<div class="col col-12 portBox">                                                    
				<div class="portHead color-#UCase(left(SOLUTION,2))#">
					<span>#SOLUTION#</span>
				</div>
				<div class="portBody" style="display: block;">       
					<ul class="hoverList small scrollContent">   
						<cfoutput group="FAMILY">                 
						<li class="hoverListHead">#FAMILY#</li>
							<cfif attributes.type eq 13>
								<cfoutput group="MODULE">
                                    <ul>
                                        <li class="hoverListHead">#MODULE#</li>
                                        <cfoutput>
                                            <li><a href="#request.self#?fuseaction=#FULL_FUSEACTION#" target="_blank">#OBJECT#</a></li>                          
                                        </cfoutput>
                                    </ul>
								</cfoutput>	
							<cfelse>
								<ul>
									<cfoutput group="MODULE">
										<li class="hoverListHead">#MODULE#</li>
										<cfoutput>
											<cfif FULL_FUSEACTION contains 'popup'>
												<li><a href="javascript:" onclick="windowopen('#request.self#?fuseaction=#FULL_FUSEACTION#','list')">#OBJECT#</a></li>   	 
											<cfelse>
												<li><a href="#request.self#?fuseaction=#FULL_FUSEACTION#" target="_blank">#OBJECT#</a></li> 
											</cfif>                    
										</cfoutput>
									</cfoutput>
								</ul>
							</cfif>
						</cfoutput>    
					</ul>
				</div>
			</div> 
		</div>
	</cfoutput>
</div>
<script>
	$(function() {
		var $msrContent = $('.msr-content');
		$msrContent.masonry({itemSelector: '.msr-item'});
	});
</script>