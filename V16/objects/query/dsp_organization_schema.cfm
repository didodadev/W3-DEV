<cffunction name="get_sub_dep">
	<cfargument  name="dep_id">
	<cfquery name="GET_SUB_DEPARTMENTS" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			DEPARTMENT
		WHERE
			HIERARCHY_DEP_ID LIKE '#dep_id#.%'
	</cfquery>		
	<cfset list_val=ValueList(GET_SUB_DEPARTMENTS.DEPARTMENT_ID)>
	<cfreturn #list_val#>
</cffunction>
<cffunction name="GET_NAME">
	<cfargument  name="dep_id">
	<cfquery name="GET_DEPARTMENTS" datasource="#dsn#">
		SELECT 
			DEPARTMENT_HEAD
		FROM 
			DEPARTMENT
		WHERE
			DEPARTMENT_ID=#dep_id#
	</cfquery>		
	<cfset list_val=GET_DEPARTMENTS.DEPARTMENT_HEAD>
	<cfreturn #list_val#>
</cffunction>
<br/>
<cfset sb_dep=ArrayNew(3)>
<link href="../css/win_ie_1.css" rel="stylesheet" type="text/css">
<cfinclude template="../query/get_zones.cfm">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
	<tr>
		  <td class="headbold" valign="top">		  
			<table cellspacing="0" cellpadding="0">
				 <tr class="color-list">
					<td height="20" class="txtboldblue" align="center"><cf_get_lang_main no='166.Organizasyon'></td>
			  </tr>
				<tr>
					<td>
						<table cellspacing="0" cellpadding="0">	<!--- table bolgeler ana--->
							<tr>
								<cfloop from="1" to="#zones.recordcount#" index="k">
										<cfquery name="BRANCH" datasource="#dsn#">
											SELECT
												*
											FROM
												BRANCH
											WHERE
												ZONE_ID=#ZONES.ZONE_ID[K]#
										</cfquery>
										<td  valign="top" colspan="<cfoutput>#branch.Recordcount#</cfoutput>" align="center"   >
												<table>
													<tr  style="cursor:pointer;" >  
													  <td align="center"   height="35">															
															<br/>
														  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_detail_zone&id=#zones.zone_ID[k]#</cfoutput>','medium');"><img src="/images/tree_1.gif" border="0" align="absmiddle"></a><b><cfif branch.Recordcount ><a href="javascript://"   onClick="gizle_goster(a<cfoutput>#k#</cfoutput>b);"></cfif><cfoutput>#zones.zone_name[k]#</cfoutput><cfif branch.Recordcount ></a></cfif></b>
														</td>
													</tr>
												<cfif branch.Recordcount >
													<tr id="a<cfoutput>#k#</cfoutput>b" style="display:none;" >
														<td>
															<DIV style="Z-INDEX: 1002;  POSITION: absolute;  ">
																<HR width="100%"  color="##000033" noShade>
															</DIV>
															<table cellspacing="0" cellpadding="0" >
																<tr>
																	
																	<cfloop from="1" to="#branch.Recordcount#" index="i">
																		<cfquery name="DEPARTMENT_ROWS" datasource="#dsn#">
																				SELECT 
																					BRANCH_ID 
																				FROM 
																					DEPARTMENT
																				WHERE
																					BRANCH_ID=#BRANCH.BRANCH_ID#
																		</cfquery>	
																		
