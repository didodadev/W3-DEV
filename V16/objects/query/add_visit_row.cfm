<!--- BK 20130205 6 aya silinsin 
<cfif isdefined("attributes.is_sales")>
	<cfquery name="GET_EVENT_CATS" datasource="#dsn#">
		SELECT * FROM EVENT_CAT ORDER BY EVENTCAT
	</cfquery>
<cfelse>
	<cfif isdefined("attributes.is_activity")>
		<cfquery name="GET_EVENT_CATS" datasource="#dsn#">
			SELECT * FROM SETUP_ACTIVITY_TYPES ORDER BY ACTIVITY_TYPE
		</cfquery>
	<cfelse>
		<cfquery name="GET_EVENT_CATS" datasource="#dsn#">
			SELECT * FROM SETUP_VISIT_TYPES ORDER BY VISIT_TYPE
		</cfquery>
	</cfif>
</cfif> --->

<cfif isdefined("attributes.is_activity")>
	<cfquery name="GET_EVENT_CATS" datasource="#dsn#">
		SELECT * FROM SETUP_ACTIVITY_TYPES ORDER BY ACTIVITY_TYPE
	</cfquery>
<cfelse>
	<cfquery name="GET_EVENT_CATS" datasource="#dsn#">
		SELECT VISIT_TYPE_ID,VISIT_TYPE FROM SETUP_VISIT_TYPES ORDER BY VISIT_TYPE
	</cfquery>
