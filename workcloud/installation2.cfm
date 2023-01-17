<cfset getParameter = parameter.getParameter() />

<cfif isdefined('getParameter.employee_url') and len(getParameter.employee_url) and isdefined('getParameter.license_code') and len(getParameter.license_code)>
	<div class="ui-info-text">
		<h1>Main Database and Product Database Definition</h1>
	</div>
	<cfform name="installation_2" id="installation_2" type="formControl" action="#installUrl#" method="post">
		<div class="ui-form-list">
			<div class="col-md-12 paddingLess">
				<input type="hidden" name="db_type" value="MSSQL">
				<div class="col-md-12 paddingLess">
					<div class="form-group">
						<label>Instalation Name <font color="red">*</font></label>
						<div class="col-md-12 pdnl pdnr">
							<input required class="form-control" message="Enter Installation Name"  name="server_detail" id="server_detail" type="text" value="workcubeadmin@workcube.com,Workcube Production Server" autocomplete="off" />
						</div>
					</div>
				</div>
				<div class="col-md-6 col-xs-12 paddingLess">
					<div class="form-group">
						<label>Datasource <font color="red">*</font></label>
						<div class="col-md-12 pdnl">
							<input required class="form-control" message="Enter Definitions od Database" name="dsn" id="dsn" type="text" value="<cfoutput>#getParameter.dsn#</cfoutput>" />
						</div>
					</div>
					<div class="form-group">
						<label>Database Username <font color="red">*</font></label>
						<div class="col-md-12 pdnl">
							<input required class="form-control" message="Enter DB Username" name="db_username" id="db_username" type="text" value="" />
						</div>
					</div>
					<div class="form-group">
						<label>Database Password <font color="red">*</font></label>
						<div class="col-md-12 pdnl">
							<input required class="form-control" message="Enter DB Password" name="db_password" id="db_password" type="password" value=""  />
						</div>
					</div>
					<div class="form-group">
						<label>CF Admin Password <font color="red">*</font></label>
						<div class="col-md-12 pdnl">
							<input required class="form-control" message="Enter CF Server Admin Password" name="cf_admin_password" id="cf_admin_password" type="password" value=""/>
						</div>
					</div>
				</div>
				<div class="col-md-6 col-xs-12 paddingLess">
					<div class="form-group">
						<label>Database Host <font color="red">*</font></label>
						<div class="col-md-12 pdnl pdnr">
							<input required class="form-control" message="Enter DB Host Definition" name="database_host" id="database_host" type="text" value="" />
						</div>
					</div>
					<div class="form-group">
						<label>Database Port <font color="red">*</font></label>
						<div class="col-md-12 pdnl pdnr">
							<input required class="form-control" message="Enter DB Port Definition" name="database_port" id="database_port" type="text" value="" />
						</div>
					</div>
					<div class="form-group">
						<label>Database Data Folder <font color="red">*</font></label>
						<div class="col-md-12 pdnl pdnr">
							<input required class="form-control" message="Enter path of DB Data Folder" name="database_folder" id="database_folder" type="text" value="" placeholder="C://DATAPATH/"/>
						</div>
					</div>
					<div class="form-group">
						<label>Database Log Folder <font color="red">*</font></label>
						<div class="col-md-12 pdnl pdnr">
							<input required class="form-control" message="Enter path of DB Log Folder" name="database_log_folder" id="database_log_folder" type="text" value="" placeholder="C://LOGPATH/"/>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-12" id="installList">
				<table class="ui-table-list">
					<tr id="control">
						<td>Control System</td>
						<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
					</tr>
					<tr id="databases">
						<td>Create Database, Logins, Schemas, Users</td>
						<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
					</tr>
					<tr id="mainProductTables">
						<td>Create Main and Product Tables</td>
						<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
					</tr>
					<tr id="mainProductViews">
						<td>Create Main and Product Views</td>
						<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
					</tr>
					<tr id="mainProductProcedures">
						<td>Create Main and Product Procedures</td>
						<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
					</tr>
					<tr id="mainFunctions">
						<td>Create Main Functions</td>
						<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
					</tr>
					<tr id="jobs">
						<td>Create Jobs</td>
						<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
					</tr>
					<tr id="license">
						<td>Create License</td>
						<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="ui-form-list-btn">
			<div class="col-md-12 paddingLess">
				<div class="form-group button-panel">
					<input  class="btn btn-info" type="submit" value="Next Step">
				</div>
			</div>
		</div>
	</cfform>

	<script>
	
		function startAjaxRequest( processes, row ) {
        
			var flag = $("div#installList table.ui-table-list tr#"+processes[row][1].elementid+" td > i");
			$(flag).removeClass('fa-bookmark-o').addClass('fa-cog fa-spin font-yellow-casablanca');
			$.ajax({
				url: "cfc/install_schema.cfc?method=" + processes[row][1].method,
				dataType: "json",
				method: "post",
				data: processes[row][1].data,
				success: function( response ) {
					if( response.STATUS ){
						$(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagTrue');
						row += 1;
						if( processes[row] != undefined ) startAjaxRequest( processes, row );
						else location.href = '<cfoutput>#installUrl#?installation_type=2_1</cfoutput>';
					}else{
						$(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showInstallMistakeMessage("'+processes[row][0]+'")' }).css({ 'cursor' : 'pointer' });
						
						$('tr#install_'+processes[row][0]+'').remove();

						$(flag).parents('tr').after(
							$('<tr>').attr({ 'id' : 'install_' + processes[row][0] + '' }).append(
								$('<td>').attr({ 'colspan' : 2 }).append(
									$('<table>').addClass('ui-table-list').css({ 'width' : '100%' })
								)
							).hide()
						);
						if( response.MESSAGE != '' ){
							$('tr#install_' + processes[row][0] + ' table').append(
								$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.MESSAGE ))
							);
						}else{
							$('tr#install_' + processes[row][0] + ' table').append(
								$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Type'), $('<td>').text( response.ERRORMESSAGE.Type )),
								$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.ERRORMESSAGE.Message )),
								$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Detail'), $('<td>').text( response.ERRORMESSAGE.Detail ))
							);
						}
						if( response.ERRORMESSAGE.queryError != undefined ){
							$('tr#install_' + processes[row][0] + ' table').append(
								$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('queryError'), $('<td>').text( response.ERRORMESSAGE.queryError )),
								$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Sql'), $('<td>').text( response.ERRORMESSAGE.Sql ))
							);
						}
						$("span.loading").remove();
					}
				}
			});

		}

		$("form[name = installation_2]").submit(function(){

			$("div#installList table.ui-table-list tr td > i").removeClass("fa-bookmark flagFalse").addClass("fa-bookmark-o");

			var form = $(this).serialize();
			var process = {
				control: { method : "controlSystem", elementid : "control" , data : form },
				database: { method : "createDatabase", elementid : "databases" , data : "" },
				mainProductTables : { method : "createObject", elementid : "mainProductTables" , data : '&object_type=' + 'tables' + '&schema_type=' + 'main_product' },
				mainProductViews : { method : "createObject", elementid : "mainProductViews" , data : '&object_type=' + 'views' + '&schema_type=' + 'main_product' },
				mainProductProcedures : { method : "createObject", elementid : "mainProductProcedures" , data : '&object_type=' + 'procedures' + '&schema_type=' + 'main_product' },
				mainFunctions : { method : "createObject", elementid : "mainFunctions" , data : '&object_type=' + 'functions' + '&schema_type=' + 'main_product' },
				jobs : { method : "createObject", elementid : "jobs" , data : '&object_type=' + 'jobs' + '&schema_type=' + 'master' },
				license : { method : "createLicense", elementid : "license" , data : "" }
			}

			var processes = new Array();
			for( var i in process ) processes.push([i, process[i]]);

			startAjaxRequest( processes, 0 );

			return false;

		});

		function showInstallMistakeMessage( cmpName ) {
			if( $('tr#install_'+cmpName+'').hasClass("activeTr") ) 
				$('tr#install_'+cmpName+'').hide().removeClass("activeTr");
			else $('tr#install_'+cmpName+'').show().addClass("activeTr");
		}

	</script>
<cfelse>
	<script>
		alert("<cfoutput>You must verification your license code and domain address!</cfoutput>");
		location.href = "<cfoutput>#installUrl#</cfoutput>";
	</script>
</cfif>