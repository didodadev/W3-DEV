
	<cfset params = CreateObject("component", "/WMO/params")>
    <cfset systemParam = params.systemParam()>
    <cfset dsn = systemParam.dsn>
	<cfset db_host = systemParam.database_host>
	<cfset db_port = systemParam.database_port>
	<cfset database_folder = systemParam.database_folder>
	<cfset database_log_folder = systemParam.database_log_folder>
	<cfform name="add_installation" type="formControl" action="#installUrl#" method="post">
		<input type="hidden" name="installation_type" id="installation_type" value="install_2" />
		<input class="form-control"  name="db_type"  type="hidden"  value="MSSQL" />
		<div class="form-group col-md-12">
			<label class="col-md-12">Datasource <font color="red">*</font></label>
			<div class="col-md-10">
				<input required class="form-control" message="Enter Definitions od Database" name="datasource" id="datasource" type="text" value="<cfoutput>#dsn#</cfoutput>" />
			</div>
		</div>
		<div class="form-group col-md-12">
			<label class="col-md-12">Database Username <font color="red">*</font></label>
			<div class="col-md-10">
				<input required class="form-control" message="Enter DB Username" name="db_username" id="db_username" type="text" value="" />
			</div>
		</div>
		<div class="form-group col-md-12">
			<label class="col-md-12">Database Password <font color="red">*</font></label>
			<div class="col-md-10">
				<input required class="form-control" message="Enter DB Password" name="db_password" id="db_password" type="password" value=""  />
			</div>
		</div>
		<div class="form-group col-md-12">
			<label class="col-md-12">Database Host <font color="red">*</font></label>
			<div class="col-md-10">
				<input required class="form-control" message="Enter DB Host Definition" name="db_host" id="db_host" type="text" value="<cfoutput>#db_host#</cfoutput>" />
			</div>
		</div>
		<div class="form-group col-md-12">
			<label class="col-md-12">Database Port <font color="red">*</font></label>
			<div class="col-md-10">
				<input required class="form-control" message="Enter DB Port Definition" name="db_port" id="db_port" type="text" value="<cfoutput>#db_port#</cfoutput>" />
			</div>
		</div>
		<div class="form-group col-md-12">
			<label class="col-md-12">Database Data Folder <font color="red">*</font></label>
			<div class="col-md-10">
				<input required class="form-control" message="Enter path of DB Data Folder" name="db_folder" id="db_folder" type="text" value="<cfoutput>#database_folder#</cfoutput>"/>
			</div>
		</div>
		<div class="form-group col-md-12">
			<label class="col-md-12">Database Log Folder <font color="red">*</font></label>
			<div class="col-md-10">
				<input required class="form-control" message="Enter path of DB Log Folder" name="db_log_folder" id="db_log_folder" type="text" value="<cfoutput>#database_log_folder#</cfoutput>"/>
			</div>
		</div>
		<div class="form-group col-md-12">
			<label class="col-md-12">CF Admin Password <font color="red">*</font></label>
			<div class="col-md-10">
				<input required class="form-control" message="Enter CF Server Admin Password" name="cf_admin_password" id="cf_admin_password" type="password" value=""/>
			</div>
		</div>
		<div class="form-group button-panel col-md-12">
			<div class="col-md-10">
				<input  class="btn btn-info" type="submit" value="Next Step">
			</div>
		</div>
	</cfform>