<!--- 																		<td  align="center"  colspan="<cfoutput>#department_rows.recordcount#</cfoutput>" height="35">  --->
																			<cfif department_rows.recordcount eq 1>
																				<cfset clspn=department_rows.recordcount+1>			
																			<cfelseif  not department_rows.recordcount >
																				<cfset clspn=1>						
																			<cfelse>
																				<cfset clspn=department_rows.recordcount>						
																			</cfif>
																		<td  align="center"  colspan="<cfoutput>#clspn#</cfoutput>" height="35"> 
																		  <DIV  style="Z-INDEX: 1002; WIDTH: 2px;   height=19px;   
																		  BACKGROUND-COLOR: 000033; layer-background-color: red"> </DIV>
																		</td>
																	</cfloop>
																</tr>							
																<tr>
																	<cfoutput query="branch">
																			<cfquery name="DEPARTMENTS" datasource="#dsn#">
																				SELECT 
																					* 
																				FROM 
																					DEPARTMENT
																				WHERE
																					BRANCH_ID=#BRANCH.BRANCH_ID#
																				AND
																					HIERARCHY_DEP_ID NOT LIKE '%.%'
																			</cfquery>		
																			<cfif department_rows.recordcount eq 1>
																				<cfset clspn_=department_rows.recordcount+1>			
																			<cfelseif not department_rows.recordcount >
																				<cfset clspn_=1>
																			<cfelse>
																				<cfset clspn_=department_rows.recordcount>						
																			</cfif>
																			<td   nowrap valign="top" align="center" colspan="#clspn#">
																				
																			<table align="center" cellspacing="0" cellpadding="0">
																			<tr  style="cursor:pointer;"   >
																			  <td align="center" valign="top" nowrap>																						<br/> 
																					  <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_branch&id=#branch.branch_ID#','medium');"><img src="/images/tree_1.gif" border="0" align="absmiddle"></a><B><cfif departments.recordcount><a  onClick="gizle_goster(dep<cfoutput>#branch_ID#</cfoutput>no);"  href="javascript://" ></cfif>#branch.branch_name#<cfif departments.recordcount></a></cfif></B>																			  
																					  </td>
																			</tr>
																			<tr  id="dep<cfoutput>#branch_ID#</cfoutput>no" style="display:none;" >
																				<td align="center">
																						<cfif departments.recordcount>
																							<DIV style="Z-INDEX: 1002;  POSITION: absolute;  HEIGHT: 10px">
																								<HR width="100%" color=red noShade>
																							</DIV>
																							<table cellspacing="0" cellpadding="0" height="25">
																								<tr>
																									<cfloop from="1" to="#departments.recordcount#" index="i">
																										<td align="center" height="35px">
																											  <DIV  style="Z-INDEX: 1002; WIDTH: 2px;   height=19px; BACKGROUND-COLOR: red; layer-background-color: red">
																											   </DIV>
																										</td>
																									</cfloop>	
																								</tr>
																								<tr>
																									<cfloop from="1" to="#departments.recordcount#" index="i">
																									  <td align="center" valign="top">
																										  <table cellspacing="0" cellpadding="0" height="25">
																											<tr>
																												<cfset sub_list=get_sub_dep(departments.DEPARTMENT_ID[i])>
																												<td align="center" width="100%"  nowrap colspan="#ListLen(sub_list)#">
																													
																												 <b>
																												 <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=hr.popup_list_department_position&DEPARTMENT_ID=#departments.DEPARTMENT_ID[i]#','list');">
																												 	<img src="/images/tree_1.gif" border="0" align="absmiddle">
																												 </a>
																													<cfif LEN(sub_list)>																												 
																														<a href="javascript://"   onClick="gizle_goster(sub_dep#departments.DEPARTMENT_ID[i]#no);gizle_goster(sub_dep#departments.DEPARTMENT_ID[i]#cb);gizle_goster(sub_dep#departments.DEPARTMENT_ID[i]#vcb);">
																													</cfif>
																												  		#departments.department_head[i]# 
																													<cfif LEN(sub_list)>				
																													</a>
																													</cfif>
																												
																												  </b>
																												</td>
																											</tr>
																										<cfif LEN(sub_list)>		
																											<cfset lst_arr=ListToArray(sub_list)>		
																											<tr id="sub_dep#departments.DEPARTMENT_ID[i]#cb"  style="display:none;">
																											<cfif ArrayLen(lst_arr) eq 0>
																												<cfset alen=1>
																											<cfelse>
																												<cfset alen=ArrayLen(lst_arr)+1>	
																											</cfif>
																												<td colspan="#alen#">
																													<DIV style="Z-INDEX: 1002;  POSITION: absolute;   HEIGHT: 10px; width=100%;" align="left" >
																														<HR width="100%" color=red noShade>
																													</DIV>																														
																												</td>
																											</tr>	
																												<tr id="sub_dep#departments.DEPARTMENT_ID[i]#vcb" style="display:none;">
																													<cfloop from="1" to="#ArrayLen(lst_arr)#" index="j">
																														<td align="center" height="35px">
																															  <DIV  style="Z-INDEX: 1002; WIDTH: 2px;   height=19px;   
																															  BACKGROUND-COLOR: red; layer-background-color: red"> </DIV>
																														</td>
																													</cfloop>	
																												</tr>																											
																												<tr align="center" height="35px" id="sub_dep#departments.DEPARTMENT_ID[i]#no" style="display:none;">
																													<cfloop from="1" to="#ArrayLen(lst_arr)#" index="j">
																														<td>
																															<cfif ArrayLen(lst_arr) eq 1>
																																<cfset depa_id=sub_list>
																															<cfelse>
																																<cfset depa_id=lst_arr[j]>
																															</cfif>	
																															 <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=hr.popup_list_department_position&department_id=#depa_id#','list');" >
																																<b>#GET_NAME(lst_arr[j])#</b>
																															 </a>
																														</td>
																													</cfloop>
																											</tr>
																											</cfif>
																										  </table>
																									  </td>
																																																				  
																									</cfloop>	
																								</tr>
																							</table>	
																						</cfif>
																				</td>
																			</tr>
																			
																			</table>				


																			</td> 		
																										
															  </cfoutput>
															 </tr>		
															</table>
														</td>
													</tr>
												</cfif>		
												</table>
								  </td>
							  </cfloop>
							
							</tr>
						</table>
										
				
					</td>	
				</tr>
			</table>
	  </td>
	</tr>
</table>


