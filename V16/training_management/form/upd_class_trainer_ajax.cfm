<cfsetting showdebugoutput="no">
<cfscript>
	get_trainers = createObject("component","V16.training_management.cfc.get_class_trainers");
	get_trainers.dsn = dsn;
	get_trainer_names = get_trainers.get_classes
					(
						module_name : fusebox.circuit,
						class_id : attributes.class_id
					);
</cfscript>
<cfset getComponent = createObject('component','V16.project.cfc.get_project_detail')>
<cf_ajax_list>
	<cfif (get_trainer_names.recordcount)>
		<ul class="ui-list_type2">
			<cfoutput query="get_trainer_names">
				<li>
					<cfif len(class_id)>
						<cfif TRAINER_DETAIL eq 'Çalışan'>
							<div class="ui-list-img">                        
								<cfset employee_photo = getComponent.EMPLOYEE_PHOTO(employee_id:get_trainer_names.T_ID)>
								<cfif len(employee_photo.photo)>
									<cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
								<cfelseif employee_photo.sex eq 1>
									<cfset emp_photo ="images/male.jpg">
								<cfelse>
									<cfset emp_photo ="images/female.jpg">
								</cfif>
								<img src='#emp_photo#' />
							</div>
							<div class="ui-list-text">                                                
								<span class="name">#get_emp_info(get_trainer_names.T_ID,0,0)#</span>
								<span class="title">#get_trainers.get_pos_cat(emp_id : T_ID)#</span>
								<ul class="contact-list">
									<cfif len(employee_photo.employee_email)><li><a href="mailto:#employee_photo.employee_email#"><i class="fa fa-envelope-open-o" title="#employee_photo.employee_email#"></i></a></li></cfif>
									<li>
										<a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_trainer_names.T_ID#', 'warning_modal');"><i class="fa fa-user-o"></i></a>
									</li>
									<li>
										<a href="#request.self#?fuseaction=objects.workflowpages&tab=1&subtab=2&employee_id=#T_ID#" target="_blank"><i class="fa fa-comment-o"></i></a>
									</li>
                                    <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=training_management.emptypopup_del_class_trainer&id=#ID#')"><i class="fa fa-minus"></i></a></li>
									</ul>
							</div>
						<cfelseif TRAINER_DETAIL eq 'Bireysel'>
							<div class="ui-list-img">   
								<cfset employee_photo = getComponent.CONSUMER_PHOTO(consumer_id:T_ID)>
								<cfif len(employee_photo.picture)>
									<cfset emp_photo ="../../documents/member/consumer/#employee_photo.picture#">
								<cfelseif employee_photo.sex eq 1>
									<cfset emp_photo ="images/male.jpg">
								<cfelse>
									<cfset emp_photo ="images/female.jpg">
								</cfif>
								<img src='#emp_photo#' />                    
							</div>
							<div class="ui-list-text">                                                                        
								<span class="name">#get_cons_info(T_ID,1,0)#</span>
						
								<ul class="contact-list">
									<cfif len(employee_photo.consumer_email)><li><a href="mailto:#employee_photo.consumer_email#"><i class="fa fa-envelope-open-o" title="#employee_photo.consumer_email#"></i></a></li></cfif>
                                    <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=training_management.emptypopup_del_class_trainer&id=#ID#')"><i class="fa fa-minus"></i></a></li>
								</ul>
							</div>
							<cfelseif TRAINER_DETAIL eq 'Kurumsal'>
							<div class="ui-list-img">                                            
								<cfset employee_photo = getComponent.PARTNER_PHOTO(partner_id:T_ID)>
								<cfif len(employee_photo.photo)>
									<cfset emp_photo ="../../documents/member/#employee_photo.PHOTO#">
								<cfelseif employee_photo.sex eq 1>
									<cfset emp_photo ="images/male.jpg">
								<cfelse>
									<cfset emp_photo ="images/female.jpg">
								</cfif>
								<img src='#emp_photo#' />                    
								<cfset GET_COMPANY_PARTNER = getComponent.GET_COMPANY_PARTNER(PARTNER_ID :T_ID)>       
								<cfset member_name_ = '#GET_COMPANY_PARTNER.COMPANY_PARTNER_NAME# #GET_COMPANY_PARTNER.COMPANY_PARTNER_SURNAME#-#GET_COMPANY_PARTNER.NICKNAME#'>                   
							</div>
							<div class="ui-list-text">                                                
								<span class="name">#member_name_#</span>
								<ul class="contact-list"> 
								<cfif len(employee_photo.COMPANY_PARTNER_EMAIL)><li><a href="mailto:#employee_photo.COMPANY_PARTNER_EMAIL#"><i class="fa fa-envelope-open-o" title="#employee_photo.COMPANY_PARTNER_EMAIL#"></i></a></li></cfif>
                                <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=training_management.emptypopup_del_class_trainer&id=#ID#')"><i class="fa fa-minus"></i></a></li>
								</ul>
							</div> 
						</cfif>
					
					</cfif>
				</li>
			</cfoutput>
		</ul>		
	<cfelseif (get_trainer_names.recordcount EQ 0)>
		<tr><td><cfoutput>#getlang('main',72,'kayit yok')#</cfoutput> !</td></tr>
	</cfif>
</cf_ajax_list>