</cfif>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT * FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_COMPANY" datasource="#dsn#">
	<cfif isdefined("attributes.cons_ids") and len(attributes.cons_ids)>
		SELECT 
			'' FULLNAME,
			'' COMPANY_ID,
			'' PARTNER_ID,
			CONSUMER_ID,
			CONSUMER_NAME COMPANY_PARTNER_NAME,
			CONSUMER_SURNAME COMPANY_PARTNER_SURNAME
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID IN (#attributes.cons_ids#)
	<cfelse>
		SELECT 
			COMPANY.FULLNAME,
			COMPANY.COMPANY_ID,
			COMPANY_PARTNER.PARTNER_ID,
			'' CONSUMER_ID,
			COMPANY_PARTNER.COMPANY_PARTNER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
		FROM
			COMPANY_PARTNER,
			COMPANY
		WHERE
			COMPANY_PARTNER.PARTNER_ID IN (#attributes.par_ids#) AND
			COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
	</cfif>
</cfquery>
<cfset sayac = "#attributes.record_num_#">
<cffunction name="getTimeCustomTagStart" output="true" access="public" returnType="string">
    <cfargument name="startclocksayac" type="string" required="false" default="" />
    <cfsavecontent variable="cf_wrktimeformat_info"><div class="form-group col col-6"><cf_wrkTimeFormaT name="start_clock" id="start_clock" index="#arguments.startclocksayac#"  value='9'></div></cfsavecontent>;
    <cfreturn #cf_wrktimeformat_info# />
</cffunction>
<cffunction name="getTimeCustomTagFinish" output="true" access="public" returnType="string">
    <cfargument name="finishclocksayac" type="string" required="false" default="" />
    <cfsavecontent variable="cf_wrktimeformat_info"><div class="form-group col col-6"><cf_wrkTimeFormaT name="finish_clock" id="finish_clock" index="#arguments.finishclocksayac#"  value='17'></div></cfsavecontent>;
    <cfreturn #cf_wrktimeformat_info# />
</cffunction>
<cfoutput query="GET_COMPANY">
<cfset sayac = sayac + 1 >
<cfset saatformati_dinamik_row_start[sayac] = getTimeCustomTagStart(sayac) />
<cfset saatformati_dinamik_row_finish[sayac] = getTimeCustomTagFinish(sayac) />
</cfoutput>
<cfif get_company.recordcount>
	<script type="text/javascript">
			row_count=<cfoutput>#attributes.record_num_#</cfoutput>;
			var last_row_count = <cfoutput>#attributes.record_num_#</cfoutput>;
			<cfif isdefined("attributes.is_position")>
				<cfoutput query="get_company">
					row_count++;
					var newRow;
					var newCell;
					<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.record_num.value=row_count;
					newRow = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("table1").insertRow(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("table1").rows.length);
					newRow.setAttribute("name","frm_row" + row_count);
					newRow.setAttribute("id","frm_row" + row_count);		
					newRow.setAttribute("NAME","frm_row" + row_count);
					newRow.setAttribute("ID","frm_row" + row_count);
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="#company_id#"><input type="text" name="company_name' + row_count +'" id="company_name' + row_count +'" value="#FULLNAME#"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac('+ row_count +');"></span></div></div>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '';
					tbl	= <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("table1");
				</cfoutput>
			<cfelse>
				<cfif isdefined("attributes.is_activity")>
					<cfoutput query="get_company">
						row_count++;
						var newRow;
						var newCell;
						<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.record_num.value=row_count;
						newRow = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("table1").insertRow(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("table1").rows.length);
						newRow.setAttribute("name","frm_row" + row_count);
						newRow.setAttribute("id","frm_row" + row_count);		
						newRow.setAttribute("NAME","frm_row" + row_count);
						newRow.setAttribute("ID","frm_row" + row_count);		
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';		
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<div class="form-group"><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="#company_id#"><input type="text" name="company_name' + row_count +'" id="company_name' + row_count +'" readonly="" value="#fullname#"></div>';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="<cfif isdefined("attributes.cons_ids") and len(attributes.cons_ids)>#consumer_id#</cfif>"><input type="hidden" name="partner_id' + row_count +'" value="#partner_id#"><input type="text" name="partner_name' + row_count +'" readonly="" value="#company_partner_name# #company_partner_surname#"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac(' + row_count +');"></span></div></div>';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap", "nowrap");
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="start_date' + row_count +'" id="start_date' + row_count +'" class="text" maxlength="10" value="#attributes.kontrol_startdate#"><span class="input-group-addon" id="start_date'+ row_count +'_td"></span></div></div>';
						<!---wrk_date_image('start_date' + row_count + '');--->
						<cfif isdefined("attributes.draggable")><cfelse>opener.</cfif>wrk_date_image("start_date" + row_count);
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap", "nowrap");
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="finish_date' + row_count +'" id="finish_date' + row_count +'" class="text" maxlength="10" value="#attributes.kontrol_finishdate#"><span class="input-group-addon" id="finish_date'+ row_count +'_td"></span></div></div>';
						<!---wrk_date_image('finish_date' + row_count + '');--->
						<cfif isdefined("attributes.draggable")><cfelse>opener.</cfif>wrk_date_image("finish_date" + row_count);
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="pos_emp_id' + row_count +'" id="pos_emp_id' + row_count +'" value="#session.ep.position_code#"><input type="text" name="pos_emp_name' + row_count +'" id="pos_emp_name' + row_count +'" readonly="" value="#get_emp_info(session.ep.userid,0,0)#"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_pos(' + row_count +');"></span></div></div>';
					    tbl	= <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("table1");
					</cfoutput>
				<cfelse>
					<cfset sayac1 = "#attributes.record_num_#">
					<cfoutput query="get_company">
						<cfset sayac1= sayac1+1>
						row_count++;
						var newRow;
						var newCell;
						<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.record_num.value=row_count;
						newRow = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("table1").insertRow(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("table1").rows.length);
						newRow.setAttribute("name","frm_row" + row_count);
						newRow.setAttribute("id","frm_row" + row_count);		
						newRow.setAttribute("NAME","frm_row" + row_count);
						newRow.setAttribute("ID","frm_row" + row_count);		
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';		
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<div class="form-group"><input type="hidden" value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="#company_id#"><input type="text" name="company_name' + row_count +'" id="company_name' + row_count +'" readonly="" value="#fullname#"></div>';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value="#partner_id#"><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="<cfif isdefined("attributes.cons_ids") and len(attributes.cons_ids)>#consumer_id#</cfif>"><input type="text" name="partner_name' + row_count +'" id="partner_name' + row_count +'" readonly="" value="#company_partner_name# #company_partner_surname#"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac(' + row_count +');"></span></div></div>';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap", "nowrap");
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="start_date' + row_count +'" id="start_date' + row_count +'" class="text" maxlength="10" value="#attributes.kontrol_startdate#"><span class="input-group-addon" id="start_date'+ row_count +'_td"></span></div></div>';
						wrk_date_image('start_date' + row_count + '')
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML =  '#trim(saatformati_dinamik_row_start[sayac1])#'+'<div class="form-group col col-6"><select name="start_minute' + row_count +'" id="start_minute' + row_count +'"><option value="00">00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30" selected>30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option></select></div>';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '#trim(saatformati_dinamik_row_finish[sayac1])#'+'<div class="form-group col col-6"><select name="finish_minute' + row_count +'" id="finish_minute' + row_count +'"><option value="00">00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30" selected>30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option></select></div>';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<div class="form-group"><select name="warning_id' + row_count +'" id="warning_id' + row_count +'"><option value="">Seçiniz</option><cfloop query="get_event_cats"><option value="#visit_type_id#">#visit_type#</option></cfloop></select></div>';
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="pos_emp_id' + row_count +'" id="pos_emp_id' + row_count +'" value="#session.ep.position_code#"><input type="text" name="pos_emp_name' + row_count +'" id="pos_emp_name' + row_count +'" readonly="" value="#get_emp_info(session.ep.userid,0,0)#"><span class="input-group-addon icon-ellipsis" onClick="temizlerim(' + row_count +');pencere_ac_pos(' + row_count +');"></span>';
						<cfif isdefined("attributes.is_choose_project") and attributes.is_choose_project eq 1>
							newCell=newRow.insertCell(newRow.cells.length);
							newCell.innerHTML='<div class="form-group"><div class="input-group"><input type="hidden" name="relation_asset_id'+row_count+'" id="relation_asset_id'+row_count+'" value=""><input type="text" name="relation_asset'+row_count+'" id="relation_asset'+row_count+'" readonly="readonly" value=""><span class="input-group-addon icon-ellipsis" onClick="clear(' + row_count +');pencere_ac_asset(' + row_count +');"></span></div></div>';
							newCell=newRow.insertCell(newRow.cells.length);
							newCell.innerHTML='<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+row_count+'" id="project_id'+row_count+'" value=""><input type="text" name="project_head'+row_count+'"  id="project_head'+row_count+'" readonly="readonly" value=""><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_project(' + row_count +');"></span></div></div>';
						</cfif>
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '';
						tbl	= <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("table1");
					</cfoutput>
				</cfif>
				var last_row_count = row_count;
			</cfif>
	</script>
</cfif>
<cfif isdefined("attributes.is_close") and attributes.is_close eq 0 and not isdefined("attributes.draggable")>
	<cfquery name="get_all_company" dbtype="query">
		SELECT DISTINCT COMPANY_ID FROM get_company
	</cfquery>
	<cfif fusebox.use_period and get_all_company.recordcount eq 1 and len(get_all_company.company_id)>
		<cfquery name="GET_NOTE" datasource="#dsn#">
			SELECT * FROM NOTES WHERE ACTION_SECTION = 'COMPANY_ID' AND ACTION_ID = #get_company.company_id# AND IS_WARNING = 1 ORDER BY ACTION_ID DESC
		</cfquery>
		<cfif get_note.recordcount>
			<script type="text/javascript">
				window.open('<cfoutput>#request.self#?fuseaction=objects.popup_detail_company_note&c_id=#get_company.company_id#</cfoutput>','','scrollbars=0, resizable=0,width=500,height=500,left='+(screen.width-500)/2+',top='+(screen.height-500)/2+"'");
			</script>
		</cfif>
	</cfif>
	<cfset add_str = "">
	<cfif isdefined("attributes.kontrol_startdate")><cfset add_str = "#add_str#&kontrol_startdate=#attributes.kontrol_startdate#"></cfif>
	<cfif isdefined("attributes.startdate")><cfset add_str = "#add_str#&startdate=#attributes.startdate#"></cfif>
    <cfif isdefined("attributes.is_choose_project")><cfset add_str = "#add_str#&is_choose_project=#attributes.is_choose_project#"></cfif>
	<cfif isdefined("attributes.fuseaction_name")><cfset fuseaction_ = attributes.fuseaction_name><cfelse><cfset fuseaction_ = popup_list_multiuser_company></cfif>
	<script type="text/javascript">
		window.location='<cfoutput>#request.self#?fuseaction=#fuseaction_##add_str#</cfoutput>&is_first=1&is_sales=1&is_close=0&is_submitted=1&record_num_='+last_row_count;
	</script>
<cfelse>
	<script type="text/javascript">
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</script>
</cfif>
