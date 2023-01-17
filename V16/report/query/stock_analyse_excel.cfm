				<cfsavecontent variable="report">
					<table cellpadding="2"  cellspacing="1" border="0" class="color-border" width="98%" align="center">
						<cfoutput query="GET_ALL_STOCK">
							<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<cfif listfind('1,8',attributes.report_type,',')>
									<td>
										#replace(GET_ALL_STOCK.STOCK_CODE,";","","all")#
									</td>
								</cfif>
								<cfif attributes.report_type eq 1>
									<cfif isdefined("x_dsp_special_code") and x_dsp_special_code eq 1>
										<td>
											#stock_code_2#
										</td>
									</cfif>
								</cfif>
								<td width="130" nowrap="nowrap">
								   #replace(GET_ALL_STOCK.ACIKLAMA,";","","all")#
								</td>
								<cfif listfind('1,2,8',attributes.report_type)>					
									<td>#replace(GET_ALL_STOCK.BARCOD,";","","all")#</td>
								</cfif>
								<cfif attributes.report_type eq 8>
									<cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
										<td>
											#GET_ALL_STOCK.SPECT_VAR_ID#
											<cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
											 - #GET_ALL_STOCK.SPECT_NAME#
											</cfif>
										</td>
									<cfelse>
										<td align="right">
											#GET_ALL_STOCK.SPECT_VAR_ID#
										</td>
									</cfif>
								</cfif>
								<cfif listfind('1,2,8',attributes.report_type)>					
									<td>
										#replace(GET_ALL_STOCK.PRODUCT_CODE,";","","all")#
									</td>
								</cfif>
								<td width="130" nowrap="nowrap">
									#replace(GET_ALL_STOCK.MANUFACT_CODE,";","","all")#
								</td>
								<td width="100" nowrap="nowrap">
									#replace(GET_ALL_STOCK.MAIN_UNIT,";","","all")#
								</td>
								<td align="right" nowrap="nowrap" format="numeric">
									<cfif isdefined("DB_STOK_MIKTAR") and len(DB_STOK_MIKTAR)>
										#TLFormat(DB_STOK_MIKTAR,4)#
									<cfelse>
										#TLFormat(0,4)#
									</cfif>
							   </td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap="nowrap" format="numeric">
										<cfif not isdefined('attributes.is_system_money_2')>
											<cfif len(DB_STOK_MIKTAR) and len(ALL_START_COST)>
												#((DB_STOK_MIKTAR*GET_ALL_STOCK.ALL_START_COST)/1)#
											<cfelseif len (DB_STOK_MIKTAR)>
												#((DB_STOK_MIKTAR*0)/1)#
											<cfelseif len(ALL_START_COST)>
												#((0*GET_ALL_STOCK.ALL_START_COST)/1)#
											</cfif>
										<cfelse>
											
												<cfif len(DB_STOK_MIKTAR) and len(ALL_START_COST)>
													#((DB_STOK_MIKTAR*GET_ALL_STOCK.ALL_START_COST_2)/1)#
												<cfelseif len (DB_STOK_MIKTAR)>
													#((DB_STOK_MIKTAR*0)/1)#
												<cfelseif len(ALL_START_COST)>
													#((0*GET_ALL_STOCK.ALL_START_COST_2)/1)#
												</cfif>
										</cfif>
									</td>
								</cfif>
								<!--- alıs ve alıs iadeler bolumu --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
									<td align="right" format="numeric">
										<cfif isdefined("TOPLAM_ALIS") and len(TOPLAM_ALIS)>
											#TLFormat(TOPLAM_ALIS,4)#
										</cfif>
									 </td>
									 <td align="right" format="numeric">
										<cfif isdefined("TOPLAM_ALIS_IADE") and len(TOPLAM_ALIS_IADE)>
											#TLFormat(TOPLAM_ALIS_IADE,4)#
										</cfif>
									 </td>
									 <td align="right" format="numeric">
										 <cfif len(TOPLAM_ALIS) and  len(TOPLAM_ALIS_IADE)>
											 #(TOPLAM_ALIS - TOPLAM_ALIS_IADE)#
										  </cfif> 		 
									  </td>
									<cfif isdefined('attributes.display_cost')>
										<td width="85" align="right" nowrap format="numeric">
										<cfif isdefined("TOPLAM_ALIS_MALIYET") and len(TOPLAM_ALIS_MALIYET)>
											#TLFormat(TOPLAM_ALIS_MALIYET)# 
										</cfif>
										 </td>
										 <td width="15" nowrap="nowrap">
											<cfif isdefined("TOPLAM_ALIS_MALIYET") and len(TOPLAM_ALIS_MALIYET)>#attributes.cost_money#</cfif>
										 </td>
										 <td width="85" align="right" nowrap format="numeric">
										<cfif isdefined("TOPLAM_ALIS_IADE_MALIYET") and len(TOPLAM_ALIS_IADE_MALIYET)>
											#TLFormat(TOPLAM_ALIS_IADE_MALIYET)# 
										</cfif>
										 </td>
										<td width="15" nowrap>
											<cfif isdefined("TOPLAM_ALIS_IADE_MALIYET") and len(TOPLAM_ALIS_IADE_MALIYET)>#attributes.cost_money#</cfif>
										 </td>
										<td width="85" align="right" nowrap format="numeric">
											<cfif len(TOPLAM_ALIS_MALIYET) and len(TOPLAM_ALIS_IADE_MALIYET)>
												#TLFormat(TOPLAM_ALIS_MALIYET - TOPLAM_ALIS_IADE_MALIYET)# 
											</cfif>
										</td>
										<td width="15" nowrap>
											<cfif len(TOPLAM_ALIS_MALIYET) and len(TOPLAM_ALIS_IADE_MALIYET)>
												<cfif (TOPLAM_ALIS_MALIYET - TOPLAM_ALIS_IADE_MALIYET) neq 0>#attributes.cost_money#</cfif>
											</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="85" align="right" nowrap format="numeric">
												<cfif isdefined("TOPLAM_ALIS_MALIYET_2") and len(TOPLAM_ALIS_MALIYET_2)>
													#TLFormat(TOPLAM_ALIS_MALIYET_2)# 
												</cfif>
											</td>
											<td width="15" nowrap>
												<cfif isdefined("TOPLAM_ALIS_MALIYET_2") and len(TOPLAM_ALIS_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
											<td width="85" align="right" nowrap format="numeric">
												<cfif isdefined("TOPLAM_ALIS_IADE_MALIYET_2") and len(TOPLAM_ALIS_IADE_MALIYET_2)>
													#TLFormat(TOPLAM_ALIS_IADE_MALIYET_2)# 
												</cfif>
											</td>
											<td width="15" nowrap>
												<cfif isdefined("TOPLAM_ALIS_IADE_MALIYET_2") and len(TOPLAM_ALIS_IADE_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
											<td width="85" align="right" nowrap format="numeric">
												#TLFormat(TOPLAM_ALIS_MALIYET_2 - TOPLAM_ALIS_IADE_MALIYET_2)# 
											</td>
											<td width="15" nowrap><cfif (TOPLAM_ALIS_MALIYET_2 - TOPLAM_ALIS_IADE_MALIYET_2) neq 0>#session.ep.money2#</cfif></td>
										</cfif>
									</cfif>
								<td class="color-header" width="1"></td>
								</cfif>
								<!--- satıs ve satıs iade bolumu --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
										<td align="right" format="numeric">
											<cfif isdefined("TOPLAM_SATIS") and len(TOPLAM_SATIS)>
												#TLFormat(TOPLAM_SATIS,4)#</cfif>
										</td>
										<td align="right" format="numeric">
											<cfif isdefined("TOPLAM_SATIS_IADE") and len(TOPLAM_SATIS_IADE)>
												#TLFormat(TOPLAM_SATIS_IADE,4)#
											</cfif>
										</td>
										<td align="right" format="numeric">
											<cfif len (TOPLAM_SATIS) and  len(TOPLAM_SATIS_IADE)>
												#TLFormat((TOPLAM_SATIS -TOPLAM_SATIS_IADE),4)#
											</cfif>
										 </td>
										<cfif isdefined('attributes.from_invoice_actions')><!--- satıs fatura tutarı --->
											<td align="right" format="numeric">
												<cfif isdefined("FATURA_SATIS_MIKTAR") and len(FATURA_SATIS_MIKTAR)>
												   #TLFormat(FATURA_SATIS_MIKTAR)#
												</cfif>	
											</td>
											<td width="82" align="right" format="numeric">
												<cfif isdefined("FATURA_SATIS_TUTAR") and len(FATURA_SATIS_TUTAR)>
													#TLFormat(FATURA_SATIS_TUTAR)# 
												</cfif>	
											</td>
											<td width="15" nowrap>
												<cfif isdefined("FATURA_SATIS_TUTAR") and len(FATURA_SATIS_TUTAR)>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="110" align="right" format="numeric">
													<cfif isdefined("FATURA_SATIS_TUTAR_2") and len(FATURA_SATIS_TUTAR_2)>
														#TLFormat(FATURA_SATIS_TUTAR_2)# 
													</cfif>	
												</td>
												<td width="15" nowrap>
													<cfif isdefined("FATURA_SATIS_TUTAR_2") and len(FATURA_SATIS_TUTAR_2)>#session.ep.money2#</cfif>
												</td>
											</cfif>
											<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
												<td width="82" align="right" format="numeric">
													<cfif isdefined("FATURA_SATIS_MALIYET") and len(FATURA_SATIS_MALIYET)>
														#TLFormat(FATURA_SATIS_MALIYET)# 
													</cfif>
												</td>
												<td width="15" nowrap>
													<cfif isdefined("FATURA_SATIS_MALIYET") and len(FATURA_SATIS_MALIYET)>#attributes.cost_money#</cfif>
												</td>
												<cfif isdefined('attributes.is_system_money_2')>
													<td width="110" align="right" format="numeric">
														<cfif isdefined("FATURA_SATIS_MALIYET_2") and len(FATURA_SATIS_MALIYET_2)>
															#TLFormat(FATURA_SATIS_MALIYET_2)# 
														</cfif>	
													</td>
													<td width="15" nowrap>
														<cfif isdefined("FATURA_SATIS_MALIYET_2") and len(FATURA_SATIS_MALIYET_2)>#session.ep.money2#</cfif>
													</td>
												</cfif>
											</cfif>
											<td align="right" format="numeric">
												<cfif isdefined("FATURA_SATIS_IADE_MIKTAR") and len(FATURA_SATIS_IADE_MIKTAR)>
													#TLFormat(FATURA_SATIS_IADE_MIKTAR,4)#
												</cfif>	
										   </td>
										   <td width="108" align="right" format="numeric">
												<cfif isdefined("FATURA_SATIS_IADE_TUTAR") and len(FATURA_SATIS_IADE_TUTAR)>
													#TLFormat(FATURA_SATIS_IADE_TUTAR)# 
												</cfif>
											</td>
											<td width="15" nowrap>
												<cfif isdefined("FATURA_SATIS_IADE_TUTAR") and len(FATURA_SATIS_IADE_TUTAR)>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="132" align="right" format="numeric">
													<cfif isdefined("FATURA_SATIS_IADE_TUTAR_2") and len(FATURA_SATIS_IADE_TUTAR_2)>
														#TLFormat(FATURA_SATIS_IADE_TUTAR_2)# 
													</cfif>
												</td>
												<td width="15" nowrap>
													<cfif isdefined("FATURA_SATIS_IADE_TUTAR_2") and len(FATURA_SATIS_IADE_TUTAR_2)>#session.ep.money2#</cfif>
												</td>
											</cfif>
											<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
												<td width="82" align="right" format="numeric">
													<cfif isdefined("FATURA_SATIS_IADE_MALIYET") and len(FATURA_SATIS_IADE_MALIYET)>
														#TLFormat(FATURA_SATIS_IADE_MALIYET)# 
													</cfif>
												</td>
												<td width="15" nowrap>
													<cfif isdefined("FATURA_SATIS_IADE_MALIYET") and len(FATURA_SATIS_IADE_MALIYET)>#attributes.cost_money#</cfif>
												</td>
												<cfif isdefined('attributes.is_system_money_2')>
													<td width="110" align="right" format="numeric">
														<cfif isdefined("FATURA_SATIS_IADE_MALIYET_2") and len(FATURA_SATIS_IADE_MALIYET_2)>
															#TLFormat(FATURA_SATIS_IADE_MALIYET_2)# 
														</cfif>	
													</td>
													<td width="15" nowrap>
														<cfif isdefined("FATURA_SATIS_IADE_MALIYET_2") and len(FATURA_SATIS_IADE_MALIYET_2)>#session.ep.money2#</cfif>
													</td>
												</cfif>
											</cfif>
										</cfif>
										<cfif isdefined('attributes.display_cost')>
											<td align="right" nowrap format="numeric">
											<cfif isdefined("TOPLAM_SATIS_MALIYET") and len(TOPLAM_SATIS_MALIYET)>
												#TLFormat(TOPLAM_SATIS_MALIYET)# 
											</cfif>
											</td>
											<td width="15" nowrap>
												<cfif isdefined("TOPLAM_SATIS_MALIYET") and len(TOPLAM_SATIS_MALIYET)>#attributes.cost_money#</cfif>
											</td>
											<td width="82" align="right" format="numeric">
											<cfif isdefined("TOP_SAT_IADE_MALIYET") and len(TOP_SAT_IADE_MALIYET)>
												#TLFormat(TOP_SAT_IADE_MALIYET)# 
											</cfif>
											</td>
											<td width="15" nowrap>
												<cfif isdefined("TOP_SAT_IADE_MALIYET") and len(TOP_SAT_IADE_MALIYET)>#attributes.cost_money#</cfif>
											</td>
											<td width="82" align="right" nowrap format="numeric">
												<cfif len(TOPLAM_SATIS_MALIYET) and len (TOP_SAT_IADE_MALIYET)>
  													#TLFormat(TOPLAM_SATIS_MALIYET-TOP_SAT_IADE_MALIYET)#
												<cfelseif len(TOPLAM_SATIS_MALIYET)>
													 #TLFormat(TOPLAM_SATIS_MALIYET-0)#
												<cfelseif len (TOP_SAT_IADE_MALIYET)>
													#TLFormat(0-TOP_SAT_IADE_MALIYET)#
												</cfif>
											</td>
											<td width="15" nowrap>
												<cfif len(TOPLAM_SATIS_MALIYET) and len (TOP_SAT_IADE_MALIYET)>
													<cfif (TOPLAM_SATIS_MALIYET-TOP_SAT_IADE_MALIYET) neq 0>#attributes.cost_money#</cfif>
												<cfelseif len(TOPLAM_SATIS_MALIYET)>
													<cfif (TOPLAM_SATIS_MALIYET-0) neq 0>#attributes.cost_money#</cfif>
												<cfelseif len (TOP_SAT_IADE_MALIYET)>
													<cfif (0-TOP_SAT_IADE_MALIYET) neq 0>#attributes.cost_money#</cfif>
												</cfif>
											</td>
											<td width="70" align="right" nowrap format="numeric">
												<cfif isdefined("FATURA_SATIS_MIKTAR")  and  len(FATURA_SATIS_MIKTAR) and  isdefined("FATURA_SATIS_IADE_MIKTAR")  and  len (FATURA_SATIS_IADE_MIKTAR) >
  													#TLFormat(((FATURA_SATIS_MIKTAR - FATURA_SATIS_IADE_MIKTAR)*ALL_FINISH_COST)/1)#
												<cfelseif isdefined("FATURA_SATIS_MIKTAR") and len(FATURA_SATIS_MIKTAR) >
													 #TLFormat(((FATURA_SATIS_MIKTAR - 0)*ALL_FINISH_COST)/1)#
												<cfelseif  isdefined("FATURA_SATIS_IADE_MIKTAR") and len (TOP_SAT_IADE_MALIYET)>
													#TLFormat(((0 - FATURA_SATIS_IADE_MIKTAR)*ALL_FINISH_COST)/1)#
												</cfif>
											</td>
											<td width="15" nowrap>
												#attributes.cost_money#
											</td>
											<cfif isdefined('attributes.is_system_money_2')>	 				
												<td width="82" align="right" nowrap format="numeric">
												<cfif isdefined("TOPLAM_SATIS_MALIYET_2") and len(TOPLAM_SATIS_MALIYET_2)>
													#TLFormat(TOPLAM_SATIS_MALIYET_2)# 
												</cfif>
												</td>
												<td width="15" nowrap>
													<cfif isdefined("TOPLAM_SATIS_MALIYET_2") and len(TOPLAM_SATIS_MALIYET_2)>#session.ep.money2#</cfif>
												</td>
												<td width="120" align="right" format="numeric">
												<cfif isdefined("TOP_SAT_IADE_MALIYET_2") and len(TOP_SAT_IADE_MALIYET_2)>
													#TLFormat(TOP_SAT_IADE_MALIYET_2)#
												</cfif>
												</td>
												<td width="15" nowrap>
													<cfif isdefined("TOP_SAT_IADE_MALIYET_2") and len(TOP_SAT_IADE_MALIYET_2)> #session.ep.money2#</cfif>
												</td>
												<td width="120" align="right" nowrap format="numeric">
													#TLFormat(TOPLAM_SATIS_MALIYET_2 - TOP_SAT_IADE_MALIYET_2)# 
												</td>
												<td width="15" nowrap format="numeric">
													<cfif (TOPLAM_SATIS_MALIYET_2 - TOP_SAT_IADE_MALIYET_2) neq 0> #session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
								</cfif>
								<!--- Konsinye cikis irs. --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
									<td align="right" format="numeric">
										<cfif isdefined("KONS_CIKIS_MIKTAR") and len(KONS_CIKIS_MIKTAR)>
											#TLFormat(KONS_CIKIS_MIKTAR,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="85" align="right" nowrap format="numeric">
											<cfif isdefined("KONS_CIKIS_MALIYET") and len(KONS_CIKIS_MALIYET)>								
												#TLFormat(KONS_CIKIS_MALIYET)# 	
											</cfif>
										</td>
										<td width="15" nowrap>
											<cfif isdefined("KONS_CIKIS_MALIYET") and len(KONS_CIKIS_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="130" align="right" format="numeric">
											<cfif isdefined("KONS_CIKIS_MALIYET_2") and len(KONS_CIKIS_MALIYET_2)>								
												#TLFormat(KONS_CIKIS_MALIYET_2)# 	
											</cfif>
											</td>
											<td width="15" nowrap>
												<cfif isdefined("KONS_CIKIS_MALIYET_2") and len(KONS_CIKIS_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								   <td class="color-header" width="1"></td>
								</cfif>
								<!--- konsinye iade gelen --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
									<td align="right" format="numeric">
										<cfif isdefined("KONS_IADE_MIKTAR") and len(KONS_IADE_MIKTAR)>
											#TLFormat(KONS_IADE_MIKTAR,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
									   <td width="118" align="right" format="numeric">
										<cfif isdefined("KONS_IADE_MALIYET") and len(KONS_IADE_MALIYET)>								
											#TLFormat(KONS_IADE_MALIYET)# 	
										</cfif>
										</td>
										<td align="right" nowrap width="15">
											<cfif isdefined("KONS_IADE_MALIYET") and len(KONS_IADE_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="128" align="right" format="numeric">
												<cfif isdefined("KONS_IADE_MALIYET_2") and len(KONS_IADE_MALIYET_2)>								
													#TLFormat(KONS_IADE_MALIYET_2)# 
												</cfif>
											</td>
											<td align="right" nowrap width="15">
												<cfif isdefined("KONS_IADE_MALIYET_2") and len(KONS_IADE_MALIYET_2)>#session.ep.money2#	</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!--- Konsinye Giriş İrs. --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
									<td align="right" format="numeric">
										<cfif isdefined("KONS_GIRIS_MIKTAR") and len(KONS_GIRIS_MIKTAR)>
										  #TLFormat(KONS_GIRIS_MIKTAR,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="118" align="right" format="numeric">
										<cfif isdefined("KONS_GIRIS_MALIYET") and len(KONS_GIRIS_MALIYET)>								
											#TLFormat(KONS_GIRIS_MALIYET)# 	
										</cfif>
										</td>
										<td align="right" nowrap width="15">
											<cfif isdefined("KONS_GIRIS_MALIYET") and len(KONS_GIRIS_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
										   <td width="128" align="right" format="numeric">
											<cfif isdefined("KONS_GIRIS_MALIYET_2") and len(KONS_GIRIS_MALIYET_2)>								
												#TLFormat(KONS_GIRIS_MALIYET_2)# 	
											</cfif>
										   </td>
										   <td align="right" nowrap width="15">
												<cfif isdefined("KONS_GIRIS_MALIYET_2") and len(KONS_GIRIS_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!--- Konsinye Giriş İade İrs. --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
									<td align="right" format="numeric">
										<cfif isdefined("KONS_GIRIS_IADE_MIKTAR") and len(KONS_GIRIS_IADE_MIKTAR)>
										   #TLFormat(KONS_GIRIS_IADE_MIKTAR,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="118" align="right" format="numeric">
											<cfif isdefined("KONS_GIRIS_IADE_MALIYET") and len(KONS_GIRIS_IADE_MALIYET)>								
												#TLFormat(KONS_GIRIS_IADE_MALIYET)# 	
											</cfif>
										</td>
										<td align="right" nowrap width="15">
											<cfif isdefined("KONS_GIRIS_IADE_MALIYET") and len(KONS_GIRIS_IADE_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="128" align="right" format="numeric">
												<cfif isdefined("KONS_GIRIS_IADE_MALIYET_2") and len(KONS_GIRIS_IADE_MALIYET_2)>								
													#TLFormat(KONS_GIRIS_IADE_MALIYET_2)# 	
												</cfif>
											</td>
											<td align="right" nowrap width="15">
												<cfif isdefined("KONS_GIRIS_IADE_MALIYET_2") and len(KONS_GIRIS_IADE_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!--- Teknik Servis Giriş --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
									<td align="right" format="numeric">
										<cfif isdefined("SERVIS_GIRIS_MIKTAR") and len(SERVIS_GIRIS_MIKTAR)>
											#TLFormat(SERVIS_GIRIS_MIKTAR,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="42" align="right" nowrap format="numeric">
											<cfif isdefined("SERVIS_GIRIS_MALIYET") and len(SERVIS_GIRIS_MALIYET)>
												#TLFormat(SERVIS_GIRIS_MALIYET)# 
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("SERVIS_GIRIS_MALIYET") and len(SERVIS_GIRIS_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="42" format="numeric">
												<cfif isdefined("SERVIS_GIRIS_MALIYET_2") and len(SERVIS_GIRIS_MALIYET_2)>
													#TLFormat(SERVIS_GIRIS_MALIYET_2)# 
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("SERVIS_GIRIS_MALIYET_2") and len(SERVIS_GIRIS_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!--- Teknik Servis Çıkış --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
									<td align="right" format="numeric">
										<cfif isdefined("SERVIS_CIKIS_MIKTAR") and len(SERVIS_CIKIS_MIKTAR)>
										   #TLFormat(SERVIS_CIKIS_MIKTAR,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="42" align="right" nowrap format="numeric">
											<cfif isdefined("SERVIS_CIKIS_MALIYET") and len(SERVIS_CIKIS_MALIYET)>
												#TLFormat(SERVIS_CIKIS_MALIYET)#
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("SERVIS_CIKIS_MALIYET") and len(SERVIS_CIKIS_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="42" format="numeric">
												<cfif isdefined("SERVIS_CIKIS_MALIYET_2") and len(SERVIS_CIKIS_MALIYET_2)>
													#TLFormat(SERVIS_CIKIS_MALIYET_2)# 
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("SERVIS_CIKIS_MALIYET_2") and len(SERVIS_CIKIS_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!--- RMA Giriş --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
									<td align="right" format="numeric">
										<cfif isdefined("RMA_GIRIS_MIKTAR") and len(RMA_GIRIS_MIKTAR)>
										   #TLFormat(RMA_GIRIS_MIKTAR,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="34" align="right" nowrap format="numeric">
											<cfif isdefined("RMA_GIRIS_MALIYET") and len(RMA_GIRIS_MALIYET)>
											   #TLFormat(RMA_GIRIS_MALIYET)# 
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("RMA_GIRIS_MALIYET") and len(RMA_GIRIS_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="42" format="numeric">
												<cfif isdefined("RMA_GIRIS_MALIYET_2") and len(RMA_GIRIS_MALIYET_2)>
												   #TLFormat(RMA_GIRIS_MALIYET_2)# 
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("RMA_GIRIS_MALIYET_2") and len(RMA_GIRIS_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!--- RMA Çıkış --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
									<td align="right" format="numeric">
										<cfif isdefined("RMA_CIKIS_MIKTAR") and len(RMA_CIKIS_MIKTAR)>
										   #TLFormat(RMA_CIKIS_MIKTAR,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="34" align="right" nowrap format="numeric">
											<cfif isdefined("RMA_CIKIS_MALIYET") and len(RMA_CIKIS_MALIYET)>
												#TLFormat(RMA_CIKIS_MALIYET)# 
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("RMA_CIKIS_MALIYET") and len(RMA_CIKIS_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="42" format="numeric">
												<cfif isdefined("RMA_CIKIS_MALIYET_2") and len(RMA_CIKIS_MALIYET_2)>
												   #TLFormat(RMA_CIKIS_MALIYET_2)# 
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("RMA_CIKIS_MALIYET_2") and len(RMA_CIKIS_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
									<td class="color-header" width="1"></td>
								</cfif>
								<!--- uretim fisleri --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
									<td align="right" format="numeric">
										<cfif isdefined("TOPLAM_URETIM") and len(TOPLAM_URETIM)>
										 #TLFormat(TOPLAM_URETIM,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td align="right" nowrap format="numeric">
											<cfif isdefined("URETIM_MALIYET") and len(URETIM_MALIYET)>								
												#TLFormat(URETIM_MALIYET)# 
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("URETIM_MALIYET") and len(URETIM_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td align="right" nowrap format="numeric">
												<cfif isdefined("URETIM_MALIYET_2") and len(URETIM_MALIYET_2)>								
													#TLFormat(URETIM_MALIYET_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("URETIM_MALIYET_2") and len(URETIM_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!--- sarf ve fire fisleri --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
									<td align="right" format="numeric">
										<cfif isdefined("TOPLAM_SARF") and len(TOPLAM_SARF)>
											#TLFormat(TOPLAM_SARF,4)#
										</cfif>
									</td>
									<td align="right" format="numeric">
										<cfif isdefined("TOPLAM_URETIM_SARF") and len(TOPLAM_URETIM_SARF)>
											#TLFormat(TOPLAM_URETIM_SARF,4)#
										</cfif>
									</td>
									<td align="right" format="numeric">
										<cfif isdefined("TOPLAM_FIRE") and len(TOPLAM_FIRE)>
											#TLFormat(TOPLAM_FIRE,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="62" align="right" nowrap format="numeric">
											<cfif isdefined("SARF_MALIYET") and len(SARF_MALIYET)>								
												#TLFormat(SARF_MALIYET)# 	
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("SARF_MALIYET") and len(SARF_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<td width="62" align="right" nowrap format="numeric">
											<cfif isdefined("URETIM_SARF_MALIYET") and len(URETIM_SARF_MALIYET)>								
												 #TLFormat(URETIM_SARF_MALIYET)# 	
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("URETIM_SARF_MALIYET") and len(URETIM_SARF_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<td width="62" align="right" nowrap format="numeric">
											<cfif isdefined("FIRE_MALIYET") and len(FIRE_MALIYET)>								
												#TLFormat(FIRE_MALIYET)# 	
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("FIRE_MALIYET") and len(FIRE_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="62" align="right" nowrap format="numeric">
												<cfif isdefined("SARF_MALIYET_2") and len(SARF_MALIYET_2)>								
													 #TLFormat(SARF_MALIYET_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("SARF_MALIYET_2") and len(SARF_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
											<td width="62" align="right" nowrap format="numeric">
											<cfif isdefined("URETIM_SARF_MALIYET_2") and len(URETIM_SARF_MALIYET_2)>								
												#TLFormat(URETIM_SARF_MALIYET_2)# 	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("URETIM_SARF_MALIYET_2") and len(URETIM_SARF_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
											<td width="62" align="right" nowrap format="numeric">
												<cfif isdefined("FIRE_MALIYET_2") and len(FIRE_MALIYET_2)>								
													#TLFormat(FIRE_MALIYET_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("FIRE_MALIYET_2") and len(FIRE_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
									<td class="color-header" width="1"></td>
								</cfif>
								<!--- sayim fisleri --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
									<td align="right" format="numeric">
										<cfif isdefined("TOPLAM_SAYIM") and len(TOPLAM_SAYIM)>
											#TLFormat(TOPLAM_SAYIM,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="62" align="right" nowrap format="numeric">
											<cfif isdefined("SAYIM_MALIYET") and len(SAYIM_MALIYET)>								
												 #TLFormat(SAYIM_MALIYET)# 	
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("SAYIM_MALIYET") and len(SAYIM_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="62" align="right" nowrap format="numeric">
												<cfif isdefined("SAYIM_MALIYET_2") and len(SAYIM_MALIYET_2)>								
													 #TLFormat(SAYIM_MALIYET_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("SAYIM_MALIYET_2") and len(SAYIM_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!--- demontajdan giris --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
									<td align="right" format="numeric">
										<cfif isdefined("DEMONTAJ_GIRIS") and len(DEMONTAJ_GIRIS)>
										   #TLFormat(DEMONTAJ_GIRIS,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("DEMONTAJ_GIRIS_MALIYET") and len(DEMONTAJ_GIRIS_MALIYET)>								
												#TLFormat(DEMONTAJ_GIRIS_MALIYET)# 
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("DEMONTAJ_GIRIS_MALIYET") and len(DEMONTAJ_GIRIS_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
										   <td width="125" align="right" nowrap format="numeric">
												<cfif isdefined("DEMONTAJ_GIRIS_MALIYET_2") and len(DEMONTAJ_GIRIS_MALIYET_2)>								
													#TLFormat(DEMONTAJ_GIRIS_MALIYET_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("DEMONTAJ_GIRIS_MALIYET_2") and len(DEMONTAJ_GIRIS_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!--- demontaja giden --->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
									<td align="right" format="numeric">
										<cfif isdefined("DEMONTAJ_GIDEN") and len(DEMONTAJ_GIDEN)>
											#TLFormat(DEMONTAJ_GIDEN,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="38" align="right" nowrap format="numeric">
										<cfif isdefined("DEMONTAJ_GIDEN_MALIYET") and len(DEMONTAJ_GIDEN_MALIYET)>								
											#TLFormat(DEMONTAJ_GIDEN_MALIYET)#	
										</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("DEMONTAJ_GIDEN_MALIYET") and len(DEMONTAJ_GIDEN_MALIYET)> #attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="118" align="right" nowrap format="numeric">
											<cfif isdefined("DEMONTAJ_GIDEN_MALIYET_2") and len(DEMONTAJ_GIDEN_MALIYET_2)>								
												#TLFormat(DEMONTAJ_GIDEN_MALIYET_2)# 	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("DEMONTAJ_GIDEN_MALIYET_2") and len(DEMONTAJ_GIDEN_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!--- masraf fişleri--->
								<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
									<td align="right" format="numeric">
										<cfif isdefined("TOPLAM_MASRAF_MIKTAR") and len(TOPLAM_MASRAF_MIKTAR)>
											#TLFormat(TOPLAM_MASRAF_MIKTAR,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("MASRAF_MALIYET") and len(MASRAF_MALIYET)>								
												#TLFormat(MASRAF_MALIYET)#	
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("MASRAF_MALIYET") and len(MASRAF_MALIYET)> #attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("MASRAF_MALIYET_2") and len(MASRAF_MALIYET_2)>								
													 #TLFormat(MASRAF_MALIYET_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("MASRAF_MALIYET_2") and len(MASRAF_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!---depo sevk : giris-cıkıs stok bilgileri ayrı kolonlarda--->
								<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
									<td align="right" format="numeric">
										<cfif isdefined("SEVK_GIRIS_MIKTARI") and len(SEVK_GIRIS_MIKTARI)>
											#TLFormat(SEVK_GIRIS_MIKTARI,4)#
										</cfif>
									</td>
									<td align="right" format="numeric">
										<cfif isdefined("SEVK_CIKIS_MIKTARI") and len(SEVK_CIKIS_MIKTARI)>
										   #TLFormat(SEVK_CIKIS_MIKTARI,4)#
										 </cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
									
										<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("SEVK_GIRIS_MALIYETI") and len(SEVK_GIRIS_MALIYETI)>								
												#TLFormat(SEVK_GIRIS_MALIYETI)#	
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("SEVK_GIRIS_MALIYETI") and len(SEVK_GIRIS_MALIYETI)> #attributes.cost_money#</cfif>
										</td>
										<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("SEVK_CIKIS_MALIYETI") and len(SEVK_CIKIS_MALIYETI)>								
												#TLFormat(SEVK_CIKIS_MALIYETI)#	
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("SEVK_CIKIS_MALIYETI") and len(SEVK_CIKIS_MALIYETI)> #attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("SEVK_GIRIS_MALIYETI_2") and len(SEVK_GIRIS_MALIYETI_2)>								
													#TLFormat(SEVK_GIRIS_MALIYETI_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("SEVK_GIRIS_MALIYETI_2") and len(SEVK_GIRIS_MALIYETI_2)>#session.ep.money2#</cfif>
											</td>
											<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("SEVK_CIKIS_MALIYETI_2") and len(SEVK_CIKIS_MALIYETI_2)>								
													#TLFormat(SEVK_CIKIS_MALIYETI_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("SEVK_CIKIS_MALIYETI_2") and len(SEVK_CIKIS_MALIYETI_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!---ithal mal girişi: giris-cıkıs stok bilgileri ayrı kolonlarda--->
								<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
									<td align="right" format="numeric">
										<cfif isdefined("ITHAL_MAL_GIRIS_MIKTARI") and len(ITHAL_MAL_GIRIS_MIKTARI)>
											 #TLFormat(ITHAL_MAL_GIRIS_MIKTARI,4)#
										</cfif>
									</td>
									<td align="right" format="numeric">
										<cfif isdefined("ITHAL_MAL_CIKIS_MIKTARI") and len(ITHAL_MAL_CIKIS_MIKTARI)>
										   #TLFormat(ITHAL_MAL_CIKIS_MIKTARI,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("ITHAL_MAL_GIRIS_MALIYETI") and len(ITHAL_MAL_GIRIS_MALIYETI)>								
												#TLFormat(ITHAL_MAL_GIRIS_MALIYETI)#	
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("ITHAL_MAL_GIRIS_MALIYETI") and len(ITHAL_MAL_GIRIS_MALIYETI)> #attributes.cost_money#</cfif>
										</td>
										<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("ITHAL_MAL_CIKIS_MALIYETI") and len(ITHAL_MAL_CIKIS_MALIYETI)>								
												#TLFormat(ITHAL_MAL_CIKIS_MALIYETI)#	
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("ITHAL_MAL_CIKIS_MALIYETI") and len(ITHAL_MAL_CIKIS_MALIYETI)> #attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("ITHAL_MAL_GIRIS_MALIYETI_2") and len(ITHAL_MAL_GIRIS_MALIYETI_2)>								
												   #TLFormat(ITHAL_MAL_GIRIS_MALIYETI_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("ITHAL_MAL_GIRIS_MALIYETI_2") and len(ITHAL_MAL_GIRIS_MALIYETI_2)>#session.ep.money2#</cfif>
											</td>
											<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("ITHAL_MAL_CIKIS_MALIYETI_2") and len(ITHAL_MAL_CIKIS_MALIYETI_2)>								
												   #TLFormat(ITHAL_MAL_CIKIS_MALIYETI_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("ITHAL_MAL_CIKIS_MALIYETI_2") and len(ITHAL_MAL_CIKIS_MALIYETI_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<!---ambar fişi--->
								<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
									<td align="right" format="numeric">
										<cfif isdefined("AMBAR_FIS_GIRIS_MIKTARI") and len(AMBAR_FIS_GIRIS_MIKTARI)>
											#TLFormat(AMBAR_FIS_GIRIS_MIKTARI,4)#
										</cfif>
									</td>
									<td align="right" format="numeric">
										<cfif isdefined("AMBAR_FIS_CIKIS_MIKTARI") and len(AMBAR_FIS_CIKIS_MIKTARI)>
											#TLFormat(AMBAR_FIS_CIKIS_MIKTARI,4)#
										</cfif>
									</td>
									<cfif isdefined('attributes.display_cost')>
										<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("AMBAR_FIS_GIRIS_MALIYETI") and len(AMBAR_FIS_GIRIS_MALIYETI)>								
												#TLFormat(AMBAR_FIS_GIRIS_MALIYETI)#	
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("AMBAR_FIS_GIRIS_MALIYETI") and len(AMBAR_FIS_GIRIS_MALIYETI)> #attributes.cost_money#</cfif>
										</td>
										<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("AMBAR_FIS_CIKIS_MALIYET") and len(AMBAR_FIS_CIKIS_MALIYET)>								
												#TLFormat(AMBAR_FIS_CIKIS_MALIYET)#	
											</cfif>
										</td>
										<td nowrap="nowrap" width="15">
											<cfif isdefined("AMBAR_FIS_CIKIS_MALIYET") and len(AMBAR_FIS_CIKIS_MALIYET)>#attributes.cost_money#</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("AMBAR_FIS_GIRIS_MALIYETI_2") and len(AMBAR_FIS_GIRIS_MALIYETI_2)>								
													 #TLFormat(AMBAR_FIS_GIRIS_MALIYETI_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("AMBAR_FIS_GIRIS_MALIYETI_2") and len(AMBAR_FIS_GIRIS_MALIYETI_2)>#session.ep.money2#</cfif>
											</td>
											<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("AMBAR_FIS_CIKIS_MALIYET_2") and len(AMBAR_FIS_CIKIS_MALIYET_2)>								
													#TLFormat(AMBAR_FIS_CIKIS_MALIYET_2)# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("AMBAR_FIS_CIKIS_MALIYET_2") and len(AMBAR_FIS_CIKIS_MALIYET_2)>#session.ep.money2#</cfif>
											</td>
										</cfif>
									</cfif>
								</cfif>
								<td align="right" format="numeric">
                                <cfif isdefined("TOTAL_STOCK") and len(TOTAL_STOCK)>
                                    <cfset donem_sonu_stok=TOTAL_STOCK>
                                   
                                    #TLFormat(TOTAL_STOCK,4)#
                                <cfelse>
                                    #TLFormat(0,4)#
                                </cfif>
                            </td>
							<cfif isdefined('attributes.display_cost')>
                                <cfif wrk_round(donem_sonu_stok) neq 0>
									<cfset donem_sonu_maliyet=(donem_sonu_stok*GET_ALL_STOCK.ALL_FINISH_COST)>
									<cfif donem_sonu_maliyet neq 0>
									
										<cfset ds_toplam_maliyet = donem_sonu_maliyet/1>
									</cfif>
									<cfif isdefined('attributes.is_system_money_2')>
										<cfset donem_sonu_maliyet2=(donem_sonu_stok*ds_urun_birim_maliyet2)>
										<cfif donem_sonu_maliyet2 neq 0>
																					
											<cfset ds_toplam_maliyet2 =donem_sonu_maliyet2>
										</cfif>
									</cfif>
                                </cfif>
                                <td width="82" align="right" nowrap format="numeric">
									#TLFormat(ds_toplam_maliyet)#
								</td>
                                <td>
									<cfif isdefined("attributes.display_cost_money")>
										#all_finish_money#
									<cfelse>
										#attributes.cost_money#	
									</cfif>
								</td>
                                <cfif isdefined('attributes.is_system_money_2')>
                                    <td align="right" nowrap format="numeric">
                                    	#TLFormat(ds_toplam_maliyet2)#
									</td>
                                    <td width="15" nowrap>
										<cfif ds_toplam_maliyet2 neq 0>#session.ep.money2#</cfif>
									</td>
                                </cfif>
                                <cfif isdefined('attributes.display_ds_prod_cost')><!--- birim maliyet --->
                                    <td align="right" nowrap format="numeric">
										<cfif wrk_round(donem_sonu_stok) neq 0>#TLFormat(ds_toplam_maliyet/donem_sonu_stok)#</cfif>
									</td>
                                    <td>
										<cfif wrk_round(donem_sonu_stok) neq 0>
											<cfif isdefined("attributes.display_cost_money")>
												#all_finish_money#
											<cfelse>
												#attributes.cost_money#	
											</cfif>
										</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											<cfif wrk_round(donem_sonu_stok) neq 0>#TLFormat(ds_toplam_maliyet2/donem_sonu_stok)#</cfif>
										</td>
										<td width="15" nowrap>
											<cfif ds_toplam_maliyet2 neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
                                </cfif>
                            </cfif>
							</tr>
						</cfoutput>
				</table>
			</cfsavecontent>
			<cfset report1 = Trim( report ) />
		   <cffile action="write" file="#upload_folder##dir_seperator#reserve_files#dir_seperator#stock_analyse.xls" output="#report1#">
			<cfinclude template="../../fbx_download.cfm">
			<script type="text/javascript">
				wrk_down_dosya_ver('<cfoutput>/documents/reserve_files/stock_analyse.xls</cfoutput>','1')
			</script>			
