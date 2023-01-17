<cfquery name="PRINTER" datasource="#dsn#">
	SELECT 
        PRINTER_ID, 
        PRINTER_NAME, 
        IS_DEFAULT 
    FROM 
    	SETUP_PRINTER
</cfquery>
<cfif PRINTER.recordcount>
	<cf_box>
<cfoutput query="PRINTER">
	<ul class="ui-list">
		<li>
			<a href="#request.self#?fuseaction=settings.form_upd_printer&ID=#PRINTER_ID#">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-bars-chart-1"></span>
					#PRINTER_NAME#	
				</div>
				<div class="ui-list-right">
					<i class="fa fa-pencil"></i>
				</div>
			</a>
		</li>
	</ul>
</cfoutput>
</cf_box>
</cfif>	