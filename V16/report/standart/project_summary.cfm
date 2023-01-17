<cf_CatalystHeader>
<div class="row">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfsavecontent  variable="head"><cf_get_lang dictionary_id='47768.Proje Dashboard'></cfsavecontent>
			<cf_box title="#head#">
				<cf_box_search>
					<div class="col col-3 col-xs-12" style="text-align:right;">
						<div class="form-group" id="item-status">
							<div class="input-group">
								<select name="list_type" id="list_type" onChange="change_type(this.value);">
									<option value="1"><cf_get_lang dictionary_id='40020.Grafikler'></option>
									<option value="2"><cf_get_lang dictionary_id='38739.Tablolar'></option>
								</select>
							</div>
						</div>
					</div>	
				</cf_box_search>
			</cf_box>	
	</div>	
	<script src="JS/Chart.min.js"></script>
	<div id="graphs">
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='40177.Kategorilere Göre'><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
			<cf_box title=#head#>
				<div id="cat_work_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_cat_work_summary','cat_work_summary');
					</script>
				</div>
			</cf_box>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='40176.Aşamalara Göre'><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
			<cf_box title=#head#>
				<div id="stage_work_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_stage_work_summary','stage_work_summary');
					</script>
				</div>
			</cf_box>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='48263.Bitirme Oranlarına Göre'><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
			<cf_box title=#head#>
				<div id="fin_rate_mywork_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_fin_work_summary&type=1','fin_rate_mywork_summary');
					</script>
				</div>
			</cf_box>	
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='48273.Zaman Harcamalarına Göre'><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
			<cf_box title=#head#>
				<div id="time_cost_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_time_cost_summary&type=1','time_cost_summary');
					</script>
				</div>
			</cf_box>	
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='48292.Termini Geçmiş İş Sayısı'></cfsavecontent>
			<cf_box title=#head#>
				<div id="mytermin_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_termin_summary&type=1','mytermin_summary');
					</script>
				</div>
			</cf_box>	
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='40175.Önceliklere Göre'><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
			<cf_box title=#head#>
				<div id="priority_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_priority_work_summary','priority_summary');
					</script>
				</div>
			</cf_box>	
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='48297.Delege Edilen Aktif İş Sayısı'></cfsavecontent>
			<cf_box title=#head#>
				<div id="record_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_record_work_summary','record_summary');
					</script>
				</div>
			</cf_box>	
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='48298.Kişilere Göre Toplam Görev Sayısı'></cfsavecontent>
			<cf_box title=#head#>
				<div id="proj_emp_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_project_emp_summary','proj_emp_summary');
					</script>
				</div>
			</cf_box>	
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='48263.Bitirme Oranlarına Göre'><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
			<cf_box title=#head#>
				<div id="fin_rate_work_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_fin_work_summary&type=2','fin_rate_work_summary');
					</script>
				</div>
			</cf_box>	
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='48273.Zaman Harcamalarına Göre'><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
			<cf_box title=#head#>
				<div id="all_time_cost_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_time_cost_summary&type=2','all_time_cost_summary');
					</script>
				</div>
			</cf_box>	
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id='48292.Termini Geçmiş İş Sayısı'></cfsavecontent>
			<cf_box title=#head#>
				<div id="termin_summary">
					<script type="text/javascript">
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_termin_summary&type=2','termin_summary');
					</script>
				</div>
			</cf_box>	
		</div>
	</div>

	<div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="rel_table" style="display:none;">
		<div>
			<cfsavecontent variable="message1"><cf_get_lang dictionary_id='60785.Delege Edilen İşler'> - <cf_get_lang dictionary_id='60786.İş Tamamlanma Oranları'></cfsavecontent>
			<cf_box
				id="rec_table_summary"
				unload_body="1"
				closable="0"
				title="#message1#"
				box_page="#request.self#?fuseaction=report.popup_rec_table_work_summary">
			</cf_box>
		</div>
		<div>
			<cfsavecontent variable="message2"><cf_get_lang dictionary_id='60785.Delege Edilen İşler'> - <cf_get_lang dictionary_id='57569.Görevli'></cfsavecontent>	
			<cf_box
				id="rec_emp_summary"
				unload_body="1"
				closable="0"
				title="#message2#"
				box_page="#request.self#?fuseaction=report.popup_rec_emp_work_summary">
			</cf_box>
		</div>
		<div>
			<cfsavecontent variable="message3"><cf_get_lang dictionary_id='30831.Delege Eden'> - <cf_get_lang dictionary_id='57561.Zaman Harcamaları'></cfsavecontent>	
			<cf_box
				id="rec_time_cost_summary"
				unload_body="1"
				closable="0"
				title="#message3#"
				box_page="#request.self#?fuseaction=report.popup_record_time_cost_sum&type=1">
			</cf_box>
		</div>
		<div>
			<cfsavecontent variable="message4"><cf_get_lang dictionary_id='60787.Kişilere Göre İşler'> - <cf_get_lang dictionary_id='48292.Termini Geçmiş İş Sayısı'></cfsavecontent>
			<cf_box
				id="rec_out_of_date_summary"
				unload_body="1"
				closable="0"
				title="#message4#"
				box_page="#request.self#?fuseaction=report.popup_table_out_of_work">
			</cf_box>
		</div>
		<div>
			<cfsavecontent variable="message5"><cf_get_lang dictionary_id='40176.Aşamalara Göre'> <cf_get_lang dictionary_id='58020.İşler'> - <cf_get_lang dictionary_id='48263.Bitirme Oranlarına Göre'></cfsavecontent>
			<cf_box
				id="fin_rate_table_summary"
				unload_body="1"
				closable="0"
				title="#message5#"
				box_page="#request.self#?fuseaction=report.popup_finish_rate_table_work&type=1">
			</cf_box>
		</div>
		<div>
			<cfsavecontent variable="message6"><cf_get_lang dictionary_id='40177.Kategorilere Göre İşler'> <cf_get_lang dictionary_id='58020.İşler'> - <cf_get_lang dictionary_id='48263.Bitirme Oranlarına Göre'></cfsavecontent>
			<cf_box
				id="fin_rate_table2_summary"
				unload_body="1"
				closable="0"
				title="#message6#"
				box_page="#request.self#?fuseaction=report.popup_finish_rate_table_work&type=2">
			</cf_box>
		</div>
		<div>
			<cfsavecontent variable="message7"><cf_get_lang dictionary_id='40177.Kategorilere Göre İşler'> <cf_get_lang dictionary_id='58020.İşler'> - <cf_get_lang dictionary_id='57561.Zaman Harcamaları'></cfsavecontent>
			<cf_box
				id="rec_time_cost2_summary"
				unload_body="1"
				closable="0"
				title="#message7#"
				box_page="#request.self#?fuseaction=report.popup_record_time_cost_sum&type=2">
			</cf_box>
		</div>
	</div>
</div>

<script type="text/javascript">
	function change_type(typ)
	{
		if(typ == 1)
		{
			gizle(rel_table);
			goster(graphs);
		}
		else
		{
			goster(rel_table);
			gizle(graphs);		
		}
	}

</script>
